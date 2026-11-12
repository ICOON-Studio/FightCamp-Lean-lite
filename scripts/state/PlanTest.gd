extends RefCounted
## S356 CORE3 step 4, the fight plan's Test it (Game Godot/research/CORE3_DESIGN_S354.md s3; Kalli: "a range, 3 tests a camp,
## film study narrows it"): the plan on the board fights SIMS quick bouts against her booked opponent in today's form, through
## fight night's own rounds (BoutNight.play_out on a scratch career - nothing is booked), and says how often it wins and
## WHERE it breaks: the round it loses most and her tank by then, stoppages, the arrow that works least.
## The wins show as a range, not a number: SPREAD_UNSEEN either side with nothing found on tape, SPREAD_SEEN with her whole
## file open (OppFile.found), and the true count sits somewhere inside it (a fixed offset per bout), so the test reads the
## plan without giving the fight away. Every test of a camp rolls the same dice, so a change in the range is the plan's.
## S382 G3 (gym idea 4): the tests ARE the camp's sparring nights (SparNights) - a test takes the next one still to come,
## no flat 3 a camp; fight week has none. Who she spars sets the range: club mates +-SPREAD_UNSEEN, the outside partner who
## matches the opponent (camp.partner, BoutRules.partner_matches) +-SPREAD_PARTNER; film still narrows it to +-SPREAD_SEEN.
##   run(c, f, arrows) -> {ok, why | wins, sims, lo, hi, rounds [won, fought], breaks: [lines], left, night}
##   left(f, today) -> tests left this camp   next_night(f, today) -> day of the next free spar night (-1 none)
##   button(f, today) -> "Test it - Thu spar night (2 left)"
## State: f["bout"]["plan_test_nights"] (the spar nights used), plan_tests (count), plan_test (the last result, on the board).

