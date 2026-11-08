extends RefCounted
## S391 the two women touch. Every judged film's top complaint was limbs through bodies, and the S336 push-out could not answer it:
## bjj_tremble_probe with `withsep withcarry` reads the JOINTS clear (peak 0.214 -> 0.054 m) and the DRAWN bodies unchanged (ANY part
## p95 0.176 -> 0.196 m), at twice the jerk. It solves the data's thin figure, and our bones sit 9-28 cm off those joints (our lengths,
## GrappleDrawn.track's shift). So this works on the bones as drawn and touches only the ends of the chain: the hips, trunk and head stay
## on the recording, and each arm and leg swings about its own shoulder or hip, its shape kept, until it clears the other's trunk, pelvis and head.
##   Nothing is solved from scratch: a limb starts from where it was drawn last frame and relaxes toward the recording, so it presses and
##   slides along a body instead of landing on a fresh compromise each frame (S379's trembling). The correction reaches the drawn pose
##   through GrapplePose.limb_fix, eased (critically damped, speed capped), so it never pops.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const GD := preload("res://scripts/grapple/GrappleDrawn.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")

## [key, root bone, middle bone, end bone, upper radius, lower radius]
const LIMBS := [["LeftArm", "LeftUpperArm", "LeftLowerArm", "LeftHand", 0.06, 0.045],
	["RightArm", "RightUpperArm", "RightLowerArm", "RightHand", 0.06, 0.045],
	["LeftLeg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 0.10, 0.065, "LeftToes"],
	["RightLeg", "RightUpperLeg", "RightLowerLeg", "RightFoot", 0.10, 0.065, "RightToes"]]
const FOOT_R := 0.068
const SOLID := ["pelvis", "trunk", "head", "neck", "shoulders", "face"]
## S399 GRAPPLEFIX1 "bodies merging" (every blind critic): tools/grapple_mesh_probe.gd on the skinned meshes found the merging is
## limb in LIMB (a foot or forearm 4-7 cm into the other's thigh, 886 blue's feet in red's thighs 0.33-1.67 s), and limbs only
## cleared the other's trunk, pelvis and head. The other's thighs and upper arms are solid too, met at their capsule's skin (not
## SKIN_M early: wrapped legs are always that close) less LIMB_PRESS_M - the capsules sit 1-2 cm outside the mesh, so a touch still
## touches. Only the big parts: the ends (shins, feet, forearms) yield to them but not to each other - all ten limb parts solid
## cleared no more and shook more (12 moves, mesh park median 4.4 -> 3.4 cm big / 4.1 all, frames past 3 cm 66 -> 42% / 46%,
## jerk p95 median 179 -> 209 / 246). `-- limbsolid=0` turns it off, `-- limbset=all` tries all ten.
const LIMB_SOLID := ["thighL", "thighR", "upperarmL", "upperarmR"]
const LIMB_SOLID_ALL := ["thighL", "thighR", "shinL", "shinR", "upperarmL", "upperarmR", "forearmL", "forearmR", "footL", "footR"]
const LIMB_PRESS_M := 0.0
const PASSES := 3
const GAIN := 0.8        # of a contact's depth closed a pass
const SKIN_M := -0.035   # a limb is pushed before it touches: the ease lags, so it has this much to lag into (S399: 2 -> 3.5 cm, the ease is longer)
const LEVER_MIN := 0.3   # a contact nearer the root than this share of the bone pushes as if it were here
const LEVER_MIN_M := 0.12
const STEP_MAX := 0.16   # the most one pass moves a joint
const RELAX_S := 0.7     # a free limb's way back to the recording
const EASE_S := 0.1     # the drawn correction's lag
const SPEED_MAX := 2.5   # metres a second
const OFF_MAX := 0.25    # how far a held hand moves on top of the swing (bjj_drawn_bars HUMAN)
const OFF_LEG_MAX := 0.1
const MAT_NEAR_M := 0.09   # a hand this low in the data is on the mat, past FAR not at all
const MAT_FAR_M := 0.16
const SWING_MAX := 0.7  # radians a limb may leave the recording
const HEAD_TURN_MAX := 0.7
## What can be held: [data joint a, data joint b, the data figure's radius, drawn bone a, drawn bone b, our skin's radius].
## The data radii are GrappleGrip.BODY's; ours GrappleContact's measured table.
const HOLDS := [["Core", "Neck", 0.13, "Spine", "Neck", 0.14], ["LeftHip", "RightHip", 0.11, "LeftUpperLeg", "RightUpperLeg", 0.118],
	["Neck", "Head", 0.07, "Neck", "Head", 0.07], ["Head", "Head", 0.10, "Head", "Head", 0.12],
	["LeftHip", "LeftKnee", 0.075, "LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightHip", "RightKnee", 0.075, "RightUpperLeg", "RightLowerLeg", 0.10],
	["LeftKnee", "LeftAnkle", 0.05, "LeftLowerLeg", "LeftFoot", 0.065], ["RightKnee", "RightAnkle", 0.05, "RightLowerLeg", "RightFoot", 0.065],
	["LeftShoulder", "LeftElbow", 0.05, "LeftUpperArm", "LeftLowerArm", 0.06], ["RightShoulder", "RightElbow", 0.05, "RightUpperArm", "RightLowerArm", 0.06],
	["LeftElbow", "LeftWrist", 0.04, "LeftLowerArm", "LeftHand", 0.045], ["RightElbow", "RightWrist", 0.04, "RightLowerArm", "RightHand", 0.045]]
const HOLD_NEAR_M := 0.05       # a hand this close to the data's skin holds fully, past FAR not at all
const HOLD_FAR_M := 0.14
const HOLD_FOOT_NEAR_M := 0.03  # a foot only where the data really hooks
const HOLD_FOOT_FAR_M := 0.09
const HOLD_STAY_M := 0.02       # a hold keeps its segment until another is this much nearer
const HOLD_EASE_S := 0.12
const HOLD_LET_GO_S := 0.04
const HOLD_SKIN_M := 0.012
const HOLD_FIRM := 0.9
const HOLD_GLIDE_S := 0.16
const HOLD_TOUCH_S := 0.06
const TOUCH_PRESS_M := 0.01     # a held forearm lies this far into the skin
## Control arms beside GrapplePlayer's `nolimbs`.
static var _args := OS.get_cmdline_user_args()
## S399 GRAPPLEFIX1: the shown limb's ease (two stages of half each); `-- limbease=0.2` tries another.
## S399 measured on 23 slow moves (tools/grapple_orbit.gd game arm): 0.1 s -> jerk p95 up to 138, 0.2 s -> limbs lag into bodies,
## 0.15 s with SKIN_M 3.5 cm -> 10 of 23 inside every bar (8 before).
const LIMB_EASE_S := 0.15
## S399 GRAPPLEFIX1: the most a middle joint may swing ROUND its root-to-end line, radians a second. Every way of fading a
## corrected plane into the recording's axis has a frame where the two cancel (S1 blue's elbow 24 cm; with the swung axis
## 860/1198/1629 at 32-52 cm), and an axis near that line leaves the side undefined (860 folded: 40 cm). The elbow's way out
## from the line is turned toward its target at this rate, so a side change is a swing, never a jump.
const AXIS_RATE := 6.0
static var axis_rate := _arg_f("axisrate=", AXIS_RATE)
static var end_out := not _args.has("endout=0")
static var limb_ease_s := _arg_f("limbease=", LIMB_EASE_S)
static var skin_m := _arg_f("skin=", SKIN_M)
static var swing_max := _arg_f("swing=", SWING_MAX)
static var limb_press_m := _arg_f("limbpress=", LIMB_PRESS_M)
static var limb_solid := not _args.has("limbsolid=0")
static var limb_set: Array = LIMB_SOLID_ALL if _args.has("limbset=all") else LIMB_SOLID


static func _arg_f(prefix: String, fallback: float) -> float:
	for a in _args:
		if str(a).begins_with(prefix):
			return float(str(a).substr(prefix.length()))
	return fallback


static func fresh() -> Dictionary:
	return {}


## `d`: both women's bones as drawn this frame (limb_fix included); `rec`: each woman's limbs as the recording would draw them,
## GrappleDrawn.recorded; `j`: the joints the poses were handed. Writes each pose's limb_fix for the next solve.
static func solve(men: Array, d: Array, rec: Array, j: Array, st: Dictionary, dt: float) -> void:
	var parts := [GD.parts(d[0]), GD.parts(d[1])]
	for w in 2:
		var solids := _solids(parts[1 - w])
		var fix := {}
		for l in LIMBS:
			var r: Array = (rec[w] as Dictionary).get(l[0], [])
			if r.is_empty():
				continue
			var key := "%d%s" % [w, l[0]]
			var hold := _hold(str(l[0]), j[w], j[1 - w], d[1 - w], st, key, dt)
			hold.append(_on_mat(str(l[0]), j[w]))
			fix[l[0]] = _limb(l, d[w], r, solids, hold, st, key, dt)
		(men[w] as Node).set("limb_fix", fix)
		(men[w] as Node).set("head_fix", _head(d[w], solids, st, "%dHead" % w, dt))


static func _solids(p: Dictionary) -> Array:
	var out: Array = []
	for c in p["all"]:
		if str(c[0]) in SOLID:
			out.append(c)
		elif limb_solid and str(c[0]) in limb_set:
			# _deepest adds -skin_m to every solid: taken back here, so a limb meets a limb at the skin.
			out.append([c[0], c[1], c[2], float(c[3]) + skin_m - limb_press_m])
	return out


## One limb. It swings as one rigid piece about its shoulder or hip, the shape the recording gave it kept, by a capped angle: a kneel stays a
## kneel. (S391's first cut moved the end and re-solved the bend; the bars went green while 25-77% of frames had a limb over 35 cm off the
## recording, knees behind hips: operator, "blue doesn t even look like a human".) On top of the swing only a held or planted end moves a
## little further. Returns [the way the middle sticks out, end offset from the recording]. The solve runs on its own last answer, never on
## the eased drawn limb: the ease inside the loop made it ring.
static func _limb(l: Array, d: Dictionary, r: Array, solids: Array, hold: Array, st: Dictionary, key: String, dt: float) -> Array:
	var root: Vector3 = d[l[1]]
	var ra := float(l[4])
	var rb := float(l[5])
	var arm := l.size() <= 6
	var rec_m: Vector3 = r[0]
	var rec_e: Vector3 = r[1]
	var normal: Vector3 = r[2]
	var a := root.distance_to(d[l[2]])
	var b := (d[l[2]] as Vector3).distance_to(d[l[3]])
	var s: Dictionary = st.get(key, {"sw": Vector3.ZERO, "o": Vector3.ZERO, "ease_w": Vector3.ZERO, "vw": Vector3.ZERO, "ease_o": Vector3.ZERO, "vo": Vector3.ZERO})
	st[key] = s
	# A foot rides its ankle: the bones as drawn give its length and aim.
	var foot: Vector3 = Vector3.ZERO if arm else (d[l[6]] as Vector3) - (d[l[3]] as Vector3)
	var keep := exp(-dt / RELAX_S) if dt > 0.0 else 1.0
	var w: Vector3 = (s["sw"] as Vector3) * keep
	var o: Vector3 = (s["o"] as Vector3) * keep
	var o_max := OFF_MAX if arm else OFF_LEG_MAX
	var pin := float(hold[1])
	var mat := float(hold[2]) * (1.0 - pin)   # a hand on her outranks a hand near the mat
	if pin > 0.0:
		var m0 := root + _swing(w, rec_m - root)
		var e0 := root + _swing(w, rec_e - root) + o
		# A hold on the far side of a thick body would pull the forearm through it: the hand stops where the line first meets her.
		# Not from inside her: from a buried elbow the first touch is the elbow itself, and the hand would fold onto it.
		if float(_deepest(m0, m0, rb, solids)[0]) <= 0.0:
			var touch := _first_touch(m0, hold[0], rb, solids)
			# The search lands in steps of a few millimetres; held still, those steps were the hands' tremble.
			# S399 GRAPPLEFIX1: second order (a first-order lag starts at full speed: a corner in the hand's path every new touch).
			if _args.has("touch1"):
				s["touch"] = (s.get("touch", touch) as Vector3).lerp(touch, 1.0 - exp(-dt / HOLD_TOUCH_S)) if dt > 0.0 else touch
			else:
				if not s.has("touch"):
					s["touch"] = touch
					s["vtouch"] = Vector3.ZERO
				ease_to2(s, "touch", "vtouch", touch, dt, HOLD_TOUCH_S * 2.0)
			var firm := pin
			if not arm:
				# A foot hooks with its heel: toes that would go in give the hold up, they cannot swing out of the way.
				firm *= 1.0 - smoothstep(0.0, 0.05, float(_deepest(s["touch"], (s["touch"] as Vector3) + foot, FOOT_R, solids)[0]))
			o += ((s["touch"] as Vector3) - e0) * firm
	for _p in PASSES:
		var e := root + _swing(w, rec_e - root) + o
		var m := _real_middle(root, root + _swing(w, rec_m - root), e, a, b, _swing(w, normal), not arm)
		var c := _deepest(root, m, ra, solids)
		if float(c[0]) > 0.0:
			w += _torque(root, root.lerp(m, maxf(float(c[2]), LEVER_MIN)), (c[1] as Vector3) * float(c[0]) * GAIN)
		c = _deepest(m, e, rb, solids)
		if float(c[0]) > 0.0:
			w += _torque(root, m.lerp(e, float(c[2])), (c[1] as Vector3) * float(c[0]) * GAIN)
		if not arm:
			c = _deepest(e, e + foot, FOOT_R, solids)
			if float(c[0]) > 0.0:
				w += _torque(root, e, (c[1] as Vector3) * float(c[0]) * GAIN)
		if m.y < ra:
			w += _torque(root, m, Vector3.UP * (ra - m.y))
		var low := maxf(rb - e.y, (FOOT_R - e.y - foot.y) if not arm else 0.0)
		if low > 0.0:
			w += _torque(root, e, Vector3.UP * low)
		w = w.limit_length(swing_max)
		if mat > 0.0:
			# Not over a low elbow: a hand pressed down onto the mat drives the joint behind it under.
			o.y += (rb - e.y) * mat * smoothstep(ra, ra + 0.08, m.y)
		o = o.limit_length(o_max)
	# S399 GRAPPLEFIX1 (operator: "Yes, try re-bend"; S1 7.5 s, blue's hand 7 cm in red's pelvis, the forearm 15 cm through her
	# in a full grip): the swing turns the arm about the shoulder, and a hand the recording grips INSIDE our thicker woman stays
	# in her whatever the arm does - letting the elbow go round its line instead cleared 1 cm at jerk 253 -> 311. The end itself
	# comes out to her skin along her normal (within o's own cap): S1 park 14.8 -> 8.9 cm. `-- endout=0` = off.
	if end_out:
		for _p in 2:
			var e := root + _swing(w, rec_e - root) + o
			var c := _deepest(e, e, rb, solids)
			var dep := float(c[0]) + skin_m
			if dep > 0.0:
				o += (c[1] as Vector3) * dep
		o = o.limit_length(o_max)
	# The mat has the last word: it is the one surface the eye never forgives.
	for _p in 2:
		var e := root + _swing(w, rec_e - root) + o
		var m := _real_middle(root, root + _swing(w, rec_m - root), e, a, b, _swing(w, normal), not arm)
		if m.y < ra:
			w += _torque(root, m, Vector3.UP * (ra - m.y))
			o.y += (ra - m.y) * 0.5
		var low := maxf(rb - e.y, (FOOT_R - e.y - foot.y) if not arm else 0.0)
		if low > 0.0:
			w += _torque(root, e, Vector3.UP * low)
	# S399 GRAPPLEFIX1: a held or planted end never comes in closer than the limb can fold (Pose.min_reach): there the bend's
	# direction is a guess and the middle joint spun (860: a 46 cm one-frame pop).
	var e_end := root + _swing(w, rec_e - root) + o
	var reach := e_end - root
	var near := Pose.min_reach(a, b, not arm) + Pose.SOFT_IK_M
	if reach.length() < near:
		var out_dir := reach.normalized() if reach.length() > 0.02 else (rec_e - root).normalized()
		o += out_dir * near - reach
	s["sw"] = w.limit_length(swing_max + 0.1)
	s["o"] = o
	# S399 GRAPPLEFIX1: two stages (ease_to2), so the shown limb's acceleration never jumps when the solve turns a corner.
	ease_to2(s, "ease_w", "vw", w, dt, limb_ease_s)
	ease_to2(s, "ease_o", "vo", o, dt, limb_ease_s)
	var shown_w: Vector3 = s["ease_w"]
	var shown_e := root + _swing(shown_w, rec_e - root) + (s["ease_o"] as Vector3)
	var shown_m := _real_middle(root, root + _swing(shown_w, rec_m - root), shown_e, a, b, _swing(shown_w, normal), not arm)
	if shown_m.y < ra:
		# The ease lags and the mat does not wait for it: a joint it would sink swings up now. S399: on the shown limb only, never
		# written back into the ease (that was a jump in its state with no speed to match: 620's red leg rang 0.37-0.68 rad).
		shown_w += _torque(root, shown_m, Vector3.UP * (ra - shown_m.y))
		shown_e = root + _swing(shown_w, rec_e - root) + (s["ease_o"] as Vector3)
		# S399: the same middle as above (it was the plain swing here, so the bend plane jumped each time the joint met the mat).
		shown_m = _real_middle(root, root + _swing(shown_w, rec_m - root), shown_e, a, b, _swing(shown_w, normal), not arm)
	var under := rb - shown_e.y
	if not arm:
		under = maxf(under, FOOT_R - shown_e.y - foot.y)
	if under > 0.0:
		shown_e.y += under
	# S399 GRAPPLEFIX1: the axis, rate-limited, and the middle bent about it; GrapplePose bends exactly so (index 2).
	var want_axis := _bend_axis(root, root + _swing(shown_w, rec_m - root), shown_e, _swing(shown_w, normal))
	var axis: Vector3 = want_axis.normalized()
	var line := shown_e - root
	var want := Pose._reach(root, shown_e, a, b, want_axis, not arm)
	if line.length() > 1e-3 and not want.is_empty():
		var dir := line.normalized()
		var pole_want: Vector3 = (want[0] as Vector3) - dir * (want[0] as Vector3).dot(dir)
		if pole_want.length() > 1e-4:
			pole_want = pole_want.normalized()
			var pole := pole_want
			if s.has("pole") and dt > 0.0 and axis_rate > 0.0:
				var last: Vector3 = s["pole"]
				last -= dir * last.dot(dir)
				if last.length() > 0.2:
					pole = turn_toward(last, pole_want, axis_rate * dt)
					pole = (pole - dir * pole.dot(dir)).normalized()
			s["pole"] = pole
			axis = pole.cross(dir)   # Pose._reach puts the middle along dir x axis = pole
	var bent := Pose._reach(root, shown_e, a, b, axis, not arm)
	if not bent.is_empty():
		shown_m = root + (bent[0] as Vector3)
	return [shown_m - root, shown_e - rec_e, axis]


## `from` turned toward `to` by at most `max_ang` radians (unit result). A `to` too short to have a direction keeps `from`.
static func turn_toward(from: Vector3, to: Vector3, max_ang: float) -> Vector3:
	var f := from.normalized()
	if to.length() < 1e-4:
		return f
	var t := to.normalized()
	var ang := f.angle_to(t)
	if ang <= max_ang:
		return t
	var ax := f.cross(t)
	if ax.length() < 1e-5:
		ax = f.cross(Vector3.UP if absf(f.y) < 0.9 else Vector3.RIGHT)
	return f.rotated(ax.normalized(), max_ang)


## Where the middle joint really lands once the end has moved off the swing (what GrapplePose will draw).
static func _real_middle(root: Vector3, m: Vector3, e: Vector3, a: float, b: float, normal: Vector3, leg: bool = false) -> Vector3:
	var bend := Pose._reach(root, e, a, b, _bend_axis(root, m, e, normal), leg)
	return root + (bend[0] as Vector3) if not bend.is_empty() else m


## The axis the middle bends about: the swung recording's middle and the end's plane, faded near the line (Pose.held_plane) into
## `normal` - the recording's axis SWUNG with the limb. S399 GRAPPLEFIX1 (S1 sequence, blue's elbow 24 cm in one frame at 11.37 s,
## a held hand pushed off red's thigh): faded into the UNSWUNG axis, a limb turned 0.5 rad summed to almost nothing and the bend
## side flipped in a frame.
static func _bend_axis(root: Vector3, m: Vector3, e: Vector3, normal: Vector3) -> Vector3:
	return Pose.held_plane((m - root).cross(e - root), normal)


## `v` under the small rotation `w` (axis times angle).
static func _swing(w: Vector3, v: Vector3) -> Vector3:
	var ang := w.length()
	return v if ang < 1e-5 else v.rotated(w / ang, ang)


## The rotation that moves the point `at` by `push`, about `root`.
static func _torque(root: Vector3, at: Vector3, push: Vector3) -> Vector3:
	var arm := at - root
	return arm.cross(push.limit_length(STEP_MAX)) / maxf(arm.length_squared(), LEVER_MIN_M * LEVER_MIN_M)


## What the recording says this hand or foot is holding, carried across to the bodies as drawn. GrappleMap's contacts are real, but on a
## thin figure, and our women sit thicker and further apart: the hand the data lays on a shoulder hangs in the air here. So the spot is
## read off the data (which segment of the other woman, how far along, from which side) and found again on her drawn bones, at our skin.
## Returns [where the end should be, how firmly 0..1].
static func _hold(limb: String, mine: PackedVector3Array, other: PackedVector3Array, od: Dictionary, st: Dictionary, key: String, dt: float) -> Array:
	var arm := limb.ends_with("Arm")
	if _args.has("nohold") or (not arm and _args.has("nofoothold")):
		return [Vector3.ZERO, 0.0]
	var side := limb.trim_suffix("Arm").trim_suffix("Leg")
	var joint := DB.joint(side + ("Wrist" if arm else "Ankle"))
	var p: Vector3 = mine[joint]
	if arm:
		p = (mine[DB.joint(side + "Hand")] + mine[DB.joint(side + "Fingers")]) * 0.5
	var s: Dictionary = st.get(key + "Hold", {"seg": -1, "w": 0.0})
	st[key + "Hold"] = s
	var best := -1
	var best_gap := INF
	var best_u := 0.0
	var last := int(s["seg"])
	for i in HOLDS.size():
		var h: Array = HOLDS[i]
		var a: Vector3 = other[DB.joint(h[0])]
		var b: Vector3 = other[DB.joint(h[1])]
		var ab := b - a
		var u := 0.0 if ab.length_squared() < 1e-8 else clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
		var gap := p.distance_to(a + ab * u) - float(h[2]) - (HOLD_STAY_M if i == last else 0.0)
		if gap < best_gap:
			best_gap = gap
			best = i
			best_u = u
	var near := HOLD_NEAR_M if arm else HOLD_FOOT_NEAR_M
	var far := HOLD_FAR_M if arm else HOLD_FOOT_FAR_M
	var want := 1.0 - smoothstep(near, far, best_gap)
	s["seg"] = best if want > 0.0 else -1
	# Slow to take hold, quick to let go: a tap's hand must leave the leg it slaps.
	s["w"] = lerpf(float(s["w"]), want, 1.0 - exp(-dt / (HOLD_EASE_S if want > float(s["w"]) else HOLD_LET_GO_S))) if dt > 0.0 else want
	var w := float(s["w"])
	if w < 0.02 or best < 0:
		return [Vector3.ZERO, 0.0]
	var h: Array = HOLDS[best]
	var ja: Vector3 = other[DB.joint(h[0])]
	var jb: Vector3 = other[DB.joint(h[1])]
	var from := p - ja.lerp(jb, best_u)
	var a2: Vector3 = od[h[3]]
	var b2: Vector3 = od[h[4]]
	var on := a2.lerp(b2, best_u)
	var dir := from.normalized() if from.length() > 1e-4 else Vector3.UP
	var at := on + dir * (float(h[5]) + (HOLD_SKIN_M if arm else FOOT_R)) - (p - mine[joint])
	# The side a hold sits on is noise when the data's hand is on the bone, and a new segment is a jump: the spot glides, never hops.
	if not s.has("at") or float(s["w"]) < 0.05:
		s["at"] = at
		s["vat"] = Vector3.ZERO
	ease_to2(s, "at", "vat", at, dt, HOLD_GLIDE_S)
	return [s["at"], w * HOLD_FIRM]


## How flat on the mat the data puts this hand, 0..1. The pair is lifted as a whole to clear the mat, and with it every posted hand and tap:
## the data's touch on the floor is carried over like a hold. Hands only: pulling a foot down drove the knee behind it under the mat.
static func _on_mat(limb: String, mine: PackedVector3Array) -> float:
	if not limb.ends_with("Arm"):
		return 0.0
	return 1.0 - smoothstep(MAT_NEAR_M, MAT_FAR_M, mine[DB.joint(limb.trim_suffix("Arm") + "Wrist")].y)


## The head turns on the neck to clear a body (a whole-body shift for it ran `rel` to its cap and lifted the top woman half a metre).
## Returns [offset at the head's centre, the centre's distance from the neck].
static func _head(d: Dictionary, solids: Array, st: Dictionary, key: String, dt: float) -> Array:
	var neck: Vector3 = d["Neck"]
	var head: Vector3 = d["Head"]
	var c := head + (head - neck).normalized() * GD.HEAD_UP
	var rho := neck.distance_to(c)
	var s: Dictionary = st.get(key, {"w": Vector3.ZERO, "off": Vector3.ZERO, "v": Vector3.ZERO})
	st[key] = s
	var rec := neck + (c - (s["off"] as Vector3) - neck).normalized() * rho
	var keep := exp(-dt / RELAX_S) if dt > 0.0 else 1.0
	var p: Vector3 = rec + (s["w"] as Vector3) * keep
	for _p in PASSES:
		var hit := _deepest(p, p, GD.HEAD_R, solids)
		if float(hit[0]) > 0.0:
			p += ((hit[1] as Vector3) * float(hit[0]) * GAIN).limit_length(STEP_MAX)
		p = neck + (p - neck).normalized() * rho
	var from := (rec - neck).normalized()
	var to := (p - neck).normalized()
	var ang := from.angle_to(to)
	if ang > HEAD_TURN_MAX and from.cross(to).length() > 1e-5:
		p = neck + from.rotated(from.cross(to).normalized(), HEAD_TURN_MAX) * rho
	s["w"] = p - rec
	ease_to2(s, "off", "v", s["w"], dt)
	return [s["off"], rho]


## How far along from `m` to `to` a capsule of radius `r` gets before it would sink past the skin.
static func _first_touch(m: Vector3, to: Vector3, r: float, solids: Array) -> Vector3:
	if float(_deepest(m, to, r - TOUCH_PRESS_M, solids)[0]) <= 0.0:
		return to
	var lo := 0.0
	var hi := 1.0
	for _i in 6:
		var mid := (lo + hi) * 0.5
		if float(_deepest(m, m.lerp(to, mid), r - TOUCH_PRESS_M, solids)[0]) > 0.0:
			hi = mid
		else:
			lo = mid
	return m.lerp(to, lo)


## The deepest overlap of a capsule against `solids`: [depth past the skin, normal out of the solid, where along a..b].
static func _deepest(a: Vector3, b: Vector3, r: float, solids: Array) -> Array:
	var best := 0.0
	var n := Vector3.UP
	var at := 0.5
	var len2 := a.distance_squared_to(b)
	for c in solids:
		var pts := Geometry3D.get_closest_points_between_segments(a, b, c[1], c[2])
		var along: Vector3 = (pts[0] as Vector3) - (pts[1] as Vector3)
		var dist := along.length()
		var depth := r + float(c[3]) - skin_m - dist
		if depth > best:
			best = depth
			n = along / dist if dist > 1e-4 else Vector3.UP
			at = 0.5 if len2 < 1e-8 else clampf(((pts[0] as Vector3) - a).dot(b - a) / len2, 0.0, 1.0)
	return [best, n, at]


## S399 GRAPPLEFIX1: two ease_to stages in a row, each at half the lag. One stage's acceleration jumps whenever its target turns a
## corner (a jerk spike on every bone of the woman it moves); through a second it is continuous. `s` keeps key+"1" / vkey+"1".
static func ease_to2(s: Dictionary, key: String, vkey: String, want: Vector3, dt: float, lag_s: float = EASE_S) -> void:
	if dt <= 0.0:
		return
	if not s.has(key + "1"):
		s[key + "1"] = s[key]
		s[vkey + "1"] = Vector3.ZERO
	ease_to(s, key + "1", vkey + "1", want, dt, lag_s * 0.5)
	ease_to(s, key, vkey, s[key + "1"], dt, lag_s * 0.5)


## Critically damped toward `want`, speed capped: the correction has no corners, so it shows no jerk.
static func ease_to(s: Dictionary, key: String, vkey: String, want: Vector3, dt: float, lag_s: float = EASE_S) -> void:
	if dt <= 0.0:
		return
	var o := 2.0 / lag_s
	var x := o * dt
	var ex := 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
	var v: Vector3 = s[vkey]
	var pos: Vector3 = s[key]
	var ch := (pos - want).limit_length(SPEED_MAX * lag_s)
	var tmp := (v + ch * o) * dt
	s[vkey] = (v - tmp * o) * ex
	s[key] = (pos - ch) + (ch + tmp) * ex
