extends SceneTree
## S537 STEPPAY3: the moment "short" gives step_in its place in the fight. The opponent boxes at range and her jab falls short:
## fought from outside her reach, step in behind it.
## rules/StepMoment.gd deals it, PlanFight.ANSWERS grades it. Red on main (no rule, no row). Checks: tests/step_moment_kit.gd.

const Kit := preload("res://tests/step_moment_kit.gd")


func _initialize() -> void:
	var fails := Kit.run("short", "step_in", "Holly Price",
		[["range", "long", false], ["range", "outside", true]],
		[["press", "long", true], ["counter", "long", true], ["loadup", "outside", false], ["she_tired", "long", false], ["tiring", "long", true], ["range", "own_ropes", false]], "press")
	if not Kit.finished:
		fails += 1
		print("FAIL the checks did not run to the end (script error above)")
	print("step_moment_short_test: %s (%d failures)" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)
