extends Control


@onready var parallax_toggle: CheckButton = %ParallaxToggle
@onready var v_sync_toggle: CheckButton = %VSyncToggle
@onready var shake_toggle: CheckButton = %ShakeToggle
@onready var flash_toggle: CheckButton = %FlashToggle

@onready var input_button_scene = preload("res://scenes/input_button.tscn")
#@onready var action_list = $ColorRect/TabContainer/Controls/TabBar/MarginContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"left": "Move Left",
	"right": "Move Right",
	"up": "Move Up",
	"down": "Move Down",
	"dash": "Dash",
}


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
		
		

	
	var video_settings = ConfigFileHandler.load_video_settings()
	v_sync_toggle.button_pressed = video_settings.vsync
	parallax_toggle.button_pressed = video_settings.parallax
	shake_toggle.button_pressed = video_settings.screen_shake
	flash_toggle.button_pressed = video_settings.flash
	# and the same for the flash
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	# saving audio as 0 to 100, instead of 0 to 1
	%MasterSlider.value = min(audio_settings.master_volume, 1.0) * 100
	%SFXSlider.value = min(audio_settings.sfx_volume, 1.0) * 100
	%MSlider.value = min(audio_settings.music_volume, 1.0) * 100

# ------------------------


# --- GRAPHICS ---
# camera follows player parralax effext
func _on_parallax_toggle_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_settings("parallax", toggled_on)
	Graphics.camera_follow_player = toggled_on


# vsync
func _on_v_sync_toggle_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_settings("vsync", toggled_on)
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


# camera shake
func _on_shake_toggle_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_settings("screen_shake", toggled_on)
	Graphics.camera_shake = toggled_on


# flash when hit effect
func _on_flash_toggle_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_settings("flash", toggled_on)
	Graphics.flash_when_hit_effect = toggled_on

# -----------


func _on_back_pressed() -> void:
	AudioManager.play_button_pressed()
	#get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
	if Global.current_scene_name != 0:
		self.hide()
	else:
		get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")

func _on_back_mouse_entered() -> void:
	AudioManager.play_button_hover()

func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", %MasterSlider.value / 100)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", %SFXSlider.value / 100)


func _on_m_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume", %MSlider.value / 100)
