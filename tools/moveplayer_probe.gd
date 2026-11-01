extends SceneTree
## S342 MOVEPLAYER1 probe: builds MovePlayer, for each of 5 move ids calls show_move(id),
## lets it play once, and prints MOVEPLAYER <id> clips=<n> played=<n> gap=<m> ghost_alpha=<a> her_alpha=<a>.
## Then MOVEPLAYER OK <n>/5 counting moves where played == clips (> 0),
## |gap - the from-card's range middle| <= 0.12 m, ghost_alpha <= 0.45 and her_alpha == 1.0.
## Headless: $GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/moveplayer_probe.gd

const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")

const MOVE_IDS := ["1-1", "1-2-3", "step_back", "tie_up", "pivot_out"]
const PLAY_TIME_S := 8.0  # seconds to let each move play (enough for all clips to finish)
const GAP_TOLERANCE_M := 0.12
const GHOST_ALPHA_MAX := 0.45


func _initialize() -> void:
	var player := MovePlayer.new()
	root.add_child(player)
	await player.ready
	# Wait a few frames for the bodies to load
	for i in 5:
		await process_frame
	var passed := 0
	for move_id in MOVE_IDS:
		var result := await _test_move(player, move_id)
		if result["pass"]:
			passed += 1
		print("MOVEPLAYER %s clips=%d played=%d gap=%.3f ghost_alpha=%.2f her_alpha=%.1f %s" % [
			move_id,
			result["clips"],
			result["played"],
			result["gap"],
			result["ghost_alpha"],
			result["her_alpha"],
			"PASS" if result["pass"] else "FAIL"
		])
	print("MOVEPLAYER OK %d/%d" % [passed, MOVE_IDS.size()])
	quit(0 if passed == MOVE_IDS.size() else 1)


func _test_move(player: Node, move_id: String) -> Dictionary:
	var clips := MoveClips.clips(move_id)
	var mv := SM.move(move_id)
	var from_id := str(mv.get("from", ""))
	var card := SM.card(from_id)
	var range_m: Array = card.get("range_m", [])
	var expected_gap: float
	if range_m.size() >= 2:
		expected_gap = (float(range_m[0]) + float(range_m[1])) * 0.5
	elif from_id == "clinch":
		expected_gap = 0.225
	else:
		expected_gap = 0.6  # DEFAULT_RANGE_M
	player.show_move(move_id)
	# Let it play
	var elapsed := 0.0
	var frame_t := 1.0 / 60.0  # assume 60 fps
	while elapsed < PLAY_TIME_S:
		await process_frame
		elapsed += frame_t
	# Gather results
	var played: Array = player.played_clips()
	var gap: float = player.pelvis_gap()
	var ghost_a: float = player.ghost_alpha()
	var her_a: float = player.her_alpha()
	# Check pass conditions
	var clips_ok := played.size() == clips.size() and clips.size() > 0
	var gap_ok := absf(gap - expected_gap) <= GAP_TOLERANCE_M
	var ghost_ok := ghost_a <= GHOST_ALPHA_MAX
	var her_ok := her_a == 1.0
	var ok := clips_ok and gap_ok and ghost_ok and her_ok
	return {
		"clips": clips.size(),
		"played": played.size(),
		"gap": gap,
		"ghost_alpha": ghost_a,
		"her_alpha": her_a,
		"pass": ok
	}
