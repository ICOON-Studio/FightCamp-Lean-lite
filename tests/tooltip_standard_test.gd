extends SceneTree
## S532 GUIDETIPS1 (owner: "your tooltips do not explain things"; "cost a week to do what"; "why you repeat the description
## in the tooltip ?"): the tooltip standard, ops/research/GUIDETIPS1_STANDARD.md section 2, as a test.
##   1. The rules (Tip.faults): his three examples of a tooltip that fails are caught; the cards that replace them pass.
##   2. The game words: every Glossary note has its word, a definition of 15 words or fewer and a Why; the levels a card
##      quotes are the rule's.
##   3. The card: a plain tooltip_text is taken over and drawn wrapped, never wider than the standard's column.
##   4. The screens: on People the coach's tiles, on Fighters the TIREDNESS column and on Training the mastery bar each
##      open a card that says what it is and what to do, and break no rule.
##      On Fight prep the towel and its three lines do the same.
##   5. The ratchet: the tooltips still breaking a rule on the walked screens may only go down (FAULTS_AT_MOST), until
##      every screen is rewritten. `-- list` prints each one.

const Tips := preload("res://scripts/ui/Tips.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const TipCards := preload("res://scripts/ui/TipCards.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const WhiteboardKit := preload("res://scripts/ui/WhiteboardKit.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightPrep := preload("res://scripts/ui/FightPrep.gd")

const FAULTS_AT_MOST := 42   # lower it as screens are rewritten; never raise it

var _fails := 0
var main: Node
var _seen := {}
var _total := 0
var _broken := 0
var _list := false


func _initialize() -> void:
	_list = OS.get_cmdline_user_args().has("list")
	_rules()
	_words()
	await _card()
	await _screens()
	print("TOOLTIP_STANDARD tooltips=%d broken=%d (at most %d)" % [_total, _broken, FAULTS_AT_MOST])
	_check(_broken <= FAULTS_AT_MOST, "the broken tooltips on the walked screens only go down: %d <= %d" % [_broken, FAULTS_AT_MOST])
	print("TOOLTIP_STANDARD %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _rules() -> void:
	var cost := Tip.faults({"lines": ["Cost a week"], "kind": "plain"}, "$450 wage a week")
	_check(cost.has("short"), "'Cost a week' is caught: under six words (%s)" % str(cost))
	var again := Tip.faults({"lines": ["Evening classes, a week"], "kind": "plain"}, "+$350 evening classes a week")
	_check(again.has("repeat") and again.has("short"), "'Evening classes, a week' is caught: it repeats its label (%s)" % str(again))
	var wall := Tip.faults({"lines": ["Tiredness 38 of 100. Under 50 is fresh. A fight and hard training raise it; a full rest day takes off about an eighth. Over 80 the next morning's training counts only 60%."], "kind": "plain"}, "38 Fresh")
	_check(wall.has("long"), "the one-line tiredness wall is caught: too much for a line (%s)" % str(wall))
	_check(Tip.faults({"lines": ["Rest: 38 now, 30 tonight, 80 is the line."], "kind": "plain"}).has("piled"), "three numbers in one sentence are caught")
	_check(Tip.faults({"lines": ["Sharp moves land x1.3 as often as usable ones."], "kind": "plain"}).has("jargon"), "'x1.3' is caught")
	_check(Tip.faults({"title": "Pay", "what": "What it buys.", "kind": "short"}, "", ["Reid"]).is_empty(), "a two-line SHORT card passes")
	_check(Tip.faults({"title": "Pay", "what": "Reid runs the sessions for your boxers.", "kind": "short"}, "", ["Reid"]).has("name"), "a person's name is caught")
	_check(Tip.faults({"title": "Pay", "rows": [["a", "1", "", ""]], "kind": "full"}).has("no_what"), "a card that never says what the thing is, is caught")
	_check(Tip.faults({"title": "Pay", "what": "What it buys.", "keys": ["runway", "dues", "bill"]}).has("keys"), "three underlined words are caught")
	_check(Tip.faults({"title": "Pay", "what": "What it buys.", "keys": ["nope"]}).has("key_unknown"), "an underlined word with no note is caught")
	_check(Tip.faults({"title": "Runway 6 weeks", "what": "What it is.", "keys": ["runway"]}).has("key_title"), "a card never links its own word")
	var tired := TipCards.tiredness(38.0, "Fresh")
	_check(Tip.faults(Tip.spec(tired), "38 Fresh", ["Reid"]).is_empty(), "the tiredness card passes (%s)" % str(Tip.faults(Tip.spec(tired), "38 Fresh")))
	_check(str(tired["title"]) == "Tiredness  38 of 100 - fresh" and str(tired["rows"][0][2]) == "now", "it leads with the value and marks the band it is in")
	_check(str(tired["rows"][2][1]) == "from %d" % int(WhiteboardKit.AMBER_AT) and str(tired["rows"][3][1]) == "from %d" % int(WhiteboardKit.RED_AT),
		"its bands are the rule's (%s, %s)" % [tired["rows"][2][1], tired["rows"][3][1]])
	_check(str(TipCards.tiredness(84.0, "Overcooked")["rows"][3][2]) == "now" and str(TipCards.tiredness(84.0)["do"]).begins_with("Give a rest day now"), "over the line it says rest now")
	var bar := TipCards.mastery("Jab", 24.0, 27.0)
	_check(Tip.faults(Tip.spec(bar), "Jab", ["Reid"]).is_empty(), "the mastery card passes (%s)" % str(Tip.faults(Tip.spec(bar), "Jab")))
	_check(str(bar["do"]) == "1 more pad night like this reaches the flag.", "24 -> 27: %s" % bar["do"])
	_check(str(TipCards.mastery("Jab", 20.0, 22.0)["do"]) == "4 more pad nights like this reach the flag.", "20 -> 22: %s" % TipCards.mastery("Jab", 20.0, 22.0)["do"])
	_check(str(TipCards.mastery("Jab", 40.0, 44.0)["do"]) == "4 more pad nights like this reach Sharp." and str(TipCards.mastery("Jab", 40.0, 44.0)["rows"][1][2]) == "now",
		"past the flag it aims at Sharp: %s" % TipCards.mastery("Jab", 40.0, 44.0)["do"])
	for tile in ["pay", "classes", "net"]:
		var money := TipCards.coach_money(tile, 450, false)
		_check(Tip.faults(Tip.spec(money), "$450 coach's pay a week", ["Reid"]).is_empty(), "the coach's %s card passes (%s)" % [tile, str(Tip.faults(Tip.spec(money), "$450 coach's pay a week"))])
		_check(str(money["rows"][2][0]) == "Real cost" and str(money["rows"][2][1]) == "-$100", "%s: pay less classes is the real cost (%s %s)" % [tile, money["rows"][2][0], money["rows"][2][1]])
	_check(str(TipCards.coach_money("pay", 450, true)["do"]) == "", "a hired coach's card has no Hire line")


func _words() -> void:
	for id in Glossary.TERMS:
		var t := Glossary.term(id)
		_check(str(t.get("name", "")) != "" and str(t.get("why", "")) != "" and str(t.get("def", "")).split(" ", false).size() <= 15,
			"note %s: a word, a definition of 15 words or fewer, a Why" % id)
	_check(str(Glossary.term("fatigue")["name"]) == "Tiredness", "one word for it everywhere: Tiredness")
	_check(MoveMastery.word(29.9) == "Learning" and MoveMastery.word(30.0) == "Usable" and MoveMastery.word(60.0) == "Sharp" and MoveMastery.word(85.0) == "Signature",
		"the levels the mastery card quotes are the rule's")


func _card() -> void:
	var host := Control.new()
	host.position = Vector2(700, 400)
	root.add_child(host)
	var b := Button.new()
	b.text = "Rest"
	b.tooltip_text = "Tiredness 38 of 100. Under 50 is fresh. A fight and hard training raise it; a full rest day takes off about an eighth."
	var inner := Label.new()
	inner.mouse_filter = Control.MOUSE_FILTER_PASS
	b.add_child(inner)
	host.add_child(b)
	await process_frame
	_check(Tips.plain_under(inner) == b and b.tooltip_text == "" and Tip.of(b).get("kind", "") == "plain",
		"a plain tooltip is taken over: the engine's box never opens (%s)" % str(Tip.of(b).get("kind", "")))
	Tips.pin(b, func(): return Tips.plain_spec(b))
	await process_frame
	await process_frame
	var card := Tips.open_card()
	_check(card != null and card.size.x <= Tips.TEXT_W * TextScale.factor() + 60.0 and card.size.y > 90.0, "it is drawn as a wrapped card, not one long line (%s)" % (str(card.size) if card != null else "no card"))
	Tips.close_all()
	var c := Control.new()
	c.custom_minimum_size = Vector2(80, 40)
	c.size = Vector2(80, 40)
	host.add_child(c)
	Tip.explain(c, TipCards.tiredness(38.0, "Fresh"))
	Tips.pin(c, c.get_meta(Tips.META_SPEC))
	await process_frame
	await process_frame
	card = Tips.open_card()
	_check(card != null and card.size.x <= Tips.TEXT_W * TextScale.factor() + 60.0, "the full card keeps the standard's width (%s)" % (str(card.size) if card != null else "no card"))
	for part in ["Title", "What", "Moves", "Do"]:
		_check(card != null and card.find_child(part, true, false) != null, "the card has its %s line" % part)
	_check(Tips.plain_under(c) == null, "a control with a card keeps it: nothing takes it over")
	Tips.close_all()
	host.queue_free()
	await process_frame


func _screens() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	main.size = Vector2(1920, 1080)
	main.act("newcareer")
	main.act("quick")
	await _page("home_start")
	var go := main.find_child("Go", true, false) as Control
	_check(go != null, "the top bar has its Continue button")
	if go != null:
		_clean(go, "Continue (a job blocks the days)", "full")
	main.act("interview")
	main.act("pickcard", "signature")
	await _page("reception")
	main.act("sign")
	main.act("go", "gym:1")
	await _page("people")
	var tiles: Array = []
	for box in main.find_children("CoachTiles", "", true, false):
		tiles.append_array(box.get_children())
	_check(tiles.size() >= 5, "People: the coach's tiles are there (%d)" % tiles.size())
	for t in tiles:
		_clean(t as Control, "People tile '%s'" % _label_of(t as Control))
	main.act("hire", "reid")
	await process_frame
	main.act("go", "fighters:0")
	await _page("fighters")
	var col := main.find_child("Col_tiredness", true, false) as Control
	_check(col != null, "Fighters: the TIREDNESS column is there")
	if col != null:
		_clean(col, "Fighters TIREDNESS", "full")
	main.nav({"area": "training"})
	await _page("training")
	main.on_go()
	main.on_go()
	main.run_to_stop()
	main.act("area", "home")
	await _page("home_week1")
	for i in 4:
		main.act("go", "money:%d" % i)
		await _page("money_%d" % i)
	TestJump.run(main, "club4")   # the four-fighter test club: pad nights with drills on them
	if not main.modal.is_empty():
		main.act("close")
	main.nav({"area": "training"})
	await _page("training_club")
	go = main.find_child("Go", true, false) as Control
	_check(go != null and str(Tip.of(go).get("title", "")) == "Continue", "the test club's week is set: Continue is free")
	if go != null:
		_clean(go, "Continue (the days can run)", "full")
		_check(str(Tip.of(go).get("now", "")).begins_with("Next stop: "), "Continue says where the days will stop: %s" % Tip.of(go).get("now", ""))
	var bars := main.find_children("Bar_*", "Control", true, false).filter(func(b): return "ghost" in b)   # the pad tiles' own bars
	_check(not bars.is_empty(), "Training: a pad night shows a mastery bar (%d)" % bars.size())
	if not bars.is_empty():
		var n: Node = bars[0]
		while n != null and not (n is Control and (n as Control).has_meta(Tips.META_SPEC)):
			n = n.get_parent()
		_check(n != null, "Training: the mastery bar's tile opens a card")
		if n != null:
			_clean(n as Control, "Training mastery bar", "full")
	# Fight prep: the towel and its three lines (owner: explain the towel; never "she")
	var towel := FightPrep.towel_row(main, main.career.fighter())
	root.add_child(towel)
	await process_frame
	_check(towel.get_child_count() == 4, "Fight prep: the towel and its three lines (%d)" % towel.get_child_count())
	for b in towel.get_children():
		_clean(b as Control, "Towel '%s'" % _label_of(b as Control), "full")
		_check(not (" " + " ".join(Tip.prose(Tip.of(b as Control))).to_lower() + " ").contains(" she "), "Towel '%s' names nobody" % _label_of(b as Control))
	towel.queue_free()


## The control opens a card (not a plain line) that breaks no rule.
func _clean(c: Control, what: String, kind: String = "") -> void:
	var s := Tip.of(c)
	var f := Tip.faults(s, _label_of(c), _names())
	_check(not s.is_empty() and str(s.get("kind", "")) in (["short", "full"] if kind == "" else [kind]) and f.is_empty(),
		"%s: a %s card, no rule broken (%s %s)" % [what, kind if kind != "" else "short or full", str(s.get("kind", "none")), str(f)])


func _page(page: String) -> void:
	await _settle(6)
	var names := _names()
	for n in main.find_children("*", "Control", true, false):
		var c := n as Control
		if not c.is_visible_in_tree():
			continue
		var s := Tip.of(c)
		if s.is_empty():
			continue
		var key := str(s.get("title", "")) + "|" + " ".join(Tip.prose(s))
		if _seen.has(key):
			continue
		_seen[key] = true
		_total += 1
		var f := Tip.faults(s, _label_of(c), names)
		if not f.is_empty():
			_broken += 1
			if _list:
				print("TIPFAULT %s [%s] label=\"%s\" tip=\"%s\"" % [page, ",".join(f), _label_of(c).left(40).replace("\n", " "), key.left(170).replace("\n", " / ")])


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _names() -> Array:
	var out: Array = []
	var c: Career = main.career
	if c == null:
		return out
	for f in c.fighters:
		for k in ["first", "name"]:
			if str(f.get(k, "")).length() > 2:
				out.append(str(f[k]))
	if str(c.coach.get("name", "")).length() > 2:
		out.append_array(str(c.coach["name"]).split(" "))
	return out


func _label_of(c: Control) -> String:
	if c is Button or c is Label:
		return str(c.get("text"))
	var words: Array = []
	for l in c.find_children("*", "Label", true, false):
		words.append(str((l as Label).text))
	return " ".join(words)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
