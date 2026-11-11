extends RefCounted
## S379 C222 the TV camera rules as geometry (operator on the FIGHT9 round-9 film at 1:40.5: "the camera movement makes me
## dizzy, watch what angles are used in televised events and try to do the same, why you keep zooming in and out and rotate
## all at the same time"; the rulebook researched for it: docs/TV_CAMERA_RULES.md). TV covers a round from one elevated main
## camera on one side that holds its framing and only pans; the angle changes with a cut, never a swing; no zoom while a
## camera moves; replays are a few fixed slow-motion angles joined by straight cuts; no camera behind a boxer (S368). Pure:
## RingCamera (the live lens), KnockdownReplay (the replay's fixed angles) place their lenses with these.
##   place(a, b, prefer, dist, yaw, h, look_h, aspect) -> {lens, look, fov, off, high}   frame_fov(lens, look, pts, aspect, mx)
##   behind_deg(a, b, lens)   inside(p)   clamp_in(p)   spring(x, v, to, w, dt)   turn(ang, vel, want, dt)

## S347: every lens stands inside the ropes, IN_M in from them (the ring is 5.5 m: FightStage.RING_M * 0.5 = 2.75).
const RING_HALF_M := 2.75
const IN_M := 0.4
## A lens turns at most TURN_MAX_DEG_S (S379 preview rule 10 deg/s, kept 2 under it) and eases in and out of a turn
## (TURN_ACC deg/s^2); it closes the gap to its aim at TURN_GAIN per second and lets a smaller miss than DEAD_DEG be.
const TURN_MAX_DEG_S := 8.0
const TURN_ACC := 24.0
const TURN_GAIN := 1.8
const DEAD_DEG := 0.4
## Placing a lens at a cut: side-on to the pair, turned at most MAX_YAW off it (MAX_YAW_WIDE when nothing else fits), no
## nearer than PLACE_MIN_M (MIN_M when nothing else fits) and PLACE_CLEAR_M from either boxer, and at least PLACE_BEHIND_DEG
## off straight behind both (tools/cam_view_probe.gd counts "behind" under 45).
const MAX_YAW := 30.0
const MAX_YAW_WIDE := 40.0
const PLACE_MIN_M := 2.1
const MIN_M := 1.7
const PLACE_CLEAR_M := 1.45
const PLACE_BEHIND_DEG := 64.0
## A metre of distance is worth YAW_COST_DEG of turn off side-on (side-on first: a turned lens is nearer a boxer's back).
const YAW_COST_DEG := 25.0
## No room on either side (a corner): the lens rises to HIGH_H over the canvas, still inside the ropes.
const HIGH_H := 2.7
## The frame at a cut holds both boxers from FOOT_M (below the canvas: room under the boots) to HEAD_M (room over the
## head) with MARGIN_X metres beside them (they move while the lens rides behind them), as if they stood at least
## MIN_GAP_M apart; FOV_PAD on top. One FOV for the whole shot.
const HEAD_M := 2.15
## S426 operator: "the hud hides players feet" - the corner bar covers the bottom ~16% of the picture: the room under the
## boots stays 0.2 m and place() looks BAR_DROP_M lower than the centred frame, so the pair rides above the bar.
const BAR_DROP_M := 0.3
## S427 (his feet still went under the bar when a boxer stood near the lens): a point below the lens's line of sight may
## only use BAR_CLEAR of the lower half of the picture, the rest is the corner bar (bottom ~16% = 0.32 of that half).
const BAR_CLEAR := 0.68
const FOOT_M := -0.2
const MARGIN_X := 0.45
## Only the open middle of the picture counts: the body-map panels (FightHud) cover the outer ~17.5 % of each side.
const OPEN_W := 0.64
const MIN_GAP_M := 1.5
const FOV_PAD := 1.06
const FOV_MIN := 30.0
const FOV_MAX := 60.0


