extends SceneTree
## S362 the T3 sticky notes and the top-bar / gym index cards (J90 6c, 6g).
##   1. Glossary: every term has a name, a definition of 15 words or fewer, a Why line.
##   2. place_note: beside the card on the side away from the control, inside the screen, never over the card.
##   3. TopCards: the money card's rows add up to its net; the date names the next stop; members and kit read the career.
##   4. live: a card with keys underlines them; resting on one opens its note beside the card; leaving closes it.
## Population: the quick-start career (30 members, one coach, no fighter signed). Headless the mouse rests at (0, 0).

const Tips := preload("res://scripts/ui/Tips.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var _fails := 0


func _initialize() -> void:
	for id in Glossary.TERMS:
		var t := Glossary.term(id)
		var words := str(t["def"]).split(" ", false).size()
		_check(str(t["name"]) != "" and words <= 15 and str(t["why"]) != "", "%s: a name, %d-word definition, a Why" % [id, words])
	_check(Glossary.term("nothing").is_empty(), "an unknown term has no note")

	var screen := Rect2(0, 0, 1920, 1080)
	var card := Rect2(400, 200, 360, 220)
	var r := Tips.place_note(Vector2(320, 160), card, screen, true)
	_check(r.position.x >= card.end.x and not r.intersects(card), "away to the right: beside the card (%s)" % r)
	r = Tips.place_note(Vector2(320, 160), card, screen, false)
	_check(r.end.x <= card.position.x, "away to the left (%s)" % r)
	r = Tips.place_note(Vector2(320, 160), Rect2(1500, 200, 400, 220), screen, true)
	_check(screen.grow(-16).encloses(r) and not r.intersects(Rect2(1500, 200, 400, 220)), "no room on the right: flipped, inside the screen (%s)" % r)

	var c := Career.quick_start()
	var m := TopCards.money(c)
	var sum := 0
	for row in m["rows"]:
		if str(row[0]) != "Net a week":
			sum += int(str(row[1]).replace("$", "").replace(",", "").replace("+", ""))
	var net := int(Sim.weekly_income(c)["total"]) - int(Sim.weekly_costs(c)["total"])
	_check(sum == net and str(m["rows"].back()[1]) == ("+" if net >= 0 else "-") + GameMoney.text(absi(net)), "the money rows add up to the net (%d vs %d)" % [sum, net])
	_check((m["keys"] as Array).has("runway"), "the money card links Runway")
	var d := TopCards.date(c)
	_check(str(d["rows"][0][2]) == str(Clock.next_stop(c)["r"]), "the date card names the next stop (%s)" % d["rows"][0][2])
	_check(str(TopCards.members(c)["rows"][0][1]) == str(c.members), "the members card reads the books")
	var worn: Dictionary = c.facilities.filter(func(f): return str(f["state"]) == "worn")[0]
	_check(str(TopCards.kit(c, worn)["rows"][1][0]) == "Repair", "a worn piece's card prices the repair")

	root.size = Vector2i(1920, 1080)
	var b := Button.new()
	b.text = "cash"
	b.size = Vector2(160, 40)
	root.add_child(b)
	await process_frame
	Tips.card(b, func(): return {"title": "Money a week", "rows": [["Dues", "+$242", "", ""]], "means": "it grows.", "keys": ["runway", "dues", "nope"]})
	b.mouse_entered.emit()
	await _secs(0.4)
	var tc := Tips.open_card()
	_check(tc != null, "the card opens")
	if tc == null:
		_done()
		return
	_check(tc.size.x >= Tips.TEXT_W and tc.get_global_rect().encloses((tc.get_child(0) as Control).get_global_rect().grow(-1.0)),
		"the card's size holds its text (%s; measured on screen, not before)" % tc.size)
	var key := tc.find_child("Key_runway", true, false) as Control
	_check(key != null and tc.find_child("Key_dues", true, false) != null and tc.find_child("Key_nope", true, false) == null,
		"known terms underlined, an unknown one dropped")
	# Bring the keyword under the resting mouse: the card moves so Runway sits on (0, 0) (after its slide-in tween).
	await _secs(0.3)
	tc.position -= key.get_global_rect().get_center()
	await _secs(0.1)
	_check(Tips.open_note() == null, "no note before the keyword delay")
	await _secs(0.3)
	var note := Tips.open_note()
	_check(note != null, "resting on Runway opens its note")
	if note != null:
		_check(not note.get_global_rect().intersects(tc.get_global_rect()), "the note sits beside the card, not on it")
		var st := (note as PanelContainer).get_theme_stylebox("panel") as StyleBoxFlat
		_check(st != null and st.bg_color == Tips.NOTE_BG, "the note is a yellow sticky")
	tc.position += Vector2(900, 600)
	await _secs(0.2)
	_check(Tips.open_note() == null, "off the keyword and the note: the note closes")
	_done()


func _done() -> void:
	Tips.close_all()
	print("TIP_NOTES %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _secs(s: float) -> void:
	await create_timer(s).timeout


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
