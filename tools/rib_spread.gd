extends "res://tests/rib_damage_test.gd"
## S439 merge prep: rib_damage_test's arms on another seed window, read-only (no bar here, the test's own _judge prints
## its PASS/FAIL lines with the numbers). Args after --: from=<first day> (the test's window is 1000..1199; a window is
## SEEDS = 200 days), notank (her Tank off at the first bell forced to 0, as main's no-camp bout had).
## Run on the branch and on main's scripts swapped in, to read the spread of "body plan target more-hit rib at or under
## 35" and "S318 loser hurt" across disjoint windows. S439: the test itself now reads eight windows for those two (from its
## first day on); from=<day> shifts the whole set. tools/rib_sweep.gd replays the same windows at other hit sizes.

var _off := 0
var _notank := false


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("from="):
			_off = int(str(a).substr(5)) - 1000
		elif str(a) == "notank":
			_notank = true
	print("RIB_SPREAD window days %d..%d notank=%s" % [1000 + _off, 1199 + _off, str(_notank)])
	super._initialize()


func _fresh(c: Career, day: int) -> Dictionary:
	var f: Dictionary = super._fresh(c, day + _off)
	if _notank:
		f["bout"]["stale"] = 0.0
	return f


var _shown := false


func _fight(c: Career, f: Dictionary, plan: String, aim: String, tag: String) -> Dictionary:
	var r: Dictionary = super._fight(c, f, plan, aim, tag)
	if not _shown:
		_shown = true
		print("RIB_SPREAD first bout: Tank off at the first bell %.2f (%s)" % [float(f["bout"].get("stale", 0.0)), str(f["bout"].get("tank_why", "-"))])
	return r


func _header() -> void:
	super._header()
	var st: Dictionary = _base["stats"]
	var at: Dictionary = (load("res://scripts/rules/Attrs.gd") as GDScript).call("of", _base.duplicate(true))
	print("RIB_SPREAD her conditioning %.1f stamina %s recovery %s week_fatigue %s" % [float(st.get("conditioning", -1.0)),
		str(at.get("stamina", "-")), str(at.get("recovery", "-")), str(_base.get("week_fatigue", "-"))])
