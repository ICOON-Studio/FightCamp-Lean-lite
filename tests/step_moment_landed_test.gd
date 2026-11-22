extends SceneTree
## S537 STEPPAY3: the moment "landed" gives step_out its place in the fight. Your boxer won the last exchange at long or mid
## range against a presser or a loader: she stands at the end of her punches, the return is coming, step out before it.
## rules/StepMoment.gd deals it, PlanFight.ANSWERS grades it. Red on main (no rule, no row). Checks: tests/step_moment_kit.gd.

const Kit := preload("res://tests/step_moment_kit.gd")


func _initialize() -> void:
	var fails := Kit.run("landed", "step_out", "Jade Cooper",
		[["press", "long", true], ["loadup", "long", true], ["loadup", "mid", true]],
		[["press", "long", false], ["range", "long", true], ["counter", "long", true], ["press", "inside", true], ["loadup", "own_ropes", true], ["she_hurt", "long", true], ["hurt", "long", true]], "range")
	if not Kit.finished:
		fails += 1
		print("FAIL the checks did not run to the end (script error above)")
	print("step_moment_landed_test: %s (%d failures)" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)
