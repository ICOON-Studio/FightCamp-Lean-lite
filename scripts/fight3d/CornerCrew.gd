extends Node3D
## S307 the corner teams and the corner's things (docs/FIGHT_NIGHT_SCRIPT.md v2): the old project's clothed MetaHuman
## staff - her coach, the second and, in a pro bout, the cutman; the other corner's coach and second - the stools, buckets,
## the water bottle and the ice pack (basic shapes), and the moves the scene needs on any body: walk (the body moves at
## the walk clip's own ground speed), turn, sit down and stand up (the ActionForge sit is an in-place take: her feet travel
## 0.48 m forward under her, so her body moves back by exactly the feet's travel and the feet stay put on the canvas).
## Hidden while the boxers fight.
##   build(stage, pro)  corner(side)  place(a, at, yaw)  play(a, clip, speed)  walk(a, to, speed, done)  turn(a, yaw, done)
##   sit(i, done)  stand(i, done)  hold(prop, a, bone)  set_shown(on)  tick(delta)

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const CornerIK := preload("res://scripts/fight3d/CornerIK.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")

const DIR := "res://assets/models/metahuman/"
const BODIES := {"coach": "mh_staff_coach", "second": "mh_staff_trainer", "cutman": "mh_staff_cutman_1",
	"blue_coach": "mh_staff_coach_2", "blue_second": "mh_staff_trainer"}
const LOOPS := ["af_walk", "af_walk_carry", "af_sit_idle", "af_sit_talk", "af_crouch_idle", "af_talk", "af_idle",
	"af_idle_foldarms", "af_nod_yes"]
## The stool's centre, from the post along the corner's diagonal, metres (her back a hand from the corner pad).
const SEAT_IN_M := 0.62
## Seated, her hip joint stands this far above the seat (tools/corner_probe.gd: seated hips 0.54 m on the 169 cm body).
const HIP_OVER_SEAT_M := 0.10
const SEATED_HIPS_M := 0.54
## af_walk's ground speed at 1x on the unscaled body (tools/corner_probe.gd: the standing foot moves back 0.90-0.98 m/s).
const WALK_MS := 0.92
const TURN_S := 0.12
const SIT := ["af_sit_enter", "af_sit_exit"]

var stage: Node3D
var actors := {}            # role -> {node, skel, ap, js: null}
var props := {}             # name -> Node3D
var _walks := {}            # actor node -> {a, to, speed, done}
var _turns := {}            # actor node -> {a, yaw, done}
var _feet_moves := {}       # actor node -> {a, clip, from, fwd, curve, then}
var _follow: Array = []     # [{prop, a, bone, tip, offset, aim}] a prop held in a hand or riding on a bone
var _curves := {}           # "<boxer i>:<clip>" -> [[t, feet forward m]]


func build(s: Node3D, pro: bool) -> void:
	stage = s
	name = "CornerCrew"
	for role in BODIES:
		if role == "cutman" and not pro:
			continue
		actors[role] = _body(DIR + str(BODIES[role]) + ".glb")
	for i in stage.boxers.size():
		_loops(stage.boxers[i]["ap"])
		stage.boxers[i]["ik"] = CornerIK.attach(stage.boxers[i]["skel"], stage.boxers[i]["node"])
		for clip in SIT:
			_curves["%d:%s" % [i, clip]] = _feet_curve(stage.boxers[i], clip)
		stage.guard(i)
	for side in ["red", "blue"]:
		var c := corner(side)
		props[side + "_stool"] = _stool(c, float(stage.boxers[0 if side == "red" else 1]["node"].scale.x))
		props[side + "_bucket"] = _cyl(0.15, 0.32, Color(0.75, 0.75, 0.78), 0.4)
		props[side + "_bucket"].position = (c["post"] as Vector3) - (c["d"] as Vector3) * 0.42 + Vector3(0, 0.16, 0)
	props["bottle"] = _cyl(0.035, 0.22, Color(0.55, 0.8, 0.95, 0.75), 0.15)
	# An ice bag in a towel, held flat against the back of her neck (thin side front to back).
	props["ice"] = _box(Vector3(0.12, 0.09, 0.03), Color(0.82, 0.88, 0.95), 0.85)
	set_shown(false)


