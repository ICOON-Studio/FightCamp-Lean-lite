extends SceneTree
## OFFERGONE1: an expired fight offer is never a dead end. BoutPage with an unknown id shows "That offer is gone." and a
## "Back to Fights" button that opens the Fights area. Needs never points at an expired, answered or missing offer
## (expiry sets `answered` as well as `expired`, in Bouts.day_events, so the flag's `answered` check covers it).

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const BOUT_PAGE := preload("res://scenes/areas/BoutPage.tscn")

var failures := 0


func _initialize() -> void:
	await _run()
	print("OFFER_GONE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _run() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	# No career loaded: the null branch still has a way on.
	_check(_gone_page(main), "no career: the page has a 'Back to Fights' button")

	# A real career: an unknown id reaches the 'not found' branch.
	main.act("quick")
	var c: Career = main.career
	c.first_hour = {}
	main.act("go_btn")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
		await process_frame
	await process_frame
	var sign := main.modal_node().find_child("Sign", true, false) as Button
	_check(sign != null, "the interview has a Sign button")
	if sign == null:
		return
	sign.pressed.emit()
	_check(c.fighters.size() == 1, "a boxer is signed")
	if c.fighters.is_empty():
		return
	_check(_gone_page(main), "unknown offer id: the page has a 'Back to Fights' button")

	# Needs: a flag exists only while the offer can be answered.
	var f: Dictionary = c.fighters[0]
	var open := _offer(c, "t:open", c.day + 3)
	f["offers"] = [open]
	_check(_flagged(c, "t:open"), "an open offer has its flag")
	open["answered"] = true
	_check(not _flagged(c, "t:open"), "an answered offer has no flag")
	var late := _offer(c, "t:late", c.day)
	f["offers"] = [late]
	c.day += 1
	Bouts.day_events(c)
	_check(bool(late["expired"]), "the offer expired when its day passed")
	_check(not _flagged(c, "t:late"), "an expired offer has no flag")
	f["offers"] = []
	_check(not _flagged(c, "t:late"), "an offer that no longer exists has no flag")


func _gone_page(main: Node) -> bool:
	var page := BOUT_PAGE.instantiate()
	root.add_child(page)
	page.build(main, "nonexistent:offer")
	var ok := _find_button_in(page, "Back to Fights") != null
	page.queue_free()
	return ok


func _offer(c: Career, id: String, expires: int) -> Dictionary:
	var o := Bouts._offer(id, (c.rivals[0] as Dictionary).duplicate(true), c.day + 21, expires, 0)
	o["mismatch"] = false
	return o


func _flagged(c: Career, id: String) -> bool:
	for n in Needs.needs(c):
		if str((n as Dictionary).get("act", "")) == "openBout" and str((n as Dictionary).get("arg", "")) == id:
			return true
	return false


func _find_button_in(node: Node, text: String) -> Button:
	for child in node.get_children():
		if child is Button and (child as Button).text == text:
			return child as Button
		var found := _find_button_in(child, text)
		if found:
			return found
	return null
