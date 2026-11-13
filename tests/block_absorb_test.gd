extends SceneTree
## BLOCKLOOK3 (owner C347 on the filmed blocks: "why there are no body reactions on the hits from the red fighter ?"). A
## real block absorbs the punch: the catching glove is driven back toward her face and her head rocks back a little, then
## both reset. Rows: block_catch_test's head-punch rows (pairs A_B and B_A: pro_left_jab, pro_right_cross, pro_left_hook,
## pro_right_hook) and the body hook's elbow brace, each played through BeatFire.fire itself (result blocked, def block),
## the stage at 60 frames a second, the pair stood at the stage's own gap (tests/ruler_stand.gd). The blocker's DRAWN
## skeleton (after every modifier) is read on Skeleton3D.skeleton_updated each frame. Contact = the first frame the punch's
## clip is at its contact (one frame short counts, as block_catch_test). Everything is read in her hips' frame along her
## facing, so her guard's own weave or a step is not counted.
##   glove_back   the catching glove's (the REAR glove for the jab and the lead hook, the LEAD glove for the cross and the
##                rear hook) most travel back toward her (against her facing) from its contact place, within PEAK_S
##                after contact: 0.03-0.06 m.
##   head_back    the Head bone's most travel back, same window: 0.01-0.03 m.
##   to_face_min  the catching glove's centre to her face point (FightStage.target_point), nearest over the 0.5 s after
##                contact: >= 0.08 m.
##   back_in_guard_by  seconds after contact until her catch has let go (BlockCatch weight 0) and the give still shown
##                (BlockCatch.give_left(): the glove's knock, the head's rock back, the brace's trunk give, each on its
##                HitSnap envelope) is under 0.005 m: <= 0.5 s. Read off the springs, not the drawn bones: her guard
##                clip alone carries the head 2-4 cm and the glove 5-7 cm over 0.5 s (main, this ruler's trace).
##   SCALE        per pair, the cross's and the rear hook's glove_back are larger than the jab's.
##   body hook    the elbow brace (HitSnap.brace): the top of the torso (the Neck bone) gives back 0.01-0.03 m from its
##                contact place within PEAK_S (torso_give; the brace alone curls her trunk INTO the punch), back by 0.5 s.
## 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/block_absorb_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const Stand := preload("res://tests/ruler_stand.gd")

const HZ := 60.0
const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const CLIPS := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook"]
const MOVE_MAP := {"pro_left_jab": "jab", "pro_right_cross": "cross", "pro_left_hook": "lead_hook", "pro_right_hook": "rear_hook"}
const PEAK_S := 0.12
const AFTER_S := 0.8
const GUARD_BY_S := 0.5
const BACK_TOL := 0.005
const GLOVE_BACK := Vector2(0.03, 0.06)
const HEAD_BACK := Vector2(0.01, 0.03)
const TORSO_GIVE := Vector2(0.01, 0.03)
const FACE_BAR := 0.08


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
var _drawn := {}
var _gb := {}   # setup -> clip -> glove_back


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _bw(skel: Skeleton3D, bone: String) -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin


func _on_blocker_drawn() -> void:
	var skel: Skeleton3D = st.boxers[1]["skel"]
	var c: Node = st.boxers[1].get("block_catch")
	_drawn = {"hips": _bw(skel, "Hips"), "head": _bw(skel, "Head"), "chest": _bw(skel, "Neck"), "face": st.target_point(1, false),
		"Left": _bw(skel, "LeftHand"), "Right": _bw(skel, "RightHand"), "w": float(c.get("w")) if c != null else 0.0,
		"give": float(c.call("give_left")) if c != null and c.has_method("give_left") else 0.0}


func _seed_for(move: String, clip: String) -> int:
	for s in 400:
		var r := RandomNumberGenerator.new()
		r.seed = s
		var ctx := {"big": false, "miss": false, "tired": false, "step": false, "roll": r.randf()}
		if BeatClips.punch(move, ctx, st.has_move) == clip:
			return s
	return -1


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	print("BLOCK_ABSORB")
	await _run_setup(BOXER_A, BOXER_B, "A_B")
	await _run_setup(BOXER_B, BOXER_A, "B_A")
	print("BLOCK_ABSORB failures=%d" % failures)
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
	Engine.max_fps = 30   # ruler_stand's settle counts are 30 Hz frames
	var opened: bool = await Stand.open(st, self)
	Engine.max_fps = int(HZ)
	if not opened:
		_check(false, "STAND %s: two stands of the same pair disagree" % setup)
	var v := FakeView.new()
	v.stage = st
	root.add_child(v)
	_gb[setup] = {}
	for clip in CLIPS:
		await _row(v, setup, str(clip), str(MOVE_MAP[clip]))
	var body_clip := BeatClips.punch("body_hook", {"big": false, "miss": false, "tired": false, "step": false, "roll": 0.0}, st.has_move)
	await _row(v, setup, body_clip, "body_hook")
	var g: Dictionary = _gb[setup]
	if g.has("pro_left_jab") and g.has("pro_right_cross") and g.has("pro_right_hook"):
		var jab := float(g["pro_left_jab"])
		_check(float(g["pro_right_cross"]) > jab and float(g["pro_right_hook"]) > jab,
			"SCALE %s: glove_back cross %.3f, rear hook %.3f, both more than the jab's %.3f" % [setup, float(g["pro_right_cross"]), float(g["pro_right_hook"]), jab])
	v.queue_free()
	st.queue_free()
	await process_frame
	await process_frame


