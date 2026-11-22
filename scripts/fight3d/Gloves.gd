extends Node
## Boxing gloves on a MetaHuman boxer: the hand mesh is cut away (its fingers would poke through) and one glove per hand
## follows the palm frame every time the skeleton updates. A lean version of the old repo's CCFighterSkin procedural
## gloves (rigid, no skinned cuff). The mesh is assets/models/gloves/boxing_glove.glb (CC BY 4.0, CREDITS.md): one
## closed LEFT glove in metres, palm on +Z, its vertex red channel marks the cuff band.

const MeshCut := preload("res://scripts/fight3d/MeshCut.gd")
const GLOVE_PATH := "res://assets/models/gloves/boxing_glove.glb"
## Wrist, middle knuckle, index knuckle, little knuckle, elbow.
const HANDS := {
	"l": ["LeftHand", "LeftMiddleProximal", "LeftIndexProximal", "LeftLittleProximal", "LeftLowerArm"],
	"r": ["RightHand", "RightMiddleProximal", "RightIndexProximal", "RightLittleProximal", "RightLowerArm"],
}
## S316 (operator: "the gloves do not stick properly on the wrist"): the clips bend the bare wrist (the guard idles cock the
## hand back and down), and a glove laid along the hand then leaves the forearm at an angle, its cuff off the wrist. A taped,
## gloved wrist is held nearly straight: the glove's long axis is this share of the way from the hand to the forearm.
## `-- bentwrist` = the control arm (the glove along the hand, as before).
## S400 (operator: "the gloves need to be a bit larger, they look like mma gloves"): amateur women box in 10 oz gloves; the
## mesh at 1.0 read small. front_m() measures the mounted mesh, so reach and GloveClear follow the size.
const SIZE := 1.2
## S536 GLOVEFACE1 (owner C447, a WRONG mark on the guard glove: "is the glove normal looking ?"; numbers and stills in
## docs/GLOVEFACE1_RESULT.md). Measured on the v2 player's own camera: the glove's box (31.2 x 16.8 x 17.0 cm) is inside
## what makers list for a 10 oz glove (29-34.5 x 15.5-17 x 14-16), so SIZE stays. What read wrong was the outline and where
## it sat: (1) the fist is 8.9 cm across at the wrist and only fills out at the knuckles (a club), (2) the cuff is a
## straight 10.7 cm tube, wider than the wrist it joins, (3) the guard glove stood 0.5 to 2.5 cm INSIDE her own face.
##   SHAPE      per axis on top of SIZE (across the knuckles, wrist to knuckles, palm to back): a little shorter and deeper.
##   WAIST      the hand part filled out around the wrist end (mesh y WAIST_Y, over WAIST_SPAN): a rounded fist.
##   CUFF_*     the cuff a bell: CUFF_NECK of its width where it joins the glove, CUFF_OPEN at the forearm end, CUFF_LEN of its length.
##   own face   the glove is kept ON her face, never in it (_off_face): three balls down the glove against the skin her
##              head bone carries; the wrist gives up to WRIST_GIVE, the rest is a slide of at most SLIDE_M under the cuff.
## `-- oldglove` = the control arm (the glove as it was).
const SHAPE := Vector3(1.0, 0.95, 1.06)
const WAIST := 0.10
const WAIST_Y := 0.008
const WAIST_SPAN := 0.05
const CUFF_TOP_Y := -0.03
const CUFF_LEN := 0.95
const CUFF_NECK := 0.92
const CUFF_OPEN := 1.16
## [centre in the mesh's own metres, radius]: the heel of the hand, the fist, the knuckle end.
const BALLS := [[Vector3(-0.008, 0.035, 0.034), 0.059], [Vector3(0.005, 0.085, 0.035), 0.067], [Vector3(0.008, 0.125, 0.03), 0.059]]
const FACE_W := 0.6        # skin counts as her head's when the head bone and its children carry this much of it
const FACE_MAX := 900      # points kept of it
const FACE_NEAR_M := 0.40  # wrist to head bone: further than this the face is not read
const FACE_PAD_M := 0.008
const RIM_SIDE_M := 0.035
const WRIST_GIVE := 0.6   # radians the glove may turn at the wrist to come off the face
const SLIDE_M := 0.045
const EASE := 0.5          # of the way to the cleared place, each skeleton update
const ARM_NEAR_M := 0.17
const OWN_ROOM_M := 0.012  # room kept between her own gloves and forearms past the clash ruler's bar
static var old_glove: bool = OS.get_cmdline_user_args().has("oldglove")
static var _reshaped := {}   # the source mesh -> its reshaped copy
const WRIST_STRAIGHT := 0.85
## Palms in, thumbs on top (the old repo's S162e measure on the certified clips), about the glove's long axis.
const TWIST_DEG := {"l": -75.0, "r": 71.0}
const CUT_FINGERS := ["Thumb", "Index", "Middle", "Ring", "Little"]
## S391 (operator: "how come the gloves are not fixed yet ?"): the MetaHuman palm hangs on lower-case helper bones
## (index_metacarpal_l, pinky_01_half_l), not on Left*/Right* ones. Left standing, it poked out of the straightened glove.
const CUT_HELPERS := ["index_", "middle_", "ring_", "pinky_", "thumb_"]
const SHADER_CODE := """
shader_type spatial;
uniform vec4 colour : source_color = vec4(0.55, 0.05, 0.05, 1.0);
uniform vec4 cuff_colour : source_color = vec4(0.92, 0.92, 0.9, 1.0);
void fragment() {
	float band = smoothstep(0.35, 0.65, COLOR.r);
	ALBEDO = mix(colour.rgb, cuff_colour.rgb, band);
	ROUGHNESS = mix(0.45, 0.53, band);
	CLEARCOAT = mix(0.24, 0.12, band);
	CLEARCOAT_ROUGHNESS = 0.3;
}
"""
static var _shader: Shader = null

