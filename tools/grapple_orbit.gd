extends SceneTree
const Drift := preload("res://tools/orbit_drift.gd")   # S379 operator: "the camera spins too fast ... got me dizzy"
## S379 the board's Grappling animations page (operator: "i want to see the progress on animations on board, make a new
## one for the grappling animations"): each GrappleMap move the belt match plays, PURE - the recorded data on our two
## women and nothing laid on top: main's S335 GrapplePlayer (Catmull-Rom between the data's keyframes, GrappleTiming's
## pace), the per-frame push-out OFF (`contact = false`), GrapplePose's wrist/ankle IK OFF and no GrappleGrip (the S379
## audit's `nolayers` arm - the idle hump, routed waypoints and finish of claude/bjj9base are not on main at all).
## The pair alone on the boxing page's grey grid (clip_orbit.gd's studio), a camera circling once; the move plays once
## and holds its last frame (no loop cut inside a measured play); a move over PLAY_MAX_S plays evenly faster to fit.
## Frames -> <out>/<id>/f0000.jpg in a fixed 960x540 SubViewport; ops/Tools/lean_grapple_render.py encodes each to an mp4.
## While it films it MEASURES the women AS DRAWN (bones read on Skeleton3D.skeleton_updated, after GrapplePose - the S307
## trap; tools/bjj_tremble_probe.gd's definitions on claude/bjj9base):
##   jerk  the third difference of each tracked bone at 30 fps in m/s^3, p95 pooled over both women (S379: clean S335 film
##         code 44, the r10 match with its layers 1312)
##   flips velocity direction reversals per second per bone (steps over 0.5 mm turning more than 90 deg; 0.05 vs 3.75)
##   spike the worst one-frame step that is over SPIKE_X times both its neighbours (a pop), metres
##   overlap capsules on the drawn bones: either woman's limbs, head and neck into the other's pelvis + trunk; peak depth
##         in metres and the frames deeper than 6 cm (bodies inside bodies)
## One `GORBIT_JSON {...}` line per move.
##   python tools/hidden_desktop.py run --timeout=1800 <godot.exe> --path . --windowed --resolution 960x540 \
##       --audio-driver Dummy --script res://tools/grapple_orbit.gd -- out=<dir> ids=<GrappleMap sequence index,...>

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
## The browser's two women and their colours (GrappleBrowser.gd: BODIES / TOPS / TRUNKS / TRIM_DARKEN).
const BODIES := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
const TOPS := [Color("#ff6a5c"), Color("#5b93ff")]
const TRUNKS := [Color("#e2483d"), Color("#2f6fdb")]
const TRIM_DARKEN := 0.45
const W := 960
const H := 540
const FPS := 30.0
const HOLD_S := 0.8
const MIN_S := 4.0
const MAX_S := 9.0
## GrappleMap stores no timing (GrappleTiming paces it): a move longer than PLAY_MAX_S plays faster, evenly, so the whole
## move fits a short preview (the belt match itself caps a move at 4 s and lands a takedown in 1.9 s).
const PLAY_MAX_S := 6.0
## The camera fits the move: far enough that the pair's widest reach over the move and its tallest point stay in frame.
const RADIUS_MIN := 2.1
const FOLLOW_S := 0.6   # S379: the camera eases after the pair's centre with this lag (a travelling move stays framed)
const FIT_MARGIN := 1.5
const ELEVATION_DEG := 24.0
const V_MIN := 0.0005
const SPIKE_X := 3.0
const DEEP_M := 0.06
const TRACK := ["LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftFoot", "RightFoot", "LeftLowerLeg",
	"RightLowerLeg", "Head", "Hips"]
const BONES := ["Hips", "Spine", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
	"LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
	"LeftToes", "RightToes"]
