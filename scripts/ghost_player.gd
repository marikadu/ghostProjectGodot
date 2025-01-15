extends CharacterBody2D


@export var max_speed = 400
@export var dash_speed = 1100
@export var acceleration = 1200
@export var friction = 400
@onready var axis = Vector2.ZERO

var dashing = false
# dash duration
var can_dash = true

@onready var npc = get_tree().root.get_node("main/NPC")  # Get NPC node

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
#	left - right
#	can't move both ways at the same time
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
#	up - down
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()
	
	
func move(delta):
	axis = get_input_axis()
	
#	if the player is not moving - standing
	if axis == Vector2.ZERO:
		apply_friction(friction * delta)
		
	else: 
		apply_movement(axis * acceleration * delta)
		
	if dashing:
		velocity = velocity.normalized() * dash_speed
		
	move_and_slide()
	
	
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
	
#func stop_dash():
	#dashing = false
	#print("dash ended")


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_timer_reset_timeout() -> void:
	can_dash = true
