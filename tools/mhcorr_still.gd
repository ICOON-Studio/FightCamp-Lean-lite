extends SceneTree
## MHCORR2 (S535) stills and numbers for the body correctives: two v2 boxers on the game's broadcast camera in the
## guard and mid-punch (both men head to feet, or the still is refused), torso close-ups, and the spine chain of the
## guard against the rest (the owner: "the stomach goes inside weirdly").
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/mhcorr_still.gd -- <out_dir> tag=after [red=11 blue=13]
##   nomhcorr        the bodies without the correctives (the before arm; MetaHumanCorrectiveRBF reads it)
##   only=close      the guard and the close-ups, no punches
##   flatnormal      the skin without its normal maps (is a dent the lighting or the mesh?)
##   spinerest=<f>   the trunk's bones eased f of the way back to rest (is a dent the spine's bend?)
## Headless it prints the numbers and saves nothing.

const W := 1920
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const TRUNK := ["Spine", "spine_02", "Chest", "spine_04", "UpperChest"]

var out_dir := "user://mhcorr"
var tag := "after"
var stage: Node3D
var pictures := true
var drawn: Array = [{}, {}]   # per boxer: bone index -> global pose as drawn


class SpineEase extends SkeletonModifier3D:
	var f := 0.0
	func _process_modification() -> void:
		var sk := get_skeleton()
		for n in ["Spine", "spine_02", "Chest", "spine_04", "UpperChest"]:
			var b := sk.find_bone(n)
			if b >= 0:
				sk.set_bone_pose_rotation(b, sk.get_bone_pose_rotation(b).slerp(sk.get_bone_rest(b).basis.get_rotation_quaternion(), f))


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	tag = _arg("tag", "after")
	pictures = DisplayServer.get_name() != "headless"
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	Player2.force = true
	FightClips.untouched = true
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("red", "11"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("blue", "13"), "corner": "blue"})
	if stage.v2 == null:
		print("MHCORR_STILL FAIL the v2 player was not built")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		var d: Dictionary = drawn[i]
		sk.skeleton_updated.connect(func() -> void:
			for b in sk.get_bone_count():
				d[b] = sk.get_bone_global_pose(b))
		var amount := float(_arg("spinerest", "0"))
		if amount > 0.0:
			var m := SpineEase.new()
			m.name = "SpineEase"
			m.f = amount
			sk.add_child(m)
			var js: Node = stage.boxers[i].get("js")
			sk.move_child(m, (js.get_index() + 1) if js != null else 0)
			Player2.KEEP.append("SpineEase")
		var mods: Array = sk.get_children().filter(func(x): return x is SkeletonModifier3D and (x as SkeletonModifier3D).active).map(func(x): return str(x.name))
		print("MHCORR_STILL boxer %d layers on: %s" % [i, ", ".join(PackedStringArray(mods))])
		var corr: Node = sk.get_node_or_null("MetaHumanCorrectiveRBF")
		print("MHCORR_STILL boxer %d correctives: %s" % [i, str(corr.get("table_path")).get_file() if corr != null else "none"])
		if args.has("flatnormal"):
			for mi in (stage.boxers[i]["node"] as Node).find_children("*", "MeshInstance3D", true, false):
				for s in (mi as MeshInstance3D).mesh.get_surface_count():
					var mat := (mi as MeshInstance3D).get_surface_override_material(s) as ShaderMaterial
					if mat != null:
						mat.set_shader_parameter("normal_tex", null)
						mat.set_shader_parameter("micro_strength", 0.0)
	for f in 90:
		await process_frame
	_freeze(0)
	_freeze(1)
	for f in 6:
		await process_frame
	_rig_facts()
	_spine("guard")
	await _broadcast("guard")
	await _close()
	if _arg("only", "") != "close":
		for shot in [[0, "jab"], [1, "cross"], [0, "lead_hook"]]:
			var who := int(shot[0])
			var clip := _punch_clip(who, str(shot[1]))
			if clip == "":
				print("MHCORR_STILL no %s take on boxer %d" % [str(shot[1]), who])
				continue
			var ap: AnimationPlayer = stage.boxers[who]["ap"]
			stage.v2._play(who, clip, 0.0, "punch", true)
			var cs := float(stage.v2.db["rows"][clip].get("contact_s", 0.3))
			for f in 240:
				await process_frame
				if str(ap.current_animation) != clip or ap.current_animation_position >= cs - 0.008:
					break
			_freeze(who)
			for f in 14:
				await process_frame
			_spine("%s %s (%s)" % ["red" if who == 0 else "blue", str(shot[1]), clip])
			await _broadcast("%s_%s" % ["red" if who == 0 else "blue", str(shot[1])])
			ap.speed_scale = 1.0
			stage.v2.guard(who)
			for f in 50:
				await process_frame
			_freeze(who)
	print("MHCORR_STILL done")
	quit(0)


