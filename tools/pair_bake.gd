extends SceneTree
## S317 PAIR BAKE (operator on update 15's clinch: "Clinch looks wrong", Q-S294-25; his C143 mark: "calculate the grip
## without wearing the glove"). Our clinch was built from a block pose and IK. The old repo owns a two-person clinch
## authored in Cascadeur (Game Godot/assets/anim/audition/cascadeur/Cascy_CageClinch_Att/_Vic.glb, 4 s, both bodies in
## one scene: heads past each other's shoulder, arms tied). This retargets both halves onto two of our MetaHuman boxers and
## saves them in the lean baked format (tracks by bone name, the Hips position as a delta from this body's rest - here
## WITH its X/Z, so the pair keeps its spacing), then renders the pair at a few times for the visual gate.
## Retarget: each mapped bone's WORLD rotation change from the source rest is applied to the target's world rest
## (both rigs rest in an A-pose); joints the source lacks (spine_02, spine_04, neck_02, UpperChest) stay at rest.
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1600x900 \
##       --audio-driver Dummy --script res://tools/pair_bake.gd -- <out_dir for stills>

const MH := preload("res://scripts/fight3d/MHRig.gd")
const SRC := "E:/FightCamp/Game/Godot/assets/anim/audition/cascadeur/Cascy_CageClinch_%s.glb"
const BODIES := {"Att": "res://assets/models/metahuman/mh_boxer_11.glb", "Vic": "res://assets/models/metahuman/mh_boxer_10.glb"}
const OUT := {"Att": "res://assets/anim/baked/clinch_att.res", "Vic": "res://assets/anim/baked/clinch_vic.res"}
const MAP := {"pelvis": "Hips", "stomach": "Spine", "chest": "Chest", "neck": "Neck", "head": "Head",
	"clavicle_l": "LeftShoulder", "arm_l": "LeftUpperArm", "forearm_l": "LeftLowerArm", "hand_l": "LeftHand",
	"clavicle_r": "RightShoulder", "arm_r": "RightUpperArm", "forearm_r": "RightLowerArm", "hand_r": "RightHand",
	"thigh_l": "LeftUpperLeg", "calf_l": "LeftLowerLeg", "foot_l": "LeftFoot", "toe_l": "LeftToes",
	"thigh_r": "RightUpperLeg", "calf_r": "RightLowerLeg", "foot_r": "RightFoot", "toe_r": "RightToes"}
const FPS := 30.0
const SHOTS_AT := [0.5, 1.5, 2.5, 3.5]
## The pelvis gap the stills (and Clinch.gd) hold: the printed spacing x our hips height.
const GAP_M := 0.77

## Each half is turned into its own boxer's frame (facing +Z, the body's forward, toward the other) and centred on her
## own mean hips, so the ring places both boxers at the clip's spacing (printed: forward gap, sideways offset).
var _src := {}     # role -> {root, skel, ap, anim}
var _turn := {}    # role -> Basis: the scene's yaw so she faces +Z
var _mean := {}    # role -> Vector3: her mean pelvis (scene world), the centre
var _tgt := {}     # role -> {body, skel}


func _initialize() -> void:
	var out_dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "user://pair_bake"
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1600, 900)
	for role in ["Att", "Vic"]:
		var doc := GLTFDocument.new()
		var st := GLTFState.new()
		if doc.append_from_file(SRC % role, st) != OK:
			print("PAIR_BAKE cannot read ", SRC % role)
			quit(1)
			return
		var s: Node3D = doc.generate_scene(st)
		s.visible = false
		root.add_child(s)
		var ap: AnimationPlayer = s.find_children("*", "AnimationPlayer", true, false)[0]
		_src[role] = {"root": s, "skel": s.find_children("*", "Skeleton3D", true, false)[0], "ap": ap,
			"anim": ap.get_animation_list()[0]}
		var body := MH.load_fighter(BODIES[role])
		root.add_child(body)
		_tgt[role] = {"body": body, "skel": body.find_children("*", "Skeleton3D", true, false)[0]}
	await process_frame
	_frames()
	for role in ["Att", "Vic"]:
		var anim := _bake(role)
		ResourceSaver.save(anim, OUT[role])
		print("PAIR_BAKE saved ", OUT[role], " ", anim.length, " s, ", anim.get_track_count(), " tracks")
	await _stills(out_dir)
	quit(0)


