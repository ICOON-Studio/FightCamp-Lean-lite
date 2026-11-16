extends RefCounted
## S498 FIGHT MOTION WEEK day 3 - heads never overlap inside (both blind critics' first fault on the r0 film: "the bodies
## pass through each other ... their heads overlap for about 0.4 s"; ruler "a head inside the other's body" 9-15 frames).
## Film r2b: every such frame is one pair of clips - a body shot against the gut-shot fold: the hitter leans in, the hit
## boxer folds forward, and the two heads meet 15-19 cm apart, hips still 0.8-1.0 m apart.
## GloveClear already leaned her trunk out of the other's head (S316), but (1) it kept the head CENTRES 19 cm apart, the
## distance at which two 20 cm heads are already 1 cm inside each other, and took the centre straight above the head bone -
## a folded head's centre is ~5 cm in front of it; (2) each boxer leaned out of 70 % of what was left AFTER the other's
## lean, a frame late: the pair settled at ~80 % of the overlap, never clear; (3) it pushed straight back, so the hitter
## was stood up off his own body shot, and it came on in one frame.
## This is the rule GloveClear runs now, as pure numbers:
##   - the heads' true centres keep TOUCH_M, starting softly SOFT_M outside it;
##   - each boxer's lean is worked out from the two heads as the CLIPS put them (no lean in the reading, so nothing chases
##     its own tail), half each; while one boxer's punch is landing he gives HOLD_SHARE and she the rest;
##   - the lean goes SIDEWAYS as much as back: each head to its own side of the line between the two (a boxer puts his
##     head outside the other's shoulder inside; he does not stand up). Dead in line, both go to their own left;
##   - it grows at most RISE_MPS and goes at most FALL_MPS, so it never pops.
## r3a film (the rule above alone): one of the two overlaps gone, the other WORSE (heads 8 cm): the gut-shot fold starts on
## the contact frame and closes the last 15 cm in ONE frame - no lean that never pops can answer that in time. A boxer
## digging to the body does not wait for it: his head is already outside her elbow when the punch lands. So the thrower of
## a body punch DIPS his head to his own side from the start of the clip (dip), DIP_M at most, the nearer the heads the
## more; his dipped head is what she reads, so her fold comes down beside it and the two sides are never in doubt.
## `-- noheadside` = the control arm (GloveClear's S316 lean, as it was).
##   want(c, hc, hips, his_hips, touch, side_last, share) -> {push: Vector3, side: int}
##   ease(prev, want, dt, rise, fall) -> Vector3     knee(over, soft) -> float     shares(mine, his) -> float
##   low_punch(clip) -> bool     dip(c, hc, hips, his_hips, side_last) -> {push: Vector3, side: int}

## The head centres keep this (two heads ~0.20 m deep and ~0.16 m wide: clear of each other with a few cm of air).
const TOUCH_M := 0.28
## The lean starts this far outside the touch (a C1 knee, as GloveClear's glove push).
const SOFT_M := 0.08
## The sideways part of the lean against its straight-back part.
const SIDE_BIAS := 0.9
## Heads nearer the line between the boxers than this have no side yet: they keep the last one, or take their own left.
const SIDE_DEAD_M := 0.03
## The lean's speed, metres a second at the head (PopCap's cap on a head is 2.7).
const RISE_MPS := 2.4
const FALL_MPS := 0.7
## The most one head leans.
const MAX_M := 0.20
## The boxer whose punch is landing gives this share of the pair's lean (his punch keeps its line); she gives the rest.
const HOLD_SHARE := 0.25
## The dip of a body punch: this far to the side with the heads DIP_NEAR_M apart or less, none from DIP_FAR_M; it comes
## and goes at DIP_MPS (a body shot's clip reaches its contact in 0.4-0.5 s).
const DIP_M := 0.11
const DIP_NEAR_M := 0.60
const DIP_FAR_M := 0.95
const DIP_MPS := 0.5
## A reach weight this much over the other's makes him "the one landing".
const HOLD_GAP := 0.3

static var on: bool = not OS.get_cmdline_user_args().has("noheadside")
static var trace: bool = OS.get_cmdline_user_args().has("headtrace")   # prints each frame a lean is wanted or shown


## The soft start: 0 until `soft / 2` outside the touch, the full overlap from `soft / 2` inside it, a parabola between.
static func knee(over: float, soft: float) -> float:
	if soft <= 0.0:
		return maxf(over, 0.0)
	if over <= -0.5 * soft:
		return 0.0
	if over >= 0.5 * soft:
		return over
	return (over + 0.5 * soft) * (over + 0.5 * soft) / (2.0 * soft)


## My share of the pair's lean from the two reach weights (0-1 each): half each, less for the one whose punch is landing.
static func shares(mine: float, his: float) -> float:
	if mine > his + HOLD_GAP:
		return HOLD_SHARE
	if his > mine + HOLD_GAP:
		return 1.0 - HOLD_SHARE
	return 0.5


