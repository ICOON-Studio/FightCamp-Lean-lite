extends SceneTree
## S383c/d OWNED MOCAP films the operator can judge (operator on the S383 reel: "the video clip is lagging, cant tell how
## good the animations are, also the knees are trembling again"). The S383b diagnosis (tools/owned_mocap_jitter.gd) found
## the old reel ran the WHOLE fight modifier stack (FootPlant re-planting feet the clips already plant), on wall-clock
## delta, with a camera re-aimed at the hips every frame. Here, on the game's boxer (FightStage's kit: mh_boxer_08,
## bare-chested, trunks, boots, gloves), rendered 1920x1080 in a SubViewport (the hidden desktop's window is not 1080 tall):
##   pure (default): the clip ITSELF - every fight modifier off but MetaHumanTwist (the skin's twist bones;
##     clip_orbit.strip_modifiers), no KneeTrack (operator rule "mocap plays pure"). Each frame is the clip at exactly
##     t0 + f/30 (seek + pause): nothing in the picture depends on render speed.
##   mods=game: the full fight stack, the clip PLAYING as in a fight (run with --fixed-fps 30): each cycle the guard
##     (between=, default pro_idle) for BETWEEN_S then the clip (blend BLEND_S), for loop_s seconds - what fights show.
## FIXED camera (no orbit, no follow), placed once: chest height, 3/4 front (view= degrees from the boxer's front, default
## -45 = his right-front), aimed at the window's mean hips, the boxer ~70 % of the frame height (wider if his hips travel
## past the frame), on the grey grid (a sliding foot shows against it). Floor travel is kept (he moves in the frame).
##   full film: the whole clip, or the 30 s window with the least hips travel (max_s=30)
##   legs film (legs=1): a 10 s close-up of knees and feet, camera at knee height, in the 10 s window with the least travel
##   python tools/hidden_desktop.py run --timeout=3600 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --fixed-fps 30 --audio-driver Dummy --script res://tools/owned_mocap_film.gd -- out=<dir> \
##       res=<a.res,...> [ids=<library clip,...>] [glb=mh_boxer_08] [legs=1] [view=-45] [max_s=30] [legs_s=10] \
##       [mods=game] [loop_s=10] [between=pro_idle]
## Frames -> <out>/<name>/f00000.jpg (and <out>/<name>_legs/...); encode with ffmpeg at 30 fps. One FILM line per film.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const FPS := 30
const FOV := 30.0
const SIZE := Vector2i(1920, 1080)
const BODY_H := 1.78
const FILL := 0.70
const EYE_Y := 1.30
const LEGS_H := 1.15
const LEGS_EYE_Y := 0.55
const MIN_S := 10.0
const WARM := 30
const BETWEEN_S := 1.0
const BLEND_S := 0.15

var _vp: SubViewport
var _cam: Camera3D


func _initialize() -> void:
	var out_dir := "user://owned_film"
	var ids: Array = []
	var extra: Array = []
	var who := "mh_boxer_08"
	var legs := false
	var view := -45.0
	var max_s := 30.0
	var legs_s := 10.0
	var game := false
	var loop_s := 10.0
	var between := "pro_idle"
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		var v := s.substr(s.find("=") + 1)
		if s.begins_with("out="):
			out_dir = v
		elif s.begins_with("ids="):
			ids = Array(v.split(",", false))
		elif s.begins_with("res="):
			extra = Array(v.split(",", false))
		elif s.begins_with("glb="):
			who = v
		elif s == "legs=1":
			legs = true
		elif s.begins_with("view="):
			view = float(v)
		elif s.begins_with("max_s="):
			max_s = float(v)
		elif s.begins_with("legs_s="):
			legs_s = float(v)
		elif s == "mods=game":
			game = true
		elif s.begins_with("loop_s="):
			loop_s = float(v)
		elif s.begins_with("between="):
			between = v
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % who, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	for n in stage.get_children():
		if n is Node3D and n != stage.boxers[0]["node"] and n != stage.camera:
			(n as Node3D).visible = false
	_studio()
	var bx: Dictionary = stage.boxers[0]
	var body: Node3D = bx["node"]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	if game:
		var mods: Array = []
		for c in skel.get_children():
			if c is SkeletonModifier3D:
				mods.append(str(c.name))
		print("FILM game stack: ", ",".join(mods))
	else:
		print("FILM modifiers off: ", ",".join(Orbit.strip_modifiers(skel)))
	(stage.camera as Camera3D).set_process(false)
	_vp = SubViewport.new()
	_vp.size = SIZE
	_vp.world_3d = root.world_3d
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.msaa_3d = Viewport.MSAA_4X
	root.add_child(_vp)
	_cam = Camera3D.new()
	_cam.fov = FOV
	_vp.add_child(_cam)
	_cam.current = true
	for p in extra:
		Orbit._add_res(ap, skel, str(p))
		ids.append(str(p).get_file().get_basename())
	var face: float = body.global_rotation.y + deg_to_rad(view)
	for id in ids:
		var name := str(id)
		if not ap.has_animation(name):
			print("FILM MISSING ", name)
			continue
		var anim := ap.get_animation(name)
		if game:
			await _film_game(bx, anim, name, between, out_dir.path_join(name + "_game"), face, loop_s)
			continue
		await _film(bx, anim, name, out_dir.path_join(name), face, max_s, BODY_H / FILL, EYE_Y, 0.95)
		if legs:
			await _film(bx, anim, name, out_dir.path_join(name + "_legs"), face, legs_s, LEGS_H, LEGS_EYE_Y, 0.45)
	print("FILM DONE")
	quit(0)


