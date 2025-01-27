extends TextureProgressBar

@onready var damage_timer: Timer = $DamageTimer
@onready var healing_timer: Timer = $HealingTimer
@onready var damage_bar: ProgressBar = $Damagebar
@onready var healing_bar: ProgressBar = $Healingbar
#@onready var health_bar: TextureProgressBar = $"."
@onready var game_controller = get_tree().root.get_node("main")


var health = 0 : set = _set_health
var lerp_speed = 5.0 
var healing_health = 0


func _process(delta):
	if damage_bar != null and damage_bar.value > health:
#		lerp for better UI -> smooth hp bar
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_bar.value = lerp(float(healing_bar.value), float(health), lerp_speed * delta)
		
	if damage_bar.value < health:
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_bar.value = lerp(float(healing_bar.value), float(health), lerp_speed * delta)

func _set_health(_new_health):
	var prev_health = health
	health = min(max_value, _new_health)
	value = health # update the progress bar

	# NPC dies
	if health <= 0:
		Events.npc_died.emit() # sending a signal that the npc has died

	# damage
	if health < prev_health:
		# making sure that the timer is connected
		#if damage_timer != null and !is_damage_timer_connected:
			#is_timer_connected = true
			#pass
		damage_timer.start()

	# healing
	elif health > prev_health:
		#if damage_bar != null:
			#damage_bar.value = health  # updating the healthbar if healed
			#damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_timer.start()


func init_health(_health):
	max_value = _health
	health = _health
	value = health
	#healing_health = health

	if damage_bar != null:
		damage_bar.max_value = health
		damage_bar.value = health
		
	if healing_bar != null:
		healing_bar.max_value = health
		healing_bar.value = health


func _on_damage_timer_timeout() -> void:
	if damage_bar != null:
		# show the damage bar and then reduce it to the current health
		damage_bar.value = health
		healing_bar.value = health
		#damage_bar.hide()
		#is_timer_connected = false


func _on_healing_timer_timeout() -> void:
	if damage_bar != null:
		# show the damage bar and then reduce it to the current health
		damage_bar.value = health
		healing_bar.value = health
		await get_tree().create_timer(0.8).timeout
		#is_timer_connected = false
