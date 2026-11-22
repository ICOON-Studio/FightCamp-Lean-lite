extends SceneTree
## BOUGHTCLIP1 (S537, owner C468: "They both look weird show me the bought clip"): the cross three times on ONE FIXED
## side camera (it never moves; the same in all three), 30 pictures a second, half a second before the punch to half a
## second after the take:
##   game    a LANDED plain cross of a planned exchange, as the v2 player shows it (the other man in range)
##   ours    the same take on our body and nothing else: every pose layer off (the skin's twist and corrective joints
##           stay: they move no limb), standing where the game's punch began; the other man hidden
##   bought  the vendor's file itself (read at run time, nothing imported) on ITS skeleton and ITS mannequin (Motus Man),
##           sized to our leg and stood on the same spot
##   python tools/hidden_desktop.py run --timeout=600 --log=<file> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 60 --script res://tools/boughtclip_film.gd -- <out_dir> [red=02 blue=01] [seed=7]
## Pictures: <pass>_NNN.jpg and <pass>_contact.png; tools/boughtclip_trio.py puts the three side by side.

const W := 960
const H := 1080
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const KR := preload("res://tools/kneeroot_lib.gd")
const FBX := "E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/Box1_M3_Right_Cross.fbx"
const TAKE := "pro_right_cross"
const SKIN_LAYERS := ["MetaHumanTwist", "MetaHumanCorrectiveRBF"]
const LEAD := 30              # frames (60 a second) shown before the punch starts
const TAIL := 30

