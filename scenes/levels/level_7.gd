#extends Control
extends Node2D
# -- LEVEL 7

# CTRL + drag a script to put it here with @onready with $
#@onready var camera_2d: Camera2D = $Camera2D

@onready var camera: Camera2D = %Camera2D
@onready var win_game: ColorRect = $UI/WinScreen_completed_game
@onready var game_over: ColorRect = $UI/GameOverScreen
#@onready var is_game_over = false

@onready var npc = preload("res://player/npc.tscn")
@onready var player = preload("res://player/ghost_player.tscn")
@onready var firefly = preload("res://player/firefly.tscn")
@onready var fire_fly_spawn_timer: Timer = $FireFlySpawnTimer
@onready var possessed_dies: AudioStreamPlayer2D = $possessed_dies
@onready var possessed_hit: AudioStreamPlayer2D = $possessed_hit
@onready var sfx_win: AudioStreamPlayer2D = $win
@onready var sfx_game_over: AudioStreamPlayer2D = $game_over

# level 7 special
@onready var spawn_timer_decrease: Timer = $SpawnTimerDecrease
var min_spawn_time = 0.3
var decrease_amount = 0.2 # for how much to decrease every 20 seconds
var decrease_interval = 20.0
var times_possessed_is_spawned = 0

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
	Global.current_scene_name = 7
	
	Global.is_game_won = false
	
	# start with slower and gradually go to faster
	# every 20 seconds the time is decreased by 0.2
	$EnemySpawnTimer.wait_time = 1.4
	spawn_timer_decrease.wait_time = decrease_interval
	
	#fire_fly_spawn_timer.start(randi_range(10,18)) 

	# connecting to signals
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	Events.possessed_defeated.connect(_on_possessed_defeated)
	
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
		#print("NPC ready")
	#else:
		#print("NPC already instantiated or error occured")
		
	player_instance = player.instantiate()
	
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_possessed"):
		spawn_possessed()


func show_game_over():
	if not Global.is_game_over: # don't trigget game over if there is already game over
		player_instance.can_move = false
		Global.is_game_over = true
		game_over.show()
		Global.update_personal_best() # update personal best when game over only for level 7
		# personal best time
		Global.time_recorded = $"%Timer".get_time_formatted()
		Global.update_personal_best_time()
		sfx_game_over.play()
		# show that the ghosts go back to hiding spots when sun rises
		kill_all_enemies()
		can_spawn_enemies = false
		can_spawn_fireflies = false
		npc_instance.npc_ignore_player = true


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
	
	call_deferred("add_child", possessed_instance)
	
	# increase speed every time the possessed is spawned
	var min_speed_increase = times_possessed_is_spawned * 10
	var speed_increase = times_possessed_is_spawned * 12
	var max_speed_increase = times_possessed_is_spawned * 4
	
	possessed_instance.min_speed = 130 + min_speed_increase
	possessed_instance.speed = 145 + speed_increase
	possessed_instance.max_speed = 260 + max_speed_increase
	
	times_possessed_is_spawned += 1
	
	print("times possessed is spawned: ", times_possessed_is_spawned)
	


func _on_possessed_defeated():
	possessed_dies.play()
	possessed_hit.play()
	can_spawn_enemies = true
	if npc_instance != null:
		npc_instance.restore_health(2.0)
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


func _on_spawn_timer_decrease_timeout() -> void:
	$EnemySpawnTimer.wait_time = max($EnemySpawnTimer.wait_time - decrease_amount, min_spawn_time)
	print("spawn rate decreased: ", $EnemySpawnTimer.wait_time)
	
	# the possessed's speed changes
	#possessed_instance.min_speed = 160
	#possessed_instance.speed = 180
	#possessed_instance.max_speed = 300
	
