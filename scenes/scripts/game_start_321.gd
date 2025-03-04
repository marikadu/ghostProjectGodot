extends Control
## "get ready" 3-2-1 timer


@onready var label = $Label
@onready var game_start_timer: Timer = $GameStartTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var time_left

func _ready() -> void:
	Events.resume_game.connect(_on_resume_game)


func time_until_game_start():
	time_left = game_start_timer.time_left
	var second = int(time_left) % 60
	#return [minute, second]
	return [second]


func _process(_delta: float) -> void:
	label.text = "%2d" % time_until_game_start()


func _on_resume_game():
	AudioManager.play_after_pause()
	self.visible = true
	game_start_timer.start()
	$SecondTimer.start()
	animation_player.play("zoom_out")


func _on_second_timer_timeout() -> void:
	animation_player.play("zoom_out")
	# 1.1 instead of 1, because there's the sound bug, sound starts playing again
	# even if it doesn't have a loop
	if game_start_timer.time_left < 1.1:
		print("timer bye")
		self.visible = false
		get_tree().paused = false
		
		game_start_timer.stop()
		$SecondTimer.stop()
