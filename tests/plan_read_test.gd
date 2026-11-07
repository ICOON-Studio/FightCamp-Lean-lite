extends SceneTree
## S396 rank 3 (PlanRead): reads build on right answers that land, the opponent's on wrong ones punished, both capped;
## a right answer leaned on loses its edge after FREE_USES. Prints PLAN_READ checks=<n> failures=<n>.

const PlanRead := preload("res://scripts/rules/PlanRead.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_check(PlanRead.after(0, "best", true, true) == 1, "a right answer that lands reads her")
	_check(PlanRead.after(0, "best", true, false) == 0, "a right answer that misses reads nothing")
	_check(PlanRead.after(0, "wrong", true, false) == -1, "a wrong answer punished gives the opponent the read")
	_check(PlanRead.after(0, "best", false, true) == 0, "an improvised move reads nothing")
	_check(PlanRead.after(PlanRead.MAX_READS, "best", true, true) == PlanRead.MAX_READS, "reads cap")
	_check(PlanRead.edge(-5) == -PlanRead.MAX_READS * PlanRead.STACK_EDGE, "the opponent's reads cap too")
	_check(is_equal_approx(PlanRead.adjust(PlanRead.FREE_USES), 1.0) and PlanRead.adjust(PlanRead.FREE_USES + 2) < 0.5,
		"leaning on one answer stops paying")
	print("PLAN_READ checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL ", what)
