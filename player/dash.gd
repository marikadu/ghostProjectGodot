extends Control

#@onready var player: CharacterBody2D = get_node_or_null("../../GhostPlayer")
@onready var player: CharacterBody2D = %GhostPlayer
@onready var stamina_restore_anim: Timer = $stamina_restore_anim

@onready var stamina_bars = [ # progress bar array
	$stamina1,
	$stamina2,
	$stamina3,
	$stamina4,
	$stamina5]

# variables for smooth transition
var lerp_speed = 5.0  # speed of the smooth transition for resetting the bar
var stamina_bar_values = []

var time_to_wait = 1.5
var s_timer = 0
var can_start_stimer = true

func _ready() -> void:
	
	if player:
		stamina_bar_values = []
		for bar in stamina_bars:
			stamina_bar_values.append(bar.value)
	pass


func _process(_delta: float) -> void:
	
	if player:
		for i in range(len(stamina_bars)):
			var target_value = stamina_bars[i].max_value if i < player.current_stamina else 0
			
			# stamina bar smooth animation
			stamina_bar_values[i] = lerp(float(stamina_bar_values[i]), float(target_value), lerp_speed * _delta)
			
			# show the value to the progress bar
			stamina_bars[i].value = stamina_bar_values[i]
			
			if player.dashing:
				#print("dashingggngng")
				stamina_restore_anim.start()
	


func _on_stamina_restore_anim_timeout() -> void:
	#stamina_bar_values.value = player.current_stamina
	pass # Replace with function body.
