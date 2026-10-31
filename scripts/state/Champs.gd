extends RefCounted
## S328 update 30: the road to the National Amateur Championships (make-it-a-game plan decision 6; rules SeasonPath +
## ChampDraw). England Boxing: 5 bouts and 3 months with the club to enter, Elite age 19-40, entering makes her Elite for
## life. The London regional (her and 3 of the region's women in her division), then the national draw (the other
## regions' champions, 8-12 boxers). Every round she boxes is a normal booked bout - camp, weigh-in, fight night, the
## corner - marked bout["champ"] = the stage; a bye passes on its day; a loss, an injury or missed weight ends the run.
## While she is in it no other offers come. Fighter keys: "joined" (the day she signed), "champ" (this season's run, {}
## before any), "titles" [{year, t}], "elite", "nat_final" (reached a national final: promoters call).
## Bouts.after_fight, Bouts.day_events, Sim.step_day, Clock.next_stop, Needs and the WORLD/FIGHTS/HOME pages call in here.

const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")
const ChampDraw := preload("res://scripts/rules/ChampDraw.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const NationalField := preload("res://scripts/state/NationalField.gd")

## Her and three of the region's women (SeasonPath clamps a regional to 4).
const REGIONAL_FIELD := 4
const NATIONAL_MIN := 8
const NATIONAL_MAX := 12
## Entries open 8 weeks before they close (England Boxing opens the NAC entry window weeks ahead; the game shows it then).
const ENTRY_WINDOW := 56
const RATING_STATS: Array[String] = ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]


static func active(f: Dictionary) -> bool:
	var ch: Dictionary = f.get("champ", {})
	return not ch.is_empty() and not bool(ch["done"])


static func bouts(f: Dictionary) -> int:
	return int(f["w"]) + int(f["l"]) + int(f.get("d", 0))


## Days with the club (a save from before update 30 has no "joined": she counts from the career's first day).
static func club_days(c: Career, f: Dictionary) -> int:
	return c.day - int(f.get("joined", 0))


static func check(c: Career, f: Dictionary) -> Dictionary:
	return SeasonPath.eligible(bouts(f), club_days(c, f), int(f.get("age", 21)), Injuries.out(c, f), bool(f.get("pro", false)))


static func entries_open(c: Career) -> bool:
	return SeasonPath.entry_close(c.day) - c.day <= ENTRY_WINDOW


static func opens_on(c: Career) -> int:
	return SeasonPath.entry_close(c.day) - ENTRY_WINDOW


## Her strength on the draw's scale (the rivals' "rating" is BoutRules.fight_power's base: the six fight stats' mean).
static func rating_of(f: Dictionary) -> float:
	var s := 0.0
	for k in RATING_STATS:
		s += float(f["stats"].get(k, 55.0))
	return snappedf(s / RATING_STATS.size(), 0.5)


## The day of a stage of this season's championship.
static func stage_day(close: int, stage: int) -> int:
	if stage < 2:
		return close + SeasonPath.REGIONAL_START + SeasonPath.REGIONAL_GAP * stage
	return close + SeasonPath.REGIONAL_START + SeasonPath.REGIONAL_GAP + SeasonPath.NATIONALS_GAP + SeasonPath.NATIONAL_ROUND_DAYS[stage - 2]


## Why she cannot enter now, "" when she can.
static func cannot_enter(c: Career, f: Dictionary) -> String:
	if active(f):
		return "Already entered"
	var close := SeasonPath.entry_close(c.day)
	if not (f.get("champ", {}) as Dictionary).is_empty() and int(f["champ"]["close"]) == close:
		return "Already boxed this year's championships"
	var ok := check(c, f)
	if not bool(ok["ok"]):
		return str(ok["reason"])
	if not entries_open(c):
		return "Entries open on %s" % Clock.fmt(opens_on(c))
	var b: Dictionary = f["bout"]
	if not b.is_empty() and int(b["day"]) >= stage_day(close, 0) - 2:
		return "Her bout on %s clashes with the regional (%s)" % [Clock.fmt(int(b["day"])), Clock.fmt(stage_day(close, 0))]
	return ""


