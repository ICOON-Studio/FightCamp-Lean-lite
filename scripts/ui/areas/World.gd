extends VBoxContainer
## WORLD: News (Mail opens it), Rankings (the region's women's lightweights; hers once she has 4 wins), Events (club shows
## and her bout), Search (every fighter, coach, prospect and gym the game knows), Nationals (S328 update 30: the road to the
## National Amateur Championships - what she still needs, the dates, Enter, her road round by round and the draw).

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Region := preload("res://scripts/state/Region.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")
const ChampDraw := preload("res://scripts/rules/ChampDraw.gd")

var _hits: VBoxContainer
var _career: Career


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	_career = c
	AreaHead.add(self, main, "world")
	match int(main.route["tab"]):
		0:
			var card := UI.card("NEWS")
			var rows: Array = []
			for x in c.news:
				rows.append(UI.row(x["t"], Clock.fmt(int(x["d"]))))
			UI.add_rows(card[1], rows)
			add_child(card[0])
		1:
			_rankings(c)
		2:
			_events(c)
		3:
			_search()
		4:
			_nationals(main, c)


## One table per division the gym has a fighter in (the women's lightweights before anyone signs).
func _rankings(c: Career) -> void:
	var divs: Array = []
	for f in c.fighters:
		if not divs.has(str(f["div"])):
			divs.append(str(f["div"]))
	if divs.is_empty():
		divs.append("wlw")
	for div in divs:
		_ranking_table(c, div)


func _ranking_table(c: Career, div: String) -> void:
	var card := UI.card("%s, LONDON REGION" % str(Data.DIVISIONS[div]["name"]).to_upper())
	add_child(card[0])
	var grid := GridContainer.new()
	grid.name = "Rankings_" + div
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 10)
	for head in ["#", "FIGHTER", "GYM", "RECORD"]:
		grid.add_child(UI.caps(head))
	var rows := Region.rankings(c, div)
	for i in mini(rows.size(), Region.RANK_ROWS):
		var r: Dictionary = rows[i]
		var col := UI.GOLD if bool(r["ours"]) else UI.FG
		grid.add_child(UI.mono(str(i + 1), UI.BODY, col))
		grid.add_child(UI.label(r["name"], UI.BODY, col, "bold" if bool(r["ours"]) else "body"))
		grid.add_child(UI.label(r["club"], UI.BODY, col))
		grid.add_child(UI.mono("%d-%d" % [r["w"], r["l"]], UI.BODY, col))
	card[1].add_child(grid)
	var notes: Array = []
	for f in c.fighters:
		if str(f["div"]) != div:
			continue
		if bool(f.get("pro", false)):
			notes.append("%s is a pro now: out of the amateur rankings." % f["first"])
		elif int(f.get("rank", 0)) > 0:
			notes.append("%s is number %d." % [f["name"], int(f["rank"])])
		else:
			notes.append("%s enters at %d wins (she has %d)." % [f["first"], Region.RANK_MIN_WINS, f["w"]])
	notes.append("Rivals fight at club shows every other Saturday.")
	card[1].add_child(UI.muted(" ".join(notes), UI.SMALL, true))


func _events(c: Career) -> void:
	var card := UI.card("EVENTS")
	add_child(card[0])
	var ev: Array = []
	for e in Champs.calendar(c):
		ev.append({"d": int(e["d"]), "t": e["t"], "ours": true})
	for d in Region.next_shows(c.day, 4):
		ev.append({"d": d, "t": "%s, %d rival bouts" % [Region.show_name(d), Region.SHOW_BOUTS], "ours": false})
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if not fb.is_empty():
			ev.append({"d": int(fb["day"]), "t": "%s vs %s: your bout%s" % [f["first"], fb["opp"]["name"], " (pro debut)" if bool(fb.get("pro", false)) else ""], "ours": true})
	ev.sort_custom(func(a, b): return int(a["d"]) < int(b["d"]))
	var rows: Array = []
	for e in ev:
		rows.append(UI.kv(Clock.fmt(int(e["d"])), e["t"], UI.GOLD if bool(e["ours"]) else UI.FG))
	UI.add_rows(card[1], rows)


