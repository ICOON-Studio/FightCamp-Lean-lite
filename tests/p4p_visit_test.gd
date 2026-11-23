extends SceneTree
## S533 P4PBUILD1 stage 1, THE VISIT (DESIGN_THREEP4P_V2 section 3): the beaten amateur opponent may ask to join.
## Evidence from the settled exchanges opens the door, the chance is seeded, bounded and never certain; the rival's
## identity and today's record move with the boxer on signing (once); a pass or an expiry starts a 120-day wait;
## Sign now / Pass / Trial first each show their real cost; save and load keep all of it; then the same walk through
## the real screens (reception, Home's need) and through real simmed bouts.
## Population: a quick-start club with Lucy against the region's own named rivals. Prints P4P_VISIT failures=N.

const CardAsk := preload("res://scripts/rules/CardAsk.gd")
const VisitWire := preload("res://scripts/state/VisitWire.gd")
const Data := preload("res://scripts/state/Data.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Region := preload("res://scripts/state/Region.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _x(at: String, won: bool, arrow: String = "", shout: bool = false, call: String = "") -> Dictionary:
	return {"at": at, "pinned": false, "won": won, "arrow": arrow, "planned": arrow != "", "arrow_fit": "best" if arrow != "" else "none",
		"shout": shout, "call": call, "fit": "best" if shout else "none"}


func _round(n: int, exs: Array) -> Dictionary:
	return {"n": n, "won": true, "exchanges": exs, "arrows": PlanFight.tally(exs), "plan": []}


## A night with the same planned line winning twice on the ropes.
func _line_night() -> Array:
	return [_round(1, [_x("long", true, "1-2"), _x("own_ropes", true, "pivot_out"), _x("mid", false)]),
		_round(2, [_x("own_ropes", true, "pivot_out"), _x("long", true, "1-2")])]


func _club(seed_value: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_value
	c.applicant = {}
	c.first_hour = {}
	c.guide = ""
	c.reputation = 40
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	return c


func _rival_of(c: Career) -> Dictionary:
	var div := str(c.fighters[0]["div"])
	return (c.rivals.filter(func(r): return str(r["div"]) == div) as Array)[2]


## The night's bookkeeping as BoutFinish does it, then the visit. Returns the bout dict.
func _night(c: Career, r: Dictionary, rounds: Array, win: bool = true, pro: bool = false) -> Dictionary:
	var m := {"damage": {"a": 4.0, "b": 9.0}}
	if not r.is_empty() and c.rivals.has(r):
		Region.record(r, not win)
	c.results.push_front({"d": c.day, "fid": "lucy"})
	VisitWire.after_bout(c, c.fighters[0], m, r, win, pro, rounds)
	return m


## The first seed on which this club, this day, gets the visit ({} = none in `tries`).
func _asked(rounds: Array, tries: int = 400, prep: Callable = Callable()) -> Dictionary:
	for s in range(1, tries + 1):
		var c := _club(s)
		if prep.is_valid():
			prep.call(c)
		var r := _rival_of(c)
		var m := _night(c, r, rounds)
		if not c.applicant.is_empty():
			return {"c": c, "r": r, "m": m, "seed": s}
	return {}


func _initialize() -> void:
	_rules()
	_wire()
	await _screens()
	_real_bouts()
	print("P4P_VISIT failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _rules() -> void:
	var ev := CardAsk.evidence(_line_night())
	_check(bool(ev["qualifies"]) and ev["kind"] == "line" and ev["what"] == "pivot_out" and int(ev["count"]) == 2 and ev["refs"] == [[1, 2], [2, 1]],
		"the same planned line won twice on the ropes is evidence, with its two exchanges: %s" % str(ev))
	var once := CardAsk.evidence([_round(1, [_x("own_ropes", true, "pivot_out"), _x("long", true, "1-2"), _x("long", true, "1-2")])])
	_check(not bool(once["qualifies"]), "once on the ropes is not evidence; wins off the ropes never count, however many")
	var held := _x("own_ropes", true, "pivot_out")
	held["planned"] = false
	_check(not bool(CardAsk.evidence([_round(1, [held, held.duplicate()])])["qualifies"]), "a line that did not fire (held, improvised) is not evidence")
	var call := CardAsk.evidence([_round(1, [_x("own_ropes", true, "", true, "tie"), _x("long", false)])])
	_check(bool(call["qualifies"]) and call["kind"] == "call" and call["what"] == "tie", "a heard, fitted call on the ropes followed by an exchange off them is evidence")
	_check(not bool(CardAsk.evidence([_round(1, [_x("own_ropes", true, "", true, "tie"), _x("own_ropes", false)])])["qualifies"]),
		"a call followed by another exchange on the ropes earns no escape")
	_check(not bool(CardAsk.evidence([_round(1, [_x("long", true), _x("own_ropes", true, "", true, "tie")])])["qualifies"]),
		"a call on the round's last exchange has no recorded escape")
	_check(not bool(CardAsk.evidence([{"n": 1, "won": true}, "x"])["qualifies"]), "an old bout with no exchanges recorded: no evidence, no crash")
	# S540 P4PEVID1: a step that RODE off the ropes is recorded on the card it led to (StepWire.ride: at = mid, rode_from = own_ropes)
	var rode := _x("mid", true, "pivot_out")
	rode["rode_from"] = "own_ropes"
	var esc := CardAsk.evidence([_round(1, [rode, _x("long", true, "1-2")]), _round(2, [rode.duplicate(), _x("mid", false)])])
	_check(bool(esc["qualifies"]) and esc["kind"] == "line" and esc["what"] == "pivot_out" and int(esc["pressure"]) == 2,
		"an escape that rode off the own ropes is under pressure: twice won = evidence (%s)" % str(esc))
	_check(not bool(CardAsk.evidence([_round(1, [_x("mid", true, "pivot_out"), _x("mid", true, "pivot_out")])])["qualifies"]),
		"the same line won twice at mid, never on the ropes, is not evidence")
	var lo := CardAsk.chance(0, true, 0, 6)
	var hi := CardAsk.chance(100, true, 6, 6)
	_check(lo > 0.0 and hi > lo and is_equal_approx(hi, CardAsk.CAP) and CardAsk.chance(9999, true, 50, 50) <= CardAsk.CAP,
		"the chance grows with the plan's share and the gym's name, never past %.2f (%.2f to %.2f)" % [CardAsk.CAP, lo, hi])
	_check(is_equal_approx(CardAsk.chance(40, true, 2, 4), CardAsk.chance(40, true, 20, 40)), "the plan's part is a share: repeating it adds nothing")
	_check(CardAsk.asks(true, false, true, true, true, true, true, 0.2, 0.1), "all gates open and the roll under the chance: the opponent asks")
	_check(not CardAsk.asks(true, false, true, true, true, true, true, 0.2, 0.2), "never certain: the roll decides")
	_check(not CardAsk.asks(false, false, true, true, true, true, true, 1.0, 0.0), "never after a loss")
	_check(not CardAsk.asks(true, true, true, true, true, true, true, 1.0, 0.0), "never after a pro bout")
	_check(not CardAsk.asks(true, false, false, true, true, true, true, 1.0, 0.0), "never while someone waits at reception")
	_check(not CardAsk.asks(true, false, true, false, true, true, true, 1.0, 0.0), "never with every place taken")
	_check(not CardAsk.asks(true, false, true, true, false, true, true, 1.0, 0.0), "never for a boxer the region does not know")
	_check(not CardAsk.asks(true, false, true, true, true, false, true, 1.0, 0.0), "never inside the 120-day wait")
	_check(not CardAsk.asks(true, false, true, true, true, true, false, 1.0, 0.0), "never without evidence")
	_check(CardAsk.reason(ev, "pivot out").contains("pivot out") and CardAsk.reason(call, "Tie up").contains("after the call"),
		"the line at reception quotes the exact action, and a call is 'after the call'")


func _wire() -> void:
	var got := _asked(_line_night())
	_check(not got.is_empty(), "a qualifying night brings the visit on some seed (first: %s)" % str(got.get("seed", "none")))
	if got.is_empty():
		return
	var c: Career = got["c"]
	var r: Dictionary = got["r"]
	var a: Dictionary = c.applicant
	var name := str(r["name"])
	_check(str(a["rival"]) == name and int(a["w"]) == int(r["w"]) and int(a["l"]) == int(r["l"]) and str(a["club_before"]) == str(r["club"]),
		"the visitor IS the region's boxer: link, club and the record with tonight's loss (%d-%d)" % [int(a["w"]), int(a["l"])])
	_check(str(got["m"].get("card_ask", "")).contains(Clock.fmt(c.day + CardAsk.WAIT_DAYS)) and not str(got["m"]["card_ask"]).contains(name),
		"the result line gives the last day and no name: %s" % str(got["m"].get("card_ask", "")))
	_check(str(a.get("quote", "")).contains("2 times") and not str(a["quote"]).contains("pivot_out"), "the quote is the evidence in words: %s" % str(a.get("quote", "")))
	_check((c.results[0].get("evidence", {}) as Dictionary).get("kind", "") == "line", "the bout's record keeps the evidence")
	# The misses: no evidence, no link, no place, a loss.
	var none := _asked([_round(1, [_x("long", true, "1-2"), _x("long", true, "1-2")])], 150)
	_check(none.is_empty(), "an easy win with no pressure never brings a visit, on any of 150 seeds")
	var seen_note := false
	var unlinked := false
	for s in range(1, 151):
		var cu := _club(s)
		var mu := _night(cu, {"name": "Nobody Known", "first": "Nobody", "w": 2, "l": 2, "rating": 50.0}, _line_night())
		unlinked = unlinked or not cu.applicant.is_empty()
		seen_note = seen_note or str(mu.get("visit_note", "")) != ""
	_check(not unlinked and seen_note, "an opponent the region does not know never becomes a visitor (no invented boxer); the result says the work was noticed")
	var full := _asked(_line_night(), 150, func(cf: Career):
		while GymSpend.place_blocked(cf) == "":
			var extra := Data.fighter_state(Data.lucy(), cf.day)
			extra["id"] = "extra%d" % cf.fighters.size()
			cf.fighters.append(extra))
	_check(full.is_empty(), "with every place taken (boxers and grapplers together) nobody asks")
	# Save and load keep the visit.
	var back := SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c))))
	_check(str(back.applicant.get("rival", "")) == name and int(back.applicant["expires"]) == int(a["expires"]) and str(back.applicant["quote"]) == str(a["quote"])
		and bool(back.applicant["from_card"]), "save and load keep the link, the last day and the quote")
	# The trial: one, on the Monday inside the visit, then one day to decide.
	var monday := c.day - posmod(c.day, 7) + 7
	var expected := monday if monday <= int(a["expires"]) else -1
	_check(CardAsk.trial_day_for(a, c.day) == expected, "the trial is next Monday when that falls inside the visit (%d)" % expected)
	a["expires"] = monday + 3
	_check(VisitWire.trial(c) and int(a["trial_day"]) == monday and int(a["expires"]) == monday + CardAsk.TRIAL_DECIDE_DAYS and not VisitWire.trial(c),
		"Trial first books the one Monday and leaves one day after it to decide; there is no second trial")
	_check(c.fighters.size() == 1 and not CardAsk.trial_seen(a, c.day) and CardAsk.trial_seen(a, monday), "the trial holds no place and is seen on its day")
	# Trial first has a price: on the trial's morning the old club may have won the boxer back (seeded, about 1 in 4).
	var lost := 0
	var lost_ok := true
	var came_ok := true
	for s in range(1, 201):
		var ct: Career = SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c))))
		ct.seed = s
		ct.day = monday
		VisitWire.day(ct)
		if ct.applicant.is_empty():
			lost += 1
			lost_ok = lost_ok and int(ct.rival(name).get("visit_cool", -1)) == monday + CardAsk.COOLDOWN_DAYS and ct.fighters.size() == 1
		else:
			VisitWire.day(ct)   # the same morning again rolls nothing new
			came_ok = came_ok and bool(ct.applicant.get("trial_came", false)) and CardAsk.trial_seen(ct.applicant, ct.day)
	print("  P4P_VISIT trial mornings=200 lost=%d" % lost)
	_check(lost >= 30 and lost <= 70 and lost_ok and came_ok, "Trial first costs something: on about 1 morning in 4 the boxer has gone back (%d of 200), the wait runs; else the read is there" % lost)
	# Expiry: here through the last day, gone the day after, and the wait starts.
	var c2: Career = SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c))))
	c2.day = int(c2.applicant["expires"])
	VisitWire.day(c2)
	_check(not c2.applicant.is_empty(), "on the last day the visitor is still at reception")
	c2.day += 1
	VisitWire.day(c2)
	_check(c2.applicant.is_empty() and int(c2.rival(name).get("visit_cool", -1)) == c2.day + CardAsk.COOLDOWN_DAYS and c2.fighters.size() == 1,
		"the day after, the visitor is gone and the 120-day wait runs")
	# Pass: the wait, and no new ask inside it.
	var c3: Career = SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c))))
	VisitWire.pass_visit(c3)
	var cool := int(c3.rival(name).get("visit_cool", -1))
	_check(c3.applicant.is_empty() and cool == c3.day + CardAsk.COOLDOWN_DAYS, "Pass: reception is free and the wait runs to day %d" % cool)
	var again := false
	for s in range(1, 301):
		c3.seed = s
		c3.day = cool - 1
		_night(c3, c3.rival(name), _line_night())
		again = again or not c3.applicant.is_empty()
	_check(not again, "inside the wait that boxer never asks again (300 seeds)")
	for s in range(1, 301):
		c3.seed = s
		c3.day = cool
		if c3.applicant.is_empty():
			_night(c3, c3.rival(name), _line_night())
	_check(not c3.applicant.is_empty(), "from day %d a new qualifying bout can bring the boxer back" % cool)
	c3 = SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c3))))
	_check(not c3.applicant.is_empty() and int(c3.rival(name)["visit_cool"]) == cool, "save and load keep the wait too")
	# Sign with the club full: refused, the visit stays open; then signed once, the rival moved, today's record.
	var before := c.fighters.size()
	var places_free: Array = []
	while GymSpend.place_blocked(c) == "":
		var extra := Data.fighter_state(Data.lucy(), c.day)
		extra["id"] = "extra%d" % c.fighters.size()
		c.fighters.append(extra)
		places_free.append(extra)
	var no: Dictionary = VisitWire.sign(c, ["technique"])
	_check(not bool(no["ok"]) and str(no["why"]) != "" and not c.applicant.is_empty() and not c.rival(name).is_empty(),
		"a filled last place refuses the signing and says why (%s); the visit stays open" % str(no["why"]))
	for e in places_free:
		c.fighters.erase(e)
	r["w"] = int(r["w"]) + 1   # the world moved on while the visitor waited
	c.fighters[0]["offers"] = [{"id": "lucy:x", "opp": {"name": name}, "answered": false}, {"id": "lucy:y", "opp": {"name": "Someone Else"}, "answered": false}]
	var rivals_before := c.rivals.size()
	var focus := str(Recruit.FOCUS.keys()[0])
	var yes: Dictionary = VisitWire.sign(c, [focus])
	var f: Dictionary = yes.get("f", {})
	_check(bool(yes["ok"]) and c.fighters.size() == before + 1 and c.applicant.is_empty() and str(f["name"]) == name, "Sign now: the boxer is on the roster")
	_check(c.rival(name).is_empty() and c.rivals.size() == rivals_before - 1, "the rival left the region's table exactly once")
	_check(int(f["w"]) == int(r["w"]) and int(f["l"]) == int(r["l"]) and (f.get("past_bouts", []) as Array).size() == (r.get("bouts", []) as Array).size(),
		"the record is today's (%d-%d), with the bouts behind it" % [int(f["w"]), int(f["l"])])
	_check((f.get("stand_down", {}) as Dictionary).has("open_day"), "the rest after the bout came along (no sparring until day %s)" % str((f.get("stand_down", {}) as Dictionary).get("open_day", "?")))
	_check(c.fighters[0]["offers"].size() == 1 and str(c.fighters[0]["offers"][0]["id"]) == "lucy:y", "an offer against that boxer is withdrawn; the others stay")
	var twice: Dictionary = VisitWire.sign(c, [focus])
	_check(not bool(twice["ok"]) and c.fighters.size() == before + 1, "a second press signs nobody")
	# An old save's visitor (no link): resolved by name when the region still has the boxer, never duplicated.
	var c4 := _club(5)
	var r4 := _rival_of(c4)
	var old := CardAsk.walkin(r4, c4.fighters[0], c4.day)
	old.erase("rival")
	old.erase("trial_day")
	c4.applicant = old
	var s4: Dictionary = VisitWire.sign(c4, [focus])
	_check(bool(s4["ok"]) and c4.rival(str(r4["name"])).is_empty() and c4.fighters.size() == 2, "an old save's visitor signs and leaves the table (no twin)")
	var c5 := _club(5)
	var ghost := CardAsk.walkin({"name": "Old Save Ghost", "first": "Old", "w": 1, "l": 1, "rating": 50.0}, c5.fighters[0], c5.day)
	ghost.erase("rival")
	c5.applicant = ghost
	var n5 := c5.rivals.size()
	_check(bool(VisitWire.sign(c5, [focus])["ok"]) and c5.rivals.size() == n5, "an old visitor the region never knew signs as before, nothing guessed")


