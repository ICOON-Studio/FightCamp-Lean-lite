extends SceneTree
## S373 FLOWBOUT1 wiring: the bout's plan record (PlanRecord, kept on each result as "plan_rec") shows on screen - the
## Record tab says what the plan did that night, and each Game plan line says how its move has done across real bouts.
## Population: a quick-start career with its first fighter signed (as game_plan_test); two kept results written for the
## move on the fighter's long-range line - 5 of 8 and 3 of 4 planned exchanges won (8 of 12 = works) - and one bout
## with no tally (an old save).

const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
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
	var c: Career = main.career
	var f: Dictionary = c.fighters[0]
	var arrows: Array = f.get("arrows", [])
	if arrows.is_empty():
		arrows = PlanFight.starter().duplicate(true)
		f["arrows"] = arrows
	var line: Dictionary = PlanLines.lines(arrows)[0]
	var mid := str(arrows[PlanLines.find(arrows, str(line["place"]), str(line["when"]))]["move"])
	c.results.push_front({"d": 30, "fid": f["id"], "who": f["first"], "opp": "Maria Ortega", "win": true, "outcome": "win",
		"pro": false, "cards": "30-27 x3", "why": "the jab kept her out",
		"plan_rec": {"plan": [mid], "used": 8, "worked": 5, "improvised": 3, "lines": {mid: [5, 8]}}})
	c.results.push_front({"d": 44, "fid": f["id"], "who": f["first"], "opp": "Priya Nair", "win": false, "outcome": "loss",
		"pro": false, "cards": "28-29 x3", "why": "outworked late", "plan_rec": {"plan": [mid], "used": 4, "worked": 3, "improvised": 6, "lines": {mid: [3, 4]}}})
	c.results.push_front({"d": 50, "fid": f["id"], "who": f["first"], "opp": "Erin Doyle", "win": true, "outcome": "win",
		"pro": false, "cards": "30-27 x3", "why": "an old save", "plan_rec": {}})

	# 1. The Record tab: a bout's line says what the plan did; a bout with no tally says nothing about a plan.
	main.act("fighter", str(f["id"]))
	main.act("ftab", "4")   # FighterPage.TABS[4] = Record
	await _frames(8)
	var text := _texts(main)
	_check(text.contains("Plan: 5 of 8 planned exchanges won, 3 improvised."), "test 1: the Maria Ortega bout shows its plan tally")
	_check(text.contains("Plan: 3 of 4 planned exchanges won, 6 improvised."), "test 1: the Priya Nair bout shows its own")
	_check(text.count("Plan: ") == 2, "test 1: the old-save bout carries no plan line (%d)" % text.count("Plan: "))

	# 2. The Game plan line for that move: 8 of 12 across the two bouts, PlanRecord's word "works".
	GamePlan.open = ""
	main.act("go", "playbook:1")
	await _frames(10)
	var chip := main.find_child("InBouts_" + mid.replace("@", "_").replace(" ", "_"), true, false)
	_check(chip != null, "test 2: the %s line shows how it did in real bouts" % mid)
	var chip_text := _texts(chip) if chip != null else ""
	_check(chip_text.contains("In bouts: 8 of 12 won, works"), "test 2: 8 of 12 won reads works (%s)" % chip_text)
	_end()


func _texts(n: Node) -> String:
	var out := ""
	for l in n.find_children("*", "Label", true, false):
		out += str((l as Label).text) + "\n"
	if n is Label:
		out += str((n as Label).text)
	return out


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		_fails += 1
		print("FAIL ", label)


func _end() -> void:
	print("PLAN_RECORD_UI failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)
