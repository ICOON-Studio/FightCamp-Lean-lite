extends SceneTree
## TURNPRO6 (S533) the pro debut: one opponent rule, a read that walks the card the bout is fought on, and the offer's shown
## chance against PLAYED bouts. RED on main: BoutRead walked 3 rounds for the 4-round debut, never charged the corner
## call's energy and skipped Second wind, so a boxer who empties the tank (Tess, "Go to the body" every round) read 46 %
## where her bouts won 28 %; and the offer showed no chance at all (DebutRead did not exist).
## Population: Lucy Jackson (out-boxer, orthodox, Second wind) and Tess Reilly (pressure fighter, southpaw, the body call),
## each played from signing to the first pro offer, signed with Bow Lane through Roster.turn_pro and played by the game's
## days to fight night; then NIGHTS bouts a gap on PlanTest's scratch dice (day 50000 + k * 7), the opponent's rating alone
## moving (gaps -2, 0, +2). Bounds, never exact counts: the read within BAND of the played win share.

const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CardOdds := preload("res://scripts/rules/CardOdds.gd")
const Data := preload("res://scripts/state/Data.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const NIGHTS := 300
const DICE_DAY := 50000
const BAND := 0.05          ## the brief's bound: the read within 5 points of the played share
const OFFER_LOW := 0.10     ## the offer reads the boxer as today (weeks of training still to come): it may err LOW by this much
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
var failures := 0


func _initialize() -> void:
	_opp_rule()
	_card_shape()
	_words()
	_read_against_bouts(Data.lucy(), "Lucy")
	_read_against_bouts(Data.PROSPECTS[2], "Tess")
	_house_gaps()
	print("DEBUT_READ failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS %s" % label)
	else:
		failures += 1
		print("FAIL %s" % label)


func _opp_rule() -> void:
	var stats := {"power": 60.0, "speed": 62.0, "technique": 64.0, "defense": 58.0, "conditioning": 66.0, "fight_iq": 62.0, "chin": 70.0}
	var night := BoutRules.fight_power(stats, {}, 0, "", true)
	_check(is_equal_approx(DebutOpp.rating(stats, 1.0), snappedf(night - 1.0, 0.1)), "a gap of 1 is an opponent rated 1 under the boxer's no-camp strength")
	_check(DebutOpp.rating(stats, -1.0) > DebutOpp.rating(stats, 1.0), "a gap below 0 is a stronger debutant")
	var woman := {"sex": "f", "div": "wlw", "stats": stats}
	var man := {"sex": "m", "div": "mlw", "stats": stats}
	var ok := true
	for day in 8:
		ok = ok and DebutOpp.NAMES_F.has(DebutOpp.name_for(woman, day)) and DebutOpp.NAMES_M.has(DebutOpp.name_for(man, day))
	_check(ok, "a woman debuts against a woman, a man against a man")
	_check(str(DebutOpp.make(man, 0.0, 3, "Bow Lane Promotions")["sex"]) == "m", "the opponent carries the boxer's sex")
	_check(DebutOpp.name_for(woman, 3, "Bow Lane Promotions") != DebutOpp.name_for(woman, 3, "Harrow & Finch Boxing"), "two houses on one day put up two different debutants (S534 owner C442)")


func _card_shape() -> void:
	var even := CardOdds.card([0.0, 0.0, 0.0, 0.0], 5.0)
	_check(absf(float(even["win"]) + float(even["draw"]) + float(even["loss"]) - 1.0) < 0.0001, "a card's chances sum to 1")
	_check(absf(float(even["win"]) - float(even["loss"])) < 0.0001 and float(even["draw"]) > 0.15, "an even 4-round card: win = loss, and level cards are a real share")
	_check(float(CardOdds.card([0.0, 0.0, 0.0], 5.0)["draw"]) < 0.0001, "a 3-round card has no draw")
	var better := CardOdds.card([4.0, 4.0, 4.0, 4.0], 5.0)
	_check(float(better["win"]) > float(even["win"]) + 0.05, "a better boxer wins the card more often")
	var res := CardOdds.result([0.0, 0.0, 0.0, 0.0], 5.0)
	_check(float(res["win"]) >= float(even["win"]) and float(res["draw"]) <= float(even["draw"])
		and absf(float(res["win"]) + float(res["draw"]) + float(res["loss"]) - 1.0) < 0.0001, "stoppages move level cards to a win, and the three still sum to 1")
	_check(float(CardOdds.result([-40.0, -40.0, -40.0, -40.0], 5.0)["win"]) >= 0.01 and float(CardOdds.result([40.0, 40.0, 40.0, 40.0], 5.0)["win"]) <= 0.99, "never certain either way")


func _words() -> void:
	_check(DebutRead.words({"opp_gap": 1.0}) == "a debutant rated 1.0 under", "a positive gap reads 'under'")
	_check(DebutRead.words({"opp_gap": -1.5}) == "a debutant rated 1.5 over", "a negative gap reads 'over', never a minus sign")
	_check(DebutRead.words({"opp_gap": 0.0}) == "a debutant rated level", "no gap reads 'level'")


## The read against played bouts: the offer's read at signing, and the booked bout's read on fight night, gap by gap.
func _read_against_bouts(who: Dictionary, label: String) -> void:
	var snap := _build_pro_ready(who)
	_check(not snap.is_empty(), "%s reaches a pro offer" % label)
	if snap.is_empty():
		return
	var sc: Career = snap["career"]
	var sf: Dictionary = sc.fighter_by_id(str(snap["fighter_id"]))
	var coach := float(sc.coach.get("rating", 0.0))
	var terms: Dictionary = ProCall.terms("bow", 0, false)
	var offer := {}
	for g in [-2.0, 0.0, 2.0]:
		offer[g] = float(DebutRead.card(sf, terms.merged({"opp_gap": g}, true), sc.day, coach)["win"])
	_check(float(offer[-2.0]) < float(offer[0.0]) and float(offer[0.0]) < float(offer[2.0]), "%s: the offer's chance rises with the gap (%.3f / %.3f / %.3f)" % [label, offer[-2.0], offer[0.0], offer[2.0]])
	var night0 := DebutOpp.night(sf["stats"])
	var signed_on := sc.day
	var fd := _to_fight_day(snap, float(terms["opp_gap"]))
	_check(not fd.is_empty(), "%s makes fight night" % label)
	if fd.is_empty():
		return
	var c: Career = fd["c"]
	var f: Dictionary = fd["f"]
	var booked: Dictionary = f["bout"]["opp"]
	_check(is_equal_approx(float(booked["rating"]), DebutOpp.rating(sf["stats"], float(terms["opp_gap"]))) and str(booked["name"]) == DebutOpp.name_for(sf, signed_on, str(booked["club"]).trim_suffix(" stable")),
		"%s: turn_pro books the opponent the offer read (DebutOpp)" % label)
	_check(BoutRead.round_edges(f, booked, f.get("camp", {}), coach).size() == 4, "%s: the read walks the debut's 4 rounds" % label)
	var tank := float(BoutRules.tank_parts_for(c.results, f, float(f.get("week_fatigue", 20.0)), int(f["bout"].get("day", c.day)))["off"])
	for g in [-2.0, 0.0, 2.0]:
		var opp: Dictionary = booked.duplicate(true)
		opp["rating"] = snappedf(night0 - float(g), 0.1)
		var wins := 0
		for k in NIGHTS:
			wins += int(_one(c, f, DICE_DAY + k * 7, opp, tank) == "win")
		var share := float(wins) / float(NIGHTS)
		var fx: Dictionary = f.duplicate(true)
		fx["bout"]["opp"] = opp
		var night_read := BoutRead.chance(fx, opp, fx.get("camp", {}), coach)
		_check(absf(night_read - share) <= BAND, "%s gap %+.0f: the booked bout's read %.3f within %.2f of the played share %.3f (%d nights)" % [label, g, night_read, BAND, share, NIGHTS])
		_check(float(offer[g]) <= share + BAND and float(offer[g]) >= share - OFFER_LOW,
			"%s gap %+.0f: the offer's read %.3f no more than %.2f over and %.2f under the played share %.3f" % [label, g, float(offer[g]), BAND, OFFER_LOW, share])


## The two houses' gaps (ProCall.promoters, set from docs/TURNPRO6_RESULT.md): the guarantee house is the safer debut.
func _house_gaps() -> void:
	var rows: Dictionary = ProCall.promoters()
	_check(float(rows["hf"]["opp_gap"]) > float(rows["bow"]["opp_gap"]), "the guarantee house books the weaker debutant")
	var snap := _build_pro_ready(Data.lucy())
	var sc: Career = snap["career"]
	var sf: Dictionary = sc.fighter_by_id(str(snap["fighter_id"]))
	var bow := float(DebutRead.card(sf, ProCall.terms("bow", 0, false), sc.day, 58.0)["win"])
	var hf := float(DebutRead.card(sf, ProCall.terms("hf", 0, false), sc.day, 58.0)["win"])
	_check(hf > bow + 0.05, "the offer shows the guarantee house as the safer debut (%.3f against %.3f)" % [hf, bow])


func _one(c: Career, f: Dictionary, day: int, opp: Dictionary, tank_off: float) -> String:
	var sc := Career.new()
	sc.day = day
	sc.coach = c.coach.duplicate(true)
	sc.seed = c.seed
	var sf: Dictionary = f.duplicate(true)
	sf["bout"]["opp"] = opp.duplicate(true)
	sf["bout"]["stale"] = tank_off
	sf["bout"]["tank_why"] = ""
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, m)
	return BoutNight.outcome_of(sf, m)


