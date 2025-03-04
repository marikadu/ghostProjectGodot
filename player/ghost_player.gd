extends CharacterBody2D

@export var max_speed = 460
@export var acceleration = 2700
@export var friction = 930 # the lower -> the more "slippery" the surface is
@export var dash_speed = 1330

@export var max_stamina_sections = 5
@export var dash_stamina_cost = 1
@export var stamina_restore_time = 2.5 # time to restore 1 section
@export var enemy_type: String = "player"


var dashing = false

var current_speed = 0.0
var current_stamina = max_stamina_sections
var restoring_stamina = false
var can_move = true


var input: Vector2 = Vector2.ZERO
var playback: AnimationNodeStateMachinePlayback

signal is_dashing

@onready var dash_effect_scene = preload("res://player/DashGhost.tscn")
@onready var dash_stamina = preload("res://player/dash_stamina.tscn")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var dashing_t: Timer = $dashing_t

@onready var ghost_effect_timer: Timer = $GhostEffectTimer
@onready var dash_timer_reset: Timer = $dash_timer_reset
@onready var stamina_restore_timer : Timer = $stamina_restore_timer

@onready var sprite_move: Sprite2D = $s_move
@onready var sprite_gameover: AnimatedSprite2D = $sprite_gameover

var dash_stamina_instance


func _ready():
	can_move = true
	sprite_gameover.visible = false
	sprite_move.visible = true
	sprite_gameover.stop()
	
	dash_stamina_instance = dash_stamina.instantiate()
	current_speed = max_speed
	playback = animation_tree["parameters/playback"]
	animation_tree.active = true
	
	stamina_restore_timer.set_wait_time(stamina_restore_time)
	
	Events.game_over.connect(sad_ghost)
	Events.game_over_woke_up_human.connect(sad_ghost)


func _physics_process(delta: float) -> void:
	
	# debugging game over
	#if Input.is_action_pressed("game_over_input"):
		#Global.is_game_over = true
	
	if can_move:
		input = Input.get_vector("left", "right", "up", "down")
		
		# dashing
		if Input.is_action_just_pressed("dash") and input != Vector2.ZERO:
			#print("dashing!")
			start_dash()

		# if the player is not moving or is standing -> sliding
		if input == Vector2.ZERO:
			apply_friction(friction * delta)
		else:
			apply_movement(input * acceleration * delta)
		
		if dashing:
			#apply_movement(velocity * delta * dash_speed)
			velocity = velocity.normalized() * dash_speed
			#apply_friction(friction * delta)
			
			
			#velocity = velocity.normalized() * dash_speed # the player is sliding after dashing
			# BUT if the player quickly changes direction and dashes, the player will go the initial
			# direciton which makes the controlls unresponsive
			
			#velocity = input.normalized() * dash_speed # the player is in full controll of the directions
			# BUT the player is not sliding after dashing
			
			#apply_friction(friction * delta)
			#apply_movement(input * acceleration * delta) * dash_speed
		
	else:
		# slowly slide
		velocity = lerp(velocity, Vector2.ZERO, delta * 2)


	move_and_slide()
	select_animation()
	update_animation_param()
	
	#sprite_move.scale.x = move_toward(sprite_move.scale.x, 1, 1 * delta)
	#sprite_move.scale.y = move_toward(sprite_move.scale.y, 1, 1 * delta)
	
	
# -------- ANIMATION --------
func select_animation():
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else:
		playback.travel("walk")


func update_animation_param():
	if input == Vector2.ZERO:
		return

	animation_tree["parameters/idle/blend_position"] = input
	animation_tree["parameters/walk/blend_position"] = input
# --------------------------


# -------- MOVEMENT --------
func apply_friction(amount: float) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func apply_movement(accel: Vector2) -> void:
	velocity += accel
	# limit_length = clamp
	# no more than the max_speed
	velocity = velocity.limit_length(max_speed)


func start_dash() -> void:
	if current_stamina >= dash_stamina_cost:
		AudioManager.play_dash()
		#dash.play()
		dashing = true
		current_stamina -= dash_stamina_cost
		# starting the timer once the player is dashing
		dashing_t.start()
		dash_timer_reset.start()
		ghost_effect_timer.start()
		#print("dashing! current stamina: ", current_stamina)
		spawn_dash_effect()

		
		if not restoring_stamina:
			restoring_stamina = true
			stamina_restore_timer.start()
			
			
	else:
		pass
		#print("not enough stamina!")
		

# when game over
func sad_ghost():
	#if Global.is_game_over:
		can_move = false
		playback.travel("idle")
		sprite_gameover.visible = true
		sprite_gameover.play("game_over")
		#sprite_gameover.play("game_over_idle")
		
		sprite_move.visible = false

# --------------------------


func spawn_dash_effect():
	var dash_effect = dash_effect_scene.instantiate()
	dash_effect.position = self.global_position
	dash_effect.texture = sprite_move.texture
	dash_effect.vframes = sprite_move.vframes
	dash_effect.hframes = sprite_move.hframes
	dash_effect.frame = sprite_move.frame
	get_parent().add_child(dash_effect)

# when dash ends (after 0.2 seconds after dash)
func _on_dash_timer_timeout() -> void:
	ghost_effect_timer.stop()
	dashing = false
	#print("no more dashing")
	
	#if velocity.length() > 0:
		#velocity -= velocity.normalized() * 200
		#if velocity.length() < 0.1:
			#velocity = Vector2.ZERO
			
	#print("waiting...wating...")
	if dash_timer_reset.is_stopped():
		#print("stop wait timer")
		dashing_t.stop()


func _on_dash_timer_reset_timeout() -> void:
	dash_timer_reset.stop()

func _on_ghost_effect_timer_timeout() -> void:
	spawn_dash_effect()

func _on_stamina_restore_timer_timeout() -> void:
	restore_stamina()
			
			
func restore_stamina():
	if current_stamina < max_stamina_sections:
		current_stamina += 1
		#stamina_restored.play()
		#print("restored 1 stamina. stamina: ", current_stamina)
		
		# if stamina less than max. -> continue restoring
		if current_stamina < max_stamina_sections:
			stamina_restore_timer.start()
		else:
			restoring_stamina = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("interact_dash"):
		pass
		
