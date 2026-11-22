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
const PlanBet := preload("res://scripts/ui/PlanBet.gd")
const PlanSaves := preload("res://scripts/ui/PlanSaves.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const Dump := preload("res://tools/result_dump.gd")

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

	# 5) S483 MODETELLS1: film finds the opponent's modes; the + Add an IF list says how often (FOUND: OFTEN/SOME/RARE) and
	# the file column carries the same word.
	OppFile.open_all(opp)
	PlanChart.adding_if = false
	main.act("go", "playbook:1")
	await _frames(6)
	gp = main.find_child("GamePlan", true, false)
	var file_txt := " ".join(gp.find_child("PlanFile", true, false).find_children("*", "Label", true, false).map(func(l): return str(l.text)))
	_check(file_txt.contains("SOME (") or file_txt.contains("OFTEN (") or file_txt.contains("RARE ("), "the file column shows a mode's band (%s)" % file_txt.left(160))
	add = gp.find_child("AddIf", true, false)
	add.on_click.call()
	await _frames(3)
	ifs = main.find_child("GamePlan", true, false).find_child("AddIfList", true, false)
	var chips := " ".join(ifs.find_children("*", "Label", true, false).map(func(l): return str(l.text))) if ifs != null else ""
	_check(chips.contains("FOUND: SOME") or chips.contains("FOUND: OFTEN") or chips.contains("FOUND: RARE"), "the IF list names a found mode's band (%s)" % chips.left(200))
	await _planflow2(main, c, f)
	_end()


## S538 PLANFLOW2 (owner Q-S294-301 "yes add those"): 6) mark the main bet; 7) save the plan under a name; 8) clear the
## chart; 9) load it back (only the lines this boxer can fire, the dropped ones named); 10) a fought bout: the result
## page's Plan tab judges the bet, and the chart shows each line's uses.
func _planflow2(main: Node, c: Career, f: Dictionary) -> void:
	PlanChart.adding_if = false
	GamePlan.open = ""
	PlanSaves.open = false
	main.act("go", "playbook:1")
	await _frames(6)
	var gp := main.find_child("GamePlan", true, false)
	var bet_b: Button = gp.find_child("Bet_long_", true, false)
	_check(bet_b != null and bet_b.text == "Bet on it" and bet_b.tooltip_text.length() > 40 and not bet_b.tooltip_text.contains(bet_b.text),
		"6: a written line offers the bet, and its tooltip explains it")
	if bet_b != null:
		bet_b.pressed.emit()
		await _frames(3)
	var stamped: Array = (f["arrows"] as Array).filter(func(a): return bool(a.get("bet", false)))
	_check(str(f.get("plan_bet", "")) == "long|" and stamped.size() == 1 and PlanBet.key_of(stamped[0]) == "long|", "6: the bet is on the boxer's plan, on one line (%s)" % str(f["arrows"]))
	bet_b = gp.find_child("Bet_long_", true, false)
	_check(bet_b != null and bet_b.text == "MAIN BET", "6: the chart shows the line as the MAIN BET")

	var before: Array = (f["arrows"] as Array).duplicate(true)
	(gp.find_child("SavesBtn", true, false) as Button).pressed.emit()
	await _frames(3)
	var name_edit: LineEdit = gp.find_child("SaveName", true, false)
	_check(name_edit != null and gp.find_child("PlanSaves", true, false) != null, "7: Save / Load opens the saved plans")
	if name_edit == null:
		return
	name_edit.text = "Box the counter"
	(gp.find_child("SaveNow", true, false) as Button).pressed.emit()
	await _frames(3)
	_check(c.saved_plans.size() == 1 and str(c.saved_plans[0]["name"]) == "Box the counter" and c.saved_plans[0]["arrows"] == before,
		"7: the plan is saved with the career under its name, bet and all")

	gp._write([])
	gp._refresh()
	await _frames(3)
	_check((f["arrows"] as Array).is_empty() and not f.has("plan_bet"), "8: the chart is cleared (and the bet with its line)")

	var want := PlanSaves.fit(c.saved_plans[0], f, gp._limit())
	var load_b: Button = gp.find_child("Load", true, false)
	_check(load_b != null and load_b.disabled == (want["arrows"] as Array).is_empty() and load_b.tooltip_text.length() > 30, "9: the saved plan has a Load button that says what it will do")
	if load_b != null and not load_b.disabled:
		load_b.pressed.emit()
		await _frames(3)
		_check(f["arrows"] == want["arrows"] and not (f["arrows"] as Array).is_empty(), "9: the load puts the lines this boxer can fire on the plan (%d of %d)" % [(f["arrows"] as Array).size(), before.size()])
		_check((str(f.get("plan_bet", "")) == "long|") == (f["arrows"] as Array).any(func(a): return bool(a.get("bet", false))), "9: the bet comes back with its line")
		var told: Label = gp.find_child("SavesSaid", true, false)
		var all_named := (want["dropped"] as Array).all(func(d): return told != null and told.text.contains(str(d["name"])) and told.text.contains(str(d["why"])))
		_check(told != null and told.text.begins_with("Loaded") and all_named, "9: the page says what was loaded and names each dropped line and why (%s)" % (told.text if told else ""))
	PlanSaves.open = false

	# 10) a bout fought through the game's own fight night (tools/result_dump.gd: Lucy v Priya Nair, the plan A B C), A the bet.
	var cf: Array = Dump._setup(44)
	cf[1]["plan_bet"] = "long|"
	var m: Dictionary = Dump._fight(cf[0], cf[1], PlanBet.stamp(Dump.PLAN.duplicate(true), cf[1]), true)
	_check(bool(m["rounds"][0]["plan"][0].get("bet", false)), "10: the bout fought the plan with its bet marked")
	var tab: Control = ResultTabs.plan(m, [str(cf[1]["first"]), "Priya"])
	var said: Label = tab.find_child("MainBet", true, false)
	_check(said != null and said.text.begins_with("MAIN BET, line A") and said.text.contains("The bet "), "10: the result's Plan tab judges the bet (%s)" % (said.text if said else ""))
	tab.free()
	var rec: Dictionary = (cf[0] as Career).results[0]
	var lines: Dictionary = rec["plan_rec"]["lines"]
	print("PLAN_CHART bout record: %s" % str(rec["plan_rec"]))
	c.results.push_front(rec.merged({"fid": f["id"]}, true))
	f["arrows"] = Dump.PLAN.duplicate(true)
	main.act("go", "playbook:1")
	await _frames(8)
	gp = main.find_child("GamePlan", true, false)
	for a in Dump.PLAN:
		var mid := str(a["move"])
		var used := int((lines.get(mid, [0, 0]) as Array)[1])
		var chip := gp.find_child(("InBouts_" if used > 0 else "LastBout_") + mid.replace("@", "_").replace(" ", "_"), true, false)
		_check(chip != null, "10: after the bout the chart shows %s's uses (%s)" % [mid, "fired %d" % used if used > 0 else "never fired"])
	c.results.push_back(rec.merged({"fid": f["id"]}, true))   # a second bout on record: the last bout's own count shows beside the sum
	main.act("go", "playbook:1")
	await _frames(8)
	gp = main.find_child("GamePlan", true, false)
	var fired := 0
	for a in Dump.PLAN:
		var mid2 := str(a["move"])
		var per: Array = lines.get(mid2, [0, 0])
		if int(per[1]) > 0:
			fired += 1
			var last: Node = gp.find_child("LastBout_" + mid2.replace("@", "_").replace(" ", "_"), true, false)
			var txt := str((last.get_child(0) as Label).text) if last != null else ""
			_check(txt == "Last bout: fired %d, won %d" % [int(per[1]), int(per[0])], "10: %s shows the last bout's own count (%s)" % [mid2, txt])
	_check(fired > 0, "10: the bout threw at least one line of the plan")


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
