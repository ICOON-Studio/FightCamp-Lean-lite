extends SkeletonModifier3D
## S315: a glove never sits inside the other boxer's head. Up close (inside spells, heads 14 cm apart) the guard idle,
## hooks and jabs played from clips authored at range put a glove centre deep inside the other's head in ~4 % of inside
## frames (tools/inside_guard_probe.gd: 22-36 of 571, with or without the S315 inside guard). Every frame, per hand: if the
## glove's centre (GLOVE_FWD_M past the wrist along the forearm) is nearer the other's head centre than CLEAR_M, the wrist
## is moved straight out of it by the difference and the arm re-solved as a two-bone chain (hand keeps its rotation). A
## landed punch's glove front stops on the face (PunchReach), at about the touch distance, so it moves a cm or two at most.
## tools/inside_guard_probe.gd, round 1's first 90 s: glove centre < 0.09 m from a head centre 36 -> 8 of 571 inside frames.
## Runs after HitSnap, before ElbowClear. `-- noglove` = the control arm (gloves and heads), `-- noheads` = heads only.
## S316: her head clears the other's too (_clear_head, run before the gloves).
##   setup(skel)  other (the other boxer's Skeleton3D, set by FightStage)

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const BlockCatch := preload("res://scripts/fight3d/BlockCatch.gd")   # S478: RISE_S, when a blocked punch becomes the catch's
const HeadClear := preload("res://scripts/fight3d/HeadClear.gd")   # S498: the head lean's rule (touch, sides, ease)

## Head ~0.09 m + glove ~0.06 m radius: they touch at ~0.15 m. Kept at the touch: the other head is read before her own sway
## and snap move it (up to ~5 cm), so 0.13 left 12 of 571 inside frames deep in a head (36 without this modifier).
const CLEAR_M := 0.15
## S350 (SMOOTH3): the push starts with a soft knee SOFT_M wide round the touch (C1), so a glove sliding past a head is
## eased out instead of kinked; from CLEAR_M - SOFT_M / 2 inward it is the full CLEAR_M - d as before.
const SOFT_M := 0.04
const GLOVE_FWD_M := 0.08
const HEAD_UP_M := 0.08

## Head centre 8 cm up the head bone, ~0.09-0.10 m radius: two heads touch at ~0.19 m.
const HEAD_TOUCH_M := 0.19
## Each boxer leans out of this share of the overlap; over half, since the first boxer of the frame reads the other's
## head a frame late (peer.shown_head) and the arc's chord falls a little short of the push.
const HEAD_SHARE := 0.7
## S382 MOVETIP1 round 3: the touch this body keeps (the hover card's studio keeps the heads further apart: MoveStudio).
var head_touch_m := HEAD_TOUCH_M
## S382 MOVETIP1 round 3: the head's centre rides with the head (HEAD_UP_M up the skull as it stands in the bind pose,
## turned with the head bone) instead of straight up from the bone - a folded head's centre is out in front of the bone,
## ~0.05 m nearer the other's than the straight-up guess (tools/movetip_heads_probe.gd). The studio turns it on.
var ride := false
var _up_rest := Vector3.UP   # the bind pose's up, in the head bone's own frame

