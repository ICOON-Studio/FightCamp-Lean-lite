extends SceneTree
## Films fight night for review: round 1 in highlights, rounds 2 and 3 full (S304: round 3 shows tiredness and cut combos),
## to the final bell. Prints both fighters first (the film names its population). Run under Godot's movie writer on the
## never-shown desktop, then watch the result with the eyes skill:
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 1280x720 ##       --fixed-fps 30 --write-movie <out>.avi --script res://tools/fight3d_film.gd -- <out_dir>

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const CornerMinute := preload("res://scripts/fight3d/CornerMinute.gd")
const PICK_AT_S := 16.0   # the card comes up at 9 s: a player reads it, then picks
## S395 (operator: "why do you render full fight clips"): `short` runs the dull stretches fast, so a film costs a third.
const FAST := 12.0
## S396 (blind judges rated the action off a round played at 12x): the opening exchanges play as played, so the blows can be read.
const REAL_ROUND_S := 22.0
const FAST_ROUND_TO_S := 172.0   # round 1 at speed to here, then the last 8 s and the bell as played
const FAST_CORNER_S := Vector2(17.0, 48.0)   # the walk, the card and the walk out stay as played
var _fast_on := false

var main: Node
var out_dir := "user://fight3d_play"
var failures := 0
## S301 joins probe: `joins=<csv>` logs every frame, per boxer, the clip playing and the hands/head/hips in her own body
## frame (root motion excluded) - tools/joins_report.py reads it for velocity jumps at clip changes.
var _joins: FileAccess
var _frame := 0
const JOIN_BONES := ["LeftHand", "RightHand", "Head", "Hips", "LeftFoot", "RightFoot"]


func _initialize() -> void:
	# S379 (operator: "skip the walk in for the clips"): the film opens with both boxers in their corners (CornerStart);
	# `walkin` films the game's full intro.
	FightIntro.from_corners = not OS.get_cmdline_user_args().has("walkin")
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	for a in args:
		if str(a).begins_with("seed="):   # RETARGET2B: two arms of a film must play the same career and fight
			seed(int(str(a).substr(5)))
		if str(a).begins_with("joins="):
			_joins = FileAccess.open(str(a).substr(6), FileAccess.WRITE)
			_joins.store_line("frame,who,clip,pos_x,pos_z," + ",".join(JOIN_BONES.map(func(b): return "%s_x,%s_y,%s_z" % [b, b, b])))
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
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
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	print("FILM her ", f.get("name", f.get("first", "?")), " stats ", f["stats"])
	print("FILM opp ", offer.get("opp", offer))
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
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	if _joins != null:
		for bx in view.stage.boxers:
			var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
			tap.setup(bx["skel"], JOIN_BONES)
			(bx["skel"] as Skeleton3D).add_child(tap)   # last in the stack: what the viewer sees
			bx["tap"] = tap
		process_frame.connect(_log_joins.bind(view))
	# S359: the intro (S307) plays before round 1 with playing false - wait for the round to start, or the film ends at once.
	await _until(func(): return bool(view.playing), 120.0)
	if OS.get_cmdline_user_args().has("short"):
		process_frame.connect(_fast.bind(view))
	await _until(func(): return float(view.t) >= float(view.length) - 1.0 or not bool(view.playing), 220.0)
	_rings(view, "one second before the bell")
	await _until(func(): return not bool(view.playing), 220.0)
	_rings(view, "end of the bell")
	await _corner(view, "body")
	if OS.get_cmdline_user_args().has("short"):   # S395 (operator: "noneedto bea full fight ?"): one round, the corner, the next bell
		await _wait(75)
		print("FILM done")
		quit(0)
		return
	await _until(func(): return not bool(view.playing), 220.0)
	await _corner(view, "long")
	await _until(func(): return not bool(view.playing), 220.0)
	await _wait(60)
	if _joins != null:
		_joins.close()
	print("FILM done")
	quit(0)


