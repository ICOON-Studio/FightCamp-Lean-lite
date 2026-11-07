extends SceneTree
## S393 INSIDE4 probe: does a folded face still sink into the other boxer's torso in a PLAYED fight?
## Three LIVE rounds of fight night through the tools/fight3d_play.gd flow, the bodies as SHOWN
## (tools/pose_tap.gd as the last modifier). Every frame, for each boxer: her head centre (GloveClear's
## own formula: HEAD_UP_M up the head bone) to the OTHER boxer's torso segment Hips -> UpperChest,
## and the clip each one plays. Print a line per frame under 0.20 m (time, who, distance, both clips)
## and a summary: HEAD_TORSO_PROBE frames=<n> under_0.20=<n> worst=<m> spells=<n spells >= 0.2 s>
## GLOVECLEAR=<main|torso>.
## Run: python tools/hidden_desktop.py run --timeout=400 <godot.exe> --headless --audio-driver Dummy
##       --path . --fixed-fps 30 --script res://tools/head_torso_probe.gd -- show3d

const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const GloveClearScript := preload("res://scripts/fight3d/GloveClear.gd")
const PoseTap := preload("res://tools/pose_tap.gd")

const ROUNDS := 3
const THRESH := 0.20
const SPELL_MIN_S := 0.2
const HEAD_UP_M := 0.08
const TAP_BONES := ["Head", "Hips", "UpperChest"]

var main: Node
var view: Node
var stage: Node3D
var taps: Array = []
var _clock := 0.0
var _armed := false
var _playing_round := 0
var _rounds_done := 0
var _bout_over := false
var _total_frames := 0
var _under_frames := 0
var _worst_dist := 999.0
var _under_lines: Array = []
var _frame_rows: Array = []   # {t, who, dist, clip_me, clip_other}
var picked := {}
var _speed_set := false


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	f["arrows"] = [{"move": "1-1"}, {"move": "step_back"}, {"move": "tie_up"}, {"move": "pivot_out"}]
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	main.act("accept", str(offer["id"]))
	main.act("camp", str(f["id"]))
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	await _wait(4)
	if main.modal.is_empty() or str(main.modal.get("type", "")) != "fight":
		print("HEAD_TORSO_FAIL no fight modal after fightnight")
		return
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	await _wait(2)
	if view != null:
		for ch in view.get_children():
			if ch.has_method("cue_touch"):
				ch.finish()
	await _wait(2)
	print("HEAD_TORSO start: %s vs %s, rounds %d" % [str(f["name"]), str(f["bout"]["opp"]["name"]), int(main.modal.get("total", 3))])


func _process(delta: float) -> bool:
	_clock += delta
	if main != null and (view == null or not is_instance_valid(view)):
		view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view == null:
		return false
	if view != null and view.get("stage") != null and not _armed:
		_arm()
	if _armed and is_instance_valid(stage):
		_sample()
	_rounds()
	_drive()
	if _done():
		_report()
		return true
	return false


func _arm() -> void:
	stage = view.get("stage")
	if stage == null or (stage.boxers as Array).size() < 2:
		return
	for i in 2:
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(skel, TAP_BONES)
		skel.add_child(tap)
		taps.append(tap)
	_armed = true
	var gc_mode := "torso" if _has_clear_torso() else "main"
	print("HEAD_TORSO armed: pose taps last, GLOVECLEAR=%s" % gc_mode)


func _has_clear_torso() -> bool:
	if stage == null or (stage.boxers as Array).size() < 2:
		return false
	for i in 2:
		var gc = stage.boxers[i].get("gclear")
		if gc != null and gc.has_method("_clear_torso"):
			return true
	return false


