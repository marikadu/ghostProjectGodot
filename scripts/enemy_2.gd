extends CharacterBody2D

var speed = 200
var npc: Node2D
var player: Node2D
@onready var detection_area: Area2D = $Area2D  # Reference to the Area2D node

func _ready() -> void:
	# Replace "main/GhostPlayer" with the actual path to the GhostPlayer node in your scene tree
	player = get_tree().root.get_node("main/GhostPlayer")
	npc = get_tree().root.get_node("main/NPC")
	if not npc:
		print("NPC not found in the scene tree!")

func _physics_process(_delta: float) -> void:
	if npc:
		var direction = (npc.position - position).normalized()
		velocity = direction * speed
		look_at(npc.position)
		#move_and_collide(velocity * delta)
		move_and_slide()

		# Move the enemy and check for collisions
		#var collision = move_and_collide(velocity * delta)
		#if collision:
			#handle_collision(collision)

#func handle_collision(collision: KinematicCollision2D) -> void:
	#if collision.get_collider() == player:
		#print("Enemy collided with the player!")
		#queue_free()  # Removes the enemy from the scene


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print("Enemy overlapped with the player!")
		queue_free()  # Removes the enemy from the scene
		
	elif body == npc:
		print("got the NPC")
		queue_free()
	pass # Replace with function body.
