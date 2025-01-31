extends Node

signal win_game
signal game_over
signal game_over_woke_up_human
signal npc_died
signal possessed_defeated
signal possessed_escaped

# --- tutorial signals ---
signal send_scripted_enemy

signal send_scripted_enemy2
signal killed_scripted_enemy2

signal send_scripted_enemy3
signal killed_scripted_enemy3

signal npc_is_scared_of_the_player
signal npc_is_scared_of_the_player2

signal introduce_fireflies

signal start_counting_down

signal win_game_tutorial


#func _ready() -> void:
	#health_bar.connect("spawn_posessed", event_node, "_on_spawn_posessed")
