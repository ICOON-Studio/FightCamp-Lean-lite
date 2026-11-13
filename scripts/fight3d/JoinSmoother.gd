extends SkeletonModifier3D
## S301 (operator on the S301 films: "doesnt look smooth", "these still feel off"). SMOOTH3: real dead blending (Daniel Holden,
## "Dead Blending", 2023, theorangeduck.com). At a join, store the shown pose and its full velocity per bone (rotation + the
## hips' position). Each frame, extrapolate that source pose along its velocity, the velocity decaying with a half-life
## (rotation: integrate the angle |w| (1 - e^{-lt}) / l about w's axis). Show slerp(extrapolated source, the clip's current
## pose, w(t)) with w(t) = 1 - (1 + kt) e^{-kt} * envelope(t): k from the join's half-life, the existing quintic `_envelope`
## so w lands on 1 at the join's duration with zero slope. That is C1 at both ends, and the target's own velocity never
## needs to be known.
## JOINFIX1 (POWER1_STEP4_RESULT.md: the lead uppercut's glove jumped 0.48 m in one frame on the cut back to guard): the
## arm (and chest) an armed landing reach held starts the join from the pose as DRAWN (read in Skeleton3D.skeleton_updated,
## after the whole stack: PunchReach, ReachLimit's cap and lean), not from this modifier's own input (the clip's raised
## arm); see _held_bones. The join is captured on the join frame itself (it waited up to two frames for the new pose).
##   setup(skel, bone_names)  join()  (call join() right before AnimationPlayer.play(new, 0.0))

const DURATION_S := 0.3
const HALF_LIFE_S := 0.06

var _bones: PackedInt32Array = []
var _root := -1                         # the hips: its position is carried too (the clips move the pelvis)
var _shown: Array = []                  # what the viewer saw last frame, per tracked bone (Quaternion)
var _before: Array = []                 # the frame before that
## JOINFIX1: the pose as drawn (after every modifier) on the last two frames, read in skeleton_updated; the join starts here.
var _drawn: Array = []
var _drawn_before: Array = []
var _drawn_dt := 1.0 / 60.0
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
var _ready := false
## POWER1 step 4 (e), review round 1: the next join starts from the shown pose standing still (HitImpact's quick hand-back).
## Under a landed punch's reach the shown arm is the clip's, still swinging on (the lead uppercut's glove rises over her head
## after the hit): carried on along that speed it flew up 0.3-0.6 m a frame (tools/hit_frame_film.gd trace=1, 15-36 m/s).
var still := false


func setup(skel: Skeleton3D, bone_names: Array) -> bool:
	for n in bone_names:
		var i := skel.find_bone(str(n))
		if i >= 0 and not _bones.has(i):
			_bones.append(i)
	_root = skel.find_bone("pelvis")
	if _root < 0:
		_root = skel.find_bone("Hips")
	if not _bones.is_empty() and not skel.skeleton_updated.is_connected(_on_drawn):
		skel.skeleton_updated.connect(_on_drawn.bind(skel))
	return not _bones.is_empty()


## JOINFIX1: skeleton_updated fires after the whole modifier stack, before the pose is put back: what the viewer sees.
func _on_drawn(skel: Skeleton3D) -> void:
	if not is_instance_valid(skel) or not active:
		return
	_drawn_before = _drawn
	_drawn = []
	for b in _bones:
		_drawn.append(skel.get_bone_pose_rotation(b))
	_drawn_dt = maxf(get_process_delta_time(), 1e-4)


## half_life / duration: S305 (operator "make it more fluid"): research G147 - into a strike 80-150 ms, back to the
## idle 200-300 ms; the defaults are the strike join.
func join(half_life: float = HALF_LIFE_S, duration: float = DURATION_S) -> void:
	_pending = true
	_next = Vector2(half_life, duration)


