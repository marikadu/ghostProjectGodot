extends Camera2D


@onready var player: CharacterBody2D = %GhostPlayer


func _ready() -> void:
	if not Global.current_scene_name == 8:
		position = get_viewport_rect().size / 2

func _process(_delta):
	
	# maybe even shake + slightly zoom out or zoom in for more juice
	
	if Graphics.camera_follow_player:
		cameraUpdate()
	

## https://www.youtube.com/watch?v=P0VMQ40VTtc 
## got the solution from the comment from that video 
func cameraUpdate():
	if player:
		# the lower the player position division number -> the slower the camera
		# "get_viewport_rect()" # to find the middle of the screen
		var cam_position = player.get_position_delta()/6 + get_viewport_rect().size / 2
		set_position(cam_position)
		
		# note to myself:
		# position smoothing in the camera made it jump from (0,0) to the middle of the player screen
		# when the achor mode was set to drag center
		# so to fix the "sharp jump", I needed to turn off the position smoothing option!!