func _build_pro_ready(who: Dictionary) -> Dictionary:
	var c := Career.quick_start()
	c.seed = 7000; c.first_hour = {}; FirstWeek.skip(c)
	c.applicant = who.duplicate(true)
	Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	f["ambition"] = "Turn pro as soon as the call comes"
	var guard := 0
	while c.day < 156 * 7 and not c.closed and guard < 5000:
		guard += 1
		if not c.pro_offer.is_empty():
			return {"career": c.duplicate(true), "fighter_id": str(f["id"]), "offer": c.pro_offer.duplicate(true), "day": c.day}
		_pre(c, f, true)
		Sim.step_day(c)
	return {}


func _to_fight_day(snap: Dictionary, gap: float) -> Dictionary:
	var c: Career = (snap["career"] as Career).duplicate(true)
	var f: Dictionary = c.fighter_by_id(str(snap["fighter_id"]))
	c.pro_offer = (snap["offer"] as Dictionary).duplicate(true)
	c.pro_offer["offers"] = [ProCall.terms("bow", 0, false).merged({"opp_gap": gap}, true)]
	Roster.turn_pro(c, "bow")
	var guard := 0
	while guard < 200 and not c.closed:
		guard += 1
		_pre(c, f, false)
		if (f["bout"] as Dictionary).is_empty():
			return {}
		if Bouts.fight_day(c, f):
			return {"c": c, "f": f}
		Sim.step_day(c)
	return {}


func _pre(c: Career, f: Dictionary, fight: bool) -> void:
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	for o2 in (f["offers"] as Array).duplicate():
		if not bool(o2["answered"]):
			Bouts.decline(c, str(o2["id"]))
	if Bouts.camp_due(c, f):
		Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if fight and Bouts.fight_day(c, f):
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