## The other woman's parts [bone a, bone b, radius] tested against a torso (bjj_tremble_probe.gd's mesh-true radii).
const PARTS := [["Head", "Head", 0.11], ["Neck", "Head", 0.07], ["LeftUpperArm", "LeftLowerArm", 0.06],
	["RightUpperArm", "RightLowerArm", 0.06], ["LeftLowerArm", "LeftHand", 0.045], ["RightLowerArm", "RightHand", 0.045],
	["LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightUpperLeg", "RightLowerLeg", 0.10], ["LeftLowerLeg", "LeftFoot", 0.065],
	["RightLowerLeg", "RightFoot", 0.065], ["LeftFoot", "LeftToes", 0.068], ["RightFoot", "RightToes", 0.068]]
const TORSO := [["LeftUpperLeg", "RightUpperLeg", 0.118], ["Spine", "Neck", 0.12]]
const GRID_SHADER := """
shader_type spatial;
uniform vec3 base : source_color = vec3(0.46, 0.47, 0.49);
uniform vec3 line : source_color = vec3(0.30, 0.31, 0.33);
uniform vec3 major : source_color = vec3(0.20, 0.21, 0.23);
varying vec3 wp;
void vertex() { wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
float grid(vec2 p, float step, float w) {
	vec2 g = abs(fract(p / step - 0.5) - 0.5) / fwidth(p / step);
	return 1.0 - clamp(min(g.x, g.y) - w, 0.0, 1.0);
}
void fragment() {
	vec3 c = mix(base, line, grid(wp.xz, 0.25, 0.0));
	c = mix(c, major, grid(wp.xz, 1.0, 0.5));
	ALBEDO = c;
	ROUGHNESS = 0.95;
}
"""

var out_dir := "user://grapple_orbit"
var _cache: Array = [{}, {}]


func _initialize() -> void:
	var ids: Array = []
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("out="):
			out_dir = s.substr(4)
		elif s.begins_with("ids="):
			ids = Array(s.substr(4).split(",", false))
	# The picture is a fixed 960x540 SubViewport: the hidden desktop's window comes out 960x504 (S379 726da2ef).
	var vp := SubViewport.new()
	vp.size = Vector2i(W, H)
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var world := Node3D.new()
	vp.add_child(world)
	_studio(world)
	var cam := Camera3D.new()
	cam.fov = 45.0
	world.add_child(cam)
	cam.current = true
	var poses: Array = []
	var legs: Array = []
	var skels: Array = []
	for i in 2:
		var body := MH.load_fighter(BODIES[i])
		world.add_child(body)
		MH.colour_trunks(body, TRUNKS[i])
		Kit.colour_vest(body, TOPS[i], 0.8)
		_mma_trim(body, TRUNKS[i].darkened(TRIM_DARKEN))
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var pose: Node = Pose.attach(skel)
		pose.set("ik", false)
		poses.append(pose)
		skels.append(skel)
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
		_watch(skel, i)
	var player: Node = Player.new()
	player.set("contact", false)
	var db: Array = DB.load_db()
	await process_frame
	var done := 0
	for id in ids:
		var idx := int(id)
		if idx < 0 or idx >= db.size() or not DB.is_transition(db[idx]):
			print("GORBIT MISSING ", id)
			continue
		var seq: Dictionary = db[idx]
		player.play(seq, poses, Player.pair_scale(legs), Transform3D.IDENTITY)
		var length: float = player.length_s()
		var speed := maxf(1.0, length / PLAY_MAX_S)
		var shown := length / speed
		var total := clampf(shown + HOLD_S, MIN_S, MAX_S)
		var frames := int(ceil(total * FPS))
		var fit := _fit(player, length)
		var look: Vector3 = fit[0]
		var radius: float = fit[1]
		var core := DB.joint("Core")
		var follow := look
		var dir := out_dir.path_join(str(idx))
		DirAccess.make_dir_recursive_absolute(dir)
		var tracks: Array = []   # per woman, per TRACK bone: an Array of Vector3 over the measured frames (Arrays, not
		for w in 2:              # PackedVector3Array: a packed array read out of an Array is a copy, appends would be lost)
			var per: Array = []
			for _b in TRACK:
				per.append([])
			tracks.append(per)
		var ov := PackedFloat32Array()
		var measured := int(ceil(minf(shown, total) * FPS)) + 1
		# One unrecorded settle frame so the first saved frame already shows this move's first pose.
		player.seek(0.0)
		await RenderingServer.frame_post_draw
		for f in frames:
			var t := minf(float(f) / FPS * speed, length)
			player.seek(t)
			var ang := deg_to_rad(35.0) + Drift.angle(f, frames, FPS)
			var flat := radius * cos(deg_to_rad(ELEVATION_DEG))
			var js_now: Array = player.joints_at(t)
			var c_now: Vector3 = ((js_now[0] as PackedVector3Array)[core] + (js_now[1] as PackedVector3Array)[core]) * 0.5
			follow = Vector3(c_now.x, look.y, c_now.z) if f == 0 else follow.lerp(Vector3(c_now.x, look.y, c_now.z), 1.0 - exp(-1.0 / (FPS * FOLLOW_S)))
			cam.look_at_from_position(follow + Vector3(sin(ang) * flat, radius * sin(deg_to_rad(ELEVATION_DEG)), cos(ang) * flat),
				follow, Vector3.UP)
			await RenderingServer.frame_post_draw
			vp.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.88)
			if f < measured:
				for w in 2:
					for k in TRACK.size():
						(tracks[w][k] as Array).append(_cache[w].get(TRACK[k], Vector3.ZERO))
				ov.append(_overlap())
		var row := _numbers(tracks, ov, shown)
		row["speed"] = snappedf(speed, 0.01)
		row["id"] = idx
		row["title"] = str(seq["title"])
		row["length_s"] = snappedf(length, 0.01)
		row["frames"] = frames
		print("GORBIT_JSON " + JSON.stringify(row))
		done += 1
	print("GORBIT DONE %d/%d" % [done, ids.size()])
	quit(0)