## {post, d (into the ring), l (her left as she sits facing d), seat (xz on the canvas), seat_y} for "red" / "blue".
func corner(side: String) -> Dictionary:
	var half: float = stage.RING_M * 0.5
	var post := Vector3(-half, 0, -half) if side == "red" else Vector3(half, 0, half)
	var d := (-post).normalized()
	var i := 0 if side == "red" else 1
	var sc: float = (stage.boxers[i]["node"] as Node3D).scale.x
	return {"post": post, "d": d, "l": Vector3.UP.cross(d).normalized(), "seat": post + d * SEAT_IN_M,
		"seat_y": (SEATED_HIPS_M - HIP_OVER_SEAT_M) * sc}


func set_shown(on: bool) -> void:
	for role in actors:
		var a: Dictionary = actors[role]
		(a["node"] as Node3D).visible = on
		var ap: AnimationPlayer = a["ap"]
		if not on:
			ap.stop()
	for k in props:
		(props[k] as Node3D).visible = on and not (k in ["bottle", "ice"])
	if not on:
		_walks.clear()
		_turns.clear()
		_feet_moves.clear()
		_follow.clear()


func place(a: Dictionary, at: Vector3, yaw: float) -> void:
	var n: Node3D = a["node"]
	n.position = Vector3(at.x, 0.0, at.z)
	n.rotation = Vector3(0, yaw, 0)
	_walks.erase(n)
	_turns.erase(n)
	_feet_moves.erase(n)


## Faces from `at` toward `to` (y ignored).
static func yaw_to(at: Vector3, to: Vector3) -> float:
	return atan2(to.x - at.x, to.z - at.z)


const CROUCH_UPRIGHT_DEG := 55.0


func play(a: Dictionary, clip: String, speed: float = 1.0, from_s: float = 0.0) -> void:
	var ap: AnimationPlayer = a["ap"]
	if not ap.has_animation(clip):
		return
	ap.speed_scale = 1.0
	if a.get("js") != null:
		(a["js"] as Node).join(0.1, 0.4)
		ap.play(clip, 0.0, speed)
	else:
		ap.play(clip, 0.25, speed)
	if from_s > 0.0:
		ap.seek(from_s, true)
	# S310: the crouch clip bends the back near flat; in the corner a crouch is an upright squat (CornerIK.upright).
	if a.get("ik") != null:
		a["ik"].upright(CROUCH_UPRIGHT_DEG if clip == "af_crouch_idle" else 0.0)


## Walks `a` to `to` at the walk clip's ground speed for its size, turning into the way it goes; `done` on arrival.
func walk(a: Dictionary, to: Vector3, done: Callable = Callable(), carry: bool = false) -> void:
	var n: Node3D = a["node"]
	_turns.erase(n)
	play(a, "af_walk_carry" if carry else "af_walk")
	var speed := WALK_MS * (0.68 if carry else 1.0) * n.scale.x
	_walks[n] = {"a": a, "to": Vector3(to.x, 0, to.z), "speed": speed, "done": done}


func turn(a: Dictionary, yaw: float, done: Callable = Callable()) -> void:
	var n: Node3D = a["node"]
	_turns[n] = {"a": a, "yaw": yaw, "done": done}


## Boxer i sits down where she stands (the stool behind her): the sit, then the seated loop.
func sit(i: int, done: Callable = Callable()) -> void:
	_feet_fixed(i, "af_sit_enter", func():
		play(stage.boxers[i], "af_sit_idle")
		if done.is_valid():
			done.call())


## Boxer i stands up off the stool (her body comes forward over her feet).
func stand(i: int, done: Callable = Callable()) -> void:
	_feet_fixed(i, "af_sit_exit", func():
		play(stage.boxers[i], "af_idle")
		if done.is_valid():
			done.call())


## Where boxer i stands before she sits, so that seated her hips are over the seat (her back to the post).
func sit_spot(i: int, c: Dictionary) -> Vector3:
	var curve: Array = _curves.get("%d:af_sit_enter" % i, [[0.0, 0.0]])
	return (c["seat"] as Vector3) + (c["d"] as Vector3) * float(curve[-1][1]) * (stage.boxers[i]["node"] as Node3D).scale.x


## `prop` follows `a`'s hand: centred between the hand and its middle finger's base; `aim` (a world point) tips its top
## toward it (the bottle toward her lips).
func hold(prop: String, a: Dictionary, hand: String = "Left", aim: Callable = Callable()) -> void:
	_add_follow({"prop": props[prop], "a": a, "bone": hand + "Hand", "tip": hand + "MiddleProximal", "aim": aim})


