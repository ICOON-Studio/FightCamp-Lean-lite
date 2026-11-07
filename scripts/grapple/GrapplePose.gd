extends SkeletonModifier3D
## S335 a GrappleMap man's 23 joints -> our MetaHuman's 22 bones (BJJ_SOURCES_S334.md "Retarget route", decided there).
## Each bone takes the rotation that turns its rest pair of directions (an aim from this joint to the next, and a second
## direction that fixes the roll) into the same pair read off the joints. Aim + roll per bone, so the rig's own bone axes
## never matter. The rolls: limbs use their bend plane (shoulder-elbow-wrist / hip-knee-ankle are three real points) and
## fall back to the body's forward when the limb is straight; the trunk uses the hip line and the shoulder line, its bend
## shared over Spine / Chest / UpperChest (1/3, 2/3, 1); feet use heel-toe-ankle; the head follows the neck; the palm roll
## is not in the data, so the hand keeps the forearm's. Bone lengths stay ours (only the hips take the data's position),
## so a longer arm reaches past the data's hand - the player scales the pair to our size first.
## S379 BJJ9R11 continuity (operator on the theatre's 'To 50/50' at 0:14: "not sure what is this ??" - red's head jumped
## 0.2 m in one frame while the data moved 5 cm). The drawn pose (the modifier, frame after frame) remembers its last trunk
## turn and limb bend planes, so no bone's roll flips in one frame:
## * trunk: Spine/Chest share the hips-to-shoulders turn (1/3, 2/3) by slerp, which takes the short way round; when that
##   turn passes 180 deg the short way swaps sides and Spine/Chest spun ~120 deg in one frame (the head 0.2 m). At such a
##   crossing the trunk keeps turning the way it came, then unwinds to the short way over UNWIND_S (eased).
## * limbs: a straight limb's bend plane is noise (upper x lower flips sign through straight, and the old hard switch to
##   the body's forward at sin 0.15 jumped too: upper arms rolled 94-177 deg in one frame on 5 of the 8 theatre chains).
##   The roll now follows the bend plane only as the limb bends (BEND_S0..BEND_S1, the sine of the bend) and otherwise
##   keeps the last frame's roll (the body's forward in a one-off pose_globals call), turning at most ROLL_STEP_DEG a
##   frame; the IK bends toward that roll.
## * hands: the forearm's frame swung onto the data's hand (an aim + roll frame flipped where the data's hand joint sits
##   along the bend normal - hands spun 94-178 deg in one frame), the swing capped and faded where the hand joint is noise.
## * feet: a pointed foot lines heel, ankle and toe up and its side's sign flips; the drawn foot keeps the last frame's side.
## A cut (seek, another chain: the joints jump, CUT_M) forgets the last frame. Measured: tools/theatre_pop_probe.gd.
##   attach(skel) -> GrapplePose   .joints = PackedVector3Array(23, world)   (empty = the pose is left alone)

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const SIDES := ["Left", "Right"]
## Seconds a trunk turned the long way (past 180 deg) takes to unwind to the short way.
const UNWIND_S := 1.0
## The sine of a limb's bend where its roll starts / ends following the bend plane (~4.6 / ~25 deg).
const BEND_S0 := 0.08
const BEND_S1 := 0.42
## |dot| of the last and the new short trunk turn under this (> 60 deg apart) = a cut (seek, new move), not a crossing.
const CUT_DOT := 0.87
## A limb or foot whose aim turned more than this in one frame was cut to (seek, new move): its roll starts afresh.
const CUT_DEG := 45.0
## The most a drawn limb's roll turns in one frame (a limb re-bending the other way rolls round over a few frames).
const ROLL_STEP_DEG := 20.0
## The joints' mean move in one frame (m, skeleton space) over which the drawn pose takes it as a cut and starts afresh.
const CUT_M := 0.12
## The most a hand swings off its forearm (deg), and the data's hand-off-forearm angles over which that swing fades out.
const WRIST_MAX := 90.0
const WRIST_FADE := Vector2(120.0, 165.0)
## The data's wrist->hand lengths (m, pair-scaled) over which the hand's swing fades in (shorter = a collapsed hand joint).
const HAND_SHORT := Vector2(0.03, 0.06)
const SOFT_IK_M := 0.04
## S399 GRAPPLEFIX1: an elbow or knee folds no tighter than this inside angle. A hold that pulled a hand onto its own shoulder
## folded the arm flat, the bend's direction came from a 1-2 cm hand-to-shoulder line, and the elbow spun 46 cm in a frame (860).
const FOLD_MIN_DEG := 35.0
const FOLD_MIN_LEG_DEG := 15.0   # a knee folds heel to seat (35 deg pushed 1235's feet into the other woman: park 6.7 -> 15.4 cm)
static var fold_min_deg := _arg_f("fold=", FOLD_MIN_DEG)
static var fold_min_leg_deg := _arg_f("foldleg=", FOLD_MIN_LEG_DEG)
static var soft_ik_m := _arg_f("softik=", SOFT_IK_M)


