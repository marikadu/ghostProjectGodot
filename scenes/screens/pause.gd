extends Control

@onready var pause_menu: Control = $"."
#@onready var options_pause = preload("res://scenes/menus/options_pause.tscn")
@onready var options_pause: Control = $OptionsMenu


func _ready() -> void:
	pause_menu.hide()
	options_pause.hide()



func _process(delta: float) -> void:
	# if not in the paused state and pressed esc
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
		
	# if in the paused state and pressed esc | AND NOT in the settings
	elif Input.is_action_just_pressed("pause") and get_tree().paused and not options_pause.visible:
		resume()
	
	# if in the paused state and pressed esc | AND in the settings
	elif Input.is_action_just_pressed("pause") and get_tree().paused and options_pause.visible:
		options_pause.hide()


func resume():
	pause_menu.hide()
	get_tree().paused = false
	
func pause():
	pause_menu.show()
	get_tree().paused = true


# --- buttons ---
func _on_resume_pressed() -> void:
	resume()

func _on_main_menu_button_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
	print("FROM PAUSE: to the main menu")


func _on_settings_pressed() -> void:
	options_pause.show()
