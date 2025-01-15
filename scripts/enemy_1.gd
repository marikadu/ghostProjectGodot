extends CharacterBody2D

var speed = 200
var player: Node2D

func _ready() -> void:
	# Replace "main/GhostPlayer" with the actual path to the GhostPlayer node in your scene tree
	player = get_tree().root.get_node("main/GhostPlayer")
	if not player:
		print("GhostPlayer not found in the scene tree!")

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		look_at(player.position)
		move_and_collide(velocity * delta)

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
	pass # Replace with function body.
