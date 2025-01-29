extends AnimationPlayer


func _ready() -> void:
	if !Global.current_scene_name == "level_1":
		play("stars")
		print("stars go")
	else:
		print("stars no")
		pass
	
