extends AnimationPlayer


@export var time = 15.0
@export var sun_wait_before_sunrise = 30.0


func _ready() -> void:
	if !Global.current_scene_name == "level_1":
		await get_tree().create_timer(sun_wait_before_sunrise).timeout
		play("sun")
	else:
		pass
	
