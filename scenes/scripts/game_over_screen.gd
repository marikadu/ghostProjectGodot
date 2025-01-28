extends CenterContainer



func _on_try_again_pressed() -> void:
	print("try again")



func _on_main_menu_button_pressed() -> void:
	#print("FROM GAME OVER: to the main menu")
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")
#	get_tree().change_scene_to_file("MainMenu.tscn")
