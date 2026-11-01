extends SkeletonModifier3D
## S301 (operator on the S301 films: "doesnt look smooth", "these still feel off"). SMOOTH3: real dead blending (Daniel Holden,
## "Dead Blending", 2023, theorangeduck.com). At a join, store the shown pose and its full velocity per bone (rotation + the
## hips' position). Each frame, extrapolate that source pose along its velocity, the velocity decaying with a half-life
## (rotation: integrate the angle |w| (1 - e^{-lt}) / l about w's axis). Show slerp(extrapolated source, the clip's current
## pose, w(t)) with w(t) = 1 - (1 + kt) e^{-kt} * envelope(t): k from the join's half-life, the existing quintic `_envelope`
## so w lands on 1 at the join's duration with zero slope. That is C1 at both ends, and the target's own velocity never
## needs to be known.
##   setup(skel, bone_names)  join()  (call join() right before AnimationPlayer.play(new, 0.0))

const DURATION_S := 0.3
const HALF_LIFE_S := 0.06

var _bones: PackedInt32Array = []
var _root := -1                         # the hips: its position is carried too (the clips move the pelvis)
var _shown: Array = []                  # what the viewer saw last frame, per tracked bone (Quaternion)
var _before: Array = []                 # the frame before that
var _shown_root := Vector3.ZERO
var _before_root := Vector3.ZERO
## SMOOTH3: full velocity per bone (the source's angular velocity vector, not one axis)
var _vels: Array = []                   # per bone [angular velocity Vector3]
var _root_vel := Vector3.ZERO
var _t := -1.0
var _pending := false
var _hl := HALF_LIFE_S                  # S305: this join's half-life and length (a return to guard eases slower)
var _dur := DURATION_S
var _next := Vector2(HALF_LIFE_S, DURATION_S)
var _dt := 1.0 / 60.0
var _carry := false                     # S306: the body jumped on the canvas; start the hips where they were seen
var _carry_from := Transform3D()
## SMOOTH3: the join's start state (the shown pose and its velocity, captured when the new clip's first frame lands)
var _start_rots: Array = []             # per bone: the rotation at join start
var _start_root := Vector3.ZERO
var _ap: AnimationPlayer = null
var _clip := ""
var _capture_frame := 0
var _ready := false


func setup(skel: Skeleton3D, bone_names: Array) -> bool:
	for n in bone_names:
		var i := skel.find_bone(str(n))
		if i >= 0 and not _bones.has(i):
			_bones.append(i)
	_root = skel.find_bone("pelvis")
	if _root < 0:
		_root = skel.find_bone("Hips")
	return not _bones.is_empty()


## half_life / duration: S305 (operator "make it more fluid"): research G147 - into a strike 80-150 ms, back to the
## idle 200-300 ms; the defaults are the strike join.
func join(half_life: float = HALF_LIFE_S, duration: float = DURATION_S) -> void:
	_pending = true
	_next = Vector2(half_life, duration)


## SMOOTH3: record the AnimationPlayer and clip so capture waits for the new pose to land.
func set_target(ap: AnimationPlayer, clip: String) -> void:
	_ap = ap
	_clip = clip
	_capture_frame = 0
	_ready = false


## S306 (SideStep): her place on the canvas is about to take a step; `from` = the skeleton's world transform before it.
## The next join starts the hips where the viewer saw them, so the body glides onto the new spot instead of jumping.
func carry(from: Transform3D) -> void:
	_carry = true
	_carry_from = from


## _process_modification (not the _with_delta variant): every Godot 4.x calls it, the delta comes from the frame.
func _process_modification() -> void:
	var delta := get_process_delta_time()
	var skel := get_skeleton()
	if skel == null:
		return
	# SMOOTH3: capture only when the new clip's pose has landed (Fix 2)
	if _pending and _shown.size() == _bones.size():
		_hl = _next.x
		_dur = _next.y
		_capture_frame += 1
		if _should_capture(skel):
			_capture(skel)
			_ready = true
			_pending = false
			_carry = false
	elif not _pending:
		_carry = false
	if _ready and _t >= 0.0:
		_t += delta
		if _t >= _dur:
			_t = -1.0
			_ready = false
		else:
			_apply_blend(skel, delta)
	_before = _shown
	_shown = []
	for b in _bones:
		_shown.append(skel.get_bone_pose_rotation(b))
	if _root >= 0:
		_before_root = _shown_root
		_shown_root = skel.get_bone_pose_position(_root)
	_dt = maxf(delta, 1e-4)


