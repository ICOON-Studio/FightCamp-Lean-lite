extends SceneTree
## S380 (operator on the camp panel's portrait: "THIS DOESNT LOOK LIKE A PLAYER PROFILE PICTURE, THE PICTURE NEED TO MAKE
## THE FIGHTER UNIQUE D INDETIFIABLE, make it abig bigger maybe and make the fighters pose like ufc fighters pose"): each
## boxer's profile picture is a fight-card promo shot - a dark studio, a key light and two coloured rim lights, the
## body square to the lens from the waist up, the face open above the gloves and the eyes into the camera (a
## head is pitched up to the lens). Same body and kit as the fight (FighterKit); S380 second pass: no gloves.
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 720x900 \
##       --audio-driver Dummy --script res://tools/bake_promo.gd [-- stems=mh_boxer_01,mh_boxer_10] [poses=clip@s,...]
## Writes assets/ui/face/<stem>.jpg (W x H, the file HomeBoard.portrait shows); with poses= several, test shots go to
## E:/FightCamp/tmp/promo_<stem>_<clip>_<s>.jpg instead.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")

const W := 720
const H := 900
const OUT := "res://assets/ui/face"
const MH_DIR := "res://assets/models/metahuman"
const FOV := 24.0            # degrees, vertical: a portrait lens, waist to just over the head
const BELT_M := 0.12         # the frame's bottom: just over the hips (the belt line)
const TOP_M := 0.30          # the frame's top: over the head bone (the crown + a little air)
const LENS_H := 0.10         # the lens a little over the frame's middle: a touch down on the chest, level with the eyes
const CHIN_DEG := -24.0      # pitch added to the clip about the lens axis (minus = chin up)
const POSE := ["af_idle_foldarms", 1.0]   # arms folded, bare hands: the fight-poster stance; the guard hid the face
const BG := Color(0.035, 0.04, 0.05)
const RIM_A := Color(0.95, 0.25, 0.2)    # warm rim, the fighter's left
const RIM_B := Color(0.25, 0.55, 1.0)    # cool rim, the fighter's right

var _cam: Camera3D
var _chin := CHIN_DEG
var _bg := BG
var _plain := false   # S387 plain=1 (operator: "use normal lightning not red and blue"): soft white rims, neutral fill
var _out := OUT   # S387 studio=<res dir> bg=r,g,b: the lit-backdrop set PromoShot shows (dark skin vanished on the dark studio)
var _faces := {}   # stem -> its eyes and nose in the photo (promo_face.json)


