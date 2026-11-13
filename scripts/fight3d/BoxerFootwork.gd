extends RefCounted
## FOOTWORK1 (S381, operator on every walk clip we had: "those clips are all terrible how we will fix the walking
## animations? and hopping feeling like other fighting game have ?"). Procedural boxer footwork under the guard's upper
## body: a bounce on the balls of the feet, and step-drag steps where the body travels only as far as the feet are put
## down (the centre of the stance IS the midpoint of the two feet - StepRoot's idea, by construction). Pure: no nodes;
## BoxerFootworkRig.gd puts it on the skeleton. World metres, a 1.78 m boxer (x `scale`).
## Numbers (E:/FightCamp/tmp/undisputed_study/footwork_S381.md + the S381 real-boxer sheet; real wins where they differ):
##   bounce 2.2 Hz (real 2.2-2.4; Undisputed idle 2.0, IQR 1.8-2.3), hips 3.6 cm p2p in place, 5 cm on a step pair, most
##   of it from the heels (round 3, operator on 7 cm: "his ass is bouncing"; Undisputed idle 7.2, IQR 3.9-9.6);
##   round 2 (eyes on r3: "a perfectly regular sine, metronomic, always on"): each bounce
##   draws its own period and depth (sd 13 % / 15 %, seeded - a human, not a metronome), and the boxer drops into
##   FLAT-FOOTED spells (a 1 cm breathing bob, heels down, smaller slower shuffle steps; real boxers bounce ~25-35 % of
##   a bout - here `bounce_share`, 0.55 by default for the game's hop feel, set it lower for realism);
##   weight leg to leg once a breath (S453 C369; was half the bounce rate): the hips sway 2.5 cm toward the loaded foot and its heel sinks while the
##   other heel rises (Undisputed L/R foot height correlation -0.26); a planted ball NEVER leaves the canvas (r3 had a 2 cm
##   toe-off "hop" - one boot hovered; Undisputed idle 0 % airborne) - the hop feel is the hips and the heels;
##   heels: rear 1.6-4.8 cm, lead 1-3.8 cm over the bounce (round 3; r4c rear 1.6-3.4, lead 1.2-2.4; Undisputed heel
##   rise p90 2 cm, rhythm idles more; round 1 with 1 cm read as standing still), flat-footed rear 1.2, lead 0;
##   stance (balls of the feet) 0.50 m along x 0.32 m across = ankles ~0.46 x ~0.23 with the rear foot 40 deg out (real
##   coach 0.47-0.57; Undisputed 0.62 = 0.56 along x 0.18 across; round 2: >= 0.18 across so the 3/4 view never bunches);
##   step 0.26 m, 0.25 m sideways (real one foot length 0.27-0.30), x `size`; step-drag order (real): forward lead first,
##   back rear first, sideways the near foot first; one pair per bounce, each foot 0.23-0.25 s in the air, the second
##   lifting as the first lands (Undisputed 0.17-0.18 s apart); swing clearance 4.5 cm (2.5 flat-footed);
##   upper body (round 2): the chest follows the hips' bounce 0.065 s late, the head nods 0.12 s late, the shoulders
##   counter-rotate 4 deg against each step (a foot going forward on her left turns the chest to her left).
## S391 wired into the ring (RingFeet.gd): go(to, dur) = one step pair onto any spot NOW (the fight cannot wait for the top
## of a bounce; the bounce is warped so the pair is one bounce); place(at, yaw) = stand there, no step; hold_want = the
## bounce calms under a punch (set each frame by the caller, 1 = throwing).
##   new(start, yaw, south, scale, seed)  step(dir, size)  face(yaw)  go(to, dur)  place(at, yaw)  tick(dt)
##   pose() -> {centre, yaw, hip, feet, ...}

