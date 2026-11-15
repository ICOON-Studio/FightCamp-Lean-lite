extends SceneTree
## S482 PLANFLOW1 golden path (his Q-240 "Yes, build it": one Game plan page, set up in four clicks). Walks the chart the way
## the player does: 1) the bell box - a range's answer; 2) + Add an IF - the opponent's file, their game first; 3) the
## answer to the new IF; 4) Test it on a sparring night. Every pick lands on fighter.arrows (the plan the bout reads).
## Population: a quick-start career, its first fighter signed, a bout booked against Data.OPPONENTS[1] (a known game).

const Data := preload("res://scripts/state/Data.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")

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
	var c: Career = main.career
	var f: Dictionary = c.fighters[0]
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	f["bout"] = {"opp": opp, "day": c.day + 14, "weighed": false, "made": false, "done": false, "film": 1}
	f["arrows"] = PlanLines.set_line([], "mid", "", str(SM.outs("mid")[0]["id"]))   # one line: room for the walk
	# S482: the coach's suggestion fires - no line of it sits under the fire rule's 30 (a new boxer has steps and combos at 0).
	f["arrows"] = []
	main.act("go", "playbook:1")
	await _frames(6)
	var sug: Array = (main.find_child("GamePlan", true, false)).arrows
	_check(not sug.is_empty() and sug.all(func(a): return FireLevel.mastery_of(f, str(a["move"])) >= FireLevel.USABLE_AT),
		"the coach's suggestion is lines she can fire (%s)" % ", ".join(sug.map(func(a): return str(a["move"]))))
	f["arrows"] = PlanLines.set_line([], "mid", "", str(SM.outs("mid")[0]["id"]))   # one line: room for the walk
	GamePlan.open = ""
	GamePlan.vs = ""
	GamePlan.adding = ""
	PlanChart.adding_if = false
	main.act("go", "playbook:1")
	await _frames(10)
	var gp := main.find_child("GamePlan", true, false)
	_check(gp != null and gp.get_script() == PlanChart, "the Game plan page is the chart")
	if gp == null:
		_end()
		return
	_check(gp.find_child("BellBox", true, false) != null, "the bell box is on the chart")
	_check(gp.find_child("AddIf", true, false) != null, "the dashed + Add an IF is on the chart")
	_check(gp.find_child("PlanLeft", true, false) != null and gp.find_child("PlanFile", true, false) != null, "the opponent's file is on the left")
	_check(gp.find_child("TestIt", true, false) != null, "Test it is on the page with a bout booked")
	var lists := gp.find_children("Line_*", "", true, false).filter(func(n): return n.get_parent().name == "GamePlan")
	_check(lists.is_empty(), "the list is gone: no line is a row of the page itself")

	# 1) The bell box: click a range, pick an answer.
	var long_row: Node = gp.find_child("Line_long_", true, false)
	var write: Button = long_row.find_children("*", "Button", true, false)[0] if long_row != null else null
	_check(write != null and write.text == "Write a line", "click 1: the bell box's long range waits for a line")
	if write != null:
		write.pressed.emit()
		await _frames(3)
	gp = main.find_child("GamePlan", true, false)
	var pop := gp.find_child("AnswerList", true, false)
	_check(pop != null, "click 1: the range's answers open")
	var opt := _first_open(pop)
	if opt != null:
		opt.pressed.emit()
		await _frames(3)
	_check(PlanLines.find(f.get("arrows", []), "long") >= 0, "click 1: the pick is on fighter.arrows (the plan the bout reads)")
	gp = main.find_child("GamePlan", true, false)
	_check(gp.find_child("AnswerList", true, false) == null, "click 1: the list closes on a pick")

	# 2) + Add an IF: the opponent's file, their game first.
	var add: Control = gp.find_child("AddIf", true, false)
	add.on_click.call()
	await _frames(3)
	gp = main.find_child("GamePlan", true, false)
	var ifs := gp.find_child("AddIfList", true, false)
	_check(ifs != null, "click 2: + Add an IF opens the list")
	var game := OppFile.main_game(opp)
	var picks: Array = ifs.find_children("AddIf_*", "Button", true, false) if ifs != null else []
	_check(not picks.is_empty() and str((picks[0] as Node).name) == "AddIf_" + game, "click 2: the opponent's game comes first (%s)" % game)
	var heard := false
	for l in ifs.find_children("*", "Label", true, false) if ifs != null else []:
		var t := str((l as Label).text)
		heard = heard or t.contains("she ") or t.contains(" her ") or t.contains(str(f.get("first", "@@")))
	_check(not heard, "click 2: no names or she/her in the list (S448, S412)")
	if not picks.is_empty():
		(picks[0] as Button).pressed.emit()
		await _frames(3)

	# 3) The answer to the new IF.
	gp = main.find_child("GamePlan", true, false)
	_check(gp.find_child("If_" + game, true, false) != null, "click 3: the new diamond is drawn")
	pop = gp.find_child("AnswerList", true, false)
	_check(pop != null, "click 3: its answers open at once")
	opt = _first_open(pop)
	if opt != null:
		opt.pressed.emit()
		await _frames(3)
	var place := PlanLines.place_for(game)
	_check(PlanLines.find(f.get("arrows", []), place, game) >= 0, "click 3: the IF's answer is saved with its when (%s at %s)" % [game, place])
	gp = main.find_child("GamePlan", true, false)
	_check(gp.find_child("Line_%s_%s" % [place, game], true, false) != null, "click 3: the answer box sits beside its diamond")

	# 4) Test it: a sparring night against the opponent; the result shows on the right.
	var tb: Button = gp.find_child("TestIt", true, false)
	if tb != null and not tb.disabled:
		tb.pressed.emit()
		await _frames(3)
		_check(not (f["bout"].get("plan_test", {}) as Dictionary).is_empty(), "click 4: Test it ran on the plan")
	else:
		_check(false, "click 4: Test it is pressable")
	_end()


func _first_open(pop: Node) -> Button:
	if pop == null:
		return null
	for b in pop.find_children("Opt_*", "Button", true, false):
		if (b as Button).modulate.a > 0.9:
			return b
	return null


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print(("ok   " if ok else "FAIL ") + what)


func _end() -> void:
	print("PLAN_CHART %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)