## SMOOTH3: the AnimationPlayer and the clip the join goes to. JOINFIX1: the capture no longer waits for that clip's pose
## (it starts from the drawn pose on the join frame); kept for the callers and for what the join is going to.
func set_target(ap: AnimationPlayer, clip: String) -> void:
	_ap = ap
	_clip = clip
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
	# JOINFIX1: capture on the join frame itself, from the last drawn pose (the new clip's pose need not have landed: the
	# blend starts from where the viewer saw her, and the target is read fresh every frame).
	if _pending and (_drawn.size() == _bones.size() or _shown.size() == _bones.size()):
		_hl = _next.x
		_dur = _next.y
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
	# JOINFIX1: the arm a landing reach held on the last drawn frame starts from the DRAWN pose and its drawn velocity; every
	# other bone from this modifier's input as before (see _held_bones).
	var held := _held_bones(skel)
	for j in _bones.size():
		var drawn: bool = held.has(_bones[j])
		var src: Array = _drawn if drawn else _shown
		var prev: Array = _drawn_before if drawn else _before
		var dt := _drawn_dt if drawn else _dt
		var have_before := prev.size() == _bones.size()
		var shown: Quaternion = src[j]
		_start_rots.append(shown)
		# Full angular velocity vector (not just one axis)
		var vel := Vector3.ZERO
		if have_before:
			var turn: Quaternion = shown * (prev[j] as Quaternion).inverse()
			if turn.w < 0.0:
				turn = -turn
			if turn.get_angle() > 1e-6:
				var axis := turn.get_axis().normalized()
				var angle := turn.get_angle()
				vel = axis * (angle / dt)
		_vels.append(vel if not still else Vector3.ZERO)
	still = false
	if _root >= 0:
		_start_root = _shown_root
		_root_vel = (_shown_root - _before_root) / _dt if _before.size() == _bones.size() else Vector3.ZERO
		if _carry:
			var parent := skel.get_bone_parent(_root)
			var pg := skel.get_bone_global_pose(parent) if parent >= 0 else Transform3D()
			var seen := _carry_from * (pg * _shown_root)
			_start_root = pg.affine_inverse() * (skel.global_transform.affine_inverse() * seen)
	_t = 0.0


## JOINFIX1: the bones whose drawn pose the join must start from: the arm (upper arm, forearm, hand) and the chest of the
## glove the landing reach (PunchReach, with ReachLimit's cap and chest lean) held, armed and weighted, on the last drawn
## frame. That arm was drawn where the reach put it, not where the clip had it (the lead uppercut's clip arm rises over her
## head after the hit: blending from there jumped the glove up to 0.48 m in a frame). At the cut the reach lets go over its
## own fade from the point it held, so starting the arm there counts it once. Every other bone, and every join with no
## armed reach (a punch cut off by play() is disarmed before the join and fades on from the clip pose, as before), keeps
## this modifier's input: the guard tuck, the weave and the tired sag stay on across a join and are laid on again after
## it, so starting from their drawn result counted them twice (probe, tests/join_return_test.gd: the drawn source on every
## join raised the lead uppercut's post-hit pop from a median 10 to 26 m/s by stacking the guard tuck on the punch's start;
## with fading reaches included, a fidget join 0.15 s after the cut stepped the glove 8.5 m/s).
func _held_bones(skel: Skeleton3D) -> Dictionary:
	var out := {}
	var pr: Node = skel.get_node_or_null("PunchReach")
	if pr == null or _drawn.size() != _bones.size() or _drawn_before.size() != _bones.size():
		return out
	var arms: Dictionary = pr.get("_arms") if pr.get("_arms") is Dictionary else {}
	var hands: Array = []
	if str(pr.get("_clip")) != "" and float(pr.get("last_weight")) > 0.0:
		hands.append(str(pr.get("_hand")))
	for h in hands:
		var ids: Array = arms.get(h, [])
		for k in mini(3, ids.size()):
			out[int(ids[k])] = true
	if not hands.is_empty() and int(pr.get("_chest")) >= 0:
		out[int(pr.get("_chest"))] = true   # ReachLimit's chest lean, laid on by the same reach (and let go by its fade)
	return out


## 1 -> 0 with zero slope at both ends (the old repo's smooth_envelope): the start keeps the carried speed, the end lands on
## the new clip with no step.
static func _envelope(t: float, duration: float = DURATION_S) -> float:
	var u := clampf(t / duration, 0.0, 1.0)
	return 1.0 - u * u * u * (10.0 + u * (-15.0 + 6.0 * u))