const BOUNCE_HZ := 2.2
const HZ_SD := 0.18            # each bounce's rate: x (1 + N(0, sd)), clamped +-35 % (bottom-to-bottom CV ~0.13)
const AMP_SD := 0.15           # each bounce's depth, clamped +-30 %
## Round 3 (operator on r4c_side: "his ass is bouncing more than usual"; probe: hips 7.3 cm p2p a bounce, 6.3 of it from
## the knees at 24 deg a bounce, 1.1 from the ankles): the hips dip half as far and the heels carry most of it.
const BOUNCE_M := 0.036        # hip dip, peak to peak, bouncing in place (r4c 0.07)
const MOVE_BOUNCE_M := 0.048   # on a step pair (r4c 0.09)
const SIT_M := 0.018           # bouncing, the hips sit this much lower (the dip's lost half): r4c's mean knee bend
const MOVE_SIT := 0.6          # ... plus this much of a step pair's extra dip
const FLAT_M := 0.012          # flat-footed: a breathing bob
const FLAT_SIT := 0.035        # ... with the hips this much lower (r4a look: heels down + no dip = locked-out legs)
const AMP_EASE_S := 0.25
const SPRING_EASE_S := 0.5     # bounce <-> flat-footed blend
const BOUNCE_SPELL := Vector2(3.0, 6.0)   # seconds
const STANCE_LEN := 0.50       # ball to ball along the fight line
const STANCE_WID := 0.32       # across it
const STEP_M := 0.26
const SIDE_STEP_M := 0.25
const FLAT_STEP := 0.65        # flat-footed steps are this much of a bouncing one ...
const FLAT_DUR := 1.25         # ... and take this much longer
const LIFT_M := 0.045          # a stepping foot's clearance
const FLAT_LIFT_M := 0.025
const HEEL_REAR := Vector2(0.016, 0.048)   # heel height at the bottom / top of the bounce (r4c 1.6-3.4 cm)
const HEEL_LEAD := Vector2(0.010, 0.038)   # (r4c 1.2-2.4 cm; round 3: the bounce reads from the ankles, balls planted)
const HEEL_FLAT := Vector2(0.0, 0.012)     # lead, rear flat-footed
const HEEL_WEIGHT := 0.008     # the unloaded heel rises, the loaded one sinks, this much each way at full sway
const HEEL_SWING := 0.05       # extra heel on toe-off, mid-swing it eases back
const HEEL_BALL_M := 0.18      # heel to ball of the foot (pitch = asin(heel / this))
const REAR_YAW_DEG := -32.0    # orthodox: the rear toes turn 32 deg to her right (round 2: 45 -> 32, the rear knee caved)
const LEAD_YAW_DEG := 0.0
const SWAY_M := 0.025          # hips leg to leg along the stance line, once a breath (S453) ...
const SWAY_FA := 0.55          # ... its fore-aft part cut to this (r4c: 2 cm fore-aft a bounce, the backside pushing back)
const CHEST_LAG_S := 0.065
const NOD_LAG_S := 0.12
const NOD_DEG := 2.5
const TWIST_DEG := 4.0
const FIRST := Vector2(0.0, 0.52)    # the first foot's swing, as a fraction of the pair (one bounce)
const SECOND := Vector2(0.46, 0.98)
const TURN_DEG := 14.0         # facing off by more than this with no step queued: a turning step
const HOLD_EASE_S := 0.12      # S391: the bounce calms and comes back this fast around a punch
const HOLD_CALM := 0.8         # ... by this much of its depth, its heels and its leg-to-leg sway
const HZ_WARP := Vector2(1.3, 5.0)   # S391 go(): the bounce rate while it catches up with a pair
## S391 a punch drives off the foot on its side: the heel comes up and the foot turns in on its ball (a rear hand on the rear
## foot, a lead hook on the lead foot). With the feet held still under a punch the legs read dead.
const PIVOT_HEEL_M := 0.055
const PIVOT_DEG := 26.0
const PIVOT_EASE_S := 0.1
## S391 a step opens the stance past its length: the hips sink into it this much per metre (real boxers sit into a lunge; on
## straight legs the trailing foot was dragged, tools/ring_feet_probe.gd).
const NEAR_FROM := 0.6         # S391 go(): sideways past this share of the way forward or back, the near foot goes first (else a
                               # diagonal's rear foot, going first, passes the lead foot: ring_feet_test read -0.04 m across)
## S391 a foot never lands on the other boxer's: its landing keeps this far from her balls (keep_off, world x/z; set each frame
## by the caller), moved straight away from them. centre() ignores the nudge: the stance she means stays where the fight put it.
## (tools/ring_feet_probe.gd: 28 % of a round under 0.2 m, down to 0.00 m, when both lead feet shared a side.)
const BOOT_M := 0.22
const WIDE_SIT := 0.4
const WIDE_FROM_M := 0.3       # ... past this: a calm pair keeps the bounce the operator approved, only a lunge sinks
const LEAD := 0
const REAR := 1
## step dir -> [body-frame step (x = her left, y = forward) as a fraction of STEP_M/SIDE_STEP_M, which foot first]
const DIRS := {"fwd": [Vector2(0, 1), "lead"], "back": [Vector2(0, -1), "rear"], "left": [Vector2(1, 0), "near"],
	"right": [Vector2(-1, 0), "near"], "turn": [Vector2.ZERO, "rear"]}