static func _arg_f(prefix: String, fallback: float) -> float:
	for x in OS.get_cmdline_user_args():
		if str(x).begins_with(prefix):
			return float(str(x).substr(prefix.length()))
	return fallback

var joints := PackedVector3Array()
## World-space offset applied to every drawn bone after the solve (partner overlap fix — joints stay on the data).
var world_shift := Vector3.ZERO
## Two-bone IK on the wrists and ankles after the aim solve (off = the aim solve alone, the control arm)
var ik := true
## S391 GrappleLimbs: limb key ("LeftArm"...) -> [root to middle, end offset]: world metres, the second off the recording.
var limb_fix := {}
## S391 GrappleLimbs: [offset at the head's centre, world metres; that centre's distance from the neck]. Empty = the recording's head.
var head_fix: Array = []
## The limbs as the recording alone draws them, skeleton space, from the last pose_globals: key -> [middle, end, bend normal].
var limb_rec := {}
## S399 GRAPPLEFIX1: a fixed step for the drawn pose's memory (tools/grapple_orbit.gd, tests); < 0 = the frame's delta.
var step_dt := -1.0
var _id := {}
var _rest := {}          # bone -> global rest (skeleton space)
var _rest_local := {}    # bone -> local rest
var _fwd := Vector3.BACK # the body's forward at rest (skeleton space), from the feet
var _mem := {}           # the drawn pose's last frame: trunk turn + unwind, each limb's bend normal (skeleton space)


static func attach(skel: Skeleton3D) -> Node:
	var gp := new()
	gp.name = "GrapplePose"
	if not gp._setup(skel):
		gp.free()
		return null
	skel.add_child(gp)
	# Before the twist bones read the arms.
	var twist := skel.get_node_or_null("MetaHumanTwist")
	if twist != null:
		skel.move_child(gp, twist.get_index())
	return gp


func _setup(skel: Skeleton3D) -> bool:
	var names := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head"]
	for s in SIDES:
		for b in ["Shoulder", "UpperArm", "LowerArm", "Hand", "MiddleProximal", "UpperLeg", "LowerLeg", "Foot", "Toes"]:
			names.append(s + b)
	for n in names:
		var i := skel.find_bone(n)
		if i < 0:
			return false
		_id[n] = i
	for i in skel.get_bone_count():
		_rest[i] = skel.get_bone_global_rest(i)
		_rest_local[i] = skel.get_bone_rest(i)
	var f := Vector3.ZERO
	for s in SIDES:
		f += _p(s + "Toes") - _p(s + "Foot")
	f.y = 0.0
	_fwd = f.normalized()
	return true


func _p(bone: String) -> Vector3:
	return (_rest[_id[bone]] as Transform3D).origin


## The orthonormal frame of an aim and a roll direction (columns: aim, roll made square to it, their cross).
static func frame(aim: Vector3, roll: Vector3) -> Basis:
	var a := aim.normalized()
	var s := square(roll, a)
	return Basis(a, s, a.cross(s))


