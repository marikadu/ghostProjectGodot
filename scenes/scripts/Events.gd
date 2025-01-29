extends Node

signal win_game
signal game_over
signal npc_died
signal possessed_defeated
signal possessed_escaped

# --- tutorial signals ---
signal send_scripted_enemy
signal send_scripted_enemy2
signal send_scripted_enemy2_killed
signal npc_is_scared_of_the_player
signal npc_is_scared_of_the_player2
signal possessed_spawned_tutorial
signal start_counting_down


#func _ready() -> void:
	#health_bar.connect("spawn_posessed", event_node, "_on_spawn_posessed")
