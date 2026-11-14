extends Node
## S313 real-fight gap 4 (Game Godot/research/S310_REAL_FIGHT_GAPS.md row "Clinch"; filmed R1 1:14 chest to chest, R1
## 5:22.9 heads together and the referee parts them): the tie-up in the ring. No clinch clip exists (Fab, MoCap Online,
## Reallusion checked S311), so it is built from our own pieces: RangeBreath's "clinch" phase walks the holder in to
## CLINCH_M; here both stand in the block pose held mid-loop, each body shifted to its own left so the heads pass each
## other's shoulder, the holder's arms over the other's upper back and the other's hands on the holder's flanks
## (CornerIK, attached to every boxer by CornerCrew), each looking past the other's shoulder.
##   setup(stage)  start(holder, dur, digs, digger)  release()  offset(i, to) -> Vector3  floor_m(base) -> float  engaged
## S354 (CLINCH2, operator S340 "someone also needs to perfect the clinch"): the hold is a real tie-up, not a freeze - an
## A-frame (the trunk leans from the pelvis: chests in, hips back), a jostle (the pair turns about its middle and drifts,
## feet shuffling), the free hand digs short hooks into the other's ribs (a beat's `digs`/`digger`), and the pair is only
## called TIED once that pose has come in - the spacing and the hands ease in from start(), nothing snaps.

