extends RefCounted
## WORLD > Nationals (S328 update 30; S329 rebuilt as pictures after the operator's C150 "can be improved" on the
## page of rows): per amateur, her season as a road (SeasonRoad), what she still needs to enter as rings (NeedRing), Enter,
## and the draw as a bracket (Bracket) - the national one once it is made, the London regional under it.

const UI := preload("res://scripts/ui/UI.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")
const ChampDraw := preload("res://scripts/rules/ChampDraw.gd")
const SeasonRoad := preload("res://scripts/ui/SeasonRoad.gd")
const NeedRing := preload("res://scripts/ui/NeedRing.gd")
const Bracket := preload("res://scripts/ui/Bracket.gd")


static func build(page: Control, main: Node, c: Career) -> void:
	var amateurs := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	if amateurs.is_empty():
		var card := UI.card("THE NATIONAL AMATEUR CHAMPIONSHIPS")
		page.add_child(card[0])
		var text := "The season's goal for an amateur: 5 bouts and 3 months with the club, the London regional, then the nationals. Sign a fighter first."
		if not c.fighters.is_empty():
			text = "Your fighters are pros: the nationals are for amateurs."
		card[1].add_child(UI.muted(text, UI.BODY, true))
		return
	for f in amateurs:
		_road_card(page, main, c, f)
		if not (f.get("champ", {}) as Dictionary).is_empty():
			_draw_card(page, f)


## The championships this road is about: hers when she is in them, or the ones she boxed until next season's entries
## open; else the next ones.
static func _this_year(c: Career, f: Dictionary) -> bool:
	var ch: Dictionary = f.get("champ", {})
	if ch.is_empty():
		return false
	return Champs.active(f) or int(ch["close"]) == SeasonPath.entry_close(c.day) or not Champs.entries_open(c)


static func _road_card(page: Control, main: Node, c: Career, f: Dictionary) -> void:
	var card := UI.card("ROAD TO THE NATIONALS: %s" % str(f["name"]).to_upper())
	card[0].name = "Road_" + str(f["id"])
	page.add_child(card[0])
	var road := SeasonRoad.new()
	road.name = "Season_" + str(f["id"])
	road.stops = stops(c, f)
	card[1].add_child(road)
	if not _this_year(c, f):
		card[1].add_child(_needs(c, f))
		var why := Champs.cannot_enter(c, f)
		if why == "":
			var b := UI.button("Enter %s" % f["first"], "Btn", main.act.bind("enterchamp", str(f["id"])))
			b.name = "Enter_" + str(f["id"])
			b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			card[1].add_child(b)
			card[1].add_child(UI.muted("Each round is a normal bout: camp, weigh-in, your corner. No other offers while she is in it; no ticket cut for the club.", UI.SMALL, true))
		else:
			card[1].add_child(UI.muted(why + ".", UI.BODY, true))
	var titles: Array = f.get("titles", [])
	if not titles.is_empty():
		var row := UI.hbox(8)
		row.add_child(UI.caps("TITLES"))
		for t in titles:
			row.add_child(UI.chip("%d  %s" % [int(t["year"]), t["t"]], "gold"))
		card[1].add_child(row)


## Her road as SeasonRoad stops: ready, entered, then each round (Champs.path); before she enters, the next season's dates.
static func stops(c: Career, f: Dictionary) -> Array:
	if _this_year(c, f):
		var out: Array = [{"label": "Ready to enter", "date": "5 bouts, 13 weeks", "state": "done"},
			{"label": "Entered", "date": "by " + Clock.fmt(int(f["champ"]["close"])), "state": "done"}]
		for r in Champs.path(c, f):
			var st := str(r["state"])
			var sub := str(r["t"])
			if st == "ahead":
				sub = "draw after the regional" if int(r["stage"]) == 2 and str(f["champ"]["level"]) == "regional" else ""
			out.append({"label": r["label"], "date": Clock.fmt(int(r["d"])), "sub": sub, "state": st})
		return out
	var close := SeasonPath.entry_close(c.day)
	var ready := bool(Champs.check(c, f)["ok"])
	var open := Champs.entries_open(c)
	return [
		{"label": "Ready to enter", "date": "yes" if ready else "not yet", "state": "done" if ready else "next",
			"sub": "" if ready else "see below"},
		{"label": "Entries open", "date": Clock.fmt(close - Champs.ENTRY_WINDOW), "sub": "close " + Clock.fmt(close),
			"sub2": "enter her now" if ready and open else "", "state": "next" if ready else "ahead"},
		{"label": "Regional semi-final", "date": Clock.fmt(Champs.stage_day(close, 0)), "sub": "London, 4 boxers", "state": "ahead"},
		{"label": "Regional final", "date": Clock.fmt(Champs.stage_day(close, 1)), "state": "ahead"},
		{"label": "National championships", "date": Clock.fmt(Champs.stage_day(close, 2)), "sub": "up to 4 bouts in 9 days", "state": "ahead"},
	]


