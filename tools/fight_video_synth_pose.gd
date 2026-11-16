extends RefCounted
## FIGHT VIDEO DATASET (S495): the exact pose labels of a synthetic clip. Each boxer's 17 COCO joints are read off the
## skeleton AS DRAWN (inside Skeleton3D.skeleton_updated: after the whole modifier stack; outside it the bones are back on
## the clip) and projected through the camera that drew the frame.
##   attach(stage) once; frame(stage, cam, size) after the frame is drawn -> {joints, joints3d, gloves, boxes}
## COCO order: nose, l/r eye, l/r ear, l/r shoulder, l/r elbow, l/r wrist, l/r hip, l/r knee, l/r ankle (the boxer's own
## left and right). Shoulder, elbow, wrist, hip, knee, ankle are the joint centres (bone origins). The MetaHuman body has
## no face joints in our rig, so nose, eyes and ears are fixed points in the head bone's frame (FACE, metres on the
## unscaled body; the head bone sits at the skull's base): right to about 2 cm, not exact.
## v (visibility): 2 = inside the picture, 0 = outside it or behind the lens. Whether another body hides the joint is
## NOT worked out (no depth read-back).

const BONES := ["Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand",
	"LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot", "LeftToes", "RightToes"]
## [forward, up, left] from the head bone: nose, left eye, right eye, left ear, right ear.
const FACE := [Vector3(0.115, 0.055, 0.0), Vector3(0.085, 0.095, 0.032), Vector3(0.085, 0.095, -0.032),
	Vector3(0.0, 0.075, 0.075), Vector3(0.0, 0.075, -0.075)]
const HEAD_TOP := Vector3(0.02, 0.21, 0.0)
const BOX_PAD := 0.06   # of the box's own size, each side

var _idx: Array = [[], []]       # per boxer, the bone index of every BONES name
var _drawn: Array = [[], []]     # per boxer, each bone's Transform3D in skeleton space, as drawn this frame
var _face: Array = [[], []]      # per boxer, the head bone's local axes: [forward, up, left]


func attach(stage: Node3D) -> void:
	for i in 2:
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var body: Node3D = stage.boxers[i]["node"]
		var ids: Array = []
		for b in BONES:
			ids.append(skel.find_bone(b))
		_idx[i] = ids
		# The head's own axes for "forward", "up" and "left": read on the rest pose, where the body faces its +Z.
		var to_body := body.global_transform.affine_inverse() * skel.global_transform
		var rest := (to_body * skel.get_bone_global_rest(ids[0])).basis.orthonormalized()
		var l := (to_body * skel.get_bone_global_rest(ids[1])).origin
		var r := (to_body * skel.get_bone_global_rest(ids[2])).origin
		var left := Vector3(signf(l.x - r.x), 0.0, 0.0)
		_face[i] = [rest.inverse() * Vector3(0, 0, 1), rest.inverse() * Vector3(0, 1, 0), rest.inverse() * left]
		_drawn[i] = ids.map(func(id: int) -> Transform3D: return skel.get_bone_global_pose(id))
		skel.skeleton_updated.connect(_read.bind(i, skel))


func _read(i: int, skel: Skeleton3D) -> void:
	var out: Array = []
	for id in _idx[i]:
		out.append(skel.get_bone_global_pose(id))
	_drawn[i] = out


## The 17 COCO joints of boxer i in world space (metres), plus her head top and toes for the box.
func world(stage: Node3D, i: int) -> Dictionary:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var xf := skel.global_transform
	var s := (stage.boxers[i]["node"] as Node3D).scale.x
	var head: Transform3D = xf * (_drawn[i][0] as Transform3D)
	var hb := head.basis.orthonormalized()
	var ax: Array = _face[i]
	var at := func(v: Vector3) -> Vector3:
		return head.origin + hb * ((ax[0] as Vector3) * v.x + (ax[1] as Vector3) * v.y + (ax[2] as Vector3) * v.z) * s
	var pts: Array = []
	for f in FACE:
		pts.append(at.call(f))
	for k in range(1, 13):
		pts.append(xf * (_drawn[i][k] as Transform3D).origin)
	var extra: Array = [at.call(HEAD_TOP), xf * (_drawn[i][13] as Transform3D).origin, xf * (_drawn[i][14] as Transform3D).origin]
	return {"joints": pts, "extra": extra}


## Where a world point falls in the picture, in pixels of `size` (the saved image), and whether it is in front of the lens.
## Worked out from the lens's own projection, not Camera3D.unproject_position: that answers in the window's stretched
## canvas units, which are not the saved picture's pixels (the first test clip drew every joint 50 px off the bodies).
static func project(cam: Camera3D, p: Vector3, size: Vector2) -> Array:
	var v := cam.get_camera_transform().affine_inverse() * p
	var c := cam.get_camera_projection() * Vector4(v.x, v.y, v.z, 1.0)
	if c.w <= 0.0001:
		return [Vector2(-1, -1), false]
	return [Vector2((c.x / c.w * 0.5 + 0.5) * size.x, (0.5 - c.y / c.w * 0.5) * size.y), true]


## One drawn frame -> the labels of both boxers. size = the saved picture in pixels.
func frame(stage: Node3D, cam: Camera3D, size: Vector2) -> Dictionary:
	var joints: Array = []
	var joints3d: Array = []
	var gloves: Array = []
	var boxes: Array = []
	for i in 2:
		var w := world(stage, i)
		var row: Array = []
		var row3: Array = []
		var lo := Vector2(INF, INF)
		var hi := Vector2(-INF, -INF)
		var gl: Array = []
		for hand in ["LeftHand", "RightHand"]:
			var g := project(cam, stage.glove_front(i, hand), size)
			var g2: Vector2 = g[0]
			gl.append([snappedf(g2.x, 0.1), snappedf(g2.y, 0.1)])
			if bool(g[1]):
				lo = lo.min(g2)
				hi = hi.max(g2)
		for p in (w["joints"] as Array):
			var p3: Vector3 = p
			var pr := project(cam, p3, size)
			var p2: Vector2 = pr[0]
			var seen := bool(pr[1]) and p2.x >= 0.0 and p2.y >= 0.0 and p2.x < size.x and p2.y < size.y
			row.append([snappedf(p2.x, 0.1), snappedf(p2.y, 0.1), 2 if seen else 0])
			row3.append([snappedf(p3.x, 0.001), snappedf(p3.y, 0.001), snappedf(p3.z, 0.001)])
			if bool(pr[1]):
				lo = lo.min(p2)
				hi = hi.max(p2)
		for p in (w["extra"] as Array):
			var e := project(cam, p, size)
			if bool(e[1]):
				lo = lo.min(e[0])
				hi = hi.max(e[0])
		var pad := (hi - lo) * BOX_PAD
		lo = (lo - pad).clamp(Vector2.ZERO, size)
		hi = (hi + pad).clamp(Vector2.ZERO, size)
		joints.append(row)
		joints3d.append(row3)
		gloves.append(gl)
		boxes.append([snappedf(lo.x, 0.1), snappedf(lo.y, 0.1), snappedf(hi.x, 0.1), snappedf(hi.y, 0.1)])
	return {"joints": joints, "joints3d": joints3d, "gloves": gloves, "boxes": boxes}
