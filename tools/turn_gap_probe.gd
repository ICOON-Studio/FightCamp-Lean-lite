extends SceneTree
## TURNPRO6 (S533, replaces TURNGAP1's probe): the pro debut's win share against the opponent gap, house by house.
## WHY IT WAS REBUILT: TURNGAP1's "20 boxers x 10 seeds" was ONE boxer on THREE nights. Career.quick_start signs the same
## walk-in whatever the seed (the seed only moves injuries), and its 10 "seeds" moved the signing day by 0..9 days, which
## lands on three Saturdays (1 / 7 / 2 seeds); a bout's dice are the fight day's (LiveRound._rng), so 7 of 10 "seeds"
## were the same bout.
## POPULATION (printed with every run): the six people the game can sign (Data.lucy + Data.PROSPECTS: four women, two men,
## five styles, both stances) x two sets of training picks, each played from signing to the first pro offer. Each boxer
## then signs EACH house's plain deal through Roster.turn_pro and is played by the game's own days to the morning of
## fight night (camp started when due, weighed in). CONTROL ARM: from that one fight-night boxer only the opponent's
## rating moves (night - gap, DebutOpp, as turn_pro sets it), and every gap is fought on the same independent nights:
## PlanTest's scratch career, bout k on day DICE_DAY + k * 7 (BoutNight.play_out, nothing booked) - the game's own way
## to roll a bout again. The scratch bout on the real day's dice is checked against the real booked bout (same_dice).
## Beside each share: the chance the offer shows at signing (DebutRead.card) and the amateur read (BoutRead.chance).
## DEBUTPICK1 (S533) pick=1: two arms a house on the same fight-night boxer and the same nights - "fixed" = the house's
## old one gap for everybody (ProCall.promoters: the control arm, it reads the old spread) and "picked" = the gap
## DebutPick finds for THIS boxer at the offer (what ProOfferWire.make now books). docs/DEBUTPICK1_RESULT.md.
## Args (after --): pick=1 nights=250 boxers=12 first=0 gaps=-2,0,2 out=<jsonl path>. Prints JSON lines; docs/TURNPRO6_RESULT.md is written from them.

