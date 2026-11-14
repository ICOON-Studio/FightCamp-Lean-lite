extends RefCounted
## A bout offer read as a decision: the coach's estimate of the opponent, and the fighter's chance, rank and mismatch.
## chance() walks the bout the sim fights. Shouts and the corner minute are left out. One rating range hides the truth
## across all seven stats, and a hidden tell moves nothing. coach is the gym coach's rating. salt is the career seed.

const StyleName := preload("res://scripts/rules/StyleName.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")   # S460 PlanPhase lines by round
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanChain := preload("res://scripts/rules/PlanChain.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")   # GRADE1
const PerkFight := preload("res://scripts/rules/PerkFight.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")

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
const ANY_WEAK := ["", "Fades after round 2", "Leaves the chin open", "Walks in straight"]
const ANY_WEAPON := ["", "Never stops throwing", "Stops people"]
## The band's allowance for what chance() leaves out, each side (tests/bout_read_test.gd measures chance() against real bouts).
const SLACK := 0.03
## With time for a camp the read assumes the club's usual one.
const USUAL_CAMP := 2
## Exchanges.next_mode's odds of "tiring": on an empty tank, and in a late fade.
const OPP_TIRED_ODDS := 0.75
const FADE_ODDS := 0.5
## Punches each side lands in an exchange on the mean (Exchanges.LANDED): what its body shots cost a tank.
const MEAN_LANDED := 3.5
## Share of a plan's edge that reaches the ring in her own trouble and the opponent's tiring (the opponent's games walk the
## card chain exactly: PlanChain).
const PLAN_REACH := 0.75
## S397 what rides on a plan's answers past their own exchange (PlanRead's reads, PlanPressure's pressure and tank ceiling).
## S434 PUNCHSTART1 round 2 re-fit on the card chain walked exchange by exchange (her trouble and the opponent's tiring counted
## once): 22 arms x 1,000 real bouts (Lucy +-shifts, tired, no plan to four arrows, vs Maria/Priya/Erin/Dana) worst 0.033, rms
## 0.017; 8 held-out arms 0.065 / 0.036 (round 1, 1.4 with the double count: 0.041 / 0.026, held out 0.074 / 0.041).
const PLAN_CARRY := 1.9
## Rounds of next_mode's dice behind one style's mix.
const MIX_ROUNDS := 300

static var _mixes := {}; static var _ge := {}; static var _ready := {}; static var _re := {}
static func clear_cache() -> void: _ge = {}; _re = {}

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
	return RoundStyle.from_opponent(opp)["stats"]   # S398 the profile's own chin holds a chin weakness


## Her words as the file shows them: what is not found yet is blank.
static func public(opp: Dictionary) -> Dictionary:
	var v := opp.duplicate()
	if not OppFile.known(opp, "weapon"):
		v["threat"] = ""
	if not OppFile.known(opp, "weakness"):
		v["weak"] = ""
	return v


## {stat: [lo, hi]} for the seven stats: the rating range moved by what the file shows, plus the room for a hidden tell.
## S398 the room is what any real scouting phrase can do to that stat on the fighter model (_rooms: every threat and
## weakness line the game's boxers carry, through AttrGen's words), so a range only shrinks as the file opens and always
## holds the truth.
static func stat_ranges(opp: Dictionary, salt: int) -> Dictionary:
	var r := float(opp.get("rating", 60.0))
	var span := rating_range(opp, salt)
	var shown := true_stats(public(opp))
	var rooms := _rooms()
	var out := {}
	for k in shown:
		var off := float(shown[k]) - r
		var down := 0.0
		var up := 0.0
		if not OppFile.known(opp, "weakness"):
			down += float(rooms["weak"][k][0])
			up += float(rooms["weak"][k][1])
		if not OppFile.known(opp, "weapon"):
			down += float(rooms["weapon"][k][0])
			up += float(rooms["weapon"][k][1])
		out[k] = [float(span[0]) + off - down, float(span[1]) + off + up]
	return out