## What England Boxing asks before she can enter, as four rings.
static func _needs(c: Career, f: Dictionary) -> HBoxContainer:
	var row := UI.hbox(18)
	row.name = "Needs_" + str(f["id"])
	var n := Champs.bouts(f)
	var weeks := mini(int(Champs.club_days(c, f) / 7.0), 13)
	var age := int(f.get("age", 21))
	var right_age := age >= SeasonPath.AGE_MIN and age <= SeasonPath.AGE_MAX
	var fit := not Injuries.out(c, f)
	var met := func(ok: bool) -> Color: return UI.GREEN if ok else UI.AMBER
	row.add_child(_tile("BOUTS", "%d of %d" % [mini(n, SeasonPath.MIN_BOUTS), SeasonPath.MIN_BOUTS], str(mini(n, SeasonPath.MIN_BOUTS)),
		n, SeasonPath.MIN_BOUTS, met.call(n >= SeasonPath.MIN_BOUTS)))
	row.add_child(_tile("WITH THE CLUB", "%d of 13 weeks" % weeks, str(weeks), weeks, 13, met.call(Champs.club_days(c, f) >= SeasonPath.MIN_CLUB_DAYS)))
	row.add_child(_tile("AGE", "Elite is %d to %d" % [SeasonPath.AGE_MIN, SeasonPath.AGE_MAX], str(age), 1, 1, UI.GREEN if right_age else UI.RED))
	row.add_child(_tile("FIT TO BOX", "yes" if fit else Injuries.line(c, f), "OK" if fit else "HURT", 1, 1, UI.GREEN if fit else UI.RED))
	return row


static func _tile(head: String, sub: String, big: String, value: float, goal: float, col: Color) -> PanelContainer:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var h := UI.hbox(14)
	p.add_child(h)
	var ring := NeedRing.new()
	ring.value = value
	ring.goal = goal
	ring.big = big
	ring.colour = col
	h.add_child(ring)
	var v := UI.vbox(4)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_child(UI.caps(head))
	v.add_child(UI.label(sub, UI.BODY, col, "bold", true))
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	return p


## The draw as brackets: the national one once it is made, the London regional under it.
static func _draw_card(page: Control, f: Dictionary) -> void:
	var ch: Dictionary = f["champ"]
	var card := UI.card("THE DRAW %d" % int(Clock._date(int(ch["close"]))["year"]))
	card[0].name = "Draw_" + str(f["id"])
	page.add_child(card[0])
	if bool(ch["done"]):
		card[1].add_child(UI.label(str(ch["result"]), UI.BODY + 3, UI.GOLD, "bold"))
	if str(ch["level"]) == "national":
		card[1].add_child(UI.caps("NATIONAL CHAMPIONSHIPS: %d REGIONAL CHAMPIONS, THE TOP SEEDS GET THE BYES" % int(ch["national_size"])))
		card[1].add_child(_bracket(f, "national", "National champion"))
		card[1].add_child(UI.sep())
	card[1].add_child(UI.caps("LONDON REGIONAL: THE WINNER GOES TO THE NATIONAL DRAW"))
	card[1].add_child(_bracket(f, "regional", "London champion"))


static func _bracket(f: Dictionary, level: String, champ: String) -> Control:
	var b := Bracket.new()
	b.name = "Bracket_%s_%s" % [level, f["id"]]
	b.her = str(f["name"])
	b.champion_title = champ
	b.set_rounds(bracket_rounds(f, level))
	return b


## Bracket rounds for one level of her championships: the rounds boxed, the round being boxed, the rounds still to come
## (names not known yet).
static func bracket_rounds(f: Dictionary, level: String) -> Array:
	var ch: Dictionary = f["champ"]
	var close := int(ch["close"])
	var lo := 0 if level == "regional" else 2
	var hi := 1 if level == "regional" else 5
	var out: Array = []
	var last := -1
	var count := 0
	for r in ch["rounds"]:
		var st := int(r["stage"])
		if st < lo or st > hi:
			continue
		out.append({"title": Champs.stage_name(st), "date": Clock.fmt(Champs.stage_day(close, st)),
			"pairs": _names(f, r["pairs"]), "winners": (r["winners"] as Array).map(func(w): return _who(f, str(w)))})
		last = st
		count = (r["pairs"] as Array).size()
	if Champs.active(f) and str(ch["level"]) == level:
		var st := int(ch["stage"])
		out.append({"title": Champs.stage_name(st), "date": Clock.fmt(Champs.stage_day(close, st)), "pairs": _names(f, ch["pairs"]), "winners": []})
		last = st
		count = (ch["pairs"] as Array).size()
	if last < 0:
		return out
	for st in range(last + 1, hi + 1):
		count = maxi(1, int(count / 2.0))
		var empty: Array = []
		for i in count:
			empty.append(["", ""])
		out.append({"title": Champs.stage_name(st), "date": Clock.fmt(Champs.stage_day(close, st)), "pairs": empty, "winners": []})
	return out


static func _names(f: Dictionary, pairs: Array) -> Array:
	return pairs.map(func(p): return [_who(f, str(p[0])), _who(f, str(p[1]))])


static func _who(f: Dictionary, id: String) -> String:
	if id == ChampDraw.BYE:
		return "bye"
	return str(f["name"]) if id == str(f["id"]) else id
