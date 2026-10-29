extends RefCounted
## S115 - FIGHTER KIT: what a fighter wears that his body mesh does not carry.
##
## The operator, 2026-09-27: "when you notice something you have to act on it - all fighters have no
## clothes and no gloves". The four boxing bodies (f01-f04) wear gloves and trunks but stand barefoot;
## real boxers wear boxing boots. f01 is the C200 reference rig (hash-locked), so the boot cannot be
## baked into its mesh: it rides each foot bone on a BoneAttachment3D, sized from the rig's OWN foot
## and toe bones, so one boot fits every boxing body.
##
## The boot is `assets/models/kit/boxing_boot.glb` (Higgsfield tripo_3d, job c5591bc5, 5 credits,
## commercial use per Higgsfield terms s4.4). A stand-in until the MPFB generator pipeline
## (status deck: "Fighters - one pipeline") dresses bodies from its CC0 clothes library.
##
## Kickboxing, muay thai and MMA are fought barefoot - no boots there, by the rules.

const BOOT_PATH := "res://assets/models/kit/boxing_boot.glb"
## Real boxing boot on our rigs: the toe JOINT is the ball of the foot; the toe tips reach ~7 cm past it
## (measured S115 - a 4 cm spill left bare toes showing), so the sole runs 10 cm past the joint.
const TOE_SPILL_M := 0.10
const HEEL_SPILL_M := 0.09
## Our rigs' feet are wider than the generated boot's proportions (S115: skin showed at the inner edge).
const WIDTH_FACTOR := 1.3
## The toe bone sits this far above the floor in the rest pose (sole thickness under the ball).
const TOE_CLEAR_M := 0.02
## The generated boot's toe points along -Z (measured S115: the first fit showed it on backwards),
## so it turns half a circle to face the rig's +Z forward.
const BOOT_YAW := PI
const FEET := [["LeftFoot", "LeftToes", 1.0], ["RightFoot", "RightToes", -1.0]]


## True when this body's discipline wears boxing boots: the old boxing bodies f01-f04 and every MetaHuman boxer (mh_boxer_*).
## S263 (operator: "use boots on the fighters", "i told you before"): the `_box_` test never matched mh_boxer_NN.glb, so every
## MetaHuman boxer fought barefoot. With a discipline given, only boxing wears them (kickboxing/muay thai/MMA are barefoot).
## The top takes the corner's colour, matte: MH_Top is the singlet painted on the skin (S299 re-export); Staff_Shirt is the
## old Creator tee (no body under it) on bodies not yet re-exported. (Moved from FightStage, S306.)
static func colour_vest(body: Node3D, colour: Color, roughness: float) -> void:
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			if src != null and (src.resource_name.begins_with("Staff_Shirt") or src.resource_name.begins_with("MH_Top")):
				var vest := StandardMaterial3D.new()
				vest.albedo_color = colour
				vest.roughness = roughness
				mi.set_surface_override_material(s, vest)


static func wears_boots(model_name: String, discipline: String = "") -> bool:
	var file := model_name.get_file().to_lower()
	var boxing_body: bool = file.contains("_box_") or _is_mh_boxer(model_name)
	if not discipline.is_empty():
		return discipline == "boxing" and boxing_body
	return boxing_body


static func _is_mh_boxer(model_name: String) -> bool:
	return model_name.contains("/metahuman/") and model_name.get_file().to_lower().begins_with("mh_boxer")


## Dress one mounted fighter. Returns how many kit pieces were added (0 when none apply).
## Idempotent: a body that is already dressed is left alone.
static func dress(body: Node3D, model_name: String, discipline: String = "") -> int:
	if body == null or not wears_boots(model_name, discipline):
		return 0
	var skels: Array = body.find_children("*", "Skeleton3D", true, false)
	if skels.is_empty():
		return 0
	var skel: Skeleton3D = skels[0] as Skeleton3D
	if skel.has_node("FighterKit_LeftFoot"):
		return 0
	var scene: PackedScene = load(BOOT_PATH)
	if scene == null:
		return 0
	if _is_mh_boxer(model_name):
		return _dress_metahuman(body, skel, scene)
	var added := 0
	for foot in FEET:
		var foot_bone: int = skel.find_bone(str(foot[0]))
		var toe_bone: int = skel.find_bone(str(foot[1]))
		if foot_bone < 0 or toe_bone < 0:
			continue
		## Toe joint in the foot bone's rest frame: how far forward and how far down it sits.
		var toe_local: Vector3 = skel.get_bone_rest(toe_bone).origin
		var boot: Node3D = scene.instantiate()
		var box := _mesh_box(boot)
		if box.size.z <= 0.0:
			boot.free()
			continue
		var length_m: float = toe_local.z + TOE_SPILL_M + HEEL_SPILL_M
		var s: float = length_m / box.size.z
		var attach := BoneAttachment3D.new()
		attach.name = "FighterKit_" + str(foot[0])
		attach.bone_name = str(foot[0])
		skel.add_child(attach)
		attach.add_child(boot)
		## Turn the toe forward, mirror the right boot across the foot's own X.
		boot.rotation = Vector3(0.0, BOOT_YAW, 0.0)
		boot.scale = Vector3(s * WIDTH_FACTOR * float(foot[2]), s, s)
		var sole_y: float = toe_local.y - TOE_CLEAR_M
		var front_z: float = toe_local.z + TOE_SPILL_M
		## After the half turn the boot's local -Z end (box.position.z) is its toe.
		boot.position = Vector3(0.0, sole_y - box.position.y * s, front_z + box.position.z * s)
		for mi in boot.find_children("*", "MeshInstance3D", true, false):
			mi.set_meta("fighter_kit", true)
		added += 1
	return added


