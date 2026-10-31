extends VBoxContainer
## FIGHTS: Offers, Calendar, Results. An offer's Open goes to its bout page.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const BOUT_PAGE := preload("res://scenes/areas/BoutPage.tscn")


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
	var card := UI.card("OFFERS ON THE TABLE")
	add_child(card[0])
	var open := Bouts.open_offers(c)
	if open.is_empty():
		var lines: Array = []
		for bf in c.fighters:
			var fb: Dictionary = bf["bout"]
			if not fb.is_empty():
				lines.append("Booked: %s vs %s, %s." % [bf["first"], fb["opp"]["name"], Clock.fmt(int(fb["day"]))])
		if lines.is_empty():
			lines.append("No offers right now. They come every couple of weeks." if not c.fighters.is_empty() else "Sign a fighter to get offers.")
		card[1].add_child(UI.muted(" ".join(lines), UI.BODY, true))
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
