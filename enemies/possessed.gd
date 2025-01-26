extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

@export var speed = 145
@export var health = 3
@export var rotation_speed: float = 2.0  # speed of rotation (degrees per second)
@export var rotation_range: float = 2.0  # maximum rotation angle (in degrees) to the left and right
@export var wait_death_animation = 0.8

var npc: CharacterBody2D
var player: CharacterBody2D
var dead : bool

@onready var can_hurt = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var possessed_area = $Area2DPossessed
@onready var ran_dir_timer = $ChangingRandomDirection
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation
@onready var possessed_escapes = get_tree().root.get_node("main/PossessedEscapes")
@onready var camera_control = get_tree().root.get_node("main/CameraControl")
@onready var possessed_hit: AudioStreamPlayer2D = $possessed_hit
@onready var hit: AudioStreamPlayer2D = $hit
@onready var main = get_tree().root.get_node("main")

#var velocity = Vector2.ZERO
var random_direction: Vector2 = Vector2.ZERO


func _ready() -> void:

	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance
	
	animated_sprite.play("dead")
	
	if npc.killed_by == "enemy1":
		animated_sprite.play("idle_purple")
		#print("spawn PURPLE possessed")
	elif npc.killed_by == "enemy2":
		animated_sprite.play("idle_blue")
		#print("spawn BLUE possessed")
	elif npc.killed_by == "enemy3":
		animated_sprite.play("idle_red")
		#print("spawn RED possessed")
	
	if possessed_area:
#		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))
		possessed_area.connect("body_exited", Callable(self, "_on_possessed_area_body_exited"))
	else:
		print("Possessed area is missing!")
		

	
func _process(_delta):
	# smoothly oscillating rotation between -rotation_range and +rotation_range
	rotation = sin(Time.get_ticks_msec() * rotation_speed * 0.001) * rotation_range
	
	#animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 1 * delta)
	#animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 1 * delta)

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
		
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 3 * delta)
		
		
#func get_random_direction() -> Vector2:
	#random angle between 0 and 2PI radians
	#var random_angle = randf_range(0, 2 * PI) 
	# convert angle to vector directions
	#return Vector2(cos(random_angle), sin(random_angle))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and !player.dashing:
		print("touched player, ignore player")
		# show somehow that the possessed 
		#doesn't care if you are not dashing
		#queue_free()  # remove the enemy from the scene
		pass
		
		
	if body == player and player.dashing and not dead :
		take_damage()
		
		#queue_free()  # remove the enemy from the scene
		if health <= 0:
			die()
		
func take_damage():
	# can't kill if game over
	if not Global.is_game_over:
		animated_sprite.scale = Vector2(1.6, 0.7)
		possessed_hit.play()
		hit.play()
		hit_flash.play("hit_flash")
		health -= 1
		print("ow oww")
		camera_control.apply_shake(3, 1)
		
		
		if not dead:
			if npc.killed_by == "enemy1":
				animated_sprite.play("hit_purple")
				await get_tree().create_timer(0.6).timeout
				if not dead:
					animated_sprite.play("idle_purple")
				
			elif npc.killed_by == "enemy2":
				animated_sprite.play("hit_blue")
				await get_tree().create_timer(0.6).timeout
				if not dead:
					animated_sprite.play("idle_blue")
				
			elif npc.killed_by == "enemy3":
				animated_sprite.play("hit_red")
				await get_tree().create_timer(0.6).timeout
				if not dead:
					animated_sprite.play("idle_red")
	
func die():
	# if I put the sounds here, they don't work. probably because of the "queue_free"
	dead = true
	# death animations
	if npc.killed_by == "enemy1":
		animated_sprite.play("death_purple")
	elif npc.killed_by == "enemy2":
		animated_sprite.play("death_blue")
	elif npc.killed_by == "enemy3":
		animated_sprite.play("death_red")

	animated_sprite.scale = Vector2(1.2, 0.8)
	hit.play()
	camera_control.apply_shake(12, 3)
	Global.score += 100
	print("Score: ", Global.score)
	Events.possessed_defeated.emit()
	print("posesses died")
	await get_tree().create_timer(wait_death_animation).timeout
	queue_free()
		


#func _on_changing_random_direction_timeout() -> void:
	# updating random direction every 1.4 seconds
	#random_direction = get_random_direction()
	
	# restart the timer to keep updating direction every 2 seconds
	#ran_dir_timer.start(1.4)


func _on_area_2d_possessed_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area == possessed_escapes and not dead:
		print("Possessed: possesed has escaped")
		print("lmao possessed has escaped")
		Events.game_over.emit()
		Events.possessed_escaped.emit()
