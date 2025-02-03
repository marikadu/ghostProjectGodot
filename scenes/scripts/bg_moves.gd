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

@onready var moon_player: AnimationPlayer = $moon/moon_player
@onready var stars_player: AnimationPlayer = $stars/stars_player
@onready var sun_player: AnimationPlayer = $sun/sun_player
@onready var wait_before_sunrise_timer: Timer = $wait_before_sunrise
@onready var moon_timer: Timer = $moon_timer

@export var time = 15.0
@export var wait_before_sunrise = 45.0
@export var rise_the_sun = 48.0


var camera_off = Vector2(576,449)



func _ready() -> void:
	Events.start_counting_down.connect(tutorial_background)
	
	await get_tree().create_timer(0.1).timeout
	if Global.current_scene_name == 1:
		print("bg_moves: stop the bg!!!!!!")
		#time = 8.0
		wait_before_sunrise = 18.0
		rise_the_sun = 22.0
		
	# different background for the infinite mode
	elif Global.current_scene_name == 7:
		print("bg moves: infinite mode")
		background_animation_start()
		wait_before_sunrise = null
		rise_the_sun = 22.0
	
	# animate background as normal
	else:
		background_animation_start()
		print("bg_moves: ", Global.current_scene_name)
		
	#wait_before_sunrise_timer.set_wait_time(wait_before_sunrise) 


func _process(delta):
	#foreground.position = (player.position*delta) * 2
	if Graphics.camera_follow_player:
		n_middleground.position = (player.position*delta) / 2
		d_middleground.position = (player.position*delta) / 2
		
		n_background.position = (player.position*delta) / 4
		d_background.position = (player.position*delta) / 4
	
	if Global.current_scene_name == 1:
		return
		
	elif Global.current_scene_name == 7:
		return
	
	else:
		await get_tree().create_timer(wait_before_sunrise).timeout
		fade_out()
	
	
	
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
	

func tutorial_background():
	background_animation_start()
	await get_tree().create_timer(wait_before_sunrise).timeout
	fade_out()
	

func background_animation_start():
	print("bg_moves: activate all bg")

	if Global.current_scene_name == 1:
		stars_player.play("stars")
		await get_tree().create_timer(rise_the_sun).timeout
		sun_player.play("sun")
		
	elif Global.current_scene_name == 7:
		# infinite mode:
		# infinite stars, no sun, moon every 1 minute
		moon_timer.start()
		stars_player.play("stars")
		#moon_player.play("moon")
		
		
	else:
		moon_player.play("moon")
		stars_player.play("stars")
		await get_tree().create_timer(rise_the_sun).timeout
		sun_player.play("sun")
		


func _on_moon_timer_timeout() -> void:
	moon_player.play("moon")
