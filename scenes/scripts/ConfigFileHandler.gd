extends Node


var config = ConfigFile.new()
const settings_file_path = "user://settings.ini"


func _ready():
	# if the file doesn't exist, create new file with default values
	if not FileAccess.file_exists(settings_file_path):
		config.set_value("keybinding", "left", "A")
		config.set_value("keybinding", "right", "D")
		config.set_value("keybinding", "up", "W")
		config.set_value("keybinding", "down", "S")
		config.set_value("keybinding", "dash", "Shift")
	
		config.set_value("video", "vsync", true)
		config.set_value("video", "parallax", true)
		config.set_value("video", "screen_shake", true)
		config.set_value("video", "flash", true)
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(settings_file_path)
		
	# if it exists, load settings
	else:
		config.load(settings_file_path)

	# load and apply settings
	apply_keybindings()
	apply_audio_settings()
	apply_video_settings()
	
# apply keybindings at game start


# ---- GRAPHICS SETTINGS ----

func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(settings_file_path)


func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings


func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(settings_file_path)


func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	

func is_vsync_enabled() -> bool:
	return config.get_value("video", "vsync", true) 

func is_parallax_enabled() -> bool:
	return config.get_value("video", "parallax", true) 
	
func is_shake_enabled() -> bool:
	return config.get_value("video", "screen_shake", true) 

func is_flash_enabled() -> bool:
	return config.get_value("video", "flash", true) 
	
	
# ------ SAVING KEYBINDINGS ------

func save_keybindings(action: StringName, event: InputEvent):
	var event_str # string of an event
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	
	config.set_value("keybinding", action, event_str)
	config.save(settings_file_path)
	
	
func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else: 
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
			
		keybindings[key] = input_event
	return keybindings
	
	
func apply_keybindings():
	var keybindings = load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
		
func apply_audio_settings():
	load_audio_settings()


func apply_video_settings():
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if is_vsync_enabled() else DisplayServer.VSYNC_DISABLED
	)
	Graphics.camera_follow_player = is_parallax_enabled()
	Graphics.camera_shake = is_shake_enabled()
	Graphics.flash_when_hit_effect = is_flash_enabled()
