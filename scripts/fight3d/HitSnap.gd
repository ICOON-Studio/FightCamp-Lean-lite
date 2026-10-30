extends SkeletonModifier3D
## S302 (operator on the S301 film: "the punches feel like they have no power"). The receiver's head snaps the way the
## punch drives it - back for a straight, round for a hook - the instant it lands, then settles (John J-GUARDPACE1: the
## receiver's head snaps back). Additive on top of the hit-reaction clip, on the frame clock (not the clip's), so it
## shows through the hit-stop while both bodies hold still. Runs after JoinSmoother and PunchReach.
##   setup(skel)  snap(dir_world: Vector3, degrees: float)  brace(hit_left: bool)
## S305 brace (the move reel: a blocked body shot played a head cover-up): a body shot is blocked with the elbow - the
## gloves stay at the chin, the elbow on the punched side drops onto the ribs and the trunk crunches a little toward it
## (BRACE_*), on the same frame clock, rising in BRACE_RISE_S and settling like the snap.

## Up to the peak, then a damped settle (seconds).
const RISE_S := 0.035
const SETTLE_TAU_S := 0.11
const LIFE_S := 0.55
## The share of the turn on the neck; the rest on the head.
const NECK_SHARE := 0.45

var _neck := -1
var _head := -1
var _dir := Vector3.ZERO      # skeleton space, the way the glove was travelling
var _deg := 0.0
var _t := -1.0
const BRACE_RISE_S := 0.06
const BRACE_ELBOW_DEG := 22.0
const BRACE_CRUNCH_DEG := 9.0
const BRACE_SIDE_DEG := 6.0
## S310 (operator: "body shots still have no reaction"): a LANDED body shot folds her - the same trunk curl and elbow drop
## as the brace, bigger (FOLD_GAIN), held FOLD_HOLD_S and let go slowly (FOLD_TAU_S): winded, not flicked. The 30 fps film
## of the gut-shot clip alone (tools/fight3d_bodyshot.gd) showed the fold for ~0.3 s at fight speed.
const FOLD_GAIN := 2.6
const FOLD_HOLD_S := 0.3
const FOLD_TAU_S := 0.24
const FOLD_LIFE_S := 1.3
var _bt := -1.0
var _bleft := true
var _gain := 1.0               # 1 = the brace, FOLD_GAIN = a landed body shot
var _b := {}                   # bone ids: spine, chest, hips, l/r upper, lower, hand


