extends Control

@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5

@onready var hit: AudioStreamPlayer2D = $hit
#@onready var player = preload("res://player/ghost_player.tscn")
#var player: CharacterBody2D
@onready var player = get_tree().root.get_node("main/GhostPlayer")

var can_hit_1
var can_hit_2
var can_hit_3
var can_hit_4
var can_hit_5

func _ready() -> void:
	can_hit_1 = true
	can_hit_2 = false
	can_hit_3 = false
	can_hit_4 = false
	can_hit_5 = false

	label_1.visible = true
	label_2.visible = false
	label_3.visible = false
	label_4.visible = false
	label_5.visible = false
	
	
	Events.killed_scripted_enemy3.connect(_on_npc_is_scared_of_the_player_text)
	#Events.send_scripted_enemy2_killed.connect(_on_enemies_start_spawning)
	Events.possessed_spawned_tutorial.connect(_on_possessed_spawned)
	Events.possessed_defeated.connect(_on_possessed_defeated_first_time)
	Events.start_counting_down.connect(_on_start_counting_down)


func _physics_process(delta: float) -> void:
	label_1.scale.x = move_toward(label_1.scale.x, 1, 3 * delta)
	label_1.scale.y = move_toward(label_1.scale.y, 1, 3 * delta)
	
	label_2.scale.x = move_toward(label_2.scale.x, 1, 3 * delta)
	label_2.scale.y = move_toward(label_2.scale.y, 1, 3 * delta)
	
	label_3.scale.x = move_toward(label_3.scale.x, 1, 3 * delta)
	label_3.scale.y = move_toward(label_3.scale.y, 1, 3 * delta)
	
	label_4.scale.x = move_toward(label_4.scale.x, 1, 3 * delta)
	label_4.scale.y = move_toward(label_4.scale.y, 1, 3 * delta)

func _on_first_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_1:
		#if can_hit_1:
		first_get_hit()
			#print("yo yo")
		
#func _on_b_area_body_entered(body: Node2D) -> void:
	#if body == player and player.dashing:
		#first_get_hit()
		#print("yo yo")

func first_get_hit():
	#player.ghost_dies.play()
	player.hit.play()
	#hit_flash.play("hit_flash")
	label_1.scale = Vector2(1.5, 0.7)
	player.dash_hit.play()
	await get_tree().create_timer(0.4).timeout
	label_1.visible = false
	can_hit_1 = false
	#label_1.queue_free()
	label_2.visible = true
	can_hit_2 = true
	Events.send_scripted_enemy.emit()
	


func _on_second_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_2:
		player.hit.play()
		label_2.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		#await get_tree().create_timer(0.2).timeout
		print("you are so cool")
		

func _on_fifth_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

	
func _on_third_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_3:
		player.hit.play()
		label_3.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		#await get_tree().create_timer(0.2).timeout
		print("you are so cool2")
	
	
func _on_npc_is_scared_of_the_player_text():
	Events.npc_is_scared_of_the_player2.emit()
	label_5.visible = true
	can_hit_5 = true
	
	label_2.visible = false
	can_hit_2 = false
	
	await get_tree().create_timer(5).timeout
	
	_on_enemies_start_spawning()
	
	
func _on_enemies_start_spawning():
	#label_2.visible = false
	#can_hit_2 = false
	label_5.visible = false
	can_hit_5 = false
	
func _on_possessed_spawned():
	label_3.visible = true
	can_hit_3 = true
	
func _on_possessed_defeated_first_time():
	label_3.visible = false
	can_hit_3 = false


func _on_start_counting_down():
	label_4.visible = true
	can_hit_4 = true

func _on_fourth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_3:
		player.hit.play()
		label_4.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		#await get_tree().create_timer(0.2).timeout
		print("you are so cool3")
