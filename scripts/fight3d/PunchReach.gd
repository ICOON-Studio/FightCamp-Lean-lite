extends SkeletonModifier3D
## S302 (operator on the S301 film: "the punches feel like they have no power and target enemys hand rather than their
## head"). The Pro punch clips were authored against a bag at their own range; at the fight's gap their gloves stop short
## and meet the other boxer's raised guard (tools/punch_reach.gd). A LANDED punch is armed here: around its contact the
## punching arm is re-solved as a two-bone chain whose glove front lands on the target (her face, her ribs for a body shot),
## weight easing in before contact and out after it. What the arm cannot reach, the chest leans in (a boxer turns her
## shoulder through the punch). The hand keeps its global rotation, so the glove meets the target the way the clip threw it.
## Blocked and missed punches are never armed: they stay on the gloves. Runs after JoinSmoother, before ElbowClear.
##   setup(skel, ap)  arm(clip, hand_bone, contact_s, target: Callable -> world Vector3, glove_front_m)  disarm()

## Clip seconds (the clip's own time, so it follows any playback speed): weight 0 -> 1 over IN_S before contact, held
## HOLD_S, 1 -> 0 over OUT_S.
const IN_S := 0.14
const HOLD_S := 0.05
const OUT_S := 0.16
## The most the chest may lean toward the target (radians) to cover what the arm cannot.
const LEAN_MAX := 0.30
## When the next clip cuts in (a combo, a hit), the reach and the carry let go over this long instead of at once (S302
## joins report: an instant release jolted the hook hand 12 m/s in one frame; JoinSmoother runs before this modifier).
const FADE_S := 0.12
## The glove's long axis leans this share from the hand onto the forearm (Gloves.WRIST_STRAIGHT; `-- bentwrist` = 0 there).
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
## Solves per frame for the full-weight wrist (the glove axis moves with the forearm); `-- onepass` = the S302 single step.
static var SOLVE_PASSES: int = 1 if OS.get_cmdline_user_args().has("onepass") else 4
static var STRAIGHT: float = 0.0 if OS.get_cmdline_user_args().has("bentwrist") else Gloves.WRIST_STRAIGHT

var ap: AnimationPlayer
var _arms := {}          # "LeftHand" -> [upper, lower, hand]
var _chest := -1
var _clip := ""
var _hand := ""
var _contact := 0.0
var _target: Callable
var _front := 0.15
var last_weight := 0.0   # for probes
var lunge_m := 0.0       # how far her body carries in at full weight (FightStage reads lunge())
var _w_now := 0.0
var _fades := {}         # hand -> {w, target, front, lunge}: a reach whose clip was cut off, falling to 0 over FADE_S


func setup(skel: Skeleton3D, player: AnimationPlayer) -> bool:
	ap = player
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand"),
			skel.find_bone(side + "MiddleProximal")]
		if ids.has(-1):
			return false
		_arms[side + "Hand"] = ids
	_chest = skel.find_bone("Chest")
	return true


func arm(clip: String, hand_bone: String, contact_s: float, target: Callable, glove_front_m: float) -> void:
	_clip = clip
	_hand = hand_bone
	_contact = contact_s
	_target = target
	_front = glove_front_m


func disarm() -> void:
	if _clip != "" and _w_now > 0.0:
		_fades[_hand] = {"w": _w_now, "target": _target, "front": _front, "lunge": lunge_m}
	_clip = ""
	_w_now = 0.0
	lunge_m = 0.0


## The body's carry toward the target now, metres (0 when nothing is armed or fading).
func lunge() -> float:
	var out := 0.0
	for f in _fades.values():
		out = maxf(out, float(f["lunge"]) * float(f["w"]))
	if _clip == "" or lunge_m <= 0.0 or ap == null or str(ap.assigned_animation) != _clip:
		return out
	return maxf(out, lunge_m * weight(ap.current_animation_position, _contact))


## 0..1 at clip time t.
static func weight(t: float, contact: float) -> float:
	var u := 0.0
	if t < contact - IN_S:
		return 0.0
	elif t < contact:
		u = (t - (contact - IN_S)) / IN_S
	elif t <= contact + HOLD_S:
		return 1.0
	elif t < contact + HOLD_S + OUT_S:
		u = 1.0 - (t - contact - HOLD_S) / OUT_S
	else:
		return 0.0
	return u * u * (3.0 - 2.0 * u)


func _process_modification() -> void:
	last_weight = 0.0
	var skel := get_skeleton()
	if skel == null or ap == null:
		return
	if _clip != "" and str(ap.assigned_animation) != _clip:
		disarm()
	var dt := get_process_delta_time()
	for hand in _fades.keys():
		var f: Dictionary = _fades[hand]
		f["w"] = maxf(0.0, float(f["w"]) - dt / FADE_S)
		if float(f["w"]) <= 0.0 or (_clip != "" and hand == _hand):
			_fades.erase(hand)
		else:
			_reach(skel, str(hand), float(f["w"]), f["target"], float(f["front"]))
	if _clip != "" and _arms.has(_hand):
		_w_now = weight(ap.current_animation_position, _contact)
		last_weight = _w_now
		if _w_now > 0.0:
			_reach(skel, _hand, _w_now, _target, _front)


## S331 (INSIDEMISS1): re-lands the armed glove after later modifiers moved her trunk (GloveClear's head lean, HitSnap):
## an inside jab's glove rode the lean 0.25 m to the side of the face (hit_gap_probe). `-- nosettle` = the control arm.
static var SETTLE: bool = not OS.get_cmdline_user_args().has("nosettle")
func settle() -> void:
	var skel := get_skeleton()
	if SETTLE and skel != null and _clip != "" and _w_now > 0.0:
		_reach(skel, _hand, _w_now, _target, _front)


