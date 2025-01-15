extends Camera2D

@onready var player = get_tree().root.get_node("main/GhostPlayer")

func _process(delta):
	position += (player.position * delta) - position
	
