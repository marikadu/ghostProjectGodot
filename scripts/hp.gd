extends TextureProgressBar

@onready var timer = $Timer
@onready var damage_bar = $Damagebar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health  # Update the main progress bar

	if health <= 0:
		queue_free()

	# Handle damage and healing updates
	if health < prev_health:
		if timer != null:
			timer.start()  # Start the timer to delay damage bar update
	elif damage_bar != null:
		damage_bar.value = health  # Immediately update the damage bar for healing

func init_health(_health):
	health = _health
	max_value = health
	value = health

	if damage_bar != null:
		damage_bar.max_value = health
		damage_bar.value = health

func _on_timer_timeout() -> void:
	if damage_bar != null:
		damage_bar.value = health  # Update damage bar to match current health
