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
const PINNED_M := 0.3
## S322 (burn_probe still, round 3: pinned by the ropes he stood pressed to a boxer's back - 0.55 from her hips lets
## the bodies touch on screen): 0.8.
const KEEP_M := 0.8
const KEEP_PUSH_M := 0.42
## He walks to his spot once it is this far away.
const SLACK_M := 0.45
## af_walk's ground speed at 1x (CornerCrew.WALK_MS); stepping in he hurries.
const WALK_MS := 0.92
const HURRY := 1.5
const PUSH_S := 0.9
const TURN_S := 0.15
const EDGE_IN_M := 0.4
## S323 (update 25 exe still: 1.25 m behind the line, centred, he stood BETWEEN their heads on screen - ref_probe only
## measured the ground): his spot is picked on the SCREEN. Candidates along the line (metres from their middle; BEYOND =
## past a boxer's back by that much), scored: off the gap between their heads on screen first, then room inside the
## ropes, then the least move from where he stands.
const ALONG_TRY := [0.6, -0.6]
const BEYOND_TRY := [0.9, 1.4, 2.0]
## Crossing to the other end of their line walks him behind them, through the gap on screen (S323 ref_probe: 1059 of the
## 1143 between-frames were him walking across): he keeps his end unless it has no clear spot.
const SWITCH_COST := 60.0
## Screen pixels each side of the two heads that count as "between them"; his head height (metres).
const SCREEN_GAP_PX := 70.0
const HEAD_Y_M := 1.65
## S348 (operator C200 on the round-1 still: the referee stood a metre from the lens and filled a quarter of the screen,
## the body view drawn over him): since S347 the camera stands inside the ropes, so he keeps this far from it on the canvas
## and his spot is picked away from it.
const LENS_KEEP_M := 2.2
static var lens_keep := true   # tools/ref_probe.gd `-- nolens` = the control arm (S347 behaviour)

var stage: Node3D
var body: Node3D
var ap: AnimationPlayer
var _mode := "watch"      # watch | in | part
var _part_left := 0.0
var _side := 1.0          # which side of the line he keeps (away from the camera)
var _along := ALONG_M     # metres along the boxers' line from their middle (picked on screen in watch mode)


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
		_keep_off_lens()
		return
	_move(delta)
	_keep_clear(KEEP_PUSH_M if _mode == "part" else KEEP_M)
	if _mode == "watch":
		_keep_off_lens()


func _move(delta: float) -> void:
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
			# S323: in the gap between their heads on screen he hurries out of it (and never idles there).
			var seen := between_on_screen()
			if seen or body.position.distance_to(to) > SLACK_M or str(ap.current_animation) == "af_walk":
				_walk_to(to, WALK_MS * (HURRY if seen else 1.0), delta, 0.1)
			else:
				if str(ap.current_animation) == "":
					_play("af_idle")
				_face(_mid(), delta)


func _mid() -> Vector3:
	var m: Vector3 = ((stage.boxers[0]["pos"] as Vector3) + (stage.boxers[1]["pos"] as Vector3)) * 0.5
	return Vector3(m.x, 0.0, m.z)


## `out` metres off the boxers' line, on the side away from the camera, inside the ropes; `along_m` 0 = square between
## them (the push), else the spot picked on screen (_pick_along).
func _spot(out: float, along_m: float = ALONG_M) -> Vector3:
	var a: Vector3 = stage.boxers[0]["pos"]
	var b: Vector3 = stage.boxers[1]["pos"]
	var line := Vector3(b.x - a.x, 0, b.z - a.z)
	var perp := Vector3.UP.cross(line.normalized()) if line.length() > 0.01 else Vector3.RIGHT
	var cam: Camera3D = stage.get("camera")
	var dir := line.normalized() if line.length() > 0.01 else Vector3.ZERO
	if cam != null and _mode == "watch":
		_side = -1.0 if perp.dot(cam.global_position - _mid()) > 0.0 else 1.0
		_along = _pick_along(cam, perp * out * _side, dir, line.length() * 0.5)
	var p := _mid() + perp * out * _side + dir * (0.0 if along_m == 0.0 else _along)
	var edge: float = float(stage.RING_M) * 0.5 - EDGE_IN_M
	return Vector3(clampf(p.x, -edge, edge), 0.0, clampf(p.z, -edge, edge))


