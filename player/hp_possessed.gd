extends TextureProgressBar

@onready var damage_timer: Timer = $DamageTimer
#@onready var healing_timer: Timer = $HealingTimer
@onready var damage_bar: ProgressBar = $Damagebar
@onready var healing_bar: ProgressBar = $Healingbar
@onready var game_controller = get_tree().root.get_node("main")


#var health = 0 : set = _set_health
var health = 9 : set = _set_health
var lerp_speed = 5.0 
var fade_speed = 7



func _process(delta):
	if damage_bar != null and damage_bar.value > health:
		# lerp for better UI -> smooth hp bar
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_bar.value = lerp(float(healing_bar.value), float(health), lerp_speed * delta)
	elif damage_bar.value < health:
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_bar.value = lerp(float(healing_bar.value), float(health), lerp_speed * delta)


func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health  # update the progress bar


	# damage
	if health < prev_health:
		damage_timer.start()
	# healing
	else:
		damage_bar.value = health
		


func init_health(_health):
	max_value = _health
	health = _health
	value = health

	if damage_bar != null:
		damage_bar.max_value = health
		damage_bar.value = health


func _on_damage_timer_timeout() -> void:
	if damage_bar != null:
		# show the damage bar and then reduce it to the current health
		damage_bar.value = health
