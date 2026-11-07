extends SceneTree
## S394 (menu direction S393, the blind reviewers' top fault in all 8 rounds: "bare heads with no kit"): the portrait set for the
## menus. Head and shoulders on the studio set's slate backdrop. Men bare-chested (S372), women in a singlet in a colour that is
## no corner's (gym_singlet.gd). S395: no gloves (his S380 "pose without gloves"; they read as bowling balls), the arms hang out
## of frame, and a soft key from the front replaces the hard overhead lamp that made the skin sweaty plastic.
##   python tools/hidden_desktop.py run --timeout=590 --log=<f> <godot.exe> --path . --windowed --resolution 720x900 \
##       --audio-driver Dummy --script res://tools/bake_gym_portraits.gd [-- stems=mh_boxer_01,mh_boxer_10] [test=<dir>]
## Writes assets/ui/face/gym/<stem>.jpg (W x H, 4:5 as the studio set) and gym/promo_face.json (the marks, promo_face.json's format);
## test=<dir> writes the photos there instead. The file IS the frame: PromoShot's CROP_H is for the waist-up studio set.
## Every look is a constant below. Drawn in a SubViewport at SS times the size, so it does not matter what size the window opens at.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Look := preload("res://scripts/rules/MetaHumanLook.gd")
const Singlet := preload("res://tools/gym_singlet.gd")

const W := 720
const H := 900
const SS := 2                # drawn at twice the size and scaled down: clean hair cards
const OUT := "res://assets/ui/face/gym"
const FOV := 14.0            # degrees, vertical: a long press lens, about 2.6 m off
const FRAME_M := 0.40        # metres of fighter from the frame's top to its bottom, at the face: S395 a press headshot, the chest seams stay out
const EYES_AT := 0.44        # the eye line, from the top of the frame
const POSE := ["mc_win", 0.8]   # an upright, square stance; the arms are then set by _arm
const CHIN_DOWN_DEG := 2.0   # head pitch: a touch down, a serious look
const HAND_DROP_M := 0.72    # wrists this far under the eye line: the arms hang, the hands are out of frame
const HAND_SIDE_M := 0.27    # each wrist off the middle
const HAND_OUT_M := 0.0      # wrists in the eyes' plane
const LAMP_AT := Vector3(0.45, 0.8, 1.3)   # off the eyes: a key high and to one side of the lens
const LAMP_PALE := 2.7       # lamp energy on the palest skin
const LAMP_DARK := 4.4       # and on the darkest: one exposure washed out the pale faces
const LAMP_SIZE := 0.3       # metres: a soft box, so the shadows have wide edges
const AMBIENT_PALE := 0.36
const AMBIENT_DARK := 0.55    # dark skin keeps its chin and neck out of the black
const FILL := 0.8            # the low bounce, on the far side of the key
const SKIN_SSS := 0.45       # under the game's 0.55: the shadow's edge glowed red round the eyes
const SKIN_ROUGH := 0.62     # dry skin: the game's 0.48 and sweat read as plastic this close
const SKIN_SPEC := 0.28
const LASH_ALPHA := 0.08      # blind review: the stacked lash cards read as blocky falsies; fighters wear no make-up
## Not corner colours: no red, no blue. One per woman in Faces.CM's order, so neighbours differ.
const SINGLETS := ["#1d2024", "#57534a", "#12291f", "#3d3117", "#0e2f31", "#2a1b30", "#343a3f"]
const SINGLET_TRIM := "#a8a496"   # the binding: TRIM_MIX of this in the singlet's colour
const TRIM_MIX := 0.5
const BG := Color(0.50, 0.55, 0.60)   # the studio set's slate (bake_promo bg=, PromoShot's note): dark skin and hair read on it, no keying

var _vp: SubViewport
var _env: Environment
var _cam: Camera3D
var _lamp: SpotLight3D
var _fill: OmniLight3D
var _out := OUT
var _test := false
var _marks := {}