## Where each body stands over the clip and which way each faces the other.
func _frames() -> void:
	for role in ["Att", "Vic"]:
		var s: Dictionary = _src[role]
		var ss: Skeleton3D = s["skel"]
		var ap: AnimationPlayer = s["ap"]
		ap.play(s["anim"])
		ap.pause()
		var sum := Vector3.ZERO
		var n := 0
		var x := 0.0
		while x <= ap.get_animation(s["anim"]).length:
			ap.seek(x, true)
			sum += ss.global_transform * ss.get_bone_global_pose(ss.find_bone("pelvis")).origin
			n += 1
			x += 0.25
		_mean[role] = sum / n
	var f: Vector3 = (_mean["Vic"] as Vector3) - (_mean["Att"] as Vector3)
	f.y = 0.0
	var d := f.length()
	f = f.normalized()
	_turn["Att"] = Basis(Vector3.UP, atan2(f.x, f.z)).inverse()
	_turn["Vic"] = Basis(Vector3.UP, atan2(-f.x, -f.z)).inverse()
	var src_hips_y: float = (_mean["Att"] as Vector3).y
	print("PAIR_BAKE spacing (source units) forward %.3f, hips y %.3f -> ratio %.4f" % [d, src_hips_y, d / maxf(src_hips_y, 0.001)])


## World rotation of a skeleton-space basis.
static func _w(skel: Skeleton3D, b: Basis) -> Basis:
	return skel.global_transform.basis.orthonormalized() * b


func _bake(role: String) -> Animation:
	var s: Dictionary = _src[role]
	var ss: Skeleton3D = s["skel"]
	var ts: Skeleton3D = _tgt[role]["skel"]
	var ap: AnimationPlayer = s["ap"]
	var length: float = ap.get_animation(s["anim"]).length
	ap.play(s["anim"])
	ap.pause()
	var src_rest := {}
	var tgt_rest := {}
	for sb in MAP:
		var si := ss.find_bone(sb)
		var ti := ts.find_bone(str(MAP[sb]))
		if si < 0 or ti < 0:
			print("PAIR_BAKE missing ", sb, " -> ", MAP[sb])
			continue
		src_rest[sb] = _w(ss, ss.get_bone_global_rest(si).basis.orthonormalized())
		tgt_rest[MAP[sb]] = _w(ts, ts.get_bone_global_rest(ti).basis.orthonormalized())
	# Height: the target's hips over the floor against the source's (world metres).
	var src_hips_y: float = (ss.global_transform * ss.get_bone_global_rest(ss.find_bone("pelvis")).origin).y
	var ti_hips := ts.find_bone("Hips")
	var tgt_hips_y: float = (ts.global_transform * ts.get_bone_global_rest(ti_hips).origin).y
	var k := tgt_hips_y / maxf(src_hips_y, 0.01)
	var anim := Animation.new()
	anim.length = length
	var tracks := {}
	for i in ts.get_bone_count():
		var n := ts.get_bone_name(i)
		if tgt_rest.has(n) or n in ["spine_02", "spine_04", "neck_02", "UpperChest"]:
			var t := anim.add_track(Animation.TYPE_ROTATION_3D)
			anim.track_set_path(t, NodePath(n))
			tracks[n] = t
	var hips_t := anim.add_track(Animation.TYPE_POSITION_3D)
	anim.track_set_path(hips_t, NodePath("Hips"))
	var rest_hips: Vector3 = ts.get_bone_rest(ti_hips).origin
	var x := 0.0
	while x <= length + 0.0001:
		ap.seek(minf(x, length), true)
		# The target's skeleton-space globals, parents first (bone order is parents first).
		var glob := {}
		for i in ts.get_bone_count():
			var n := ts.get_bone_name(i)
			var p := ts.get_bone_parent(i)
			var pg: Basis = glob[p] if p >= 0 else Basis()
			var g: Basis
			var sb := _src_of(n)
			if sb != "" and src_rest.has(sb):
				var delta: Basis = (_turn[role] as Basis) * _w(ss, ss.get_bone_global_pose(ss.find_bone(sb)).basis.orthonormalized()) * (src_rest[sb] as Basis).inverse()
				g = ts.global_transform.basis.orthonormalized().inverse() * (delta * (tgt_rest[n] as Basis))
			else:
				g = pg * ts.get_bone_rest(i).basis.orthonormalized()
			glob[i] = g
			if tracks.has(n):
				anim.rotation_track_insert_key(tracks[n], x, (pg.inverse() * g).get_rotation_quaternion())
		var pw: Vector3 = ss.global_transform * ss.get_bone_global_pose(ss.find_bone("pelvis")).origin
		var m: Vector3 = _mean[role]
		var rel: Vector3 = (_turn[role] as Basis) * Vector3(pw.x - m.x, 0.0, pw.z - m.z)
		var hw := Vector3(rel.x * k, pw.y * k, rel.z * k)
		var local: Vector3 = ts.global_transform.affine_inverse() * hw
		anim.position_track_insert_key(hips_t, x, local - rest_hips)
		x += 1.0 / FPS
	return anim


