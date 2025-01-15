extends Control

@onready var camera = get_node("Camera2D")

# list of enemies
var enemy_list = [
	preload("res://scenes/enemy_1.tscn"),
	preload("res://scenes/enemy_2.tscn")
]

# how far outside the camera to spawn enemies
# 1st number - min distance, 2nd number - max distance in pixles
@export var spawn_distance_range = Vector2(500, 1000)

func _ready() -> void:
#	checking if camera node is found
	if camera == null:
		print("camera is not found, where is camera?")
	else:
		print("camera found")

# when enemy timer reaches zero -> ready to spawn another enemy
func _on_enemy_1_spawn_timer_timeout() -> void:
	# Ensure the camera is initialized and its position is accessible
	if camera == null:
#		can't spawn enemy if camera is not found
		print("Cannot spawn enemies, camera is not ready!")
		return
	
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

	# adding the enemy to the group
	enemy_instance.add_to_group("enemies")

# calculate random spawn spot around the camera
func get_random_position_around_camera(camera_position: Vector2, camera_size: Vector2) -> Vector2:
	# min and max spawn distance from the camera
	var min_distance = spawn_distance_range.x
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
	
	
