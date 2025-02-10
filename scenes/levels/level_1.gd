#extends Control
extends Node2D
# -- LEVEL 1
# -- aka TUTORIAL


@onready var camera: Camera2D = %Camera2D
@onready var win_game: ColorRect = $UI/WinScreen
@onready var game_over: ColorRect = $UI/GameOverScreen

@onready var npc = preload("res://player/npc.tscn")
@onready var player = preload("res://player/ghost_player.tscn")
@onready var firefly = preload("res://player/firefly.tscn")
@onready var fire_fly_spawn_timer: Timer = $FireFlySpawnTimer

@onready var timer_animation_player: AnimationPlayer = $UI/CountDownTimer/timerPlayer
@onready var health_animation_player: AnimationPlayer = $UI/HealthBar/healthPlayer
@onready var tutorial: Control = $Tutorial


var possessed = preload("res://enemies/possessed.tscn")
var npc_instance: Node = null  # store the NPC instance
var player_instance
var player_is_speedrunning_the_tutorial: bool


# list of enemies
var enemy_list = [
	preload("res://enemies/enemy_1.tscn"),
	preload("res://enemies/enemy_2.tscn"),
	preload("res://enemies/enemy_3.tscn")]
	

# for the tutorial: enemy showcase 
var scripted_enemy_1 = preload("res://enemies/enemy_2_tutorial.tscn")
var scripted_enemy_1_instance
var scripted_enemy_2 = preload("res://enemies/enemy_1_tutorial.tscn")
var scripted_enemy_2_instance
var scripted_enemy_3 = preload("res://enemies/enemy_3_tutorial.tscn")
var scripted_enemy_3_instance
# tutorial ghost
var orial = preload("res://player/orial.tscn")
var orial_instance


# store enemy instances
var enemy_instances = []

# control spawning
@onready var can_spawn_enemies = true
@onready var can_spawn_fireflies = true
@onready var can_spawn_posessed = false


func _ready() -> void:
	#show_timer()
	#show_health()
	
	Global.current_scene_name = 1
	print(Global.current_scene_name)
	
	Global.is_game_won = false
	
	#fire_fly_spawn_timer.start(randi_range(10,18)) 

	# connecting to signals
	Events.win_game.connect(show_win_game)
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	Events.possessed_defeated.connect(_on_possessed_defeated)
	Events.game_over_woke_up_human.connect(_on_woke_up_human)
	
	# tutorial signals
	Events.send_scripted_enemy.connect(_on_spawn_scripted_enemy)
	#Events.send_scripted_enemy2.connect(_on_spawn_scripted_enemy2)
	Events.killed_scripted_enemy2.connect(_on_scripted_enemy2_killed)
	Events.killed_scripted_enemy3.connect(_on_scripted_enemy3_killed)
	Events.npc_is_scared_of_the_player2.connect(_on_npc_is_scared_of_the_player2)
	Events.introduce_fireflies.connect(_on_introduce_fireflies)
	
	
	# resetting the score for every new game
	Global.score = 0
	#print("resetting score:", Global.score)
	

	if npc_instance == null:  # check if the NPC instance exists
		npc_instance = npc.instantiate()  # instance the NPC
		#npc_instance.position = Vector2(576, 390)
		npc_instance.position = get_viewport_rect().size/2
		add_child(npc_instance)  # adding npc to the scene tree
		Global.npc_instance = npc_instance # store the instance in the global variable

		
	player_instance = player.instantiate()
	player_is_speedrunning_the_tutorial = false
	
	AudioManager.play_game_theme()
	# prevents the "gameover" or "win" from playing again
	AudioManager.OST["parameters/switch_to_clip"] = "Intro" 
	
	
	if scripted_enemy_1_instance == null:  # check if the scripted_1 instance exists
		scripted_enemy_1_instance = scripted_enemy_1.instantiate()
		scripted_enemy_1_instance.position = Vector2(368, -77)
		add_child(scripted_enemy_1_instance)
		
	if scripted_enemy_2_instance == null:  # check if the scripted_2 instance exists
		scripted_enemy_2_instance = scripted_enemy_2.instantiate()
		scripted_enemy_2_instance.position = Vector2(1300, 335)
		add_child(scripted_enemy_2_instance)
		
	if scripted_enemy_3_instance == null:  # check if the scripted_3 instance exists
		scripted_enemy_3_instance = scripted_enemy_3.instantiate()
		scripted_enemy_3_instance.position = Vector2(298, 997)
		add_child(scripted_enemy_3_instance)
		
	if orial_instance == null:
		orial_instance = orial.instantiate()
		orial_instance.position = Vector2(-98, 642)
		add_child(orial_instance)
	
	
	if Global.current_scene_name == 1:
		%CountDownTimer.cd_timer.autostart = false
		%CountDownTimer.cd_timer.start(30.0)
		%CountDownTimer.cd_timer.paused = true
		print("TUTORIAL start")
		npc_instance.npc_ignore_player = true
	
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_possessed"):
		spawn_possessed()
	
	
func show_win_game():
	win_game.show()
	Global.is_game_won = true
	kill_all_enemies()
	Global.update_personal_best() # updating personal best ONLY when won the game
	can_spawn_enemies = false
	can_spawn_fireflies = false
	npc_instance.npc_ignore_player = true
	Events.win_game_tutorial.emit()
	if Global.unlocked_levels < 2 :
		Global.unlocked_levels = 2
		print("unlocked level 2!")
	else:
		print("you already have level 2 unlocked")
	#get_tree().paused = true # pause game
