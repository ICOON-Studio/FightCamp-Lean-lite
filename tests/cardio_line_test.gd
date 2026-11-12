extends SceneTree
## S433 CARDIO1 (TRAINING_MAP F3, CORE_LOOP C1 / C3): one row, one number. The round-3 fade, the round's energy cost and
## the minute's refill read Stamina / Recovery, never the mean of the two (the old "conditioning"); a goal names an
## ability. Population: BalanceHarness's live-bout fighter (avg 60, every move at 30, the first opponent) with its
## abilities set by hand, two of them differing only in Stamina or only in Recovery; play_round's stat blocks.
##   1. The night line is Stamina's, at FADE_STAMINA (S434 FADESHARE round 2: 60, measured on 1,030 bouts at fight time, main's
##      share of fading bouts 64.6%, line 60 63.6%, 59 58.5% (out of the 5-point bar); numbers in BoutRules' comment and
##      tools/fade_share.gd; round 1's 59 was measured on signing day only); the mean has no line.
##   2. play_round: the fade is the design's slope (TRAINING_MAP F3), OWN_FADE x clamp(0.25 x (line - Stamina), 0, 2): the
##      line none, 2 under 0.5, 4 under 1.0, 8 or more under 2.0; Stamina at the line with Recovery 50 (a mean under it) has
##      none; Stamina 1 under with Recovery 70 (a mean over it) fades 0.25.
##   3. The bout's tank (Bouts._energy -> BoutNight, and BoutRead's read of it): round 1's cost moves with Stamina and not
##      with Recovery; the minute's refill moves with Recovery and not with Stamina.
##   4. FighterGoal: the keys are the 14 abilities; "Stamina for five rounds" targets Stamina; a goal "Stamina 63" is met
##      when Stamina reaches 63 (whatever Recovery and the mean say); a goal can name Footwork; no trust_delta.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const BalanceHarness := preload("res://scripts/rules/BalanceHarness.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	# 1.
	var line := BoutRules.FADE_STAMINA
	_check(is_equal_approx(line, 60.0), "the line sits where FADESHARE at fight time put it, 60 (got %.1f)" % line)
	_check(BoutRules.clears_night_line("stamina", line) and not BoutRules.clears_night_line("stamina", line - 0.01),
		"Stamina %.0f clears the round-3 line, %.2f does not" % [line, line - 0.01])
	_check(BoutRules.night_line("conditioning").is_empty(), "the mean of Stamina and Recovery carries no line")
	# 2.
	var base := {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 60.0, "fight_iq": 60.0, "chin": 60.0}
	var camp := {"protocol": 2}
	var opp := {"rating": 60.0}
	var fit := base.duplicate()
	fit.merge({"stamina": line, "recovery": 50.0, "conditioning": (line + 50.0) / 2.0})
	var fade_fit := _fade(fit, camp, opp)
	_check(is_zero_approx(fade_fit), "Stamina %.0f, Recovery 50: no own fade in round 3 (got %.2f)" % [line, fade_fit])
	var short := base.duplicate()
	short.merge({"stamina": line - 1.0, "recovery": 70.0, "conditioning": (line - 1.0 + 70.0) / 2.0})
	var fade_short := _fade(short, camp, opp)
	_check(is_equal_approx(fade_short, 0.25), "Stamina %.0f, Recovery 70: fades 0.25 in round 3 (got %.2f)" % [line - 1.0, fade_short])
	for row in [[0.0, 0.0], [2.0, 0.5], [4.0, 1.0], [8.0, 2.0], [20.0, 2.0], [-6.0, 0.0]]:
		var st := base.duplicate()
		st["stamina"] = line - float(row[0])
		var got := _fade(st, camp, opp)
		_check(is_equal_approx(got, float(row[1])) and is_equal_approx(BoutRules.own_fade(line - float(row[0])), float(row[1])),
			"the slope: Stamina %.0f fades %.2f (got %.3f)" % [line - float(row[0]), float(row[1]), got])
	# 3.
	var s70 := _tank(70.0, 50.0)
	var s50 := _tank(50.0, 50.0)
	var r70 := _tank(60.0, 70.0)
	var r50 := _tank(60.0, 50.0)
	_check(float(s70["end1"]) > float(s50["end1"]) + 0.5, "round 1 costs less at Stamina 70 than 50: %.2f vs %.2f" % [s70["end1"], s50["end1"]])
	_check(is_equal_approx(float(r70["end1"]), float(r50["end1"])), "Recovery does not change round 1's cost: %.2f vs %.2f" % [r70["end1"], r50["end1"]])
	_check(float(r70["back"]) > float(r50["back"]) + 0.2, "the minute gives back more at Recovery 70 than 50: %.2f vs %.2f" % [r70["back"], r50["back"]])
	_check(is_equal_approx(float(s70["back_share"]), float(s50["back_share"])),
		"Stamina does not change the refill's share of the debt: %.3f vs %.3f" % [s70["back_share"], s50["back_share"]])
	_check(is_equal_approx(float(s70["read_end1"]), float(s70["end1"])) and is_equal_approx(float(r70["read_end1"]), float(r70["end1"])),
		"BoutRead's read of round 1 agrees with the bout's tank")
	_check(is_equal_approx(float(r70["read_end1"]), float(r50["read_end1"])), "BoutRead: Recovery does not change round 1's cost")
	# 4.
	_check(FighterGoal.STAT_KEYS.size() == 14 and FighterGoal.STAT_KEYS.has("stamina") and FighterGoal.STAT_KEYS.has("footwork")
		and not FighterGoal.STAT_KEYS.has("conditioning"), "goal keys are the 14 abilities: %s" % str(FighterGoal.STAT_KEYS))
	var f := _goal_fighter(60.5, 50.0)
	var g := FighterGoal.goal_for(f, "five_round_engine", 0)
	var tg: Dictionary = g.get("targets", {})
	_check(tg.has("stamina") and is_equal_approx(float(tg.get("stamina", 0.0)), 63.0) and not tg.has("conditioning"),
		"'Stamina for five rounds' is Stamina 60.5 + 2.5 = 63: %s" % str(tg))
	# S434: it aims at the fade line when the line is 3 or fewer points away (Lucy's 56.4 is 3.6 under 60: +2.5), else +2.5.
	var near := FighterGoal.goal_for(_goal_fighter(line - 2.6, 60.0), "five_round_engine", 0)
	_check(is_equal_approx(float((near["targets"] as Dictionary)["stamina"]), line),
		"'Stamina for five rounds' 2.6 under the line aims at the line %.0f: %s" % [line, str(near["targets"])])
	var far := FighterGoal.goal_for(_goal_fighter(line - 5.0, 60.0), "five_round_engine", 0)
	_check(is_equal_approx(float((far["targets"] as Dictionary)["stamina"]), line - 2.5),
		"5 under the line it is +2.5: %s" % str(far["targets"]))
	var met := FighterGoal.progress(g, _goal_fighter(63.0, 40.0), 10, {})
	_check(str(met.get("status", "")) == "MET", "goal Stamina 63 met at Stamina 63 with Recovery 40 (mean 51.5): %s" % str(met.get("status")))
	var short_goal := FighterGoal.progress(g, _goal_fighter(62.8, 80.0), 10, {})
	_check(str(short_goal.get("status", "")) != "MET", "goal Stamina 63 not met at Stamina 62.8 with Recovery 80 (mean 71.4)")
	var fw := {"id": "x", "title": "Footwork 60", "start_day": 0, "deadline_day": 28, "targets": {"footwork": 60.0},
		"start_stats": {"footwork": 57.0}}
	var fw_now := _goal_fighter(60.0, 60.0)
	(fw_now["attrs"] as Dictionary)["footwork"] = 60.0
	_check(str(FighterGoal.progress(fw, fw_now, 5, {})["status"]) == "MET", "a goal can be Footwork 60")
	var out := FighterGoal.outcome(g, true)
	_check(not out.has("trust_delta") and int(out.get("morale_delta", 0)) > 0, "a met goal moves mood only: %s" % str(out))
	print("CARDIO_LINE checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _fade(stats: Dictionary, camp: Dictionary, opp: Dictionary) -> float:
	return float(BoutRules.play_round(2, stats, camp, 0, "", opp, 0.5, 0.5)["mine"]) \
		- float(BoutRules.play_round(3, stats, camp, 0, "", opp, 0.5, 0.5)["mine"])


## The live-bout fighter with Stamina and Recovery set; round 1's bell energy, what the minute gave back and BoutRead's read.
func _tank(stamina: float, recovery: float) -> Dictionary:
	var f := BalanceHarness.make_fighter(60, 60.0, {}, 0)
	var a := Attrs.of(f).duplicate()
	a["stamina"] = stamina
	a["recovery"] = recovery
	f["attrs"] = a
	Attrs.sync(f)
	var opp: Dictionary = f["bout"]["opp"]
	var read: Array = BoutRead._energy(f, opp)
	var e1 := Bouts._energy(f, 1, "")
	var e2 := Bouts._energy(f, 2, "")
	var end1 := float(e1["a_end"])
	var back := float(e2["a"]) - end1
	var debt := float(e1["a"]) - end1
	return {"end1": end1, "back": back, "back_share": back / maxf(0.001, debt), "read_end1": float((read[0] as Dictionary)["a_end"])}


func _goal_fighter(stamina: float, recovery: float) -> Dictionary:
	var a := {}
	for k in Attrs.ABILITIES:
		a[k] = 58.0
	a["stamina"] = stamina
	a["recovery"] = recovery
	return {"attrs": a, "stats": {"power": 58.0, "technique": 58.0, "speed": 58.0, "defense": 58.0,
		"conditioning": (stamina + recovery) / 2.0, "fight_iq": 58.0, "chin": 58.0}, "booked_fight": true}


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)
