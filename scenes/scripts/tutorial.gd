extends Control

@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var bg_4: NinePatchRect = $Label4/bg4
@onready var bg_4_2: NinePatchRect = $Label4_2/bg4_2
@onready var label_4_2: Label = $Label4_2
@onready var label_5: Label = $Label5
@onready var label_6: Label = $Label6
@onready var label_7: Label = $Label7

@onready var player = get_tree().root.get_node("main/GhostPlayer")

var can_hit_1
var can_hit_2
var can_hit_3
var can_hit_4
var can_hit_4_2
var can_hit_5
var can_hit_6

func _ready() -> void:
	can_hit_1 = false
	can_hit_2 = false
	can_hit_3 = false
	can_hit_4 = false
	can_hit_4_2 = false
	can_hit_5 = false
	can_hit_6 = false

	label_1.visible = false
	label_2.visible = false
	label_3.visible = false
	label_4.visible = false
	label_4_2.visible = false
	label_5.visible = false
	label_6.visible = false
	label_7.visible = false
	
	Events.tutorial_start.connect(_on_tutorial_start)
	Events.killed_scripted_enemy3.connect(_on_npc_is_scared_of_the_player_text)
	Events.introduce_fireflies.connect(_on_introduce_fireflies)
	Events.start_counting_down.connect(_on_start_counting_down)
	Events.win_game_tutorial.connect(_on_win_game)
	
	Events.game_over_woke_up_human.connect(_on_game_over)
	Events.game_over.connect(_on_game_over)


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
		first_get_hit()


func _on_tutorial_start():
	label_1.visible = true
	can_hit_1 = true
	AudioManager.play_orial_voice()


func first_get_hit():
	AudioManager.play_hit2()
	can_hit_1 = false
	label_1.scale = Vector2(1.5, 0.7)
	AudioManager.play_dash_hit()
	await get_tree().create_timer(0.4, false).timeout
	label_1.visible = false
	label_2.visible = true
	can_hit_2 = true
	AudioManager.play_orial_voice()
	Events.send_scripted_enemy.emit()


func _on_second_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_2:
		can_hit_2 = false
		AudioManager.play_hit2()
		label_2.scale = Vector2(1.5, 0.7)
		AudioManager.play_dash_hit()
		#print("you are so cool_2")
		await get_tree().create_timer(0.4, false).timeout
		can_hit_2 = true


func _on_third_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_3:
		can_hit_3 = false
		AudioManager.play_hit2()
		label_3.scale = Vector2(1.5, 0.7)
		AudioManager.play_dash_hit()
		print("you are so cool3")
		await get_tree().create_timer(0.4, false).timeout
		can_hit_3 = true


func _on_npc_is_scared_of_the_player_text():
	if not Global.is_game_over:
		Events.npc_is_scared_of_the_player2.emit()
		
		label_3.visible = true
		can_hit_3 = true
		AudioManager.play_orial_voice()
		
		label_2.visible = false
		can_hit_2 = false
		
		await get_tree().create_timer(5, false).timeout
		_on_enemies_start_spawning()
	
	
func _on_enemies_start_spawning():
	if not Global.is_game_over:
		await get_tree().create_timer(2, false).timeout
		label_3.visible = false
		can_hit_3 = false
	
	
func _on_introduce_fireflies():
	if not Global.is_game_over:
		await get_tree().create_timer(8, false).timeout
		label_4.visible = true
		can_hit_4 = true
		bg_4.visible = true
		AudioManager.play_orial_voice()
		await get_tree().create_timer(3, false).timeout
		bg_4.visible = false
	
		label_4.visible = false
		can_hit_4 = false
		
		bg_4_2.visible = true
		label_4_2.visible = true
		can_hit_4_2 = true
		AudioManager.play_orial_voice()


func _on_fourth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_4:
		can_hit_4 = false
		AudioManager.play_hit2()
		label_4.scale = Vector2(1.5, 0.7)
		AudioManager.play_dash_hit()
		print("you are so cool4")
		await get_tree().create_timer(0.4, false).timeout
		can_hit_4 = true


func _on_fourth_2_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_4_2:
		can_hit_4_2 = false
		AudioManager.play_hit2()
		label_4_2.scale = Vector2(1.5, 0.7)
		AudioManager.play_dash_hit()
		print("you are so cool4_2")
		await get_tree().create_timer(0.4, false).timeout
		can_hit_4_2 = true


func _on_fifth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_5:
		can_hit_5 = false
		AudioManager.play_hit2()
		label_5.scale = Vector2(1.5, 0.7)
		AudioManager.play_dash_hit()
		print("you are so cool5")
		await get_tree().create_timer(0.4, false).timeout
		can_hit_5 = true


func _on_sixth_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_6:
		can_hit_6 = false
		AudioManager.play_hit2()
		label_6.scale = Vector2(1.5, 0.7)
		AudioManager.play_dash_hit()
		print("you are so cool6")
		await get_tree().create_timer(0.4, false).timeout
		can_hit_6 = true
	
	
func _on_start_counting_down():
	if not Global.is_game_over:
		label_4.visible = false
		can_hit_4= false
		
		label_4_2.visible = false
		can_hit_4_2= false
		bg_4_2.visible = false
		
		label_5.visible = true
		can_hit_5 = true
		AudioManager.play_orial_voice()


func _on_win_game():
	if not Global.is_game_over:
		label_5.visible = false
		can_hit_5 = false
		
		label_6.visible = true
		can_hit_6 = true
		AudioManager.play_orial_voice()
		await get_tree().create_timer(6, false).timeout
		label_6.visible = false
		can_hit_6 = false
	

func _on_game_over():
	label_1.visible = false
	can_hit_1 = false
	
	label_2.visible = false
	can_hit_2 = false
	
	label_3.visible = false
	can_hit_3 = false
	
	label_4.visible = false
	can_hit_4 = false
	
	label_4_2.visible = false
	can_hit_4_2 = false
	
	label_5.visible = false
	can_hit_5 = false
	
	label_1.visible = false
	can_hit_1 = false
	
	label_7.visible = true
