extends ColorRect
# created to prevent misclick
var can_press: bool


func _ready():
	can_press = true
	hide()


func show_window():
	can_press = false
	get_tree().paused = true  # Pause the game
	show()  # Show the window


func hide_window():
	hide()  # Hide the window
	get_tree().paused = false  # Resume the game

# ---- YES button: quit game ----
func _on_yes_pressed() -> void:
	hide_window()
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().quit()


func _on_yes_mouse_entered() -> void:
	AudioManager.play_button_hover()


# --- NO button: continue playing ----
func _on_no_pressed() -> void:
	hide_window()


func _on_no_mouse_entered() -> void:
	AudioManager.play_button_hover()
