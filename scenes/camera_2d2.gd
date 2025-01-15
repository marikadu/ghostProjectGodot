extends Camera2D

@onready var player = get_tree().root.get_node("main/GhostPlayer")

# camera strength
#@export var follow_strength = 0.1
#@export var camera_offset = Vector2(-100000, -100000) 

func _process(delta):
	#print(player.position)
	#position += (get_global_mouse_position() * -delta) - position
	position += (player.position * delta) - position
	
	#position += (get_global_mouse_position()*delta * -1) - position
	#position += (player.position*delta * - 1) - position
	#position += (player.position*delta) - position
	#position = position.lerp(-1.0 * player.position, follow_strength)
	
	#var target_position = player.position + camera_offset
	#position = position.lerp(target_position * -0.02, follow_strength)
	

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
