extends SkeletonModifier3D
## S302 (operator on the S301 film: "the guard looks fake"). tools/punch_reach.gd measured the Pro guard (pro_idle) on our
## bodies: the wrists hang 0.22 m in front of the face, the gloves out at arm's length (John J-GUARDPACE1: gloves ~0.10-0.20 m
## in front of the face, chin tucked, small hand pumps). While she stands in her guard, each wrist is drawn back toward
## her face (S316: to the GUARD point) and pumps a little (lead more than rear), the arm re-solved as a
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
## S506 FREEHAND (blind r11, both critics' first change: the rear hand "keeps falling to the belt"; "while one arm punches,
## hold the other glove within 8 cm of the chin"). While a punch clip plays, the hand that is NOT punching is held at its
## own guard point the same way (GUARD / the inside guard, the two-bone chain, the hand keeping its rotation) at FREE_W; a
## body shot at FREE_BODY_W (the free glove may sag to cover the ribs). `free_drop` + `free_drop_clip` (BeatFire, from
## the beat's after fact right_low / left_low, which the drops-the-right habit raises): that punch lets its free hand go
## and the clip's own drop shows - the film log and the picture agree. Ruler: tools/free_hand_probe.gd. `-- nofreehand`.
##   free_drop  free_drop_clip   free_hand() -> the hand held now ("" when none)

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FREE_W := 0.9
const FREE_BODY_W := 0.5
## In fast (the punch's first frames are the guard leaving), out slower than the guard eases back in, so the glove
## handed from this hold to the guard's never dips at the crossover.
const FREE_IN_S := 0.12
const FREE_OUT_S := 0.45
## S510 (owner on the r13 sheets, ex5 #25-36 and ex3 #17-24: "wtf is the right hand of blue fighter doing"; r11 and r12
## critics: "the free glove straight up above his head"): the free hold put the WRIST on the guard point, 3-4 cm under the
## head bone - which sits at eye height, not at the chin - with the forearm upright, so the 19 cm of glove over the wrist
## stood over his forehead to the top of his head (the same height in r12 and r13: -0.01 .. -0.04 m, forearm 0.9-1.0 up).
## While a punch plays the free wrist is held FREE_DROP_M lower (the chin's height: the glove covers the cheek, its top
## at the brow) and FREE_BACK_M nearer the face; the standing guard is not changed. `-- nofreedrop` = the control arm.
const FREE_DROP_M := 0.11
const FREE_BACK_M := 0.03
static var FREE_DROP: bool = not OS.get_cmdline_user_args().has("nofreedrop")
## The same words as scripts/rules/PunchEnd.gd / FreeHand.gd (copied: the rules modules stay preload-free).
const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot"]
const EXCLUDE_WORDS := ["hit_by", "dodge", "weave", "idle"]

## S317 smoothness (tools/smooth_probe.gd raw baseline: the tuck added 77 of our 676 kinks a minute, most on pro_idle):
## a wrist moves ~0.2 m between the clip's guard and GUARD; over 0.15 s that is ~50 m/s^2 (the probe's kink is 18). Over
## EASE_S 0.3 it is ~13 - the guard settles, it does not snap.
const EASE_S := 0.3
## Hand pumps: metres along her forward axis, cycles a second.
const PUMP_M := {"lead": 0.035, "rear": 0.015}
const PUMP_HZ := 1.3
## The face, from the head bone (FightStage.FACE_FWD_M / FACE_UP_M).
const FACE_FWD_M := 0.09
const FACE_UP_M := 0.07

## S316 (operator on the update 18 build, a still at long range: "this guard is so wrong", "bad"): the S313 low guard put
## the wrists 0.31 m under the head bone and 0.12 m apart - gloves crossed at the chest, elbows flared (inside_guard_probe
## "rest"). Now the guard is one place at every range: each wrist on its own side of the face, the rear glove at the cheek,
## the lead out in front at chin height (forward, out to her side, up - metres from the head bone; the face is FACE_FWD_M
## in front of it, the chin ~0.08 forward and ~0.02 down), elbows bent down and in. At long range only the lead drops a
## few cm (LOW_M) - the real guard's lead sags there, the gloves never meet.
const GUARD := {"lead": Vector3(0.26, 0.07, -0.04), "rear": Vector3(0.14, 0.10, -0.03)}
const ELBOW_IN := 0.5
const LOW_M := {"lead": 0.05, "rear": 0.0}
const LOW_UP_S := 0.15
const LOW_DOWN_S := 0.6

var low := 0.0        # wanted: 1 = the long-range guard (set every frame by Footwork.aim)
var inner := 0.0      # 1 = the inside guard (set every frame by FightStage from Footwork.inside_w)
## S322 the body is the track: 0..1 per glove from its own shoulder's Burn (BodyBurn, BodyLoad.part_effect). A tired
## boxer's hands sink: at 1 the glove sits at her chest, not her face (half that up close, where she keeps them at the
## cheeks longer).
var tired := {"lead": 0.0, "rear": 0.0}
## S322 burn_probe: 0.22 put the jab glove 0.16-0.18 m under her face late in round 3 (at the chest); a tired boxer's
## lead sags to shoulder / top-of-chest height: 0.14 (~0.11 m at the round-3 reading).
## S323 (operator on update 25, Q-S294-41 "Too little / can't see it": 0.10 m read as nothing from the broadcast camera): the
## spent jab hand hangs at the belly, the rear at the chest - and TiredSag folds the trunk under them.
const TIRED_DROP_M := {"lead": 0.30, "rear": 0.20}
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
var free_drop := ""        # the hand a beat lets drop on its punch (LeftHand / RightHand), "" = held
var free_drop_clip := ""   # the punch clip that drop belongs to
var _fw := 0.0
var _free := ""
var _free_clip := ""
var _free_want := 0.0
var _free_on := true


