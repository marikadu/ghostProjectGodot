extends Node

# timer for the normal gamemode


@onready var label = $Label
@onready var cd_timer = $CountDownTimerTimer
var time_left

var npc: CharacterBody2D


func _ready() -> void:
	Events.possessed_escaped.connect(_on_possessed_escaped)
	
#	initializing npc before accessing it
	call_deferred("_initialize_npc")
	
	#tutorial_mode()
	

func time_left_until_win():
	time_left = cd_timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]
	
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("time_minus"):
		#print("timer down")
		#time_left = 2.0
		cd_timer.set_wait_time(6.0) 
		cd_timer.start()
		
	#label.scale.x = move_toward(label.scale.x, 1, 3 * delta)
	#label.scale.y = move_toward(label.scale.y, 1, 3 * delta)


func _process(_delta: float) -> void:
	label.text = "%02d:%02d" % time_left_until_win()
	
	#if cd_timer.time_left <= 5.0:
		#animate_timer()
	#if cd_timer.time_left <= 0.0:
		#stop_animate_timer()
	
	
func _initialize_npc() -> void:
	npc = Global.npc_instance
	if npc == null:
		print("NPC instance not ready yet")


func _on_timer_timeout() -> void:
	var animated_sprite = npc.get_node_or_null("AnimatedSprite2D")
	if animated_sprite != null:
		if npc.is_alive:
			animated_sprite.play("waking_up")
			Events.win_game.emit()
			
		else:
			Events.time_up_human_dead.emit()
			Events.game_over.emit()

	if npc == null:
		return 
		
func _on_possessed_escaped():
	#print("stop the timer")
	cd_timer.stop()


#func tutorial_mode():
	#if Global.current_scene_name == "level_1":
		#print("setting cd timer to 30 seconds")
		#cd_timer.set_wait_time(30.0)
	
