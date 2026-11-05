extends SceneTree
## S383d KneeTrack hysteresis (operator on the owned-mocap films: "the knees are trembling again"; tools/owned_mocap_jitter.gd
## found the knee pole flipping up to 179 deg in one frame on cmu_13_17). A knee pointing backwards from its toes sits
## near +-180 deg; the old clamp sent it to +ALLOW one frame and -ALLOW the next as the clip's foot wobbled across 180.
## On our boxer (mh_boxer_08, the idle's first pose) the left foot is turned 180 +- 1 deg about the vertical, frame after
## frame, and KneeTrack.align runs on each: the corrected knee must keep its side (no turn > 10 deg between frames), sit
## within ALLOW_DEG (+2) of the toes, and the side it keeps is the one it chose first. A knee already over its toes is
## left alone (moves < 0.5 deg).

const Measure := preload("res://tools/owned_mocap_measure.gd")
const KneeTrack := preload("res://scripts/fight3d/KneeTrack.gd")
const IDLE := "res://assets/anim/baked/mc_Box1_M3_Idle.res"

var checks := 0
var failures := 0


func _initialize() -> void:
	var rig := Measure.rig_for("mh_boxer_08")
	root.add_child(rig["body"])
	await process_frame   # the tree is live: global poses and transforms update
	var skel: Skeleton3D = rig["skel"]
	_pose(skel, load(IDLE) as Animation, 0.0)
	var base := {}
	for b in skel.get_bone_count():
		base[b] = skel.get_bone_pose_rotation(b)
	var foot := skel.find_bone("LeftFoot")
	# Control: the idle's own knee is over its toes - align leaves it (almost) where it is.
	var before := _knee_yaw(skel)
	var off0 := absf(_wrap(before - _toes_yaw(skel)))
	KneeTrack.align(skel, 1.0)
	if off0 <= KneeTrack.ALLOW_DEG - 1.0:
		_check(absf(_wrap(_knee_yaw(skel) - before)) < 0.5, "a knee over its toes (%.1f deg) is left alone (moved %.2f deg)" % [off0, absf(_wrap(_knee_yaw(skel) - before))])
	else:
		_check(absf(_wrap(_knee_yaw(skel) - _toes_yaw(skel))) <= KneeTrack.ALLOW_DEG + 2.0, "the idle knee (%.1f deg off its toes) is brought within %.0f deg" % [off0, KneeTrack.ALLOW_DEG])
	skel.remove_meta("knee_track_side")
	var yaws: Array = []
	var off_max := 0.0
	var sides := {}
	var turned := INF
	var back := INF
	for f in 12:
		for b in base:
			skel.set_bone_pose_rotation(b, base[b])
		var toes0 := _toes_yaw(skel)
		_turn_foot(skel, foot, deg_to_rad(180.0 + (1.0 if f % 2 == 0 else -1.0)))
		turned = minf(turned, absf(_wrap(_toes_yaw(skel) - toes0)))
		back = minf(back, absf(_wrap(_knee_yaw(skel) - _toes_yaw(skel))))
		KneeTrack.align(skel, 1.0)
		yaws.append(_knee_yaw(skel))
		off_max = maxf(off_max, absf(_wrap(_knee_yaw(skel) - _toes_yaw(skel))))
		sides[str(skel.get_meta("knee_track_side", [0.0, 0.0])[0])] = true
	_check(turned > 170.0, "the test turned the toes round (%.1f deg)" % turned)
	_check(back > 150.0, "so the knee pointed backwards from them before the fix (%.1f deg)" % back)
	var step_max := 0.0
	for i in range(1, yaws.size()):
		step_max = maxf(step_max, absf(_wrap(float(yaws[i]) - float(yaws[i - 1]))))
	print("KNEE_TRACK knee turn between frames max %.2f deg, knee to toes max %.1f deg, sides %s" % [step_max, off_max, str(sides.keys())])
	_check(step_max < 10.0, "a backwards knee keeps its side frame to frame (max turn %.1f deg, the old clamp flipped ~40)" % step_max)
	_check(off_max <= KneeTrack.ALLOW_DEG + 2.0, "the knee is brought over the toes (worst %.1f deg off)" % off_max)
	_check(sides.size() == 1, "one side kept all along (%s)" % str(sides.keys()))
	print("KNEE_TRACK checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


## The clip's pose at time t on the skeleton (rotations; the hips offset from rest).
static func _pose(skel: Skeleton3D, anim: Animation, t: float) -> void:
	for k in anim.get_track_count():
		var b := skel.find_bone(str(anim.track_get_path(k)))
		if b < 0:
			continue
		if anim.track_get_type(k) == Animation.TYPE_ROTATION_3D:
			skel.set_bone_pose_rotation(b, anim.rotation_track_interpolate(k, t))
		elif anim.track_get_type(k) == Animation.TYPE_POSITION_3D:
			skel.set_bone_pose_position(b, skel.get_bone_rest(b).origin + anim.position_track_interpolate(k, t))


## Turns the foot `ang` about the skeleton's vertical through the ankle (its global turn), keeping the rest of the leg.
static func _turn_foot(skel: Skeleton3D, foot: int, ang: float) -> void:
	var g := skel.get_bone_global_pose(foot).basis.get_rotation_quaternion()
	var par := skel.get_bone_parent(foot)
	var gp := skel.get_bone_global_pose(par).basis.get_rotation_quaternion()
	skel.set_bone_pose_rotation(foot, (gp.inverse() * Quaternion(Vector3.UP, ang) * g).normalized())


## The left knee's offset from the hip-ankle line, as a yaw on the floor (deg).
static func _knee_yaw(skel: Skeleton3D) -> float:
	var h := skel.get_bone_global_pose(skel.find_bone("LeftUpperLeg")).origin
	var k := skel.get_bone_global_pose(skel.find_bone("LeftLowerLeg")).origin
	var a := skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin
	var ax := (a - h).normalized()
	var v := (k - h) - ax * (k - h).dot(ax)
	return rad_to_deg(atan2(v.x, v.z))


## The left foot's ankle-to-toes direction as a yaw on the floor (deg).
static func _toes_yaw(skel: Skeleton3D) -> float:
	var a := skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin
	var t := skel.get_bone_global_pose(skel.find_bone("LeftToes")).origin
	return rad_to_deg(atan2(t.x - a.x, t.z - a.z))


static func _wrap(d: float) -> float:
	return wrapf(d, -180.0, 180.0)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
	print(("ok   " if ok else "FAIL ") + what)