func _row(v: FakeView, setup: String, clip: String, move: String) -> void:
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
	var body := move == "body_hook"
	var catch_hand: String = st.hand_of(1, "RightHand" if move in ["jab", "lead_hook"] else "LeftHand")
	var cside := catch_hand.trim_suffix("Hand")
	var ap0: AnimationPlayer = st.boxers[0]["ap"]
	var fwd: Vector3 = (st.boxers[1]["node"] as Node3D).global_transform.basis.z
	fwd = Vector3(fwd.x, 0.0, fwd.z).normalized()
	v._amb_rng.seed = sd
	v.t = 0.0
	var bf := BeatFire.new()
	await process_frame
	await process_frame
	bf.fire(v, {"who": "a", "move": move, "result": "blocked", "def": "block", "t": 0.0})
	var snaps: Array = []
	var contact_i := -1
	for f in int(3.0 * HZ):
		await process_frame
		snaps.append(_drawn.duplicate())
		if contact_i < 0 and str(ap0.current_animation) == clip and ap0.current_animation_position >= c - sp / HZ - 1e-4:
			contact_i = snaps.size() - 1
		if contact_i >= 0 and snaps.size() - 1 >= contact_i + int(AFTER_S * HZ):
			break
	if contact_i < 0:
		_check(false, "ROW %s: the punch never reached its contact" % tag)
		return
	var at: Dictionary = snaps[contact_i]
	var g0: Vector3 = (at[cside] as Vector3) - (at["hips"] as Vector3)
	var h0: Vector3 = (at["head"] as Vector3) - (at["hips"] as Vector3)
	var c0: Vector3 = (at["chest"] as Vector3) - (at["hips"] as Vector3)
	var glove_back := 0.0
	var head_back := 0.0
	var torso := 0.0
	var to_face := 9.0
	var peak_i := contact_i
	for i in range(contact_i, snaps.size()):
		var d: Dictionary = snaps[i]
		var tt := float(i - contact_i) / HZ
		var hp: Vector3 = d["hips"]
		if tt <= PEAK_S + 1e-4:
			var gb := (g0 - ((d[cside] as Vector3) - hp)).dot(fwd)
			var hb := (h0 - ((d["head"] as Vector3) - hp)).dot(fwd)
			var tg := (c0 - ((d["chest"] as Vector3) - hp)).dot(fwd)
			if maxf(gb, maxf(hb, tg)) >= maxf(glove_back, maxf(head_back, torso)):
				peak_i = i
			glove_back = maxf(glove_back, gb)
			head_back = maxf(head_back, hb)
			torso = maxf(torso, tg)
		if tt <= GUARD_BY_S + 1e-4:
			to_face = minf(to_face, (d[cside] as Vector3).distance_to(d["face"]))
	var back_by := -1.0
	for i in range(peak_i, snaps.size()):
		var d: Dictionary = snaps[i]
		if float(d["w"]) <= 0.0 and float(d["give"]) <= BACK_TOL:
			back_by = float(i - contact_i) / HZ
			break
	if OS.get_cmdline_user_args().has("trace"):
		for i in range(contact_i, snaps.size(), 3):
			var d: Dictionary = snaps[i]
			var hp: Vector3 = d["hips"]
			print("  +%.3f w=%.2f glove_back=%+.3f head_back=%+.3f head_off=%.3f chest_off=%.3f" % [float(i - contact_i) / HZ, float(d["w"]),
				(g0 - ((d[cside] as Vector3) - hp)).dot(fwd), (h0 - ((d["head"] as Vector3) - hp)).dot(fwd),
				(((d["head"] as Vector3) - hp) - h0).length(), (((d["chest"] as Vector3) - hp) - c0).length()])
	var back_ok := back_by >= 0.0 and back_by <= GUARD_BY_S
	print("ABSORB %s: glove_back=%.3f head_back=%.3f to_face_min=%.3f back_in_guard_by=%.2f torso_give=%.3f (catch %s, contact frame %d)" % [
		tag, glove_back, head_back, to_face, back_by, torso, catch_hand, contact_i])
	if body:
		_check(torso >= TORSO_GIVE.x and torso <= TORSO_GIVE.y and back_ok,
			"ABSORB %s: elbow brace, the torso gives %.3f m (bar %.2f-%.2f), back by %.2f s (bar <= %.1f)" % [tag, torso, TORSO_GIVE.x, TORSO_GIVE.y, back_by, GUARD_BY_S])
	else:
		_gb[setup][clip] = glove_back
		_check(glove_back >= GLOVE_BACK.x and glove_back <= GLOVE_BACK.y and head_back >= HEAD_BACK.x and head_back <= HEAD_BACK.y and to_face >= FACE_BAR and back_ok,
			"ABSORB %s: glove back %.3f m (bar %.2f-%.2f), head back %.3f m (bar %.2f-%.2f), glove to face %.3f m at nearest (bar >= %.2f), back in guard by %.2f s (bar <= %.1f)" % [
			tag, glove_back, GLOVE_BACK.x, GLOVE_BACK.y, head_back, HEAD_BACK.x, HEAD_BACK.y, to_face, FACE_BAR, back_by, GUARD_BY_S])
	for i in 40:
		await process_frame
