extends RefCounted
## STAFFCARDS1 (S547; owner S545 on the Staff screen: "this screen is terrible"; S544: "looks like spreadheet you need to
## use art"): the Staff window of the office computer as CARDS, after the S546 mockup docs/mockups/s546/staff_cards.png.
## Two rows: AT THE GYM (you, the coach, the mat coach, each hired job, the evening coaches) and JOBS OPEN (the coaches for
## hire while none is signed, the open jobs, one more evening coach). A card = a face or a grey silhouette, the name over
## it, a tag, the job in plain words, at most four facts, one button. The detail is the hover (Tip.explain). A card that
## came to AT THE GYM on this visit carries NEW until the page is left. Nothing scrolls: the page fits the 756 px window.
## Rows come from OfficeDesk.staff_sheet (one source with the office's Staff sheet); the acts are the game's own (hire,
## hirerole, letgorole, eveningcoach) - no rule lives here. The drawing of one card: StaffDeskCard.
##   StaffDesk.page(parent, main, c)    StaffDesk.hover(c, id) -> a card's hover spec    boxer_line(c, f, coach)

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const DeskCard := preload("res://scripts/ui/StaffDeskCard.gd")
const StaffCard := preload("res://scripts/ui/StaffCard.gd")
const OfficeDesk := preload("res://scripts/ui/OfficeDesk.gd")
const HireRunway := preload("res://scripts/ui/HireRunway.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const CoachAreas := preload("res://scripts/rules/CoachAreas.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const FilmPattern := preload("res://scripts/rules/FilmPattern.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Promises := preload("res://scripts/rules/Promises.gd")

const ROLE_LINE := {"assistant": "10 hours a week", "strength": "2 sessions a week", "physio": "On call, a session a week",
	"cutman": "By the pro night"}
const ROW_W := 1688.0   # the hosted window's inner width at 1920 (measured on the S547 still: 1716 pushed the top bar 17 px off)
const GAP := 14
const SOFT := Palette.MUTED
const DOT := "  ·  "

## NEW: the cards that came to AT THE GYM since this visit began (main.past's length marks a visit).
static var _visit := -1
static var _seen: Array = []
static var _new: Array = []


static func page(parent: Container, main: Node, c: Career) -> void:
	var gym: Array = []
	var open: Array = []
	for r in OfficeDesk.staff_sheet(c):
		var id := str(r["id"])
		match str(r["kind"]):
			"you":
				gym.append(_you(c))
			"coach":
				gym.append(_coach(main, c, c.coach, true))
			"hire":
				if c.coach.is_empty():
					open.append(_coach(main, c, Data.coach(id), false))
			"role", "open":
				(gym if c.staff_roles.has(id) else open).append(_role(main, c, id))
			"evening":
				if c.extra_coaches > 0:
					gym.append(_evening(main, c, true))
				open.append(_evening(main, c, false))
	if c.bjj_on():   # the mat coach works beside the coach (by the class, no act to let go)
		gym.insert(mini(2, gym.size()), _mat(c))
	_mark_new(main, gym)
	if c.coach.is_empty():   # the one hire the gym needs first: the guide's "Hire an assistant coach" (FirstWeek)
		for s in open:
			if str(s["id"]) == "reid":
				s["button"]["pulse"] = true
	var root := UI.vbox(6)
	root.name = "PeoplePage"
	parent.add_child(root)
	_head(parent, root, c, gym.size(), open.size())
	root.add_child(DeskCard.section("AT THE GYM"))
	root.add_child(_row("AtTheGym", gym))
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 2)
	root.add_child(gap)
	root.add_child(DeskCard.section("JOBS OPEN"))
	root.add_child(_row("JobsOpen", open))