## `v` made square to the unit `u` and normalized; any square direction when `v` lies along `u`.
static func square(v: Vector3, u: Vector3) -> Vector3:
	var p := v - u * u.dot(v)
	if p.length() < 1e-5:
		p = u.cross(Vector3.UP if absf(u.y) < 0.9 else Vector3.RIGHT)
	return p.normalized()


## The rotation taking the rest pair onto the target pair.
static func turn(rest_aim: Vector3, rest_roll: Vector3, aim: Vector3, roll: Vector3) -> Basis:
	return frame(aim, roll) * frame(rest_aim, rest_roll).inverse()


## World rotations per bone (skeleton space) for one man's joints `j` (skeleton space). Pure apart from the rest pose,
## unless `mem` is given: the last frame's trunk turn and bend normals, read and updated (`dt` seconds since).
func solve_rotations(j: PackedVector3Array, mem: Variant = null, dt: float = 0.0) -> Dictionary:
	if mem is Dictionary:
		_cut(mem, j)
	var J := func(n: String) -> Vector3: return j[DB.joint(n)]
	var rot := {}
	var lhip: Vector3 = J.call("LeftHip")
	var rhip: Vector3 = J.call("RightHip")
	var mid_rest := (_p("LeftUpperLeg") + _p("RightUpperLeg")) * 0.5
	var mid := (lhip + rhip) * 0.5
	var r_hips := turn(_p("Chest") - mid_rest, _p("RightUpperLeg") - _p("LeftUpperLeg"),
		J.call("Core") - mid, J.call("RightHip") - J.call("LeftHip"))
	var r_top := turn(_p("Neck") - _p("Chest"), _p("RightUpperArm") - _p("LeftUpperArm"),
		J.call("Neck") - J.call("Core"), J.call("RightShoulder") - J.call("LeftShoulder"))
	var mids := trunk(r_hips.get_rotation_quaternion(), r_top.get_rotation_quaternion(), mem, dt)
	rot["Hips"] = r_hips
	rot["Spine"] = mids[0]
	rot["Chest"] = mids[1]
	rot["UpperChest"] = r_top
	var r_neck := turn(_p("Head") - _p("Neck"), _p("RightUpperArm") - _p("LeftUpperArm"),
		J.call("Head") - J.call("Neck"), J.call("RightShoulder") - J.call("LeftShoulder"))
	rot["Neck"] = r_neck
	rot["Head"] = r_neck
	var fwd_top := r_top * _fwd
	var fwd_hips := r_hips * _fwd
	for s in SIDES:
		rot[s + "Shoulder"] = turn(_p(s + "UpperArm") - _p("Neck"), _p("Neck") - _p("Chest"),
			J.call(s + "Shoulder") - J.call("Neck"), J.call("Neck") - J.call("Core"))
		# Arm: a bent elbow (upper arm down, forearm forward) has the bend normal upper x fore = rest aim x forward.
		var ua: Vector3 = J.call(s + "Elbow") - J.call(s + "Shoulder")
		var fa: Vector3 = J.call(s + "Wrist") - J.call(s + "Elbow")
		var rest_ua := _p(s + "LowerArm") - _p(s + "UpperArm")
		var n := bend_normal(ua, fa, ua.cross(fwd_top), mem, s + "Arm")
		var rest_n := rest_ua.cross(_fwd)
		rot[s + "UpperArm"] = turn(rest_ua, rest_n, ua, n)
		rot[s + "LowerArm"] = turn(_p(s + "Hand") - _p(s + "LowerArm"), rest_n, fa, n)
		# Hand: the forearm's frame swung onto the data's hand (no twist at the wrist; the palm roll is not in the data).
		# The data's hand often sits 90 deg off the forearm ALONG the bend normal, where an aim + roll frame flipped.
		var r_fore: Basis = rot[s + "LowerArm"]
		rot[s + "Hand"] = wrist(r_fore, r_fore * (_p(s + "MiddleProximal") - _p(s + "Hand")), J.call(s + "Hand") - J.call(s + "Wrist"))
		# Leg: a bent knee (thigh forward-down, shin back-down) has thigh x shin = forward x down.
		var th: Vector3 = J.call(s + "Knee") - J.call(s + "Hip")
		var sh: Vector3 = J.call(s + "Ankle") - J.call(s + "Knee")
		var rest_th := _p(s + "LowerLeg") - _p(s + "UpperLeg")
		var m := bend_normal(th, sh, fwd_hips.cross(th), mem, s + "Leg")
		var rest_m := _fwd.cross(rest_th)
		rot[s + "UpperLeg"] = turn(rest_th, rest_m, th, m)
		rot[s + "LowerLeg"] = turn(_p(s + "Foot") - _p(s + "LowerLeg"), rest_m, sh, m)
		# Foot: toe-heel forward, ankle-heel up -> forward x up is the foot's side, at rest and in the data.
		var toe: Vector3 = J.call(s + "Toe")
		var heel: Vector3 = J.call(s + "Heel")
		var ankle: Vector3 = J.call(s + "Ankle")
		var rest_ft := _p(s + "Toes") - _p(s + "Foot")
		rot[s + "Foot"] = turn(rest_ft, Vector3(rest_ft.x, 0.0, rest_ft.z).cross(Vector3.UP),
			toe - ankle, foot_side(toe - heel, ankle - heel, toe - ankle, mem, s + "Foot"))
		rot[s + "Toes"] = rot[s + "Foot"]
	return rot


