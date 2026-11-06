extends RefCounted
## S377 BJJ9 round 10 (Argon round 9, its condition 4 and the film's worst moment: "The UI announces KIM WINS -
## SUBMISSION (TO ARM LOCK) while Red is on bottom with legs wrapped high around Blue's upper back, and Blue is sitting
## upright in guard with both arms tucked in. Neither fighter is applying an armbar."): GrappleMap's arm-lock landing
## is an ATTEMPT - the winner's last move ("arm bar", db 1458) lands on "arm lock" (db 263) with the loser's arm still
## bent 107-128 deg, its elbow 0.19-0.21 m off the hips. The data DOES contain the finished relation (db 153 / 826
## "extend arm": straight 169 deg, elbow 0.16 m off the attacker's hips, the arm above the pelvis, a leg across the
## victim's face) - but only from a supine attacker, so it cannot be laid on this landing directly.
## This module builds the FINISH from ANY lock landing: the winning fighter takes the armbar - she sits on the loser's
## shoulder, the loser's near arm pulled STRAIGHT across her lap (the elbow on her hip line, the wrist raised beyond
## her far hip - the judge's own words: "the winning fighter's hips are pivoted perpendicular, leg across the face,
## and the defender's arm is fully extended between the thighs"), her shin swings across the loser's face, her hips
## rise into the extension, and the loser taps twice on her thigh.
## Pure: raw (GrappleMap) space in, raw keyframes out - the browser aligns/blends/plays them like any move.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const Timing := preload("res://scripts/grapple/GrappleTiming.gd")

## GrappleMap transition id for "extend arm" (db / graph 826) — the recorded finish relation (lands on 153).
const EXTEND_ARM_ID := 826

const SIT_S := 0.85       # the landing -> the sit (hips on the loser's shoulder, the arm caught)
const LOCK_S := 1.35      # the shin swings across the face
const EXT_S := 1.90       # the hips rise into the extension
const TAP1_S := 2.30
const TAP1B_S := 2.55
const TAP2_S := 2.80
const TAP2B_S := 3.05
const HIP_UP := 0.035     # the extension: how far the winner's hips leave the mat under the arm
const REACH_UP := 0.29    # a GrappleMap man's upper arm (GrappleMapDB.LIMBS)
const REACH_FORE := 0.27
const SEAT_H := 0.29      # the winner's hip joints sit this high (on the loser's shoulder; her hips capsule rests on the loser's shoulder capsule - below ~0.28 the resolver fights the seat)
const TAPS := 3
const TAP_START_S := 0.45
const TAP_BEAT_S := 0.2
const TAP_HIGH := 0.2      # how high the slapping hand lifts
const TAP_REACH := 0.42    # how far from the shoulder the hand lands
const TAP_OFF := 0.13     # how far the tapping hand leaves the mat between taps
const TAP_MAT_Y := 0.045  # the fingers' height at the touch (their floor clearance)
## The locked arm's line, measured against the game's capsule table (hips r 0.118, upper arm r 0.06, thigh r 0.10):
## the elbow must clear the hips capsule END - an aim through the pelvis (or under it) made the resolver push the
## elbow 0.14 m and bend the arm 40 deg, and an aim into the thigh bent it too. This aims the arm out past the hip
## corner, low: the arm stretches straight across the lap, hand past the far hip.
const ARM_AIM_B := 0.45   # along the loser's body axis, from the winner's hip centre
const ARM_AIM_UP := -0.08  # nearly FLAT: the arm crosses under the pelvis's front (the capsule table needs 0.178 m
						   # between the arm's and the hips' axes; a 20 deg climb leaves only 0.10 and the resolver
						   # pushes the elbow 0.08 and bends the arm 40 deg off straight)
