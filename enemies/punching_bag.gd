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
#@onready var hit: AudioStreamPlayer2D = $hit
@onready var camera_control = get_tree().root.get_node("MainMenu/CameraControl")


func _ready() -> void:
	player = get_tree().root.get_node("MainMenu/GhostPlayer")
	
	animated_sprite_2d.play("moving")
	send_scripted_enemy2 = true
	scripted_enemy2_move = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not dead:
		die()


func die():
	AudioManager.play_ghost_dies()
	AudioManager.play_hit2()
	dead = true
	splash.emitting = true
	animated_sprite_2d.play("dies")
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
	if player.dashing:
		#print("b detected dash")
		AudioManager.play_dash_hit()
		player.restore_stamina()
		AudioManager.play_stamina_restored()
		camera_control.apply_shake(4, 5)
	await get_tree().create_timer(wait_death_animation).timeout
	animated_sprite_2d.play("moving")
	dead = false
	#queue_free()  # remove the enemy from the scene
	
	#Events.killed_scripted_enemy2.emit()
	#Events.send_scripted_enemy3.emit()
	
