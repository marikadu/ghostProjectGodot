extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 145
var npc: CharacterBody2D
var player: CharacterBody2D

var rotation_speed: float = 2.0  # Speed of rotation (degrees per second)
var rotation_range: float = 2.0  # Maximum rotation angle (in degrees) to the left and right
@export var health = 3  # Health of the possessed


@onready var animated_sprite = $AnimatedSprite2D
@onready var possessed_area = $Area2DPossessed
@onready var ran_dir_timer = $ChangingRandomDirection
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation
@onready var possessed_escapes = get_tree().root.get_node("main/PossessedEscapes")
@onready var camera_control = get_tree().root.get_node("main/CameraControl")
@onready var possessed_hit: AudioStreamPlayer2D = $possessed_hit
@onready var hit: AudioStreamPlayer2D = $hit


#var velocity = Vector2.ZERO
var random_direction: Vector2 = Vector2.ZERO


func _ready() -> void:

	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance
	
	animated_sprite.play("dead")
	
	if possessed_area:
#		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))
		possessed_area.connect("body_exited", Callable(self, "_on_possessed_area_body_exited"))
	else:
		print("Possessed area is missing!")

	
func _process(_delta):
	# smoothly oscillating rotation between -rotation_range and +rotation_range
	rotation = sin(Time.get_ticks_msec() * rotation_speed * 0.001) * rotation_range

# chasing the player
func _physics_process(delta: float) -> void:
	if player:
		#var direction = (player.position - position).normalized()
#		running away from the player

		var direction = (position - player.position).normalized()
		#velocity = get_random_direction() * speed
		velocity = direction * speed
		#look_at(player.position)
		move_and_collide(velocity * delta)
		
		
#func get_random_direction() -> Vector2:
	#random angle between 0 and 2PI radians
	#var random_angle = randf_range(0, 2 * PI) 
	# convert angle to vector directions
	#return Vector2(cos(random_angle), sin(random_angle))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and !player.dashing:
		print("touched player, ignore player") # show somehow that the possessed 
		#doesn't care if you are not dashing
		
		#print("Player got the enemy")
		#queue_free()  # remove the enemy from the scene
		pass
		
		
	if body == player and player.dashing :
		take_damage()
		
		#queue_free()  # remove the enemy from the scene
		if health <= 0:
			die()
		
func take_damage():
	# show somehow that the possessed takes damage
	possessed_hit.play()
	hit.play()
	hit_flash.play("hit_flash")
	health -= 1
	print("ow oww")
	camera_control.apply_shake(3, 1)
	
func die():
	# if I put the sounds here, they don't work
	# probably because of the "queue_free"
	hit.play()
	camera_control.apply_shake(12, 3)
	Global.score += 100
	print("Score: ", Global.score)
	Events.possessed_defeated.emit()
	print("posesses died")
	queue_free()
		


#func _on_changing_random_direction_timeout() -> void:
	# updating random direction every 1.4 seconds
	#random_direction = get_random_direction()
	
	# restart the timer to keep updating direction every 2 seconds
	#ran_dir_timer.start(1.4)


func _on_area_2d_possessed_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area == possessed_escapes:
		print("Possessed: possesed has escaped")
		print("lmao possessed has escaped")
		Events.game_over.emit()
		Events.possessed_escaped.emit()
	pass # Replace with function body.
