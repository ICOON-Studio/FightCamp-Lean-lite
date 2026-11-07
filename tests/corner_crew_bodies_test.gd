extends SceneTree
## S399: no two people in the corners share a body in an amateur bout (fighter-look critics: "the same coach and second in
## both corners"). Pure: reads CornerCrew.body_for, loads no model. Prints CORNER_CREW_BODIES failures=<n>.
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
var failures := 0


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _initialize() -> void:
	var am: Array = []
	for role in CornerCrew.BODIES:
		var b: String = CornerCrew.body_for(role, false)
		if b != "":
			am.append(b)
	_check(am.size() == 4, "amateur bout: 4 corner people (%d)" % am.size())
	var uniq := {}
	for b in am:
		uniq[b] = true
	_check(uniq.size() == am.size(), "amateur bout: every corner face differs %s" % str(am))
	_check(CornerCrew.body_for("blue_second", false) != CornerCrew.body_for("second", false), "blue's second is not red's second")
	_check(CornerCrew.body_for("cutman", true) != "", "pro bout: the cutman is there")
	print("CORNER_CREW_BODIES failures=%d" % failures)
	quit(1 if failures else 0)
