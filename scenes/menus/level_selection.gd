extends Control

#@onready var 2: Button = %Level_2
#@onready var 3: Button = %Level_3
@onready var level_select: Control = $"."
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var v_box_infinite_night: VBoxContainer = $VBoxInfiniteNight
#@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var personal_best: Label = %PersonalBestNumber
@onready var personal_best_time_label: Label = $BestTime/PersonalBestTime


#func _ready() -> void:
	#for i in range(h_box_container.get_child_count()):
		##i.text = i.name
		#Global.levels.append(i+1)
		#
		#for level in h_box_container.get_children():
			## checking for levels and starting from 1 (since array starts with 0)
			#if str_to_var(level.name) in range(Global.unlocked_levels + 1):
				## connecting the buttons
				#level.mouse_entered.connect(_on_level_hover.bind(level))
				#
				##level.disabled = not (str_to_var(level.name) in range(Global.unlocked_levels + 1))
				##pass
				## don't disable levels 0, 1 by default
				#level.disabled = false
			#else:
				#level.disabled = true
func _ready() -> void:
	for level in h_box_container.get_children():
		
		# connecting the levels to the button hover sound
		if not level.mouse_entered.is_connected(_on_level_hover): # preventing multiple connections
			level.mouse_entered.connect(_on_level_hover.bind(level))
			
		## button pressed sound
		#if not level.pressed.is_connected(_on_level_pressed):
			#level.mouse_entered.connect(_on_level_pressed.bind(level))
		
		# enable or disable based on the number of unlocked levels
		level.disabled = not (str_to_var(level.name) in range(Global.unlocked_levels + 1))

				
	v_box_infinite_night.hide()
	$BestTime.hide()

	if Global.unlocked_levels == 6:
		v_box_infinite_night.show()
		$BestTime.show()


func _process(_delta: float) -> void:
	# show personal best as string for the label
	personal_best.text = str(Global.personal_best)
	
	# storing personal best time as int for later to compare previous time and new time
	#personal_best_time_label.text = "%02d:%02d" % [int(Global.personal_best_time) / 60, int(Global.personal_best_time) % 60]
	
	var best_time = int(Global.personal_best_time)
	personal_best_time_label.text = "%02d:%02d" % [best_time / 60, best_time % 60]

func _on_back_pressed() -> void:
	AudioManager.play_button_pressed()
	get_tree().change_scene_to_file("res://scenes/menus/menu_main.tscn")
	
func _on_back_mouse_entered() -> void:
	AudioManager.play_button_hover()


func _on_1_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_2_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")
	#pass # Replace with function body.


func _on_3_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level3.tscn")



func _on_4_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level4.tscn")


func _on_5_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level5.tscn")


func _on_6_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level6.tscn")
	

# infinite night
func _on_7_infinite_pressed() -> void:
	Global.is_main_menu_music_playing = false
	AudioManager.play_button_pressed()
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level7.tscn")
	

func _on_level_hover(level: Button) -> void:
	if not level.disabled:  # playing the sound only when the button is enabled
		AudioManager.play_button_hover()
		
#func _on_level_pressed(level: Button) -> void:
	#if not level.disabled:  # playing the sound only when the button is enabled
		#AudioManager.play_button_pressed()
