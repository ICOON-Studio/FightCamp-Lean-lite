extends RefCounted
## S387 MENUBOUT (operator "Yes, build 1-3"; ops/research/MENU_CRITIC_S386.md item 2): a bout offer read as a decision. What
## the coach can estimate of the opponent from her file, and what that makes the fighter's chance, rank and mismatch.
## No odds model of its own: chance() walks the bout the sim fights. An exchange is Exchanges.settle's dice on the edge
## (ComboOdds.win_odds), the edge is LiveRound.open's base (ComboOdds.gap) plus the rest of LiveRound.exchange's mean terms,
## a round is the most of six exchanges, a bout the most of three rounds. tests/bout_read_test.gd holds it to real bouts
## (BoutNight.play_out). What it leaves out: her shouts and the corner minute, so a bout the player works can beat it.
## An opponent has one number, her rating; RoundStyle.from_opponent makes her stats from it, so that is what is hidden.
## HIDING (PlanTest's rule: the truth sits inside the range, at a place the range does not show): the range is nested stage
## by stage, each find cuts it from a dice-picked side, so the truth cannot be read off its middle or off how it moved.
## All seven stats share the one range: seven separate dice would close in on her rating by overlap. A hidden tell moves
## nothing: public() blanks its words, and every opponent gets the same room for what a hidden tell could be.
##   stage(opp) -> {found, all, share}   rating_range(opp, salt) -> [lo, hi]   stat_ranges(opp, salt) -> {stat: [lo, hi]}
##   true_stats(opp) -> {stat: value}    camp_for(f, days) -> camp   chance(f, opp, camp) -> 0..1
##   band(f, opp, camp, salt) -> {lo, hi}   mismatch(f, opp, camp, salt) -> power points
##   rank_of(rows, name) -> 1-based or 0   rank_move(rows, f, opp_name, order, min_wins) -> {now, win, loss, need}
## Pure static; salt = the career's seed, so the same opponent reads differently in another career.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PerkFight := preload("res://scripts/rules/PerkFight.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")

## The range's full width in rating points: nothing found, her whole file open (design values; the file never gives the
## exact number). The truth starts at least EDGE_KEEP of the width from either end.
const WIDE := 12.0
const NARROW := 3.0
const EDGE_KEEP := 0.2
## What a hidden tell can do to a stat (RoundStyle.from_opponent: -10 conditioning or defence, +8 speed; BoutNight._counts:
## -8 chin). Every opponent's range keeps this room until the tell is found.
const ROOM_WEAK := {"conditioning": 10.0, "defense": 10.0, "chin": 8.0}
const ROOM_WEAPON := {"speed": 8.0}
const CHIN_WEAK := 8.0
## While a tell is hidden the band's ends take the worst and the best of these, the same list for every opponent: each
## stands for one kind of words the sim reads (her tank, her third round, her games; the body shots on her fighter's tank).
const ANY_WEAK := ["", "Fades after round 2", "Heavy legs late", "Walks in straight"]
const ANY_WEAPON := ["", "Hooks", "Body hooks"]
## The band's allowance for what chance() leaves out, each side (tests/bout_read_test.gd measures chance() against real bouts).
const SLACK := 0.03
## With time for a camp the read assumes the club's usual one.
const USUAL_CAMP := 2
## Exchanges.next_mode's odds of "tiring": on an empty tank, and in a late fade.
const OPP_TIRED_ODDS := 0.75
const FADE_ODDS := 0.5
## Punches each side lands in an exchange on the mean (Exchanges.LANDED): what its body shots cost a tank.
const MEAN_LANDED := 3.5
## Share of a plan's edge that reaches the ring: she starts many exchanges where the last one left her, not on the card the
## game puts her on (measured: a four-arrow plan in real bouts against the same plan always on the game's own card).
const PLAN_REACH := 0.75
## Rounds of next_mode's dice behind one style's mix.
const MIX_ROUNDS := 300

static var _mixes := {}


## How far her file is open: tape tells found, of all she has.
static func stage(opp: Dictionary) -> Dictionary:
	var found := OppFile.found(opp).size()
	var all := found + OppFile.hidden(opp).size()
	return {"found": found, "all": all, "share": 1.0 if all == 0 else float(found) / float(all)}


static func _width(found: int, all: int) -> float:
	return NARROW if all <= 0 else lerpf(WIDE, NARROW, float(found) / float(all))


