extends SceneTree
## LANDREACH3 probe: diagnose why landed lead gloves stop 5-11 cm off the face point in HEIGHT.
## Same CTRL_LANDED setup as block_meet_test (Stand, stg.play, stg.land, seek to contact, pause, 2 frames).
## Prints per row: glove - hit_face, hit_face - target, the drawn glove BEFORE carry_base,
## and whether carry_base moved _hit_w.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tools/landreach3_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Stand := preload("res://tests/ruler_stand.gd")

const HZ := 30.0
const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const CTRL_LANDED_BAR := 0.05
const CLIPS := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook"]
const MOVE_MAP := {"pro_left_jab": "jab", "pro_right_cross": "cross", "pro_left_hook": "lead_hook", "pro_right_hook": "rear_hook"}

var ctrl_fail := 0
var worst_height := 0.0


func _initialize() -> void:
	Engine.max_fps = 30
	print("LANDREACH3")
	await _run_setup(BOXER_A, BOXER_B, "A_B")
	await _run_setup(BOXER_B, BOXER_A, "B_A")
	await _run_setup(BOXER_A, BOXER_A, "A_A")
	print("LANDREACH3 ctrl_fail=%d worst_height=%.3f" % [ctrl_fail, worst_height])
	quit(0)


func _make_stage(glb_0: String, glb_1: String) -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	stg.set_process(false)
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb_0, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % glb_1, "corner": "blue"})
	stg.set_process(true)
	for i in 3:
		await process_frame
	return stg


func _reset(stg: Node3D) -> float:
	return await Stand.stand(stg, self)


func _run_setup(glb_puncher: String, glb_blocker: String, setup: String) -> void:
	var stg: Node3D = await _make_stage(glb_puncher, glb_blocker)
	if not await Stand.open(stg, self):
		print("FAIL STAND")
	for clip in CLIPS:
		await _run_ctrl_landed(stg, 0, 1, clip, setup)
	stg.queue_free()
	await process_frame


func _run_ctrl_landed(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String) -> void:
	if not (stg.boxers[puncher]["ap"] as AnimationPlayer).has_animation(clip):
		return
	var gap: float = await _reset(stg)
	if not Stand.held(stg, gap):
		return
	var move: String = MOVE_MAP.get(clip, "jab")
	var punch_speed: float = BeatClips.speed(clip, move)
	var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
	var hand: String = "LeftHand" if clip.contains("left") or clip.contains("jab") else "RightHand"
	hand = stg.hand_of(puncher, hand)
	stg.play(puncher, clip, punch_speed, 0.0)
	var body: bool = move == "body_hook" or clip.contains("kidney") or clip.contains("body")
	stg.land(puncher, clip, body, 0.0, contact_s)
	var puncher_ap: AnimationPlayer = stg.boxers[puncher]["ap"]
	puncher_ap.seek(contact_s, true)
	puncher_ap.pause()
	for w in 2:
		await process_frame
	var gf: Vector3 = stg.glove_front(puncher, hand)
	var face: Vector3 = stg.target_point(blocker, false)
	var reach_node: Node = stg.boxers[puncher].get("reach")
	var hit_face: Vector3 = reach_node.get("hit_face") if reach_node else Vector3.INF
	var shown_cur: Vector3 = reach_node.get("_shown_cur") if reach_node else Vector3.INF
	var hit_w: Vector3 = reach_node.get("_hit_w") if reach_node else Vector3.INF
	var height_err: float = absf(gf.y - face.y)
	worst_height = maxf(worst_height, height_err)
	var to_face: float = gf.distance_to(face)
	var carry_moved: bool = hit_w.is_finite() and shown_cur.is_finite() and hit_w.distance_to(shown_cur) > 0.001
	var fail: bool = to_face >= CTRL_LANDED_BAR
	if fail:
		ctrl_fail += 1
	var glove_hit: Vector3 = hit_face - gf if hit_face.is_finite() else Vector3.INF
	var hit_tgt: Vector3 = face - hit_face if hit_face.is_finite() else Vector3.INF
	print("PROBE %s %s to_face=%.3f height=%.3f glove-hit_face=(%.3f,%.3f,%.3f) hit_face-target=(%.3f,%.3f,%.3f) carry_moved=%s%s" % [
		setup, clip, to_face, height_err,
		glove_hit.x, glove_hit.y, glove_hit.z,
		hit_tgt.x, hit_tgt.y, hit_tgt.z,
		"yes" if carry_moved else "no",
		" RULER_FAIL" if fail else ""])
	puncher_ap.play()
