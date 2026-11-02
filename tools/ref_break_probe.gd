extends SceneTree
## S368 REFBREAK probe (Gemini 4 Argon on the S367 film, 0:21: "the referee's break crouches between them with an arm
## through Blue's waist" - true on the frames). The clinch_check.gd harness (a real FightStage, the game's cast with the
## referee, three scripted clinch holds and their breaks in ~15 s) with a pose tap on the referee too: every frame he is
## drawn, how far his arms, hands and torso sink INTO either boxer's torso or head, on the pose AS SHOWN (after the IK).
##   <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/ref_break_probe.gd
## A hand on a chest is the job (contact); deeper than THROUGH_M is a limb through a body. Prints REFBREAK lines, one per
## break, then REFBREAK_SUMMARY; the push must also reach both (a hand within TOUCH_M of each torso). FEWER THAN 3
## BREAKS measured = VOID (exit 1), never a pass.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const ClinchCheck := preload("res://tools/clinch_check.gd")

## The bounds. Never loosen one to make a line pass.
const THROUGH_M := 0.02
## During the push each boxer's torso has one of his hands this close (a gap, metres; <= 0 = touching).
const TOUCH_M := 0.05
const BREAKS_MIN := 3
const RUN_S := 16.0
## Body volumes, metres (a MetaHuman adult: torso ~0.30 wide at the chest, head ~0.22): capsules round bone segments.
const TORSO_R := 0.15
const HEAD_R := 0.11
const HEAD_UP_M := 0.08
const UPPERARM_R := 0.05
const FOREARM_R := 0.045
const HAND_R := 0.05
## Gloves/GloveClear: the hand's middle sits past the wrist along the forearm.
const HAND_FWD_M := 0.08
const BOXER_BONES := ["Head", "UpperChest", "Hips"]
const REF_BONES := ["UpperChest", "Hips", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm",
	"RightUpperArm"]

var stage: Node3D
var _view: Node
var _beat: RefCounted
var _taps: Array = []   # boxer 0, boxer 1, the referee
var _ref: Node
var _t := 0.0
var _next := 0
var _on := false
var _prev_mode := "watch"
var _breaks: Array = []   # {n, t0, t1, frames, through, worst, part, into, at, modes, parts}


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	stage = Stage.new()
	root.add_child(stage)
	var pair := Faces.pair({"name": "Lucy"}, {"name": "Maria", "stance": "orthodox"})
	stage.setup({"glb": Faces.glb(pair[0]), "corner": "red", "scale": 1.0, "stance": "orthodox"},
		{"glb": Faces.glb(pair[1]), "corner": "blue", "scale": 1.0, "stance": "orthodox"})
	FightCast.crew(stage, false)
	_view = ClinchCheck.View.new()
	_view.stage = stage
	_view._amb_rng.seed = 20261102
	root.add_child(_view)
	_beat = BeatFire.new()
	for i in 2:
		_taps.append(_tap(stage.boxers[i]["skel"], BOXER_BONES))
	_ref = stage.get("referee")
	if _ref == null:
		print("REFBREAK VOID: the cast built no referee")
		quit(1)
		return
	var rs := (_ref.get("body") as Node3D).find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	_taps.append(_tap(rs, REF_BONES))
	print("REFBREAK start: %d scripted holds, through > %.2f m" % [3, THROUGH_M])


func _tap(skel: Skeleton3D, bones: Array) -> SkeletonModifier3D:
	var tap: SkeletonModifier3D = PoseTap.new()
	tap.setup(skel, bones)
	skel.add_child(tap)
	return tap


func _process(delta: float) -> bool:
	_t += delta
	_view.t = _t
	while _next < ClinchCheck.BEATS.size() and _t >= float(ClinchCheck.BEATS[_next]["t"]):
		_beat.fire(_view, ClinchCheck.BEATS[_next])
		_next += 1
	stage.aim(RangeBreath.phase(ClinchCheck.BEATS, _next, _t))
	_watch()
	if _t >= RUN_S:
		_report()
		return true
	return false


