extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(_event: InputEvent) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("screenshot"):
		var img = get_viewport().get_texture().get_image()
		img.save_png("user://debug_screenshot.png")
		print("took screenshot")
