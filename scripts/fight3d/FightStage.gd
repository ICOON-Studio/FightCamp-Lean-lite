extends Node3D
## The 3D ring: two MetaHuman boxers (gloves, boots, singlet and trunks in the corner's colour), the ropes, the lights and the
## broadcast camera. It shows moves; it never decides anything (the bout is settled in Bouts before anyone watches).
## Every boxer always plays a clip: the moving guard (the old game's active guard, baked) under everything, punches, slips,
## hit reactions and footwork on top. A body only moves across the canvas while its feet step (a footwork clip, at that
## clip's measured stride speed), so nobody floats or slides.
##   setup(a, b)  a/b = {"glb": res path, "corner": "red"|"blue"}
##   play(who, move)  a punch or a defence; react(who, kind) "head"|"body"|"hurt"; step(who, dir); circle(dir, s)

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const ElbowClear := preload("res://scripts/fight3d/ElbowClear.gd")
const JoinSmoother := preload("res://scripts/fight3d/JoinSmoother.gd")
const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const HitSnap := preload("res://scripts/fight3d/HitSnap.gd")
const GuardTuck := preload("res://scripts/fight3d/GuardTuck.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")
const RingSet := preload("res://scripts/fight3d/RingSet.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const HitStun := preload("res://scripts/fight3d/HitStun.gd")
const SideStep := preload("res://scripts/fight3d/SideStep.gd")
const FootPlant := preload("res://scripts/fight3d/FootPlant.gd")

## Stride speed of each footwork clip at 1x, metres a second, and its direction in the boxer's own frame (old repo U84,
## measured on the source): the body moves exactly this fast while the clip plays, so the planted foot stays planted.
const STRIDE := {"advance": [1.736, 0.0], "retreat": [1.781, 180.0], "strafe_left": [1.705, -90.0], "strafe_right": [1.764, 90.0]}
const CONTACT_S := 8.0 / 30.0
## When the glove lands, seconds into each move (natives frame 8; baked: the old repo's clip_phases contact_s).
const CONTACT := {"jab": CONTACT_S, "cross": CONTACT_S, "lead_hook": CONTACT_S, "body_hook": 0.70, "rear_uppercut": 0.58}
const CLIP_S := 20.0 / 30.0
## The face, from the head bone (the skull's base): forward and up, metres on the unscaled body.
const FACE_FWD_M := 0.09
const FACE_UP_M := 0.07
## S302 impact (operator: "the punches feel like they have no power"; John J-GUARDPACE1: hit-stop 2-3 frames on a jab, 4-6
## on a power punch; the receiver's head snaps). Seconds both bodies hold at contact, head-snap degrees, camera nudge metres.
const HOLD_S := {"jab": 0.05, "power": 0.08, "big": 0.11}
const SNAP_DEG := {"jab": 9.0, "cross": 14.0, "hook": 17.0, "uppercut": 15.0}
const SHAKE_M := {"jab": 0.0, "power": 0.025, "big": 0.06}
## A landed punch whose target sits beyond her straight arm (clip_contact.json short_m, tools/punch_reach.gd): the chest
## lean covers about LEAN_COVER_M, her body carries in for the rest, at most LUNGE_MAX_M, on the reach's ease in/out.
const LEAN_COVER_M := 0.06
const LUNGE_MAX_M := 0.26
const BLEND_S := 0.15
## S305 (operator: "make it more fluid", "doesnt always reset to a default clip"): the return to guard enters the idle loop
## at the point nearest the pose she is in (IdleMatch) and eases in slower than a strike.
const GUARD_FADE_S := 0.2
const GUARD_HALF_LIFE_S := 0.1
const GUARD_JOIN_S := 0.45
const WALK_SCALE := 0.55
const RING_M := 5.5       # inside the ropes (amateur rings are 4.9-6.1 m)
const APRON_M := 0.6
const CORNERS := {"red": [Color(0.62, 0.06, 0.06), Color(0.95, 0.95, 0.92)], "blue": [Color(0.06, 0.16, 0.6), Color(0.95, 0.95, 0.92)]}
## Ludo S299 kit (docs/research/LUDO_KIT_S299.md): bright singlet, white waistband + piping (baked MH_Trim), trunks ~40%
## darker, so singlet / belt line / trunks / gloves read apart at broadcast distance.
const TRUNKS := {"red": Color(0.38, 0.03, 0.03), "blue": Color(0.03, 0.10, 0.35)}
const VESTS := {"red": Color(0.78, 0.08, 0.08), "blue": Color(0.08, 0.28, 0.78)}
const CLOTH_ROUGHNESS := 0.65

var boxers: Array = []      # [{node, skel, ap, gloves, pos: Vector3, vel: Vector3, move_left: float}]
var camera: Camera3D        # RingCamera
var gap_m := 1.0            # pelvis to pelvis, set from the jab's reach
var _ring_side: Array = []    # ropes and posts: hidden while they stand between the camera and the boxers
var _cut: Array = [{}, {}]    # per boxer, the Pro clip playing: {clip, contact, back, fast} (S301 recovery cut)
var _hold_left := 0.0         # S302 hit-stop: both bodies still while > 0
var _held_speed := [1.0, 1.0]
var stun := HitStun.new()     # S305: a hit boxer stays in her reaction (no defence, fidget or step over it)
var life := GuardLife.new()   # S302: each boxer's own guard tempo, fidgets, and a pair step that is not in lockstep
var side := SideStep.new()    # S306: a dodge's step stays taken; a weave steps off the line
## S306: the turn to face her opponent eases over this (a committed side step turned both bodies ~10 degrees in one frame).
const FACE_S := 0.08


func setup(a: Dictionary, b: Dictionary) -> void:
	life.setup(self, 7919)
	var ring := RingSet.new()
	ring.name = "RingSet"
	add_child(ring)
	ring.build(RING_M, APRON_M)
	_ring_side = ring.ring_side
	for spec in [a, b]:
		boxers.append(_boxer(spec))
	gap_m = _jab_gap()
	for bx in boxers:
		bx["idle_match"] = IdleMatch.sample(bx, BeatClips.first(BeatClips.GUARD, (bx["ap"] as AnimationPlayer).has_animation))
	side.setup(self)
	boxers[0]["pos"] = Vector3(0, 0, -gap_m * 0.5)
	boxers[1]["pos"] = Vector3(0, 0, gap_m * 0.5)
	camera = RingCamera.new()
	add_child(camera)
	for i in boxers.size():
		guard(i)
	_compose(0.0)
	broadcast(true)


func has_move(move: String) -> bool:
	return (boxers[0]["ap"] as AnimationPlayer).has_animation(move)


func _boxer(spec: Dictionary) -> Dictionary:
	var body := MH.load_fighter(str(spec["glb"]))
	add_child(body)
	# S300 (operator: "the one fighter look enormous"): each body is scaled to the boxer's own height.
	body.scale = Vector3.ONE * float(spec.get("scale", 1.0))
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var corner := str(spec.get("corner", "red"))
	MH.colour_trunks(body, TRUNKS[corner], CLOTH_ROUGHNESS)
	FighterKit.colour_vest(body, VESTS[corner], CLOTH_ROUGHNESS)
	FighterKit.dress(body, str(spec["glb"]), "boxing")
	# Elbows outside her torso, before the twist bones read the arms.
	var ec := ElbowClear.new()
	ec.name = "ElbowClear"
	if ec.setup(skel):
		skel.add_child(ec)
		skel.move_child(ec, 0)
	else:
		ec.free()
	var gl := Gloves.new()
	gl.name = "Gloves"
	body.add_child(gl)
	gl.mount(body, CORNERS[corner][0], CORNERS[corner][1])
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(ap, skel)
	# S302: a southpaw plays every clip mirrored (lead = right).
	var south := str(spec.get("stance", "")) == "southpaw"
	if south:
		MirrorClip.mirror_library(ap, skel)
	# S301: every clip change goes through the join smoother (first in the stack, so the elbows and twists read its pose).
	var js := JoinSmoother.new()
	js.name = "JoinSmoother"
	# `nojoin` on the command line = the S300 crossfades (the control arm of the S301 joins report).
	if not OS.get_cmdline_user_args().has("nojoin") and js.setup(skel, _track_bones(ap)):
		skel.add_child(js)
		skel.move_child(js, 0)
	else:
		js.free()
		js = null
	# S302: her guard tucks in toward her face and pumps (after the join smoother).
	var gt := GuardTuck.new()
	gt.name = "GuardTuck"
	gt.lead = "RightHand" if south else "LeftHand"
	if gt.setup(skel, ap, body, BeatClips.GUARD + GuardLife.FIDGETS, boxers.size() * 31 + 7):
		skel.add_child(gt)
		skel.move_child(gt, (js.get_index() + 1) if js != null else 0)
	else:
		gt.free()
		gt = null
	# S302: a landed punch reaches the head past the guard (after the guard tuck, before the elbows clear).
	var pr := PunchReach.new()
	pr.name = "PunchReach"
	if pr.setup(skel, ap):
		skel.add_child(pr)
		skel.move_child(pr, (gt.get_index() + 1) if gt != null else ((js.get_index() + 1) if js != null else 0))
	else:
		pr.free()
		pr = null
	var hs := HitSnap.new()
	hs.name = "HitSnap"
	if hs.setup(skel):
		skel.add_child(hs)
		skel.move_child(hs, (pr.get_index() + 1) if pr != null else 0)
	else:
		hs.free()
		hs = null
	# S306: her planted feet stay where they stand; a foot steps when her body has moved off it.
	var fp := FootPlant.attach(skel, ap, null) if not OS.get_cmdline_user_args().has("nofeet") else null
	ap.animation_finished.connect(_on_finished.bind(boxers.size()))
	return {"node": body, "skel": skel, "ap": ap, "gloves": gl, "js": js, "reach": pr, "snap": hs, "feet": fp, "south": south, "front": gl.front_m(),
		"pos": Vector3.ZERO, "vel": Vector3.ZERO, "move_left": 0.0}


## S302: `who` throws `clip` and it LANDS: around contact her glove is carried onto the other's face (ribs if `body`).
func land(who: int, clip: String, body: bool) -> void:
	var pr: Node = boxers[who].get("reach")
	if pr == null:
		return
	var row := BeatClips.contact_row(clip)
	var hand := hand_of(who, str(row.get("hand", "LeftHand" if clip.contains("left_") or clip.contains("jab") else "RightHand")))
	pr.arm(clip, hand, BeatClips.contact(clip, CONTACT_S), target_point.bind(1 - who, body), float(boxers[who]["front"]))
	pr.lunge_m = clampf(float(row.get("short_m", 0.0)) - LEAN_COVER_M, 0.0, LUNGE_MAX_M)


## The hand an orthodox clip names, on boxer i: a southpaw's clips are mirrored, so Left and Right swap.
func hand_of(i: int, orthodox_hand: String) -> String:
	if not bool(boxers[i].get("south", false)):
		return orthodox_hand
	return MirrorClip.counterpart(orthodox_hand)


## Where a landed punch meets boxer i, in world space: her face (in front of the head bone), or her ribs.
func target_point(i: int, body: bool) -> Vector3:
	var skel: Skeleton3D = boxers[i]["skel"]
	var fwd: Vector3 = (boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()
	var s := _scale(i)
	if body:
		var ch := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Chest")).origin
		return ch + (fwd * 0.11 + Vector3.DOWN * 0.14) * s
	var head := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	return head + (fwd * FACE_FWD_M + Vector3.UP * FACE_UP_M) * s


## The striking face of boxer i's glove on `hand` as shown (the glove follows the skeleton after its modifiers).
func glove_front(i: int, hand: String) -> Vector3:
	var g: Node3D = (boxers[i]["gloves"] as Node).gloves.get("l" if hand.begins_with("Left") else "r")
	return g.global_position + g.global_transform.basis.y.normalized() * float(boxers[i]["front"]) * _scale(i)


## The bones the guard, footwork and a punch animate (every clip in the library drives the same set).
func _track_bones(ap: AnimationPlayer) -> Array:
	var out: Array = []
	for clip in ["pro_idle", "idle", "advance", "pro_left_jab", "jab"]:
		if not ap.has_animation(clip):
			continue
		var anim := ap.get_animation(clip)
		for i in anim.get_track_count():
			var bone := str(anim.track_get_path(i).get_concatenated_subnames())
			if bone != "" and not out.has(bone):
				out.append(bone)
	return out


## Starts `clip` on boxer `who` with no crossfade: the join smoother eases from what was shown (S301).
func _start(who: int, clip: String, speed: float, fade: float = BLEND_S) -> void:
	var bx: Dictionary = boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	if bx.get("js") != null:
		# S305: back to the guard eases over the idle's 200-300 ms (research G147); into a strike or a reaction stays quick.
		if fade >= GUARD_FADE_S:
			(bx["js"] as Node).join(GUARD_HALF_LIFE_S, GUARD_JOIN_S)
		else:
			(bx["js"] as Node).join()
		ap.play(clip, 0.0, speed)
	else:
		ap.play(clip, fade, speed)


func _process(delta: float) -> void:
	stun.tick(delta)
	side.tick()
	_recover()
	life.tick(delta)
	_hold(delta)
	_compose(delta)
	if not camera.close:
		broadcast(false, delta)
	camera.nudge(delta)
	camera.clear_view(_ring_side, _mid())


## The hit-stop: both AnimationPlayers stand still (whatever speed a move set is kept and given back after).
func _hold(delta: float) -> void:
	if _hold_left <= 0.0:
		return
	_hold_left -= delta
	for i in boxers.size():
		var ap: AnimationPlayer = boxers[i]["ap"]
		if _hold_left > 0.0:
			if ap.speed_scale != 0.0:
				_held_speed[i] = ap.speed_scale
				ap.speed_scale = 0.0
		elif ap.speed_scale == 0.0:
			ap.speed_scale = _held_speed[i]


## S302: `hitter`'s `move` lands on `who`: her hit reaction starts, both bodies hold for the hit-stop, her head snaps the
## way the glove drove it (not on a body shot), and a power shot nudges the camera.
func hit(who: int, clip: String, speed: float, hitter: int, move: String, big: bool) -> void:
	# S305: fast to its peak, then the clip's own pace back to guard; locked in it until then (HitStun).
	var fast := BeatClips.react_fast(clip, speed)
	stun.clear(who)
	play(who, clip, fast)
	if str((boxers[who]["ap"] as AnimationPlayer).current_animation) == clip:
		var cut := HitStun.react_cut(clip, speed, fast)
		_cut[who] = cut if not cut.is_empty() else _cut[who]
		stun.start(who, clip, speed)
	var kind := "big" if big else ("jab" if move == "jab" else "power")
	_hold_left = float(HOLD_S[kind])
	for i in boxers.size():
		var sc: float = (boxers[i]["ap"] as AnimationPlayer).speed_scale
		if sc != 0.0:
			_held_speed[i] = sc
	camera.shake(float(SHAKE_M[kind]))
	var body := move.contains("body")
	var snap: Node = boxers[who].get("snap")
	if snap == null or body:
		return
	var deg := 9.0
	for key in SNAP_DEG:
		if move.contains(key):
			deg = float(SNAP_DEG[key])
	var hand := hand_of(hitter, "LeftHand" if move in ["jab", "lead_hook", "lead_uppercut"] else "RightHand")
	var skel: Skeleton3D = boxers[hitter]["skel"]
	var shoulder := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(hand.trim_suffix("Hand") + "UpperArm")).origin
	snap.snap(target_point(who, false) - shoulder, deg * (1.5 if big else 1.0))


## Positions: each boxer moves only by her own stepping velocity; both always face each other. The jab gap is kept by
## stepping: while one of them steps, she is held on the gap (her feet are moving, so it reads as part of the step); when
## both stand and the gap is off by more than 5 cm, the nearer-to-centre one takes a short corrective step.
func _compose(delta: float) -> void:
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		if float(bx["move_left"]) > 0.0:
			bx["pos"] = (bx["pos"] as Vector3) + (bx["vel"] as Vector3) * delta
			bx["move_left"] = float(bx["move_left"]) - delta
			if float(bx["move_left"]) <= 0.0:
				bx["vel"] = Vector3.ZERO
				guard(i)
	var a: Vector3 = boxers[0]["pos"]
	var b: Vector3 = boxers[1]["pos"]
	var dist := a.distance_to(b)
	var axis := (b - a).normalized() if dist > 0.01 else Vector3.BACK
	var moving := [float(boxers[0]["move_left"]) > 0.0, float(boxers[1]["move_left"]) > 0.0]
	if moving[0] or moving[1]:
		var err := dist - gap_m
		if moving[0] and moving[1]:
			boxers[0]["pos"] = a + axis * err * 0.5
			boxers[1]["pos"] = b - axis * err * 0.5
		elif moving[0]:
			boxers[0]["pos"] = a + axis * err
		else:
			boxers[1]["pos"] = b - axis * err
	elif absf(dist - gap_m) > 0.05 and delta > 0.0:
		# Only a boxer standing in her guard steps (never mid-punch or mid-reaction); the one farther from centre first.
		var order := [0, 1] if a.length() > b.length() else [1, 0]
		for who in order:
			if str((boxers[who]["ap"] as AnimationPlayer).current_animation) in BeatClips.GUARD:
				var speed := float(STRIDE["advance"][0]) * WALK_SCALE
				_walk(who, "advance" if dist > gap_m else "retreat", minf(0.4, absf(dist - gap_m) / speed))
				break
	a = boxers[0]["pos"]
	b = boxers[1]["pos"]
	var mid := (a + b) * 0.5
	var limit := RING_M * 0.5 - 0.9
	var shift := Vector3(clampf(mid.x, -limit, limit) - mid.x, 0, clampf(mid.z, -limit, limit) - mid.z)
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		bx["pos"] = (bx["pos"] as Vector3) + shift
		var me: Vector3 = bx["pos"]
		var other: Vector3 = boxers[1 - i]["pos"]
		var n: Node3D = bx["node"]
		var to := other - me
		# S302: a landed punch carries her in (shown only; her place on the canvas stays).
		var pr: Node = bx.get("reach")
		n.position = me + (to.normalized() * float(pr.lunge()) if pr != null and to.length() > 0.01 else Vector3.ZERO)
		if to.length() > 0.01:
			var yaw := atan2(to.x, to.z)
			n.rotation = Vector3(0.0, yaw if delta <= 0.0 else lerp_angle(n.rotation.y, yaw, 1.0 - exp(-delta / FACE_S)), 0.0)


## The boxer's own frame: forward toward the other, left = her left.
func _frame(i: int) -> Basis:
	return (boxers[i]["node"] as Node3D).transform.basis


## Her guard between moves: the Punch Pro idle when loaded (every Pro clip starts and ends in it, S300), else the old one.
func guard(who: int) -> void:
	var ap: AnimationPlayer = boxers[who]["ap"]
	var idle := BeatClips.first(BeatClips.GUARD, ap.has_animation)
	ap.speed_scale = 1.0
	if idle != "":
		# S302: her own tempo, from a random point of the loop (both started the same loop in step: 0.92 correlated).
		var g := life.settle(who, idle, ap.get_animation(idle).length)
		var at := IdleMatch.pick(boxers[who], idle, float(g[2]), life.rng)
		_start(who, idle, float(g[1]), GUARD_FADE_S)
		ap.seek(at, true)
	else:
		ap.play("jab")
		ap.seek(0.0, true)
		ap.pause()


## S301: a Pro clip plays its recovery fast (BeatClips.recover_scale, from its measured contact) and hands over to the guard
## the moment it is back in guard, instead of standing on to the end of the take.
func _recover() -> void:
	for who in boxers.size():
		var cut: Dictionary = _cut[who]
		if cut.is_empty():
			continue
		var ap: AnimationPlayer = boxers[who]["ap"]
		if str(ap.current_animation) != str(cut["clip"]):
			_cut[who] = {}
			continue
		var at := ap.current_animation_position
		if not bool(cut["fast"]) and float(cut["contact"]) >= 0.0 and at >= float(cut["contact"]):
			cut["fast"] = true
			ap.speed_scale = float(cut["scale"])
		if float(cut["back"]) > 0.0 and at >= float(cut["back"]):
			_cut[who] = {}
			guard(who)


func _on_finished(_name: StringName, who: int) -> void:
	if float(boxers[who]["move_left"]) <= 0.0:
		guard(who)


## A punch, a defence or a hit reaction, played where she stands at `speed` (BeatClips.speed: Pro clips on shipped timing),
## from `from_s` seconds into the clip (S302: a combo's follow-up starts part-way through its wind-up).
func play(who: int, move: String, speed: float = 1.0, from_s: float = 0.0) -> void:
	var ap: AnimationPlayer = boxers[who]["ap"]
	if stun.blocks(who, move):
		return
	if not ap.has_animation(move):
		move = {"body_hook": "lead_hook", "rear_uppercut": "cross", "slip": "", "pull": ""}.get(move, "")
		if move == "" or not ap.has_animation(move):
			return
	ap.speed_scale = 1.0
	life.cancel(who)
	if boxers[who].get("reach") != null:
		(boxers[who]["reach"] as Node).disarm()
	_start(who, move, speed)
	if from_s > 0.0:
		(boxers[who]["ap"] as AnimationPlayer).seek(from_s, true)
	var r := BeatClips.recovery(move)
	_cut[who] = {} if r.y <= 0.0 else {"clip": move, "contact": r.x if r.x >= 0.15 else -1.0, "back": r.y, "fast": false,
		"scale": BeatClips.recover_scale(move, speed)}
	side.arm(who, move)


## Footwork: `who` steps in (+1) or out (-1) for `seconds`, feet stepping at the clip's stride speed. `follow` = she
## answers the other's step a beat later (S302: never in the same frame).
func step(who: int, dir: int, seconds: float = 0.3, follow: bool = false) -> void:
	var clip := "advance" if dir > 0 else "retreat"
	if follow:
		life.later(who, life.follow_delay(), _walk.bind(who, clip, seconds * life.rng.randf_range(0.8, 1.15)))
	else:
		_walk(who, clip, seconds)


## Both circle the same way (her left when dir = -1): one leads, the other follows a beat later for her own length of
## time, so the pair turns about its middle without moving as one.
func circle(dir: int, seconds: float = 0.45) -> void:
	var clip := "strafe_left" if dir < 0 else "strafe_right"
	var lead := life.rng.randi() % boxers.size()
	_walk(lead, clip, seconds)
	var other := 1 - lead
	life.later(other, life.follow_delay(), _walk.bind(other, clip, seconds * life.rng.randf_range(0.75, 1.2)))


func _walk(who: int, clip: String, seconds: float) -> void:
	var bx: Dictionary = boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip) or stun.left(who) > 0.0:
		return
	var spec: Array = STRIDE[clip]
	# A southpaw's step clips are mirrored: the clip that steps to her left is the mirrored strafe_right (same stride).
	if bool(bx.get("south", false)) and clip.begins_with("strafe_"):
		clip = MirrorClip.counterpart(clip.replace("left", "Left").replace("right", "Right")).to_lower()
	var dir := Basis(Vector3.UP, deg_to_rad(-float(spec[1]))) * _frame(who).z
	# Boxers shuffle, they do not stride: the step clip plays at WALK_SCALE and the body moves at the same fraction of
	# the clip's stride speed, so the feet still match the ground.
	bx["vel"] = dir.normalized() * float(spec[0]) * WALK_SCALE
	bx["move_left"] = seconds
	_cut[who] = {}
	ap.speed_scale = 1.0
	_start(who, clip, WALK_SCALE, 0.08)


