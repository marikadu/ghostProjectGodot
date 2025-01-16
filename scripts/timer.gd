extends Node
# to restart the same scene
# get_tree().reload_current_scene()

# slow down time
# Engine.time_scale = 0.5 (would be cool for lose screen)

@onready var label = $Label
@onready var timer = $Timer

var npc: CharacterBody2D


func _ready() -> void:
	timer.start()
#	initializing npc before accessing it
	call_deferred("_initialize_npc")
	

func time_left_until_win():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]


func _process(_delta: float) -> void:
	label.text = "%02d:%02d" % time_left_until_win()
	
	
func _initialize_npc() -> void:
	npc = Global.npc_instance
	if npc == null:
		print("NPC instance not ready yet")
	else:
		print("NPC loaded successfully")


func _on_timer_timeout() -> void:
	print("win!")
	Events.win_game.emit()
	#npc.animated_sprite.play("waking_up")

	if npc == null:
		print("NPC instance is null")
		return 
	
	var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
	if animated_sprite != null:
		animated_sprite.play("waking_up")
	else:
		print("AnimatedSprite2D node not found")

	#if npc != null:
		#var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
		#if animated_sprite != null:
			#animated_sprite.play("waking_up")
		#else:
			#print_debug("no animated sprite node")
	#else:
		#print_debug("no NPC is found")
