extends CharacterBody2D

@export var max_speed = 460
@export var acceleration = 2700
@export var friction = 600
@export var dash_speed = 1300

@export var max_stamina_sections = 3
@export var dash_stamina_cost = 1
@export var stamina_restore_time = 1.7 # time to restore 1 section

var dashing = false

var current_speed = 0.0
var current_stamina = max_stamina_sections
var restoring_stamina = false

var input: Vector2 = Vector2.ZERO
var playback: AnimationNodeStateMachinePlayback

signal is_dashing

@onready var dash_effect_scene = preload("res://scenes/DashGhost.tscn")
@onready var dash_stamina = preload("res://player/dash_stamina.tscn")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var dashing_t: Timer = $dashing_t

@onready var ghost_effect_timer: Timer = $GhostEffectTimer
@onready var dash_timer_reset: Timer = $dash_timer_reset
@onready var stamina_restore_timer : Timer = $stamina_restore_timer

@onready var sprite: Sprite2D = $Sprite2D
@onready var dash: AudioStreamPlayer2D = $dash
@onready var dash_hit: AudioStreamPlayer2D = $dash_hit
@onready var hit: AudioStreamPlayer2D = $hit
@onready var ghost_dies: AudioStreamPlayer2D = $ghost_dies


func _ready():
	current_speed = max_speed
	playback = animation_tree["parameters/playback"]
	animation_tree.active = true
	
	stamina_restore_timer.set_wait_time(stamina_restore_time)


func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	
	# dashing
	if Input.is_action_just_pressed("dash") and input != Vector2.ZERO:
		start_dash()


	# if the player is not moving or is standing -> sliding
	if input == Vector2.ZERO:
		apply_friction(friction * delta)

	else:
		apply_movement(input * acceleration * delta)
	
	if dashing:
		velocity = velocity.normalized() * dash_speed
		#velocity 
		#current_speed = lerp(1200.0, 200.0, delta * 1200)

	move_and_slide()
	select_animation()
	update_animation_param()
	
	
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
		dash.play()
		dashing = true
		current_stamina -= dash_stamina_cost
		# starting the timer once the player is dashing
		dashing_t.start()
		dash_timer_reset.start()
		ghost_effect_timer.start()
		print("dashing! current stamina: ", current_stamina)
		spawn_dash_effect()
		# for the dash restore animation of the indicator
		
		if not restoring_stamina:
			restoring_stamina = true
			stamina_restore_timer.start()
			
	else:
		print("not enough stamina!")
# --------------------------



func spawn_dash_effect():
	# Spawn a dash effect
	var dash_effect = dash_effect_scene.instantiate()
	dash_effect.position = self.global_position
	dash_effect.texture = sprite.texture
	dash_effect.vframes = sprite.vframes
	dash_effect.hframes = sprite.hframes
	dash_effect.frame = sprite.frame
	get_parent().add_child(dash_effect)

# when dash ends (after 0.2 seconds after dash)
# make the UI stamina bar to restore here!!!!!!!
func _on_dash_timer_timeout() -> void:
	ghost_effect_timer.stop()
	dashing = false
	#print("waiting...wating...")
	if dash_timer_reset.is_stopped():
		#print("stop wait timer")
		dashing_t.stop()

func _on_dash_timer_reset_timeout() -> void:
	dash_timer_reset.stop()

func _on_ghost_effect_timer_timeout() -> void:
	spawn_dash_effect()

func _on_stamina_restore_timer_timeout() -> void:
	if current_stamina < max_stamina_sections:
		current_stamina += 1
		print("restored 1 stamina. stamina: ", current_stamina)
		
		#update_stamina_ui()
		
		# if stamina less than max. -> continue restoring
		if current_stamina < max_stamina_sections:
			stamina_restore_timer.start()
		else:
			restoring_stamina = false
			
#func update_stamina_ui():
	#for i in range(max_stamina_sections):
		## Smoothly transition each stamina bar
		#if i < current_stamina:
			#dash_stamina.stamina_bars[i].value = dash_stamina.stamina_bars[i].max_value  # Full
		#else:
			#dash_stamina.stamina_bars[i].value = 0  # Empty
	#pass
