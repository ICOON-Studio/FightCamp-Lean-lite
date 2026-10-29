extends SkeletonModifier3D
## S302 (operator on the S301 film: "the guard looks fake"). tools/punch_reach.gd measured the Pro guard (pro_idle) on our
## bodies: the wrists hang 0.22 m in front of the face, the gloves out at arm's length (John J-GUARDPACE1: gloves ~0.10-0.20 m
## in front of the face, chin tucked, small hand pumps). While she stands in her guard, each wrist is drawn back toward
## her face by TUCK_M (never closer than MIN_FRONT_M) and pumps a little (lead more than rear), the arm re-solved as a
## two-bone chain, the hand keeping its rotation. Eases in and out (EASE_S) so leaving the guard for a punch never pops.
## Runs after JoinSmoother, before PunchReach.
##   setup(skel, ap, body, guard_clips, seed)

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")

const TUCK_M := 0.10
const MIN_FRONT_M := 0.10
const EASE_S := 0.15
## Hand pumps: metres along her forward axis, cycles a second.
const PUMP_M := {"lead": 0.035, "rear": 0.015}
const PUMP_HZ := 1.3
## The face, from the head bone (FightStage.FACE_FWD_M / FACE_UP_M).
const FACE_FWD_M := 0.09
const FACE_UP_M := 0.07

var ap: AnimationPlayer
var body: Node3D
var guards: Array = []
var lead := "LeftHand"   # her lead hand pumps more (a southpaw's is the right)
var _arms := {}
var _head := -1
var _w := 0.0
var _t := 0.0
var _phase := 0.0


func setup(skel: Skeleton3D, player: AnimationPlayer, body_node: Node3D, guard_clips: Array, seed: int) -> bool:
	ap = player
	body = body_node
	guards = guard_clips
	_phase = float(seed % 97) * 0.37
	_head = skel.find_bone("Head")
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side + "Hand"] = ids
	return _head >= 0


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or ap == null:
		return
	var dt := get_process_delta_time()
	_t += dt
	var want := 1.0 if guards.has(str(ap.assigned_animation)) else 0.0
	_w = move_toward(_w, want, dt / EASE_S)
	if _w <= 0.0:
		return
	var e := _w * _w * (3.0 - 2.0 * _w)
	var fwd := (skel.global_transform.basis.inverse() * body.global_transform.basis.z)
	fwd.y = 0.0
	fwd = fwd.normalized()
	var head: Vector3 = skel.get_bone_global_pose(_head).origin
	var face := head + fwd * FACE_FWD_M + Vector3.UP * FACE_UP_M
	for hand in _arms:
		var ids: Array = _arms[hand]
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var front := (g_hd.origin - face).dot(fwd)
		var back := clampf(front - MIN_FRONT_M, 0.0, TUCK_M)
		var pump := float(PUMP_M["lead" if hand == lead else "rear"]) * sin(TAU * PUMP_HZ * _t + _phase + (0.0 if hand == "LeftHand" else 2.1))
		var move := (-back + pump) * e
		if absf(move) < 1e-4:
			continue
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
		var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
		PunchReach.solve(skel, ids, s, g_hd.origin + fwd * move, l1, l2, g_hd.basis)
