extends SceneTree
## S409 a full-body picture of each boxer for the game-look cards: guard stance, gloves on, transparent background, a little
## below eye level so she reads as a fighter on a poster. Same body and kit as the fight.
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 --audio-driver Dummy \
##       --script res://tools/bake_full_body.gd -- out=<dir> [stems=mh_boxer_01,mh_boxer_12]
## Writes <dir>/<stem>.png, 600 x 800.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const Baked := preload("res://tools/bake_hub_sprites.gd")
const FighterPose := preload("res://scripts/rules/FighterPose.gd")

const W := 600
const H := 800
const SUPER := 2
const VIEW_H_M := 2.15
const AIM_Y_M := 0.9
const LENS_DOWN_DEG := 6.0
const LENS_ROUND_DEG := 35.0
const CLIP := "pro_idle"
const THREE_QUARTER := deg_to_rad(38.0)

var _vp: SubViewport
var _out := "E:/FightCamp/tmp/s409_look/fullbody"
var _alt := false
var _poses: Array = []
var _poseset := false   # S412 each boxer's three FighterPose pictures: <stem>[_alt].png, _p1, _p2


func _initialize() -> void:
	var stems: Array = Baked.STEMS.duplicate()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("out="):
			_out = a.substr(4)
		if a.begins_with("stems="):
			stems = a.substr(6).split(",")
		if a.begins_with("poses="):
			for sp in a.substr(6).split(","):
				_poses.append(Array(sp.split("@")))
		if a == "poseset":
			_poseset = true
		if a == "alt":   # S410 the other corner's kit, <stem>_alt.png: the versus screen dresses each side in its corner's colour
			_alt = true
	DirAccess.make_dir_recursive_absolute(_out)
	_setup()
	var made := 0
	for stem in stems:
		var glb := "res://assets/models/metahuman/%s.glb" % stem
		var body := MH.load_fighter(glb)
		if body == null:
			push_error("cannot load " + glb)
			continue
		var side: String = "blue" if (str(stem).right(2) in Baked.BLUE_STEMS) != _alt else "red"
		Kit.colour_vest(body, Stage.VESTS[side], Stage.CLOTH_ROUGHNESS)
		Kit.cloth_normals(body)
		Kit.dress(body, glb, "boxing")
		var gloves := Gloves.new()
		gloves.name = "Gloves"
		body.add_child(gloves)
		gloves.mount(body, Stage.CORNERS[side][0], Stage.CORNERS[side][1])
		_vp.add_child(body)
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		FightClips.load_into(ap, skel)
		ap.speed_scale = 0.0
		# S412 operator: "make fighters to have unique random poses instead of same or mirrored ones": poses=<clip>@<fraction>,...
		# writes one picture per pose, <stem>[_alt]_p<i>.png; without it, the one guard picture as before.
		var list: Array = _poses if not _poses.is_empty() else [[CLIP, 0.4]]
		if _poseset:
			list = FighterPose.of(str(stem)).map(func(n): return FighterPose.POOL[n])
		for i in list.size():
			var clip := str(list[i][0])
			if not ap.has_animation(clip):
				push_error("no clip " + clip)
				continue
			ap.play(clip)
			ap.seek(float(list[i][1]) * (ap.get_animation(clip).length if _poseset or not _poses.is_empty() else 1.0), true)
			await process_frame
			if _poseset or not _poses.is_empty():
				_turn_to_three_quarter(body, skel)
			var h := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips"))
			body.position += Vector3(-h.origin.x, 0.0, -h.origin.z)
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			var img := _vp.get_texture().get_image()
			img.convert(Image.FORMAT_RGBA8)
			img.fix_alpha_edges()
			img.resize(W, H, Image.INTERPOLATE_LANCZOS)
			img.save_png(_out.path_join(str(stem) + ("_alt" if _alt else "") + ("_p%d" % i if (not _poses.is_empty()) or (_poseset and i > 0) else "") + ".png"))
		made += 1
		body.queue_free()
		await process_frame
	print("FULLBODY made=%d" % made)
	quit(0 if made == stems.size() else 1)


## S412 operator: "they facing the side of the screen instead each other exlude those side pics maybe add only poses with specific
## angles": the chest always points the same way to the lens, three-quarter to the picture's left, whatever the clip's own heading.
func _turn_to_three_quarter(body: Node3D, skel: Skeleton3D) -> void:
	var cam := _vp.get_camera_3d()
	var l := (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("LeftUpperArm"))).origin
	var r := (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("RightUpperArm"))).origin
	var chest := ((l - r) * Vector3(1, 0, 1)).normalized().cross(Vector3.UP)
	var to_lens := ((cam.global_position - body.global_position) * Vector3(1, 0, 1)).normalized()
	var right := (cam.global_basis.x * Vector3(1, 0, 1)).normalized()
	var want := (to_lens * cos(THREE_QUARTER) - right * sin(THREE_QUARTER)).normalized()
	body.rotate_y(chest.signed_angle_to(want, Vector3.UP))


func _setup() -> void:
	_vp = SubViewport.new()
	_vp.size = Vector2i(W * SUPER, H * SUPER)
	_vp.transparent_bg = true
	_vp.own_world_3d = true
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.msaa_3d = Viewport.MSAA_4X
	root.add_child(_vp)
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_CLEAR_COLOR
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.85, 0.85, 0.85)
	e.ambient_light_energy = 0.55
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	_vp.add_child(env)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = VIEW_H_M
	_vp.add_child(cam)
	var yaw := deg_to_rad(LENS_ROUND_DEG)
	var pitch := deg_to_rad(LENS_DOWN_DEG)
	var aim := Vector3(0.0, AIM_Y_M, 0.0)
	cam.look_at_from_position(aim + Vector3(sin(yaw) * cos(pitch), sin(pitch), cos(yaw) * cos(pitch)) * 6.0, aim, Vector3.UP)
	cam.make_current()
	for l in [[Vector3(-55, 35, 0), 1.25, Color(1.0, 0.97, 0.93)], [Vector3(-25, -50, 0), 0.5, Color(0.92, 0.95, 1.0)], [Vector3(-10, 170, 0), 0.7, Color(1.0, 0.95, 0.88)]]:
		var light := DirectionalLight3D.new()
		light.rotation_degrees = l[0]
		light.light_energy = l[1]
		light.light_color = l[2]
		light.shadow_enabled = false
		_vp.add_child(light)
