extends Marker2D

var occupied = false  # Flag to check if the zone is occupied
var object_in_zone = null  # Store the object currently in the zone


# Function to mark the zone as occupied
# mark the zone as selected
func select():
	#if occupied:
		#return
	for child in get_tree().get_nodes_in_group("zone"):
		child.deselect()
	modulate = Color.WEB_MAROON
	print("Zone selected, ready to drop object.")

# Function to deselect the zone (reset visual state)
func deselect():
	modulate = Color.WHITE
	print("Zone deselected.")

# Function to handle the drop of the object into the zone
func _drop_object(dropped_object):
	if occupied:
		print("Cannot drop object here, the zone is occupied.")
		return
	else:
		object_in_zone = dropped_object
		occupied = true  # Mark the zone as occupied
		dropped_object.global_position = global_position  # Snap the object into the zone
		print("Object placed in the zone. NOT OCCUPIED")

# Handle when an object leaves the zone (if needed, can implement this for more advanced behavior)
func _remove_object():
	occupied = false
	object_in_zone = null
