extends Control



@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var options: Button = $MarginContainer/VBoxContainer/Options
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var splash: CPUParticles2D = $splash
@onready var hit: AudioStreamPlayer2D = $hit
#@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_flash: AnimationPlayer = $MarginContainer/VBoxContainer/Play/HitFlash


#@onready var camera_control = get_tree().root.get_node("MainMenu/CameraControl")


var player: CharacterBody2D


func _ready() -> void:
	player = get_tree().root.get_node("MainMenu/GhostPlayer")


func _on_play_pressed() -> void:
	print("play")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass # Replace with function body.


func _on_options_pressed() -> void:
	print("options")
	get_tree().change_scene_to_file("res://scenes/menu_options.tscn")
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	print("quit")
	get_tree().quit()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.
	if body == player:
		get_hit()
		
	if body == player and player.dashing:
		get_hit()
		player.restore_stamina()
		hit.play()
		#camera_control.apply_shake(4, 5)
		
		
func get_hit():
	player.ghost_dies.play()
	splash.emitting = true
	player.hit.play()
	hit_flash.play("hit_flash")
	#Global.score += 10
	#await get_tree().create_timer(wait_death_animation).timeout
	#queue_free()  # remove the enemy from the scene
	if player.dashing:
		player.dash_hit.play()
