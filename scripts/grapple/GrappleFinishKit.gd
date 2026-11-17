extends RefCounted
## SPLIT500B: the SQUEEZE finish lifted out of GrappleFinish.gd (the 500-line rule) - the lock that grows out of any
## submission landing (the hips slide in, the arm goes straight or the grip bends up, the legs clamp, the loser taps),
## with the raw-space geometry helpers both halves share. GrappleFinish.squeeze forwards here; the constants the
## recorded armbar still reads are aliased back there. Pure: raw (GrappleMap) space in, raw keyframes out.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

## Shared with GrappleFinish's recorded armbar and tap_out (aliased there).
const REACH_UP := 0.29    # a GrappleMap man's upper arm (GrappleMapDB.LIMBS)
const REACH_FORE := 0.27
const TAPS := 3
const TAP_REACH := 0.42    # how far from the shoulder the hand lands
const TAP_MAT_Y := 0.045  # the fingers' height at the touch (their floor clearance)
const GRIP_SUBS := ["kimura", "americana"]


## S390 (black belt on the film: "the setup is close", then the recorded extension popped the pair 90 degrees and lost the arm): the
## finish grows out of the landing on screen, so nothing jumps. The lock tightens (LOCK_IN_S), the hips rise (SQUEEZE_M), the
## loser taps on the winner's leg, and the last tap is the end. For the arm family the winner's hands take the wrist and the arm
## goes straight; every family gets the squeeze and the tap.
const LOCK_IN_S := 1.3
const SQUEEZE_S := 0.6
const SQUEEZE_M := 0.07
const TAP_FIRST_S := 0.25
const TAP_GAP_S := 0.28
const TAP_LIFT_M := 0.24
const TAP_DRIVE_M := 0.03
const PULL_M := 0.09      # the loser pulled down over the winner's hips
const NECK_PAST_M := 0.16 # the crossing ankle lands this far past the neck
const NECK_SIDE_M := 0.14
const LEG_M := 0.43       # GrappleMap thigh and shin (GrappleMapDB.LIMBS)


static func squeeze(frame: Array, winner: int, tags: Array) -> Dictionary:
	var w: PackedVector3Array = (frame[winner] as PackedVector3Array).duplicate()
	var l: PackedVector3Array = (frame[1 - winner] as PackedVector3Array).duplicate()
	var free := "Left"
	if tags.has("armbar") or tags.has("spiderweb"):
		# The arm is chosen ONCE, before she moves: once her hips slide in both elbows are near them and it could flip mid-finish.
		var arm := _arm_side(w, l)
		_pull_in(w, l, arm)
		free = _take_arm(w, l, arm)
		_leg_chest(w, l, arm, _leg_over(w, l, arm))
		# Her free arm posts out on the mat: beside the trapped one it hid it ("both arms between the legs").
		var post := _flat(l[DB.joint(free + "Shoulder")] - w[DB.joint("Core")]).normalized()
		_hand_to(l, free, Vector3(l[DB.joint(free + "Shoulder")].x, TAP_MAT_Y, l[DB.joint(free + "Shoulder")].z) + post * TAP_REACH)
	else:
		var core: Vector3 = w[DB.joint("Core")]
		free = "Right" if l[DB.joint("RightWrist")].distance_to(core) > l[DB.joint("LeftWrist")].distance_to(core) else "Left"
		for t in tags:
			if GRIP_SUBS.has(t):
				_take_grip(w, l, free)
				break
	var locked: Array = [w, l] if winner == 0 else [l, w]
	var tight: PackedVector3Array = w.duplicate()
	for n in ["Core", "LeftHip", "RightHip"]:
		tight[DB.joint(n)] += Vector3.UP * SQUEEZE_M
	for n in ["LeftKnee", "RightKnee"]:
		tight[DB.joint(n)] += Vector3.UP * SQUEEZE_M * 0.5
	var held: Array = [tight, l] if winner == 0 else [l, tight]
	var frames: Array = [[_dup(frame[0]), _dup(frame[1])], locked, held]
	var times := PackedFloat32Array([0.0, LOCK_IN_S, LOCK_IN_S + SQUEEZE_S])
	var t := LOCK_IN_S + SQUEEZE_S + TAP_FIRST_S
	var on := _tap_spot(tight, l, free)
	for k in TAPS * 2:
		var lv: PackedVector3Array = l.duplicate()
		var up := k % 2 == 0
		_hand_to(lv, free, on + Vector3.UP * (TAP_LIFT_M if up else 0.0))
		# She keeps extending into each tap: a winner frozen under three slaps read as a held still (S391 film: "the pose freezes").
		var wv: PackedVector3Array = tight.duplicate()
		if not up:
			for n in ["Core", "LeftHip", "RightHip"]:
				wv[DB.joint(n)] += Vector3.UP * TAP_DRIVE_M
		frames.append([wv, lv] if winner == 0 else [lv, wv])
		times.append(t)
		t += TAP_GAP_S
	return {"frames": frames, "times": times, "free": free}


