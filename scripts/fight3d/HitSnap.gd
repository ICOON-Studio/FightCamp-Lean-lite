extends SkeletonModifier3D
## S302 (operator on the S301 film: "the punches feel like they have no power"). The receiver's head snaps the way the
## punch drives it - back for a straight, round for a hook - the instant it lands, then settles (John J-GUARDPACE1: the
## receiver's head snaps back). Additive on top of the hit-reaction clip, on the frame clock (not the clip's), so it
## shows through the hit-stop while both bodies hold still. Runs after JoinSmoother and PunchReach.
##   setup(skel)  snap(dir_world: Vector3, degrees: float)

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


func setup(skel: Skeleton3D) -> bool:
	for n in ["Neck", "neck_01", "Neck1"]:
		_neck = skel.find_bone(n)
		if _neck >= 0:
			break
	_head = skel.find_bone("Head")
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


func _process_modification() -> void:
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
