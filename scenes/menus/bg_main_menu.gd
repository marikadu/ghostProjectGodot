extends Node2D

@onready var player = get_tree().root.get_node("MainMenu/GhostPlayer")

@onready var foreground: Sprite2D = $foreground
@onready var middleground: Sprite2D = $middleground
@onready var background: Sprite2D = $background

var camera_off = Vector2(576,449)


func _process(delta):
	if Graphics.camera_follow_player:
		#pass
		#foreground.position = (player.position*delta) * 8
		middleground.position = (player.position*delta) * 2
		background.position = (player.position*delta) / 4
	else:
		pass
		#middleground.offset = Vector2.ZERO
		#background.offset = Vector2.ZERO
