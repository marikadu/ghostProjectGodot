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
		
		
	_create_action_list()
	
func _create_action_list():
	InputMap.load_from_project_settings()
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
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event() # stopping the initial event

func _update_action_list(button, event):
	button.find_child("ActionInput").text = event.as_text().trim_suffix(" (Physical)")
	





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
		


func _on_reset_button_pressed() -> void:
	# reset button has focus "none"
	# getting the actions from the project settings
	_create_action_list()
	pass # Replace with function body.