const PushOff := preload("res://scripts/fight3d/PushOff.gd")
const POSES := ["pro_block_loop", "mc_block"]
## S317 (operator Q-S294-25 "Clinch looks wrong", his C143 mark "calculate the grip without wearing the glove"): when the
## baked two-person clinch is there (FightClips.PAIR, tools/pair_bake.gd from a Cascadeur-authored clinch: both lean in
## from the hips, heads past each other's shoulder, arms tied) the holder plays its attacker half and the other its victim
## half, pure and in step, PAIR_GAP_M apart, looping PAIR_SPAN. The clip's own arm poses are a cage clinch (S318) and its
## hands sit on arms and heads, so the tie's four hands are aimed by IK (spec 3, `_stance`); the clip carries the bodies -
## the lean, the shoulders, the hips back. S354: 0.68, not the clip's own 0.83 x hip height (0.77): at 0.77 the other's
## ribs are 0.54 m from a 0.49 m arm (the dig stopped 0.13 m short of them) and the chests 0.41 m apart, four hands.
const PAIR_GAP_M := 0.68
const PAIR_SPAN := Vector2(0.4, 3.6)
const PAIR_SPEED := 0.8
## The tie-up starts once the pelvises are this close (the holder's walk in ends at RangeBreath.CLINCH_M).
const ENGAGE_M := 0.62
## Nobody closes inside this while tied up (the stage's usual floor is MIN_GAP_M 0.62).
const MIN_M := 0.32
## Each body shifts this far to her own left: heads 2 x SIDE_M apart sideways, cheek past the other's ear.
## S316 (operator on a clinch still: "very bad" - faces nose to nose): 0.13 puts the heads ear by ear, chin over the
## other's shoulder.
const SIDE_M := 0.13
const EASE_S := 0.3
## The pose is held between these shares of its loop (a block loop played to its end would hand back to the guard).
## Letting go: the shift and the closest gap ease back over this long (the push-off and their step out cover it).
const RELEASE_S := 0.5
const HOLD_SPAN := Vector2(0.3, 0.75)
const HOLD_SPEED := 0.35
## Where the hands go, metres: over the shoulder blade (behind and below the shoulder joint), and on the flank.
## SPLIT471: BACK_M, BLADE_DOWN_M, FLANK_M, OVERHOOK_*, ELBOW_* moved to ClinchPose.gd with the functions that use them.
const ClinchPose := preload("res://scripts/fight3d/ClinchPose.gd")
## S354 the tie is set up as they come together, and the pair is only TIED once it has come in: the join draws the tie's
## pose over the punch she was throwing in ~0.3 s, and samples of that blend (heads 0.62 m apart, chests square) are not
## samples of a tie-up. Same for the spacing: it eases in from start() (taken from the inside range it used to pull the
## pair 0.19 m apart in one frame).
const TIE_SET_S := 0.4
const TIE_SLACK_M := 0.06
## S469 (the seed-4242 film: a tie called right after a landed cross - both reached for each other from punching range,
## one still rocked back: straight arms, gloves 13 cm through gloves, 18 frames). The hands go for the tie only once the
## pair stands within an arm of it and neither is in a hit reaction; then they get HANDS_S to arrive before it is TIED.
## `-- farhands` = the old rule (hands from the beat's own frame).
const HANDS_M := 0.85
const HANDS_S := 0.3
static var FAR_HANDS: bool = OS.get_cmdline_user_args().has("farhands")
## S354: the pair's own clip starts only once the two stand this close to the tie's gap. It is not a step clip
## (Footwork.can_step wants a guard or a fidget), so starting it on the beat's own frame froze the holder mid-ring - one
## round measured three of its four holds never closing a centimetre and timing out. The clinch band is 0.06 m
## (Footwork.BAND_M), so this must clear that: at the band's far edge no further step is issued.
const NEAR_M := 0.07
## S354 the A-frame (spec 2): the trunk leans forward from the pelvis (CornerIK.upright, after the clip, so the animation
## cannot undo it) - chests in, hips back. The pair clip already leans them in (pelvis gap - chest gap 0.36 m); the lean
## adds the "leaning her weight on the other" read without driving the heads inside each other's guard.
const LEAN_DEG := 8.0
## S354 measured: on top of the clip's own 0.36 m A-frame an 8 deg trunk lean brought the head bones to 0.13 m apart
## (GloveClear's 0.19 m does not survive a lean applied after it) and sank the head bone to the shoulder line, where the
## clip's own cross-body tie cannot put a glove under it. The clip IS the A-frame; our own block pose needs the lean.
const PAIR_LEAN_DEG := 0.0
## S354 the jostle (spec 4): over one hold the pair turns this far about its middle (eased in) and the holder walks the
## other back - hips and feet travel, and the planted feet carry it as shuffle steps. Direction from the stage's rng (no
## randf(): a seeded fight plays the same, S341 note 6).
const TURN_DEG := 34.0
const JOSTLE_S := 1.1
const DRIFT_M := 0.26
const DRIFT_RATE := 0.06      # it keeps creeping this fast after the turn: a 3-5 s hold is never a freeze
## S354 the digs (spec 5): the digger's free hand (the arm NOT in the overhook) leaves the tie, lands on the other's ribs
## and comes back - hand travel DIG_TIE out/up to DIG_OFF_M, ~0.35 s out and back, spaced over the hold. The IK drives the
## WRIST and the glove's centre is GLOVE_FWD_M further along the forearm (Gloves, GloveClear), so the wrist is aimed that
## far back down the arm for the glove's centre to land on the ribs.
const GLOVE_FWD_M := 0.08
const DIG_OFF_M := 0.05
## The tie the free hand comes back to: out to the side, level with the ribs - the elbow comes up and the hook drives in.
## (A hand raised 0.18 m above the ribs put its own glove 0.01 m under its own head: spec 3's 0.07 m bound, S354 probe.)
const DIG_TIE_OUT := 0.28
const DIG_TIE_UP := 0.02
const DIG_OUT_S := 0.18
const DIG_DWELL_S := 0.24
const DIG_BACK_S := 0.28
const DIG_GAP_S := 0.55
const DIG_FIRST_S := 0.9