## A cut (a seek, another chain or move laid on: the joints jumped over CUT_M on average since the last frame) forgets
## the last frame, so the drawn pose starts afresh like a one-off solve instead of easing out of a stale roll.
static func _cut(mem: Dictionary, j: PackedVector3Array) -> void:
	if mem.has("joints") and (mem["joints"] as PackedVector3Array).size() == j.size():
		var last: PackedVector3Array = mem["joints"]
		var sum := 0.0
		for i in j.size():
			sum += j[i].distance_to(last[i])
		if sum / maxf(1.0, j.size()) > CUT_M:
			mem.clear()
	mem["joints"] = j


## Spine and Chest: the hips-to-shoulders turn shared 1/3 and 2/3 (qh, qt world rotations). Without `mem` the short way
## (a slerp). With it: when the turn passes 180 deg (its short way swaps sides from one frame to the next) the bones keep
## the way they were turning (unwind = 1) and ease back to the short way over UNWIND_S; a cut (the turn jumped) snaps.
static func trunk(qh: Quaternion, qt: Quaternion, mem: Variant = null, dt: float = 0.0) -> Array:
	var rel := (qh.inverse() * qt).normalized()
	if rel.w < 0.0:
		rel = -rel
	var unwind := 0.0
	if mem is Dictionary:
		var last: Dictionary = mem
		unwind = float(last.get("unwind", 0.0))
		if last.has("trunk"):
			var d := rel.dot(last["trunk"])
			if absf(d) < CUT_DOT:
				unwind = 0.0
			elif d < 0.0:
				unwind = 1.0 - unwind
		unwind = maxf(0.0, unwind - dt / UNWIND_S)
		last["trunk"] = rel
		last["unwind"] = unwind
	var ang := rel.get_angle()
	if unwind <= 0.0 or ang < 1e-3:
		return [Basis(qh.slerp(qt, 1.0 / 3.0)), Basis(qh.slerp(qt, 2.0 / 3.0))]
	# The short turn `ang` about `axis`, less a full turn as far as the unwind has left: the way it came.
	var axis := rel.get_axis()
	var total := ang - smoothstep(0.0, 1.0, unwind) * TAU
	return [Basis(qh * Quaternion(axis, total / 3.0)), Basis(qh * Quaternion(axis, total * 2.0 / 3.0))]


