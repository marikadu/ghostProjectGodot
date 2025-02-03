extends Node

# timer for the infinite gamemode (level7)

#@onready var label = $Label
#@onready var cd_timer = $CountDownTimerTimer
#var time_left
var time: float = 0.0
var minutes: float = 0.0
var seconds: float = 0.0
#var msec: int = 0

var npc: CharacterBody2D


func _ready() -> void:
	Events.possessed_escaped.connect(_on_possessed_escaped)
	
#	initializing npc before accessing it
	call_deferred("_initialize_npc")
	



#func time_left_until_win():
	#time_left = cd_timer.time_left
	#var minute = floor(time_left / 60)
	#var second = int(time_left) % 60
	#return [minute, second]
	
	
#func _physics_process(_delta: float) -> void:
	#if Input.is_action_pressed("time_minus"):
		##print("timer down")
		##time_left = 2.0
		#cd_timer.set_wait_time(6.0) 
		#cd_timer.start()
		
	#label.scale.x = move_toward(label.scale.x, 1, 3 * delta)
	#label.scale.y = move_toward(label.scale.y, 1, 3 * delta)


func _process(delta: float) -> void:
	time += delta
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d" % seconds

		
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:02d" % [minutes, seconds]
	
func _initialize_npc() -> void:
	npc = Global.npc_instance
	#if npc == null:
		#print("NPC instance not ready yet")
	#else:
		#print("NPC loaded successfully")


func _on_possessed_escaped():
	#print("stop the timer")
	stop()
