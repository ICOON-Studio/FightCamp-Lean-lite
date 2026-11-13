extends RefCounted
## POWER1 step 3, review round 2 (blind review of beeea8f2: a 1.5x drive of the WHOLE body left the jabs at 2.4-5.9 m/s and
## the crosses at 3.5-5.3 against bands of 6-8 and 7-9, the legs and hips already stepping 1.5x their old worst; owner S439:
## "the punches do not feellike the y have power"). The drive is the punching ARM's alone, put on by the landing reach
## (PunchReach); the body plays the clip at its pace and the contact stays the clip's (no timer moves).
## What it is up against: at the fight's spacing (pelvis to pelvis 0.93-0.99 m; REFERENCE_DISTANCES_S439.md: a shipped
## game fights at 1.05-1.35 m) the guard's glove starts only 0.08-0.25 m off her face. A glove read at 7-9 m/s over two
## frames covers 0.23-0.30 m in them: nearly all of that. Tried and measured first (tools/punch_pace.gd `scan`), all short:
## the arm's own keys on a clock that waits and catches up (cross b 4.2 -> 3.6-5.1 m/s, and the hand started 0.3-0.4 s
## late); a path started once an even push fits what is left, with the glove following the clip (it never fit in time:
## the follow uses the distance up). So, on a driven punch (PunchPace.arm hands the reach `drive_v`, its end speed, and
## `drive_t`, its time):
##   1. Until the drive the glove is the clip's own (S445: the old HOLD pinned it and the drive teleported it).
##   2. DRIVE: the last `drive_t` before the contact, a cubic path from the glove as shown (where, and how fast) onto the
##      target, arriving AT the contact at `drive_v`, still speeding up (CROSS_POWER_S439.md fix 1: "arrive moving").
##      Known: in the played fight the hit's timer fires one to two frames early and the hit puts the clip on its contact,
##      so the drive's last two frames can draw as one (film, seed 4242: cross b 0.27 m in one frame). Ending the path a
##      frame early was measured worse (the glove then often sat on her face a frame before the hit: hit_carry_test read
##      5 jabs and crosses arriving at 7-34 % of their top speed).
## Clip time and metres throughout.
##   aim(reach, glove, t, target) -> the point to aim at, or Vector3.INF (not a driven punch)
##   start(p0, v0, t0, c, face, v_end) -> the path    at(path, t, face) -> its point at clip time t

const PEAK_DT_MAX := 0.04


static func aim(pr: Node, g: Vector3, t: float, face: Vector3) -> Vector3:
	var v_end := float(pr.get("drive_v"))
	var td := float(pr.get("drive_t"))
	if v_end <= 0.0 or td <= 0.0:
		return Vector3.INF
	var c := float(pr.get("_contact"))
	var to := face - g
	var d := to.length()
	if d < 1e-4:
		return face
	var path: Dictionary = pr.get("_path")
	# S445 fix (blind read: the HOLD pinned the glove ~0.5 m out, then the drive covered it all in 0.08 s - cross 15.2 m/s in
	# one frame after 13 frames still, bone pops 2 -> 13, punch_speed 47 with the drive against 41 without). No hold: until
	# the drive the glove is the clip's own; the drive starts from it as shown, where it is and how fast it moves.
	# ... and it starts early enough to get there on an even push (2 d / v), not in a fixed drive_t: a far glove popped.
	if not path.has("dir") and t >= c - maxf(td, 2.0 * d / v_end):
		var sp: Vector3 = pr.get("_shown_prev")
		var sc: Vector3 = pr.get("_shown_cur")
		var ts: Vector2 = pr.get("_shown_t")
		if sc.is_finite() and sp.is_finite() and ts.y > ts.x + 1e-4 and ts.y - ts.x <= PEAK_DT_MAX and ts.y < c:
			path = start(sc, (sc - sp) / (ts.y - ts.x), ts.y, c, face, v_end)
		else:
			path = start(g, Vector3.ZERO, t, c, face, v_end)
		pr.set("_path", path)
	if path.has("dir"):
		pr.set("_dir_w", path["dir"])
		return at(path, t, face)
	return g


## The path from the glove shown at p0 (clip time t0, moving at v0 a clip second) onto `face` at the contact c, arriving at
## v_end along the line it starts on; {} when there is no time or distance left.
static func start(p0: Vector3, v0: Vector3, t0: float, c: float, face: Vector3, v_end: float) -> Dictionary:
	var to := face - p0
	if c - t0 < 1e-3 or to.length() < 1e-3:
		return {"floor": 0.0}
	return {"p0": p0, "v0": v0, "t0": t0, "c": c, "dir": to.normalized(), "v_end": v_end}


## Cubic Hermite from (p0, v0) at t0 to (face, v_end along dir) at c.
static func at(path: Dictionary, t: float, face: Vector3) -> Vector3:
	var span := float(path["c"]) - float(path["t0"])
	var u := clampf((t - float(path["t0"])) / span, 0.0, 1.0)
	var u2 := u * u
	var u3 := u2 * u
	var p0: Vector3 = path["p0"]
	var m0: Vector3 = (path["v0"] as Vector3) * span
	var m1: Vector3 = (path["dir"] as Vector3) * float(path["v_end"]) * span
	return p0 * (2.0 * u3 - 3.0 * u2 + 1.0) + m0 * (u3 - 2.0 * u2 + u) + face * (-2.0 * u3 + 3.0 * u2) + m1 * (u3 - u2)