var other: Skeleton3D
## The other boxer's GloveClear: its head centre AS SHOWN (after her snap, sway and hit fold), in world space. Read from
## outside the stack, her skeleton gives the animated pose without them - up to ~0.15 m off in a gut shot's fold.
var peer = null
## S320 hit_gap_probe: her own PunchReach. A landing punch's glove is meant to touch the face - this modifier kept every
## glove 0.15 m from the other head's centre and pushed the scoring glove 0.13-0.22 m off the face it was carried onto
## (inside jabs and hooks "landed" short). The striking hand is left alone while its reach is on.
var reach: Node = null
var shown_head := Vector3.INF
## S379: her hips as shown (world): the broadcast lens frames and keeps off her back by them - a step's travel sits in the
## clip's hips up to ~0.5 m from her root before the root catches up.
var shown_hips := Vector3.INF
## S465 C389 (operator markup on the rear uppercut tail: "clipping", twice): a glove never passes through the other boxer's
## glove or forearm. Each boxer moves out of ARM_SHARE of the overlap (both do, so the pair clears it; the peer's arms are
## read up to a frame late). `-- noclash` = the control arm.
## S468 C394 (his four marks on the same film after that fix, each "still clipping"): the S465 shapes were two 0.06 m balls
## 0.08 m past the wrist, touching at 0.12 m - but the mounted glove (Gloves.SIZE 1.2, S400) is 0.17 m thick and runs from
## 0.12 m behind the wrist to 0.19 m ahead of it, so "clear" still drew one glove 3-5 cm inside the other, and a forearm
## was never kept off a glove at all. The shapes are the drawn ones now: the glove a capsule along the forearm from
## GLOVE_AT.x to GLOVE_AT.y ahead of the wrist, radius GLOVE_R; the forearm a capsule elbow to wrist, radius FORE_R (times
## the body's scale); the padding gives SQUISH_M. Her glove AND her forearm are kept off the other's gloves and forearms,
## the deepest overlap first, CLASH_PASSES times a frame. tools/clash_meter.gd reads the same shapes off the drawn bodies.
## `-- ballclash` = the S465 balls (control arm).
const ARM_SHARE := 0.6
static var BALLS: bool = OS.get_cmdline_user_args().has("ballclash")
static var GLOVE_AT: Vector2 = Vector2(0.08, 0.08) if BALLS else Vector2(0.04, 0.115)
static var GLOVE_R: float = 0.06 if BALLS else 0.075
static var FORE_R: float = 0.04
static var SQUISH_M: float = 0.0   # the ruler allows 2 cm of give (tools/clash_meter.gd); a give here on top drew 3 cm
static var CLASH_PASSES: int = 1 if BALLS else 4
## Right of way (S468; the S465 rule was "a punching hand never moves", and the film showed her jab going out through
## the other's uppercut hand on its way home: two hands that never moved). Rank 2 = a punch on its way in or on her (armed
## on this hand, up to LIVE_S clip seconds past its contact); 1 = that hand going home (armed past that, or fading);
## 0 = a guard hand. The lower rank moves out of all of the overlap, equals share it, two live punches leave each other be.
const LIVE_S := 0.12
const OWN_ROUNDS := 2   # S478: rounds of (the other boxer's arms, then her own) per frame
const PUSH_MAX_M := 0.10   # the most one pass moves a wrist
const RETRACT := 0.6
const OPEN_SIDE := 1.0   # S476 CLASH3: how much of "open outward" goes across the push off a landing punch (0.5 tried: seed 77 cross 4.1 -> 5.5 cm, worse)
const TUCK_M := Vector2(0.25, 0.40)   # wrist to shoulder: no drawing in under .x, all of it from .y
## Her arms as shown, world space, per side: [elbow, wrist, the glove's axis (unit), the hand's rank, her scale, how far
## the elbow and the wrist moved since the frame before, a live punch's kind] (read by the other boxer's GloveClear). The boxer drawn first in
## a frame reads the other's arms a frame late: a jab's glove is 10-13 cm on by then, so she reads them one step ahead
## (shown_f tells her they are last frame's).
var shown_arms := {}
var shown_f := -1
var clash_late := false   # BoxerBuild: ArmClash runs clash_pass() after ElbowClear
var clash := true
var clash_pushes := 0    # frames a glove was moved off the other's glove or forearm (for probes)
var heads := true        # `-- noheads` turns the head clearance off (control arm)
var pushes := 0          # frames a glove was moved out (for probes)
var head_pushes := 0     # frames her trunk leaned out of the other's head
## S498 (HeadClear): her head's true centre before her own lean (world) - the other boxer's lean is worked out from it;
## `tie` 0-1 = the tie-up's weight (Clinch sets it: heads on shoulders keep the old touch); the lean shown now and its side.
var raw_head := Vector3.INF
var tie := 0.0
var _lean := Vector3.ZERO
var _lean_side := 0
var _lean_frame := -1
var _dip := Vector3.ZERO      # a body punch's own head dip (world), eased
var _dip_side := 0
var _arms := {}
var _head := -1
var _hips := -1
var _spine := -1
var _chest := -1


