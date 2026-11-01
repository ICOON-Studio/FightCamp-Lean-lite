extends SceneTree
## NEXT STEP card on her fighter page OVERVIEW tab.

const NextStep := preload("res://scripts/rules/NextStep.gd")
const FighterPageScript := preload("res://scripts/ui/areas/FighterPage.gd")
const UI := preload("res://scripts/ui/UI.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	_quick_sign()
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	main.act("fighter", "lucy")
	main.act("ftab", "0")
	await process_frame
	var need_new := _check_page(c, f, false)
	print("need_new=%s" % need_new)
	f["w"] = 5
	f["l"] = 0
	f.erase("d")
	f["registered"] = c.day - 100
	main.act("ftab", "1")
	main.act("ftab", "0")
	await process_frame
	var need_after := _check_page(c, f, true)
	print("need_after=%s" % need_after)
	if failures == 0:
		print("PASS next_step_card_test")
	else:
		print("FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)


func _quick_sign() -> void:
	main.act("quick")
	main.career.seed = 1
	main.act("go_btn")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await process_frame


func _fighter_page() -> Node:
	var page: Node = main._shell.find_child("FighterPage", true, false)
	_check(page != null, "fighter page is open")
	return page


func _next_step_card(page: Node) -> VBoxContainer:
	var cards: Array = []
	for p in page.find_children("*", "PanelContainer", true, false):
		if str(p.theme_type_variation) != "Card":
			continue
		for l in p.find_children("*", "Label", true, false):
			if str(l.text) == "NEXT STEP":
				var bodies: Array = p.find_children("*", "VBoxContainer", true, false)
				for b in bodies:
					if b.get_parent() == p:
						return b
	_check(false, "NEXT STEP card exists")
	return null


func _chip_texts(page: Node) -> Array:
	var texts: Array = []
	for p in page.find_children("*", "PanelContainer", true, false):
		var v := str(p.theme_type_variation)
		if not v.begins_with("Chip"):
			continue
		for l in p.find_children("*", "Label", true, false):
			if l.get_parent() == p:
				texts.append({"text": str(l.text), "gold": v == "ChipGold"})
	return texts


func _check_page(c: Career, f: Dictionary, after_edit: bool) -> String:
	var page := _fighter_page()
	if page == null:
		return ""
	var card := _next_step_card(page)
	if card == null:
		return ""
	# First card: the NEXT STEP panel is the first Card on the page (after header chrome).
	var first_card: PanelContainer = null
	for ch in page.get_children():
		if ch is PanelContainer and str(ch.theme_type_variation) == "Card":
			first_card = ch
			break
	_check(first_card != null and card.get_parent() == first_card, "NEXT STEP is the first card")

	var inp: Dictionary = FighterPageScript._road_input(c, f)
	var road: Dictionary = NextStep.road(inp, c.day)
	var expected_need: String = str(road["need"])

	for step_name in NextStep.STEPS:
		var found := false
		for row in _chip_texts(card):
			if str(row["text"]).contains(step_name):
				found = true
				break
		_check(found, "shows step '%s'" % step_name)

	var gold := _chip_texts(card).filter(func(row): return bool(row["gold"]))
	_check(gold.size() == 1, "exactly one lit chip (got %d)" % gold.size())

	var need_found := ""
	for l in card.find_children("*", "Label", true, false):
		var t := str(l.text)
		if t == expected_need:
			need_found = t
			break
	_check(need_found == expected_need, "need line matches NextStep.road (expected '%s')" % expected_need)
	_check(expected_need != "", "need line is not empty")

	if after_edit:
		var lit_name := ""
		if int(road["lit"]) >= 0:
			lit_name = str(road["steps"][road["lit"]]["name"])
		var ok_lit := lit_name == "The nationals" or int(road["lit"]) > 2
		_check(ok_lit, "after edit lit step is The nationals or later (lit=%d '%s')" % [road["lit"], lit_name])

	return expected_need