## `prop` rides on `a`'s `bone`, `offset` metres in a frame turned with her (x her left, z forward) and leaning with the
## line from the bone to the head (y).
func hold_at(prop: String, a: Dictionary, bone: String, offset: Vector3) -> void:
	_add_follow({"prop": props[prop], "a": a, "bone": bone, "tip": "", "offset": offset})


## Props follow the pose the viewer sees: after the skeleton's modifiers (the hand IK), like the gloves (Gloves.gd).
func _add_follow(f: Dictionary) -> void:
	var p: Node3D = f["prop"]
	p.visible = true
	_follow = _follow.filter(func(x): return x["prop"] != p)
	_follow.append(f)
	var skel: Skeleton3D = f["a"]["skel"]
	if not skel.has_meta("corner_follow"):
		skel.set_meta("corner_follow", true)
		skel.skeleton_updated.connect(_follow_props.bind(skel))


## `a` looks at `b`'s face (null: back to the clip).
func look(a: Dictionary, b: Variant) -> void:
	if a.get("ik") == null:
		return
	if b == null:
		a["ik"].look(null)
		return
	var other: Dictionary = b
	a["ik"].look(func(): return face(other))


## A face's point in the world: in front of the head bone, at the eyes.
static func face(a: Dictionary) -> Vector3:
	var skel: Skeleton3D = a["skel"]
	var n: Node3D = a["node"]
	var head := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	var ik: Object = a.get("ik")
	if ik != null and ik.head_world != Vector3.INF:
		head = ik.head_world   # S309: the head as shown (a look moves it)
	return head + n.global_transform.basis.z.normalized() * 0.09 * n.scale.x + Vector3.UP * 0.04 * n.scale.x


func drop(prop: String) -> void:
	var p: Node3D = props[prop]
	p.visible = false
	_follow = _follow.filter(func(f): return f["prop"] != p)


func tick(delta: float) -> void:
	for n in _walks.keys():
		var w: Dictionary = _walks[n]
		var to: Vector3 = w["to"]
		var at: Vector3 = (n as Node3D).position
		var dist := Vector2(to.x - at.x, to.z - at.z).length()
		var stride := float(w["speed"]) * delta
		if dist <= stride:
			(n as Node3D).position = to
			_walks.erase(n)
			# Arrived: she stops walking (the walk cycle would march on the spot through the turn).
			play(w["a"], "af_idle")
			if (w["done"] as Callable).is_valid():
				(w["done"] as Callable).call()
			continue
		var dir := Vector3(to.x - at.x, 0, to.z - at.z) / dist
		(n as Node3D).position = at + dir * stride
		_ease_yaw(n, atan2(dir.x, dir.z), delta)
	for n in _turns.keys():
		var tw: Dictionary = _turns[n]
		_ease_yaw(n, float(tw["yaw"]), delta)
		if absf(angle_difference((n as Node3D).rotation.y, float(tw["yaw"]))) < 0.02:
			(n as Node3D).rotation.y = float(tw["yaw"])
			_turns.erase(n)
			if (tw["done"] as Callable).is_valid():
				(tw["done"] as Callable).call()
	for n in _feet_moves.keys():
		var fm: Dictionary = _feet_moves[n]
		var ap: AnimationPlayer = fm["a"]["ap"]
		var t := ap.current_animation_position if str(ap.current_animation) == str(fm["clip"]) else 99.0
		(n as Node3D).position = (fm["from"] as Vector3) - (fm["fwd"] as Vector3) * _at(fm["curve"], t) * (n as Node3D).scale.x
		if t >= 99.0:
			_feet_moves.erase(n)
			(fm["then"] as Callable).call()


func _follow_props(skel: Skeleton3D) -> void:
	for f in _follow:
		if f["a"]["skel"] != skel:
			continue
		var at := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(str(f["bone"]))).origin
		var p: Node3D = f["prop"]
		if str(f["tip"]) == "":
			# Rides on the bone, turned with the line from it to the next bone up (the neck's lean), offset in that frame.
			var n: Node3D = f["a"]["node"]
			var up_to := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(str(f.get("up_bone", "Head")))).origin
			var y := (up_to - at).normalized()
			var z := n.global_transform.basis.z.normalized()
			var x := y.cross(z).normalized()
			z = x.cross(y).normalized()
			var basis := Basis(x, y, z)
			p.global_transform = Transform3D(basis, at + basis * (f["offset"] as Vector3) * n.scale.x)
			continue
		var tip := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(str(f["tip"]))).origin
		p.global_position = at.lerp(tip, 0.6)
		var aim: Callable = f.get("aim", Callable())
		if aim.is_valid():
			var to: Vector3 = (aim.call() as Vector3) - p.global_position
			if to.length() > 0.02 and absf(to.normalized().dot(Vector3.UP)) < 0.99:
				p.look_at(p.global_position + to, Vector3.UP)
				p.rotate_object_local(Vector3.RIGHT, -PI * 0.5)


