extends SceneTree
## S342 MOVEPLAYER1 probe (Round 2): builds MovePlayer, for each of 5 move ids calls show_move(id),
## lets it play once, and prints:
##   MOVEPLAYER <id> clips=<n> played=<n> gap=<m> ghost_alpha=<a> her_alpha=<a>
##   MOVEPLAYER <id> reach=<m>  (for punch moves: glove to ghost's head at contact, PASS <= 0.12)
##   MOVEPLAYER <id> min_gap=<m>  (pelvis gap over the whole move, PASS >= 0.45 outside clinch)
## Then MOVEPLAYER OK <n>/5 counting moves where played == clips (> 0),
## |gap - the from-card's range middle| <= 0.12 m, ghost_alpha <= 0.45, her_alpha == 1.0,
## reach <= 0.12 (for punches), min_gap >= 0.45 (outside clinch).
## Headless: $GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/moveplayer_probe.gd

const MovePlayer := preload("res://scripts/fight3d/MovePlayer.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")

const MOVE_IDS := ["1-1", "1-2-3", "step_back", "tie_up", "pivot_out"]
const PLAY_TIME_S := 8.0
const GAP_TOLERANCE_M := 0.12
const GHOST_ALPHA_MAX := 0.45
const REACH_PASS_M := 0.12
const MIN_GAP_PASS_M := 0.45


func _initialize() -> void:
	var player := MovePlayer.new()
	root.add_child(player)
	await player.ready
	for i in 5:
		await process_frame
	var passed := 0
	for move_id in MOVE_IDS:
		var result := await _test_move(player, move_id)
		if result["pass"]:
			passed += 1
		var has_punch: bool = result["has_punch"]
		var is_clinch: bool = result["is_clinch"]
		print("MOVEPLAYER %s clips=%d played=%d gap=%.3f ghost_alpha=%.2f her_alpha=%.1f %s" % [
			move_id,
			result["clips"],
			result["played"],
			result["gap"],
			result["ghost_alpha"],
			result["her_alpha"],
			"PASS" if result["pass"] else "FAIL"
		])
		if has_punch:
			print("MOVEPLAYER %s reach=%.3f %s" % [
				move_id,
				result["reach"],
				"PASS" if result["reach"] <= REACH_PASS_M else "FAIL"
			])
		if not is_clinch:
			print("MOVEPLAYER %s min_gap=%.3f %s" % [
				move_id,
				result["min_gap"],
				"PASS" if result["min_gap"] >= MIN_GAP_PASS_M else "FAIL"
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
	elif from_id in ["own_ropes", "opp_ropes", "corner"]:
		expected_gap = 0.9
	elif from_id == "clinch":
		expected_gap = 0.225
	else:
		expected_gap = 0.6
	# S345: a punch combination starts at the pair's own jab gap (where the fight throws it), not the card's middle.
	if str(mv.get("kind", "")) == "combo":
		expected_gap = player.jab_gap()
	player.show_move(move_id)
	# Let it play
	var elapsed := 0.0
	var frame_t := 1.0 / 60.0
	while elapsed < PLAY_TIME_S:
		await process_frame
		elapsed += frame_t
	# Gather results
	var played: Array = player.played_clips()
	var gap: float = player.pelvis_gap()
	var ghost_a: float = player.ghost_alpha()
	var her_a: float = player.her_alpha()
	var reach: float = player.reach_at_contact()
	var min_g: float = player.min_gap()
	# Check if any clip is a punch
	var has_punch := false
	for c in clips:
		var cn := str(c)
		if cn.contains("jab") or cn.contains("cross") or cn.contains("hook") or cn.contains("uppercut") or cn.contains("body"):
			has_punch = true
			break
	var is_clinch := from_id == "clinch"
	# Check pass conditions
	var clips_ok := played.size() == clips.size() and clips.size() > 0
	var gap_ok := absf(gap - expected_gap) <= GAP_TOLERANCE_M
	var ghost_ok := ghost_a <= GHOST_ALPHA_MAX
	var her_ok := her_a == 1.0
	var reach_ok := true
	if has_punch:
		reach_ok = reach <= REACH_PASS_M
	var min_gap_ok := true
	if not is_clinch:
		min_gap_ok = min_g >= MIN_GAP_PASS_M
	var ok := clips_ok and gap_ok and ghost_ok and her_ok and reach_ok and min_gap_ok
	return {
		"clips": clips.size(),
		"played": played.size(),
		"gap": gap,
		"ghost_alpha": ghost_a,
		"her_alpha": her_a,
		"reach": reach,
		"min_gap": min_g,
		"has_punch": has_punch,
		"is_clinch": is_clinch,
		"pass": ok
	}
