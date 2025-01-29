extends CenterContainer


func _ready() -> void:
	print(Global.current_scene_name)

func _on_level_selection_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_level_selection.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")
	print("FROM WIN: to the main menu")


func _on_next_level_pressed() -> void:
	change_level()
	
func change_level():
	get_tree().change_scene_to_file("res://scenes/level"+str(Global.current_scene_name+1)+".tscn")
	# on the last level don't show the "Next Level" button
	pass
