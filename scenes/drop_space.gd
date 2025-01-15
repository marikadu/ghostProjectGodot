extends TextureRect

var dropped_data = null  # Store the data when an object is dropped

var rect_size = 40
var rect_position = 30

# Called when the mouse enters the drop area
func _on_panel_mouse_entered():
	print("Mouse entered the drop space")
	# When the mouse enters, snap the object to fit the TextureRect size
	if dropped_data:
		# Resize the dropped object to the size of the TextureRect (drop space)
		dropped_data.rect_min_size = rect_size  # This will adjust the size of the dropped data to match the drop area size
		dropped_data.position = rect_position  # Optionally center the object in the drop space

# Called when the mouse exits the drop area
func _on_panel_mouse_exited():
	print("Mouse left the drop space")
	# Optionally, restore the object's size if needed or handle when the object leaves
	if dropped_data:
		# Optionally reset the object size or position if needed
		pass

# This function will be called when an object is about to drop onto this area
func _can_drop_data(_pos, data):
	# Check if the data can be dropped onto this area
	return data is Texture2D  # Or any other type of object you are using for the dragged object

# This function will handle what happens when the data is dropped
func _drop_data(_pos, data):
	if data is Texture2D:
		# Snap the object into position (e.g., center of the drop space)
		texture = data  # Example: Replace the texture of the drop area with the dropped object's texture
		dropped_data = data  # Store the dropped object's data
		print("Data dropped: ", dropped_data)
