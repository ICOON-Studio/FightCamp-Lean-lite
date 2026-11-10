extends SkeletonModifier3D
## BLOCKMEET2: lifts the blocking gloves to face height during a block clip (mc_to_block sits them ~0.10 m low).
## S420 (collect): the lift turns the WHOLE arm about the shoulder (UpperArm rotated so the hand rises); moving only
## the hand bone tore the hand ~0.085 m off the forearm (tests/block_meet_test.gd WRIST bar). The rise is what brings
## each hand to face height (the Head bone + FACE_UP_M, as FightStage.target_point), never above it, at most MAX_RISE_M.

const FACE_UP_M := 0.07    # FightStage.FACE_UP_M
const MAX_RISE_M := 0.18

var ap: AnimationPlayer
var _arms: Array = []   # [[upper_arm_id, hand_id], ...]
var _head := -1


func setup(skel: Skeleton3D, player: AnimationPlayer) -> void:
	ap = player
	_arms.clear()
	_head = skel.find_bone("Head")
	for side in ["Left", "Right"]:
		var up := skel.find_bone(side + "UpperArm")
		var hand := skel.find_bone(side + "Hand")
		if up >= 0 and hand >= 0:
			_arms.append([up, hand])


func _process_modification() -> void:
	if ap == null or _head < 0:
		return
	if not str(ap.assigned_animation).contains("block"):
		return
	var skel := get_skeleton()
	if skel == null:
		return
	var gt: Transform3D = skel.global_transform
	var s: float = gt.basis.get_scale().y
	var face_y: float = (gt * skel.get_bone_global_pose(_head).origin).y + FACE_UP_M * s
	for arm in _arms:
		var up_pose: Transform3D = skel.get_bone_global_pose(arm[0])
		var sh_w: Vector3 = gt * up_pose.origin
		var hand_w: Vector3 = gt * skel.get_bone_global_pose(arm[1]).origin
		var rise: float = clampf(face_y - hand_w.y, 0.0, MAX_RISE_M * s)
		if rise <= 0.001:
			continue
		var a: Vector3 = hand_w - sh_w
		var b: Vector3 = a + Vector3.UP * rise
		if a.length() < 0.05:
			continue
		# The turn in world space, carried into skeleton space.
		var q_w := Quaternion(a.normalized(), b.normalized())
		var gb: Basis = gt.basis.orthonormalized()
		var q_s: Basis = gb.inverse() * Basis(q_w) * gb
		up_pose.basis = q_s * up_pose.basis
		skel.set_bone_global_pose(arm[0], up_pose)
