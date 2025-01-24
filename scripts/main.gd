extends Control

# CTRL + drag a script to put it here with @onready with $
#@onready var camera_2d: Camera2D = $Camera2D

@onready var camera: Camera2D = %Camera2D
@onready var win_game: ColorRect = $UI/WinScreen
@onready var game_over: ColorRect = $UI/GameOverScreen
@onready var is_game_over = false

@onready var npc = preload("res://scenes/npc.tscn")
@onready var possessed_dies: AudioStreamPlayer2D = $possessed_dies
@onready var possessed_hit: AudioStreamPlayer2D = $possessed_hit
@onready var sfx_win: AudioStreamPlayer2D = $win


var possessed = preload("res://enemies/possessed.tscn")
var npc_instance: Node = null  # Store the NPC instance
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
#@onready var can_kill_possessed = true

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
	sfx_win.play()
	win_game.show()
	kill_all_enemies()
	Global.update_personal_best() # updating personal best ONLY when won the game
	can_spawn_enemies = false
	#get_tree().paused = true # pause game
#	I don't know if I need to unpause it when I go to other screen, show check it later
	pass

	
func show_game_over():
	is_game_over = true
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
		#spawn_enemy()
		pass
	else:
		return