## Pelvis-to-pelvis distance at which A's jab glove, at contact, meets B's face (both in the guard frame of the clip).
func _jab_gap() -> float:
	# S300: with the Punch Pro library the gap comes from its jab at its measured contact (the native jab reached 0.3-0.5 m
	# further, so Pro punches met the guard, never the face, in the S300 film).
	var jab := "pro_left_jab" if has_move("pro_left_jab") else "jab"
	var reach := IdleMatch.pose_point(boxers[0], jab, BeatClips.contact(jab, CONTACT_S), hand_of(0, "LeftHand")).z * _scale(0) + 0.10
	# +0.07 (S302: GuardTuck draws the gloves 0.10 m in toward the face, so the guards stand 0.29 m apart at the old +0.19 -
	# the gap closes 0.12 m: face to face ~0.64 m, John J-GUARDPACE1 0.60-0.75 m; S300 film 3: untucked, +0.09 touched).
	var face := IdleMatch.pose_point(boxers[1], jab, 0.0, "Head").z * _scale(1) + 0.07
	return clampf(reach + face, 0.8, 1.6)


func _scale(i: int) -> float:
	return (boxers[i]["node"] as Node3D).scale.x


func _mid() -> Vector3:
	return ((boxers[0]["pos"] as Vector3) + (boxers[1]["pos"] as Vector3)) * 0.5


## The broadcast camera follows the pair (RingCamera); `snap` jumps straight there.
func broadcast(snap: bool = false, delta: float = 0.0) -> void:
	camera.broadcast(boxers[0]["pos"], boxers[1]["pos"], snap, delta)


## The close-up on a big shot on boxer `hit`, held until broadcast() is called again.
func close_up(hit: int) -> void:
	var skel: Skeleton3D = boxers[hit]["skel"]
	var head: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	camera.close_up(boxers[0]["pos"], boxers[1]["pos"], head.y, hit)

