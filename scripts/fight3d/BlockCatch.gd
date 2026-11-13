extends SkeletonModifier3D
## BLOCKLOOK2: a block is the guard that catches the punch. The blocker plays no clip of her own - she stays in her guard
## (no clip change, so no lean and no head drop) and this modifier turns ONE arm, UpperArm then LowerArm (never the hand
## alone: the wrist stays on the forearm), so the glove meets the punch on its line in front of her face at contact time:
## the REAR glove for a jab or lead hook, the LEAD glove for a cross or rear hook (the glove on the side the punch arrives).
## The other glove stays in its guard. The catch point sits in front of the face, a little to the catching side, at cheek
## height - never above the head bone. It rises over RISE_S before contact (MoveStudio.BLOCK_SET_S at the block rate), holds
## through the contact and eases out over EASE_OUT_S. FightStage.arm_block carries the punching glove onto it.
## Timing follows the punch's own clip while it plays (so a seek or a slowed clip stays in step); before the punch starts it
## counts down the real seconds to contact. A punch refused or cut off (`alive` false) lets the glove go back.

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const RISE_S := 0.25          # MoveStudio.BLOCK_SET_S: the rise starts this long before contact ...
const SET_EARLY_S := 0.06     # ... and the glove is set (weight full) this long before it: a few frames early, never late
const HOLD_S := 0.08          # held after contact
const EASE_OUT_S := 0.25      # back into the guard
const RELEASE_S := 0.12       # let go of a punch that never arrives
const MAX_RATE := 12.0        # weight change per second at most (a late arm does not snap)
const STRAIGHT := Vector2(0.11, 0.05)   # forward, out to the catching side - metres from the face point
const HOOK := Vector2(0.08, 0.09)       # a hook comes from the side: the glove sits wider, by the temple
const BELOW_FACE_M := 0.045   # cheek height: under the face point ...
const LOW_M := 0.06           # ... the lowest it goes to meet a low hook (the bar: -0.08; GloveClear lifts the face after this reads it - block_meet read the glove up to 0.025 lower)
const MEET_M := 0.06          # the glove's centre sits this far behind the punching glove's front (touching it)
const MEET_NEAR := Vector2(0.10, 0.30)  # the punch is this near the catch point: the glove goes to meet it on its line
const OVER_HEAD_MAX_M := 0.022  # ... and never more than this above the head bone (the bar: 0.03)

var stage: Node3D
var me := -1
var w := 0.0                  # the catch weight now (0: her guard untouched)
var _hold := Vector3.INF      # the OTHER glove's place in her chest's frame when the catch began (it stays in her guard)
var _arm := ["", "", ""]      # [upper, lower, hand] bone names of the catching arm
var _phand := ""              # the punching hand (the puncher's bone name)
var _clip := ""
var _hook := false
var _contact := 0.0
var _speed := 1.0
var _left := -1.0             # real seconds to contact while the punch has not started
var _seen := false
var _after := -1.0            # seconds since contact (-1: before)
var _alive := Callable()
var _release := false


## The blocker's catch (made once, last on her modifier stack, so what it sets is what is drawn).
static func on(stg: Node3D, blocker: int) -> Node:
	var c: Node = stg.boxers[blocker].get("block_catch")
	if c == null:
		var skel: Skeleton3D = stg.boxers[blocker]["skel"]
		c = load("res://scripts/fight3d/BlockCatch.gd").new()
		c.stage = stg
		c.me = blocker
		skel.add_child(c)
		stg.boxers[blocker]["block_catch"] = c
	return c


## `puncher` throws `clip` (`move`), its contact `contact_s` into the clip at `speed`, `contact_in` real seconds from now.
static func block(stg: Node3D, puncher: int, clip: String, move: String, contact_s: float, speed: float, contact_in: float, alive: Callable = Callable()) -> Node:
	var c: Node = on(stg, 1 - puncher)
	c.arm(clip, move, contact_s, speed, contact_in, alive)
	return c