func _initialize() -> void:
	root.size = Vector2i(W, H)
	root.msaa_3d = Viewport.MSAA_8X   # hair cards (S332)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	var stems: Array = []
	var poses: Array = [POSE]
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = Array(a.trim_prefix("stems=").split(","))
		if a.begins_with("studio="):
			_out = a.trim_prefix("studio=")
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_out))
		if a == "plain=1":
			_plain = true
		if a.begins_with("bg="):
			var v := a.trim_prefix("bg=").split(",")
			_bg = Color(float(v[0]), float(v[1]), float(v[2]))
		if a.begins_with("chin="):
			_chin = float(a.trim_prefix("chin="))
		if a.begins_with("poses="):
			poses = []
			for q in a.trim_prefix("poses=").split(","):
				poses.append([q.get_slice("@", 0), float(q.get_slice("@", 1))])
	if stems.is_empty():
		for f in DirAccess.get_files_at(MH_DIR):
			if str(f).begins_with("mh_boxer_") and str(f).ends_with(".glb"):
				stems.append(str(f).get_basename())
		stems.sort()
	_studio()
	var n := 0
	for stem in stems:
		var glb := MH_DIR.path_join(str(stem) + ".glb")
		var body := MH.load_fighter(glb)
		if body == null:
			push_error("cannot load " + glb)
			continue
		Kit.colour_vest(body, Stage.VESTS["red"], Stage.CLOTH_ROUGHNESS)   # as BoxerBuild dresses the red corner
		Kit.cloth_normals(body)
		Kit.dress(body, glb, "boxing")
		# S380 operator: "make them pose without gloves on" - bare hands, arms folded (no Gloves node)
		root.add_child(body)
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		FightClips.load_into(ap, skel)
		for pose in poses:
			ap.play(str(pose[0]))
			ap.seek(float(pose[1]), true)
			ap.pause()
			await process_frame
			_square(body, skel)
			var look: Node = _look(skel) if OS.get_cmdline_user_args().has("look") else Node.new()
			for i in 6:
				await process_frame
			await RenderingServer.frame_post_draw
			var img := _photo(root.get_texture().get_image())
			var path := ProjectSettings.globalize_path(_out.path_join(str(stem) + ".jpg"))
			if poses.size() > 1 or OS.get_cmdline_user_args().has("test"):
				path = "E:/FightCamp/tmp/promo_%s_%s_%.1f.jpg" % [stem, pose[0], pose[1]]
			img.save_jpg(path, 0.92)
			print("PROMO %s -> %s" % [stem, path])
			_faces[stem] = _face_uv(skel)
			print("PROMO_FACE %s %s" % [stem, JSON.stringify(_faces[stem])])
			n += 1
			look.queue_free()
		body.queue_free()
		await process_frame
	if _out == OUT and not (poses.size() > 1 or OS.get_cmdline_user_args().has("test")):   # merge: a stems= run keeps the other bodies
		var jp := OUT.path_join("promo_face.json")
		var old = JSON.parse_string(FileAccess.get_file_as_string(jp)) if FileAccess.file_exists(jp) else {}
		var all: Dictionary = old if old is Dictionary else {}
		all.merge(_faces, true)
		var jf := FileAccess.open(jp, FileAccess.WRITE)
		jf.store_string(JSON.stringify(all, "	", true))
		jf.close()
	print("PROMOS baked=%d" % n)
	quit(0 if n > 0 else 1)


## The dark studio: background colour, a soft key from the front-left, a fill, two coloured rims behind.
func _studio() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = _bg
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.6, 0.6, 0.6) if _plain else Color(0.5, 0.55, 0.6)
	e.ambient_light_energy = 0.55 if _plain else 0.25
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	root.add_child(env)
	_cam = Camera3D.new()
	_cam.fov = FOV
	root.add_child(_cam)
	_cam.make_current()
	for l in [[Vector3(-1.4, 2.3, 2.2), Color(1.0, 0.95, 0.9), 2.6, 7.0], [Vector3(1.6, 1.5, 2.4), Color(0.85, 0.9, 1.0), 0.8, 7.0],
			[Vector3(-1.5, 1.9, -1.2), RIM_A, 5.0, 4.0], [Vector3(1.5, 1.9, -1.2), RIM_B, 5.0, 4.0]]:
		var o := OmniLight3D.new()
		o.position = l[0]
		o.light_color = Color.WHITE if _plain else l[1]
		o.light_energy = minf(float(l[2]), 1.2) if _plain and l[0].z < 0.0 else float(l[2])
		o.omni_range = l[3]
		o.shadow_enabled = l == [Vector3(-1.4, 2.3, 2.2), Color(1.0, 0.95, 0.9), 2.6, 7.0]
		root.add_child(o)


