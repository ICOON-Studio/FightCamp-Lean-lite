extends SceneTree
## S533 P4PBUILD1 stage 3, THE COACH'S READ (DESIGN_THREEP4P_V2 section 2), end to end on the real screens: a quick-start
## club signs its walk-in and hires a coach; the first real offer carries the read on the offer card, on the bout's letter
## and in its report (one builder); the three answers are priced; Accept keeps the read's call on the bout; the bout
## settles it into the coach's record; save and load keep the record; the read changes nothing in the career.
## Then a pro after the debut (TestJump "proladder"): each pro row carries its own read. Prints P4P_COACH_READ failures=N.

const CoachRead := preload("res://scripts/rules/CoachRead.gd")
const CoachReadWire := preload("res://scripts/state/CoachReadWire.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _initialize() -> void:
	await _walk()
	_record()
	await _pro()
	print("P4P_COACH_READ failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _open_offer(c: Career) -> Array:
	for f in c.fighters:
		for o in f.get("offers", []):
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				return [f, o]
	return []


func _walk() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	await process_frame
	var c: Career = main.career
	c.guide = ""
	c.first_hour = {}
	for i in 120:
		if not _open_offer(c).is_empty():
			break
		Sim.step_day(c)
		c.review_pending = false
	var fo := _open_offer(c)
	_check(not fo.is_empty() and not c.coach.is_empty(), "a coach is hired and a legal offer is on the table")
	if fo.is_empty():
		main.queue_free()
		return
	var f: Dictionary = fo[0]
	var o: Dictionary = fo[1]
	var id := str(o["id"])
	var nid := id.validate_node_name()   # an offer id carries ":" and a node name cannot
	var before := JSON.stringify(SaveGame.to_dict(c))
	var x := CoachReadWire.facts(c, f, o)
	var r := CoachRead.read(x)
	_check(JSON.stringify(SaveGame.to_dict(c)) == before, "reading changes nothing in the career")
	_check(JSON.stringify(CoachRead.read(CoachReadWire.facts(c, f, o))) == JSON.stringify(r), "the same offer reads the same every time")
	var picks := (r["choices"] as Array).filter(func(ch): return bool(ch["pick"]))
	print("  P4P_COACH_READ read: %s | %s | %s" % [CoachRead.line(r), r["sure_words"], str((r["choices"] as Array).map(func(ch): return "%s: %s" % [ch["label"], ch["price"]]))])
	_check((r["choices"] as Array).size() == 3 and picks.size() == 1 and int(r["sure"]) >= 1 and int(r["sure"]) <= 3 and not bool(r["guess"]),
		"the real offer: three priced answers, one pick, 1 to 3 marks, the coach's own read")
	_check(int(x["days_out"]) == int(o["day"]) - c.day and float(x["lo"]) <= float(x["hi"]) and int(x["pass_price"]) == Bouts.pass_price(c, f, o),
		"its facts are the career's: the bout's day, the win range, the price Pass really costs (%d)" % int(x["pass_price"]))
	var body := CoachRead.line(r) + str(r["sure_words"]) + str(r["choices"])
	_check(not body.contains(str(o["opp"]["name"])) and not body.contains(str(f["first"])) and not body.contains(str(c.coach.get("name", "#"))), "no names in the read's text")
	main.act("go", "fights:0")
	await process_frame
	var card := main.find_child("CoachReadBox_" + nid, true, false)
	_check(card != null and card.find_child("CoachRead_" + nid, true, false) != null and card.find_child("CoachSure", true, false) != null
		and card.find_child("CoachChoice_accept", true, false) != null and card.find_child("CoachChoice_pass", true, false) != null
		and card.find_child("CoachChoice_later", true, false) != null, "the offer card shows the read, how sure, and the three answers")
	main.act("openBout", id)
	await process_frame
	# S535 OFFERBUILD1: the offer opens as a letter; the read is its own slate (verdict, gain, risk, how sure), same CoachRead.
	var quote := main.find_child("ReadQuote", true, false) as Label
	var gain := main.find_child("ReadGain", true, false)
	var sure := main.find_child("ReadSure", true, false)
	var said_gain := str((gain.get_child(1) as Label).text) if gain != null else ""
	var said_sure := str((sure.get_child(1) as Label).text) if sure != null else ""
	_check(quote != null and quote.text.contains(str(r["verdict"])) and said_gain.contains(str(r["gain"])) and said_sure.contains("%d of 3" % int(r["sure"]))
		and main.find_child("Accept", true, false) != null and main.find_child("Pass", true, false) != null, "the offer letter shows the same read, short, with Accept and Pass")
	VersusPanel.show_report(main, id)
	await process_frame
	var rc := main.find_child("CoachReadCard", true, false)
	_check(rc != null and rc.find_child("CoachChoice_later", true, false) != null, "the bout's report shows the whole read")
	var said_lab := rc.find_child("CoachRead_" + nid, true, false) as Label if rc != null else null
	var said := said_lab.text if said_lab != null else ""
	_check(said == CoachRead.line(r), "every screen says the same thing (one builder)")
	VersusPanel.show_report(main, "")
	main.act("accept", id)
	await process_frame
	var want := 1 if float(x["lo"]) >= 0.5 else (-1 if float(x["hi"]) <= 0.5 else 0)
	_check((f["bout"] as Dictionary).has("read_call") and int(f["bout"]["read_call"]) == want, "Accept keeps the read's call on the bout (%d)" % want)
	main.queue_free()
	await process_frame


func _record() -> void:
	var c := Career.quick_start()
	c.coach = {"name": "Reid", "rating": 60.0}
	var f := {"bout": {"read_call": 1}}
	CoachReadWire.settle(c, f, "win")
	CoachReadWire.settle(c, f, "loss")
	CoachReadWire.settle(c, f, "draw")
	_check(CoachReadWire.record(c) == [1, 2], "a favoured call: right on a win, wrong on a loss, a draw settles nothing")
	CoachReadWire.settle(c, {"bout": {"read_call": -1}}, "loss")
	CoachReadWire.settle(c, {"bout": {"read_call": 0}}, "win")
	CoachReadWire.settle(c, {"bout": {}}, "win")
	_check(CoachReadWire.record(c) == [2, 3], "an underdog call is right on a loss; no call and an old bout are never scored")
	var back := SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c))))
	_check(CoachReadWire.record(back) == [2, 3], "save and load keep the record")
	for i in 30:
		CoachReadWire.settle(c, f, "win")
	_check(int(CoachReadWire.record(c)[1]) == CoachRead.RECORD_KEEP, "the record keeps the last %d" % CoachRead.RECORD_KEEP)
	var none := Career.quick_start()
	none.coach = {}
	CoachReadWire.settle(none, f, "win")
	_check(CoachReadWire.record(none) == [0, 0] and not none.coach.has("reads"), "with no coach hired no record is kept")


func _pro() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var ok: bool = TestJump.run(main, "proladder")
	main.act("go", "fights:0")
	await process_frame
	var labs := main.find_children("ProCoachRead", "Label", true, false)
	var text := str((labs[0] as Label).text) if not labs.is_empty() else ""
	_check(ok and not labs.is_empty() and text.contains("Gain: ") and text.contains("Cost: ") and text.contains("How sure: "), "each pro row carries its own read (%d rows): %s" % [labs.size(), text])
	main.queue_free()
	await process_frame
