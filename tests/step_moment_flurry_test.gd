extends SceneTree
## S537 STEPPAY3: the moment "flurry" gives roll_out its place in the fight. On your own ropes against a presser or a loader she
## steps in close with hooks: fought inside, roll under and out.
## rules/StepMoment.gd deals it, PlanFight.ANSWERS grades it. Red on main (no rule, no row). Checks: tests/step_moment_kit.gd.

const Kit := preload("res://tests/step_moment_kit.gd")


func _initialize() -> void:
	var fails := Kit.run("flurry", "roll_out", "Jade Cooper",
		[["loadup", "own_ropes", false], ["press", "own_ropes", true]],
		[["range", "own_ropes", false], ["counter", "own_ropes", false], ["loadup", "mid", false], ["she_hurt", "own_ropes", false], ["tiring", "own_ropes", false]], "tiring")
	if not Kit.finished:
		fails += 1
		print("FAIL the checks did not run to the end (script error above)")
	print("step_moment_flurry_test: %s (%d failures)" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)