## The winner's own legs: the bent one swings wide of the loser's raised legs (r 0.10 thighs need 0.20 between axes -
## round 10's first cut buried it 0.14 m in the loser's thigh), the crossing shin rides 0.18 to the side of the head
## (a shin straight over the head's centre is inside it: the head is r 0.11).
const LEG2_OUT := Vector3(0, 0.16, -0.30)    # the near (right) leg's knee, from her hip centre (minus b*0.10):
const LEG2_ANKLE := Vector3(0, -0.20, -0.34) # knee UP beside the locked arm (the lap's "V"), the foot planted
## The loser's own legs: the landing leaves them wound up around the winner, and no armbar sits on a victim whose
## legs are still in the air - K1 drops them to the mat, knees out (the thigh capsule is r 0.10: two thighs need
## 0.20 m between axes, and the round-10 first cut buried the winner's leg 0.14 m in one left up there).
const VIC_R_KNEE := Vector3(0.05, 0.10, -0.22)   # from her pelvis, minus b*0.34 (her near leg extends back-out)
const VIC_R_ANKLE := Vector3(0, 0.02, -0.30)     # (minus b*0.56)
const VIC_L_KNEE := Vector3(0, 0.24, 0.30)       # her far leg bends, knee up beside the winner
const VIC_L_ANKLE := Vector3(0, 0.0, 0.42)       # (minus b*0.36)
const SHIN_SIDE := 0.18   # the crossing shin's offset off the head's axis (to the far side of the face)


static func times() -> PackedFloat32Array:
	return PackedFloat32Array([0.0, SIT_S, LOCK_S, EXT_S, TAP1_S, TAP1B_S, TAP2_S, TAP2B_S])


## S380 BJJ9R15: GrappleMap's recorded "extend arm" (826), aligned from the lock landing — not hand-tuned keyframes.
static func recorded(db: Array, landing: Array) -> Dictionary:
	if EXTEND_ARM_ID < 0 or EXTEND_ARM_ID >= db.size():
		return build(landing)
	var seq: Array = db[EXTEND_ARM_ID]["frames"]
	if seq.is_empty():
		return build(landing)
	var how: Dictionary = Graph.align(landing, seq[0])
	var placed: Array = Graph.placed(seq, how)
	var side := "Right"
	var best := INF
	var w := 0 if (landing[0] as PackedVector3Array)[DB.joint("Core")].y >= (landing[1] as PackedVector3Array)[DB.joint("Core")].y else 1
	var vic: PackedVector3Array = landing[1 - w]
	var win: PackedVector3Array = landing[w]
	for s in ["Left", "Right"]:
		var d := _seg_dist(vic[DB.joint(s + "Elbow")], win[DB.joint("LeftHip")], win[DB.joint("RightHip")])
		if d < best:
			best = d
			side = s
	return {"frames": placed, "times": Timing.key_times_shape(placed, TAP2B_S, 0.25), "side": side}


## The finish for a landing frame ([man0, man1], raw): {frames: Array, times: PackedFloat32Array, side: String}.
## The attacker is the man ON TOP (a submission is offered only to the top fighter - BeltMatch.offers), so the winner
## takes the arm; everything is built from the landing's own joints.
static func build(frame: Array) -> Dictionary:
	var a := 0 if (frame[0] as PackedVector3Array)[DB.joint("Core")].y >= (frame[1] as PackedVector3Array)[DB.joint("Core")].y else 1
	var atk: PackedVector3Array = (frame[a] as PackedVector3Array).duplicate()
	var vic: PackedVector3Array = (frame[1 - a] as PackedVector3Array).duplicate()
	# The loser's near arm: the one whose elbow is nearest the winner's hip line (the arm she already has).
	var side := "Right"
	var best := INF
	for s in ["Left", "Right"]:
		var d := _seg_dist(vic[DB.joint(s + "Elbow")], atk[DB.joint("LeftHip")], atk[DB.joint("RightHip")])
		if d < best:
			best = d
			side = s
	var sh: Vector3 = vic[DB.joint(side + "Shoulder")]
	# The victim's body axis on the mat (her hips -> her neck): the winner sits across it, left hip toward the head.
	var pel := (vic[DB.joint("LeftHip")] + vic[DB.joint("RightHip")]) * 0.5
	var b := _flat(vic[DB.joint("Neck")] - pel).normalized()
	# The winner's seat: hip joints over the loser's shoulder, her hip line on the loser's body axis.
	var hipc := Vector3(sh.x, SEAT_H, sh.z)
	# The arm runs STRAIGHT across the hips (the judge's words), out past the far hip (ARM_AIM_*). The loser's
	# shoulder holds its own spot (lifting it 3 cm puts it 2 cm deeper into the winner's pelvis capsule).
	var sh_lift := sh + Vector3(0, -0.01, 0)
	var dir := ((hipc + b * ARM_AIM_B + Vector3(0, ARM_AIM_UP, 0)) - sh_lift).normalized()
	var e := sh_lift + dir * REACH_UP
	var w := sh_lift + dir * (REACH_UP + REACH_FORE)
	var stages: Array = []
	stages.append([_dup(atk), _dup(vic)])
	var sit := _sit(atk, vic, hipc, b, side)
	stages.append(sit)
	# From the sit on, the loser's body is the SETTLED one (her legs come down with the sit - building K2+ from the
	# landing's own victim put them straight back up in the air).
	var vic2: PackedVector3Array = sit[1]
	stages.append(_lock(atk, vic2, hipc, b, side, sh_lift, e, w))
	stages.append(_extend(atk, vic2, hipc, b, side, sh_lift, e, w))
	var at := _tap_point(stages[3], side)
	for k in 4:
		var st: Array = [_dup(stages[3][0]), _dup(stages[3][1])]
		_tap(st, side, at, k % 2 == 0)
		stages.append(st)
	return {"frames": stages, "times": times(), "side": side}


