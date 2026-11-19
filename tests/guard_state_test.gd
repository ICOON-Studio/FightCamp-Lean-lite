extends SceneTree
## S524 GUARDWEAR steps 1-2: GuardState - both guards full at the first bell (amateur max 70, a pro by class), blocks
## wear the defender (the side that took more punches loses more guard), the ropes wear faster than the open ring
## (control arm: the same exchange off the ropes), the corner's minute gives back 15, and the HUD bar reads it.

const GuardState := preload("res://scripts/state/GuardState.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const FightMeters := preload("res://scripts/rules/FightMeters.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _f(pro: bool, limit: float) -> Dictionary:
	return {"pro": pro, "limit": limit, "bout": {}, "stats": {}, "attrs": {"stamina": 60.0, "strength": 55.0}}


func _initialize() -> void:
	var am := _f(false, 60.0)
	var g: Dictionary = GuardState.open(am, 1)
	_check(float(g["a"]["g"]) == 70.0 and float(g["b"]["max"]) == 70.0, "an amateur's guard starts full at 70")
	var pro := _f(true, 75.0)
	_check(float(GuardState.open(pro, 1)["a"]["max"]) == 100.0, "a pro middleweight's guard is 100")
	_check(float(GuardState.open(_f(true, 57.0), 1)["a"]["max"]) == 80.0 and GuardState.wclass(90.0) == "heavy", "light 80, heavy above 81 kg")
	_check(GuardState.blocked_of(4) == 5 and GuardState.blocked_of(0) == 0, "4 landed of 13 thrown: 5 of the other 9 blocked (%d)" % GuardState.blocked_of(4))
	# A 6-1 exchange: our boxer landed 6, the opponent 1 - the opponent blocked far more of ours and loses more guard.
	var r := GuardState.after(am, [6, 1], "", {"stamina": 55.0, "strength": 55.0})
	var ga := float(r["g"][0])
	var gb := float(r["g"][1])
	_check(gb < ga and ga <= 70.0 and gb > 0.0, "the side under fire loses more guard (ours %.1f, theirs %.1f)" % [ga, gb])
	_check(absf(float(r["share"][1]) - gb / 70.0) < 0.001, "share = guard / max")
	# Control arm: the same exchange with our boxer on the ropes wears ours faster.
	var open_ring := _f(false, 60.0)
	GuardState.open(open_ring, 1)
	var on_ropes := _f(false, 60.0)
	GuardState.open(on_ropes, 1)
	var r1 := GuardState.after(open_ring, [3, 4], "", {})
	var r2 := GuardState.after(on_ropes, [3, 4], "own_ropes", {})
	_check(float(r2["g"][0]) < float(r1["g"][0]) and absf(float(r2["g"][1]) - float(r1["g"][1])) < 0.001,
		"trapped on the ropes wears our guard faster (%.2f vs %.2f), theirs the same" % [float(r2["g"][0]), float(r1["g"][0])])
	# A round of six 4-3 exchanges, then the corner.
	var bout := _f(false, 60.0)
	GuardState.open(bout, 1)
	for i in 6:
		GuardState.after(bout, [4, 3], "", {})
	var end_r1 := float(bout["bout"]["guard"]["a"]["g"])
	_check(end_r1 < 70.0 and end_r1 > 20.0, "a round of 4-3 exchanges wears the guard but leaves it standing (%.1f of 70)" % end_r1)
	GuardState.open(bout, 2)
	_check(absf(float(bout["bout"]["guard"]["a"]["g"]) - minf(70.0, end_r1 + 15.0)) < 0.001, "the corner's minute gives back 15")
	# The HUD bar: guard_v4 lowers the bar; without it the bar is as before.
	var src := {"energy": 100.0, "burn": {}, "drop": {}}
	var before := float(FightMeters.bars(src)["guard"]["fill"])
	src["guard_v4"] = 0.4
	_check(absf(float(FightMeters.bars(src)["guard"]["fill"]) - 0.4) < 0.001 and before == 1.0, "the guard bar reads the worn guard (1.0 -> 0.4)")
	_check(GuardState.share({"bout": {}}, "a") == -1.0, "no guard yet (an old save): -1, the bar keeps its old reading")
	# Step 4: Tie up is the clinch (+10 under half guard, once a round); Hands up gives +5 at the next corner.
	var cl := _f(false, 60.0)
	GuardState.open(cl, 1)
	cl["bout"]["guard"]["a"]["g"] = 30.0
	var t1 := GuardState.after(cl, [0, 0], "", {}, "tie")
	var t2 := GuardState.after(cl, [0, 0], "", {}, "tie")
	_check(bool(t1["clinch"]) and absf(float(t1["g"][0]) - 44.0) < 0.001 and not bool(t2["clinch"]),
		"Tie up under half guard: +10 (+4 amateur quiet) once, refused the second time (%.1f)" % float(t1["g"][0]))
	var hi := _f(false, 60.0)
	GuardState.open(hi, 1)
	_check(not bool(GuardState.after(hi, [0, 0], "", {}, "tie")["clinch"]), "Tie up at full guard: no clinch")
	var hu := _f(false, 60.0)
	GuardState.open(hu, 1)
	hu["bout"]["guard"]["a"]["g"] = 20.0
	hu["bout"]["guard"]["b"]["g"] = 20.0
	GuardState.after(hu, [0, 0], "", {}, "hands")
	GuardState.open(hu, 2)
	_check(absf(float(hu["bout"]["guard"]["a"]["g"]) - (24.0 + 20.0)) < 0.001 and absf(float(hu["bout"]["guard"]["b"]["g"]) - 39.0) < 0.001,
		"Hands up: our corner gives 20, theirs 15 (%.1f / %.1f)" % [float(hu["bout"]["guard"]["a"]["g"]), float(hu["bout"]["guard"]["b"]["g"])])
	# The corner minute: under half guard the hurt row says it and names the calls; a bout without the guard says nothing.
	var sm := CornerCard.summarize([])
	var low := str(CornerCard.card(sm, 80.0, ["A", "B"], 0, 0.4)["hurt"])
	_check(low.contains("Guard down to 40% (leaking)") and low.contains("Hands up"), "corner card, guard 40%%: %s" % low)
	_check(not str(CornerCard.card(sm, 80.0, ["A", "B"], 0, 0.6)["hurt"]).contains("Guard") and not str(CornerCard.card(sm, 80.0, ["A", "B"])["hurt"]).contains("Guard"),
		"guard 60% or no guard: no guard line")
	var AttrBoard: GDScript = load("res://scripts/ui/AttrBoard.gd")
	_check(str(AttrBoard.shoulder_line(65.0, 65.0)).contains("12% slower") and str(AttrBoard.shoulder_line(50.0, 40.0)).contains("as usual"),
		"the Stamina / Strength hover names the shoulders: %s" % str(AttrBoard.shoulder_line(65.0, 65.0)))
	# The result page's stats: blocks and the guard left, only for a bout that has a guard (control: an old save's rounds).
	var ex1 := {"landed": [4, 3], "body": [1, 0], "won": true, "guard": {"blocked": [5, 6], "share": [0.8, 0.7]}}
	var ex2 := {"landed": [2, 5], "body": [0, 1], "won": false, "guard": {"blocked": [7, 3], "share": [0.6, 0.65]}}
	var st := FightStats.of([{"n": 1, "exchanges": [ex1, ex2]}])
	var labels: Array = FightStats.rows(st).map(func(r): return str(r["label"]))
	_check(st["blocked"] == [12, 9] and labels.has("Punches blocked") and labels.has("Guard left at the last bell"),
		"the result page counts blocks (%s) and the guard left (%s)" % [str(st["blocked"]), str(st["guard"])])
	_check(not labels.has("Got through the guard (in punches)"), "no leak recorded (S524 rounds): no got-through row")
	var ex3 := {"landed": [3, 4], "body": [0, 0], "won": false, "guard": {"blocked": [6, 4], "share": [0.5, 0.7], "through": [0.70, 0.14]}}
	var st3 := FightStats.of([{"n": 1, "exchanges": [ex3]}])
	var thr: Array = FightStats.rows(st3).filter(func(r): return str(r["label"]) == "Got through the guard (in punches)")
	_check(thr.size() == 1 and str(thr[0]["a"]) == "10" and str(thr[0]["b"]) == "2" and int(thr[0]["lead"]) == 1,
		"the result page shows what got through each guard, fewer leads: %s" % str(thr))
	# S525 guard habits (design s1.3): a slow starter's guard wears 12% less in round 1 (control: no habit, same exchange);
	# a fader recovers less after round 4 (quiet exchanges); without a round number (old callers) habits are ignored.
	var plain := _f(true, 75.0)
	var slow := _f(true, 75.0)
	slow["habits"] = ["slow_starter"]
	GuardState.open(plain, 1)
	GuardState.open(slow, 1)
	var gp := float(GuardState.after(plain, [2, 6], "", {}, "", 1)["g"][0])
	var gsl := float(GuardState.after(slow, [2, 6], "", {}, "", 1)["g"][0])
	_check(gsl > gp, "a slow starter keeps more guard in round 1 (%.1f vs %.1f)" % [gsl, gp])
	var fader := _f(true, 75.0)
	var steady := _f(true, 75.0)
	fader["habits"] = ["fades_late"]
	for b in [fader, steady]:
		GuardState.open(b, 1)
		b["bout"]["guard"]["a"]["g"] = 40.0
	var rf := float(GuardState.after(fader, [3, 0], "", {}, "", 5)["g"][0])
	var rs := float(GuardState.after(steady, [3, 0], "", {}, "", 5)["g"][0])
	_check(rf < rs and rf > 40.0, "a fader recovers less in round 5 on a quiet exchange (%.2f vs %.2f)" % [rf, rs])
	var old_f := _f(true, 75.0)
	old_f["habits"] = ["slow_starter"]
	GuardState.open(old_f, 1)
	_check(absf(float(GuardState.after(old_f, [2, 6], "", {})["g"][0]) - gp) < 0.001, "no round number: the habit is ignored")
	_check(GuardState.guard_habit(["lunges_with_jab", "fades_late"]) == "fades_late" and GuardState.guard_habit([]) == "", "guard_habit picks the guard habit")
	var OF: GDScript = load("res://scripts/rules/OppFile.gd")
	_check(OF.GUARD_NOTE.keys().all(func(h): return GuardState.GUARD_HABITS.has(h)) and GuardState.GUARD_HABITS.all(func(h): return OF.GUARD_NOTE.has(h)),
		"the opponent file names the guard effect of every guard habit the fight reads")
	var FN: GDScript = load("res://scripts/ui/modals/FightNight.gd")
	var icons_ok := FN != null
	for col in ["green", "yellow", "orange", "red"]:
		icons_ok = icons_ok and FN.GUARD_ICON.has(col) and load(str(FN.GUARD_ICON[col])) is Texture2D
	_check(icons_ok and GuardWear.colour(0.4, 1.0) == "orange" and str(FN.GUARD_ICON["orange"]).ends_with("guard_leaking.png"),
		"the corner guard line carries Ludo's icon for each colour (40% = leaking)")
	var old := FightStats.rows(FightStats.of([{"n": 1, "exchanges": [{"landed": [4, 3], "body": [1, 0], "won": true}]}]))
	_check(not old.map(func(r): return str(r["label"])).has("Punches blocked"), "an old save's bout shows no guard rows")
	# S525 damage through the guard (GUARDPROBE1 sizes): a low guard leaks more than a full one on the same blocks (control:
	# the full guard), no blocks leak nothing, amateurs wear at their own (smaller) scale, and the switch off adds no damage.
	var full: Array = GuardState.wear_through(10, 100.0, 100.0, "middle", {})
	var low_g: Array = GuardState.wear_through(10, 20.0, 100.0, "middle", {})
	_check(float(low_g[1]) > float(full[1]) * 1.3 and float(full[1]) > 0.0, "10 blocks leak more at guard 20 than at 100 (%.2f vs %.2f)" % [float(low_g[1]), float(full[1])])
	_check(float(GuardState.wear_through(0, 50.0, 100.0, "middle", {})[1]) == 0.0, "no blocks, no damage through")
	var w_am := float(GuardState.wear_through(10, 70.0, 70.0, "light", {"amateur": true})[0]) / 1.15   # amateur ctx adds +15% wear
	var w_pro := float(GuardState.wear_through(10, 70.0, 70.0, "light", {})[0])
	_check(absf(w_am / w_pro - GuardState.AMATEUR_SCALE / GuardState.WEAR_SCALE) < 0.01, "amateurs wear at AMATEUR_SCALE (%.3f of pro)" % (w_am / w_pro))
	var dm := _f(true, 75.0)
	GuardState.open(dm, 1)
	_check(float(GuardState.after(dm, [5, 5], "", {})["through"][0]) > 0.0, "an exchange returns the damage through each guard")
	print("GUARD_STATE failures=%d" % failures)
	quit(0 if failures == 0 else 1)
