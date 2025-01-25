extends Control


func _on_play_pressed() -> void:
	print("play")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass # Replace with function body.


func _on_options_pressed() -> void:
	print("options")
	get_tree().change_scene_to_file("res://scenes/menu_options.tscn")
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	print("quit")
	get_tree().quit()
	pass # Replace with function body.