var skel: Skeleton3D
var _straight := 0.0 if OS.get_cmdline_user_args().has("bentwrist") else WRIST_STRAIGHT
var gloves := {}
var idx := {}
var _balls := {}                       # side -> [[centre in the glove node's frame, radius]]
var _head := -1
## S537 KNEEROOT1 (owner C464 "why the gloves doing their own thing ?", C466 "reds gloves move on their own"): in the v2
## fight's tight guard the move off the face bent the rear glove 14-34 deg off its own forearm and flicked it up to 17 deg
## in one picture (tools/kneeroot_probe.gd; rigid it stays within 1 deg). Player2 switches it off: the glove is where
## the take puts the hand. Every other user (the gym, the shipped player) keeps it.
var face_clear := true
var _face := PackedVector3Array()      # her face, in the head bone's frame
var _face_n := PackedVector3Array()
var _turn := {}                        # side -> the glove's eased turn off the face (its own frame)
var _slide := {}                       # side -> its eased slide


## Puts gloves of `colour` (cuff band `cuff`) on the body. Returns how many hands got one.
func mount(body: Node3D, colour: Color, cuff: Color) -> int:
	var skels := body.find_children("*", "Skeleton3D", true, false)
	if skels.is_empty():
		return 0
	skel = skels[0] as Skeleton3D
	var packed := load(GLOVE_PATH) as PackedScene
	if packed == null:
		return 0
	if _shader == null:
		_shader = Shader.new()
		_shader.code = SHADER_CODE
	for side in HANDS:
		var bones: Array = []
		for b in HANDS[side]:
			bones.append(skel.find_bone(str(b)))
		if bones.has(-1):
			continue
		idx[side] = bones
		var g := Node3D.new()
		g.name = "Glove_" + side
		var model := packed.instantiate() as Node3D
		model.name = "Geometry"
		# The mesh is a LEFT glove (thumb lobe on -X, palm +Z). The right hand's frame mirrors X; the left takes it turned
		# half a turn about Y. Then the twist about the long axis.
		model.scale = (Vector3(-1.0, 1.0, 1.0) if side == "r" else Vector3(-1.0, 1.0, -1.0)) * SIZE * (Vector3.ONE if old_glove else SHAPE)
		model.transform = Transform3D(Basis(Vector3.UP, deg_to_rad(float(TWIST_DEG[side]))), Vector3.ZERO) * model.transform
		var mat := ShaderMaterial.new()
		mat.shader = _shader
		mat.set_shader_parameter("colour", colour)
		mat.set_shader_parameter("cuff_colour", cuff)
		for mi in model.find_children("*", "MeshInstance3D", true, false):
			(mi as MeshInstance3D).material_override = mat
			if not old_glove:
				(mi as MeshInstance3D).mesh = _reshape((mi as MeshInstance3D).mesh)
		var balls: Array = []
		for ball in BALLS:
			balls.append([model.transform * (ball[0] as Vector3), float(ball[1]) * SIZE * (SHAPE.x + SHAPE.z) * 0.5])
		_balls[side] = balls
		g.add_child(model)
		skel.add_child(g)
		gloves[side] = g
	if not old_glove:
		_read_face(body)
	_cut_hands(body)
	skel.skeleton_updated.connect(_follow)
	_follow()
	return gloves.size()