## One fixed-camera film of `anim` in its least-travel window of at most `win` s: frame height `span` m at the boxer
## (more if the hips travel wider than the frame), camera at `eye_y`, aimed at the window's mean hips (x, z) at `aim_y`.
func _film(bx: Dictionary, anim: Animation, name: String, dir: String, face: float, win: float,
		span: float, eye_y: float, aim_y: float) -> void:
	var skel: Skeleton3D = bx["skel"]
	var length := minf(anim.length, win)
	var whole: Array = Orbit.hips_path(skel, anim, 0.0, anim.length)
	var w := int(round(length * FPS)) + 1
	# A clip shorter than MIN_S (our 2 s idle) plays looped for MIN_S, as the game loops it.
	var loop_w := int(round(MIN_S * FPS)) if anim.length < MIN_S else w
	var best := 0
	var best_r := INF
	var s := 0
	while s + w <= whole.size():
		var r := _range(whole.slice(s, s + w))
		if r < best_r:
			best_r = r
			best = s
		s += FPS
	var t0 := best / float(FPS)
	var dist := _place(whole.slice(best, best + w), face, span, best_r, eye_y, aim_y)
	DirAccess.make_dir_recursive_absolute(dir)
	for f in loop_w:
		var t := t0 + f / float(FPS)
		if loop_w != w:
			t = fmod(f / float(FPS), anim.length)
		Stage.IdleMatch.freeze(bx, name, minf(t, anim.length))
		await RenderingServer.frame_post_draw
		_vp.get_texture().get_image().save_jpg(dir.path_join("f%05d.jpg" % f), 0.95)
	print("FILM %s %s %.2f-%.2f s %d frames%s hips_range=%.2f m dist=%.2f m" % [name, dir.get_file(), t0, t0 + (w - 1) / float(FPS),
		loop_w, " (looped)" if loop_w != w else "", best_r, dist])


## The fight's way (mods=game): the guard for BETWEEN_S, then the clip, again and again for `loop_s` seconds, the clip
## PLAYING on the frame delta (--fixed-fps 30) through the whole modifier stack; WARM frames on the guard first.
func _film_game(bx: Dictionary, anim: Animation, name: String, between: String, dir: String, face: float, loop_s: float) -> void:
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(between):
		between = name
	var path: Array = Orbit.hips_path(skel, anim, 0.0, anim.length)
	var dist := _place(path, face, BODY_H / FILL, _range(path), EYE_Y, 0.95)
	DirAccess.make_dir_recursive_absolute(dir)
	for w in WARM:
		Stage.IdleMatch.freeze(bx, between, 0.0)
		await process_frame
	ap.play(between, 0.0)
	var frames := int(round(loop_s * FPS))
	var active_end := _active_end(anim)
	var in_clip := false
	var guard_left := BETWEEN_S
	for f in frames:
		# The guard for BETWEEN_S, then the clip until its last moving frame (the PRO combo ends on a 0.35 s still hold:
		# repeated frames in a film), then the guard.
		if not in_clip:
			guard_left -= 1.0 / FPS
			if guard_left <= 0.0:
				ap.play(name, BLEND_S)
				in_clip = true
		elif not ap.is_playing() or str(ap.current_animation) != name or ap.current_animation_position >= active_end:
			ap.play(between, BLEND_S)
			in_clip = false
			guard_left = BETWEEN_S
		await RenderingServer.frame_post_draw
		_vp.get_texture().get_image().save_jpg(dir.path_join("f%05d.jpg" % f), 0.95)
	print("FILM %s %s game stack, %d frames (%.1f s guard + the %.2f s clip, looped) dist=%.2f m" % [name, dir.get_file(), frames,
		BETWEEN_S, anim.length, dist])


## The clip's last moving moment: the last 1/30 s step where any rotation track turns more than 0.2 deg.
static func _active_end(anim: Animation) -> float:
	var t := anim.length
	while t > 0.5:
		var t0 := t - 1.0 / FPS
		for k in anim.get_track_count():
			if anim.track_get_type(k) != Animation.TYPE_ROTATION_3D:
				continue
			var q0 := anim.rotation_track_interpolate(k, t0)
			var q1 := anim.rotation_track_interpolate(k, t)
			if rad_to_deg(q0.angle_to(q1)) > 0.2:
				return t
		t = t0
	return anim.length


## Places the fixed camera for a film over hips `path`: `face` around them at `eye_y`, aimed at their mean at `aim_y`, far
## enough that `span` m fills the frame's height and the hips' travel `travel` (+1 m for the body) fits its width.
func _place(path: Array, face: float, span: float, travel: float, eye_y: float, aim_y: float) -> float:
	var c := Vector3.ZERO
	for p in path:
		c += p
	c /= float(maxi(path.size(), 1))
	var h := maxf(span, (travel + 1.0) / 0.9 * float(SIZE.y) / float(SIZE.x))
	var dist := h / (2.0 * tan(deg_to_rad(FOV) * 0.5))
	_cam.look_at_from_position(Vector3(c.x + sin(face) * dist, eye_y, c.z + cos(face) * dist), Vector3(c.x, aim_y, c.z), Vector3.UP)
	return dist


## The diagonal of the hips' floor box (m).
static func _range(path: Array) -> float:
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	for p in path:
		var v := Vector2((p as Vector3).x, (p as Vector3).z)
		lo = Vector2(minf(lo.x, v.x), minf(lo.y, v.y))
		hi = Vector2(maxf(hi.x, v.x), maxf(hi.y, v.y))
	return (hi - lo).length()


## clip_orbit.gd's studio: grey grid floor, plain backdrop, three-point light.
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