func _freeze(i: int) -> void:
	(stage.boxers[i]["ap"] as AnimationPlayer).speed_scale = 0.0


## The first played punch take of that family this body has (else any take of the family).
func _punch_clip(i: int, family: String) -> String:
	var ap: AnimationPlayer = stage.boxers[i]["ap"]
	var rows: Dictionary = stage.v2.db.get("rows", {})
	var spare := ""
	for n in rows:
		var r: Dictionary = rows[n]
		if str(r.get("kind", "")) != "punch" or str(r.get("family", "")) != family or not ap.has_animation(str(n)) or not (r.get("drop", []) as Array).is_empty():
			continue
		if bool(r.get("played", false)):
			return str(n)
		if spare == "":
			spare = str(n)
	return spare


func _world(i: int, bone: String, up: float = 0.0) -> Vector3:
	var sk: Skeleton3D = stage.boxers[i]["skel"]
	var b := sk.find_bone(bone)
	var g: Transform3D = drawn[i].get(b, sk.get_bone_global_rest(b)) if b >= 0 else Transform3D.IDENTITY
	return sk.global_transform * g.origin + Vector3.UP * up


## A still from the game's broadcast camera, saved only with both men in the picture from head to feet.
func _broadcast(name: String) -> void:
	if not pictures:
		return
	var cam: Camera3D = stage.camera
	cam.make_current()
	for f in 6:
		await process_frame
	var bad: Array = []
	for i in 2:
		for p in [["Head", 0.14], ["LeftToes", -0.06], ["RightToes", -0.06], ["LeftHand", 0.0], ["RightHand", 0.0]]:
			var w := _world(i, str(p[0]), float(p[1]))
			var s := cam.unproject_position(w)
			if cam.is_position_behind(w) or s.x < 8.0 or s.x > W - 8.0 or s.y < 8.0 or s.y > H - 8.0:
				bad.append("%s %s at %s" % ["red" if i == 0 else "blue", str(p[0]), str(s.round())])
	if not bad.is_empty():
		print("STILL_FRAMING FAIL %s: %s" % [name, "; ".join(PackedStringArray(bad))])
		return
	await _save("%s_%s" % [tag, name])
	print("STILL_FRAMING ok %s (both men head to feet, shot %s)" % [name, str(cam.get("shot_name"))])


## Torso close-ups of each man in his guard (the other man hidden): a look at the chest and the stomach, not a game shot.
func _close() -> void:
	if not pictures:
		return
	var cam := Camera3D.new()
	cam.fov = 28.0
	root.add_child(cam)
	for i in 2:
		var node: Node3D = stage.boxers[i]["node"]
		var other: Node3D = stage.boxers[1 - i]["node"]
		var fwd := node.global_transform.basis.z.normalized()
		var side := fwd.cross(Vector3.UP).normalized()
		var mid := _world(i, "Chest")
		other.visible = false
		var og: Variant = stage.boxers[1 - i].get("gloves")
		if og is Node3D:
			(og as Node3D).visible = false
		for view in [["front", fwd * 2.3 + side * 0.35], ["three", fwd * 1.8 + side * 1.5], ["side", side * 2.4 + fwd * 0.2], ["sideb", side * -2.4 + fwd * 0.2]]:
			cam.global_position = mid + (view[1] as Vector3) + Vector3(0.0, 0.10, 0.0)
			cam.look_at(mid, Vector3.UP)
			cam.make_current()
			for f in 4:
				await process_frame
			await _save("%s_close_%s_%s" % [tag, "red" if i == 0 else "blue", str(view[0])])
		other.visible = true
		if og is Node3D:
			(og as Node3D).visible = true
	(stage.camera as Camera3D).make_current()
	cam.queue_free()
	for f in 4:
		await process_frame


