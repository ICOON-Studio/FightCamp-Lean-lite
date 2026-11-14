extends RefCounted
## POWER1 step 4 (c), the landing reach's limits (PunchReach calls these). UPPERCUT_RANGE_S439.md: at the fight's one spacing
## the reach straightened every uppercut to the solve's own limit (165-166 deg: fully locked out) and carried gloves from
## wherever the clip had them; a shipped game lets its arm correction add at most 0.30 m and leaves hooks and uppercuts to
## the clip (REFERENCE_DISTANCES_S439.md). So:
##   - the reach never puts the glove more than CORR_M from where the clip has it this frame (cap);
##   - an uppercut's elbow never opens past UPPER_ELBOW_DEG (reach); what is left, the chest lean covers, then it falls short;
##   - a landed punch whose glove is still more than GRAZE_M off its target on the hit frame is shown as a graze, never as a
##     clean hit (HitImpact): the result stands (it was settled before anyone watched), only how it looks changes.
## The chest lean moved here from PunchReach (its 500-line cap). `-- nopunchrange` = the control arm (no cap, uppercuts
## straighten to the solve's limit, every landed punch shown clean).
##   cap(clip_glove, at) -> Vector3   reach(clip, l1, l2) -> metres   solve_capped(...)   miss(reach) -> metres   lean(...)

const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")

const CORR_M := 0.30
const UPPER_ELBOW_DEG := 120.0
const GRAZE_M := 0.15
## S466 LANDREACH1 (bisected to d258cab0): the carry starts from the glove as drawn on the hit frame only when that is
## within SHOWN_M of the face point; review round 1 assumed it was "1-3 cm short", but the rear hand was 13-19 cm short there
## and the carry then started from the short point, so the landed cross never reached her face. Further off = the face point.
const SHOWN_M := 0.02


## Review round 1: the cap holds while the reach brings the glove TO her, through the hit frame; after it the carry goes on
## from the point it met (THROUGH_M) - capped to the clip's glove, which is still flying on past her or swinging home, the
## carried glove was dragged 0.2-0.5 m along with it (hit_frame_test THROUGH, the hooks).
## A blocked punch (no carry: FightStage.land_block) is not capped: its reach goes to her blocking glove, in front of her face
## and inside any landed punch's correction, and capping it left the glove 1-2 cm off the block (block_meet TOUCH).
static func capping(pr: Node) -> bool:
	return str(pr.get("_clip")) != "" and float(pr.get("_thru")) > 0.0 and (not (pr.get("_hit_w") as Vector3).is_finite() or int(pr.get("_hit_f")) == int(pr.get("_key")))


## The point the reach may put the glove on this frame: `at`, pulled to within CORR_M of the clip's own glove.
static func cap(clip_glove: Vector3, at: Vector3, shift := Vector3.ZERO) -> Vector3:
	if not RangeTable.on or not clip_glove.is_finite() or not at.is_finite():
		return at
	clip_glove = base(clip_glove, shift, at)
	return clip_glove + (at - clip_glove).limit_length(CORR_M)


## S470 LANDREACH4 (hit_gap_probe + layer_trace: lead hooks shown 0.14-0.34 m LOW inside): the footwork's torso layer
## (lean, hips) had moved the hook's hand 0.19 m down before the reach ran, so the reach spent most of its CORR_M putting
## the hand back where the clip had it. The cap now counts from the nearest point to `at` between the clip's glove as it
## stands and the same glove without that layer's move (`shift`, skeleton space): never tighter than before.
## `-- nobodycap` = the control arm.
static var BODY_CAP: bool = not OS.get_cmdline_user_args().has("nobodycap")
static func base(clip_glove: Vector3, shift: Vector3, at: Vector3) -> Vector3:
	if not BODY_CAP or shift.length_squared() < 1e-8:
		return clip_glove
	return clip_glove + shift * clampf((at - clip_glove).dot(shift) / shift.length_squared(), 0.0, 1.0)


## The torso layer's move of the armed hand this frame (skeleton space; ZERO without the footwork rig).
static func body_shift(skel: Skeleton3D, hand_bone: int) -> Vector3:
	var up := skel.get_node_or_null("BoxerFootworkUpper")
	return (up.get("hand_shift") as Dictionary).get(hand_bone, Vector3.ZERO) if up != null else Vector3.ZERO


