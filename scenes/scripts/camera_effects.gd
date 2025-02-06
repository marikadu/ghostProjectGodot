extends Control

@export var def_randomStrength: float = 20.0
@export var def_shakeFade: float = 2.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_fade: float = 0.0
var camZoom = Vector2.ZERO
var zoom_camera: bool
#var zoom = Vector2(1.0, 1.0)
var zoom = Vector2(0.9, 0.9)
#var zoom_speed = 0.3
var zoom_speed = 1

var vsync_enabled = ConfigFileHandler.is_vsync_enabled()
var parallax_enabled = ConfigFileHandler.is_parallax_enabled()
var shake_enabled = ConfigFileHandler.is_shake_enabled()
var flash_enabled = ConfigFileHandler.is_flash_enabled()

@onready var camera: Camera2D = %Camera2D


func _process(delta):
	# smooth zoom
	camera.zoom.x = lerp(camera.zoom.x, zoom.x, zoom_speed * delta)
	camera.zoom.y = lerp(camera.zoom.y, zoom.y, zoom_speed * delta)
	
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
	if camera:
		camera.offset = randomOffset()
	else:
		print("camera not found")
		
	#camera.offset = randomOffset()
	
	
#	if vsync_enabled:
#		print("VSync is ON")
#	else:
#		print("VSync is OFF")
	
	
func apply_shake(custom_strength: float = -1.0, custom_fade: float = -1.0):
	if shake_enabled:
		print("should shake")
	# if no custom strength given -> use default
		shake_strength = custom_strength if custom_strength >= 0 else def_randomStrength
		shake_fade = custom_fade if custom_fade >= 0 else def_shakeFade
	else:
		print("shake not enabled")
		pass

func zoom_in():
	#camera.zoom.x = lerp(1.0, 1.2, zoom_time)
	#camera.zoom.y = lerp(1.0, 1.2, zoom_time)
	zoom = Vector2(1.01, 1.01)
	
func zoom_out():
	zoom = Vector2(0.9, 0.9)
	
	
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))
	
