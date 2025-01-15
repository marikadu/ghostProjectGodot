extends Marker2D

# Called when the delete zone is ready
func _ready():
	# Add the delete zone to a specific group for easy identification
	add_to_group("delete_zone")

# Called every frame to check if the object is within the delete zone
func _process(delta):
	# Check if mouse button is released before deleting
	if Input.is_action_just_released("click"):
		# Get all the instances of the blue_flower_2 objects (or similar objects)
		var objects_to_check = get_tree().get_nodes_in_group("flowers_on_table")  # Group name for dragged objects
		for object in objects_to_check:
			# Check if the object is within the delete zone
			if is_object_inside_delete_zone(object):
				object.queue_free()  # Destroy the object when it is inside the delete zone
				print("Object deleted!")

# Helper function to check if an object is inside the delete zone
func is_object_inside_delete_zone(object):
	# Get the delete zone's bounding box
	var delete_zone_rect = Rect2(global_position - Vector2(50, 50), Vector2(100, 100))  # Adjust size as needed
	# Check if the object's position is within the delete zone's bounds
	return delete_zone_rect.has_point(object.global_position)