## How far the wrist may go from the shoulder for `clip` (the solve's own limit, an uppercut's at UPPER_ELBOW_DEG).
static func reach(clip: String, l1: float, l2: float) -> float:
	if RangeTable.on and RangeTable.kind(clip) == "uppercut":
		return sqrt(l1 * l1 + l2 * l2 - 2.0 * l1 * l2 * cos(deg_to_rad(UPPER_ELBOW_DEG)))
	return l1 + l2 - 0.004


## Review round 1 (the ruler reading the bodies as drawn: straights landed with the elbow at 54-109 deg, the live shoulder
## and face 0.1 m off the table either way from punch to punch, which no stance distance can take out). What the chest leans
## to: the arm's reach when the point is out of reach (as before); for her armed punch, when the point is so close that the
## elbow would fold past its kind's angle (RangeTable.ELBOW_DEG: 162 a straight, 100 a hook, 105 an uppercut), the
## wrist's distance at that angle - the chest turns her shoulder BACK off the point (the owner: "make shoulder lean a bit
## back like in jab a"); the hips and feet stay where they are, so the weight going into the punch (PunchWeight) is the
## same. -1 = no lean. `clip` "" = a fading reach or the control arm (out of reach only).
static func lean_to(clip: String, d: float, reach_m: float, l1: float, l2: float) -> float:
	if d > reach_m:
		return reach_m
	if clip == "" or not RangeTable.on or RangeTable.kind(clip) == "body":
		return -1.0
	var th := deg_to_rad(float(RangeTable.ELBOW_DEG[RangeTable.kind(clip)]))
	var fold := sqrt(maxf(0.0, l1 * l1 + l2 * l2 - 2.0 * l1 * l2 * cos(th)))
	return fold if d < fold - 0.005 else -1.0


## The clip's own glove for the cap (skeleton space): read on the pass's first solve of the armed hand and kept for the
## rest of the pass (GloveClear's settle() re-solves from the already-moved arm, which let the glove go another CORR_M).
static func clip_glove(pr: Node, skel: Skeleton3D, ids: Array, front: float, armed: bool) -> Vector3:
	var pass_n := int(pr.get_meta("cg_pass", 0))
	if armed and int(pr.get_meta("cg_at", -1)) == pass_n:
		return pr.get_meta("cg")
	var g: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin + (pr.call("_along", skel, ids) as Vector3) * front
	if armed:
		pr.set_meta("cg_at", pass_n)
		pr.set_meta("cg", g)
	return g


## Review round 1 (blind review: "the cap is centred on last frame's clip glove ... the chest lean then adds on top",
## 0.397 m measured): the cap on the glove as DRAWN. Solves the arm onto `want`; when the glove front then stands further
## than CORR_M from the clip's own glove this frame (`clip_glove`, skeleton space, before any lean), the wrist is pulled
## back by the excess and the arm solved again (twice: the glove's axis turns with the forearm). `capped` false = a plain
## solve (a fading reach, the control arm).
static func solve_capped(pr: Node, skel: Skeleton3D, ids: Array, s: Vector3, want: Vector3, l1: float, l2: float, basis: Basis,
		pole: Vector3, pole_w: float, clip_glove: Vector3, front: float, capped: bool) -> void:
	solve_held(pr, skel, ids, s, want, l1, l2, basis, pole, pole_w)
	if capped:
		pr.set_meta("cg_w", skel.global_transform * clip_glove)   # the clip's own glove as last used this frame (probes)
	if not capped or not RangeTable.on:
		return
	var cap := CORR_M / maxf(skel.global_transform.basis.get_scale().x, 1e-4)
	for n in 2:
		var g: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin + (pr.call("_along", skel, ids) as Vector3) * front
		var off := g - base(clip_glove, body_shift(skel, int(ids[2])), g)
		if off.length() <= cap:
			return
		want -= off - off.limit_length(cap)
		solve_held(pr, skel, ids, s, want, l1, l2, basis, pole, pole_w)


## The armed glove's distance from the point it latched on the hit frame (metres; -1 before the latch or when not driven).
static func miss(pr: Node) -> float:
	var at: Vector3 = pr.get("hit_face")
	var shown: Vector3 = pr.get("_shown_cur")
	return shown.distance_to(at) if at.is_finite() and shown.is_finite() else -1.0


