extends SceneTree
const Drift := preload("res://tools/orbit_drift.gd")   # S379 operator: "the camera spins too fast ... got me dizzy"
## S365 the board's Boxer animations page (operator: "can you update the boxer animations, to see what we have ingame"): each
## clip the fight can pick (Game/Tools/lean_anim_catalogue.py --ids) on the game's own boxer - the fight's body, gloves and
## kit, the clip as FightClips loads it - alone on a grey grid floor (the grid shows foot slide), a camera circling once
## (operator S270: "a drone camera rotates around them", "i dont need the ring"). Frames -> <out>/<id>/f0000.jpg; the
## board's renderer (Game/Tools/lean_anim_render.py) encodes each to an mp4. What the fight adds on top (the joins, the arm
## bent to the target, glove push, head snap) is NOT in these: this is the clip itself, with KneeTrack.align(skel, 1.0) on
## every frame after the clip so the board's previews show the knees as the fight plays them (S370 TASK_KNEETRACK1).
##   python tools/hidden_desktop.py run --timeout=3600 <godot.exe> --path . --windowed --resolution 960x540 \
##       --script res://tools/clip_orbit.gd -- out=<dir> ids=<a,b,...> [glb=mh_boxer_10]
## S381 res=<a.res,b.res,...>: baked clips not wired into FightClips (tools/owned_mocap_bake.gd output) are added as their
## file stem, hips as an offset from this body's rest and their floor travel KEPT (the grid then shows any foot slide).
## S383 t0=<s> max_s=<s>: film a window of each clip (from t0, at most max_s seconds) - a long take's best 40 s.
## S383c (operator: "the video clip is lagging ... the knees are trembling again"; tools/owned_mocap_jitter.gd measured it):
## FightStage.setup gives the boxer the WHOLE fight modifier stack, so these films were not "the clip itself" - FootPlant
## re-planted feet the clips already plant (knee shake 3-4x the clip's), its swings ran on wall-clock delta (uneven steps)
## and KneeTrack ran twice a frame. Now every SkeletonModifier3D except MetaHumanTwist (skinning helpers) is switched off
## (strip_modifiers) and KneeTrack.align runs once, as documented above; `mods=game` keeps the stack (the old films) and
## then skips the explicit align (S383d: it ran twice a frame - the call here and the modifier).
## The camera circles a FIXED floor point (the clip window's mean hips) instead of re-centring on the hips every frame
## (every hip sway became a whole-frame shake and the grid slid instead of the boxer moving).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const KneeTrack := preload("res://scripts/fight3d/KneeTrack.gd")
const RkLoco := preload("res://scripts/fight3d/RkLoco.gd")
const FPS := 30
const MIN_S := 4.0
const TAIL_S := 0.4
const RADIUS := 2.7
const HEIGHT := 1.35
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

var out_dir := "user://clip_orbit"