## A limb's roll normal (upper, lower: its two segments): the bend plane (upper x lower) once the limb bends past
## BEND_S1, else a reference turned toward the bend plane as far as it bends - the last frame's normal (mem[key]) carried
## onto the new upper segment, or `fallback` the first time. With `mem` it turns at most ROLL_STEP_DEG a frame (a limb
## re-bending the other way rolls round over a few frames) unless the limb was cut to (its upper segment jumped over
## CUT_DEG). A limb passing straight never flips its roll.
static func bend_normal(upper: Vector3, lower: Vector3, fallback: Vector3, mem: Variant = null, key: String = "") -> Vector3:
	var u := upper.normalized()
	var nb := u.cross(lower.normalized())
	var held := false
	var ref := fallback
	if mem is Dictionary and (mem as Dictionary).has(key) and rad_to_deg(u.angle_to(mem[key + "Aim"])) < CUT_DEG:
		var last: Vector3 = mem[key]
		if (last - u * u.dot(last)).length() > 0.3:
			ref = last
			held = true
	ref = square(ref, u)
	var w := smoothstep(BEND_S0, BEND_S1, nb.length())
	var n := ref
	if w > 0.0:
		var a := ref.signed_angle_to(nb.normalized(), u) * w
		if held:
			a = clampf(a, -deg_to_rad(ROLL_STEP_DEG), deg_to_rad(ROLL_STEP_DEG))
		n = ref.rotated(u, a)
	if mem is Dictionary:
		mem[key] = n
		mem[key + "Aim"] = u
	return n


## The hand's world rotation: the forearm's `r_fore` swung from `straight` (where a straight wrist points the hand) onto
## the data's wrist->hand `hand`, at most WRIST_MAX; a hand joint folded back over the wrist (WRIST_FADE) is noise - its
## swing axis spins - so its swing fades to none there, as it does for a hand joint collapsed onto the wrist (HAND_SHORT:
## the data's wrist->hand is 7.5-9.5 cm; at 2-3 cm its direction is noise).
static func wrist(r_fore: Basis, straight: Vector3, hand: Vector3) -> Basis:
	var axis := straight.cross(hand)
	if axis.length() < 1e-6:
		return r_fore
	var deg := rad_to_deg(straight.angle_to(hand))
	var k := minf(deg, WRIST_MAX) * (1.0 - smoothstep(WRIST_FADE.x, WRIST_FADE.y, deg)) * smoothstep(HAND_SHORT.x, HAND_SHORT.y, hand.length())
	return Basis(axis.normalized(), deg_to_rad(k)) * r_fore


## The foot's side from the data's heel->toe `fwd` and heel->ankle `up` (fwd x up), square to the foot's `aim`. With `mem`
## (the last frame's side, mem[key]): when heel, ankle and toe line up (a pointed foot) the side's sign is noise - the
## data's ankle crosses the heel-toe line and the sole flipped in one frame - so it stays on the last frame's side and is
## held there as the points line up (sine BEND_S0..BEND_S1), turning at most ROLL_STEP_DEG a frame. A cut (the foot's
## aim jumped over CUT_DEG) starts afresh.
static func foot_side(fwd: Vector3, up: Vector3, aim: Vector3, mem: Variant = null, key: String = "") -> Vector3:
	var a := aim.normalized()
	var side := fwd.cross(up)
	if not mem is Dictionary:
		return side
	var last: Dictionary = mem
	if last.has(key) and rad_to_deg(a.angle_to(last[key + "Aim"])) < CUT_DEG:
		var ref := square(last[key], a)
		if side.dot(ref) < 0.0:
			side = -side
		var w := smoothstep(BEND_S0, BEND_S1, side.length() / maxf(1e-6, fwd.length() * up.length()))
		var turn_by := clampf(ref.signed_angle_to(square(side, a), a) * w, -deg_to_rad(ROLL_STEP_DEG), deg_to_rad(ROLL_STEP_DEG))
		side = ref.rotated(a, turn_by)
	last[key] = square(side, a)
	last[key + "Aim"] = a
	return side


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or joints.size() != DB.JOINTS.size():
		return
	var inv := skel.global_transform.affine_inverse()
	var j := PackedVector3Array()
	for v in joints:
		j.append(inv * v)
	var glob := pose_globals(skel, j, _mem, step_dt if step_dt >= 0.0 else get_process_delta_time())
	if world_shift.length_squared() > 1e-12:
		var gt := skel.global_transform
		var inv_gt := gt.affine_inverse()
		for i in glob:
			var w: Vector3 = gt * (glob[i] as Transform3D).origin + world_shift
			var g: Transform3D = glob[i]
			g.origin = inv_gt * w
			glob[i] = g
	for i in skel.get_bone_count():
		var parent := skel.get_bone_parent(i)
		var local: Transform3D = glob[i] if parent < 0 else (glob[parent] as Transform3D).affine_inverse() * glob[i]
		skel.set_bone_pose_position(i, local.origin)
		skel.set_bone_pose_rotation(i, local.basis.get_rotation_quaternion())


