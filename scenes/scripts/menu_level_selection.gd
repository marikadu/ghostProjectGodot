extends Control

#@onready var 2: Button = %Level_2
#@onready var 3: Button = %Level_3
@onready var level_select: Control = $"."
@onready var h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer


func _ready() -> void:
	for i in range(h_box_container.get_child_count()):
		#i.text = i.name
		Global.levels.append(i+1)
		
		for level in h_box_container.get_children():
			# checking for levels and starting from 1 (since array starts with 0)
			if str_to_var(level.name) in range(Global.unlocked_levels + 1):
				#pass
				# don't disable levels 0, 1 by default
				level.disabled = false
			else:
				level.disabled = true


func _on_back_pressed() -> void:
	print("back")
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")


func _on_1_pressed() -> void:
	print("level 1 selected")
	get_tree().change_scene_to_file("res://scenes/level1.tscn")


func _on_2_pressed() -> void:
	print("level 2 selected")
	pass # Replace with function body.


func _on_3_pressed() -> void:
	print("level 3 selected")
	pass # Replace with function body.
