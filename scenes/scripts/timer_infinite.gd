extends Control

# timer for the infinite gamemode (level7)

@onready var cd_timer: Control = $"."

var time: float = 0.0
var minutes: float = 0.0
var seconds: float = 0.0
#var msec: int = 0

var npc: CharacterBody2D


func _ready() -> void:
	Events.possessed_escaped.connect(_on_possessed_escaped)
	Events.game_over_woke_up_human.connect(_on_woke_up_human)
	
#	initializing npc before accessing it
	call_deferred("_initialize_npc")


func _process(delta: float) -> void:
	time += delta
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d" % seconds

		
func stop() -> void:
	set_process(false)
	

# storing time as String
func get_time_formatted() -> String:
	return "%02d:%02d" % [minutes, seconds]


func _initialize_npc() -> void:
	npc = Global.npc_instance


func _on_possessed_escaped():
	#print("stop the timer")
	stop()
	# storing the time as int
	Global.time_recorded = minutes * 60 + seconds
	
func _on_woke_up_human():
	stop()
	Global.time_recorded = minutes * 60 + seconds