## Enters her: the London regional draw is made now. Returns false when she cannot.
static func enter(c: Career, f: Dictionary) -> bool:
	if cannot_enter(c, f) != "":
		return false
	var close := SeasonPath.entry_close(c.day)
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 131 + close * 17 + absi(hash(str(f["id"])))
	var pool: Array = c.rivals.filter(func(r): return str(r["div"]) == str(f["div"]))
	for i in range(pool.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = pool[i]
		pool[i] = pool[j]
		pool[j] = t
	var ch := {"close": close, "level": "regional", "stage": 0, "pairs": [], "ratings": {}, "field": {}, "rounds": [],
		"done": false, "result": "", "withdraw": false, "national_size": 0}
	var entrants: Array = [{"id": str(f["id"]), "rating": rating_of(f)}]
	ch["ratings"][str(f["id"])] = rating_of(f)
	for r in pool.slice(0, REGIONAL_FIELD - 1):
		entrants.append({"id": str(r["name"]), "rating": float(r["rating"])})
		ch["ratings"][str(r["name"])] = float(r["rating"])
		ch["field"][str(r["name"])] = (r as Dictionary).duplicate(true)
	ch["pairs"] = ChampDraw.first_round(entrants)
	ch["stage"] = 2 - SeasonPath.bouts_to_win(entrants.size())
	f["champ"] = ch
	f["elite"] = true
	for o in f["offers"]:
		o["answered"] = true
	c.add_news("%s is entered for the National Amateur Championships: the London regional starts %s. Entering makes her an Elite boxer." % [
		f["name"], Clock.fmt(stage_day(close, int(ch["stage"])))])
	if (f["bout"] as Dictionary).is_empty():
		book_next(c, f)
	return true


static func opponent(f: Dictionary) -> String:
	return ChampDraw.opponent(f["champ"]["pairs"], str(f["id"]))


static func stage_name(stage: int) -> String:
	return str(SeasonPath.STAGE_NAMES[clampi(stage, 0, SeasonPath.STAGE_NAMES.size() - 1)])


## Books her next round as a normal bout (or waits for a bye's day). Called with no bout booked.
static func book_next(c: Career, f: Dictionary) -> void:
	while active(f) and (f["bout"] as Dictionary).is_empty():
		var ch: Dictionary = f["champ"]
		var stage := int(ch["stage"])
		var day := stage_day(int(ch["close"]), stage)
		var opp := opponent(f)
		if opp == ChampDraw.BYE:
			if c.day < day:
				return
			c.add_news("%s has a bye through the %s." % [f["first"], stage_name(stage).to_lower()])
			advance(c, f, true)
			continue
		if day < c.day:
			withdraw(c, f, "she could not box on the day")
			return
		var inj: Dictionary = f.get("injury", {})
		var hurt_past := Injuries.out(c, f) and int(inj["until_day"]) > day
		if hurt_past and Injuries.NO_CHOICE.has(str(inj["type"])):
			withdraw(c, f, "no doctor will clear her")
			return
		f["bout"] = {"opp": (ch["field"][opp] as Dictionary).duplicate(true), "day": day, "weighed": day == c.day,
			"made": day == c.day, "done": false, "film": BoutRules.FILM_DEPTH_DEFAULT, "champ": stage}
		f["booked_fight"] = true
		c.add_news("%s: %s vs %s, %s." % [stage_name(stage), f["name"], opp, Clock.fmt(day)])
		if hurt_past:
			f["injury"]["choice"] = "pending"
			c.add_news("%s's %s is on %s, before she is fit: you decide." % [f["first"], stage_name(stage).to_lower(), Clock.fmt(day)])
		return


## The round is settled: the other pairs by the draw's dice, hers by her result. A loss ends the run.
static func advance(c: Career, f: Dictionary, won: bool, words: String = "") -> void:
	var ch: Dictionary = f["champ"]
	var stage := int(ch["stage"])
	var winners := ChampDraw.winners(ch["pairs"], ch["ratings"], str(f["id"]), won, c.seed + int(ch["close"]) * 31 + stage * 7)
	(ch["rounds"] as Array).append({"stage": stage, "pairs": (ch["pairs"] as Array).duplicate(true), "winners": winners})
	if not won:
		_finish(c, f, stage, false, words)
		return
	if winners.size() <= 1:
		if str(ch["level"]) == "regional":
			c.add_news("%s is the London regional champion. She goes to the nationals." % f["name"])
			_national_draw(c, f)
		else:
			_finish(c, f, 5, true)
		return
	ch["pairs"] = ChampDraw.next_round(winners)
	ch["stage"] = stage + 1


## Out of the run without boxing (injured, missed weight): her opponent goes through.
static func withdraw(c: Career, f: Dictionary, why: String) -> void:
	if not active(f):
		return
	var stage := int(f["champ"]["stage"])
	c.add_news("%s withdraws from the %s: %s." % [f["first"], stage_name(stage).to_lower(), why])
	advance(c, f, false, "Withdrew from the " + stage_name(stage).to_lower())


## After her championship bout (Bouts.after_fight): settle the round, book the next.
static func after_bout(c: Career, f: Dictionary, won: bool) -> void:
	if not active(f):
		return
	advance(c, f, won)
	book_next(c, f)


## Each day (Sim.step_day, after the week's injuries): a pull-out ends the run; a bye passes; the next round is booked.
static func day_events(c: Career) -> void:
	for f in c.fighters:
		if not active(f):
			continue
		if bool(f["champ"].get("withdraw", false)):
			f["champ"]["withdraw"] = false
			withdraw(c, f, "injured")
			continue
		if (f["bout"] as Dictionary).is_empty():
			book_next(c, f)


static func _national_draw(c: Career, f: Dictionary) -> void:
	var ch: Dictionary = f["champ"]
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 211 + int(ch["close"]) * 13
	var size := rng.randi_range(NATIONAL_MIN, NATIONAL_MAX)
	var entrants: Array = [{"id": str(f["id"]), "rating": rating_of(f)}]
	ch["ratings"][str(f["id"])] = rating_of(f)
	for o in NationalField.field(rng.randi(), size - 1, str(f["div"])):
		entrants.append({"id": str(o["name"]), "rating": float(o["rating"])})
		ch["ratings"][str(o["name"])] = float(o["rating"])
		ch["field"][str(o["name"])] = o
	ch["level"] = "national"
	ch["national_size"] = entrants.size()
	ch["pairs"] = ChampDraw.first_round(entrants)
	ch["stage"] = 6 - SeasonPath.bouts_to_win(entrants.size())
	c.add_news("The national draw is made: %d regional champions, %s." % [entrants.size(), Clock.fmt(stage_day(int(ch["close"]), int(ch["stage"])))])


static func _finish(c: Career, f: Dictionary, reached: int, won: bool, words: String = "") -> void:
	var ch: Dictionary = f["champ"]
	var result := words if words != "" else SeasonPath.result_words(reached, won)
	ch["done"] = true
	ch["result"] = result
	ch["reached"] = reached
	var year := int(Clock._date(int(ch["close"]))["year"])
	f["titles"] = (f.get("titles", []) as Array) + [{"year": year, "t": result}]
	if reached == 5:
		f["nat_final"] = true
	c.add_news("Nationals %d: %s - %s." % [year, f["name"], result])


## ---------- what the pages show ----------

## HOME's season line under her name, "" for a pro.
static func home_line(c: Career, f: Dictionary) -> String:
	if bool(f.get("pro", false)):
		return ""
	var ch: Dictionary = f.get("champ", {})
	if active(f):
		var stage := int(ch["stage"])
		var opp := opponent(f)
		if opp == ChampDraw.BYE:
			return "Nationals: a bye through the %s, %s" % [stage_name(stage).to_lower(), Clock.fmt(stage_day(int(ch["close"]), stage))]
		return "Nationals: %s vs %s, %s" % [stage_name(stage).to_lower(), opp, Clock.fmt(stage_day(int(ch["close"]), stage))]
	if not entries_open(c) and not ch.is_empty():
		return "Nationals %d: %s" % [int(Clock._date(int(ch["close"]))["year"]), ch["result"]]
	var ok := bool(check(c, f)["ok"])
	if ok and not entries_open(c):
		return "Ready for the nationals: entries open on %s" % Clock.fmt(opens_on(c))
	return SeasonPath.goal_line(c.day, bouts(f), club_days(c, f), ok and cannot_enter(c, f) == "")


## Her road this season, round by round: [{stage, label, d, t, state}] (state done | next | ahead | out).
static func path(c: Career, f: Dictionary) -> Array:
	var ch: Dictionary = f.get("champ", {})
	var rows: Array = []
	if ch.is_empty():
		return rows
	var me := str(f["id"])
	for r in ch["rounds"]:
		var opp := ChampDraw.opponent(r["pairs"], me)
		var went := (r["winners"] as Array).has(me)
		var t := "a bye" if opp == ChampDraw.BYE else ("beat %s" % opp if went else "lost to %s" % opp)
		if not went and opp != ChampDraw.BYE and str(ch["result"]).begins_with("Withdrew"):
			t = "withdrew; %s goes through" % opp
		rows.append({"stage": int(r["stage"]), "label": stage_name(int(r["stage"])), "d": stage_day(int(ch["close"]), int(r["stage"])),
			"t": t, "state": "done" if went else "out"})
	if not active(f):
		return rows
	var stage := int(ch["stage"])
	var last := 1 if str(ch["level"]) == "regional" else 5
	for s in range(stage, last + 1):
		var t := "if she keeps winning"
		if s == stage:
			var opp := opponent(f)
			t = "a bye" if opp == ChampDraw.BYE else "vs %s" % opp
		rows.append({"stage": s, "label": stage_name(s), "d": stage_day(int(ch["close"]), s), "t": t,
			"state": "next" if s == stage else "ahead"})
	if str(ch["level"]) == "regional":
		rows.append({"stage": 2, "label": "National championships", "d": stage_day(int(ch["close"]), 2),
			"t": "the draw is made after the regional", "state": "ahead"})
	return rows


## The calendar's championship dates: entries close (while she can still go this year) and her road.
static func calendar(c: Career) -> Array:
	var ev: Array = []
	var close := SeasonPath.entry_close(c.day)
	var amateurs := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	if not amateurs.is_empty():
		ev.append({"d": close, "t": "Nationals entries close"})
	for f in amateurs:
		for row in path(c, f):
			if str(row["state"]) == "next" or str(row["state"]) == "ahead":
				ev.append({"d": int(row["d"]), "t": "%s: %s (%s)" % [row["label"], f["first"], row["t"]]})
	return ev
