extends Control


@onready var parallax_toggle: CheckButton = %ParallaxToggle
@onready var v_sync_toggle: CheckButton = %VSyncToggle
@onready var shake_toggle: CheckButton = %ShakeToggle
@onready var flash_toggle: CheckButton = %FlashToggle



func _ready() -> void:
	
	# by default it is turned on and the toggle button is ON
	if Graphics.vsync_enabled:
		v_sync_toggle.button_pressed = true
		
	if Graphics.camera_follow_player:
		parallax_toggle.button_pressed = true
		
	if Graphics.camera_shake:
		shake_toggle.button_pressed = true
		
	if Graphics.flash_when_hit_effect:
		flash_toggle.button_pressed = true
		

func _on_back_pressed() -> void:
	print("back")
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")


# camera follows player parralax effext
func _on_parallax_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Graphics.camera_follow_player = true
		print("camera follow player = true")
	else:
		Graphics.camera_follow_player = false
		print("camera follow player = false")


# vsync
func _on_v_sync_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Graphics.vsync_enabled = true
		print("menu: vsync true")
	else:
		Graphics.vsync_enabled = false
		print("menu: vsync false")


# camera shake
func _on_shake_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Graphics.camera_shake = true
		print("camera shake = true")
	else:
		Graphics.camera_shake = false
		print("camera shake = false")


# flash when hit effect
func _on_flash_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Graphics.flash_when_hit_effect = true
		print("flash hit = true")
	else:
		Graphics.flash_when_hit_effect = false
		print("flash hit = false")
		