func _sample() -> void:
	var f := Engine.get_process_frames()
	var poses: Array = []
	for i in 2:
		var shown: Dictionary = (taps[i] as SkeletonModifier3D).shown
		if shown.is_empty():
			return
		var xf: Transform3D = (stage.boxers[i]["skel"] as Skeleton3D).global_transform
		var e := {"f": f, "t": _clock}
		for b in TAP_BONES:
			if shown.has(b):
				e[b] = xf * (shown[b] as Vector3)
		var ap: AnimationPlayer = stage.boxers[i]["ap"]
		e["clip"] = str(ap.assigned_animation)
		poses.append(e)
	if poses.size() < 2:
		return
	_total_frames += 1
	for i in 2:
		var head_bone: Vector3 = poses[i]["Head"]
		var head_centre: Vector3 = head_bone + Vector3.UP * HEAD_UP_M
		var other_hips: Vector3 = poses[1 - i]["Hips"]
		var other_uc: Vector3 = poses[1 - i]["UpperChest"]
		var d := _point_to_segment(head_centre, other_hips, other_uc)
		if d < _worst_dist:
			_worst_dist = d
		if d < THRESH:
			_under_frames += 1
			_under_lines.append("HEAD_TORSO t=%.2f who=%d dist=%.3f me=%s other=%s" % [
				_clock, i, d, str(poses[i]["clip"]), str(poses[1 - i]["clip"])])
			_frame_rows.append({"t": _clock, "who": i, "dist": d,
				"clip_me": str(poses[i]["clip"]), "clip_other": str(poses[1 - i]["clip"])})


## Closest distance from point P to segment AB.
func _point_to_segment(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab := b - a
	var t := (p - a).dot(ab) / maxf(ab.length_squared(), 1e-5)
	t = clampf(t, 0.0, 1.0)
	var closest := a + ab * t
	return (p - closest).length()


func _rounds() -> void:
	if view == null or not is_instance_valid(view):
		return
	if bool(view.playing):
		_playing_round = int(view.round_n)
		if not _speed_set:
			FightView.fast = true
			view._toggle_speed()
			view._toggle_speed()
			_speed_set = true
	elif _playing_round > 0:
		_rounds_done = maxi(_rounds_done, _playing_round)
		_bout_over = _bout_over or str(view.get("_stop")) != ""
		_playing_round = 0


func _drive() -> void:
	if view == null or not is_instance_valid(view) or not view.is_inside_tree():
		return
	var bar: Node = view.get("_shouting")
	if bar != null and is_instance_valid(bar):
		if not picked.has(bar.get_instance_id()):
			picked[bar.get_instance_id()] = true
			if bar.has_method("_set_aim"):
				bar.call("_set_aim", "body")
			bar.call("_pick", "body" if bar.find_child("Shout_body", true, false) != null else "")
		return
	if bool(view.playing):
		return
	for ch in view.get_children():
		if not ch.has_method("cue_walk_out"):
			continue
		if picked.has(ch.get_instance_id()):
			return
		var ui: Node = ch.get("ui")
		var card: Node = ui.get("_card") if ui != null else null
		if card == null or not bool(card.get("visible")):
			return
		picked[ch.get_instance_id()] = true
		ch.call("_pick", "body")
		ch.call("finish")


func _done() -> bool:
	if _clock < 750.0 and _rounds_done < ROUNDS and not _bout_over:
		return false
	return true


func _report() -> void:
	var spells := _count_spells()
	var gc_mode := "torso" if _has_clear_torso() else "main"
	print("HEAD_TORSO_PROBE frames=%d under_0.20=%d worst=%.3f spells=%d GLOVECLEAR=%s" % [
		_total_frames, _under_frames, _worst_dist, spells, gc_mode])
	if _under_frames > 0 and _under_frames <= 30:
		for line in _under_lines:
			print(line)


func _count_spells() -> int:
	if _frame_rows.is_empty():
		return 0
	var sorted_rows: Array = _frame_rows.duplicate()
	sorted_rows.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
	var spells := 0
	var spell_start := -1.0
	var spell_end := -1.0
	for row in sorted_rows:
		var t := float(row["t"])
		if spell_start < 0.0:
			spell_start = t
			spell_end = t
		elif t - spell_end > 1.0 / 15.0:
			if spell_end - spell_start >= SPELL_MIN_S:
				spells += 1
			spell_start = t
			spell_end = t
		else:
			spell_end = t
	if spell_end - spell_start >= SPELL_MIN_S:
		spells += 1
	return spells


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
