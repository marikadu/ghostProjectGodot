extends TextureProgressBar

@onready var damage_timer: Timer = $DamageTimer
@onready var healing_timer: Timer = $HealingTimer
@onready var damage_bar: ProgressBar = $Damagebar
@onready var healing_bar: ProgressBar = $Healingbar
@onready var game_controller = get_tree().root.get_node("main")


var health = 0 : set = _set_health
var lerp_speed = 5.0 
var fade_speed = 7
var fading_in = false
var fading_out = false


func _ready() -> void:
	healing_bar.visible = false
	healing_timer.autostart = false
	healing_bar.modulate = Color(1, 1, 1, 0) # completely transparent


func _process(delta):
	if damage_bar != null and damage_bar.value > health:
		# lerp for better UI -> smooth hp bar
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_bar.value = lerp(float(healing_bar.value), float(health), lerp_speed * delta)
	elif damage_bar.value < health:
		damage_bar.value = lerp(float(damage_bar.value), float(health), lerp_speed * delta)
		healing_bar.value = lerp(float(healing_bar.value), float(health), lerp_speed * delta)

	# fade-in, fade-out
	if fading_in:
		_fade_in(delta)
	elif fading_out:
		_fade_out(delta)


func _set_health(_new_health):
	var prev_health = health
	health = min(max_value, _new_health)
	value = health  # update the progress bar

	# NPC dies
	if health <= 0:
		Events.npc_died.emit() # sending a signal that the npc has died

	# damage
	if health < prev_health:
		damage_timer.start()
		
	# healing
	elif health > prev_health:
		healing_bar.visible = true
		fading_in = true
		fading_out = false
		healing_timer.start()


func init_health(_health):
	max_value = _health
	health = _health
	value = health

	if damage_bar != null:
		damage_bar.max_value = health
		damage_bar.value = health

	if healing_bar != null:
		healing_bar.max_value = health
		healing_bar.value = health
		healing_bar.visible = false
		healing_bar.modulate = Color(1, 1, 1, 0)  # healing bar is fully transparent


func _on_damage_timer_timeout() -> void:
	if damage_bar != null:
		# show the damage bar and then reduce it to the current health
		damage_bar.value = health
		healing_bar.value = health
		#damage_bar.hide()


func _on_healing_timer_timeout() -> void:
	if healing_bar != null:
		await get_tree().create_timer(0.8).timeout
		fading_in = false
		fading_out = true  # start fade-out


# fade in
func _fade_in(delta):
	var current_alpha = healing_bar.modulate.a
	if current_alpha < 1.0:
		healing_bar.modulate.a = min(current_alpha + fade_speed * delta, 1.0)
	else:
		fading_in = false  # stop fade-in when fully visible


# fade out
func _fade_out(delta):
	var current_alpha = healing_bar.modulate.a
	if current_alpha > 0.0:
		healing_bar.modulate.a = max(current_alpha - fade_speed * delta, 0.0)
	else:
		fading_out = false  # stop fade-out when fully transparent
		healing_bar.visible = false
