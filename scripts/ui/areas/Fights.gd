extends VBoxContainer
## FIGHTS: Offers, Calendar, Results. An offer's Open goes to its bout page.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const BOUT_PAGE := preload("res://scenes/areas/BoutPage.tscn")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
## Her latest results on the Offers tab's standing card.
const LAST_RESULTS := 3


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	if str(main.route.get("bout", "")) != "":
		var page := BOUT_PAGE.instantiate()
		add_child(page)
		page.build(main, str(main.route["bout"]))
		return
	AreaHead.add(self, main, "fights")
	match int(main.route["tab"]):
		0:
			_offers(main, c)
		1:
			_calendar(c)
		2:
			_results(c)


func _offers(main: Node, c: Career) -> void:
	# S369 (S367 critic: "a list in the top fifth of an empty page"): the offers on the left, each fighter's standing on
	# the right - her face, record, what she has booked and her last results - so an empty week still reads.
	var cols := UI.hbox(16)
	cols.name = "OfferCols"
	add_child(cols)
	var card := UI.card("OFFERS ON THE TABLE")
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card[0].size_flags_stretch_ratio = 3.0
	card[0].size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	cols.add_child(card[0])
	if not c.fighters.is_empty():
		var side := UI.vbox(16)
		side.name = "Standing"
		side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		side.size_flags_stretch_ratio = 2.0
		cols.add_child(side)
		for f in c.fighters:
			side.add_child(_standing(main, c, f))
	var open := Bouts.open_offers(c)
	if open.is_empty():
		if c.fighters.is_empty():
			card[1].add_child(UI.muted("Sign a fighter to get offers.", UI.BODY, true))
			return
		card[1].add_child(UI.muted("No offers right now.", UI.BODY, true))
		# S369: when each one's next offer can come (Bouts.day_events' own rule), not "every couple of weeks".
		for bf in c.fighters:
			card[1].add_child(UI.label(_next_offer(c, bf), UI.BODY, UI.FG, "bold", true))
		return
	var rows: Array = []
	for fo in open:
		var f: Dictionary = fo[0]
		var o: Dictionary = fo[1]
		var unsafe := bool(o["mismatch"])
		var sub := ("Not safe: she has %d bouts, %s has %d" % [int(o["own_bouts"]), str(o["opp"]["name"]).split(" ")[1],
			int(o["their_bouts"])]) if unsafe else "Legal, even match"
		var b := UI.button("Open", "Btn", main.act.bind("openBout", o["id"]))
		b.name = "Open_" + str(o["id"])
		rows.append(UI.row("%s vs %s, %s" % [f["first"], o["opp"]["name"], Clock.fmt(int(o["day"]))],
			"%s; answer by %s" % [sub, Clock.fmt(int(o["expires"]))], UI.RED if unsafe else UI.GREEN, [b]))
	UI.add_rows(card[1], rows)


## When her next offer can come, by Bouts.day_events' rule: none while booked or in the championships, else from her
## next_offer_day.
func _next_offer(c: Career, f: Dictionary) -> String:
	var fb: Dictionary = f["bout"]
	if not fb.is_empty():
		return "Booked: %s vs %s, %s." % [f["first"], fb["opp"]["name"], Clock.fmt(int(fb["day"]))]
	if Champs.active(f):
		return "%s: no other offers while she is in the championships." % f["first"]
	if bool(f.get("pro", false)):
		return "%s: pro bouts are not offered here." % f["first"]
	var days := int(f.get("next_offer_day", c.day)) - c.day
	if days > 0:
		return "%s: the next offer can come from %s (in %d day%s)." % [f["first"], Clock.fmt(int(f["next_offer_day"])), days, "" if days == 1 else "s"]
	return "%s: an offer can come any day now." % f["first"]


## One fighter's standing: booked or free, then her last results (newest first).
func _standing(main: Node, c: Career, f: Dictionary) -> Control:
	var fc := FighterCard.build(main, f, "Standing")
	var v: VBoxContainer = fc[1]
	var fb: Dictionary = f["bout"]
	if fb.is_empty():
		v.add_child(UI.label("Free to fight", UI.BODY, UI.GREEN, "bold"))
	else:
		v.add_child(UI.label("Booked: vs %s, %s" % [fb["opp"]["name"], Clock.fmt(int(fb["day"]))], UI.BODY, UI.GOLD, "bold"))
	v.add_child(UI.caps("LAST RESULTS"))
	var shown := 0
	for r in c.results:
		if str(r.get("fid", "")) != str(f["id"]) or shown >= LAST_RESULTS:
			continue
		var won := str(r.get("outcome", "win" if bool(r["win"]) else "loss"))
		var l := UI.label("%s %s, %s" % [{"win": "W", "loss": "L", "draw": "D"}[won], r["opp"], r["cards"]], UI.SMALL,
			UI.GREEN if won == "win" else (UI.RED if won == "loss" else UI.FG), "bold")
		v.add_child(l)
		shown += 1
	if shown == 0:
		v.add_child(UI.muted("No bouts with the club yet.", UI.SMALL))
	return fc[0]


func _calendar(c: Career) -> void:
	var card := UI.card("CALENDAR")
	add_child(card[0])
	var ev: Array = []
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if not fb.is_empty():
			ev.append({"d": int(fb["day"]) - 1, "t": "Weigh-in: %s" % f["first"]})
			ev.append({"d": int(fb["day"]), "t": "Fight night: %s vs %s" % [f["first"], fb["opp"]["name"]]})
		if not (f["camp"] as Dictionary).is_empty():
			ev.append({"d": int(f["camp"]["start"]), "t": "%s's camp started" % f["first"]})
	var next := Clock.next_stop(c)
	if not ["weigh-in", "fight night"].has(str(next["r"])):
		ev.append({"d": int(next["d"]), "t": str(next["r"]).capitalize()})
	ev.append({"d": GameMoney.next_bill_day(c.day), "t": "Month-end bill"})
	ev.append_array(Champs.calendar(c))   # S328 the nationals: entries close, her road round by round
	ev.sort_custom(func(a, b): return int(a["d"]) < int(b["d"]))
	var seen := {}
	var rows: Array = []
	for e in ev:
		var key := "%d|%s" % [e["d"], str(e["t"]).to_lower()]
		if seen.has(key):
			continue
		seen[key] = true
		rows.append(UI.kv(Clock.fmt(int(e["d"])), e["t"], UI.FG))
	UI.add_rows(card[1], rows)


func _results(c: Career) -> void:
	var card := UI.card("RESULTS")
	add_child(card[0])
	if c.results.is_empty():
		card[1].add_child(UI.muted("No bouts yet.", UI.BODY))
		return
	var rows: Array = []
	for r in c.results:
		var won := str(r.get("outcome", "win" if bool(r["win"]) else "loss"))
		rows.append(UI.row("%s %s vs %s, %s%s" % [r.get("who", ""), {"win": "beat", "loss": "lost to", "draw": "drew with"}[won], r["opp"], r["cards"], " (pro)" if bool(r.get("pro", false)) else ""],
			"%s. %s" % [Clock.fmt(int(r["d"])), r["why"]], UI.GREEN if bool(r["win"]) else UI.RED))
	UI.add_rows(card[1], rows)
