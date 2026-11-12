extends SceneTree
## S443 R29 wiring check (the map's probe JUDGES1 gates (a), (b), (c) read on real bouts; it does not set the weights):
## Lucy as signed, 6 weaker and 6 stronger, against every OPPONENT + MISMATCH + RIVAL, SIMS bouts each through fight
## night's own rounds (BoutNight.play_out). Per decision: the judges' verdict against the old rounds-won cards
## (BoutRules.cards_of); per round: the judges' majority against the exchange winner (r.won); splits; "out-landed and lost".
##   godot --headless --audio-driver Dummy --path . --script res://tools/judges_agree_probe.gd [-- sims] [grid]
## Prints JUDGES_AGREE lines. S444 JUDGES1: `grid` plays the bouts once and re-scores every decision on a grid of WEIGHTS /
## LEAN_MULT (the same card rule as Judges.score_round, weights passed in), printing JUDGES_GRID lines.

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const JudgeNight := preload("res://scripts/state/JudgeNight.gd")
const Judges := preload("res://scripts/rules/Judges.gd")

const CAMP := {"protocol": 2, "focus": "conditioning", "film": false, "partner": false, "start": 0}


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var sims := int(args[0]) if not args.is_empty() and str(args[0]).is_valid_int() else 40
	var t := {"bouts": 0, "decisions": 0, "flipped": 0, "rounds": 0, "round_agree": 0, "split": 0, "majority": 0, "unanimous": 0,
		"draw": 0, "outlanded_lost": 0}
	var kept: Array = []   # grid: per decision {rounds [{p, counts, won}], leans, pro, la, lb, old}
	for shift in [-6.0, 0.0, 6.0]:
		for o in Data.OPPONENTS + [Data.MISMATCH] + Data.RIVALS:
			for k in sims:
				var sc := Career.new()
				sc.day = 60000 + k * 7
				sc.seed = 443
				sc.coach = {"rating": 58.0}
				var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
				for s in f["stats"]:
					f["stats"][s] = float(f["stats"][s]) + shift
				f["camp"] = CAMP.duplicate(true)
				f["bout"] = {"opp": (o as Dictionary).duplicate(true), "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
				sc.fighters = [f]
				var m := BoutNight.fight_modal(f)
				BoutNight.play_out(sc, f, m)
				t["bouts"] += 1
				var rounds: Array = m["rounds"]
				JudgeNight.cards(f, m)
				if BoutNight.stopped(m) != "" or not m.has("judges"):
					continue
				t["decisions"] += 1
				var old := BoutRules.verdict(BoutRules.cards_of(rounds))
				var new := BoutRules.verdict((m["judges"]["cards"] as Array).map(func(c): return "%d-%d" % [int(c[0]), int(c[1])]))
				t["flipped"] += int(old != new)
				t[str(m["judges"]["verdict"])] += 1
				var la := 0
				var lb := 0
				var keep_rounds: Array = []
				var fb: Dictionary = f["bout"]
				var own_pace := float(JudgeNight.Attrs.of(f).get("pace", 55.0))
				var opp_pace := float(JudgeNight.AttrGen.attrs_of(fb["opp"]).get("pace", 55.0))
				for ri in rounds.size():
					var r: Dictionary = rounds[ri]
					var sum := [0, 0]
					for x in r["exchanges"]:
						sum[0] += int(x["landed"][0])
						sum[1] += int(x["landed"][1])
					la += sum[0]
					lb += sum[1]
					var ours := ((m["judges"]["by_round"] as Array)[ri] as Array).filter(func(s): return int(s["a"]) > int(s["b"])).size()
					t["rounds"] += 1
					t["round_agree"] += int((ours >= 2) == bool(r["won"]))
					var jr := JudgeNight.round_of(r, own_pace, opp_pace)
					keep_rounds.append({"p": Judges.parts(jr), "counts": jr["counts"], "won": bool(r["won"]), "won_n": int(r.get("won_n", 0))})
				t["outlanded_lost"] += int((la > lb and new == "loss") or (lb > la and new == "win"))
				kept.append({"rounds": keep_rounds, "leans": m["judges"]["leans"], "pro": bool(fb.get("pro", false)), "la": la, "lb": lb, "old": old,
					"opp": str(o.get("first", "")), "shift": shift})
	var d := maxf(1.0, float(t["decisions"]))
	print("JUDGES_AGREE bouts=%d decisions=%d (Lucy -6/0/+6 x every opponent x %d)" % [t["bouts"], t["decisions"], sims])
	print("JUDGES_AGREE (a) exchange winner takes the round on the judges' majority: %.1f in 100 (band 80-90)" % (100.0 * t["round_agree"] / maxf(1.0, t["rounds"])))
	print("JUDGES_AGREE (b) out-landed and lost the decision: %.1f in 100 (under 15)" % (100.0 * t["outlanded_lost"] / d))
	print("JUDGES_AGREE (c) split %.1f, majority %.1f, unanimous %.1f, draw %.1f in 100 (split band 10-25)" % [
		100.0 * t["split"] / d, 100.0 * t["majority"] / d, 100.0 * t["unanimous"] / d, 100.0 * t["draw"] / d])
	print("JUDGES_AGREE decisions that change hands against the old rounds-won cards: %.1f in 100" % (100.0 * t["flipped"] / d))
	if args.has("grid"):
		_grid(kept)
	var at := args.find("dump")
	if at >= 0 and at + 1 < args.size():   # the kept decisions as JSON, for a re-score outside Godot
		var fh := FileAccess.open(str(args[at + 1]), FileAccess.WRITE)
		fh.store_string(JSON.stringify(kept))
		fh.close()
	quit(0)


## The S444 grid: every weight set re-scores the kept decisions; a row passes when (a) 80-90, (b) < 15, (c) 10-25.
func _grid(kept: Array) -> void:
	var n := 0
	for cl in [0.25, 0.35, 0.5, 0.75, 1.0]:
		for bg in [1.0, 2.0, 3.0]:
			for rg in [0.5, 1.0, 2.0, 3.0, 4.0]:
				for ini in [0.5, 1.0, 2.0, 3.0, 4.0]:
					for mult in [1.5, 2.0, 3.0]:
						var w := {"clean": cl, "big": bg, "ring": rg, "initiative": ini, "work": 1.0}
						var g := _rescore(kept, w, mult)
						var ok: bool = g["a"] >= 80.0 and g["a"] <= 90.0 and g["b"] < 15.0 and g["c"] >= 10.0 and g["c"] <= 25.0
						n += int(ok)
						print("JUDGES_GRID %s clean=%.2f big=%.1f ring=%.1f init=%.1f mult=%.1f a=%.1f b=%.1f c=%.1f maj=%.1f una=%.1f draw=%.1f flip=%.1f" % [
							"PASS" if ok else "out ", cl, bg, rg, ini, mult, g["a"], g["b"], g["c"], g["majority"], g["unanimous"], g["draw"], g["flip"]])
	print("JUDGES_GRID rows passing all three: %d" % n)


func _rescore(kept: Array, w: Dictionary, mult: float) -> Dictionary:
	var rounds := 0
	var agree := 0
	var t := {"split": 0, "majority": 0, "unanimous": 0, "draw": 0, "ol": 0, "flip": 0}
	for b in kept:
		var pro: bool = b["pro"]
		var parts: Array = Judges.counted(pro)
		var tot := [[0, 0], [0, 0], [0, 0]]
		for r in b["rounds"]:
			var ours := 0
			for j in 3:
				var s := _side(r["p"], str(b["leans"][j]), parts, w, mult)
				var c: Array = r["counts"]
				var sa := 10 if s == "a" else 9
				var sb := 10 if s == "b" else 9
				if int(c[0]) != int(c[1]):
					var net := absi(int(c[0]) - int(c[1]))
					sa = 9 - net if int(c[0]) > int(c[1]) else 10
					sb = 10 if int(c[0]) > int(c[1]) else 9 - net
				tot[j][0] += sa
				tot[j][1] += sb
				ours += int(sa > sb)
			rounds += 1
			agree += int((ours >= 2) == bool(r["won"]))
		var ac := 0
		var bc := 0
		for c in tot:
			ac += int(c[0] > c[1])
			bc += int(c[1] > c[0])
		var verdict := "draw"
		var res := "draw"
		if ac != bc and maxi(ac, bc) >= 2:
			res = "win" if ac > bc else "loss"
			verdict = "unanimous" if maxi(ac, bc) == 3 else ("majority" if 3 - ac - bc == 1 else "split")
		t[verdict] += 1
		t["ol"] += int((int(b["la"]) > int(b["lb"]) and res == "loss") or (int(b["lb"]) > int(b["la"]) and res == "win"))
		t["flip"] += int(res != str(b["old"]))
	var d := maxf(1.0, float(kept.size()))
	return {"a": 100.0 * agree / maxf(1.0, rounds), "b": 100.0 * t["ol"] / d, "c": 100.0 * t["split"] / d,
		"majority": 100.0 * t["majority"] / d, "unanimous": 100.0 * t["unanimous"] / d, "draw": 100.0 * t["draw"] / d,
		"flip": 100.0 * t["flip"] / d}


## Judges.score_round's winner on one card, with the weights passed in (the count is applied by the caller).
func _side(p: Dictionary, lean: String, parts: Array, w: Dictionary, mult: float) -> String:
	var ta := 0.0
	var tb := 0.0
	for part in parts:
		var v: Array = p[part]
		var k: float = float(w[part]) * (mult if part == lean else 1.0)
		ta += float(v[0]) * k
		tb += float(v[1]) * k
	if not is_equal_approx(ta, tb):
		return "a" if ta > tb else "b"
	for tie in ([lean, "clean"] if parts.has(lean) else ["clean"]):
		var v: Array = p.get(tie, [0, 0])
		if not is_equal_approx(float(v[0]), float(v[1])):
			return "a" if float(v[0]) > float(v[1]) else "b"
	return str(p.get("last", "a")) if str(p.get("last", "")) != "" else "a"
