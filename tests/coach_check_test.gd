extends SceneTree
## S387 CoachCheck: the eight checks read the career's real state and each points at the place that fixes it.

const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var failures := 0


func _initialize() -> void:
	var c := Career.quick_start()
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var f: Dictionary = c.fighter()
	var r := _by_key(CoachCheck.rows(c, f))
	_check(r.size() == 8, "eight checks")
	_check(_state(r, "fit") == "ok", "a fresh fighter is fit")
	_check(_state(r, "weight") == "warn", "over the limit with no bout: a warning, %s" % r["weight"]["word"])
	_check(_state(r, "fight") == "warn" and str(r["fight"]["arg"]) == "fights:0", "no bout points at the offers")
	_check(_state(r, "camp") == "off" and _state(r, "file") == "off" and _state(r, "plan") == "off", "camp, file and plan are not due yet")
	var s := CoachCheck.score(CoachCheck.rows(c, f))
	_check(int(s[1]) == 5, "only the due checks count: %d" % int(s[1]))

	f["week_fatigue"] = 80.0
	r = _by_key(CoachCheck.rows(c, f))
	_check(_state(r, "fit") == "bad", "overcooked (80, the whiteboard's scale) is red")
	f["week_fatigue"] = 0.0
	f["morale"] = 0.0
	r = _by_key(CoachCheck.rows(c, f))
	_check(_state(r, "mood") == "bad", "low morale is red")
	f["morale"] = 70.0
	f["weight"] = float(f["limit"]) - 1.0
	r = _by_key(CoachCheck.rows(c, f))
	_check(_state(r, "weight") == "ok", "under the limit is green")

	var before := JSON.stringify(f)
	CoachCheck.rows(c, f)
	_check(JSON.stringify(f) == before, "reading the checks changes nothing")

	f["arrows"] = [{"at": "x"}]
	f["bout"] = {"day": c.day + 21, "opp": (c.rivals[0] as Dictionary).duplicate(true), "done": false}
	r = _by_key(CoachCheck.rows(c, f))
	_check(_state(r, "fight") == "ok", "a booked bout is green: %s" % r["fight"]["word"])
	_check(_state(r, "camp") == "bad" and str(r["camp"]["act"]) == "camp", "a due camp is red and opens the camp")
	_check(_state(r, "file") == "warn", "an unread file warns: %s" % r["file"]["word"])
	_check(_state(r, "plan") == "ok", "a written plan is green")
	f["arrows"] = []
	r = _by_key(CoachCheck.rows(c, f))
	_check(_state(r, "plan") == "warn", "a booked bout with no plan warns")
	print("COACH_CHECK failures=%d" % failures)
	print("PASS coach_check_test" if failures == 0 else "FAIL coach_check_test")
	quit(failures)


func _by_key(rows: Array) -> Dictionary:
	var out := {}
	for x in rows:
		out[str(x["key"])] = x
	return out


func _state(r: Dictionary, key: String) -> String:
	return str(r[key]["state"])


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