## Every bone's pose in skeleton space for joints `j` (skeleton space). A bone read from outside gets the pose before
## the modifiers ran (S307 trap), so tests and cameras read this - one-off (no `mem`): the short trunk turn and the body's
## forward for a straight limb's roll, so it differs from the drawn pose only at a 180-deg trunk crossing or a straight limb.
func pose_globals(skel: Skeleton3D, j: PackedVector3Array, mem: Variant = null, dt: float = 0.0) -> Dictionary:
	if head_fix.size() == 2 and (head_fix[0] as Vector3).length_squared() > 1e-8:
		# The neck bends toward the corrected head; the Head joint's distance is the data's, so the offset is scaled to it.
		j = j.duplicate()
		var hj := DB.joint("Head")
		j[hj] += skel.global_transform.basis.inverse() * (head_fix[0] as Vector3) * (j[hj].distance_to(j[DB.joint("Neck")]) / float(head_fix[1]))
	var rot := solve_rotations(j, mem, dt)
	var by_id := {}
	for n in rot.keys():
		by_id[_id[n]] = rot[n]
	var mid_rest := (_p("LeftUpperLeg") + _p("RightUpperLeg")) * 0.5
	var mid := (j[DB.joint("LeftHip")] + j[DB.joint("RightHip")]) * 0.5
	var hips_pos := mid + (rot["Hips"] as Basis) * (_p("Hips") - mid_rest)
	var glob := {}
	for i in skel.get_bone_count():
		_global(skel, i, by_id, hips_pos, glob)
	if not ik:
		return glob
	# Two-bone IK: our arms and legs are not the data's, so the wrists and ankles go where the data puts them (a grip,
	# a post, a foot on the mat), the elbow and knee kept on the side the data bends them.
	for s in SIDES:
		for limb in [["UpperArm", "LowerArm", "Hand", "Wrist"], ["UpperLeg", "LowerLeg", "Foot", "Ankle"]]:
			var up: String = s + limb[0]
			var lo: String = s + limb[1]
			var rest_up := _p(lo) - _p(up)
			var rest_lo := _p(s + limb[2]) - _p(lo)
			var roll := rest_up.cross(_fwd) if limb[0] == "UpperArm" else _fwd.cross(rest_up)
			# The aim solve's bend normal (continuous through straight) picks the side the elbow / knee bends to.
			var normal: Vector3 = (by_id[_id[up]] as Basis) * roll
			var root: Vector3 = glob[_id[up]].origin
			var is_leg: bool = limb[0] == "UpperLeg"
			var bend := _reach(root, j[DB.joint(s + limb[3])], rest_up.length(), rest_lo.length(), normal, is_leg)
			if bend.is_empty():
				continue
			var key: String = s + ("Arm" if limb[0] == "UpperArm" else "Leg")
			var rec_mid: Vector3 = root + (bend[0] as Vector3)
			var rec_end: Vector3 = rec_mid + (bend[1] as Vector3)
			limb_rec[key] = [rec_mid, rec_end, normal]
			var fix: Array = limb_fix.get(key, [])
			if not fix.is_empty():
				# GrappleLimbs: the end moved, and the middle sticks out the way it says.
				var to_skel := skel.global_transform.basis.inverse()
				var end: Vector3 = rec_end + to_skel * (fix[1] as Vector3)
				var plane := (to_skel * (fix[0] as Vector3)).cross(end - root)
				var moved := _reach(root, end, rest_up.length(), rest_lo.length(), held_plane(plane, normal), is_leg)
				if not moved.is_empty():
					bend = moved
			var n: Vector3 = (bend[0] as Vector3).cross(bend[1])
			if n.length() < 1e-4:
				continue
			by_id[_id[up]] = turn(rest_up, roll, bend[0], n)
			by_id[_id[lo]] = turn(rest_lo, roll, bend[1], n)
	glob = {}
	for i in skel.get_bone_count():
		_global(skel, i, by_id, hips_pos, glob)
	return glob