func _initialize() -> void:
	root.size = Vector2i(W, H)
	var stems: Array = Faces.CM.keys() + Faces.MEN_CM.keys()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = Array(a.trim_prefix("stems=").split(","))
		if a.begins_with("test="):
			_out = a.trim_prefix("test=")
			_test = true
	stems.sort()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_out))
	_studio()
	var n := 0
	for stem in stems:
		var glb := Faces.glb(str(stem))
		var body := MH.load_fighter(glb)
		if body == null:
			push_error("cannot load " + glb)
			continue
		var mesh := body.find_child("MH_Body", true, false) as MeshInstance3D
		Singlet.weld_weights(mesh)
		_portrait_materials(body, mesh)
		Singlet.bare_top(mesh)
		_vp.add_child(body)
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		if Faces.CM.has(stem):   # the men box bare-chested (S372)
			var pick := Color(str(SINGLETS[Faces.CM.keys().find(stem) % SINGLETS.size()]))
			Singlet.wear(mesh, skel, pick, pick.lerp(Color(SINGLET_TRIM), TRIM_MIX))
		var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		FightClips.load_into(ap, skel)
		var pale := clampf((Look.tone_luma(MH._skin_tone(glb)) - 0.25) / 0.5, 0.0, 1.0)
		_lamp.light_energy = lerpf(LAMP_DARK, LAMP_PALE, pale)
		_env.ambient_light_energy = lerpf(AMBIENT_DARK, AMBIENT_PALE, pale)
		ap.play(str(POSE[0]))
		ap.seek(float(POSE[1]), true)
		ap.pause()
		await process_frame
		_square(body, skel)
		for i in 6:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := _vp.get_texture().get_image()
		img.resize(W, H, Image.INTERPOLATE_LANCZOS)
		var path := ProjectSettings.globalize_path(_out.path_join(str(stem) + ".jpg"))
		img.save_jpg(path, 0.92)
		_marks[stem] = _face_uv(skel)
		print("GYM %s -> %s %s" % [stem, path, JSON.stringify(_marks[stem])])
		n += 1
		body.queue_free()
		await process_frame
	if not _test:
		_save_marks()
	print("GYM baked=%d" % n)
	quit(0 if n > 0 else 1)


## The room: the lamp above, a small low bounce, the slate behind. Nothing else lights the fighter.
func _studio() -> void:
	_vp = SubViewport.new()
	_vp.size = Vector2i(W * SS, H * SS)
	_vp.msaa_3d = Viewport.MSAA_8X   # hair cards (S332)
	_vp.use_debanding = true
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.positional_shadow_atlas_size = 8192
	_vp.positional_shadow_atlas_quad_0 = Viewport.SHADOW_ATLAS_QUADRANT_SUBDIV_1
	root.add_child(_vp)
	RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
	var env := WorldEnvironment.new()
	_env = Environment.new()
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = BG
	_env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	_env.ambient_light_color = Color(0.55, 0.6, 0.68)
	_env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = _env
	_vp.add_child(env)
	_cam = Camera3D.new()
	_cam.fov = FOV
	_vp.add_child(_cam)
	_cam.make_current()
	_lamp = SpotLight3D.new()
	_lamp.light_color = Color(1.0, 0.96, 0.9)
	_lamp.spot_range = 5.0
	_lamp.spot_angle = 40.0
	_lamp.spot_angle_attenuation = 0.6
	_lamp.shadow_enabled = true
	_lamp.shadow_bias = 0.02
	_lamp.shadow_normal_bias = 0.4
	_lamp.shadow_blur = 1.5
	_lamp.light_size = LAMP_SIZE
	_vp.add_child(_lamp)
	_fill = OmniLight3D.new()
	_fill.light_color = Color(1.0, 0.9, 0.82)
	_fill.light_energy = FILL
	_fill.omni_range = 3.0
	_vp.add_child(_fill)


