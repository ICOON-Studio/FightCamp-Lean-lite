extends SceneTree
## STAFFCARDS1 (S547, owner S545 on the Staff screen: "this screen is terrible"): the Staff window is CARDS (the S546
## mockup docs/mockups/s546/staff_cards.png). Two sections, AT THE GYM and JOBS OPEN; every person and job is ONE card
## StaffCard_<id> with a face or a silhouette, a name, at most four fact lines and at most one button; an open job has no
## borrowed face; the whole page fits the 756 px office window with no scroll; Hire moves a card to AT THE GYM with NEW on
## it and its button reads "Let go"; Let go moves it back.
##   godot --headless --audio-driver Dummy --path . --script res://tests/staff_cards_test.gd
## Prints STAFF_CARDS failures=<n>.

const Sim := preload("res://scripts/state/Sim.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const MAIN := preload("res://scenes/Main.tscn")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = MAIN.instantiate()
	root.add_child(main)
	await _settle(3)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	await _settle(2)
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	main.act("go", "gym:1")
	await _settle(6)
	_page("no coach")
	var hire := main.find_child("Hire_reid", true, false) as Control
	_check(hire != null and bool(hire.get_meta(Pulse.ON, false)), "no coach: the coach's Hire pulses (the guide names a coach first)")
	_check(_pulsing() == 1, "one Hire pulses (%d)" % _pulsing())
	main.act("hire", "reid")
	main.act("go", "gym:1")
	await _settle(6)
	_page("Luke Reid hired")
	_check(_in("AtTheGym", "StaffCard_reid"), "the hired coach's card is AT THE GYM")
	_check(_in("AtTheGym", "StaffCard_you"), "you are AT THE GYM")
	_check(_in("JobsOpen", "StaffCard_physio"), "the physio's job is open")
	var head := main.find_child("StaffHead", true, false) as Label
	_check(head != null and head.text.contains("at the gym") and head.text.contains("jobs open") and head.text.contains("wages"),
		"the head line: '%s'" % (head.text if head != null else "none"))
	var b := main.find_child("Hire_physio", true, false) as Button
	_check(b != null, "the physio's card has Hire")
	if b != null:
		b.pressed.emit()
		await _settle(6)
	_check(_in("AtTheGym", "StaffCard_physio"), "after Hire the physio's card is AT THE GYM")
	var card := main.find_child("StaffCard_physio", true, false)
	_check(card != null and card.find_child("NewTag", true, false) != null, "it carries NEW")
	var lg := card.find_child("LetGo_physio", true, false) as Button if card != null else null
	_check(lg != null and lg.text == "Let go", "its button now reads Let go")
	_page("physio hired")
	if lg != null:
		lg.pressed.emit()
		await _settle(6)
	_check(_in("JobsOpen", "StaffCard_physio"), "after Let go the physio's card is back in JOBS OPEN")
	_check(not c.staff_roles.has("physio"), "and the game let the physio go")
	_done()


## Every card on the page, checked against the METHOD.
func _page(when: String) -> void:
	var page := main.find_child("PeoplePage", true, false) as Control
	_check(page != null, "%s: the Staff page draws" % when)
	if page == null:
		return
	for sec in ["AtTheGym", "JobsOpen"]:
		_check(page.find_child(sec, true, false) != null, "%s: section %s" % [when, sec])
	var cards: Array = page.find_children("StaffCard_*", "", true, false)
	_check(cards.size() >= 6, "%s: %d cards" % [when, cards.size()])
	for n in cards:
		var id := str(n.name).substr(10)
		var face := n.find_child("Face", true, false) != null
		var sil := n.find_child("Silhouette", true, false) != null
		_check(face or sil, "%s: %s has a face or a silhouette" % [when, id])
		_check(n.find_child("CardName", true, false) != null, "%s: %s has a name" % [when, id])
		var facts: Array = n.find_children("Fact*", "", true, false)
		_check(facts.size() <= 4, "%s: %s has %d facts (at most 4)" % [when, id, facts.size()])
		var buttons: Array = n.find_children("*", "Button", true, false)
		_check(buttons.size() <= 1, "%s: %s has %d buttons (at most 1)" % [when, id, buttons.size()])
		if _under(n, "JobsOpen") and not ["reid", "hale"].has(id):
			_check(not face, "%s: open job %s borrows no face" % [when, id])
	var sc := main.find_child("HostScroll", true, false) as ScrollContainer
	_check(sc != null and sc.is_ancestor_of(page), "%s: the page is in the office window" % when)
	if sc != null:
		var bar := sc.get_v_scroll_bar()
		print("  layout %s: page h=%.0f window=%.0f scroll=%.0f/%.0f" % [when, page.size.y, sc.size.y, bar.max_value, bar.page])
		_check(bar.max_value <= bar.page + 1.0 and page.get_global_rect().end.y <= 1080.0, "%s: the page fits the window, no scroll" % when)
	var words := _words(page)
	_check(not words.to_lower().contains("club"), "%s: never 'club' on the Staff page" % when)


func _words(n: Node) -> String:
	var s := ""
	if n is Label:
		s = (n as Label).text
	elif n is Button:
		s = (n as Button).text
	for ch in n.get_children():
		s += " " + _words(ch)
	return s


func _pulsing() -> int:
	var page := main.find_child("PeoplePage", true, false)
	var n := 0
	if page != null:
		for x in page.find_children("*", "Control", true, false):
			if bool((x as Control).get_meta(Pulse.ON, false)):
				n += 1
	return n


func _in(section: String, card: String) -> bool:
	var s := main.find_child(section, true, false)
	return s != null and s.find_child(card, true, false) != null


func _under(n: Node, section: String) -> bool:
	var p := n.get_parent()
	while p != null:
		if str(p.name) == section:
			return true
		p = p.get_parent()
	return false


func _settle(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok: " if ok else "  FAIL: ") + what)
	if not ok:
		failures += 1


func _done() -> void:
	print("STAFF_CARDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)
