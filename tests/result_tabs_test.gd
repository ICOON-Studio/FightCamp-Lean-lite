extends SceneTree
## S443 RESULTTABS: the fight result as a summary with tabs (operator Q-S294-199 "Yes, summary + tabs"). Plays the result
## page's sample bout through the game's own fight night (tools/result_dump.gd, the first of seeds 44-63 with a measured fix) and
## builds the real page: the summary holds the verdict, ONE cause with its measured fix (FixLab), what it cost and the
## rounds strip; the three tabs build; the fix button writes the measured lines into the plan; no he/she in the words.

const Dump := preload("res://tools/result_dump.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")
const FightNight := preload("res://scripts/ui/modals/FightNight.gd")
const BoutActs := preload("res://scripts/ui/BoutActs.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")

var failures := 0
var asserts := 0


func _initialize() -> void:
	# S468: the page's sample bout is no longer pinned to seed 44's story (since the S466 card fix that bout never walks a
	# planned line into the opponent's game, so FixLab had no cause; best was "" and the read of the fix's lines below was
	# a script error that left the test hanging). The sample is the first bout of seeds 44-63 where FixLab finds a line to
	# rewrite; what is checked is FixLab's rule on that bout, not which line a seed loses on. tools/fixlab_scan.gd (S468):
	# on all 20 the plan as written wins 9 of 40 and the best change 11, under MIN_GAIN, so the page offers NO fix - that
	# case is checked as the page draws it, and the button's path is then walked with the rewrite set as the fix.
	var c: Career
	var f: Dictionary
	var m: Dictionary
	var seed_used := -1
	for sd in range(44, 64):
		var cf := Dump._setup(sd)
		var mm := Dump._fight(cf[0], cf[1], Dump.PLAN, true)
		var pre := FixLab.run(cf[0], mm)
		if bool(pre.get("ok", false)) and (pre["changes"] as Dictionary).has("rewrite"):
			c = cf[0]
			f = cf[1]
			m = mm
			seed_used = sd
			break
	_check(seed_used >= 0, "one bout of seeds 44-63 has a line FixLab would rewrite")
	if seed_used < 0:
		print("RESULT_TABS failures=%d" % failures)
		quit(1)
		return
	print("RESULT_TABS sample bout: seed %d" % seed_used)
	m["step"] = "result"
	m["night_seen"] = true   # the headline card was seen (HeadlineCard)
	_check(m.has("lab_from"), "the bout keeps the boxer at the first bell (lab_from); outcome %s %s" % [m["outcome"], str(m["cards"])])
	var worst := _lab_rules(c, f, m)
	var desk := Desk.new()
	desk.career = c
	desk.modal = m
	root.add_child(desk)
	var page := _page(desk, m)
	_check(m.has("fixlab") and not m.has("lab_from"), "the fix is measured once, on the first draw")
	if not m.has("fixlab"):
		print("RESULT_TABS failures=%d" % (failures + 1))
		quit(1)
		return
	var lab: Dictionary = m["fixlab"]
	print("RESULT_TABS lab written=%d best=%s best_wins=%d verdict=%s of %d" % [int(lab["written"]), lab["best"], int(lab["best_wins"]), lab["verdict"], int(lab["nights"])])
	var fixed := str(lab["best"]) != ""
	for n in ["ResultHead", "Judges", "WhyRank", "ResultTabs", "Tab_summary", "Cause", "CauseHead", "FixLadder", "FixVerdict", "Cost", "RoundStrip", "BackHome"]:
		_check(page.find_child(n, true, false) != null, "the summary holds %s" % n)
	_check((page.find_child("PlanFix", true, false) != null) == fixed, "the fix button is there only when a change beats luck (best '%s')" % str(lab["best"]))
	var head: Label = page.find_child("CauseHead", true, false)
	var cause := "Line %s: %s" % [FixLab.LETTERS[int(worst["i"])], ResultCause._move(str(worst["move"]))]
	_check(head != null and head.text.begins_with(cause), "the one cause is the line that lost most, '%s': '%s'" % [cause, head.text if head else ""])
	var verdict: Label = page.find_child("FixVerdict", true, false)
	print("RESULT_TABS verdict: %s" % (verdict.text if verdict else ""))
	_check(verdict != null and (verdict.text.contains("Even the best plan") == (["even", "class"].has(str(lab["verdict"])))), "the verdict sentence follows the numbers")
	_check(not fixed or str(lab["best"]) == "both" or int(lab["changes"].get("both", {}).get("wins", -1)) < int(lab["best_wins"]), "both changes are the fix unless they win less")
	for k in lab["changes"]:
		_check((str(lab["best"]) != str(k)) or int(lab["changes"][k]["wins"]) - int(lab["written"]) >= FixLab.MIN_GAIN, "the fix beats the plan as written by %d nights or more" % FixLab.MIN_GAIN)
	_check(int((page.find_child("Round1", true, false) as Node).get_child(0).get_child_count()) >= 2, "the rounds strip draws round 1")
	_check(_pronouns(page) == "", "no he/she on the summary: %s" % _pronouns(page))
	for t in ["exchanges", "numbers", "plan"]:
		m["result_tab"] = t
		page = _page(desk, m)
		_check(page.find_child("Tab_" + t, true, false) != null and page.find_child("BackHome", true, false) != null, "the %s tab builds with Back home" % t)
		_check(_pronouns(page) == "", "no he/she on the %s tab: %s" % [t, _pronouns(page)])
	if not fixed:
		lab["best"] = "rewrite"   # no change beat luck on this bout: the button's path is walked with the rewrite as the fix
		m["result_tab"] = "summary"
		page = _page(desk, m)
		_check(page.find_child("PlanFix", true, false) != null, "with a fix the summary holds PlanFix")
	var want: Array = lab["changes"][str(lab["best"])]["arrows"]
	BoutActs.act(desk, "planfix", str(f["id"]))
	_check(f["arrows"] == want and bool(m.get("fix_done", false)), "Put the fix in the plan writes the measured lines: %s" % str(f["arrows"]))
	m["result_tab"] = "summary"
	page = _page(desk, m)
	var b: Button = page.find_child("PlanFix", true, false)
	_check(b != null and b.disabled, "the fix button reads as done once pressed")
	print("RESULT_TABS asserts=%d" % asserts)
	print("RESULT_TABS failures=%d" % failures)
	quit(failures)


