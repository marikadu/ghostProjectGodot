extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 100
var npc: CharacterBody2D
var player: CharacterBody2D
var dead : bool

# waiting time before disappearing for the death animation to play
@export var wait_death_animation = 0.4
@export var enemy_type: String = "enemy2"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash


func _ready() -> void:
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance
	animated_sprite_2d.play("moving")


# chasing the NPC
func _physics_process(delta: float) -> void:
	if npc:
		var direction = (npc.position - position).normalized()
		velocity = direction * speed
		look_at(npc.position)
		move_and_collide(velocity * delta)
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		die()
		#dead = true
		#animated_sprite_2d.play("dies")
		#hit_flash.play("hit_flash")
		player.ghost_dies.play()
		#player.hit.play()
		#Global.score += 10
		#await get_tree().create_timer(wait_death_animation).timeout
		#queue_free()  # remove the enemy from the scene
		#if player.dashing:
			#player.dash_hit.play()
		
	elif body == npc and not dead:
		npc.take_damage(1.0, self) # damage the npc
		queue_free()
		
		
func die():
	dead = true
	splash.emitting = true
	animated_sprite_2d.play("dies")
	#player.ghost_dies.play()
	player.hit.play()
	hit_flash.play("hit_flash")
	Global.score += 10
	await get_tree().create_timer(wait_death_animation).timeout
	queue_free()  # remove the enemy from the scene
	if player.dashing:
		player.dash_hit.play()