## K1: the winner slides her seat onto the loser's shoulder, her legs under her, trunk upright; the loser's arm is
## still where the landing left it (the straightening runs across K1->K2).
static func _sit(atk: PackedVector3Array, vic: PackedVector3Array, hipc: Vector3, b: Vector3, _side: String) -> Array:
	var a := _body(atk, hipc, b, 0.0, Vector3.ZERO)
	# Her left leg is mid-swing here (halfway from the landing to the face-crossing shin): the K0->K2 blend passes
	# through this key, and the landing's own left leg is still wound around the loser's back - live, its capsule sat
	# 0.144 m inside the loser's arm.
	var tgt := _dup(a)
	_shin_over_face(tgt, vic, b)
	a[DB.joint("LeftKnee")] = a[DB.joint("LeftKnee")].lerp(tgt[DB.joint("LeftKnee")], 0.5)
	a[DB.joint("LeftAnkle")] = a[DB.joint("LeftAnkle")].lerp(tgt[DB.joint("LeftAnkle")], 0.5)
	_feet(a, "Left")
	var v := _dup(vic)
	var pel := (v[DB.joint("LeftHip")] + v[DB.joint("RightHip")]) * 0.5
	v[DB.joint("RightKnee")] = pel - b * 0.34 + VIC_R_KNEE
	v[DB.joint("RightAnkle")] = pel - b * 0.56 + VIC_R_ANKLE
	v[DB.joint("LeftKnee")] = pel - b * 0.26 + VIC_L_KNEE
	v[DB.joint("LeftAnkle")] = pel - b * 0.36 + VIC_L_ANKLE
	_feet(v, "Right")
	_feet(v, "Left")
	return [a, v]


## K2: the shin swings across the loser's face and the near arm is straightened across the winner's lap.
static func _lock(atk: PackedVector3Array, vic: PackedVector3Array, hipc: Vector3, b: Vector3, side: String,
		sh: Vector3, e: Vector3, w: Vector3) -> Array:
	var a := _body(atk, hipc, b, 0.0, e)
	var v := _arm(vic, side, sh, e, w)
	_shin_over_face(a, v, b)
	return [a, v]


## K3: the extension - the hips rise under the arm, the arm and the loser's shoulder ride with them.
static func _extend(atk: PackedVector3Array, vic: PackedVector3Array, hipc: Vector3, b: Vector3, side: String,
		sh: Vector3, e: Vector3, w: Vector3) -> Array:
	var a := _body(atk, hipc, b, HIP_UP, e + Vector3(0, HIP_UP, 0))
	var v := _arm(vic, side, sh + Vector3(0, HIP_UP, 0), e + Vector3(0, HIP_UP, 0), w + Vector3(0, HIP_UP, 0))
	_shin_over_face(a, v, b)
	return [a, v]


