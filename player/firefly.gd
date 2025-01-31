extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 100
var npc: CharacterBody2D
var player: CharacterBody2D
#var dead : bool

# waiting time before disappearing for the death animation to play
#@export var wait_death_animation = 0.4
#@export var enemy_type: String = "enemy2"

#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash
@onready var reachable_sprite: Sprite2D = $ReachableSprite
@onready var sprite: Sprite2D = $Sprite2D
@onready var ran_dir_timer: Timer = $ran_dir_timer
#@onready var pick_up: AudioStreamPlayer2D = $pick_up
@onready var point_light: PointLight2D = $PointLight2D
@onready var hit: AudioStreamPlayer2D = $hit



#var velocity = Vector2.ZERO
var random_direction: Vector2 = Vector2.ZERO
var time = 0
var t = 0.5 # influences moving towards target
var p = 0.5 # influences oscillating


func _ready() -> void:
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance
	$Sprite2D2.visible = false
	#animated_sprite_2d.play("moving")


# chasing the NPC
func _physics_process(delta: float) -> void:
	time += delta
	
	if npc:
		var towards_target = (npc.global_position - global_position).normalized()
		
		var perpendicular = Vector2(towards_target.y, -towards_target.x)
		
		global_position += (t * towards_target + p * perpendicular * sin(time)) * speed * delta
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print("player got the firefly")
		fade_out()
		
	if body == player and player.dashing:
		#pick_up.play()
		hit.play()
		player.restore_stamina() # restore 3 stamina bars
		player.restore_stamina()
		player.restore_stamina()
		splash.emitting = true
		print("yippie")
		Global.score += 10
		
		#fade_out()

	if body == npc and npc.is_alive:
		npc.heal(1)
		npc.healing.play()
		print("firefly got the npc, heal the npc ", npc.health)
		await get_tree().create_timer(1).timeout
		fade_out()
		
	elif body == npc and not npc.is_alive:
		print("don't heal npc", npc.health)
		await get_tree().create_timer(1).timeout
		fade_out()
		
	#elif body == npc and not dead:
		#npc.take_damage(1, self) # damage the npc
		#queue_free()
		
func fade_out():
	var tween: Tween = get_tree().create_tween()
	# transitions and ease for the tweens
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	# tween modulation over 0.5 seconds
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	#tween.tween_property(self, "modulate:a", 0.0, 0.5)
	point_light.energy = lerp(0.3, 0.0, 1)
	# callback when tween finishes
	tween.tween_callback(Callable(self, "finished"))
		
func finished() -> void:
	# delete tween when finished
	queue_free()
		
		
#func die():
	#dead = true
	#splash.emitting = true
	##animated_sprite_2d.play("dies")
	##player.ghost_dies.play()
	#player.hit.play()
	#hit_flash.play("hit_flash")
	#Global.score += 10
	#await get_tree().create_timer(wait_death_animation).timeout
	#queue_free()  # remove the enemy from the scene
	#if player.dashing:
		#player.dash_hit.play()


func _on_reachable_area_body_entered(body: Node2D) -> void:
	if body == player:
		#sprite.material.get_shader_parameter() = false
		#material.get_shader_parameter() = false
		#material.set_shader_param("visible", true)
		#reachable_sprite.visible = true
		$Sprite2D2.visible = true

		
	pass # Replace with function body.


func _on_reachable_area_body_exited(body: Node2D) -> void:
	if body == player:
		#reachable_sprite.visible = false
		$Sprite2D2.visible = false
