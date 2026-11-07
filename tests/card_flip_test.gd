extends SceneTree
## S382 CARDFLIP1 (TRAINING_SCREEN_S381.md 5.6, build order item 3): the payoff in the real week review.
##   1. the week report carries the PADS rows (PadReview) and the 1-1 placed on Monday's pads crosses usable there;
##   2. the review shows a PADS row of FlipCards; the 1-1 card starts on its face (the gold back laid out at alpha 0);
##   3. during the reveal it turns: its width squeezes (scale.x < 1 mid-turn), then the gold back faces out at full scale,
##      the card's size never changes (no pop), both sides fit the card (no clipping), the back reads USABLE and
##      "Mon pads: before -> after", the bar ends at the week's after; the turn takes FLIP_S (~0.35 s);
##   4. a card that crossed nothing has no back; a click (finish) settles every card at once; the Moves note leaves out
##      the moves already on the PADS row.
## Population: the jump=camp career (Lucy in camp, a new week, her bout booked); the 1-1 set at 27.0 on her first pad night.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const FlipCard := preload("res://scripts/ui/FlipCard.gd")

var _fails := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	f["combos"]["1-1"] = 27.0
	var nights := PadWeek.nights_of(f)
	var first := int((nights["pads"] as Array)[0]) if not (nights["pads"] as Array).is_empty() else -1
	_check(first >= 0, "she has a pad night this week (%s)" % str(nights))
	PadEdit.clear(f, nights, first)
	_check(PadEdit.place(f, nights, first, "combo:1-1"), "the 1-1 on her first pad night, whole")
	for i in 14:
		if c.review_pending:
			break
		main.run_to_stop()
	_check(c.review_pending, "the week ran to its review")
	var fr: Dictionary = {}
	for x in c.last_report.get("fighters", []):
		if str(x["id"]) == fid:
			fr = x
	var row: Dictionary = {}
	for r in fr.get("pads", []):
		if str(r["card"]) == "combo:1-1":
			row = r
	_check(not row.is_empty() and str(row["cross"].get("tier", "")) == "usable" and int(row["cross"]["dow"]) == first,
		"report: the 1-1 crossed usable on night %d (%s)" % [first, str(row.get("cross", {}))])
	main.act("review")
	await _frames(2)
	var rv: Node = main.modal_node()
	_check(rv != null and str(main.modal.get("type", "")) == "review", "the review opened")
	if rv == null:
		_done()
		return
	var prow := rv.find_child("Pads_" + fid, true, false)
	_check(prow != null and prow.get_child_count() >= 1, "a PADS row of drill cards (%d)" % (0 if prow == null else prow.get_child_count()))
	var card = rv.find_child("PadCard_combo_1-1", true, false)
	_check(card != null and card.back != null and not card.gold and card.back.modulate.a == 0.0 and card.face.modulate.a == 1.0,
		"the 1-1 starts on its face, the gold back laid out unseen")
	if card == null or card.back == null:
		_done()
		return
	await _frames(2)
	var size0: Vector2 = card.size
	var min_scale := 1.0
	var t0 := -1.0
	var t1 := -1.0
	var start := Time.get_ticks_msec()
	while Time.get_ticks_msec() - start < 15000 and not bool(rv.get("revealed")):
		await process_frame
		var now := (Time.get_ticks_msec() - start) / 1000.0
		if card.scale.x < 0.999 and t0 < 0.0:
			t0 = now
		if card.scale.x < 0.999:
			t1 = now
		min_scale = minf(min_scale, card.scale.x)
		if card.size != size0:
			_check(false, "the card's size changed mid-reveal (%s -> %s)" % [str(size0), str(card.size)])
			size0 = card.size
	await _frames(3)
	_check(min_scale < 0.6, "it turns: the width squeezed to %.2f mid-turn" % min_scale)
	_check(t0 >= 0.0 and t1 - t0 < 0.6 and t1 - t0 > 0.15, "the turn lasts about FLIP_S (%.2f s)" % (t1 - t0))
	_check(is_equal_approx(FlipCard.FLIP_S, 0.35), "the spec's 0.35 s turn (FLIP_S %.2f)" % FlipCard.FLIP_S)
	_check(card.gold and card.back.modulate.a == 1.0 and card.face.modulate.a == 0.0 and card.scale == Vector2.ONE,
		"the gold back faces out at full scale")
	_check(card.size == size0, "no pop: the same size before and after (%s)" % str(card.size))
	_check(card.size.x <= FlipCard.CARD_W + 0.5, "a card's shape, not a strip across the review (%.0f wide)" % card.size.x)
	var fits: bool = card.back.get_combined_minimum_size().y <= card.size.y + 0.5 and card.face.get_combined_minimum_size().y <= card.size.y + 0.5
	_check(fits, "both sides fit the card (face %.0f, back %.0f, card %.0f)" % [card.face.get_combined_minimum_size().y,
		card.back.get_combined_minimum_size().y, card.size.y])
	var tier: Label = card.find_child("Tier", true, false)
	var when: Label = card.find_child("When", true, false)
	_check(tier != null and tier.text == "Usable", "the back's tier word: %s" % ("-" if tier == null else tier.text))
	var nm: Label = card.back.find_child("Name", true, false)
	_check(nm != null and nm.text == "1-1" and nm.size.x > 20.0, "the back names the card: %s (%.0f px)" % [
		"-" if nm == null else nm.text, 0.0 if nm == null else nm.size.x])
	var want := "%s pads: %.1f -> %.1f" % [PadEdit.DAY_WORDS[first], float(row["cross"]["before"]), float(row["cross"]["after"])]
	_check(when != null and when.text == want, "the night that did it: %s (want %s)" % ["-" if when == null else when.text, want])
	_check(is_equal_approx(float(card.bar.get("end")), float(row["after"])), "the face's bar ends at the week's after")
	_check(card.find_child("Quote", true, false) == null and not _texts(card).any(func(s): return s.contains("\"")),
		"no coach quote on the gold card")
	# 4. a card that crossed nothing; finish settles at once
	var flat = FlipCard.make(f, {"card": "move:Jab", "before": 51.0, "after": 51.4, "pads": [0], "spar": [], "cross": {}})
	var turned = FlipCard.make(f, {"card": "combo:1-1", "before": 27.0, "after": 31.0, "pads": [0], "spar": [], "cross":
		{"tier": "usable", "at": 30.0, "dow": 0, "station": "pads", "before": 27.0, "after": 31.0}})
	var box := HBoxContainer.new()
	box.size = Vector2(900, 220)
	root.add_child(box)
	box.add_child(flat)
	box.add_child(turned)
	await _frames(2)
	flat.flip()
	_check(flat.back == null and not flat.gold, "a card that crossed nothing has no back and never turns")
	turned.grow()
	turned.flip()
	turned.settle()
	_check(turned.gold and turned.scale == Vector2.ONE and is_equal_approx(float(turned.bar.get("end")), 31.0),
		"settle: the gold back out, the bar full, at once")
	box.queue_free()
	var notes := rv.find_child("Notes_" + fid, true, false) as Label
	var on_row: Array = []
	for k in prow.get_children():
		on_row.append(str(k.row["card"]))
	var dup := false
	if notes != null:
		for id in on_row:
			if str(id).begins_with("move:") and notes.text.contains(str(id).substr(5) + " "):
				dup = true
	_check(not dup, "the Moves note leaves out the PADS row's moves (%s)" % ("-" if notes == null else notes.text))
	_done()


func _texts(n: Node) -> Array:
	var out: Array = []
	if n is Label:
		out.append((n as Label).text)
	for ch in n.get_children():
		out.append_array(_texts(ch))
	return out


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _done() -> void:
	print("CARD_FLIP %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)
