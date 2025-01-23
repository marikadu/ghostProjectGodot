extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 100
var npc: CharacterBody2D
var player: CharacterBody2D

#@onready var ghost_dies: AudioStreamPlayer2D = $ghost_dies


func _ready() -> void:
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = Global.npc_instance


# chasing the NPC
func _physics_process(delta: float) -> void:
	if npc:
		var direction = (npc.position - position).normalized()
		velocity = direction * speed
		look_at(npc.position)
		move_and_collide(velocity * delta)
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.ghost_dies.play()
		player.hit.play()
		Global.score += 10
		queue_free()  # remove the enemy from the scene
		if player.dashing:
			player.dash_hit.play()
		
	elif body == npc:
		npc.take_damage(1) # damage the npc
		queue_free()