## The office window's bar takes the head line beside STAFF (Office.bar_head); a page drawn on its own puts it on top.
## Reputation has no other screen (members: the office desktop and Finance; dues: Finance), so it stays here, one word.
static func _head(parent: Node, root: Container, c: Career, at_gym: int, jobs: int) -> void:
	var wages := int(c.coach.get("salary", 0)) + StaffRoles.wages(c.staff_roles) + StaffRoles.EVENING_WAGE * c.extra_coaches + int(Sim.bjj_money(c)["coach"])
	var line := UI.label("%d at the gym%s%d job%s open%swages %s a week" % [at_gym, DOT, jobs, "" if jobs == 1 else "s", DOT, GameMoney.text(wages)], 16, SOFT, "semi")
	line.name = "StaffHead"
	var rep := UI.label(_rep_word(c.reputation), 16, SOFT, "semi")
	rep.name = "Reputation"
	rep.mouse_filter = Control.MOUSE_FILTER_STOP
	Tip.explain(rep, {"title": "Reputation", "what": "How far the gym's name reaches.", "now": "Reputation %d today." % c.reputation,
		"moves": "Each win adds %d; a worn gym costs it." % BoutRules.WIN_REPUTATION})
	var office := parent
	while office != null and not ("bar_head" in office and office.get("bar_head") != null):
		office = office.get_parent()
	var box: Container = office.get("bar_head") if office != null else null
	if box == null:
		box = UI.hbox(14)
		root.add_child(box)
	box.add_child(UI.spacer())
	box.add_child(line)
	box.add_child(UI.label("·", 16, SOFT, "semi"))
	box.add_child(rep)


static func _rep_word(rep: int) -> String:
	return "Known locally" if rep < 30 else ("Known in the region" if rep < 60 else "A name in the sport")


static func _row(name: String, specs: Array) -> HBoxContainer:
	var h := UI.hbox(GAP)
	h.name = name
	var n := maxi(1, specs.size())
	var w := minf(DeskCard.W, floorf((ROW_W - float(GAP * (n - 1))) / float(n)))
	for s in specs:
		h.add_child(DeskCard.card(s, w, hover_for(s)))
	return h


static func hover_for(s: Dictionary) -> Dictionary:
	return s.get("hover", {})


## Cards that arrived at the gym since the visit began carry NEW; a fresh visit starts clean.
static func _mark_new(main: Node, gym: Array) -> void:
	var visit: int = (main.get("past") as Array).size() if main.get("past") is Array else 0
	var ids: Array = gym.map(func(s): return str(s["id"]))
	if visit != _visit:
		_visit = visit
		_new = []
	else:
		for id in ids:
			if not _seen.has(id) and not _new.has(id):
				_new.append(id)
	_new = _new.filter(func(id): return ids.has(id))
	_seen = ids
	for s in gym:
		s["new"] = _new.has(str(s["id"]))


## ---------- the people and the jobs (each a card spec for StaffDeskCard) ----------

static func _you(c: Career) -> Dictionary:
	var cd := HeadCoach.card(HeadCoach.of(c.head))
	var facts: Array = [[str(cd.get("edge", "")), "good"], ["Holds the pads for every boxer", ""], ["In the corner on fight night", ""]]
	var owed := Promises.open_rows(c)   # S488 PROMISES OPEN: no other screen lists them, so your card keeps them (the list on hover)
	if not owed.is_empty():
		var rows: Array = owed.slice(0, 3).map(func(r): return [str(r["name"]), str(r["line"]), "", ""])
		facts.append(["Promises open: %d" % owed.size(), "", {"node": "PromisesOpen", "title": "Promises open",
			"what": "What you promised a boxer, and by when.", "rows": rows}])
	return {"id": "you", "inner": "HeadCoachRow", "face": str(cd.get("photo", "")), "name": str(c.head.get("name", HeadCoach.DEFAULT_NAME)),
		"tag": "You", "role": "Head coach, owner", "facts": facts, "hover": hover(c, "you")}


static func _coach(main: Node, c: Career, coach: Dictionary, hired: bool) -> Dictionary:
	var who := _with_areas(coach)
	var id := str(who.get("id", ""))
	var area := CoachAreas.best(who)
	var full := str(who.get("kind", "")).begins_with("Full")
	var rating := float((who.get("areas", {}) as Dictionary).get(area, who.get("rating", 0.0)))
	var lift := ("moves " + CoachAreas.pct_for(area, rating)) if area == "pads" else (CoachAreas.pct_for(area, rating) + " gain")
	var facts: Array = [["Best at %s: %s" % [CoachAreas.short(area).to_lower(), lift], "good"]]
	facts.append(["Runs the evening classes", ""] if hired else [str(who.get("note", "")).left(1).to_upper() + str(who.get("note", "")).substr(1), ""])
	facts.append(["You pay:", GameMoney.text(int(who.get("salary", 0))) + " a week"])
	if hired:
		facts.append(["Classes bring in:", GameMoney.text(GameMoney.CLASSES_WITH_COACH)])
	var s := {"id": id, "inner": "Assistant_" + id, "face": _photo(c, id), "name": str(who.get("name", "")), "tag": "Full-time" if full else "Part-time",
		"role": "Coach, full-time" if full else "Coach, part-time", "facts": facts, "hover": hover(c, id)}
	if not hired:
		s["button"] = {"text": "Hire", "name": "Hire_" + id, "solid": true, "press": main.act.bind("hire", id),
			"tip": "Signs this coach: %s once, then %s a week." % [GameMoney.text(GameMoney.COACH_SIGNING_FEE), GameMoney.text(int(who.get("salary", 0)))]}
	return s


