extends SkeletonModifier3D
## FOOTWORK1: puts BoxerFootwork's plan on the boxer. The body node stands over the middle of the ankles facing the plan's
## yaw (drive()); the hips ride the bounce and the leg-to-leg sway; each foot stands on the ball of the foot with the heel
## up by the plan's pitch, its toes flat on the canvas, the knee over the toes (two-bone IK, the knee on its foot's line).
## S391 wired into the ring, so TWO modifiers: the legs run where FootPlant runs (after it, before the twist bones) and
## override it; the hips and the torso (class Upper, _torso: leaned, lagged, nodded, counter-twisted) run EARLY, before
## GuardTuck, PunchReach and GloveClear, or a bounce and a lean under the arms would move every landed glove off its target
## and every head out of its clearance. `w` eases the rig in and out (EASE_S): want = 0 hands the legs back to FootPlant
## under it, so falls, knockouts, the clinch and the win play free. Under a punch (plan.hold) the hips keep the clip's height.
##   attach(skel, body, plan, after, early) -> rig | null    drive()    mid()    want, w, ease_w(delta)
##   last: {ankle, ball, knee_deg} per foot (probes read it)

const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"], ["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]]
## The guard clip holds the hips at rest height with bent knees, so its feet float ~4.5 cm; the hips come down this much
## (skeleton units) so the balls stand ON the canvas with the knees bent ~30 deg at the top of the bounce.
const DROP := 0.04             # round 2: 0.02 -> 0.04 for the wider stance (the rear leg locked out at the top)
const REACH_MAX := 0.985       # never ask a leg for more than this of its length (knee ~160 deg)
## Round 2 (eyes on r3: knees caved in, torso rigid and upright): the knee is put over its own foot's line (the point on
## the IK circle whose sideways offset from the foot's vertical plane is nearest 0, turned at most KNEE_TURN_DEG off the
## plain toes-pole bend); the torso leans LEAN_DEG forward from the hips (half a hip hinge, half the spine, whatever
## the guard clip already leans); the chest rides the plan's lag, the head its nod, the chest its counter-twist.
const KNEE_TURN_DEG := 45.0
## ... and only this much of the way there (r4b look, front view of a side step: all the way read bow-legged on the
## turned-out rear foot; the rest of the way is the plain toes-pole bend)
const KNEE_OVER := 0.7
const LEAN_DEG := 10.0
const HINGE := 0.5             # share of the lean taken at the hips
## S392 (two blind judges, film 0:19.8: "his rear knee folds almost to the mat"): pro_body_shot takes the hips to 0.59 m with the
## rear foot held, the knee 0.19 m off the canvas. A duck stops at this share of the hips' rest height. `-- nohipfloor` = the control arm.
const HIP_FLOOR := 0.78
const GAZE := 0.5              # share of the lean the head takes back (eyes stay on the man in front)
const EASE_S := 0.2            # S391: in and out, like FootPlant's free clips
const MAX_PITCH := 1.1         # S391: the heel's highest, radians (a lunge's rear foot)
const SWING_PITCH := 0.3       # HUMANFIGHT1: a stepping foot's sole stays within ~17 deg of flat

var plan                       # BoxerFootwork
var body: Node3D
var _hips := -1
var _spine := -1
var _chest := -1
var _neck := -1
var _head := -1
var _hips_y := 0.0
var _floored: bool = not OS.get_cmdline_user_args().has("nohipfloor")
var _legs: Array = []          # [lead, rear]: {ids: [u, l, f, t], v: ball->ankle (flat, yaw 0), fb: foot basis, tb: toe basis, toe_y}
var last: Array = [{}, {}]
var want := 1.0                # S391: 1 = the rig has the legs and hips, 0 = FootPlant and the clip have them
var w := 1.0
var upper: Node = null         # S391: the early half (class Upper)
## HUMANFIGHT1: upper_want 0 = the legs only (eased like `w`: a switch in one frame dropped the hips 15 cm). Under a captured clip (RingFeet's carry) the take keeps its own hips and torso: the
## rig's drop, bounce and lean belong to the Punch PRO clips' floating guard, and easing them in and out for a
## quarter-second step moved the hips 4 cm down and up at every lunge.
var upper_want := 1.0
var upper_w := 1.0
var _guard_lean := 0.0         # S391: the lean last topped up in her guard


