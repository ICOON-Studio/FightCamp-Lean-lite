extends SceneTree
## HabitBeats (fight model step 5): over 200 seeds each:
##   1. landed counts are preserved by apply, 2. beats stay sorted by t and the last beat is unchanged,
##   3. every playable habit fires at least once and never more than MAX_FIRES in one round,
##   4. digs_body_when_hurt increases her body_hook count, 5. slow_starter reduces round-1 first-quarter
##      punches and leaves round 2 alone, 6. fades_late adds a tired beat in round 3's last third and
##      never fires in round 1, 7. b's habits never rewrite a's beats except drops_right_after_jab,
##   8. unknown habit ids are silently ignored.

const RS := preload("res://scripts/rules/RoundScript.gd")
const HB := preload("res://scripts/rules/HabitBeats.gd")

var failures := 0
const SEEDS := 200
const ALL_HABITS: Array = [
	"drops_right_after_jab", "digs_body_when_hurt", "loads_up_when_hurt",
	"covers_up_when_hurt", "wide_hook_tell", "slow_starter", "fades_late",
	"admires_her_work", "one_and_done", "talks_when_ahead", "lunges_with_jab",
	"retreats_straight_back",
]


func _initialize() -> void:
	_test_1_landed()
	_test_2_sorted_last()
	_test_3_fires()
	_test_4_digs_body()
	_test_5_slow_starter()
	_test_6_fades_late()
	_test_7_b_habits()
	_test_8_unknown()
	print("HABIT_BEATS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _round(n: int, won: bool) -> Dictionary:
	return {"n": n, "won": won, "mine": 60.0, "theirs": 61.0, "corner": "", "lines": ["A.", "B.", "C."]}


func _build(n: int, seed: int) -> Dictionary:
	return RS.build(_round(n, true), "Out-boxer", "Pressure fighter", 40.0, seed)


func _ctx() -> Dictionary:
	return {"won_last": {"a": true, "b": true}}


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _is_punch(move: String) -> bool:
	return move != "step_in" and move != "step_out" and move != "tired" and move != "count"


## 1. Landed counts preserved for every habit on each side, and with all habits on both.
func _test_1_landed() -> void:
	var ok := true
	for s in SEEDS:
		for n in [1, 2, 3]:
			var sc := _build(n, s)
			var before: Dictionary = RS.landed(sc)
			var rng := RandomNumberGenerator.new()
			rng.seed = s
			HB.apply(sc, {"a": ALL_HABITS, "b": ALL_HABITS}, _ctx(), rng)
			var after: Dictionary = RS.landed(sc)
			if int(before["a"]) != int(after["a"]) or int(before["b"]) != int(after["b"]):
				ok = false
	for side in ["a", "b"]:
		for hid in ALL_HABITS:
			for s in SEEDS:
				var sc := _build(2, s)
				var before: Dictionary = RS.landed(sc)
				var rng := RandomNumberGenerator.new()
				rng.seed = s
				var hab: Dictionary = {"a": [], "b": []}
				hab[side] = [hid]
				HB.apply(sc, hab, _ctx(), rng)
				var after: Dictionary = RS.landed(sc)
				if int(before["a"]) != int(after["a"]) or int(before["b"]) != int(after["b"]):
					ok = false
	_check(ok, "landed count preserved for all habits over %d seeds" % SEEDS)


## 2. Beats stay sorted by t; the last beat is unchanged.
func _test_2_sorted_last() -> void:
	var ok_sorted := true
	var ok_last := true
	for s in SEEDS:
		for n in [1, 2, 3]:
			var sc := _build(n, s)
			var last_t: float = float(sc["beats"][-1]["t"])
			var last_who: String = str(sc["beats"][-1]["who"])
			var last_move: String = str(sc["beats"][-1]["move"])
			var last_result: String = str(sc["beats"][-1]["result"])
			var rng := RandomNumberGenerator.new()
			rng.seed = s
			HB.apply(sc, {"a": ALL_HABITS, "b": ALL_HABITS}, _ctx(), rng)
			var beats: Array = sc["beats"]
			for i in range(1, beats.size()):
				if float(beats[i]["t"]) <= float(beats[i - 1]["t"]):
					ok_sorted = false
					break
			var lb: Dictionary = beats[-1]
			if float(lb["t"]) != last_t or str(lb["who"]) != last_who or str(lb["move"]) != last_move or str(lb["result"]) != last_result:
				ok_last = false
	_check(ok_sorted, "beats stay sorted by t after apply")
	_check(ok_last, "last beat is unchanged after apply")


## 3. Each playable habit fires at least once over 200 seeds and never more than MAX_FIRES in one round.
func _test_3_fires() -> void:
	for hid in ALL_HABITS:
		var fired := false
		var max_ok := true
		var rn: int = 2
		if hid == "slow_starter":
			rn = 1
		elif hid == "fades_late":
			rn = 3
		for s in SEEDS:
			var sc := _build(rn, s)
			var rng := RandomNumberGenerator.new()
			rng.seed = s
			var fires: Array = HB.apply(sc, {"a": [hid], "b": []}, _ctx(), rng)
			var side_fires: int = 0
			for f in fires:
				if str(f["who"]) == "a" and str(f["habit"]) == str(hid):
					side_fires += 1
			if side_fires > 0:
				fired = true
			if side_fires > HB.MAX_FIRES:
				max_ok = false
		_check(fired, "'%s' fires at least once in %d seeds" % [hid, SEEDS])
		_check(max_ok, "'%s' never fires more than %d in one round" % [hid, HB.MAX_FIRES])


## 4. digs_body_when_hurt: her body_hook count after > before over all seeds.
func _test_4_digs_body() -> void:
	var total_before := 0
	var total_after := 0
	for s in SEEDS:
		var sc := _build(2, s)
		for b in sc["beats"]:
			if str(b["who"]) == "a" and str(b["move"]) == "body_hook":
				total_before += 1
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		HB.apply(sc, {"a": ["digs_body_when_hurt"], "b": []}, _ctx(), rng)
		for b in sc["beats"]:
			if str(b["who"]) == "a" and str(b["move"]) == "body_hook":
				total_after += 1
	_check(total_after > total_before, "digs_body_when_hurt: a body_hook after (%d) > before (%d)" % [total_after, total_before])


## 5. slow_starter: round 1 fewer a punches in first quarter; round 2 unchanged.
func _test_5_slow_starter() -> void:
	var fq: float = 40.0 * 0.25
	var total_before := 0
	var total_after := 0
	for s in SEEDS:
		var sc := _build(1, s)
		for b in sc["beats"]:
			if str(b["who"]) == "a" and _is_punch(str(b["move"])) and float(b["t"]) <= fq:
				total_before += 1
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		HB.apply(sc, {"a": ["slow_starter"], "b": []}, _ctx(), rng)
		for b in sc["beats"]:
			if str(b["who"]) == "a" and _is_punch(str(b["move"])) and float(b["t"]) <= fq:
				total_after += 1
	_check(total_after < total_before, "slow_starter: round 1 fewer a punches in first quarter (%d < %d)" % [total_after, total_before])
	var ok := true
	for s in SEEDS:
		var sc1 := _build(2, s)
		var sc2 := _build(2, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		HB.apply(sc2, {"a": ["slow_starter"], "b": []}, _ctx(), rng)
		if sc1["beats"].size() != sc2["beats"].size():
			ok = false
			break
		for i in sc1["beats"].size():
			var b1: Dictionary = sc1["beats"][i]
			var b2: Dictionary = sc2["beats"][i]
			if str(b1["move"]) != str(b2["move"]) or str(b1["result"]) != str(b2["result"]) or str(b1["who"]) != str(b2["who"]):
				ok = false
				break
		if not ok:
			break
	_check(ok, "slow_starter: round 2 is unchanged")


## 6. fades_late: round 3 has a tired beat for her in the last third every seed; round 1 never.
func _test_6_fades_late() -> void:
	var lt: float = 40.0 * 2.0 / 3.0
	var ok_r3 := true
	for s in SEEDS:
		var sc := _build(3, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		HB.apply(sc, {"a": ["fades_late"], "b": []}, _ctx(), rng)
		var has_t := false
		for b in sc["beats"]:
			if str(b["who"]) == "a" and str(b["move"]) == "tired" and float(b["t"]) >= lt:
				has_t = true
				break
		if not has_t:
			ok_r3 = false
			break
	_check(ok_r3, "fades_late: round 3 has a tired beat for a in last third every seed")
	var ok_r1 := true
	for s in SEEDS:
		var sc := _build(1, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		var fires: Array = HB.apply(sc, {"a": ["fades_late"], "b": []}, _ctx(), rng)
		for f in fires:
			if str(f["habit"]) == "fades_late":
				ok_r1 = false
				break
		if not ok_r1:
			break
	_check(ok_r1, "fades_late: round 1 never gets a tired beat from it")


## 7. b's habits never rewrite a's beats except drops_right_after_jab.
func _test_7_b_habits() -> void:
	var no_cross: Array = ALL_HABITS.duplicate()
	no_cross.erase("drops_right_after_jab")
	var ok := true
	for hid in no_cross:
		for s in SEEDS:
			var sc := _build(2, s)
			var a_before: Array = []
			for b in sc["beats"]:
				if str(b["who"]) == "a":
					a_before.append({"move": str(b["move"]), "result": str(b["result"])})
			var rng := RandomNumberGenerator.new()
			rng.seed = s
			HB.apply(sc, {"a": [], "b": [hid]}, _ctx(), rng)
			var a_after: Array = []
			for b in sc["beats"]:
				if str(b["who"]) == "a":
					a_after.append({"move": str(b["move"]), "result": str(b["result"])})
			if a_before.size() != a_after.size():
				ok = false
				break
			for i in a_before.size():
				if str(a_before[i]["move"]) != str(a_after[i]["move"]) or str(a_before[i]["result"]) != str(a_after[i]["result"]):
					ok = false
					break
			if not ok:
				break
		if not ok:
			break
	_check(ok, "b's habits (except drops_right) never rewrite a's beats")
	var drops_ok := false
	for s in SEEDS:
		var sc := _build(2, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		HB.apply(sc, {"a": [], "b": ["drops_right_after_jab"]}, _ctx(), rng)
		for b in sc["beats"]:
			if str(b["who"]) == "a" and b.has("habit") and str(b["habit"]) == "drops_right_after_jab":
				drops_ok = true
				break
		if drops_ok:
			break
	_check(drops_ok, "drops_right_after_jab from b rewrites a's punch")


## 8. Unknown habit ids are ignored (no error, no change).
func _test_8_unknown() -> void:
	var ok := true
	for s in SEEDS:
		var sc1 := _build(2, s)
		var sc2 := _build(2, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		HB.apply(sc2, {"a": ["nonexistent_habit", "another_fake"], "b": ["bogus_123"]}, _ctx(), rng)
		if sc1["beats"].size() != sc2["beats"].size():
			ok = false
			break
		for i in sc1["beats"].size():
			var b1: Dictionary = sc1["beats"][i]
			var b2: Dictionary = sc2["beats"][i]
			if str(b1["move"]) != str(b2["move"]) or str(b1["result"]) != str(b2["result"]) or str(b1["who"]) != str(b2["who"]):
				ok = false
				break
		if not ok:
			break
	_check(ok, "unknown habit ids are ignored (no error, no change)")
