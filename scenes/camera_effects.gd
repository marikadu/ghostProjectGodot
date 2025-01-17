extends Control

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

@onready var camera: Camera2D = %Camera2D

func _ready() -> void:
	pass
	
func apply_shake():
	shake_strength = randomStrength
	#
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
	camera.offset = camera.offset - randomOffset()
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))