## The horizontal lean (metres at the head) that takes my head centre `c` clear of the other's `hc`, both as the clips put
## them, all in one space with y up. `hips` / `his_hips` give the line between the boxers. `side_last` is the side this
## boxer leans to already, or the other boxer's (0 = none yet: read from the heads); `share` is my part of the pair's lean. Returns the lean and the side taken
## (+1 / -1 along UP x the line to the other; 0 when no lean is wanted).
static func want(c: Vector3, hc: Vector3, hips: Vector3, his_hips: Vector3, touch: float = TOUCH_M, side_last: int = 0,
		share: float = 0.5) -> Dictionary:
	var away := c - hc
	var v := absf(away.y)
	away.y = 0.0
	var h := away.length()
	# The horizontal gap that makes the 3D distance the touch (a fold drops one head well below the other).
	var need_h := sqrt(maxf(touch * touch - v * v, 0.0))
	var over := knee(need_h - h, SOFT_M)
	if over <= 0.0:
		return {"push": Vector3.ZERO, "side": 0}
	var line := his_hips - hips
	line.y = 0.0
	if line.length() < 1e-4:
		line = -away
	if line.length() < 1e-4:
		line = Vector3.FORWARD
	line = line.normalized()
	var lat := Vector3.UP.cross(line)
	var s := away.dot(lat)
	# r3c film: the fold crosses the line between the boxers at 12-18 cm a frame, so a side read from the heads each frame
	# flipped three frames running and the lean went left, right, left (14 more head jumps). A side once taken is kept
	# until the lean is over (GloveClear clears it); the two boxers take matching sides (the same sign = opposite ways).
	var side := side_last if side_last != 0 else 1
	if side_last == 0 and absf(s) > SIDE_DEAD_M:
		side = 1 if s > 0.0 else -1
	var straight := away / h if h > 1e-4 else -line
	var dir := (straight + lat * (SIDE_BIAS * float(side))).normalized()
	# How far the pair moves apart along `dir` (and its mirror) until the gap is h + over.
	var b := 2.0 * away.dot(dir)
	var c0 := h * h - (h + over) * (h + over)
	var t := 0.5 * (-b + sqrt(maxf(b * b - 4.0 * c0, 0.0)))
	return {"push": dir * minf(maxf(t, 0.0) * clampf(share, 0.0, 1.0), MAX_M), "side": side}


## The lean shown this frame: `prev` moved toward `want`, growing at most `rise` and going at most `fall` (m/s).
static func ease(prev: Vector3, want_v: Vector3, dt: float, rise: float = RISE_MPS, fall: float = FALL_MPS) -> Vector3:
	var rate := rise if want_v.length() >= prev.length() else fall
	return prev.move_toward(want_v, rate * maxf(dt, 0.0))


## A punch to the body (its thrower dips his head to the side): the Pro body shot and kidney shot, the old body hook.
static func low_punch(clip: String) -> bool:
	return clip.contains("body_shot") or clip.contains("kidney") or clip.contains("body_hook")


## The body puncher's dip: sideways only, to the side his head already is of the line between the boxers (inside
## SIDE_DEAD_M of it: his own left; a side once taken is kept), DIP_M with the heads DIP_NEAR_M apart or nearer, none
## from DIP_FAR_M.
static func dip(c: Vector3, hc: Vector3, hips: Vector3, his_hips: Vector3, side_last: int = 0) -> Dictionary:
	var away := c - hc
	away.y = 0.0
	var near := clampf((DIP_FAR_M - away.length()) / (DIP_FAR_M - DIP_NEAR_M), 0.0, 1.0)
	if near <= 0.0:
		return {"push": Vector3.ZERO, "side": 0}
	var line := his_hips - hips
	line.y = 0.0
	if line.length() < 1e-4:
		line = -away
	if line.length() < 1e-4:
		line = Vector3.FORWARD
	var lat := Vector3.UP.cross(line.normalized())
	var s := away.dot(lat)
	var side := side_last if side_last != 0 else 1
	if absf(s) > SIDE_DEAD_M and side_last == 0:
		side = 1 if s > 0.0 else -1
	return {"push": lat * (float(side) * DIP_M * near * near * (3.0 - 2.0 * near)), "side": side}


## Leans the trunk (the `bones`, hips end first) so the point `c` (skeleton space, her head's centre) moves by `push`
## (skeleton space, horizontal): each bone turns about its own joint by its part of the move.
static func lean(skel: Skeleton3D, bones: Array, c: Vector3, push: Vector3) -> void:
	var dist := push.length()
	if dist < 1e-5 or bones.is_empty():
		return
	var dir := push / dist
	for b in bones:
		var g: Transform3D = skel.get_bone_global_pose(int(b))
		var arm := c - g.origin
		var axis := arm.cross(dir)
		if axis.length() < 1e-5 or arm.length() < 1e-3:
			continue
		var q := Quaternion(axis.normalized(), dist / float(bones.size()) / arm.length())
		skel.set_bone_global_pose(int(b), Transform3D(Basis(q) * g.basis, g.origin))
		c = g.origin + q * arm