## The winner seated: hips at `hipc` (+up), her hip line on `b` (left toward the loser's head), trunk leaning back off
## the loser, right leg bent under her near the loser's ribs, left leg set afterwards by _shin_over_face.
static func _body(src: PackedVector3Array, hipc: Vector3, b: Vector3, hips_up: float, hold: Vector3) -> PackedVector3Array:
	var a := _dup(src)
	var h := hipc + Vector3(0, hips_up, 0)
	a[DB.joint("LeftHip")] = h + b * 0.115
	a[DB.joint("RightHip")] = h - b * 0.115
	# Upright over the shoulder, her trunk leaning toward the arm she is locking (she hugs it), hip line on b.
	var spine := (Vector3(0, 0.82, -0.30) + b * 0.24).normalized()
	var neck := h + spine * 0.46
	a[DB.joint("Core")] = h + spine * 0.26
	a[DB.joint("Neck")] = neck
	a[DB.joint("Head")] = neck + spine * 0.16 + Vector3(0, 0.02, 0)
	a[DB.joint("LeftShoulder")] = h + spine * 0.40 + b * 0.17
	var sh_r := h + spine * 0.40 - b * 0.17
	a[DB.joint("RightShoulder")] = sh_r
	# Her right hand braces the levered arm at the elbow (the wrist itself sits out past her own reach); the left
	# posts on the mat beside her.
	var rw: Vector3 = hold + Vector3(0, -0.07, -0.05) if hold != Vector3.ZERO else h + b * 0.28 + Vector3(0, -0.10, -0.08)
	a[DB.joint("RightElbow")] = (sh_r + rw) * 0.5 + spine * -0.05 + Vector3(0, 0, -0.05)
	a[DB.joint("RightWrist")] = rw
	a[DB.joint("RightHand")] = rw + (rw - a[DB.joint("RightElbow")]).normalized() * 0.05
	a[DB.joint("RightFingers")] = rw + (rw - a[DB.joint("RightElbow")]).normalized() * 0.10
	a[DB.joint("LeftElbow")] = h + spine * 0.22 - b * 0.06 + Vector3(0, 0, -0.14)
	a[DB.joint("LeftWrist")] = h - Vector3(0, 0.24, 0) - b * 0.05 + Vector3(0, 0, -0.10)
	a[DB.joint("LeftHand")] = a[DB.joint("LeftWrist")] + Vector3(-0.04, 0, -0.04)
	a[DB.joint("LeftFingers")] = a[DB.joint("LeftWrist")] + Vector3(-0.08, 0, -0.06)
	# The near (right) leg bent with the knee up beside the locked arm (the lap's "V").
	a[DB.joint("RightKnee")] = h - b * 0.10 + LEG2_OUT
	a[DB.joint("RightAnkle")] = h - b * 0.16 + LEG2_ANKLE
	_feet(a, "Right")
	return a


## The winner's left shin across the loser's face: the knee behind/above her head, the foot planted beyond it, the
## shin riding SHIN_SIDE to the side of the head's axis (over her cheek/temple - straight over the centre is inside
## the head sphere).
static func _shin_over_face(a: PackedVector3Array, v: PackedVector3Array, b: Vector3) -> void:
	var head: Vector3 = v[DB.joint("Head")]
	var side := b.cross(Vector3.UP).normalized() * SHIN_SIDE
	a[DB.joint("LeftKnee")] = head - b * 0.08 + side + Vector3(0, 0.24, 0)
	a[DB.joint("LeftAnkle")] = head + b * 0.20 + side + Vector3(0, -0.19, 0)
	_feet(a, "Left")


## The loser's lock arm: shoulder sh -> elbow e -> wrist w, one straight line (the shoulder is levered off the mat
## with the arm).
static func _arm(vic: PackedVector3Array, side: String, sh: Vector3, e: Vector3, w: Vector3) -> PackedVector3Array:
	var v := _dup(vic)
	var u := (w - e).normalized()
	v[DB.joint(side + "Shoulder")] = sh
	v[DB.joint(side + "Elbow")] = e
	v[DB.joint(side + "Wrist")] = w
	v[DB.joint(side + "Hand")] = w + u * 0.055
	v[DB.joint(side + "Fingers")] = w + u * 0.105
	return v


