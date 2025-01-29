extends AnimationPlayer


func _ready() -> void:
	if Global.current_scene_name == 1:
		play("stars")
		print("stars NO")
	else:
		print("stars go")
		pass
	
