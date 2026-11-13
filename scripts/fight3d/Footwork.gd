extends RefCounted
## The boxers' steps on the canvas (out of FightStage, S311): a body moves only while a step clip plays, at that clip's
## measured stride speed x its play rate, so the planted foot stays planted. S311 real-fight gap 1: the range follows
## RangeBreath - rest out of reach, an entry lunge by the attacker, the pocket, a step out after the last punch.
##   aim(phase)  aim_step(dist, a_far)  step(who, dir)  circle(dir, s)  walk(who, clip, s, scale, aim_m)  stop(who)  offset(to)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")
const RkLoco := preload("res://scripts/fight3d/RkLoco.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const RkJoin := preload("res://scripts/fight3d/RkJoin.gd")

## Stride speed of each footwork clip at 1x, metres a second, and its direction in the boxer's own frame (old repo U84,
## measured on the source): the body moves exactly this fast while the clip plays, so the planted foot stays planted.
const STRIDE := {"advance": [1.736, 0.0], "retreat": [1.781, 180.0], "strafe_left": [1.705, -90.0], "strafe_right": [1.764, 90.0]}
## Boxers shuffle, they do not stride: a circle or a small correction plays the step clip at this rate.
const WALK_SCALE := 0.55
## An entry lunge runs the advance clip at 1.15x (2.0 m/s: 0.6 m in ~0.3 s), a step out 0.8x.
const LUNGE_SCALE := 1.15
const EXIT_SCALE := 0.8
## How far off want_m the gap may sit in each phase before someone steps.
const BAND_M := {"in": 0.06, "pocket": 0.08, "rest": 0.12, "clinch": 0.06, "inside": 0.06}
## S314 inside range: each body shifts this far to her own left so the heads pass each other's shoulder (forehead by the
## other's shoulder, as real inside work looks), easing in and out over INSIDE_EASE_S.
## S392 (blind coach: "faces mashed together"; ring_feet_probe: heads 0.06 m apart inside): 0.07 left the heads on one line. 0.13 is
## the clinch's ear by ear (Clinch.SIDE_M), and with the rig her feet step there too (RingFeet.tick), so the boots clear as well.
const INSIDE_SIDE_M := 0.13
const INSIDE_EASE_S := 0.3

## S311 real-fight gap 3: out of range their feet never stop (real: feet moving 53-56 % of a round, ~155 m travel; ours
## 8-9 %, 10 m). Each boxer at rest takes her own rhythm steps - a half step in or out inside the rest band, or a short
## circle step on her own - with a short pause between them.
const RHYTHM_PAUSE_S := Vector2(0.05, 0.35)
const HALF_STEP_S := Vector2(0.14, 0.26)
const CIRCLE_STEP_S := Vector2(0.25, 0.55)
## S391 with the rig a step goes in only once her feet have landed the last one, and it is one pair long (RingFeet.PAIR_M):
## her place never runs ahead of her feet. Feet moving ~55 % of the round (real 53-56 %; the old pause on step pairs read 81 %).
const RIG_PAUSE_S := Vector2(0.2, 0.75)
const RIG_HALF_S := Vector2(0.1, 0.2)
const RIG_CIRCLE_S := Vector2(0.15, 0.32)
## S391 at punching range their feet keep moving too (with the rig): small steps between punches, longer pauses. Short
## circle steps hold the gap, a little in or out rocks it inside the phase's band; the inside spell moves least.
const RANGE_PAUSE_S := {"pocket": Vector2(0.15, 0.55), "in": Vector2(0.2, 0.6), "inside": Vector2(0.45, 1.1)}
const RANGE_STEP_S := Vector2(0.09, 0.2)
const RANGE_ROCK_S := Vector2(0.05, 0.09)
## Pressed (a step_in beat), the other steps back this long (her answer to his step).
const GIVE_S := Vector2(0.22, 0.34)
## S315 the pivot out of the inside (InsideExits "pivot", John J_INSIDE2: ~90 deg on the lead foot behind a check hook):
## the leaver circles to her lead side at the held gap until the line between them has turned this far, fast; the other
## turns after her at her own facing pace (RingPlace.FACE_S), so for a moment she faces where the leaver was.
const PIVOT_DEG := 70.0
const PIVOT_SCALE := 1.3

var stage: Node
var _pause := [0.0, 0.0]
var want_m := 1.0           # the gap kept now
var _aim := {"phase": "pocket", "who": -1, "move": "jab"}
var _rest_roll := 0.5
var inside_w := 0.0         # 0..1, how far into an inside spell (FightStage lowers its floor and shifts the bodies by it)
var _pivoted := false       # this pivot phase's step is taken
## S320 GLIDE STEPS (operator: "the footing and moving of the fighters looks very bad, why the clips we have are so much
## smoother than what i see in the fight"; smooth_probe: 167 clip changes a minute, 154 of them the old game's WALKING
## strides - advance/retreat/strafe at 1.7 m/s - played at 0.19-1.15x for 0.2-0.9 s and cut, every cut a jolt of hands and
## head). A step no longer plays a clip: her guard plays on uncut, her body moves, and FootPlant takes the steps (each foot
## holds the canvas and shuffles onto its new spot, 0.15 s, the procedural stepping shipped games use). `-- stepclips` =
## the old stride clips (the control arm).
var glide: bool = not OS.get_cmdline_user_args().has("stepclips")
## S391 the feet chase her place in step pairs and the body rides on them (RingFeet.gd). `-- nofootwork` = the S320 glide on
## FootPlant. The Playbook's move player turns it off: its boxers are placed by hand between clips.
var rig_on: bool = glide and not OS.get_cmdline_user_args().has("nofootwork")


func setup(owner: Node) -> void:
	stage = owner
	want_m = float(stage.gap_m)


## What range to keep now (FightView passes RangeBreath.phase every frame). A new quiet spell rolls its own rest gap.
func aim(ph: Dictionary) -> void:
	if str(ph["phase"]) == "rest" and str(_aim["phase"]) != "rest":
		_rest_roll = stage.life.rng.randf()
	if str(ph["phase"]) == "pivot" and str(_aim["phase"]) != "pivot":
		_pivoted = false
	_aim = ph
	want_m = RangeBreath.want_m(ph, float(stage.gap_m), _rest_roll, RangeTable.moves(stage, ph))
	# S313 gap 5: the guard drops out of range and comes up for the entry and the pocket (GuardTuck.low).
	for bx in stage.boxers:
		if bx.get("tuck") != null:
			bx["tuck"].low = 1.0 if str(ph["phase"]) == "rest" else 0.0


func phase() -> String:
	return str(_aim["phase"])


## When the gap is outside its phase's band, one boxer standing in her guard steps to want_m: in the "in" phase only the
## attacker (a lunge, while the other may still move); otherwise the phase's boxer first, one at a time.
func aim_step(dist: float, a_far: bool) -> void:
	var ph := str(_aim["phase"])
	if ph == "pivot":
		_pivot(int(_aim["who"]), dist)
		return
	var err := dist - want_m
	if absf(err) <= float(BAND_M.get(ph, 0.08)):
		return
	var first := int(_aim["who"])
	var order: Array = [first, 1 - first] if first >= 0 else ([0, 1] if a_far else [1, 0])
	if ph in ["in", "clinch", "inside"]:
		order = [first]   # the attacker lunges; S313 the one who ties up walks in on the other; S314 so does the infighter
		if ph == "inside" and err > 0.0 and first >= 0:
			order = [first, 1 - first]   # S314: she is busy punching - the other closes the last bit (both work inside)
	for who in order:
		if float(stage.boxers[1 - who]["move_left"]) > 0.0 and not ph in ["in", "inside"]:
			return
		if not can_step(who):
			continue
		var scale := LUNGE_SCALE if ph in ["in", "clinch", "inside"] else (EXIT_SCALE if ph == "rest" else WALK_SCALE)
		_to(who, dist, want_m, scale)
		return


## Every frame at rest: a boxer free to step takes her next rhythm step once her pause runs out.
func rhythm(delta: float, dist: float) -> void:
	inside_w = move_toward(inside_w, 1.0 if str(_aim["phase"]) == "inside" else 0.0, delta / INSIDE_EASE_S)
	if rig_on and RANGE_PAUSE_S.has(str(_aim["phase"])):
		_range_steps(delta, dist)
	if str(_aim["phase"]) != "rest":
		return
	var rng: RandomNumberGenerator = stage.life.rng
	for who in 2:
		_pause[who] = float(_pause[who]) - delta
		if float(_pause[who]) > 0.0 or not can_step(who) or not feet_down(who) or _captured(who):
			continue
		var p: Vector2 = RIG_PAUSE_S if rig_on else RHYTHM_PAUSE_S
		_pause[who] = rng.randf_range(p.x, p.y)
		var half: Vector2 = RIG_HALF_S if rig_on else HALF_STEP_S
		var round_s: Vector2 = RIG_CIRCLE_S if rig_on else CIRCLE_STEP_S
		if rng.randf() < 0.5:
			# A half step toward the middle of the rest band (in when long, out when short), never out of it.
			walk(who, "advance" if dist > want_m else "retreat", rng.randf_range(half.x, half.y))
		else:
			walk(who, "strafe_left" if rng.randf() < 0.5 else "strafe_right", rng.randf_range(round_s.x, round_s.y))
		return


## S399 ROKOKO2: she is in the Rokoko captured guard (RkClips) - the take carries the actor's own rhythm (his feet shift and
## pivot in it), so the fight adds no rhythm steps over it; the steps the range needs (aim_step, lunges, exits, circles)
## still go in, and RkPure hands her legs to the rig for them.
func _captured(who: int) -> bool:
	var c := str((stage.boxers[who]["ap"] as AnimationPlayer).current_animation)
	return c.begins_with("rk_guard") or (RkClips.pro_on() and c in RkClips.guards())


## S391 no step pair of hers under way (always true without the rig).
func feet_down(who: int) -> bool:
	var rig: Variant = stage.boxers[who].get("rig")
	return not rig_on or rig == null or (rig.plan.pair as Dictionary).is_empty()


## S391 the rhythm at punching range: a boxer free to step takes a small one between punches; the "in" phase's attacker is
## on her lunge, the other keeps moving.
func _range_steps(delta: float, dist: float) -> void:
	var ph := str(_aim["phase"])
	var rng: RandomNumberGenerator = stage.life.rng
	var pause: Vector2 = RANGE_PAUSE_S[ph]
	for who in 2:
		_pause[who] = float(_pause[who]) - delta
		if float(_pause[who]) > 0.0 or not can_step(who) or not feet_down(who) or (ph == "in" and who == int(_aim["who"])) or _captured(who):
			continue
		_pause[who] = rng.randf_range(pause.x, pause.y)
		if rng.randf() < 0.65 or ph == "inside":
			walk(who, "strafe_left" if rng.randf() < 0.5 else "strafe_right", rng.randf_range(RANGE_STEP_S.x, RANGE_STEP_S.y))
		else:
			walk(who, "advance" if dist > want_m else "retreat", rng.randf_range(RANGE_ROCK_S.x, RANGE_ROCK_S.y))
		return


## The shown body's shift in an inside spell (FightStage._compose adds it like Clinch.offset): her own left of the line.
func offset(to: Vector3) -> Vector3:
	if inside_w <= 0.0 or to.length() < 0.01:
		return Vector3.ZERO
	return Vector3.UP.cross(to.normalized()) * INSIDE_SIDE_M * inside_w * inside_w * (3.0 - 2.0 * inside_w)


## Footwork beat: `who` lunges in to the pocket (+1) or steps out of range (-1). Stepping in is pressure: the other gives
## ground a beat later, so a pressing exchange walks her back toward the ropes ("backs Lucy to the ropes"). Stepping
## out, the other holds (S311: before, both always moved the same way, so the gap never changed).
func step(who: int, dir: int) -> void:
	var dist := (stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"])
	if not can_step(who):
		return
	if dir > 0:
		var s := maxf(GIVE_S.x, (dist - float(stage.gap_m)) / (float(STRIDE["advance"][0]) * LUNGE_SCALE))
		walk(who, "advance", s + GIVE_S.x, LUNGE_SCALE)
		var life: GuardLife = stage.life
		life.later(1 - who, life.follow_delay(), _give.bind(1 - who, life.rng.randf_range(GIVE_S.x, GIVE_S.y)))
	else:
		_to(who, dist, RangeBreath.REST_M.y, EXIT_SCALE)


## The pivot out: once the leaver is free (her check hook back in guard), one fast circle step to her lead side (the
## left for an orthodox, the right for a southpaw) at the held gap; the arc it covers turns the line PIVOT_DEG.
func _pivot(who: int, dist: float) -> void:
	if _pivoted or who < 0 or not can_step(who):
		return
	_pivoted = true
	var side := "strafe_right" if bool(stage.boxers[who].get("south", false)) else "strafe_left"
	walk(who, side, deg_to_rad(PIVOT_DEG) * dist / (float(STRIDE[side][0]) * PIVOT_SCALE), PIVOT_SCALE)


## Pressed, she steps back (if she is free to): the pair travels her way.
func _give(who: int, seconds: float) -> void:
	if can_step(who):
		walk(who, "retreat", seconds, EXIT_SCALE)


## Both circle the same way (her left when dir = -1): one leads, the other follows a beat later for her own length of
## time, so the pair turns about its middle without moving as one.
func circle(dir: int, seconds: float = 0.45) -> void:
	var clip := "strafe_left" if dir < 0 else "strafe_right"
	var life: GuardLife = stage.life
	var lead: int = life.rng.randi() % 2
	walk(lead, clip, seconds)
	var other: int = 1 - lead
	life.later(other, life.follow_delay(), walk.bind(other, clip, seconds * life.rng.randf_range(0.75, 1.2)))


## S316 how long a finished step's clip plays on, slowing to GRACE_SPEED, waiting for the next step (else the guard).
const STEP_GRACE_S := 0.35
const GRACE_SPEED := 0.35


## Standing in her guard (or a fidget), not stepping, not locked in a hit reaction: free to take a step.
## S318 tried letting a step start inside a finished step's grace: smooth_probe read MORE clip changes (160 -> 212/min,
## steps started sooner and more often) - kept out.
func can_step(who: int) -> bool:
	var clip := str((stage.boxers[who]["ap"] as AnimationPlayer).current_animation)
	return float(stage.boxers[who]["move_left"]) <= 0.0 and stage.stun.left(who) <= 0.0 \
		and (clip in BeatClips.GUARD or clip in GuardLife.FIDGETS)


## A step clip for `seconds`, body moving at its stride speed x `scale`. `aim_m` > 0: an aimed step in or out that stops
## at that gap; 0: a circle step, which keeps the gap it started at.
func walk(who: int, clip: String, seconds: float, scale: float = WALK_SCALE, aim_m: float = 0.0) -> void:
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip) or stage.stun.left(who) > 0.0:
		return
	var dist := (stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"])
	bx["aim_m"] = aim_m
	bx["aim_dir"] = 0.0 if aim_m <= 0.0 else signf(dist - aim_m)
	bx["hold_m"] = dist if aim_m <= 0.0 and clip.begins_with("strafe_") else 0.0
	var spec: Array = STRIDE[clip]
	# A southpaw's step clips are mirrored: the clip that steps to her left is the mirrored strafe_right (same stride).
	if bool(bx.get("south", false)) and clip.begins_with("strafe_"):
		clip = MirrorClip.counterpart(clip.replace("left", "Left").replace("right", "Right")).to_lower()
	var dir := Basis(Vector3.UP, deg_to_rad(-float(spec[1]))) * (bx["node"] as Node3D).transform.basis.z
	# S322 burning legs (BodyBurn "legs", 1.0 .. BodyLoad.STEP_MIN): shorter, slower steps.
	bx["vel"] = dir.normalized() * float(spec[0]) * scale * float(bx.get("legs", 1.0))
	bx["move_left"] = seconds
	bx["move_total"] = seconds
	# S399 ROKOKO2: a captured step clip carries her (RkLoco) - its own hip travel moves her, whole loops nearest the
	# distance asked; her body never glides under a standing guard.
	# HUMANFIGHT1: an AIMED step (to a range: the entry lunge, the step out, a correction) is not a captured step clip.
	# The clip plays whole loops at its own pace - the step in takes 1.6 s where a lunge takes 0.3 - so the pair never
	# reached the range it was sent to (the gap read 1.4 m in the pocket and inside phases, where 1.0 and 0.64 were asked)
	# and landed punches then carried her 0.35-0.9 m in at up to 3 m/s. An aimed step glides her place at its stride speed
	# and stops on the gap; the rig's step pairs carry her feet (RingFeet). `-- lococlipsaim` = the control arm.
	if RkLoco.on() and (aim_m <= 0.0 or OS.get_cmdline_user_args().has("lococlipsaim")):
		var body_dir: Vector3 = (bx["node"] as Node3D).global_transform.basis.inverse() * dir
		var loco := RkLoco.pick(bx, body_dir, (bx["vel"] as Vector3).length() * seconds)
		if not loco.is_empty():
			bx["vel"] = Vector3.ZERO
			bx["hold_m"] = 0.0   # no gap pin and no stop at the aimed gap: the step plays its whole loops
			bx["aim_dir"] = 0.0
			bx["move_left"] = float(loco["seconds"])
			bx["move_total"] = float(loco["seconds"])
			stage._cut[who] = {}
			RkJoin.capture(stage, who)
			stage._start(who, str(loco["clip"]), 1.0, stage.GUARD_FADE_S)   # the guard's slower join (a strike's popped the knee)
			RkJoin.align(stage, who)
			return
	if glide:
		return
	stage._cut[who] = {}
	# S316 smoothness (tools/smooth_probe.gd: a step clip restarted 176 times in 1.8 min, each played 0.23 s, the guard
	# idle flashed 0.13 s between them - a cut every 0.4 s): a step that follows a step on the same clip carries the clip
	# on instead of starting it again.
	var going := float(bx.get("step_grace", 0.0)) > 0.0 and str(ap.current_animation) == clip
	bx["step_grace"] = 0.0
	if going:
		ap.speed_scale = scale
	else:
		ap.speed_scale = 1.0
		stage._start(who, clip, scale, 0.08)


## The step ends: a punch or a reaction started mid-step plays on (the step only carried her body).
func stop(who: int) -> void:
	var bx: Dictionary = stage.boxers[who]
	bx["vel"] = Vector3.ZERO
	bx["move_left"] = 0.0
	bx["aim_dir"] = 0.0
	bx["hold_m"] = 0.0
	# S316: the step clip plays on (slowing) for STEP_GRACE_S before the guard comes back - footwork is a run of steps,
	# and the next one usually comes inside it (FightStage._compose ends the grace).
	if STRIDE.has(str((bx["ap"] as AnimationPlayer).current_animation)):
		bx["step_grace"] = STEP_GRACE_S
	elif RkLoco.is_loco(str((bx["ap"] as AnimationPlayer).current_animation)):
		stage.guard(who)   # S399: the captured step is done (whole loops): back to her guard where the step left her


## An aimed step from `dist` to `to` at `scale`, long enough to get there (it stops on arrival).
func _to(who: int, dist: float, to: float, scale: float) -> void:
	if absf(dist - to) <= 0.04:
		return
	var clip := "advance" if dist > to else "retreat"
	walk(who, clip, clampf(absf(dist - to) / (float(STRIDE[clip][0]) * scale) + 0.05, 0.12, 0.8), scale, to)
