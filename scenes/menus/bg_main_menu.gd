extends Node2D

@onready var player = get_tree().root.get_node("MainMenu/GhostPlayer")

@onready var foreground: Sprite2D = $foreground
@onready var middleground: Sprite2D = $middleground
@onready var background: Sprite2D = $background

var camera_off = Vector2(576,449)


func _process(delta):
	if Graphics.camera_follow_player:

		# old code:
		#middleground.position = (player.position*delta) * 2
		#background.position = (player.position*delta) / 4
		
		# new code:
		# the lower the number -> the faster will bg move
		middleground.position = player.get_position_delta()/-2 + Vector2(0, -40)
		background.position = player.get_position_delta()/-9 + Vector2(0, -30)
