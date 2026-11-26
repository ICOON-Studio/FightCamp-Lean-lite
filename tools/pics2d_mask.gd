extends RefCounted
## MASK1 (S559, ops/research/TASK_MASK1.md). The owner on the body toy: "you break down the body to each limb ... when i
## say you highlight the arm i move my mouse on i do not want text near the fighters (tubes or circles on the fighters are
## forbidden)". An ID pass from the 3D beside each picture: a second SubViewport on the SAME world, its own camera copied
## from the picture camera before each draw, so the mask and the picture are the same frame (nothing waits between them).
## Each body mesh gets a twin on a layer only the mask camera sees: the same mesh, skin and skeleton, one flat colour per
## part by vertex colour - the part whose bones carry the most of that vertex's skin weight. Unshaded, no outline, linear
## tone map, no anti-aliasing, transparent background. Parts (per man): lead arm, rear arm, legs (both: "feet"), torso
## (neck down to the hips), head (BODYUI2, S562: its own part - bones named head, neck, jaw, eye, face). The lead arm is the hand stage.hand_of names for the orthodox LeftHand (a southpaw: his right).
## Godot's own StandardMaterial3D (unshaded, vertex colour as albedo); no addon.

const LAYER := 1 << 19
## [r, g, b] 0..255 per corner and part - anim_web.py snaps the saved mask to exactly these; body_ui.js reads them back.
const PART := {
	"blue": {"lead": [255, 0, 0], "rear": [0, 255, 0], "legs": [0, 0, 255], "torso": [255, 255, 0], "head": [0, 128, 255]},
	"red": {"lead": [255, 0, 255], "rear": [0, 255, 255], "legs": [255, 128, 0], "torso": [128, 0, 255], "head": [255, 0, 128]}}
const ARM := ["upperarm", "lowerarm", "forearm", "elbow", "hand", "wrist", "thumb", "index", "middle", "ring", "little", "pinky", "finger"]
## BODYUI2 (S562, owner Q-339 "head opens slip, roll, lean back"): the head is its own part. Checked first, so no arm or
## leg bone name may hold one of these ("ear" is out: forearm).
const HEAD := ["head", "neck", "jaw", "eye", "face", "facial", "teeth", "tongue", "nose", "brow"]
const LEG := ["upperleg", "lowerleg", "thigh", "calf", "knee", "foot", "toe", "ball", "ankle", "leg"]

var sv: SubViewport
var cam: Camera3D
var main_cam: Camera3D
var main_sv: SubViewport
var twins: Array = []   # [original MeshInstance3D, twin]
var verts := 0
var _arg_dbg := OS.get_cmdline_user_args().has("mask_debug")


