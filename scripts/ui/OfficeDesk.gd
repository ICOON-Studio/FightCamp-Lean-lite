extends RefCounted
## OFFICE1 (S450, TASK_OFFICE1): the office computer's Desktop, as rows of values read from the career. Pure: nothing here
## changes the career; Office.gd draws the rows. Every number is the career's own, through the function that owns it:
##   needs(c)          the three most urgent from HomeNeeds.ranked (the same act / arg Home's note runs), the first pulses
##   calendar(c)       28 days from today's Monday; chips from the data Fights' calendar (Fixtures.events) reads: the bouts,
##                     their fight weeks, an offer's last day, the month bill (rent, coaches, fees), dues in, the club show
##   mail(c)           the 3 newest news items, unread first
##   fighter_cards(c)  one card a boxer (and the no-gi athlete): class header, flag word, Stamina, Mood, rank, Next.
##                     NAMES ONLY IN HEADERS (S448): no row field carries a name
##   money_ahead(c)    the Money page's own 8-week forecast (CashForecast.project) and three rows
##   staff(c)          the head coach (you), the club coach and the staff jobs by ROLE (S431), an empty slot says what fills it

const HomeNeeds := preload("res://scripts/ui/HomeNeeds.gd")
const StaffCard := preload("res://scripts/ui/StaffCard.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const RosterFlag := preload("res://scripts/rules/RosterFlag.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const StatBlock := preload("res://scripts/rules/StatBlock.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Region := preload("res://scripts/state/Region.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const SHOWN_NEEDS := 3
const DAYS := 28
const SHOWN_MAIL := 3
const WEEKS := 8
## A need's act -> its KitIcon.
const NEED_ICON := {"openBout": "offer", "interview": "members", "camp": "camp", "weighin": "weight", "injurychoice": "injured",
	"prooffer": "contract", "goaltalk": "star", "review": "calendar", "trial": "scouted", "opennight": "mat", "closedgym": "lock",
	"go": "money", "guideweek": "calendar"}
## A chip that owns a calendar cell first (a cell draws one chip; all of them sit in its hover).
const CHIP_ORDER := ["bout", "show", "offer_ends", "open", "champs", "bills", "fight_week", "dues"]


static func needs(c: Career) -> Array:
	var out: Array = []
	var ranked: Array = HomeNeeds.ranked(c)
	for i in mini(SHOWN_NEEDS, ranked.size()):
		var x: Dictionary = (ranked[i] as Dictionary).duplicate()
		var act := str(x["act"])
		var icon := str(NEED_ICON.get(act, "clock"))
		if act == "go" and not str(x["arg"]).begins_with("money"):
			icon = "calendar" if str(x["arg"]).begins_with("fights") else "members"
		x["icon"] = icon
		x["level"] = HomeNeeds.urgency(x)
		x["pulse"] = i == 0   # S442: one pulsing critical button a screen, the decision due first
		out.append(x)
	return out


## [{d, n (day of the month), today, chips: [{kind, t, tip}]}], Monday first.
static func calendar(c: Career) -> Array:
	var monday := c.day - posmod(c.day, 7)
	var cells: Array = []
	for i in DAYS:
		var d := monday + i
		cells.append({"d": d, "n": int(Clock._date(d)["day"]), "today": d == c.day, "chips": []})
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if fb.has("day") and not bool(fb.get("done", false)):
			var bd := int(fb["day"])
			var word := _class_word(str(f["wc"])).to_lower()
			_chip(cells, monday, bd, "bout", "Bout: %s" % word, "%s bout, %s" % [str(f["wc"]), Clock.fmt(bd)])
			for k in range(bd - 7, bd):
				_chip(cells, monday, k, "fight_week", "fight week", "Fight week: the bout is %s" % Clock.fmt(bd))
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				_chip(cells, monday, int(o["expires"]), "offer_ends", "offer ends", "%s bout offer: answer by %s" % [str(f["wc"]), Clock.fmt(int(o["expires"]))])
	for g in c.grapplers:
		for d in g.get("entered", []):
			_chip(cells, monday, int(d), "open", "no-gi open", "No-gi open, %s" % Clock.fmt(int(d)))
	for e in Champs.calendar(c):
		_chip(cells, monday, int(e["d"]), "champs", "nationals", str(e["t"]))
	if int(c.show.get("day", -1)) >= 0:
		_chip(cells, monday, int(c.show["day"]), "show", "club show", "Our club show, %s" % Clock.fmt(int(c.show["day"])))
	var ahead: Array = CashForecast.project(c, WEEKS)
	var split: Dictionary = CashForecast.bill_split(ahead)
	var bill := GameMoney.next_bill_day(c.day)
	_chip(cells, monday, bill, "bills", "bills due", "Month bill %s: %s. Rent, coaches and England Boxing fees are paid here." % [Clock.fmt(bill), GameMoney.text(int(split["amount"]))])
	for w in ahead:
		var close := int(w["day"]) - 1   # the week closes overnight Sunday into Monday: dues land on its Sunday
		_chip(cells, monday, close, "dues", "dues in", "Week %d income in: %s" % [int(w["w"]) - 1, GameMoney.text(int(w["income"]))])
	for cell in cells:
		(cell["chips"] as Array).sort_custom(func(a, b): return CHIP_ORDER.find(str(a["kind"])) < CHIP_ORDER.find(str(b["kind"])))
	return cells


static func _chip(cells: Array, monday: int, d: int, kind: String, t: String, tip: String) -> void:
	var i := d - monday
	if i < 0 or i >= cells.size():
		return
	var chips: Array = cells[i]["chips"]
	if chips.any(func(x): return str(x["kind"]) == kind):
		return
	chips.append({"kind": kind, "t": t, "tip": tip})


## [{sender, line, unread, d}]: the newest first, unread before read. News carries no sender: the club's own mail reads
## "Club news", the region's stories "Around the region".
static func mail(c: Career) -> Array:
	var unread: Array = []
	var read: Array = []
	var left := c.unread
	for n in c.news:
		var own := bool(n.get("own", false))
		var fresh := own and left > 0
		if fresh:
			left -= 1
		var row := {"sender": "Club news" if own else "Around the region", "line": str(n["t"]), "unread": fresh, "d": int(n["d"])}
		(unread if fresh else read).append(row)
	return (unread + read).slice(0, SHOWN_MAIL)


static func fighter_cards(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		out.append(_boxer(c, f))
	for g in c.grapplers:
		out.append(_grappler(c, g))
	return out


static func _boxer(c: Career, f: Dictionary) -> Dictionary:
	var rows: Array = CoachCheck.rows(c, f)
	var flag: Dictionary = RosterFlag.pick(rows)
	var word := ""
	var tone := ""
	if flag.is_empty():
		var s: Array = CoachCheck.score(rows)
		word = "Sharp" if int(s[0]) == int(s[1]) else "Building"
		tone = "g" if word == "Sharp" else "b"
	else:
		word = str(flag["word"]).capitalize()
		tone = "r" if bool(flag["red"]) or str(flag["word"]) == "OFFER" else "a"
	var pro := bool(f.get("pro", false))
	var w := int(f.get("pro_w" if pro else "w", 0))
	var l := int(f.get("pro_l" if pro else "l", 0))
	var rank := 0 if pro else Region.our_rank(c, f)
	var big := "Pro" if pro else ("#%d" % rank if rank > 0 else "Unranked")
	var small := "%d-%d" % [w, l] if rank <= 0 else "regional, %d-%d" % [w, l]
	var sc: Array = CoachCheck.score(rows)   # S453 C368: the coach's checklist done, as a share (the Ready bar)
	var ready := roundi(100.0 * float(sc[0]) / float(sc[1])) if int(sc[1]) > 0 else -1
	var nxt := "no bout booked"
	var fb: Dictionary = f["bout"]
	if fb.has("day"):
		var days := int(fb["day"]) - c.day
		nxt = "bout today" if days <= 0 else "bout in %d day%s" % [days, "" if days == 1 else "s"]
	elif not RosterRow._open_offer(f).is_empty():
		nxt = "offer open"
	return {"id": str(f["id"]), "sport": "boxing", "header": "%s %d kg" % [_class_word(str(f["wc"])), roundi(float(f["limit"]))],
		"flag": word, "tone": tone, "face": Faces.stem(f), "rank": big, "rank_sub": small,
		"stamina": roundi(float(Attrs.of(f).get("stamina", 0.0))), "mood": roundi(float(f.get("morale", 0.0))), "next": nxt,
		"rating": StatBlock.overall(f), "ready": ready, "ready_tip": "%d of %d coach checks done" % [int(sc[0]), int(sc[1])]}


static func _grappler(c: Career, g: Dictionary) -> Dictionary:
	var row: Dictionary = RosterRow.row(c, str(g["id"]))
	var goal: Dictionary = (row.get("coach", {}) as Dictionary).get("goal", {})
	var ready := str(goal.get("cls", "")) == "green"
	var nf: Dictionary = row.get("next_fight", {})
	var when := str(nf.get("date", ""))
	var nxt := ("open %s" % when if str(nf.get("tag", "")) == "OPEN" else "next open %s" % when) if when != "" else "no open entered"
	return {"id": str(g["id"]), "sport": "bjj", "header": "BJJ %s" % _class_word(str(g["wc"]).get_slice(" ", 0)),
		"flag": str(goal.get("status", "Building")) if ready else "Building", "tone": "g" if ready else "b",
		"face": Faces.stem(g), "rank": "%s belt" % str(g.get("belt", "white")).capitalize(),
		"rank_sub": "%d-%d" % [int(g.get("w", 0)), int(g.get("l", 0))],
		"stamina": roundi(float((g.get("stats", {}) as Dictionary).get("cardio", 0.0))), "mood": roundi(float(g.get("morale", 0.0))),
		"next": nxt, "rating": _avg(g.get("stats", {})), "ready": 100 if ready else -1, "ready_tip": "ready for the next open" if ready else ""}


## The mean of a stats dictionary's numbers, rounded (a grappler's one rating).
static func _avg(stats: Dictionary) -> int:
	if stats.is_empty():
		return 0
	var t := 0.0
	for k in stats:
		t += float(stats[k])
	return roundi(t / float(stats.size()))


## "Lightweight" -> "Light".
static func _class_word(wc: String) -> String:
	return wc.replace("weight", "").strip_edges()


## {cash, weeks: [{w, day, cash}], low, rows: [{t, amount, tip}]}: the Money page's projection (Money.gd: CashForecast.project(c, 8)).
static func money_ahead(c: Career) -> Dictionary:
	var ahead: Array = CashForecast.project(c, WEEKS)
	var weeks: Array = []
	var low := c.cash
	for w in ahead.slice(0, WEEKS):
		weeks.append({"w": int(w["w"]), "day": int(w["day"]), "cash": int(w["cash"])})
		low = mini(low, int(w["cash"]))
	var dues := 0
	for w in ahead.slice(0, 4):
		dues += Membership.weekly_dues(int(w["members"]), c.dues_band)
	var end_day := int(ahead[WEEKS - 1]["day"]) if ahead.size() >= WEEKS else c.day
	var bouts := 0
	var cuts := 0
	for f in c.fighters:   # CashForecast.markers' rule: a booked bout's ticket cut lands on fight night, none at a championship
		var b: Dictionary = f.get("bout", {})
		if b.is_empty() or bool(b.get("done", false)) or int(b.get("day", -1)) <= c.day or int(b.get("day", -1)) > end_day:
			continue
		bouts += 1
		cuts += 0 if b.has("champ") else BoutRules.TICKET_CUT
	var split: Dictionary = CashForecast.bill_split(ahead)
	var fixed := int(split["rent"]) + int(split["coach"]) + int(split["staff"]) + int(split["stipends"])
	var rows: Array = [
		{"t": "Dues, next 4 weeks", "amount": dues, "tip": "Members' dues a week, as the Money page forecasts the members"},
		{"t": "Ticket cuts (%d booked bout%s)" % [bouts, "" if bouts == 1 else "s"], "amount": cuts, "tip": "Paid on fight night"},
		{"t": "Rent, coaches, stipends", "amount": -fixed, "tip": "In the month bill on %s" % Clock.fmt(int(split["day"]))},
	]
	return {"cash": c.cash, "weeks": weeks, "low": low, "rows": rows}


## [{role, line, pay, face, empty}]
static func staff(c: Career) -> Array:
	var out: Array = []
	var total := 0
	var done := 0
	for f in c.fighters:
		var pads: Array = PadWeek.nights_of(f).get("pads", [])
		total += pads.size()
		done += pads.filter(func(d): return int(d) < posmod(c.day, 7)).size()
	var line := "pad nights %d of %d done this week" % [done, total] if total > 0 else "no pad nights yet: sign a boxer"
	out.append({"role": "Head coach (you)", "line": line, "pay": "", "face": "res://assets/ui/art/guide_trainer.png", "empty": false})
	if c.coach.is_empty():
		out.append({"role": "No club coach yet", "line": "hire one from Staff: training runs slower without", "pay": "", "face": "", "empty": true})
	else:
		out.append({"role": "Club coach", "line": "runs the evening classes", "pay": "%s a week" % GameMoney.text(int(c.coach.get("salary", 0))),
			"face": "", "empty": false})
	for id in c.staff_roles:
		var r: Dictionary = StaffRoles.role(str(id))
		var pay := "%s a pro night" % GameMoney.text(int(r["per_bout"])) if int(r.get("per_bout", 0)) > 0 else "%s a week" % GameMoney.text(int(r.get("wage", 0)))
		out.append({"role": str(StaffCard.ROLE_WORD.get(str(id), "Staff")), "line": str(r.get("effect", "")), "pay": pay, "face": "", "empty": false})
	for r in StaffRoles.LIST:
		if not c.staff_roles.has(str(r["id"])):
			var word := str(StaffCard.ROLE_WORD.get(str(r["id"]), "staff")).to_lower()
			out.append({"role": "No %s yet" % word, "line": "hire from Staff: %s" % str(r["effect"]).to_lower(), "pay": "", "face": "", "empty": true})
			break
	return out
