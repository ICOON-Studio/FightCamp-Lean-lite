extends SceneTree
## BLOCKLOOK2: a block is a guard that catches the punch. Blocked head punches are played through BeatFire.fire itself
## (the fight's own block branch: the beat, the guard wait, go(), the block), the stage at 60 frames a second, the pair
## stood at the stage's own gap (tests/ruler_stand.gd). The blocker's DRAWN skeleton (after every modifier) is read on
## Skeleton3D.skeleton_updated each frame; the row is read on the first frame the punch's clip is at its contact (one frame
## short counts, as tests/block_set_test.gd).
## Pairs: A=mh_boxer_10, B=mh_boxer_12, setups A_B and B_A (puncher_blocker). Punches: pro_left_jab, pro_right_cross,
## pro_left_hook, pro_right_hook. Bars per row:
##   UPRIGHT  the chest (Chest -> Neck) leans at most 12 deg further from vertical than in the guard one frame before the
##            block starts, and the Head bone drops at most 0.06 m.
##   CATCH    the catching glove - the REAR glove for the jab and the lead hook, the LEAD glove for the cross and the rear
##            hook - is between the punch and the face (block_meet's definition), its centre 0.06-0.14 m in front of the
##            face point and -0.08..+0.06 m of its height; the other glove moves at most 0.05 m from its guard (read in her
##            chest's frame: GuardWeave's own wander of the trunk is the guard, not the glove leaving it; world move printed).
##   MEETS    block_meet's touch bar (glove front to catching glove surface <= 0.04 m, not > 0.03 m inside) at the frame the
##            front is nearest that glove within 0.10 s before / 0.05 s after contact, and the front stays >= 0.08 m off
##            the face.
##   OVERHEAD no hand bone more than 0.03 m above the Head bone at any frame of the block.
##   WRIST    the elbow-to-wrist distance changes at most 0.01 m during the block.
## The block "starts" on the first frame the blocker plays a block clip or her BlockCatch has weight; it lasts until both
## are gone again (at most CONTACT + 0.6 s). 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/block_catch_test.gd   [-- trace: frames around contact]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const Stand := preload("res://tests/ruler_stand.gd")

const HZ := 60.0
const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const CLIPS := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook"]
const MOVE_MAP := {"pro_left_jab": "jab", "pro_right_cross": "cross", "pro_left_hook": "lead_hook", "pro_right_hook": "rear_hook"}
const LEAN_BAR := 12.0
const DROP_BAR := 0.06
const FWD_LO := 0.06
const FWD_HI := 0.14
const GY_LO := -0.08
const GY_HI := 0.06
const OTHER_BAR := 0.05
const TOUCH_HI := 0.04
const INSIDE_BAR := 0.03
const FACE_BAR := 0.08
const OVER_HEAD_BAR := 0.03
const WRIST_BAR := 0.01
const GLOVE_RADIUS := 0.04
const BETWEEN_TOL := 0.15
const SCAN_BEFORE := 0.10
const SCAN_AFTER := 0.05


class FakeBody extends RefCounted:
	func land(_b: Dictionary, _at: float) -> void:
		pass


class FakeView extends Node:
	var stage: Node3D
	var _amb_rng := RandomNumberGenerator.new()
	var t := 0.0
	var _profiles := {}
	var body := FakeBody.new()


var failures := 0
var st: Node3D
var _drawn := {}      # the blocker's last drawn pose readings
var _pdrawn := {}     # the puncher's


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _bw(skel: Skeleton3D, bone: String) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin


func _on_blocker_drawn() -> void:
	var skel: Skeleton3D = st.boxers[1]["skel"]
	var cx: Transform3D = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Chest"))
	var chest := cx.origin
	var neck := _bw(skel, "Neck")
	var d := {"lean": rad_to_deg((neck - chest).normalized().angle_to(Vector3.UP)), "head": _bw(skel, "Head"),
		"face": st.target_point(1, false), "hips": _bw(skel, "Hips")}
	for s in ["Left", "Right"]:
		d[s] = _bw(skel, s + "Hand")
		d[s + "_wr"] = _bw(skel, s + "LowerArm").distance_to(d[s])
		d[s + "_in"] = cx.affine_inverse() * d[s]   # in her chest's frame: where the glove sits in her guard
	_drawn = d


func _on_puncher_drawn() -> void:
	var skel: Skeleton3D = st.boxers[0]["skel"]
	_pdrawn = {"LeftUpperArm": _bw(skel, "LeftUpperArm"), "RightUpperArm": _bw(skel, "RightUpperArm")}


func _seed_for(move: String, clip: String) -> int:
	for s in 400:
		var r := RandomNumberGenerator.new()
		r.seed = s
		var ctx := {"big": false, "miss": false, "tired": false, "step": false, "roll": r.randf()}
		if BeatClips.punch(move, ctx, st.has_move) == clip:
			return s
	return -1


