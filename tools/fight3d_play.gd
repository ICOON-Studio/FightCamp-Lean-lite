extends SceneTree
## Plays the real game to fight night and films the 3D rounds (S308: 3:00 rounds, run at 2x here): the clock, the shout
## bar at 0:30 and its pick, the verdict, round 2 on the corner's plan, the corner minute (S307, skipped here after a still), SKIP BOUT, the result. Also checks the flow: every round watched,
## the modal back between rounds, the result reached. Real pictures only (run it on the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/fight3d_play.gd -- <out_dir>
## Prints FIGHT3D_PLAY failures=<n>.
## S381 HOLOOFF: `gameplan` after <out_dir> plays the S378 jump=gameplan set-up - two of her own combinations drilled, the
## 3-punch signature named the GO-TO, the plan 1-1 / step in / body - and prints the go-to's throws a round (GOTO lines).
## The live round shows no holo panels (checked on every still); the corner card's holo shows where the punches landed.
## S382: `hold=<s>` keeps the corner card up that many more seconds (films), `end=corner` stops after the corner minute.

const W := 1920
const H := 1080
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")

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
	if OS.get_cmdline_user_args().has("gameplan"):   # S381: the operator's plan + the S378 jump=gameplan go-to
		f["arrows"] = [{"move": "1-1"}, {"move": "step_in"}, {"move": "1-2-3b"}]
		for mv in ["Jab", "Cross", "Lead hook"]:
			f["moves"][mv] = maxf(float(f["moves"].get(mv, 0.0)), 70.0)
		f["book"] = TestJump.OWN_BOOK.duplicate(true)
		OwnCombos.ensure_ids(f)
		f["own_combos"] = {"own:1": ComboWords.SIGNATURE_AT, "own:2": 55.0}
		f["plan_combo"] = "own:1"
		print("GOTO named \"%s\" rows %d" % [OwnCombos.named(f).get("name", "-"), OwnCombos.rows_for_ring(f).size()])
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
	if OS.get_cmdline_user_args().has("gameplan"):
		# S381: the camp's weeks fade the undrilled go-to below the signature (85 -> 82) and her hand-speed cap is 2 punches,
		# so a plain 3-punch go-to is never thrown; the film starts the bout from the jump's own state (punches 70, go-to 85).
		f = c.fighter()
		for mv in ["Jab", "Cross", "Lead hook"]:
			f["moves"][mv] = maxf(float(f["moves"].get(mv, 0.0)), 70.0)
		f["own_combos"] = {"own:1": ComboWords.SIGNATURE_AT, "own:2": 55.0}
		print("GOTO at the bell \"%s\" rows %s" % [OwnCombos.named(f).get("name", "-"),
			OwnCombos.rows_for_ring(f).map(func(r): return "%s sig=%s" % [r["id"], r["sig"]])])
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
	_holo_off(view, "round 1 opens")
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
	_holo_off(view, "the verdict")
	print("VERDICT \"%s\"" % view._caption.text)
	await _until(func(): return view._shouting != null, 20.0)
	if view._shouting != null:
		view._shouting._pick("")
	_goto_count(view, 1, "watched")
	view.skip_round()
	await _wait(2)
	_goto_count(view, 1, "whole round")
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
		# S381 HOLOOFF: the holo is the corner card's - her body with the places that took punches coloured.
		var fig: Control = cm.ui._card.find_child("*BodyFigure*", true, false)
		if fig == null:
			for n in cm.ui._card.find_children("*", "Control", true, false):
				if (n as Control).has_method("set_values") and (n as Control).has_method("hit"):
					fig = n
		var struck := []
		if fig != null:
			for p in BodyMap.PLACES:
				if float((fig.get("_values") as Dictionary).get(p, 100.0)) < 100.0:
					struck.append("%s %d" % [p, int((fig.get("_values") as Dictionary)[p])])
		print("CORNER HOLO %s holo=%s struck %s" % [fig != null, fig.get("holo") if fig != null else false, struck])
		_check(fig != null and fig.is_visible_in_tree(), "S381 the corner card shows her holo")
		# S382: the spots it DRAWS (the skin shader's spot colours) - this round's hits tinted even while 'fine' - and its words.
		var skin: Control = fig.get_node_or_null("Skin") if fig != null else null
		var spot: Array = (skin.material as ShaderMaterial).get_shader_parameter("spot_col") if skin != null else []
		var words: Array = (cm.ui.round_words.drawn as Array).map(func(d): return str(d[0])) if cm.ui.round_words != null else []
		print("CORNER HOLO round hits %s drawn spots %s words %s" % [fig.get("round_hits") if fig != null else {},
			spot.map(func(c: Color): return "%s a%.2f" % [c.to_html(false), c.a]), words])
		_check(spot.size() == 3 and spot.any(func(c: Color): return c.a > 0.0) and not words.is_empty(),
			"S382 the corner holo draws where she was hit in round 1 (tinted spots + words)")
		var hold := 0.0
		for a in OS.get_cmdline_user_args():
			if str(a).begins_with("hold="):
				hold = float(str(a).trim_prefix("hold="))
		if hold > 0.0:   # S382 film: the card stays up `hold` more seconds of the picture before the pick
			await create_timer(hold, true, false, true).timeout
			await _shot("p05b_corner_card_held", 0.0)
			_check(cm.ui._card.visible, "S382 the corner card is still up after the %.1f s hold" % hold)
		if OS.get_cmdline_user_args().has("end=corner"):   # S382 film: round 1 + the corner minute only
			cm._pick("lead")
			cm.finish()
			await _wait(30)
			print("FIGHT3D_PLAY failures=%d" % failures)
			quit(0 if failures == 0 else 1)
			return
		_check(cm.ui.find_children("Corner_*", "", true, false).size() == 8, "the corner card offers all eight calls")
		_check(cm.ui.find_child("PlanChange", true, false) != null, "S339 the corner card has the PLAN row (change one arrow)")
		cm._pick("lead")
		cm.finish()
	await _wait(2)
	_check(bool(view.playing) and int(view.round_n) == 2 and str(LiveRound.live(main.modal).get("plan", "")) == "lead",
		"round 2 plays on the corner's plan")
	await _shot("p06_round2_mid", 12.0)
	_holo_off(view, "round 2")
	# S381 HOLOOFF: the live round is the boxers - stills through round 2 (no holo, no close-up pops on any of them), and
	# the mouse where her old body panel stood reaches no figure (S348 C199's hover moved to the corner card's figure).
	for k in 4:
		await _shot("p06%s_round2_live" % "bcde"[k], 6.0)
		_holo_off(view, "round 2 still %d" % (k + 1))
	var bl: Node = view.find_child("BodyLive", true, false)
	if bl != null:
		# S382: the live round builds no holo at all (no figure for the mouse to reach where the old panel stood).
		var figs := view.find_children("*", "Control", true, false).filter(func(n): return n.has_method("set_portrait"))
		_check(figs.is_empty(), "S382 no holo figure is built in the live round (%d)" % figs.size())
		var landed := 0
		for side in 2:
			landed += int(bl.stats[side]["landed"])
		_check(landed > 0, "S381 the body map still counts the landed shots while hidden (%d)" % landed)
	_goto_count(view, 2, "watched")
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


