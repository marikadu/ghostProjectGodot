extends CenterContainer



func _on_try_again_pressed() -> void:
	Global.is_game_over = false
	# loading the same level
	get_tree().change_scene_to_file("res://scenes/levels/level"+str(Global.current_scene_name)+".tscn")



func _on_main_menu_button_pressed() -> void:
	Global.is_game_over = false
	#print("FROM GAME OVER: to the main menu")
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
#	get_tree().change_scene_to_file("MainMenu.tscn")
