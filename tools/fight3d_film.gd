extends SceneTree
## Films fight night for review: round 1 in highlights, rounds 2 and 3 full (S304: round 3 shows tiredness and cut combos),
## to the final bell. Prints both fighters first (the film names its population). Run under Godot's movie writer on the
## never-shown desktop, then watch the result with the eyes skill:
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 1280x720 ##       --fixed-fps 30 --write-movie <out>.avi --script res://tools/fight3d_film.gd -- <out_dir>

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")

var main: Node
var out_dir := "user://fight3d_play"
var failures := 0
## S301 joins probe: `joins=<csv>` logs every frame, per boxer, the clip playing and the hands/head/hips in her own body
## frame (root motion excluded) - tools/joins_report.py reads it for velocity jumps at clip changes.
var _joins: FileAccess
var _frame := 0
const JOIN_BONES := ["LeftHand", "RightHand", "Head", "Hips", "LeftFoot", "RightFoot"]


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	for a in args:
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
	await _until(func(): return not bool(view.playing), 90.0)
	await _wait(45)
	pass   # S308: rounds are always full (3:00)
	main.act("fightstep", "corner:body")
	await _until(func(): return not bool(view.playing), 120.0)
	await _wait(45)
	main.act("fightstep", "corner:long")
	await _until(func(): return not bool(view.playing), 120.0)
	await _wait(60)
	if _joins != null:
		_joins.close()
	print("FILM done")
	quit(0)


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