const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const DebutPick := preload("res://scripts/rules/DebutPick.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var GAPS: Array = [-4.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]   ## gaps=3,5,6 on the command line reads other points of the curve
const PICK_SETS := [["Jab and move", "Pad rounds", "Hill sprints"], ["Body work", "Defence drills", "Film study"]]
const HOUSES := ["bow", "hf"]
const DICE_DAY := 50000   ## PlanTest.DICE_DAY: far from any real fight night's dice
const MAX_WEEKS := 156
var out_lines: Array = []
var seen := {}
var pick_mode := false
var t0 := 0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func _say(tag: String, d: Dictionary) -> void:
	d["tag"] = tag
	d["t"] = snappedf((Time.get_ticks_msec() - t0) / 1000.0, 0.1)
	var s := JSON.stringify(d)
	out_lines.append(s)
	print(s)


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var nights := int(_arg("nights", "250"))
	var n_boxers := int(_arg("boxers", "12"))
	var first := int(_arg("first", "0"))
	pick_mode = _arg("pick", "0") == "1"
	if _arg("gaps", "") != "":
		GAPS = Array(_arg("gaps", "").split(",")).map(func(s): return float(s))
	var people: Array = [Data.lucy()] + Data.PROSPECTS
	_say("run", {"nights": nights, "gaps": GAPS, "pick": pick_mode, "houses": HOUSES, "dice": "day %d + k * 7, k < nights" % DICE_DAY,
		"people": people.map(func(p): return "%s (%s, %s, %s)" % [p["name"], p["style"], p["stance"], p["div"]]), "picks": PICK_SETS})
	for bi in range(first, mini(first + n_boxers, people.size() * PICK_SETS.size())):
		var who: Dictionary = people[bi % people.size()]
		var picks: Array = PICK_SETS[int(bi / people.size())]
		var snap := _build_pro_ready(who, picks, 7000 + bi * 137)
		if snap.is_empty():
			_say("noready", {"b": bi, "who": str(who["name"]), "picks": picks})
			continue
		var sc: Career = snap["career"]
		var sf: Dictionary = sc.fighter_by_id(str(snap["fighter_id"]))
		var stamp := "%s|%d|%s" % [str(sf["name"]), int(snap["day"]), str(sf["stats"])]
		if seen.has(stamp):
			_say("same", {"b": bi, "who": str(sf["name"]), "as": seen[stamp], "why": "the picks changed nothing before the offer: the same boxer, not counted twice"})
			continue
		seen[stamp] = bi
		_say("boxer", {"b": bi, "who": str(sf["name"]), "style": str(sf.get("style", "")), "stance": str(sf.get("stance", "")), "div": str(sf["div"]),
			"picks": picks, "offer_day": int(snap["day"]), "w": int(sf["w"]), "l": int(sf["l"]), "night": DebutOpp.night(sf["stats"]),
			"called": ((snap["offer"] as Dictionary).get("offers", []) as Array).map(func(t): return str(t["key"]))})
		for house in HOUSES:
			_house(bi, snap, str(house), nights)
	var path := _arg("out", "")
	if path != "":
		var fh := FileAccess.open(path, FileAccess.WRITE)
		if fh != null:
			fh.store_string("\n".join(out_lines) + "\n"); fh.close()
	print("TURNPRO6 probe done %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _house(bi: int, snap: Dictionary, house: String, nights: int) -> void:
	var sc: Career = snap["career"]
	var sf: Dictionary = sc.fighter_by_id(str(snap["fighter_id"]))
	var coach := float(sc.coach.get("rating", 0.0))
	var terms: Dictionary = ProCall.terms(house, 0, false)
	# DEBUTPICK1: the two arms - the house's fixed gap (control) and the gap picked for this boxer on the offer day
	var gaps: Array = GAPS
	var picked := {}
	if pick_mode:
		picked = DebutPick.pick(sf, terms, sc.day, coach)
		gaps = [float(terms["opp_gap"]), float(picked["gap"])]
	# what the offer shows at signing, gap by gap
	var signing := {}
	for g in gaps:
		var t2: Dictionary = terms.merged({"opp_gap": g}, true)
		var card := DebutRead.card(sf, t2, sc.day, coach)
		var fx0: Dictionary = sf.duplicate()
		fx0["pro"] = true
		fx0["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": DebutRead.ROUNDS}
		var raw0 := BoutRead.CardOdds.card(BoutRead.round_edges(fx0, card["opp"], {"protocol": BoutRead.USUAL_CAMP}, coach), BoutRead.RingDuel.FORM_SD)
		signing[g] = [float(card["win"]), float(card["draw"]), float(raw0["win"]), float(raw0["draw"])]
	var fd := _to_fight_day(snap, house, float(gaps[1]) if pick_mode else float(terms["opp_gap"]))
	if fd.is_empty():
		_say("house", {"b": bi, "house": house, "none": true})
		return
	var c: Career = fd["c"]
	var f: Dictionary = fd["f"]
	var six := 0.0
	for k in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		six += float(f["stats"].get(k, 55.0)) / 6.0
	var tp := BoutRules.tank_parts_for(c.results, f, float(f.get("week_fatigue", 20.0)), int(f["bout"].get("day", c.day)))
	# the control arm plays the game's bout: the scratch bout on the real day's dice against the booked one
	var scratch := _one(c, f, c.day, {}, float(tp["off"]))
	var c2: Career = c.duplicate(true)
	var f2: Dictionary = c2.fighter_by_id(str(f["id"]))
	Bouts.fight_step(c2, f2, Bouts.fight_modal(f2), "sim")
	_say("house", {"b": bi, "house": house, "weeks": int(terms["debut_weeks"]), "deal_gap": float(gaps[1]) if pick_mode else float(terms["opp_gap"]), "pick": picked, "fight_day": c.day,
		"night_signing": float(fd["night0"]), "six_signing": float(fd["night0"]) - BoutRules.NO_CAMP_EDGE, "six_fight": six,
		"camp": int((f.get("camp", {}) as Dictionary).get("protocol", -1)), "tank_off": float(tp["off"]), "opp": str(f["bout"]["opp"]["name"]),
		"same_dice": [scratch.get_slice(":", 0), str((c2.results[0] as Dictionary).get("outcome", "?"))]})
	for gi in gaps.size():
		var g: float = gaps[gi]
		var opp2: Dictionary = (f["bout"]["opp"] as Dictionary).duplicate(true)
		opp2["rating"] = snappedf(float(fd["night0"]) - float(g), 0.1)
		var res := _nights(c, f, nights, opp2, float(tp["off"]))
		var fx: Dictionary = f.duplicate(true)
		fx["bout"]["opp"] = opp2
		var edges: Array = BoutRead.round_edges(fx, opp2, fx.get("camp", {}), coach)
		var raw := BoutRead.CardOdds.card(edges, BoutRead.RingDuel.FORM_SD)
		var fit := BoutRead.CardOdds.result(edges, BoutRead.RingDuel.FORM_SD)
		var f3: Dictionary = fx.duplicate(true)
		f3["bout"].erase("rounds")   # the amateur card's read of the same night (2 rounds of 3), for the comparison
		if pick_mode:
			res["arm"] = "fixed" if gi == 0 else "picked"
			res["target"] = float(picked["target"])
		res.merge({"b": bi, "house": house, "g": g, "opp_rating": float(opp2["rating"]), "offer_win": signing[g][0], "offer_draw": signing[g][1],
			"offer_raw_win": signing[g][2], "offer_raw_draw": signing[g][3], "night_win": float(fit["win"]), "night_draw": float(fit["draw"]),
			"night_raw_win": float(raw["win"]), "night_raw_draw": float(raw["draw"]), "edges": edges,
			"amateur_read": BoutRead.chance(f3, opp2, f3.get("camp", {}), coach)})
		_say("gap", res)


func _one(c: Career, f: Dictionary, day: int, opp2: Dictionary, tank_off: float) -> String:
	var sc := Career.new()
	sc.day = day
	sc.coach = c.coach.duplicate(true)
	sc.seed = c.seed
	var sf: Dictionary = f.duplicate(true)
	if not opp2.is_empty():
		sf["bout"]["opp"] = opp2.duplicate(true)
	sf["bout"]["stale"] = tank_off
	sf["bout"]["tank_why"] = ""
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, m)
	var rw := ""
	for r in m["rounds"]:
		rw += "1" if bool(r["won"]) else "0"
	return BoutNight.outcome_of(sf, m) + ":" + rw + ":" + BoutNight.stopped(m)


func _nights(c: Career, f: Dictionary, k_n: int, opp2: Dictionary, tank_off: float) -> Dictionary:
	var win := 0; var draw := 0; var loss := 0; var stop_w := 0; var stop_l := 0
	for k in k_n:
		var parts := _one(c, f, DICE_DAY + k * 7, opp2, tank_off).split(":")
		match parts[0]:
			"win": win += 1
			"draw": draw += 1
			_: loss += 1
		if parts[2] != "":
			if parts[0] == "win": stop_w += 1
			else: stop_l += 1
	return {"n": k_n, "win": win, "draw": draw, "loss": loss, "stop_w": stop_w, "stop_l": stop_l}


func _build_pro_ready(who: Dictionary, picks: Array, seed_n: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	c.applicant = who.duplicate(true)
	Sim.sign(c, picks.duplicate()); Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	f["ambition"] = "Turn pro as soon as the call comes"
	var guard := 0
	while c.day < MAX_WEEKS * 7 and not c.closed and guard < 5000:
		guard += 1
		if not c.pro_offer.is_empty():
			return {"career": c.duplicate(true), "fighter_id": str(f["id"]), "offer": c.pro_offer.duplicate(true), "day": c.day}
		_pre(c, f, true)
		Sim.step_day(c)
	return {}


## Signs this house's plain deal (its own weeks) on the offer day and plays to the morning of fight night (weighed, not fought).
func _to_fight_day(snap: Dictionary, house: String, gap: float) -> Dictionary:
	var c: Career = (snap["career"] as Career).duplicate(true)
	var f: Dictionary = c.fighter_by_id(str(snap["fighter_id"]))
	c.pro_offer = (snap["offer"] as Dictionary).duplicate(true)
	c.pro_offer["offers"] = [ProCall.terms(house, 0, false).merged({"opp_gap": gap}, true)]
	var night0 := DebutOpp.night(f["stats"])
	Roster.turn_pro(c, house)
	var guard := 0
	while guard < 200 and not c.closed:
		guard += 1
		_pre(c, f, false)
		if (f["bout"] as Dictionary).is_empty():
			return {}
		if Bouts.fight_day(c, f):
			return {"c": c, "f": f, "night0": night0}
		Sim.step_day(c)
	return {}


## A day's answers before the clock moves: take the offered bouts, start the camp when due, weigh in, fight (amateur road).
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
