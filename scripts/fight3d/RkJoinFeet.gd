extends SkeletonModifier3D
## S399 ROKOKO2 - feet planted THROUGH a join (operator S399: "what matters is the sequence blending"; tools/rokoko_seq.gd:
## 13.7 of the 30-s sequence's 15 m of planted-foot slide happened inside the 0.3-0.45 s joins, where the join smoother
## blends one stance into another and drags both feet along the canvas).
## Armed at a join into a captured clip (RkJoin.align: her toe balls' world spots before the new clip started). For the
## join, the ANCHOR foot (the lower one) stays on its spot; the other foot holds for the first half, then STEPS to where the
## new clip puts it - a small lift (STEP_LIFT_M at mid-step), not a slide. Each leg is a two-bone solve (hip -> knee ->
## ankle) toward the ankle that puts the ball on its spot, the knee kept in its own bend plane, the foot keeping its turn.
## The weight eases off over the join's last RELEASE_S, by which time the new clip's own feet stand where the pins held
## them (RkJoin laid them there). Runs right after JoinSmoother; RkPure keeps it on (it only acts during a join).

const JOIN_S := 0.75   # longer than the blend: the knees change slowly enough not to snap (6 deg/frame^2)
const RELEASE_S := 0.35
const GRIP_S := 0.15   # the pins ease in (full at once snapped the knees on the join's 2nd-3rd frame: 11-22 snaps)
const STEP_LIFT_M := 0.05
const STEP_S := Vector2(0.12, 0.55)   # the free foot's step inside the join (a quick one jerked the knee: 15-23 snaps)
const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"], ["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]]

var _ids: Array = []
var _pins: Array = []        # world ball spots [L, R]
var _anchor := 0
var _t := -1.0
var _rel := -1.0             # a release under way (s): the pins let go over LET_GO_S, never in one frame
const LET_GO_S := 0.0   # immediate: the join smoother blends from the legs as shown (_sync), so nothing jumps
var ap: AnimationPlayer = null   # a step clip playing (RkLoco) releases the pins: its own steps lift the feet
var js: Node = null          # the boxer's JoinSmoother: the pins start when its blend has (it captures 1-2 frames late)


func setup(skel: Skeleton3D) -> bool:
	for leg in LEGS:
		var ids: Array = []
		for n in leg:
			ids.append(skel.find_bone(str(n)))
		if ids.has(-1):
			return false
		_ids.append(ids)
	return true


## A join starts: hold her balls at `pins` (world), the lower one longest.
func arm(pins: Array) -> void:
	if pins.size() != 2 or OS.get_cmdline_user_args().has("nojoinfeet"):   # `-- nojoinfeet` = the control arm
		return
	_pins = pins
	_anchor = 0 if (pins[0] as Vector3).y <= (pins[1] as Vector3).y else 1
	_t = 0.0
	_rel = -1.0


func release() -> void:
	if _t >= 0.0 and _rel < 0.0:
		_rel = 0.0


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _t < 0.0:
		return
	if ap != null and str(ap.current_animation).begins_with("rk_loc_"):
		release()
	if _rel >= 0.0:
		_rel += get_process_delta_time()
		if _rel >= LET_GO_S:
			_t = -1.0
			_rel = -1.0
			return
	if js != null and bool(js.get("_pending")):
		return   # S399: pinning the raw new clip before the blend starts snapped the knees (11-22 leg snaps a join)
	_t += get_process_delta_time()
	if _t >= JOIN_S:
		_t = -1.0
		return
	var inv := skel.global_transform.affine_inverse()
	var fade := clampf((JOIN_S - _t) / RELEASE_S, 0.0, 1.0) * clampf(_t / GRIP_S, 0.0, 1.0)
	fade = fade * fade * (3.0 - 2.0 * fade)
	if _rel >= 0.0:
		var r := 1.0 - _rel / LET_GO_S
		fade *= r * r * (3.0 - 2.0 * r)
	for i in 2:
		var ids: Array = _ids[i]
		var ball := skel.get_bone_global_pose(ids[3]).origin
		var pin: Vector3 = inv * (_pins[i] as Vector3)
		var w := fade
		var lift := 0.0
		if i != _anchor and OS.get_cmdline_user_args().has("jfanchor"):
			continue
		if i != _anchor:
			# the free foot: held for the first half, then a step onto the clip's own spot (its pin eases there)
			var u := clampf((_t - STEP_S.x) / (STEP_S.y - STEP_S.x), 0.0, 1.0)
			u = u * u * (3.0 - 2.0 * u)
			pin = pin.lerp(ball, u)
			lift = sin(PI * u) * STEP_LIFT_M * (1.0 if u > 0.0 and u < 1.0 else 0.0)
			w = fade if u >= 1.0 or _t < GRIP_S or _rel >= 0.0 else 1.0
		var goal := pin + Vector3(0.0, lift, 0.0)
		var err := goal - ball
		if OS.get_cmdline_user_args().has("jfdebug") and _t < 0.2:
			print("JFDBG t=%.3f leg=%d anchor=%s err=%.3f w=%.2f" % [_t, i, i == _anchor, err.length(), w])
		if err.length() < 0.002 or w <= 0.0:
			continue
		_reach(skel, ids, skel.get_bone_global_pose(ids[2]).origin + err * w)
		_sync(skel, ids)


