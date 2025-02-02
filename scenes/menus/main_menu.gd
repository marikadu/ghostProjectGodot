extends Control


@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var settings: Button = $MarginContainer/VBoxContainer/Settings
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var p_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Play/p_splash
@onready var o_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Settings/o_splash

@onready var hit: AudioStreamPlayer2D = $hit


var player: CharacterBody2D


func _ready() -> void:
	Global.current_scene_name = 0
	print(Global.current_scene_name)
	player = get_tree().root.get_node("MainMenu/GhostPlayer")
	
func _physics_process(delta: float) -> void:
	play.scale.x = move_toward(play.scale.x, 1, 3 * delta)
	play.scale.y = move_toward(play.scale.y, 1, 3 * delta)
	
	settings.scale.x = move_toward(settings.scale.x, 1, 3 * delta)
	settings.scale.y = move_toward(settings.scale.y, 1, 3 * delta)


func _on_play_pressed() -> void:
	print("play")
	get_tree().change_scene_to_file("res://scenes/menus/level_selection.tscn")


func _on_options_pressed() -> void:
	print("options")
	get_tree().change_scene_to_file("res://scenes/menus/options.tscn")


func _on_exit_pressed() -> void:
	print("quit")
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()


# --- PLAY ---
func _on_b_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing:
		play_get_hit()
		#camera_control.apply_shake(4, 5)
		

func play_get_hit():
	#player.ghost_dies.play()
	p_splash.emitting = true
	player.hit.play()
	player.restore_stamina()
	#hit_flash.play("hit_flash")
	play.scale = Vector2(1.4, 0.7)
	if player.dashing:
		player.dash_hit.play()


# --- OPTIONS ---
func _on_o_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing:
		options_get_hit()
		

func options_get_hit():
	#player.ghost_dies.play()
	o_splash.emitting = true
	player.hit.play()
	player.restore_stamina()
	#hit_flash.play("hit_flash")
	settings.scale = Vector2(1.4, 0.7)
	if player.dashing:
		player.dash_hit.play()


func _on_play_mouse_entered() -> void:
	$button_hover.play()

func _on_options_mouse_entered() -> void:
	$button_hover.play()

func _on_exit_mouse_entered() -> void:
	$button_hover.play()