## Wrist to the striking face of the glove, metres along the glove's long axis (from the mounted mesh).
func front_m() -> float:
	var g: Node3D = gloves.get("l") if gloves.has("l") else null
	if g == null:
		return 0.15
	var top := 0.0
	for m in g.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var xf := g.global_transform.affine_inverse() * mi.global_transform
		var box: AABB = xf * mi.get_aabb()
		top = maxf(top, box.end.y)
	return top if top > 0.05 else 0.15


func _follow() -> void:
	var placed := {}
	var arms := {}
	for side in gloves:
		var bones: Array = idx[side]
		var p: Array = []
		for i in bones:
			p.append(skel.get_bone_global_pose(int(i)).origin)
		var wrist: Vector3 = p[0]
		var along: Vector3 = (p[1] as Vector3) - wrist
		if along.length() < 1e-5:
			continue
		along = along.normalized()
		var arm: Vector3 = wrist - (p[4] as Vector3)
		if _straight > 0.0 and arm.length() > 1e-5 and along.angle_to(arm) > 1e-3:
			along = along.slerp(arm.normalized(), _straight).normalized()
		var across: Vector3 = (p[2] as Vector3) - (p[3] as Vector3)
		across = across - along * across.dot(along)
		across = across.normalized() if across.length() > 1e-5 else along.cross(Vector3.UP).normalized()
		placed[side] = Transform3D(Basis(across, along, across.cross(along).normalized()), wrist)
		arms[side] = [wrist, p[4]]   # [wrist, elbow]
	for side in placed:
		var xf: Transform3D = placed[side]
		if (face_clear and not _face.is_empty()):
			var other: String = "r" if side == "l" else "l"
			var keep_off: Array = []
			if placed.has(other):
				keep_off = [(placed[other] as Transform3D) * (_balls[other][1][0] as Vector3), ((arms[other][0] as Vector3) + (arms[other][1] as Vector3)) * 0.5]
			var want := _off_face(xf, _balls[side], keep_off)
			# Eased (EASE of the way each update), in the glove's own frame: a look at her face that jumps for one frame
			# (a weave, a lean) moves the glove a little, never pops it.
			var turn: Quaternion = (_turn.get(side, Quaternion.IDENTITY) as Quaternion).slerp((xf.basis.inverse() * want.basis).get_rotation_quaternion(), EASE)
			var slide: Vector3 = (_slide.get(side, Vector3.ZERO) as Vector3).lerp(xf.basis.inverse() * (want.origin - xf.origin), EASE)
			_turn[side] = turn
			_slide[side] = slide
	# Her own two arms: the move off her face never puts a glove into her other glove or forearm (the shapes
	# tools/clash_meter.gd draws), or deeper into one than it stood.
	var share := 1.0
	if placed.size() == 2 and (face_clear and not _face.is_empty()):
		var need := minf(_own_room(placed, arms, 0.0), OWN_ROOM_M)
		while share > 0.0 and _own_room(placed, arms, share) < need - 0.0005:
			share -= 0.25
	for side in placed:
		(gloves[side] as Node3D).transform = _moved(placed[side], side, share) if (face_clear and not _face.is_empty()) else (placed[side] as Transform3D)


