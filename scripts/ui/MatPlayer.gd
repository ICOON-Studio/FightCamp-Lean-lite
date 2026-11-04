extends SubViewportContainer
## S375 the Playbook's mat (operator: "use the bjj video for training, that was showing the moves on the right side"):
## two of our women on a grey mat, a GrappleMap move (BjjFilm) played on them on a loop with a slow orbit - the ground
## browser's own room, cast and player (GrappleBrowser), sized for the Playbook's right column.
##   var m := MatPlayer.new(); m.bodies = [her_glb, partner_glb]; add it; m.play_move(syllabus_id) -> false when unfilmed
## S376 BJJCOACH1 (CoachSteps beside it): play_step(t0, t1) plays one coach step and holds where it ends; set_paused,
## set_speed (0.5x / 1x); time() / key_times() say where the film is. The orbit keeps turning on a hold.
## S382 MOVETIP1 round 2 (skeptic: the hover card's second mat put its pair into the ROOT World3D beside the Playbook's -
## four bodies in both clips, still there after the card hid): the viewport owns its World3D, as MovePlayer's always did.
## `studio` (the hover card): an off-white floor, the camera ~35 deg above, soft shadows.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const Grip := preload("res://scripts/grapple/GrappleGrip.gd")
const BjjFilm := preload("res://scripts/rules/BjjFilm.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")

const TOPS := [Color("#ff6a5c"), Color("#5b93ff")]
const TRUNKS := [Color("#e2483d"), Color("#2f6fdb")]
const ORBIT_DEG_S := 9.0
const HOLD_S := 0.8   # the pause on the landing before the move plays again
const MAT_BG := Color("#f1eee8")
const MAT_FLOOR := Color("#ebe7df")
const HOLD_IN_S := 0.01   # a held step stops this far inside its end, so it stays the step on screen

static var _db: Array = []

var bodies: Array = []
var studio := false
var player: Node
var cam: Camera3D
var _seq := -1
var _yaw := 35.0
var _look := Vector3(0, 0.4, 0)
var _hold := 0.0
var _stop_at := -1.0   # a coach step plays to here, then holds


static func db() -> Array:
	if _db.is_empty():
		_db = DB.load_db()
	return _db


func _ready() -> void:
	stretch = true
	var vp := SubViewport.new()
	vp.msaa_3d = Viewport.MSAA_4X
	vp.own_world_3d = true   # its bodies live in its own world, never in the root's (S382)
	add_child(vp)
	var world := Node3D.new()
	vp.add_child(world)
	_room(world)
	_cast(world)


## Plays this syllabus move on a loop; false when GrappleMap has no sequence for it.
func play_move(id: String) -> bool:
	var i := BjjFilm.find(db(), id)
	if i < 0 or player == null:
		return false
	_seq = i
	_hold = 0.0
	_stop_at = -1.0
	player.paused = false
	player.play(db()[i], player.men, player.scale, Transform3D.IDENTITY)
	return true


## One coach step: from t0 to t1 at the set speed, then hold just inside its end (the step stays lit).
func play_step(t0: float, t1: float) -> void:
	if player == null:
		return
	_hold = 0.0
	_stop_at = maxf(t0, t1 - HOLD_IN_S)
	player.paused = false
	player.seek(t0)


func set_paused(p: bool) -> void:
	if player != null:
		player.paused = p
		_stop_at = -1.0


func set_speed(s: float) -> void:
	if player != null:
		player.speed = s


func paused() -> bool:
	return player != null and player.paused


func time() -> float:
	return player.t() if player != null else 0.0


func key_times() -> PackedFloat32Array:
	return player.key_times() if player != null else PackedFloat32Array([0.0])


func _process(delta: float) -> void:
	if player == null or player.seq.is_empty():
		return
	if _stop_at >= 0.0 and player.t() >= _stop_at:
		player.seek(_stop_at)
		player.paused = true
		_stop_at = -1.0
	if _seq >= 0 and player.done() and not player.paused:
		_hold += delta
		if _hold >= HOLD_S:
			_hold = 0.0
			player.play(db()[_seq], player.men, player.scale, Transform3D.IDENTITY)
	if cam == null:
		return
	_yaw += ORBIT_DEG_S * delta
	var js: Array = player.joints_at(player.t())
	var lo := Vector3.INF
	var hi := -Vector3.INF
	for p in js:
		for v in (p as PackedVector3Array):
			lo = lo.min(v)
			hi = hi.max(v)
	_look = _look.lerp((lo + hi) * 0.5, minf(1.0, delta * 3.0))
	var r := maxf((hi - lo).length() * 0.5, 0.9)
	var dist := r / tan(deg_to_rad(cam.fov * 0.5)) * (0.72 if studio else 0.85)   # S375 closer than the browser: a small panel
	var up := Vector3(0, 0.70, 1.0) if studio else Vector3(0, 0.42, 0.9)   # studio: ~35 deg above
	cam.position = _look + Basis(Vector3.UP, deg_to_rad(_yaw)) * up.normalized() * dist
	cam.look_at(_look, Vector3.UP)


func _cast(world: Node3D) -> void:
	var poses: Array = []
	var legs: Array = []
	var skels: Array = []
	for i in 2:
		var b := MH.load_fighter(str(bodies[i]))
		world.add_child(b)
		MH.colour_trunks(b, TRUNKS[i])
		Kit.colour_vest(b, TOPS[i], 0.8)
		var skel := b.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		skels.append(skel)
		poses.append(Pose.attach(skel))
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
	player = Player.new()
	world.add_child(player)
	player.men = poses
	player.scale = Player.pair_scale(legs)
	for i in 2:
		Grip.attach(skels[i], poses[i], poses[1 - i])
	var start := DB.find(db(), "mount")
	if not start.is_empty():
		player.play(start, player.men, player.scale, Transform3D.IDENTITY)


func _room(world: Node3D) -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = MAT_BG if studio else Color("#dfe7ec")
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
	if studio:
		sun.rotation_degrees = Vector3(-70, 35, 0)   # high: short, soft shadows under the bodies
		sun.shadow_blur = 2.5
		sun.light_energy = 1.1
	world.add_child(sun)
	var mat := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40) if studio else Vector2(10, 10)
	mat.mesh = plane
	var m := StandardMaterial3D.new()
	m.albedo_color = MAT_FLOOR if studio else Color("#9da3a8")
	m.roughness = 0.9
	mat.material_override = m
	world.add_child(mat)
	cam = Camera3D.new()
	cam.fov = 38.0
	world.add_child(cam)
	cam.current = true