## One break = from his step in (mode "in") through the push and the linger after it, every frame he is drawn. The
## holds come back to back, so he can stay drawn from one into the next: a new step in starts a new break.
func _watch() -> void:
	var mode := str(_ref.get("_mode"))
	var drawn: bool = bool(_ref.call("shown")) or mode != "watch"
	var stepping_in := mode == "in" and _prev_mode != "in"
	_prev_mode = mode
	if drawn and (not _on or stepping_in) and not (_on and _breaks.size() > 0 and int(_breaks[-1]["parts"]) == 0):
		_breaks.append({"n": _breaks.size() + 1, "t0": _t, "t1": _t, "frames": 0, "through": 0, "worst": -1.0,
			"part": "", "into": "", "at": 0.0, "modes": {}, "parts": 0})
	_on = drawn
	if not drawn:
		return
	var b: Dictionary = _breaks[-1]
	b["t1"] = _t
	b["frames"] = int(b["frames"]) + 1
	if mode == "part" and int(b["modes"].get("part", 0)) == 0:
		b["parts"] = 1
	b["modes"][mode] = int(b["modes"].get(mode, 0)) + 1
	var deepest := -1.0
	for limb in _ref_limbs():
		for i in 2:
			for vol in _boxer_vols(i):
				var cp := Geometry3D.get_closest_points_between_segments(limb[1], limb[2], vol[1], vol[2])
				var pen := float(limb[3]) + float(vol[3]) - cp[0].distance_to(cp[1])
				deepest = maxf(deepest, pen)
				if pen > float(b["worst"]):
					b["worst"] = pen
					b["part"] = limb[0]
					b["into"] = "%s %s" % ["red" if i == 0 else "blue", vol[0]]
					b["at"] = _t
	if deepest > THROUGH_M:
		b["through"] = int(b["through"]) + 1
	# The push must reach them: during "part", each boxer's torso gets one of his hands within TOUCH_M (a fix that keeps
	# him out of reach parts nobody).
	if mode == "part":
		for i in 2:
			var vol: Array = _boxer_vols(i)[0]
			for limb in _ref_limbs():
				if str(limb[0]).ends_with("hand"):
					var cp := Geometry3D.get_closest_points_between_segments(limb[1], limb[2], vol[1], vol[2])
					var gap := cp[0].distance_to(cp[1]) - float(limb[3]) - float(vol[3])
					var key := "touch_red" if i == 0 else "touch_blue"
					b[key] = minf(float(b.get(key, 999.0)), gap)


## [name, from, to, radius] in world space, the referee's pose as shown.
func _ref_limbs() -> Array:
	var out: Array = [["torso", _bone(2, "Hips"), _bone(2, "UpperChest"), TORSO_R]]
	for s in ["Left", "Right"]:
		var up := _bone(2, s + "UpperArm")
		var lo := _bone(2, s + "LowerArm")
		var hand := _bone(2, s + "Hand")
		var fwd := (hand - lo).normalized() * HAND_FWD_M if hand.distance_to(lo) > 0.01 else Vector3.ZERO
		out.append([s.to_lower() + " upper arm", up, lo, UPPERARM_R])
		out.append([s.to_lower() + " forearm", lo, hand, FOREARM_R])
		out.append([s.to_lower() + " hand", hand + fwd, hand + fwd, HAND_R])
	return out


func _boxer_vols(i: int) -> Array:
	var head := _bone(i, "Head") + Vector3.UP * HEAD_UP_M
	return [["torso", _bone(i, "Hips"), _bone(i, "UpperChest"), TORSO_R], ["head", head, head, HEAD_R]]


func _bone(i: int, bone: String) -> Vector3:
	var shown: Dictionary = (_taps[i] as SkeletonModifier3D).shown
	var skel := (_taps[i] as SkeletonModifier3D).get_skeleton()
	if shown.has(bone) and skel != null:
		return skel.global_transform * (shown[bone] as Vector3)
	return (skel.global_position if skel != null else Vector3.ZERO)


func _report() -> void:
	var worst := -1.0
	var through := 0
	var frames := 0
	var reach := -1.0
	for b in _breaks:
		worst = maxf(worst, float(b["worst"]))
		through += int(b["through"])
		frames += int(b["frames"])
		var tr := float(b.get("touch_red", 999.0))
		var tb := float(b.get("touch_blue", 999.0))
		reach = maxf(reach, maxf(tr, tb))
		print("REFBREAK break=%d t=%.2f-%.2f frames=%d worst_pen_m=%.3f part=%s into=%s at_t=%.2f through_frames=%d touch_red_m=%.3f touch_blue_m=%.3f modes=%s" % [
			int(b["n"]), float(b["t0"]), float(b["t1"]), int(b["frames"]), float(b["worst"]), str(b["part"]),
			str(b["into"]), float(b["at"]), int(b["through"]), tr, tb, str(b["modes"])])
	if _breaks.size() < BREAKS_MIN:
		print("REFBREAK_SUMMARY VOID: %d breaks measured (need %d)" % [_breaks.size(), BREAKS_MIN])
		quit(1)
		return
	var ok := through == 0 and reach <= TOUCH_M
	print("REFBREAK_SUMMARY breaks=%d worst_pen_m=%.3f through_frames=%d of %d worst_touch_m=%.3f %s" % [_breaks.size(),
		worst, through, frames, reach, "PASS" if ok else "FAIL"])
	quit(0 if ok else 1)
