extends SkeletonModifier3D
## S307 the corner minute's hands and eyes (docs/FIGHT_NIGHT_SCRIPT.md v2 step 5, "the hands meet what they reach"):
## a hand reaches a point (the bottle at her lips, the cutman's fingers on her cheekbone) by analytic two-bone arm IK
## (FootPlant's solver, Holden "Simple Two Joint IK"), and the head turns to look at a point (the coach and his boxer face
## to face; the ActionForge crouch and sit look at the floor). Each eases in and out over EASE_S; the hand keeps the turn
## the clip gave it; the head turns at most MAX_LOOK_DEG, shared down the spine (CHAIN_SHARE).
##   attach(skel, body) -> CornerIK   reach(side, target: Callable | null)   look(target: Callable | null)

const EASE_S := 0.35
const MAX_LOOK_DEG := 65.0
## A look's share per bone from the head down to the chest (MetaHuman: head, neck_02, neck_01, spine_05, spine_04,
## spine_03); a shorter chain uses its first entries, rescaled.
const CHAIN_SHARE := [0.14, 0.12, 0.14, 0.2, 0.2, 0.2]

## S310 (operator on the side shot of the corner: "doesnt look like a natural human"): the ActionForge crouch bends the
## back near flat, so even shared down the chest the look lifted the head out on a stretched, near-level neck. A real
## coach crouches in front of the stool with his trunk up. upright(deg) tips the trunk back from the lower spine by deg
## (eased like the look), BEFORE the look, so the look only has a small turn left for the neck.
var _upright := {"deg": 0.0, "w": 0.0}
var _spine := -1
var _body: Node3D
var _arms := {}            # "Left"/"Right" -> [upper, lower, hand]
var _reach := {}           # side -> {target: Callable, w: float, on: bool}
var _look := {"target": Callable(), "w": 0.0, "on": false}
var _neck := -1
var _head := -1
var _chain: Array = []      # the look's bones, head first, up to the chest
## The head as shown (world), after this modifier ran; INF before the first frame. A bone read from outside gets the clip's
## pose, before the modifiers (S307 trap), and the look moves the head now (S309): the cameras frame this instead.
var head_world := Vector3.INF
var _face_local := Vector3.BACK   # the face's direction in the head bone's own frame
var _fwd_skel := Vector3.BACK     # the body's forward in the skeleton's space (a straight arm's elbow bends behind it)


static func attach(skel: Skeleton3D, body: Node3D) -> Node:
	var ik := new()
	ik.name = "CornerIK"
	ik._body = body
	if not ik._setup(skel):
		ik.free()
		return null
	skel.add_child(ik)
	# Before the twist bones read the arms (MetaHumanTwist follows the forearm this pose gives).
	var twist := skel.get_node_or_null("MetaHumanTwist")
	if twist != null:
		skel.move_child(ik, twist.get_index())
	return ik


func _setup(skel: Skeleton3D) -> bool:
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side] = ids
		_reach[side] = {"target": Callable(), "w": 0.0, "on": false}
	_neck = skel.find_bone("Neck")
	_head = skel.find_bone("Head")
	if _neck < 0 or _head < 0:
		return false
	_spine = skel.find_bone("Spine")
	var chest := skel.find_bone("Chest")
	var b := _head
	while b >= 0 and _chain.size() < CHAIN_SHARE.size():
		_chain.append(b)
		if b == chest:
			break
		b = skel.get_bone_parent(b)
	# In the rest pose the body faces +Z of its own frame; read that direction in the head bone's frame.
	var fwd_skel := (skel.global_transform.basis.inverse() * _body.global_transform.basis * Vector3.BACK).normalized()
	_fwd_skel = fwd_skel
	_face_local = (skel.get_bone_global_rest(_head).basis.inverse() * fwd_skel).normalized()
	return true


## `target` returns the world point the hand goes to; null lets the arm go back to its clip.
func reach(side: String, target: Variant) -> void:
	var r: Dictionary = _reach[side]
	r["on"] = target != null
	if target != null:
		r["target"] = target


## Tips the trunk back `deg` from the lower spine (0 lets the clip's back return). S341: a negative `deg` leans it
## forward (the clinch's A-frame: chests in, hips back) - set after the clip, so the animation cannot undo it.
func upright(deg: float) -> void:
	if deg != 0.0:
		_upright["deg"] = deg
	_upright["on"] = deg != 0.0