## `after`: the legs run right after this modifier. `early`: the hips and torso run right before this one (null = right
## before the legs, as on the studio grid: nothing between them there reads the arms).
static func attach(skel: Skeleton3D, owner_body: Node3D, footwork, after: Node = null, early: Node = null) -> Node:
	var rig := new()
	rig.name = "BoxerFootworkRig"
	rig.plan = footwork
	rig.body = owner_body
	if not rig.setup(skel):
		rig.free()
		return null
	skel.add_child(rig)
	if after != null and after.get_parent() == skel:
		skel.move_child(rig, after.get_index() + 1)
	else:
		var tw := skel.find_child("MetaHumanTwist", false, false)
		if tw != null:
			skel.move_child(rig, tw.get_index())
	var up := Upper.new()
	up.name = "BoxerFootworkUpper"
	up.rig = rig
	rig.upper = up
	skel.add_child(up)
	skel.move_child(up, (early if early != null and early.get_parent() == skel else rig).get_index())
	return rig


func setup(skel: Skeleton3D) -> bool:
	_hips = skel.find_bone("Hips")
	if _hips < 0:
		return false
	_hips_y = skel.get_bone_rest(_hips).origin.y
	_spine = skel.find_bone("Spine")
	_chest = skel.find_bone("Chest")
	_neck = skel.find_bone("Neck")
	_head = skel.find_bone("Head")
	var order := [0, 1] if plan.side > 0.0 else [1, 0]   # orthodox: the left leg leads
	for k in order:
		var ids: Array = []
		for n in LEGS[k]:
			ids.append(skel.find_bone(str(n)))
		if ids.has(-1):
			return false
		var ankle := skel.get_bone_global_rest(ids[2])
		var toe := skel.get_bone_global_rest(ids[3])
		var d := toe.origin - ankle.origin
		var flat := Basis(Vector3.UP, -atan2(d.x, d.z))   # turns the rest foot to point straight down +Z
		_legs.append({"ids": ids, "v": flat * (ankle.origin - toe.origin), "fb": flat * ankle.basis, "tb": flat * toe.basis,
			"toe_y": toe.origin.y})
	return true


## Stand the body on the plan: over the middle of the ankles, facing its yaw. Call each frame before the skeleton updates.
func drive() -> void:
	var p: Dictionary = plan.pose()
	var c: Vector2 = (p["centre"] as Vector2) + mid()
	body.global_position = Vector3(c.x, body.global_position.y, c.y)
	body.global_rotation = Vector3(0.0, float(p["yaw"]), 0.0)


## The middle of the ankles from the middle of the balls, world metres (x, z): the plan stands the balls of the feet, the
## hips belong over the ANKLES (they sit behind the balls, the rear one turned out), else the lead knee folds under her and
## the rear leg locks out. S391: the body node stands there, so its origin is still her hips, as the fight's gap assumes.
func mid() -> Vector2:
	var m := Vector3.ZERO
	var s := maxf(body.scale.x, 1e-3)
	for i in 2:
		m += Basis(Vector3.UP, float(plan.feet[i]["yaw"])) * (_legs[i]["v"] as Vector3) * 0.5 * s
	return Vector2(m.x, m.z)


## S391: the hips and the torso, from class Upper.
func early(skel: Skeleton3D) -> void:
	if w * upper_w <= 0.0 or plan == null:
		return
	var legs_w := w
	w *= upper_w   # the hips and torso half's own weight (the legs keep `w`)
	_early(skel)
	w = legs_w


func _early(skel: Skeleton3D) -> void:
	var p: Dictionary = plan.pose()
	var s := maxf(body.scale.x, 1e-3)
	var hip: Vector3 = p["hip"]
	var hp := skel.get_bone_pose_position(_hips)
	# in her guard the plan's bounce is the hips' height (the guard clip's own bob on top read 4.8 cm against the bar's 4.5);
	# in a punch, a slip or a reaction (hold) the clip's own height comes through: a duck goes down
	var y := lerpf(_hips_y, hp.y, float(plan.hold)) - DROP + hip.y / s
	if _floored:
		y = maxf(y, _hips_y * HIP_FLOOR)
	skel.set_bone_pose_position(_hips, hp + Vector3(hip.x / s, y - hp.y, hip.z / s) * w)
	_torso(skel, p, s)


