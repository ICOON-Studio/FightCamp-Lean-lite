extends SceneTree
## BodyMap: 7 tests, 300 seeds each.
## 1. fresh() + no landed punches -> no change
## 2. Sides (orthodox / southpaw), blocked/missed, big, b-punch-on-a
## 3. Bands + value() cap
## 4. Cuts + corner (cut/enswell/ice/water/clear) + end_round
## 5. Realistic bout (3 rounds rolled with BoutRules' ROUND_SPREAD; the bout winner takes 2+ rounds)
## 6. tally()
## 7. Determinism + split-add equivalence

const RS := preload("res://scripts/rules/RoundScript.gd")
const BM := preload("res://scripts/rules/BodyMap.gd")
const BR := preload("res://scripts/rules/BoutRules.gd")

var failures := 0
const SEEDS := 300
const EXCHANGES_PER_ROUND := 1
const ROUNDS := 3


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	print("BODY_MAP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rl(n: int) -> Dictionary:
	return {"n": n, "won": true, "mine": 60.0, "theirs": 40.0, "corner": "",
		"lines": [], "names": ["Lucy", "Maria"]}


func _build_round(rn: int, seed: int, a_won: bool, mine: float = -1.0, theirs: float = -1.0) -> Array:
	var rd := _rl(rn)
	rd["won"] = a_won
	if mine >= 0.0:
		rd["mine"] = mine
		rd["theirs"] = theirs
	elif a_won:
		rd["mine"] = 60.0
		rd["theirs"] = 40.0
	else:
		rd["mine"] = 40.0
		rd["theirs"] = 60.0
	var all_beats: Array = []
	for ex in EXCHANGES_PER_ROUND:
		var s: int = seed * 1000 + rn * 100 + ex
		var sc: Dictionary = RS.build(rd, "Out-boxer", "Out-boxer", 30.0, s)
		all_beats.append_array(sc["beats"])
	return all_beats


func _count_landed(beats: Array, who: String) -> int:
	var n := 0
	for b in beats:
		if str(b["who"]) == who and str(b["result"]) == "lands":
			n += 1
	return n


## 1. fresh(): both boxers, six places at 100, no cuts. A round with no landed punch changes nothing.
func _test1() -> void:
	var m: Dictionary = BM.fresh()
	var ok := true
	for who in ["a", "b"]:
		for p in BM.PLACES:
			if BM.value(m, who, p) != 100.0:
				ok = false
				break
		if not ok:
			break
		if not (m[who]["cuts"] as Dictionary).is_empty():
			ok = false
		if not ok:
			break
	if not ok:
		_check(false, "test 1: fresh() six places at 100, no cuts")
		return
	var no_land_beats: Array = [
		{"t": 1.0, "who": "a", "move": "jab", "result": "blocked", "big": false},
		{"t": 2.0, "who": "b", "move": "cross", "result": "misses", "big": false},
		{"t": 3.0, "who": "a", "move": "step_in", "result": "none", "big": false},
	]
	BM.add_beats(m, no_land_beats, {"a": false, "b": false})
	for who in ["a", "b"]:
		for p in BM.PLACES:
			if BM.value(m, who, p) != 100.0:
				ok = false
				break
		if not ok:
			break
	_check(ok, "test 1: fresh() + no landed punches -> no change")


## 2. Sides: orthodox lead_hook -> b right_eye + head x1.5; body_hook -> b right_ribs;
##    southpaw -> left_eye / left_ribs; blocked/missed no change; big = BIG_MULT; b-punch on a.
func _test2() -> void:
	var ok := true
	# Orthodox a, landed lead_hook -> b right_eye drops, head drops x1.5 of jab's head drop.
	var m1: Dictionary = BM.fresh()
	var hook_beat: Array = [{"t": 1.5, "who": "a", "move": "lead_hook", "result": "lands", "big": false}]
	BM.add_beats(m1, hook_beat, {"a": false, "b": false})
	if BM.value(m1, "b", "right_eye") >= 100.0:
		ok = false
	if BM.value(m1, "b", "left_eye") != 100.0:
		ok = false
	# Compare head drop from hook vs jab.
	var m_jab: Dictionary = BM.fresh()
	var jab_beat: Array = [{"t": 1.5, "who": "a", "move": "jab", "result": "lands", "big": false}]
	BM.add_beats(m_jab, jab_beat, {"a": false, "b": false})
	var jab_head_drop: float = 100.0 - BM.value(m_jab, "b", "head")
	var hook_head_drop: float = 100.0 - BM.value(m1, "b", "head")
	if jab_head_drop > 0.001:
		var ratio: float = hook_head_drop / jab_head_drop
		if absf(ratio - 1.5) > 0.01:
			ok = false
	else:
		ok = false
	# Orthodox body_hook -> b right_ribs.
	var m2: Dictionary = BM.fresh()
	var bh_beat: Array = [{"t": 2.0, "who": "a", "move": "body_hook", "result": "lands", "big": false}]
	BM.add_beats(m2, bh_beat, {"a": false, "b": false})
	if BM.value(m2, "b", "right_ribs") >= 100.0:
		ok = false
	if BM.value(m2, "b", "left_ribs") != 100.0:
		ok = false
	if BM.value(m2, "b", "head") != 100.0:
		ok = false
	# Southpaw a -> left_eye, left_ribs.
	var m3: Dictionary = BM.fresh()
	var s_hook: Array = [{"t": 3.0, "who": "a", "move": "lead_hook", "result": "lands", "big": false}]
	BM.add_beats(m3, s_hook, {"a": true, "b": false})
	if BM.value(m3, "b", "left_eye") >= 100.0:
		ok = false
	if BM.value(m3, "b", "right_eye") != 100.0:
		ok = false
	var m4: Dictionary = BM.fresh()
	var s_bh: Array = [{"t": 4.0, "who": "a", "move": "body_hook", "result": "lands", "big": false}]
	BM.add_beats(m4, s_bh, {"a": true, "b": false})
	if BM.value(m4, "b", "left_ribs") >= 100.0:
		ok = false
	if BM.value(m4, "b", "right_ribs") != 100.0:
		ok = false
	# Blocked / missed -> no change.
	var m5: Dictionary = BM.fresh()
	var blocked_beats: Array = [
		{"t": 5.0, "who": "a", "move": "jab", "result": "blocked", "big": false},
		{"t": 6.0, "who": "a", "move": "cross", "result": "misses", "big": false},
	]
	BM.add_beats(m5, blocked_beats, {"a": false, "b": false})
	for p in BM.PLACES:
		if BM.value(m5, "b", p) != 100.0:
			ok = false
	# Big beat = BIG_MULT.
	var m6: Dictionary = BM.fresh()
	var big_beat: Array = [{"t": 7.0, "who": "a", "move": "jab", "result": "lands", "big": true}]
	BM.add_beats(m6, big_beat, {"a": false, "b": false})
	var m7: Dictionary = BM.fresh()
	var norm_beat: Array = [{"t": 7.0, "who": "a", "move": "jab", "result": "lands", "big": false}]
	BM.add_beats(m7, norm_beat, {"a": false, "b": false})
	var big_drop: float = 100.0 - BM.value(m6, "b", "head")
	var norm_drop: float = 100.0 - BM.value(m7, "b", "head")
	if norm_drop > 0.001:
		if absf(big_drop / norm_drop - BM.BIG_MULT) > 0.01:
			ok = false
	else:
		ok = false
	# Punch by b lands on a.
	var m8: Dictionary = BM.fresh()
	var b_punch: Array = [{"t": 8.0, "who": "b", "move": "jab", "result": "lands", "big": false}]
	BM.add_beats(m8, b_punch, {"a": false, "b": false})
	if BM.value(m8, "a", "head") >= 100.0:
		ok = false
	if BM.value(m8, "b", "head") != 100.0:
		ok = false
	_check(ok, "test 2: sides, blocked/missed, big, b-punch-on-a")


## 3. Bands + value() cap at 100.
func _test3() -> void:
	var ok := true
	if BM.band(56.0) != "fine":
		ok = false
	if BM.band(55.0) != "hurt":
		ok = false
	if BM.band(35.0) != "critical":
		ok = false
	if BM.band(15.0) != "doctor":
		ok = false
	if BM.band(0.0) != "doctor":
		ok = false
	# value() caps at 100.
	var m: Dictionary = BM.fresh()
	m["a"]["relief"]["head"] = 50.0
	if BM.value(m, "a", "head") != 100.0:
		ok = false
	_check(ok, "test 3: bands + value() cap at 100")


## 4. Cuts + corner: cut opens at CRITICAL, CUT_MULT while open, cutman closes, end_round reopens.
##    enswell lifts one band; ice = 15% of missing; water/clear no change.
func _test4() -> void:
	var ok := true
	# Drive a face place to CRITICAL to open a cut.
	var m: Dictionary = BM.fresh()
	# Use small hits to approach CRITICAL precisely, then one final hit to cross it.
	var small_hits: Array = []
	for i in 8:
		small_hits.append({"t": float(1 + i), "who": "a", "move": "rear_uppercut",
			"result": "lands", "big": false})
	BM.add_beats(m, small_hits, {"a": false, "b": false})
	var nose_val: float = BM.value(m, "b", "nose")
	# Add one more hit to cross CRITICAL.
	var one_more: Array = [{"t": 20.0, "who": "a", "move": "rear_uppercut", "result": "lands", "big": false}]
	BM.add_beats(m, one_more, {"a": false, "b": false})
	nose_val = BM.value(m, "b", "nose")
	if nose_val > BM.CRITICAL:
		# Still above CRITICAL, add more hits.
		var more_hits: Array = []
		for i in 10:
			more_hits.append({"t": float(21 + i), "who": "a", "move": "rear_uppercut",
				"result": "lands", "big": false})
		BM.add_beats(m, more_hits, {"a": false, "b": false})
		nose_val = BM.value(m, "b", "nose")
	if nose_val > BM.CRITICAL:
		_check(false, "test 4: could not drive nose to CRITICAL (nose=%.1f)" % nose_val)
		return
	if not (m["b"]["cuts"] as Dictionary).has("nose"):
		ok = false
	# For precise drop tests, set nose to a known value with a cut.
	var m_cut: Dictionary = BM.fresh()
	m_cut["b"]["places"]["nose"] = 50.0
	m_cut["b"]["cuts"]["nose"] = true
	var val_before: float = BM.value(m_cut, "b", "nose")
	var cut_hit: Array = [{"t": 50.0, "who": "a", "move": "rear_uppercut", "result": "lands", "big": false}]
	BM.add_beats(m_cut, cut_hit, {"a": false, "b": false})
	var val_after: float = BM.value(m_cut, "b", "nose")
	var actual_drop: float = val_before - val_after
	var expected_drop: float = BM.FACE_HIT * BM.CUT_MULT
	if absf(actual_drop - expected_drop) > 0.01:
		ok = false
	# Corner cutman "cut" closes the cut -> next hit is normal.
	var m_close: Dictionary = BM.fresh()
	m_close["b"]["places"]["nose"] = 50.0
	m_close["b"]["cuts"]["nose"] = true
	BM.corner(m_close, "b", "cut", "")
	var val_before2: float = BM.value(m_close, "b", "nose")
	var closed_hit: Array = [{"t": 60.0, "who": "a", "move": "rear_uppercut", "result": "lands", "big": false}]
	BM.add_beats(m_close, closed_hit, {"a": false, "b": false})
	var val_after2: float = BM.value(m_close, "b", "nose")
	var closed_drop: float = val_before2 - val_after2
	if absf(closed_drop - BM.FACE_HIT) > 0.01:
		ok = false
	# end_round reopens the cut.
	BM.end_round(m_close)
	var val_before3: float = BM.value(m_close, "b", "nose")
	var reopen_hit: Array = [{"t": 70.0, "who": "a", "move": "rear_uppercut", "result": "lands", "big": false}]
	BM.add_beats(m_close, reopen_hit, {"a": false, "b": false})
	var val_after3: float = BM.value(m_close, "b", "nose")
	var reopen_drop: float = val_before3 - val_after3
	if absf(reopen_drop - expected_drop) > 0.01:
		ok = false
	# enswell lifts one band exactly.
	var m2: Dictionary = BM.fresh()
	m2["a"]["places"]["left_eye"] = 50.0
	m2["a"]["cuts"]["left_eye"] = true
	BM.corner(m2, "a", "enswell_left", "")
	var eye_val: float = BM.value(m2, "a", "left_eye")
	if absf(eye_val - (BM.HURT + 1.0)) > 0.01:
		ok = false
	# enswell on a "critical" eye (30 -> 36).
	var m2b: Dictionary = BM.fresh()
	m2b["a"]["places"]["right_eye"] = 30.0
	m2b["a"]["cuts"]["right_eye"] = true
	BM.corner(m2b, "a", "enswell_right", "")
	var eye_val2: float = BM.value(m2b, "a", "right_eye")
	if absf(eye_val2 - (BM.CRITICAL + 1.0)) > 0.01:
		ok = false
	# enswell on a "doctor" eye (10 -> 16).
	var m2c: Dictionary = BM.fresh()
	m2c["a"]["places"]["left_eye"] = 10.0
	m2c["a"]["cuts"]["left_eye"] = true
	BM.corner(m2c, "a", "enswell_left", "")
	var eye_val3: float = BM.value(m2c, "a", "left_eye")
	if absf(eye_val3 - (BM.DOCTOR + 1.0)) > 0.01:
		ok = false
	# enswell on a "fine" eye -> no change.
	var m2d: Dictionary = BM.fresh()
	BM.corner(m2d, "a", "enswell_left", "")
	if BM.value(m2d, "a", "left_eye") != 100.0:
		ok = false
	# end_round removes relief.
	BM.end_round(m2)
	if BM.value(m2, "a", "left_eye") != 50.0:
		ok = false
	# ice gives 15% of missing on that side only.
	var m3: Dictionary = BM.fresh()
	m3["a"]["places"]["left_ribs"] = 60.0
	BM.corner(m3, "a", "", "ice_left")
	var lr: float = BM.value(m3, "a", "left_ribs")
	var expected_ice: float = 0.15 * (100.0 - 60.0)
	if absf(lr - (60.0 + expected_ice)) > 0.01:
		ok = false
	if BM.value(m3, "a", "right_ribs") != 100.0:
		ok = false
	# water / clear change nothing.
	var m4: Dictionary = BM.fresh()
	m4["a"]["places"]["nose"] = 70.0
	BM.corner(m4, "a", "", "water")
	if BM.value(m4, "a", "nose") != 70.0:
		ok = false
	var m5: Dictionary = BM.fresh()
	m5["a"]["places"]["nose"] = 70.0
	BM.corner(m5, "a", "", "clear")
	if BM.value(m5, "a", "nose") != 70.0:
		ok = false
	_check(ok, "test 4: cuts + corner (cut/enswell/ice/water/clear) + end_round")


## 5. Realistic bout: 3 rounds rolled as BoutRules.play_round does, 300 seeds.
func _test5() -> void:
	var loser_hurt_count := 0
	var any_doctor_count := 0
	var winner_all_fine_count := 0
	var head_lowest_count := 0
	var total_winner_landed := 0
	var total_loser_landed := 0
	var total_rounds := 0
	for s in SEEDS:
		var a_south: bool = (s % 2 == 1)
		var south := {"a": a_south, "b": false}
		var mp: Dictionary = BM.fresh()
		# Rounds as BoutRules.play_round rolls them: power + (roll - 0.5) * ROUND_SPREAD, "a" a small favourite,
		# so close, clear and dominant rounds mix as in a real bout.
		var rng := RandomNumberGenerator.new()
		rng.seed = s * 7919 + 1
		var a_round_wins := 0
		for rn in ROUNDS:
			var mine: float = 63.0 + (rng.randf() - 0.5) * BR.ROUND_SPREAD
			var theirs: float = 60.0 + (rng.randf() - 0.5) * BR.ROUND_SPREAD
			var a_won: bool = mine > theirs
			if a_won:
				a_round_wins += 1
			var beats: Array = _build_round(rn + 1, s * 100 + rn, a_won, mine, theirs)
			BM.add_beats(mp, beats, south)
			var rw: String = "a" if a_won else "b"
			total_winner_landed += _count_landed(beats, rw)
			total_loser_landed += _count_landed(beats, "b" if rw == "a" else "a")
			total_rounds += 1
		var bout_winner: String = "a" if a_round_wins * 2 > ROUNDS else "b"
		var bout_loser: String = "b" if bout_winner == "a" else "a"
		var loser_has_hurt := false
		var any_doctor := false
		var winner_fine := true
		var loser_min_place := ""
		var loser_min_val := 999.0
		for p in BM.PLACES:
			var lv: float = BM.value(mp, bout_loser, p)
			var wv: float = BM.value(mp, bout_winner, p)
			if BM.band(lv) != "fine":
				loser_has_hurt = true
			if BM.band(wv) == "doctor" or BM.band(lv) == "doctor":
				any_doctor = true
			if BM.band(wv) != "fine":
				winner_fine = false
			if lv < loser_min_val:
				loser_min_val = lv
				loser_min_place = p
		var head_is_lowest: bool = loser_min_place == "head"
		if loser_has_hurt:
			loser_hurt_count += 1
		if any_doctor:
			any_doctor_count += 1
		if winner_fine:
			winner_all_fine_count += 1
		if head_is_lowest:
			head_lowest_count += 1
	var loser_hurt_pct: float = float(loser_hurt_count) / float(SEEDS) * 100.0
	var doctor_pct: float = float(any_doctor_count) / float(SEEDS) * 100.0
	var winner_fine_pct: float = float(winner_all_fine_count) / float(SEEDS) * 100.0
	var head_lowest_pct: float = float(head_lowest_count) / float(SEEDS) * 100.0
	var mean_landed: float = float(total_winner_landed + total_loser_landed) / float(total_rounds * 2)
	print("  t5: loser_hurt=%.0f%% doctor=%.0f%% winner_fine=%.0f%% head_lowest=%.0f%% mean_landed=%.1f (round winner %.1f, loser %.1f)" % [
		loser_hurt_pct, doctor_pct, winner_fine_pct, head_lowest_pct, mean_landed,
		float(total_winner_landed) / float(total_rounds), float(total_loser_landed) / float(total_rounds)])
	_check(loser_hurt_pct >= 40.0 and loser_hurt_pct <= 90.0,
		"test 5: loser hurt %.0f%% in 40..90" % loser_hurt_pct)
	_check(doctor_pct <= 8.0,
		"test 5: any doctor %.0f%% <= 8" % doctor_pct)
	_check(winner_fine_pct >= 50.0,
		"test 5: winner all fine %.0f%% >= 50" % winner_fine_pct)
	_check(head_lowest_pct <= 40.0,
		"test 5: head lowest %.0f%% <= 40" % head_lowest_pct)


## 6. tally(): totals = counted punch beats; pct = landed*100/thrown.
func _test6() -> void:
	var beats: Array = [
		{"t": 1.0, "who": "a", "move": "jab", "result": "lands", "big": false},
		{"t": 2.0, "who": "a", "move": "jab", "result": "blocked", "big": false},
		{"t": 3.0, "who": "a", "move": "cross", "result": "lands", "big": false},
		{"t": 4.0, "who": "b", "move": "lead_hook", "result": "lands", "big": false},
		{"t": 5.0, "who": "b", "move": "body_hook", "result": "misses", "big": false},
		{"t": 6.0, "who": "a", "move": "rear_uppercut", "result": "lands", "big": false},
		{"t": 7.0, "who": "a", "move": "step_in", "result": "none", "big": false},
	]
	var t: Dictionary = BM.tally(beats)
	var ok := true
	# a: thrown = jab 2, straight 1, uppercut 1, total 4; landed = jab 1, straight 1, uppercut 1, total 3.
	if int(t["a"]["thrown"]["jab"]) != 2:
		ok = false
	if int(t["a"]["thrown"]["straight"]) != 1:
		ok = false
	if int(t["a"]["thrown"]["uppercut"]) != 1:
		ok = false
	if int(t["a"]["thrown"]["total"]) != 4:
		ok = false
	if int(t["a"]["landed"]["jab"]) != 1:
		ok = false
	if int(t["a"]["landed"]["straight"]) != 1:
		ok = false
	if int(t["a"]["landed"]["uppercut"]) != 1:
		ok = false
	if int(t["a"]["landed"]["total"]) != 3:
		ok = false
	# b: thrown = hook 1, body 1, total 2; landed = hook 1, total 1.
	if int(t["b"]["thrown"]["hook"]) != 1:
		ok = false
	if int(t["b"]["thrown"]["body"]) != 1:
		ok = false
	if int(t["b"]["thrown"]["total"]) != 2:
		ok = false
	if int(t["b"]["landed"]["hook"]) != 1:
		ok = false
	if int(t["b"]["landed"]["total"]) != 1:
		ok = false
	# pct checks.
	if int(t["a"]["pct"]["jab"]) != 50:
		ok = false
	if int(t["a"]["pct"]["total"]) != 75:
		ok = false
	if int(t["b"]["pct"]["hook"]) != 100:
		ok = false
	if int(t["b"]["pct"]["body"]) != 0:
		ok = false
	# Empty beats.
	var t2: Dictionary = BM.tally([])
	if int(t2["a"]["thrown"]["total"]) != 0:
		ok = false
	if int(t2["a"]["pct"]["total"]) != 0:
		ok = false
	_check(ok, "test 6: tally() totals + pct")


## 7. Determinism + split-add equivalence.
func _test7() -> void:
	var ok := true
	for s in SEEDS:
		var beats: Array = _build_round(1, s, true)
		var south := {"a": false, "b": false}
		var m1: Dictionary = BM.fresh()
		BM.add_beats(m1, beats, south)
		var m2: Dictionary = BM.fresh()
		BM.add_beats(m2, beats, south)
		for who in ["a", "b"]:
			for p in BM.PLACES:
				if absf(BM.value(m1, who, p) - BM.value(m2, who, p)) > 0.001:
					ok = false
					break
			if not ok:
				break
		if not ok:
			break
	if not ok:
		_check(false, "test 7a: determinism")
		return
	# Split-add equivalence: add_beats(beats[0..k]) + add_beats(beats[k..]) == add_beats(beats).
	var ok2 := true
	for s in SEEDS:
		var beats: Array = _build_round(2, s, true)
		var south := {"a": false, "b": false}
		var m_full: Dictionary = BM.fresh()
		BM.add_beats(m_full, beats, south)
		var mid: int = beats.size() / 2
		var first_half: Array = beats.slice(0, mid)
		var second_half: Array = beats.slice(mid)
		var m_split: Dictionary = BM.fresh()
		BM.add_beats(m_split, first_half, south)
		BM.add_beats(m_split, second_half, south)
		for who in ["a", "b"]:
			for p in BM.PLACES:
				if absf(BM.value(m_full, who, p) - BM.value(m_split, who, p)) > 0.001:
					ok2 = false
					break
			if not ok2:
				break
		if not ok2:
			break
	_check(ok2, "test 7b: split-add equivalence")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
