extends CharacterBody2D

@onready var healthbar : TextureProgressBar = get_tree().root.get_node("main/UI/HealthBar")
#@onready var healthbar = %HealthBar
#@onready var healthbar: TextureProgressBar = %HealthBar
#@onready var healthbar = get_node("Node/%HealthBar")


#@onready var npc = get_tree().root.get_node("main/NPC")
@onready var npc_area = $Area2DNPC
@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation
@onready var npc_hit: AudioStreamPlayer2D = $npc_hit
@onready var hit: AudioStreamPlayer2D = $hit



#@onready var camera_control: Control = %CameraControl
@onready var camera_control = get_tree().root.get_node("main/CameraControl")



var health: int
var max_health: int
var is_alive: bool = true
var player: CharacterBody2D
var killed_by: String = ""


func _ready():
	player = get_tree().root.get_node("main/GhostPlayer")
	max_health = 5
	health = max_health # at the start of the game, health is max
	is_alive = true

	if healthbar != null:
		healthbar.init_health(health)

	if npc_area:
		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))

	if hit_timer:
		hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))
		
		
func _physics_process(delta: float) -> void:
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 3 * delta)
		

func set_health(value: int):
	if not is_alive:
		# doesn't update when is dead / when game over
		return  
		

	# npc dies
	health = value
	if health <= 0:
		health = 0
		is_alive = false
		camera_control.apply_shake(30.0, 5)
		animated_sprite.play("gone")
		print("npc died. killed: ", killed_by)
		switchValue()
		#last_attacker = attacker.enemy_type if attacker.has_method("enemy_type") else "unknown"
	else:
		#print("NPC health: %d" % health)
		pass

	if healthbar != null:
#		if the healthbar is active -> update it
		healthbar.health = health
		
func switchValue():
	match killed_by:
		"enemy1":
			print("killed by PURPLE")
		"enemy2":
			print("killed by BLUE")
		"enemy3":
			print("killed by RED")
	pass

# enemy collision logic
func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		# reduce health by 1
		take_damage(1, body)
		pass
	if body == player:
		#print("AAAAAAAAAAA")
		# apply damage if player is near
		pass

# take damage
func take_damage(damage: int, enemy: Node):
	killed_by = enemy.enemy_type
	camera_control.apply_shake(1.2, 1)
	npc_hit.play()
	hit.play()
	animated_sprite.play("hit")
	hit_flash.play("hit_flash")
#	update health
	set_health(health - damage)
	animated_sprite.scale = Vector2(1.2, 0.8)
	if hit_timer:
		hit_timer.start()
		
func restore_health(amount: int) -> void:
	# revive npc if dead and health is restored
	#if not is_alive and health + amount > 0:
	if not is_alive:
			is_alive = true
			animated_sprite.play("sleeping")
			print("npc back from the dead")
			
			
	health = min(health + amount, max_health)  # doesn't go beyond max_health
	if healthbar != null:
		healthbar.health = health  # update the health bar
		
	print("NPC health: ", health)

# when isHit timer finishes -> go back to sleeping animation if alive
func _on_hit_timer_timeout():
	$isHitAnimation.stop()
	#print("Hit animation finished")
	if is_alive:
		animated_sprite.play("sleeping")
		