static var _room_cache := {}


## {weak: {stat: [down, up]}, weapon: {...}}: the most any one real phrase moves each of the seven.
static func _rooms() -> Dictionary:
	if not _room_cache.is_empty():
		return _room_cache
	var data: GDScript = load("res://scripts/state/Data.gd")
	var gen: GDScript = load("res://scripts/world/WorldGen.gd")
	var rows: Array = data.OPPONENTS + [data.MISMATCH] + data.RIVALS + data.DIVISION_RIVALS + gen.STYLES
	var base := {"rating": 60.0, "style": "Boxer-puncher", "name": "room", "threat": "", "weak": ""}
	var zero := RoundStyle.from_opponent(base)["stats"] as Dictionary
	var out := {"weak": {}, "weapon": {}}
	for k in zero:
		out["weak"][k] = [0.0, 0.0]
		out["weapon"][k] = [0.0, 0.0]
	for row in rows:
		for cat in ["weak", "weapon"]:
			var field := "weak" if cat == "weak" else "threat"
			var st: Dictionary = RoundStyle.from_opponent(base.merged({field: str(row.get(field, ""))}, true))["stats"]
			for k in zero:
				var d := float(st[k]) - float(zero[k])
				out[cat][k][0] = maxf(float(out[cat][k][0]), -d)
				out[cat][k][1] = maxf(float(out[cat][k][1]), d)
	_room_cache = out
	return out


## S398 the tale of the tape on the fighter model: the opponent's six keys (Duels.keys: long game, pocket, inside, power,
## durability, engine) as ranges - the rating range on the shape the file's FOUND words show, plus KEY_ROOM either way while a
## tell is still hidden (it could be a weapon or a hole). {name: [lo, hi]} in Duels.keys order.
const KEY_ROOM := 4.0


static func key_ranges(opp: Dictionary, salt: int) -> Array:
	var span := rating_range(opp, salt)
	var pub := public(opp)   # a world boxer's shape is on public tape (record, style); the scout's words are not
	var lo := RingDuel.Duels.keys(RingDuel.AttrGen.attrs_of(pub.merged({"rating": float(span[0])}, true)))
	var hi := RingDuel.Duels.keys(RingDuel.AttrGen.attrs_of(pub.merged({"rating": float(span[1])}, true)))
	var room := 0.0 if int(stage(opp)["found"]) >= int(stage(opp)["all"]) else KEY_ROOM
	var out: Array = []
	for i in lo.size():
		out.append({"name": str(lo[i]["name"]), "lo": float(lo[i]["value"]) - room, "hi": float(hi[i]["value"]) + room})
	return out


## The camp the read assumes: hers, else the usual one with time for it, else none.
static func camp_for(f: Dictionary, days: int) -> Dictionary:
	var camp: Dictionary = f.get("camp", {})
	if not camp.is_empty():
		return camp
	return {"protocol": USUAL_CAMP} if days >= BoutRules.CAMP_MIN_DAYS else {}


## BoutNight._energy, read only, on the coach's calls: per round {edge (her combination edge and both tired penalties),
## a, a_end, b, b_end (the tanks at the first and last bell)}.
static func _energy(f: Dictionary, opp: Dictionary, off := 0.0) -> Array:
	var op := RoundStyle.from_opponent(opp)
	var mine: Dictionary = OwnCombos.all_mastery(f)
	var own := RingDuel.Attrs.of(f)   # S433 CARDIO1: the cost reads Stamina, the minute's refill Recovery
	var cond_b := RoundStyle.stat(op, "conditioning")
	var econ := SkillAwards.bout_economy(f, RoundStyle.SHARE) * StyleName.effect(f, "combo_energy")   # S459 as BoutNight
	var a := Combos.TANK - off   # S434 the played Tank: hurt and the scale (BoutRules.tank_read), as BoutNight._energy
	var b := Combos.TANK
	var qa := 0.0
	var qb := 0.0
	var out: Array = []
	for n in range(1, BoutRules.ROUNDS + 1):
		var ra := Combos.after_round(a, qa, Combos.round_spend(mine, _call(f, n), float(own["stamina"]), econ), float(own["recovery"]))
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
	var key := hash(sit) ^ (n * 1315423911) ^ hash(f.get("stats", {})) ^ hash(f.get("arrows", [])) ^ hash(f.get("moves", {})) ^ hash(f.get("combos", {})) ^ hash(f.get("personality", {})) ^ hash(f.get("perks", [])) ^ hash(f.get("habits", [])) ^ int(round(float(f.get("footwork", 0.0)) * 1000.0))
	if _ge.has(key):
		return float(_ge[key])
	var e := _game_edge_of(f, sit, n)
	_ge[key] = e
	return e
