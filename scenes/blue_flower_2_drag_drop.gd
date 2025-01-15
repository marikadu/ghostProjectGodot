extends Node2D

var selected = false  # Tracks whether the object is being dragged
var rest_point  # The original position of the object when not selected
var rest_nodes = []  # Zones where the object can be dropped
var dragging = false  # Whether the object is currently being dragged
var previous_zone = null  # To track the previous zone

# Called when the object is first added to the scene
func _ready():
	# Get all the zones that can accept drops
	rest_nodes = get_tree().get_nodes_in_group("zone")
	# Set the default resting position to the first zone (if exists)
	#if rest_nodes.size() > 0:
	rest_point = rest_nodes[0].global_position
		# Optionally, you can set the first zone as visually selected (change its color, etc.)
	rest_nodes[0].modulate = Color(0.5, 0.5, 1)  # Example: Change color to indicate it's selected
	# Add this object to the group for detection by the delete_zone
	rest_nodes[0].select()
	add_to_group("flowers_on_table")

# Handle mouse events (start dragging when mouse clicks on the object)
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		selected = true  # Start dragging

# Update the object's position during the drag (while selected)
func _physics_process(delta: float) -> void:
	if selected:
		# Lerp (smooth movement) the object to follow the mouse
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		# If not selected, return the object to its resting point (the drop zone)
		global_position = lerp(global_position, rest_point, 10 * delta)

# Handle the release of the object (when mouse is released)
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
			selected = false  # Stop dragging
			var shortest_dist = 75  # Distance threshold to check for a drop area
			var closest_zone = null  # To store the closest zone
			var closest_distance = 9999  # Arbitrarily large distance to initialize

			# Find the closest zone by distance
			for child in rest_nodes:
				# Skip delete zones (zones in the "delete_zone" group)
				if child.is_in_group("delete_zone"):
					continue

				var distance = global_position.distance_to(child.global_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_zone = child

			# If the object is close enough to a zone and the zone is not occupied
			if closest_zone and closest_distance <= shortest_dist:
				if !closest_zone.occupied:
					# Before placing into a new zone, reset the previous zone's occupied status
					if previous_zone:
						previous_zone.occupied = false
					# Drop the object into the zone and mark the zone as occupied
					closest_zone._drop_object(self)
					rest_point = closest_zone.global_position  # Update resting position to the zone
					previous_zone = closest_zone  # Update the previous zone
				else:
					print("Zone is already occupied!")
			else:
				print("Object was not close enough to a valid zone.")
