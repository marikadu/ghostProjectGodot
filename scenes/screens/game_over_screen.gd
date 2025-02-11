extends CenterContainer


@onready var cause: Label = $"../Cause"

func _ready() -> void:
	cause.hide()
	
	Events.game_over.connect(_on_game_over)
	Events.possessed_escaped.connect(_on_possessed_escaped)
	Events.game_over_woke_up_human.connect(_on_woke_up_human)


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
	

# show the player the cause of Game Over
func show_game_over_message(reason: String):
	match reason:
		"possessed_on_screen":
			cause.text = "The human is possessed!"
			
		"possessed_escaped":
			cause.text = "The Possessed has escaped!"
			
		"you_woke_them_up":
			cause.text = "You woke the humnan up!"
			
		_:
			cause.text = ""
		
	cause.visible = true


func _on_game_over():
	show_game_over_message("possessed_on_screen")
	
func _on_possessed_escaped():
	show_game_over_message("possessed_escaped")
	

func _on_woke_up_human():
	show_game_over_message("you_woke_them_up")
