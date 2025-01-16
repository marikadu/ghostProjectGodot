extends CharacterBody2D

@onready var healthbar = get_tree().root.get_node("main/HealthBar")
@onready var npc = get_tree().root.get_node("main/NPC")
@onready var npc_area = $Area2DNPC
@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_flash = $AnimatedSprite2D/HitFlash
@onready var hit_timer = $isHitAnimation

var health: int
var is_alive: bool = true

func _ready():
	health = 10
	is_alive = true

	if healthbar != null:
		healthbar.init_health(health)

	if npc_area:
		npc_area.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))

	if hit_timer:
		hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))

func set_health(value: int):
	if not is_alive:
		# doesn't update when is dead / when game over
		return  
		

	health = value
	if health <= 0:
		health = 0
		is_alive = false
		print("NPC died")
		print("GAME OVER")
	else:
		print("NPC health: %d" % health)

	if healthbar != null:
#		if the healthbar is active -> update it
		healthbar.health = health

# enemy collision (doesn't work for some reason)
func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		take_damage(1)  # Reduce health by 1 when an enemy touches the NPC

# take damage (works)
func take_damage(damage: int):
	animated_sprite.play("hit")
	hit_flash.play("hit_flash")

#	update health
	set_health(health - damage)

	if hit_timer:
		hit_timer.start()

# when isHit timer finishes -> go back to sleeping animation if alive
func _on_hit_timer_timeout():
	print("Hit animation finished")
	if is_alive:
		animated_sprite.play("sleeping")