## Turns the chest about the root of the spine so the shoulder comes toward `want` by the part the arm cannot reach
## (at most lean_max * w radians).
static func lean(skel: Skeleton3D, chest: int, s: Vector3, want: Vector3, reach_m: float, w: float, lean_max: float) -> void:
	var g_ch: Transform3D = skel.get_bone_global_pose(chest)
	var pivot := g_ch.origin
	var from := (s - pivot)
	var short := s.distance_to(want) - reach_m
	var dir := (want - s).normalized()
	var to := from + dir * short
	if from.length() < 0.05 or to.length() < 0.05:
		return
	var q := Quaternion(from.normalized(), to.normalized())
	var ang := minf(q.get_angle(), lean_max * w)
	if ang < 1e-4:
		return
	q = Quaternion(q.get_axis().normalized(), ang)
	skel.set_bone_global_pose(chest, Transform3D(Basis(q) * g_ch.basis, pivot))


## S448 (the played lead uppercut, after its hit): while the reach holds a landed glove on its carry at full weight, the
## fist keeps the angle to the forearm it had on the hit frame (latch_hand). The clip's own hand turned up over her head
## while the reach held the forearm on her face: the wrist bent ~180 deg, and the glove's axis (the forearm's
## WRIST_STRAIGHT share, PunchReach._along) flipped from solve to solve - the glove out and back 26-37 m/s. After the hold
## the hand turns back to the clip's at most HAND_RATE (hand_rate), so letting go never turns the glove in one frame.
## Review (lead session: with every landed punch held, hooks' and the kidney shot's carry went short, THROUGH): only an
## uppercut holds its fist - its tail is the one that turns the fist up over her own head.
const HAND_RATE := deg_to_rad(1200.0)   # rad/s: ~20 deg a frame, the glove's front ~4 m/s from the turn alone


static func solve_held(pr: Node, skel: Skeleton3D, ids: Array, s: Vector3, want: Vector3, l1: float, l2: float, basis: Basis,
		pole: Vector3, pole_w: float) -> void:
	pr.call("solve", skel, ids, s, want, l1, l2, basis, pole, pole_w)
	if float(pr.get("_hold_w")) <= 0.0 or not bool(pr.get_meta("hold_on", false)):
		return
	var hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
	var held: Basis = skel.get_bone_global_pose(int(ids[1])).basis.orthonormalized() * (pr.get("_hold_hand") as Basis)
	skel.set_bone_global_pose(int(ids[2]), Transform3D(held.orthonormalized().scaled(hd.basis.get_scale()), hd.origin))
	pr.set_meta("held_k", int(pr.get("_key")))


## The armed hand in its forearm's frame as drawn on the hit frame (PunchReach._note_shown), for solve_held; an uppercut
## holds it from here, and hand_rate turns it back after.
static func latch_hand(pr: Node, skel: Skeleton3D, ids: Array) -> void:
	var la: Basis = skel.get_bone_global_pose(int(ids[1])).basis.orthonormalized()
	var hb: Basis = skel.get_bone_global_pose(int(ids[2])).basis.orthonormalized()
	pr.set("_hold_hand", la.inverse() * hb)
	var on := RangeTable.on and RangeTable.kind(str(pr.get("_clip"))) == "uppercut"
	pr.set_meta("hold_on", on)
	if on:
		pr.set_meta("trk", [str(pr.get("_hand")), Quaternion(hb), Engine.get_process_frames()])
		pr.set_meta("held_k", int(pr.get("_key")))
	else:
		pr.remove_meta("trk")


## Once a frame, after the reach: the tracked hand turns toward the pose's own at most HAND_RATE * dt; held this frame (or
## caught up) = it takes the pose's as it is.
static func hand_rate(pr: Node, skel: Skeleton3D, dt: float) -> void:
	var trk: Array = pr.get_meta("trk", [])
	if trk.is_empty() or not (pr.get("_arms") as Dictionary).has(trk[0]) or Engine.get_process_frames() - int(trk[2]) > 1:
		pr.remove_meta("trk")   # a frame missed: what it holds is stale, never turn from it
		return
	trk[2] = Engine.get_process_frames()
	var hid := int((pr.get("_arms") as Dictionary)[trk[0]][2])
	var hd: Transform3D = skel.get_bone_global_pose(hid)
	var now := Quaternion(hd.basis.orthonormalized())
	if int(pr.get_meta("held_k", -1)) == int(pr.get("_key")):
		trk[1] = now
		return
	var was: Quaternion = trk[1]
	var ang := was.angle_to(now)
	if ang <= HAND_RATE * dt:
		pr.remove_meta("trk")
		return
	var q := was.slerp(now, HAND_RATE * dt / ang)
	trk[1] = q
	skel.set_bone_global_pose(hid, Transform3D(Basis(q).scaled(hd.basis.get_scale()), hd.origin))


