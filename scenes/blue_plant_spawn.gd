extends Sprite2D

var object_to_spawn = preload("res://scenes/blue_flower_2.tscn")
var spawned_object = null  # Reference to the currently dragged object
var dragging = false  # Tracks if an object is being dragged
var drop_area = null  # Reference to the zone the object is being dragged over

func _on_b_spawn_button_button_down() -> void:
	print("Spawning blue flower")
	if object_to_spawn:
		# Instance the new object
		spawned_object = object_to_spawn.instantiate()

		# Set its initial position at the cursor
		spawned_object.position = get_global_mouse_position()

		# Add it to the scene
		get_tree().current_scene.add_child(spawned_object)

		# Start dragging the new object
		dragging = true
	else:
		print("No object_to_spawn assigned!")

func _process(delta: float) -> void:
	# If dragging, update the position of the currently dragged object
	if dragging and spawned_object:
		# Use the global mouse position to move the object
		spawned_object.position = get_global_mouse_position()

func _on_b_spawn_button_button_up() -> void:
	# Stop dragging when the mouse button is released
	if dragging and spawned_object:
		dragging = false
		print("Dropped blue flower at:", spawned_object.position)

		# Check if the object is over a valid drop area
		var shortest_dist = 75  # A threshold for how close the object must be to a zone
		var closest_zone = null
		var closest_distance = 9999  # Arbitrarily large distance

		for zone in get_tree().get_nodes_in_group("zone"):
			var distance = spawned_object.global_position.distance_to(zone.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_zone = zone
		
		if closest_zone and closest_distance <= shortest_dist:
			closest_zone._drop_object(spawned_object)
			spawned_object = null  # Clear the reference to the dragged object
		else:
			print("Cannot drop object here, zone is already occupied.")

		# Optionally, reset the spawn object after checking
		spawned_object = null