## The winner scoots her hips in under the loser's near shoulder (her whole body slides, so every limb keeps its length): only then is
## the arm as long as her torso and the wrist lands on her chest, not her face ("both of Ana's hands cover her own face"). The loser
## comes down over her ("kneeling upright, unbothered").
static func _pull_in(w: PackedVector3Array, l: PackedVector3Array, side: String) -> void:
	var hips: Vector3 = (w[DB.joint("LeftHip")] + w[DB.joint("RightHip")]) * 0.5
	var slide := _flat(l[DB.joint(side + "Shoulder")] - hips)
	for j in w.size():
		w[j] += slide
	hips += slide
	var toward := Vector3.DOWN * PULL_M
	for n in ["Neck", "Head", "LeftShoulder", "RightShoulder"]:
		l[DB.joint(n)] += toward
	l[DB.joint("Core")] += toward * 0.5


static func _arm_side(w: PackedVector3Array, l: PackedVector3Array) -> String:
	var side := "Right"
	var best := INF
	for s in ["Left", "Right"]:
		var d := _seg_dist(l[DB.joint(s + "Elbow")], w[DB.joint("LeftHip")], w[DB.joint("RightHip")])
		if d < best:
			best = d
			side = s
	return side


## The winner's leg nearest the loser's neck crosses it: a real armbar's leg over the face. Two-bone, the knee up.
static func _leg_over(w: PackedVector3Array, l: PackedVector3Array, arm: String) -> String:
	var neck: Vector3 = l[DB.joint("Neck")]
	var side := "Left" if w[DB.joint("LeftKnee")].distance_to(neck) <= w[DB.joint("RightKnee")].distance_to(neck) else "Right"
	var hip: Vector3 = w[DB.joint(side + "Hip")]
	var was: Vector3 = w[DB.joint(side + "Ankle")]
	# Across the throat, clear of the head ("Ana's foot goes through Nadia's head"): past the neck, low, to the far side of the arm.
	var along := _flat(neck - hip).normalized()
	var away := Vector3.UP.cross(along).normalized()
	if away.dot(l[DB.joint(arm + "Shoulder")] - neck) > 0.0:
		away = -away
	var to := neck + along * NECK_PAST_M + away * NECK_SIDE_M + Vector3.DOWN * 0.1 - hip
	var ankle := hip + to.normalized() * minf(to.length(), LEG_M * 2.0 - 0.02)
	var half := hip.distance_to(ankle) * 0.5
	w[DB.joint(side + "Knee")] = (hip + ankle) * 0.5 + Vector3.UP * sqrt(maxf(0.0, LEG_M * LEG_M - half * half))
	w[DB.joint(side + "Ankle")] = ankle
	for n in ["Heel", "Toe"]:
		w[DB.joint(side + n)] += ankle - was
	return side


## Her other leg clamps too, shin across the loser's chest under the arm ("the other leg hangs in the air", "no knee squeeze"). `over`: the leg already on the neck.
static func _leg_chest(w: PackedVector3Array, l: PackedVector3Array, arm: String, over: String) -> void:
	var side := "Left" if over == "Right" else "Right"
	var hip: Vector3 = w[DB.joint(side + "Hip")]
	var was: Vector3 = w[DB.joint(side + "Ankle")]
	var chest: Vector3 = l[DB.joint("Core")].lerp(l[DB.joint("Neck")], 0.45)
	var along := _flat(chest - hip).normalized()
	var away := Vector3.UP.cross(along).normalized()
	if away.dot(l[DB.joint(arm + "Shoulder")] - l[DB.joint("Neck")]) > 0.0:
		away = -away
	var to := chest + along * NECK_PAST_M + away * NECK_SIDE_M - hip
	var ankle := hip + to.normalized() * minf(to.length(), LEG_M * 2.0 - 0.02)
	var half := hip.distance_to(ankle) * 0.5
	w[DB.joint(side + "Knee")] = (hip + ankle) * 0.5 + Vector3.UP * sqrt(maxf(0.0, LEG_M * LEG_M - half * half))
	w[DB.joint(side + "Ankle")] = ankle
	for n in ["Heel", "Toe"]:
		w[DB.joint(side + n)] += ankle - was