static func inside(p: Vector3) -> bool:
	var half := RING_HALF_M - IN_M
	return absf(p.x) <= half + 0.0001 and absf(p.z) <= half + 0.0001


static func clamp_in(p: Vector3) -> Vector3:
	var half := RING_HALF_M - IN_M
	return Vector3(clampf(p.x, -half, half), p.y, clampf(p.z, -half, half))


## The smallest angle, over both boxers, between "away from the other one" and "toward the lens" (flat): under 45 the lens
## is behind that boxer (tools/cam_view_probe.gd).
static func behind_deg(a: Vector3, b: Vector3, lens: Vector3) -> float:
	var best := 180.0
	for k in 2:
		var me := a if k == 0 else b
		var them := b if k == 0 else a
		var away := Vector3(me.x - them.x, 0.0, me.z - them.z)
		var to_lens := Vector3(lens.x - me.x, 0.0, lens.z - me.z)
		if away.length() > 0.01 and to_lens.length() > 0.01:
			best = minf(best, rad_to_deg(away.angle_to(to_lens)))
	return best


static func flat_gap(p: Vector3, q: Vector3) -> float:
	return Vector2(p.x - q.x, p.z - q.z).length()


## The vertical FOV (deg) that holds every point of `pts` in a 16:9 (`aspect`) frame from `lens` looking at `look`, with
## `mx` metres to spare on both sides of each, inside the open middle (OPEN_W) between the HUD's side panels.
static func frame_fov(lens: Vector3, look: Vector3, pts: Array, aspect: float, mx: float) -> float:
	var inv := Basis.looking_at(look - lens, Vector3.UP).inverse()
	var need := 0.0
	for p in pts:
		var c: Vector3 = inv * ((p as Vector3) - lens)
		var depth := -c.z
		if depth < 0.3:
			continue
		need = maxf(need, absf(c.y) / depth / (BAR_CLEAR if c.y < 0.0 else 1.0))
		need = maxf(need, (absf(c.x) + mx) / depth / (aspect * OPEN_W))
	return rad_to_deg(2.0 * atan(need))


## The side-on direction (flat) on the `prefer` side of the pair a -> b (ZERO prefer: either).
static func side_on(a: Vector3, b: Vector3, prefer: Vector3) -> Vector3:
	var ax := Vector3(b.x - a.x, 0.0, b.z - a.z)
	var perp := (ax.normalized() if ax.length() > 0.05 else Vector3.RIGHT).cross(Vector3.UP).normalized()
	return -perp if prefer.length() > 0.01 and perp.dot(prefer) < 0.0 else perp


## `p` is inside the picture of a lens at `xf` with vertical `fov` (deg) on an `aspect` frame.
static func in_view(xf: Transform3D, fov: float, aspect: float, p: Vector3) -> bool:
	var c := xf.affine_inverse() * p
	var t := tan(deg_to_rad(fov) * 0.5)
	return c.z < -0.2 and absf(c.y) <= t * -c.z and absf(c.x) <= t * aspect * -c.z


## The width / height of the picture `n` draws into (16:9 when it has none yet).
static func aspect_of(n: Node) -> float:
	var s := n.get_viewport().get_visible_rect().size if n != null and n.get_viewport() != null else Vector2.ZERO
	return s.x / s.y if s.y > 1.0 else 16.0 / 9.0


## Both boxers head to feet, spread to MIN_GAP_M along their line when they stand closer.
static func pair_points(a: Vector3, b: Vector3) -> Array:
	var mid := Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5)
	var ax := Vector3(b.x - a.x, 0.0, b.z - a.z)
	var half := maxf(ax.length(), MIN_GAP_M) * 0.5
	ax = ax.normalized() if ax.length() > 0.05 else Vector3.RIGHT
	var pts: Array = []
	for p in [mid - ax * half, mid + ax * half]:
		pts.append(p + Vector3.UP * FOOT_M)
		pts.append(p + Vector3.UP * HEAD_M)
	return pts


