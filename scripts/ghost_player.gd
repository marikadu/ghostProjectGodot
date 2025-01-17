extends CharacterBody2D


@export var max_speed = 460
@export var acceleration = 2700
@export var friction = 900
@export var dash_speed = 1100
@onready var animation_tree: AnimationTree

@onready var axis = Vector2.ZERO
@onready var animated_sprite = $AnimatedSprite2D

var dashing = false
# dash duration
var can_dash = true


func _physics_process(delta: float) -> void:
	# dashing only once when SHIFT is pressed
	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash()
		
	
		
	#if dashing:
		#dash_timer -=delta
		#if dash_timer <= 0:
			#stop_dash()
			
	move(delta)
	
#	movement logic
func get_input_axis():
	#var input_vector = Input.get_vector("_move_left", "move_right", "move_up", "move_down")
#	left - right
#	can't move both ways at the same time
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))

#	up - down
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
#	--------------------------------------------
#	sprite changing logic
	
	if Input.is_action_pressed("move_right"):
		animated_sprite.play("left")
		print("right")
		animated_sprite.scale.x=-1
	
	if Input.is_action_pressed("move_left"):
		animated_sprite.play("left")
		print("left")
		animated_sprite.scale.x=1
	
	if Input.is_action_pressed("move_down"):
		animated_sprite.play("down")
		print("down")
		if Input.is_action_pressed("move_left"):
			animated_sprite.play("down_left")
			animated_sprite.scale.x=1
			print("down_left")
		elif Input.is_action_pressed("move_right"):
			animated_sprite.play("down_left")
			animated_sprite.scale.x=-1
			print("down_left")
		
	if Input.is_action_pressed("move_up"):
		animated_sprite.play("up")
		print("up")
		if Input.is_action_pressed("move_left"):
			animated_sprite.play("up_left")
			animated_sprite.scale.x=1
			print("up_left")
		elif Input.is_action_pressed("move_right"):
			animated_sprite.play("up_left")
			animated_sprite.scale.x=-1
			print("up_left")
		
		
#	--------------------------------------------
		
	
	return axis.normalized()
	#return input_vector.normalized()
	#pass
		
	
	
func move(delta):
	axis = get_input_axis()
	
#	if the player is not moving = standing
	if axis == Vector2.ZERO:
		apply_friction(friction * delta)
		#print("standing")
		animated_sprite.play("idle")
		
	else: 
		apply_movement(axis * acceleration * delta)
		
	if dashing:
		velocity = velocity.normalized() * dash_speed
		
	move_and_slide()
	update_animation_param()
		
		
func update_animation_param():
	pass
	
func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
		
	else:
		velocity = Vector2.ZERO
		
		
		
func apply_movement(accel):
	velocity += accel
#	limit length = clamp
	velocity = velocity.limit_length(max_speed)
	
func start_dash():
	dashing = true
	can_dash = false
	# starting the timer once the player is dashing
	$dash_timer.start()
	$dash_timer_reset.start()
	print("dashing!")


func _on_dash_timer_timeout() -> void:
	dashing = false
	#print("waiting...wating...")
	if $dash_timer_reset.is_stopped():
		#print("stop wait timer")
		$dash_timer.stop()

func _on_dash_timer_reset_timeout() -> void:
	$dash_timer_reset.stop()
	can_dash = true
	#print("you can dash")
