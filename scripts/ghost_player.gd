extends CharacterBody2D

@export var max_speed = 460
@export var acceleration = 2700
@export var friction = 600
@export var dash_speed = 1100
#@export var dash_duration = 0.2  # Dash duration in seconds
#@onready var dash_timer: Timer = $dash_timer


#$dash_timer
@onready var dash_effect_scene = preload("res://scenes/DashGhost.tscn")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var dash_timer: Timer = $dash_timer
@onready var ghost_effect_timer: Timer = $GhostEffectTimer
@onready var dash_timer_reset: Timer = $dash_timer_reset
@onready var sprite: Sprite2D = $Sprite2D

var dashing = false
var can_dash = true

var input: Vector2 = Vector2.ZERO
var playback: AnimationNodeStateMachinePlayback

func _ready():
	playback = animation_tree["parameters/playback"]
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	
	# dashing
	if Input.is_action_just_pressed("dash") and can_dash and input != Vector2.ZERO:
		start_dash()


	# if the player is not moving or is standing -> sliding
	if input == Vector2.ZERO:
		apply_friction(friction * delta)

	else:
		apply_movement(input * acceleration * delta)
	
	if dashing:
		velocity = velocity.normalized() * dash_speed

	move_and_slide()
	select_animation()
	update_animation_param()


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
	dashing = true
	can_dash = false
	# starting the timer once the player is dashing
	dash_timer.start()
	dash_timer_reset.start()
	ghost_effect_timer.start()
	print("dashing!")
	spawn_dash_effect()
	
	
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
		dash_timer.stop()

func _on_dash_timer_reset_timeout() -> void:
	dash_timer_reset.stop()
	can_dash = true
	print("you can dash")

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


func _on_ghost_effect_timer_timeout() -> void:
	spawn_dash_effect()
	#instance_ghost
	pass # Replace with function body.
