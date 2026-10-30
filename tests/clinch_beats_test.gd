extends SceneTree
## ClinchBeats: 8 tests, 300 seeds each.
## 1. punch beats unchanged  2. sorted, no punches in clinch window, t/break_t in range
## 3. avg clinches per round (mix of situations) in range  4. duration mean 2.7..5.5, all in bounds
## 5. hurt clinches >= 2x range; holder correct >= 70%  6. clinches_when_tired habit
## 7. each clinch followed by two ref step_outs  8. determinism  9. no two clinch windows overlap (Claude, S313)

const RS := preload("res://scripts/rules/RoundScript.gd")
const CB := preload("res://scripts/rules/ClinchBeats.gd")

var failures := 0
const SEEDS := 300
const SITS: Array = ["press", "range", "counter", "loadup", "tiring", "hurt"]
const SIT_W: Array = [0.35, 0.25, 0.15, 0.1, 0.1, 0.05]


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	_test8()
	_test9()
	print("CLINCH_BEATS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rl(n: int) -> Dictionary:
	return {"n": n, "won": true, "mine": 60.0, "theirs": 0.0, "corner": "", "lines": [], "names": ["Lucy", "Maria"]}


func _ctx(n: int, sit: String, energy: Dictionary = {"a": 70.0, "b": 70.0}, habits: Dictionary = {"a": [], "b": []}) -> Dictionary:
	return {"n": n, "sit": sit, "energy": energy, "habits": habits}


func _pick_sit(rng: RandomNumberGenerator) -> String:
	var r: float = rng.randf()
	var cum: float = 0.0
	for i in SITS.size():
		cum += float(SIT_W[i])
		if r < cum:
			return str(SITS[i])
	return str(SITS[0])


func _build_exchange(rn: int, seed: int) -> Array:
	var sc: Dictionary = RS.build(_rl(rn), "Out-boxer", "Pressure fighter", 30.0, seed)
	return (sc["beats"] as Array).duplicate(true)


## 1. Every punch beat (who, move, result, t) is still there and unchanged after apply.
func _test1() -> void:
	var ok := true
	for s in SEEDS:
		var beats: Array = _build_exchange(2, s)
		var punches_before: Array = []
		for b in beats:
			if str(b["move"]) in CB.PUNCHES:
				punches_before.append({"who": str(b["who"]), "move": str(b["move"]), "result": str(b["result"]), "t": float(b["t"])})
		var rng := RandomNumberGenerator.new()
		rng.seed = s + 10000
		CB.apply(beats, _ctx(2, "press"), rng)
		var punches_after: Array = []
		for b in beats:
			if str(b["move"]) in CB.PUNCHES:
				punches_after.append({"who": str(b["who"]), "move": str(b["move"]), "result": str(b["result"]), "t": float(b["t"])})
		if punches_before.size() != punches_after.size():
			ok = false
			break
		for i in punches_before.size():
			var pb: Dictionary = punches_before[i]
			var pa: Dictionary = punches_after[i]
			if str(pb["who"]) != str(pa["who"]) or str(pb["move"]) != str(pa["move"]) or str(pb["result"]) != str(pa["result"]) or absf(float(pb["t"]) - float(pa["t"])) > 0.001:
				ok = false
				break
		if not ok:
			break
	_check(ok, "test 1: every punch beat unchanged after apply")


## 2. Beats stay sorted by t; every clinch window holds no punch beat; 0.5 <= t and break_t <= 29.5.
func _test2() -> void:
	var ok := true
	for s in SEEDS:
		var beats: Array = _build_exchange(2, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s + 20000
		CB.apply(beats, _ctx(2, "press"), rng)
		for i in range(1, beats.size()):
			if float(beats[i]["t"]) < float(beats[i - 1]["t"]) - 0.001:
				ok = false
				break
		if not ok:
			break
		for b in beats:
			if str(b["move"]) != "clinch":
				continue
			var t: float = float(b["t"])
			var bt: float = float(b["break_t"])
			if t < 0.5 - 0.001 or bt > 29.5 + 0.001:
				ok = false
				break
			var win_end: float = bt + CB.BREAK_S
			for ob in beats:
				if str(ob["move"]) in CB.PUNCHES:
					var ot: float = float(ob["t"])
					if ot >= t - 0.001 and ot <= win_end + 0.001:
						ok = false
						break
			if not ok:
				break
		if not ok:
			break
	_check(ok, "test 2: sorted, no punches in clinch window, t/break_t in range")


## 3. Average clinches per round (6 exchanges, realistic mix): round 1 in 1.5..4.0, round 3 in 3.0..6.5, r3 > r1+1.
func _test3() -> void:
	var avgs: Dictionary = {}
	for rn in [1, 3]:
		var total_clinches := 0
		for s in SEEDS:
			var sit_rng := RandomNumberGenerator.new()
			sit_rng.seed = s * 7 + 3
			for ex in 6:
				var sit: String = _pick_sit(sit_rng)
				var beats: Array = _build_exchange(rn, s * 100 + ex)
				var rng := RandomNumberGenerator.new()
				rng.seed = s * 1000 + ex
				var nb: Array = CB.apply(beats, _ctx(rn, sit), rng)
				for b in nb:
					if str(b["move"]) == "clinch":
						total_clinches += 1
		avgs[rn] = float(total_clinches) / float(SEEDS)
	_check(float(avgs[1]) >= 1.5 and float(avgs[1]) <= 4.0, "test 3: round 1 avg %.2f in 1.5..4.0" % float(avgs[1]))
	_check(float(avgs[3]) >= 3.0 and float(avgs[3]) <= 6.5, "test 3: round 3 avg %.2f in 3.0..6.5" % float(avgs[3]))
	_check(float(avgs[3]) > float(avgs[1]) + 1.0, "test 3: round 3 (%.2f) > round 1 (%.2f) + 1.0" % [float(avgs[3]), float(avgs[1])])


## 4. Mean clinch duration 2.7..5.5 s; none outside DUR_MIN_S..DUR_MAX_S.
## S313: real is 4.1 s, but punches are never moved and our exchanges rarely leave a free gap over 3-4 s,
## so the placed mean sits near 2.9 s; Qwen's overlapping version read 2.68 (this floor catches it).
func _test4() -> void:
	var dur_sum := 0.0
	var dur_count := 0
	var all_in_range := true
	for s in SEEDS:
		var beats: Array = _build_exchange(2, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s + 40000
		var nb: Array = CB.apply(beats, _ctx(2, "press"), rng)
		for b in nb:
			if str(b["move"]) == "clinch":
				var d: float = float(b["dur"])
				dur_sum += d
				dur_count += 1
				if d < CB.DUR_MIN_S - 0.001 or d > CB.DUR_MAX_S + 0.001:
					all_in_range = false
	var mean_dur: float = dur_sum / maxf(1.0, float(dur_count))
	_check(mean_dur >= 2.7 and mean_dur <= 5.5, "test 4: mean duration %.2f in 2.7..5.5" % mean_dur)
	_check(all_in_range, "test 4: all durations in %.1f..%.1f" % [CB.DUR_MIN_S, CB.DUR_MAX_S])


## 5. hurt clinches >= 2x range; hurt holder is "b" >= 70%; she_hurt holder is "a" >= 70%.
func _test5() -> void:
	var hurt_count := 0
	var range_count := 0
	var hurt_b := 0
	var she_hurt_count := 0
	var she_hurt_a := 0
	for s in SEEDS:
		for sit in ["hurt", "range", "she_hurt"]:
			var beats: Array = _build_exchange(2, s * 10 + SITS.find(sit))
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 100 + SITS.find(sit)
			var nb: Array = CB.apply(beats, _ctx(2, str(sit)), rng)
			for b in nb:
				if str(b["move"]) == "clinch":
					if str(sit) == "hurt":
						hurt_count += 1
						if str(b["who"]) == "b":
							hurt_b += 1
					elif str(sit) == "range":
						range_count += 1
					elif str(sit) == "she_hurt":
						she_hurt_count += 1
						if str(b["who"]) == "a":
							she_hurt_a += 1
	_check(hurt_count >= range_count * 2, "test 5: hurt clinches (%d) >= 2x range (%d)" % [hurt_count, range_count])
	if hurt_count > 0:
		_check(float(hurt_b) / float(hurt_count) >= 0.7, "test 5: hurt holder 'b' >= 70%% (%.0f%%)" % (100.0 * float(hurt_b) / float(hurt_count)))
	else:
		_check(false, "test 5: no hurt clinches to check")
	if she_hurt_count > 0:
		_check(float(she_hurt_a) / float(she_hurt_count) >= 0.7, "test 5: she_hurt holder 'a' >= 70%% (%.0f%%)" % (100.0 * float(she_hurt_a) / float(she_hurt_count)))
	else:
		_check(false, "test 5: no she_hurt clinches to check")


## 6. clinches_when_tired: habit + low energy -> "a" clinches more; high energy -> no change.
func _test6() -> void:
	var a_with := 0
	var a_without := 0
	for s in SEEDS:
		var beats1: Array = _build_exchange(2, s)
		var rng1 := RandomNumberGenerator.new()
		rng1.seed = s + 50000
		var ctx1 := _ctx(2, "press", {"a": 40.0, "b": 70.0}, {"a": ["clinches_when_tired"], "b": []})
		var nb1: Array = CB.apply(beats1, ctx1, rng1)
		for b in nb1:
			if str(b["move"]) == "clinch" and str(b["who"]) == "a":
				a_with += 1
		var beats2: Array = _build_exchange(2, s)
		var rng2 := RandomNumberGenerator.new()
		rng2.seed = s + 50000
		var ctx2 := _ctx(2, "press", {"a": 40.0, "b": 70.0}, {"a": [], "b": []})
		var nb2: Array = CB.apply(beats2, ctx2, rng2)
		for b in nb2:
			if str(b["move"]) == "clinch" and str(b["who"]) == "a":
				a_without += 1
	_check(a_with > a_without, "test 6: habit + energy 40: 'a' clinches %d vs %d without" % [a_with, a_without])
	var a_h90 := 0
	var a_nh90 := 0
	for s in SEEDS:
		var beats1: Array = _build_exchange(2, s)
		var rng1 := RandomNumberGenerator.new()
		rng1.seed = s + 60000
		var ctx1 := _ctx(2, "press", {"a": 90.0, "b": 70.0}, {"a": ["clinches_when_tired"], "b": []})
		var nb1: Array = CB.apply(beats1, ctx1, rng1)
		for b in nb1:
			if str(b["move"]) == "clinch" and str(b["who"]) == "a":
				a_h90 += 1
		var beats2: Array = _build_exchange(2, s)
		var rng2 := RandomNumberGenerator.new()
		rng2.seed = s + 60000
		var ctx2 := _ctx(2, "press", {"a": 90.0, "b": 70.0}, {"a": [], "b": []})
		var nb2: Array = CB.apply(beats2, ctx2, rng2)
		for b in nb2:
			if str(b["move"]) == "clinch" and str(b["who"]) == "a":
				a_nh90 += 1
	_check(a_h90 == a_nh90, "test 6: energy 90: habit changes nothing (%d vs %d)" % [a_h90, a_nh90])


## 7. Each clinch is followed by exactly two ref step_out beats at its break_t, one per boxer.
func _test7() -> void:
	var ok := true
	for s in SEEDS:
		var beats: Array = _build_exchange(2, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s + 70000
		CB.apply(beats, _ctx(2, "press"), rng)
		for b in beats:
			if str(b["move"]) != "clinch":
				continue
			var bt: float = float(b["break_t"])
			var ref_outs: Array = []
			for ob in beats:
				if float(ob["t"]) >= bt - 0.001 and float(ob["t"]) <= bt + 0.001 and str(ob["move"]) == "step_out" and bool(ob.get("ref", false)):
					ref_outs.append(str(ob["who"]))
			if ref_outs.size() != 2:
				ok = false
				break
			var has_a := false
			var has_b := false
			for w in ref_outs:
				if w == "a":
					has_a = true
				if w == "b":
					has_b = true
			if not has_a or not has_b:
				ok = false
				break
		if not ok:
			break
	_check(ok, "test 7: each clinch followed by two ref step_outs (a + b)")


## 8. Same seed, same input -> same output.
func _test8() -> void:
	var ok := true
	for s in SEEDS:
		var beats1: Array = _build_exchange(2, s)
		var rng1 := RandomNumberGenerator.new()
		rng1.seed = s + 80000
		var nb1: Array = CB.apply(beats1, _ctx(2, "press"), rng1)
		var beats2: Array = _build_exchange(2, s)
		var rng2 := RandomNumberGenerator.new()
		rng2.seed = s + 80000
		var nb2: Array = CB.apply(beats2, _ctx(2, "press"), rng2)
		if nb1.size() != nb2.size():
			ok = false
			break
		for i in nb1.size():
			var a: Dictionary = nb1[i]
			var c: Dictionary = nb2[i]
			if str(a["who"]) != str(c["who"]) or str(a["move"]) != str(c["move"]) or absf(float(a["t"]) - float(c["t"])) > 0.001:
				ok = false
				break
		if not ok:
			break
	_check(ok, "test 8: determinism (same seed -> same output)")


## 9. Two clinches in one exchange never overlap: windows [t, break_t + BREAK_S] are disjoint (hurt = most clinches).
func _test9() -> void:
	var ok := true
	var doubles := 0
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats: Array = _build_exchange(rn, s)
			var rng := RandomNumberGenerator.new()
			rng.seed = s + 90000
			CB.apply(beats, _ctx(rn, "hurt"), rng)
			var wins: Array = []
			for b in beats:
				if str(b["move"]) == "clinch":
					wins.append([float(b["t"]), float(b["break_t"]) + CB.BREAK_S])
			if wins.size() > 1:
				doubles += 1
			for i in wins.size():
				for j in range(i + 1, wins.size()):
					if wins[j][0] < wins[i][1] and wins[i][0] < wins[j][1]:
						ok = false
	_check(ok and doubles > 0, "test 9: no overlapping clinches (%d exchanges held two)" % doubles)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
