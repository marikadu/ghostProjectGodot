extends AnimationPlayer


@export var time = 15.0
@export var sun_wait_before_sunrise = 30.0

func _ready() -> void:
	play("moon")
	play("stars")
	await get_tree().create_timer(sun_wait_before_sunrise).timeout
	play("sun")