## Square the body to the lens, the arms down out of frame, the head level and into the lens, then the frame on the eyes and the
## lights on the head.
func _square(body: Node3D, skel: Skeleton3D) -> void:
	var fwd := _chest_fwd(skel)
	body.rotate_y(atan2(fwd.x, fwd.z) * -1.0)
	fwd = _chest_fwd(skel)
	body.rotate_y(atan2(fwd.x, fwd.z) * -1.0)   # twice: the body pivots off its root, not the chest
	# S395 (operator: "why they are all leaning to the left ?"): the win pose leans; the shoulders come level, then the head does.
	var across := _bone(skel, "LeftUpperArm") - _bone(skel, "RightUpperArm")
	body.rotate_z(-atan2(across.y, across.x))
	var f := _head_frame(skel)
	var eye: Vector3 = f["eye"]
	for side in [["Left", 1.0], ["Right", -1.0]]:
		var s: float = side[1]
		_arm(skel, str(side[0]), eye + Vector3(HAND_SIDE_M * s, -HAND_DROP_M, HAND_OUT_M), Vector3(0.7 * s, -1.0, -0.4))
	var hf: Vector3 = f["fw"]
	_turn_head(skel, Vector3.RIGHT, asin(clampf(hf.y, -1.0, 1.0)) + deg_to_rad(CHIN_DOWN_DEG))
	_turn_head(skel, Vector3.UP, -atan2(hf.x, hf.z))
	var hu: Vector3 = _head_frame(skel)["up"]
	_turn_head(skel, Vector3.BACK, atan2(hu.x, hu.y))
	f = _head_frame(skel)
	eye = f["eye"]
	var nose: Vector3 = f["nose"]
	var dist := FRAME_M * 0.5 / tan(deg_to_rad(FOV) * 0.5)
	var aim := Vector3(nose.x, eye.y - (0.5 - EYES_AT) * FRAME_M, eye.z)
	_cam.position = Vector3(nose.x, eye.y - 0.05, eye.z + dist)
	_cam.look_at(aim, Vector3.UP)
	_lamp.position = eye + LAMP_AT
	_lamp.look_at(eye + Vector3(0.0, -0.1, 0.0), Vector3.FORWARD)
	_fill.position = eye + Vector3(-0.7, -0.5, 1.5)


## A turn about a world axis, shared half and half between the neck and the head.
func _turn_head(skel: Skeleton3D, world_axis: Vector3, angle: float) -> void:
	var axis := (skel.global_transform.basis.inverse() * world_axis).normalized()
	for bn in ["Neck", "Head"]:
		var bi := skel.find_bone(bn)
		var gp := skel.get_bone_global_pose(bi)
		skel.set_bone_global_pose(bi, Transform3D(Basis(axis, angle * 0.5) * gp.basis, gp.origin))


## The wrist to a world point: the upper arm and the forearm turned by the shortest arc, the elbow on the pole's side.
func _arm(skel: Skeleton3D, side: String, target: Vector3, pole: Vector3) -> void:
	var up := skel.find_bone(side + "UpperArm")
	var lo := skel.find_bone(side + "LowerArm")
	var hand := skel.find_bone(side + "Hand")
	var inv := skel.global_transform.affine_inverse()
	var t := inv * target
	var s := skel.get_bone_global_pose(up).origin
	var e := skel.get_bone_global_pose(lo).origin
	var w := skel.get_bone_global_pose(hand).origin
	var a := e.distance_to(s)
	var b := w.distance_to(e)
	var dir := (t - s).normalized()
	var d := clampf(s.distance_to(t), absf(a - b) + 0.01, a + b - 0.01)
	var along := (a * a + d * d - b * b) / (2.0 * d)
	var p := inv.basis * pole
	var perp := (p - dir * p.dot(dir)).normalized()
	var e2 := s + dir * along + perp * sqrt(maxf(a * a - along * along, 0.0))
	_swing(skel, up, e - s, e2 - s)
	var e3 := skel.get_bone_global_pose(lo).origin
	_swing(skel, lo, skel.get_bone_global_pose(hand).origin - e3, t - e3)


func _swing(skel: Skeleton3D, bone: int, from: Vector3, to: Vector3) -> void:
	var axis := from.cross(to)
	if axis.length() < 1e-6:
		return
	var gp := skel.get_bone_global_pose(bone)
	skel.set_bone_global_pose(bone, Transform3D(Basis(axis.normalized(), from.angle_to(to)) * gp.basis, gp.origin))


func _bone(skel: Skeleton3D, name: String) -> Vector3:
	return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone(name))).origin


func _chest_fwd(skel: Skeleton3D) -> Vector3:
	var across := _bone(skel, "LeftUpperArm") - _bone(skel, "RightUpperArm")
	var f := Vector3(across.z, 0.0, -across.x).normalized()   # across x UP, flat
	var hands := (_bone(skel, "LeftHand") + _bone(skel, "RightHand")) * 0.5 - _bone(skel, "UpperChest")
	if Vector3(hands.x, 0.0, hands.z).dot(f) < 0.0:
		f = -f
	return f


