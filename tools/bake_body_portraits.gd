extends SceneTree
## S320 (operator C146 on the body map still: "we have real andropoid,use it"): the body map draws each boxer's OWN body,
## not a drawn figure. This bakes a front portrait of every MetaHuman boxer (one per corner colour) and where her six
## places sit on it, so the fight only loads a picture (no third 3D body at the bell).
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 720x1200 \
##       --script res://tools/bake_body_portraits.gd
## Writes assets/ui/body/<stem>_<corner>.png and <stem>.json {place: [x, y, rx, ry]} (fractions of the picture).
## Every body in Faces.CM, or only -- stems=mh_boxer_13,mh_boxer_14 (S332).

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")

const W := 720
const H := 1200
const OUT := "res://assets/ui/body"
const Faces := preload("res://scripts/rules/Faces.gd")
const PAD := 8

var _cam: Camera3D
var _img_size := Vector2(W, H)


func _initialize() -> void:
	root.size = Vector2i(W, H)
	root.transparent_bg = true
	root.msaa_3d = Viewport.MSAA_8X   # S332: the hair cards' alpha-to-coverage needs MSAA (without it her hair baked as dots)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_CLEAR_COLOR
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.55, 0.6)
	env.environment.ambient_light_energy = 0.9
	root.add_child(env)
	var key := DirectionalLight3D.new()
	key.light_energy = 1.4
	root.add_child(key)
	key.look_at_from_position(Vector3(1.5, 3.0, 4.0), Vector3(0, 1.0, 0), Vector3.UP)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 2.0
	root.add_child(cam)
	_cam = cam
	await process_frame
	var stems: Array = Faces.CM.keys()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = Array(a.trim_prefix("stems=").split(","))
	for stem in stems:
		for corner in ["red", "blue"]:
			var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % stem)
			root.add_child(body)
			MH.colour_trunks(body, Stage.TRUNKS[corner], Stage.CLOTH_ROUGHNESS)
			Kit.colour_vest(body, Stage.VESTS[corner], Stage.CLOTH_ROUGHNESS)
			Kit.cloth_normals(body)
			Kit.dress(body, "res://assets/models/metahuman/%s.glb" % stem, "boxing")
			var g := _geometry(body)
			var fwd: float = g["fwd"]
			cam.position = Vector3(0, g["mid_y"], 6.0 * fwd)
			cam.look_at(Vector3(0, g["mid_y"], 0), Vector3.UP)
			cam.size = float(g["tall"]) * 1.06
			for i in 8:
				await process_frame
			await RenderingServer.frame_post_draw
			var img := root.get_texture().get_image()
			_img_size = Vector2(img.get_width(), img.get_height())
			var crop := _alpha_box(img)
			# Head to just under the knees: the six places are all above the waist, so the torso gets the room (S320).
			var knee_px: int = int(_px(Vector3(0, g["knee_y"], 0)).y) + PAD * 4
			crop.size.y = mini(crop.size.y, knee_px - crop.position.y)
			img = img.get_region(crop)
			img.save_png(ProjectSettings.globalize_path(OUT.path_join("%s_%s.png" % [stem, corner])))
			if corner == "red":
				var places := _places(cam, g, crop)
				places["track"] = _track(body, crop)   # S323 the body view: BodyLoad's parts on her own body
				var f := FileAccess.open(OUT.path_join(stem + ".json"), FileAccess.WRITE)
				f.store_string(JSON.stringify(places, "  "))
				f.close()
				print("PORTRAIT %s %dx%d %s" % [stem, crop.size.x, crop.size.y, JSON.stringify(places)])
			body.queue_free()
			await process_frame
	quit(0)


## Fighter-space points of her head, eyes, nose and ribs (rest pose, the meshes' own vertices).
func _geometry(body: Node3D) -> Dictionary:
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var neck_y: float = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Neck"))).origin.y
	var chest: Vector3 = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Chest"))).origin
	var upper: Vector3 = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("UpperChest"))).origin
	var knee_y: float = (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("LeftLowerLeg"))).origin.y
	var head := AABB()
	var head_set := false
	var eyes := [[], []]   # by side of x
	var lo := INF
	var hi := -INF
	var skin_head: Array = []
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var to_body := _to(mi, body)
		for s in mi.mesh.get_surface_count():
			var mat: Material = mi.mesh.surface_get_material(s)
			var mname: String = mat.resource_name if mat != null else ""
			var verts: PackedVector3Array = mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]
			var skin := mname.begins_with("MH_Skin")
			var eye := mname.begins_with("MH_Eye") and not mname.begins_with("MH_Eyelashes")
			for v in verts:
				var p: Vector3 = to_body * v
				lo = minf(lo, p.y)
				hi = maxf(hi, p.y)
				if eye:
					eyes[0 if p.x < 0.0 else 1].append(p)
				elif skin and p.y > neck_y + 0.04:
					skin_head.append(p)
					if head_set:
						head = head.expand(p)
					else:
						head = AABB(p, Vector3.ZERO)
						head_set = true
	var e0 := _mean(eyes[0])
	var e1 := _mean(eyes[1])
	var hc := head.get_center()
	var fwd := signf((e0 + e1).z * 0.5 - hc.z)
	# The nose tip: the most forward head vertex between the eyes and the mouth.
	var eye_y := (e0.y + e1.y) * 0.5
	var nose := Vector3((e0.x + e1.x) * 0.5, eye_y - 0.035, hc.z)
	var best := -INF
	for p in skin_head:
		if absf(p.x - nose.x) < 0.015 and p.y < eye_y - 0.01 and p.y > eye_y - 0.07 and p.z * fwd > best:
			best = p.z * fwd
			nose = p
	var rib_y: float = lerpf(chest.y, upper.y, 0.3)
	return {"fwd": fwd if fwd != 0.0 else 1.0, "mid_y": (lo + hi) * 0.5, "tall": hi - lo, "head": head, "eyes": [e0, e1],
		"nose": nose, "rib_y": rib_y, "knee_y": knee_y, "rib_x": 0.075, "rib_z": chest.z + 0.12 * fwd}


