extends CenterContainer


func _ready() -> void:
	print(Global.current_scene_name)

func _on_level_selection_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_selection.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
	print("FROM WIN: to the main menu")


func _on_next_level_pressed() -> void:
	change_level()
	

func change_level():
	get_tree().change_scene_to_file("res://scenes/levels/level"+str(Global.current_scene_name+1)+".tscn")
	# on the last level don't show the "Next Level" button
	pass


func _on_replay_pressed() -> void:
	Global.is_game_over = false
	# loading the same level
	#get_tree().change_scene_to_file("res://scenes/levels/level"+str(Global.current_scene_name)+".tscn")
	# turns out there's a simpler solution to this, good to know
	get_tree().reload_current_scene()