static func _game_edge_of(f: Dictionary, sit: String, n: int) -> float:
	var vals: Dictionary = (f["stats"] as Dictionary).duplicate()
	vals.merge(f.get("personality", {}) as Dictionary)
	vals["footwork"] = float(f.get("footwork", vals.get("speed", 55.0)))
	var coach := float((f.get("personality", {}) as Dictionary).get("coachability", 55.0))
	var heard := Exchanges.uptake(coach, 0) * FighterProfile.trust(f)
	var call := _call(f, n)
	var e := Exchanges.call_edge(call, sit, vals, heard)
	vals.merge(RingDuel.Attrs.of(f), true)
	if float(vals.get("ring_iq", 55.0)) >= Exchanges.IQ_FINDS:   # she finds the answer herself when the game carries on
		e = lerpf(e, Exchanges.call_edge(call, sit, vals, heard, true), Exchanges.KEEP)
	e = PerkFight.call_edge(f, e) + PerkFight.jab_edge(f, sit)
	var at := str(PlanFight.GAME_CARD.get(sit, "long"))
	var moves: Dictionary = f.get("moves", {})
	var combos: Dictionary = f.get("combos", {})
	var pick := PlanFight.choose(PlanFile.arrows_for(f.get("arrows", []), f.get("late", {}), n, BoutRules.ROUNDS), at, moves, sit)   # S460 PlanPhase, as the ring
	if sit in ["tiring", "she_tired"]:   # S434 the opponent's games walk the card chain in _round_edges (PlanChain)
		e += PLAN_REACH * PLAN_CARRY * LineGrade.edge(pick, sit, PlanFight.rate(str(pick["move"]), combos), PlanFight.card_mean(at, sit, moves, combos), LineGrade.attrs_for(f))   # GRADE1
	var habits := 0.0
	for i in Exchanges.EXCHANGES:
		habits += Exchanges.HABIT_BOUT * HabitFix.cost(HabitFix.punished(f.get("habits", []), sit, n, i, n == BoutRules.ROUNDS), "", 0.0)
	return e + habits / float(Exchanges.EXCHANGES)


static func _read_copy(f: Dictionary, opp: Dictionary, camp: Dictionary, coach: float) -> Dictionary:
	var key := "%s|%s|%s|%s|%s|%.4f|%s" % [str(f.get("id", "")), str(f.get("stats", {})), str(f.get("moves", {})), str(f.get("personality", {})), str(f.get("style", "")), float(f.get("footwork", -1.0)), str(f.get("attrs", {}))]   # S434: her attributes (Stamina, Recovery), not only their means
	if not _ready.has(key):
		var made := f.duplicate()
		made["stats"] = (f.get("stats", {}) as Dictionary).duplicate()
		if f.has("attrs"): made["attrs"] = (f["attrs"] as Dictionary).duplicate()
		made["bout"] = {}
		RingDuel.Attrs.of(made)
		_ready[key] = made
	var once: Dictionary = _ready[key]
	var fx := f.duplicate()
	fx["stats"] = (once["stats"] as Dictionary).duplicate()
	fx["attrs"] = (once["attrs"] as Dictionary).duplicate()
	fx["stats_seen"] = (once["stats_seen"] as Dictionary).duplicate()
	fx["footwork"] = once.get("footwork", f.get("footwork", 55.0))
	fx["camp"] = camp
	fx["bout"] = {}
	if (fx.get("arrows", []) as Array).is_empty():
		fx["arrows"] = CoachPlan.write(str(opp.get("style", "")), coach, fx.get("moves", {}), fx.get("combos", {}), fx.get("steps", {}))
	return fx