func _places(cam: Camera3D, g: Dictionary, crop: Rect2i) -> Dictionary:
	var out := {}
	var head: AABB = g["head"]
	var hc := head.get_center()
	var top := _px(Vector3(hc.x, head.end.y, hc.z))
	var bot := _px(Vector3(hc.x, head.position.y, hc.z))
	var lft := _px(Vector3(head.position.x, hc.y, hc.z))
	var rgt := _px(Vector3(head.end.x, hc.y, hc.z))
	out["head"] = _frac((top + bot) * 0.5, absf(rgt.x - lft.x) * 0.5, absf(bot.y - top.y) * 0.5, crop)
	# Front view: the boxer's LEFT is on the viewer's RIGHT (BodyFigure's rule) - the eye that projects further right.
	var s0 := _px(g["eyes"][0])
	var s1 := _px(g["eyes"][1])
	var px_m: float = _img_size.y / cam.size
	var er := 0.022 * px_m
	out["left_eye"] = _frac(s0 if s0.x > s1.x else s1, er, er, crop)
	out["right_eye"] = _frac(s1 if s0.x > s1.x else s0, er, er, crop)
	out["nose"] = _frac(_px(g["nose"]), 0.016 * px_m, 0.02 * px_m, crop)
	var ra := _px(Vector3(g["rib_x"], g["rib_y"], g["rib_z"]))
	var rb := _px(Vector3(-float(g["rib_x"]), g["rib_y"], g["rib_z"]))
	out["left_ribs"] = _frac(ra if ra.x > rb.x else rb, 0.055 * px_m, 0.075 * px_m, crop)
	out["right_ribs"] = _frac(rb if ra.x > rb.x else ra, 0.055 * px_m, 0.075 * px_m, crop)
	return out


## S323 "the body is the track" step 3: where BodyLoad's parts sit on the portrait, as thick strokes - {place: {"pts":
## [[x, y], ...], "w": width}} in fractions of the picture (width of the picture's width). place = BodyTrack.body_place:
## left/right shoulder and arm (HER left/right), core, legs_left / legs_right (both drawn in the legs' colour).
func _track(body: Node3D, crop: Rect2i) -> Dictionary:
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var at := func(bone: String) -> Vector3: return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone))).origin
	var out := {}
	var stroke := func(pts: Array, w_m: float) -> Dictionary:
		var ppm: float = _img_size.y / _cam.size
		var fr: Array = []
		for q in pts:
			var f := _frac(_px(q), 0.0, 0.0, crop)
			fr.append([f[0], f[1]])
		return {"pts": fr, "w": snappedf(w_m * ppm / float(crop.size.x), 0.0001)}
	for side in ["Left", "Right"]:
		var lr: String = str(side).to_lower()
		var up: Vector3 = at.call(str(side) + "UpperArm")
		var lo: Vector3 = at.call(side + "LowerArm")
		var hd: Vector3 = at.call(side + "Hand")
		var cl: Vector3 = at.call(side + "Shoulder")
		out[lr + "_shoulder"] = stroke.call([cl.lerp(up, 0.45), up.lerp(lo, 0.22)], 0.10)
		out[lr + "_arm"] = stroke.call([up.lerp(lo, 0.38), lo, lo.lerp(hd, 0.8)], 0.07)
		var th: Vector3 = at.call(side + "UpperLeg")
		var kn: Vector3 = at.call(side + "LowerLeg")
		out["legs_" + lr] = stroke.call([th.lerp(kn, 0.12), th.lerp(kn, 0.92)], 0.12)
	var hips: Vector3 = at.call("Hips")
	var chest: Vector3 = at.call("Chest")
	out["core"] = stroke.call([hips.lerp(chest, 0.25), hips.lerp(chest, 0.95)], 0.17)
	return out


## The picture's pixel of a world point (the ortho camera keeps the height: cam.size metres = the image height). The
## viewport's own unproject_position works in the stretched canvas space, which is not the saved image (S320: 12 % off).
func _px(p: Vector3) -> Vector2:
	var l: Vector3 = _cam.global_transform.affine_inverse() * p
	var ppm: float = _img_size.y / _cam.size
	return Vector2(_img_size.x * 0.5 + l.x * ppm, _img_size.y * 0.5 - l.y * ppm)


func _frac(p: Vector2, rx: float, ry: float, crop: Rect2i) -> Array:
	var w := float(crop.size.x)
	var h := float(crop.size.y)
	return [snappedf((p.x - crop.position.x) / w, 0.0001), snappedf((p.y - crop.position.y) / h, 0.0001),
		snappedf(rx / w, 0.0001), snappedf(ry / h, 0.0001)]


func _alpha_box(img: Image) -> Rect2i:
	var r := img.get_used_rect()
	r = r.grow(PAD)
	return r.intersection(Rect2i(0, 0, img.get_width(), img.get_height()))


func _mean(a: Array) -> Vector3:
	var s := Vector3.ZERO
	for p in a:
		s += p
	return s / maxf(1.0, a.size())


func _to(node: Node, root_node: Node) -> Transform3D:
	var t := Transform3D.IDENTITY
	var n: Node = node
	while n != root_node and n != null:
		if n is Node3D:
			t = (n as Node3D).transform * t
		n = n.get_parent()
	return t
