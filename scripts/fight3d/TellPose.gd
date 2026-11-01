extends RefCounted
## S343 TELLS1: when a beat carried `tell`, her pose shows it - rear hand drops after jab, lunge carries body forward,
## guard sinks when she tires. A bone overlay added once per boxer, eases in/out. BeatFire calls apply() when b.has("tell").
## Uses PunchReach.solve() for hand IK (like GuardTuck) so hands actually reach target positions.
const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")

## Timing constants for each tell kind.
const HD_WAIT_S := 0.15; const HD_RISE_S := 0.15; const HD_HOLD_S := 0.50; const HD_FALL_S := 0.35
const LUNGE_RISE_S := 0.20; const LUNGE_HOLD_S := 0.15; const LUNGE_FALL_S := 0.50
## S347: a 16 deg lean added 5 deg over the jab's own lean - nothing to spot on tape.
const LUNGE_LEAN_DEG := 26.0; const LUNGE_KNEE_DEG := 12.0
const TG_RISE_S := 0.25; const TG_HOLD_S := 1.30; const TG_FALL_S := 0.35
const HL_RISE_S := 0.20; const HL_HOLD_S := 1.00; const HL_FALL_S := 0.30
## Hand drop targets (from head bone, in skeleton space, scaled by height).
const HD_DOWN_M := 0.42; const HD_FWD_M := 0.08
## Both-hands-down targets (from head bone).
const BHD_DOWN_M := 0.45; const BHD_FWD_M := 0.12
const BHD_SHOULDER_DEG := 8.0

const KEY := "tell_mod"

static func apply(stage: Node3D, who: int, kind: String, at_s: float) -> void:
	if who < 0 or who >= (stage.boxers as Array).size(): return
	var bx: Dictionary = stage.boxers[who]
	var mod: TellMod = bx.get(KEY)
	if mod == null:
		var skel: Skeleton3D = bx["skel"]
		mod = TellMod.new(); mod.name = "TellPose"
		if mod.setup(skel, bool(bx.get("south", false))):
			skel.add_child(mod)
			skel.move_child(mod, skel.get_child_count() - 1)  # Ensure it runs last
			bx[KEY] = mod
		else: mod.free(); return
	mod.start_tell(kind, at_s)

