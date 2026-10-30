extends SceneTree
## InsideExits (S315): how inside spells end. 300 seeds x rounds 1-3, the exchange built as ExchangeBeats does
## (RoundScript -> BurstShape -> InsideBeats -> ClinchBeats -> InsideExits).
## 1. every spell has exit tie/pivot/step and exit_who a/b; a pivot's leaver is the one pressed (not the spell's who)
## 2. punches keep who/t/result, body hook counts unchanged; combos and big shots keep their move
## 3. clinch count unchanged; every clinch keeps its two referee step_outs at its break_t; no punch inside a moved hold
## 4. a tie ends on its clinch (end_t <= clinch t); a pivot ends PIVOT_S after end_t; spells still >= 0.3 s long
## 5. exit shares over the realistic mix: pivot 0.25-0.60, tie 0.10-0.50, step 0.15-0.55 (none of the three is gone)
## 6. a pivot with a check hook: the leaver's lead hook lands HOOK_CONTACT_S before end_t
## 7. determinism

const RS := preload("res://scripts/rules/RoundScript.gd")
const BS := preload("res://scripts/rules/BurstShape.gd")
const IB := preload("res://scripts/rules/InsideBeats.gd")
const CB := preload("res://scripts/rules/ClinchBeats.gd")
const IX := preload("res://scripts/rules/InsideExits.gd")

const SEEDS := 300
const SITS: Array = ["press", "range", "counter", "loadup", "tiring", "hurt"]
var failures := 0


func _initialize() -> void:
	var counts := {"pivot": 0, "tie": 0, "step": 0}
	var ok := [true, true, true, true, true, true]
	var hooks := 0
	for rn in [1, 2, 3]:
		for s in SEEDS:
			var sit: String = SITS[s % SITS.size()]
			var beats := _exchange(rn, s, sit, false)
			var before := _punches(beats)
			var clinches_before := beats.filter(func(b): return str(b["move"]) == "clinch").size()
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 3 + rn
			var spells: Array = IX.apply(beats, rng)
			for sp in spells:
				var ex := str(sp.get("exit", ""))
				if not ex in counts or not str(sp.get("exit_who", "")) in ["a", "b"]:
					ok[0] = false
					continue
				counts[ex] = int(counts[ex]) + 1
				if ex == "pivot" and str(sp["exit_who"]) == str(sp["who"]):
					ok[0] = false
				if float(sp["end_t"]) - float(sp["t"]) < 0.3:
					ok[3] = false
				if ex == "pivot":
					if absf(float(sp["pivot_t"]) - float(sp["end_t"]) - IX.PIVOT_S) > 0.001:
						ok[3] = false
					for b in beats:
						if str(b["who"]) == str(sp["exit_who"]) and str(b["move"]) == "lead_hook" \
								and absf(float(b["t"]) + IX.HOOK_CONTACT_S - float(sp["end_t"])) < 0.001:
							hooks += 1
				if ex == "tie":
					var tied := false
					for b in beats:
						if str(b["move"]) == "clinch" and float(b["t"]) >= float(sp["t"]) - 0.001 and float(b["t"]) <= float(sp["end_t"]) + IX.TIE_NEAR_S + 0.001:
							tied = float(sp["end_t"]) <= float(b["t"]) + 0.001
					if not tied:
						ok[3] = false
			if not _same_punches(before, _punches(beats)):
				ok[1] = false
			var clinches := beats.filter(func(b): return str(b["move"]) == "clinch")
			if clinches.size() != clinches_before:
				ok[2] = false
			for c in clinches:
				var refs := beats.filter(func(b): return bool(b.get("ref", false)) and is_equal_approx(float(b["t"]), float(c["break_t"])))
				if refs.size() < 2:
					ok[2] = false
				if bool(c.get("tie", false)):
					for b in beats:
						if str(b["move"]) in IX.PUNCHES and float(b["t"]) > float(c["t"]) + 0.001 and float(b["t"]) < float(c["break_t"]) - 0.001:
							ok[2] = false
			for i in range(1, beats.size()):
				if float(beats[i]["t"]) < float(beats[i - 1]["t"]):
					ok[3] = false
	var total := float(counts["pivot"] + counts["tie"] + counts["step"])
	print("INSIDE_EXITS spells=%d pivot=%.2f tie=%.2f step=%.2f check_hooks=%d" % [total, counts["pivot"] / total,
		counts["tie"] / total, counts["step"] / total, hooks])
	_check(ok[0], "1: every spell has an exit and a leaver; a pivot's leaver is the pressed one")
	_check(ok[1], "2: punches keep who/t/result, body hooks, combo/big moves")
	_check(ok[2], "3: clinch count kept, referee breaks follow their clinch, no punch inside a moved hold")
	_check(ok[3], "4: tie ends on its clinch, pivot_t = end_t + PIVOT_S, spells >= 0.3 s, sorted")
	_check(_between(counts["pivot"] / total, 0.25, 0.60) and _between(counts["tie"] / total, 0.10, 0.50)
		and _between(counts["step"] / total, 0.15, 0.55), "5: exit shares in their bands")
	_check(hooks > counts["pivot"] / 4, "6: check hooks before pivots (%d of %d)" % [hooks, counts["pivot"]])
	var x := _exchange(2, 77, "press", true)
	var y := _exchange(2, 77, "press", true)
	_check(str(x) == str(y), "7: determinism")
	print("INSIDE_EXITS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _exchange(rn: int, seed: int, sit: String, exits: bool) -> Array:
	var sc: Dictionary = RS.build({"n": rn, "won": seed % 2 == 0, "mine": 10.0, "theirs": 0.0, "corner": "", "lines": [],
		"names": ["Lucy", "Maria"]}, "Out-boxer", "Pressure fighter", 30.0, seed)
	var beats: Array = (sc["beats"] as Array).duplicate(true)
	var r := RandomNumberGenerator.new()
	r.seed = seed + 7777
	BS.apply(beats, r)
	r.seed = seed + 41
	IB.apply(beats, {"sit": sit}, r)
	r.seed = seed + 31
	CB.apply(beats, {"n": rn, "sit": sit, "energy": {"a": 60.0, "b": 45.0}, "habits": {"a": [], "b": []}}, r)
	if exits:
		r.seed = seed + 43
		IX.apply(beats, r)
	return beats


func _punches(beats: Array) -> Array:
	var out: Array = []
	for b in beats:
		if str(b["move"]) in IX.PUNCHES:
			var fixed := bool(b.get("combo", false)) or str(b.get("combo_id", "")) != "" or bool(b.get("big", false)) or str(b["move"]) == "body_hook"
			out.append([str(b["who"]), snappedf(float(b["t"]), 0.001), str(b["result"]), str(b["move"]) if fixed else "-"])
	return out


func _same_punches(a: Array, b: Array) -> bool:
	return str(a) == str(b)


func _between(v: float, lo: float, hi: float) -> bool:
	return v >= lo and v <= hi


func _check(ok: bool, what: String) -> void:
	if ok:
		print("PASS " + what)
	else:
		failures += 1
		print("FAIL " + what)