## One frame toward `want` (RingFeet, once a frame).
func ease_w(delta: float) -> void:
	w = move_toward(w, want, delta / EASE_S)
	upper_w = upper_want if w <= 0.0 else move_toward(upper_w, upper_want, delta / EASE_S)


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or plan == null or w <= 0.0:
		return
	var p: Dictionary = plan.pose()
	var s := maxf(body.scale.x, 1e-3)
	var body_yaw := skel.global_rotation.y
	var inv := skel.global_transform.affine_inverse()
	for i in 2:
		var f: Dictionary = p["feet"][i]
		var leg: Dictionary = _legs[i]
		var ball_w: Vector3 = f["ball"]
		var ball := inv * Vector3(ball_w.x, skel.global_position.y, ball_w.z)
		ball.y = float(leg["toe_y"]) + ball_w.y / s
		var turn := Basis(Vector3.UP, wrapf(float(f["yaw"]) - body_yaw, -PI, PI))
		# HUMANFIGHT1 (two blind critics: "the lead boot hangs toe-down like a dancer's point"): the reach's heel lift is
		# for a PLANTED ball the hips have left behind; a foot in the air keeps its sole near flat.
		var swinging: bool = not ((plan.feet[i]["swing"] as Dictionary).is_empty())
		var pitch := minf(float(f["pitch"]), SWING_PITCH) if swinging else _reach_pitch(skel, leg, ball, turn, float(f["pitch"]))
		var tilt := turn * Basis(Vector3.RIGHT, pitch)
		var ankle: Vector3 = ball + tilt * (leg["v"] as Vector3)
		var toes_basis := (turn * Basis(Vector3.RIGHT, pitch * maxf(float(f["toe_pitch"]), 0.0)) * (leg["tb"] as Basis))
		var knee := _solve(skel, leg["ids"], ankle, ball, turn * Vector3.BACK, tilt * (leg["fb"] as Basis), toes_basis)
		last[i] = {"ankle": skel.global_transform * ankle, "ball": skel.global_transform * ball, "knee_deg": knee}


## S391 the hips have gone further from this planted ball than the leg reaches (a lunge's rear foot, a punch's carry): the
## heel comes up, the ball stays on the canvas. Without this the ankle fell short of its target and the foot was dragged.
func _reach_pitch(skel: Skeleton3D, leg: Dictionary, ball: Vector3, turn: Basis, pitch: float) -> float:
	var ids: Array = leg["ids"]
	var hip := skel.get_bone_global_pose(ids[0]).origin
	var long := ((skel.get_bone_global_pose(ids[1]).origin - hip).length() + (skel.get_bone_global_pose(ids[2]).origin - skel.get_bone_global_pose(ids[1]).origin).length()) * REACH_MAX
	var p := pitch
	while p < MAX_PITCH and (ball + turn * Basis(Vector3.RIGHT, p) * (leg["v"] as Vector3) - hip).length() > long:
		p += 0.06
	return minf(p, MAX_PITCH)


## The upper body (skeleton space: +Z forward, +X her left): the lean, the chest's lag, the head's nod, the twist.
func _torso(skel: Skeleton3D, p: Dictionary, s: float) -> void:
	if _spine < 0 or _neck < 0:
		return
	var v := skel.get_bone_global_pose(_neck).origin - skel.get_bone_global_pose(_hips).origin
	var lean := clampf(deg_to_rad(LEAN_DEG) - atan2(v.z, v.y), 0.0, deg_to_rad(25.0))
	# S391 the lean tops up her guard; a clip's own fold adds to it. Topping up against a fold took the lean back as she
	# curled (tools/body_react_probe.gd: worst body-shot curl 15.3 deg against the bar's 18; control 21.4).
	var hold := float(plan.hold)
	if hold <= 0.0:
		_guard_lean = lean
	lean = lerpf(lean, _guard_lean, hold) * w
	_turn(skel, _hips, Quaternion(Vector3.RIGHT, lean * HINGE))
	_turn(skel, _spine, Quaternion(Vector3.RIGHT, lean * (1.0 - HINGE)))
	var hb := skel.get_bone_global_pose(_hips).basis
	var sp := skel.get_bone_pose_position(_spine)
	skel.set_bone_pose_position(_spine, sp + hb.inverse() * Vector3(0.0, float(p.get("chest_dy", 0.0)) * w / s, 0.0))
	if _chest >= 0:
		_turn(skel, _chest, Quaternion(Vector3.UP, float(p.get("twist", 0.0)) * w))
	if _head >= 0:
		_turn(skel, _head, Quaternion(Vector3.RIGHT, float(p.get("nod", 0.0)) * w - lean * GAZE))


## Turn bone `b` by `q` (skeleton space) about its own joint.
static func _turn(skel: Skeleton3D, b: int, q: Quaternion) -> void:
	var g := skel.get_bone_global_pose(b).basis.get_rotation_quaternion()
	var parent := skel.get_bone_parent(b)
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(b, (qp.inverse() * q * g).normalized())