## S381 HOLOOFF: while a round plays no body panel (holo figure, close-ups) is on screen.
func _holo_off(view: Node, at: String) -> void:
	var shown := 0
	for n in ["BodyPanel0", "BodyPanel1"]:
		var p: Control = view.find_child(n, true, false)
		if p != null and p.is_visible_in_tree():
			shown += 1
	_check(shown == 0, "S381 no holo panel on screen (%s, scorebug %s)" % [at, view._bug_box.visible])


## S381: her go-to combination's throws in round n so far (beats tagged with its id), and every combination she threw.
func _goto_count(view: Node, n: int, what: String) -> void:
	var go := str(main.career.fighter().get("plan_combo", ""))
	var per := {}
	var last := ""
	var last_t := -9.0
	for b in view._round_beats:   # a throw = a run of her beats with one combo id (a new run after a 1.5 s gap)
		if str(b["who"]) != "a":
			continue
		var id := str((b as Dictionary).get("combo_id", ""))
		if id != "" and (id != last or float(b["t"]) - last_t > 1.5):
			per[id] = int(per.get(id, 0)) + 1
		last = id
		last_t = float(b["t"])
	print("GOTO round %d (%s): go-to %s thrown %d; all %s" % [n, what, go, int(per.get(go, 0)), per])


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
