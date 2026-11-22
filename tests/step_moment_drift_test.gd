extends SceneTree
## S537 STEPPAY3: the moment "drift" gives herd its place in the fight. Your boxer won the last exchange against a mover
## (range, counter): she is on the ropes sliding off to the open side, herd her back.
## rules/StepMoment.gd deals it, PlanFight.ANSWERS grades it. Red on main (no rule, no row). Checks: tests/step_moment_kit.gd.

const Kit := preload("res://tests/step_moment_kit.gd")


func _initialize() -> void:
	var fails := Kit.run("drift", "herd", "Erin Doyle",
		[["range", "long", true], ["range", "mid", true], ["counter", "outside", true]],
		[["range", "long", false], ["press", "long", true], ["loadup", "mid", true], ["she_tired", "long", true], ["hurt", "mid", true], ["range", "own_ropes", true]], "press")
	if not Kit.finished:
		fails += 1
		print("FAIL the checks did not run to the end (script error above)")
	print("step_moment_drift_test: %s (%d failures)" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)
