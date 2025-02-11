extends CharacterBody2D

@onready var healthbar : TextureProgressBar = get_tree().root.get_node("main/UI/HealthBar")

@onready var npc_area = $Area2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation
@onready var player_near_timer: Timer = $player_near
@onready var player_re_enter_npc: Timer = $player_re_enter_npc

@onready var camera_control = get_tree().root.get_node("main/CameraControl")

@onready var vfx_heal: CPUParticles2D = $vfx_heal

@export var enemy_type: String = "npc"


var health: float
var max_health: float
var is_alive: bool = true
var is_player_near: bool = false
var npc_ignore_player: bool = false
var is_healed: bool

var player_near_time_remaining: float = 0.0
var player: CharacterBody2D
var killed_by: String = ""

#var body: Node


func _ready():
	npc_ignore_player = false
	player = get_tree().root.get_node("main/GhostPlayer")
	#orial = get_tree().root.get_node("main/orial")
	max_health = 10.0
	health = max_health # at the start of the game, health is max
	is_alive = true
	is_healed = false

	if healthbar != null:
		healthbar.init_health(health)

	if npc_area:
		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))

	if hit_timer:
		hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))
		
		
func _physics_process(delta: float) -> void:
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 3 * delta)


func set_health(value: float):
	if not is_alive:
		# doesn't update when is dead / when game over
		return  
	# npc dies
	health = value
	if health <= 0:
		health = 0
		is_alive = false
		AudioManager.play_npc_died()
		camera_control.apply_shake(30.0, 5)
		#print("npc died. killed: ", killed_by)
		killedBy()
	else:
		pass

	if healthbar != null:
#		if the healthbar is active -> update it
		healthbar.health = health
		
func killedBy():
	match killed_by:
		"enemy1":
			#print("killed by LILLY")
			animated_sprite.play("gone")
		"enemy2":
			#print("killed by BLU")
			animated_sprite.play("gone")
		"enemy3":
			#print("killed by REDDY")
			animated_sprite.play("gone")
		_:
			# DON'T SPAWN POSSESSED!
			Events.game_over_woke_up_human.emit()
			print("you woke the NPC up")
			animated_sprite.play("is_woken_up")

# collision logic
func _on_area_2d_body_entered(body_e: Node) -> void:
	if is_alive:
		if body_e.is_in_group("enemy"):
			# reduce health by 1
			take_damage(2.0, body_e)
			
		# apply damage if player is near
		if body_e == player and not npc_ignore_player:
			AudioManager.OST.volume_db = -10.0 # reduse audio
			camera_control.zoom_in()
			is_player_near = true
			animated_sprite.play("hit_player")
				
				# if there is some remaining time, continue where paused
			if player_near_time_remaining > 0:
				player_near_timer.start(player_near_time_remaining)
				print("NPC: re-enter, resuming time: ", player_near_time_remaining)
			else:
				player_near_timer.start(3.0) # start from beginning
				print("NPC: STARTING timer from beginning")
			
			
			player_near_timer.one_shot = false
			AudioManager.unpause_player_near() # resume audio
			player_re_enter_npc.stop() # resetting the timer when player enters back
			player_near_time_remaining = 0.0 # resettin stored time


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player and is_alive:
		if not npc_ignore_player:
			camera_control.zoom_out()
			AudioManager.pause_player_near()
			is_player_near = false
			#print("NPC: player exited?")
			AudioManager.OST.volume_db = -2.295 # bring audio back
			
			# store remaining time + stop the timer
			player_near_time_remaining = player_near_timer.time_left
			#print("NPC: PAUSING AT: ", player_near_time_remaining)
			
			player_near_timer.stop()
			player_re_enter_npc.start() # counting for how long has player been away
			#print("NPC: player away for: ", player_re_enter_npc.time_left)
			if not Global.is_game_won:
				animated_sprite.play("sleeping")
			else:
				print("ignore player BECAUSE WIN")
				pass


# take damage
func take_damage(damage: float, enemy: Node):
	killed_by = enemy.enemy_type
	camera_control.apply_shake(1.2, 1)
	AudioManager.play_hit_npc_voice()
	AudioManager.play_hit_npc_impact()
	animated_sprite.play("hit")
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
#	update health
	#if can_npc_take_damage:
	set_health(health - damage)
	animated_sprite.scale = Vector2(1.2, 0.8)
	if hit_timer:
		hit_timer.start()


func heal(healing: float):
	is_healed = true
	vfx_heal.emitting = true
#	update health
	set_health(min(health + healing, max_health))
	animated_sprite.scale = Vector2(1.2, 0.8)
	
	if not Global.is_game_won:
		animated_sprite.play("healed")
		await get_tree().create_timer(1).timeout
		animated_sprite.play("sleeping")
		is_healed = false
	
	
# npc back from the dead
func restore_health(amount: float) -> void:
	# revive npc if dead and health is restored
	if not is_alive:
		AudioManager.play_npc_back_from_dead()
		is_alive = true
		animated_sprite.play("sleeping")
		player_near_timer.stop()
		player_near_timer.set_wait_time(3.0) 
		player_near_timer.one_shot = true
			
	health = min(health + amount, max_health)  # doesn't go beyond max_health
	if healthbar != null:
		healthbar.health = health  # update the health bar


# when isHit timer finishes -> go back to sleeping animation if alive
func _on_hit_timer_timeout():
	if is_alive and not npc_ignore_player:
		animated_sprite.play("hit")
		await get_tree().create_timer(1).timeout
		$isHitAnimation.stop()
		# don't make them go back to sleep after the game is won and they woke up
		if is_alive and not is_player_near and not Global.is_game_won and not is_healed:
			print("go back to sleep")
			animated_sprite.play("sleeping")
		elif is_alive and is_player_near:
			animated_sprite.play("hit_player")

	
func _on_player_near_timeout() -> void:
	# WORKS!!!
	if is_alive and not Global.current_scene_name == 1 and not npc_ignore_player:
		take_damage(2.0, self)
		AudioManager.play_you_hit_npc()
		player_near_timer.start(2.8) # a bit less time to make it slightly harder
		#print("NOTICED THE PLAYER ", health)

	# npc gets damaged 1 hp instead of 2 for the tutorial
	elif is_alive and Global.current_scene_name == 1 and not npc_ignore_player:
		take_damage(1.0, self)
		AudioManager.play_you_hit_npc()
		player_near_timer.start(2.8)
		#print("TUTORIAL: NOTICED THE PLAYER ", health)


func _on_player_re_enter_npc_timeout() -> void:
	if not Global.is_game_won or not Global.is_game_over:
		AudioManager.stop_player_near()
		player_near_timer.stop() # resetting the timer
		player_near_time_remaining = 0.0 # resetting remaining time
		print("SAFE: player away safe", player_near_timer.paused)
