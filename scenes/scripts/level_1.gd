#extends Control
extends Node2D
# -- LEVEL 1
# -- aka TUTORIAL


# CTRL + drag a script to put it here with @onready with $
#@onready var camera_2d: Camera2D = $Camera2D

@onready var camera: Camera2D = %Camera2D
@onready var win_game: ColorRect = $UI/WinScreen
@onready var game_over: ColorRect = $UI/GameOverScreen
#@onready var is_game_over = false

@onready var npc = preload("res://player/npc.tscn")
@onready var player = preload("res://player/ghost_player.tscn")
@onready var firefly = preload("res://player/firefly.tscn")
@onready var fire_fly_spawn_timer: Timer = $FireFlySpawnTimer
@onready var possessed_dies: AudioStreamPlayer2D = $possessed_dies
@onready var possessed_hit: AudioStreamPlayer2D = $possessed_hit
@onready var sfx_win: AudioStreamPlayer2D = $win
@onready var timer_animation_player: AnimationPlayer = $UI/CountDownTimer/timerPlayer
@onready var health_animation_player: AnimationPlayer = $UI/HealthBar/healthPlayer
@onready var tutorial: Control = $Tutorial
@onready var scripted_enemy: AnimationPlayer = $enemy1/scripted_enemy
@onready var scripted_enemy_2: AnimationPlayer = $enemy2/scripted_enemy2


var possessed = preload("res://enemies/possessed.tscn")
var npc_instance: Node = null  # Store the NPC instance
var player_instance
var times_defeated_possessed: int
var player_is_speedrunning_the_tutorial: bool
#var npc_instance = null

# list of enemies
#var enemy_list = [
	#preload("res://enemies/enemy_1.tscn"),
	#preload("res://enemies/enemy_2.tscn")]
	#preload("res://enemies/enemy_3.tscn")]
	
var enemy = preload("res://enemies/enemy_2.tscn")
var enemy_instance

# store enemy instances
#var enemy_instances = []

# control spawning
@onready var can_spawn_enemies = true
@onready var can_spawn_posessed = false
@onready var can_spawn_fireflies = true
#@onready var can_kill_possessed = true

func _ready() -> void:
	#show_timer()
	#show_health()
	
	Global.current_scene_name = "level_1"
	
	#fire_fly_spawn_timer.start(randi_range(10,18)) 

	# connecting to signals
	Events.win_game.connect(show_win_game)
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	
	Events.possessed_defeated.connect(_on_possessed_defeated)
	Events.send_scripted_enemy.connect(_on_spawn_scripted_enemy)
	Events.send_scripted_enemy2.connect(_on_spawn_scripted_enemy2)
	Events.send_scripted_enemy2_killed.connect(_on_scripted_enemy2_killed)
	Events.npc_is_scared_of_the_player2.connect(_on_npc_is_scared_of_the_player2)
	
	# resetting the score for every new game
	Global.score = 0
	print("resetting score:", Global.score)
	
	print(Global.current_scene_name)
		

	if npc_instance == null:  # check if the NPC instance exists
		npc_instance = npc.instantiate()  # instance the NPC
		#npc_instance.position = Vector2(576, 390)
		npc_instance.position = get_viewport_rect().size/2
		add_child(npc_instance)  # adding npc to the scene tree
		Global.npc_instance = npc_instance # store the instance in the global variable

		
	player_instance = player.instantiate()
	times_defeated_possessed = 0
	player_is_speedrunning_the_tutorial = false
	
	
	#var scripted_enemy1_instance = possessed.instantiate()
	#possessed_instance.position = Vector2(578, 426)
	#possessed_instance.speed = 125
	#call_deferred("add_child", possessed_instance)
	
	
	#npc_instance.can_npc_take_damage = false
	#npc_instance.can_npc_take_damage = true
	
	
	if Global.current_scene_name == "level_1":
		#%CountDownTimer.cd_timer.wait_time = 30.0
		%CountDownTimer.cd_timer.autostart = false
		#%CountDownTimer.cd_timer.set_wait_time(30.0)
		%CountDownTimer.cd_timer.start(30.0)
		%CountDownTimer.cd_timer.paused = true
		print("TUTORIAL start")
		npc_instance.npc_ignore_player = true
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("spawn_possessed"):
		spawn_possessed()
	
	
func show_win_game():
	sfx_win.play()
	win_game.show()
	kill_all_enemies()
	#Global.update_personal_best() # updating personal best ONLY when won the game
	# DON'T update personal best after the tutorial!
	can_spawn_enemies = false
	npc_instance.npc_ignore_player = true
	if Global.unlocked_levels < 2 :
		Global.unlocked_levels = 2
		print("unlocked level 2!")
	else:
		print("you already have level 2 unlocked")
	#get_tree().paused = true # pause game
#	I don't know if I need to unpause it when I go to other screen, show check it later
	pass

	
func show_game_over():
	npc_instance.npc_ignore_player = true
	player_instance.can_move = false
	#player_instance.set_physics_process(false)
	#is_game_over = true
	Global.is_game_over = true
	game_over.show()
	# show that the ghosts go back to hiding spots when sun rises
	kill_all_enemies()
	# main character (ghost) evaporates or is sad
	can_spawn_enemies = false
	#get_tree().paused = true # pause game
#	I don't know if I need to unpause it when I go to other screen, show check it later
	