## The lens for a new shot: side-on to the pair on the `prefer` side (flat direction from the pair; ZERO = either), turned
## `yaw` (deg) off side-on, `dist` metres out (closer where the ropes stop it), `h` high, looking at the pair's middle at
## `look_h` (< 0: the height that centres both of them head to feet in the frame). This side first; only when it has no room
## the other side (TV's opposite camera); then wider and closer; then the high lens. `clear_m` = room kept to either boxer
## (flat; a lens over their heads needs none). The spots are scored by distance less their turn off side-on (YAW_COST_DEG),
## so a requested `yaw` within reach of a smaller turn comes back near side-on; `keep_yaw` (the clinch shot) scores the turn
## off `yaw` instead (S379: the clinch's 28 deg turn came back at ~-2).
## Returns {lens, look, look_h, fov, off (flat, lens - the pair's middle), high}.
static func place(a: Vector3, b: Vector3, prefer: Vector3, dist: float, yaw: float, h: float, look_h: float,
		aspect: float, clear_m: float = PLACE_CLEAR_M, keep_yaw: bool = false) -> Dictionary:
	var mid := Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5)
	var perp := side_on(a, b, prefer)
	var spot := Vector3.INF
	var best := -INF
	for pass_i in 3:
		var sides: Array = [perp] if pass_i == 0 else ([-perp] if pass_i == 1 else [perp, -perp])
		var max_yaw := MAX_YAW if pass_i < 2 else MAX_YAW_WIDE
		var min_d := minf(dist, PLACE_MIN_M if pass_i < 2 else MIN_M)
		for s in sides:
			for dy in [0.0, 10.0, -10.0, 20.0, -20.0, 30.0, -30.0, 40.0, -40.0]:
				var y := yaw + float(dy)
				if absf(y) > max_yaw:
					continue
				var dir: Vector3 = Basis(Vector3.UP, deg_to_rad(y)) * (s as Vector3)
				var d := dist
				while d >= min_d and not inside(mid + dir * d):
					d -= 0.1
				if d < min_d:
					continue
				var lens := mid + dir * d
				if behind_deg(a, b, lens) < PLACE_BEHIND_DEG or minf(flat_gap(lens, a), flat_gap(lens, b)) < clear_m:
					continue
				var score := d - absf(y - (yaw if keep_yaw else 0.0)) / YAW_COST_DEG
				if score > best:
					best = score
					spot = lens
		if spot.is_finite():
			break
	var high := not spot.is_finite()
	if high:   # CAMLINE2: of the two side-on spots (clamped inside the ropes), the one least behind a boxer
		spot = clamp_in(mid + perp * dist)
		if behind_deg(a, b, clamp_in(mid - perp * dist)) > behind_deg(a, b, spot) + 10.0:
			spot = clamp_in(mid - perp * dist)
	var lens3 := spot + Vector3.UP * (HIGH_H if high else h)
	var pts := pair_points(a, b)
	if look_h < 0.0:
		look_h = centre_h(lens3, mid, pts)
	look_h -= BAR_DROP_M
	var look := mid + Vector3.UP * look_h
	var fov := clampf(frame_fov(lens3, look, pts, aspect, MARGIN_X) * FOV_PAD, FOV_MIN, FOV_MAX)
	return {"lens": lens3, "look": look, "look_h": look_h, "fov": fov, "off": spot - mid, "high": high}


## The height over `mid` to look at so the highest and the lowest of `pts` sit equally far from the frame's middle (an
## elevated lens otherwise wastes the top of the frame and needs a wider FOV).
static func centre_h(lens: Vector3, mid: Vector3, pts: Array) -> float:
	var hi := -90.0
	var lo := 90.0
	for p in pts:
		var q: Vector3 = p
		var e := rad_to_deg(atan2(q.y - lens.y, maxf(flat_gap(q, lens), 0.3)))
		hi = maxf(hi, e)
		lo = minf(lo, e)
	return lens.y + maxf(flat_gap(lens, mid), 0.3) * tan(deg_to_rad((hi + lo) * 0.5))


