extends CharacterBody2D
# if I enable layer 1 or mask 1, the enemy stops when it reaches the player

var speed = 100
var npc: CharacterBody2D
var player: CharacterBody2D

func _ready() -> void:

	player = get_tree().root.get_node("main/GhostPlayer")
	call_deferred("_initialize")

func _initialize():
	npc = get_node_or_null("main/NPC")
	if npc:
		print("NPC found: ", npc.name)
	else:
		print("NPC not found")

# chasing the NPC
func _physics_process(delta: float) -> void:
	if npc:
		var direction = (npc.position - position).normalized()
		velocity = direction * speed
		look_at(npc.position)
		move_and_collide(velocity * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		#print("Player got the enemy")
		queue_free()  # remove the enemy from the scene
		
	elif body == npc:
		#print("2got the NPC")
		npc.take_damage(1) # damage the npc
		queue_free()
