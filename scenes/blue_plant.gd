extends Sprite2D

var dragging = false
var drag_offset = Vector2.ZERO  # Offset between the mouse position and the object's position when clicked
# The drop area the object is being dragged over
var drop_area = null

func _process(_delta: float) -> void:
	if dragging:
		# Update the position of the object to follow the mouse, keeping the offset
		position = get_global_mouse_position() - drag_offset

func _on_button_button_down() -> void:
	# Start dragging and calculate the drag_offset
	dragging = true
	drag_offset = get_global_mouse_position() - position # Offset from the initial click position

func _on_button_button_up() -> void:
	# Stop dragging
	dragging = false
	print("Dropped blue flower at:", position)
	
	if drop_area and drop_area._can_drop_data(get_global_mouse_position(), self):
		print("in the area")
		drop_area._drop_data(get_global_mouse_position(), texture)
		queue_free()  # Optionally remove the dragged object after drop