## The loser's free hand taps the MAT beside her - the canonical tap under an armbar (the thigh is out of her reach
## from here, and planting the fingers into it was a 0.145 m conflict: the resolver answered by shoving the winner's
## leg, which dragged the lock arm 20 deg off straight). Touch = the fingers on the mat, release = TAP_OFF above it.
static func _tap(stage: Array, lock_side: String, at: Vector3, touch: bool) -> void:
	var loser := 1
	var v: PackedVector3Array = stage[loser]
	var free := "Left" if lock_side == "Right" else "Right"
	var fy := TAP_MAT_Y if touch else TAP_MAT_Y + TAP_OFF
	var f := Vector3(at.x, fy, at.z)
	var w := f + Vector3(0, 0.06, 0)
	v[DB.joint(free + "Wrist")] = w
	v[DB.joint(free + "Hand")] = (w + f) * 0.5
	v[DB.joint(free + "Fingers")] = f - Vector3(0, 0.02, 0) if touch else f + Vector3(0, 0.05, 0)
	stage[loser] = v


## Where the loser's free hand reaches to slap the mat: straight below where the landing left it.
static func _tap_point(stage: Array, lock_side: String) -> Vector3:
	var free := "Left" if lock_side == "Right" else "Right"
	var w: Vector3 = (stage[1] as PackedVector3Array)[DB.joint(free + "Wrist")]
	return Vector3(w.x, 0.0, w.z)


## S389 (every judge: "TAP appears, nobody taps"): the tap on ANY finish. From a landing frame the one underneath slaps the mat
## TAPS times with the free hand, the arm further from the winner. Raw frames and times, played after the finish.
static func tap_out(frame: Array) -> Dictionary:
	var lose := 1 if (frame[0] as PackedVector3Array)[DB.joint("Core")].y >= (frame[1] as PackedVector3Array)[DB.joint("Core")].y else 0
	var win_core: Vector3 = (frame[1 - lose] as PackedVector3Array)[DB.joint("Core")]
	var v: PackedVector3Array = frame[lose]
	var side := "Left"
	if v[DB.joint("RightWrist")].distance_to(win_core) > v[DB.joint("LeftWrist")].distance_to(win_core):
		side = "Right"
	var sh: Vector3 = v[DB.joint(side + "Shoulder")]
	var out := _flat(sh - win_core).normalized()
	if out.length() < 0.5:
		out = Vector3.RIGHT
	var at := Vector3(sh.x, 0.0, sh.z) + out * TAP_REACH
	var frames: Array = [[_dup(frame[0]), _dup(frame[1])]]
	var times := PackedFloat32Array([0.0])
	var t := TAP_START_S
	for k in TAPS * 2:
		var st: Array = [_dup(frame[0]), _dup(frame[1])]
		var touch := k % 2 == 1
		var f := at + Vector3(0, TAP_MAT_Y if touch else TAP_MAT_Y + TAP_HIGH, 0)
		var w := f - out * 0.05 + Vector3(0, 0.05, 0)
		var a: PackedVector3Array = st[lose]
		a[DB.joint(side + "Elbow")] = (sh + w) * 0.5 + Vector3(0, 0.09, 0)
		a[DB.joint(side + "Wrist")] = w
		a[DB.joint(side + "Hand")] = (w + f) * 0.5
		a[DB.joint(side + "Fingers")] = f
		st[lose] = a
		frames.append(st)
		times.append(t)
		t += TAP_BEAT_S
	return {"frames": frames, "times": times}


## Toe and heel of a foot under its ankle, flat on the mat, the toes pointing the way the shin runs.
static func _feet(a: PackedVector3Array, s: String) -> void:
	var an: Vector3 = a[DB.joint(s + "Ankle")]
	var dir := _flat(an - a[DB.joint(s + "Knee")])
	if dir.length() < 0.01:
		dir = Vector3.FORWARD
	dir = dir.normalized()
	a[DB.joint(s + "Heel")] = an + Vector3(0, 0.05, 0) - dir * 0.04
	var toe := an + dir * 0.12
	a[DB.joint(s + "Toe")] = Vector3(toe.x, maxf(0.015, toe.y - 0.02), toe.z)


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