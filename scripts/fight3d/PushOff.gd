extends RefCounted
## S369/S371/S372 NOREF1: there is no referee in the ring. When a clinch breaks, both boxers place their hands on the
## outside of the opponent's upper chest/shoulders and slowly push each other off to fighting range before returning
## their hands to guard.

const PUSH_S := 0.85
const HANDS_END := 0.38
const PUSH_END := 0.76
## Gloves sit on the torso shell (probe TORSO_R 0.15 + HAND_R 0.05): targets stay outside so forearms never pierce.
const CHEST_FWD_M := 0.32
const CHEST_OUT_M := 0.16

static var _t := -1.0
static var _tie_gap := 0.68
static var _range_gap := 1.0
static var _mid := Vector3.ZERO
static var _axis := Vector3.BACK
static var gap := 0.68


static func active() -> bool:
	return _t >= 0.0


static func cancel(stage: Node) -> void:
	if _t < 0.0:
		return
	_t = -1.0
	if stage != null:
		_clear_hands(stage)


static func begin(stage: Node) -> void:
	_t = 0.0
	var p0: Vector3 = stage.boxers[0]["pos"]
	var p1: Vector3 = stage.boxers[1]["pos"]
	_tie_gap = p0.distance_to(p1)
	_range_gap = maxf(float(stage.gap_m), maxf(_tie_gap + 0.22, 0.92))
	gap = _tie_gap
	_mid = (p0 + p1) * 0.5
	var d := p1 - p0
	_axis = d.normalized() if d.length() > 0.01 else Vector3.BACK
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik != null:
			ik.look(null)
			ik.upright(0.0)
			ik.reach("Left", null)
			ik.reach("Right", null)
		var ap: AnimationPlayer = stage.boxers[i]["ap"]
		if ap.has_animation("pro_block_loop"):
			ap.play("pro_block_loop")
			ap.speed_scale = 0.85
			ap.seek(0.15 * ap.get_animation("pro_block_loop").length, true)
		else:
			stage.guard(i)
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik == null:
			continue
		var other := 1 - i
		ik.reach_now("Left", _chest.bind(stage, i, other, "Left"))
		ik.reach_now("Right", _chest.bind(stage, i, other, "Right"))


static func step(stage: Node, delta: float) -> void:
	if _t < 0.0:
		return
	var prev := _t
	_t += delta
	if prev < HANDS_END and _t >= HANDS_END:
		_clear_hands(stage)
	if _t <= PUSH_END:
		var u := clampf(_t / PUSH_END, 0.0, 1.0)
		var e := u * u * (3.0 - 2.0 * u)
		gap = lerpf(_tie_gap, _range_gap, e)
		var half := _axis * (gap * 0.5)
		var half_ring: float = float(stage.RING_M) * 0.5 - 0.38
		var p0 := _mid - half
		var p1 := _mid + half
		var shift := Vector3.ZERO
		for coord in ["x", "z"]:
			var v0 := float(p0[coord])
			var v1 := float(p1[coord])
			if minf(v0, v1) < -half_ring:
				shift[coord] = -half_ring - minf(v0, v1)
			elif maxf(v0, v1) > half_ring:
				shift[coord] = half_ring - maxf(v0, v1)
		stage.boxers[0]["pos"] = p0 + shift
		stage.boxers[1]["pos"] = p1 + shift
	if _t >= PUSH_S:
		_clear_hands(stage)
		for i in 2:
			stage.guard(i)
		_t = -1.0


static func _clear_hands(stage: Node) -> void:
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik != null:
			ik.reach("Left", null)
			ik.reach("Right", null)


static func _chest(stage: Node, me: int, other: int, side: String) -> Vector3:
	var hips := _bone(stage, other, "Hips")
	var chest := _bone(stage, other, "UpperChest")
	var spine := hips.lerp(chest, 0.68)
	var to_me := (stage.boxers[me]["pos"] as Vector3) - (stage.boxers[other]["pos"] as Vector3)
	to_me = Vector3(to_me.x, 0.0, to_me.z).normalized()
	if to_me.length() < 0.01:
		to_me = (stage.boxers[other]["node"] as Node3D).global_transform.basis.z.normalized()
	var me_left := -Vector3.UP.cross(to_me).normalized()
	var out := me_left * (1.0 if side == "Left" else -1.0)
	return spine + to_me * CHEST_FWD_M + out * CHEST_OUT_M


static func _bone(stage: Node, i: int, bone: String) -> Vector3:
	var skel: Skeleton3D = stage.boxers[i]["skel"]
	var id := skel.find_bone(bone)
	return skel.global_transform * skel.get_bone_global_pose(id).origin if id >= 0 else (stage.boxers[i]["node"] as Node3D).global_position