static func _src_of(ours: String) -> String:
	for sb in MAP:
		if str(MAP[sb]) == ours:
			return sb
	return ""


## The two bodies at one origin playing their halves, from the side and from behind the attacker's shoulder.
func _stills(out_dir: String) -> void:
	var cam := Camera3D.new()
	root.add_child(cam)
	cam.current = true
	cam.fov = 40.0
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	root.add_child(sun)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.1, 0.1, 0.12)
	env.environment.ambient_light_color = Color(0.6, 0.6, 0.65)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	root.add_child(env)
	var floor := MeshInstance3D.new()
	floor.mesh = PlaneMesh.new()
	(floor.mesh as PlaneMesh).size = Vector2(8, 8)
	root.add_child(floor)
	var players := {}
	for role in ["Att", "Vic"]:
		var body: Node3D = _tgt[role]["body"]
		var skel: Skeleton3D = _tgt[role]["skel"]
		# As the ring will: each at GAP_M/2 from the middle, facing the other.
		body.position = Vector3(0, 0, -GAP_M * 0.5) if role == "Att" else Vector3(0, 0, GAP_M * 0.5)
		body.rotation.y = 0.0 if role == "Att" else PI
		var p := AnimationPlayer.new()
		body.add_child(p)
		var lib := AnimationLibrary.new()
		var anim: Animation = load(OUT[role]).duplicate(true)
		var prefix := str(p.get_node(p.root_node).get_path_to(skel))
		var hips := skel.find_bone("Hips")
		for t in anim.get_track_count():
			anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				for kk in anim.track_get_key_count(t):
					anim.track_set_key_value(t, kk, skel.get_bone_rest(hips).origin + (anim.track_get_key_value(t, kk) as Vector3))
		lib.add_animation("pair", anim)
		p.add_animation_library("", lib)
		p.play("pair")
		p.pause()
		players[role] = p
	for at in SHOTS_AT:
		for role in players:
			(players[role] as AnimationPlayer).seek(at, true)
		var mid := Vector3.ZERO
		for role in _tgt:
			var sk: Skeleton3D = _tgt[role]["skel"]
			mid += sk.global_transform * sk.get_bone_global_pose(sk.find_bone("Hips")).origin * 0.5
		for view in [["side", Vector3(3.2, 0.4, 0.0)], ["front", Vector3(0.0, 0.5, 3.2)], ["back", Vector3(-1.6, 0.6, -2.6)]]:
			cam.look_at_from_position(Vector3(mid.x, 1.2, mid.z) + (view[1] as Vector3), Vector3(mid.x, 1.0, mid.z), Vector3.UP)
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			var path := out_dir.path_join("pair_%s_%02d.png" % [view[0], int(at * 10)])
			root.get_texture().get_image().save_png(path)
			print("PAIR_BAKE wrote ", path)
