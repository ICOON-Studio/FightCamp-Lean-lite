extends SceneTree
## S328 update 30 the road to the nationals in the career (Champs, on SeasonPath + ChampDraw): who can enter and when, the
## London regional draw, each round booked as a normal bout, no other offers while she is in it, a bye on its day, the
## national draw, the result words, a loss / an injury / missed weight ending the run, no draw and no ticket cut in a
## championship bout, the pages' lines, a save keeps it. Control arms: a club bout still pays the ticket cut and can be
## drawn; offers come again once the run is over. Prints CHAMPS failures=<n>.

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const ChampDraw := preload("res://scripts/rules/ChampDraw.gd")
const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const NationalField := preload("res://scripts/state/NationalField.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


## A known career (fixed dice), Lucy signed on day 0 with five bouts, on day 40 (S331 calendar: entries open day 14, close day 70).
func _career(seed_value: int = 7) -> Career:
	var c := Career.quick_start()
	c.seed = seed_value
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.cash = 1000000
	var f: Dictionary = c.fighter()
	f["w"] = 4
	f["l"] = 1
	c.day = 40
	return c


## Her booked championship bout settles as `won` without playing it (the round logic is under test, not the fight).
func _result(c: Career, f: Dictionary, won: bool) -> void:
	c.day = int(f["bout"]["day"])
	f["bout"]["done"] = true
	f["w" if won else "l"] = int(f["w" if won else "l"]) + 1
	c.results.push_front({"d": c.day, "fid": f["id"], "who": f["first"], "opp": f["bout"]["opp"]["name"], "win": won,
		"outcome": "win" if won else "loss", "pro": false, "cards": "", "why": ""})
	Bouts.after_fight(c, f)


func _initialize() -> void:
	# --- who can enter, and when ---
	var c := _career()
	var f: Dictionary = c.fighter()
	_check(int(f.get("joined", -1)) == 0, "signing records the day she joined: %s" % str(f.get("joined")))
	_check(int(f.get("registered", 0)) == -112, "a 3-1 walk-in was registered 4 bouts x 4 weeks before she signed: %s" % str(f.get("registered")))
	f["w"] = 3
	_check(Champs.cannot_enter(c, f) == "Needs 5 bouts (has 4)", "four bouts: not yet (%s)" % Champs.cannot_enter(c, f))
	_check(Champs.home_line(c, f) == "Road to the nationals: 4/5 bouts, entries close in 30 days", "HOME reads the road: %s" % Champs.home_line(c, f))
	f["w"] = 4
	_check(Champs.cannot_enter(c, f) == "", "five bouts, registered 152 days, entries open: she can enter")
	_check(Needs.needs(c).any(func(x): return str(x["t"]) == "Enter Lucy for the nationals" and str(x["arg"]) == "world:4" and not bool(x["red"])),
		"HOME needs: an amber Enter row that opens WORLD > Nationals")
	f["registered"] = 0
	_check(Champs.cannot_enter(c, f) == "Needs 3 months registered (8 weeks to go)", "a novice registered on day 0: not 3 months yet (%s)" % Champs.cannot_enter(c, f))
	_check(Champs.home_line(c, f).begins_with("Road to the nationals: 5/5 bouts, 5 of 13 weeks registered"), "HOME counts her registered weeks: %s" % Champs.home_line(c, f))
	f["registered"] = -112
	c.day = 10
	_check(Champs.cannot_enter(c, f) == "Entries open on %s" % Clock.fmt(14), "eligible before the window: %s" % Champs.cannot_enter(c, f))
	_check(Champs.home_line(c, f).begins_with("Ready for the nationals: entries open on"), "HOME says when entries open: %s" % Champs.home_line(c, f))
	c.day = 40
	f["injury"] = {"type": "hand", "days_out": 20, "until_day": 50, "choice": ""}
	_check(Champs.cannot_enter(c, f) == "Injured or suspended", "hurt: cannot enter")
	f["injury"] = {}
	f["bout"] = {"opp": Data.OPPONENTS[0].duplicate(true), "day": 83, "weighed": false, "made": false, "done": false, "film": 1}
	_check(Champs.cannot_enter(c, f).begins_with("Her bout on"), "a booked bout past the regional clashes: %s" % Champs.cannot_enter(c, f))
	f["bout"] = {}

	# --- entering: the regional draw, her first round booked, offers stop ---
	_check(Champs.enter(c, f), "she enters")
	var ch: Dictionary = f["champ"]
	_check(Champs.active(f) and bool(f["elite"]) and str(ch["level"]) == "regional" and int(ch["close"]) == 70, "entered: the London regional, Elite")
	_check((ch["pairs"] as Array).size() == 2 and int(ch["stage"]) == 0, "four in the regional: two semi-finals (%s)" % str(ch["pairs"]))
	var b: Dictionary = f["bout"]
	_check(int(b.get("champ", -1)) == 0 and int(b["day"]) == 84 and str(b["opp"]["name"]) == Champs.opponent(f),
		"her regional semi-final is booked on day 84 against her draw: %s" % str(b.get("opp", {}).get("name")))
	_check(c.news.any(func(x): return str(x["t"]).begins_with("Regional semi-final: Lucy Jackson vs")), "the booking is in the news")
	_check(Champs.home_line(c, f).begins_with("Nationals: regional semi-final vs"), "HOME: her next round: %s" % Champs.home_line(c, f))
	var cal := Champs.calendar(c)
	_check(cal.any(func(e): return int(e["d"]) == 70) and cal.any(func(e): return int(e["d"]) == 84) and cal.any(func(e): return int(e["d"]) == 91),
		"the calendar shows entries closing, the semi and the final")
	f["next_offer_day"] = 41
	c.day = 41
	f["bout"]["day"] = 84
	Bouts.day_events(c)
	_check((f["offers"] as Array).filter(func(o): return not bool(o["answered"])).is_empty(), "no other offers while she is in it")

	# --- the run: semi, final, the national draw, to the title ---
	var other_semi: Array = []
	for p in ch["pairs"]:
		if not (p as Array).has("lucy"):
			other_semi = p
	_result(c, f, true)
	_check(int(ch["stage"]) == 1 and int(f["bout"]["day"]) == 91 and int(f["bout"]["champ"]) == 1, "won the semi: the regional final on day 91")
	_check(other_semi.has(str(f["bout"]["opp"]["name"])), "her final opponent won the other semi: %s" % str(f["bout"]["opp"]["name"]))
	_result(c, f, true)
	_check(str(ch["level"]) == "national" and int(ch["national_size"]) >= 8 and int(ch["national_size"]) <= 12, "regional champion: the national draw (%d)" % int(ch["national_size"]))
	var first_stage := 6 - SeasonPath.bouts_to_win(int(ch["national_size"]))
	var nat_day := 70 + 14 + 7 + 21
	_check(c.news.any(func(x): return str(x["t"]).contains("London regional champion")), "the regional title is news")
	var bouts_boxed := 0
	var guard := 0
	while Champs.active(f) and guard < 6:
		guard += 1
		var st := int(ch["stage"])
		if (f["bout"] as Dictionary).is_empty():
			c.day = Champs.stage_day(70, st)
			Champs.day_events(c)
			continue
		_check(int(f["bout"]["day"]) == nat_day + int(SeasonPath.NATIONAL_ROUND_DAYS[st - 2]), "%s on its day (%d)" % [Champs.stage_name(st), int(f["bout"]["day"])])
		bouts_boxed += 1
		_result(c, f, true)
	_check(int(ch["stage"]) == 5 and bool(ch["done"]) and str(ch["result"]) == "National champion", "she won it: %s" % str(ch["result"]))
	_check(bouts_boxed >= 1 and bouts_boxed <= 4 and first_stage >= 2, "up to 4 national bouts (%d)" % bouts_boxed)
	_check((f["titles"] as Array).size() == 1 and int(f["titles"][0]["year"]) == 2026, "the title is on her record: %s" % str(f["titles"]))
	_check(bool(f["nat_final"]) and Roster.pro_ready(f), "a national finalist: the promoters call")
	_check(not Champs.active(f) and int(f["next_offer_day"]) > c.day, "control: the run is over, offers come again")

	# --- a loss in the semi ends it ---
	var l := _career(11)
	var lf: Dictionary = l.fighter()
	Champs.enter(l, lf)
	_result(l, lf, false)
	_check(not Champs.active(lf) and str(lf["champ"]["result"]) == "Lost in the regional semi-final" and (lf["bout"] as Dictionary).is_empty(),
		"lost the semi: %s, nothing booked" % str(lf["champ"]["result"]))
	_check(Champs.path(l, lf).any(func(r): return str(r["state"]) == "out"), "her road shows the loss")

	# --- a bye passes on its day ---
	var y := _career(13)
	var yf: Dictionary = y.fighter()
	Champs.enter(y, yf)
	var ych: Dictionary = yf["champ"]
	var names: Array = ych["field"].keys()
	ych["pairs"] = [["lucy", ChampDraw.BYE], [names[0], names[1]]]
	yf["bout"] = {}
	Champs.book_next(y, yf)
	_check((yf["bout"] as Dictionary).is_empty() and Champs.home_line(y, yf).begins_with("Nationals: a bye through"), "a bye: nothing booked before its day")
	y.day = 84
	Champs.day_events(y)
	_check(int(ych["stage"]) == 1 and int(yf["bout"].get("champ", -1)) == 1 and [names[0], names[1]].has(str(yf["bout"]["opp"]["name"])),
		"on the day she goes through and meets the other semi's winner in the final")

	# --- out injured, out at the scale ---
	var h := _career(17)
	var hf: Dictionary = h.fighter()
	Champs.enter(h, hf)
	hf["injury"] = {"type": "ribs", "days_out": 30, "until_day": 100, "choice": "pending"}
	var cash := h.cash
	Injuries.pull_out(h, hf)
	Champs.day_events(h)
	_check(str(hf["champ"]["result"]) == "Withdrew from the regional semi-final" and h.cash == cash, "pulled out hurt: withdrew, no empty-slot fee (%s)" % str(hf["champ"]["result"]))
	var s := _career(19)
	var sf: Dictionary = s.fighter()
	Champs.enter(s, sf)
	s.day = 83
	sf["weight"] = float(sf["limit"]) + 3.0
	Bouts.weigh(s, sf)
	_check(not Champs.active(sf) and str(sf["champ"]["result"]).begins_with("Withdrew"), "missed weight: out of the draw")
	var k := _career(23)
	var kf: Dictionary = k.fighter()
	Champs.enter(k, kf)
	kf["bout"] = {}
	kf["injury"] = {"type": "ko", "days_out": 90, "until_day": 190, "choice": ""}
	Champs.book_next(k, kf)
	_check(not Champs.active(kf) and k.news.any(func(x): return str(x["t"]).contains("no doctor will clear her")), "suspended past the day: no doctor clears her, she is out")

	# --- a real championship night: never a draw, no ticket cut; a club night still pays it ---
	var draws := 0
	var paid := 0
	for i in 40:
		var n := _career(100 + i)
		var nf: Dictionary = n.fighter()
		Champs.enter(n, nf)
		n.day = int(nf["bout"]["day"])
		nf["bout"]["weighed"] = true
		nf["bout"]["made"] = true
		var before := n.cash
		var m := {"fid": nf["id"], "step": "tape", "total": 3}
		Bouts.fight_step(n, nf, m, "sim")
		draws += int(str(m["outcome"]) == "draw")
		paid += int(n.cash - before >= BoutRules.TICKET_CUT)
		var won := bool(m["win"])
		var fought := int(nf["champ"]["stage"])
		Bouts.after_fight(n, nf)
		# The round she boxed in (S339: a win that leaves her hurt can add the next round's withdrawal after it).
		var r: Dictionary = (nf["champ"]["rounds"] as Array).filter(func(x): return int(x["stage"]) == fought)[0]
		if not ((r["winners"] as Array).has("lucy") == won):
			failures += 1
			print("  FAIL: night %d: her round result does not match the fight" % i)
	_check(draws == 0 and paid == 0, "40 championship nights: no draw (%d), no ticket cut (%d)" % [draws, paid])
	var club := _career(5)
	var cf: Dictionary = club.fighter()
	cf["bout"] = {"opp": Data.OPPONENTS[1].duplicate(true), "day": club.day, "weighed": true, "made": true, "done": false, "film": 1}
	var cb := club.cash
	Bouts.fight_step(club, cf, {"fid": cf["id"], "step": "tape", "total": 3}, "sim")
	_check(club.cash - cb == BoutRules.TICKET_CUT, "control: a club bout pays the ticket cut")

	# --- the national field and a save ---
	var a := NationalField.field(42, 11, "wlw")
	var seen := {}
	for o in a:
		seen[o["name"]] = true
	_check(a.size() == 11 and seen.size() == 11 and NationalField.field(42, 11, "wlw") == a and NationalField.field(43, 11, "wlw") != a,
		"the national field: 11 different women, the same for the same dice, others for other dice")
	_check(a.all(func(o): return float(o["rating"]) >= NationalField.RATING_MIN and float(o["rating"]) <= NationalField.RATING_MAX), "regional champions rate 62-73")
	var back := SaveGame.from_dict(SaveGame.to_dict(y))
	var bf: Dictionary = back.fighter()
	_check(Champs.active(bf) and int(bf["champ"]["stage"]) == 1 and int(bf["bout"]["champ"]) == 1, "a save keeps her run")

	print("CHAMPS failures=%d" % failures)
	quit(1 if failures > 0 else 0)