## Turn the body so the chest faces the lens (+Z): forward = square to the shoulder line, on the side the gloves are.
func _square(body: Node3D, skel: Skeleton3D) -> void:
	var fwd := _chest_fwd(skel)
	body.rotate_y(atan2(fwd.x, fwd.z) * -1.0)
	fwd = _chest_fwd(skel)
	body.rotate_y(atan2(fwd.x, fwd.z) * -1.0)   # twice: the body pivots off its root, not the chest
	# the chin up a little: the idle clip looks down at the floor, a promo shot looks into the lens
	# (a pitch about the lens's horizontal axis - world X, the body now faces +Z - half in the neck, half in the head)
	var axis := (skel.global_transform.basis.inverse() * Vector3.RIGHT).normalized()
	for bn in ["Neck", "Head"]:
		var bi := skel.find_bone(bn)
		var gp := skel.get_bone_global_pose(bi)
		skel.set_bone_global_pose(bi, Transform3D(Basis(axis, deg_to_rad(_chin) * 0.5) * gp.basis, gp.origin))
	# the frame: the belt (hips + BELT_M) to over the head (head bone + TOP_M), the lens level with its middle
	var head := _bone(skel, "Head")
	var hips := _bone(skel, "Hips")
	var lo := hips.y + BELT_M
	var hi := head.y + TOP_M
	var mid := Vector3(head.x, (lo + hi) * 0.5, head.z)
	var dist := (hi - lo) * 0.5 / tan(deg_to_rad(FOV) * 0.5)
	_cam.position = mid + Vector3(0.0, LENS_H, 0.0) + Vector3.BACK * dist
	_cam.look_at(mid, Vector3.UP)


func _bone(skel: Skeleton3D, name: String) -> Vector3:
	return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone(name))).origin


func _chest_fwd(skel: Skeleton3D) -> Vector3:
	var across := _bone(skel, "LeftUpperArm") - _bone(skel, "RightUpperArm")
	var f := Vector3(across.z, 0.0, -across.x).normalized()   # across x UP, flat
	var hands := (_bone(skel, "LeftHand") + _bone(skel, "RightHand")) * 0.5 - _bone(skel, "UpperChest")
	if Vector3(hands.x, 0.0, hands.z).dot(f) < 0.0:
		f = -f
	return f


## The eyes into the lens: head (and a little neck) aimed at the camera.
func _look(skel: Skeleton3D) -> Node:
	var m := LookAtModifier3D.new()
	m.bone_name = "Head"
	m.target_node = _cam.get_path()
	m.forward_axis = SkeletonModifier3D.BONE_AXIS_PLUS_Z
	m.use_angle_limitation = true
	m.symmetry_limitation = true
	m.primary_limit_angle = deg_to_rad(70.0)
	m.secondary_limit_angle = deg_to_rad(50.0)
	m.duration = 0.0
	skel.add_child(m)
	return m


## Where the eyes and the nose land in the photo (uv 0..1): points off the head bone (MetaHuman: the eyes ~0.09 m over and
## in front of it, 0.032 m each side; the nose tip lower and further out), through the lens and the _photo crop.
func _face_uv(skel: Skeleton3D) -> Dictionary:
	var h := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head"))
	var vs := Vector2(root.get_visible_rect().size)
	var cw := minf(vs.x, vs.y * float(W) / H)
	var ch := minf(vs.y, cw * float(H) / W)
	var off := (vs - Vector2(cw, ch)) * 0.5
	var out := {}
	# the head's own up / forward / side: of its basis columns, the one nearest world up and the one nearest the lens (+Z)
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
	var side := up.cross(fw).normalized()   # + = the viewer's right
	for k in [["eye_r", Vector3(-0.032, 0.055, 0.085)], ["eye_l", Vector3(0.032, 0.055, 0.085)], ["nose", Vector3(0.0, 0.02, 0.11)]]:
		var o: Vector3 = k[1]
		var w: Vector3 = h.origin + side * o.x + up * o.y + fw * o.z
		var px := _cam.unproject_position(w) - off
		out[k[0]] = [snappedf(px.x / cw, 0.001), snappedf(px.y / ch, 0.001)]
	return out


func _photo(img: Image) -> Image:
	var w := img.get_width()
	var h := img.get_height()
	var cw := mini(w, int(h * float(W) / H))
	var ch := mini(h, int(cw * float(H) / W))
	var out := img.get_region(Rect2i((w - cw) / 2, (h - ch) / 2, cw, ch))
	out.resize(W, H, Image.INTERPOLATE_LANCZOS)
	return out