var scale := 1.0
var side := 1.0                # +1 orthodox (lead foot on her left, +X), -1 southpaw
var yaw := 0.0                 # facing: +Z turned by yaw about +Y (Godot Basis(UP, yaw))
var want_yaw := 0.0
var phase := 0.0               # bounce phase: 0 = top, 0.5 = bottom of the dip
var beats := 0                 # whole bounces so far (the weight shift runs at half the rate)
var hz := BOUNCE_HZ            # this bounce's rate
var depth := 1.0               # this bounce's depth factor
var amp := BOUNCE_M
var spring := 1.0              # 1 = bouncing on the balls, 0 = flat-footed
var moving := 0.0              # 1 = on a step pair (eased): the hips sit MOVE_SIT of the extra dip lower
var bouncing := true
var auto_flat := true          # spells of flat-footed between the bouncing ones (tests switch it off)
var bounce_share := 0.55
var hold := 0.0                # S391: 1 = the caller is throwing (the bounce calms)
var hold_want := 0.0
var keep_off: Array = []       # S391: the other boxer's balls and landings (Vector2)
var pivot := [0.0, 0.0]        # S391: per foot [lead, rear] 1 = driving off it (pivot_want set each frame by the caller)
var pivot_want := [0.0, 0.0]
var spell := 0.0               # seconds left in this spell
## S453 (operator C369 on the block reel: "you got to tune the often hip movement with the breathing effect"): the weight
## goes leg to leg once a BREATH, not once a bounce (it flipped every bounce, 1.1 Hz, against a 0.24-0.34 Hz breath): onto
## the lead foot as her chest lifts on the in-breath, back on the long out-breath. breath_of = her FighterLife (its breath
## phase _bp, so hips and chest move as one); without one (nolook, tests) her own clock at breath_hz.
var breath_hz := 0.30
var breath_of: Object = null
var _bph := 0.0
var time := 0.0
var rng := RandomNumberGenerator.new()
var queue: Array = []          # [dir, size]
var pair: Dictionary = {}      # the step pair under way
var feet: Array = []           # [lead, rear]: {at: Vector2 (world x, z), yaw: float, swing: {} | {from, to, yaw0, yaw1, u}}
var done_pairs: Array = []     # finished pairs: {dir, first, centre0, centre1, moved: [Vector2, Vector2]} (tests read it)
var periods: Array = []        # each finished bounce's length in seconds (tests read it)


func _init(start: Vector2 = Vector2.ZERO, facing: float = 0.0, south: bool = false, body_scale: float = 1.0, rng_seed: int = 381) -> void:
	scale = body_scale
	side = -1.0 if south else 1.0
	yaw = facing
	want_yaw = facing
	rng.seed = rng_seed
	_bph = float(rng_seed % 97) / 97.0   # her own breath's start (no rng draw: the seeded bounce sequence stays as it was)
	spell = rng.randf_range(BOUNCE_SPELL.x, BOUNCE_SPELL.y)
	for i in 2:
		feet.append({"at": start + rot(offset(i), yaw), "yaw": yaw + foot_yaw(i), "swing": {}, "nudge": Vector2.ZERO})


## A foot's spot from the stance centre in her own frame (x = her left, y = forward).
func offset(i: int) -> Vector2:
	var s := 1.0 if i == LEAD else -1.0
	return Vector2(side * s * STANCE_WID * 0.5, s * STANCE_LEN * 0.5) * scale


func foot_yaw(i: int) -> float:
	return deg_to_rad(LEAD_YAW_DEG if i == LEAD else REAR_YAW_DEG * side)


## Body frame (x left, y forward) -> world (x, z), turned by `a`.
static func rot(v: Vector2, a: float) -> Vector2:
	return Vector2(v.x * cos(a) + v.y * sin(a), -v.x * sin(a) + v.y * cos(a))


## World (x, z) -> her frame at facing `a`.
static func unrot(v: Vector2, a: float) -> Vector2:
	return Vector2(v.x * cos(a) - v.y * sin(a), v.x * sin(a) + v.y * cos(a))


func centre() -> Vector2:
	return ((feet[LEAD]["at"] as Vector2) - (feet[LEAD]["nudge"] as Vector2) + (feet[REAR]["at"] as Vector2) - (feet[REAR]["nudge"] as Vector2)) * 0.5


