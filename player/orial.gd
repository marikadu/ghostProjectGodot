extends CharacterBody2D

var speed = 200
var player: CharacterBody2D
var dead: bool
var moving: bool
var moving_direction: String
var vfx = preload("res://scenes/vfx.tscn")
var vfx_instance

@export var enemy_type: String = "orial"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash
@onready var camera_control = get_tree().root.get_node("main/CameraControl")
@onready var movement: AnimationPlayer = $movement



func _ready() -> void:
	player = get_tree().root.get_node("main/GhostPlayer")
	animated_sprite_2d.play("left")
	movement.play("appear")
	await get_tree().create_timer(2.7, false).timeout
	moving_direction = "idle"
	animated_sprite_2d.play("idle")
	Events.tutorial_start.emit()
	Events.npc_is_scared_of_the_player2.connect(_on_show_human)
	Events.introduce_fireflies.connect(_on_introduce_fireflies)
	Events.win_game_tutorial.connect(_on_win_game)
	
	Events.game_over_woke_up_human.connect(_on_game_over)
	Events.game_over.connect(_on_game_over)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not dead and not player.dashing:
		die()
		
	if body == player and player.dashing and not dead:
		die()
		AudioManager.play_dash_hit()
		camera_control.apply_shake(4, 5)
		player.restore_stamina()


func die():
	AudioManager.play_ghost_dies()
	dead = true
	splash.emitting = true

	# different reaction based on the direction where
	# Orial is moving
	if moving_direction == "idle":
		animated_sprite_2d.play("hit")
	elif moving_direction == "left_up":
		animated_sprite_2d.play("left_up_hit")
	elif moving_direction == "left":
		animated_sprite_2d.play("left_hit")
	
	AudioManager.play_hit2()
	if Graphics.flash_when_hit_effect:
		hit_flash.play("hit_flash")
	await get_tree().create_timer(0.6, false).timeout
	dead = false
	# back to the moving direction to make the reaction
	# and movement more natural
	if moving_direction == "idle":
		animated_sprite_2d.play("idle")
	elif moving_direction == "left_up":
		animated_sprite_2d.play("left_up")
	elif moving_direction == "left":
		animated_sprite_2d.play("left")

	
func _on_show_human():
	moving = true
	animated_sprite_2d.play("left_up")
	moving_direction = "left_up"
	movement.play("show_human")
	await get_tree().create_timer(2.3, false).timeout
	animated_sprite_2d.play("idle")
	moving_direction = "idle"
	moving = false


func _on_introduce_fireflies():
	await get_tree().create_timer(3, false).timeout
	moving = true
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("left_up")
	moving_direction = "left_up"
	movement.play("fireflies")
	await get_tree().create_timer(1.6, false).timeout
	animated_sprite_2d.play("idle")
	animated_sprite_2d.flip_h = false
	moving_direction = "idle"
	moving = false


func _on_win_game():
	await get_tree().create_timer(3, false).timeout
	moving = true
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("left")
	moving_direction = "left"
	movement.play("bye")
	await get_tree().create_timer(3, false).timeout
	moving = false
	queue_free()
	
	
func _on_game_over():
	animated_sprite_2d.play("game_over")