## The plane a corrected limb bends in. Near the line it means nothing: it fades to the recording's own, or the elbow flips side in one frame.
static func held_plane(plane: Vector3, normal: Vector3) -> Vector3:
	var firm := smoothstep(0.01, 0.05, plane.length())
	return plane.normalized() * firm + normal.normalized() * (1.0 - firm)


## The shortest root-to-end distance a limb of these lengths reaches (FOLD_MIN_DEG at the middle joint).
static func min_reach(a: float, b: float, leg: bool = false) -> float:
	var fold := fold_min_leg_deg if leg else fold_min_deg
	return sqrt(maxf(0.0, a * a + b * b - 2.0 * a * b * cos(deg_to_rad(fold))))


## The upper and lower limb directions that put the end at `target` from `root` (lengths a, b; the reach clamped), the
## middle joint bent in the plane square to `normal` (upper x lower along normal: toward dir x normal). [] when the
## target is on the root.
static func _reach(root: Vector3, target: Vector3, a: float, b: float, normal: Vector3, leg: bool = false) -> Array:
	var to := target - root
	if to.length() < 1e-4:
		return []
	var dir := to.normalized()
	# S399 GRAPPLEFIX1 soft IK: near full reach the middle joint sits sqrt(shortfall) off the line, so a target hovering at arm's
	# length pumped the elbow in and out (727: elbow jerk p95 938 m/s^3 with IK, 111 without). Past SOFT_IK_M short of straight
	# the reach eases toward full exponentially instead of clamping: the end falls a little short, the middle never snaps.
	var d := to.length()
	var lmax := a + b
	if soft_ik_m > 0.0 and d > lmax - soft_ik_m:
		d = lmax - soft_ik_m * exp(-(d - (lmax - soft_ik_m)) / soft_ik_m)
	var dmin := min_reach(a, b, leg)
	if soft_ik_m > 0.0 and d < dmin + soft_ik_m:
		d = dmin + soft_ik_m * exp(-((dmin + soft_ik_m) - d) / soft_ik_m)
	d = clampf(d, absf(a - b) + 1e-3, lmax - 1e-3)
	var pole := square(dir.cross(normal), dir)
	var c := clampf((a * a + d * d - b * b) / (2.0 * a * d), -1.0, 1.0)
	var elbow := root + dir * (a * c) + pole * (a * sqrt(1.0 - c * c))
	return [elbow - root, root + dir * d - elbow]


## A bone's pose in skeleton space: a solved bone turns its rest by its rotation; the rest follow their parent. Every
## bone keeps its rest offset from its parent (our lengths), the hips alone go where the data puts them.
func _global(skel: Skeleton3D, i: int, by_id: Dictionary, hips_pos: Vector3, glob: Dictionary) -> Transform3D:
	if glob.has(i):
		return glob[i]
	var parent := skel.get_bone_parent(i)
	var pg: Transform3D = Transform3D.IDENTITY if parent < 0 else _global(skel, parent, by_id, hips_pos, glob)
	var t := pg * (_rest_local[i] as Transform3D)
	if by_id.has(i):
		t.basis = (by_id[i] as Basis) * (_rest[i] as Transform3D).basis
	if i == _id["Hips"]:
		t.origin = hips_pos
	glob[i] = t
	return t
