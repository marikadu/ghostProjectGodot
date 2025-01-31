extends Control

@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_4_2: Label = $Label4_2
@onready var label_5: Label = $Label5
@onready var label_6: Label = $Label6

@onready var hit: AudioStreamPlayer2D = $hit
#@onready var player = preload("res://player/ghost_player.tscn")
#var player: CharacterBody2D
@onready var player = get_tree().root.get_node("main/GhostPlayer")

var can_hit_1
var can_hit_2
var can_hit_3
var can_hit_4
var can_hit_4_2
var can_hit_5
var can_hit_6

func _ready() -> void:
	can_hit_1 = true
	can_hit_2 = false
	can_hit_3 = false
	can_hit_4 = false
	can_hit_4_2 = false
	can_hit_5 = false
	can_hit_6 = false

	label_1.visible = true
	label_2.visible = false
	label_3.visible = false
	label_4.visible = false
	label_4_2.visible = false
	label_5.visible = false
	label_6.visible = false
	
	
	Events.killed_scripted_enemy3.connect(_on_npc_is_scared_of_the_player_text)
	Events.introduce_fireflies.connect(_on_introduce_fireflies)
	Events.start_counting_down.connect(_on_start_counting_down)
	Events.win_game_tutorial.connect(_on_win_game)


func _physics_process(delta: float) -> void:
	label_1.scale.x = move_toward(label_1.scale.x, 1, 3 * delta)
	label_1.scale.y = move_toward(label_1.scale.y, 1, 3 * delta)
	
	label_2.scale.x = move_toward(label_2.scale.x, 1, 3 * delta)
	label_2.scale.y = move_toward(label_2.scale.y, 1, 3 * delta)
	
	label_3.scale.x = move_toward(label_3.scale.x, 1, 3 * delta)
	label_3.scale.y = move_toward(label_3.scale.y, 1, 3 * delta)
	
	label_4.scale.x = move_toward(label_4.scale.x, 1, 3 * delta)
	label_4.scale.y = move_toward(label_4.scale.y, 1, 3 * delta)
	
	label_4_2.scale.x = move_toward(label_4_2.scale.x, 1, 3 * delta)
	label_4_2.scale.y = move_toward(label_4_2.scale.y, 1, 3 * delta)
	
	label_5.scale.x = move_toward(label_5.scale.x, 1, 3 * delta)
	label_5.scale.y = move_toward(label_5.scale.y, 1, 3 * delta)
	
	label_6.scale.x = move_toward(label_6.scale.x, 1, 3 * delta)
	label_6.scale.y = move_toward(label_6.scale.y, 1, 3 * delta)

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
		print("you are so cool_2")
		
	
func _on_npc_is_scared_of_the_player_text():
	Events.npc_is_scared_of_the_player2.emit()
	label_3.visible = true
	can_hit_3 = true
	
	label_2.visible = false
	can_hit_2 = false
	
	await get_tree().create_timer(5).timeout
	_on_enemies_start_spawning()
	
	
func _on_enemies_start_spawning():
	#label_2.visible = false
	#can_hit_2 = false
	label_3.visible = false
	can_hit_3 = false
	
	
func _on_introduce_fireflies():
	await get_tree().create_timer(8).timeout
	label_4.visible = true
	can_hit_4 = true
	await get_tree().create_timer(3).timeout
	label_4_2.visible = true
	can_hit_4_2 = true
	

func _on_third_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_3:
		player.hit.play()
		label_3.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		print("you are so cool3")
		

func _on_fourth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_4:
		player.hit.play()
		label_4.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		print("you are so cool4")


func _on_fourth_2_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_4_2:
		player.hit.play()
		label_4_2.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		print("you are so cool4_2")



func _on_fifth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_5:
		player.hit.play()
		label_5.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		print("you are so cool5")


func _on_sixth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_6:
		player.hit.play()
		label_6.scale = Vector2(1.5, 0.7)
		player.dash_hit.play()
		print("you are so cool6")
	
	
func _on_start_counting_down():
	label_4.visible = false
	can_hit_4= false
	
	label_4_2.visible = false
	can_hit_4_2= false
	
	label_5.visible = true
	can_hit_5 = true


func _on_win_game():
	label_5.visible = false
	can_hit_5 = false
	
	label_6.visible = true
	can_hit_6 = true
