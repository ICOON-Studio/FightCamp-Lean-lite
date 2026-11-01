extends SceneTree
## Plays the real game to fight night and films the 3D rounds (S308: 3:00 rounds, run at 2x here): the clock, the shout
## bar at 0:30 and its pick, the verdict, round 2 on the corner's plan, the corner minute (S307, skipped here after a still), SKIP BOUT, the result. Also checks the flow: every round watched,
## the modal back between rounds, the result reached. Real pictures only (run it on the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/fight3d_play.gd -- <out_dir>
## Prints FIGHT3D_PLAY failures=<n>.

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const FastDraw := preload("res://tools/fast_draw.gd")

var main: Node
var out_dir := "user://fight3d_play"
var failures := 0


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	FastDraw.begin()
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
	# S339 her coach's plan, as the plan board saves it (jab and move, step back, tie up, turn off the ropes).
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
	# S345 FIGHTHUD2: `noscout` leaves her file unread (no tape found anything), so her guard and heart show "?".
	if OS.get_cmdline_user_args().has("noscout"):
		f["bout"]["opp"]["file_found"] = []
	main.act("fightnight")
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	# S307: the intro plays first; skip it to the bell (tools/corner_film.gd films it).
	await _wait(2)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await _wait(2)
	_check(view != null and bool(view.playing), "round 1 plays in 3D (the words modal waits)")
	_check(main._modal_layer.get_child_count() == 0, "no modal over the ring while the round plays")
	# S308: 3:00 rounds; this check runs them at 2x (90 s a round).
	FightView.fast = true
	view._toggle_speed()
	view._toggle_speed()
	await _shot("p01_round1_open", 3.0)
	print("CLOCK \"%s\"" % view._clock.text)
	var cam: Camera3D = view.stage.camera
	print("CAM pos=%s fov=%.0f close=%s scene=%s current=%s a=%s b=%s" % [cam.global_position, cam.fov, cam.close, view.stage.scene,
		cam == cam.get_viewport().get_camera_3d(), view.stage.boxers[0]["pos"], view.stage.boxers[1]["pos"]])
	_check(str(view._clock.text).contains("2:5") or str(view._clock.text).contains("2:4"), "the round clock counts down from 3:00")
	await _until(func(): return view._shouting != null, 40.0)
	_check(view._shouting != null, "at 0:30 the shout bar comes up")
	await _shot("p02_shout_bar", 1.2)
	var bar: Node = view._shouting
	if bar != null:
		var shouts := bar.find_children("Shout_*", "", true, false).size()
		var clue: Label = bar.find_child("Clue", true, false)
		print("CLUE \"%s\"" % (clue.text if clue != null else ""))
		_check(shouts == 3 and bar.find_child("SayNothing", true, false) != null and clue != null and clue.text.length() > 10,
			"the bar: a clue line, three calls, Say nothing")
		var coach := str(LiveRound.preview(main.career.fighter(), main.modal)["coach"])
		bar._pick(coach)
	await _shot("p03_after_shout", 0.5)
	print("CAPTION \"%s\"" % view._caption.text)
	_check(str(view._caption.text).begins_with("Corner:"), "the shout is heard: the corner's line captions the next 30 seconds")
	# S339 the arrow she throws in this 30 s is named after the corner's line, when she has one on her card.
	var ex1: Dictionary = (LiveRound.live(main.modal).get("ex", []) as Array)[-1]
	await _until(func(): return str(view._caption.text).begins_with("Plan:"), 3.0)
	await _shot("p03b_plan_caption", 0.1)
	print("PLAN CAPTION \"%s\" (arrow %s on %s, planned %s)" % [view._caption.text, ex1.get("arrow", ""), ex1.get("at", ""), ex1.get("planned", false)])
	_check(str(view._caption.text).begins_with("Plan:") == bool(ex1.get("planned", false)), "the arrow she throws is named in the ring (only when it is planned)")
	await _until(func(): return float(view.t) > 58.2, 40.0)
	await _shot("p04_verdict", 0.1)
	print("VERDICT \"%s\"" % view._caption.text)
	await _until(func(): return view._shouting != null, 20.0)
	if view._shouting != null:
		view._shouting._pick("")
	view.skip_round()
	await _wait(2)
	var r1: Dictionary = (main.modal["rounds"] as Array)[0]
	_check((r1.get("exchanges", []) as Array).size() == 6 and int(r1.get("calls", 0)) == 1, "round 1: six exchanges, one shout (the rest skipped)")
	var cm: Node = null
	for ch in view.get_children():
		if ch.has_method("cue_walk_out"):
			cm = ch
	_check(cm != null, "round 1's bell starts the corner minute")
	if cm != null:
		await _until(func(): return cm.ui != null and cm.ui._card.visible, 40.0)
		await _shot("p05_corner_card", 0.6)
		_check(cm.ui.find_children("Corner_*", "", true, false).size() == 8, "the corner card offers all eight calls")
		_check(cm.ui.find_child("PlanChange", true, false) != null, "S339 the corner card has the PLAN row (change one arrow)")
		cm._pick("lead")
		cm.finish()
	await _wait(2)
	_check(bool(view.playing) and int(view.round_n) == 2 and str(LiveRound.live(main.modal).get("plan", "")) == "lead",
		"round 2 plays on the corner's plan")
	await _shot("p06_round2_mid", 12.0)
	# S348 (C199 "mouse over head or liver to show stats like damage taken"): the real mouse route through the fight HUD -
	# a motion onto the opponent's liver reaches her figure, rings it, and the tooltip shows what landed there.
	var bl: Node = view.find_child("BodyLive", true, false)
	if bl != null and (bl.figures as Array).size() == 2:
		var fig: Control = bl.figures[1]
		var at: Vector2 = fig.get_global_transform_with_canvas() * fig.centre_of("right_ribs")
		var mm := InputEventMouseMotion.new()
		mm.position = at
		mm.global_position = at
		root.push_input(mm, true)   # viewport coords (the hidden desktop maximises the window: window coords are scaled)
		await _wait(2)
		_check(root.gui_get_hovered_control() == fig, "C199 the mouse on her liver reaches her body view (%s)" % root.gui_get_hovered_control())
		_check(str(fig.find_child("BodyTip", false, false).hover) == "right_ribs", "C199 her liver is ringed under the mouse")
		await _shot("p06b_hover_liver", 0.6)
		var head: Vector2 = fig.get_global_transform_with_canvas() * fig.centre_of("head")
		mm = InputEventMouseMotion.new()
		mm.position = head + Vector2(0, -8)
		mm.global_position = mm.position
		root.push_input(mm, true)   # viewport coords (the hidden desktop maximises the window: window coords are scaled)
		await _wait(2)
		print("HEAD TIP \"%s\"" % str(fig._get_tooltip(head + Vector2(0, -8) - fig.get_global_transform_with_canvas().origin)).replace("\n", " | "))
		await _shot("p06c_hover_head", 0.6)
		# S348 the close-ups (the operator's anatomy-chart pictures): pointing at HEAD gives the head's tooltip.
		var co: Node = fig.find_child("BodyCallouts", false, false)
		_check(co != null, "S348 her body view has the HEAD / LIVER / RIBS close-ups")
		if co != null:
			mm = InputEventMouseMotion.new()
			mm.position = fig.get_global_transform_with_canvas() * (co.centre(0) as Vector2)
			mm.global_position = mm.position
			root.push_input(mm, true)
			await _wait(2)
			_check(str(root.gui_get_hovered_control().get_class()) == "Control" and root.gui_get_hovered_control().get_parent() == co, "S348 the mouse on HEAD reaches the close-up")
			await _shot("p06d_hover_callout", 0.6)
	view.skip_bout()
	await _wait(6)
	_check(str(main.modal.get("step", "")) == "result", "SKIP BOUT reaches the result")
	_check((main.modal["rounds"] as Array).size() == int(main.modal["total"]) or str(main.modal.get("stopped", "")) != "", "every round was fought (the corner took the rest)")
	await _shot("p07_result_over_ring", 0.3)
	# S320 the last round's page (the one the 3D view shows before the scorecards): drawn from the same modal.
	main.modal["step"] = "round"
	main.redraw_modal()
	await _shot("p08_round_page", 0.3)
	main.modal["step"] = "result"
	main.redraw_modal()
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
	var img: Image = await FastDraw.shot(self)
	var path := out_dir.path_join(name + ".png")
	img.save_png(path)
	print("wrote ", path)


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