## A critically damped spring: x moves toward `to` at rate `w` (1/s) with no overshoot and no jump in its speed.
## Returns [x, v].
static func spring(x: Vector3, v: Vector3, to: Vector3, w: float, dt: float) -> Array:
	var e := exp(-w * dt)
	var d := x - to
	var c := v + d * w
	return [to + (d + c * dt) * e, (v - c * (w * dt)) * e]


## The lens's turn: `ang` (yaw, pitch deg) toward `want` at most TURN_MAX_DEG_S, speeding up and slowing down at TURN_ACC
## (eased both ends, never past the aim). Returns [ang, vel].
static func turn(ang: Vector2, vel: Vector2, want: Vector2, dt: float) -> Array:
	var err := Vector2(wrapf(want.x - ang.x, -180.0, 180.0), want.y - ang.y)
	var goal := Vector2.ZERO
	if err.length() > DEAD_DEG:
		var speed := minf(minf(err.length() * TURN_GAIN, TURN_MAX_DEG_S), sqrt(2.0 * TURN_ACC * err.length()))
		goal = err.normalized() * speed
	var dv := goal - vel
	var step := TURN_ACC * dt
	if dv.length() > step:
		dv = dv.normalized() * step
	vel += dv
	if vel.length() > TURN_MAX_DEG_S:
		vel = vel.normalized() * TURN_MAX_DEG_S
	return [ang + vel * dt, vel]


## Yaw and pitch (deg) of a lens at `from` looking at `to` (Godot's camera looks down -Z).
static func aim(from: Vector3, to: Vector3) -> Vector2:
	var d := to - from
	return Vector2(rad_to_deg(atan2(-d.x, -d.z)), rad_to_deg(atan2(d.y, Vector2(d.x, d.z).length())))


static func basis_of(ang: Vector2) -> Basis:
	return Basis.from_euler(Vector3(deg_to_rad(ang.y), deg_to_rad(ang.x), 0.0))


## S393 C242 (operator: "stop moving the camera on every step a fighter does"): the point the lens follows rests until the pair's
## middle is more than DEAD_M from it, then is dragged along at that distance. A step or a lunge leaves the picture still;
## crossing the ring, the lens glides behind them. `-- nocalm` = the control arm.
const DEAD_M := 0.5
static var calm: bool = not OS.get_cmdline_user_args().has("nocalm")


static func anchored(anchor: Vector3, mid: Vector3) -> Vector3:
	var dead := DEAD_M if calm else 0.0
	var away := mid - anchor
	return anchor if away.length() <= dead else mid - away.normalized() * dead


## ---- CAMLINE2: what the lens can see of the two bodies (RingCamera reads FightStage.boxers through these) ----
## The camera rules judged the pair by two points on the canvas. Two things need a body: where a boxer's hips really
## are while a captured clip plays pure (hips_of), and whether one body covers the other from a lens (cover).
const BODY_BONES := {"head": "Head", "sh_l": "LeftUpperArm", "sh_r": "RightUpperArm", "el_l": "LeftLowerArm",
	"el_r": "RightLowerArm", "hand_l": "LeftHand", "hand_r": "RightHand", "hips": "Hips"}
const HEAD_MID_M := 0.1        # the skull's base (the Head bone) to the head's middle
const HEAD_R_M := 0.1
const ARM_R_M := 0.05
const SHOULDER_PAD_M := 0.05   # the deltoid outside the shoulder joint
const COVER_GAP_M := 0.05      # a part covers only what is at least this much farther from the lens
const COVER_ROWS := [0.1, 0.37, 0.63, 0.9]   # down the trunk, shoulders to hips
const COVER_COLS := [-0.65, 0.0, 0.65]       # across it, in half shoulder widths