static func _mat(c: Career) -> Dictionary:
	var money := Sim.bjj_money(c)
	var classes := roundi(float(money["coach"]) / float(BjjSide.COACH_CLASS))
	return {"id": "mat", "inner": "BjjCoach", "face": "mh_staff_coach_2", "name": "Mat coach", "tag": "No-gi",
		"role": "Jiu-jitsu coach, %d class%s" % [classes, "" if classes == 1 else "es"],
		"facts": [["Runs the no-gi classes", "good"], ["Trains your grappler" + ("" if c.grapplers.size() == 1 else "s"), ""],
		["You pay:", GameMoney.text(int(money["coach"])) + " a week"], ["Classes bring in:", GameMoney.text(int(money["dues"]))]], "hover": hover(c, "mat")}


static func _role(main: Node, c: Career, id: String) -> Dictionary:
	var r: Dictionary = StaffRoles.role(id)
	var on := c.staff_roles.has(id)
	var bout := int(r["per_bout"]) > 0
	var pay := GameMoney.text(int(r["per_bout"])) + " a night" if bout else GameMoney.text(int(r["wage"])) + " a week"
	var facts: Array = []
	for f in _figures(id):
		facts.append([f, "good"])
	facts.append(["You pay:", pay])
	var b := {"text": "Let go" if on else "Hire", "name": ("LetGo_" if on else "Hire_") + id, "solid": not on,
		"press": main.act.bind("letgorole" if on else "hirerole", id)}
	if on:
		b["tip"] = ("Takes this job off the staff; a week's notice costs %s." % GameMoney.text(StaffRoles.notice(id))) if StaffRoles.notice(id) > 0 \
			else "Takes this job off the staff; the pay by the night stops."
	else:
		b["tip"] = "Hires this person for %s.%s" % [pay, "" if bout else " " + HireRunway.text_for(c, int(r["wage"]), 0)]
	return {"id": id, "inner": "Role_" + id, "face": "", "open": not on, "name": str(StaffCard.ROLE_WORD.get(id, id)),
		"tag": "Pro nights" if bout else "", "role": str(ROLE_LINE.get(id, "")), "facts": facts, "button": b, "hover": hover(c, id)}


static func _figures(id: String) -> Array:
	match id:
		"assistant":
			return ["%d more boxer on the roster" % StaffRoles.places(["assistant"]), "Room for %d more members" % StaffRoles.COACH_MEMBERS]
		"strength":
			return ["%d%% fewer training injuries" % roundi((1.0 - StaffRoles.STRENGTH_RISK) * 100.0), "A pro camp costs half"]
		"physio":
			return ["Injured boxers back %d%% sooner" % roundi((1.0 - StaffRoles.PHYSIO_DAYS) * 100.0)]
		"cutman":
			return ["Half the layoffs from cuts"]
	return []


## at = the evening coaches already working (AT THE GYM); else the open job for one more. The game never refuses one
## (GymSpend.evening_coach): with room to spare the button is the quiet one and the card says why it can wait.
static func _evening(main: Node, c: Career, at: bool) -> Dictionary:
	var n := c.extra_coaches if at else 1
	var facts: Array = [["Room for %d more members" % (StaffRoles.COACH_MEMBERS * n), "good"]]
	var room := GymSpend.coaching_cap(c) - c.members
	if not at and room > 0:
		facts.append(["Not needed yet: the gym has room", ""])
	facts.append(["You pay:", GameMoney.text(StaffRoles.EVENING_WAGE * n) + " a week"])
	var b := {"text": "Let one go" if at else "Hire", "name": "LetGo_evening" if at else "Hire_evening", "solid": not at and room <= 0,
		"press": main.act.bind("eveningcoach", "cut" if at else "add"),
		"tip": ("One evening coach leaves; a week's notice costs %s." % GameMoney.text(StaffRoles.EVENING_WAGE)) if at
			else ("Adds an evening coach for %s a week." % GameMoney.text(StaffRoles.EVENING_WAGE))}
	return {"id": "evenings" if at else "evening", "inner": "EveningCoaches" if at else "EveningJob", "face": "", "open": not at,
		"name": "Evening coaches" if n > 1 else "Evening coach", "tag": "%d coaches" % n if n > 1 else "",
		"role": "10 hours a week" + (" each" if n > 1 else ""), "facts": facts, "button": b, "hover": hover(c, "evening")}