## Where the wrist must go for the glove front to sit on `target` (PunchReach._reach's passes, moved here unchanged in S448;
## each solve goes through solve_held). `from` INF: from the arm as it stands, measure then solve each pass (the last pass's
## target returned); else from that target, solve then measure each pass (the leaned shoulder's re-solve).
static func fit(pr: Node, skel: Skeleton3D, ids: Array, s: Vector3, target: Vector3, front: float, l1: float, l2: float,
		basis: Basis, pole: Vector3, pole_w: float, passes: int, from: Vector3) -> Vector3:
	if (RangeTable.on and RangeTable.kind(str(pr.get("_clip"))) == "uppercut") or bool(pr.get_meta("hold_on", false)):
		return _fit_held(pr, skel, ids, s, target, front, l1, l2, basis, pole, pole_w, passes)
	var full := from
	for k in passes:
		if from.is_finite():
			solve_held(pr, skel, ids, s, full, l1, l2, basis, pole, pole_w)
		var hd: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
		full = hd + (target - (hd + (pr.call("_along", skel, ids) as Vector3) * front))
		if not from.is_finite():
			solve_held(pr, skel, ids, s, full, l1, l2, basis, pole, pole_w)
	return full


## An uppercut's fit (S448): from the arm as it stands, a pass that misses by more goes back to the best one and takes half
## the step (the plain passes overshot on the folded arm after the hit). Uppercuts only: on every punch it moved the jabs'
## and crosses' glove off the face on the hit frame (hit_carry ON rows, lead session review). A held uppercut's fade after
## the cut to guard too (join_return RETURN: the same flip there); PunchReach.arm clears hold_on.
static func _fit_held(pr: Node, skel: Skeleton3D, ids: Array, s: Vector3, target: Vector3, front: float, l1: float, l2: float,
		basis: Basis, pole: Vector3, pole_w: float, passes: int) -> Vector3:
	var hd: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
	var best_hd := hd
	var best_err := target - (hd + (pr.call("_along", skel, ids) as Vector3) * front)
	var step := 1.0
	var full := best_hd + best_err
	for k in passes:
		solve_held(pr, skel, ids, s, full, l1, l2, basis, pole, pole_w)
		hd = skel.get_bone_global_pose(int(ids[2])).origin
		var err := target - (hd + (pr.call("_along", skel, ids) as Vector3) * front)
		if err.length() < best_err.length():
			best_hd = hd
			best_err = err
		else:
			step *= 0.5
		full = best_hd + best_err * step
	return full


## S466 LANDREACH1: where the landed glove's carry starts (see SHOWN_M). `face` = the latched face point, `shown` = the glove
## as drawn on the hit frame less the carry already run. Only the rear cross and rear hook (the bisect's short punches): the lead
## hand and the uppercuts land on their drawn point, and snapping them to the face sent their carry 0.12-0.27 m through
## (hit_frame THROUGH). `-- nopunchrange` (RangeTable off) = the review round 1 rule.
## S469 LANDREACH4: `w` = the reach's weight on the hit frame. Below full weight the glove is still easing in from the clip
## (a punch armed mid-clip: BeatFire's skip, a test that seeks straight to contact), 7-23 cm off her face: the hit point
## latched onto that glove and the glove went exactly there. Then the carry starts from the face, for either hand.
const FULL_W := 0.999
static var BY_WEIGHT: bool = not OS.get_cmdline_user_args().has("noweightbase")   # the control arm
static func carry_base(face: Vector3, shown: Vector3, clip: String, w: float = 1.0) -> Vector3:
	if BY_WEIGHT and RangeTable.on and w < FULL_W and face.is_finite():
		return face
	var rear := clip.contains("right_cross") or clip.contains("right_hook")
	if not RangeTable.on or not rear or not face.is_finite() or shown.distance_to(face) <= SHOWN_M:
		return shown
	return face
