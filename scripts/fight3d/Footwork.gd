extends RefCounted
## The boxers' steps on the canvas (out of FightStage, S311): a body moves only while a step clip plays, at that clip's
## measured stride speed x its play rate, so the planted foot stays planted. S311 real-fight gap 1: the range follows
## RangeBreath - rest out of reach, an entry lunge by the attacker, the pocket, a step out after the last punch.
##   aim(phase)  aim_step(dist, a_far)  step(who, dir)  circle(dir, s)  walk(who, clip, s, scale, aim_m)  stop(who)

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const GuardLife := preload("res://scripts/fight3d/GuardLife.gd")
const MirrorClip := preload("res://scripts/fight3d/MirrorClip.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")

## Stride speed of each footwork clip at 1x, metres a second, and its direction in the boxer's own frame (old repo U84,
## measured on the source): the body moves exactly this fast while the clip plays, so the planted foot stays planted.
const STRIDE := {"advance": [1.736, 0.0], "retreat": [1.781, 180.0], "strafe_left": [1.705, -90.0], "strafe_right": [1.764, 90.0]}
## Boxers shuffle, they do not stride: a circle or a small correction plays the step clip at this rate.
const WALK_SCALE := 0.55
## An entry lunge runs the advance clip at 1.15x (2.0 m/s: 0.6 m in ~0.3 s), a step out 0.8x.
const LUNGE_SCALE := 1.15
const EXIT_SCALE := 0.8
## How far off want_m the gap may sit in each phase before someone steps.
const BAND_M := {"in": 0.06, "pocket": 0.08, "rest": 0.12}

## S311 real-fight gap 3: out of range their feet never stop (real: feet moving 53-56 % of a round, ~155 m travel; ours
## 8-9 %, 10 m). Each boxer at rest takes her own rhythm steps - a half step in or out inside the rest band, or a short
## circle step on her own - with a short pause between them.
const RHYTHM_PAUSE_S := Vector2(0.05, 0.35)
const HALF_STEP_S := Vector2(0.14, 0.26)
const CIRCLE_STEP_S := Vector2(0.25, 0.55)
## Pressed (a step_in beat), the other steps back this long (her answer to his step).
const GIVE_S := Vector2(0.22, 0.34)

var stage: Node
var _pause := [0.0, 0.0]
var want_m := 1.0           # the gap kept now
var _aim := {"phase": "pocket", "who": -1, "move": "jab"}
var _rest_roll := 0.5


func setup(owner: Node) -> void:
	stage = owner
	want_m = float(stage.gap_m)


## What range to keep now (FightView passes RangeBreath.phase every frame). A new quiet spell rolls its own rest gap.
func aim(ph: Dictionary) -> void:
	if str(ph["phase"]) == "rest" and str(_aim["phase"]) != "rest":
		_rest_roll = stage.life.rng.randf()
	_aim = ph
	want_m = RangeBreath.want_m(ph, float(stage.gap_m), _rest_roll)


## When the gap is outside its phase's band, one boxer standing in her guard steps to want_m: in the "in" phase only the
## attacker (a lunge, while the other may still move); otherwise the phase's boxer first, one at a time.
func aim_step(dist: float, a_far: bool) -> void:
	var ph := str(_aim["phase"])
	var err := dist - want_m
	if absf(err) <= float(BAND_M.get(ph, 0.08)):
		return
	var first := int(_aim["who"])
	var order: Array = [first, 1 - first] if first >= 0 else ([0, 1] if a_far else [1, 0])
	if ph == "in":
		order = [first]
	for who in order:
		if float(stage.boxers[1 - who]["move_left"]) > 0.0 and ph != "in":
			return
		if not can_step(who):
			continue
		var scale := LUNGE_SCALE if ph == "in" else (EXIT_SCALE if ph == "rest" else WALK_SCALE)
		_to(who, dist, want_m, scale)
		return


## Every frame at rest: a boxer free to step takes her next rhythm step once her pause runs out.
func rhythm(delta: float, dist: float) -> void:
	if str(_aim["phase"]) != "rest":
		return
	var rng: RandomNumberGenerator = stage.life.rng
	for who in 2:
		_pause[who] = float(_pause[who]) - delta
		if float(_pause[who]) > 0.0 or not can_step(who):
			continue
		_pause[who] = rng.randf_range(RHYTHM_PAUSE_S.x, RHYTHM_PAUSE_S.y)
		if rng.randf() < 0.5:
			# A half step toward the middle of the rest band (in when long, out when short), never out of it.
			walk(who, "advance" if dist > want_m else "retreat", rng.randf_range(HALF_STEP_S.x, HALF_STEP_S.y))
		else:
			walk(who, "strafe_left" if rng.randf() < 0.5 else "strafe_right", rng.randf_range(CIRCLE_STEP_S.x, CIRCLE_STEP_S.y))
		return


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


## Standing in her guard (or a fidget), not stepping, not locked in a hit reaction: free to take a step.
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
	bx["vel"] = dir.normalized() * float(spec[0]) * scale
	bx["move_left"] = seconds
	stage._cut[who] = {}
	ap.speed_scale = 1.0
	stage._start(who, clip, scale, 0.08)


## The step ends: a punch or a reaction started mid-step plays on (the step only carried her body).
func stop(who: int) -> void:
	var bx: Dictionary = stage.boxers[who]
	bx["vel"] = Vector3.ZERO
	bx["move_left"] = 0.0
	bx["aim_dir"] = 0.0
	bx["hold_m"] = 0.0
	if STRIDE.has(str((bx["ap"] as AnimationPlayer).current_animation)):
		stage.guard(who)


## An aimed step from `dist` to `to` at `scale`, long enough to get there (it stops on arrival).
func _to(who: int, dist: float, to: float, scale: float) -> void:
	if absf(dist - to) <= 0.04:
		return
	var clip := "advance" if dist > to else "retreat"
	walk(who, clip, clampf(absf(dist - to) / (float(STRIDE[clip][0]) * scale) + 0.05, 0.12, 0.8), scale, to)
