extends Area2D

@export var fade_time = 1.0  # Time for fade effect
@export var detect_distance = 200.0  # Distance threshold for visibility

var player: Node2D
var tween: Tween

func _ready():
	player = get_tree().get_first_node_in_group("player")  # Make sure player is in a "player" group
	material.set_shader_parameter("fade_amount", 1.0)  # Initially invisible

func _process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)

		if distance < detect_distance:
			fade_shader(0.0)  # Appear
		else:
			fade_shader(1.0)  # Disappear

func fade_shader(target_value: float):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, material.get_shader_parameter("fade_amount"), target_value, fade_time)

func set_shader_value(value: float):
	material.set_shader_parameter("fade_amount", value)

func _on_body_entered(body):
	if body.is_in_group("player"):
		fade_out_and_destroy()

func fade_out_and_destroy():
	fade_shader(1.0)  # Fade out
	await get_tree().create_timer(fade_time).timeout
	queue_free()  # Remove object
