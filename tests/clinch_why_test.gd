extends SceneTree
## R11E: every random swing gets a readable reason - the clinch shot that landed says WHY.
## ClinchRest.why(opp_style, opp_rating, technique) is a pure static: first match wins.
##   1. opp_rating - technique >= 10: "more technique keeps that hand quiet"
##   2. style bonus > 0: "a <style> works in there"
##   3. otherwise ""
## ClinchRest.line(c, names, reason) appends ": <reason>." when the shot landed and reason != "".
## A clinch with no shot or no reason reads exactly as today. Two-arg call unchanged.
## LiveRound passes the why through on a real exchange.

const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

var failures := 0


func _initialize() -> void:
	_test_why_branches()
	_test_why_priority()
	_test_line_with_reason()
	_test_line_no_shot_unchanged()
	_test_line_two_args_unchanged()
	_test_live_exchange_carries_reason()
	print("CLINCH_WHY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Rule 1 branch 1: opp_rating - technique >= 10 -> technique reason.
func _test_why_branches() -> void:
	var r1 := ClinchRest.why("Out-boxer", 70.0, 55.0)
	_check(r1 == "more technique keeps that hand quiet", "branch 1: rating gap >= 10 -> technique reason (got '%s')" % r1)
	## Rule 1 branch 2: style bonus > 0 (and gap < 10) -> style reason.
	var r2 := ClinchRest.why("Pressure fighter", 60.0, 55.0)
	_check(r2 == "a pressure fighter works in there", "branch 2: style bonus > 0 -> style reason (got '%s')" % r2)
	var r2b := ClinchRest.why("Slugger", 60.0, 55.0)
	_check(r2b == "a slugger works in there", "branch 2b: slugger bonus > 0 (got '%s')" % r2b)
	## Rule 1 branch 3: no bonus, gap < 10 -> "".
	var r3 := ClinchRest.why("Out-boxer", 60.0, 55.0)
	_check(r3 == "", "branch 3: out-boxer bonus <= 0 and gap < 10 -> empty (got '%s')" % r3)
	var r3b := ClinchRest.why("Counter-puncher", 60.0, 55.0)
	_check(r3b == "", "branch 3b: counter-puncher bonus <= 0 (got '%s')" % r3b)


## When both conditions apply (gap >= 10 AND style bonus > 0), technique wins.
func _test_why_priority() -> void:
	var r := ClinchRest.why("Pressure fighter", 70.0, 55.0)
	_check(r == "more technique keeps that hand quiet", "priority: gap >= 10 wins over style bonus (got '%s')" % r)


## line() with a landed shot and a non-empty reason appends ": <reason>." instead of ".".
func _test_line_with_reason() -> void:
	var hit := {"hit": true, "shots": 1, "head": false, "edge": ClinchRest.HIT_EDGE, "damage": 0.0}
	var names := ["Lucy", "Maria"]
	var out := ClinchRest.line(hit, names, "more technique keeps that hand quiet")
	_check(out.ends_with(": more technique keeps that hand quiet."), "landed shot + reason -> ': <reason>.' (got '%s')" % out)
	var out2 := ClinchRest.line(hit, names, "a pressure fighter works in there")
	_check(out2.ends_with(": a pressure fighter works in there."), "style reason appended (got '%s')" % out2)


## A clinch with no shot reads exactly as today, regardless of reason.
func _test_line_no_shot_unchanged() -> void:
	var miss := {"hit": false, "shots": 0, "head": false, "edge": 0.0, "damage": 0.0}
	var names := ["Lucy", "Maria"]
	var out := ClinchRest.line(miss, names, "more technique keeps that hand quiet")
	_check(out == "Your boxer ties the opponent up and gets a breather.", "no shot + reason -> clean tie-up line (got '%s')" % out)
	var out2 := ClinchRest.line(miss, names)
	_check(out2 == "Your boxer ties the opponent up and gets a breather.", "no shot, no reason -> same clean line (got '%s')" % out2)


## Calling line with two arguments returns exactly what it returns today (backward compatible).
func _test_line_two_args_unchanged() -> void:
	var hit := {"hit": true, "shots": 2, "head": false, "edge": ClinchRest.HIT_EDGE * 2, "damage": 0.0}
	var names := ["Lucy", "Maria"]
	var out := ClinchRest.line(hit, names)
	_check(out == "Your boxer ties the opponent up and gets a breather, but the opponent digs two short ones to the ribs.", "two-arg landed shot (S448: roles) (got '%s')" % out)
	var miss := {"hit": false, "shots": 0, "head": false, "edge": 0.0, "damage": 0.0}
	_check(ClinchRest.line(miss, names) == "Your boxer ties the opponent up and gets a breather.", "two-arg clean tie (S448: roles)")
	_check(ClinchRest.line({}, names) == "", "two-arg empty clinch unchanged")


## A real exchange through LiveRound whose clinch_line carries the reason when the shot lands.
func _test_live_exchange_carries_reason() -> void:
	var found_reason := false
	var found_clean := false
	for seed in 200:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + seed
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = [{"move": "1-1"}, {"move": "tie_up"}, {"move": "step_back"}]
		f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		for r in m["rounds"]:
			for x in r["exchanges"]:
				var cl: Dictionary = x.get("clinch", {})
				if cl.is_empty():
					continue
				var line_text: String = str(x.get("clinch_line", ""))
				if bool(cl.get("hit", false)):
					if line_text.contains(": "):
						found_reason = true
				else:
					if not line_text.contains(": "):
						found_clean = true
		if found_reason and found_clean:
			break
	_check(found_reason, "a real exchange with a landed clinch shot carries ': <reason>' in its line")
	_check(found_clean, "a real exchange with no shot stays clean (no ': ')")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