func setup(skel: Skeleton3D) -> bool:
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side] = ids
	_head = skel.find_bone("Head")
	_hips = skel.find_bone("Hips")
	_spine = skel.find_bone("Spine")
	_chest = skel.find_bone("Chest")
	heads = _spine >= 0 and _chest >= 0 and not OS.get_cmdline_user_args().has("noheads")
	clash = not OS.get_cmdline_user_args().has("noclash")
	if _head >= 0:
		_up_rest = skel.get_bone_global_rest(_head).basis.orthonormalized().inverse() * Vector3.UP
	return _head >= 0


## Her head's centre in skeleton space (k: the skeleton's world scale).
func _centre(skel: Skeleton3D, k: float) -> Vector3:
	var g := skel.get_bone_global_pose(_head)
	return g.origin + (g.basis.orthonormalized() * _up_rest if ride else Vector3.UP) * HEAD_UP_M / k


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or other == null or not is_instance_valid(other):
		return
	var to_me := skel.global_transform.affine_inverse()
	var oh := other.find_bone("Head")
	if oh < 0:
		return
	var oc: Vector3 = other.global_transform * other.get_bone_global_pose(oh).origin + Vector3.UP * HEAD_UP_M
	if peer != null and is_instance_valid(peer) and peer.shown_head.is_finite():
		oc = peer.shown_head
	var hc: Vector3 = to_me * oc
	# Skeleton space may be scaled (each body is scaled to her height): measure in world metres.
	var k := skel.global_transform.basis.get_scale().x
	# The head first: her lean moves her own arms, and the gloves are cleared after it.
	if heads and HeadClear.on:
		_lean_head(skel, to_me, oc, k)
	elif heads:
		_clear_head(skel, hc, k)
	if reach != null:
		reach.settle()   # S331: her lean (and HitSnap's) carried the landing glove off the face; it lands again
	shown_head = skel.global_transform * _centre(skel, k)
	if _hips >= 0:
		shown_hips = skel.global_transform * skel.get_bone_global_pose(_hips).origin
	for side in _arms:
		if reach != null and str(reach.get("_hand")).begins_with(side) and float(reach.get("last_weight")) > 0.0:
			continue
		var ids: Array = _arms[side]
		var g_la: Transform3D = skel.get_bone_global_pose(int(ids[1]))
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var gc := g_hd.origin + (g_hd.origin - g_la.origin).normalized() * GLOVE_FWD_M / k
		var away := gc - hc
		var d := away.length() * k
		var p := CLEAR_M + SOFT_M * 0.5 - d
		if p <= 0.0:
			continue
		var push := (p * p / (2.0 * SOFT_M) if p < SOFT_M else p - SOFT_M * 0.5)
		var dir := away.normalized() if away.length() > 1e-5 else Vector3.UP
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var l1 := s.distance_to(g_la.origin)
		var l2 := g_la.origin.distance_to(g_hd.origin)
		PunchReach.solve(skel, ids, s, g_hd.origin + dir * push / k, l1, l2, g_hd.basis)
		pushes += 1
	if not clash_late:
		clash_pass()