## The spot foot landings must keep off, for the other boxer: both balls and where a step under way lands them.
func spots() -> Array:
	var out: Array = [feet[LEAD]["at"], feet[REAR]["at"]]
	if not pair.is_empty():
		out.append_array(pair["land"])
	return out


## `at` moved straight out of keep_off's circles.
func _clear(at: Vector2) -> Vector2:
	for spot in keep_off:
		var d: Vector2 = at - (spot as Vector2)
		if d.length() < BOOT_M:
			at = (spot as Vector2) + (d.normalized() if d.length() > 0.01 else rot(Vector2(side, 0.0), yaw)) * BOOT_M
	return at


## Queue one step pair: "fwd", "back", "left", "right" (her left/right); `size` scales its length (range work: 0.5).
func step(dir: String, size: float = 1.0) -> void:
	if DIRS.has(dir):
		queue.append([dir, size])


## Face this way; the next step lands the feet square to it (a standing boxer turns by stepping, never by twisting on
## planted feet). With nothing queued a turning step goes in once she is off by TURN_DEG.
func face(a: float) -> void:
	want_yaw = a


func busy() -> bool:
	return not pair.is_empty() or not queue.is_empty()


func tick(dt: float) -> void:
	time += dt
	_bph += dt * breath_hz
	if auto_flat:
		spell -= dt
		if spell <= 0.0:
			bouncing = bounce_share >= 1.0 or (bounce_share > 0.0 and not bouncing)
			# bounce spells 3-6 s; flat ones sized so bouncing fills `bounce_share` of the time
			var mean_b := (BOUNCE_SPELL.x + BOUNCE_SPELL.y) * 0.5
			spell = rng.randf_range(BOUNCE_SPELL.x, BOUNCE_SPELL.y) if bouncing else \
				mean_b * (1.0 - bounce_share) / maxf(bounce_share, 0.05) * rng.randf_range(0.6, 1.4)
	spring = move_toward(spring, 1.0 if bouncing else 0.0, dt / SPRING_EASE_S)
	hold = move_toward(hold, hold_want, dt / HOLD_EASE_S)
	for i in 2:
		pivot[i] = move_toward(float(pivot[i]), float(pivot_want[i]), dt / PIVOT_EASE_S)
	var target := lerpf(FLAT_M, (MOVE_BOUNCE_M if busy() else BOUNCE_M) * depth, spring * (1.0 - hold * HOLD_CALM))
	amp = move_toward(amp, target, absf(MOVE_BOUNCE_M - FLAT_M) * dt / AMP_EASE_S)
	moving = move_toward(moving, 1.0 if busy() else 0.0, dt / AMP_EASE_S)
	var before := phase
	phase += dt * hz
	if phase >= 1.0:
		phase -= 1.0
		beats += 1
		periods.append(1.0 / hz)
		hz = BOUNCE_HZ * (1.0 + clampf(rng.randfn(0.0, HZ_SD), -0.35, 0.35))
		depth = 1.0 + clampf(rng.randfn(0.0, AMP_SD), -0.3, 0.3)
	if not pair.is_empty():
		_run_pair(dt)
	if pair.is_empty() and phase < before:   # a new bounce starts at its top: the moment to step
		if queue.is_empty() and absf(wrapf(want_yaw - yaw, -PI, PI)) > deg_to_rad(TURN_DEG):
			queue.append(["turn", 1.0])
		if not queue.is_empty():
			var q: Array = queue.pop_front()
			_start_pair(str(q[0]), float(q[1]))
			_run_pair(phase / hz)


func _start_pair(dir: String, size: float) -> void:
	var d: Array = DIRS[dir]
	var v: Vector2 = d[0]
	var k := size * lerpf(FLAT_STEP, 1.0, spring)
	var local := Vector2(v.x * SIDE_STEP_M, v.y * STEP_M) * scale * k
	var first := LEAD
	match str(d[1]):
		"rear":
			first = REAR
		"near":   # the foot on the side she moves to: her lead foot sits on her left (side +1)
			first = LEAD if v.x * side > 0.0 else REAR
	_begin(dir, first, centre() + rot(local, yaw), lerpf(FLAT_DUR, 1.0, spring) / hz)