## The games her style really plays, Exchanges.next_mode's own dice run on (MAX_RUN makes them flatter than STYLE_MODES).
static func _games(opp: Dictionary, bias: Dictionary = {}) -> Dictionary:
	var style := str(opp.get("style", ""))
	var weak := "walks in" if str(opp.get("weak", "")).to_lower().contains("walks in") else ""   # the one word next_mode reads here
	var key := style + "|" + weak + "|" + str(bias)
	if _mixes.has(key):
		return _mixes[key]
	var rng := RandomNumberGenerator.new()
	rng.seed = 387
	var tally := {}
	for _round in MIX_ROUNDS:
		var mode := ""
		var run := 0
		for i in Exchanges.EXCHANGES:
			var next := Exchanges.next_mode(style, weak, 2, i, mode, Combos.TANK, false, rng, run, bias)
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
static func _re_key(f: Dictionary, o: Dictionary, camp: Dictionary, coach: float) -> String:
	return RingDuel.stat_bucket(f) + str(f.get("moves")) + str(f.get("combos")) + str(f.get("steps")) + str(f.get("arrows")) + str(f.get("personality")) + str(f.get("perks")) + str(f.get("habits")) + str(f.get("style")) + str(f.get("stance")) + str(f.get("style_dials")) + str(f.get("durability_cap")) + str(camp) + str(coach) + str(o.get("rating")) + str(o.get("weak")) + str(o.get("threat")) + str(o.get("style")) + str(o.get("shape")) + str(o.get("age")) + str(o.get("peak_age")) + str(o.get("pace")) + str(o.get("forward")) + str(o.get("heart")) + str(o.get("stance")) + str(o.get("height")) + str(o.get("reach")) + str(o.get("name")) + str(o.get("damage_ledger")) + str(o.get("sex")) + str(BoutRules.tank_read(f)) + "|r%s-%s-%s-%s" % [o.get("w"), o.get("l"), o.get("d"), o.get("pro")]   # S434 PUNCHSTART1: her punches grow with her record


static func round_edges(f: Dictionary, opp: Dictionary, camp: Dictionary, coach := 0.0) -> Array:
	var key := _re_key(f, opp, camp, coach)
	if _re.has(key):
		return _re[key]
	var out := _round_edges(f, opp, camp, coach)
	_re[key] = out
	return out


