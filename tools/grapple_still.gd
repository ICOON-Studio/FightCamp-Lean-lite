extends SceneTree
## S335 stills of the GrappleMap prototype: two of our women on a mat, posed by GrapplePose from GrappleMap sequences,
## each a position or a transition at its start / middle / end. Real pictures only (the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/grapple_still.gd -- <out_dir> ["title" ...]

const W := 1920
const H := 1080
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
## S335 operator: "use different colours on the clothes for each" - one colour head to toe per woman (top a shade lighter).
const TOPS := [Color("#ff6a5c"), Color("#5b93ff")]
const BODIES := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
const TRUNKS := [Color(0.75, 0.1, 0.1), Color(0.1, 0.25, 0.75)]
const TITLES := ["full guard kimura", "mount", "hip bump sweep w/ hand post"]

var out_dir := "user://grapple"
var cam: Camera3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	var titles: Array = TITLES if args.size() < 2 else args.slice(1)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	var world := Node3D.new()
	root.add_child(world)
	_room(world)
	var poses: Array = []
	var legs: Array = []
	for i in 2:
		var body := MH.load_fighter(BODIES[i])
		world.add_child(body)
		MH.colour_trunks(body, TRUNKS[i])
		Kit.colour_vest(body, TOPS[i], 0.8)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		poses.append(Pose.attach(skel))
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
	var player := Player.new()
	world.add_child(player)
	player.set_process(false)
	var db: Array = DB.load_db()
	for ti in titles.size():
		var seq: Dictionary = DB.find(db, str(titles[ti]))
		if seq.is_empty():
			print("GRAPPLE_STILL missing ", titles[ti])
			continue
		player.play(seq, poses, Player.pair_scale(legs), Transform3D.IDENTITY)
		var times := [0.0] if not DB.is_transition(seq) else [0.0, player.length_s() * 0.5, player.length_s()]
		for k in times.size():
			player.seek(times[k])
			_frame(player.joints_at(times[k]))
			await _shot("g%02d_%s_%d" % [ti + 1, str(seq["title"]).replace(" ", "_").replace("/", "").left(32), k])
	quit(0)


func _room(world: Node3D) -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.82, 0.84, 0.86)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.9, 0.9, 0.92)
	e.ambient_light_energy = 0.6
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	world.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, 35, 0)
	sun.light_energy = 1.3
	sun.shadow_enabled = true
	world.add_child(sun)
	var mat := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(8, 8)
	mat.mesh = plane
	var m := StandardMaterial3D.new()
	m.albedo_color = Color("#9da3a8")
	m.roughness = 0.9
	mat.material_override = m
	world.add_child(mat)
	cam = Camera3D.new()
	cam.fov = 40.0
	world.add_child(cam)
	cam.current = true


## Both men whole in frame: the camera stands off the pair's side at a 3/4 height, far enough for their spread.
func _frame(js: Array) -> void:
	var lo := Vector3.INF
	var hi := -Vector3.INF
	for p in js:
		for v in (p as PackedVector3Array):
			lo = lo.min(v)
			hi = hi.max(v)
	var c := (lo + hi) * 0.5
	var r := maxf((hi - lo).length() * 0.5, 0.8)
	var dist := r / tan(deg_to_rad(cam.fov * 0.5)) * 1.15
	cam.position = c + Vector3(0.75, 0.55, 0.6).normalized() * dist
	cam.look_at(c, Vector3.UP)


func _shot(name: String) -> void:
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
