extends SceneTree
## S513 INTEGRATE1 (ASKPROBE4 leftover 2 of 3): a locked fight week's LATE sparring night (5 or fewer days out) rolls its
## own cut stop (FightWeek.SPAR_LATE_CUT_STOP) and its extra injury (x SPAR_LATE_INJURY_X) on its day (Injuries.late_spar).
##   1. over many seeds: the cut stop lands near 3 % of late nights and every cut takes the boxer out of the bout;
##   2. the late injury lands more often than a plain night would, never on an early night (6+ days out) or a free day;
##   3. an unlocked week, a done bout and a boxer already out never roll.
##   4. (leftover 3 of 3) the fight week's stop banks its share of the week's pad work: DrillWeek scales the pad minutes by
##      f.fw_bank (Rest up 0.2, Tick over 0.5, Train through 1.0) only in the week the bout falls in.
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/late_spar_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## A quick-start club with one boxer whose locked fight week has a sparring night `days` out, stepped to that night.
func _club(seed: int, days: int, spar_on: int, locked := true) -> Career:
	var c := Career.quick_start()
	c.seed = seed
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["bout"] = {"day": c.day + days, "done": false, "fight_week": true, "fw_locked": locked, "spar_days": [spar_on],
		"opp": {"name": "Test Opponent"}}
	return c


func _initialize() -> void:
	var n := 2000
	var cuts := 0
	var cut_out := 0
	var hurt := 0
	var early_hurt := 0
	for s in n:
		var c := _club(1000 + s, 3, 3)
		var f: Dictionary = c.fighters[0]
		Injuries.late_spar(c)
		var inj: Dictionary = f.get("injury", {})
		if str(inj.get("type", "")) == "cut":
			cuts += 1
			if (f.get("bout", {}) as Dictionary).is_empty():
				cut_out += 1
		elif not inj.is_empty():
			hurt += 1
		var e := _club(1000 + s, 7, 7)
		Injuries.late_spar(e)
		if not (e.fighters[0].get("injury", {}) as Dictionary).is_empty():
			early_hurt += 1
	var rate := float(cuts) / n
	_check(rate > FightWeek.SPAR_LATE_CUT_STOP * 0.5 and rate < FightWeek.SPAR_LATE_CUT_STOP * 1.6,
		"late night: cut stop %.1f %% of %d (rule %.0f %%)" % [rate * 100.0, n, FightWeek.SPAR_LATE_CUT_STOP * 100.0])
	_check(cuts > 0 and cut_out == cuts, "every sparring cut takes the boxer out of the bout (%d of %d)" % [cut_out, cuts])
	_check(hurt > 0, "late night: %d injuries in %d nights" % [hurt, n])
	_check(early_hurt == 0, "an early night (7 days out) rolls nothing here (%d)" % early_hurt)
	var free_day := _club(5, 3, 4)   # the spar night is 4 days out; today is 3 out
	Injuries.late_spar(free_day)
	_check((free_day.fighters[0].get("injury", {}) as Dictionary).is_empty(), "no sparring night today: no roll")
	var quiet := 0
	for s in 300:
		var u := _club(1000 + s, 3, 3, false)
		Injuries.late_spar(u)
		var d := _club(1000 + s, 3, 3)
		d.fighters[0]["bout"]["done"] = true
		Injuries.late_spar(d)
		quiet += int(not (u.fighters[0].get("injury", {}) as Dictionary).is_empty())
		quiet += int(not (d.fighters[0].get("injury", {}) as Dictionary).is_empty())
	_check(quiet == 0, "an unlocked week and a done bout never roll (%d)" % quiet)
	var bc := _club(1, 3, 3)
	var bf: Dictionary = bc.fighters[0]
	_check(DrillWeek.fw_bank(bc, bf) == 1.0, "no fight week banked: full pad work")
	for stop in ["rest_up", "tick_over", "train_through"]:
		bf["fw_bank"] = {"share": float(FightWeek.BANK_SHARE[stop]), "day": bc.day + 3}
		var want: float = float(FightWeek.BANK_SHARE[stop])
		_check(is_equal_approx(DrillWeek.fw_bank(bc, bf), want) and FightWeek.banked(stop, 100) == roundi(100 * want),
			"%s: the week's pad work counts x%.1f (banked 100 -> %d)" % [stop, want, FightWeek.banked(stop, 100)])
	bf["fw_bank"] = {"share": 0.2, "day": bc.day + 10}
	_check(DrillWeek.fw_bank(bc, bf) == 1.0, "a bout 10 days off: this week's pads count in full")
	bf["fw_bank"] = {"share": 0.2, "day": bc.day + 2}
	var before := (bf["moves"] as Dictionary).duplicate()
	DrillWeek.run(bc, bf)
	var gain_bank := 0.0
	for m in before:
		gain_bank += float(bf["moves"][m]) - float(before[m])
	_check(not bf.has("fw_bank") or int(bf["fw_bank"]["day"]) > bc.day, "the bank stays until the bout day passes")
	var c2 := _club(1, 3, 3)
	var f2: Dictionary = c2.fighters[0]
	var before2 := (f2["moves"] as Dictionary).duplicate()
	DrillWeek.run(c2, f2)
	var gain_full := 0.0
	for m in before2:
		gain_full += float(f2["moves"][m]) - float(before2[m])
	_check(gain_full > 0.0 and gain_bank < gain_full * 0.5, "Rest up's fight week drills less onto the moves (%.2f vs %.2f)" % [gain_bank, gain_full])
	print("LATE_SPAR %s" % ("PASS" if failures == 0 else "FAIL %d" % failures))
	quit(0 if failures == 0 else 1)
