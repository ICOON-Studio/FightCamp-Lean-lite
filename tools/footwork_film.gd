extends SceneTree
## FOOTWORK1 studio film (S381): BoxerFootwork + BoxerFootworkRig on the game's boxer (the fight's body, gloves, kit and
## guard clip), on clip_orbit's grey grid (the grid shows any foot slide), a slow camera drift (S379: max 10 deg/s).
##   solo: 4 s bounce in place, then forward x2, back x2, left x2, right x2, 1.5 s bounce.
##   side / front: the solo choreography from a fixed camera at her right / at the opponent's spot (for judging).
##   standoff: two boxers 20 s face to face at boxing range - bouncing and flat-footed spells, half steps in and out of
##   jab range (centres 1.15-1.45 m: lead foot to lead foot ~0.6-0.9, chest to chest ~1.1-1.3), circling (turning
##   steps); prints the measured RANGE (lead balls, chests) at the end.
## Round 2: a MALE pair by default (mh_boxer_01 red, mh_boxer_02 blue: bare-chested, trunks, boots, gloves - BoxerBuild).
## Frames -> <out>/<seg>/f0000.jpg at 30 fps; encode with ffmpeg.
##   python tools/hidden_desktop.py run --timeout=1800 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/footwork_film.gd -- out=<dir> [seg=solo,side,front,standoff] [glb=mh_boxer_01] [glb2=mh_boxer_02]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const Footwork := preload("res://scripts/fight3d/BoxerFootwork.gd")
const Rig := preload("res://scripts/fight3d/BoxerFootworkRig.gd")
const FPS := 30
const DT := 1.0 / FPS
const GUARD := "pro_idle"
const SOLO := [["fwd", "fwd"], ["back", "back"], ["left", "left"], ["right", "right"]]
const SOLO_GAP_S := 0.7
const STANDOFF_S := 20.0
const START_M := 1.34          # centre to centre at the bell
const FAR_M := 1.42            # beyond this: step in (out of jab range; r4b 1.46: lead feet to 0.96 m)
const NEAR_M := 1.24           # inside this: step out (r4a: 1.15 let the chests come to 0.98 m)
const RANGE_STEP := 0.5        # in-and-out steps are half steps (13 cm)

var out_dir := "user://footwork_film"
var rng := RandomNumberGenerator.new()
var view: SubViewport


func _initialize() -> void:
	var segs: Array = ["solo", "standoff"]
	var who := "mh_boxer_01"
	var who2 := "mh_boxer_02"
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("out="):
			out_dir = s.substr(4)
		elif s.begins_with("seg="):
			segs = Array(s.substr(4).split(",", false))
		elif s.begins_with("glb="):
			who = s.substr(4)
		elif s.begins_with("glb2="):
			who2 = s.substr(5)
	rng.seed = 381
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED   # no fight ticks on the empty stage
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % who2, "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var keep: Array = [stage.boxers[0]["node"], stage.boxers[1]["node"], stage.camera]
	for n in stage.find_children("*", "WorldEnvironment", true, false):
		n.queue_free()   # the arena's dark backdrop; the studio's grey one shows the boxer's outline
	for n in stage.get_children():
		if n is Node3D and not keep.has(n):
			(n as Node3D).visible = false
	_studio()
	(stage.camera as Camera3D).set_process(false)
	# the hidden desktop clamps the window to 1920x1009: film through a 1920x1080 SubViewport on the same world
	view = SubViewport.new()
	view.size = Vector2i(1920, 1080)
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	view.msaa_3d = Viewport.MSAA_4X
	root.add_child(view)
	var cam := Camera3D.new()
	cam.fov = 40.0
	view.add_child(cam)
	cam.current = true
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		if bx.get("feet") != null:
			(bx["feet"] as Node).free()
			bx["feet"] = null
		var body: Node3D = bx["node"]
		var fw = Footwork.new(Vector2.ZERO, 0.0, bool(bx["south"]), body.scale.x)
		bx["fw"] = fw
		bx["rig"].plan = fw   # S391: every boxer carries the rig, let go until something takes her legs
		bx["rig"].want = 1.0
		bx["rig"].w = 1.0
	for seg in segs:
		if seg in ["solo", "side", "front"]:
			await _solo(stage, cam, seg)
		elif seg == "standoff":
			await _standoff(stage, cam)
	print("FOOTWORK FILM DONE")
	quit(0)