## S263 MetaHuman boots. A MetaHuman foot bone's local axes are UE's (not +Z forward / +Y up), so the f01 fit in the bone's
## own frame floated the soles (Cursor #260 r2: 0.65 m up). The boot is fitted in the FIGHTER's rest space instead (Y up):
## forward = ankle -> ball on the ground plane, toe end TOE_SPILL_M past the ball, heel HEEL_SPILL_M behind the ankle, sole
## on the body's own lowest skin vertex (MetaHumanRig.height_of), centred on the ankle-ball line; then expressed in the foot
## bone's rest frame, so the BoneAttachment3D carries it through every pose.
static func _dress_metahuman(body: Node3D, skel: Skeleton3D, scene: PackedScene) -> int:
	var to_body := Transform3D.IDENTITY
	var node: Node = skel
	while node != body and node != null:
		if node is Node3D:
			to_body = (node as Node3D).transform * to_body
		node = node.get_parent()
	var sole_y: float = (preload("res://scripts/fight3d/MHRig.gd").height_of(body) as Vector2).x
	if not is_finite(sole_y):
		return 0
	var added := 0
	for foot in FEET:
		var foot_bone: int = skel.find_bone(str(foot[0]))
		var toe_bone: int = skel.find_bone(str(foot[1]))
		if foot_bone < 0 or toe_bone < 0:
			continue
		var foot_rest: Transform3D = to_body * skel.get_bone_global_rest(foot_bone)
		var ankle: Vector3 = foot_rest.origin
		var ball: Vector3 = (to_body * skel.get_bone_global_rest(toe_bone)).origin
		var fwd := Vector3(ball.x - ankle.x, 0.0, ball.z - ankle.z)
		if fwd.length() < 0.03:
			continue
		var ball_reach: float = fwd.length()
		fwd = fwd.normalized()
		var boot: Node3D = scene.instantiate()
		var box := _mesh_box(boot)
		if box.size.z <= 0.0:
			boot.free()
			continue
		var s: float = (ball_reach + TOE_SPILL_M + HEEL_SPILL_M) / box.size.z
		## Mesh toe points along local -Z (S115); looking_at sends -Z along `fwd`. The right boot mirrors across local X.
		var b: Basis = Basis.looking_at(fwd, Vector3.UP) * Basis.from_scale(Vector3(s * WIDTH_FACTOR * float(foot[2]), s, s))
		var toe_sole_local := Vector3(box.position.x + box.size.x * 0.5, box.position.y, box.position.z)
		var toe_sole_target := Vector3(ball.x, sole_y, ball.z) + fwd * TOE_SPILL_M
		var fit := Transform3D(b, toe_sole_target - b * toe_sole_local)
		var attach := BoneAttachment3D.new()
		attach.name = "FighterKit_" + str(foot[0])
		attach.bone_name = str(foot[0])
		skel.add_child(attach)
		attach.add_child(boot)
		boot.transform = foot_rest.affine_inverse() * fit
		_skin_to_shin(skel, to_body, boot, fit, str(foot[0]), ankle.y)
		for mi in boot.find_children("*", "MeshInstance3D", true, false):
			mi.set_meta("fighter_kit", true)
		added += 1
	return added


## S266 (operator "wtf" on two crops of Ziva's fight video: a boot floating off the leg): the high-top boot rode the FOOT bone
## rigidly, so whenever the ankle bent the shin swung out of the shaft (shaft rim 9.9 cm off the shin at 30 deg). A hard cut into
## foot + shin pieces showed the boot's inside where tall side panels crossed the cut. So the boot is SKINNED like a body mesh:
## every vertex blends from the foot bone to the shin bone across a band around the ankle (BLEND_FROM_M .. BLEND_TO_M above the
## ankle joint), baked in skeleton space with the bone rests as binds. The rigid boot stays on its FighterKit_<Foot> attachment
## HIDDEN - it is the foot-box proxy older checks measure (centre/axis/sole), never drawn. No shin bone -> the rigid boot stays.
const BLEND_FROM_M := -0.02
const BLEND_TO_M := 0.05
const SHIN_BONES := {"LeftFoot": ["LeftLowerLeg", "calf_l"], "RightFoot": ["RightLowerLeg", "calf_r"]}


