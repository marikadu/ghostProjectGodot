extends AnimationPlayer


func _ready() -> void:
	if !Global.current_scene_name == "level_1":
		play("moon")
	else:
		pass
