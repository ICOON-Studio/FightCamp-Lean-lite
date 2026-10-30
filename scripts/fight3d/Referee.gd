extends Node3D
## S313 real-fight gap 4: the referee. An amateur referee keeps off the boxers' line, a little over a metre out, and
## moves with them; when they clinch he steps in, calls "Break!" and parts them with both hands (af_push), then steps
## back out. A staff body (the cutman's: amateur bouts have none) in a white shirt and black shorts (the staff bodies
## have no trousers). He stands on the far side from the camera so he never covers the boxers. Between rounds (the
## stage in scene mode) he waits in a neutral corner.
##   build(stage) -> Referee   step_in()   part()

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const CornerIK := preload("res://scripts/fight3d/CornerIK.gd")

const BODY := "res://assets/models/metahuman/mh_staff_cutman_1.glb"
const SHIRT := Color(0.93, 0.93, 0.9)
const SHORTS := Color(0.06, 0.06, 0.07)
## Off the line between the boxers, metres from their middle; close by while they hold (an arm's length off, never in
## the clinch); in to part them.
const WATCH_M := 1.25
const NEAR_M := 0.85
const IN_M := 0.45
const SLIDE_S := 0.25
const ALONG_M := 0.6
## He walks to his spot once it is this far away.
const SLACK_M := 0.45
## af_walk's ground speed at 1x (CornerCrew.WALK_MS); stepping in he hurries.
const WALK_MS := 0.92
const HURRY := 1.5
const PUSH_S := 0.9
const TURN_S := 0.15
const EDGE_IN_M := 0.4

var stage: Node3D
var body: Node3D
var ap: AnimationPlayer
var _mode := "watch"      # watch | in | part
var _part_left := 0.0
var _side := 1.0          # which side of the line he keeps (away from the camera)


static func build(s: Node3D) -> Node3D:
	var r := new()
	r.name = "Referee"
	s.add_child(r)
	r.stage = s
	r.body = MH.load_fighter(BODY)
	r.add_child(r.body)
	var skel := r.body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	r.ap = r.body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(r.ap, skel, true)
	for c in ["af_walk", "af_idle"]:
		if r.ap.has_animation(c):
			r.ap.get_animation(c).loop_mode = Animation.LOOP_LINEAR
	FighterKit._dress_metahuman(r.body, skel, load(FighterKit.BOOT_PATH))
	FighterKit.colour_vest(r.body, SHIRT, 0.8)
	_paint(r.body, "Staff_Shorts", SHORTS)
	CornerIK.attach(skel, r.body)
	r.body.position = r._spot(WATCH_M)
	r._play("af_idle")
	s.set("referee", r)
	return r


## A clinch: he steps in on them.
func step_in() -> void:
	_mode = "in"


## The break: both hands between them, then back out.
func part() -> void:
	_mode = "part"
	_part_left = PUSH_S
	_face(_mid(), 1.0)
	_play("af_push", 1.2)


func _process(delta: float) -> void:
	if stage == null or stage.boxers.size() < 2:
		return
	if bool(stage.get("scene")):
		_walk_to(_neutral(), WALK_MS, delta)
		return
	match _mode:
		"part":
			_part_left -= delta
			# He leans in with the push (no walk cycle under it).
			body.position = body.position.lerp(_spot(IN_M, 0.0), 1.0 - exp(-delta / SLIDE_S))
			if _part_left <= 0.0:
				_mode = "watch"
		"in":
			_walk_to(_spot(NEAR_M), WALK_MS * HURRY, delta, 0.08)
		_:
			var to := _spot(WATCH_M)
			if body.position.distance_to(to) > SLACK_M or str(ap.current_animation) == "af_walk":
				_walk_to(to, WALK_MS, delta, 0.1)
			else:
				if str(ap.current_animation) == "":
					_play("af_idle")
				_face(_mid(), delta)


func _mid() -> Vector3:
	var m: Vector3 = ((stage.boxers[0]["pos"] as Vector3) + (stage.boxers[1]["pos"] as Vector3)) * 0.5
	return Vector3(m.x, 0.0, m.z)


## `out` metres off the boxers' line, on the side away from the camera, inside the ropes.
func _spot(out: float, along_m: float = ALONG_M) -> Vector3:
	var a: Vector3 = stage.boxers[0]["pos"]
	var b: Vector3 = stage.boxers[1]["pos"]
	var line := Vector3(b.x - a.x, 0, b.z - a.z)
	var perp := Vector3.UP.cross(line.normalized()) if line.length() > 0.01 else Vector3.RIGHT
	var cam: Camera3D = stage.get("camera")
	if cam != null and _mode == "watch":
		_side = -1.0 if perp.dot(cam.global_position - _mid()) > 0.0 else 1.0
	# At an angle (not for the push, which goes square between them), not square behind them: from the side camera he shows beside the pair, never between their heads.
	var along := line.normalized() * along_m if line.length() > 0.01 else Vector3.ZERO
	var p := _mid() + perp * out * _side + along
	var edge: float = float(stage.RING_M) * 0.5 - EDGE_IN_M
	return Vector3(clampf(p.x, -edge, edge), 0.0, clampf(p.z, -edge, edge))


## The neutral corner farther from the camera.
func _neutral() -> Vector3:
	var h: float = float(stage.RING_M) * 0.5 - 0.6
	var c1 := Vector3(-h, 0, h)
	var c2 := Vector3(h, 0, -h)
	var cam: Camera3D = stage.get("camera")
	if cam == null:
		return c1
	return c1 if c1.distance_to(cam.global_position) > c2.distance_to(cam.global_position) else c2


func _walk_to(to: Vector3, speed: float, delta: float, stop_m: float = 0.05) -> void:
	var at := body.position
	var d := Vector3(to.x - at.x, 0, to.z - at.z)
	if d.length() <= maxf(stop_m, speed * delta):
		if str(ap.current_animation) == "af_walk":
			_play("af_idle")
		_face(_mid(), delta)
		return
	if str(ap.current_animation) != "af_walk":
		_play("af_walk", speed / WALK_MS)
	body.position = at + d.normalized() * speed * delta
	body.rotation.y = lerp_angle(body.rotation.y, atan2(d.x, d.z), 1.0 - exp(-delta / TURN_S))


func _face(to: Vector3, delta: float) -> void:
	var d := to - body.position
	if d.length() > 0.05:
		body.rotation.y = lerp_angle(body.rotation.y, atan2(d.x, d.z), 1.0 - exp(-delta / TURN_S))


func _play(clip: String, speed: float = 1.0) -> void:
	if ap.has_animation(clip):
		ap.play(clip, 0.25, speed)


static func _paint(node: Node3D, surface: String, colour: Color) -> void:
	for m in node.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			if src != null and src.resource_name.begins_with(surface):
				var mat := StandardMaterial3D.new()
				mat.albedo_color = colour
				mat.roughness = 0.8
				mi.set_surface_override_material(s, mat)
