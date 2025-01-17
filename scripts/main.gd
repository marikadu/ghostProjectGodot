extends Control

@onready var camera = get_node("Camera2D")
#@onready var win_game = $Node/WinScreen
@onready var win_game = get_node("Node/WinScreen")
@onready var game_over = get_node("Node/GameOverScreen")
#@onready var events = get_node("Events")
#@onready var event_node = get_node("res://scripts/Events.gd")

var possessed = preload("res://scenes/possessed.tscn")
@onready var npc = preload("res://scenes/npc.tscn")
var npc_instance: Node = null  # Store the NPC instance
#var npc_instance = null

# list of enemies
var enemy_list = [
	preload("res://scenes/enemy_1.tscn"),
	preload("res://scenes/enemy_2.tscn")
]

# store enemy instances
var enemy_instances = []

# control spawning
@onready var can_spawn_enemies = true
@onready var can_spawn_posessed = false
#@onready var possessed_area = $PossessedArea  # Replace with your Area2D node's path

# how far outside the camera to spawn enemies
# 1st number - min distance, 2nd number - max distance in pixles
@export var spawn_distance_range = Vector2(500, 1000)

func _ready() -> void:

	# connecting to signals
	Events.win_game.connect(show_win_game)
	Events.game_over.connect(show_game_over)
	Events.npc_died.connect(_on_npc_died)
	Events.possessed_defeated.connect(_on_possessed_defeated)
	
#	checking if camera node is found
	if camera == null:
		print("camera is not found, where is camera?")
	else:
		print("camera found")
		
	#possessed.possessed_area.connect("body_exited", self, "_on_possessed_escapes_body_exited")
		
	
	if npc_instance == null:  # check if the NPC instance exists
		npc_instance = npc.instantiate()  # instance the NPC
		npc_instance.position = Vector2(576, 390)
		add_child(npc_instance)  # adding npc to the scene tree
		Global.npc_instance = npc_instance # store the instance in the global variable
		print("NPC ready")
	else:
		print("NPC already instantiated or error occured")
	
	
func show_win_game():
	win_game.show()
	kill_all_enemies()
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
	pass
	


func _on_npc_died():
	spawn_possessed_enemy()
#	maybe create some sort of effect "za warudo" or something, but don't affect time?
	kill_all_enemies()
	can_spawn_enemies = false
	pass
	
func spawn_possessed_enemy():
	var possessed_instance = possessed.instantiate()
	possessed_instance.position = Vector2(576, 390)
	#add_child(possessed_instance)
	call_deferred("add_child", possessed_instance)

func _on_possessed_defeated():
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

# when enemy timer reaches zero -> ready to spawn another enemy
func _on_enemy_1_spawn_timer_timeout() -> void:
	if not can_spawn_enemies:
		return
	
#	checking if camera is found and is accesible
	if camera == null:
#		can't spawn enemy if camera is not found
		print("Cannot spawn enemies, camera is not ready!")
		return
		
	can_spawn_enemies = false
	
	# randomly get an enemy from the list
	# randi = random number
	var random_enemy = enemy_list[randi() % enemy_list.size()]

	# selected enemy is instantiated
	var enemy_instance = random_enemy.instantiate()

	# get camera's position
	var camera_position = camera.position
	
	# get the viewport size (usually the same as camera's size)
	var camera_size = get_viewport().size

	# randomly choose a position outside the camera view
	var spawn_position = get_random_position_around_camera(camera_position, camera_size)

	# set the spawn position for the enemy
	enemy_instance.position = spawn_position

	# addding the enemy to the scene
	add_child(enemy_instance)
	
	# store the instance of the enemy in the list
	enemy_instances.append(enemy_instance)

	# adding the enemy to the group
	enemy_instance.add_to_group("enemies")
	
	can_spawn_enemies = true

# calculate random spawn spot around the camera
func get_random_position_around_camera(camera_position: Vector2, _camera_size: Vector2) -> Vector2:
	# min and max spawn distance from the camera
	#var min_distance = spawn_distance_range.x
	var max_distance = spawn_distance_range.y

	var spawn_x = 0
	var spawn_y = 0

	# randomly choose where the enemy should be spawned (left, up, right, or down)
	if randi() % 2 == 0:
		# spawn left or right
		spawn_x = camera_position.x + randi_range(-max_distance, max_distance)
	else:
		# spawn up or down
		spawn_y = camera_position.y + randi_range(-max_distance, max_distance)

	return Vector2(spawn_x, spawn_y)
	
	
