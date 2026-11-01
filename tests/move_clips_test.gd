extends SceneTree
## MoveClips test: every StrikeMap move has clips, every clip name resolves,
## combos have enough punch clips, unknown ids return empty, missing() works.

const SM := preload("res://scripts/rules/StrikeMap.gd")
const C := preload("res://scripts/rules/Combos.gd")
const FC := preload("res://scripts/fight3d/FightClips.gd")
const MC := preload("res://scripts/fight3d/MoveClips.gd")

var failures := 0


func _initialize() -> void:
	var valid := _build_valid_set()
	_test_1_every_move_has_clips()
	_test_2_every_clip_resolves(valid)
	_test_3_combo_punch_counts()
	_test_4_unknown_id()
	_test_5_missing()
	if failures == 0:
		print("PASS move_clips_test")
	else:
		print("FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)


func _build_valid_set() -> Dictionary:
	var out := {}
	for name in FC.CLIPS:
		out[name] = true
	for role in FC.BAKED:
		out[str(FC.BAKED[role])] = true
	for name in FC.PAIR:
		out[str(name)] = true
	for stem in FC.pro_stems():
		out[FC.pro_name(stem)] = true
	return out


func _is_punch_clip(name: String) -> bool:
	if name in ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]:
		return true
	if name.begins_with("pro_"):
		for w in ["jab", "cross", "hook", "uppercut"]:
			if name.contains(w):
				for bad in ["hit_by", "hurt", "dodge", "weave", "block", "idle", "knockout", "win", "fidget", "kidney", "countdown"]:
					if name.contains(bad):
						return false
				return true
	return false


func _count_punches_in_combo(combo_id: String) -> int:
	var row := C.row(combo_id)
	if row.is_empty():
		return 0
	return int(row["beats"].size())


func _test_1_every_move_has_clips() -> void:
	var ok := true
	for m in SM.MOVES:
		var mid := str(m["id"])
		var clips := MC.clips(mid)
		if clips.is_empty():
			ok = false
			print("  FAIL move '%s' has no clips" % mid)
			failures += 1
	_check(ok, "every StrikeMap move has a non-empty clip list")


func _test_2_every_clip_resolves(valid: Dictionary) -> void:
	var ok := true
	for m in SM.MOVES:
		var mid := str(m["id"])
		for clip_name in MC.clips(mid):
			if not valid.has(str(clip_name)):
				ok = false
				print("  FAIL move '%s' clip '%s' not in valid set" % [mid, str(clip_name)])
				failures += 1
	_check(ok, "every clip name resolves (CLIPS/BAKED/PAIR/pro_)")


func _test_3_combo_punch_counts() -> void:
	var ok := true
	for m in SM.MOVES:
		if str(m["kind"]) != "combo":
			continue
		var mid := str(m["id"])
		var combo_id := str(m["combo"])
		var expected := _count_punches_in_combo(combo_id)
		if expected == 0:
			continue
		var clips := MC.clips(mid)
		var punch_count := 0
		for c in clips:
			if _is_punch_clip(str(c)):
				punch_count += 1
		if punch_count < expected:
			ok = false
			print("  FAIL move '%s' has %d punch clips, needs %d" % [mid, punch_count, expected])
			failures += 1
	_check(ok, "every combo move has enough punch clips")


func _test_4_unknown_id() -> void:
	var result := MC.clips("nope")
	_check(result.is_empty(), "clips('nope') is empty")


func _test_5_missing() -> void:
	var all_names: Array = []
	for m in SM.MOVES:
		for c in MC.clips(str(m["id"])):
			if not all_names.has(str(c)):
				all_names.append(str(c))
	var result := MC.missing(all_names)
	_check(result.is_empty(), "missing(<all used names>) is empty")
