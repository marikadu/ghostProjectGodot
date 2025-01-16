extends TextureProgressBar

@onready var timer = $Timer
@onready var damage_bar = $Damagebar
#@onready var game_controller = get_node("res://scripts/main.gd")
@onready var game_controller = get_tree().root.get_node("main")

#@onready var event_node = get_node("res://scripts/Events.gd")

var health = 0 : set = _set_health
# lerping that doesn't work
var lerp_speed = 5.0 
var is_timer_connected = false

func _process(delta):
	if damage_bar != null and damage_bar.value > health:
#		lerp for better UI -> smooth hp bar
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)

func _set_health(_new_health):
	var prev_health = health
	health = min(max_value, _new_health)
	# update the progress bar
	value = health

	# NPC dies
	if health <= 0:
		Events.npc_died.emit() # sending a signal that the npc has died
		#queue_free() # doesn't recieve damage again
		# I need to make it possible for the hp bar to not get deleted for the
		# logic of possessed

	# handle damage, NPC is hit logic
	if health < prev_health:
		# making sure that the timer is connected
		if timer != null and !is_timer_connected:
			#is_timer_connected = true
			pass
		timer.start()

	# update the healthbar
	elif health > prev_health:
		if damage_bar != null:
			damage_bar.value = health  # Update damage bar if health increases


func init_health(_health):
	max_value = _health
	health = _health
	value = health

	if damage_bar != null:
		damage_bar.max_value = health
		damage_bar.value = health


func _on_timer_timeout() -> void:
	if damage_bar != null:
		# show the damage bar and then reduce it to the current health
		damage_bar.value = health
		#damage_bar.hide()
		#is_timer_connected = false
