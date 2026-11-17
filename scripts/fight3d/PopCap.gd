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
## S504 (s504g: 74 of 85 head jumps over 12 cm were the head moving on a body that ALSO slid - a jab's lunge 9 cm a frame
## plus its trunk 6-12 cm): the head's travel is read in the WORLD, so the body's own slide this frame (RingPlace, capped
## at the same speed) counts against the cap and the trunk gives it back. `-- skelpopcap` = the old skeleton-space read.
static var world: bool = not OS.get_cmdline_user_args().has("skelpopcap")
## S504: a second cap BEFORE the reach (BoxerBuild "PopCapPre"): the reach owns her trunk through the whole punch (held()
## ramps up from the punch's start), so the cap after it let a jab's trunk jump 6-12 cm a frame on a 9 cm lunge. Capped
## before the reach, the arm is then solved from the capped shoulder and the glove still lands. `-- noprecap`.
static var pre_on: bool = not OS.get_cmdline_user_args().has("noprecap")
var pre := false
## S508 HEADJUMP1 (s507b: 52 of 92 head jumps on a punching boxer's own head; the jumps are trunk 6.5 + neck 6.4 cm, inside
## the exemption above): with the warm arm fit (S507) the held arm no longer swings when the trunk under it is eased, so the
## trunk is capped while a glove is held too, and the landing glove is landed again on the eased shoulder (PunchReach.settle,
## as GloveClear does after its lean) - only while the landed glove lets go (_letting_go). `-- noholdcap` = the S497 exemption.
## Film s508c vs s508a (same bout, 180 s): head jumps 91 -> 86, stepping hook 9.7 -> 9.0 m/s, fling p90 6.0 -> 5.8.
static var hold_cap: bool = not OS.get_cmdline_user_args().has("noholdcap")
## S509: `-- capwhy` prints every frame a head still travels over 12 cm, with what kept the cap off (films: --log).
## s509a (180 s, seed 7): 136 such passes - 72 a LANDED punch at full hold (47 the frame after the hit, 20 on it), 43 hit
## reactions freed on purpose (FREE_HIT_S), 11 blocked / height-only punches (their head rides the body's slide: capping
## their trunk on the way in changed nothing, one pass 24 -> 33 cm). Rejected S509: the trunk capped after the hit at full
## hold (hit_carry 31 -> 43, gloves off her on the hit frame) and on the way in of an unlanded punch (shared part 18 -> 20).
static var why: bool = OS.get_cmdline_user_args().has("capwhy")

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
## S510 (r12: the worst head jumps were ALL hit reactions in their first frames - 21, 18, 18, 16 cm in one 30 fps frame,
## cross_v3 57 cm in 4 frames; animator: "no head more than 9 cm a frame except the contact frame of a power shot, cap 14
## cm"): a freed hit is no longer free of any cap - its head travels at most HIT_MAX_MPS (11.3 cm a 30 fps frame). The
## reaction's size is kept (each frame is capped against the last drawn pose, so the head catches up a frame later).
## `-- freehits` = free as before.
const HIT_MAX_MPS := 3.4   # 4.2 (14 cm a frame) first: the headless r13 log read MORE frames over the ruler's 12 cm (11 -> 15); 3.4 = 11.3 cm, still 23 cm in two frames
static var hit_cap: bool = not OS.get_cmdline_user_args().has("freehits")


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
		var d_tot := _abs(skel).distance_to(_ref_abs)
		var d_rel := head.distance_to(_ref_head)
		var freed := free_s > 0.0
		var cap := (HIT_MAX_MPS if freed else HEAD_MAX_MPS) * dt
		if (not freed or hit_cap) and d_tot > cap and d_tot < TELEPORT_M and d_rel > 0.001:
			var held := 0.0 if (pre or freed) else _holding(skel)
			var capped_held := hold_cap and held > 0.0 and _letting_go(skel, held)
			var keep := lerpf(clampf(1.0 - (d_tot - cap) / d_rel, 0.0, 1.0), 1.0, 0.0 if capped_held else held)
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
				if capped_held and skel.get_node_or_null("PunchReach") != null:
					skel.get_node("PunchReach").settle()   # the glove lands again on the eased shoulder
		if why and not pre and _abs(skel).distance_to(_ref_abs) > 0.12:
			_why(skel, d_tot, cap)
	_last_rot.resize(_bones.size())
	for k in _bones.size():
		_last_rot[k] = skel.get_bone_global_pose(_bones[k]).basis.get_rotation_quaternion()
	_last_head = head
	_last_abs = _abs(skel)


## S509: true while an ARMED punch will not land (blocked: no carry through; or a height-only miss). A landed punch, or a
## glove only fading out after one (no clip armed), is false: hit_carry 31 -> 40 when a fade counted as not landing.
func _not_landing(skel: Skeleton3D) -> bool:
	var pr := skel.get_node_or_null("PunchReach")
	return pr != null and str(pr.get("_clip")) != "" and (bool(pr.get("_height_only")) or float(pr.get("_thru")) <= 0.002)


## S509 `-- capwhy`: one line per frame the drawn head still travelled over 12 cm, with what held the cap off.
func _why(skel: Skeleton3D, d_tot: float, cap: float) -> void:
	var held := _holding(skel)
	var pr := skel.get_node_or_null("PunchReach")
	print("CAPWHY f=%d who=%s clip=%s pre_cut=%.1f after=%.1f cap=%.1f held=%.2f free=%.2f not_landing=%s letgo=%s hit_f=%d" % [
		Engine.get_process_frames(), str(skel.get_instance_id() % 1000), str(pr.get("_clip")) if pr != null else "-",
		d_tot * 100.0, _abs(skel).distance_to(_ref_abs) * 100.0, cap * 100.0, held, free_s, str(_not_landing(skel)),
		str(_letting_go(skel, held)), int(pr.get("_hit_f")) if pr != null else -1])


## The head where it is drawn: in the world (S504), or in skeleton space with `-- skelpopcap`.
func _abs(skel: Skeleton3D) -> Vector3:
	var o := skel.get_bone_global_pose(_head).origin
	return skel.global_transform * o if world else o


## How much of her trunk the landing reach owns now, 0-1 (the strongest hold among her hands).
func _holding(skel: Skeleton3D) -> float:
	var pr := skel.get_node_or_null("PunchReach")
	var out := 0.0
	if pr != null:
		for w in (pr.held() as Dictionary).values():
			out = maxf(out, float(w))
	return clampf(out, 0.0, 1.0)


## S508 A/B r1 (`holdcap` at every held frame): hit_carry 31 -> 57 - the jabs met her 16-22 cm short on the hit frame (the
## capped trunk held the shoulder back and the reach could not make it up). So the held trunk is capped only once the punch
## has landed and its glove is letting go (weight under full), never on the way in or at contact.
func _letting_go(skel: Skeleton3D, held: float) -> bool:
	var pr := skel.get_node_or_null("PunchReach")
	return pr != null and held < 0.999 and int(pr.get("_hit_f")) >= 0 and int(pr.get("_hit_f")) != Engine.get_process_frames()
