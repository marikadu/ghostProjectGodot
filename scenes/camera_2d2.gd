extends Camera2D

@onready var player = get_tree().root.get_node("main/GhostPlayer")

func _process(delta):
	# multiply by number = make camera faster
	# divide by number = make camera slower
	# I should also apply those to the items to create a parallax effect
	
	# the further from the camera -> divide by greater number
	# e.g. : far away background = divide by 6
	# background = divide by 4
	# middleground = divide by 2
	# foreground = don't divide, don't multiply
	# close foreground = multiply by 2
	position += (player.position *2 * delta) - position
	