## FixLab's choices on this bout, from the records: the planned line lost most while it walked into the opponent's game
## is the line to rewrite, to another move the Playbook offers at that line's own place; both changes fit the coach's lines.
func _lab_rules(c: Career, f: Dictionary, m: Dictionary) -> Dictionary:
	var from: Dictionary = m["lab_from"]
	var arrows: Array = from["arrows"]
	var worst := FixLab.worst_line(arrows, m["rounds"])
	var wi := int(worst.get("i", -1))
	_check(wi >= 0 and wi < arrows.size() and str(arrows[wi]["move"]) == str(worst.get("move", "")) and int(worst.get("lost", 0)) > 0,
		"the worst line is one of the plan's own and lost exchanges: %s" % str(worst))
	var ch := FixLab.changes(from, m["rounds"], 4)
	var to := str(ch.get("rewrite", {}).get("to", ""))
	_check(to != "" and to != str(worst.get("move", "")), "the worst line is rewritten to another move: %s" % to)
	_check(PlanLines.options(str(worst.get("place", "")), str(ch.get("rewrite", {}).get("sit", "")), from.get("moves", {}), from.get("combos", {})).any(
		func(o): return str(o["id"]) == to and str(o["why"]) == ""), "the rewrite is a move the Playbook offers at that line's place: %s" % to)
	if ch.has("add"):
		_check(PlanLines.find(arrows, PlanLines.place_for(str(ch["add"]["sit"])), str(ch["add"]["sit"])) < 0, "the new line answers a situation no line had: %s" % str(ch["add"]["sit"]))
	if ch.has("both"):
		_check((ch["both"]["arrows"] as Array).size() <= 4, "both changes fit the 4 lines a coach holds")
	var full := FixLab.changes(from, m["rounds"], 3)
	# S461: the fixture's plan now fires (result_dump gives its combos at Sharp), so which line went unused is read off the bout
	# itself: FixLab's rule - a full plan's new line replaces a line that never fired, and with every line fired it offers none.
	var fired := {}
	for r in m["rounds"]:
		for x in r["exchanges"]:
			if bool(x.get("planned", false)):
				fired[str(x.get("arrow", ""))] = true
	var unused: Array = (from["arrows"] as Array).filter(func(a): return not fired.has(str(a["move"])))
	if unused.is_empty():
		_check(not full.has("add"), "a full plan with every line fired gets no new line (%s)" % str(full.get("add", {})))
	else:
		_check(unused.any(func(a): return str(a["move"]) == str(full.get("add", {}).get("replaces", ""))),
			"a full plan puts the new line in place of one never used (%s; unused %s)" % [str(full.get("add", {}).get("replaces", "")), str(unused)])
	_check(FixLab.verdict(25, 30, 40) == "plan_right" and FixLab.verdict(5, 18, 40) == "even" and FixLab.verdict(5, 12, 40) == "class" and FixLab.verdict(5, 30, 40) == "fixed", "the verdict bands")
	return worst


func _page(desk: Desk, m: Dictionary) -> Control:
	for ch in desk.get_children():
		desk.remove_child(ch)
		ch.free()
	var night := FightNight.new()
	desk.add_child(night)
	night.build(desk, m)
	return night


## The first label with he/she/her/him/his in it ("" when none).
func _pronouns(n: Node) -> String:
	var re := RegEx.create_from_string("\\b(he|she|her|him|his|hers|himself|herself)\\b")
	for l in n.find_children("*", "Label", true, false):
		if re.search((l as Label).text.to_lower()) != null:
			return (l as Label).text
	for b in n.find_children("*", "Button", true, false):
		if re.search((b as Button).text.to_lower()) != null:
			return (b as Button).text
	return ""


func _check(ok: bool, label: String) -> void:
	asserts += 1
	if not ok:
		failures += 1
		print("FAIL ", label)


class Desk extends Node:
	var career: Career
	var modal: Dictionary = {}
	func act(_what: String, _arg: String = "") -> void:
		pass
	func open_modal(m: Dictionary) -> void:
		modal = m
	func redraw_modal() -> void:
		pass
	func toast(_t: String) -> void:
		pass
