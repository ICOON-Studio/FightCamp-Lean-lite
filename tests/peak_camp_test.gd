extends SceneTree
## S356 the peak-camp bonus (PeakCamp + BoutNight):
##   1. the camp's goal: her focus stat two points up, her FighterGoal's target when it names that stat,
##   2. all three lines met = peak; one missed names what was missed,
##   3. the bonus is for the fight only: +1 every stat at the first bell, every point back at the result, the gold line
##      leads the result's reasons and reaches the week review,
##   4. control arm: the same camp overreached (fatigue peak 85) fights at her own stats and says why.
## Population: Lucy Jackson (Data.lucy, out-boxer) vs Maria Ortega (Data.OPPONENTS[0], pressure fighter).

const Data := preload("res://scripts/state/Data.gd")
const PeakCamp := preload("res://scripts/rules/PeakCamp.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

var _fails := 0


func _initialize() -> void:
	var st := {"technique": 61.4, "power": 55.0}
	_check(PeakCamp.goal(st, "technique", {}) == {"stat": "technique", "target": 63.0}, "goal: technique 61.4 -> target 63")
	_check(float(PeakCamp.goal(st, "technique", {"stat": "technique", "target": 64.5})["target"]) == 64.5
		and float(PeakCamp.goal(st, "technique", {"stat": "power", "target": 70.0})["target"]) == 63.0, "her FighterGoal's target only for the same stat")
	var f := {"weight": 61.2, "limit": 61.2, "stats": {"technique": 63.0}}
	var camp := {"goal": {"stat": "technique", "target": 63.0}, "peak": 70.0}
	_check(PeakCamp.met(PeakCamp.lines(camp, f)), "on weight, on target, never overreached: peak")
	f["weight"] = 61.4
	var miss := PeakCamp.line("Lucy", PeakCamp.lines(camp, f))
	_check(not PeakCamp.met(PeakCamp.lines(camp, f)) and miss.contains("weight"), "0.2 kg over: %s" % miss)
	_check(PeakCamp.lines({}, f).is_empty() and PeakCamp.line("Lucy", []) == "", "no camp goal: no line")
	var s2 := {"a": 98.5, "b": 50.0}
	var add := PeakCamp.boost(s2, PeakCamp.CAP)
	PeakCamp.unboost(s2, add)
	_check(is_equal_approx(float(add["a"]), 0.5) and s2 == {"a": 98.5, "b": 50.0}, "the cap holds and every point goes back")

	var on := _bout(70.0)
	var off := _bout(85.0)
	_check(bool(on["boosted"]) and not bool(off["boosted"]), "first bell: peak camp +1 every stat (%s), overreached none" % [on["during"]])
	_check(bool(on["back"]) and bool(off["back"]), "after the result her stats are her own again")
	_check(str(on["why0"]).begins_with("Peak camp") and str(on["review"]).begins_with("Peak camp"), "the gold line leads the reasons and goes in the review")
	_check(str(off["why0"]).begins_with("No peak bonus") and str(off["why0"]).contains("fatigue"), "control: %s" % off["why0"])
	print("PEAK_CAMP %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


## Lucy's bout after a camp whose goal she met, with this fatigue peak: was she +1 in round 1, are her stats back after.
func _bout(peak: float) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 30
	var f: Dictionary = c.fighter()
	f["weight"] = float(f["limit"])
	var before: Dictionary = (f["stats"] as Dictionary).duplicate()
	f["camp"] = {"focus": "technique", "protocol": 2, "film": false, "start": 9,
		"goal": {"stat": "technique", "target": float(before["technique"])}, "peak": peak}
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	BoutNight.fight_step(c, f, m, "start")
	var boosted := true
	for k in before:
		boosted = boosted and is_equal_approx(float(f["stats"][k]), minf(PeakCamp.CAP, float(before[k]) + PeakCamp.BONUS))
	var during := "technique %.1f -> %.1f" % [float(before["technique"]), float(f["stats"]["technique"])]
	BoutNight.fight_step(c, f, m, "rest")
	var back := true
	for k in before:
		back = back and is_equal_approx(float(f["stats"][k]), float(before[k]))
	return {"boosted": boosted, "during": during, "back": back, "why0": str((m["why"] as Array)[0]) if not (m["why"] as Array).is_empty() else "",
		"review": str(f.get("peak_line", ""))}


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