static func _round_edges(f: Dictionary, opp: Dictionary, camp: Dictionary, coach := 0.0) -> Array:
	var fx := _read_copy(f, opp, camp, coach)
	var base := ComboOdds.night_gap(fx)   # S398 who is better is the duels below, exchange by exchange
	var tanks := _energy(fx, opp, BoutRules.tank_read(f))
	var mix := _games(opp, RingDuel.mode_bias(fx, opp))
	var own_attrs := RingDuel.Attrs.of(fx)
	var opp_attrs := RingDuel.opp(opp)
	var body_a := MEAN_LANDED * Exchanges.body_cost(float(own_attrs.get("body", 55.0))) \
		* (Exchanges.BODY_THREAT_SHARE if str(opp.get("threat", "")).to_lower().contains("body") else Exchanges.BODY_SHARE)
	var out: Array = []
	var states: Dictionary = {}
	for n in range(1, BoutRules.ROUNDS + 1):
		var t: Dictionary = tanks[n - 1]
		var e := base + float(t["edge"]) + BoutRules.stance_edge(n, str(f.get("stance", "orthodox")), opp, camp)
		if n >= BoutRules.ROUNDS:   # S434 CARDIO1: the fade's slope on her Stamina, as LiveRound
			e -= BoutRules.own_fade(float(own_attrs["stamina"]))
		if n >= BoutRules.ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
			e += BoutRules.OPP_FADE
		var worth := {}
		for sit in mix.keys() + ["tiring", "she_tired"]:
			worth[sit] = _game_edge(fx, str(sit), n)
		var body_b := MEAN_LANDED * Exchanges.body_cost(float(opp_attrs.get("body", 55.0))) \
			* (Exchanges.BODY_CALL_SHARE if _call(f, n) == "body" else Exchanges.BODY_SHARE)
		# S398 the duels, on the world's quick ladder (one energy a round, no ropes) so a page can read every hidden phrase.
		var eas: Array = []; var ebs: Array = []; var wbs: Array = []; var steps: Array = []
		var mixw := RingDuel.wants_of_mix(mix)
		for i in Exchanges.EXCHANGES:
			var at := float(i) / float(Exchanges.EXCHANGES)
			var done := float((n - 1) * Exchanges.EXCHANGES + i)
			eas.append(lerpf(float(t["a"]), float(t["a_end"]), at) - done * body_a)
			var eb := lerpf(float(t["b"]), float(t["b_end"]), at) - done * body_b
			ebs.append(eb)
			var tr := _tiring(opp, n, eb)
			wbs.append([(1.0 - tr) * float(mixw[0]) + tr, (1.0 - tr) * float(mixw[1]), (1.0 - tr) * float(mixw[2])])
		var duel_read := RingDuel.mean_edges(fx, opp, n, eas, ebs, _call(f, n), wbs, states)
		states = duel_read["states"]
		var duels: Array = duel_read["edges"]
		for i in Exchanges.EXCHANGES:
			e += float(duels[i]) / float(Exchanges.EXCHANGES)
		for i in Exchanges.EXCHANGES:
			var ex := 0.0
			if float(eas[i]) < Exchanges.SHE_TIRED:
				ex = float(worth["she_tired"])
				steps.append({"she_tired": 1.0})
			else:
				var tiring := _tiring(opp, n, float(ebs[i]))
				ex = tiring * float(worth["tiring"])
				var st := {"tiring": tiring}
				for sit in mix:
					ex += (1.0 - tiring) * float(mix[sit]) * float(worth[sit])
					st[sit] = (1.0 - tiring) * float(mix[sit])
				steps.append(st)
			e += ex / float(Exchanges.EXCHANGES)
		# S434 her plan on the cards she really stands on (PlanChain), exchange by exchange at her chance of one; her own
		# trouble and the opponent's tiring move her card but add their plan once, in worth (_game_edge_of).
		e += PLAN_CARRY * PlanChain.walk(fx.get("arrows", []), fx.get("moves", {}), fx.get("combos", {}), steps, ComboOdds.win_odds(e), ["she_tired", "tiring"], fx.get("steps", {}))
		out.append(e)
	return out



## The chance she wins this bout: two rounds of three (a 3-round card has no draw).
static func chance(f: Dictionary, opp: Dictionary, camp: Dictionary, coach := 0.0) -> float:
	var e := round_edges(f, opp, camp, coach)
	# S398 integrated over the form both bring on the night (RingDuel.form), as the bout rolls it.
	var out := 0.0
	var sd := RingDuel.FORM_SD * sqrt(2.0)
	for j in WorldBout.GH_X.size():
		var d := float(WorldBout.GH_X[j]) * sd
		var a := ComboOdds.round_odds(float(e[0]) + d)
		var b := ComboOdds.round_odds(float(e[1]) + d)
		var c := ComboOdds.round_odds(float(e[2]) + d)
		out += float(WorldBout.GH_W[j]) * (a * b + a * c + b * c - 2.0 * a * b * c)
	return clampf(out, 0.01, 0.99)   # S398 never certain, and the band's own floor and ceiling


