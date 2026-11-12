extends SceneTree
## S443 RESULTTABS: the fight result as a summary with tabs (operator Q-S294-199 "Yes, summary + tabs"). Plays the result
## page's sample bout through the game's own fight night (tools/result_dump.gd seed 44: Lucy v Priya, lost on a split) and
## builds the real page: the summary holds the verdict, ONE cause with its measured fix (FixLab), what it cost and the
## rounds strip; the three tabs build; the fix button writes the measured lines into the plan; no he/she in the words.

const Dump := preload("res://tools/result_dump.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")
const FightNight := preload("res://scripts/ui/modals/FightNight.gd")
const BoutActs := preload("res://scripts/ui/BoutActs.gd")

var failures := 0
var asserts := 0


func _initialize() -> void:
	var cf := Dump._setup(44)
	var c: Career = cf[0]
	var f: Dictionary = cf[1]
	var m := Dump._fight(c, f, Dump.PLAN, true)
	m["step"] = "result"
	m["night_seen"] = true   # the headline card was seen (HeadlineCard)
	_check(m.has("lab_from"), "the bout keeps the boxer at the first bell (lab_from); outcome %s %s" % [m["outcome"], str(m["cards"])])
	_lab_rules(c, f, m)
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
	for n in ["ResultHead", "Judges", "WhyRank", "ResultTabs", "Tab_summary", "Cause", "CauseHead", "FixLadder", "FixVerdict", "PlanFix", "Cost", "RoundStrip", "BackHome"]:
		_check(page.find_child(n, true, false) != null, "the summary holds %s" % n)
	var head: Label = page.find_child("CauseHead", true, false)
	_check(head != null and head.text.contains("Line C") and head.text.contains("One-two-hook"), "the one cause is line C's One-two-hook: '%s'" % (head.text if head else ""))
	var verdict: Label = page.find_child("FixVerdict", true, false)
	print("RESULT_TABS verdict: %s" % (verdict.text if verdict else ""))
	_check(verdict != null and (verdict.text.contains("Even the best plan") == (["even", "class"].has(str(lab["verdict"])))), "the verdict sentence follows the numbers")
	_check(str(lab["best"]) == "both" or int(lab["changes"].get("both", {}).get("wins", -1)) < int(lab["best_wins"]), "both changes are the fix unless they win less")
	_check(int((page.find_child("Round1", true, false) as Node).get_child(0).get_child_count()) >= 2, "the rounds strip draws round 1")
	_check(_pronouns(page) == "", "no he/she on the summary: %s" % _pronouns(page))
	for t in ["exchanges", "numbers", "plan"]:
		m["result_tab"] = t
		page = _page(desk, m)
		_check(page.find_child("Tab_" + t, true, false) != null and page.find_child("BackHome", true, false) != null, "the %s tab builds with Back home" % t)
		_check(_pronouns(page) == "", "no he/she on the %s tab: %s" % [t, _pronouns(page)])
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


## FixLab's choices on this bout, from the records: line C (One-two-hook v the counter) is the line to rewrite, to the
## Playbook's top answer at long range (Double jab); loading up is the situation lost most with no line.
func _lab_rules(c: Career, f: Dictionary, m: Dictionary) -> void:
	var from: Dictionary = m["lab_from"]
	var worst := FixLab.worst_line(from["arrows"], m["rounds"])
	_check(str(worst.get("move", "")) == "1-2-3" and int(worst.get("i", -1)) == 2, "the worst line is C, One-two-hook: %s" % str(worst))
	var ch := FixLab.changes(from, m["rounds"], 4)
	_check(str(ch.get("rewrite", {}).get("to", "")) == "1-1", "C is rewritten to Double jab: %s" % str(ch.get("rewrite", {}).get("to", "")))
	_check(str(ch.get("add", {}).get("sit", "")) == "loadup" and str(ch.get("add", {}).get("to", "")) == "step_back", "the new line: loads up -> Step back")
	_check((ch.get("both", {}).get("arrows", []) as Array).size() == 4, "both changes hold 4 lines for a coach who holds 4")
	var full := FixLab.changes(from, m["rounds"], 3)
	_check(str(full.get("add", {}).get("replaces", "")) == "step_back" and int(full["add"]["i"]) == 1, "a full plan puts the new line in place of B, never used")
	_check(FixLab.verdict(25, 30, 40) == "plan_right" and FixLab.verdict(5, 18, 40) == "even" and FixLab.verdict(5, 12, 40) == "class" and FixLab.verdict(5, 30, 40) == "fixed", "the verdict bands")


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
