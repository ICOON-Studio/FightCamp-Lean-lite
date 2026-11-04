extends Control
## S379 the Grappling theatre (operator: "most grappling animation look good except the 'to 50/50' but i want a tool where
## i can see the real sequence happening to understand how natural the transitions etc look maybe like a documentary style
## or movie prop"). A chain of GrappleMap transitions (TheatreChains) played back to back on our two no-gi women,
## STRAIGHT from the recording: main's GrapplePlayer with the push-out off (`contact = false`), GrapplePose's wrist/ankle
## IK off and no GrappleGrip - the board's Grappling page's pure arm (tools/grapple_orbit.gd, the operator's "look good").
## The S379 audit's per-frame show layers (idle hump, carry, impact dip, routed waypoints, built finish) are not on main.
## The only thing between two recorded moves is the join: the next move laid on the last keyframe (GrappleGraph.align)
## and one curved gap if the two recordings differ - each join is a tick on the timeline.
## A documentary director (TheatreDirector) cuts wide / low / close-up / overhead shots with a lower-third caption per
## move; Free orbit (mouse drag, wheel) to inspect. Keys: Space play/pause, Left/Right move, O orbit, L loop.
## Open: `FightCamp.exe -- jump=theatre [chain=<id>]` or the Theatre button on the ground-move browser.
##   film mode (`film=1` or film = true before _ready): no chrome but the caption and the timeline; tools/theatre_film.gd.

const UI := preload("res://scripts/ui/UI.gd")
const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const Browser := preload("res://scripts/grapple/GrappleBrowser.gd")
const Chains := preload("res://scripts/grapple/TheatreChains.gd")
const Director := preload("res://scripts/grapple/TheatreDirector.gd")
const TUI := preload("res://scripts/grapple/TheatreUI.gd")
const Strip := preload("res://scripts/grapple/TheatreStrip.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const BROWSER_SCENE := "res://scenes/dev/GrappleBrowser.tscn"
const PRE_S := 1.0    # the first position held before the chain starts
const POST_S := 1.5   # the last position held before the loop
const MAT_SHADER := """
shader_type spatial;
uniform vec3 base : source_color = vec3(0.23, 0.27, 0.32);
uniform vec3 seam : source_color = vec3(0.14, 0.16, 0.19);
varying vec3 wp;
void vertex() { wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
float line(float v, float step, float w) {
	float g = abs(fract(v / step - 0.5) - 0.5) / fwidth(v / step);
	return 1.0 - clamp(g - w, 0.0, 1.0);
}
void fragment() {
	float s = max(line(wp.x, 1.0, 0.5), line(wp.z, 2.0, 0.5));
	ALBEDO = mix(base, seam, s * 0.8);
	ROUGHNESS = 0.92;
}
"""

var film := false
var db: Array = []
var graph: RefCounted
var player: Node
var poses: Array = []
var director := Director.new()
var cam: Camera3D
var spot: SpotLight3D
var chain_id := ""
var reel: Dictionary = {}
var steps: Array = []          # [{name, line, t0, t1}] theatre seconds
var joins: Array = []          # theatre seconds
var total := 1.0
var clock := 0.0
var playing := true
var speed := 1.0
var loop := true
var orbit := false
var _orbit_yaw := 35.0
var _orbit_pitch := 22.0
var _orbit_dist := 3.6
var _shown_step := -2
var _ui: Dictionary = {}
var _cards: Dictionary = {}
var _caption: Dictionary = {}
var _strip: Control
var _ctl: Dictionary = {}
var _top: Dictionary = {}
var _pad: Control
var _world: Node3D
var _hint: Label


func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	film = film or args.has("film=1")
	theme = UI.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	db = DB.load_db()
	graph = Graph.new()
	var bg := ColorRect.new()
	bg.color = TUI.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var rows := UI.vbox(0)
	rows.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(rows)
	_top = TUI.top_bar(func(): set_orbit(not orbit), func(): get_tree().change_scene_to_file(BROWSER_SCENE))
	rows.add_child(_top["bar"])
	_cards = TUI.cards(Chains.chains(), load_chain)
	rows.add_child(_cards["box"])
	var view := _viewport()
	rows.add_child(view)
	_strip = Strip.new()
	_strip.font = UI.font("semi")
	_strip.custom_minimum_size = Vector2(0, 30 if film else 46)
	_strip.seek.connect(func(t): seek(t))
	rows.add_child(_strip)
	_ctl = TUI.controls({"prev": func(): step_move(-1), "play": func(): set_playing(not playing),
		"next": func(): step_move(1), "speed": set_speed, "loop": func(): set_loop(not loop)})
	rows.add_child(_ctl["box"])
	for n in [_top["bar"], _cards["box"], _ctl["box"]]:
		(n as Control).visible = not film
	_cast(_world)
	var first := "hip_bump"
	for a in args:
		if str(a).begins_with("chain=") and not Chains.chain(str(a).substr(6)).is_empty():
			first = str(a).substr(6)
		elif str(a) == "orbit=1":
			set_orbit(true)
	load_chain(first)


## The stage: the 3D view (a SubViewportContainer filling it) with its overlays as siblings on top.
func _viewport() -> Control:
	var box := Control.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.clip_contents = true
	var holder := SubViewportContainer.new()
	holder.stretch = true
	holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(holder)
	var vp := SubViewport.new()
	vp.msaa_3d = Viewport.MSAA_4X
	holder.add_child(vp)
	_world = Node3D.new()
	vp.add_child(_world)
	_room(_world)
	# The overlays: the drag pad (Free orbit only), the lower third, the hint.
	_pad = Control.new()
	_pad.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_pad.gui_input.connect(_orbit_input)
	box.add_child(_pad)
	_caption = TUI.caption()
	box.add_child(_caption["box"])
	_hint = UI.label("FREE ORBIT - drag to turn, wheel to zoom", 15, TUI.MUTED, "caps")
	_hint.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_hint.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_hint.offset_right = -20
	_hint.offset_top = 14
	_hint.visible = false
	box.add_child(_hint)
	return box


## A dark screening room: a tatami-seamed mat (the seams show a sliding foot), a key and fill light, and a spot that
## follows the pair so the mat falls off into the dark.
func _room(world: Node3D) -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color("#0b0d10")
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.75, 0.78, 0.85)
	e.ambient_light_energy = 0.45
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	world.add_child(env)
	for l in [[Vector3(-52, 30, 0), 0.9, true], [Vector3(-30, -150, 0), 0.35, false], [Vector3(-12, 170, 0), 0.45, false]]:
		var d := DirectionalLight3D.new()
		d.rotation_degrees = l[0]
		d.light_energy = l[1]
		d.shadow_enabled = l[2]
		world.add_child(d)
	spot = SpotLight3D.new()
	spot.spot_range = 12.0
	spot.spot_angle = 32.0
	spot.light_energy = 5.0
	spot.shadow_enabled = true
	spot.position = Vector3(0, 6.5, 0)
	spot.rotation_degrees = Vector3(-90, 0, 0)
	world.add_child(spot)
	var mat := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(24, 24)
	mat.mesh = plane
	var sm := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = MAT_SHADER
	sm.shader = sh
	mat.material_override = sm
	world.add_child(mat)
	cam = Camera3D.new()
	cam.fov = 40.0
	cam.near = 0.05
	world.add_child(cam)
	cam.current = true