## A big shot's moment plays as it plays in the game; the film goes back to speed after it.
func _fast(view: Node) -> void:
	var calls: Node = view.get_node_or_null("FightCalls")
	if calls != null and float(calls._t) >= 0.0:
		_fast_on = false
		return
	var m: Node = _minute(view)
	var want := false
	if bool(view.playing):
		want = int(view.round_n) == 1 and float(view.t) > REAL_ROUND_S and float(view.t) < FAST_ROUND_TO_S
	elif m != null:
		want = float(m.t) > FAST_CORNER_S.x and float(m.t) < FAST_CORNER_S.y
	if want:
		Engine.time_scale = FAST
	elif _fast_on:
		Engine.time_scale = view.pace() if bool(view.playing) else 1.0
	_fast_on = want


## S395: the corner minute plays to its own end, on the player's pick. This film used to send fightstep 45 frames after the
## bell, so round 2 ran under the corner: rings and buttons on the letterbox, read as a game bug (tools/hud_corner_probe.gd).
func _corner(view: Node, pick: String) -> void:
	await _until(func(): return _minute(view) != null, 5.0)
	var minute: Node = _minute(view)
	if minute == null:
		return   # a stoppage or the last round: no corner
	await _until(func(): return float(minute.t) >= PICK_AT_S, 30.0)
	minute.ui.chose.emit(pick)
	await _until(func(): return float(minute.t) >= 53.0, 60.0)
	print("FILM rest ends %.1f %.1f %s" % [minute.ui.rest_number(0), minute.ui.rest_number(1), str(minute.ctx["card"]["rest"].get("parts", []))])
	await _until(func(): return bool(view.playing), 120.0)
	await _wait(2)
	_rings(view, "next round opens")
	print("FILM edge %s %.2f clock %s, view %s window %s" % [view.bars.edge.word, view.bars.edge.value, view._clock.text, view.size, root.size])


## S395 the stamina the rings draw against what the corner card will read.
func _rings(view: Node, label: String) -> void:
	var drawn := [float(view.bars.meters[0]["stamina"].fill) * 100.0, float(view.bars.meters[1]["stamina"].fill) * 100.0]
	print("FILM rings %s: drawn %.1f / %.1f, card %.1f / %.1f" % [label, drawn[0], drawn[1], view.bars.stamina(0), view.bars.stamina(1)])
	print("FILM body %s: legs %.1f / %.1f, guard %.1f / %.1f" % [label, float(view.bars.meters[0]["legs"].fill) * 100.0, float(view.bars.meters[1]["legs"].fill) * 100.0,
		float(view.bars.meters[0]["guard"].fill) * 100.0, float(view.bars.meters[1]["guard"].fill) * 100.0])


func _minute(view: Node) -> Node:
	for c in view.get_children():
		if c is CornerMinute and not c.is_queued_for_deletion():
			return c
	return null


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


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 60.0


func _shot(name: String, after_s: float) -> void:
	await create_timer(after_s).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1


func _log_joins(view: Node) -> void:
	if not is_instance_valid(view) or view.stage == null:
		return
	_frame += 1
	for who in (view.stage.boxers as Array).size():
		var bx: Dictionary = view.stage.boxers[who]
		var skel: Skeleton3D = bx["skel"]
		var node: Node3D = bx["node"]
		var to_body := node.global_transform.affine_inverse() * skel.global_transform
		var row := [str(_frame), str(who), str((bx["ap"] as AnimationPlayer).current_animation), "%.4f" % node.position.x, "%.4f" % node.position.z]
		for b in JOIN_BONES:
			var p: Vector3 = to_body * ((bx["tap"].shown as Dictionary).get(b, Vector3.ZERO) as Vector3)
			row.append_array(["%.4f" % p.x, "%.4f" % p.y, "%.4f" % p.z])
		_joins.store_line(",".join(row))