var stage: Node
var holder := -1
var engaged := false
var _w := 0.0
var _left := 0.0
var _pose := ""
var _pair := false
# S354: the tie's own state.
var _dur := 3.0
var _digs := 0
var _digger := -1
var _pitch := 1.0             # seconds between dig starts
var _tie := 0.0               # the tie's spacing and pose, eased in from start()
var _clock := 0.0             # seconds since start(): the pose must come in before the pair is TIED
var _clip_t := 0.0            # seconds the tie's own clip has run (the pair clips only: the pose path uses _clock)
var _hold := 0.0              # seconds since the engage (the jostle and dig clock)
var _hands_t := -1.0          # seconds the tie's hands have been reaching (-1: not yet)
var _mid := Vector3.ZERO
var _axis := Vector3.BACK
var _gap := 0.0
var _turn := 1.0
var _drift := Vector3.ZERO


func setup(s: Node) -> void:
	stage = s
	name = "Clinch"
	_pair = stage.has_move("clinch_att") and stage.has_move("clinch_vic")
	for p in POSES:
		if stage.has_move(p):
			_pose = p
			break


## A "clinch" beat: `who` ties up for about `dur` seconds (the break releases it; this is the safety net).
## S354: the beat may carry `digs` (0-3) and `digger` (ClinchBeats: the woman who is NOT tying up works the body); with
## no digger named, the opponent digs. The two extra arguments default, so the S313 call `start(who, dur)` still works.
func start(who: int, dur: float, digs: int = 0, digger: int = -1) -> void:
	holder = who
	engaged = false
	_left = dur + 1.5
	_dur = maxf(dur, 1.0)
	_digs = clampi(digs, 0, 3)
	_digger = digger if _digs > 0 and digger >= 0 else (1 - who if _digs > 0 else -1)
	_pitch = clampf((_dur - DIG_FIRST_S - 0.35) / float(maxi(_digs, 1)), 0.5, 1.3)
	_tie = 0.0
	_clock = 0.0
	_clip_t = 0.0
	_hold = 0.0
	_hands_t = -1.0
	_turn = 1.0 if stage.life.rng.randf() < 0.5 else -1.0
	PushOff.cancel(stage)
	_tie_up()


func release() -> void:
	if holder < 0:
		return
	var was := engaged
	holder = -1
	engaged = false
	_digs = 0
	_digger = -1
	_hold = 0.0
	_clip_t = 0.0
	if was:
		stage.life.cancel(0)
		stage.life.cancel(1)
	PushOff.begin(stage)


## The closest the two may stand: the tie's own gap while tied, easing back to the stage's `base` as they let go (no snap
## apart). S354: (a) the tie's gap eases IN from start(); (b) while tied, the range machine's want IS the tie's gap, so
## the holder stops walking into her own floor - RangeBreath's CLINCH_M 0.38 is below the pair clips' 0.77, so she was
## mid-step on every frame of the hold: nobody was ever standing, the tie-up never engaged at all, and the live pair was
## dragged across the canvas for the whole hold. floor_m runs inside RingPlace.compose right before feet.aim_step.
func floor_m(base: float) -> float:
	var tied := PAIR_GAP_M if _pair else MIN_M
	var feet: Object = stage.get("feet")
	if holder < 0:
		if PushOff.active():
			if feet != null:
				feet.set("want_m", PushOff.gap)
			return PushOff.gap
		return lerpf(base, tied, _w)
	var gap := lerpf(base, tied, _tie)
	# Footwork is a RefCounted, not a Node (S354: typed as Node this line threw on every frame of every hold and the range
	# machine kept RangeBreath's CLINCH_M, so the walk-in never had a gap to stop at).
	if feet != null:
		feet.set("want_m", gap)
	return gap


## The shown body's shift (FightStage._compose adds it like the punch carry): her own left of the line to the other.
func offset(_i: int, to: Vector3) -> Vector3:
	if _pair or _w <= 0.0 or to.length() < 0.01:
		return Vector3.ZERO
	return Vector3.UP.cross(to.normalized()) * SIDE_M * _w * _w * (3.0 - 2.0 * _w)


