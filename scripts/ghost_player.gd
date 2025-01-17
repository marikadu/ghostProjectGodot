extends CharacterBody2D


@export var max_speed = 460
@export var speed : float = 460

@export var acceleration = 2700
@export var friction = 900
@export var dash_speed = 1100

@export var animation_tree: AnimationTree

#@onready var axis = Vector2.ZERO
#@onready var animated_sprite = $AnimatedSprite2D

var dashing = false
var can_dash = true

var input : Vector2
var playback : AnimationNodeStateMachinePlayback

func _ready():
	playback = animation_tree["parameters/playback"]
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	
	velocity = input * speed
	move_and_slide()
	select_animation()
	update_animation_param()
	
func select_animation():
#	if pressing the key but not moving anywhere
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else: 
		playback.travel("walk")
	
func update_animation_param():
	# if not moving -> not updating
	if input == Vector2.ZERO:
		return
	
	animation_tree["parameters/idle/blend_position"] = input
	animation_tree["parameters/walk/blend_position"] = input
	pass
	# dashing only once when SHIFT is pressed
	#if Input.is_action_just_pressed("dash") and can_dash:
		#start_dash()
		
	#if dashing:
		#dash_timer -=delta
		#if dash_timer <= 0:
			#stop_dash()
			
	#move(delta)
	
#	movement logic

	
#	if the player is not moving = standing
	#if axis == Vector2.ZERO:
		#apply_friction(friction * delta)
		#print("standing")
		#animated_sprite.play("idle")
		
	#else: 
		#apply_movement(axis * acceleration * delta)
		
	#if dashing:
		#velocity = velocity.normalized() * dash_speed
		

	
#func apply_friction(amount):
	#if velocity.length() > amount:
		#velocity -= velocity.normalized() * amount
		#
	#else:
		#velocity = Vector2.ZERO
		
		
		
#func apply_movement(accel):
	#velocity += accel
##	limit length = clamp
	#velocity = velocity.limit_length(max_speed)
	
#func start_dash():
	#dashing = true
	#can_dash = false
	## starting the timer once the player is dashing
	#$dash_timer.start()
	#$dash_timer_reset.start()
	#print("dashing!")


#func _on_dash_timer_timeout() -> void:
	#dashing = false
	##print("waiting...wating...")
	#if $dash_timer_reset.is_stopped():
		##print("stop wait timer")
		#$dash_timer.stop()
#
#func _on_dash_timer_reset_timeout() -> void:
	#$dash_timer_reset.stop()
	#can_dash = true
	##print("you can dash")
