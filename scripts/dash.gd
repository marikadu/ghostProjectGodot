extends Control

#@onready var ghost_player = get_node_or_null("../GhostPlayer")
#@onready var ghost_player: CharacterBody2D = $"../../GhostPlayer"
@onready var ghost_player: CharacterBody2D = get_node_or_null("../../GhostPlayer")


@onready var dash_timer_reset = ghost_player.get_node_or_null("dash_timer_reset") if ghost_player else null
@onready var pb = $TextureProgressBar  # progress bar within the UI

# variables for smooth transition
var lerp_speed = 5.0  # speed of the smooth transition for resetting the bar

func _ready() -> void:
	if dash_timer_reset:
		pb.max_value = dash_timer_reset.wait_time  # set the progress bar's max value to the timer's wait time
		pb.step = 0
		# start the game wil full progress bar
		pb.value = pb.max_value
	else:
		print("dash_timer_reset not found!")


func _process(_delta: float) -> void:
	if dash_timer_reset:
		if dash_timer_reset.is_stopped():
			# to regenirate progress bar to full, to make player be ready to dash
			#pb.value = lerp(1, 0, delta)
			pb.value = lerp(pb.value, pb.max_value, 0.1 )
		else:
			# decrease the progress bar
			#pb.value = lerp(0, 1, delta)
			pb.value = lerp(pb.value, 0.0, 0.1)
	else:
		# reset progress bar if timer is not found
		pb.value = 0
