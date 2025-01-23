extends Control

# CTRL + drag a script to put it here with @onready with $
#@onready var camera_2d: Camera2D = $Camera2D

@onready var camera: Camera2D = %Camera2D
@onready var win_game: ColorRect = $UI/WinScreen
@onready var game_over: ColorRect = $UI/GameOverScreen

@onready var npc = preload("res://scenes/npc.tscn")
@onready var possessed_dies: AudioStreamPlayer2D = $possessed_dies
@onready var possessed_hit: AudioStreamPlayer2D = $possessed_hit


var possessed = preload("res://enemies/possessed.tscn")
var npc_instance: Node = null  # Store the NPC instance
#var npc_instance = null

# list of enemies
var enemy_list = [
	preload("res://enemies/enemy_1.tscn"),
	preload("res://enemies/enemy_2.tscn"),
	preload("res://enemies/enemy_3.tscn")
]

# store enemy instances
var enemy_instances = []

# control spawning
@onready var can_spawn_enemies = true
@onready var can_spawn_posessed = false
#@onready var possessed_area = $PossessedArea  # Replace with your Area2D node's path

# how far outside the camera to spawn enemies
# 1st number - min distance, 2nd number - max distance in pixles
@export var spawn_distance_range = Vector2(550, 1200)

func _ready() -> void:

	# connecting to signals
	Events.win_game.connect(show_win_game)
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	Events.possessed_defeated.connect(_on_possessed_defeated)
	
	# resetting the score for every new game
	Global.score = 0
	print("resetting score:", Global.score)
	
#	checking if camera node is found
	if camera == null:
		print("camera is not found, where is camera?")
	else:
		print("camera found")
		
	#possessed.possessed_area.connect("body_exited", self, "_on_possessed_escapes_body_exited")
		
	
	if npc_instance == null:  # check if the NPC instance exists
		npc_instance = npc.instantiate()  # instance the NPC
		#npc_instance.position = Vector2(576, 390)
		npc_instance.position = get_viewport_rect().size/2
		add_child(npc_instance)  # adding npc to the scene tree
		Global.npc_instance = npc_instance # store the instance in the global variable
		print("NPC ready")
	else:
		print("NPC already instantiated or error occured")
	
	
func show_win_game():
	win_game.show()
	kill_all_enemies()
	# updating personal best ONLY when won the game
	Global.update_personal_best()
	can_spawn_enemies = false
	#get_tree().paused = true # pause game
#	I don't know if I need to unpause it when I go to other screen, show check it later
	pass

	
func show_game_over():
	game_over.show()
	# show that the ghosts go back to hiding spots when sun rises
	kill_all_enemies()
	# main character (ghost) evaporates or is sad
	can_spawn_enemies = false
	#get_tree().paused = true # pause game
#	I don't know if I need to unpause it when I go to other screen, show check it later
	

func _on_npc_died():
	spawn_possessed_enemy()
	# maybe create some sort of effect?
	# like change the colour / apply filter
	kill_all_enemies()
	can_spawn_enemies = false
	
func spawn_possessed_enemy():
	var possessed_instance = possessed.instantiate()
	#possessed_instance.position = Vector2(576, 390)
	possessed_instance.position = Vector2(578, 426)
	#add_child(possessed_instance)
	call_deferred("add_child", possessed_instance)

func _on_possessed_defeated():
	possessed_dies.play()
	possessed_hit.play()
	can_spawn_enemies = true
	if npc_instance != null:
		npc_instance.restore_health(2)
	else:
		print("npc not found")


# kill all enemies
func kill_all_enemies():
	for enemy in enemy_instances:
#		if there are enemies present
		if enemy != null and enemy.is_inside_tree():
			enemy.queue_free()
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
	else:
		return
	#pass # Replace with function body.


## ------ old way of spawning enemies ------
#
## when enemy timer reaches zero -> ready to spawn another enemy
#func _on_enemy_1_spawn_timer_timeout() -> void:
	#if not can_spawn_enemies:
		#return
	#
##	checking if camera is found and is accesible
	#if camera == null:
##		can't spawn enemy if camera is not found
		#print("Cannot spawn enemies, camera is not ready!")
		#return
		#
	#can_spawn_enemies = false
	#
	## randomly get an enemy from the list
	## randi = random number
	#var random_enemy = enemy_list[randi() % enemy_list.size()]
#
	## selected enemy is instantiated
	#var enemy_instance = random_enemy.instantiate()
#
	## get camera's position
	#var camera_position = camera.position
	#
	## get the viewport size (usually the same as camera's size)
	#var camera_size = get_viewport().size
#
	## randomly choose a position outside the camera view
	#var spawn_position = get_random_position_around_camera(camera_position, camera_size)
#
	## set the spawn position for the enemy
	#enemy_instance.position = spawn_position
#
	## addding the enemy to the scene
	#add_child(enemy_instance)
	#
	## store the instance of the enemy in the list
	#enemy_instances.append(enemy_instance)
#
	## adding the enemy to the group
	#enemy_instance.add_to_group("enemies")
	#
	#can_spawn_enemies = true
#
## calculate random spawn spot around the camera
#func get_random_position_around_camera(camera_position: Vector2, _camera_size: Vector2) -> Vector2:
	## min and max spawn distance from the camera
	##var min_distance = spawn_distance_range.x
	#var max_distance = spawn_distance_range.y
#
	#var spawn_x = 0
	#var spawn_y = 0
#
	## randomly choose where the enemy should be spawned (left, up, right, or down)
	#if randi() % 2 == 0:
		## spawn left or right
		#spawn_x = camera_position.x + randi_range(-max_distance, max_distance)
	#else:
		## spawn up or down
		#spawn_y = camera_position.y + randi_range(-max_distance, max_distance)
#
	#return Vector2(spawn_x, spawn_y)
	#
	##-----------------
	
