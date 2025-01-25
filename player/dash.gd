extends Control

@onready var ghost_player: CharacterBody2D = get_node_or_null("../../GhostPlayer")
@onready var stamina_restore_anim: Timer = $stamina_restore_anim
@onready var stamina_bars = [ # progress bar array
	$stamina1,
	$stamina2,
	$stamina3]

# variables for smooth transition
var lerp_speed = 5.0  # speed of the smooth transition for resetting the bar
var stamina_bar_values = []

var time_to_wait = 1.5
var s_timer = 0
var can_start_stimer = true

func _ready() -> void:
	
	if ghost_player:
		stamina_bar_values = []
		for bar in stamina_bars:
			stamina_bar_values.append(bar.value)
	pass


func _process(_delta: float) -> void:
		
	if ghost_player:
		for i in range(len(stamina_bars)):
			var target_value = stamina_bars[i].max_value if i < ghost_player.current_stamina else 0
			if i < ghost_player.current_stamina:
				stamina_bars[i].value = stamina_bars[i].max_value
				#stamina_bar_values[i] = lerp(float(stamina_bar_values[i]), float(target_value), lerp_speed * _delta)
			else:
				stamina_bars[i].value = 0
				
	#if ghost_player:
		#for i in range(len(stamina_bars)):
			## Target value: full bar if stamina exists, otherwise empty
			#var target_value = stamina_bars[i].max_value if i < ghost_player.current_stamina else 0
			#
			## Smoothly transition the bar value using lerp
			#stamina_bar_values[i] = lerp(float(stamina_bar_values[i]), float(target_value), lerp_speed * _delta)
			#
			## Apply the visual value to the progress bar
			#stamina_bars[i].value = stamina_bar_values[i]
	
	
	#if ghost_player.dashing == false:
	#if ghost_player.dashing == false and ghost_player.current_stamina < ghost_player.max_stamina_sections:
		#pass
		#restore_stamina_bar()
				
				
#func restore_stamina_bar():
	##ghost_player.timer
	#print("restoring the bar")
	##stamina_restore_anim.start()
	##pb.value = lerp(pb.value, float(ghost_player.current_stamina), 0.1)
	#pass
