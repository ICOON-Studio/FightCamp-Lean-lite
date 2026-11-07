extends SceneTree
## S396 fight polish from the 5.5 blind review: the big-shot moment needs a sight line, the walk joins slowly, the corner
## card follows the cut, and the corner lens has no near blur (it bled the hall through the coach).
## Prints FIGHT_POLISH checks=<n> failures=<n>.

const FightCalls := preload("res://scripts/fight3d/FightCalls.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	var eye := Vector3(0, 1.6, -4)
	var head := Vector3(0, 1.6, 0.5)
	_check(FightCalls.hidden(eye, head, [Vector3(0.05, 1.6, -0.3)]), "a thrower's head on the sight line hides the blow")
	_check(not FightCalls.hidden(eye, head, [Vector3(0.6, 1.6, -0.3)]), "a thrower beside the line does not")
	_check(not FightCalls.hidden(eye, head, [Vector3(0.0, 1.6, 1.2)]), "a thrower behind the hit head does not")
	_check(CornerCrew.WALK_JOIN.y >= 0.6, "the guard drops into the walk over at least 0.6 s (%.2f)" % CornerCrew.WALK_JOIN.y)
	_check(CornerOverlay.CARD_AFTER_CUT_S >= 0.3, "the corner card comes up after the cut, not on it")
	var cam := FileAccess.get_file_as_string("res://scripts/fight3d/RingCamera.gd")
	_check(cam.contains("dof_blur_near_enabled = false") and not cam.contains("dof_blur_near_enabled = shallow"), "no near blur on the corner lens")
	var minute := FileAccess.get_file_as_string("res://scripts/fight3d/CornerMinute.gd")
	_check(minute.contains("frame_at(p, subject"), "beside the card the two-shots frame her face")
	var crew := FileAccess.get_file_as_string("res://scripts/fight3d/CornerCrew.gd")
	_check(crew.contains("set_target(ap, clip)"), "a corner join names its clip, so the smoother blends it (it waited for a fight clip)")
	_check(CornerCrew.TEAM_SHIRT.has("second") and CornerCrew.TEAM_SHIRT["second"].get_luminance() > 0.1, "the second's shirt reads against the dark hall")
	print("FIGHT_POLISH checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL ", what)