const BoutNight := preload("res://scripts/state/BoutNight.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const SparNights := preload("res://scripts/rules/SparNights.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

const SIMS := 20
## The range's half-width: sparring club mates, sparring the partner who matches her, her file open on tape.
const SPREAD_UNSEEN := 4
const SPREAD_PARTNER := 2
const SPREAD_SEEN := 1
const NONE_LEFT := "No sparring night left before fight night."
## The dice: bout k of a test fights on day DICE_DAY + k * 7 of a scratch career, far from any real fight night's dice.
const DICE_DAY := 50000
## A round counts as where the plan breaks when she loses it this share of the bouts that reach it.
const BREAK_SHARE := 0.4
## An arrow is named as the weak one when it was thrown this often across the 20 bouts.
const WEAK_ARROW_USES := 6


## The spar nights still free for a test, from today to fight night (this week as the sim runs it, f["phase"] + her edits).
static func nights_free(f: Dictionary, today: int) -> Array:
	var bout: Dictionary = f.get("bout", {})
	var e: Dictionary = WeekPhase.edits(f)
	var all := SparNights.nights(bout, today, str(f.get("phase", "")), int(e.get("spar", -1)))
	return SparNights.unused(all, bout.get("plan_test_nights", []))


static func left(f: Dictionary, today: int) -> int:
	return nights_free(f, today).size()


static func next_night(f: Dictionary, today: int) -> int:
	var n := nights_free(f, today)
	return -1 if n.is_empty() else int(n[0])


static func button(f: Dictionary, today: int) -> String:
	var n := next_night(f, today)
	if n < 0:
		return "Test it - no spar night left"
	return "Test it - %s spar night (%d left)" % [Clock.DAYS[posmod(n, 7)], left(f, today)]


static func run(c: Career, f: Dictionary, arrows: Array) -> Dictionary:
	var bout: Dictionary = f.get("bout", {})
	if bout.is_empty() or bool(bout.get("done", false)):
		return {"ok": false, "why": "Book a bout first: the test fights the next opponent."}
	var night := next_night(f, c.day)
	if night < 0:
		return {"ok": false, "why": "No sparring night left before fight night: a test is a spar night."}
	var opp: Dictionary = bout["opp"]
	var wins := 0
	var lost := {}       # round n -> [lost, reached, her energy at the bell summed over the lost ones]
	var stopped := 0
	var moves := {}      # arrow id -> [worked, used]
	var rounds := [0, 0] # rounds won, rounds fought
	# S380: a test mid-camp fights with fight night's Tank (the forecast after the taper), not today's fatigue; S433 NOCAMP1:
	# camp or not (the scratch careers have no results, so the forecast's number - with her last bout - rides on the bout)
	var camp: Dictionary = f.get("camp", {})
	var tank_fc := CampForecast.run(c, f, str(camp.get("focus", "")), int(camp.get("protocol", 0)), bool(camp.get("film", false)))
	for k in SIMS:
		var sc := Career.new()
		sc.day = DICE_DAY + k * 7
		sc.coach = c.coach.duplicate(true)
		sc.seed = c.seed
		var sf: Dictionary = f.duplicate(true)
		sf["arrows"] = arrows.duplicate(true)
		sf["bout"]["film"] = OppFile.film_depth(sf["bout"]["opp"])
		sf["bout"]["stale"] = float(tank_fc["stale"])
		sf["bout"]["tank_why"] = str(tank_fc["tank_why"])   # S434 the result line names what cost it (the last bout too)
		sc.fighters = [sf]
		var m := BoutNight.fight_modal(sf)
		BoutNight.play_out(sc, sf, m)
		var outcome := BoutNight.outcome_of(sf, m)
		wins += int(outcome == "win")
		if BoutNight.stopped(m) != "" and outcome == "loss":
			stopped += 1
		for r in m["rounds"]:
			var n := int(r["n"])
			rounds = [int(rounds[0]) + int(bool(r["won"])), int(rounds[1]) + 1]
			var row: Array = lost.get(n, [0, 0, 0.0])
			row[1] = int(row[1]) + 1
			if not bool(r["won"]):
				row[0] = int(row[0]) + 1
				row[2] = float(row[2]) + float((r.get("energy", {}) as Dictionary).get("a_end", Combos.TANK))
			lost[n] = row
			var per: Dictionary = (r.get("arrows", {}) as Dictionary).get("moves", {})
			for id in per:
				var t: Array = moves.get(id, [0, 0])
				moves[id] = [int(t[0]) + int(per[id][0]), int(t[1]) + int(per[id][1])]
	var spread := _spread(opp, f.get("camp", {}))
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(str(opp.get("name", ""))) + c.seed + int(bout.get("day", 0))
	var lo := clampi(wins - rng.randi_range(0, 2 * spread), 0, maxi(0, SIMS - 2 * spread))
	var res := {"ok": true, "wins": wins, "sims": SIMS, "lo": lo, "hi": mini(SIMS, lo + 2 * spread), "rounds": rounds,
		"breaks": _breaks(str(f["first"]), lost, stopped, moves)}
	bout["plan_tests"] = int(bout.get("plan_tests", 0)) + 1
	var used: Array = bout.get("plan_test_nights", [])
	used.append(night)
	bout["plan_test_nights"] = used
	res["night"] = night
	res["left"] = left(f, c.day)
	bout["plan_test"] = res
	return res


## The range's half-width: wide sparring club mates, half that sparring the partner who matches her, narrow once tape
## study has opened her file.
static func _spread(opp: Dictionary, camp: Dictionary = {}) -> int:
	var base := SPREAD_PARTNER if bool(camp.get("partner", false)) and BoutRules.partner_matches(opp) else SPREAD_UNSEEN
	var all := OppFile.tells(opp).filter(func(t): return str(t["how"]) != "booking").size()
	var share := 1.0 if all == 0 else float(OppFile.found(opp).size()) / float(all)
	return roundi(lerpf(base, SPREAD_SEEN, share))


static func _breaks(first: String, lost: Dictionary, stopped: int, moves: Dictionary) -> Array:
	var out: Array = []
	var worst := -1
	for n in lost:
		var row: Array = lost[n]
		if float(row[0]) >= BREAK_SHARE * float(row[1]) and (worst < 0 or float(row[0]) / float(row[1]) > float(lost[worst][0]) / float(lost[worst][1])):
			worst = int(n)
	if worst > 0:
		var row: Array = lost[worst]
		var tank := float(row[2]) / float(row[0])
		out.append("Breaks in round %d: lost it in %d of %d%s." % [worst, int(row[0]), int(row[1]),
			" - %s is down to %d energy by the bell" % [first, roundi(tank)] if tank < Combos.FRESH_AT else ""])
	if stopped > 0:
		out.append("Stopped in %d of %d." % [stopped, SIMS])
	var weak := ""
	for id in moves:
		var t: Array = moves[id]
		if int(t[1]) >= WEAK_ARROW_USES and (weak == "" or float(t[0]) / float(t[1]) < float(moves[weak][0]) / float(moves[weak][1])):
			weak = str(id)
	if weak != "":
		out.append("Weakest arrow: %s worked %d of %d times." % [str(StrikeMap.move(weak).get("name", weak)), int(moves[weak][0]), int(moves[weak][1])])
	if out.is_empty():
		out.append("No round goes wrong often: the plan holds.")
	return out