func _search() -> void:
	var card := UI.card("SEARCH")
	add_child(card[0])
	var box := LineEdit.new()
	box.name = "SearchBox"
	box.placeholder_text = "Type a name: a fighter, a coach, a gym"
	box.text_changed.connect(_on_search)
	card[1].add_child(box)
	_hits = UI.vbox(6)
	_hits.name = "Hits"
	card[1].add_child(_hits)
	_on_search("")


## Everything the game knows by name: [text].
func everyone() -> Array:
	var all: Array = []
	for r in _career.rivals:
		all.append("%s, %s, %d-%d AM" % [r["name"], r["club"], r["w"], r["l"]])
	for f in _career.fighters:
		all.append("%s, %s, %d-%d AM (yours)" % [f["name"], _career.gym_name, f["w"], f["l"]])
	for c in Data.COACHES:
		all.append("%s, %s" % [c["name"], str(c["kind"]).to_lower()])
	for p in Data.PROSPECTS:
		all.append("%s, prospect: %s" % [p["name"], p["note"]])
	return all


func _on_search(q: String) -> void:
	UI.clear(_hits)
	var needle := q.strip_edges().to_lower()
	if needle == "":
		_hits.add_child(UI.muted("Every fighter, coach and gym the game knows (%d names)." % everyone().size(), UI.BODY))
		return
	var found := everyone().filter(func(x): return str(x).to_lower().contains(needle))
	if found.is_empty():
		_hits.add_child(UI.muted("Nobody by that name.", UI.BODY))
	for x in found:
		_hits.add_child(UI.label(x, UI.BODY))


## ---------- Nationals (S328) ----------

func _nationals(main: Node, c: Career) -> void:
	var amateurs := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	if amateurs.is_empty():
		var card := UI.card("THE NATIONAL AMATEUR CHAMPIONSHIPS")
		add_child(card[0])
		var text := "The season's goal for an amateur: 5 bouts and 3 months with the club, the London regional, then the nationals. Sign a fighter first."
		if not c.fighters.is_empty():
			text = "Your fighters are pros: the nationals are for amateurs."
		card[1].add_child(UI.muted(text, UI.BODY, true))
		return
	for f in amateurs:
		_road_card(main, c, f)
		var ch: Dictionary = f.get("champ", {})
		if not ch.is_empty():
			_path_card(c, f)
			_draw_card(f)


func _road_card(main: Node, c: Career, f: Dictionary) -> void:
	var card := UI.card("ROAD TO THE NATIONALS: %s" % str(f["name"]).to_upper())
	card[0].name = "Road_" + str(f["id"])
	add_child(card[0])
	var close := SeasonPath.entry_close(c.day)
	var weeks := mini(Champs.club_days(c, f) / 7, 13)
	var age := int(f.get("age", 21))
	var fit := not Injuries.out(c, f)
	var enough := Champs.bouts(f) >= SeasonPath.MIN_BOUTS
	var long_enough := Champs.club_days(c, f) >= SeasonPath.MIN_CLUB_DAYS
	var right_age := age >= SeasonPath.AGE_MIN and age <= SeasonPath.AGE_MAX
	UI.add_rows(card[1], [
		UI.kv("Bouts", "%d of %d" % [mini(Champs.bouts(f), SeasonPath.MIN_BOUTS), SeasonPath.MIN_BOUTS], UI.GREEN if enough else UI.AMBER),
		UI.kv("With the club", "%d of 13 weeks" % weeks, UI.GREEN if long_enough else UI.AMBER),
		UI.kv("Age", "%d (Elite is 19 to 40)" % age, UI.GREEN if right_age else UI.RED),
		UI.kv("Fit to box", "yes" if fit else Injuries.line(c, f), UI.GREEN if fit else UI.RED),
		UI.kv("Entries", "open %s, close %s" % [Clock.fmt(close - Champs.ENTRY_WINDOW), Clock.fmt(close)]),
		UI.kv("London regional", "%s and %s" % [Clock.fmt(Champs.stage_day(close, 0)), Clock.fmt(Champs.stage_day(close, 1))]),
		UI.kv("Nationals", "from %s, up to 4 bouts in 9 days" % Clock.fmt(Champs.stage_day(close, 2))),
	])
	var why := Champs.cannot_enter(c, f)
	if why == "":
		var b := UI.button("Enter %s" % f["first"], "Btn", main.act.bind("enterchamp", str(f["id"])))
		b.name = "Enter_" + str(f["id"])
		b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		card[1].add_child(b)
		card[1].add_child(UI.muted("Entering makes her an Elite boxer for life. No other offers come while she is in it; each round is a normal bout - camp, weigh-in, your corner. The club gets no ticket cut at the championships.", UI.SMALL, true))
	else:
		card[1].add_child(UI.muted(why + ".", UI.BODY, true))
	var titles: Array = f.get("titles", [])
	if not titles.is_empty():
		var past: Array = []
		for t in titles:
			past.append("%d: %s" % [int(t["year"]), t["t"]])
		card[1].add_child(UI.muted("Past championships - " + "; ".join(past) + ".", UI.SMALL, true))


