extends Node
# to restart the same scene
# get_tree().reload_current_scene()

# slow down time
# Engine.time_scale = 0.5 (would be cool for lose screen)

@onready var label = $Label
@onready var cd_timer = $CountDownTimerTimer
var time_left

var npc: CharacterBody2D


func _ready() -> void:
	Events.possessed_escaped.connect(_on_possessed_escaped)
	
#	initializing npc before accessing it
	call_deferred("_initialize_npc")
	

func time_left_until_win():
	time_left = cd_timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]
	
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("time_minus"):
		#print("timer down")
		#time_left = 2.0
		cd_timer.set_wait_time(2.0) 
		cd_timer.start()


func _process(_delta: float) -> void:
	label.text = "%02d:%02d" % time_left_until_win()
	
	
func _initialize_npc() -> void:
	npc = Global.npc_instance
	if npc == null:
		print("NPC instance not ready yet")
	else:
		print("NPC loaded successfully")


func _on_timer_timeout() -> void:
	var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
	if animated_sprite != null:
		if npc.is_alive:
			print("yippie npc is alive")
			print("win!")
			animated_sprite.play("waking_up")
			Events.win_game.emit()
			
		else:
			print("npc is dead lmao")
			Events.game_over.emit()
		#npc.animated_sprite.play("waking_up")

	if npc == null:
		print("NPC instance is null")
		return 
		
func _on_possessed_escaped():
	#print("stop the timer")
	cd_timer.stop()
	pass
	
	#var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
	#if animated_sprite != null:
		#animated_sprite.play("waking_up")
	#else:
		#print("AnimatedSprite2D node not found")

	#if npc != null:
		#var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
		#if animated_sprite != null:
			#animated_sprite.play("waking_up")
		#else:
			#print_debug("no animated sprite node")
	#else:
		#print_debug("no NPC is found")