## {lo, hi}: the chance at the top of her range and at the bottom of it, over what a hidden tell could be. A find only takes
## words off the list, so the band stays inside the last one, and hidden words move nothing.
static func band(f: Dictionary, opp: Dictionary, camp: Dictionary, salt: int, coach := 0.0) -> Dictionary:
	var span := rating_range(opp, salt)
	return {"lo": clampf(_end(f, opp, float(span[1]), camp, false, coach) - SLACK, 0.01, 0.99),
		"hi": clampf(_end(f, opp, float(span[0]), camp, true, coach) + SLACK, 0.01, 0.99)}


## S398 the coach's single read (Rank 5 critics: "Win chance 4-56%" read like a bug): the chance at the middle of the
## rating range the file gives, on the words found so far (hidden ones blank). Show "about <likely>%" and keep band() for
## the honest spread (it narrows with every find); the likely read moves toward the truth as the file opens.
static func likely(f: Dictionary, opp: Dictionary, camp: Dictionary, salt: int, coach := 0.0) -> float:
	var span := rating_range(opp, salt)
	return chance(f, public(opp).merged({"rating": (float(span[0]) + float(span[1])) * 0.5}, true), camp, coach)


static func _end(f: Dictionary, opp: Dictionary, rating: float, camp: Dictionary, best: bool, coach := 0.0) -> float:
	var weaks: Array = [str(opp.get("weak", ""))] if OppFile.known(opp, "weakness") else _candidates(f, opp, "weak")
	var weapons: Array = [str(opp.get("threat", ""))] if OppFile.known(opp, "weapon") else _candidates(f, opp, "threat")
	var out := 0.0 if best else 1.0
	for w in weaks:
		for t in weapons:
			var c := chance(f, opp.merged({"rating": rating, "weak": w, "threat": t}, true), camp, coach)
			out = maxf(out, c) if best else minf(out, c)
	return out


static var _cand_cache := {}


## S398 what a hidden line could be, for this fighter and this style: of every real phrase (_rooms' rows), the one that helps
## her most and the one that hurts her most on the duels (RingDuel.mean_edge), plus ANY_* (the fades and tank lines the
## duels' mean does not see). The same for any hidden word, so a hidden word still moves nothing.
static func _candidates(f: Dictionary, opp: Dictionary, field: String) -> Array:
	var key := "%s|%.1f|%s|%s|%d" % [str(f.get("name", "")), RingDuel.Attrs.overall(RingDuel.Attrs.of(f)), str(opp.get("style", "")), field, RingDuel.AttrGen.PunchStart.bouts_of(opp)]   # S434: her bouts grow her punches
	if _cand_cache.has(key):
		return _cand_cache[key]
	var data: GDScript = load("res://scripts/state/Data.gd")
	var gen: GDScript = load("res://scripts/world/WorldGen.gd")
	var rows: Array = data.OPPONENTS + [data.MISMATCH] + data.RIVALS + data.DIVISION_RIVALS + gen.STYLES
	var base := opp.duplicate()
	base["weak"] = ""
	base["threat"] = ""
	base.erase("shape")
	var lo := ""
	var hi := ""
	var lo_e := INF
	var hi_e := -INF
	for row in rows:
		var w := str(row.get(field, ""))
		var e := RingDuel.mean_edge(f, base.merged({field: w}, true))
		if e < lo_e:
			lo_e = e
			lo = w
		if e > hi_e:
			hi_e = e
			hi = w
	var out: Array = (ANY_WEAK if field == "weak" else ANY_WEAPON).duplicate()
	for w in [lo, hi]:
		if not out.has(w):
			out.append(w)
	_cand_cache[key] = out
	return out


## The strength gap as the coach reads it: her power on the night less the middle of the opponent's range. Minus = the opponent.
static func mismatch(f: Dictionary, opp: Dictionary, camp: Dictionary, salt: int) -> float:
	var span := rating_range(opp, salt)
	var shown := public(opp).merged({"rating": (float(span[0]) + float(span[1])) / 2.0}, true)
	return ComboOdds.gap(f.merged({"camp": camp, "bout": {}}, true), shown)


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
