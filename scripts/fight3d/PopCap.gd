extends SkeletonModifier3D
## S496 FIGHT MOTION WEEK - the per-frame pop cap on the shown pose (the six HUMANFIGHT1 critics' first ask, S430; never
## built). The owner: "The fight looks terrible should we stop this project?" Two blind critics on the r0 film: 4/10 and 4/10.
## tools/fight_motion_rulers.py r0: 53 frames where a head moved more than 12 cm in ONE frame (worst 28 cm, ~8 m/s) against
## 5 on 2026-11-11; control rounds: with POWER1's punch weight and drive layers off, 8. Those layers give the punch its
## body, so they stay; what goes is the one-frame jump. A real boxer's head moves at most ~2-3 m/s in a cross.
##
## After the stack has drawn this frame's pose, the head's travel since the last DRAWN frame is measured. If it is over
## HEAD_MAX_MPS * delta (measured as head minus hips: r1a showed the contact-frame jumps are 15-19 cm of the trunk's own
## bend in one frame), the spine-to-head chain (spine, chest, upper chest, neck, head - never the hips, arms or legs, so
## planted feet stay planted) is eased back toward last frame's drawn chain just far enough that the head travels the cap:
## the move spreads over two or three frames instead of one. A teleport (over TELEPORT_M) is let through.
## LAST in the stack: BoxerBuild moves it just before MetaHumanTwist, after the footwork rig and the foot locks.
## S497 (join_return went red with the cap on: hook 12.4 m/s, cross 14.1 m/s against a 9 m/s bar; green with `nopopcap`):
##   - the chain is eased in SKELETON space, not bone-local: with local rotations a clip change whose hips turn another way
##     left the old spine on the new hips for a frame (the shoulders, and the gloves on them, swung 20 cm);
##   - while the landing reach holds a glove on its target (PunchReach.held, weight w) the trunk is eased only by 1 - w:
##     the reach solved the arm from this frame's shoulder, so easing the trunk under it dragged the glove off its target
##     and back (and putting the wrist back swung the glove on the turned forearm, 25-29 cm in a frame). A punch's own
##     body turn is the punch; its contact-frame lean is eased at its source, not here.
## `-- nopopcap` = the control arm.
##   setup(skel) -> bool

const HEAD_MAX_MPS := 2.7
const TELEPORT_M := 0.6
const CHAIN := ["Head", "...", "Spine"]   # documentation only: the chain is walked head -> hips in setup()

static var on: bool = not OS.get_cmdline_user_args().has("nopopcap")

var _skel: Skeleton3D
var _bones: PackedInt32Array = PackedInt32Array()
var _head := -1
var _hips := -1
var _last_rot: Array = []        # this frame's latest drawn rotation per chain bone, skeleton space
var _last_head := Vector3.ZERO   # this frame's latest drawn head minus hips, skeleton space
var _ref_rot: Array = []         # the PREVIOUS frame's final drawn chain: what every pass of this frame is capped against
var _ref_head := Vector3.ZERO
var _last_abs := Vector3.ZERO    # head in skeleton space (with the hips' own travel), this frame's latest
var _ref_abs := Vector3.ZERO
var _have := false
var _frame := -1
var capped_frames := 0           # probes read it
## S497 r2a film: with the cap on her, a hit head travelled 15.4 cm (median) where it had 19.6 - both critics' second
## fault is "a landed punch gets no reaction". A blow IS a fast head: HitImpact frees her for FREE_HIT_S from the hit.
const FREE_HIT_S := 0.25
var free_s := 0.0


func setup(skel: Skeleton3D) -> bool:
	_skel = skel
	_head = skel.find_bone("Head")
	_hips = skel.find_bone("Hips")
	# Every bone from the head down to (not including) the hips: the MetaHuman chain has neck_02, spine_04/05 ... between
	# the humanoid names (CHAIN alone left them free, and r1b's contact-frame jumps stayed at 13).
	var b := _head
	while b >= 0 and b != _hips:
		_bones.append(b)
		b = skel.get_bone_parent(b)
	return on and _head >= 0 and _hips >= 0 and _bones.size() >= 3


## The stack can run more than once in a frame (a hit forces a pose update to put the punch on its contact): every pass
## is capped against the previous frame's FINAL pose, so the frame's head travel stays under the cap however many passes.
func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _head < 0:
		return
	var f := Engine.get_process_frames()
	if f != _frame:
		if _frame >= 0:
			_ref_rot = _last_rot.duplicate()
			_ref_head = _last_head
			_ref_abs = _last_abs
			_have = true
		_frame = f
		free_s = maxf(0.0, free_s - get_process_delta_time())
	var head := skel.get_bone_global_pose(_head).origin - skel.get_bone_global_pose(_hips).origin
	var dt := get_process_delta_time()
	if dt <= 0.0:
		dt = 1.0 / 30.0
	if _have and _ref_rot.size() == _bones.size():
		# r1d: capping the trunk's own bend left 13 contact-frame jumps - the hips slide 3-7 cm in the same frame. The cap is on
		# the head's whole travel; the chain gives back what the hips' slide adds (it leans against it), never more than all.
		var d_tot := skel.get_bone_global_pose(_head).origin.distance_to(_ref_abs)
		var d_rel := head.distance_to(_ref_head)
		var cap := HEAD_MAX_MPS * dt
		if free_s <= 0.0 and d_tot > cap and d_tot < TELEPORT_M and d_rel > 0.001:
			var keep := lerpf(clampf(1.0 - (d_tot - cap) / d_rel, 0.0, 1.0), 1.0, _holding(skel))
			if keep < 0.999:
				var cur: Array = []
				for b in _bones:
					cur.append(skel.get_bone_global_pose(b).basis.get_rotation_quaternion())
				for k in range(_bones.size() - 1, -1, -1):   # the spine's root first: each bone on its eased parent
					var b: int = _bones[k]
					var want: Quaternion = (_ref_rot[k] as Quaternion).slerp(cur[k], keep)
					var par := skel.get_bone_global_pose(skel.get_bone_parent(b)).basis.get_rotation_quaternion()
					skel.set_bone_pose_rotation(b, par.inverse() * want)
				head = skel.get_bone_global_pose(_head).origin - skel.get_bone_global_pose(_hips).origin
				capped_frames += 1
	_last_rot.resize(_bones.size())
	for k in _bones.size():
		_last_rot[k] = skel.get_bone_global_pose(_bones[k]).basis.get_rotation_quaternion()
	_last_head = head
	_last_abs = skel.get_bone_global_pose(_head).origin


## How much of her trunk the landing reach owns now, 0-1 (the strongest hold among her hands).
func _holding(skel: Skeleton3D) -> float:
	var pr := skel.get_node_or_null("PunchReach")
	var out := 0.0
	if pr != null:
		for w in (pr.held() as Dictionary).values():
			out = maxf(out, float(w))
	return clampf(out, 0.0, 1.0)
