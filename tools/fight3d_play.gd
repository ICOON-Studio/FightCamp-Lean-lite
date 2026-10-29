extends SceneTree
## Plays the real game to fight night and films the 3D rounds: stills at set moments of round 1 (highlights), a full
## round 2, the corner picker over the frozen ring, SKIP BOUT, the result. Also checks the flow: every round watched,
## the modal back between rounds, the result reached. Real pictures only (run it on the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/fight3d_play.gd -- <out_dir>
## Prints FIGHT3D_PLAY failures=<n>.

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")

var main: Node
var out_dir := "user://fight3d_play"
var failures := 0


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
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
	_check(view != null and bool(view.playing), "round 1 plays in 3D (the words modal waits)")
	_check(main._modal_layer.get_child_count() == 0, "no modal over the ring while the round plays")
	await _shot("p01_round1_open", 0.6)
	await _until(func(): return int(view.next) > 0 and str(view.beats[int(view.next) - 1]["result"]) == "lands", 20.0)
	await _shot("p02_round1_contact", 0.25)
	print("CAPTION \"%s\"" % view._caption.text)
	await _until(func(): return float(view._close_left) > 0.0, 30.0)
	await _shot("p03_round1_closeup", 0.3)
	await _until(func(): return not bool(view.playing), 40.0)
	_check(int(main.modal.get("watched", 0)) == 1, "round 1 watched -> the modal shows the corner picker")
	await _shot("p04_corner_over_ring", 0.3)
	FightView.highlights = false
	main.act("fightstep", "corner:body")
	_check(bool(view.playing) and int(view.round_n) == 2, "round 2 plays after the corner call")
	await _shot("p05_round2_full_open", 2.5)
	await _shot("p06_round2_full_mid", 14.0)
	view.skip_bout()
	await _wait(6)
	_check(str(main.modal.get("step", "")) == "result", "SKIP BOUT reaches the result")
	_check((main.modal["rounds"] as Array).size() == int(main.modal["total"]), "every round was fought (the corner took the rest)")
	await _shot("p07_result_over_ring", 0.3)
	print("FIGHT3D_PLAY failures=%d" % failures)
	quit(0 if failures == 0 else 1)


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
