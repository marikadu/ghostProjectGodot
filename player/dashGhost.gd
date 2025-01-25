extends Sprite2D

func _ready() -> void:

	var tween: Tween = get_tree().create_tween()

	# transitions and ease for the tweens
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	# tween modulation over 0.5 seconds
	tween.tween_property(self, "modulate:a", 0.0, 0.5)

	# callback when tween finishes
	tween.tween_callback(Callable(self, "finished"))

func finished() -> void:
	# delete tween when finished
	queue_free()
