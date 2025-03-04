extends Node

var npc_instance: Node = null
var player_instance
var is_game_over : bool
var is_game_won : bool
var is_main_menu_music_playing: bool
var current_scene_name: int

var score = 0
var personal_best = 0

var time_recorded = 0
var personal_best_time = 0

var levels = []
var unlocked_levels = 1

# debugging shortcuts
#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("personal_best_set"):
		#personal_best = 4412
		#update_personal_best()
		
	#if Input.is_action_just_pressed("unlock_all_levels"):
		#Global.unlocked_levels = 6


# personal best score
# DONT add to the personal best if Game Over!!!
# unless it's level 7: infinite night
func update_personal_best():
	if score > personal_best:
		personal_best = score


func update_personal_best_time():
	# recording as int to compare later
	var time_as_int = int(time_recorded) # storing seconds
	var best_time_as_int = int(personal_best_time)


	if time_as_int > best_time_as_int:
		personal_best_time = time_as_int
		print("new best time: ", personal_best_time)
