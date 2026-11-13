extends SceneTree
## OFFICE1 (S450): the office computer's Desktop rows, read from a real career by OfficeDesk (pure: it changes nothing).
## Needs: at most 3, in HomeNeeds.ranked order. Calendar: 28 days from today's Monday, a booked bout on its day and its
## fight week on the 7 days before. Money: 8 weeks, the first the Money page's own next-week projection (CashForecast).
## Fighter cards: one per boxer (c.fighters) plus the no-gi athlete, no fighter name in any row. Staff: roles, never names.
## Prints OFFICE_DESK failures=<n>.
##   godot --headless --audio-driver Dummy --path . --script res://tests/office_desk_test.gd

const DESK_PATH := "res://scripts/ui/OfficeDesk.gd"
const Sim := preload("res://scripts/state/Sim.gd")
const HomeNeeds := preload("res://scripts/ui/HomeNeeds.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	if not ResourceLoader.exists(DESK_PATH):
		_check(false, "OfficeDesk.gd exists (%s)" % DESK_PATH)
		_done()
		return
	var desk: Script = load(DESK_PATH)
	var c := Career.quick_start()
	c.head = HeadCoach.make("Dana Okafor", str(HeadCoach.ids()[0]))
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	for i in 10:   # the no-gi athlete joins at the end of week 1; offers come in
		Sim.step_day(c)
	var before := _state(c)
	_needs(desk, c)
	_calendar(desk, c)
	_money(desk, c)
	_club(desk, c)
	_cards(desk, c)
	_staff(desk, c)
	_check(_state(c) == before, "reading the desktop changes nothing in the career")
	_done()


func _done() -> void:
	print("OFFICE_DESK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _needs(desk: Script, c: Career) -> void:
	var n: Array = desk.needs(c)
	var ranked: Array = HomeNeeds.ranked(c)
	_check(n.size() <= 3, "at most three needs (%d)" % n.size())
	_check(n.size() == mini(3, ranked.size()), "the three most urgent when there are three (%d of %d)" % [n.size(), ranked.size()])
	for i in n.size():
		var x: Dictionary = n[i]
		var r: Dictionary = ranked[i]
		_check(str(x["t"]) == str(r["t"]) and str(x["act"]) == str(r["act"]) and str(x["arg"]) == str(r["arg"]),
			"need %d is HomeNeeds.ranked's %d: %s" % [i, i, str(x.get("t", ""))])
		_check(str(x.get("label", "")) != "", "need %d has its one button (%s)" % [i, str(x.get("label", ""))])
		_check(bool(x.get("pulse", false)) == (i == 0), "only the first need pulses (need %d)" % i)


func _calendar(desk: Script, c: Career) -> void:
	var monday := c.day - posmod(c.day, 7)
	var f: Dictionary = c.fighter()
	var bout_day := monday + 20   # the third week's Sunday; its fight week is the 7 days before
	var keep: Dictionary = f["bout"]
	f["bout"] = {"opp": (c.rivals[0] as Dictionary).duplicate(true), "day": bout_day, "weighed": false, "made": false, "done": false}
	var cal: Array = desk.calendar(c)
	_check(cal.size() == 28, "the calendar has 28 days (%d)" % cal.size())
	if cal.size() == 28:
		_check(int(cal[0]["d"]) == monday and posmod(int(cal[0]["d"]), 7) == 0, "it starts on today's Monday (day %d)" % int(cal[0]["d"]))
		var today: Array = cal.filter(func(x): return bool(x["today"]))
		_check(today.size() == 1 and int(today[0]["d"]) == c.day, "today's cell is the one outlined")
		var gaps := 0
		for i in 28:
			if int(cal[i]["d"]) != monday + i:
				gaps += 1
		_check(gaps == 0, "the 28 days follow on, one a cell (%d out of place)" % gaps)
		var on: Dictionary = cal[bout_day - monday]
		_check(_kinds(on).has("bout"), "the booked bout sits on its day (%s)" % str(on.get("chips", [])))
		var word := str(f["wc"]).replace("weight", "").to_lower()
		_check(_texts(on).has("Bout: %s" % word), "its chip reads Bout: %s (%s)" % [word, str(_texts(on))])
		for d in range(bout_day - 7, bout_day):
			_check(_kinds(cal[d - monday]).has("fight_week"), "fight week on day %d" % d)
		_check(not _kinds(cal[bout_day - 8 - monday]).has("fight_week"), "no fight week 8 days out")
		_check(not _kinds(cal[bout_day + 1 - monday]).has("fight_week"), "no fight week after the bout")
	f["bout"] = keep


func _club(desk: Script, c: Career) -> void:
	# S459 C380: the panel shows the club - members, room, the forecast's members a week, the bills by date.
	var m: Dictionary = desk.club_ahead(c)
	var page: Array = CashForecast.project(c, 8)
	_check(int(m["members"]) == c.members, "members now are the club's (%d)" % int(m["members"]))
	_check((m["ahead"] as Array).size() == 8 and int(m["ahead"][0]) == int(page[0]["members"]), "eight weeks of members, week 1 = the Money page's")
	var last := -1
	for b in m["bills"]:
		_check(int(b["amount"]) > 0 and int(b["day"]) > last and int(b["day"]) > c.day, "a bill ahead, by date (%s)" % str(b))
		last = int(b["day"])
	_check(not (m["bills"] as Array).is_empty(), "at least one bill in the next weeks")


func _money(desk: Script, c: Career) -> void:
	var m: Dictionary = desk.money_ahead(c)
	var weeks: Array = m.get("weeks", [])
	var page: Array = CashForecast.project(c, 8)
	_check(weeks.size() == 8, "eight weeks ahead (%d)" % weeks.size())
	_check(int(m.get("cash", -1)) == c.cash, "cash now is the tin (%d)" % int(m.get("cash", -1)))
	if not weeks.is_empty() and not page.is_empty():
		_check(int(weeks[0]["cash"]) == int(page[0]["cash"]) and int(weeks[0]["day"]) == int(page[0]["day"]),
			"week 1 is the Money page's next-week projection (%d vs %d)" % [int(weeks[0]["cash"]), int(page[0]["cash"])])
		var off := 0
		for i in mini(8, mini(weeks.size(), page.size())):
			if int(weeks[i]["cash"]) != int(page[i]["cash"]):
				off += 1
		_check(off == 0, "all eight weeks are the Money page's (%d differ)" % off)
	var rows: Array = m.get("rows", [])
	_check(rows.size() == 3, "three money rows (%d)" % rows.size())


func _cards(desk: Script, c: Career) -> void:
	var cards: Array = desk.fighter_cards(c)
	var boxers: Array = cards.filter(func(x): return str(x.get("sport", "")) == "boxing")
	_check(boxers.size() == c.fighters.size(), "one card per boxer (%d of %d)" % [boxers.size(), c.fighters.size()])
	_check(cards.size() == c.fighters.size() + c.grapplers.size(), "and one for the no-gi athlete (%d)" % cards.size())
	var names: Array = []
	for f in c.fighters + c.grapplers:
		for part in str(f["name"]).split(" ", false):
			names.append(part)
	for card in cards:
		for k in card:
			if ["id", "face"].has(str(k)):
				continue
			for part in names:
				if str(card[k]).contains(str(part)):
					_check(false, "card %s row %s carries no name (%s)" % [str(card["id"]), str(k), str(card[k])])
		_check(str(card.get("header", "")) != "", "card %s has its class header (%s)" % [str(card["id"]), str(card.get("header", ""))])
		_check(card.has("stamina") and card.has("mood"), "card %s has Stamina and Mood" % str(card["id"]))
		_check(str(card.get("next", "")) != "", "card %s says what is next (%s)" % [str(card["id"]), str(card.get("next", ""))])


func _staff(desk: Script, c: Career) -> void:
	c.coach = (Data.COACHES[0] as Dictionary).duplicate(true)
	c.staff_roles = ["physio"]
	var rows: Array = desk.staff(c)
	_check(rows.size() >= 3, "the head coach, the club coach and the physio (%d rows)" % rows.size())
	if not rows.is_empty():
		_check(str(rows[0]["role"]) == "Head coach (you)", "the first row is you (%s)" % str(rows[0]["role"]))
	var banned: Array = str(c.coach["name"]).split(" ", false) + str(c.head["name"]).split(" ", false)
	for r in rows:
		for k in ["role", "line", "pay"]:
			for part in banned:
				if str(r.get(k, "")).contains(str(part)):
					_check(false, "staff row %s names no one (%s)" % [k, str(r.get(k, ""))])
	var roles: Array = rows.map(func(r): return str(r["role"]))
	_check(roles.has("Club coach") and roles.has("Physio"), "roles by their job (%s)" % str(roles))
	c.coach = {}
	c.staff_roles = []


func _kinds(cell: Dictionary) -> Array:
	return (cell.get("chips", []) as Array).map(func(x): return str(x["kind"]))


func _texts(cell: Dictionary) -> Array:
	return (cell.get("chips", []) as Array).map(func(x): return str(x["t"]))


func _state(c: Career) -> String:
	return JSON.stringify([c.day, c.cash, c.accrued, c.unread, c.news.size(), c.fighters, c.members])


func _check(ok: bool, what: String) -> void:
	print(("  ok: " if ok else "  FAIL: ") + what)
	if not ok:
		failures += 1
