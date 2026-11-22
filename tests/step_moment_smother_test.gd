extends SceneTree
## S537 STEPPAY3: the moment "smother" gives push_off its place in the fight. A presser walks chest to chest at mid range or
## inside: fought in the clinch, push off and make room.
## rules/StepMoment.gd deals it, PlanFight.ANSWERS grades it. Red on main (no rule, no row). Checks: tests/step_moment_kit.gd.

const Kit := preload("res://tests/step_moment_kit.gd")


func _initialize() -> void:
	var fails := Kit.run("smother", "push_off", "Maria Ortega",
		[["press", "mid", false], ["press", "inside", true]],
		[["loadup", "mid", false], ["range", "mid", false], ["press", "long", false], ["press", "outside", false], ["she_tired", "mid", false], ["tiring", "inside", false]], "tiring")
	if not Kit.finished:
		fails += 1
		print("FAIL the checks did not run to the end (script error above)")
	print("step_moment_smother_test: %s (%d failures)" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)
