extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 200
var player: CharacterBody2D
var dead : bool
var vfx = preload("res://scenes/vfx.tscn")
var vfx_instance

@export var enemy_type: String = "orial"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash
@onready var hit: AudioStreamPlayer2D = $hit
@onready var camera_control = get_tree().root.get_node("main/CameraControl")
@onready var movement: AnimationPlayer = $movement



func _ready() -> void:
	player = get_tree().root.get_node("main/GhostPlayer")
	animated_sprite_2d.play("left")
	movement.play("appear")
	await get_tree().create_timer(2.3).timeout
	animated_sprite_2d.play("idle")
	#(-98, 642)


## chasing the player
#func _physics_process(delta: float) -> void:
	#if player:
		#var direction = (player.position - position).normalized()
		#velocity = direction * speed
		#look_at(player.position)
		#move_and_collide(velocity * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not dead and not player.dashing:
		die()
		
	if body == player and player.dashing and not dead:
		die()
		hit.play()
		player.dash_hit.play()
		camera_control.apply_shake(4, 5)
		player.restore_stamina()


func die():
	player.ghost_dies.play()
	dead = true
	splash.emitting = true
	animated_sprite_2d.play("hit")
	player.hit.play()
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
	await get_tree().create_timer(0.6).timeout
	dead = false
	animated_sprite_2d.play("idle")
	
	#queue_free()  # remove the enemy from the scene
