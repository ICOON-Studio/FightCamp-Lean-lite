extends SceneTree
## InsideBeats: 7 tests, 300 seeds each, rounds 1-3.
## 1. punch beats keep who/t/result; body_hook count unchanged; combo/big keep move
## 2. sorted; spells in 0.5..29.0, 1.5..6.0 s; no overlap; no pre-existing clinch in spell
## 3. inside time share (6 exchanges, realistic mix) mean 0.10..0.22
## 4. press >= 3x range inside time
## 5. inside: hooks+uppercuts >= 55%; whole round: straights >= 35%
## 6. press: "b" steps in for every spell
## 7. determinism

const RS := preload("res://scripts/rules/RoundScript.gd")
const BS := preload("res://scripts/rules/BurstShape.gd")
const IB := preload("res://scripts/rules/InsideBeats.gd")
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
	print("INSIDE_BEATS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rl(n: int) -> Dictionary:
	return {"n": n, "won": true, "mine": 60.0, "theirs": 0.0, "corner": "", "lines": [], "names": ["Lucy", "Maria"]}


func _build_exchange(rn: int, seed: int) -> Array:
	var sc: Dictionary = RS.build(_rl(rn), "Out-boxer", "Pressure fighter", 30.0, seed)
	var beats: Array = (sc["beats"] as Array).duplicate(true)
	var brng := RandomNumberGenerator.new()
	brng.seed = seed + 7777
	BS.apply(beats, brng)
	return beats


func _pick_sit(rng: RandomNumberGenerator) -> String:
	var r: float = rng.randf()
	var cum: float = 0.0
	for i in SITS.size():
		cum += float(SIT_W[i])
		if r < cum:
			return str(SITS[i])
	return str(SITS[0])


## 1. Punch beats keep who/t/result; body_hook count per boxer unchanged; combo/big keep move.
func _test1() -> void:
	var ok := true
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats: Array = _build_exchange(rn, s)
			var p_before: Array = []
			var bh_before: Dictionary = {"a": 0, "b": 0}
			for b in beats:
				var m: String = str(b["move"])
				if m in IB.PUNCHES:
					var is_cb: bool = bool(b.get("combo", false)) or str(b.get("combo_id", "")) != "" or bool(b.get("big", false))
					p_before.append({"who": str(b["who"]), "t": float(b["t"]), "result": str(b["result"]), "move": m, "cb": is_cb})
					if m == "body_hook":
						bh_before[str(b["who"])] = int(bh_before[str(b["who"])]) + 1
			var rng := RandomNumberGenerator.new()
			rng.seed = s + 10000 + rn * 1000
			IB.apply(beats, {"sit": "press"}, rng)
			var p_after: Array = []
			var bh_after: Dictionary = {"a": 0, "b": 0}
			for b in beats:
				var m: String = str(b["move"])
				if m in IB.PUNCHES:
					p_after.append({"who": str(b["who"]), "t": float(b["t"]), "result": str(b["result"]), "move": m})
					if m == "body_hook":
						bh_after[str(b["who"])] = int(bh_after[str(b["who"])]) + 1
			if p_before.size() != p_after.size():
				ok = false
				break
			for idx in p_before.size():
				var pb: Dictionary = p_before[idx]
				var pa: Dictionary = p_after[idx]
				if str(pb["who"]) != str(pa["who"]) or absf(float(pb["t"]) - float(pa["t"])) > 0.001 or str(pb["result"]) != str(pa["result"]):
					ok = false
					break
				if bool(pb["cb"]) and str(pb["move"]) != str(pa["move"]):
					ok = false
					break
			if not ok:
				break
			for side in ["a", "b"]:
				if int(bh_before[side]) != int(bh_after[side]):
					ok = false
					break
			if not ok:
				break
		if not ok:
			break
	_check(ok, "test 1: punch who/t/result, body_hook count, combo/big move unchanged")


## 2. Sorted; spells in 0.5..29.0, 1.5..6.0 s; no overlap; no pre-existing clinch in spell.
##    Both orders: ClinchBeats after InsideBeats in half the seeds, before in the other half.
func _test2() -> void:
	var ok := true
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats: Array = _build_exchange(rn, s)
			var rng := RandomNumberGenerator.new()
			rng.seed = s + 20000 + rn * 1000
			var cb_rng := RandomNumberGenerator.new()
			cb_rng.seed = s + 21000 + rn * 1000
			var ctx: Dictionary = {"sit": "press", "n": rn, "energy": {"a": 70.0, "b": 70.0}, "habits": {"a": [], "b": []}}
			# Record pre-existing clinches (before InsideBeats).
			var clinches_before: Array = []
			var ib_first: bool = (s % 2 == 1)
			if not ib_first:
				CB.apply(beats, ctx, cb_rng)
			for b in beats:
				if str(b["move"]) == "clinch":
					clinches_before.append({"t": float(b["t"]), "break_t": float(b["break_t"])})
			IB.apply(beats, {"sit": "press"}, rng)
			if ib_first:
				CB.apply(beats, ctx, cb_rng)
			# Sorted.
			for i in range(1, beats.size()):
				if float(beats[i]["t"]) < float(beats[i - 1]["t"]) - 0.001:
					ok = false
					break
			if not ok:
				break
			# Spell bounds and length.
			var spells: Array = []
			for b in beats:
				if str(b["move"]) == "inside":
					var st: float = float(b["t"])
					var et: float = float(b["end_t"])
					if st < 0.5 - 0.001 or et > 29.0 + 0.001:
						ok = false
						break
					var slen: float = et - st
					if slen < 1.5 - 0.001 or slen > 6.0 + 0.001:
						ok = false
						break
					spells.append([st, et])
			if not ok:
				break
			# No overlap.
			for i in spells.size():
				for j in range(i + 1, spells.size()):
					if float(spells[j][0]) < float(spells[i][1]) - 0.001 and float(spells[i][0]) < float(spells[j][1]) - 0.001:
						ok = false
						break
				if not ok:
					break
			if not ok:
				break
			# No pre-existing clinch contained in any spell.
			for cb_entry in clinches_before:
				for sp in spells:
					if float(cb_entry["t"]) >= float(sp[0]) - 0.001 and float(cb_entry["t"]) <= float(sp[1]) + 0.001:
						ok = false
						break
					if float(cb_entry["break_t"]) >= float(sp[0]) - 0.001 and float(cb_entry["break_t"]) <= float(sp[1]) + 0.001:
						ok = false
						break
				if not ok:
					break
			if not ok:
				break
		if not ok:
			break
	_check(ok, "test 2: sorted, spell bounds, no overlap, no pre-existing clinch in spell")


## 3. Inside time share (6 exchanges, realistic mix) mean 0.10..0.22.
func _test3() -> void:
	var share_sum := 0.0
	for s in SEEDS:
		var sit_rng := RandomNumberGenerator.new()
		sit_rng.seed = s * 7 + 3
		var total_inside := 0.0
		for ex in 6:
			var sit: String = _pick_sit(sit_rng)
			var beats: Array = _build_exchange(2, s * 100 + ex)
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 1000 + ex
			var nb: Array = IB.apply(beats, {"sit": sit}, rng)
			for b in nb:
				if str(b["move"]) == "inside":
					total_inside += float(b["end_t"]) - float(b["t"])
		share_sum += total_inside / 180.0
	var mean_share: float = share_sum / float(SEEDS)
	_check(mean_share >= 0.10 and mean_share <= 0.22, "test 3: mean inside share %.3f in 0.10..0.22" % mean_share)


## 4. Press >= 3x range inside time.
func _test4() -> void:
	var press_total := 0.0
	var range_total := 0.0
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats_p: Array = _build_exchange(rn, s)
			var rng_p := RandomNumberGenerator.new()
			rng_p.seed = s + 40000 + rn * 1000
			var nb_p: Array = IB.apply(beats_p, {"sit": "press"}, rng_p)
			for b in nb_p:
				if str(b["move"]) == "inside":
					press_total += float(b["end_t"]) - float(b["t"])
			var beats_r: Array = _build_exchange(rn, s)
			var rng_r := RandomNumberGenerator.new()
			rng_r.seed = s + 40000 + rn * 1000
			var nb_r: Array = IB.apply(beats_r, {"sit": "range"}, rng_r)
			for b in nb_r:
				if str(b["move"]) == "inside":
					range_total += float(b["end_t"]) - float(b["t"])
	if range_total > 0.001:
		_check(press_total >= range_total * 3.0, "test 4: press %.1f >= 3x range %.1f (ratio %.1f)" % [press_total, range_total, press_total / range_total])
	else:
		_check(press_total > 0.0, "test 4: press %.1f, range %.1f (no range spells)" % [press_total, range_total])


## 5. Inside: hooks+uppercuts >= 55%; whole round: straights >= 35%.
func _test5() -> void:
	var inside_punches := 0
	var inside_hu := 0
	var total_punches := 0
	var total_straights := 0
	for s in SEEDS:
		var sit_rng := RandomNumberGenerator.new()
		sit_rng.seed = s * 7 + 3
		for ex in 6:
			var sit: String = _pick_sit(sit_rng)
			var beats: Array = _build_exchange(2, s * 100 + ex)
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 1000 + ex
			IB.apply(beats, {"sit": sit}, rng)
			var spell_windows: Array = []
			for b in beats:
				if str(b["move"]) == "inside":
					spell_windows.append([float(b["t"]), float(b["end_t"])])
			for b in beats:
				var m: String = str(b["move"])
				if not (m in IB.PUNCHES):
					continue
				total_punches += 1
				if m == "jab" or m == "cross":
					total_straights += 1
				var bt: float = float(b["t"])
				var in_spell := false
				for sw in spell_windows:
					if bt >= float(sw[0]) and bt <= float(sw[1]):
						in_spell = true
						break
				if in_spell:
					inside_punches += 1
					if m == "lead_hook" or m == "body_hook" or m == "rear_uppercut":
						inside_hu += 1
	var inside_pct: float = float(inside_hu) / maxf(1, inside_punches)
	var straight_pct: float = float(total_straights) / maxf(1, total_punches)
	_check(inside_pct >= 0.55, "test 5: inside hooks+uppercuts %.1f%% >= 55%% (%d of %d)" % [inside_pct * 100, inside_hu, inside_punches])
	_check(straight_pct >= 0.35, "test 5: whole round straights %.1f%% >= 35%% (%d of %d)" % [straight_pct * 100, total_straights, total_punches])


## 6. Press: "b" steps in for every spell.
func _test6() -> void:
	var ok := true
	var any_spells := false
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats: Array = _build_exchange(rn, s)
			var rng := RandomNumberGenerator.new()
			rng.seed = s + 60000 + rn * 1000
			var nb: Array = IB.apply(beats, {"sit": "press"}, rng)
			for b in nb:
				if str(b["move"]) == "inside":
					any_spells = true
					if str(b["who"]) != "b":
						ok = false
						break
			if not ok:
				break
		if not ok:
			break
	_check(ok and any_spells, "test 6: press spells always who='b'")


## 7. Determinism.
func _test7() -> void:
	var ok := true
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var beats1: Array = _build_exchange(rn, s)
			var rng1 := RandomNumberGenerator.new()
			rng1.seed = s + 70000 + rn * 1000
			var nb1: Array = IB.apply(beats1, {"sit": "press"}, rng1)
			var beats2: Array = _build_exchange(rn, s)
			var rng2 := RandomNumberGenerator.new()
			rng2.seed = s + 70000 + rn * 1000
			var nb2: Array = IB.apply(beats2, {"sit": "press"}, rng2)
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
		if not ok:
			break
	_check(ok, "test 7: determinism")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