func arm(clip: String, move: String, contact_s: float, speed: float, contact_in: float, alive: Callable) -> void:
	var puncher := 1 - me
	var row := BeatClips.contact_row(clip)
	var orth := str(row.get("hand", "LeftHand" if clip.contains("left_") or clip.contains("jab") else "RightHand"))
	var punch_hand: String = stage.hand_of(puncher, orth)
	# The punch from her left hand arrives on the blocker's right side: that glove catches it.
	var side := "Right" if punch_hand == "LeftHand" else "Left"
	_phand = punch_hand
	_arm = [side + "UpperArm", side + "LowerArm", side + "Hand"]
	_clip = clip
	_hook = move.contains("hook") or clip.contains("hook")
	_contact = contact_s
	_speed = maxf(0.05, speed)
	_left = contact_in
	_seen = false
	_after = -1.0
	_alive = alive
	_release = false


## The catching glove's hand bone ("LeftHand" / "RightHand"; "" before the first arm). FightStage.arm_block carries the
## punch onto this glove while the catch has weight.
func catch_hand() -> String:
	return str(_arm[2])


func _ttc(dt: float) -> float:
	var ap: AnimationPlayer = stage.boxers[1 - me]["ap"]
	if str(ap.current_animation) == _clip and _clip != "":
		_seen = true
		return (_contact - ap.current_animation_position) / _speed
	_left -= dt
	if _seen and _after < 0.0 and _left > 0.05:
		_release = true   # the punch stopped before it arrived
	return _left


func _target_w(dt: float) -> float:
	if _clip == "" or _release:
		return 0.0
	if _alive.is_valid() and not bool(_alive.call()):
		_release = true
		return 0.0
	var ap: AnimationPlayer = stage.boxers[me]["ap"]
	var reach: Node = stage.boxers[me].get("reach")
	if (reach != null and str(reach.get("_clip")) != "") or str(ap.current_animation).contains("hit"):
		_release = true   # she punches back or is hit: the guard is hers again
		return 0.0
	if _after >= 0.0:
		_after += dt
	else:
		var ttc := _ttc(dt)
		if ttc > 0.0:
			return 1.0 - smoothstep(SET_EARLY_S, RISE_S, ttc)
		_after = 0.0
	# Held for HOLD_S after contact on both clocks: real time, and the punch's own clip while it still plays (a slowed or
	# stepped punch is still on the glove).
	var a := _after
	var pap: AnimationPlayer = stage.boxers[1 - me]["ap"]
	if str(pap.current_animation) == _clip:
		a = minf(a, maxf(0.0, (pap.current_animation_position - _contact) / _speed))
	if a <= HOLD_S:
		return 1.0
	var o := (a - HOLD_S) / EASE_OUT_S
	if o >= 1.0:
		_clip = ""
		return 0.0
	return 1.0 - smoothstep(0.0, 1.0, o)


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or stage == null or me < 0:
		return
	var dt := get_process_delta_time()
	var want := _target_w(dt)
	var rate := MAX_RATE if want >= w else 1.0 / (RELEASE_S if _release else 0.05)
	w = move_toward(w, want, rate * maxf(dt, 1.0 / 240.0))
	if w <= 0.0001:
		w = 0.0
		_hold = Vector3.INF
		return
	var up := skel.find_bone(_arm[0])
	var lo := skel.find_bone(_arm[1])
	var hd := skel.find_bone(_arm[2])
	var head := skel.find_bone("Head")
	if up < 0 or lo < 0 or hd < 0 or head < 0:
		return
	var xf := skel.global_transform
	var face: Vector3 = stage.target_point(me, false)
	var head_w := xf * skel.get_bone_global_pose(head).origin
	var fwd: Vector3 = (stage.boxers[me]["node"] as Node3D).global_transform.basis.z
	fwd = Vector3(fwd.x, 0.0, fwd.z).normalized()
	var sh := xf * skel.get_bone_global_pose(up).origin
	var out := sh - face
	out = (out - fwd * out.dot(fwd))
	out = Vector3(out.x, 0.0, out.z).normalized()
	var k: Vector2 = HOOK if _hook else STRAIGHT
	var top := minf(face.y - BELOW_FACE_M, head_w.y + OVER_HEAD_MAX_M)
	var goal_w := face + fwd * k.x + out * k.y
	goal_w.y = top
	# On a hook's line: as the punching glove comes near, the glove slides sideways and down to meet it (its centre
	# MEET_M behind the front, toward the face), kept inside the catch's box. Its distance in front of the face stays put:
	# the punch is carried onto this glove (FightStage.arm_block), so following it forward or back would chase it.
	var pf: Vector3 = stage.glove_front(1 - me, _phand)
	var m := 1.0 - smoothstep(MEET_NEAR.x, MEET_NEAR.y, pf.distance_to(goal_w))
	if m > 0.0 and _hook:   # a hook's line runs across her: a straight one is met where it aims, at the face
		var meet := pf + (face - pf).normalized() * MEET_M
		var c := goal_w.lerp(meet, m)
		var rel := c - face
		var f := k.x
		var o := clampf(rel.dot(out), 0.02, 0.11)
		goal_w = face + fwd * f + out * o
		goal_w.y = clampf(c.y, face.y - LOW_M, top)
	var goal := xf.affine_inverse() * goal_w
	var now := skel.get_bone_global_pose(hd).origin
	_reach(skel, up, lo, hd, now.lerp(goal, w))
	_keep_other(skel)