func _ease_yaw(n: Node3D, yaw: float, delta: float) -> void:
	n.rotation.y = lerp_angle(n.rotation.y, yaw, 1.0 - exp(-delta / TURN_S))


## Plays `clip` on boxer i while her body moves against her feet's own travel in it (sampled at build), so they stay put.
func _feet_fixed(i: int, clip: String, then: Callable) -> void:
	var a: Dictionary = stage.boxers[i]
	var n: Node3D = a["node"]
	_walks.erase(n)
	_turns.erase(n)
	play(a, clip)
	_feet_moves[n] = {"a": a, "clip": clip, "from": n.position, "fwd": n.transform.basis.z.normalized(),
		"curve": _curves.get("%d:%s" % [i, clip], [[0.0, 0.0]]), "then": then}


## [[t, metres]]: how far forward of where they started her two feet stand (their mean), through the clip.
func _feet_curve(bx: Dictionary, clip: String) -> Array:
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip):
		return [[0.0, 0.0]]
	var length := ap.get_animation(clip).length
	var out: Array = []
	var z0 := 0.0
	for k in 21:
		var t := length * float(k) / 20.0
		var z := (IdleMatch.pose_point(bx, clip, t, "LeftFoot").z + IdleMatch.pose_point(bx, clip, t, "RightFoot").z) * 0.5
		if k == 0:
			z0 = z
		out.append([t, z - z0])
	return out


static func _at(curve: Array, t: float) -> float:
	if t >= float(curve[-1][0]):
		return float(curve[-1][1])
	for k in range(1, curve.size()):
		if t <= float(curve[k][0]):
			var t0 := float(curve[k - 1][0])
			var u := (t - t0) / maxf(0.0001, float(curve[k][0]) - t0)
			return lerpf(float(curve[k - 1][1]), float(curve[k][1]), u)
	return 0.0


func _body(glb: String) -> Dictionary:
	var body := MH.load_fighter(glb)
	add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(ap, skel, true)
	_loops(ap)
	# The staff bodies come barefoot: the boxers' black boots, fitted to their feet, read as shoes.
	FighterKit._dress_metahuman(body, skel, load(FighterKit.BOOT_PATH))
	return {"node": body, "skel": skel, "ap": ap, "js": null, "ik": CornerIK.attach(skel, body)}


func _loops(ap: AnimationPlayer) -> void:
	for c in LOOPS:
		if ap.has_animation(c):
			ap.get_animation(c).loop_mode = Animation.LOOP_LINEAR


## A corner stool: a square wooden seat on four splayed metal legs, seat top at the height her hips need.
func _stool(c: Dictionary, _scale: float) -> Node3D:
	var root := Node3D.new()
	add_child(root)
	root.position = c["seat"]
	root.rotation.y = yaw_to(Vector3.ZERO, c["d"])
	var top := float(c["seat_y"])
	var seat := _box(Vector3(0.36, 0.035, 0.32), Color(0.35, 0.22, 0.12), 0.7)
	seat.reparent(root, false)
	seat.position = Vector3(0, top - 0.018, 0)
	for x in [-0.14, 0.14]:
		for z in [-0.12, 0.12]:
			var leg := _cyl(0.014, top, Color(0.25, 0.25, 0.27), 0.35)
			leg.reparent(root, false)
			leg.position = Vector3(x * 1.1, top * 0.5, z * 1.1)
	return root


func _box(size: Vector3, colour: Color, rough: float) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	m.mesh = bm
	m.material_override = _mat(colour, rough)
	add_child(m)
	return m


func _cyl(r: float, h: float, colour: Color, rough: float) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = r
	cm.bottom_radius = r
	cm.height = h
	m.mesh = cm
	m.material_override = _mat(colour, rough)
	add_child(m)
	return m


static func _mat(colour: Color, rough: float) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = colour
	mat.roughness = rough
	if colour.a < 1.0:
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return mat