func _screens() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	var got := _asked(_line_night())
	if got.is_empty():
		_check(false, "screens: no visit to show")
		return
	var src: Career = got["c"]
	c.applicant = {}
	c.first_hour = {}
	c.guide = ""
	c.seed = src.seed
	c.day = src.day
	c.reputation = src.reputation
	c.rivals = src.rivals
	c.fighters = src.fighters
	c.applicant = src.applicant
	var name := str(c.applicant["name"])
	var need: Array = Needs.needs(c).filter(func(n): return str(n.get("act", "")) == "interview")
	_check(need.size() == 1 and not bool(need[0]["red"]) and not (str(need[0]["t"]) + str(need[0]["s"])).contains(name)
		and str(need[0]["s"]).contains(Clock.fmt(int(c.applicant["expires"]))), "Home's need: not a blocker, no name, the last day (%s)" % str(need[0].get("s", "")))
	main.act("interview")
	await process_frame
	var modal: Node = main.find_child("WalkInCard", true, false)
	_check(modal != null and modal.find_child("Sign", true, false) != null and modal.find_child("Pass", true, false) != null,
		"reception opens on the visitor with Sign and Pass")
	var terms := modal.find_child("VisitTerms", true, false) if modal != null else null
	_check(terms != null and str(terms.get("text")).contains("$250") and str(terms.get("text")).contains("of %d" % GymSpend.places(c)),
		"the terms show the real stipend and the place it takes: %s" % (str(terms.get("text")) if terms != null else "-"))
	var until := modal.find_child("VisitUntil", true, false) if modal != null else null
	_check(until != null and str(until.get("text")).contains(Clock.fmt(int(c.applicant["expires"])).to_upper()), "the card says the last day")
	var can_trial := CardAsk.trial_day_for(c.applicant, c.day) >= 0
	_check((modal.find_child("Trial", true, false) != null) == can_trial, "Trial first is offered only when a Monday falls inside the visit (%s)" % str(can_trial))
	if can_trial:
		main.act("trialvisit")
		await process_frame
		_check(int(c.applicant["trial_day"]) > c.day and main.find_child("Trial", true, false) == null and not c.applicant.is_empty(), "Trial first: booked, and offered once")
		main.act("interview")
		await process_frame
	main.act("pickcard", str(Recruit.FOCUS.keys()[0]))
	await process_frame
	var n := c.fighters.size()
	main.act("signvisit")
	await process_frame
	_check(c.fighters.size() == n + 1 and c.applicant.is_empty() and c.rival(name).is_empty() and main.modal.is_empty(), "Sign on the real screen: on the roster, off the region's table")
	main.queue_free()
	await process_frame