func setup(skel: Skeleton3D) -> bool:
	for n in ["Neck", "neck_01", "Neck1"]:
		_neck = skel.find_bone(n)
		if _neck >= 0:
			break
	_head = skel.find_bone("Head")
	for n in ["Spine", "Chest", "Hips", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"]:
		_b[n] = skel.find_bone(n)
	return _head >= 0


func snap(dir_world: Vector3, degrees: float) -> void:
	var skel := get_skeleton()
	if skel == null or dir_world.length() < 1e-4:
		return
	_dir = (skel.global_transform.basis.inverse() * dir_world).normalized()
	_deg = degrees
	_t = 0.0


## 0 -> 1 at RISE_S, then an exponential settle; 0 after LIFE_S.
static func envelope(t: float) -> float:
	if t < 0.0 or t >= LIFE_S:
		return 0.0
	if t < RISE_S:
		var u := t / RISE_S
		return u * u * (3.0 - 2.0 * u)
	return exp(-(t - RISE_S) / SETTLE_TAU_S)


## A body shot meets her elbow on her left side when `hit_left`.
func brace(hit_left: bool) -> void:
	if (_b.values() as Array).has(-1):
		return
	_bleft = hit_left
	_bt = 0.0
	_gain = 1.0


## A landed body shot on her left side when `hit_left`: she folds over it and covers with the elbow.
func fold(hit_left: bool) -> void:
	brace(hit_left)
	_gain = FOLD_GAIN


## The fold's shape: up like the brace, held, then a slow settle; 0 after FOLD_LIFE_S.
static func fold_envelope(t: float) -> float:
	if t < 0.0 or t >= FOLD_LIFE_S:
		return 0.0
	if t < BRACE_RISE_S:
		var u := t / BRACE_RISE_S
		return u * u * (3.0 - 2.0 * u)
	if t < BRACE_RISE_S + FOLD_HOLD_S:
		return 1.0
	return exp(-(t - BRACE_RISE_S - FOLD_HOLD_S) / FOLD_TAU_S)


func _process_modification() -> void:
	if _bt >= 0.0:
		_brace_step()
	if _t < 0.0:
		return
	_t += get_process_delta_time()
	var e := envelope(_t)
	if e <= 0.0:
		_t = -1.0
		return
	var skel := get_skeleton()
	if skel == null:
		return
	var turn := deg_to_rad(_deg) * e
	if _neck >= 0:
		_turn(skel, _neck, turn * NECK_SHARE)
		_turn(skel, _head, turn * (1.0 - NECK_SHARE))
	else:
		_turn(skel, _head, turn)


## Rotates `bone` about its own origin so the face (in front of the head bone, against the punch) moves along the punch.
func _turn(skel: Skeleton3D, bone: int, angle: float) -> void:
	var g: Transform3D = skel.get_bone_global_pose(bone)
	var head: Transform3D = skel.get_bone_global_pose(_head)
	var p := head.origin + Vector3.UP * 0.08 - _dir * 0.09 - g.origin
	var axis := p.cross(_dir)
	if axis.length() < 1e-5:
		return
	var q := Quaternion(axis.normalized(), angle)
	skel.set_bone_global_pose(bone, Transform3D(Basis(q) * g.basis, g.origin))


func _brace_step() -> void:
	_bt += get_process_delta_time()
	var e := envelope(_bt * RISE_S / BRACE_RISE_S) if _bt < BRACE_RISE_S else envelope(_bt - BRACE_RISE_S + RISE_S)
	if _gain > 1.0:
		e = fold_envelope(_bt) * _gain
	var skel := get_skeleton()
	if e <= 0.0 or skel == null:
		_bt = -1.0
		return
	var pose := func(n: String) -> Vector3: return skel.get_bone_global_pose(int(_b[n])).origin
	var up: Vector3 = (pose.call("Chest") - pose.call("Hips")).normalized()
	var left: Vector3 = (pose.call("LeftUpperArm") - pose.call("RightUpperArm")).normalized()
	var fwd := left.cross(up).normalized()
	var side := left if _bleft else -left
	# The trunk: curls forward and toward the punched side, half on the spine, half on the chest.
	for n in ["Spine", "Chest"]:
		_rotate(skel, int(_b[n]), up.cross(fwd).normalized(), deg_to_rad(BRACE_CRUNCH_DEG) * e * 0.5)
		_rotate(skel, int(_b[n]), up.cross(side).normalized(), deg_to_rad(BRACE_SIDE_DEG) * e * 0.5)
	# The elbow drops onto the ribs; the forearm turns back so the glove stays where it was.
	var arm := "Left" if _bleft else "Right"
	var sh: Vector3 = pose.call(arm + "UpperArm")
	var el: Vector3 = pose.call(arm + "LowerArm")
	var hand: Vector3 = pose.call(arm + "Hand")
	var ribs: Vector3 = (pose.call("Chest") + pose.call("Hips")) * 0.5 + side * 0.12 + fwd * 0.06
	var a := (el - sh).normalized()
	var b := (ribs - sh).normalized()
	if a.cross(b).length() < 1e-5:
		return
	var turn := minf(a.angle_to(b), deg_to_rad(BRACE_ELBOW_DEG) * minf(e, 1.6))
	var q := Quaternion(a.cross(b).normalized(), turn)
	_rotate(skel, int(_b[arm + "UpperArm"]), a.cross(b).normalized(), turn)
	var el2: Vector3 = sh + q * (el - sh)
	var hand2: Vector3 = sh + q * (hand - sh)
	var f1 := (hand2 - el2).normalized()
	var f2 := (hand - el2).normalized()
	if f1.cross(f2).length() > 1e-5:
		_rotate(skel, int(_b[arm + "LowerArm"]), f1.cross(f2).normalized(), f1.angle_to(f2))


## Turns `bone` about its own origin by `angle` around `axis` (skeleton space).
func _rotate(skel: Skeleton3D, bone: int, axis: Vector3, angle: float) -> void:
	var g: Transform3D = skel.get_bone_global_pose(bone)
	skel.set_bone_global_pose(bone, Transform3D(Basis(Quaternion(axis, angle)) * g.basis, g.origin))
