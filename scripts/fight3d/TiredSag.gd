extends SkeletonModifier3D
## S323 (operator on update 25's tired guard, Q-S294-41: "Too little / can't see it" - the jab glove sank ~0.10 m, unseen from
## the broadcast camera). What a tired boxer shows from the cheap seats (fight film, late rounds): the trunk folds forward over
## the hips, the head hangs ahead of the chest, and the shoulders heave with each breath - slow and deep, a big lift on the
## in-breath. `tired` (0..1, BodyBurn from the trunk, legs and shoulders' Burn) sets all three; at 0 it does nothing.
## Runs right after JoinSmoother, BEFORE GuardTuck: the guard is then drawn to the hunched face, the gloves follow the head
## down. `-- noburn` keeps `tired` at 0 (the control arm).
##   setup(skel, seed)   tired

## The trunk's fold at tired 1 (degrees, half on the spine, half on the chest) and the neck's (the head forward and down).
const HUNCH_DEG := 12.0
const NECK_DEG := 8.0
## The breath: cycles a second (fresh -> spent) and each shoulder's lift at the in-breath (degrees on the clavicle).
const BREATH_HZ := Vector2(0.45, 0.75)
const SHRUG_DEG := 7.0
const CHEST_DEG := 2.5
## Eases toward the wanted `tired` so a new exchange never pops the pose.
const EASE_S := 1.0

var tired := 0.0
var _w := 0.0
var _t := 0.0
var _b := {}


func setup(skel: Skeleton3D, seed: int) -> bool:
	for n in ["Hips", "Spine", "Chest", "Neck", "LeftShoulder", "RightShoulder", "LeftUpperArm", "RightUpperArm"]:
		_b[n] = skel.find_bone(n)
		if int(_b[n]) < 0:
			return false
	_t = float(seed % 89) * 0.41
	return true


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	var dt := get_process_delta_time()
	_w = move_toward(_w, clampf(tired, 0.0, 1.0), dt / EASE_S)
	if _w <= 0.001:
		return
	var w := _w * _w * (3.0 - 2.0 * _w)
	_t += dt * lerpf(BREATH_HZ.x, BREATH_HZ.y, w)
	# In-breath quick, out-breath long: a lifted sine, sharpened toward its top.
	var breath := pow(0.5 + 0.5 * sin(TAU * _t), 1.6)
	var pose := func(n: String) -> Vector3: return skel.get_bone_global_pose(int(_b[n])).origin
	var up: Vector3 = (pose.call("Chest") - pose.call("Hips")).normalized()
	var left: Vector3 = (pose.call("LeftUpperArm") - pose.call("RightUpperArm")).normalized()
	var fwd := left.cross(up).normalized()
	var fold := up.cross(fwd).normalized()   # turning about this tips `up` toward `fwd`
	for n in ["Spine", "Chest"]:
		_rotate(skel, int(_b[n]), fold, deg_to_rad(HUNCH_DEG) * w * 0.5)
	# The chest lifts a little on the in-breath (against the fold).
	_rotate(skel, int(_b["Chest"]), fold, -deg_to_rad(CHEST_DEG) * w * breath)
	_rotate(skel, int(_b["Neck"]), fold, deg_to_rad(NECK_DEG) * w)
	# Each clavicle swings its shoulder up toward `up` on the in-breath.
	var up2: Vector3 = (pose.call("Neck") - pose.call("Chest")).normalized()
	for side in ["Left", "Right"]:
		var c: Vector3 = pose.call(side + "Shoulder")
		var a: Vector3 = (pose.call(side + "UpperArm") - c).normalized()
		var axis := a.cross(up2)
		if axis.length() > 1e-4:
			_rotate(skel, int(_b[side + "Shoulder"]), axis.normalized(), deg_to_rad(SHRUG_DEG) * w * breath)


## Turns `bone` about its own origin by `angle` around `axis` (skeleton space).
func _rotate(skel: Skeleton3D, bone: int, axis: Vector3, angle: float) -> void:
	var g: Transform3D = skel.get_bone_global_pose(bone)
	skel.set_bone_global_pose(bone, Transform3D(Basis(Quaternion(axis, angle)) * g.basis, g.origin))
