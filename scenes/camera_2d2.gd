extends Camera2D

@onready var player = get_tree().root.get_node("main/GhostPlayer") # !!!!

func _process(delta):
	#pass
	# multiply by number = make camera faster
	# divide by number = make camera slower
	# I should also apply those to the items to create a parallax effect
	
	# the further from the camera -> divide by greater number
	# e.g. : far away background = divide by 6
	# background = divide by 4
	# middleground = divide by 2
	# foreground = don't divide, don't multiply
	# close foreground = multiply by 2
	
	# add camera shake when kill the enemy
	# more shake when defeat the possessed?
	# maybe even shake + slightly zoom out or zoom in for more juice
	
	# maybe something similar to ori and the will of the whisps
	
	position += (player.position *2 * delta) - position # !!!!!
	#position += (player.position * delta) - position # !!!!!
	#position += (player.position * delta) - position
	#position = position.lerp(player.position, delta * smoothing_factor)
	#position = position.lerp(player.position, delta)
	#position += ((player.position * 0.05) * delta) - position

	
	#position += lerp((player.position *2 * delta) - position, player.position, delta)

# camera shake
	#if shake_intensity > 0.0:
		#var shake_offset = Vector2(randf() - 0.5, randf() - 0.5) * shake_intensity
		#position += shake_offset
		#shake_intensity = max(shake_intensity - shake_decay * delta/2, 0.0)
#
#func start_shake(intensity: float, duration: float) -> void:
	#shake_intensity = intensity
	#shake_decay = intensity / duration
	
	