## S468: the arms off each other, and her arms as shown for the other boxer. Run LAST of the arm layers (ArmClash, after
## ElbowClear): mid-stack, ElbowClear then moved her elbows 2-18 cm (tools/clash_meter.gd `drift`), and the glove's long
## axis follows the forearm, so a glove just cleared swung back into the other's. `clash_late` false = run here, mid-stack
## (the S465 place: `-- ballclash`, and any body built without ArmClash).
func clash_pass() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	var k := skel.global_transform.basis.get_scale().x
	_clear_own(skel, k)   # S477 OWNGLOVE1: her own two gloves stay out of each other; S478: BEFORE the other boxer's arms, which get the last word
	if clash and peer != null and is_instance_valid(peer):
		if dbg_on:
			dbg = "late %s" % str(int(peer.shown_f) != Engine.get_process_frames())
		# S478: the other boxer's arms and her own settle together - each push can put a glove back into the other's (seed 4242
		# 08_jab f40: her own pass after the clash left two guard gloves 5.4 cm deep), so the pair runs OWN_ROUNDS times.
		for r in OWN_ROUNDS:
			for side in _arms:
				var rank := _rank(side)
				if dbg_on and r == 0:
					dbg += " | %s r%d before %.3f" % [side, rank, _deepest(skel, _arms[side], k)]
				if rank < (1 if BALLS else 2):   # a live punch's glove is PunchReach's; the other boxer's hands move off it
					_clear_arms(skel, _arms[side], k, rank)
				if dbg_on and r == OWN_ROUNDS - 1:
					dbg += " after %.3f" % _deepest(skel, _arms[side], k)
			_clear_own(skel, k)   # and her own gloves again, so the other boxer's push never leaves them in each other
	for side in _arms:
		var ids: Array = _arms[side]
		var elbow: Vector3 = skel.global_transform * skel.get_bone_global_pose(int(ids[1])).origin
		var wrist: Vector3 = skel.global_transform * skel.get_bone_global_pose(int(ids[2])).origin
		var was: Array = shown_arms.get(side, [])
		var fresh := was.size() == 8 and shown_f == Engine.get_process_frames() - 1
		var rank := _rank(side)
		shown_arms[side] = [elbow, wrist, (wrist - elbow).normalized(), rank, k,
			elbow - (was[0] as Vector3) if fresh else Vector3.ZERO, wrist - (was[1] as Vector3) if fresh else Vector3.ZERO,
			0 if rank < 2 else (1 if float(reach.get("_thru")) > 0.0 else (0 if bool(reach.get("_height_only")) or not _block_up() else 2))]
			# ^ a live punch's kind: 1 it LANDS (her arm opens outward off it), 2 it is BLOCKED (FightStage.arm_block: the
			#   catching glove is meant to meet it - BlockCatch's job; pushed off it with the true glove shape the catch ended
			#   9 cm under her face, block_meet GY), 0 anything else (a miss passes her: she moves off it as off any hand)
	shown_f = Engine.get_process_frames()


## S478 CLASH3: a blocked punch is BlockCatch's to meet only once her catch is rising (BlockCatch.RISE_S before its contact,
## on the punch's own clip). Before that - a blocked rear hook armed on the hand still coming home from a landed cross,
## seed 77's 08_cross f27-f29, 10 cm inside her guard glove - she moves off it as off any hand.
func _block_up() -> bool:
	var rap: AnimationPlayer = reach.get("ap")
	return rap == null or float(reach.get("_contact")) - rap.current_animation_position <= BlockCatch.RISE_S


## Probe (dbg_on): how deep this arm is in the other's arms by this modifier's own shapes and read (no squish, no knee).
var dbg_on := false
var dbg := ""
func _deepest(skel: Skeleton3D, ids: Array, k: float) -> float:
	var to_w := skel.global_transform
	var elbow: Vector3 = to_w * skel.get_bone_global_pose(int(ids[1])).origin
	var wrist: Vector3 = to_w * skel.get_bone_global_pose(int(ids[2])).origin
	var along := (wrist - elbow).normalized()
	var out := -9.0
	for arm in (peer.shown_arms as Dictionary).values():
		var pk := float(arm[4])
		var late := int(peer.shown_f) != Engine.get_process_frames()
		var pe: Vector3 = (arm[0] as Vector3) + ((arm[5] as Vector3) if late else Vector3.ZERO)
		var pw: Vector3 = (arm[1] as Vector3) + ((arm[6] as Vector3) if late else Vector3.ZERO)
		var pa := (pw - pe).normalized()
		for m in [[wrist + along * GLOVE_AT.x * k, wrist + along * GLOVE_AT.y * k, GLOVE_R * k], [elbow, wrist, FORE_R * k]]:
			for t in [[pw + pa * GLOVE_AT.x * pk, pw + pa * GLOVE_AT.y * pk, GLOVE_R * pk], [pe, pw, FORE_R * pk]]:
				var pts := Geometry3D.get_closest_points_between_segments(m[0], m[1], t[0], t[1])
				out = maxf(out, float(m[2]) + float(t[2]) - (pts[0] as Vector3).distance_to(pts[1]))
	return out


