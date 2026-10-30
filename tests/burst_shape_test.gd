extends SceneTree
## BurstShape: real amateur bouts throw punches in bursts of 2-5, then a quiet spell.
## 300 seeds x rounds 1-3 x margins close/clear/dominant.
##   1. every beat still there, same punch order, every non-t key unchanged
##   2. sorted by t; first >= START_S - 0.001; last <= END_S + 0.001
##   3. burst sizes (punches < 1.0 s apart): median 2 or 3; singles < 30 %; 2-5 >= 60 %
##   4. bursts per exchange: mean 2.5..7 (S313: our exchange carries ~21 punches, the real rate; ~4 was for ~10)
##   5. quiet spells (gaps >= 1.0 s between punches): mean 2.0..4.5; >= 4 s in 40 %+ exchanges
##   6. combos: same combo_id -> all punch-to-punch gaps <= IN_GAP_S.y + 0.001
##   7. habit beats: <= IN_GAP_S.y + 0.001 after the punch before (when it is a punch)
##   8. same seed -> same output

const RS := preload("res://scripts/rules/RoundScript.gd")
const BS := preload("res://scripts/rules/BurstShape.gd")

var failures := 0
const SEEDS := 300


func _initialize() -> void:
	var total_burst_sizes: Array = []
	var bursts_per_ex: Array = []
	var all_quiet: Array = []
	var exchanges_with_long: int = 0

	for s in SEEDS:
		var n: int = (s % 3) + 1
		var mine: float = [3.0, 10.0, 20.0][(s / 3) % 3]
		var beats: Array = _build(s, n, mine)
		var orig_count: int = beats.size()
		var orig_punch_order: Array = []
		var orig_non_t: Array = []
		for b in beats:
			if BS.is_punch(str(b["move"])):
				orig_punch_order.append([str(b["who"]), str(b["move"]), str(b["result"])])
			var kd: Dictionary = {}
			for k in b.keys():
				if str(k) != "t":
					kd[str(k)] = b[k]
			orig_non_t.append(kd)

		var rng := RandomNumberGenerator.new()
		rng.seed = s * 7 + 1
		var bursts: Array = BS.apply(beats, rng)

		# 1. Count, punch order, non-t keys unchanged.
		_check(beats.size() == orig_count, "s%d count %d == %d" % [s, beats.size(), orig_count])
		var punch_order: Array = []
		for b in beats:
			if BS.is_punch(str(b["move"])):
				punch_order.append([str(b["who"]), str(b["move"]), str(b["result"])])
		_check(punch_order == orig_punch_order, "s%d punch order" % s)
		var keys_ok: bool = true
		for i in beats.size():
			var bt: Dictionary = beats[i]
			var orig: Dictionary = orig_non_t[i]
			for k in orig.keys():
				if str(bt.get(k, "__MISSING__")) != str(orig[k]):
					keys_ok = false
		_check(keys_ok, "s%d non-t keys unchanged" % s)

		# 2. Sorted; first >= START_S - 0.001; last <= END_S + 0.001.
		var sorted_ok: bool = true
		for i in range(1, beats.size()):
			if float(beats[i]["t"]) < float(beats[i - 1]["t"]) - 0.001:
				sorted_ok = false
		_check(sorted_ok, "s%d sorted" % s)
		if beats.size() > 0:
			_check(float(beats[0]["t"]) >= BS.START_S - 0.001, "s%d first >= START_S" % s)
			_check(float(beats[beats.size() - 1]["t"]) <= BS.END_S + 0.001, "s%d last <= END_S" % s)

		# 3. Burst sizes (punches < 1.0 s apart).
		var punch_times: Array = []
		for b in beats:
			if BS.is_punch(str(b["move"])):
				punch_times.append(float(b["t"]))
		var ex_bursts: Array = []
		if punch_times.size() > 0:
			var cur: int = 1
			for i in range(1, punch_times.size()):
				if punch_times[i] - punch_times[i - 1] < 1.0:
					cur += 1
				else:
					ex_bursts.append(cur)
					cur = 1
			ex_bursts.append(cur)
		for bs_val in ex_bursts:
			total_burst_sizes.append(bs_val)
		bursts_per_ex.append(ex_bursts.size())

		# 5. Quiet spells (gaps >= 1.0 s between punches).
		var ex_quiet: Array = []
		for i in range(1, punch_times.size()):
			var gap: float = punch_times[i] - punch_times[i - 1]
			if gap >= 1.0:
				ex_quiet.append(gap)
				all_quiet.append(gap)
		if ex_quiet.max() >= 4.0:
			exchanges_with_long += 1

		# 6. Combos: same combo_id -> gaps <= IN_GAP_S.y + 0.001.
		for i in range(1, beats.size()):
			var cid: String = str(beats[i].get("combo_id", ""))
			if cid != "" and cid == str(beats[i - 1].get("combo_id", "")):
				if BS.is_punch(str(beats[i]["move"])) and BS.is_punch(str(beats[i - 1]["move"])):
					var g: float = float(beats[i]["t"]) - float(beats[i - 1]["t"])
					_check(g <= BS.IN_GAP_S.y + 0.001, "s%d combo gap %.3f" % [s, g])

		# 7. Habit beats: <= IN_GAP_S.y + 0.001 after the punch before.
		for i in range(1, beats.size()):
			if str(beats[i].get("habit", "")) != "" and BS.is_punch(str(beats[i - 1]["move"])):
				var g: float = float(beats[i]["t"]) - float(beats[i - 1]["t"])
				_check(g <= BS.IN_GAP_S.y + 0.001, "s%d habit gap %.3f" % [s, g])

		# 8. Determinism (same seed -> same output).
		var beats2: Array = _build(s, n, mine)
		var rng2 := RandomNumberGenerator.new()
		rng2.seed = s * 7 + 1
		BS.apply(beats2, rng2)
		_check(_deep_eq(beats, beats2), "s%d deterministic" % s)

	# 3. Aggregate burst stats.
	if total_burst_sizes.size() > 0:
		total_burst_sizes.sort()
		var med: int = total_burst_sizes[total_burst_sizes.size() / 2]
		_check(med == 2 or med == 3, "median burst size %d in [2,3]" % med)
		var singles: int = 0
		var in_range: int = 0
		for bs_val in total_burst_sizes:
			if bs_val == 1:
				singles += 1
			if bs_val >= 2 and bs_val <= 5:
				in_range += 1
		var single_pct: float = float(singles) / float(total_burst_sizes.size())
		var range_pct: float = float(in_range) / float(total_burst_sizes.size())
		_check(single_pct < 0.30, "singles %.1f%% < 30%%" % (single_pct * 100))
		_check(range_pct >= 0.60, "2-5 bursts %.1f%% >= 60%%" % (range_pct * 100))

	# 4. Bursts per exchange: mean 2.5..7.
	if bursts_per_ex.size() > 0:
		var bsum: float = 0.0
		for v in bursts_per_ex:
			bsum += float(v)
		var bmean: float = bsum / float(bursts_per_ex.size())
		_check(bmean >= 2.5 and bmean <= 7.0, "bursts/exchange mean %.2f in [2.5,7]" % bmean)

	# 5. Quiet spell stats.
	if all_quiet.size() > 0:
		var qsum: float = 0.0
		for v in all_quiet:
			qsum += v
		var qmean: float = qsum / float(all_quiet.size())
		_check(qmean >= 2.0 and qmean <= 4.5, "quiet mean %.2f in [2.0,4.5]" % qmean)
		var long_pct: float = float(exchanges_with_long) / float(SEEDS)
		_check(long_pct >= 0.40, ">= 4s quiet in %.0f%% >= 40%%" % (long_pct * 100))

	print("BURST_SHAPE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _build(seed: int, n: int, mine: float) -> Array:
	var rl: Dictionary = {"n": n, "won": true, "mine": mine, "theirs": 0.0, "corner": "",
		"lines": ["One.", "Two."], "names": ["Lucy", "Maria"]}
	var sc: Dictionary = RS.build(rl, "Out-boxer", "Pressure fighter", 30.0, seed)
	var out: Array = []
	for b in sc["beats"]:
		out.append(b.duplicate(true))
	return out


func _deep_eq(a: Variant, b: Variant) -> bool:
	if a is Array and b is Array:
		var aa: Array = a
		var bb: Array = b
		if aa.size() != bb.size():
			return false
		for i in aa.size():
			if not _deep_eq(aa[i], bb[i]):
				return false
		return true
	if a is Dictionary and b is Dictionary:
		var da: Dictionary = a
		var db: Dictionary = b
		if da.size() != db.size():
			return false
		for k in da.keys():
			if not db.has(k) or not _deep_eq(da[k], db[k]):
				return false
		return true
	return str(a) == str(b)


func _check(cond: bool, label: String) -> void:
	if not cond:
		failures += 1
		print("FAIL " + label)