#	I don't know if I need to unpause it when I go to other screen, show check it later
	pass

	
func show_game_over():
	if not Global.is_game_over: # don't trigget game over if there is already game over
		player_instance.can_move = false
		Global.is_game_over = true
		game_over.show()
		# show that the ghosts go back to hiding spots when sun rises
		kill_all_enemies()
		# main character (ghost) evaporates or is sad
		can_spawn_enemies = false
		npc_instance.npc_ignore_player = true
		can_spawn_fireflies = false
		%CountDownTimer.cd_timer.paused = true
		#get_tree().paused = true # pause game
	#	I don't know if I need to unpause it when I go to other screen, show check it later

func _on_woke_up_human():
	npc_instance.npc_ignore_player = true
	player_instance.can_move = false
	Global.is_game_over = true
	game_over.show()
	kill_all_enemies()
	can_spawn_enemies = false
	can_spawn_fireflies = false
	%CountDownTimer.cd_timer.paused = true


# NPC died
# maybe create some sort of effect?
# like change the colour / apply filter
func _on_npc_died():
	match npc_instance.killed_by:
		"enemy1", "enemy2", "enemy3":
			spawn_possessed()
			kill_all_enemies()
			can_spawn_enemies = false
			can_spawn_fireflies = false
		_:
			print("dammmn you woke them up")
			kill_all_enemies()
			can_spawn_enemies = false
			can_spawn_fireflies = false
	
	
func spawn_possessed():
	var possessed_instance = possessed.instantiate()
	possessed_instance.position = Vector2(578, 426)
	# lower speed for the tutorial
	possessed_instance.speed = 120
	possessed_instance.max_speed = 160
	call_deferred("add_child", possessed_instance)
	

func _on_possessed_defeated():
	AudioManager.play_posessed_dies()
	AudioManager.play_posessed_hit()
	if npc_instance != null:
		npc_instance.restore_health(5.0)
	else:
		print("npc not found")
	can_spawn_enemies = true
	


 #kill all enemies
func kill_all_enemies():
	for enemy in enemy_instances:
#		if there are enemies present
		if enemy != null and enemy.is_inside_tree():
			enemy.die()
			#enemy.queue_free()
#	clear the list
	enemy_instances.clear()
	


func spawn_enemy():
	var random_enemy = enemy_list[randi() % enemy_list.size()]
	
	var enemy_instance = random_enemy.instantiate() # selected enemy is instantiated
	%PathFollow2D.progress_ratio = randf() # get a random position from Path2D
	enemy_instance.global_position = %PathFollow2D.global_position
	add_child(enemy_instance) # spawn to the scene
	enemy_instances.append(enemy_instance) # store the instance of the enemy in the list
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
		spawn_firefly()
		pass
	else:
		return



# ---- TUTORIAL PART ----

func _on_spawn_scripted_enemy():
	scripted_enemy_1_instance.scripted_enemy.play("scripted_enemy2")
	
	
#func _on_spawn_scripted_enemy2():
	#print("spawn enemy2 lmao")
	#scripted_enemy_2.play("scripted_enemy")
	

func _on_npc_is_scared_of_the_player2():
	if npc_instance.is_alive:
		npc_instance.npc_ignore_player = false
	await get_tree().create_timer(1.8, false).timeout
	
	$EnemySpawnTimer.start()
	await get_tree().create_timer(7.8, false).timeout
	$EnemySpawnTimer.stop()
	Events.introduce_fireflies.emit()

	
	# INTRODUCE TO THE FIREFLIES HERE
func _on_introduce_fireflies():
	if not Global.is_game_over:

		await get_tree().create_timer(2.2, false).timeout
		show_health()
		await get_tree().create_timer(3.5, false).timeout
		
		spawn_firefly()
		await get_tree().create_timer(3, false).timeout
		
		$FireFlySpawnTimer.start()
		$FireFlySpawnTimer.wait_time = 2.7
		#show_health()
		await get_tree().create_timer(3, false).timeout
		# enemies spawn slowly while introducing to the fireflies
		$EnemySpawnTimer.wait_time = 3.2
		$EnemySpawnTimer.start()
		
		await get_tree().create_timer(9, false).timeout
		$FireFlySpawnTimer.start()
		$FireFlySpawnTimer.wait_time = 5.6
		_on_show_the_rest_of_ui()


func _on_show_the_rest_of_ui():
	if not Global.is_game_over:
		#await get_tree().create_timer(3).timeout
		#show_health()
		await get_tree().create_timer(4, false).timeout
		
		# showing the timer
		$EnemySpawnTimer.wait_time = 1.5
		$FireFlySpawnTimer.wait_time = 8
		show_timer()
		
		# starting the game
		await get_tree().create_timer(3.5, false).timeout
		%CountDownTimer.cd_timer.paused = false
		Events.start_counting_down.emit()
		$EnemySpawnTimer.start()
	
	

	
func _on_scripted_enemy2_killed():
	#Events.npc_is_scared_of_the_player.emit()
	Events.send_scripted_enemy3.emit()
	
func _on_scripted_enemy3_killed():
	Events.npc_is_scared_of_the_player.emit()



func show_timer():
	if not Global.is_game_over:
		timer_animation_player.play("show_timer")
	
func show_health():
	if not Global.is_game_over:
		health_animation_player.play("show_health")
	