func look(target: Variant) -> void:
	_look["on"] = target != null
	if target != null:
		_look["target"] = target


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	var delta := maxf(get_process_delta_time(), 1e-4)
	var to_skel := skel.global_transform.affine_inverse()
	# S310: the trunk up out of the crouch first, then the look, then the hands.
	_upright["w"] = move_toward(float(_upright["w"]), 1.0 if bool(_upright.get("on", false)) else 0.0, delta / EASE_S)
	if float(_upright["w"]) > 0.0 and _spine >= 0:
		var g := skel.get_bone_global_pose(_spine)
		var axis := _fwd_skel.cross(Vector3.UP).normalized()
		var q := Quaternion(axis, deg_to_rad(float(_upright["deg"])) * _smooth(float(_upright["w"])))
		var par := skel.get_bone_parent(_spine)
		var pq := skel.get_bone_global_pose(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
		skel.set_bone_pose_rotation(_spine, (pq.inverse() * (q * g.basis.get_rotation_quaternion())).normalized())
	# The look first: it turns the chest (S309), and the hands then still meet what they reach.
	_look["w"] = move_toward(float(_look["w"]), 1.0 if bool(_look["on"]) else 0.0, delta / EASE_S)
	if float(_look["w"]) > 0.0 and (_look["target"] as Callable).is_valid():
		_turn_head(skel, to_skel * ((_look["target"] as Callable).call() as Vector3), _smooth(float(_look["w"])))
	for side in _arms:
		var r: Dictionary = _reach[side]
		r["w"] = move_toward(float(r["w"]), 1.0 if bool(r["on"]) else 0.0, delta / EASE_S)
		if float(r["w"]) > 0.0 and (r["target"] as Callable).is_valid():
			var ids: Array = _arms[side]
			var anim := skel.get_bone_global_pose(ids[2]).origin
			var want: Vector3 = to_skel * ((r["target"] as Callable).call() as Vector3)
			_solve(skel, ids, anim.lerp(want, _smooth(float(r["w"]))))
	head_world = skel.global_transform * skel.get_bone_global_pose(_head).origin


static func _smooth(u: float) -> float:
	return u * u * (3.0 - 2.0 * u)


## Turns the spine, neck and head (skeleton space) so the face points at `t`, by at most MAX_LOOK_DEG, `w` of the way.
## S309 (operator on the corner still: "his neck looks wierd"): the crouching coach looked up at her with the neck and head
## alone (40/60) out of a back bent to the floor, so the head jutted out of hunched shoulders. The turn is now shared down
## the chain from the head to the chest (CHAIN_SHARE, head first): the back lifts and no joint takes more than a quarter.
func _turn_head(skel: Skeleton3D, t: Vector3, w: float) -> void:
	var gh := skel.get_bone_global_pose(_head)
	var face := (gh.basis.orthonormalized() * _face_local).normalized()
	var want := (t - gh.origin).normalized()
	var angle := face.angle_to(want)
	if angle < 0.01:
		return
	var axis := face.cross(want)
	if axis.length() < 1e-6:
		return
	axis = axis.normalized()
	var turn := minf(angle, deg_to_rad(MAX_LOOK_DEG)) * w
	var share_sum := 0.0
	for i in _chain.size():
		share_sum += float(CHAIN_SHARE[i])
	# Old global turns first (setting a bone moves its children's globals), then each bone from the chest up.
	var old: Array = _chain.map(func(b): return skel.get_bone_global_pose(b).basis.get_rotation_quaternion())
	var parent := skel.get_bone_parent(_chain[-1])
	var parent_new := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	var acc := Quaternion.IDENTITY
	for i in range(_chain.size() - 1, -1, -1):
		acc = Quaternion(axis, turn * float(CHAIN_SHARE[i]) / share_sum) * acc
		var g1: Quaternion = acc * (old[i] as Quaternion)
		skel.set_bone_pose_rotation(_chain[i], (parent_new.inverse() * g1).normalized())
		parent_new = g1


## Two-bone IK in the skeleton's space (FootPlant._solve): the elbow bends in the plane it bends in now.
func _solve(skel: Skeleton3D, ids: Array, t: Vector3) -> void:
	var ga := skel.get_bone_global_pose(ids[0])
	var gb := skel.get_bone_global_pose(ids[1])
	var gc := skel.get_bone_global_pose(ids[2])
	var a := ga.origin
	var b := gb.origin
	var c := gc.origin
	var lab := (b - a).length()
	var lcb := (c - b).length()
	if lab < 1e-5 or lcb < 1e-5 or (c - a).length() < 1e-5 or (t - a).length() < 1e-5:
		return
	var lat := clampf((t - a).length(), absf(lab - lcb) + 1e-4, lab + lcb - 1e-4)
	var ac_ab_0 := acos(clampf((c - a).normalized().dot((b - a).normalized()), -1.0, 1.0))
	var ba_bc_0 := acos(clampf((a - b).normalized().dot((c - b).normalized()), -1.0, 1.0))
	var ac_at_0 := acos(clampf((c - a).normalized().dot((t - a).normalized()), -1.0, 1.0))
	var ac_ab_1 := acos(clampf((lcb * lcb - lab * lab - lat * lat) / (-2.0 * lab * lat), -1.0, 1.0))
	var ba_bc_1 := acos(clampf((lat * lat - lab * lab - lcb * lcb) / (-2.0 * lab * lcb), -1.0, 1.0))
	var axis0 := (c - a).cross(b - a)
	if axis0.length() < 1e-4:
		# A hanging arm is dead straight: bend it as an arm bends, the elbow back and down.
		ac_ab_0 = 0.0
		ba_bc_0 = PI
		axis0 = (c - a).cross(-_fwd_skel * 0.8 + Vector3.DOWN * 0.2)
		if axis0.length() < 1e-6:
			return
	axis0 = axis0.normalized()
	var r0 := Quaternion(axis0, ac_ab_1 - ac_ab_0)
	var r1 := Quaternion(axis0, ba_bc_1 - ba_bc_0)
	var axis1 := (c - a).cross(t - a)
	var r2 := Quaternion(axis1.normalized(), ac_at_0) if axis1.length() > 1e-6 else Quaternion.IDENTITY
	var qa := ga.basis.get_rotation_quaternion()
	var qb := gb.basis.get_rotation_quaternion()
	var qc := gc.basis.get_rotation_quaternion()
	var qa1 := r2 * r0 * qa
	var qb1 := r2 * r1 * r0 * qb
	var parent := skel.get_bone_parent(ids[0])
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(ids[0], (qp.inverse() * qa1).normalized())
	skel.set_bone_pose_rotation(ids[1], (qa1.inverse() * qb1).normalized())
	skel.set_bone_pose_rotation(ids[2], (qb1.inverse() * qc).normalized())
