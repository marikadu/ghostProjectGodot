extends Node

# npc instance
var npc_instance: Node = null
var is_game_over : bool

var score = 0
var personal_best = 0

# personal best score
# DONT add to the personal best if Game Over!!!
func update_personal_best():
	if score > personal_best:
		personal_best = score
		print("New personal best:", personal_best)
		
		
		
#func save_personal_best():
	#var file = File.new()
	#if file.open("user://personal_best.save", File.WRITE) == OK:
		#file.store_var(personal_best)
		#file.close()
		#print("Personal best saved:", personal_best)
