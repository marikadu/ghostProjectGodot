#extends Control
extends Node2D
# -- LEVEL 2
# -- aka TUTORIAL 2


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
@onready var tutorial: Control = $Tutorial2



var possessed = preload("res://enemies/possessed.tscn")
var npc_instance: Node = null  # Store the NPC instance
var player_instance
#var times_defeated_possessed: int
#var player_is_speedrunning_the_tutorial: bool
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
	#show_timer()
	#show_health()
	
	Global.current_scene_name = 2
	print(Global.current_scene_name)
	
	Global.is_game_won = false
	
	#fire_fly_spawn_timer.start(randi_range(10,18)) 
	fire_fly_spawn_timer.start(7) 
	#enemy_spawn_timer.start(0.4) 

	# connecting to signals
	Events.win_game.connect(show_win_game)
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	Events.possessed_defeated.connect(_on_possessed_defeated)
	
	# tutorial signals


	
	# resetting the score for every new game
	Global.score = 0
	print("resetting score:", Global.score)
	

	if npc_instance == null:  # check if the NPC instance exists
		npc_instance = npc.instantiate()  # instance the NPC
		npc_instance.position = get_viewport_rect().size/2
		add_child(npc_instance)  # adding npc to the scene tree
		Global.npc_instance = npc_instance # store the instance in the global variable

		
	player_instance = player.instantiate()
	
	
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("spawn_possessed"):
		spawn_possessed()
	
	
func show_win_game():
	sfx_win.play()
	win_game.show()
	Global.is_game_won = true
	kill_all_enemies()
	#Global.update_personal_best() # updating personal best ONLY when won the game
	# DON'T update personal best after the tutorial!
	can_spawn_enemies = false
	npc_instance.npc_ignore_player = true
	if Global.unlocked_levels < 3 :
		Global.unlocked_levels = 3
		print("unlocked level 3!")
	else:
		print("you already have level 3 unlocked")
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
	kill_all_enemies()
	can_spawn_enemies = false
	

func _on_npc_died():
	spawn_possessed()
	kill_all_enemies()
	can_spawn_enemies = false
	$EnemySpawnTimer.wait_time = 1.6
	
	
func spawn_possessed():
	var possessed_instance = possessed.instantiate()
	possessed_instance.position = Vector2(578, 426)
	possessed_instance.speed = 135
	call_deferred("add_child", possessed_instance)
	

func _on_possessed_defeated():
	possessed_dies.play()
	possessed_hit.play()
	if npc_instance != null:
		npc_instance.restore_health(2.0)
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
	firefly_instance.add_to_group("firefly")
	can_spawn_fireflies = true


func _on_fire_fly_spawn_timer_timeout() -> void:
	if can_spawn_fireflies:
		spawn_firefly()
		pass
	else:
		return

# ---- TUTORIAL PART ----
