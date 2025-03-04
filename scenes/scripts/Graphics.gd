extends Node

var camera_follow_player: bool
var vsync_enabled: bool
var camera_shake: bool
var flash_when_hit_effect: bool

func _ready() -> void:
	
	# default settings
	camera_follow_player = true
	
	vsync_enabled = false
	if vsync_enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		#print("vsync on")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#print("vsync off")
		
	camera_shake = ConfigFileHandler.is_shake_enabled()
	#print ("camera shake is set to: ", camera_shake)
	
	flash_when_hit_effect = true