## The hand's right of way (see LIVE_S): 2 a live punch, 1 going home, 0 a guard hand.
func _rank(side: String) -> int:
	if reach == null:
		return 0
	var hand := side + "Hand"
	if str(reach.get("_clip")) != "" and str(reach.get("_hand")) == hand:
		var rap: AnimationPlayer = reach.get("ap")
		return 2 if rap == null or rap.current_animation_position <= float(reach.get("_contact")) + LIVE_S else 1
	return 1 if (reach.get("_fades") as Dictionary).has(hand) else 0


## S465 C389, S468 C394: her glove and forearm off the other's gloves and forearms (the shapes above). The deepest overlap
## wins; she moves out of her share of it (soft knee as for heads; all of it when the other hand outranks hers) and the arm
## is re-solved with the hand's rotation kept (the wrist moves; the arm turns about the shoulder with it).
func _clear_arms(skel: Skeleton3D, ids: Array, k: float, rank: int) -> void:
	var to_w := skel.global_transform
	for n in CLASH_PASSES:
		var g_la: Transform3D = skel.get_bone_global_pose(int(ids[1]))
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var elbow: Vector3 = to_w * g_la.origin
		var wrist: Vector3 = to_w * g_hd.origin
		var along := (wrist - elbow).normalized()
		var mine := [[wrist + along * GLOVE_AT.x * k, wrist + along * GLOVE_AT.y * k, GLOVE_R * k, 1.0], [elbow, wrist, FORE_R * k, 0.0]]
		var best := 0.0     # the push wanted, metres
		var dir := Vector3.ZERO
		var at := 1.0       # where on her arm the touch is: 1 = the glove or the wrist, 0 = the elbow
		var live := false   # the touch is the hand of a punch that lands
		for arm in (peer.shown_arms as Dictionary).values():
			var prank := int(arm[3])
			if (prank < rank or int(arm[7]) == 2) and not BALLS:
				continue   # that hand moves off hers; a blocked punch is the block's to meet
			var pk := float(arm[4])
			var late := not BALLS and int(peer.shown_f) != Engine.get_process_frames()
			var pe: Vector3 = (arm[0] as Vector3) + ((arm[5] as Vector3) if late else Vector3.ZERO)
			var pw: Vector3 = (arm[1] as Vector3) + ((arm[6] as Vector3) if late else Vector3.ZERO)
			var pa := (pw - pe).normalized()
			# Equals share it: the boxer drawn first moves ARM_SHARE of it off arms a frame old; the one drawn second sees the
			# other's arms as they are drawn this frame and takes what is left.
			var own := 1.0 if prank > rank or not late else ARM_SHARE
			var theirs := [[pw + pa * GLOVE_AT.x * pk, pw + pa * GLOVE_AT.y * pk, GLOVE_R * pk], [pe, pw, FORE_R * pk]]
			for m in mine:
				if BALLS and float(m[3]) == 0.0:
					continue   # the S465 rule: her glove only
				for t in theirs:
					var pts := Geometry3D.get_closest_points_between_segments(m[0], m[1], t[0], t[1])
					var gap: Vector3 = pts[0] - pts[1]
					var p := float(m[2]) + float(t[2]) - SQUISH_M + SOFT_M * 0.5 - gap.length()
					if p <= 0.0:
						continue
					var push := (p * p / (2.0 * SOFT_M) if p < SOFT_M else p - SOFT_M * 0.5) * own
					if push > best:
						best = push
						live = int(arm[7]) == 1
						dir = gap if gap.length() > 1e-4 else (wrist + along * GLOVE_FWD_M * k) - pw
						var seg: Vector3 = (m[1] as Vector3) - (m[0] as Vector3)
						at = 1.0 if float(m[3]) == 1.0 else clampf(((pts[0] as Vector3) - (m[0] as Vector3)).dot(seg) / maxf(seg.length_squared(), 1e-8), 0.0, 1.0)
		if best <= 0.0 or dir.length() < 1e-5:
			return
		# The wrist's move turns the whole arm about the shoulder: a point on the forearm follows by about half (at the elbow)
		# to all (at the wrist) of it, so a touch there asks the wrist for that much more.
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		# ... and she draws the hand in toward her own shoulder as she moves it aside (RETRACT of the push, none once the
		# glove is TUCK_M.x from the shoulder: it would go into her own face). clashdbg on the film: her long-guard glove sat
		# BETWEEN the other's two gloves, a gap narrower than a glove, so pushing off one pushed into the other and the
		# overlap never fell (0.066 -> 0.052, 0.059 -> 0.064 m); drawing the arm in is the way out of a pinch, and what a
		# boxer does when crowded.
		var aside := (to_w.affine_inverse().basis * dir).normalized()
		if live:
			# Off a live punch her arm opens OUTWARD, away from her own middle (a punch that lands came up or through the
			# middle of her guard; the film's freeze frames had the uppercut's glove at her chin 7-8 cm inside her forearm,
			# her arm pinned between it and the other's guard hand with no room to draw in).
			# S476 CLASH3: the outward part goes only ACROSS the push, never against it. (aside + out).normalized() cancelled
			# the push when "outward" pointed back at the punch: seed 4242's rear uppercut, her guard glove 9.5 cm inside it,
			# 4 passes took it to 6.2 cm (clash_meter 6.5 cm, the frame after the hit).
			for sd in _arms:
				if _arms[sd] != ids:
					var out_l: Vector3 = (s - skel.get_bone_global_pose(int(_arms[sd][0])).origin).normalized()
					aside = aside + (out_l - aside * out_l.dot(aside)) * OPEN_SIDE
		var back := s - g_hd.origin
		var room := clampf((back.length() * k - TUCK_M.x) / (TUCK_M.y - TUCK_M.x), 0.0, 1.0)
		var move := (aside + back.normalized() * RETRACT * room) * minf(best / lerpf(0.5, 1.0, at), PUSH_MAX_M) / k
		PunchReach.solve(skel, ids, s, g_hd.origin + move, s.distance_to(g_la.origin), g_la.origin.distance_to(g_hd.origin), g_hd.basis)
		if n == 0:
			clash_pushes += 1


