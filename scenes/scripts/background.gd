extends CanvasModulate


var target_alpha: float = 0.0  # Target alpha for fading out
var fade_duration: float = 4000.0  # Total time for the transition
var elapsed_time: float = 0.0  # Timer to track progress
var is_transitioning: bool = true  # Flag to allow only one transition

func _process(delta: float) -> void:
	if not is_transitioning:
		return  # Stop further updates if the transition is complete

	# Update elapsed time and calculate progress
	elapsed_time += delta
	var progress = elapsed_time / fade_duration

	# Interpolate alpha based on progress
	var mod = get_modulate()
	mod.a = lerp(mod.a, target_alpha, progress)
	set_modulate(mod)

	# Check if the transition is complete
	if elapsed_time >= fade_duration:
		is_transitioning = false  # Stop further updates
		mod.a = target_alpha  # Ensure alpha is set exactly to the target
		set_modulate(mod)