func _init(tree_root: Node, stage: Node3D, main: Camera3D, pic_sv: SubViewport) -> void:
	main_cam = main
	main_sv = pic_sv
	main.cull_mask = main.cull_mask & ~LAYER
	sv = SubViewport.new()
	sv.size = pic_sv.size
	sv.transparent_bg = true
	sv.msaa_3d = Viewport.MSAA_DISABLED
	sv.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
	sv.use_taa = false
	sv.use_debanding = false
	sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sv.world_3d = main.get_world_3d()
	tree_root.add_child(sv)
	cam = Camera3D.new()
	cam.cull_mask = LAYER
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.background_color = Color(0, 0, 0, 0)
	env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	env.tonemap_exposure = 1.0
	env.glow_enabled = false
	env.ssao_enabled = false
	env.ssil_enabled = false
	env.fog_enabled = false
	env.adjustment_enabled = false
	cam.environment = env
	sv.add_child(cam)
	# FLAT, not smooth: a triangle across a part boundary (the waist, the shoulder) must not blend two part colours into a
	# third (the first render's waist read as the other man's part). The colour is sRGB, ALBEDO linear.
	var sh := Shader.new()
	sh.code = """shader_type spatial;
render_mode unshaded, cull_disabled, shadows_disabled;
varying flat vec4 part;
void vertex() { part = COLOR; }
void fragment() {
	vec3 c = part.rgb;
	ALBEDO = mix(pow((c + vec3(0.055)) / vec3(1.055), vec3(2.4)), c / vec3(12.92), vec3(lessThan(c, vec3(0.04045))));
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	for i in 2:
		_build(stage, i, mat)
	print("PICS2D_MASK twins=%d vertices=%d" % [twins.size(), verts])


static func part_of(bone: String, lead: String) -> String:
	var n := bone.to_lower().replace("_", "").replace(".", "")
	var b := bone.to_lower()
	var left := n.begins_with("left") or b.ends_with("_l") or b.ends_with(".l")
	var right := n.begins_with("right") or b.ends_with("_r") or b.ends_with(".r")
	for k in HEAD:
		if n.contains(k):
			return "head"
	for k in LEG:
		if n.contains(k):
			return "legs"
	for k in ARM:
		if n.contains(k) and (left or right):
			return "lead" if (left and lead == "Left") or (right and lead == "Right") else "rear"
	return "torso"


func _build(stage: Node3D, i: int, mat: Material) -> void:
	var bx: Dictionary = stage.boxers[i]
	var skel: Skeleton3D = bx["skel"]
	var col: String = ["red", "blue"][i]
	var lead := str(stage.hand_of(i, "LeftHand")).trim_suffix("Hand")
	var bone_part: Array = []
	for b in skel.get_bone_count():
		bone_part.append(part_of(skel.get_bone_name(b), lead))
	if _arg_dbg:   # mask_debug: every bone and its part (BODYUI2: check the head bones by name)
		for b in skel.get_bone_count():
			print("PICS2D_MASK_BONE %s %s -> %s" % [col, skel.get_bone_name(b), bone_part[b]])
	for n in (bx["node"] as Node).find_children("*", "MeshInstance3D", true, false):
		var mi := n as MeshInstance3D
		if mi.mesh == null or mi.has_meta("mask_twin") or mi.mesh.get_surface_count() == 0:
			continue
		var fixed := _attached_part(mi, skel, lead)
		var m := _mesh(mi, skel, bone_part, fixed, PART[col])
		if _arg_dbg:   # mask_debug on the command line
			print("PICS2D_MASK %s %s on %s: %s" % [col, mi.name, mi.get_parent().name, fixed if fixed != "" else "skinned"])
		var tw := MeshInstance3D.new()
		tw.set_meta("art_toon", true)   # ArtStyle leaves it alone
		tw.set_meta("mask_twin", true)
		tw.mesh = m
		tw.skin = mi.skin
		tw.layers = LAYER
		tw.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		tw.material_override = mat
		mi.get_parent().add_child(tw)
		tw.transform = mi.transform
		tw.skeleton = mi.skeleton   # a sibling: the same relative path
		mi.layers = mi.layers & ~LAYER
		twins.append([mi, tw])


## A mesh hung on a bone (BoneAttachment3D) takes that bone's part; "" = skinned (per vertex).
func _attached_part(mi: Node, skel: Skeleton3D, lead: String) -> String:
	var p := mi.get_parent()
	while p != null and p != skel.get_parent():
		if p is BoneAttachment3D:
			return part_of(str((p as BoneAttachment3D).bone_name), lead)
		p = p.get_parent()
	if mi.get("skin") != null:
		return ""
	# a rigid piece moved by a script (the gloves): the part of the bone nearest its middle
	var mid: Vector3 = (mi as MeshInstance3D).global_transform * (mi as MeshInstance3D).get_aabb().get_center()
	var best := -1
	var near := INF
	for b in skel.get_bone_count():
		var d := (skel.global_transform * skel.get_bone_global_pose(b).origin).distance_to(mid)
		if d < near:
			near = d
			best = b
	return part_of(skel.get_bone_name(best), lead) if best >= 0 else "torso"


func _mesh(mi: MeshInstance3D, skel: Skeleton3D, bone_part: Array, fixed: String, pal: Dictionary) -> ArrayMesh:
	var src := mi.mesh
	var skin := mi.skin
	var out := ArrayMesh.new()
	var cols := {}
	for k in pal:
		cols[k] = Color8(int(pal[k][0]), int(pal[k][1]), int(pal[k][2]))
	for s in src.get_surface_count():
		var arr: Array = src.surface_get_arrays(s)
		var pos: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var nv := pos.size()
		verts += nv
		var c := PackedColorArray()
		c.resize(nv)
		var bones = arr[Mesh.ARRAY_BONES]
		var wts = arr[Mesh.ARRAY_WEIGHTS]
		var skinned: bool = fixed == "" and bones != null and wts != null and (wts as PackedFloat32Array).size() >= nv
		var per := (wts as PackedFloat32Array).size() / nv if skinned else 0
		var map := {}   # skin bind -> skeleton bone
		for v in nv:
			var part := fixed if fixed != "" else "torso"
			if skinned:
				var sum := {}
				for j in per:
					var w: float = wts[v * per + j]
					if w <= 0.0:
						continue
					var bi: int = bones[v * per + j]
					if not map.has(bi):
						map[bi] = _bone(skel, skin, bi)
					var bone: int = map[bi]
					var p: String = bone_part[bone] if bone >= 0 and bone < bone_part.size() else "torso"
					sum[p] = float(sum.get(p, 0.0)) + w
				var best := -1.0
				for p in sum:
					if float(sum[p]) > best:
						best = float(sum[p])
						part = p
			c[v] = cols[part]
		arr[Mesh.ARRAY_COLOR] = c
		var flags := Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS if per == 8 else 0
		out.add_surface_from_arrays(src.surface_get_primitive_type(s), arr, [], {}, flags)
	return out


func _bone(skel: Skeleton3D, skin: Skin, bi: int) -> int:
	if skin == null or skin.get_bind_count() == 0:
		return bi
	if bi >= skin.get_bind_count():
		return -1
	var b := skin.get_bind_bone(bi)
	if b < 0:
		b = skel.find_bone(str(skin.get_bind_name(bi)))
	return b


## Before the picture is drawn: the mask camera stands where the picture camera stands, a twin shows when its body shows.
func sync() -> void:
	sv.size = main_sv.size
	cam.projection = main_cam.projection
	cam.size = main_cam.size
	cam.fov = main_cam.fov
	cam.near = main_cam.near
	cam.far = main_cam.far
	cam.keep_aspect = main_cam.keep_aspect
	cam.h_offset = main_cam.h_offset
	cam.v_offset = main_cam.v_offset
	cam.global_transform = main_cam.global_transform
	for t in twins:
		(t[1] as MeshInstance3D).visible = (t[0] as MeshInstance3D).is_visible_in_tree()
		(t[1] as MeshInstance3D).transform = (t[0] as MeshInstance3D).transform


## After the frame both viewports drew: the mask of that same frame.
func save(path: String) -> void:
	sv.get_texture().get_image().save_png(path)
