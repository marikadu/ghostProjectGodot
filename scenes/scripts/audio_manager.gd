extends Node2D

var sound_position: float = 0.0

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
	#$player_near.stream_paused = false # unpause if paused
	if not $player_near.playing:
		$player_near.play()
	$player_near.stream_paused = false # unpause if paused
	
func pause_player_near():
	sound_position = $player_near.get_playback_position()
	$player_near.stream_paused = true
	print("player near: ", sound_position)
	
func unpause_player_near():
	$player_near.stream_paused = false
	$player_near.play(sound_position)
	print("continuing to play sound at:", sound_position)

func stop_player_near():
	print("stopping the audio")
	$player_near.stop()
	sound_position = 0.0 # resetting the position
	#$player_near.stream = null  # resetting the stream
	#if $player_near:
		#$player_near.stop()
		#print("Sound stopped:", !$player_near.playing)
	
		#fade_out($player_near, 1.0) # this works, but if quickly re-entered, the
		# audio doesn't play!
	
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
	
	
	
#func _delayed_stop():
	#fade_out($player_near, 1.0)


#func fade_out(stream_player: AudioStreamPlayer, duration: float = 1.0):
	#var tween = create_tween()
	#tween.tween_property(stream_player, "volume_db", -80, duration).set_trans(Tween.TRANS_LINEAR)
	#
	## when finished, stop the audio
	#await tween.finished
	#stream_player.stop()
	#stream_player.volume_db = 0