## Two-bone solve: hip ids[0], knee ids[1], ankle ids[2] reaches `target` (skeleton space); the foot keeps its global turn.
func _reach(skel: Skeleton3D, ids: Array, target: Vector3) -> void:
	var hg := skel.get_bone_global_pose(ids[0])
	var kg := skel.get_bone_global_pose(ids[1])
	var ag := skel.get_bone_global_pose(ids[2])
	var h := hg.origin
	var k := kg.origin
	var a := ag.origin
	var l1 := (k - h).length()
	var l2 := (a - k).length()
	var to := target - h
	var d := clampf(to.length(), absf(l1 - l2) + 1e-3, l1 + l2 - 1e-3)
	var dir := to.normalized()
	var n := (k - h).cross(a - h)
	if n.length() < 1e-5:
		return
	n = n.normalized()
	var perp := n.cross(dir).normalized()
	if (k - h).dot(perp) < 0.0:
		perp = -perp
	var ca := clampf((l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d), -1.0, 1.0)
	var k2 := h + (dir * ca + perp * sqrt(1.0 - ca * ca)) * l1
	var t2 := h + dir * d
	var foot_basis := ag.basis
	# thigh: turn (k - h) onto (k2 - h)
	var hq := Quaternion((k - h).normalized(), (k2 - h).normalized())
	var hg2 := Transform3D(Basis(hq) * hg.basis, h)
	_set_global(skel, ids[0], hg2)
	# calf: its new global, then turn (a - k) carried by the thigh onto (t2 - k2)
	var kg2 := hg2 * (hg.affine_inverse() * kg)
	var a_now := kg2 * (kg.affine_inverse() * ag).origin
	var kq := Quaternion((a_now - kg2.origin).normalized(), (t2 - k2).normalized())
	var kg3 := Transform3D(Basis(kq) * kg2.basis, kg2.origin)
	_set_global(skel, ids[1], kg3)
	_set_global(skel, ids[2], Transform3D(foot_basis, kg3 * (kg.affine_inverse() * ag).origin))


## The join smoother remembers each frame's pose as its own output (before this layer): give it the legs as SHOWN, so
## the next join's dead blend starts from them (a release, or a step clip's join, otherwise jumped back in one frame).
func _sync(skel: Skeleton3D, ids: Array) -> void:
	if js == null:
		return
	var bones: PackedInt32Array = js.get("_bones")
	var shown: Array = js.get("_shown")
	if shown.size() != bones.size():
		return
	for b in ids:
		var k := bones.find(int(b))
		if k >= 0:
			shown[k] = skel.get_bone_pose_rotation(int(b))


static func _set_global(skel: Skeleton3D, b: int, g: Transform3D) -> void:
	var p := skel.get_bone_parent(b)
	var pg: Transform3D = skel.get_bone_global_pose(p) if p >= 0 else Transform3D.IDENTITY
	var local := pg.affine_inverse() * g
	skel.set_bone_pose_rotation(b, local.basis.get_rotation_quaternion())
