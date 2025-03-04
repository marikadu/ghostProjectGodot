extends Control


@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var settings: Button = $MarginContainer/VBoxContainer/Settings
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var p_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Play/p_splash
@onready var o_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Settings/o_splash
@onready var e_splash: CPUParticles2D = $MarginContainer/VBoxContainer/Exit/e_splash
@onready var camera_2d: Camera2D = %Camera2D
@onready var exit_confirmation: ColorRect = %ExitConfirmation


var player: CharacterBody2D

var can_hit_play: bool
var can_hit_settings: bool
var can_hit_exit: bool

var can_hit_other_buttons: bool # preventing the other buttons to be hit if multiple buttons are hit



func _ready() -> void:
	
	if get_tree().paused == true:
		get_tree().paused = false # unpause the game if quit during pause
	can_hit_play = true
	can_hit_settings = true
	can_hit_exit = true
	can_hit_other_buttons = true

	Global.current_scene_name = 0
	print(Global.current_scene_name)
	player = get_tree().root.get_node("MainMenu/GhostPlayer")
	player.position = get_viewport_rect().size / 2
	
	AudioManager.stop_game_theme()
	
	#AudioManager.play_game_theme()
	AudioManager.play_main_menu()
	if Global.is_main_menu_music_playing == false:
		Global.is_main_menu_music_playing = true
		#print(Global.is_main_menu_music_playing)
		
	#AudioManager.play_main_menu()
	# prevents the "gameover" or "win" from playing again
	#AudioManager.OST["parameters/switch_to_clip"] = "MainMenu" 
	# edit: no need for that!
	
func _physics_process(delta: float) -> void:
	play.scale.x = move_toward(play.scale.x, 1, 2.3 * delta)
	play.scale.y = move_toward(play.scale.y, 1, 2.3 * delta)
	
	settings.scale.x = move_toward(settings.scale.x, 1, 2 * delta)
	settings.scale.y = move_toward(settings.scale.y, 1, 2 * delta)
	
	exit.scale.x = move_toward(exit.scale.x, 1, 2 * delta)
	exit.scale.y = move_toward(exit.scale.y, 1, 2 * delta)


func _on_play_pressed() -> void:
	AudioManager.play_button_pressed()
	get_tree().change_scene_to_file("res://scenes/menus/level_selection.tscn")


func _on_options_pressed() -> void:
	AudioManager.play_button_pressed()
	get_tree().change_scene_to_file("res://scenes/menus/options.tscn")


func _on_exit_pressed() -> void:
	# "are you sure you want to exit window"
	#%ExitConfirmation.show()
	exit_confirmation.show_window()


# --- PLAY ---
func _on_p_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_play:
		play_get_hit()
		#camera_control.apply_shake(4, 5)
		

func play_get_hit():
	if not can_hit_other_buttons:
		return
	else:
		can_hit_play = false
		can_hit_other_buttons = false
		p_splash.emitting = true
		AudioManager.play_hit2()
		AudioManager.play_dash_hit()
		player.restore_stamina()
		AudioManager.play_stamina_restored()
		play.scale = Vector2(1.4, 0.7)
		await get_tree().create_timer(0.2).timeout # cooldown timer to restrict the player from hitting it multiple times at once
		can_hit_play = true
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/menus/level_selection.tscn")
	


# --- OPTIONS ---
func _on_o_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_settings:
		options_get_hit()
		

func options_get_hit():
	if not can_hit_other_buttons:
		return
	else:
		can_hit_settings = false
		can_hit_other_buttons = false
		o_splash.emitting = true
		AudioManager.play_hit2()
		AudioManager.play_dash_hit()
		AudioManager.play_stamina_restored()
		player.restore_stamina()
		settings.scale = Vector2(1.4, 0.7)
		await get_tree().create_timer(0.2).timeout
		can_hit_settings = true
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/menus/options.tscn")
		#await get_tree().create_timer(0.8).timeout
	

# --- EXIT ---
func _on_e_area_body_entered(body: Node2D) -> void:
	if body == player and player.dashing and can_hit_settings:
		exit_get_hit()
		

func exit_get_hit():
	if not can_hit_other_buttons:
		return
	else:
		can_hit_exit = false
		can_hit_other_buttons = false
		e_splash.emitting = true
		AudioManager.play_hit2()
		AudioManager.play_dash_hit()
		AudioManager.play_stamina_restored()
		player.restore_stamina()
		exit.scale = Vector2(1.4, 0.7)
		await get_tree().create_timer(0.1).timeout
		can_hit_exit = true
		
		exit_confirmation.show_window()
		await get_tree().create_timer(0.3, false).timeout # can hit other buttons
		# GOOD TO KNOW: false ^ means that it stops when the game is paused!
		can_hit_other_buttons = true


# --- BUTTON SOUNDS ---
func _on_play_mouse_entered() -> void:
	AudioManager.play_button_hover()

func _on_options_mouse_entered() -> void:
	AudioManager.play_button_hover()

func _on_exit_mouse_entered() -> void:
	AudioManager.play_button_hover()
