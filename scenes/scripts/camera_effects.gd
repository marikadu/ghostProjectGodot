extends Control

@export var def_randomStrength: float = 20.0
@export var def_shakeFade: float = 2.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_fade: float = 0.0

@onready var camera: Camera2D = %Camera2D
#@onready var camera: Camera2D = $main/Camera2D
#@onready var camera: Camera2D = %Camera2D
#@onready var camera = get_tree().root.get_node("Camera2D")

	
#func apply_shake():
	#shake_strength = randomStrength
	
func apply_shake(custom_strength: float = -1.0, custom_fade: float = -1.0):
	# Use custom strength if provided, otherwise fall back to default
	shake_strength = custom_strength if custom_strength >= 0 else def_randomStrength
	shake_fade = custom_fade if custom_fade >= 0 else def_shakeFade
	#
	
	
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
	if camera:
		camera.offset = randomOffset()
	else:
		print("Camera is not assigned or not found!")
	#camera.offset = randomOffset()
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))
	