var out_dir := "user://boughtclip"
var stage: Node3D
var cam: Camera3D


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	Player2.force = true
	FightClips.untouched = true
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("red", "02"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("blue", "01"), "corner": "blue"})
	if stage.v2 == null:
		print("BOUGHT_FILM FAIL the v2 player was not built")
		quit(1)
		return
	cam = Camera3D.new()
	cam.fov = 40.0
	root.add_child(cam)
	cam.make_current()
	for f in 90:
		await process_frame
	var p2: Node = stage.v2
	var blue: Node3D = stage.boxers[1]["node"]
	var red: Node3D = stage.boxers[0]["node"]
	var ap: AnimationPlayer = stage.boxers[1]["ap"]
	var sk: Skeleton3D = stage.boxers[1]["skel"]
	var cs := float(p2.db["rows"][TAKE].get("contact_s", 0.3))
	var length: float = ap.get_animation(TAKE).length
	var total := LEAD + int(length * 60.0) + TAIL
	# ---- the game: the first landed plain cross blue throws
	var ev := {}
	var sd := int(_arg("seed", "7"))
	for attempt in 40:
		var round := {"n": 1, "won": attempt % 2 == 1, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		p2.queue(RS.build(round, ["Boxer", "Slugger"][attempt % 2], ["Slugger", "Boxer"][(attempt / 2) % 2], 30.0, sd + attempt)["beats"], 0.0, 30.0)
		var want: Array = (p2.plan["tracks"]["b"] as Array).filter(func(e): return str(e["kind"]) == "punch" and str(e["clip"]) == TAKE and str(e.get("result", "")) == "lands")
		if not want.is_empty():
			ev = want[0]
			print("BOUGHT_FILM seed %d: blue lands %s, starts %.2f s, contact %.2f s" % [sd + attempt, TAKE, float(ev["t"]), float(ev["contact_t"])])
			break
	if ev.is_empty():
		print("BOUGHT_FILM FAIL no landed %s in 40 plans" % TAKE)
		quit(1)
		return
	var t := 0.0
	var f0 := int(round(float(ev["t"]) * 60.0)) - LEAD
	var spot := {}
	var shot := false
	for f in f0 + total:
		p2.clock(t, true)
		await process_frame
		t += 1.0 / 60.0
		if f == f0:
			# the one camera of the whole film: side-on to the line between the two men, on the puncher
			var line := Vector3(red.position.x - blue.position.x, 0.0, red.position.z - blue.position.z).normalized()
			var side := line.cross(Vector3.UP)
			if side.x > 0.0:
				side = -side
			var look := blue.position + line * 0.5 + Vector3.UP * 0.95
			cam.global_position = look + side * 3.7 + Vector3.UP * 0.05
			cam.look_at(look, Vector3.UP)
		if f == f0 + LEAD:
			spot = {"blue": blue.position, "red": red.position, "hips": sk.global_transform * sk.get_bone_global_pose(sk.find_bone("Hips")).origin,
				"fwd": Vector3(blue.global_transform.basis.z.x, 0.0, blue.global_transform.basis.z.z).normalized()}
		if f < f0:
			continue
		if not shot and str(ap.current_animation) == TAKE and ap.current_animation_position >= cs - 0.008:
			shot = true
			await _png("game_contact")
		if (f - f0) % 2 == 0:
			await _jpg("game_%03d" % ((f - f0) / 2))
	p2.clock(t, false)
	if spot.is_empty():
		print("BOUGHT_FILM FAIL the game pass never reached the punch")
		quit(1)
		return
	print("BOUGHT_FILM game pass done, contact still %s" % str(shot))
	# ---- ours: the take alone on our body, from the spot the game's punch began
	red.visible = false
	for i in 2:
		p2._home[i] = spot["blue" if i == 1 else "red"]
		p2.guard(i)
	for f in 60:
		p2._home[1] = spot["blue"]
		p2._home[0] = spot["red"]
		await process_frame
	var off: Array = []
	for c in sk.get_children():
		if c is SkeletonModifier3D and (c as SkeletonModifier3D).active and not SKIN_LAYERS.has(str(c.name)):
			(c as SkeletonModifier3D).active = false
			off.append(c)
	p2._play(1, TAKE, 0.0, "punch", true)
	ap.speed_scale = 0.0
	for f in total:
		var tt := clampf(float(f - LEAD) / 60.0, 0.0, length - 0.01)
		ap.seek(tt, true)
		await process_frame
		if f == LEAD + int(round(cs * 60.0)):
			await _png("ours_contact")
		if f % 2 == 0:
			await _jpg("ours_%03d" % (f / 2))
	for m in off:
		(m as SkeletonModifier3D).active = true
	ap.speed_scale = 1.0
	print("BOUGHT_FILM ours pass done (%d layers off: %s)" % [off.size(), ", ".join(PackedStringArray(off.map(func(m): return str(m.name))))])
	# ---- bought: the vendor's file on its own skeleton and mannequin
	blue.visible = false
	var src := KR.load_fbx(root, FBX)
	if src.is_empty():
		print("BOUGHT_FILM FAIL cannot read %s" % FBX)
		quit(1)
		return
	var scene: Node3D = src["scene"]
	var grey := StandardMaterial3D.new()
	grey.albedo_color = Color(0.74, 0.72, 0.70)
	grey.roughness = 0.75
	var meshes := scene.find_children("*", "MeshInstance3D", true, false)
	for m in meshes:
		(m as MeshInstance3D).material_override = grey   # the pack's own textures are not in the pack's folder: one plain colour
	var our_leg: float = 0.0
	for pair in [["LeftUpperLeg", "LeftLowerLeg"], ["LeftLowerLeg", "LeftFoot"]]:
		our_leg += (sk.get_bone_global_rest(sk.find_bone(pair[0])).origin - sk.get_bone_global_rest(sk.find_bone(pair[1])).origin).length() * blue.scale.x
	var p0: Dictionary = KR.src_pts(src, 0.0)
	var k: float = our_leg / KR.leg_len(p0)
	scene.scale = Vector3.ONE * k
	var sfwd: Vector3 = p0["fwd"]
	var bf: Vector3 = spot["fwd"]
	scene.rotation.y = atan2(bf.x, bf.z) - atan2(sfwd.x, sfwd.z)
	await process_frame
	p0 = KR.src_pts(src, 0.0)
	var floor_y: float = minf((p0["toe_L"] as Vector3).y, (p0["toe_R"] as Vector3).y) - 0.02
	scene.position += Vector3((spot["hips"] as Vector3).x - (p0["hips"] as Vector3).x, -floor_y, (spot["hips"] as Vector3).z - (p0["hips"] as Vector3).z)
	print("BOUGHT_FILM bought: %d mesh(es), %d bones, sized x%.3f to our leg, take %.2f s" % [meshes.size(), (src["skel"] as Skeleton3D).get_bone_count(), k, (src["anim"] as Animation).length])
	var sap: AnimationPlayer = src["ap"]
	for f in total:
		sap.seek(clampf(float(f - LEAD) / 60.0, 0.0, (src["anim"] as Animation).length - 0.01), true)
		await process_frame
		if f == LEAD + int(round(cs * 60.0)):
			await _png("bought_contact")
		if f % 2 == 0:
			await _jpg("bought_%03d" % (f / 2))
	print("BOUGHT_FILM done %d pictures a pass" % ((total + 1) / 2))
	quit(0)


func _jpg(name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_jpg(out_dir.path_join(name + ".jpg"), 0.9)


func _png(name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
