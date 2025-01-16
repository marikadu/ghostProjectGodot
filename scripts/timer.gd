extends Node
# to restart the same scene
# get_tree().reload_current_scene()

# slow down time
# Engine.time_scale = 0.5 (would be cool for lose screen)

@onready var label = $Label
@onready var timer = $Timer
#@onready var win_screen = get_tree().root.get_node("main/WinScreen")

var npc: CharacterBody2D


func _ready() -> void:
	timer.start()
	npc = get_tree().root.get_node("main/NPC")
	
	# Ensure the NPC and its AnimatedSprite are valid
	if npc == null:
		print("no npc found")
	elif not npc.has_node("AnimatedSprite2D"):
		print("no sprite node")
	else:
		print("npc loaded successfully")

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
	#npc.animated_sprite.play("waking_up")
	# access the AnimatedSprite and play the animation
	if npc != null:
		var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
		if animated_sprite != null:
			animated_sprite.play("waking_up")
		else:
			print("no animated sprite node")
	else:
		print("no NPC is found")
