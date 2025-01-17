extends Control


func _on_back_pressed() -> void:
	print("back")
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")
	pass # Replace with function body.
