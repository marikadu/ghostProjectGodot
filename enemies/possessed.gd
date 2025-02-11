extends CharacterBody2D


@export var min_speed = 130
@export var speed = 145
@export var max_speed = 260
@export var speed_increase_rate = 30.0
@export var decrease_speed_when_hit = 60
@export var rotation_speed: float = 2.0  # speed of rotation (degrees per second)
@export var rotation_range: float = 2.0  # maximum rotation angle (in degrees) to the left and right
@export var wait_death_animation = 0.8

var npc: CharacterBody2D
var player: CharacterBody2D
var dead : bool
var health = 9.0
var current_speed: float
var time_alive: float = 0.0

@onready var can_hurt = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var possessed_area = $Area2DPossessed
@onready var ran_dir_timer = $ChangingRandomDirection
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation
@onready var possessed_escapes = get_tree().root.get_node("main/PossessedEscapes")
@onready var camera_control = get_tree().root.get_node("main/CameraControl")

@onready var main = get_tree().root.get_node("main")
@onready var health_bar: TextureProgressBar = $CanvasLayer/HealthBar
@onready var time_alive_timer: Timer = $timeAlive


#var velocity = Vector2.ZERO
var random_direction: Vector2 = Vector2.ZERO


func _ready() -> void:

	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance
	health_bar.init_health(health)
	
	current_speed = speed  # start at normal speed
	
	time_alive_timer.start()
	

	match npc.killed_by:
		"enemy1":
			animated_sprite.play("idle_purple")
			#print("spawn LILLY possessed")
		"enemy2":
			animated_sprite.play("idle_blue")
			#print("spawn BLU possessed")
		"enemy3":
			animated_sprite.play("idle_red")
			#print("spawn REDDY possessed")
		_:
			# hidden 4th possessed
			animated_sprite.play("dead")
			#print("possessed: npc is woken up")
	
	if possessed_area:
#		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))
		possessed_area.connect("body_exited", Callable(self, "_on_possessed_area_body_exited"))
	else:
		print("possessed missing")
		

	
func _process(_delta):
	# smoothly oscillating rotation between -rotation_range and +rotation_range
	rotation = sin(Time.get_ticks_msec() * rotation_speed * 0.001) * rotation_range
	

# running away from the player
func _physics_process(delta: float) -> void:
	#if dead or Global.is_game_over:
		#return
	
	if player:
		var direction = (position - player.position).normalized()
		#velocity = get_random_direction() * speed
		velocity = direction * current_speed
		move_and_collide(velocity * delta)
		
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 3 * delta)
	
	# gradually increase speed after being spawned
	# to make the player want to kill it as soon as possible
	# only increase speed if the possessed hasn't been hit
	if current_speed < max_speed:
		time_alive += delta
		current_speed = min(current_speed + (time_alive * speed_increase_rate * delta), max_speed)
	
	#print(current_speed)
		
#func get_random_direction() -> Vector2:
	#random angle between 0 and 2PI radians
	#var random_angle = randf_range(0, 2 * PI) 
	# convert angle to vector directions
	#return Vector2(cos(random_angle), sin(random_angle))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and !player.dashing and not dead and not Global.is_game_over:
		take_damage(1.0)
		AudioManager.play_hit2()
		#print("-1")
		if health <= 0:
			die()
		
		
	if body == player and player.dashing and not dead and not Global.is_game_over :
		take_damage(3.0)
		AudioManager.play_hit()
		AudioManager.play_hit2()
		AudioManager.play_dash_hit()
		AudioManager.play_stamina_restored()
		player.restore_stamina()
		if health <= 0:
			die()
		
func take_damage(damage: float):
	# can't kill if game over
	if not Global.is_game_over:
		animated_sprite.scale = Vector2(1.6, 0.7)
		AudioManager.play_posessed_hit()
		#possessed_hit.play()
		if Graphics.flash_when_hit_effect:
			hit_flash.play("hit_flash")
		health -= damage
		health_bar.health = health
		#print("ow oww")
		camera_control.apply_shake(3, 1)
		# decrease current speed with every hit
		current_speed = max(current_speed - decrease_speed_when_hit, min_speed)
		
		
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
	dead = true
	# death animations
	if npc.killed_by == "enemy1":
		animated_sprite.play("death_purple")
	elif npc.killed_by == "enemy2":
		animated_sprite.play("death_blue")
	elif npc.killed_by == "enemy3":
		animated_sprite.play("death_red")

	animated_sprite.scale = Vector2(1.2, 0.8)
	#hit.play()
	camera_control.apply_shake(12, 3)
	Global.score += 100
	print("Score: ", Global.score)
	Events.possessed_defeated.emit()
	#print("posesses died")
	time_alive_timer.stop()
	# decrease speed to 0 in a span of 0.6 seconds when dies
	var tween = get_tree().create_tween()
	tween.tween_property(self, "current_speed", 0.0, 0.6).set_trans(Tween.TRANS_LINEAR)
	
	await get_tree().create_timer(wait_death_animation).timeout
	queue_free()
		


#func _on_changing_random_direction_timeout() -> void:
	# updating random direction every 1.4 seconds
	#random_direction = get_random_direction()
	
	# restart the timer to keep updating direction every 2 seconds
	#ran_dir_timer.start(1.4)

# possessed escaped
func _on_area_2d_possessed_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area == possessed_escapes and not dead:
		print("POSSESSED: ESCALPES")
		Events.game_over.emit()
		Events.possessed_escaped.emit()
