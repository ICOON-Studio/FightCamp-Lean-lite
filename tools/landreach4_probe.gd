extends SceneTree
## LANDREACH4 probe: diagnose why landed lead gloves stop 5-11 cm off the face point in HEIGHT.
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
	print("LANDREACH4")
	await _run_setup(BOXER_A, BOXER_B, "A_B")
	await _run_setup(BOXER_B, BOXER_A, "B_A")
	await _run_setup(BOXER_A, BOXER_A, "A_A")
	print("LANDREACH4 ctrl_fail=%d worst_height=%.3f" % [ctrl_fail, worst_height])
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
		await _run_ctrl_landed(stg, 0, 1, clip, setup, 0)
		await _run_ctrl_landed(stg, 0, 1, clip, setup, 8)
	stg.queue_free()
	await process_frame


func _run_ctrl_landed(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String, wait_f: int) -> void:
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
	stg.land(puncher, clip, false, 0.0, contact_s)
	var ap: AnimationPlayer = stg.boxers[puncher]["ap"]
	var pr: Node = stg.boxers[puncher].get("reach")
	if wait_f > 0:
		ap.seek(0.0, true)
		ap.pause()
		for w in wait_f:
			await process_frame
	ap.seek(contact_s, true)
	ap.pause()
	for w in 2:
		await process_frame
	var gf: Vector3 = stg.glove_front(puncher, hand)
	var face: Vector3 = stg.target_point(blocker, false)
	var hit_face: Vector3 = pr.get("hit_face")
	var hit_w: Vector3 = pr.get("_hit_w")
	var aim: Vector3 = pr.get("_aim_w")
	var last_at: Vector3 = pr.get("_last_at")
	var cg: Vector3 = pr.get_meta("cg_w", Vector3.INF)
	var d := gf - face
	print("PROBE %s %s wait=%d w=%.2f last_w=%.2f armed_t=%.3f to_face=%.3f d=(%.3f,%.3f,%.3f) hit_w-face=%.3f aim-face=%.3f last_at-face=%.3f glove-last_at=%.3f clipglove-face=%.3f clipglove-glove=%.3f" % [
		setup, clip, wait_f, float(pr.get("last_weight")), float(pr.get("_last_w")), float(pr.get("_armed_t")), d.length(), d.x, d.y, d.z,
		hit_w.distance_to(face), aim.distance_to(face), last_at.distance_to(face), gf.distance_to(last_at),
		cg.distance_to(face) if cg.is_finite() else -1.0, cg.distance_to(gf) if cg.is_finite() else -1.0])
	ap.play()