func setup(skel: Skeleton3D, player: AnimationPlayer, body_node: Node3D, guard_clips: Array, seed: int) -> bool:
	ap = player
	body = body_node
	guards = guard_clips
	_phase = float(seed % 97) * 0.37
	_head = skel.find_bone("Head")
	_sh = [skel.find_bone("LeftUpperArm"), skel.find_bone("RightUpperArm")]
	_free_on = not OS.get_cmdline_user_args().has("nofreehand")
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
	var clip := str(ap.assigned_animation)
	var want := 1.0 if guards.has(clip) else 0.0
	_w = move_toward(_w, want, dt / EASE_S)
	if _free_on and clip != _free_clip:
		_free_clip = clip
		var fh := free_of(clip, lead)
		if fh != "":
			_free = fh
			_free_want = 0.0 if (clip == free_drop_clip and free_drop == fh) else (FREE_BODY_W if clip.contains("body") else FREE_W)
		else:
			_free_want = 0.0
	_fw = move_toward(_fw, _free_want, dt / (FREE_IN_S if _free_want > _fw else FREE_OUT_S))
	if _w <= 0.0 and _fw <= 0.0:
		return
	_low = move_toward(_low, low, dt / (LOW_UP_S if low < _low else LOW_DOWN_S))
	var lw := _low * _low * (3.0 - 2.0 * _low)
	var e := _w * _w * (3.0 - 2.0 * _w)
	var fwd := (skel.global_transform.basis.inverse() * body.global_transform.basis.z)
	fwd.y = 0.0
	fwd = fwd.normalized()
	var head: Vector3 = skel.get_bone_global_pose(_head).origin
	# Skeleton space is scaled with her height: the guard points are world metres.
	var k := skel.global_transform.basis.get_scale().x
	var ef := _fw * _fw * (3.0 - 2.0 * _fw)
	var iw := inner * inner * (3.0 - 2.0 * inner)   # S506: the inside share alone (was times e, divided back out below)
	var left := skel.get_bone_global_pose(int(_sh[0])).origin - skel.get_bone_global_pose(int(_sh[1])).origin
	left.y = 0.0
	left = left.normalized() if left.length() > 1e-4 else fwd.cross(Vector3.UP)
	for hand in _arms:
		var ids: Array = _arms[hand]
		# S506: the free hand during a punch takes the stronger of the guard's ease and the free hold.
		var eh := maxf(e, ef) if hand == _free else e
		if eh <= 0.0:
			continue
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var role := "lead" if hand == lead else "rear"
		var pump := float(PUMP_M[role]) * sin(TAU * PUMP_HZ * _t + _phase + (0.0 if hand == "LeftHand" else 2.1)) * e / eh
		var out := left if hand == "LeftHand" else -left
		# S316 one guard at every range: her own wrist point from the head bone (GUARD), the lead a little lower at long
		# range, the inside guard up close; the clip's own guard only shows through the ease in and out.
		var gp: Vector3 = GUARD[role] / k
		var to := head + fwd * (gp.x + pump / k) + out * gp.y + Vector3.UP * (gp.z - float(LOW_M[role]) * lw / k)
		if iw > 0.0:
			to = to.lerp(head + (fwd * (IN_FWD_M + pump * 0.5) + out * IN_SIDE_M + Vector3.UP * IN_UP_M) / k, iw)
		to += Vector3.DOWN * float(TIRED_DROP_M[role]) * float(tired[role]) * (1.0 - 0.5 * iw) / k
		if FREE_DROP and hand == _free and ef > 0.0:
			to += (Vector3.DOWN * FREE_DROP_M - fwd * FREE_BACK_M) * ef / k
		to = g_hd.origin.lerp(to, eh)
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var l1 := s.distance_to(skel.get_bone_global_pose(int(ids[1])).origin)
		var l2 := skel.get_bone_global_pose(int(ids[1])).origin.distance_to(g_hd.origin)
		var pole := (Vector3.DOWN - out * lerpf(ELBOW_IN, IN_ELBOW_IN, iw)).normalized()
		PunchReach.solve(skel, ids, s, to, l1, l2, g_hd.basis, pole, eh)


## The hand held now by the free hold ("" when none).
func free_hand() -> String:
	return _free if _fw > 0.0 else ""


## S506: the hand that is NOT punching in `clip` ("" when the clip is no punch). Its punching hand is the clip's own (the
## measured contact row, else left_ / jab = the left), mirrored for a southpaw (her lead is the right).
static func free_of(clip: String, lead_hand: String) -> String:
	var hit := false
	for w in PUNCH_WORDS:
		hit = hit or clip.contains(w)
	for w in EXCLUDE_WORDS:
		hit = hit and not clip.contains(w)
	if not hit:
		return ""
	var orth := str(BeatClips.contact_row(clip).get("hand", "LeftHand" if clip.contains("left_") or clip.contains("jab") else "RightHand"))
	var punching := orth if lead_hand == "LeftHand" else ("RightHand" if orth == "LeftHand" else "LeftHand")
	return "RightHand" if punching == "LeftHand" else "LeftHand"
