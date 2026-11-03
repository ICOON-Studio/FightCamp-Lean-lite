extends SceneTree
## ClinchBeats, 300 seeds each. S374 operator: a clinch only when she is desperate to break the opponent's combo, at the
## risk of a shot coming in; pretty rare; the real stats set aside.
## 1. the exchange's punches unchanged (only entry shots added)  2. sorted, no punches in the clinch window, t/break_t in range
## 3. rare: under 0.8 a round in a realistic mix, more when hurt  4. durations in bounds
## 5. hurt clinches > range; holder is the hurt one >= 70%  6. clinches_when_tired habit  7. two step_outs a clinch
## 8. determinism  9. at most one clinch an exchange  10. every clinch follows a combination landing on its holder
## 11. the entry risk: about ENTRY_HIT_P of clinches open with the attacker's shot landing on the holder

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
	_test10()
	_test11()
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


## S374: an exchange she is losing - the opponent's combinations land on HER, so she is the one who may grab.
func _build_losing(rn: int, seed: int) -> Array:
	var rl := _rl(rn)
	rl["won"] = false
	rl["mine"] = 0.0
	rl["theirs"] = 60.0
	var sc: Dictionary = RS.build(rl, "Out-boxer", "Pressure fighter", 30.0, seed)
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
			if str(b["move"]) in CB.PUNCHES and not bool(b.get("entry", false)):
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
	_check(ok, "test 1: every punch beat of the exchange unchanged after apply (entry shots aside)")


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


## 3. Rare (S374): a realistic mix of situations averages under 0.8 clinches a round (6 exchanges) and above 0.05; an
## all-hurt round holds more than the mix.
func _test3() -> void:
	var mix := 0
	var hurt := 0
	for s in SEEDS:
		var sit_rng := RandomNumberGenerator.new()
		sit_rng.seed = s * 7 + 3
		for ex in 6:
			var beats: Array = _build_exchange(2, s * 100 + ex)
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 1000 + ex
			for b in CB.apply(beats, _ctx(2, _pick_sit(sit_rng)), rng):
				mix += 1 if str(b["move"]) == "clinch" else 0
			var beats2: Array = _build_exchange(2, s * 100 + ex)
			var rng2 := RandomNumberGenerator.new()
			rng2.seed = s * 1000 + ex
			for b in CB.apply(beats2, _ctx(2, "hurt"), rng2):
				hurt += 1 if str(b["move"]) == "clinch" else 0
	var avg := float(mix) / float(SEEDS)
	_check(avg < 0.8 and avg > 0.05, "test 3: rare - %.2f clinches a round in the mix (0.05..0.8)" % avg)
	_check(hurt > mix, "test 3: a hurt boxer grabs more (%d all-hurt vs %d mixed)" % [hurt, mix])


## 4. Every clinch lasts DUR_MIN_S..DUR_MAX_S; the mean is short (1.5..3.5 s - a grab to break a combo, not a rest).
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
	_check(dur_count == 0 or (mean_dur >= 1.5 and mean_dur <= 3.5), "test 4: mean duration %.2f in 1.5..3.5 (%d clinches)" % [mean_dur, dur_count])
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
			var beats: Array = _build_losing(2, s * 10 + 7) if str(sit) == "she_hurt" else _build_exchange(2, s * 10 + SITS.find(sit))
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
	_check(hurt_count > range_count, "test 5: hurt clinches (%d) > range (%d)" % [hurt_count, range_count])
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
		var beats1: Array = _build_losing(2, s)
		var rng1 := RandomNumberGenerator.new()
		rng1.seed = s + 50000
		var ctx1 := _ctx(2, "press", {"a": 40.0, "b": 70.0}, {"a": ["clinches_when_tired"], "b": []})
		var nb1: Array = CB.apply(beats1, ctx1, rng1)
		for b in nb1:
			if str(b["move"]) == "clinch" and str(b["who"]) == "a":
				a_with += 1
		var beats2: Array = _build_losing(2, s)
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


## 9. At most one clinch an exchange (S374: rare), even when hurt.
func _test9() -> void:
	var most := 0
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats: Array = _build_exchange(rn, s)
			var rng := RandomNumberGenerator.new()
			rng.seed = s + 90000
			var n := 0
			for b in CB.apply(beats, _ctx(rn, "hurt"), rng):
				n += 1 if str(b["move"]) == "clinch" else 0
			most = maxi(most, n)
	_check(most <= 1, "test 9: at most one clinch an exchange (most %d)" % most)


## 10. Every clinch follows a combination landing on its holder: COMBO_LANDED_MIN of the other boxer's punches landed in
## the 2.5 s before it (the entry shot counts - it lands on her as she closes).
func _test10() -> void:
	var ok := true
	var seen := 0
	for s in SEEDS:
		for sit in ["press", "hurt", "she_hurt", "tiring"]:
			var beats: Array = _build_exchange(2, s * 5 + 1)
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 31 + sit.length()
			for c in CB.apply(beats, _ctx(2, sit), rng):
				if str(c["move"]) != "clinch":
					continue
				seen += 1
				var landed := 0
				for b in beats:
					if str(b["move"]) in CB.PUNCHES and str(b["who"]) != str(c["who"]) and str(b["result"]) == "lands" 							and float(b["t"]) < float(c["t"]) and float(b["t"]) >= float(c["t"]) - 2.5:
						landed += 1
				if landed < CB.COMBO_LANDED_MIN:
					ok = false
	_check(ok and seen > 0, "test 10: all %d clinches answer a combination landing on the holder" % seen)


## 11. The entry risk: about ENTRY_HIT_P of clinches open with the attacker's shot landing on the holder, ENTRY_LEAD_S before.
func _test11() -> void:
	var clinches := 0
	var entries := 0
	var ok := true
	for s in SEEDS:
		var beats: Array = _build_exchange(3, s)
		var rng := RandomNumberGenerator.new()
		rng.seed = s + 110000
		var nb: Array = CB.apply(beats, _ctx(3, "hurt"), rng)
		var c: Dictionary = {}
		var e: Dictionary = {}
		for b in nb:
			if str(b["move"]) == "clinch":
				c = b
			elif bool(b.get("entry", false)):
				e = b
		if c.is_empty():
			continue
		clinches += 1
		if not e.is_empty():
			entries += 1
			ok = ok and str(e["who"]) != str(c["who"]) and str(e["result"]) == "lands" 				and absf(float(c["t"]) - float(e["t"]) - CB.ENTRY_LEAD_S) < 0.001
	var share := float(entries) / maxf(1.0, float(clinches))
	_check(ok and clinches > 0 and share > CB.ENTRY_HIT_P - 0.2 and share < CB.ENTRY_HIT_P + 0.2,
		"test 11: %d of %d clinches cost an entry shot (%.0f%%, aim %.0f%%), each on the holder %.2f s before" % [entries, clinches, share * 100.0, CB.ENTRY_HIT_P * 100.0, CB.ENTRY_LEAD_S])


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