func _path_card(c: Career, f: Dictionary) -> void:
	var ch: Dictionary = f["champ"]
	var card := UI.card("HER ROAD %d" % int(Clock._date(int(ch["close"]))["year"]))
	card[0].name = "Path_" + str(f["id"])
	add_child(card[0])
	var col := {"done": UI.GREEN, "out": UI.RED, "next": UI.GOLD, "ahead": UI.MUTED}
	var rows: Array = []
	for r in Champs.path(c, f):
		rows.append(UI.kv(Clock.fmt(int(r["d"])), "%s: %s" % [r["label"], r["t"]], col[str(r["state"])]))
	if bool(ch["done"]):
		rows.append(UI.kv("Result", str(ch["result"]), UI.GOLD))
	UI.add_rows(card[1], rows)


## The draw so far: each round played (her pair in gold), then the round still to box.
func _draw_card(f: Dictionary) -> void:
	var ch: Dictionary = f["champ"]
	var card := UI.card("THE DRAW")
	card[0].name = "Draw_" + str(f["id"])
	add_child(card[0])
	var me := str(f["id"])
	for r in ch["rounds"]:
		card[1].add_child(UI.caps("%s, %s" % [Champs.stage_name(int(r["stage"])), Clock.fmt(Champs.stage_day(int(ch["close"]), int(r["stage"])))]))
		for i in (r["pairs"] as Array).size():
			var p: Array = r["pairs"][i]
			var w := str(r["winners"][i])
			var ours := p.has(me)
			var loser := str(p[1]) if w == str(p[0]) else str(p[0])
			var line := "%s: a bye" % _who(f, w) if p.has(ChampDraw.BYE) else "%s beat %s" % [_who(f, w), _who(f, loser)]
			card[1].add_child(UI.label(line, UI.BODY, UI.GOLD if ours else UI.FG, "bold" if ours else "body"))
	if Champs.active(f):
		var st := int(ch["stage"])
		card[1].add_child(UI.caps("%s, %s" % [Champs.stage_name(st), Clock.fmt(Champs.stage_day(int(ch["close"]), st))]))
		for p in ch["pairs"]:
			var ours: bool = (p as Array).has(me)
			card[1].add_child(UI.label("%s vs %s" % [_who(f, str(p[0])), _who(f, str(p[1]))], UI.BODY, UI.GOLD if ours else UI.FG,
				"bold" if ours else "body"))
	if str(ch["level"]) == "national":
		card[1].add_child(UI.muted("%d regional champions in the national draw; the top seeds get the byes." % int(ch["national_size"]), UI.SMALL, true))
	else:
		card[1].add_child(UI.muted("The London regional: the winner goes to the national draw.", UI.SMALL, true))


func _who(f: Dictionary, id: String) -> String:
	if id == ChampDraw.BYE:
		return "bye"
	return str(f["name"]) if id == str(f["id"]) else id