class TellMod:
	extends SkeletonModifier3D
	var _t := 0.0; var _south := false; var _tells: Array = []
	var _head := -1; var _hips := -1; var _spine := -1; var _chest := -1
	var _neck := -1
	var _l_shoulder := -1; var _r_shoulder := -1
	var _l_upper_leg := -1; var _r_upper_leg := -1
	var _arms := {}; var _rear := "RightHand"; var _lead := "LeftHand"
	var _head_start: Vector3 = Vector3.ZERO

	func setup(skel: Skeleton3D, south: bool) -> bool:
		_south = south
		_head = skel.find_bone("Head"); _hips = skel.find_bone("Hips")
		_spine = skel.find_bone("Spine"); _chest = skel.find_bone("Chest")
		_neck = skel.find_bone("Neck")
		_l_shoulder = skel.find_bone("LeftShoulder"); _r_shoulder = skel.find_bone("RightShoulder")
		_l_upper_leg = skel.find_bone("LeftUpperLeg"); _r_upper_leg = skel.find_bone("RightUpperLeg")
		if _south:
			_rear = "LeftHand"; _lead = "RightHand"
		else:
			_rear = "RightHand"; _lead = "LeftHand"
		for side in ["Left", "Right"]:
			var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
			if ids.has(-1): return false
			_arms[side + "Hand"] = ids
		return _head >= 0 and _hips >= 0 and _chest >= 0

	func start_tell(kind: String, at_s: float) -> void:
		# Start the tell immediately (at_s is for delaying until punch contact, but we apply it now)
		_tells.append({"kind": kind, "start_t": _t, "delay": at_s})

	func _process_modification() -> void:
		var skel := get_skeleton()
		if skel == null: return
		_t += get_process_delta_time()
		var alive: Array = []
		for tell in _tells:
			var delay: float = float(tell.get("delay", 0.0))
			var elapsed: float = _t - float(tell["start_t"]) - delay
			if _apply_tell(skel, str(tell["kind"]), elapsed): alive.append(tell)
		_tells = alive

	func _apply_tell(skel: Skeleton3D, kind: String, elapsed: float) -> bool:
		match kind:
			"hand_drop": return _apply_hand_drop(skel, elapsed)
			"lunge": return _apply_lunge(skel, elapsed)
			"tired_guard": return _apply_both_hands_down(skel, elapsed, TG_RISE_S, TG_HOLD_S, TG_FALL_S)
			"hands_low": return _apply_both_hands_down(skel, elapsed, HL_RISE_S, HL_HOLD_S, HL_FALL_S)
		return false

	static func _weight(elapsed: float, wait: float, rise: float, hold: float, fall: float) -> float:
		if elapsed < wait: return 0.0
		if elapsed < wait + rise:
			var t := clampf((elapsed - wait) / rise, 0.0, 1.0); return t * t * (3.0 - 2.0 * t)
		if elapsed < wait + rise + hold: return 1.0
		if elapsed < wait + rise + hold + fall:
			var t := clampf((elapsed - wait - rise - hold) / fall, 0.0, 1.0); return 1.0 - t * t * (3.0 - 2.0 * t)
		return 0.0

	## Hand drop: rear hand sinks from chin to chest after the jab.
	func _apply_hand_drop(skel: Skeleton3D, elapsed: float) -> bool:
		var w := _weight(elapsed, HD_WAIT_S, HD_RISE_S, HD_HOLD_S, HD_FALL_S)
		if w <= 0.0: return elapsed < HD_WAIT_S + HD_RISE_S + HD_HOLD_S + HD_FALL_S
		var k: float = skel.global_transform.basis.get_scale().x
		var head: Vector3 = skel.get_bone_global_pose(_head).origin
		var fwd := _fwd(skel)
		var left := _left(skel)
		var out := -left if _rear == "RightHand" else left
		# Target: down and slightly forward from the head
		var target: Vector3 = head + Vector3.DOWN * HD_DOWN_M / k + fwd * HD_FWD_M / k + out * 0.05 / k
		_place_hand(skel, _rear, target, w)
		return true

	## Lunge: chest leans forward, front knee bends, hips shift back slightly to keep feet planted.
	func _apply_lunge(skel: Skeleton3D, elapsed: float) -> bool:
		var w := _weight(elapsed, 0.0, LUNGE_RISE_S, LUNGE_HOLD_S, LUNGE_FALL_S)
		if w <= 0.0: return elapsed < LUNGE_RISE_S + LUNGE_HOLD_S + LUNGE_FALL_S
		var k: float = skel.global_transform.basis.get_scale().x
		var fwd := _fwd(skel)
		var up := _up(skel)
		var left := _left(skel)
		# Hips shift back slightly to counter the stage step (keeps feet planted)
		var g_hips: Transform3D = skel.get_bone_global_pose(_hips)
		skel.set_bone_global_pose(_hips, Transform3D(g_hips.basis, g_hips.origin - fwd * 0.15 / k * w))
		# Chest leans forward (rotates about the lateral axis)
		var fold := up.cross(fwd).normalized()
		_rotate(skel, _chest, fold, deg_to_rad(LUNGE_LEAN_DEG) * w)
		_rotate(skel, _spine, fold, deg_to_rad(LUNGE_LEAN_DEG * 0.4) * w)
		# Front knee bends (the leg closer to the opponent)
		var front_leg := _l_upper_leg if fwd.z < 0 else _r_upper_leg
		if front_leg >= 0:
			var knee_axis := left
			_rotate(skel, front_leg, knee_axis, deg_to_rad(LUNGE_KNEE_DEG) * w)
		return true

	## Both hands down: guard sinks to chest, shoulders round.
	func _apply_both_hands_down(skel: Skeleton3D, elapsed: float, rise: float, hold: float, fall: float) -> bool:
		var w := _weight(elapsed, 0.0, rise, hold, fall)
		if w <= 0.0: return elapsed < rise + hold + fall
		var k: float = skel.global_transform.basis.get_scale().x
		var head: Vector3 = skel.get_bone_global_pose(_head).origin
		var fwd := _fwd(skel)
		var left := _left(skel)
		# Place both hands low at the chest
		for hand in ["LeftHand", "RightHand"]:
			if not _arms.has(hand): continue
			var out := left if hand == "LeftHand" else -left
			var target: Vector3 = head + Vector3.DOWN * BHD_DOWN_M / k + fwd * BHD_FWD_M / k + out * 0.12 / k
			_place_hand(skel, hand, target, w)
		# Shoulders round forward
		var up := _up(skel)
		var fold := up.cross(fwd).normalized()
		_rotate(skel, _spine, fold, deg_to_rad(BHD_SHOULDER_DEG) * w * 0.5)
		_rotate(skel, _chest, fold, deg_to_rad(BHD_SHOULDER_DEG) * w * 0.5)
		if _neck >= 0:
			_rotate(skel, _neck, fold, deg_to_rad(BHD_SHOULDER_DEG * 0.6) * w)
		return true

	## Places the wrist on `target` with the stage's two-bone solve (PunchReach.solve, as GuardTuck): the shoulder stays,
	## the elbow keeps its side and drops toward the ribs, the hand keeps its rotation; `w` eases from the clip's wrist.
	## S347: the r1/r2 hand rotation set the forearm back on the OLD elbow, so the hand barely moved (GPU drop 0.05-0.16 m).
	func _place_hand(skel: Skeleton3D, hand: String, target: Vector3, w: float) -> void:
		if not _arms.has(hand): return
		var ids: Array = _arms[hand]
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var el: Vector3 = skel.get_bone_global_pose(int(ids[1])).origin
		var out := _left(skel) if hand == "LeftHand" else -_left(skel)
		var pole := (Vector3.DOWN - out * 0.3).normalized()
		PunchReach.solve(skel, ids, s, g_hd.origin.lerp(target, w), s.distance_to(el), el.distance_to(g_hd.origin), g_hd.basis, pole, w)

	func _fwd(skel: Skeleton3D) -> Vector3:
		var up := _up(skel)
		var left := _left(skel)
		return left.cross(up).normalized()

	func _up(skel: Skeleton3D) -> Vector3:
		var chest: Vector3 = skel.get_bone_global_pose(_chest).origin
		var hips: Vector3 = skel.get_bone_global_pose(_hips).origin
		return (chest - hips).normalized()

	func _left(skel: Skeleton3D) -> Vector3:
		var l_sh: Vector3 = skel.get_bone_global_pose(_l_shoulder).origin
		var r_sh: Vector3 = skel.get_bone_global_pose(_r_shoulder).origin
		return (l_sh - r_sh).normalized()

	func _rotate(skel: Skeleton3D, bone: int, axis: Vector3, angle: float) -> void:
		var g: Transform3D = skel.get_bone_global_pose(bone)
		skel.set_bone_global_pose(bone, Transform3D(Basis(Quaternion(axis, angle)) * g.basis, g.origin))
