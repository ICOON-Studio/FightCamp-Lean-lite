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
const GloveClearScript := preload("res://scripts/fight3d/GloveClear.gd")
const PunchRange := preload("res://scripts/fight3d/PunchRange.gd")
const Footwork := preload("res://scripts/fight3d/Footwork.gd")
const Clinch := preload("res://scripts/fight3d/Clinch.gd")
const RingPlace := preload("res://scripts/fight3d/RingPlace.gd")
const HitImpact := preload("res://scripts/fight3d/HitImpact.gd")

const CONTACT_S := 8.0 / 30.0
## When the glove lands, seconds into each move (natives frame 8; baked: the old repo's clip_phases contact_s).
const CONTACT := {"jab": CONTACT_S, "cross": CONTACT_S, "lead_hook": CONTACT_S, "body_hook": 0.70, "rear_uppercut": 0.58}
const CLIP_S := 20.0 / 30.0
## The face, from the head bone (the skull's base): forward and up, metres on the unscaled body.
const FACE_FWD_M := 0.09
const FACE_UP_M := 0.07
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
## S315 `-- noinguard` = the old guard up close (the control arm of the inside guard).
var _no_inguard := OS.get_cmdline_user_args().has("noinguard")


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
	for i in boxers.size():
		if boxers[i].get("gclear") != null:
			boxers[i]["gclear"].other = boxers[1 - i]["skel"]
			boxers[i]["gclear"].peer = boxers[1 - i].get("gclear")
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
func land(who: int, clip: String, body: bool, at_s: float = 0.0, contact_s: float = -1.0) -> void:
	var pr: Node = boxers[who].get("reach")
	if pr == null: return
	var row := BeatClips.contact_row(clip)
	var hand := hand_of(who, str(row.get("hand", "LeftHand" if clip.contains("left_") or clip.contains("jab") else "RightHand")))
	# S321: the beat's own contact (its per-move fallback: a body hook's 0.70 s, not the jab's 0.27 s).
	pr.arm(clip, hand, contact_s if contact_s >= 0.0 else BeatClips.contact(clip, CONTACT_S), target_point.bind(1 - who, body), float(boxers[who]["front"]))
	boxers[who]["land_f"] = [Engine.get_process_frames(), at_s, (boxers[who]["ap"] as AnimationPlayer).current_animation_position]   # hit_gap_probe timing
	# S320 (operator: "some hits seem to register even when opponent is way to far"; tools/hit_gap_probe.gd: the glove
	# 0.21 m off the target at contact (p50), 66 % past 0.15 m, up to 0.98 m - punches landed from 1.6 m). The clip touches
	# at the gap gap_m - short_m (clip_contact.json, measured at the jab gap); she must close the rest of today's gap by the
	# contact: the lean and the reach's lunge take up to LEAN_COVER_M + LUNGE_MAX_M, a step in carries the remainder.
	var need := _gap() - (gap_m - float(row.get("short_m", 0.0)))
	pr.lunge_m = clampf(need - LEAN_COVER_M, 0.0, LUNGE_MAX_M)
	var rest := need - LEAN_COVER_M - float(pr.lunge_m)
	if rest > 0.03 and at_s > 0.0:
		PunchRange.close_in(self, who, rest, at_s)


## Pelvis to pelvis now, metres.
func _gap() -> float:
	return Vector2(boxers[0]["pos"].x - boxers[1]["pos"].x, boxers[0]["pos"].z - boxers[1]["pos"].z).length()


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
	# S320 hit_gap_probe: up close her trunk leans out of the other head (GloveClear._clear_head), so the animated head
	# read here sat ~0.15 m behind the face the camera shows and inside punches stopped short. Aim at the head as SHOWN.
	var gc: Node = boxers[i].get("gclear")
	if gc != null and (gc.get("shown_head") as Vector3).is_finite():
		head = (gc.get("shown_head") as Vector3) - Vector3.UP * GloveClearScript.HEAD_UP_M
	return head + (fwd * FACE_FWD_M + Vector3.UP * FACE_UP_M) * s


## The striking face of boxer i's glove on `hand` as shown (the glove follows the skeleton after its modifiers).
func glove_front(i: int, hand: String) -> Vector3:
	var g: Node3D = (boxers[i]["gloves"] as Node).gloves.get("l" if hand.begins_with("Left") else "r")
	return g.global_position + g.global_transform.basis.y.normalized() * float(boxers[i]["front"]) * _scale(i)


## Starts `clip` on boxer `who` with no crossfade: the join smoother eases from what was shown (S301).
func _start(who: int, clip: String, speed: float, fade: float = BLEND_S) -> void:
	var bx: Dictionary = boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	# S322 (hit_gap_probe timing): play() on the clip already playing carries on from where it is, so a double jab's
	# second jab started 0.30 s in and passed its contact before the hit. A new move always starts its clip over.
	if str(ap.current_animation) == clip:
		ap.stop()
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


var hit_gaps: Array = []   # S320 PunchRange.record: every landed contact's glove miss (tools/hit_gap_probe.gd)


## The hit-stop and a landed punch's reaction, head snap and camera nudge: HitImpact.
func _hold(delta: float) -> void:
	HitImpact.hold(self, delta)


func hit(who: int, clip: String, speed: float, hitter: int, move: String, big: bool, punch_id: int = -2) -> void:
	HitImpact.hit(self, who, clip, speed, hitter, move, big, punch_id)


## S311: what range to keep now (FightView passes RangeBreath.phase every frame).
func aim(ph: Dictionary) -> void:
	feet.aim(ph)


## Positions and facing each frame: RingPlace.
func _compose(delta: float) -> void:
	RingPlace.compose(self, delta)


## Her guard between moves: the Punch Pro idle when loaded (every Pro clip starts and ends in it, S300), else the old one.
func guard(who: int) -> void:
	var ap: AnimationPlayer = boxers[who]["ap"]
	boxers[who]["step_grace"] = 0.0
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


## S301 a Pro clip's fast recovery back to the guard: HitImpact.recover.
func _recover() -> void:
	HitImpact.recover(self)


func _on_finished(_name: StringName, who: int) -> void:
	if not scene and float(boxers[who]["move_left"]) <= 0.0:
		guard(who)


## A punch, a defence or a hit reaction, played where she stands at `speed` (BeatClips.speed: Pro clips on shipped timing),
## from `from_s` seconds into the clip (S302: a combo's follow-up starts part-way through its wind-up).
## False when nothing started (hit-locked, no clip). S321: each start is numbered (play_id) so a hit knows its punch.
func play(who: int, move: String, speed: float = 1.0, from_s: float = 0.0) -> bool:
	var ap: AnimationPlayer = boxers[who]["ap"]
	if stun.blocks(who, move):
		return false
	if not ap.has_animation(move):
		move = {"body_hook": "lead_hook", "rear_uppercut": "cross", "slip": "", "pull": ""}.get(move, "")
		if move == "" or not ap.has_animation(move):
			return false
	boxers[who]["play_id"] = int(boxers[who].get("play_id", 0)) + 1
	ap.speed_scale = 1.0
	boxers[who]["step_grace"] = 0.0
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
	return true


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
	# S348: the lens keeps off the referee in every mode (stepping in to part a clinch he came within a metre of it).
	camera.avoid = (referee.get("body") as Node3D).position if referee != null and referee.get("body") != null else Vector3.INF
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