## The pair onto stance centre `c1`, turning toward want_yaw (at most 40 deg a pair).
func _begin(dir: String, first: int, c1: Vector2, dur: float) -> void:
	var yaw1 := yaw + clampf(wrapf(want_yaw - yaw, -PI, PI), -deg_to_rad(40.0), deg_to_rad(40.0))
	var to: Array = []
	var land: Array = []
	for i in 2:
		to.append(c1 + rot(offset(i), yaw1))
		land.append(_clear(to[i]))
	pair = {"dir": dir, "first": first, "u": 0.0, "dur": dur, "yaw0": yaw, "yaw1": yaw1,
		"c0": centre(), "from": [feet[LEAD]["at"], feet[REAR]["at"]], "to": to, "land": land, "lifted": [false, false]}


## S391: one step pair onto stance centre `to`, now, over `dur` seconds. Real step-drag order from the way it goes in her
## frame: forward the lead foot first, back the rear, sideways the near foot. The bounce catches up to end with the pair.
func go(to: Vector2, dur: float) -> void:
	if not pair.is_empty():
		return
	var v := unrot(to - centre(), yaw)
	var first := LEAD
	var dir := "fwd"
	if absf(v.x) < absf(v.y) * NEAR_FROM:
		first = LEAD if v.y >= 0.0 else REAR
		dir = "fwd" if v.y >= 0.0 else "back"
	else:
		first = LEAD if v.x * side > 0.0 else REAR
		dir = "left" if v.x > 0.0 else "right"
	queue.clear()
	_begin(dir, first, to, dur)
	hz = clampf((1.0 - phase) / dur, HZ_WARP.x, HZ_WARP.y)


## S391: stand on stance centre `at` facing `facing`, no step (a scene hands her back; the feet are shown from here).
func place(at: Vector2, facing: float) -> void:
	yaw = facing
	want_yaw = facing
	pair = {}
	queue.clear()
	for i in 2:
		feet[i]["at"] = at + rot(offset(i), yaw)
		feet[i]["yaw"] = yaw + foot_yaw(i)
		feet[i]["swing"] = {}
		feet[i]["nudge"] = Vector2.ZERO


func _run_pair(dt: float) -> void:
	pair["u"] = float(pair["u"]) + dt / float(pair["dur"])
	var u: float = pair["u"]
	var first: int = pair["first"]
	for k in 2:
		var i := first if k == 0 else 1 - first
		var win: Vector2 = FIRST if k == 0 else SECOND
		var f: Dictionary = feet[i]
		var s := clampf((u - win.x) / (win.y - win.x), 0.0, 1.0)
		if u >= win.x and not bool(pair["lifted"][i]):
			pair["lifted"][i] = true
			f["swing"] = {"from": pair["from"][i], "to": pair["land"][i], "yaw0": f["yaw"],
				"yaw1": float(pair["yaw1"]) + foot_yaw(i), "u": 0.0, "n0": f["nudge"],
				"n1": (pair["land"][i] as Vector2) - (pair["to"][i] as Vector2)}
		if not (f["swing"] as Dictionary).is_empty():
			var sw: Dictionary = f["swing"]
			sw["u"] = s
			var e := s * s * (3.0 - 2.0 * s)
			f["at"] = (sw["from"] as Vector2).lerp(sw["to"], e)
			f["nudge"] = (sw["n0"] as Vector2).lerp(sw["n1"], e)
			f["yaw"] = lerp_angle(float(sw["yaw0"]), float(sw["yaw1"]), e)
			if s >= 1.0:
				f["at"] = sw["to"]
				f["nudge"] = sw["n1"]
				f["swing"] = {}
	var prog := clampf(u, 0.0, 1.0)
	yaw = lerp_angle(float(pair["yaw0"]), float(pair["yaw1"]), prog * prog * (3.0 - 2.0 * prog))
	if u >= 1.0 and (feet[LEAD]["swing"] as Dictionary).is_empty() and (feet[REAR]["swing"] as Dictionary).is_empty():
		yaw = float(pair["yaw1"])
		done_pairs.append({"dir": pair["dir"], "first": pair["first"], "centre0": pair["c0"], "centre1": centre(),
			"moved": [(feet[LEAD]["at"] as Vector2) - (pair["from"][LEAD] as Vector2),
				(feet[REAR]["at"] as Vector2) - (pair["from"][REAR] as Vector2)]})
		pair = {}


## 0 at the top of the bounce, 1 at the bottom of the dip: a round, hanging top and a quicker dip (a spring, not a sine).
static func dip_at(ph: float) -> float:
	var d := 0.5 - 0.5 * cos(TAU * ph)
	return pow(d, 1.5)


func dip() -> float:
	return dip_at(phase)