func _initialize() -> void:
	var ids: Array = []
	var who := "mh_boxer_10"
	var extra: Array = []
	var t0 := 0.0
	var max_s := INF
	var game_mods := false
	## S399 ROKOKO2: `tail=<s>` the hold after the clip (default TAIL_S; a judge read the hold as an abrupt settle);
	## `follow` = the orbit centre eases after the hips (a walk travels 1-2 m and left the frame round a fixed point).
	var tail_s := TAIL_S
	var follow := false
	var once := false   # S399: the clip plays once, no repeat (a repeat restarts it: the judge reads that seam as a pop)
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("out="):
			out_dir = s.substr(4)
		elif s.begins_with("ids="):
			ids = Array(s.substr(4).split(",", false))
		elif s.begins_with("glb="):
			who = s.substr(4)
		elif s.begins_with("res="):
			extra = Array(s.substr(4).split(",", false))
		elif s.begins_with("t0="):
			t0 = float(s.substr(3))
		elif s.begins_with("max_s="):
			max_s = float(s.substr(6))
		elif s == "mods=game":
			game_mods = true
		elif s.begins_with("tail="):
			tail_s = float(s.substr(5))
		elif s == "follow":
			follow = true
		elif s == "once":
			once = true
		elif not s.begins_with("--"):
			# S400: a brief wrote `clips=` - read as nothing, 0 clips filmed, a one-frame film went on the board
			push_error("ORBIT unknown argument: " + s)
			quit(2)
			return
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	for n in stage.get_children():
		if n is Node3D and n != stage.boxers[0]["node"] and n != stage.camera:
			(n as Node3D).visible = false
	_studio(stage)
	var bx: Dictionary = stage.boxers[0]
	var body: Node3D = bx["node"]
	var skel: Skeleton3D = bx["skel"]
	if not game_mods:
		print("ORBIT modifiers off: ", ",".join(strip_modifiers(skel)))
	var ap: AnimationPlayer = bx["ap"]
	var hips := skel.find_bone("Hips")
	var cam: Camera3D = stage.camera
	cam.set_process(false)
	cam.fov = 45.0
	for p in extra:
		_add_res(ap, skel, str(p))
		ids.append(str(p).get_file().get_basename())
	var done := 0
	for id in ids:
		var name := str(id)
		if not ap.has_animation(name):
			print("ORBIT MISSING ", name)
			continue
		var dir := out_dir.path_join(name)
		DirAccess.make_dir_recursive_absolute(dir)
		var start := minf(t0, ap.get_animation(name).length)
		var length: float = minf(ap.get_animation(name).length - start, max_s)
		var cycle := length + tail_s
		var total := cycle if once else maxf(MIN_S, cycle)
		var frames := int(ceil(total * FPS))
		var face: float = body.global_rotation.y
		var c := Vector3.ZERO
		var path := hips_path(skel, ap.get_animation(name), start, length)
		# S399 a captured loco clip (RkLoco) is in place in the library: her body travels by its root curve
		var loco := RkLoco.info(skel, name)
		var base := body.position
		if not loco.is_empty():
			for k in path.size():
				path[k] = (path[k] as Vector3) + body.global_transform.basis * RkLoco.sample(loco, start + k / float(FPS))
		for p in path:
			c += p
		c /= float(maxi(path.size(), 1))
		c.y = 1.0
		if follow and path.size() > 0:
			c = Vector3((path[0] as Vector3).x, 1.0, (path[0] as Vector3).z)
		for f in frames:
			var t := float(f) / FPS
			var in_cycle := fmod(t, cycle)
			Stage.IdleMatch.freeze(bx, name, start + minf(in_cycle, length))
			if not loco.is_empty():
				body.position = base + body.global_transform.basis * RkLoco.sample(loco, start + minf(in_cycle, length))
			if follow and path.size() > 0:
				var hp: Vector3 = path[clampi(int(minf(in_cycle, length) * FPS), 0, path.size() - 1)]
				c = c.lerp(Vector3(hp.x, 1.0, hp.z), 1.0 - exp(-(1.0 / FPS) / 0.6))
			if not game_mods and not name.begins_with("rk_"):   # S399: a Rokoko clip plays pure (RkPure) - no knee layer
				KneeTrack.align(skel, 1.0)   # once: with mods=game the KneeTrack modifier already runs
			var ang := face + PI * 0.5 + Drift.angle(f, frames, 30.0)
			cam.look_at_from_position(Vector3(c.x + sin(ang) * RADIUS, HEIGHT, c.z + cos(ang) * RADIUS), c, Vector3.UP)
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.88)
		done += 1
		body.position = base
		print("ORBIT %s %.2f-%.2fs %d frames" % [name, start, start + length, frames])
	print("ORBIT DONE %d/%d" % [done, ids.size()])
	quit(0 if done > 0 else 1)


## S383c: switches off every SkeletonModifier3D under `skel` but MetaHumanTwist (the skin's twist helpers) - the clip
## itself, no fight layers. Returns the names switched off.
static func strip_modifiers(skel: Skeleton3D) -> Array:
	var off: Array = []
	for c in skel.get_children():
		if c is SkeletonModifier3D and str(c.name) != "MetaHumanTwist":
			(c as SkeletonModifier3D).active = false
			off.append(str(c.name))
	return off


## S383c: the hips in world space, read off the clip's Hips position track (no pose update needed), every 1/FPS from t0
## for `length` seconds.
static func hips_path(skel: Skeleton3D, anim: Animation, t0: float, length: float) -> Array:
	var hb := skel.find_bone("Hips")
	var par := skel.get_bone_parent(hb)
	var pg := skel.get_bone_global_rest(par) if par >= 0 else Transform3D.IDENTITY
	var tr := -1
	for t in anim.get_track_count():
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D and str(anim.track_get_path(t)).ends_with(":Hips"):
			tr = t
	var out: Array = []
	for f in int(length * FPS) + 1:
		var lp: Vector3 = skel.get_bone_rest(hb).origin
		if tr >= 0:
			lp = anim.position_track_interpolate(tr, minf(t0 + f / float(FPS), anim.length))
		out.append(skel.global_transform * (pg * lp))
	return out


## A baked clip from a file, as FightClips._add_baked adds it but with its floor travel kept.
static func _add_res(ap: AnimationPlayer, skel: Skeleton3D, path: String) -> void:
	var anim := (load(path) as Animation).duplicate(true) as Animation
	var any := ap.get_animation(ap.get_animation_list()[0])
	var prefix := str(any.track_get_path(0)).get_slice(":", 0)
	var rest := skel.get_bone_rest(skel.find_bone("Hips")).origin
	for t in anim.get_track_count():
		anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			for k in anim.track_get_key_count(t):
				anim.track_set_key_value(t, k, rest + (anim.track_get_key_value(t, k) as Vector3))
	ap.get_animation_library("").add_animation(path.get_file().get_basename(), anim)


## A studio: grey grid floor, plain backdrop, three-point light.
func _studio(stage: Node3D) -> void:
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