## The arm she has: the loser's elbow nearest her hips. It goes straight toward her chest, her hands on the wrist. Returns the free side.
static func _take_arm(w: PackedVector3Array, l: PackedVector3Array, side: String) -> String:
	var sh: Vector3 = l[DB.joint(side + "Shoulder")]
	var chest: Vector3 = (w[DB.joint("Core")] + w[DB.joint("Neck")]) * 0.5 + Vector3.UP * 0.12
	var dir := (chest - sh).normalized()
	var wrist := sh + dir * (REACH_UP + REACH_FORE)
	l[DB.joint(side + "Elbow")] = sh + dir * REACH_UP
	l[DB.joint(side + "Wrist")] = wrist
	l[DB.joint(side + "Hand")] = wrist + dir * 0.06
	l[DB.joint(side + "Fingers")] = wrist + dir * 0.13
	for s in ["Left", "Right"]:
		var grip := wrist + Vector3.UP * 0.05 + (Vector3.LEFT if s == "Left" else Vector3.RIGHT) * 0.04
		var ws: Vector3 = w[DB.joint(s + "Shoulder")]
		var to := grip - ws
		if to.length() > REACH_UP + REACH_FORE - 0.01:
			grip = ws + to.normalized() * (REACH_UP + REACH_FORE - 0.01)
		var mid := (ws + grip) * 0.5
		var half := ws.distance_to(grip) * 0.5
		w[DB.joint(s + "Elbow")] = mid + Vector3.UP * sqrt(maxf(0.0, REACH_UP * REACH_UP - half * half))
		w[DB.joint(s + "Wrist")] = grip
		w[DB.joint(s + "Hand")] = grip + (grip - ws).normalized() * 0.05
		w[DB.joint(s + "Fingers")] = grip + (grip - ws).normalized() * 0.11
	return "Left" if side == "Right" else "Right"


## A kimura or americana: both her hands on the wrist of the arm she has, that arm bent up behind the shoulder ("no figure-four, no bent arm").
static func _take_grip(w: PackedVector3Array, l: PackedVector3Array, free: String) -> void:
	var side := "Left" if free == "Right" else "Right"
	var sh: Vector3 = l[DB.joint(side + "Shoulder")]
	var core: Vector3 = w[DB.joint("Core")]
	var out := _flat(sh - l[DB.joint("Core")]).normalized()
	var elbow := sh + (out + Vector3.UP * 0.3).normalized() * REACH_UP
	var wrist := elbow + (_flat(core - elbow).normalized() + Vector3.UP * 0.5).normalized() * REACH_FORE
	var along := (wrist - elbow).normalized()
	l[DB.joint(side + "Elbow")] = elbow
	l[DB.joint(side + "Wrist")] = wrist
	l[DB.joint(side + "Hand")] = wrist + along * 0.06
	l[DB.joint(side + "Fingers")] = wrist + along * 0.13
	for s in ["Left", "Right"]:
		_hand_to(w, s, wrist + (Vector3.LEFT if s == "Left" else Vector3.RIGHT) * 0.04 + Vector3.UP * 0.03)


## Where the free hand taps: the mat, out past the shoulder, the side she posts on. S390 aimed it at the winner's thigh; S391's film measured it
## landing there (palm on her skin) and still no judge saw a tap: the thigh lies behind the loser's own head. A slap on the mat is seen and heard.
static func _tap_spot(w: PackedVector3Array, l: PackedVector3Array, free: String) -> Vector3:
	var sh: Vector3 = l[DB.joint(free + "Shoulder")]
	var out := _flat(sh - w[DB.joint("Core")]).normalized()
	# Of three ways out, the one clearest of her own legs (a judge: "it lands through her own foot").
	var best := Vector3(sh.x, TAP_MAT_Y, sh.z) + out * TAP_REACH
	var best_gap := -1.0
	for turn in [0.0, 0.7, -0.7]:
		var spot := Vector3(sh.x, TAP_MAT_Y, sh.z) + out.rotated(Vector3.UP, turn) * TAP_REACH
		var gap := INF
		for s in ["Left", "Right"]:
			gap = minf(gap, _seg_dist(spot, l[DB.joint(s + "Knee")], l[DB.joint(s + "Ankle")]))
			gap = minf(gap, _seg_dist(spot, l[DB.joint(s + "Ankle")], l[DB.joint(s + "Toe")]))
		if gap > best_gap + 0.05:
			best_gap = gap
			best = spot
	return best


static func _hand_to(l: PackedVector3Array, side: String, at: Vector3) -> void:
	var sh: Vector3 = l[DB.joint(side + "Shoulder")]
	var to := at - sh
	var reach := REACH_UP + REACH_FORE - 0.01
	var hand := at if to.length() <= reach else sh + to.normalized() * reach
	var mid := (sh + hand) * 0.5
	var half := sh.distance_to(hand) * 0.5
	l[DB.joint(side + "Elbow")] = mid + Vector3.UP * sqrt(maxf(0.0, REACH_UP * REACH_UP - half * half))
	l[DB.joint(side + "Wrist")] = hand
	l[DB.joint(side + "Hand")] = hand + to.normalized() * 0.05
	l[DB.joint(side + "Fingers")] = hand + to.normalized() * 0.11


## The raw-space geometry both halves share (GrappleFinish forwards _seg_dist / _flat / _dup here).
static func _seg_dist(p: Vector3, a: Vector3, b: Vector3) -> float:
	return p.distance_to(_closest_on_seg(p, a, b))


static func _closest_on_seg(p: Vector3, a: Vector3, b: Vector3) -> Vector3:
	var ab := b - a
	if ab.length_squared() < 1e-12:
		return a
	return a + ab * clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)


static func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


static func _dup(p: PackedVector3Array) -> PackedVector3Array:
	return p.duplicate()