## 0 breathed out .. 1 at the top of the in-breath (FighterLife's curve: pow(0.5 + 0.5 sin, 1.5)).
func breath() -> float:
	var bp: float = _bph
	if breath_of != null and is_instance_valid(breath_of):
		bp = float(breath_of.get("_bp"))
	return pow(0.5 + 0.5 * sin(TAU * bp), 1.5)


## What the rig puts on the skeleton this frame. hip: offset in her frame (x left, y up, z forward), world metres.
## feet[i]: {ball: Vector3 world (y = lift off the canvas, 0 when planted), yaw (world), pitch (heel-up rad), heel (m),
## toe_pitch, planted}. chest_dy: the chest's lag behind the hips (m, + = above where the hips put it); nod: head pitch
## (rad, + = forward); twist: shoulders about the vertical (rad, + = chest turned to her left).
func pose() -> Dictionary:
	var dp := dip()
	var up := 1.0 - dp
	# leg to leg with the breath (S453 C369): the in-breath carries the weight onto the lead foot, the out-breath back
	# (+ = on the lead foot); FighterLife's own breath curve, in quick, out long
	var calm := 1.0 - hold * HOLD_CALM
	var w := (2.0 * breath() - 1.0) * calm
	var line := offset(LEAD) - offset(REAR)
	var sway := line.normalized() * SWAY_M * scale * w
	sway.y *= SWAY_FA
	# on a step pair the hips also sit lower by most of the extra dip (the rear knee of a back step, landing at the
	# bottom of the dip, stays bent and over its toes as in r4c)
	var sit := (SIT_M + (MOVE_BOUNCE_M - BOUNCE_M) * MOVE_SIT * moving) * scale * spring + FLAT_SIT * scale * (1.0 - spring)
	var spread := ((feet[LEAD]["at"] as Vector2) - (feet[REAR]["at"] as Vector2)).length() - (offset(LEAD) - offset(REAR)).length()
	sit += maxf(spread - WIDE_FROM_M, 0.0) * WIDE_SIT
	var hip := Vector3(sway.x, -amp * scale * dp - sit, sway.y)
	var out_feet: Array = []
	var twist := 0.0
	for i in 2:
		var f: Dictionary = feet[i]
		var heels: Vector2 = HEEL_LEAD if i == LEAD else HEEL_REAR
		var flat: float = HEEL_FLAT.x if i == LEAD else HEEL_FLAT.y
		var carry := w if i == LEAD else -w
		var heel := lerpf(flat, lerpf(heels.x, heels.y, up) - HEEL_WEIGHT * carry, spring * calm) * scale
		var lift := 0.0
		var toe_pitch := 0.0
		var sw: Dictionary = f["swing"]
		var planted := sw.is_empty()
		if not planted:
			var s: float = sw["u"]
			lift = lerpf(FLAT_LIFT_M, LIFT_M, spring) * scale * sin(PI * s)
			heel += HEEL_SWING * scale * sin(PI * minf(s * 1.6, 1.0)) * (1.0 - s)
			toe_pitch = 1.0
			# a foot going forward on her left turns the pelvis to her right; the shoulders answer the other way
			var mv := unrot((sw["to"] as Vector2) - (sw["from"] as Vector2), yaw)
			var lat := signf(offset(i).x)
			twist += deg_to_rad(TWIST_DEG) * clampf(mv.y / (STEP_M * scale), -1.0, 1.0) * lat * sin(PI * s)
		var drive: float = pivot[i] if planted else 0.0
		heel += PIVOT_HEEL_M * scale * drive
		# the rear foot turns in toward her front (it stands turned out), the lead foot the same way round her hips
		var turn_in := deg_to_rad(PIVOT_DEG) * drive * side * (1.0 if i == REAR else -1.0)
		var pitch := asin(clampf(maxf(heel, 0.0) / (HEEL_BALL_M * scale), 0.0, 0.9))
		var at: Vector2 = f["at"]
		out_feet.append({"ball": Vector3(at.x, lift, at.y), "yaw": float(f["yaw"]) + turn_in, "pitch": pitch, "heel": heel,
			"toe_pitch": toe_pitch, "planted": planted})
	var lagged := -amp * scale * dip_at(fposmod(phase - CHEST_LAG_S * hz, 1.0)) - sit
	var nod := deg_to_rad(NOD_DEG) * (dip_at(fposmod(phase - NOD_LAG_S * hz, 1.0)) - 0.4) * amp / BOUNCE_M
	return {"centre": centre(), "yaw": yaw, "hip": hip, "feet": out_feet, "chest_dy": lagged - hip.y, "nod": nod,
		"twist": twist, "spring": spring}
