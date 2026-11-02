extends RefCounted
## S356 CORE3 step 4, the fight plan's Test it (Game Godot/research/CORE3_DESIGN_S354.md s3; Kalli: "a range, 3 tests a camp,
## film study narrows it"): the plan on the board fights SIMS quick bouts against her booked opponent in today's form, through
## fight night's own rounds (BoutNight.play_out on a scratch career - nothing is booked), and says how often it wins and
## WHERE it breaks: the round it loses most and her tank by then, stoppages, the arrow that works least.
## The wins show as a range, not a number: SPREAD_UNSEEN either side with nothing found on tape, SPREAD_SEEN with her whole
## file open (OppFile.found), and the true count sits somewhere inside it (a fixed offset per bout), so the test reads the
## plan without giving the fight away. Every test of a camp rolls the same dice, so a change in the range is the plan's.
##   run(c, f, arrows) -> {ok, why | wins, sims, lo, hi, rounds [won, fought], breaks: [lines], left}   left(f) -> tests left this camp
## State: f["bout"]["plan_tests"] (tests used), f["bout"]["plan_test"] (the last result, shown on the board).

const BoutNight := preload("res://scripts/state/BoutNight.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const SIMS := 20
const TESTS_A_CAMP := 3
const SPREAD_UNSEEN := 4
const SPREAD_SEEN := 1
## The dice: bout k of a test fights on day DICE_DAY + k * 7 of a scratch career, far from any real fight night's dice.
const DICE_DAY := 50000
## A round counts as where the plan breaks when she loses it this share of the bouts that reach it.
const BREAK_SHARE := 0.4
## An arrow is named as the weak one when it was thrown this often across the 20 bouts.
const WEAK_ARROW_USES := 6


static func left(f: Dictionary) -> int:
	return maxi(0, TESTS_A_CAMP - int((f.get("bout", {}) as Dictionary).get("plan_tests", 0)))


static func run(c: Career, f: Dictionary, arrows: Array) -> Dictionary:
	var bout: Dictionary = f.get("bout", {})
	if bout.is_empty() or bool(bout.get("done", false)):
		return {"ok": false, "why": "Book a bout first: the test fights her next opponent."}
	if left(f) == 0:
		return {"ok": false, "why": "No tests left this camp (%d a camp)." % TESTS_A_CAMP}
	var opp: Dictionary = bout["opp"]
	var wins := 0
	var lost := {}       # round n -> [lost, reached, her energy at the bell summed over the lost ones]
	var stopped := 0
	var moves := {}      # arrow id -> [worked, used]
	var rounds := [0, 0] # rounds won, rounds fought
	for k in SIMS:
		var sc := Career.new()
		sc.day = DICE_DAY + k * 7
		sc.coach = c.coach.duplicate(true)
		sc.seed = c.seed
		var sf: Dictionary = f.duplicate(true)
		sf["arrows"] = arrows.duplicate(true)
		sf["bout"]["film"] = OppFile.film_depth(sf["bout"]["opp"])
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
	var spread := _spread(opp)
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(str(opp.get("name", ""))) + c.seed + int(bout.get("day", 0))
	var lo := clampi(wins - rng.randi_range(0, 2 * spread), 0, maxi(0, SIMS - 2 * spread))
	var res := {"ok": true, "wins": wins, "sims": SIMS, "lo": lo, "hi": mini(SIMS, lo + 2 * spread), "rounds": rounds,
		"breaks": _breaks(str(f["first"]), lost, stopped, moves)}
	bout["plan_tests"] = int(bout.get("plan_tests", 0)) + 1
	res["left"] = left(f)
	bout["plan_test"] = res
	return res


## The range's half-width: wide on a stranger, narrow once tape study has opened her file.
static func _spread(opp: Dictionary) -> int:
	var all := OppFile.tells(opp).filter(func(t): return str(t["how"]) != "booking").size()
	var share := 1.0 if all == 0 else float(OppFile.found(opp).size()) / float(all)
	return roundi(lerpf(SPREAD_UNSEEN, SPREAD_SEEN, share))


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
