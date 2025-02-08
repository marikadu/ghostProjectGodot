#extends Control
extends Node2D
# -- LEVEL 2

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


var possessed = preload("res://enemies/possessed.tscn")
var npc_instance: Node = null
var player_instance
#var npc_instance = null

# list of enemies
var enemy_list = [
	preload("res://enemies/enemy_1.tscn"),
	preload("res://enemies/enemy_2.tscn"),
	preload("res://enemies/enemy_3.tscn")]

# store enemy instances
var enemy_instances = []

# control spawning
@onready var can_spawn_enemies = true
@onready var can_spawn_posessed = false
@onready var can_spawn_fireflies = true
#@onready var can_kill_possessed = true

func _ready() -> void:
	Global.current_scene_name = 2
	
	Global.is_game_won = false
	%CountDownTimer.cd_timer.paused = false
	$EnemySpawnTimer.wait_time = 0.9
	
	#fire_fly_spawn_timer.start(randi_range(10,18)) 

	# connecting to signals
	Events.win_game.connect(show_win_game)
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	Events.possessed_defeated.connect(_on_possessed_defeated)
	
	# resetting the score for every new game
	Global.score = 0
	print("resetting score:", Global.score)
		
	print(Global.current_scene_name)
		
	
	if npc_instance == null:  # check if the NPC instance exists
		npc_instance = npc.instantiate()  # instance the NPC
		npc_instance.position = get_viewport_rect().size/2
		add_child(npc_instance)  # adding npc to the scene tree
		Global.npc_instance = npc_instance # store the instance in the global variable
		#print("NPC ready")
	#else:
		#print("NPC already instantiated or error occured")
		
	player_instance = player.instantiate()
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_possessed"):
		spawn_possessed()
	
	
func show_win_game():
	Global.is_game_won = true
	AudioManager.play_win()
	win_game.show()
	kill_all_enemies()
	Global.update_personal_best() # updating personal best ONLY when won the game
	can_spawn_enemies = false
	can_spawn_fireflies = false
	npc_instance.npc_ignore_player = true
	if Global.unlocked_levels < 3 :
		Global.unlocked_levels = 3
		print("unlocked level 3!")
	else:
		print("you already have level 3 unlocked")


	
func show_game_over():
	if not Global.is_game_over: # don't trigget game over if there is already game over
		player_instance.can_move = false
		Global.is_game_over = true
		game_over.show()
		AudioManager.play_game_over()
		# show that the ghosts go back to hiding spots when sun rises
		kill_all_enemies()
		can_spawn_enemies = false
		can_spawn_fireflies = false
		npc_instance.npc_ignore_player = true
		%CountDownTimer.cd_timer.paused = true
		#get_tree().paused = true # pause game
	#	I don't know if I need to unpause it when I go to other screen, show check it later
	

#func _on_npc_died():
	#spawn_possessed()
	## maybe create some sort of effect?
	## like change the colour / apply filter
	#kill_all_enemies()
	#can_spawn_enemies = false
	
func _on_npc_died():
	match npc_instance.killed_by:
		"enemy1", "enemy2", "enemy3":
			spawn_possessed()
			kill_all_enemies()
			can_spawn_enemies = false
			can_spawn_fireflies = false
		_:
			print("dammmn you woke them up")
			#kill_all_enemies()
			show_game_over()
			#can_spawn_enemies = false
			#can_spawn_fireflies = false
	
	
func spawn_possessed():
	var possessed_instance = possessed.instantiate()
	possessed_instance.position = Vector2(578, 426)
	possessed_instance.speed = 130
	possessed_instance.max_speed = 175
	call_deferred("add_child", possessed_instance)


func _on_possessed_defeated():
	AudioManager.play_posessed_dies()
	AudioManager.play_posessed_hit()
	can_spawn_enemies = true
	if npc_instance != null:
		npc_instance.restore_health(4.0)
	else:
		print("npc not found")


# kill all enemies
func kill_all_enemies():
	for enemy in enemy_instances:
#		if there are enemies present
		if enemy != null and enemy.is_inside_tree():
			enemy.die()
			#enemy.queue_free()
#	clear the list
	enemy_instances.clear()


func spawn_enemy():
	# randomly get an enemy from the list
	# randi = random number
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
		pass
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