## Every bone of the women as drawn this frame (after GrapplePose ran), world space.
func _watch(skel: Skeleton3D, who: int) -> void:
	var ids := {}
	for n in BONES:
		ids[n] = skel.find_bone(n)
	skel.skeleton_updated.connect(func() -> void:
		var d := {}
		var gt := skel.global_transform
		for n in BONES:
			if int(ids[n]) >= 0:
				d[n] = gt * skel.get_bone_global_pose(int(ids[n])).origin
		_cache[who] = d)


## The camera's target and distance for the whole move (steady - no chasing the bodies): the pair's mean core, half its
## tallest point high; far enough for the widest joint (16:9 at 45 deg: half-width tan 36 deg) and the height (tan 22.5).
func _fit(player: Node, length: float) -> Array:
	var c := Vector3.ZERO
	var n := 0
	var core := DB.joint("Core")
	var samples: Array = []
	for k in 9:
		var js: Array = player.joints_at(length * k / 8.0)
		samples.append(js)
		for w in 2:
			c += (js[w] as PackedVector3Array)[core]
			n += 1
	c /= float(n)
	var reach := 0.0
	var top := 0.0
	for js in samples:
		# S379: the camera follows the pair (see FOLLOW_S), so the frame only has to hold the pair's own spread at each
		# moment, not the whole path a travelling move covers (the pair shrank into the distance on takedowns)
		var cs: Vector3 = ((js[0] as PackedVector3Array)[core] + (js[1] as PackedVector3Array)[core]) * 0.5
		for w in 2:
			for p in (js[w] as PackedVector3Array):
				reach = maxf(reach, Vector2(p.x - cs.x, p.z - cs.z).length())
				top = maxf(top, p.y)
	var look := Vector3(c.x, clampf(top * 0.45, 0.25, 0.9), c.z)
	var radius := maxf(RADIUS_MIN, FIT_MARGIN * maxf(reach / tan(deg_to_rad(36.0)), (top * 0.5 + 0.15) / tan(deg_to_rad(22.5))))
	return [look, radius]