func _on_npc_died():
	spawn_possessed()
	# maybe create some sort of effect?
	# like change the colour / apply filter
	kill_all_enemies()
	can_spawn_enemies = false
	$EnemySpawnTimer.wait_time = 1.8
	
	
func spawn_possessed():
	var possessed_instance = possessed.instantiate()
	possessed_instance.position = Vector2(578, 426)
	possessed_instance.speed = 125
	call_deferred("add_child", possessed_instance)
	times_defeated_possessed += 1
	print(times_defeated_possessed)
	
	# !!!!!!!!!!!!!!!! make it happen only once!!!!!!!!!!!
	# add to an int every time the possessed spawns and if >1 -> don't do this tutorial part again
	if times_defeated_possessed <= 1:
		#%CountDownTimer.cd_timer.wait_time = 30
		Events.possessed_spawned_tutorial.emit()
		Engine.time_scale = 0.3
		await get_tree().create_timer(0.7).timeout
		Engine.time_scale = 1.0
	else:
		print("already defeated the possessed, don't slow time")
	

func _on_possessed_defeated():
	possessed_dies.play()
	possessed_hit.play()
	if npc_instance != null:
		npc_instance.restore_health(2.0)
	else:
		print("npc not found")
	times_defeated_possessed += 1
	print(times_defeated_possessed)
		
	# !!!!!!!!!!!!!! make this also happen only once!!!!!!!!!!!!!!!!!!!
	if times_defeated_possessed <= 2:
		Events.possessed_defeated.emit()
		#%CountDownTimer.cd_timer.wait_time = 30
		await get_tree().create_timer(3.5).timeout
		show_timer()
		await get_tree().create_timer(3.5).timeout
		can_spawn_enemies = true
		%CountDownTimer.cd_timer.paused = false
		#%CountDownTimer.cd_timer.start()
		Events.start_counting_down.emit()
		print("startttt timer")
	elif times_defeated_possessed > 3:
		can_spawn_enemies = true
	


 #kill all enemies
func kill_all_enemies():
	#for enemy in enemy_instance:
##		if there are enemies present
		#if enemy != null and enemy.is_inside_tree():
			#enemy.die()
			##enemy.queue_free()
##	clear the list
	#enemy_instance.clear()
	for enemy_instance in get_tree().get_nodes_in_group("enemies"):
		if enemy_instance != null and enemy_instance.is_inside_tree():
			enemy_instance.die()
			enemy_instance.queue_free()


func spawn_enemy():
	# randomly get an enemy from the list
	# randi = random number
	#var random_enemy = enemy_list[randi() % enemy_list.size()]
	#enemy_instance
	
	var enemy_instance = enemy.instantiate() # selected enemy is instantiated
	%PathFollow2D.progress_ratio = randf() # get a random position from Path2D
	enemy_instance.global_position = %PathFollow2D.global_position
	add_child(enemy_instance) # spawn to the scene
	#enemy_instance.append(enemy_instance) # store the instance of the enemy in the list
	enemy_instance.add_to_group("enemies") # add the enemy into the group
	can_spawn_enemies = true
	
	
func _on_enemy_spawn_timer_timeout() -> void:
	if can_spawn_enemies:
		spawn_enemy()
	else:
		return
		
		
func spawn_firefly():
	var firefly_instance = firefly.instantiate()
	
	%PathFollow2D.progress_ratio = randf() # get a random position from Path2D
	firefly_instance.global_position = %PathFollow2D.global_position
	add_child(firefly_instance) # spawn to the scene
	#enemy_instances.append(enemy_instance) # store the instance of the enemy in the list
	firefly_instance.add_to_group("firefly")
	can_spawn_fireflies = true


func _on_fire_fly_spawn_timer_timeout() -> void:
	if can_spawn_fireflies:
		#spawn_firefly()
		pass
	else:
		return

# ---- TUTORIAL PART ----

func _on_spawn_scripted_enemy():
	print("spawn enemy lmao")
	scripted_enemy.play("scripted_enemy2")
	
func _on_spawn_scripted_enemy2():
	print("spawn enemy2 lmao")
	scripted_enemy_2.play("scripted_enemy")
	

#func _on_npc_is_scared_of_the_player():
func _on_npc_is_scared_of_the_player2():
	if npc_instance.is_alive:
		npc_instance.npc_ignore_player = false
	await get_tree().create_timer(1.8).timeout
	
	$EnemySpawnTimer.start()
	print("spawn enemies")
	await get_tree().create_timer(7).timeout
	$EnemySpawnTimer.stop()
	await get_tree().create_timer(3).timeout
	show_health()
	await get_tree().create_timer(4).timeout
	$EnemySpawnTimer.wait_time = 0.1
	$EnemySpawnTimer.start()
	

	
func _on_scripted_enemy2_killed():
	Events.npc_is_scared_of_the_player.emit()
	
	#$EnemySpawnTimer.start()
	#print("spawn enemies")
	#await get_tree().create_timer(15).timeout
	#$EnemySpawnTimer.stop()
	#await get_tree().create_timer(3).timeout
	#show_health()
	#await get_tree().create_timer(5).timeout
	#$EnemySpawnTimer.wait_time = 0.1
	#$EnemySpawnTimer.start()




func show_timer():
	timer_animation_player.play("show_timer")
	
func show_health():
	health_animation_player.play("show_health")
	
