extends CenterContainer



func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")
	print("FROM WIN: to the main menu")
#	get_tree().change_scene_to_file("MainMenu.tscn")
	pass # Replace with function body.