## The deepest part of one woman inside the other's pelvis or trunk this frame (both ways), metres.
func _overlap() -> float:
	var worst := 0.0
	for w in 2:
		var me: Dictionary = _cache[w]
		var other: Dictionary = _cache[1 - w]
		if me.is_empty() or other.is_empty():
			continue
		for tc in TORSO:
			if not (other.has(tc[0]) and other.has(tc[1])):
				continue
			for p in PARTS:
				if not (me.has(p[0]) and me.has(p[1])):
					continue
				var cp := Geometry3D.get_closest_points_between_segments(me[p[0]], me[p[1]], other[tc[0]], other[tc[1]])
				worst = maxf(worst, float(p[2]) + float(tc[2]) - cp[0].distance_to(cp[1]))
	return worst


func _numbers(tracks: Array, ov: PackedFloat32Array, length: float) -> Dictionary:
	var jerks := PackedFloat32Array()
	var flips := 0
	var spike := 0.0
	var spike_at := ""
	var n_frames := 0
	for w in 2:
		for k in TRACK.size():
			var p: Array = tracks[w][k]
			n_frames = p.size()
			for i in range(3, p.size()):
				var j3: Vector3 = (p[i] as Vector3) - 3.0 * (p[i - 1] as Vector3) + 3.0 * (p[i - 2] as Vector3) - (p[i - 3] as Vector3)
				jerks.append(j3.length() * FPS * FPS * FPS)
			for i in range(2, p.size()):
				var a: Vector3 = p[i - 1] - p[i - 2]
				var b: Vector3 = p[i] - p[i - 1]
				if a.length() > V_MIN and b.length() > V_MIN and a.dot(b) < 0.0:
					flips += 1
			for i in range(2, p.size() - 1):
				var s: float = (p[i] as Vector3).distance_to(p[i - 1])
				var before: float = (p[i - 1] as Vector3).distance_to(p[i - 2])
				var after: float = (p[i + 1] as Vector3).distance_to(p[i])
				if s > SPIKE_X * maxf(before, 0.002) and s > SPIKE_X * maxf(after, 0.002) and s > spike:
					spike = s
					spike_at = "%s %s %.2fs" % [["red", "blue"][w], TRACK[k], i / FPS]
	jerks.sort()
	var deep := 0
	var peak := 0.0
	for d in ov:
		peak = maxf(peak, d)
		if d > DEEP_M:
			deep += 1
	var secs := maxf(length, 1.0 / FPS)
	return {"jerk_p95": snappedf(jerks[int(jerks.size() * 0.95)] if jerks.size() > 0 else 0.0, 0.1),
		"flips_s": snappedf(float(flips) / (2.0 * TRACK.size()) / secs, 0.01),
		"spike_m": snappedf(spike, 0.001), "spike_at": spike_at,
		"overlap_peak_m": snappedf(peak, 0.001), "overlap_deep_frames": deep, "measured_frames": n_frames}


## clip_orbit.gd's studio: grey grid floor (it shows a sliding foot), plain backdrop, three-point light.
func _studio(world: Node3D) -> void:
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40)
	floor.mesh = plane
	var mat := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = GRID_SHADER
	mat.shader = sh
	floor.material_override = mat
	floor.position.y = 0.002
	world.add_child(floor)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.62, 0.64, 0.67)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.56, 0.6)
	env.environment.ambient_light_energy = 0.6
	world.add_child(env)
	for l in [[Vector3(-50, 35, 0), 1.3], [Vector3(-25, -140, 0), 0.55], [Vector3(-15, 160, 0), 0.7]]:
		var d := DirectionalLight3D.new()
		d.rotation_degrees = l[0]
		d.light_energy = l[1]
		d.shadow_enabled = l[1] > 1.0
		world.add_child(d)


## GrappleBrowser._mma_trim: the boxing kit's white trim in the corner's dark shade (MMA shorts and top).
static func _mma_trim(body: Node3D, colour: Color) -> void:
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			if src != null and src.resource_name.begins_with("MH_Trim"):
				var trim := StandardMaterial3D.new()
				trim.albedo_color = colour
				trim.roughness = 0.8
				mi.set_surface_override_material(s, trim)
