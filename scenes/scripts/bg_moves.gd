extends Node2D

@onready var player = get_tree().root.get_node("main/GhostPlayer")

@onready var n_foreground: Sprite2D = $n_foreground
@onready var n_middleground: Sprite2D = $n_middleground
@onready var n_background: Sprite2D = $n_background
@onready var n_sky: Sprite2D = $n_sky

@onready var d_foreground: Sprite2D = $d_foreground
@onready var d_middleground: Sprite2D = $d_middleground
@onready var d_background: Sprite2D = $d_background
@onready var d_sky: Sprite2D = $d_sky


@export var time = 15.0
@export var wait_before_sunrise = 29.0

var camera_off = Vector2(576,449)


func _process(delta):
	#foreground.position = (player.position*delta) * 2
	n_middleground.position = (player.position*delta) / 2
	d_middleground.position = (player.position*delta) / 2
	
	n_background.position = (player.position*delta) / 4
	d_background.position = (player.position*delta) / 4
	
	if !Global.current_scene_name == "level_1":
		#print("sunrise animation ready")
		await get_tree().create_timer(wait_before_sunrise).timeout
		fade_out()
	else:
		#print("delay sunrise")
		pass
	

	#position = (player.position*delta) + camera_off # NEW CODE
	
	
func fade_out():
	var tween_f = get_tree().create_tween()
	var tween_m = get_tree().create_tween()
	var tween_b = get_tree().create_tween()
	var tween_s = get_tree().create_tween()
	tween_f.tween_property(n_foreground, "modulate:a", 0, time)
	tween_m.tween_property(n_middleground, "modulate:a", 0, time)
	tween_b.tween_property(n_background, "modulate:a", 0, time)
	tween_s.tween_property(n_sky, "modulate:a", 0, time)
	tween_f.play()
	tween_m.play()
	tween_b.play()
	tween_s.play()
	await tween_f.finished
	await tween_m.finished
	await tween_b.finished
	await tween_s.finished
	tween_f.kill()
	tween_m.kill()
	tween_b.kill()
	tween_s.kill()