## The glove's place with `share` of its eased move off the face.
func _moved(xf: Transform3D, side: String, share: float) -> Transform3D:
	var turn: Quaternion = Quaternion.IDENTITY.slerp(_turn.get(side, Quaternion.IDENTITY), share)
	return Transform3D(xf.basis * Basis(turn), xf.origin + xf.basis * ((_slide.get(side, Vector3.ZERO) as Vector3) * share))


## The room her two arms leave each other with `share` of the move off the face, metres (negative = past the clash
## ruler's 2 cm give): glove against glove (0.13 m between their axes) and each glove against the other forearm (0.095).
func _own_room(placed: Dictionary, arms: Dictionary, share: float) -> float:
	var room := 9.0
	var axes := {}
	for side in ["l", "r"]:
		var xf := _moved(placed[side], side, share)
		axes[side] = [xf.origin + xf.basis.y * 0.04, xf.origin + xf.basis.y * 0.0775, xf.origin + xf.basis.y * 0.115]
	for a in axes["l"]:
		for b in axes["r"]:
			room = minf(room, (a as Vector3).distance_to(b) - 0.13)
	for side in ["l", "r"]:
		var other: String = "r" if side == "l" else "l"
		for a in axes[side]:
			for f in [0.0, 0.33, 0.67, 1.0]:
				room = minf(room, (a as Vector3).distance_to((arms[other][1] as Vector3).lerp(arms[other][0], f)) - 0.095)
	return room


## GLOVEFACE1: the glove's place with its balls out of her own face (skeleton space). The deepest ball first: the glove
## turns about the wrist (a guard's wrist bends) up to WRIST_GIVE, then slides along the face's normal up to SLIDE_M (the
## bell cuff hides that much). It never moves at her other arm (`keep_off`: its fist and mid forearm, when within
## ARM_NEAR_M): that part of the push is dropped, unless nearly all of it is.
func _off_face(xf: Transform3D, balls: Array, keep_off: Array) -> Transform3D:
	var head := skel.get_bone_global_pose(_head)
	if xf.origin.distance_squared_to(head.origin) > FACE_NEAR_M * FACE_NEAR_M:
		return xf
	var inv := head.affine_inverse()
	var mid: Vector3 = inv * (xf * (balls[1][0] as Vector3))
	var near := PackedInt32Array()
	for i in _face.size():
		if _face[i].distance_squared_to(mid) < 0.0324:   # 18 cm
			near.append(i)
	if near.is_empty():
		return xf
	var turned := 0.0
	var slid := 0.0
	for pass_n in 6:
		var worst := 0.001
		var dir := Vector3.ZERO
		var arm := Vector3.ZERO
		for ball in balls:
			var c: Vector3 = xf * (ball[0] as Vector3)
			var ch := inv * c
			var d2 := 1e9
			var hit := -1
			for i in near:
				var e := _face[i].distance_squared_to(ch)
				if e < d2:
					d2 = e
					hit = i
			var s := (ch - _face[hit]).dot(_face_n[hit])
			var pen := float(ball[1]) + FACE_PAD_M - s
			# The nearest skin must lie under the ball along its own normal (within RIM_SIDE_M to the side): at the open
			# rim of the head's skin (the neck, under the jaw) a ball beside the neck is not in her face.
			if pen > worst and d2 - s * s < RIM_SIDE_M * RIM_SIDE_M:
				worst = pen
				dir = (head.basis * _face_n[hit]).normalized()
				arm = c - xf.origin
		if dir == Vector3.ZERO:
			break
		var free := dir
		for point in keep_off:
			var to: Vector3 = (point as Vector3) - (xf.origin + arm)
			if to.length() < ARM_NEAR_M:
				free -= to.normalized() * maxf(free.dot(to.normalized()), 0.0)
		if free.length() > 0.35:
			worst = minf(worst / free.length(), worst * 1.6)
			dir = free.normalized()
		var want := arm + dir * worst
		var axis := arm.cross(want)
		if turned < WRIST_GIVE - 0.005 and arm.length() > 0.07 and axis.length() > 1e-6:
			var ang := minf(arm.angle_to(want), WRIST_GIVE - turned)
			xf.basis = Basis(axis.normalized(), ang) * xf.basis
			turned += ang
		elif slid < SLIDE_M - 0.0005:
			var move := minf(worst, SLIDE_M - slid)
			xf.origin += dir * move
			slid += move
		else:
			break
	return xf


