extends CenterContainer



func _on_next_level_pressed() -> void:
	AudioManager.play_button_pressed()
	change_level()


func _on_replay_pressed() -> void:
	AudioManager.play_button_pressed()
	Global.is_game_over = false
	# loading the same level
	#get_tree().change_scene_to_file("res://scenes/levels/level"+str(Global.current_scene_name)+".tscn")
	# turns out there's a simpler solution to this, good to know
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	AudioManager.play_button_pressed()
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")


func change_level():
	get_tree().change_scene_to_file("res://scenes/levels/level"+str(Global.current_scene_name+1)+".tscn")
	# on the last level don't show the "Next Level" button


func _on_main_menu_button_mouse_entered() -> void:
	AudioManager.play_button_hover()


func _on_replay_mouse_entered() -> void:
	AudioManager.play_button_hover()