## The range around `truth` after `found` of `all` finds: each find cuts it to the next width, from a side the dice pick.
static func _nest(truth: float, found: int, all: int, salt: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = salt
	var keep := NARROW * EDGE_KEEP
	var lo := truth - WIDE * rng.randf_range(EDGE_KEEP, 1.0 - EDGE_KEEP)
	var hi := lo + WIDE
	for i in found:
		var cut := _width(i, all) - _width(i + 1, all)
		var off_lo := clampf(cut * rng.randf(), maxf(0.0, cut - (hi - truth - keep)), minf(cut, truth - lo - keep))
		lo += off_lo
		hi -= cut - off_lo
	return [lo, hi]


## Her rating as the file reads it.
static func rating_range(opp: Dictionary, salt: int) -> Array:
	var s := stage(opp)
	return _nest(float(opp.get("rating", 60.0)), int(s["found"]), int(s["all"]), hash(str(opp.get("name", ""))) + salt)


## Her seven stats as the sim fights them: RoundStyle's, with the chin BoutNight._counts takes off a chin weakness.
static func true_stats(opp: Dictionary) -> Dictionary:
	var st: Dictionary = RoundStyle.from_opponent(opp)["stats"]
	if str(opp.get("weak", "")).to_lower().contains("chin"):
		st["chin"] = float(st["chin"]) - CHIN_WEAK
	return st


## Her words as the file shows them: what is not found yet is blank.
static func public(opp: Dictionary) -> Dictionary:
	var v := opp.duplicate()
	if not OppFile.known(opp, "weapon"):
		v["threat"] = ""
	if not OppFile.known(opp, "weakness"):
		v["weak"] = ""
	return v


## {stat: [lo, hi]} for the seven stats: the rating range moved by what the file shows, plus the room for a hidden tell.
static func stat_ranges(opp: Dictionary, salt: int) -> Dictionary:
	var r := float(opp.get("rating", 60.0))
	var span := rating_range(opp, salt)
	var shown := true_stats(public(opp))
	var out := {}
	for k in shown:
		var off := float(shown[k]) - r
		var down := 0.0 if OppFile.known(opp, "weakness") else float(ROOM_WEAK.get(k, 0.0))
		var up := 0.0 if OppFile.known(opp, "weapon") else float(ROOM_WEAPON.get(k, 0.0))
		out[k] = [float(span[0]) + off - down, float(span[1]) + off + up]
	return out


## The camp the read assumes: hers, else the usual one with time for it, else none.
static func camp_for(f: Dictionary, days: int) -> Dictionary:
	var camp: Dictionary = f.get("camp", {})
	if not camp.is_empty():
		return camp
	return {"protocol": USUAL_CAMP} if days >= BoutRules.CAMP_MIN_DAYS else {}


## BoutNight._energy, read only, on the coach's calls: per round {edge (her combination edge and both tired penalties),
## a, a_end, b, b_end (the tanks at the first and last bell)}.
static func _energy(f: Dictionary, opp: Dictionary) -> Array:
	var op := RoundStyle.from_opponent(opp)
	var mine: Dictionary = OwnCombos.all_mastery(f)
	var cond_a := float((f["stats"] as Dictionary).get("conditioning", 55.0))
	var cond_b := RoundStyle.stat(op, "conditioning")
	var econ := SkillAwards.bout_economy(f, RoundStyle.SHARE)
	var a := Combos.TANK
	var b := Combos.TANK
	var qa := 0.0
	var qb := 0.0
	var out: Array = []
	for n in range(1, BoutRules.ROUNDS + 1):
		var ra := Combos.after_round(a, qa, Combos.round_spend(mine, _call(f, n), cond_a, econ), cond_a)
		var rb := Combos.after_round(b, qb, Combos.round_spend(op["combos"], "", cond_b), cond_b)
		var a_end := float(ra["bell"])
		var b_end := float(rb["bell"])
		out.append({"edge": Combos.edge(mine, a) + OwnCombos.ring_edge(f, a, (a + a_end) / 2.0) - Combos.tired_penalty(a_end) + Combos.tired_penalty(b_end),
			"a": a, "a_end": a_end, "b": b, "b_end": b_end})
		a = float(ra["next"])
		b = float(rb["next"])
		qa = float(ra["debt"])
		qb = float(rb["debt"])
	return out


## The corner's plan for round n when nobody works the corner (BoutNight._box_out): none in round 1, then her better tool.
static func _call(f: Dictionary, n: int) -> String:
	return "" if n == 1 else BoutRules.auto_corner(f["stats"])


## LiveRound.exchange's call, perk, plan and habit terms in one situation of round n, as a mean over the round's exchanges.
static func _game_edge(f: Dictionary, sit: String, n: int) -> float:
	var vals: Dictionary = (f["stats"] as Dictionary).duplicate()
	vals.merge(f.get("personality", {}) as Dictionary)
	vals["footwork"] = float(f.get("footwork", vals.get("speed", 55.0)))
	var coach := float((f.get("personality", {}) as Dictionary).get("coachability", 55.0))
	var heard := Exchanges.uptake(coach, 0) * FighterProfile.trust(f)
	var call := _call(f, n)
	var e := Exchanges.call_edge(call, sit, vals, heard)
	if float(vals.get("fight_iq", 55.0)) >= Exchanges.IQ_FINDS:   # she finds the answer herself when the game carries on
		e = lerpf(e, Exchanges.call_edge(call, sit, vals, heard, true), Exchanges.KEEP)
	e = PerkFight.call_edge(f, e) + PerkFight.jab_edge(f, sit)
	var at := str(PlanFight.GAME_CARD.get(sit, "long"))
	var moves: Dictionary = f.get("moves", {})
	var combos: Dictionary = f.get("combos", {})
	var pick := PlanFight.choose(f.get("arrows", []), at, moves, sit)
	e += PLAN_REACH * PlanFight.edge(pick, sit, PlanFight.rate(str(pick["move"]), combos), PlanFight.card_mean(at, sit, moves, combos))
	var habits := 0.0
	for i in Exchanges.EXCHANGES:
		habits += HabitFix.cost(HabitFix.punished(f.get("habits", []), sit, n, i, n == BoutRules.ROUNDS), "", 0.0)
	return e + habits / float(Exchanges.EXCHANGES)


## The games her style really plays, Exchanges.next_mode's own dice run on (MAX_RUN makes them flatter than STYLE_MODES).
static func _games(opp: Dictionary) -> Dictionary:
	var style := str(opp.get("style", ""))
	var weak := "walks in" if str(opp.get("weak", "")).to_lower().contains("walks in") else ""   # the one word next_mode reads here
	var key := style + "|" + weak
	if _mixes.has(key):
		return _mixes[key]
	var rng := RandomNumberGenerator.new()
	rng.seed = 387
	var tally := {}
	for _round in MIX_ROUNDS:
		var mode := ""
		var run := 0
		for i in Exchanges.EXCHANGES:
			var next := Exchanges.next_mode(style, weak, 2, i, mode, Combos.TANK, false, rng, run)
			run = run + 1 if next == mode else 1
			mode = next
			tally[mode] = float(tally.get(mode, 0.0)) + 1.0 / float(MIX_ROUNDS * Exchanges.EXCHANGES)
	_mixes[key] = tally
	return tally


## Share of her game given to "tiring" in an exchange of round n (Exchanges.next_mode): an empty tank, a late fade.
static func _tiring(opp: Dictionary, n: int, energy: float) -> float:
	var t := OPP_TIRED_ODDS if energy < Exchanges.OPP_TIRED else 0.0
	if str(opp.get("weak", "")).to_lower().contains("fades") and n >= BoutRules.ROUNDS:
		t += (1.0 - t) * FADE_ODDS
	return t


## Her mean edge in power points in each round against this opponent, on this camp.
static func round_edges(f: Dictionary, opp: Dictionary, camp: Dictionary) -> Array:
	var fx := f.merged({"camp": camp, "bout": {}}, true)
	var base := ComboOdds.gap(fx, opp)
	var tanks := _energy(fx, opp)
	var mix := _games(opp)
	var body_a := MEAN_LANDED * Exchanges.BODY_COST * (Exchanges.BODY_THREAT_SHARE if str(opp.get("threat", "")).to_lower().contains("body") else Exchanges.BODY_SHARE)
	var out: Array = []
	for n in range(1, BoutRules.ROUNDS + 1):
		var t: Dictionary = tanks[n - 1]
		var e := base + float(t["edge"]) + BoutRules.stance_edge(n, str(f.get("stance", "orthodox")), opp, camp)
		if n >= BoutRules.ROUNDS and not BoutRules.clears_night_line("conditioning", float((f["stats"] as Dictionary).get("conditioning", 0.0))):
			e -= BoutRules.OWN_FADE
		if n >= BoutRules.ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
			e += BoutRules.OPP_FADE
		var worth := {}
		for sit in mix.keys() + ["tiring", "she_tired"]:
			worth[sit] = _game_edge(fx, str(sit), n)
		var body_b := MEAN_LANDED * Exchanges.BODY_COST * (Exchanges.BODY_CALL_SHARE if _call(f, n) == "body" else Exchanges.BODY_SHARE)
		for i in Exchanges.EXCHANGES:
			var at := float(i) / float(Exchanges.EXCHANGES)
			var done := float((n - 1) * Exchanges.EXCHANGES + i)
			var ex := 0.0
			if lerpf(float(t["a"]), float(t["a_end"]), at) - done * body_a < Exchanges.SHE_TIRED:
				ex = float(worth["she_tired"])
			else:
				var tiring := _tiring(opp, n, lerpf(float(t["b"]), float(t["b_end"]), at) - done * body_b)
				ex = tiring * float(worth["tiring"])
				for sit in mix:
					ex += (1.0 - tiring) * float(mix[sit]) * float(worth[sit])
			e += ex / float(Exchanges.EXCHANGES)
		out.append(e)
	return out


## The chance of the round at edge e: most of six exchanges; a 3-3 split goes to the bigger margin, which leans her way as often.
static func _round_odds(e: float) -> float:
	var p := ComboOdds.win_odds(e)
	var total := 0.0
	var ways := 1.0
	var six := Exchanges.EXCHANGES
	for k in range(0, six + 1):
		var share := ways * pow(p, k) * pow(1.0 - p, six - k)
		if k * 2 > six:
			total += share
		elif k * 2 == six:
			total += share * p
		ways = ways * float(six - k) / float(k + 1)
	return total


## The chance she wins this bout: two rounds of three (a 3-round card has no draw).
static func chance(f: Dictionary, opp: Dictionary, camp: Dictionary) -> float:
	var e := round_edges(f, opp, camp)
	var a := _round_odds(float(e[0]))
	var b := _round_odds(float(e[1]))
	var c := _round_odds(float(e[2]))
	return a * b + a * c + b * c - 2.0 * a * b * c


## {lo, hi}: the chance at the top of her range and at the bottom of it, over what a hidden tell could be. A find only takes
## words off the list, so the band stays inside the last one, and hidden words move nothing.
static func band(f: Dictionary, opp: Dictionary, camp: Dictionary, salt: int) -> Dictionary:
	var span := rating_range(opp, salt)
	return {"lo": clampf(_end(f, opp, float(span[1]), camp, false) - SLACK, 0.01, 0.99),
		"hi": clampf(_end(f, opp, float(span[0]), camp, true) + SLACK, 0.01, 0.99)}


static func _end(f: Dictionary, opp: Dictionary, rating: float, camp: Dictionary, best: bool) -> float:
	var weaks: Array = [str(opp.get("weak", ""))] if OppFile.known(opp, "weakness") else ANY_WEAK
	var weapons: Array = [str(opp.get("threat", ""))] if OppFile.known(opp, "weapon") else ANY_WEAPON
	var out := 0.0 if best else 1.0
	for w in weaks:
		for t in weapons:
			var c := chance(f, opp.merged({"rating": rating, "weak": w, "threat": t}, true), camp)
			out = maxf(out, c) if best else minf(out, c)
	return out


## The strength gap as the coach reads it: her power on the night less the middle of the opponent's range. Minus = the opponent.
static func mismatch(f: Dictionary, opp: Dictionary, camp: Dictionary, salt: int) -> float:
	var span := rating_range(opp, salt)
	return ComboOdds.gap(f.merged({"camp": camp, "bout": {}}, true), {"rating": (float(span[0]) + float(span[1])) / 2.0})


## A name's place (1-based) in a division table (Region.rankings' rows), 0 when not in it.
static func rank_of(rows: Array, name: String) -> int:
	for i in rows.size():
		if str(rows[i]["name"]) == name:
			return i + 1
	return 0


## Her place now and after a win or a loss (the opponent's record moves too), 0 = unranked. order = the table's sort
## (Region.before), min_wins = Region.RANK_MIN_WINS. need = wins still short of the table after this bout's win.
static func rank_move(rows: Array, f: Dictionary, opp_name: String, order: Callable, min_wins: int) -> Dictionary:
	return {"now": rank_of(rows, str(f["name"])), "win": _after(rows, f, opp_name, true, order, min_wins),
		"loss": _after(rows, f, opp_name, false, order, min_wins), "need": maxi(0, min_wins - int(f["w"]) - 1)}


static func _after(rows: Array, f: Dictionary, opp_name: String, won: bool, order: Callable, min_wins: int) -> int:
	var w := int(f["w"]) + int(won)
	if w < min_wins:
		return 0
	var table: Array = rows.filter(func(r): return str(r["name"]) != str(f["name"])).map(func(r): return (r as Dictionary).duplicate())
	for r in table:
		if str(r["name"]) == opp_name:
			r["w"] = int(r["w"]) + int(not won)
			r["l"] = int(r["l"]) + int(won)
	table.append({"name": f["name"], "w": w, "l": int(f["l"]) + int(not won), "rating": 0.0})
	table.sort_custom(order)
	return rank_of(table, str(f["name"]))