## Boxer `bx` (a row of FightStage.boxers: skel, gclear) as world points {head (its middle), sh_l, sh_r, el_l, el_r,
## hand_l, hand_r, hips}: the animation's pose - and while the synthetic layers run (GloveClear active), moved to where
## that layer showed the hips, with the head it showed. {} without a skeleton or a bone.
static func body_of(bx: Dictionary) -> Dictionary:
	var skel: Skeleton3D = bx.get("skel")
	if skel == null:
		return {}
	var xf := skel.global_transform
	var out := {}
	for key in BODY_BONES:
		var id := skel.find_bone(BODY_BONES[key])
		if id < 0:
			return {}
		out[key] = xf * skel.get_bone_global_pose(id).origin
	out["head"] = (out["head"] as Vector3) + Vector3.UP * HEAD_MID_M * xf.basis.get_scale().y
	var gc: Variant = bx.get("gclear")
	if gc != null and (gc as SkeletonModifier3D).active and (gc.shown_hips as Vector3).is_finite():
		var shift: Vector3 = (gc.shown_hips as Vector3) - (out["hips"] as Vector3)
		for part in out:
			out[part] = (out[part] as Vector3) + shift
		if (gc.shown_head as Vector3).is_finite():
			out["head"] = gc.shown_head
	return out


## Where boxer `bx` stands for the lens (the hips, on the canvas), given the point FightStage hands in (`given`: the hips
## as GloveClear last showed them). While a captured clip plays pure, RkPure switches that layer off and its read stands
## still - the lens was blind to a pair turning through a captured step (CAMLINE2: up to 0.8 s straight behind a boxer).
## Then no layer acts and the animation's own hips are the hips shown.
static func hips_of(bx: Dictionary, given: Vector3) -> Vector3:
	var gc: Variant = bx.get("gclear")
	var skel: Skeleton3D = bx.get("skel")
	if gc == null or skel == null or (gc as SkeletonModifier3D).active or flat_gap(given, gc.shown_hips) > 0.001:
		return given
	var id := skel.find_bone("Hips")
	if id < 0:
		return given
	var h := skel.global_transform * skel.get_bone_global_pose(id).origin
	return Vector3(h.x, given.y, h.z)


## How much (0..1) of `me`'s head and trunk the body of `other` covers, seen from `lens`: two points on the head and
## COVER_ROWS x COVER_COLS over the trunk, each covered when the line from the lens to it passes through a part of the
## other body (trunk, legs, head, arms: capsules) that is nearer the lens. Both bodies as body_of gives them.
static func cover(lens: Vector3, me: Dictionary, other: Dictionary) -> float:
	if me.is_empty() or other.is_empty():
		return 0.0
	var mine: Vector3 = me["hips"]
	var theirs: Vector3 = other["hips"]
	if flat_gap(lens, theirs) > flat_gap(lens, mine) + 0.4:
		return 0.0   # the other body stands behind this one
	var w := 0.5 * (other["sh_l"] as Vector3).distance_to(other["sh_r"]) + SHOULDER_PAD_M
	var chest: Vector3 = ((other["sh_l"] as Vector3) + (other["sh_r"] as Vector3)) * 0.5
	var head: Vector3 = other["head"]
	var caps: Array = [[chest, theirs, w], [theirs, Vector3(theirs.x, 0.0, theirs.z), w * 0.8],
		[head - Vector3.UP * 0.02, head + Vector3.UP * 0.02, HEAD_R_M]]
	for s in ["l", "r"]:
		caps.append([other["sh_" + s], other["el_" + s], ARM_R_M])
		caps.append([other["el_" + s], other["hand_" + s], ARM_R_M * 1.5])
	var my_w := 0.5 * (me["sh_l"] as Vector3).distance_to(me["sh_r"]) + SHOULDER_PAD_M
	var top: Vector3 = ((me["sh_l"] as Vector3) + (me["sh_r"] as Vector3)) * 0.5
	var across := (top - lens).cross(Vector3.UP).normalized()
	var pts: Array = [(me["head"] as Vector3) + Vector3.UP * 0.04, (me["head"] as Vector3) - Vector3.UP * 0.04]
	for r in COVER_ROWS:
		for c in COVER_COLS:
			pts.append(top.lerp(mine, float(r)) + across * float(c) * my_w)
	var covered := 0
	for p in pts:
		var far := lens.distance_to(p) - COVER_GAP_M
		for cap in caps:
			var q := Geometry3D.get_closest_points_between_segments(lens, p, cap[0], cap[1])
			if q[0].distance_to(q[1]) < float(cap[2]) and lens.distance_to(q[1]) < far:
				covered += 1
				break
	return float(covered) / pts.size()


