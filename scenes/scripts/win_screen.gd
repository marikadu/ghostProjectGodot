extends CenterContainer



func _on_level_selection_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_level_selection.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")
	print("FROM WIN: to the main menu")