## The other glove stays in her guard: held where it sat in her chest's frame when the catch began (her guard's own
## drift - GuardWeave, GuardTuck following the face - would carry it 5-6 cm during a block), by the catch weight.
func _keep_other(skel: Skeleton3D) -> void:
	var side := "Left" if str(_arm[0]).begins_with("Right") else "Right"
	var up := skel.find_bone(side + "UpperArm")
	var lo := skel.find_bone(side + "LowerArm")
	var hd := skel.find_bone(side + "Hand")
	var ch := skel.find_bone("Chest")
	if up < 0 or lo < 0 or hd < 0 or ch < 0:
		return
	var cx := skel.get_bone_global_pose(ch)
	var now := skel.get_bone_global_pose(hd).origin
	if not _hold.is_finite():
		_hold = cx.affine_inverse() * now
		return
	_reach(skel, up, lo, hd, now.lerp(cx * _hold, w))


## Two-bone reach in skeleton space: UpperArm swings the elbow, LowerArm swings the wrist onto `t`. Bone lengths kept.
func _reach(skel: Skeleton3D, up: int, lo: int, hd: int, t: Vector3) -> void:
	for _i in 2:
		var gu := skel.get_bone_global_pose(up)
		var gl := skel.get_bone_global_pose(lo)
		var gh := skel.get_bone_global_pose(hd)
		var s := gu.origin
		var e := gl.origin
		var h := gh.origin
		var l1 := s.distance_to(e)
		var l2 := e.distance_to(h)
		var to_t := t - s
		var d := clampf(to_t.length(), absf(l1 - l2) + 0.001, l1 + l2 - 0.002)
		if to_t.length() < 1e-5 or l1 < 1e-5 or l2 < 1e-5:
			return
		var dir := to_t.normalized()
		var pole := (e - s) - dir * (e - s).dot(dir)
		if pole.length() < 1e-5:
			pole = Vector3.DOWN - dir * dir.y
		pole = pole.normalized()
		var ca := clampf((l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d), -1.0, 1.0)
		var e2 := s + dir * ca * l1 + pole * sqrt(maxf(0.0, 1.0 - ca * ca)) * l1
		_turn(skel, up, gu, e - s, e2 - s)
		gl = skel.get_bone_global_pose(lo)
		gh = skel.get_bone_global_pose(hd)
		_turn(skel, lo, gl, gh.origin - gl.origin, (s + dir * d) - gl.origin)


func _turn(skel: Skeleton3D, bone: int, g: Transform3D, a: Vector3, b: Vector3) -> void:
	if a.length() < 1e-6 or b.length() < 1e-6:
		return
	var q := Quaternion(a.normalized(), b.normalized())
	skel.set_bone_global_pose(bone, Transform3D(Basis(q) * g.basis, g.origin))
