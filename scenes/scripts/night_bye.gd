extends Sprite2D

@onready var newhouse_n: Sprite2D = %newhouse_n

@export var time = 15.0
@export var wait_before_sunrise = 29.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#newhouse_n.self_modulate.a = 0.5
	
	# wait for some time before sunrise
	await get_tree().create_timer(wait_before_sunrise).timeout
	fade_out()
	#pass
	
	
func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(newhouse_n, "modulate:a", 0, time)
	tween.play()
	await tween.finished
	tween.kill()
