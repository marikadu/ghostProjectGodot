extends Node
# to restart the same scene
# get_tree().reload_current_scene()

# slow down time
# Engine.time_scale = 0.5 (would be cool for lose screen)

@onready var label = $Label
@onready var timer = $Timer
#@onready var win_screen = get_tree().root.get_node("main/WinScreen")


func _ready() -> void:
	timer.start()

func time_left_until_win():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]


func _process(_delta: float) -> void:
	label.text = "%02d:%02d" % time_left_until_win()


func _on_timer_timeout() -> void:
	print("win!")
	Events.win_game.emit()
	pass # Replace with function body.