func _process(delta: float) -> void:
	_w = move_toward(_w, 1.0 if engaged else 0.0, delta / (EASE_S if engaged else RELEASE_S))
	_tie = move_toward(_tie, 1.0 if holder >= 0 else 0.0, delta / EASE_S)
	PushOff.step(stage, delta)
	if holder < 0:
		return
	_clock += delta
	_left -= delta
	if _left <= 0.0:
		release()
		return
	var dist := (stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"])
	var want := (PAIR_GAP_M if _pair else ENGAGE_M) + TIE_SLACK_M
	if not engaged and dist > PAIR_GAP_M and _free(0) and _free(1):
		var p0: Vector3 = stage.boxers[0]["pos"]
		var p1: Vector3 = stage.boxers[1]["pos"]
		var dir := (p1 - p0).normalized()
		var close_m := minf(dist - PAIR_GAP_M, delta * 0.9)
		stage.boxers[holder]["pos"] = (p0 + dir * close_m) if holder == 0 else (p1 - dir * close_m)
		dist = (stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"])
	# S354: the pair is TIED once it stands at the tie's spacing and the tie's own clip has had TIE_SET_S to come in. The
	# clip is the clock (the pose path has no clip and keeps _clock): a hold whose first sample lands mid-join reads the
	# old pose - the r1 run measured a head gap of 0.62 m on the engage frame.
	if _pair and not FAR_HANDS:
		if _hands_t < 0.0 and dist <= HANDS_M and _free(0) and _free(1):
			_hands_t = 0.0
			for i in 2:
				if stage.boxers[i].get("ik") != null:
					_stance(i, stage.boxers[i]["ik"])
		elif _hands_t >= 0.0:
			_hands_t += delta
	var set_t := _clip_t if _pair else _clock
	var hands_set := not _pair or FAR_HANDS or _hands_t >= HANDS_S
	if not engaged and set_t >= TIE_SET_S and hands_set and dist <= want and _free(0) and _free(1):
		_engage()
	_hold_clips(delta)
	if not engaged:
		return
	_hold += delta
	_jostle()
	_dig()


## The clip of the tie-up on both bodies (the pair halves in step, or the block pose held mid-loop), looping its span.
## S354: with the pair clips the two first have to WALK to the tie's spacing - while they do, they keep their own guard so
## Footwork can still hand out the step (can_step: a guard or fidget clip only). The pose itself (the hands, the lean) is
## already tying from the beat's own frame: _tie_up runs in start().
func _hold_clips(delta: float) -> void:
	if _pair:
		var far := (stage.boxers[0]["pos"] as Vector3).distance_to(stage.boxers[1]["pos"]) > PAIR_GAP_M + NEAR_M
		if _clip_t <= 0.0 and far:
			return
		for i in 2:
			var clip := "clinch_att" if i == holder else "clinch_vic"
			var ap: AnimationPlayer = stage.boxers[i]["ap"]
			if str(ap.current_animation) != clip:
				stage.act(i, clip, PAIR_SPEED)
				ap.seek(PAIR_SPAN.x, true)
			elif ap.current_animation_position > PAIR_SPAN.y:
				ap.seek(PAIR_SPAN.x, true)
		# The holder always carries the attacker's half of the pair.
		if str((stage.boxers[holder]["ap"] as AnimationPlayer).current_animation) == "clinch_att":
			_clip_t += delta
		return
	if _pose == "":
		return
	for i in 2:
		var ap: AnimationPlayer = stage.boxers[i]["ap"]
		var len := ap.get_animation(_pose).length
		if str(ap.current_animation) != _pose:
			stage.act(i, _pose, HOLD_SPEED)
			ap.seek(len * HOLD_SPAN.x, true)
		elif ap.current_animation_position > len * HOLD_SPAN.y:
			ap.seek(len * HOLD_SPAN.x, true)


## Not mid-step and not locked in a hit reaction.
func _free(i: int) -> bool:
	return float(stage.boxers[i]["move_left"]) <= 0.0 and stage.stun.left(i) <= 0.0


## The tie's pose, hands and trunk, set the moment the beat fires: they come in over the join (and CornerIK's own EASE_S)
## while the pair walks in, so the tie is already drawn the frame the spacing is reached.
func _tie_up() -> void:
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik == null:
			continue
		ik.upright(-PAIR_LEAN_DEG if _pair else -LEAN_DEG)
		if _pair and FAR_HANDS:
			_stance(i, ik)


## The hands the paired clip cannot claim: its own are a cage clinch (S318: the lead glove rides 6 cm above the holder's
## own head, cupping the other's head; the other's hands sit on the holder's arms at head height). Spec 3: the holder's
## arm over the other's arm with the hand on the UPPER BACK below the shoulder, the other's hand on the holder's flank -
## their elbows are up by the heads, and a grip on an elbow put a glove at head height (S354 probe: 0.10 m above the
## holder's own head, 0.00 m under the other's).
func _stance(i: int, ik: Node) -> void:
	if i == holder:
		var hs := ClinchPose.lead(stage, holder)
		ik.reach(hs, ClinchPose.blade.bind(stage, 1 - holder, ClinchPose.other_side(hs)))
		if _digger == holder:
			ik.reach(_free_side(), _dig_target.bind(1 - holder, _free_side()))
		else:
			# Spec 3 both arms read as a tie: the other hand takes the other shoulder blade (her right hand meets the
			# other's left side). Leaving it to the clip put a cage-clinch glove on her arm, 0.09 m inside it at the
			# tie's own spacing.
			ik.reach(_free_side(), ClinchPose.blade.bind(stage, 1 - holder, hs))
	else:
		var grip := ClinchPose.lead(stage, holder)
		ik.reach(grip, ClinchPose.grip.bind(stage, holder, grip))
		if _digger == i:
			ik.reach(_free_side(), _dig_target.bind(holder, _free_side()))


func _engage() -> void:
	engaged = true
	_hold = 0.0
	_mid = ((stage.boxers[0]["pos"] as Vector3) + (stage.boxers[1]["pos"] as Vector3)) * 0.5
	var d: Vector3 = (stage.boxers[1]["pos"] as Vector3) - (stage.boxers[0]["pos"] as Vector3)
	_axis = d.normalized() if d.length() > 0.01 else Vector3.BACK
	_gap = PAIR_GAP_M if _pair else MIN_M
	# The holder leans on her: the pair walks the other way (a shuffle of steps), plus a little off the line.
	var left := Vector3.UP.cross(_axis)
	var rng: RandomNumberGenerator = stage.life.rng
	_drift = (_axis * (-1.0 if holder == 0 else 1.0) - left * rng.randf_range(-0.35, 0.35)).normalized()
	if _pair:
		return
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik == null:
			continue
		var other := 1 - i
		# Facing each other, her left hand meets the other's right side.
		# S316: the holder overhooks - each arm over the other's arm at the elbow, pinning it (was: a hug around the
		# shoulders); the held boxer's gloves stay on the holder's ribs (she can only work the body).
		if i == holder:
			ik.reach("Left", ClinchPose.overhook.bind(stage, other, "Right"))
			ik.reach("Right", ClinchPose.overhook.bind(stage, other, "Left"))
		else:
			ik.reach("Left", ClinchPose.flank.bind(stage, other, -1.0))
			ik.reach("Right", ClinchPose.flank.bind(stage, other, 1.0))
		ik.look(ClinchPose.past.bind(stage, other))
	if _digger >= 0:
		var ik2: Node = stage.boxers[_digger].get("ik")
		if ik2 != null:
			ik2.reach(_free_side(), _dig_target.bind(1 - _digger, _free_side()))


## S354 the jostle: the pair turns about its own middle (equal and opposite), easing in, and the holder walks the other
## back - a slow drift the planted feet carry as shuffle steps. RingPlace faces each body at the other, so turning the two
## canvas positions turns both bodies. Written into `pos` (not a shown offset): the feet, the facing and the camera all
## follow it, and the pair's distance stays the tie's own.
func _jostle() -> void:
	var e := ClinchPose.smooth(clampf(_hold / JOSTLE_S, 0.0, 1.0))
	var ang := deg_to_rad(TURN_DEG) * _turn * e
	var walk := _drift * (DRIFT_M * e + DRIFT_RATE * maxf(0.0, _hold - JOSTLE_S))
	var mid := _mid + walk
	var half := _axis * (_gap * 0.5)
	stage.boxers[0]["pos"] = mid - half.rotated(Vector3.UP, ang)
	stage.boxers[1]["pos"] = mid + half.rotated(Vector3.UP, ang)


## The digger's free hand on its arc: out to the ribs, held there a beat, back to the tie; the digs spaced over the hold.
func _dig() -> void:
	if _digger < 0 or _digs <= 0:
		return
	var ik: Node = stage.boxers[_digger].get("ik")
	if ik != null:
		ik.reach(_free_side(), _dig_target.bind(1 - _digger, _free_side()))


## The IK drives the WRIST and the glove's centre - what lands on the ribs - rides GLOVE_FWD_M up the glove's own long
## axis (Gloves: the node stands on the wrist with its +Y the glove's axis; GloveClear measures the centre the same way).
## The axis is read off the glove node, which follows the skeleton AFTER the IK: last frame's shown glove, not a guess
## from the clip's arm - guessing it left the centre 0.09 m off its mark and the dig 0.13 m short of the ribs (S354).
func _dig_target(other: int, side: String) -> Vector3:
	var want := _dig_point(other, side)
	var g: Node3D = (stage.boxers[_digger]["gloves"] as Node).gloves.get("l" if side == "Left" else "r")
	if g == null:
		return want
	return want - g.global_transform.basis.y.normalized() * GLOVE_FWD_M


## The dig's own point: 0 = the glove centre on the ribs, 1 = the hand back up at the tie (a short hook's start). The ribs
## are the spine_02/03 band on the side the free hand meets (spec 5), and the dig lands on the point of that band her arm
## can reach: the pair stands a chest apart, and the band's lower end is 0.62 m from a 0.49 m arm (S354 probe: the glove
## stopped 0.16 m short of the flank point there).
func _dig_point(other: int, side: String) -> Vector3:
	var ribs := ClinchPose.closest(ClinchPose.bone(stage, _digger, side + "UpperArm"), ClinchPose.rib_band(stage, other, side))
	var left := Vector3.UP.cross(ClinchPose.fwd(stage, other)).normalized()
	var out := left * (1.0 if side == "Right" else -1.0)
	var k := _dig_k()
	return ribs + out * lerpf(DIG_OFF_M, DIG_TIE_OUT, k) + Vector3.UP * DIG_TIE_UP * k


## How far into the tie's own hand the dig is now: 1 between digs, 0 on the ribs, eased out and back over ~0.35 s.
func _dig_k() -> float:
	var t := _hold - DIG_FIRST_S
	if t < 0.0:
		return 1.0
	var k := int(floor(t / _pitch))
	if k >= _digs:
		return 1.0
	var s := t - float(k) * _pitch
	if s < DIG_OUT_S:
		return 1.0 - ClinchPose.smooth(s / DIG_OUT_S)
	if s < DIG_OUT_S + DIG_DWELL_S:
		return 0.0
	var back := (s - DIG_OUT_S - DIG_DWELL_S) / DIG_BACK_S
	return 1.0 if back >= 1.0 else ClinchPose.smooth(back)


## The digger's free hand: the arm NOT in the overhook. The holder overhooks with her lead hand and the held boxer grips
## with the hand that faces the holder's other arm, so for both diggers the free hand is the one on the side of the
## holder's OWN free arm (S318 `_stance`).
func _free_side() -> String:
	return ClinchPose.other_side(ClinchPose.lead(stage, holder))
