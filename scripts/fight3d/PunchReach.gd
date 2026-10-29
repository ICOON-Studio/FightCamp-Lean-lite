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


## Carries `hand`'s glove front onto the target by weight w.
func _reach(skel: Skeleton3D, hand: String, w: float, target_fn: Callable, glove_front: float) -> void:
	if not target_fn.is_valid() or not _arms.has(hand):
		return
	var target: Vector3 = skel.global_transform.affine_inverse() * (target_fn.call() as Vector3)
	var ids: Array = _arms[hand]
	var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
	var front := g_hd.origin + _along(skel, ids) * glove_front
	# Where the wrist must go for the glove front to sit on the target, eased in by the weight.
	var want: Vector3 = g_hd.origin + (target - front) * w
	var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
	var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
	var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
	var reach := l1 + l2 - 0.004
	if _chest >= 0 and s.distance_to(want) > reach:
		_lean(skel, s, want, reach, w)
		s = skel.get_bone_global_pose(int(ids[0])).origin
	solve(skel, ids, s, want, l1, l2, g_hd.basis)


## The wrist-to-knuckle direction of the hand (the glove's long axis, as Gloves.gd mounts it).
func _along(skel: Skeleton3D, ids: Array) -> Vector3:
	var wrist: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = skel.get_bone_global_pose(int(ids[3])).origin - wrist
	return a.normalized() if a.length() > 1e-5 else Vector3.FORWARD


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
## keeps `hand_basis`. ids = [upper arm, lower arm, hand, ...] (GuardTuck uses it too).
static func solve(skel: Skeleton3D, ids: Array, s: Vector3, want: Vector3, l1: float, l2: float, hand_basis: Basis) -> void:
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
	var e2 := c + bend * r
	var rot_ua := Quaternion((e - s).normalized(), (e2 - s).normalized())
	skel.set_bone_global_pose(ua, Transform3D(Basis(rot_ua) * g_ua.basis, s))
	var g_la: Transform3D = skel.get_bone_global_pose(la)
	var h_now: Vector3 = skel.get_bone_global_pose(hd).origin
	var rot_la := Quaternion((h_now - e2).normalized(), (h - e2).normalized())
	skel.set_bone_global_pose(la, Transform3D(Basis(rot_la) * g_la.basis, e2))
	skel.set_bone_global_pose(hd, Transform3D(hand_basis, h))
