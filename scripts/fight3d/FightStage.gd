extends Node3D
## The 3D ring: two MetaHuman boxers (gloves, boots, singlet and trunks in the corner's colour), the ropes, the lights and the
## broadcast camera. It shows moves; it never decides anything (the bout is settled in Bouts before anyone watches).
## Every boxer always plays a clip: the moving guard (the old game's active guard, baked) under everything, punches, slips,
## hit reactions and footwork on top. A body only moves across the canvas while its feet step (a footwork clip, at that
## clip's measured stride speed), so nobody floats or slides.
##   setup(a, b)  a/b = {"glb": res path, "corner": "red"|"blue"}
##   play(who, move)  a punch or a defence; react(who, kind) "head"|"body"|"hurt"; step(who, dir); circle(dir, s)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")
const RingSet := preload("res://scripts/fight3d/RingSet.gd")
const RingCamera := preload("res://scripts/fight3d/RingCamera.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const HitStun := preload("res://scripts/fight3d/HitStun.gd")
const SideStep := preload("res://scripts/fight3d/SideStep.gd")
const FootPlant := preload("res://scripts/fight3d/FootPlant.gd")
const BoxerBuild := preload("res://scripts/fight3d/BoxerBuild.gd")
const Footwork := preload("res://scripts/fight3d/Footwork.gd")
const Clinch := preload("res://scripts/fight3d/Clinch.gd")

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
## S311: nobody closes inside this pelvis gap (gloves in guard would meet).
const MIN_GAP_M := 0.62
## S314: in an inside spell the heads pass each other's shoulder (Footwork.offset), so they may close to this.
const INSIDE_FLOOR_M := 0.48
## S311: the pair's middle stays this far inside the ropes (was 0.9: nobody ever reached them), and a boxer's pelvis
## at least ROPE_LEAN_M (backed onto the ropes she leans on them).
const MID_IN_M := 0.55
const ROPE_LEAN_M := 0.06
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
var feet := Footwork.new()   # S311: steps, circles and the range that breathes (RangeBreath)
var _ropes: Node3D = null     # S311 RingRopes: they bow where a boxer leans on them
var _ring_side: Array = []    # ropes and posts: see-through while they stand between the camera and the boxers
var _cut: Array = [{}, {}]    # per boxer, the Pro clip playing: {clip, contact, back, fast} (S301 recovery cut)
var _hold_left := 0.0         # S302 hit-stop: both bodies still while > 0
var _held_speed := [1.0, 1.0]
var clinch := Clinch.new()    # S313: the tie-up (real-fight gap 4); referee: Referee.gd (FightCast.crew builds him)
var referee: Node3D = null
var stun := HitStun.new()     # S305: a hit boxer stays in her reaction (no defence, fidget or step over it)
var life := GuardLife.new()   # S302: each boxer's own guard tempo, fidgets, and a pair step that is not in lockstep
var side := SideStep.new()    # S306: a dodge's step stays taken; a weave steps off the line
## S307 corner minute / intro: while `scene` is on, a director (CornerMinute) places and plays both boxers; the fight rules
## (face each other, keep the gap, the guard between moves, fidgets) are off.
var scene := false
## S306: the turn to face her opponent eases over this (a committed side step turned both bodies ~10 degrees in one frame).
const FACE_S := 0.08


func setup(a: Dictionary, b: Dictionary) -> void:
	life.setup(self, 7919)
	var ring := RingSet.new()
	ring.name = "RingSet"
	add_child(ring)
	ring.build(RING_M, APRON_M)
	_ring_side = ring.ring_side
	_ropes = ring.ropes
	for spec in [a, b]:
		boxers.append(BoxerBuild.build(self, spec, boxers.size()))
	gap_m = _jab_gap()
	feet.setup(self)
	add_child(clinch)
	clinch.setup(self)
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
	_ropes.tick(delta, boxers.map(func(bx): return bx["skel"]))
	if scene:
		camera.nudge(delta)
		return
	stun.tick(delta)
	side.tick()
	_recover()
	life.tick(delta)
	_hold(delta)
	_compose(delta)
	if not camera.close:
		broadcast(false, delta)
	camera.nudge(delta)
	camera.clear_view(_ring_side, boxers[0]["pos"], boxers[1]["pos"], delta)


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
		# S311: a plain head shot snaps and lets her fight on; hurt, big and body shots keep the full reaction.
		var light := not big and not move.contains("body") and not (BeatClips.REACT["hurt"] as Array).has(clip)
		var cut := HitStun.head_cut(clip, fast) if light else HitStun.react_cut(clip, speed, fast)
		_cut[who] = cut if not cut.is_empty() else _cut[who]
		stun.start(who, clip, speed, light)
	var kind := "big" if big else ("jab" if move == "jab" else "power")
	_hold_left = float(HOLD_S[kind])
	for i in boxers.size():
		var sc: float = (boxers[i]["ap"] as AnimationPlayer).speed_scale
		if sc != 0.0:
			_held_speed[i] = sc
	camera.shake(float(SHAKE_M[kind]))
	var body := move.contains("body")
	var snap: Node = boxers[who].get("snap")
	if snap == null:
		return
	if body:
		# S310: a landed body shot folds her over the side it hit (a lead hook from the hitter meets her other side).
		snap.fold(hand_of(hitter, "LeftHand") == "RightHand")
		return
	var deg := 9.0
	for key in SNAP_DEG:
		if move.contains(key):
			deg = float(SNAP_DEG[key])
	var hand := hand_of(hitter, "LeftHand" if move in ["jab", "lead_hook", "lead_uppercut"] else "RightHand")
	var skel: Skeleton3D = boxers[hitter]["skel"]
	var shoulder := skel.global_transform * skel.get_bone_global_pose(skel.find_bone(hand.trim_suffix("Hand") + "UpperArm")).origin
	snap.snap(target_point(who, false) - shoulder, deg * (1.5 if big else 1.0))


## S311: what range to keep now (FightView passes RangeBreath.phase every frame).
func aim(ph: Dictionary) -> void:
	feet.aim(ph)


## Positions: each boxer moves only by her own stepping velocity; both always face each other. S311: the gap is no
## longer held - it follows want_m (RangeBreath). A circling boxer keeps the distance she started at (a strafe round a
## point would open it); an aimed step in or out stops where it was aimed; nobody closes inside MIN_GAP_M. When the gap
## is outside its band, a boxer standing in her guard steps to it: the attacker lunges in, otherwise one steps out.
func _compose(delta: float) -> void:
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		if float(bx["move_left"]) > 0.0:
			bx["pos"] = (bx["pos"] as Vector3) + (bx["vel"] as Vector3) * delta
			bx["move_left"] = float(bx["move_left"]) - delta
			if float(bx["move_left"]) <= 0.0:
				feet.stop(i)
	var a: Vector3 = boxers[0]["pos"]
	var b: Vector3 = boxers[1]["pos"]
	var dist := a.distance_to(b)
	var axis := (b - a).normalized() if dist > 0.01 else Vector3.BACK
	var moving := [float(boxers[0]["move_left"]) > 0.0, float(boxers[1]["move_left"]) > 0.0]
	var pin := [moving[0] and float(boxers[0]["hold_m"]) > 0.0, moving[1] and float(boxers[1]["hold_m"]) > 0.0]
	if (moving[0] and float(boxers[0]["aim_dir"]) != 0.0) or (moving[1] and float(boxers[1]["aim_dir"]) != 0.0):
		pin = [false, false]    # an aimed step changes the range; a circle beside it does not hold it
	var keep := dist
	if pin[0] or pin[1]:
		keep = float(boxers[0 if pin[0] else 1]["hold_m"])
	keep = maxf(keep, clinch.floor_m(lerpf(MIN_GAP_M, INSIDE_FLOOR_M, feet.inside_w)))
	if absf(dist - keep) > 0.001:
		var err := dist - keep
		var share := [0.5, 0.5] if pin[0] == pin[1] else ([1.0, 0.0] if pin[0] else [0.0, 1.0])
		boxers[0]["pos"] = a + axis * err * float(share[0])
		boxers[1]["pos"] = b - axis * err * float(share[1])
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		if moving[i] and float(bx["aim_dir"]) != 0.0 and (keep - float(bx["aim_m"])) * float(bx["aim_dir"]) <= 0.0:
			feet.stop(i)
	if delta > 0.0:
		feet.aim_step(keep, a.length() > b.length())
		feet.rhythm(delta, keep)
	a = boxers[0]["pos"]
	b = boxers[1]["pos"]
	var mid := (a + b) * 0.5
	var limit := RING_M * 0.5 - MID_IN_M
	var shift := Vector3(clampf(mid.x, -limit, limit) - mid.x, 0, clampf(mid.z, -limit, limit) - mid.z)
	# S311: each boxer may reach the ropes (her pelvis ROPE_LEAN_M inside them: her hips lean on the middle rope, which
	# bows - RingRopes), never through them.
	var edge := RING_M * 0.5 - ROPE_LEAN_M
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		var at: Vector3 = (bx["pos"] as Vector3) + shift
		bx["pos"] = Vector3(clampf(at.x, -edge, edge), at.y, clampf(at.z, -edge, edge))
		var me: Vector3 = bx["pos"]
		var other: Vector3 = boxers[1 - i]["pos"]
		var n: Node3D = bx["node"]
		var to := other - me
		# S302: a landed punch carries her in (shown only; her place on the canvas stays).
		var pr: Node = bx.get("reach")
		n.position = me + (to.normalized() * float(pr.lunge()) if pr != null and to.length() > 0.01 else Vector3.ZERO) + clinch.offset(i, to) + feet.offset(to)
		if to.length() > 0.01:
			var yaw := atan2(to.x, to.z)
			n.rotation = Vector3(0.0, yaw if delta <= 0.0 else lerp_angle(n.rotation.y, yaw, 1.0 - exp(-delta / FACE_S)), 0.0)


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
	if not scene and float(boxers[who]["move_left"]) <= 0.0:
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


## Footwork (Footwork.gd): a lunge in (+1) or a step out (-1); both circling; one step clip on `who`.
func step(who: int, dir: int) -> void:
	feet.step(who, dir)


func circle(dir: int, seconds: float = 0.45) -> void:
	feet.circle(dir, seconds)


func _walk(who: int, clip: String, seconds: float, scale: float = Footwork.WALK_SCALE, aim_m: float = 0.0) -> void:
	feet.walk(who, clip, seconds, scale, aim_m)


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


## The broadcast camera follows the pair (RingCamera); `snap` jumps straight there.
func broadcast(snap: bool = false, delta: float = 0.0) -> void:
	camera.broadcast(boxers[0]["pos"], boxers[1]["pos"], snap, delta)


## The close-up on a big shot on boxer `hit`, held until broadcast() is called again.
func close_up(hit: int) -> void:
	var skel: Skeleton3D = boxers[hit]["skel"]
	var head: Vector3 = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	camera.close_up(boxers[0]["pos"], boxers[1]["pos"], head.y, hit)


## S307: hands both boxers to a scene director (on) or back to the fight (off: they stand where the scene left them, in
## their guard).
func scene_mode(on: bool) -> void:
	scene = on
	_hold_left = 0.0
	for i in boxers.size():
		var bx: Dictionary = boxers[i]
		life.cancel(i)
		stun.clear(i)
		_cut[i] = {}
		if bx.get("reach") != null:
			(bx["reach"] as Node).disarm()
		bx["vel"] = Vector3.ZERO
		bx["move_left"] = 0.0
		(bx["ap"] as AnimationPlayer).speed_scale = 1.0
		if not on:
			var at := (bx["node"] as Node3D).position
			bx["pos"] = Vector3(at.x, 0.0, at.z)
			guard(i)


## S307: a scene clip on boxer `who` (through the join smoother, like every move).
func act(who: int, clip: String, speed: float = 1.0) -> void:
	if (boxers[who]["ap"] as AnimationPlayer).has_animation(clip):
		_start(who, clip, speed, GUARD_FADE_S)
