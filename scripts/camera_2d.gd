extends Camera2D

@onready var player = get_tree().root.get_node("main/GhostPlayer")

# Settings to control how much the camera follows the player
@export var follow_strength: float = 0.1  # Higher values = more follow
@export var off: Vector2 = Vector2(0, 0)  # Optional offset for fine-tuning the camera position

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	if player == null:
		print("Player node not found! Check the path.")  # Optional debug print to help diagnose issues

# Called every frame
func _process(delta: float) -> void:
	if player != null:  # Ensure the player is valid before trying to access its position
		# Calculate the desired position for the camera (player position with offset)
		var target_position = player.position + off

		# Optionally, lock the camera movement to specific axes
		#target_position.x = position.x + follow_strength  # Lock x-axis movement (camera follows only y-axis)
		#target_position.y = position.y + follow_strength # Uncomment this line to lock on the y-axis instead

		# Smoothly move the camera toward the target position
		position = position.lerp(target_position, follow_strength)
	else:
		print("Player node is not assigned properly!")  # Optional debug print
