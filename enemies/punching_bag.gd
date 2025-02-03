extends CharacterBody2D


var player: CharacterBody2D
var dead : bool
var send_scripted_enemy2: bool
var scripted_enemy2_move: bool

# waiting time before disappearing for the death animation to play
@export var wait_death_animation = 0.4
@export var enemy_type: String = "enemy_dummy"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash
@onready var hit: AudioStreamPlayer2D = $hit
@onready var camera_control = get_tree().root.get_node("MainMenu/CameraControl")


func _ready() -> void:
	player = get_tree().root.get_node("MainMenu/GhostPlayer")
	
	animated_sprite_2d.play("moving")
	send_scripted_enemy2 = true
	scripted_enemy2_move = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not dead:
		die()
		
	if body == player and player.dashing and not dead:
		die()


func die():
	player.ghost_dies.play()
	dead = true
	splash.emitting = true
	animated_sprite_2d.play("dies")
	player.hit.play()
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
	#Global.score += 10
	if player.dashing:
		player.dash_hit.play()
		player.restore_stamina()
		player.stamina_restored.play()
		camera_control.apply_shake(4, 5)
	await get_tree().create_timer(wait_death_animation).timeout
	animated_sprite_2d.play("moving")
	dead = false
	#queue_free()  # remove the enemy from the scene
	
	#Events.killed_scripted_enemy2.emit()
	#Events.send_scripted_enemy3.emit()
	
	
#func _on_send_scripted_enemy2():
	#send_scripted_enemy2 = true
	#scripted_enemy2_move = true
	#print("sending second eeeeeeeeee")
	#await get_tree().create_timer(5.5).timeout
	# making enemy 2 stop for the player to hit it
	#scripted_enemy2_move = false
	
