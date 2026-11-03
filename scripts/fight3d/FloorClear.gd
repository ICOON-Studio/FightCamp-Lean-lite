extends SkeletonModifier3D
## S376 (operator, on the knockdown clip's still: "hands are below canvas wtf"): the knockdown / knockout clips lie the
## body ~10 cm too deep for our bodies - measured on Danny (tools S376): hands -0.09..-0.12 m, forearms to -0.15 m, the
## hips joint at 0.01 m, the feet at -0.04 m under the canvas (y 0), so the arms vanish and only the gloves show. Once a
## boxer is low (hips under LOW_HIPS_M), the whole body is lifted until the pelvis, chest and head rest ON the canvas
## (each bone's centre at least its radius up), then an arm still under it swings up from the shoulder, and its forearm
## from the elbow, until the glove and the forearm lie on top. Standing poses are never touched. Runs after FootPlant.
##   FloorClear.attach(skel) -> FloorClear

const LOW_HIPS_M := 0.45     # the lift eases in from this hips height down to LOW_FULL_M
const LOW_FULL_M := 0.25
## Bone centre -> surface (m): how far above the canvas each bone's centre must be.
const TORSO := {"Hips": 0.11, "Spine1": 0.11, "Spine2": 0.11, "Head": 0.10}
const ARMS := [["LeftUpperArm", "LeftLowerArm", "LeftHand"], ["RightUpperArm", "RightLowerArm", "RightHand"]]
const ELBOW_R := 0.05
const GLOVE_R := 0.08
const STEP_DEG := 4.0
const MAX_DEG := 80.0

var _torso: Dictionary = {}   # bone index -> radius
var _hips := -1
var _arms: Array = []         # [upper, lower, hand] per arm
var lift := 0.0               # the last lift (m), probes read it


static func attach(skel: Skeleton3D) -> Node:
	var f := new()
	f.name = "FloorClear"
	for b in TORSO:
		var i := skel.find_bone(str(b))
		if i >= 0:
			f._torso[i] = float(TORSO[b])
	f._hips = skel.find_bone("Hips")
	for a in ARMS:
		var ids: Array = (a as Array).map(func(n): return skel.find_bone(str(n)))
		if not ids.has(-1):
			f._arms.append(ids)
	skel.add_child(f)
	return f


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _hips < 0:
		return
	var xf := skel.global_transform
	var hips_y := (xf * skel.get_bone_global_pose(_hips).origin).y
	var w := clampf((LOW_HIPS_M - hips_y) / (LOW_HIPS_M - LOW_FULL_M), 0.0, 1.0)
	lift = 0.0
	if w <= 0.0:
		return
	# 1. The body up onto the canvas: the deepest torso bone's shortfall, eased in as she goes down.
	var need := 0.0
	for i in _torso:
		need = maxf(need, float(_torso[i]) - (xf * skel.get_bone_global_pose(int(i)).origin).y)
	if need > 0.0:
		lift = need * w
		var up_sk := (xf.basis.inverse() * Vector3(0.0, lift, 0.0))
		var parent := skel.get_bone_parent(_hips)
		var pb := skel.get_bone_global_pose(parent).basis if parent >= 0 else Basis.IDENTITY
		skel.set_bone_pose_position(_hips, skel.get_bone_pose_position(_hips) + pb.inverse() * up_sk)
	# 2. Each arm out of the canvas: the upper arm swings up about the shoulder, then the forearm about the elbow.
	for ids in _arms:
		_raise(skel, xf, int(ids[0]), [int(ids[1]), int(ids[2])], [ELBOW_R, GLOVE_R])
		_raise(skel, xf, int(ids[1]), [int(ids[2])], [GLOVE_R])


## Turn bone `pivot` up (about the horizontal axis across its limb) in STEP_DEG steps until every bone in `pts` is at
## least its radius above the canvas, at most MAX_DEG.
func _raise(skel: Skeleton3D, xf: Transform3D, pivot: int, pts: Array, radii: Array) -> void:
	if not _below(skel, xf, pts, radii):
		return
	var g := skel.get_bone_global_pose(pivot)
	var tip := skel.get_bone_global_pose(int(pts[pts.size() - 1])).origin
	var limb := xf.basis * (tip - g.origin)
	var axis := limb.cross(Vector3.UP)
	if axis.length() < 1e-4:
		return
	axis = (xf.basis.inverse() * axis).normalized()   # skeleton space
	var parent := skel.get_bone_parent(pivot)
	var pq := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	var q0 := g.basis.get_rotation_quaternion()
	var deg := 0.0
	while deg < MAX_DEG and _below(skel, xf, pts, radii):
		deg += STEP_DEG
		# Rotating the limb about (limb x UP) by +angle raises its far end (+X about +Z turns toward +Y).
		var q := Quaternion(axis, deg_to_rad(deg)) * q0
		skel.set_bone_pose_rotation(pivot, (pq.inverse() * q).normalized())


func _below(skel: Skeleton3D, xf: Transform3D, pts: Array, radii: Array) -> bool:
	for k in pts.size():
		if (xf * skel.get_bone_global_pose(int(pts[k])).origin).y < float(radii[k]):
			return true
	return false
