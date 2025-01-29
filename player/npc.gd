extends CharacterBody2D

@onready var healthbar : TextureProgressBar = get_tree().root.get_node("main/UI/HealthBar")
#@onready var healthbar = %HealthBar
#@onready var healthbar: TextureProgressBar = %HealthBar
#@onready var healthbar = get_node("Node/%HealthBar")


#@onready var npc = get_tree().root.get_node("main/NPC")
@onready var npc_area = $Area2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation
@onready var player_near_timer: Timer = $player_near
#@onready var sleep_distance: CollisionShape2D = $Area2DNPC/sleep_distance
@onready var camera_control = get_tree().root.get_node("main/CameraControl")

@onready var npc_hit: AudioStreamPlayer2D = $npc_hit
@onready var hit: AudioStreamPlayer2D = $hit
@onready var player_near_sfx: AudioStreamPlayer2D = $player_near_sfx
@onready var healing: AudioStreamPlayer2D = $healing

@export var enemy_type: String = "npc"


var health: float
var max_health: float
var is_alive: bool = true
var is_player_near: bool = false
var npc_ignore_player: bool = false
#var can_npc_take_damage: bool
#var player_near_time: float = 0.0
#var patience: float = 3.0
var player: CharacterBody2D
var killed_by: String = ""
var body: Node


func _ready():
	#get_tree().get_current_scene().get_name()
	#if get_parent.name == "level1":
		#print("yyyyy")
	npc_ignore_player = false
	player = get_tree().root.get_node("main/GhostPlayer")
	max_health = 10.0
	health = max_health # at the start of the game, health is max
	is_alive = true
	#get_tree().get_current_scene().filename
	
	#if player_near_timer:
		#player_near_timer.set_wait_time(0.1) # checking if player is near every 0.1 seconds
		#player_near_timer.start()

	if healthbar != null:
		healthbar.init_health(health)

	if npc_area:
		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))

	if hit_timer:
		hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))
		
		
func _physics_process(delta: float) -> void:
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 3 * delta)
	#player_near = is_player_near()
		

func set_health(value: float):
	if not is_alive:
		# doesn't update when is dead / when game over
		return  
	# npc dies
	health = value
	if health <= 0:
		health = 0
		is_alive = false
		camera_control.apply_shake(30.0, 5)
		animated_sprite.play("gone")
		print("npc died. killed: ", killed_by)
		switchValue()
	else:
		#print("NPC health: %d" % health)
		pass

	if healthbar != null:
#		if the healthbar is active -> update it
		healthbar.health = health
		
func switchValue():
	match killed_by:
		"enemy1":
			print("killed by PURPLE")
		"enemy2":
			print("killed by BLUE")
		"enemy3":
			print("killed by RED")
		_:
			# DON'T SPAWN POSSESSED!
			print("you woke the NPC up")
	pass

# collision logic
func _on_area_2d_body_entered(body: Node) -> void:
	if is_alive:
		if body.is_in_group("enemy"):
			# reduce health by 1
			take_damage(2.0, body)
			
		# apply damage if player is near
		if body == player and not npc_ignore_player:
			camera_control.zoom_in()
			player_near_sfx.play()
			is_player_near = true
			#print("player near")
			player_near_timer.start()
			player_near_timer.one_shot = false
			animated_sprite.play("hit_player")
			
		#if body.is_in_group("firefly"):
			#print("firefly entered")
			#heal(0.5)
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player and is_alive:
		camera_control.zoom_out()
		player_near_sfx.stop()
		is_player_near = false
		player_near_timer.stop()
		player_near_timer.set_wait_time(3.0) 
		player_near_timer.one_shot = true
		if not Global.is_game_won:
			animated_sprite.play("sleeping")
		else:
			print("ignore player BECAUSE WIN")
		#print("player bye")
		 #apply damage if player is near

# take damage
func take_damage(damage: float, enemy: Node):
	killed_by = enemy.enemy_type
	camera_control.apply_shake(1.2, 1)
	npc_hit.play()
	hit.play()
	animated_sprite.play("hit")
	hit_flash.play("hit_flash")
#	update health
	#if can_npc_take_damage:
	set_health(health - damage)
	animated_sprite.scale = Vector2(1.2, 0.8)
	if hit_timer:
		hit_timer.start()
	
func heal(healing: float):
	#npc_hit.play()
	animated_sprite.play("gone")
	#hit_flash.play("hit_flash")
#	update health
	#health = min(health + healing, max_health)  # doesn't go beyond max_health
	#set_health(health + healing)
	set_health(min(health + healing, max_health))
	animated_sprite.scale = Vector2(1.2, 0.8)
	
	
		
func restore_health(amount: float) -> void:
	# revive npc if dead and health is restored
	#if not is_alive and health + amount > 0:
	if not is_alive:
		is_alive = true
		animated_sprite.play("sleeping")
		print("npc back from the dead")
		player_near_timer.stop()
		player_near_timer.set_wait_time(3.0) 
		player_near_timer.one_shot = true
			
			
	health = min(health + amount, max_health)  # doesn't go beyond max_health
	if healthbar != null:
		healthbar.health = health  # update the health bar
		
	print("NPC health: ", health)


# when isHit timer finishes -> go back to sleeping animation if alive
func _on_hit_timer_timeout():
	if is_alive and not npc_ignore_player:
		#print("AAAAAAAAAAA")
		animated_sprite.play("hit")
		await get_tree().create_timer(1).timeout
		$isHitAnimation.stop()
		# don't make them go back to sleep after the game is won and they woke up lol
		if is_alive and not is_player_near and not Global.is_game_won:
			print("go back to sleeepe")
			animated_sprite.play("sleeping")
		elif is_alive and is_player_near:
			animated_sprite.play("hit_player")

	
func _on_player_near_timeout() -> void:
	if is_alive and not Global.current_scene_name == 1 and not npc_ignore_player:
		take_damage(2.0, self)
		print("NOTICED THE PLAYER ", health)
	# npc gets damaged 1 hp instead of 2 for the tutorial
	elif is_alive and Global.current_scene_name == 1 and not npc_ignore_player:
		take_damage(1.0, self)
		print("TUTORIAL: NOTICED THE PLAYER ", health)