## ---------- the hover (what used to be the page's tiles and bars) ----------

static func hover(c: Career, id: String) -> Dictionary:
	match id:
		"you":
			var cd := HeadCoach.card(HeadCoach.of(c.head))
			return {"title": "Your edge: %s" % cd.get("edge", ""), "what": "What you bring as head coach.",
				"now": str(cd.get("plain", "")).replace("on file", "on the scouting report")}
		"mat":
			return {"title": "Mat coach", "what": "A jiu-jitsu coach, paid by the class.",
				"now": "%s a class; the no-gi dues pay for it." % GameMoney.text(BjjSide.COACH_CLASS)}
		"evening":
			return {"title": "Evening coaches", "what": "Ten hours of evening classes a week.",
				"now": "Each carries %d more members. The gym can carry %d now." % [StaffRoles.COACH_MEMBERS, GymSpend.coaching_cap(c)]}
	if not StaffRoles.role(id).is_empty():
		var r: Dictionary = StaffRoles.role(id)
		var said := PackedStringArray()
		for part in str(r["effect"]).split("; ", false):
			said.append(part.left(1).to_upper() + part.substr(1))
		return {"title": str(StaffCard.ROLE_WORD.get(id, id)), "what": "%s." % str(r["name"]), "now": "%s." % ". ".join(said)}
	var who := _with_areas(c.coach if str(c.coach.get("id", "")) == id else Data.coach(id))
	var rating := float(who.get("rating", 0.0))
	var rows: Array = []
	var ranked := CoachAreas.ranked(who)
	for i in mini(3, ranked.size()):   # the tooltip standard holds three rows (Tip.MAX_ROWS): his three best areas
		var a := str(ranked[i]["id"])
		var ra := float(ranked[i]["rating"])
		rows.append([CoachAreas.short(a), str(roundi(ra)), "%s %s" % [CoachAreas.pct_for(a, ra), "moves" if a == "pads" else "gain"], "good" if i == 0 else ""])
	var s := {"title": str(who.get("name", "")), "what": "%s, %s." % [str(who.get("kind", "")), str(who.get("note", ""))], "rows": rows,
		"means": means(rating)}
	var f := c.fighter()
	if not f.is_empty():
		s["now"] = boxer_line(c, f, who) + "."   # its own sentence (Tip.faults reads sentences: run on, it piled four numbers)
	return s


## What a coach of this rating holds: tactics in one fight plan (PlanBoard) and patterns checked a film night (FilmPattern).
static func means(rating: float) -> String:
	return "%d tactics a plan, %d film checks a night." % [PlanBoard.arrow_limit(rating), FilmPattern.checks(int(rating), true, 0, 99)]


## The boxer's week with this coach against training alone (WeekPlan; pad nights count moves, S413).
static func boxer_line(c: Career, f: Dictionary, coach: Dictionary) -> String:
	var area := CoachAreas.best(coach)
	if area == "pads":
		return CoachAreas.move_line(area, DrillWeek.week_moves(c, f, 0.0), DrillWeek.week_moves(c, f, CoachAreas.rating_for(coach, "pads")))
	return CoachAreas.line(area, _points(c, f, {}, area), _points(c, f, coach, area))


static func _points(c: Career, f: Dictionary, coach: Dictionary, area: String) -> float:
	var ctx: Dictionary = Sim.week_ctx(c, f)
	ctx["coach"] = coach
	return WeekPlan.area_week(WeekPlan.days_of(f), PadWeek.evenings(f), ctx, area)


static func _with_areas(coach: Dictionary) -> Dictionary:
	var fresh := Data.coach(str(coach.get("id", "")))
	if (coach.get("areas", {}) as Dictionary).size() >= CoachAreas.AREAS.size() or fresh.is_empty():
		return coach
	var out := coach.duplicate(true)
	out["areas"] = (fresh["areas"] as Dictionary).duplicate(true)
	if not out.has("rating"):
		out["rating"] = fresh["rating"]
	return out


static func _photo(c: Career, id: String) -> String:
	if id == "reid":
		return "mh_boxer_07"
	return "mh_boxer_08" if str(HeadCoach.card(HeadCoach.of(c.head)).get("photo", "")) == "mh_staff_trainer" else "mh_staff_trainer"
