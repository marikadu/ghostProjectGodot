extends Control


var sound_has_played = false
var text_has_faded = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transition.transition()
	Transition.animation_player.speed_scale -= 0.2
	Transition.animation_player.play("fade_out")
	await Transition.on_transition_finished
	$VideoStreamPlayer.play()
	
	await Transition.on_transition_finished

	
func _process(_delta: float) -> void:
	await get_tree().create_timer(2.1).timeout
	if not sound_has_played:
		AudioManager.play_ghost_dies()
		sound_has_played = true
		
	if not text_has_faded:
		await get_tree().create_timer(1.1).timeout
		$Label/AnimationPlayer.play("fade_out")
		text_has_faded = true


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
