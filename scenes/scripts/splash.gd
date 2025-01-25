extends Node2D

@onready var splash_vfx: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	splash()

func splash():
	splash_vfx.emitting=true
