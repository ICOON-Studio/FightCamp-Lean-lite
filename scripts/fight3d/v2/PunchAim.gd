extends SkeletonModifier3D
## FIGHTPLAYER2 phase 3 (S512, scope 3a + 3c: "code FINISHES the last 30 cm of a punch"): the ONE arm adjustment of the
## v2 player. A landed punch's take carries its glove to where the take's own actor aimed (the census: the bought jab
## lands 20 cm under the chin of a man his own size). This moves the punching hand by the offset between where the take
## will put the glove front at its contact and the target point (the lower face, the ribs), eased in over the last
## IN_S before the contact and out after it, never more than MAX_M: the swing keeps its shape, the arm finishes on
## the target. Two-bone IK on the punching arm only (the elbow keeps its bend plane); nothing else is touched.
## Not for a miss (it stays short) or a blocked punch (it stops on the guard's line).
##   attach(skel, after) -> PunchAim     arm(clip, hand, contact_s, offset_fn)     disarm()     last_m: the offset used

const MAX_M := 0.30
const IN_S := 0.22            # the offset eases in over this before the contact
const HOLD_S := 0.04          # ... is whole this long after it
const OUT_S := 0.22           # ... and is gone this long after that

var ap: AnimationPlayer
var _clip := ""
var _ids: Array = []          # [upper arm, lower arm, hand]
var _contact_s := 0.0
var _offset: Callable         # () -> Vector3: target - where the take will put the glove front, world
var _latched := Vector3.ZERO
var _has_latch := false
var last_m := 0.0
var left_m := 0.0             # what the solve could not close (m): the arm is at its reach
var front_rel := Vector3.ZERO  # wrist -> glove front, skeleton space, as the take holds it at its contact


static func attach(skel: Skeleton3D, player: AnimationPlayer, after: Node) -> Node:
	var m := new()
	m.name = "PunchAim"
	m.ap = player
	skel.add_child(m)
	skel.move_child(m, (after.get_index() + 1) if after != null else 0)
	return m


func arm(clip: String, hand: String, contact_s: float, offset_fn: Callable, wrist_to_front: Vector3 = Vector3.ZERO) -> void:
	front_rel = wrist_to_front
	var skel := get_skeleton()
	var side := hand.trim_suffix("Hand")
	_ids = [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(hand)]
	if _ids.has(-1):
		_clip = ""
		return
	_clip = clip
	_contact_s = contact_s
	_offset = offset_fn
	_has_latch = false
	last_m = 0.0


func disarm() -> void:
	_clip = ""


func _process_modification() -> void:
	if _clip == "" or ap == null or str(ap.current_animation) != _clip:
		_clip = ""
		return
	var ct := ap.current_animation_position - _contact_s
	if ct < -IN_S:
		return
	if ct > HOLD_S + OUT_S:
		_clip = ""
		return
	var w := 1.0
	if ct < 0.0:
		w = 1.0 + ct / IN_S
	elif ct > HOLD_S:
		w = 1.0 - (ct - HOLD_S) / OUT_S
	w = w * w * (3.0 - 2.0 * w)
	# the target is followed until the glove is nearly there, then held (a head that snaps on the hit must not drag it)
	if ct < -0.03 or not _has_latch:
		_latched = (_offset.call() as Vector3).limit_length(MAX_M)
		_has_latch = true
	last_m = _latched.length()
	if last_m < 0.005:
		return
	var skel := get_skeleton()
	var inv := skel.global_transform.affine_inverse()
	var pa := skel.get_bone_global_pose(int(_ids[0]))
	var pb := skel.get_bone_global_pose(int(_ids[1]))
	var pc := skel.get_bone_global_pose(int(_ids[2]))
	# The glove front sits past the wrist, rigid with the forearm: moving the wrist turns the forearm and the front with
	# it. Solve for the FRONT (three passes: the wrist goal is corrected by what the turn of the forearm adds).
	var want: Vector3 = inv.basis * _latched * w
	var rel: Vector3 = pb.basis.inverse() * front_rel
	var goal: Vector3 = pc.origin + want
	var got: Array = []
	var best := INF
	var hand_rel: Vector3 = pb.basis.inverse() * (pc.origin - pb.origin)
	for pass_i in 6:
		var try: Array = _solve(pa, pb, pc, goal)
		if try.is_empty():
			break
		var nb: Transform3D = try[1]
		var miss: Vector3 = (pc.origin + front_rel + want) - (nb.origin + nb.basis * (hand_rel + rel))
		if miss.length() < best:
			best = miss.length()
			got = try
		if best < 0.004:
			break
		goal += miss * 0.7
	left_m = best
	if got.is_empty():
		return
	skel.set_bone_global_pose(int(_ids[0]), got[0])
	skel.set_bone_global_pose(int(_ids[1]), got[1])


## Two-bone IK (Holden, "Simple Two Joint IK"): the hand goes to `goal`, the elbow keeps its bend plane.
func _solve(pa: Transform3D, pb: Transform3D, pc: Transform3D, goal: Vector3) -> Array:
	var a := pa.origin
	var b := pb.origin
	var c := pc.origin
	var lab := (b - a).length()
	var lcb := (c - b).length()
	if lab < 0.01 or lcb < 0.01:
		return []
	var lat := clampf((goal - a).length(), 0.02, (lab + lcb) * 0.995)
	var ac := (c - a).normalized()
	var ab := (b - a).normalized()
	var at := (goal - a).normalized()
	var ac_ab_0 := acos(clampf(ac.dot(ab), -1.0, 1.0))
	var ba_bc_0 := acos(clampf((a - b).normalized().dot((c - b).normalized()), -1.0, 1.0))
	var ac_ab_1 := acos(clampf((lcb * lcb - lab * lab - lat * lat) / (-2.0 * lab * lat), -1.0, 1.0))
	var ba_bc_1 := acos(clampf((lat * lat - lab * lab - lcb * lcb) / (-2.0 * lab * lcb), -1.0, 1.0))
	var axis0 := ac.cross(ab)
	if axis0.length() < 0.001:
		axis0 = ac.cross(Vector3.UP)   # a dead straight arm: bend it downward-out
	axis0 = axis0.normalized()
	var r0 := Quaternion(axis0, ac_ab_1 - ac_ab_0)
	var r1 := Quaternion(axis0, ba_bc_1 - ba_bc_0)
	var axis1 := ac.cross(at)
	var r2 := Quaternion.IDENTITY if axis1.length() < 0.0001 else Quaternion(axis1.normalized(), acos(clampf(ac.dot(at), -1.0, 1.0)))
	var up_rot := r2 * r0
	var na := Transform3D(Basis(up_rot) * pa.basis, a)
	var nb_origin := a + up_rot * (b - a)
	var nb := Transform3D(Basis(up_rot * r1) * pb.basis, nb_origin)
	return [na, nb]