func _point_line_dist(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab := b - a
	if ab.length_squared() < 1e-10:
		return p.distance_to(a)
	var tt := clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
	return p.distance_to(a + ab * tt)


func _blocking() -> bool:
	var c: Node = st.boxers[1].get("block_catch")
	return str((st.boxers[1]["ap"] as AnimationPlayer).current_animation).contains("block") or (c != null and float(c.get("w")) > 0.0)


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	print("BLOCK_CATCH")
	await _run_setup(BOXER_A, BOXER_B, "A_B")
	await _run_setup(BOXER_B, BOXER_A, "B_A")
	print("BLOCK_CATCH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _run_setup(glb_0: String, glb_1: String, setup: String) -> void:
	st = Stage.new()
	root.add_child(st)
	st.set_process(false)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb_0, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % glb_1, "corner": "blue"})
	st.set_process(true)
	for i in 10:
		await process_frame
	(st.boxers[1]["skel"] as Skeleton3D).skeleton_updated.connect(_on_blocker_drawn)
	(st.boxers[0]["skel"] as Skeleton3D).skeleton_updated.connect(_on_puncher_drawn)
	Engine.max_fps = 30   # ruler_stand's settle counts are 30 Hz frames
	var opened: bool = await Stand.open(st, self)
	Engine.max_fps = int(HZ)
	if not opened:
		_check(false, "STAND %s: two stands of the same pair disagree" % setup)
	var v := FakeView.new()
	v.stage = st
	root.add_child(v)
	print("PAIR %s stand=%.3f south=%s/%s" % [setup, Stand.ref(st), str(st.boxers[0].get("south", false)), str(st.boxers[1].get("south", false))])
	for clip in CLIPS:
		await _row(v, setup, str(clip))
	v.queue_free()
	st.queue_free()
	await process_frame
	await process_frame