## The browser's two women in their colours; pure: no IK, no grip modifiers, no push-out.
func _cast(world: Node3D) -> void:
	var legs: Array = []
	for i in 2:
		var b := MH.load_fighter(Browser.BODIES[i])
		world.add_child(b)
		MH.colour_trunks(b, Browser.TRUNKS[i])
		Kit.colour_vest(b, Browser.TOPS[i], 0.8)
		Browser._mma_trim(b, (Browser.TRUNKS[i] as Color).darkened(Browser.TRIM_DARKEN))
		var skel := b.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var pose: Node = Pose.attach(skel)
		pose.set("ik", false)
		poses.append(pose)
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
	player = Player.new()
	player.set("contact", false)
	player.set("paused", true)   # the theatre's clock drives it (seek), never its own _process
	world.add_child(player)
	player.men = poses
	player.scale = Player.pair_scale(legs)


## Build the chain's reel, lay it on the women, plan the director's shots, reset the clock.
func load_chain(id: String) -> void:
	var c := Chains.chain(id)
	if c.is_empty():
		return
	chain_id = id
	reel = Chains.reel(db, c)
	player.play({"frames": reel["frames"]}, poses, player.scale, Transform3D.IDENTITY)
	var kt: PackedFloat32Array = player.key_times()
	steps = []
	for s in reel["steps"]:
		var row: Dictionary = (s as Dictionary).duplicate()
		row["t0"] = PRE_S + kt[int(s["k0"])]
		row["t1"] = PRE_S + kt[int(s["k1"])]
		steps.append(row)
	joins = []
	for j in reel["joins"]:
		joins.append(PRE_S + kt[int(j["k"])])
	total = PRE_S + float(player.length_s()) + POST_S
	director.plan(sample, steps, total)
	_strip.setup(steps, joins, total)
	TUI.mark_card(_cards["buttons"], id)
	_shown_step = -2
	clock = 0.0
	set_playing(true)
	apply()


## Both women's joints (world) at theatre time t - the director's sampler.
func sample(t: float) -> Array:
	return player.joints_at(clampf(t - PRE_S, 0.0, float(player.length_s())))


func step_index(t: float) -> int:
	for i in range(steps.size() - 1, -1, -1):
		if t >= float(steps[i]["t0"]):
			return i
	return -1


func _process(delta: float) -> void:
	if steps.is_empty():
		return
	if playing:
		clock += delta * speed
		if clock >= total:
			if loop:
				clock = 0.0
			else:
				clock = total
				set_playing(false)
	apply()