## The lens's sight line from `xf` to where it leaves the ring on the canvas: metres (the far rope behind the pair).
## -1 when the lens does not look across the ring (straight down, or a film shot looking away from it).
static func far_rope_m(xf: Transform3D) -> float:
	var fwd := -xf.basis.z
	var flat := Vector2(fwd.x, fwd.z)
	if flat.length() < 0.05:
		return -1.0
	var dir := flat.normalized()
	var t := INF
	for ax in 2:
		if absf(dir[ax]) > 0.001:
			var start := xf.origin.x if ax == 0 else xf.origin.z
			t = minf(t, (RING_HALF_M * signf(dir[ax]) - start) / dir[ax])
	return minf(t, RING_HALF_M * 4.0) / maxf(0.5, flat.length()) if t > 0.5 else -1.0


## CAMLINE2 the broadcast lens's far blur, set in ONE place (it was set in RingCamera._init, at every cut, on every
## ride frame and in the close-up, with three different starts): it starts FAR_PAST_M beyond the rope behind the pair
## (far_rope_m) and is full FAR_RAMP_M further - before the crowd's first row, 2.85 m beyond the ropes (RingSet). Was:
## from 1.6 m beyond the pair, so the far ropes sat at 0.15 of the 0.22 on average (the probe's read on main).
const FAR_PAST_M := 0.4
const FAR_RAMP_M := 1.6
const FAR_BLUR := 0.22   # S317: the hall behind the ring properly soft (0.14 read sharp and cheap)
static func far_blur(attributes: CameraAttributes, xf: Transform3D, subject_m: float) -> void:
	var lens := attributes as CameraAttributesPractical
	var rope := far_rope_m(xf)
	# A lens that does not look across the ring (a walk-in shot): from FAR_RAMP_M beyond what it looks at, as before.
	lens.dof_blur_far_distance = rope + FAR_PAST_M if rope > 0.0 else subject_m + FAR_RAMP_M
	lens.dof_blur_far_transition = FAR_RAMP_M
	lens.dof_blur_amount = FAR_BLUR


## How much of either body of `bodies` ([body_of, body_of]) the other covers from a lens at `lens`.
static func cover_pair(lens: Vector3, bodies: Array) -> float:
	return maxf(cover(lens, bodies[0], bodies[1]), cover(lens, bodies[1], bodies[0]))


## The side-on side of the pair a, b (flat) from which the bodies cover each other least, for a lens `dist` out and `h`
## high: the `here` side (where the lens stands: the 180-degree line), unless the other covers SIDE_GAIN less. ZERO
## when no side covers less than `need`.
const SIDE_GAIN := 0.1
static func open_side(a: Vector3, b: Vector3, here: Vector3, bodies: Array, dist: float, h: float, need: float = 9.0) -> Vector3:
	var mid := Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5)
	var side := side_on(a, b, here)
	var c0 := cover_pair(clamp_in(mid + side * dist) + Vector3.UP * h, bodies)
	var c1 := cover_pair(clamp_in(mid - side * dist) + Vector3.UP * h, bodies)
	if minf(c0, c1) >= need:
		return Vector3.ZERO
	return -side if c1 + SIDE_GAIN < c0 else side
