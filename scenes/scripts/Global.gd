extends Node

var npc_instance: Node = null
var player_instance
var is_game_over : bool
var is_game_won : bool
var current_scene_name: int

var score = 0
var personal_best = 0

var levels = []
var unlocked_levels = 1


#var save_file = FileAccess.open("user://user-data.txt", FileAccess.WRITE)
#var save_file_path = "user://save/"
#var save_file_file = "Save.tres"



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("personal_best_set"):
		personal_best = 4412
		update_personal_best()


# personal best score
# DONT add to the personal best if Game Over!!!
func update_personal_best():
	if score > personal_best:
		personal_best = score
		#print("New personal best:", personal_best)
		#save_file.store_string(personal_best)
