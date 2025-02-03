extends CharacterBody2D

var speed = 100
var npc: CharacterBody2D
var player: CharacterBody2D

#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var splash: CPUParticles2D = $splash
@onready var sprite: Sprite2D = $Sprite2D
@onready var ran_dir_timer: Timer = $ran_dir_timer
@onready var point_light: PointLight2D = $PointLight2D
@onready var hit: AudioStreamPlayer2D = $hit



var random_direction: Vector2 = Vector2.ZERO
var time = 0
var t = 0.5 # influences moving towards target
var p = 0.5 # influences oscillating
var picked_up: bool # created to make it not happen that
# player got the firefly and it instantly healed the npc


func _ready() -> void:
	picked_up = false
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance


# chasing the NPC
func _physics_process(delta: float) -> void:
	time += delta
	
	if npc:
		var towards_target = (npc.global_position - global_position).normalized()
		
		var perpendicular = Vector2(towards_target.y, -towards_target.x)
		
		global_position += (t * towards_target + p * perpendicular * sin(time)) * speed * delta
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player and not player.dashing and not picked_up:
		print("not caught the firefly")
		picked_up = true
		fade_out()
		
	if body == player and player.dashing and not picked_up:
		hit.play()
		# restore 3 stamina bars
		$stamina_restored.play() # different sound
		player.restore_stamina()
		player.restore_stamina()
		player.restore_stamina()
		splash.emitting = true
		picked_up = true
		print("yippie restore stamina")
		#print("yippie")
		Global.score += 10
		fade_out()
		
	# heal npc once reached
	if body == npc and npc.is_alive and not picked_up:
		npc.heal(1)
		npc.sfx_healing.play()
		print("firefly got the npc, heal the npc ", npc.health)
		await get_tree().create_timer(1).timeout
		picked_up = true
		print("healing npc")
		fade_out()
		
	elif body == npc and not npc.is_alive and not picked_up:
		print("don't heal npc", npc.health)
		await get_tree().create_timer(0.4).timeout
		picked_up = true
		fade_out()
		
		
func fade_out():
	var tween: Tween = get_tree().create_tween()
	# transitions and ease for the tweens
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	# tween modulation over 0.5 seconds
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	point_light.energy = lerp(0.3, 0.0, 1)
	# callback when tween finishes
	tween.tween_callback(Callable(self, "finished"))
		
func finished() -> void:
	# delete tween when finished
	queue_free()
		
		