## S477 OWNGLOVE1: a boxer's own two gloves stay out of each other in the guard and its fidgets (no punches thrown).
## After the cross-boxer clearance, check her own arms for overlap. When they overlap by more than the 2 cm give (SQUISH_M),
## move the hand with the lower rank out of the overlap; equal ranks: the rear hand moves (orthodox Right, southpaw Left).
## Move along the gap between the two gloves (sideways, away from the other), re-solve with PunchReach.solve keeping the
## hand's rotation, CLASH_PASSES passes, PUSH_MAX_M per pass. Keep the hand off her own face (TUCK_M, as _clear_arms does).
func _clear_own(skel: Skeleton3D, k: float) -> void:
	var to_w := skel.global_transform
	var rear := _rear_side(skel)
	for n in CLASH_PASSES:
		var arm_data := {}
		for side in _arms:
			var ids: Array = _arms[side]
			var g_la: Transform3D = skel.get_bone_global_pose(int(ids[1]))
			var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
			var elbow: Vector3 = to_w * g_la.origin
			var wrist: Vector3 = to_w * g_hd.origin
			var along := (wrist - elbow).normalized()
			arm_data[side] = {"ids": ids, "elbow": elbow, "wrist": wrist, "along": along,
				"glove": [wrist + along * GLOVE_AT.x * k, wrist + along * GLOVE_AT.y * k, GLOVE_R * k],
				"fore": [elbow, wrist, FORE_R * k], "rank": _rank(side), "is_rear": side == rear,
				"la": g_la, "hd": g_hd}
		var sides := arm_data.keys()
		if sides.size() < 2:
			return
		var a0: Dictionary = arm_data[sides[0]]
		var a1: Dictionary = arm_data[sides[1]]
		var best := 0.0
		var move_side := ""
		var dir := Vector3.ZERO
		var at := 1.0
		for pair in [["glove", "glove"], ["glove", "fore"], ["fore", "glove"]]:
			var m: Array = a0[pair[0]]
			var t: Array = a1[pair[1]]
			var pts := Geometry3D.get_closest_points_between_segments(m[0], m[1], t[0], t[1])
			var gap: Vector3 = pts[0] - pts[1]
			var p := float(m[2]) + float(t[2]) - SQUISH_M + SOFT_M * 0.5 - gap.length()
			if p <= 0.0:
				continue
			var push := p * p / (2.0 * SOFT_M) if p < SOFT_M else p - SOFT_M * 0.5
			if push <= best:
				continue
			best = push
			dir = gap if gap.length() > 1e-4 else (a0["wrist"] + a0["along"] * GLOVE_FWD_M * k) - a1["wrist"]
			var r0 := int(a0["rank"])
			var r1 := int(a1["rank"])
			if r0 < r1:
				move_side = sides[0]
			elif r1 < r0:
				move_side = sides[1]
			else:
				move_side = sides[0] if bool(a0["is_rear"]) else sides[1]
			var seg: Vector3 = (m[1] as Vector3) - (m[0] as Vector3)
			at = 1.0 if pair[0] == "glove" else clampf(((pts[0] as Vector3) - (m[0] as Vector3)).dot(seg) / maxf(seg.length_squared(), 1e-8), 0.0, 1.0)
		if best <= 0.0 or dir.length() < 1e-5 or move_side == "":
			return
		var arm: Dictionary = arm_data[move_side]
		var ids: Array = arm["ids"]
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var g_hd: Transform3D = arm["hd"]
		# The gap points from a1 to a0; if moving a1, negate it (push away from a0)
		var push_dir := dir if move_side == sides[0] else -dir
		var aside := (to_w.affine_inverse().basis * push_dir).normalized()
		var back := s - g_hd.origin
		var room := clampf((back.length() * k - TUCK_M.x) / (TUCK_M.y - TUCK_M.x), 0.0, 1.0)
		var move := (aside + back.normalized() * RETRACT * room) * minf(best / lerpf(0.5, 1.0, at), PUSH_MAX_M) / k
		PunchReach.solve(skel, ids, s, g_hd.origin + move, s.distance_to(arm["la"].origin), arm["la"].origin.distance_to(g_hd.origin), g_hd.basis)


