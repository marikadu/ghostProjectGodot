extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 40
var max_speed = 300
var npc: CharacterBody2D
var player: CharacterBody2D
var time_to_max_speed = 2.0 # time to reach the max.speed
var elapsed_time = 0.0  # time tracker for speed increase
var delay_before_acceleration = 2.0 # wait before setting to max.speed
var is_accelerating = false
var dead : bool

# waiting time before disappearing for the death animation to play
@export var wait_death_animation = 0.4
@export var enemy_type: String = "enemy3"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var speed_timer = $SpeedTimer  # timer to control gradual speed change
@onready var splash: CPUParticles2D = $splash
@onready var hit: AudioStreamPlayer2D = $hit
@onready var camera_control = get_tree().root.get_node("main/CameraControl")


func _ready() -> void:
	dead = false
	#var mooving = true
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance
	
	# wait before going to max.speed
	speed_timer.wait_time = delay_before_acceleration
	speed_timer.start()
	animated_sprite_2d.play("moving")
	
	
func _process(delta: float) -> void:
	if is_accelerating:
			elapsed_time += delta
			if elapsed_time <= time_to_max_speed:
				# increase speed linearly over time_to_max_speed
				speed = lerp(10, max_speed, elapsed_time / time_to_max_speed)
			# cap the speed to max when acceleration ends
			else:
				speed = max_speed 
		
			

# chasing the NPC
func _physics_process(delta: float) -> void:
	if npc:
		var direction = (npc.position - position).normalized()
		velocity = direction * speed
		look_at(npc.position)
		move_and_collide(velocity * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not dead and not player.dashing:
		die()
		
	if body == player and player.dashing and not dead:
		die()
		hit.play()
		player.dash_hit.play()
		player.stamina_restored.play()
		camera_control.apply_shake(4, 5)
		player.restore_stamina()
		
	elif body == npc and not dead:
		animated_sprite_2d.play("attack")
		npc.take_damage(1.0, self) # damage the npc
		dead = true
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "speed", 40.0, 0.3).set_trans(Tween.TRANS_LINEAR)
		
		await get_tree().create_timer(wait_death_animation).timeout
		queue_free()
		
		
		
# stopping or pausing speed change
# getting faster after timer has reached 3 seconds
func _on_speed_timer_timeout() -> void:
	#print("Starting acceleration!")
	is_accelerating = true
	#print("Max speed reached: ", speed)
	speed_timer.stop()
	

func die():
	player.ghost_dies.play()
	dead = true
	splash.emitting = true
	animated_sprite_2d.play("dies")
	player.hit.play()
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
	Global.score += 10
	await get_tree().create_timer(wait_death_animation).timeout
	queue_free()  # remove the enemy from the scene
