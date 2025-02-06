extends Control


@onready var parallax_toggle: CheckButton = %ParallaxToggle
@onready var v_sync_toggle: CheckButton = %VSyncToggle
@onready var shake_toggle: CheckButton = %ShakeToggle
@onready var flash_toggle: CheckButton = %FlashToggle

@onready var input_button_scene = preload("res://scenes/input_button.tscn")
@onready var action_list = $ColorRect/TabContainer/Controls/TabBar/MarginContainer/ActionList

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
		
	_load_keybindings_from_settings()
	
	_create_action_list()
	
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
	

# --- CUSTOM KEYBINDINGS ---
func _load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
	
	
func _create_action_list():
	#InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free() #action list is empty
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("ActionInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0: # if the event exists
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
	if not is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("ActionInput").text = "Press key to bind"
		

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey or 
			(event is InputEventMouseButton and event.pressed)
		):
			# double click counts as single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			#InputMap.action_add_event(action_to_remap, event)
			
			# remove duplicate inputs
			for action in input_actions:
				if InputMap.action_has_event(action, event):
					InputMap.action_erase_event(action, event)
					var buttons_with_action = action_list.get_children().filter(func(button):
						return button.find_child("ActionLabel").text == input_actions[action]
					)
					for button in buttons_with_action:
						button.find_child("ActionInput").text = ""
				
			InputMap.action_add_event(action_to_remap, event)
			ConfigFileHandler.save_keybindings(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event() # stopping the initial event

func _update_action_list(button, event):
	button.find_child("ActionInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed() -> void:
	AudioManager.play_button_pressed()
	print("resetting keybindings")
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size()> 0:
			# overriding the settings with the defaults
			ConfigFileHandler.save_keybindings(action, events[0])
	
	# getting the actions from the project settings
	_create_action_list()
	
func _on_reset_button_mouse_entered() -> void:
	AudioManager.play_button_hover()

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
	print("back")
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")

func _on_back_mouse_entered() -> void:
	AudioManager.play_button_hover()

func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", %MasterSlider.value / 100)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", %SFXSlider.value / 100)