## SMOOTH3: wait for the new clip's pose to land (2 frames or the animation position moved).
func _should_capture(skel: Skeleton3D) -> bool:
	if _ap == null or _clip == "":
		return _capture_frame >= 2
	if str(_ap.current_animation) != _clip:
		return false
	# The player has applied the new clip if its position moved from where play/seek left it
	var pos := _ap.current_animation_position
	if _capture_frame >= 2:
		return true
	# Check if the pose changed from what we stored
	if _shown.size() == _bones.size():
		for j in _bones.size():
			var cur: Quaternion = skel.get_bone_pose_rotation(_bones[j])
			var diff: float = (cur * (_shown[j] as Quaternion).inverse()).get_angle()
			if diff > 1e-4:
				return true
	return false


## SMOOTH3: the dead blend - extrapolate the source pose along its velocity, slerp to the current pose.
func _apply_blend(skel: Skeleton3D, _delta: float) -> void:
	var k := log(2.0) / _hl
	var env := _envelope(_t, _dur)
	# w(t) = 1 - (1 + kt) e^{-kt} * envelope(t)
	var w := 1.0 - (1.0 + k * _t) * exp(-k * _t) * env
	w = clampf(w, 0.0, 1.0)
	for j in _bones.size():
		var b := _bones[j]
		var start_rot: Quaternion = _start_rots[j]
		var vel: Vector3 = _vels[j]
		# Extrapolate: integrate the angular velocity with decay
		# angle = |w| * (1 - e^{-kt}) / k about w's axis
		var angle: float = vel.length()
		var ext: Quaternion
		if angle < 1e-6:
			ext = start_rot
		else:
			var axis: Vector3 = vel.normalized()
			var a: float = angle * (1.0 - exp(-k * _t)) / k
			ext = Quaternion(axis, a) * start_rot
		# Slerp from extrapolated source to current clip pose
		var cur: Quaternion = skel.get_bone_pose_rotation(b)
		var blended: Quaternion = ext.slerp(cur, w)
		skel.set_bone_pose_rotation(b, blended)
	# Hips position
	if _root >= 0:
		var ext_root := _start_root + _root_vel * (1.0 - exp(-k * _t)) / k
		var cur_root: Vector3 = skel.get_bone_pose_position(_root)
		var blended_root := ext_root.lerp(cur_root, w)
		skel.set_bone_pose_position(_root, blended_root)


## SMOOTH3: capture the shown pose and its full velocity (Fix 1).
func _capture(skel: Skeleton3D) -> void:
	_start_rots = []
	_vels = []
	var have_before := _before.size() == _bones.size()
	for j in _bones.size():
		var shown: Quaternion = _shown[j]
		_start_rots.append(shown)
		# Full angular velocity vector (not just one axis)
		var vel := Vector3.ZERO
		if have_before:
			var turn: Quaternion = shown * (_before[j] as Quaternion).inverse()
			if turn.w < 0.0:
				turn = -turn
			if turn.get_angle() > 1e-6:
				var axis := turn.get_axis().normalized()
				var angle := turn.get_angle()
				vel = axis * (angle / _dt)
		_vels.append(vel)
	if _root >= 0:
		_start_root = _shown_root
		_root_vel = (_shown_root - _before_root) / _dt if have_before else Vector3.ZERO
		if _carry:
			var parent := skel.get_bone_parent(_root)
			var pg := skel.get_bone_global_pose(parent) if parent >= 0 else Transform3D()
			var seen := _carry_from * (pg * _shown_root)
			_start_root = pg.affine_inverse() * (skel.global_transform.affine_inverse() * seen)
	_t = 0.0


## 1 -> 0 with zero slope at both ends (the old repo's smooth_envelope): the start keeps the carried speed, the end lands on
## the new clip with no step.
static func _envelope(t: float, duration: float = DURATION_S) -> float:
	var u := clampf(t / duration, 0.0, 1.0)
	return 1.0 - u * u * u * (10.0 + u * (-15.0 + 6.0 * u))