## The spot along the line (metres from their middle) that keeps him off the gap between their heads ON SCREEN (S313/S314:
## on the far side, sliding beyond a boxer's back when the ropes pin him).
func _pick_along(cam: Camera3D, off: Vector3, dir: Vector3, half: float) -> float:
	var tries: Array = ALONG_TRY.duplicate()
	for k in BEYOND_TRY:
		tries.append(half + float(k))
		tries.append(-half - float(k))
	var h0 := cam.unproject_position(stage.boxers[0]["pos"] + Vector3.UP * HEAD_Y_M).x
	var h1 := cam.unproject_position(stage.boxers[1]["pos"] + Vector3.UP * HEAD_Y_M).x
	var lo := minf(h0, h1) - SCREEN_GAP_PX
	var hi := maxf(h0, h1) + SCREEN_GAP_PX
	var best := _along
	var best_score := INF
	for t in tries:
		var spot := _mid() + off + dir * float(t)
		var sx := cam.unproject_position(spot + Vector3.UP * HEAD_Y_M).x
		var score := absf(float(t) - _along) * 0.2 + _pinned(off + dir * float(t)) * 10.0
		if signf(float(t)) != signf(_along):
			score += SWITCH_COST
		if sx > lo and sx < hi and not cam.is_position_behind(spot):
			score += 100.0
		if lens_keep and Vector2(spot.x - cam.global_position.x, spot.z - cam.global_position.z).length() < LENS_KEEP_M:
			score += 80.0
		if score < best_score:
			best_score = score
			best = float(t)
	return best


## True when his head shows between the two boxers' heads on screen (ref_probe, the S323 screen check).
func between_on_screen() -> bool:
	var cam: Camera3D = stage.get("camera")
	if cam == null:
		return false
	var h0 := cam.unproject_position(stage.boxers[0]["pos"] + Vector3.UP * HEAD_Y_M).x
	var h1 := cam.unproject_position(stage.boxers[1]["pos"] + Vector3.UP * HEAD_Y_M).x
	var sx := cam.unproject_position(body.position + Vector3.UP * HEAD_Y_M).x
	return sx > minf(h0, h1) and sx < maxf(h0, h1)


## How far the ropes would push a spot this offset from the boxers' middle back in.
func _pinned(off: Vector3) -> float:
	var p := _mid() + off
	var edge: float = float(stage.RING_M) * 0.5 - EDGE_IN_M
	return Vector2(p.x - clampf(p.x, -edge, edge), p.z - clampf(p.z, -edge, edge)).length()


## Never inside `keep` metres of a boxer (he steps round them, not through them).
func _keep_clear(keep: float) -> void:
	for bx in stage.boxers:
		var bp: Vector3 = bx["pos"]
		var d := Vector3(body.position.x - bp.x, 0, body.position.z - bp.z)
		if d.length() < keep:
			body.position = Vector3(bp.x, 0, bp.z) + (d.normalized() if d.length() > 0.01 else Vector3.RIGHT) * keep


## Never within LENS_KEEP_M of the camera on the canvas (inside the ropes it would film his shirt): pushed out from the
## lens, kept inside the ropes.
func _keep_off_lens() -> void:
	var cam: Camera3D = stage.get("camera")
	if cam == null or not lens_keep:
		return
	var cp := Vector3(cam.global_position.x, 0, cam.global_position.z)
	var d := Vector3(body.position.x - cp.x, 0, body.position.z - cp.z)
	if d.length() >= LENS_KEEP_M:
		return
	var away := d.normalized() if d.length() > 0.01 else Vector3(-cp.x, 0, -cp.z).normalized()
	var p := cp + away * LENS_KEEP_M
	var edge: float = float(stage.RING_M) * 0.5 - EDGE_IN_M
	body.position = Vector3(clampf(p.x, -edge, edge), 0.0, clampf(p.z, -edge, edge))


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