## GLOVEFACE1: the skin her head bone and its children carry, thinned to FACE_MAX points, in the head bone's frame.
func _read_face(body: Node3D) -> void:
	_head = skel.find_bone("Head")
	if _head < 0:
		return
	var carried := {}
	for b in skel.get_bone_count():
		var up := b
		while up >= 0 and up != _head:
			up = skel.get_bone_parent(up)
		if up == _head:
			carried[b] = true
	var inv := skel.get_bone_global_rest(_head).affine_inverse()
	var pts := PackedVector3Array()
	var nrm := PackedVector3Array()
	for found in body.find_children("*", "MeshInstance3D", true, false):
		var mi := found as MeshInstance3D
		if mi.skin == null or not (mi.mesh is ArrayMesh):
			continue
		var binds := {}
		for bi in mi.skin.get_bind_count():
			var nm := str(mi.skin.get_bind_name(bi))
			if carried.has(skel.find_bone(nm) if not nm.is_empty() else mi.skin.get_bind_bone(bi)):
				binds[bi] = true
		var mesh := mi.mesh as ArrayMesh
		for s in (mesh.get_surface_count() if not binds.is_empty() else 0):
			var mat := mesh.surface_get_material(s)
			if mat == null or not mat.resource_name.begins_with("MH_Skin"):
				continue
			var arr: Array = mesh.surface_get_arrays(s)
			var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var normals: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
			var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
			var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
			if bones.is_empty() or normals.size() != verts.size():
				continue
			var per: int = bones.size() / verts.size()
			for i in verts.size():
				var w := 0.0
				for k in per:
					if binds.has(bones[i * per + k]):
						w += weights[i * per + k]
				if w >= FACE_W:
					pts.append(inv * verts[i])
					nrm.append((inv.basis * normals[i]).normalized())
	var step := maxi(1, int(ceil(float(pts.size()) / FACE_MAX)))
	for i in range(0, pts.size(), step):
		_face.append(pts[i])
		_face_n.append(nrm[i])


## GLOVEFACE1: the glove mesh with a filled-out wrist end and a bell cuff (the vertex-red band is kept), made once.
static func _reshape(src: Mesh) -> Mesh:
	if _reshaped.has(src):
		return _reshaped[src]
	var out := ArrayMesh.new()
	for s in src.get_surface_count():
		var arr: Array = src.surface_get_arrays(s)
		var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var low := 0.0
		for v in verts:
			low = minf(low, v.y)
		for i in verts.size():
			var v := verts[i]
			var k := 1.0 + WAIST * exp(-pow((v.y - WAIST_Y) / WAIST_SPAN, 2.0))
			if v.y < CUFF_TOP_Y:
				var t := clampf((CUFF_TOP_Y - v.y) / maxf(CUFF_TOP_Y - low, 1e-4), 0.0, 1.0)
				k = lerpf(k, lerpf(CUFF_NECK, CUFF_OPEN, t), smoothstep(0.0, 0.25, t))
				v.y = CUFF_TOP_Y - (CUFF_TOP_Y - v.y) * CUFF_LEN
			verts[i] = Vector3(v.x * k, v.y, v.z * k)
		arr[Mesh.ARRAY_VERTEX] = verts
		out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
		out.surface_set_material(s, src.surface_get_material(s))
	_reshaped[src] = out
	return out


## Drops every triangle that the hand or finger bones carry (weight >= 0.25), so no finger shows through a glove.
func _cut_hands(body: Node3D) -> void:
	var names := MeshCut.bones_named(skel, CUT_FINGERS)
	for n in names.keys():
		if not (str(n).begins_with("Left") or str(n).begins_with("Right")):
			names.erase(n)
	for bi in skel.get_bone_count():
		var bn := str(skel.get_bone_name(bi))
		if bn.ends_with("_l") or bn.ends_with("_r"):
			for prefix in CUT_HELPERS:
				if bn.begins_with(prefix):
					names[bn] = true
	names["LeftHand"] = true
	names["RightHand"] = true
	for found in body.find_children("*", "MeshInstance3D", true, false):
		MeshCut.cut(found as MeshInstance3D, skel, names)
