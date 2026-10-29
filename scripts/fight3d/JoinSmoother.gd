extends SkeletonModifier3D
## S301 (operator on the S300 films: "doesnt look smooth", "these still feel off"). Inertialization (Holden's dead blending,
## the old repo's FightInertialize): at a clip change the AnimationPlayer cuts straight to the new clip, and this modifier
## carries what the viewer last saw - each bone's offset from the new clip and the speed it was moving at - then decays
## that offset to nothing over DURATION_S. A linear crossfade jumps the velocity at its first frame (the S301 joins
## report: guard -> footwork jolted the feet 11-15 m/s in one frame, five times anything inside a clip); this keeps the
## body moving the way it was and eases into the new clip.
##   setup(skel, bone_names)  join()  (call join() right before AnimationPlayer.play(new, 0.0))

const DURATION_S := 0.3
const HALF_LIFE_S := 0.06

var _bones: PackedInt32Array = []
var _root := -1                         # the hips: its position is carried too (the clips move the pelvis)
var _shown: Array = []                  # what the viewer saw last frame, per tracked bone (Quaternion)
var _before: Array = []                 # the frame before that
var _shown_root := Vector3.ZERO
var _before_root := Vector3.ZERO
var _offsets: Array = []                # per bone [offset Quaternion, angular speed along its axis]
var _root_off := Vector3.ZERO
var _root_vel := Vector3.ZERO
var _t := -1.0
var _pending := false
var _dt := 1.0 / 60.0


func setup(skel: Skeleton3D, bone_names: Array) -> bool:
	for n in bone_names:
		var i := skel.find_bone(str(n))
		if i >= 0 and not _bones.has(i):
			_bones.append(i)
	_root = skel.find_bone("pelvis")
	if _root < 0:
		_root = skel.find_bone("Hips")
	return not _bones.is_empty()


func join() -> void:
	_pending = true


## _process_modification (not the _with_delta variant): every Godot 4.x calls it, the delta comes from the frame.
func _process_modification() -> void:
	var delta := get_process_delta_time()
	var skel := get_skeleton()
	if skel == null:
		return
	if _pending and _shown.size() == _bones.size():
		_capture(skel)
	_pending = false
	if _t >= 0.0:
		_t += delta
		if _t >= DURATION_S:
			_t = -1.0
		else:
			var k := log(2.0) / HALF_LIFE_S
			var env := _envelope(_t)
			for j in _bones.size():
				var off: Quaternion = _offsets[j][0]
				var x0 := off.get_angle()
				if x0 < 1e-5 or off.get_axis().length() < 1e-9:
					continue
				var x := (x0 + (float(_offsets[j][1]) + x0 * k) * _t) * exp(-k * _t) * env
				var b := _bones[j]
				skel.set_bone_pose_rotation(b, Quaternion(off.get_axis().normalized(), x) * skel.get_bone_pose_rotation(b))
			if _root >= 0:
				var p := (_root_off + (_root_vel + _root_off * k) * _t) * exp(-k * _t) * env
				skel.set_bone_pose_position(_root, skel.get_bone_pose_position(_root) + p)
	_before = _shown
	_shown = []
	for b in _bones:
		_shown.append(skel.get_bone_pose_rotation(b))
	if _root >= 0:
		_before_root = _shown_root
		_shown_root = skel.get_bone_pose_position(_root)
	_dt = maxf(delta, 1e-4)


## The offset from the new clip's first frame to what was shown, and the speed the shown pose was turning along it.
func _capture(skel: Skeleton3D) -> void:
	_offsets = []
	var have_before := _before.size() == _bones.size()
	for j in _bones.size():
		var shown: Quaternion = _shown[j]
		## S304: normalized - an unanimated bone gave an exact-zero axis with w a hair under 1 (52,184 "axis must be
		## normalized" errors in one film; Godot then turned nothing, so it was noise, not motion).
		var off := (shown * skel.get_bone_pose_rotation(_bones[j]).inverse()).normalized()
		if off.w < 0.0:
			off = -off   # the short way round
		var speed := 0.0
		var axis := off.get_axis()
		if have_before and off.get_angle() > 1e-5:
			var turn: Quaternion = shown * (_before[j] as Quaternion).inverse()
			if turn.w < 0.0:
				turn = -turn
			var w := turn.get_axis().normalized() * turn.get_angle() / _dt if turn.get_angle() > 1e-6 else Vector3.ZERO
			speed = w.dot(axis.normalized())
		_offsets.append([off, speed])
	if _root >= 0:
		_root_off = _shown_root - skel.get_bone_pose_position(_root)
		_root_vel = (_shown_root - _before_root) / _dt if have_before else Vector3.ZERO
	_t = 0.0


## 1 -> 0 with zero slope at both ends (the old repo's smooth_envelope): the start keeps the carried speed, the end lands on
## the new clip with no step.
static func _envelope(t: float) -> float:
	var u := clampf(t / DURATION_S, 0.0, 1.0)
	return 1.0 - u * u * u * (10.0 + u * (-15.0 + 6.0 * u))
