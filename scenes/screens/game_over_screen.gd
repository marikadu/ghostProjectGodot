extends CenterContainer



func _on_try_again_pressed() -> void:
	Global.is_game_over = false
	AudioManager.play_button_pressed()
	# loading the same level
	get_tree().change_scene_to_file("res://scenes/levels/level"+str(Global.current_scene_name)+".tscn")



func _on_main_menu_button_pressed() -> void:
	Global.is_game_over = false
	AudioManager.play_button_pressed()
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")


func _on_try_again_mouse_entered() -> void:
	AudioManager.play_button_hover()


func _on_main_menu_button_mouse_entered() -> void:
	AudioManager.play_button_hover()
