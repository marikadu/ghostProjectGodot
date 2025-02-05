extends Control


@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var settings: Button = $MarginContainer/VBoxContainer/Settings
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var p_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Play/p_splash
@onready var o_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Settings/o_splash
@onready var e_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Exit/e_splash
@onready var camera_2d: Camera2D = %Camera2D

@onready var hit: AudioStreamPlayer2D = $hit

var player: CharacterBody2D

var can_hit_play: bool
var can_hit_settings: bool
var can_hit_exit: bool




func _ready() -> void:
	can_hit_play = true
	can_hit_settings = true
	can_hit_exit = true

	Global.current_scene_name = 0
	print(Global.current_scene_name)
	player = get_tree().root.get_node("MainMenu/GhostPlayer")
	
func _physics_process(delta: float) -> void:
	play.scale.x = move_toward(play.scale.x, 1, 2.3 * delta)
	play.scale.y = move_toward(play.scale.y, 1, 2.3 * delta)
	
	settings.scale.x = move_toward(settings.scale.x, 1, 2 * delta)
	settings.scale.y = move_toward(settings.scale.y, 1, 2 * delta)
	
	exit.scale.x = move_toward(exit.scale.x, 1, 2 * delta)
	exit.scale.y = move_toward(exit.scale.y, 1, 2 * delta)


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
func _on_p_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_play:
		play_get_hit()
		#camera_control.apply_shake(4, 5)
		

func play_get_hit():
	can_hit_play = false
	p_splash.emitting = true
	player.hit.play()
	player.restore_stamina()
	play.scale = Vector2(1.4, 0.7)
	player.dash_hit.play()
	# cooldown timer to restrict the player from hitting it multiple times at once
	await get_tree().create_timer(0.8).timeout
	can_hit_play = true


# --- OPTIONS ---
func _on_o_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_settings:
		options_get_hit()
		

func options_get_hit():
	can_hit_settings = false
	o_splash.emitting = true
	player.hit.play()
	player.restore_stamina()
	settings.scale = Vector2(1.4, 0.7)
	player.dash_hit.play()
	await get_tree().create_timer(0.8).timeout
	can_hit_settings = true

# --- EXIT ---
func _on_e_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_settings:
		exit_get_hit()
		

func exit_get_hit():
	can_hit_exit = false
	e_splash.emitting = true
	player.hit.play()
	player.restore_stamina()
	exit.scale = Vector2(1.4, 0.7)
	player.dash_hit.play()
	await get_tree().create_timer(0.8).timeout
	can_hit_exit = true


# --- BUTTON SOUNDS ---
func _on_play_mouse_entered() -> void:
	$button_hover.play()

func _on_options_mouse_entered() -> void:
	$button_hover.play()

func _on_exit_mouse_entered() -> void:
	$button_hover.play()