## The rear hand's side: orthodox = Right, southpaw = Left. Read from BoxerFootworkRig's plan if present (the way
## BoxerFootwork does); fallback: the hand further back in skeleton space (the rear hand guards the face, the lead extends).
func _rear_side(skel: Skeleton3D) -> String:
	for child in skel.get_children():
		var plan = child.get("plan") if child != null else null
		if plan != null:
			var side = plan.get("side") if plan is Object else null
			if side != null and float(side) < 0.0:
				return "Left"
			if side != null:
				return "Right"
	var left_w := skel.get_bone_global_pose(int(_arms["Left"][2])).origin
	var right_w := skel.get_bone_global_pose(int(_arms["Right"][2])).origin
	return "Left" if left_w.z > right_w.z else "Right"


## S498 (HeadClear.gd, the fight week's "heads overlap inside"): the lean out of the other's head worked out from both
## heads as the clips put them (true centres, half each, sideways as much as back), eased so it never pops.
func _lean_head(skel: Skeleton3D, to_me: Transform3D, oc: Vector3, k: float) -> void:
	var g := skel.get_bone_global_pose(_head)
	var c := g.origin + g.basis.orthonormalized() * _up_rest * HEAD_UP_M / k
	var f := Engine.get_process_frames()
	if f != _lean_frame:   # the stack can run twice in a frame (a hit's forced update): one step of the ease a frame
		_lean_frame = f
		var dt := get_process_delta_time()
		var pg: Node = peer if peer != null and is_instance_valid(peer) else null
		var his: Vector3 = pg.raw_head if pg != null and (pg.raw_head as Vector3).is_finite() else oc
		var oh := other.find_bone("Hips")
		var his_hips: Vector3 = other.global_transform * other.get_bone_global_pose(oh).origin if oh >= 0 else his
		var here := skel.global_transform * c
		var my_hips: Vector3 = skel.global_transform * skel.get_bone_global_pose(_hips).origin if _hips >= 0 else here
		# A body punch's thrower dips his head to his side from the start of the clip; what she reads is his dipped head.
		var low: bool = reach != null and is_instance_valid(reach) and reach.get("ap") != null and HeadClear.low_punch(str(reach.ap.current_animation))
		var d: Dictionary = HeadClear.dip(here, his, my_hips, his_hips, _dip_side) if low else {"push": Vector3.ZERO, "side": 0}
		_dip = HeadClear.ease(_dip, d["push"], dt, HeadClear.DIP_MPS, HeadClear.DIP_MPS)
		_dip_side = int(d["side"]) if low else (_dip_side if _dip.length() > 0.005 else 0)
		raw_head = here + _dip
		var touch := maxf(head_touch_m, lerpf(HeadClear.TOUCH_M, head_touch_m, tie))
		var seed := _lean_side if _lean_side != 0 else _dip_side   # her side: her own, her dip's, else the other's
		if seed == 0 and pg != null:
			seed = int(pg._lean_side) if int(pg._lean_side) != 0 else int(pg._dip_side)
		var w: Dictionary = HeadClear.want(raw_head, his, my_hips, his_hips, touch, seed,
				HeadClear.shares(_held(reach), _held(pg.reach if pg != null else null)))
		if int(w["side"]) != 0:
			_lean_side = int(w["side"])
		elif _lean.length() < 0.005:
			_lean_side = 0
		_lean = HeadClear.ease(_lean, w["push"], dt)
		if HeadClear.trace and ((w["push"] as Vector3).length() > 0.0 or _lean.length() > 0.0 or _dip.length() > 0.0):
			print("HEADTRACE f=%d %s raw=%.3f want=%s lean=%s side=%d dip=%s low=%s" % [f, skel.get_parent().name, raw_head.distance_to(his), w["push"], _lean, _lean_side, _dip, low])
	if (_lean + _dip).length() < 1e-4:
		return
	HeadClear.lean(skel, [_spine, _chest], c, to_me.basis * (_lean + _dip))
	head_pushes += 1