static func _skin_to_shin(skel: Skeleton3D, to_body: Transform3D, boot: Node3D, fit: Transform3D, foot_name: String, ankle_y: float) -> void:
	var foot_bone := skel.find_bone(foot_name)
	var shin_bone := -1
	var shin_name := ""
	for name in SHIN_BONES.get(foot_name, []):
		shin_bone = skel.find_bone(str(name))
		if shin_bone >= 0:
			shin_name = str(name)
			break
	if foot_bone < 0 or shin_bone < 0:
		return
	var skin := Skin.new()
	skin.add_named_bind(foot_name, skel.get_bone_global_rest(foot_bone).affine_inverse())
	skin.add_named_bind(shin_name, skel.get_bone_global_rest(shin_bone).affine_inverse())
	var body_to_skel: Transform3D = to_body.affine_inverse()
	var made := 0
	for mi_value in boot.find_children("*", "MeshInstance3D", true, false):
		var mi: MeshInstance3D = mi_value
		var to_rest: Transform3D = fit * _local_to_root(mi, boot)  ## mesh -> fighter rest space (Y up), where the band is
		var mesh := _skinned_mesh(mi, to_rest, body_to_skel * to_rest, ankle_y)
		if mesh == null:
			continue
		var drawn := MeshInstance3D.new()
		drawn.name = "FighterKitSkin_%s_%d" % [foot_name, made]
		drawn.mesh = mesh
		drawn.skin = skin
		skel.add_child(drawn)
		drawn.skeleton = drawn.get_path_to(skel)
		drawn.set_meta("fighter_kit", true)
		drawn.set_meta("boot_skinned", true)
		made += 1
	if made > 0:
		boot.visible = false


static func _local_to_root(node: Node3D, root: Node3D) -> Transform3D:
	var xf := Transform3D.IDENTITY
	var n: Node = node
	while n != root and n != null:
		if n is Node3D:
			xf = (n as Node3D).transform * xf
		n = n.get_parent()
	return xf


## The boot mesh baked into skeleton space with 2-bone weights (bind 0 = foot, 1 = shin). A mirrored fit (the right boot,
## negative X scale) flips the triangle winding so the faces still point out.
static func _skinned_mesh(mi: MeshInstance3D, to_rest: Transform3D, to_skel: Transform3D, ankle_y: float) -> ArrayMesh:
	var src: Mesh = mi.mesh
	if src == null:
		return null
	var out := ArrayMesh.new()
	var nbasis: Basis = to_skel.basis.inverse().transposed()
	var mirrored: bool = to_skel.basis.determinant() < 0.0
	for s in src.get_surface_count():
		var a: Array = src.surface_get_arrays(s)
		var verts: PackedVector3Array = a[Mesh.ARRAY_VERTEX]
		var n: int = verts.size()
		var out_v := PackedVector3Array()
		out_v.resize(n)
		var bones := PackedInt32Array()
		bones.resize(n * 4)
		var weights := PackedFloat32Array()
		weights.resize(n * 4)
		for k in n:
			var h: float = (to_rest * verts[k]).y - ankle_y
			var w: float = smoothstep(BLEND_FROM_M, BLEND_TO_M, h)
			out_v[k] = to_skel * verts[k]
			bones[k * 4] = 0
			bones[k * 4 + 1] = 1
			weights[k * 4] = 1.0 - w
			weights[k * 4 + 1] = w
		a[Mesh.ARRAY_VERTEX] = out_v
		if a[Mesh.ARRAY_NORMAL] != null:
			var nr: PackedVector3Array = a[Mesh.ARRAY_NORMAL]
			for k in nr.size():
				nr[k] = (nbasis * nr[k]).normalized()
			a[Mesh.ARRAY_NORMAL] = nr
		if a[Mesh.ARRAY_TANGENT] != null:
			var tg: PackedFloat32Array = a[Mesh.ARRAY_TANGENT]
			for k in range(0, tg.size(), 4):
				var t: Vector3 = (to_skel.basis * Vector3(tg[k], tg[k + 1], tg[k + 2])).normalized()
				tg[k] = t.x
				tg[k + 1] = t.y
				tg[k + 2] = t.z
				if mirrored:
					tg[k + 3] = -tg[k + 3]
			a[Mesh.ARRAY_TANGENT] = tg
		var idx: PackedInt32Array = a[Mesh.ARRAY_INDEX] if a[Mesh.ARRAY_INDEX] != null else PackedInt32Array()
		if idx.is_empty():
			idx.resize(n)
			for k in n:
				idx[k] = k
		if mirrored:
			for t in range(0, idx.size() - 2, 3):
				var tmp := idx[t + 1]
				idx[t + 1] = idx[t + 2]
				idx[t + 2] = tmp
		a[Mesh.ARRAY_INDEX] = idx
		a[Mesh.ARRAY_BONES] = bones
		a[Mesh.ARRAY_WEIGHTS] = weights
		out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, a)
		out.surface_set_material(out.get_surface_count() - 1, mi.get_active_material(s))
	return out if out.get_surface_count() > 0 else null


static func _mesh_box(node: Node3D) -> AABB:
	var out := AABB()
	var first := true
	for mi in node.find_children("*", "MeshInstance3D", true, false):
		var m := mi as MeshInstance3D
		var box: AABB = m.transform * m.get_aabb()
		out = box if first else out.merge(box)
		first = false
	return out
