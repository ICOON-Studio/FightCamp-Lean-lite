extends SkeletonModifier3D
## S302 (operator on the S301 film: "the guard looks fake"). tools/punch_reach.gd measured the Pro guard (pro_idle) on our
## bodies: the wrists hang 0.22 m in front of the face, the gloves out at arm's length (John J-GUARDPACE1: gloves ~0.10-0.20 m
## in front of the face, chin tucked, small hand pumps). While she stands in her guard, each wrist is drawn back toward
## her face by TUCK_M (never closer than MIN_FRONT_M) and pumps a little (lead more than rear), the arm re-solved as a
## two-bone chain, the hand keeping its rotation. Eases in and out (EASE_S) so leaving the guard for a punch never pops.
## Runs after JoinSmoother, before PunchReach.
## S313 real-fight gap 5 (Game Godot/research/S310_REAL_FIGHT_GAPS.md "Guard at range"): out of range the real
## guard drops - wrists ~0.18-0.21 (lead) / ~0.11-0.13 (rear) arm units below the shoulder line, gloves chin-to-chest
## and forward; ours sat at eye level everywhere. `low` (0..1, Footwork sets it from the range phase: 1 at rest) lowers
## each wrist by LOW_M and carries it FWD_M forward, and lets the tuck go; it comes back up fast for the entry lunge
## (RangeBreath's "in" starts 0.38 s before the punch) and drops slowly once they are back out.
## S315 inside range (John J_INSIDE2, coaching sources): up close the elbows are glued to the ribs ("if you can see
## daylight between your elbow and your ribs, the punch is too wide") and the gloves sit at the cheeks/temples. `inner`
## (0..1, FightStage sets it from Footwork.inside_w) draws each wrist to a point by the cheek on its own side and turns
## the elbow's bend down and in (ElbowClear then keeps it just outside the ribs).
##   setup(skel, ap, body, guard_clips, seed)   low   inner

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

const LOW_M := {"lead": 0.26, "rear": 0.16}
const LOW_FWD_M := 0.06
const LOW_UP_S := 0.15
const LOW_DOWN_S := 0.6

var low := 0.0        # wanted: 1 = the long-range guard (set every frame by Footwork.aim)
var inner := 0.0      # 1 = the inside guard (set every frame by FightStage from Footwork.inside_w)
## The inside guard's wrist, from the head bone: forward, out to her own side, up (metres).
const IN_FWD_M := 0.13
const IN_SIDE_M := 0.10
const IN_UP_M := -0.03
## The elbow's bend: down and this much in toward her ribs (ElbowClear stops it at the ribs).
const IN_ELBOW_IN := 0.8
var _low := 0.0
var ap: AnimationPlayer
var body: Node3D
var guards: Array = []
var lead := "LeftHand"   # her lead hand pumps more (a southpaw's is the right)
var _arms := {}
var _head := -1
var _w := 0.0
var _t := 0.0
var _phase := 0.0
var _sh := [-1, -1]


func setup(skel: Skeleton3D, player: AnimationPlayer, body_node: Node3D, guard_clips: Array, seed: int) -> bool:
	ap = player
	body = body_node
	guards = guard_clips
	_phase = float(seed % 97) * 0.37
	_head = skel.find_bone("Head")
	_sh = [skel.find_bone("LeftUpperArm"), skel.find_bone("RightUpperArm")]
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
	_low = move_toward(_low, low, dt / (LOW_UP_S if low < _low else LOW_DOWN_S))
	var lw := _low * _low * (3.0 - 2.0 * _low)
	var e := _w * _w * (3.0 - 2.0 * _w)
	var fwd := (skel.global_transform.basis.inverse() * body.global_transform.basis.z)
	fwd.y = 0.0
	fwd = fwd.normalized()
	var head: Vector3 = skel.get_bone_global_pose(_head).origin
	var face := head + fwd * FACE_FWD_M + Vector3.UP * FACE_UP_M
	var iw := inner * inner * (3.0 - 2.0 * inner) * e
	var left := skel.get_bone_global_pose(int(_sh[0])).origin - skel.get_bone_global_pose(int(_sh[1])).origin
	left.y = 0.0
	left = left.normalized() if left.length() > 1e-4 else fwd.cross(Vector3.UP)
	for hand in _arms:
		var ids: Array = _arms[hand]
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var front := (g_hd.origin - face).dot(fwd)
		var back := clampf(front - MIN_FRONT_M, 0.0, TUCK_M) * (1.0 - lw)
		var pump := float(PUMP_M["lead" if hand == lead else "rear"]) * sin(TAU * PUMP_HZ * _t + _phase + (0.0 if hand == "LeftHand" else 2.1))
		var move := (-back + pump + LOW_FWD_M * lw) * e
		var drop := float(LOW_M["lead" if hand == lead else "rear"]) * lw * e
		if absf(move) < 1e-4 and drop < 1e-4 and iw <= 0.0:
			continue
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
		var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
		var to := g_hd.origin + fwd * move - Vector3.UP * drop
		var out := left if hand == "LeftHand" else -left
		if iw > 0.0:
			to = to.lerp(head + fwd * IN_FWD_M + out * IN_SIDE_M + Vector3.UP * IN_UP_M, iw)
		PunchReach.solve(skel, ids, s, to, l1, l2, g_hd.basis, (Vector3.DOWN - out * IN_ELBOW_IN).normalized(), iw)
