extends Camera2D

#@onready var player = get_tree().root.get_node("main/GhostPlayer") # !!!!
@onready var player: CharacterBody2D = %GhostPlayer

#var camera_off = Vector2(576,449)

func _ready() -> void:
	if not Global.current_scene_name == 8:
		position = get_viewport_rect().size / 2
	#offset = get_viewport_rect().size * 2


func _process(_delta):
	
	# maybe even shake + slightly zoom out or zoom in for more juice
	
	# maybe something similar to ori and the will of the whisps
	if Graphics.camera_follow_player:
		cameraUpdate()
		

# https://www.youtube.com/watch?v=P0VMQ40VTtc comment
func cameraUpdate():
	#var pos = get_local_mouse_position()
	if player:
		# the lower the player position division number -> the slower the camera
		#get_viewport_rect() to find the middle of the screen
		var pos = player.get_position_delta()/6 + get_viewport_rect().size / 2
		set_position(pos)
		
		# NOTE TO MYSELF
		# POSITION SMOOTHING MADE THE CAMERA JUMP FROM 0,0 TO THE MIDDLE OF THE SCREEN
		# WHEN THE ACHOR MODE IS SET TO DRAG CENTER
		# SO TO FIX THE ISSUE, I NEEDED TO TURN THE POSITION SMOOTHING OFF!!!!!!!!!!
		
		