## The head's own axes (of its basis columns, the nearest world up and the nearest the lens) and its eye and nose points
## (bake_promo._face_uv's offsets off the head bone).
func _head_frame(skel: Skeleton3D) -> Dictionary:
	var h := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head"))
	var cols := [h.basis.x.normalized(), h.basis.y.normalized(), h.basis.z.normalized()]
	var up: Vector3 = cols[0]
	var fw: Vector3 = cols[0]
	for c in cols:
		if absf(c.dot(Vector3.UP)) > absf(up.dot(Vector3.UP)):
			up = c
		if absf(c.dot(Vector3.BACK)) > absf(fw.dot(Vector3.BACK)):
			fw = c
	up = up * signf(up.dot(Vector3.UP))
	fw = fw * signf(fw.dot(Vector3.BACK))
	return {"up": up, "fw": fw, "eye": h.origin + up * 0.055 + fw * 0.085, "nose": h.origin + up * 0.02 + fw * 0.11}


## Where the eyes and the nose land in the photo, uv 0..1, as promo_face.json has them.
func _face_uv(skel: Skeleton3D) -> Dictionary:
	var f := _head_frame(skel)
	var up: Vector3 = f["up"]
	var fw: Vector3 = f["fw"]
	var side := up.cross(fw).normalized()   # + = the viewer's right
	var eye: Vector3 = f["eye"]
	var size := Vector2(_vp.size)
	var out := {}
	for k in [["eye_r", eye - side * 0.032], ["eye_l", eye + side * 0.032], ["nose", f["nose"]]]:
		var uv: Vector2 = _cam.unproject_position(k[1]) / size
		out[k[0]] = [snappedf(uv.x, 0.001), snappedf(uv.y, 0.001)]
	return out


func _save_marks() -> void:   # merge: a stems= run keeps the other bodies
	var jp := OUT.path_join("promo_face.json")
	var old = JSON.parse_string(FileAccess.get_file_as_string(jp)) if FileAccess.file_exists(jp) else {}
	var all: Dictionary = old if old is Dictionary else {}
	all.merge(_marks, true)
	var jf := FileAccess.open(jp, FileAccess.WRITE)
	jf.store_string(JSON.stringify(all, "	", true))
	jf.close()


## What a close lamp shows up in the game's materials. Lash and brow cards stay out of its shadow (they threw claw marks on the cheeks:
## a plain alpha material casts none, and the lashes share the body's mesh), the whites of the eyes come down (they glared under
## the lamp), the skin scatters less, and the body is two-sided: a sliver of folded skin by each arm showed the backdrop through it.
func _portrait_materials(body: Node3D, mesh: MeshInstance3D) -> void:
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if str(mi.name).contains("Brow"):
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for s in mesh.mesh.get_surface_count():
		var src := mesh.mesh.surface_get_material(s)
		if src == null:
			continue
		var name := src.resource_name
		if name.begins_with("MH_Eyelashes"):
			var lash := mesh.get_active_material(s).duplicate() as StandardMaterial3D
			lash.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			lash.albedo_color.a = LASH_ALPHA
			mesh.set_surface_override_material(s, lash)
		elif name == "MH_Eye":
			var eye := mesh.get_active_material(s).duplicate() as StandardMaterial3D
			eye.albedo_color = Color(0.72, 0.72, 0.72)
			mesh.set_surface_override_material(s, eye)
		elif name.begins_with("MH_Skin"):
			var skin := mesh.get_active_material(s) as ShaderMaterial
			skin.set_shader_parameter("sss_strength", SKIN_SSS)
			skin.set_shader_parameter("roughness_v", SKIN_ROUGH)
			skin.set_shader_parameter("specular_v", SKIN_SPEC)
			skin.set_shader_parameter("sheen", 0.0)
			skin.set_shader_parameter("clearcoat_v", 0.0)
			if name.begins_with("MH_Skin_Body"):
				var two := Shader.new()
				two.code = skin.shader.code.replace("render_mode sss_mode_skin;", "render_mode sss_mode_skin, cull_disabled;")
				skin.shader = two

