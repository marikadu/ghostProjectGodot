extends Node2D



# ---- UI ----
func play_button_hover():
	$button_hover.play()

func play_button_pressed():
	$button_pressed.play()


# --- PLAYER ----
func play_hit():
	$hit.play()

func play_hit2():
	$hit2.play()

func play_dash():
	$dash.play()

func play_dash_hit():
	$dash_hit.play()
	
func play_stamina_restored():
	$stamina_restored.play()
	
func play_ghost_dies():
	$ghost_dies.play()
	

# --- ELLY/SlEEPING HUMAN/NPC ----
func play_player_near():
	$player_near.play()

func stop_player_near():
	$player_near.stop()
	
func play_hit_npc_impact():
	$hit_npc_impact.play()
	
func play_hit_npc_voice():
	$hit_npc_voice.play()
	
func play_npc_died():
	$npc_died.play()
	
func play_npc_back_from_dead():
	$npc_back_from_dead.play()
	
func play_healing():
	$healing.play()

# ---- POSESSED ----
func play_posessed_hit():
	$possessed_hit.play()

func play_posessed_dies():
	$possessed_dies.play()
	
# ---- FIREFLY ----
func play_pick_up():
	$pick_up.play()

func play_firefly_hit():
	$firefly_hit.play()
	
func play_firefly_stamina_restored():
	$firefly_stamina_restored.play()
	
# ---- GAME STATE ----
func play_game_over():
	$game_over.play()
	
func play_win():
	$win.play()