func _save(name: String) -> void:
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)


## What the rig has around the trunk: bones under the spine that no clip moves, and blend shapes.
func _rig_facts() -> void:
	var sk: Skeleton3D = stage.boxers[0]["skel"]
	var extra: Array = []
	for b in sk.get_bone_count():
		var n := sk.get_bone_name(b)
		if (n.contains("spine") or n.contains("pelvis") or n.contains("stomach") or n.contains("belly") or n.contains("abdomen")) and not TRUNK.has(n):
			extra.append(n)
	print("TRUNK helper bones on the rig: %s" % (", ".join(PackedStringArray(extra)) if not extra.is_empty() else "none"))
	for mi in (stage.boxers[0]["node"] as Node).find_children("*", "MeshInstance3D", true, false):
		var m := mi as MeshInstance3D
		if m.mesh != null and (m.mesh.get_blend_shape_count() > 0 or str(m.name).contains("Body")):
			print("TRUNK mesh %s: %d blend shapes, %d surfaces" % [str(m.name), m.mesh.get_blend_shape_count(), m.mesh.get_surface_count()])


## The trunk as drawn against the rest: each bone's turn off its rest, the whole bend hips -> upper chest, and how
## much the front of the trunk has shortened (hips to upper chest, straight line).
func _spine(label: String) -> void:
	for i in 2:
		var sk: Skeleton3D = stage.boxers[i]["skel"]
		var parts: Array = []
		for n in ["Hips"] + TRUNK + ["Neck", "Head"]:
			var b := sk.find_bone(str(n))
			if b < 0 or not (drawn[i] as Dictionary).has(b):
				continue
			var par := sk.get_bone_parent(b)
			var local: Transform3D = (drawn[i][par] as Transform3D).affine_inverse() * (drawn[i][b] as Transform3D) if par >= 0 else (drawn[i][b] as Transform3D)
			var d: Quaternion = (sk.get_bone_rest(b).basis.get_rotation_quaternion().inverse() * local.basis.get_rotation_quaternion()).normalized()
			var e := d.get_euler() * (180.0 / PI)
			parts.append("%s %.0f (x %.0f y %.0f z %.0f)" % [str(n), rad_to_deg(d.get_angle()), e.x, e.y, e.z])
		var hips := sk.find_bone("Hips")
		var top := sk.find_bone("UpperChest")
		var rest_v: Vector3 = sk.get_bone_global_rest(hips).basis.inverse() * (sk.get_bone_global_rest(top).origin - sk.get_bone_global_rest(hips).origin)
		var pose_v: Vector3 = (drawn[i][hips] as Transform3D).basis.inverse() * ((drawn[i][top] as Transform3D).origin - (drawn[i][hips] as Transform3D).origin)
		var rel: Quaternion = ((sk.get_bone_global_rest(hips).basis.inverse() * sk.get_bone_global_rest(top).basis).get_rotation_quaternion().inverse() * ((drawn[i][hips] as Transform3D).basis.inverse() * (drawn[i][top] as Transform3D).basis).get_rotation_quaternion()).normalized()
		print("SPINE %s | %s (mh_boxer_%s) | each bone's turn off rest, deg: %s" % [label, "red" if i == 0 else "blue", _arg("red" if i == 0 else "blue", "11" if i == 0 else "13"), "; ".join(PackedStringArray(parts))])
		print("SPINE %s | %s | hips to upper chest: rest %.1f cm, drawn %.1f cm; that line leans %.0f deg off its rest; the upper chest is turned %.0f deg against the hips" % [label, "red" if i == 0 else "blue",
			rest_v.length() * 100.0, pose_v.length() * 100.0, rad_to_deg(rest_v.angle_to(pose_v)), rad_to_deg(rel.get_angle())])