## Carries `hand`'s glove front onto the target by weight w.
func _reach(skel: Skeleton3D, hand: String, w: float, target_fn: Callable, glove_front: float) -> void:
	if not target_fn.is_valid() or not _arms.has(hand):
		return
	var target: Vector3 = skel.global_transform.affine_inverse() * (target_fn.call() as Vector3)
	var ids: Array = _arms[hand]
	var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
	var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
	var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
	var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
	# Where the wrist must go for the glove front to sit on the target. S321: the glove's axis follows the forearm, and
	# moving the wrist turns the forearm, so one step left the front 0.13-0.28 m off (hit_gap_probe, inside punches): the
	# full-weight wrist is found by re-solving from the moved arm, then the pose is put back and eased in by the weight.
	var keep := [skel.get_bone_global_pose(int(ids[0])), skel.get_bone_global_pose(int(ids[1])), g_hd]
	var full := g_hd.origin
	for k in SOLVE_PASSES:
		var hd_now: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
		full = hd_now + (target - (hd_now + _along(skel, ids) * glove_front))
		solve(skel, ids, s, full, l1, l2, g_hd.basis)
	for k in 3:
		skel.set_bone_global_pose(int(ids[k]), keep[k])
	var want: Vector3 = g_hd.origin + (full - g_hd.origin) * w
	var reach := l1 + l2 - 0.004
	if _chest >= 0 and s.distance_to(want) > reach:
		_lean(skel, s, want, reach, w)
		s = skel.get_bone_global_pose(int(ids[0])).origin
	solve(skel, ids, s, want, l1, l2, g_hd.basis)


## The glove's long axis, as Gloves.gd mounts it: the wrist-to-knuckle direction turned WRIST_STRAIGHT of the way onto the
## forearm (S316 taped wrist). S321: this aimed along the bare hand alone, so wherever a clip bends the wrist (hooks, short
## inside punches) the glove's real striking face landed 0.13-0.28 m short and to the side of the face (hit_gap_probe).
func _along(skel: Skeleton3D, ids: Array) -> Vector3:
	var wrist: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = skel.get_bone_global_pose(int(ids[3])).origin - wrist
	if a.length() < 1e-5:
		return Vector3.FORWARD
	a = a.normalized()
	var arm: Vector3 = wrist - skel.get_bone_global_pose(int(ids[1])).origin
	if STRAIGHT > 0.0 and arm.length() > 1e-5 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm.normalized(), STRAIGHT).normalized()
	return a


## Turns the chest about the root of the spine so the shoulder comes toward `want` by the part the arm cannot reach.
func _lean(skel: Skeleton3D, s: Vector3, want: Vector3, reach: float, w: float) -> void:
	var g_ch: Transform3D = skel.get_bone_global_pose(_chest)
	var pivot := g_ch.origin
	var from := (s - pivot)
	var short := s.distance_to(want) - reach
	var dir := (want - s).normalized()
	var to := from + dir * short
	if from.length() < 0.05 or to.length() < 0.05:
		return
	var q := Quaternion(from.normalized(), to.normalized())
	var ang := minf(q.get_angle(), LEAN_MAX * w)
	if ang < 1e-4:
		return
	q = Quaternion(q.get_axis().normalized(), ang)
	skel.set_bone_global_pose(_chest, Transform3D(Basis(q) * g_ch.basis, pivot))


## Two-bone solve: shoulder fixed, wrist on `want` (clamped to the arm's reach), elbow kept on its current side; the hand
## keeps `hand_basis`. ids = [upper arm, lower arm, hand, ...] (GuardTuck uses it too). S315: `pole_w` > 0 turns the elbow's
## side that far toward `pole` (skeleton space; GuardTuck's inside guard drops the elbows onto the ribs).
static func solve(skel: Skeleton3D, ids: Array, s: Vector3, want: Vector3, l1: float, l2: float, hand_basis: Basis, pole := Vector3.ZERO, pole_w := 0.0) -> void:
	var ua: int = ids[0]
	var la: int = ids[1]
	var hd: int = ids[2]
	var g_ua: Transform3D = skel.get_bone_global_pose(ua)
	var e: Vector3 = skel.get_bone_global_pose(la).origin
	var d := clampf(s.distance_to(want), absf(l1 - l2) + 0.01, l1 + l2 - 0.004)
	var axis := want - s
	if axis.length() < 1e-4:
		return
	axis = axis.normalized()
	var h := s + axis * d
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var r := sqrt(maxf(0.0, l1 * l1 - a * a))
	var c := s + axis * a
	var bend := (e - c) - axis * (e - c).dot(axis)
	bend = bend.normalized() if bend.length() > 1e-4 else Vector3.DOWN
	if pole_w > 0.0:
		var pp := pole - axis * pole.dot(axis)
		if pp.length() > 1e-4:
			bend = bend.slerp(pp.normalized(), clampf(pole_w, 0.0, 1.0)).normalized()
	var e2 := c + bend * r
	var rot_ua := Quaternion((e - s).normalized(), (e2 - s).normalized())
	skel.set_bone_global_pose(ua, Transform3D(Basis(rot_ua) * g_ua.basis, s))
	var g_la: Transform3D = skel.get_bone_global_pose(la)
	var h_now: Vector3 = skel.get_bone_global_pose(hd).origin
	var rot_la := Quaternion((h_now - e2).normalized(), (h - e2).normalized())
	skel.set_bone_global_pose(la, Transform3D(Basis(rot_la) * g_la.basis, e2))
	skel.set_bone_global_pose(hd, Transform3D(hand_basis, h))