## The strongest hold a boxer's landing reach has on a glove now, 0-1 (PunchReach.held).
static func _held(r) -> float:
	var out := 0.0
	if r != null and is_instance_valid(r):
		for w in (r.held() as Dictionary).values():
			out = maxf(out, float(w))
	return out


## S316: heads touch up close (temple to temple, a head on a shoulder) but never pass through each other - inside_guard_probe
## measured 8 of 571 inside frames with the head centres under 0.16 m (the closest 0.026 m: a gut shot's fold into a cross).
## Her trunk leans back from the other head by HEAD_SHARE of the overlap (both boxers do it, so the pair clears it), half on
## the spine, half on the chest, in the horizontal plane only. `-- noheads` = the control arm.
func _clear_head(skel: Skeleton3D, hc: Vector3, k: float) -> void:
	var c := _centre(skel, k)
	var away := c - hc
	away.y = 0.0
	var d := (c - hc).length() * k
	if d >= head_touch_m or away.length() < 1e-5:
		return
	var dir := away.normalized()
	# Horizontal only: the gap that makes the 3D distance the touch, given the heads' height difference (a gut shot's fold
	# drops one head well below the other).
	var v := absf((c - hc).y) * k
	var h := away.length() * k
	var push := (sqrt(maxf(head_touch_m * head_touch_m - v * v, 0.0)) - h) * HEAD_SHARE / k
	if push <= 0.0:
		return
	for b in [_spine, _chest]:
		var g: Transform3D = skel.get_bone_global_pose(b)
		var arm := c - g.origin
		var axis := arm.cross(dir)
		if axis.length() < 1e-5 or arm.length() < 1e-3:
			continue
		var q := Quaternion(axis.normalized(), 0.5 * push / arm.length())
		skel.set_bone_global_pose(b, Transform3D(Basis(q) * g.basis, g.origin))
		c = g.origin + q * arm
	head_pushes += 1