## Two-bone IK in skeleton space: hip -> knee -> ankle meets `t`, the knee over the foot's line (the vertical plane
## through the ankle `t` and the ball `ball`, `fwd` = the foot's heel-to-toe), the thigh twisted so the knee's hinge lies
## in the bend plane (no knee twist); then the foot and toes take their bases. Returns the knee's inner angle in degrees.
func _solve(skel: Skeleton3D, ids: Array, t: Vector3, ball: Vector3, fwd: Vector3, foot: Basis, toes: Basis) -> float:
	var ga := skel.get_bone_global_pose(ids[0])
	var gb := skel.get_bone_global_pose(ids[1])
	var gc := skel.get_bone_global_pose(ids[2])
	var a := ga.origin
	var b := gb.origin
	var c := gc.origin
	var l1 := (b - a).length()
	var l2 := (c - b).length()
	var d := t - a
	if l1 < 1e-5 or l2 < 1e-5 or d.length() < 1e-5:
		return 180.0
	var dir := d.normalized()
	var reach := clampf(d.length(), absf(l1 - l2) + 1e-3, (l1 + l2) * REACH_MAX)
	var u := fwd - dir * fwd.dot(dir)
	if u.length() < 1e-4:
		u = (b - a) - dir * (b - a).dot(dir)
	u = u.normalized()
	var along := (reach * reach + l1 * l1 - l2 * l2) / (2.0 * reach)
	var r := sqrt(maxf(l1 * l1 - along * along, 0.0))
	# the knee circle: a + dir * along + r (cos th u + sin th w); th = 0 bends toward the toes. Put the knee over the
	# foot's line: its sideways offset n.(knee - t) = 0, n = the foot's sideways axis
	var w := dir.cross(u)
	var fl := Vector3(ball.x - t.x, 0.0, ball.z - t.z)
	var n := (fl if fl.length() > 1e-4 else fwd).normalized().cross(Vector3.UP)
	var ca := r * n.dot(u)
	var cb := r * n.dot(w)
	var cr := sqrt(ca * ca + cb * cb)
	var th := 0.0
	if cr > 1e-5:
		var phi := atan2(cb, ca)
		var ac := acos(clampf(-n.dot(a + dir * along - t) / cr, -1.0, 1.0))
		var t1 := wrapf(phi + ac, -PI, PI)
		var t2 := wrapf(phi - ac, -PI, PI)
		th = clampf((t1 if absf(t1) < absf(t2) else t2) * KNEE_OVER, -deg_to_rad(KNEE_TURN_DEG), deg_to_rad(KNEE_TURN_DEG))
	var side := u * cos(th) + w * sin(th)
	var knee := a + dir * along + side * r
	var end := a + dir * reach
	var q1 := _arc(b - a, knee - a)
	# twist the thigh about itself so the clip's knee hinge lines up with the new bend plane
	var axis := (knee - a).normalized()
	var hinge0 := q1 * (b - a).cross(c - b)
	var hinge1 := (knee - a).cross(end - knee)
	var qt := Quaternion.IDENTITY
	if hinge0.length() > 1e-6 and hinge1.length() > 1e-6:
		var h0 := (hinge0 - axis * hinge0.dot(axis)).normalized()
		var h1 := (hinge1 - axis * hinge1.dot(axis)).normalized()
		qt = Quaternion(axis, atan2(axis.dot(h0.cross(h1)), clampf(h0.dot(h1), -1.0, 1.0)))
	var qa1 := (qt * q1 * ga.basis.get_rotation_quaternion()).normalized()
	var shin := qt * q1 * (c - b)
	var q2 := _arc(shin, end - knee)
	var qb1 := (q2 * qt * q1 * gb.basis.get_rotation_quaternion()).normalized()
	var qf := foot.get_rotation_quaternion()
	var parent := skel.get_bone_parent(ids[0])
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	_put(skel, ids[0], (qp.inverse() * qa1).normalized())
	_put(skel, ids[1], (qa1.inverse() * qb1).normalized())
	_put(skel, ids[2], (qb1.inverse() * qf).normalized())
	_put(skel, ids[3], (qf.inverse() * toes.get_rotation_quaternion()).normalized())
	return rad_to_deg((a - knee).angle_to(end - knee))


## A leg bone's turn: all the way at w = 1, part of the way from what FootPlant left while easing in or out.
func _put(skel: Skeleton3D, bone: int, q: Quaternion) -> void:
	skel.set_bone_pose_rotation(bone, q if w >= 1.0 else skel.get_bone_pose_rotation(bone).slerp(q, w))


static func _arc(from: Vector3, to: Vector3) -> Quaternion:
	if from.length() < 1e-6 or to.length() < 1e-6:
		return Quaternion.IDENTITY
	var f := from.normalized()
	var t := to.normalized()
	if f.dot(t) > 0.999999:
		return Quaternion.IDENTITY
	if f.dot(t) < -0.999999:
		var ortho := f.cross(Vector3.RIGHT)
		if ortho.length() < 1e-3:
			ortho = f.cross(Vector3.UP)
		return Quaternion(ortho.normalized(), PI)
	return Quaternion(f, t)


## S391: the early half of the rig (see the header).
class Upper:
	extends SkeletonModifier3D
	var rig: Node

	func _process_modification() -> void:
		var skel := get_skeleton()
		if skel != null and rig != null:
			rig.early(skel)
