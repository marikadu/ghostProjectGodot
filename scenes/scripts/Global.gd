extends Node

var npc_instance: Node = null
var player_instance
var is_game_over : bool
var is_game_won : bool
var current_scene_name: int

var score = 0
var personal_best = 0

var time_recorded = 0
var personal_best_time = 0

var levels = []
var unlocked_levels = 1


#var save_file = FileAccess.open("user://user-data.txt", FileAccess.WRITE)
#var save_file_path = "user://save/"
#var save_file_file = "Save.tres"

# debugging shortcuts
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("personal_best_set"):
		personal_best = 4412
		update_personal_best()
		
	if Input.is_action_just_pressed("unlock_all_levels"):
		Global.unlocked_levels = 6


# personal best score
# DONT add to the personal best if Game Over!!!
# unless it's level 7: infinite night
func update_personal_best():
	if score > personal_best:
		personal_best = score
		#print("New personal best:", personal_best)
		#save_file.store_string(personal_best)


func update_personal_best_time():
	var time_as_int = int(time_recorded)
	var best_time_as_int = int(personal_best_time)
	
	if time_as_int and (best_time_as_int == 0 or time_as_int > best_time_as_int):
		personal_best_time = time_recorded
		print("new best time: ", personal_best_time)
