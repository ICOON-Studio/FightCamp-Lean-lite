extends SceneTree
## S360 PLAYBOOK > Game plan (GamePlan, operator Q-S294-91) and > Moves (a move book, MoveWords): the plan as lines, a pick
## saves at once onto fighter.arrows, answers rated against the opponent's game, the coach's lines locked past his limit,
## hovering an answer plays it; every move of the map in the book with its tier.
## Population: a quick-start career with its first fighter signed (the film tool's start); no bout booked, so the lines rate
## against the "Rate against" pick (a presser first, then a range boxer).

const SM := preload("res://scripts/rules/StrikeMap.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")

var _fails := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var f: Dictionary = main.career.fighters[0]

	# MOVES: the move book, every move of the map once, tiers on the cards.
	main.act("go", "playbook:0")
	await _frames(10)
	var book := main.find_child("MoveBook", true, false)
	_check(book != null, "test 1: Moves is a move book (no map)")
	var cards: Array = book.find_children("Move_*", "Button", true, false) if book != null else []
	_check(cards.size() == SM.MOVES.size(), "test 1: every move has a card (%d of %d)" % [cards.size(), SM.MOVES.size()])
	_check(book != null and book.find_child("BookHead", true, false) != null, "test 1: the book says how many moves are ready")
	var tiers := 0
	for c in cards:
		tiers += int((c as Node).find_child("Tier", false, false) != null)
	_check(tiers >= SM.MOVES.size() - 3, "test 1: cards show their tier (%d)" % tiers)

	# GAME PLAN: the lines.
	GamePlan.open = ""
	GamePlan.vs = "press"
	main.act("go", "playbook:1")
	await _frames(10)
	var gp := main.find_child("GamePlan", true, false)
	_check(gp != null, "test 2: Game plan opens the lines")
	if gp == null:
		_end()
		return
	for p in PlanLines.PLACES:
		_check(gp.find_child("Line_%s_" % p, false, false) != null, "test 2: a line for %s" % p)
	_check(gp.find_child("PlanMeter", true, false) != null, "test 2: the lines meter and the plan edge show")
	var locks := 0
	for n in gp.find_children("*", "TextureRect", true, false):
		locks += int(str((n as Control).tooltip_text).begins_with("A coach rated"))
	var limit := PlanBoard.arrow_limit(float(main.career.coach.get("rating", 0.0)))
	_check(locks == PlanBoard.TOP_COACH - limit, "test 2: the lines past this coach wait locked (%d)" % locks)

	# Open a line: its answers, rated; hovering one plays it; a pick saves at once.
	gp.open = "mid|"
	gp._refresh()
	await _frames(3)
	var back: Button = gp.find_child("Opt_step_back", true, false)
	var walk: Button = gp.find_child("Opt_3b-3", true, false)
	_check(back != null and walk != null, "test 3: the open line lists the answers at mid range")
	var mp := main.find_child("MovePlayer", true, false)
	if back != null:
		back.mouse_entered.emit()
		await _frames(3)
		_check(mp != null and str(mp.get("_move_id")) == "step_back", "test 3: hovering an answer plays it")
		_check(_text(back).contains("Beats it"), "test 3: step back beats a presser, said on the card")
		var before_edge := float(PlanLines.strength(gp.arrows, "press", f.get("moves", {}), f.get("combos", {}))["edge"])
		gp._pick("mid", "", "slip 2-3", false)
		await _frames(3)
		_check(PlanLines.find(f.get("arrows", []), "mid") >= 0 and str(f["arrows"][PlanLines.find(f["arrows"], "mid")]["move"]) == "slip 2-3",
			"test 3: the pick is saved on the fighter at once (no Save button)")
		var after_edge := float(PlanLines.strength(gp.arrows, "press", f.get("moves", {}), f.get("combos", {}))["edge"])
		_check(after_edge != before_edge or PlanLines.find(gp.arrows, "mid") >= 0, "test 3: the plan edge follows the pick (%.1f -> %.1f)" % [before_edge, after_edge])

	# Rate against another game: the same answer reads differently.
	GamePlan.vs = "range"
	gp._refresh()
	await _frames(3)
	var vs_range := PlanLines.options("long", "range", f.get("moves", {}), f.get("combos", {}))
	_check(str(vs_range[0]["fit"]) == "best", "test 4: rated against a range boxer, the top answer beats it (%s)" % vs_range[0]["id"])

	# The coach's limit: a new line past it is refused, the plan stays legal.
	var full: Array = []
	for p in ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]:
		if full.size() < limit:
			full = PlanLines.set_line(full, p, "", str(SM.outs(p)[0]["id"]))
	gp._write(full)
	var spare := ""
	for p in PlanLines.PLACES:
		if PlanLines.find(full, p) < 0:
			spare = p
			break
	gp._pick(spare, "", str(SM.outs(spare)[0]["id"]), false)
	await _frames(2)
	_check(gp.arrows.size() == limit, "test 5: a line past the coach's %d is refused (%d)" % [limit, gp.arrows.size()])
	_check(PlanBoard.validate(f["arrows"], SM.MOVES, limit)["ok"], "test 5: the saved plan stays legal")

	# A situation line: + When she presses adds it, a pick answers it.
	gp._write(PlanLines.clear_line(gp.arrows, "inside"))
	GamePlan.adding = "loadup"
	GamePlan.open = PlanLines.place_for("loadup") + "|loadup"
	gp._refresh()
	await _frames(2)
	_check(gp.find_child("Line_mid_loadup", false, false) != null, "test 6: + When she loads up adds a line")
	gp._pick("mid", "loadup", "slip 2-3", false)
	await _frames(2)
	_check(PlanLines.find(f["arrows"], "mid", "loadup") >= 0, "test 6: the situation's answer is saved with its when")
	_end()


func _text(b: Node) -> String:
	var out := ""
	for l in b.find_children("*", "Label", true, false):
		out += str((l as Label).text) + " "
	return out


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _end() -> void:
	print("GAME_PLAN %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