func _reset(bx: Dictionary, at: Vector2, yaw: float, phase: float, seed_n: int = 381) -> void:
	var body: Node3D = bx["node"]
	var fw = Footwork.new(at, yaw, bool(bx["south"]), body.scale.x, seed_n)
	fw.phase = phase
	bx["fw"] = fw
	(bx["rig"] as Node).plan = fw


func _solo(stage: Node3D, cam: Camera3D, view_mode: String = "solo") -> void:
	var bx: Dictionary = stage.boxers[0]
	(stage.boxers[1]["node"] as Node3D).visible = false
	_reset(bx, Vector2.ZERO, 0.0, 0.0)
	var fw = bx["fw"]
	var dir := out_dir.path_join(view_mode)
	DirAccess.make_dir_recursive_absolute(dir)
	var group := 0
	var idle_since := 0.0
	var f := 0
	var tail := -1.0
	var marks: Array = []
	while true:
		var t := f * DT
		if group < SOLO.size() and t >= 4.0 and not fw.busy() and t - idle_since >= SOLO_GAP_S:
			for d in SOLO[group]:
				fw.step(d)
			marks.append("%.2f %s" % [t, SOLO[group][0]])
			group += 1
		if fw.busy():
			idle_since = t
		if group >= SOLO.size() and not fw.busy() and tail < 0.0:
			tail = t
		if tail >= 0.0 and t - tail > 1.5:
			break
		_frame(bx, f, 0.0)
		var c: Vector2 = fw.centre()
		var ang := deg_to_rad(40.0) + deg_to_rad(110.0) * smoothstep(0.0, 1.0, t / 17.0)
		match view_mode:
			"side":   # fixed, from her right: the step-drag along the fight line, knees and heels in profile
				cam.look_at_from_position(Vector3(-3.0, 0.6, 0.0), Vector3(0.0, 0.8, 0.0), Vector3.UP)
			"front":  # fixed, from the opponent's spot: stance width, knees over toes, sideways steps
				cam.look_at_from_position(Vector3(0.0, 0.6, 3.0), Vector3(0.0, 0.8, 0.0), Vector3.UP)
			_:
				cam.look_at_from_position(Vector3(c.x + sin(ang) * 2.6, 0.95, c.y + cos(ang) * 2.6), Vector3(c.x, 0.78, c.y), Vector3.UP)
		await RenderingServer.frame_post_draw
		view.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.9)
		f += 1
	print("SOLO %d frames, groups at %s" % [f, ", ".join(marks)])