func _row(v: FakeView, setup: String, clip: String) -> void:
	var move: String = MOVE_MAP[clip]
	var tag := "%s %s" % [setup, clip]
	var sd := _seed_for(move, clip)
	if sd < 0:
		_check(false, "SKIP %s: no lone-punch roll picks it" % tag)
		return
	Engine.max_fps = 30
	var gap: float = await Stand.stand(st, self)
	Engine.max_fps = int(HZ)
	if not Stand.held(st, gap):
		_check(false, "VOID %s gap=%.3f, the stage's own gap is %.3f" % [tag, gap, Stand.ref(st)])
		return
	var sp := BeatClips.speed(clip, move)
	var c := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
	var orth := "LeftHand" if clip.contains("left") else "RightHand"
	var phand: String = st.hand_of(0, orth)
	# The catching glove: rear for the jab and the lead hook, lead for the cross and the rear hook.
	var catch_hand: String = st.hand_of(1, "RightHand" if move in ["jab", "lead_hook"] else "LeftHand")
	var other_hand := "Left" if catch_hand.begins_with("Right") else "Right"
	var cside := catch_hand.trim_suffix("Hand")
	var ap0: AnimationPlayer = st.boxers[0]["ap"]
	var fwd: Vector3 = (st.boxers[1]["node"] as Node3D).global_transform.basis.z
	fwd = Vector3(fwd.x, 0.0, fwd.z).normalized()
	v._amb_rng.seed = sd
	v.t = 0.0
	var bf := BeatFire.new()
	await process_frame
	await process_frame
	# Snapshot 0: the guard on the frame before the beat fires (a block set at once starts on the next frame).
	var snaps: Array = [{"d": _drawn.duplicate(), "p": _pdrawn.duplicate(), "gf": st.glove_front(0, phand), "on": _blocking(),
		"clip": false, "pos": -1.0}]
	bf.fire(v, {"who": "a", "move": move, "result": "blocked", "def": "block", "t": 0.0})
	var contact_i := -1
	for f in int(2.5 * HZ):
		await process_frame
		var gl: Node = st.boxers[0]["gloves"]
		var on_clip := str(ap0.current_animation) == clip
		snaps.append({"d": _drawn.duplicate(), "p": _pdrawn.duplicate(), "gf": st.glove_front(0, phand), "on": _blocking(),
			"clip": on_clip, "pos": ap0.current_animation_position if on_clip else -1.0})
		if contact_i < 0 and on_clip and ap0.current_animation_position >= c - sp / HZ - 1e-4:
			contact_i = snaps.size() - 1
		if contact_i >= 0 and snaps.size() - 1 > contact_i + int(0.6 * HZ):
			break
	if contact_i < 0:
		_check(false, "ROW %s: the punch never reached its contact" % tag)
		return
	var start := -1
	for i in snaps.size():
		if bool(snaps[i]["on"]):
			start = i
			break
	if start < 0 or start > contact_i:
		_check(false, "ROW %s: no block started before contact (start frame %d, contact frame %d)" % [tag, start, contact_i])
		return
	var ref: Dictionary = snaps[maxi(0, start - 1)]["d"]
	var end := snaps.size() - 1
	for i in range(contact_i, snaps.size()):
		if not bool(snaps[i]["on"]):
			end = i
			break
	var at: Dictionary = snaps[contact_i]["d"]
	# UPRIGHT
	var lean := float(at["lean"]) - float(ref["lean"])
	var drop := (ref["head"] as Vector3).y - (at["head"] as Vector3).y
	# CATCH (at the contact frame)
	var face: Vector3 = at["face"]
	var cg: Vector3 = at[cside]
	var fwd_m := (cg - face).dot(fwd)
	var gy := cg.y - face.y
	var gf: Vector3 = snaps[contact_i]["gf"]
	var sh: Vector3 = snaps[contact_i]["p"].get(phand.trim_suffix("Hand") + "UpperArm", Vector3.ZERO)
	var between := cg.distance_to(sh) < face.distance_to(sh) and _point_line_dist(cg, gf, face) < BETWEEN_TOL
	# The other glove "stays in guard": read in her chest's frame, so her guard's own weave (GuardWeave wanders the trunk
	# and hips a few cm between punches) is not counted as the glove leaving the guard. The world move is printed too.
	var other_move := (at[other_hand + "_in"] as Vector3).distance_to(ref[other_hand + "_in"])
	var other_world := (at[other_hand] as Vector3).distance_to(ref[other_hand])
	var side_m := (cg - face).dot(Vector3.UP.cross(fwd).normalized())
	# MEETS: the frame the front is nearest the catching glove in the scan window
	var best := 999.0
	var best_face := 999.0
	for i in range(maxi(0, contact_i - int(SCAN_BEFORE * HZ)), mini(snaps.size(), contact_i + int(SCAN_AFTER * HZ) + 1)):
		var di: Dictionary = snaps[i]["d"]
		var g: Vector3 = snaps[i]["gf"]
		var dd := g.distance_to(di[cside])
		if dd < best:
			best = dd
			best_face = g.distance_to(di["face"])
	var touch := best - GLOVE_RADIUS
	# OVERHEAD and WRIST over the block's frames
	var over := -9.0
	var wrist := 0.0
	for i in range(start, end + 1):
		var di: Dictionary = snaps[i]["d"]
		for s in ["Left", "Right"]:
			over = maxf(over, (di[s] as Vector3).y - (di["head"] as Vector3).y)
			wrist = maxf(wrist, absf(float(di[s + "_wr"]) - float(ref[s + "_wr"])))
	var hips_move := (at["hips"] as Vector3).distance_to(ref["hips"])
	if OS.get_cmdline_user_args().has("trace"):
		for i in range(maxi(0, contact_i - 12), mini(snaps.size(), contact_i + 6)):
			var di: Dictionary = snaps[i]["d"]
			var g: Vector3 = snaps[i]["gf"]
			print("  f%d pos=%.3f on=%s gf-catch=%.3f gf-face=%.3f gf_rel=%s gf-other=%.3f other_d=%.3f hips_d=%.3f" % [i, float(snaps[i]["pos"]), str(snaps[i]["on"]),
				g.distance_to(di[cside]), g.distance_to(di["face"]), str(g - (di["face"] as Vector3)), g.distance_to(di[other_hand]), (di[other_hand] as Vector3).distance_to(ref[other_hand]),
				(di["hips"] as Vector3).distance_to(ref["hips"])])
	print("ROW %s: hips_moved=%.3f lean=%+.1f deg head_drop=%.3f catch=%s fwd=%.3f gy=%+.3f between=%s other=%.3f (world %.3f) side=%+.3f touch=%+.3f to_face=%.3f over_head=%+.3f wrist=%.4f (block frames %d..%d, contact %d)" % [
		tag, hips_move, lean, drop, catch_hand, fwd_m, gy, "yes" if between else "no", other_move, other_world, side_m, touch, best_face, over, wrist, start, end, contact_i])
	_check(lean <= LEAN_BAR and drop <= DROP_BAR, "UPRIGHT %s: lean %+.1f deg (bar %.0f), head drop %.3f m (bar %.2f)" % [tag, lean, LEAN_BAR, drop, DROP_BAR])
	_check(between and fwd_m >= FWD_LO and fwd_m <= FWD_HI and gy >= GY_LO and gy <= GY_HI and other_move <= OTHER_BAR,
		"CATCH %s: %s between=%s, %.3f m in front (bar %.2f-%.2f), %+.3f m of face height (bar %.2f..%+.2f), other glove moved %.3f in her guard (bar %.2f)" % [
		tag, catch_hand, "yes" if between else "no", fwd_m, FWD_LO, FWD_HI, gy, GY_LO, GY_HI, other_move, OTHER_BAR])
	_check(touch <= TOUCH_HI and touch >= -INSIDE_BAR and best_face >= FACE_BAR,
		"MEETS %s: touch %+.3f m (bar <= %.2f, not > %.2f inside), to_face %.3f (bar >= %.2f)" % [tag, touch, TOUCH_HI, INSIDE_BAR, best_face, FACE_BAR])
	_check(over <= OVER_HEAD_BAR, "OVERHEAD %s: highest hand %+.3f m over the head bone (bar %.2f)" % [tag, over, OVER_HEAD_BAR])
	_check(wrist <= WRIST_BAR, "WRIST %s: elbow-to-wrist changed %.4f m (bar %.2f)" % [tag, wrist, WRIST_BAR])
	for i in 40:
		await process_frame
