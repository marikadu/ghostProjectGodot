extends Node


var config = ConfigFile.new()
const settings_file_path = "user://settings.ini"


func _ready():
	# if the file doesn't exist, create new file with default values
	if not FileAccess.file_exists(settings_file_path):
		#config.set_value("keybinding", "left", "A")
		#config.set_value("keybinding", "right", "D")
		#config.set_value("keybinding", "up", "W")
		#config.set_value("keybinding", "down", "S")
		#config.set_value("keybinding", "dash", "Shift")
	
		config.set_value("video", "vsync", true)
		config.set_value("video", "parallax", true)
		config.set_value("video", "screen_shake", true)
		config.set_value("video", "flash", true)
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		
		config.save(settings_file_path)
		
	# if it exists, load settings
	else:
		config.load(settings_file_path)

	# load and apply settings
	apply_audio_settings()
	apply_video_settings()

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


func apply_audio_settings():
	load_audio_settings()


func apply_video_settings():
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if is_vsync_enabled() else DisplayServer.VSYNC_DISABLED
	)
	Graphics.camera_follow_player = is_parallax_enabled()
	Graphics.camera_shake = is_shake_enabled()
	Graphics.flash_when_hit_effect = is_flash_enabled()
