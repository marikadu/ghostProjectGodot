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
	$stamina_restored.play
	
func play_ghost_dies():
	$ghost_dies.play()
	
# ---- FIREFLY ----
func play_pick_up():
	$pick_up.play()

func play_firefly_hit():
	$firefly_hit.play()
	
func play_firefly_stamina_restored():
	$firefly_stamina_restored.play()
