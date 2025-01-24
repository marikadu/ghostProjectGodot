extends Node2D

@onready var player = get_tree().root.get_node("main/GhostPlayer")

@onready var foreground: Sprite2D = $foreground
@onready var middleground: Sprite2D = $middleground
@onready var background: Sprite2D = $background

var camera_off = Vector2(576,449)


func _process(delta):
	#foreground.position = (player.position*delta) * 2
	middleground.position = (player.position*delta) / 2
	background.position = (player.position*delta) / 4
	pass
	#position = (player.position*delta) + camera_off # NEW CODE
