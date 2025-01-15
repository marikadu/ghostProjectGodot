extends Control

@onready var player = get_tree().root.get_node("main/GhostPlayer")

# Strength of the camera's follow, higher value means more follow.
@export var follow_strength = 0.5  # Adjust this value to control how much the camera follows the player

func _process(delta):
	print(player.position)
	#position += (get_global_mouse_position()*delta * -1) - position
	#position += (player.position*delta * - 1) - position
	#position += (player.position*delta) - position
	#position = position.lerp(-1.0 * player.position, follow_strength)
	position = position.lerp(player.position * -1, follow_strength) / 5
	

#@export var max_offset: Vector2
#@export var smoothing: float = 2.0
#
#@onready var parallax = $Parallax
#
#func _process(delta):
	#var center: Vector2 = get_viewport_rect().size /2.0
	#var dist: Vector2 = get_global_mouse_position() - center
	#var offset: Vector2 = dist / center
	#
	#var new_pos: Vector2
	#
	#new_pos.x = lerp(max_offset.x, -max_offset.x, offset.x)
	#new_pos.y = lerp(max_offset.y, -max_offset.y, offset.y)
#
	#parallax.position.x = lerp(parallax.position.x, new_pos.x, smoothing * delta)
	#parallax.position.y = lerp(parallax.position.y, new_pos.y, smoothing * delta)
