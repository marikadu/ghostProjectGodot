extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transition.transition()
	Transition.animation_player.play("fade_out")
	#await Transition.on_transition_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