func _standoff(stage: Node3D, cam: Camera3D) -> void:
	var a: Dictionary = stage.boxers[0]
	var b: Dictionary = stage.boxers[1]
	(b["node"] as Node3D).visible = true
	_reset(a, Vector2(0, -START_M * 0.5), 0.0, 0.0, 381)
	_reset(b, Vector2(0, START_M * 0.5), PI, 0.37, 1381)
	var dir := out_dir.path_join("standoff")
	DirAccess.make_dir_recursive_absolute(dir)
	var wait := [0.6, 1.1]
	var frames := int(STANDOFF_S * FPS)
	var rng_lead := Vector2(INF, -INF)
	var rng_chest := Vector2(INF, -INF)
	for f in frames:
		for i in 2:
			var me: Dictionary = [a, b][i]
			var other: Dictionary = [b, a][i]
			var fw = me["fw"]
			var to: Vector2 = (other["fw"].centre() as Vector2) - fw.centre()
			fw.face(atan2(to.x, to.y))
			wait[i] = float(wait[i]) - DT
			if float(wait[i]) <= 0.0 and not fw.busy() and not other["fw"].busy():
				var gap := to.length()
				var roll := rng.randf()
				if gap > FAR_M:
					fw.step("fwd", RANGE_STEP)
				elif gap < NEAR_M:
					fw.step("back", RANGE_STEP)
				elif roll < 0.3:
					fw.step("fwd", RANGE_STEP)    # into jab range ...
				elif roll < 0.55:
					fw.step("back", RANGE_STEP)   # ... and out
				elif roll < 0.8:
					fw.step(["left", "right"][rng.randi() % 2], 0.7)
				wait[i] = rng.randf_range(0.4, 1.3)
		_frame(a, f, 0.0)
		_frame(b, f, 0.7)
		var lead_d: float = (_ball(a, 0) - _ball(b, 0)).length()
		var chest_d: float = (_bone(a, "UpperChest") - _bone(b, "UpperChest")).length()
		rng_lead = Vector2(minf(rng_lead.x, lead_d), maxf(rng_lead.y, lead_d))
		rng_chest = Vector2(minf(rng_chest.x, chest_d), maxf(rng_chest.y, chest_d))
		var c: Vector2 = ((a["fw"].centre() as Vector2) + (b["fw"].centre() as Vector2)) * 0.5
		var ang := PI * 0.5 + deg_to_rad(-30.0) + deg_to_rad(60.0) * smoothstep(0.0, 1.0, float(f) / frames)
		cam.look_at_from_position(Vector3(c.x + sin(ang) * 4.0, 1.05, c.y + cos(ang) * 4.0), Vector3(c.x, 0.8, c.y), Vector3.UP)
		await RenderingServer.frame_post_draw
		view.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.9)
	print("STANDOFF %d frames, pairs %d / %d" % [frames, a["fw"].done_pairs.size(), b["fw"].done_pairs.size()])
	print("RANGE lead ball to lead ball %.2f-%.2f m, chest to chest %.2f-%.2f m (UpperChest bones)" % [rng_lead.x, rng_lead.y,
		rng_chest.x, rng_chest.y])


## World position of the plan's ball of the foot i (0 = lead) / of a bone (the skeleton's last pose).
static func _ball(bx: Dictionary, i: int) -> Vector3:
	var p: Dictionary = bx["fw"].pose()
	var b: Vector3 = p["feet"][i]["ball"]
	return Vector3(b.x, 0.0, b.z)


static func _bone(bx: Dictionary, bone_name: String) -> Vector3:
	var skel: Skeleton3D = bx["skel"]
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone_name)).origin


## clip_orbit's studio: grey grid floor (0.25 m lines, 1 m majors), plain backdrop, three-point light.
func _studio() -> void:
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40)
	floor.mesh = plane
	var mat := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = Orbit.GRID_SHADER
	mat.shader = sh
	floor.material_override = mat
	floor.position.y = 0.002
	root.add_child(floor)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.62, 0.64, 0.67)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.56, 0.6)
	env.environment.ambient_light_energy = 0.6
	root.add_child(env)
	for l in [[Vector3(-50, 35, 0), 1.3], [Vector3(-25, -140, 0), 0.55], [Vector3(-15, 160, 0), 0.7]]:
		var d := DirectionalLight3D.new()
		d.rotation_degrees = l[0]
		d.light_energy = l[1]
		d.shadow_enabled = l[1] > 1.0
		root.add_child(d)


## One film frame for one boxer: the plan ticks, the body stands on it, the guard clip holds its frame.
func _frame(bx: Dictionary, f: int, offset_s: float) -> void:
	var fw = bx["fw"]
	fw.tick(DT)
	(bx["rig"] as Node).drive()
	var ap: AnimationPlayer = bx["ap"]
	ap.play(GUARD)
	ap.seek(fmod(f * DT + offset_s, ap.get_animation(GUARD).length), true)
	ap.pause()
