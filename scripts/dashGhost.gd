extends Sprite2D

func _ready() -> void:
	# Creates a Tween using the new API
	var tween: Tween = get_tree().create_tween()

	# Sets transition and ease for all following tweens
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	# Tween the modulate property from black (0, 0, 0, 1) to white (1, 1, 1, 1) over 0.5 seconds
	tween.tween_property(self, "modulate:a", 0.0, 0.5)

	# Optional: Add a callback when the tween finishes
	tween.tween_callback(Callable(self, "finished"))

func finished() -> void:
	queue_free()  # Free the node or execute other actions when the tween is complete
