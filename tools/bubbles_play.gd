extends SceneTree
## S442 BUBBLES stills: plays the real game to fight night (as tools/fight3d_play.gd does) and saves a still of the live
## round the moment each kind of reaction bubble is up - the shout with its heard mark, the coach's line, the plan mark -
## plus one with two up at once. Prints each bubble's rect, the post's screen point and the boxers' keep-out rects, and
## fails a still whose bubble covers one. Real pictures only (the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/bubbles_play.gd -- <out_dir>
## Prints BUBBLES_PLAY failures=<n>.

const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const FastDraw := preload("res://tools/fast_draw.gd")

var main: Node
var out_dir := "user://bubbles_play"
var failures := 0
var shot_kinds := {}


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	FastDraw.begin()
	root.size = Vector2i(1920, 1080)
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
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	await _wait(2)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await _wait(2)
	_check(view != null and bool(view.playing), "round 1 plays in 3D")
	var left := 200.0
	while left > 0.0 and bool(view.playing) and shot_kinds.size() < 4:
		await process_frame
		left -= 1.0 / 60.0
		if view._shouting != null:
			var coach := str(LiveRound.preview(main.career.fighter(), main.modal)["coach"])
			view._shouting._pick(coach)
			continue
		var rb: Node = view.get_node_or_null("ReactionBubbles")
		if rb == null or (rb.live as Array).is_empty():
			continue
		var newest: Dictionary = rb.live[-1]
		var kind := str(newest["kind"])
		if (rb.live as Array).size() == 2 and not shot_kinds.has("two"):
			kind = "two"
		if shot_kinds.has(kind):
			continue
		shot_kinds[kind] = true
		await create_timer(0.35, true, false, true).timeout   # the fade in is done
		await _shot(view, rb, "bubble_%s" % kind)
	_check(shot_kinds.has("shout") and shot_kinds.has("coach") and shot_kinds.has("plan"), "a shout, a coach line and a plan mark were shown (%s)" % [str(shot_kinds.keys())])
	print("BUBBLES_PLAY failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _shot(view: Node, rb: Node, name: String) -> void:
	var img: Image = await FastDraw.shot(self)
	var path := out_dir.path_join(name + ".png")
	img.save_png(path)
	print("wrote ", path, "  t=%.1f caption=\"%s\"" % [view.t, view._caption.text])
	print("KEEP ", rb.keep)
	for e in rb.live:
		var r: Rect2 = e["rect"]
		var words: Array = (e["node"] as Node).find_children("*", "Label", true, false).map(func(l): return (l as Label).text)
		print("BUBBLE %s %s %s" % [e["kind"], r, words])
		for k in rb.keep:
			_check(not r.intersects(k), "%s: the %s bubble %s keeps off a boxer %s" % [name, e["kind"], r, k])


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


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
