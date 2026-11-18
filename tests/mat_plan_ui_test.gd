extends SceneTree
## S515 MATPLANUI1 (MATPLAN_MAP_S433 section 6, M8 first cut): Ana's plan lines on her Playbook page, wired to the plan
## the match reads (f["bjj_plan"].lines / board, BjjBeat.walk). Population: a quick-start career, Ana Ribeiro on the mat.
## Prints MAT_PLAN_UI failures=N.

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")
const Info := preload("res://scripts/ui/MatTreeInfo.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const PRONOUN := "\\b(he|him|his|himself|she|her|hers|herself)\\b"

var _fails := 0
var main: Node


func _initialize() -> void:
	BjjTree.reset_tuning()
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	FirstWeek.ana_joins(main.career)
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	var f: Dictionary = c.grappler_by_id("ana")
	_check(not f.is_empty(), "Ana is on the mat")
	Playbook.pick = "ana"
	main.act("go", "playbook:0")
	await _frames(6)
	var panel := main.find_child("MatPlanPanel", true, false)
	_check(panel != null, "the plan panel is on Ana's Playbook page")
	var plan: Dictionary = f.get("bjj_plan", {})
	var lines: Array = plan.get("lines", [])
	_check(not lines.is_empty() and bool(plan.get("drafted", false)), "a plan with no lines gets the coach's draft (%d lines)" % lines.size())
	_check(MatLines.validate(f, plan, Info.rules(f)).is_empty(), "the draft is a valid plan")
	_check(lines.size() == MatLines.hand_size("white") and lines.any(func(l): return str(BjjTree.edge(str(l["edge"])).get("odds", "")) == "submission"),
		"the draft fills the white hand (3) and keeps a finish")
	for n in ["CoachDraft", "AddLines", "Scoreboard", "Board_behind_push", "Board_ahead_save"]:
		_check(main.find_child(n, true, false) != null, "%s is on the page" % n)
	var first := str(lines[0]["at"])
	_check(main.find_child("Line_" + first, true, false) != null, "a row for the first line (%s)" % first)
	# The timing chip cycles the line the match reads.
	var t0 := str(lines[0]["timing"])
	(main.find_child("Timing_" + first, true, false) as Button).pressed.emit()
	await _frames(1)
	_check(str(_line(f, first).get("timing", "")) != t0 and not bool(f["bjj_plan"].get("drafted", true)),
		"Timing click: %s -> %s, the plan is now yours" % [t0, str(_line(f, first).get("timing", ""))])
	# The scoreboard writes the board row.
	(main.find_child("Board_level_push", true, false) as Button).pressed.emit()
	await _frames(1)
	_check(str((f["bjj_plan"]["board"] as Dictionary).get("level", "")) == "push", "LEVEL Push is written to the plan's board")
	# Drop takes a line out; Add puts an escape back.
	var n0: int = (f["bjj_plan"]["lines"] as Array).size()
	(main.find_child("Drop_" + first, true, false) as Button).pressed.emit()
	await _frames(1)
	_check((f["bjj_plan"]["lines"] as Array).size() == n0 - 1, "Drop takes the line out")
	var add := main.find_child("Add_" + first, true, false) as Button
	if add != null:
		add.pressed.emit()
		await _frames(1)
	_check(not _line(f, first).is_empty(), "Add puts an escape back on %s" % first)
	# Coach's draft puts the draft back.
	(main.find_child("CoachDraft", true, false) as Button).pressed.emit()
	await _frames(1)
	_check(bool(f["bjj_plan"].get("drafted", false)) and str((f["bjj_plan"]["board"] as Dictionary).get("level", "")) == "steady",
		"Coach's draft restores the draft (level Steady)")
	# A new A-game route keeps the lines.
	var keep: int = (f["bjj_plan"]["lines"] as Array).size()
	(main.find_child("Goal_back", true, false) as Button).pressed.emit()
	await _frames(2)
	_check((f["bjj_plan"].get("lines", []) as Array).size() == keep, "a new route (Goal back) keeps the plan's lines")
	# No he/him words on the panel.
	var bad := 0
	var re := RegEx.create_from_string(PRONOUN)
	for l in main.find_child("MatPlanPanel", true, false).find_children("*", "Label", true, false):
		if re.search((l as Label).text.to_lower()) != null:
			bad += 1
	_check(bad == 0, "no he / she words on the panel")
	# The open night shows YOUR PLAN with the brought lines (MATPLAN_MAP_S433 section 6).
	Grapplers.live = true
	var d := c.day + 1
	while load("res://scripts/rules/NoGi.gd").open_on(d).is_empty() and d < c.day + 200:
		d += 1
	_check(Grapplers.enter(c, "ana", d) == "", "Ana enters an open")
	c.day = d
	Grapplers.day(c)
	main.act("opennight", "ana")
	await _frames(3)
	var pl := main.find_child("OpenPlan", true, false) as Label
	var first_mv := BjjTree.move_name(str(BjjTree.edge(str(f["bjj_plan"]["lines"][0]["edge"])).get("move", "")))
	_check(pl != null and pl.text.contains("YOUR PLAN") and pl.text.contains(first_mv) and pl.text.contains("in 100"),
		"the open night says YOUR PLAN with the lines (%s)" % (pl.text if pl != null else "none"))
	Grapplers.live = false
	print("MAT_PLAN_UI failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _line(f: Dictionary, at: String) -> Dictionary:
	for l in f["bjj_plan"].get("lines", []):
		if str(l.get("at", "")) == at:
			return l
	return {}


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
