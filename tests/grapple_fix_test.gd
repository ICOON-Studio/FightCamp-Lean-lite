extends "res://tools/grapple_orbit.gd"
## S399 GRAPPLEFIX1: the five worst played grappling moves AS THE GAME DRAWS THEM (tools/grapple_orbit.gd's game arm: GrapplePlayer
## contact on, GrapplePose IK, GrappleGrip, the belt match's pacing; bones read on Skeleton3D.skeleton_updated) hold the bars.
## The five are main's worst on ops/research/GRAPPLEFIX1_TABLE.md (S399): Drop Seoi Nage, Leg Weave Takedown, Hail Mary Escape,
## To Perpendicular Triangle, To Mounted Arm Triangle. Bars (TASK_GRAPPLEFIX1, never loosened):
##   torso inside the other's torso <= 3 cm; a limb or head parked inside her torso or head <= 2 cm for over 0.2 s;
##   a one-frame pop <= 3 cm; jerk p95 <= 60 m/s^3; direction flips <= 0.1 /s a bone.

const WORST := ["1140l", "1470l", "1198", "680", "727"]
const BAR := {"torso_in_m": 0.03, "limb_park_m": 0.02, "spike_m": 0.03, "jerk_p95": 60.0, "flips_s": 0.1}

var failures := 0


func _initialize() -> void:
	game = true
	nofilm = true
	var rows: Array = await measure(WORST)
	_check(rows.size() == WORST.size(), "all %d moves measured (%d)" % [WORST.size(), rows.size()])
	for r in rows:
		for k in BAR:
			var v := float(r.get(k, INF))
			_check(v <= float(BAR[k]), "%s %s: %s %.3f <= %.3f%s" % [r["id"], r["title"], k, v, float(BAR[k]),
				("  (" + str(r.get("limb_park_at", ""))) + ")" if k == "limb_park_m" else ("  (" + str(r.get("jerk_worst", "")) + ")" if k == "jerk_p95" else "")])
	print("GRAPPLE_FIX failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
