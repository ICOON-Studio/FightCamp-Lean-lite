extends SceneTree
## S343 THE TAPE ROOM through the game's own buttons (operator Q-S294-68 "the player watches the films and it unflods like
## in grappleflows , player has appropriate counters for each clip to make his plan"): quick start -> Lucy booked -> camp
## with film study -> her Camp tab's "Watch her tape" -> the room. Her flow builds node by node with the film's clock (the
## tell marked), the end opens the tell in her file and the answer's three moves; a pick is a WHEN arrow in her plan and
## the plan the bout reads; a second film's pick adds its own arrow. Headless: words only (no film), the clock still runs.
## Population: Lucy Jackson (the quick start's boxer) against the opponent her first even offer books - one bout, her
## opponent's own tape (TapeClips); the films themselves are covered over every opponent in tape_clips_test.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const TapeClips := preload("res://scripts/rules/TapeClips.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

var failures := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var ok := TestJump.run(main, "taperoom")
	var f: Dictionary = main.career.fighter()
	var room: Node = main.get_node_or_null("TapeRoom")
	_check(ok and room != null, "her Camp tab opens the tape room")
	if room == null:
		_end()
		return
	var opp: Dictionary = f["bout"]["opp"]
	var clips: Array = room.clips
	_check(clips.size() >= 2 and _find(room, "Film%d" % clips.size()) != null, "a tab a film: %d films on %s" % [clips.size(), opp["name"]])
	await process_frame

	# 1. Film 1 plays: nodes join her flow in film order as the clock passes them; the answer waits for the end.
	var c0: Dictionary = clips[0]
	var nodes: Array = c0["nodes"]
	room.advance(float(nodes[1]["t"]) + TapeClips.STILL_AFTER_S + 0.05 - room.t)
	_check(room.shown == 2 and _find(room, "Node1") != null and _find(room, "Node2") == null, "two nodes on her flow at %.1f s (%d)" % [room.t, room.shown])
	_check(_counter_buttons(room).is_empty(), "no answer before the film ends")
	room.finish()
	await process_frame
	_check(room.shown == nodes.size(), "the film's end: all %d nodes on her flow" % nodes.size())
	var tell: Node = _find(room, "Node%d" % int(c0["tell_node"]))
	_check(tell != null and _has_text(tell, "THE TELL"), "the tell's node is marked THE TELL")

	# 2. Three counters after the end; the pick goes into her plan as a WHEN arrow and lights its button.
	var btns := _counter_buttons(room)
	_check(btns.size() == 3, "three counters (%d)" % btns.size())
	var when := str(c0["when"])
	var ks := TapeClips.counters(when, TapeClips.habits_of(opp), f.get("moves", {}))
	var best := ""
	for k in ks:
		if str(k["fit"]) == "best":
			best = str(k["move"])
	var b: Button = _find(room, room.counter_name(best))
	_check(b != null, "the answer %s is one of the buttons" % best)
	if b != null:
		b.pressed.emit()
	await process_frame
	_check(TapeClips.answer(f.get("arrows", []), when) == best, "her plan: if %s - %s (%s)" % [when, best, str(f.get("arrows", []))])
	var lit: Button = _find(room, room.counter_name(best))
	_check(lit != null and lit.theme_type_variation == "ChoiceOn", "the pick is lit")

	_check((_find(room, "Spot") as Button).tooltip_text == "The file holds this already", "film 1 is her game (in her file at booking): no SPOT needed")

	# 3. Film 2 (a hidden tell): its node is a "?"; SPOT too early costs that viewing only; after Replay, SPOT in her
	# moment and the right words open it in her file now and name the node; the tape suggests the answer.
	# (tape study in camp opened her weapon on the camp's first day: the first film still hidden is the one to spot)
	var j := 1
	while j < clips.size() - 1 and TapeClips.known(opp, clips[j]):
		j += 1
	var c1: Dictionary = clips[j]
	var hidden_before := OppFile.hidden(opp).size()
	(_find(room, "Film%d" % (j + 1)) as Button).pressed.emit()
	await process_frame
	_check(room.idx == j and room.shown == 0 and not TapeClips.known(opp, c1), "film %d starts on an empty flow, its tell hidden (%s)" % [j + 1, c1["tell"]])
	var win := TapeClips.spot_window(c1, opp)
	var right := str(TapeClips.SPOT_WORDS[str(c1["shape"])])
	room.advance(maxf(0.05, win.x - 0.4))
	room.spot()
	_check(room.spotting and is_equal_approx(Engine.time_scale, 0.0) and _find(room, "SpotPick2") != null, "SPOT pauses the film on three choices")
	_pick_words(room, right)
	await process_frame
	_check(not TapeClips.known(opp, c1) and (_find(room, "Spot") as Button).disabled, "too early: not found, and the viewing's call is spent")
	(_find(room, "Replay") as Button).pressed.emit()
	await process_frame
	room.advance((win.x + win.y) * 0.5)
	var tell1: Node = _find(room, "Node%d" % int(c1["tell_node"]))
	_check(tell1 != null and _has_text(tell1, "?"), "her tell's node is a '?' until it is spotted")
	room.spot()
	_pick_words(room, right)
	await process_frame
	_check(OppFile.known(opp, str(c1["tell"])) and OppFile.hidden(opp).size() < hidden_before, "spotted: '%s' opens in her file now" % str(c1["tell"]))
	_check(tell1 != null and _has_text(tell1, "THE TELL"), "the node is named and marked THE TELL")
	_check(int(f["bout"]["film"]) == OppFile.film_depth(opp), "the fight's film depth follows what is found (%d)" % int(f["bout"]["film"]))
	room.finish()
	await process_frame
	_check(_suggested(room), "the tape suggests the answer on one counter")
	var k1: Array = TapeClips.counters(str(c1["when"]), TapeClips.habits_of(opp), f.get("moves", {}))
	var b1: Button = _find(room, room.counter_name(str(k1[0]["move"])))
	if b1 != null:
		b1.pressed.emit()
	await process_frame
	var plan: Array = f["arrows"]
	_check(TapeClips.answer(plan, str(c1["when"])) == str(k1[0]["move"]) and (str(c1["when"]) == when or TapeClips.answer(plan, when) == best),
		"two films, two answers in her plan: %s" % str(plan))
	_check(plan.size() <= PlanFight.starter().size() + 2, "the starter's arrows plus the answers, nothing doubled (%d)" % plan.size())

	# 4. Slow motion and Close: the game's speed comes back.
	room._toggle_slow()
	_check(is_equal_approx(Engine.time_scale, 0.5), "slow motion runs the tape at half speed")
	(_find(room, "CloseTape") as Button).pressed.emit()
	await process_frame
	_check(is_equal_approx(Engine.time_scale, 1.0) and main.get_node_or_null("TapeRoom") == null, "Close: back to the game at full speed")
	_end()


func _end() -> void:
	print("TAPE ROOM %s (%d failures)" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)


func _pick_words(room: Node, words: String) -> void:
	for b in room.find_children("SpotPick*", "Button", true, false):
		if (b as Button).text == words:
			(b as Button).pressed.emit()
			return
	_check(false, "SPOT list holds '%s'" % words)


func _suggested(room: Node) -> bool:
	var n := 0
	for b in _counter_buttons(room):
		for l in (b as Node).find_children("*", "Label", true, false):
			if (l as Label).text.begins_with("Suggested by the tape"):
				n += 1
	return n == 1


func _counter_buttons(n: Node) -> Array:
	return n.find_children("Counter_*", "Button", true, false)


func _find(n: Node, nm: String) -> Node:
	var hits := n.find_children(nm, "", true, false)
	return hits[0] if not hits.is_empty() else null


func _has_text(n: Node, text: String) -> bool:
	for l in n.find_children("*", "Label", true, false):
		if (l as Label).text == text:
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print("%s  %s" % ["ok  " if ok else "FAIL", what])
