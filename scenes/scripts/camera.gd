extends Camera2D

#@onready var player = get_tree().root.get_node("main/GhostPlayer") # !!!!
@onready var player: CharacterBody2D = %GhostPlayer
var camera_off = Vector2(576,449)

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
	if Graphics.camera_follow_player:
		position = (player.position*delta * 2) + camera_off # NEW CODE
	#else:
		#pass