## Real bouts, booked through the Ask and fought by the game's own sim, until one brings the visit: what the result
## carries then, and how often evidence turns up at all (printed, bounded - a tuning read, not a gate on a count).
func _real_bouts() -> void:
	var bouts := 0
	var wins := 0
	var evid := 0
	var visits := 0
	var first: Dictionary = {}
	var diag := {}
	for s in range(1, 61):
		var c := _club(100 + s)
		c.reputation = 60
		var f: Dictionary = c.fighters[0]
		var opp := str(AskFlow.sheet_name(c, f))
		var day := c.day + 10 + 7 * s   # the bout's dice are the fight day's: sixty different nights
		while not Region.is_show_day(day):
			day += 1
		if not AskFlow.book(c, f, "sheet", opp, day):
			continue
		c.day = day
		# The coach's plan for the night: the starter plan plus a way off the ropes (no plan = nothing for the other corner to see).
		var plan: Array = load("res://scripts/rules/PlanFight.gd").starter()
		if plan.filter(func(a): return str(a["move"]) == "pivot_out").is_empty():
			plan.append({"move": "pivot_out"})
		f["arrows"] = plan   # the bout takes its copy at the first bell (LiveRound)
		# A boxer some months in: her plan's lines drilled to Sharp (a day-one boxer's lines are under Usable and never fire).
		var steps: Dictionary = f.get_or_add("steps", {})
		var combos: Dictionary = f.get_or_add("combos", {})
		for a in plan:
			var mid := str(a["move"]).split("@")[0]
			steps[mid] = 70.0
			combos[mid] = 70.0
		var m := Bouts.fight_modal(f)
		Bouts.fight_step(c, f, m, "sim")
		bouts += 1
		for r in m.get("rounds", []):
			for x in r.get("exchanges", []):
				diag["ex"] = int(diag.get("ex", 0)) + 1
				if VisitWire.CardAsk.under_pressure(x):
					diag["press"] = int(diag.get("press", 0)) + 1
					var k := "p_%s_%s_%s_%s" % [str(x.get("at")), str(x.get("want", "?")), str(x.get("arrow")), str(x.get("planned"))]
					diag[k] = int(diag.get(k, 0)) + 1
		wins += 1 if bool(m.get("win", false)) else 0
		evid += 1 if bool((m.get("evidence", {}) as Dictionary).get("qualifies", false)) else 0
		if not c.applicant.is_empty():
			visits += 1
			if first.is_empty():
				first = {"c": c, "m": m, "opp": opp}
	print("  P4P_VISIT real bouts=%d wins=%d with_evidence=%d visits=%d diag=%s" % [bouts, wins, evid, visits, str(diag)])
	_check(bouts >= 40 and evid >= 1 and evid < bouts, "real bouts record evidence on some nights and not on all (%d of %d)" % [evid, bouts])
	_check(visits <= evid and visits * 2 < bouts, "the visit stays the rarer thing: %d visits in %d bouts" % [visits, bouts])
	if not first.is_empty():
		var c1: Career = first["c"]
		_check(str(c1.applicant["rival"]) == str(first["opp"]) and str(first["m"].get("card_ask", "")) != "" and bool(first["m"]["win"])
			and int(c1.applicant["l"]) == int(c1.rival(str(first["opp"]))["l"]), "a real won bout brought the opponent to reception, loss on the record")
