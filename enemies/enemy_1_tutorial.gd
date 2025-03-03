extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 200
var npc: CharacterBody2D
var player: CharacterBody2D
var dead : bool
var send_scripted_enemy2: bool
var scripted_enemy2_move: bool

# waiting time before disappearing for the death animation to play
@export var wait_death_animation = 0.4
@export var enemy_type: String = "enemy2"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash
@onready var camera_control = get_tree().root.get_node("main/CameraControl")
#@onready var scripted_enemy: AnimationPlayer = $scripted_enemy


func _ready() -> void:
	dead = false
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance # reference to npc
	animated_sprite_2d.play("moving")
	#Events.send_scripted_enemy2.connect(send)
	Events.send_scripted_enemy2.connect(_on_send_scripted_enemy2)
	send_scripted_enemy2 = false
	scripted_enemy2_move = false


# chasing the PLAYER
func _physics_process(delta: float) -> void:
	if player and send_scripted_enemy2 and scripted_enemy2_move:
		move_and_collide(velocity * delta)
		look_at(player.position)
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not dead and not player.dashing:
		die()
		
	if body == player and player.dashing and not dead:
		die()
		#hit.play()
		AudioManager.play_hit2()
		AudioManager.play_dash_hit()
		AudioManager.play_stamina_restored()
		camera_control.apply_shake(4, 5)
		player.restore_stamina()
		
	elif body == npc and not dead:
		animated_sprite_2d.play("attack")
		npc.take_damage(1.0, self) # damage the npc, pass self to npc
		dead = true
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "speed", 40.0, 0.3).set_trans(Tween.TRANS_LINEAR)
		
		await get_tree().create_timer(wait_death_animation).timeout
		queue_free()
		

func die():
	AudioManager.play_ghost_dies()
	dead = true
	splash.emitting = true
	animated_sprite_2d.play("dies")
	AudioManager.play_hit2()
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
	Global.score += 10
	await get_tree().create_timer(wait_death_animation).timeout
	queue_free()  # remove the enemy from the scene
	Events.killed_scripted_enemy2.emit()
	Events.send_scripted_enemy3.emit()
	#if player.dashing:
		#print("lmaodasdf")
		#player.dash_hit.play()
		#player.restore_stamina()
		#camera_control.apply_shake(4, 5)
	
	
func _on_send_scripted_enemy2():
	send_scripted_enemy2 = true
	scripted_enemy2_move = true
	print("sending second eeeeeeeeee")
	await get_tree().create_timer(2.7, false).timeout
	# making enemy 2 stop for the player to hit it
	scripted_enemy2_move = false
	