## Everything on screen at the clock: the women, the camera, the spot, the caption, the strip, the clock text.
func apply() -> void:
	player.seek(clampf(clock - PRE_S, 0.0, float(player.length_s())))
	var ctr := director.centre_smooth(clock)
	if orbit:
		var look := ctr
		var ry := deg_to_rad(_orbit_yaw)
		var rp := deg_to_rad(_orbit_pitch)
		cam.fov = 40.0
		cam.look_at_from_position(look + Vector3(sin(ry) * cos(rp), sin(rp), cos(ry) * cos(rp)) * _orbit_dist, look, Vector3.UP)
	else:
		var c := director.cam_at(clock)
		var look: Vector3 = c["look"]
		cam.fov = float(c["fov"])
		# The overhead sits 0.55 m off the vertical (TheatreDirector._pose), so UP stays a valid up vector.
		cam.look_at_from_position(c["pos"], look, Vector3.UP)
	spot.position = Vector3(ctr.x, 6.5, ctr.z)
	var i := step_index(clock)
	_strip.set_now(clock, i)
	if i != _shown_step:
		_shown_step = i
		_show_caption(i)
	if not film:
		(_ctl["clock"] as Label).text = "%5.1f / %.1f s" % [clock, total]


func _show_caption(i: int) -> void:
	var c := Chains.chain(chain_id)
	if i < 0:
		_caption["kicker"].text = "%d MOVES" % steps.size()
		_caption["name"].text = str(c["title"])
		_caption["line"].text = str(c["sub"]).capitalize()
	else:
		_caption["kicker"].text = "MOVE %d OF %d  -  %s" % [i + 1, steps.size(), str(c["title"]).to_upper()]
		_caption["name"].text = str(steps[i]["name"])
		_caption["line"].text = str(steps[i]["line"])
	var box: Control = _caption["box"]
	box.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(box, "modulate:a", 1.0, 0.35)


## ---------- controls ----------

func seek(t: float) -> void:
	clock = clampf(t, 0.0, total)
	apply()


func set_playing(on: bool) -> void:
	playing = on
	if not _ctl.is_empty():
		(_ctl["play"] as Button).text = "Pause" if on else "Play"
		TUI.style(_ctl["play"], on)


func set_speed(s: float) -> void:
	speed = s
	for k in _ctl["speeds"]:
		TUI.style(_ctl["speeds"][k], is_equal_approx(float(k), s))


func set_loop(on: bool) -> void:
	loop = on
	TUI.style(_ctl["loop"], on)


## To the start of the next / previous move (its join); back again from inside a move goes to its own start first.
func step_move(dir: int) -> void:
	if dir > 0:
		for s in steps:
			if float(s["t0"]) > clock + 0.05:
				seek(float(s["t0"]))
				return
		seek(total)
	else:
		for k in range(steps.size() - 1, -1, -1):
			if float(steps[k]["t0"]) < clock - 0.3:
				seek(float(steps[k]["t0"]))
				return
		seek(0.0)


func set_orbit(on: bool) -> void:
	orbit = on
	if on:
		var c := director.cam_at(clock)
		var d: Vector3 = (c["pos"] as Vector3) - (c["look"] as Vector3)
		_orbit_dist = clampf(d.length(), 1.2, 9.0)
		_orbit_yaw = rad_to_deg(atan2(d.x, d.z))
		_orbit_pitch = clampf(rad_to_deg(asin(d.normalized().y)), 3.0, 85.0)
	_pad.mouse_filter = Control.MOUSE_FILTER_STOP if on else Control.MOUSE_FILTER_IGNORE
	_hint.visible = on and not film
	if not _top.is_empty():
		(_top["mode"] as Button).text = "Free orbit" if on else "Director"
	if not steps.is_empty():
		apply()


func _orbit_input(event: InputEvent) -> void:
	if not orbit:
		return
	if event is InputEventMouseMotion and ((event as InputEventMouseMotion).button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		var r: Vector2 = (event as InputEventMouseMotion).relative
		_orbit_yaw -= r.x * 0.35
		_orbit_pitch = clampf(_orbit_pitch + r.y * 0.25, 3.0, 85.0)
	elif event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		var b := (event as InputEventMouseButton).button_index
		if b == MOUSE_BUTTON_WHEEL_UP:
			_orbit_dist = maxf(1.2, _orbit_dist * 0.9)
		elif b == MOUSE_BUTTON_WHEEL_DOWN:
			_orbit_dist = minf(9.0, _orbit_dist * 1.1)
	apply()


func _unhandled_key_input(event: InputEvent) -> void:
	var k := event as InputEventKey
	if k == null or not k.pressed or k.echo:
		return
	match k.keycode:
		KEY_SPACE:
			set_playing(not playing)
		KEY_RIGHT:
			step_move(1)
		KEY_LEFT:
			step_move(-1)
		KEY_O:
			set_orbit(not orbit)
		KEY_L:
			set_loop(not loop)
