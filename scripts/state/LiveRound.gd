extends RefCounted
## S308: the round being fought, exchange by exchange (Exchanges has the rules). Bouts opens it with the corner's plan and
## the round's energy, then hands each 30 seconds a shout ("" = say nothing: the plan carries on). The sixth exchange
## closes it into the round dict Bouts has always kept ({n, won, mine, theirs, corner, energy, ...} + exchanges).
## Lives in the fight moment as m["live"]. No preload of Bouts (Bouts preloads this).

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")
const PlanRead := preload("res://scripts/rules/PlanRead.gd")
const PlanPressure := preload("res://scripts/rules/PlanPressure.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const PerkFight := preload("res://scripts/rules/PerkFight.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const LiveRead := preload("res://scripts/state/LiveRead.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")
const Adaptation := preload("res://scripts/rules/Adaptation.gd")
const ReadBack := preload("res://scripts/rules/ReadBack.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"

## Her values a call is done with: the fight stats, her footwork and her personality.
static func values(f: Dictionary) -> Dictionary:
	var v: Dictionary = (f.get("stats", {}) as Dictionary).duplicate()
	v.merge(f.get("personality", {}) as Dictionary)
	v["footwork"] = float(f.get("footwork", v.get("speed", 55.0)))
	v.merge(Attrs.of(f), true)   # S398 the attributes a call is done with (Exchanges.CALLS needs)
	return v


static func _rng(c: Career, f: Dictionary, n: int, i: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 31 + n * 7 + i * 101 + 3 + c.fighters.find(f) * 1009
	return rng


## Opens round n. plan = the corner minute's call ("" before round 1); e = Bouts._energy's round; fix = the habit the
## corner fixed for this round (S309 HabitFix, "" = none). jobs = the rest of the corner minute (S310 CornerJobs):
## {setup: {combo, gap}, talk: kind, hurt: she starts hurt (not cleared)} - recover is applied by Bouts before this.
static func open(c: Career, f: Dictionary, m: Dictionary, n: int, plan: String, e: Dictionary, fix: String = "",
		jobs: Dictionary = {}) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	# S381 C229 stage 4: the film is worth the found tells her plan answers, counted at the first bell for the whole bout.
	if n == 1 or not f["bout"].has("answered"):
		f["bout"]["answered"] = FilmEdge.answered(f)
	# S398 the fighter model: no averaged stats against a rating any more - the base holds the night's edges (camp, film,
	# weapons, combinations and tiredness); who is better is fought exchange by exchange in RingDuel's duels.
	var base := BoutRules.night_edge(f["camp"], int(f["bout"]["answered"])) \
		+ BoutRules.weapons_edge(BoutRules.weapons(f.get("moves", {}))) + float(e.get("bonus", 0.0))
	if n == 1 or not f["bout"].has("form"):
		f["bout"].erase("form")
		RingDuel.form(f, c.day * 31 + c.fighters.find(f) * 7)
	if n >= BoutRules.ROUNDS and float(f["stats"].get("conditioning", 0.0)) < BoutRules.FADE_CONDITIONING:
		base -= BoutRules.OWN_FADE
	if n >= BoutRules.ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
		base += BoutRules.OPP_FADE
	# S356 a week with the southpaw partner (WeekTwist "Take him"): an edge on a southpaw.
	if bool(f["bout"].get("lefty", false)) and str(opp.get("stance", "")).to_lower() == "southpaw":
		base += WeekTwist.LEFTY_EDGE
	# S381 C229 stage 3: round 1 against a southpaw she never faced in camp.
	base += BoutRules.stance_edge(n, str(f.get("stance", "orthodox")), opp, f["camp"], bool(f["bout"].get("lefty", false)))
	var rng := _rng(c, f, n, 0)
	var mode := Exchanges.next_mode(str(opp.get("style", "")), str(opp.get("weak", "")), n, 0, "", float(e.get("b", 100.0)), false, rng, 0,
		RingDuel.mode_bias(f, opp))
	# S310: body shots taken all fight ({a: by her, b: by the opponent}), kept on the bout so they carry round to round.
	if n == 1 or not f["bout"].has("body"):
		f["bout"]["body"] = {"a": 0, "b": 0}
	# S339 the coach's plan she walks out with (her saved board); the corner changes it on the bout only.
	if n == 1 or not f["bout"].has("arrows"):
		f["bout"]["arrows"] = (f.get("arrows", []) as Array).duplicate(true)
	var talk := CornerJobs.talk(str(jobs.get("talk", "")), f.get("personality", {}))
	var setup := {}
	var sj: Dictionary = jobs.get("setup", {})
	if not sj.is_empty() and float((f.get("combos", {}) as Dictionary).get(str(sj.get("combo", "")), 0.0)) >= Combos.LEARN_AT:
		setup = {"combo": str(sj["combo"]), "gap": str(sj["gap"]), "mastery": float(f["combos"][str(sj["combo"])]), "used": ""}
	# S323 Pace and Aim (the body is the track: the driver mode) carry from round to round until changed.
	var was: Dictionary = m.get("live", {})
	var own_attrs := Attrs.of(f)
	var opp_attrs := RingDuel.opp(opp)
	# S375 SCOUTPLAN1 the plan's ROUND row opens the round on its pace ("" = the default below).
	var pace0 := PlanFile.pace_for(f, n)
	if n == 1:
		f["bout"]["plan_tally"] = {}
	PlanPressure.new_round(f["bout"], n)   # S397 the plan's pressure and her tank's ceiling last the bout
	m["live"] = {"pace": pace0 if pace0 != "" else str(was.get("pace", "steady")), "aim": str(was.get("aim", "")), "n": n, "plan": plan, "ex": [], "shouts": 0, "mode": mode, "her_hurt": bool(jobs.get("hurt", false)), "opp_hurt": false,
		"talk": talk, "talk_kind": str(jobs.get("talk", "")), "setup": setup, "adapt": Adaptation.start(f["bout"], str(jobs.get("adapt", "")), Exchanges.uptake(float((f.get("personality", {}) as Dictionary).get("coachability", 55.0)), 0) * FighterProfile.trust(f)),
		"cost": 0.0, "e": e, "base": base, "fix": fix, "last": n >= int(f["bout"].get("rounds", BoutRules.ROUNDS)),
		"place": int(f["bout"].get("last_place", 0)), "body": f["bout"]["body"],
		"body_cost_a": Exchanges.body_cost(float(own_attrs.get("body", 55.0))),
		"body_cost_b": PerkFight.body_cost(f) * Exchanges.body_cost(float(opp_attrs.get("body", 55.0))) / Exchanges.BODY_COST}
	m["live"]["start"] = state(m["live"], 0)
	RingDuel.open(m["live"])


## S310 what the fight display shows after i exchanges: {a, b (energy), body [taken by her, by the opponent], hurt [hers,
## the opponent's]}. Kept on each exchange ("after") and the round ("start") so the display shows only what was watched.
static func state(lv: Dictionary, i: int) -> Dictionary:
	return RingDuel.state(lv, i)


static func live(m: Dictionary) -> Dictionary:
	return m.get("live", {})


## S323 balance-check (tools/exchange_balance.gd: Push all fight won 0.88 vs Steady 0.67 - a dominant strategy; the tank
## it spent never came back to bite): pushing on an empty tank is sloppy work that walks onto counters. Push's edge fades
## from PUSH_GAS_FROM energy and turns against her by PUSH_GAS_ALL (PUSH_GAS off the edge there).
const PUSH_GAS_FROM := 55.0
const PUSH_GAS_ALL := 25.0
const PUSH_GAS := 12.0


static func push_gassed(pace: String, energy: float) -> float:
	if pace != "push":
		return 0.0
	return PUSH_GAS * clampf((PUSH_GAS_FROM - energy) / (PUSH_GAS_FROM - PUSH_GAS_ALL), 0.0, 1.0)


## Her energy as exchange i starts (the round's start -> bell, less what the calls spent and the body shots she took).
static func her_energy(lv: Dictionary, i: int) -> float:
	return RingDuel.her_energy(lv, i)


static func opp_energy(lv: Dictionary, i: int) -> float:
	return RingDuel.opp_energy(lv, i)


## What the corner sees before the next exchange: {sit, clue, offers, coach, mark, grades {call: word}, at (seconds into
## the round)}. With full film study (depth 3) the corner reads her NEXT game; without, the one she just showed. Our own
## fighter's state is always seen. coach = the best call for what the corner sees (the clue's answer); mark = the call the
## shout bar marks "coach's pick" (S310: the mark on every shout gave the answer away). Without film study there is no
## mark - the player reads the clue. With it the coach marks the answer to the game her tapes show most
## (Exchanges.favourite) or to our own fighter's state: right while she fights her usual way, wrong when she switches -
## the clue, which shows what she does now, beats following the mark blindly.
static func preview(f: Dictionary, m: Dictionary) -> Dictionary:
	var lv := live(m)
	if lv.is_empty():
		return {}
	var i := (lv["ex"] as Array).size()
	var opp: Dictionary = f["bout"]["opp"]
	var seen := str(lv["mode"])
	if int(f["bout"]["film"]) < BoutRules.FILM_DEPTH_WITH_STUDY and i > 0:
		seen = str((lv["ex"][i - 1] as Dictionary)["mode"])
	var sit := Exchanges.situation(seen, her_energy(lv, i), bool(lv["her_hurt"]))
	var names := [str(f["first"]), str(opp["first"])]
	var vals := values(f)
	var coach := str(Exchanges.MODES[sit]["best"])
	var mark := ""
	if int(f["bout"]["film"]) >= BoutRules.FILM_DEPTH_WITH_STUDY:
		var fav := Exchanges.favourite(str(opp.get("style", "")))
		mark = str(Exchanges.MODES[Exchanges.situation(fav, her_energy(lv, i), bool(lv["her_hurt"]))]["best"])
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = Exchanges.grade(str(k), vals)["word"]
	return {"sit": sit, "clue": Exchanges.clue(sit, names, i + int(lv["n"]) * 3), "offers": Exchanges.offers(sit),
		"coach": coach, "mark": mark, "grades": grades, "at": i * Exchanges.EX_SECONDS, "i": i,
		"shouts": int(lv["shouts"]), "names": names, "now": now_offer(lv, sit), "read": read_view(f, seen),
		"read_call": str(lv.get("read_call", "")),
		"pace": str(lv.get("pace", "steady")), "aim": str(lv.get("aim", "")), "aims": PaceAim.offers({"head": bool(lv["opp_hurt"])})}


## S310 the set-up's NOW button: {combo, gap, line} when the corner SEES the gap it waits for (seen = with film study her
## next game, without it the one she just showed - so without film it can fire into a game she has left), else {}.
static func now_offer(lv: Dictionary, sit_seen: String) -> Dictionary:
	var su: Dictionary = lv.get("setup", {})
	if su.is_empty() or str(su.get("used", "")) != "" or not CornerJobs.fits(str(su["gap"]), sit_seen):
		return {}
	return {"combo": str(su["combo"]), "gap": str(su["gap"]), "line": "NOW! %s!" % combo_words(str(su["combo"]))}


## "Jab-Cross-Lead hook" for a combination id.
static func combo_words(id: String) -> String:
	return "-".join(PackedStringArray((Combos.row(id).get("moves", [id]) as Array).map(func(x): return str(x))))


## Fights the next exchange with this shout ("" = say nothing; "now" = fire the set-up on the plan). Returns the closed
## round after the sixth, else {}.
static func exchange(c: Career, f: Dictionary, m: Dictionary, shout: String) -> Dictionary:
	var lv := live(m)
	if lv.is_empty():
		return {}
	var exs: Array = lv["ex"]
	var i := exs.size()
	var n := int(lv["n"])
	var opp: Dictionary = f["bout"]["opp"]
	var vals := values(f)
	var sit := Exchanges.situation(str(lv["mode"]), her_energy(lv, i), bool(lv["her_hurt"]))
	# S323 "<call>|pace=<push|steady|save>|aim=<PaceAim.AIMS>" from the shout bar: the driver mode for this exchange on.
	for opt in shout.split("|").slice(1):
		var kv := str(opt).split("=")
		if kv.size() == 2 and kv[0] == "pace" and PaceAim.PACES.has(kv[1]):
			lv["pace"] = kv[1]
		elif kv.size() == 2 and kv[0] == "aim" and PaceAim.AIMS.has(kv[1]):
			lv["aim"] = kv[1]
	shout = shout.get_slice("|", 0)
	# S333 THE READ's corner calls: "wait" (Wait for it) holds her trigger up for the rest of the round, "take" (Take it now)
	# fires the counter this exchange on whatever she has read.
	var read_call := ""
	if shout in ["wait", "take"]:
		read_call = shout
		if shout == "wait":
			lv["read_call"] = "wait"
		shout = ""
	var pace := str(lv.get("pace", "steady"))
	var aim := str(lv.get("aim", ""))
	var opp_hurt := {"head": bool(lv["opp_hurt"])}
	var fire := shout == "now" and not (lv.get("setup", {}) as Dictionary).is_empty() and str(lv["setup"].get("used", "")) == ""
	if shout == "now":
		shout = ""
	var shouted := shout != "" and Exchanges.CALLS.has(shout) and CornerTrust.lands(f)
	if shout != "" and not shouted: CornerTrust.ignored(f["bout"])
	var call := shout if shouted else str(lv["plan"])
	var coach := float((f.get("personality", {}) as Dictionary).get("coachability", 55.0))
	# S361 her trust (morale) scales what she takes in of every call and fix (FighterProfile.TRUST).
	var trust := FighterProfile.trust(f)
	var heard := Exchanges.uptake(coach, int(lv["shouts"]) if shouted else 0) * trust
	if shouted:
		lv["shouts"] = int(lv["shouts"]) + 1
	var same_game := i > 0 and str((exs[i - 1] as Dictionary)["mode"]) == str(lv["mode"])
	var finds := same_game and float(vals.get("ring_iq", 55.0)) >= Exchanges.IQ_FINDS
	# S309: a habit the situation punishes costs her, unless the corner fixed it (as far as she took it in).
	var fix := str(lv.get("fix", ""))
	var habit := HabitFix.punished(f.get("habits", []), sit, n, i, bool(lv.get("last", false)))
	# S355 the perks (PerkFight): each one fired this exchange goes on rec["perks"].
	var perks: Array = []
	var ce := Exchanges.call_edge(call, sit, vals, heard, finds)
	if PerkFight.call_edge(f, ce) != ce:
		perks.append("ring_general")
	if PerkFight.jab_edge(f, sit) > 0.0:
		perks.append("stiff_jab")
	# A named fix clears the habit for the bout. The open cost (no fix) stays HABIT_BOUT times HabitFix, so a
	# missed fix still loses nights; the uptake slip alone was not enough for the fix to beat the read.
	var habit_pts := 0.0 if habit != "" and habit == fix else Exchanges.HABIT_BOUT * HabitFix.cost(habit, fix, Exchanges.uptake(coach, 0) * trust * (0.5 if bool(f["bout"].get("hot", false)) else 1.0))
	var d := float(lv["base"]) + PerkFight.call_edge(f, ce) + PerkFight.jab_edge(f, sit) + habit_pts
	# S310 the corner's talk works every exchange of the round; the set-up once, when it is fired.
	d += float((lv.get("talk", {}) as Dictionary).get("edge", 0.0))
	var su: Dictionary = lv.get("setup", {})
	var fits := fire and CornerJobs.fits(str(su.get("gap", "")), sit)
	if fire:
		var se := CornerJobs.setup_edge(fits, float(su["mastery"]), her_energy(lv, i))
		if PerkFight.setup_edge(f, se) != se:
			perks.append("hand_speed")
		d += PerkFight.setup_edge(f, se)
	d += PaceAim.edge(pace, aim, opp_hurt, {}) - push_gassed(pace, her_energy(lv, i)) + PlanFile.cold_edge(opp, pace, n, i)
	var st := read_state(f)
	var game := str(lv["mode"])
	# A habit of hers the opponent is punishing right now (and the corner has not fixed) takes the counter away: she is
	# the one being read in that exchange.
	# One gap weapon: with a set-up armed for this gap she waits for the corner's NOW instead of going herself.
	var armed := not su.is_empty() and str(su.get("used", "")) == "" and CornerJobs.fits(str(su.get("gap", "")), sit)
	var rd := {} if fire or armed or (habit != "" and habit != fix) else LiveRead.read_fire(c, f, lv, st, game, read_call, n, i)
	# The corner's NOW on a habit she has already read past her trigger: the combination comes in on the read too.
	if fire and fits and TheRead.fires(TheRead.read(st, game), TheRead.trigger(f)):
		d += TheRead.EDGE_LANDED
	d += float(rd.get("edge", 0.0))
	# S339 the plan: the card this 30 s is fought on (her own trouble puts her where it does) and the arrow she throws there.
	if str(lv.get("at", "")) == "" or sit.begins_with("she_"):
		lv["at"] = str(PlanFight.GAME_CARD.get(sit, "long"))
	var at := str(lv["at"])
	var pick := PlanFight.choose(f["bout"].get("arrows", []), at, f.get("moves", {}), sit)
	var arrow := str(pick["move"])
	if bool(pick.get("planned", false)) and not FireLevel.fires(f["bout"].get("fire_level", {}), FireLevel.mastery_of(f, arrow), _rng(c, f, n, i + 173).randf()): pick["planned"] = false
	# S342 real plans (Q-S294-67): a hurt opponent who still hits back, a waiter in the round's last exchange.
	var psit := PlanFight.refine(sit, RoundStyle.opponent_habits(opp), i, Exchanges.EXCHANGES)
	var card_mean := PlanFight.card_mean(at, psit, f.get("moves", {}), f.get("combos", {}))
	var plan_rate := PlanFight.rate(arrow, f.get("combos", {}))
	var plan_edge := PlanFight.edge(pick, psit, plan_rate * PerkFight.combo_rate(f, arrow), card_mean)
	if plan_edge > PlanFight.edge(pick, psit, plan_rate, card_mean):
		perks.append("hand_speed")
	# S396 rank 3 (PlanRead): right answers that land build reads, wrong ones punished; both carry through the round.
	var fit_now := PlanFight.fit(arrow, psit) if bool(pick.get("planned", false)) else "none"
	var uses: Dictionary = lv.get_or_add("answer_uses", {})   # per round: both corners reset at the bell (S396 templates test)
	if plan_edge > 0.0 and fit_now == "best":
		plan_edge *= PlanRead.adjust(int(uses.get(arrow, 0)))
	var rb := ReadBack.factor(f["bout"], arrow, pick, str(lv.get("plan_won_arrow", "")))
	plan_edge *= float(rb["cov"]) * float(rb["mult"]) if plan_edge > 0.0 else 1.0
	fit_now = "wrong" if bool(rb["wrong"]) else fit_now
	# The round's reads move the exchange and count as the plan's effect (swing), but the Why grades the answers themselves.
	var read_edge := PlanRead.edge(int(lv.get("reads", 0))) + PlanPressure.edge(f["bout"])   # S397 + the bout's pressure
	d += plan_edge + read_edge
	# S360 Q-S294-90: the camp weeks spent on the opponent's own game (WeekOpp) count when the fight is on it.
	d += WeekOpp.edge(f["bout"], sit)
	# S340 the clinch's price: its own dice, so an exchange without a tie-up plays exactly as before.
	var cl := {}
	if ClinchRest.tied(call, arrow, at):
		var crng := _rng(c, f, n, i + 61)
		cl = ClinchRest.roll(ClinchRest.chance(str(opp.get("style", "")), float(opp.get("rating", 60.0)), float(vals.get("technique", 55.0))),
			crng.randf(), crng.randf(), crng.randf())
		d -= float(cl["edge"])
	# S398 where this 30 s is fought and the duel there (its own dice, so the round's other rolls stay as they were).
	var duel := RingDuel.step(f, opp, lv, call, str(lv["mode"]), her_energy(lv, i), opp_energy(lv, i), _rng(c, f, n, i + 91))
	d += float(duel["edge"])
	var rng := _rng(c, f, n, i + 1)
	var roll_a := rng.randf()
	var roll_b := rng.randf()
	var s := Exchanges.settle(d, roll_a, roll_b)
	# S388 the plan's true effect: the same dice without its edge. +1 it won this exchange, -1 it lost it (FightWhy).
	var swing := int(bool(s["won"])) - int(bool(Exchanges.settle(d - plan_edge - read_edge, roll_a, roll_b)["won"]))
	lv["reads"] = PlanRead.after(int(lv.get("reads", 0)), fit_now, bool(pick.get("planned", false)), bool(s["won"]))
	if fit_now == "best":
		uses[arrow] = int(uses.get(arrow, 0)) + 1
	if bool(pick.get("planned", false)) and bool(s["won"]):
		lv["plan_won_arrow"] = arrow
	# S323 Push throws more (and so lands more), Save less.
	s["landed"][0] = maxi(0, int(round(float(s["landed"][0]) * PaceAim.output(pace))))
	var pressed := PlanPressure.after(f["bout"], lv, s, fit_now, bool(pick.get("planned", false)))
	# S355 Counter sense: she makes an attacker miss and a free counter comes back (its own dice).
	if PerkFight.has(f, "counter_sense") and PerkFight.counters(f, sit, bool(s["won"]), _rng(c, f, n, i + 73).randf()):
		perks.append("counter_sense")
		s["landed"][0] = int(s["landed"][0]) + 1
		s["margin"] = float(s["margin"]) + PerkFight.COUNTER_MARGIN
		var kdmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
		kdmg["b"] = float(kdmg.get("b", 0.0)) + PerkFight.COUNTER_DAMAGE
		m["damage"] = kdmg
	var names := [str(f["first"]), str(opp["first"])]
	# S310 body shots: hers to the body more on "Go to the body", the opponent's more if body punching is her threat.
	var share_b := Exchanges.BODY_THREAT_SHARE if str(opp.get("threat", "")).to_lower().contains("body") else Exchanges.BODY_SHARE
	var share_a := PaceAim.body_share(aim) if aim != "" else (Exchanges.BODY_CALL_SHARE if call == "body" else Exchanges.BODY_SHARE)
	var body := [Exchanges.body_shots(int(s["landed"][0]), share_a, rng.randf()), Adaptation.body_shots(lv, m, int(s["landed"][1]), share_b, rng.randf())]
	var bt: Dictionary = lv.get("body", {"a": 0, "b": 0})
	bt["b"] = int(bt.get("b", 0)) + int(body[0])
	bt["a"] = int(bt.get("a", 0)) + int(body[1])
	if bool(cl.get("hit", false)):
		var ribs := int(cl["shots"]) - (1 if bool(cl["head"]) else 0)
		s["landed"][1] = int(s["landed"][1]) + int(cl["shots"])
		body[1] = int(body[1]) + ribs
		bt["a"] = int(bt.get("a", 0)) + ribs
		if float(cl["damage"]) > 0.0:
			var cdmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
			cdmg["a"] = float(cdmg.get("a", 0.0)) + float(cl["damage"])
			m["damage"] = cdmg
	if fire:
		su["used"] = "landed" if fits and bool(s["won"]) else "missed"
		if su["used"] == "landed":
			# A set-up that lands is head damage the knockdown roll reads (Bouts._counts) and leaves her hurt.
			var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
			dmg["b"] = float(dmg.get("b", 0.0)) + CornerJobs.SETUP_DAMAGE
			m["damage"] = dmg
	if str(rd.get("result", "")) == "landed":
		TheRead.punish(st, game)
		var rdmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
		rdmg["b"] = float(rdmg.get("b", 0.0)) + TheRead.DAMAGE
		m["damage"] = rdmg
	if TheRead.COUNTER.has(game):
		TheRead.watch(st, game, float(vals.get("fight_iq", 55.0)), int(f["bout"]["film"]) >= BoutRules.FILM_DEPTH_WITH_STUDY)
	var rec := {"i": i, "mode": str(lv["mode"]), "read": rd, "body": body, "setup": str(su.get("used", "")) if fire else "", "setup_combo": str(su.get("combo", "")) if fire else "", "sit": sit, "call": call, "shout": shouted, "fit": Exchanges.fit(call, sit),
		"pace": pace, "aim": aim, "won": s["won"], "margin": s["margin"], "landed": s["landed"], "verdict": Exchanges.verdict(call, sit, bool(s["won"]), names),
		"habit": habit, "fix": fix, "habit_line": HabitFix.line(habit_name(habit), names, habit == fix) if habit != "" else ""}
	rec["at"] = at
	rec["place"] = int(duel["place"])
	rec["duel_edge"] = float(duel["edge"])
	rec["a_best"] = str(duel["a_best"])
	rec["b_best"] = str(duel["b_best"])
	rec["pinned"] = bool(duel["pinned"])
	rec["wa"] = int(duel["wa"])
	rec["wb"] = int(duel["wb"])
	rec["duel_line"] = RingDuel.duel_line(rec, names)
	rec["arrow"] = arrow
	rec["planned"] = bool(pick["planned"])
	rec["arrow_fit"] = PlanFight.fit(arrow, psit)
	rec["psit"] = psit
	rec["plan_edge"] = plan_edge
	rec["read_edge"] = read_edge
	rec["plan_swing"] = swing
	rec["pressure"] = pressed
	# S375 SCOUTPLAN1 the plan seen in the ring: each planned arrow's running tally over the bout ([won, thrown]).
	if bool(pick["planned"]):
		var tally: Dictionary = f["bout"].get("plan_tally", {})
		var tl: Array = tally.get(arrow, [0, 0])
		tally[arrow] = [int(tl[0]) + (1 if bool(s["won"]) else 0), int(tl[1]) + 1]
		f["bout"]["plan_tally"] = tally
		rec["plan_tally"] = tally[arrow]
	RingDuel.settle(lv, rec, s, rng, vals, opp, f, call, pace, fire, cl, st, n, i, perks, names, arrow, sit, rd)
	if exs.size() < Exchanges.EXCHANGES:
		return {}
	return close(f, m)


## S333 THE READ (LiveRead holds it since S398).
static func read_state(f: Dictionary) -> Dictionary:
	return LiveRead.read_state(f)


static func read_view(f: Dictionary, seen: String) -> Dictionary:
	return LiveRead.read_view(f, seen)


static func close(f: Dictionary, m: Dictionary) -> Dictionary:
	var lv := live(m)
	var exs: Array = lv["ex"]
	var ro := Exchanges.round_of(exs)
	var e: Dictionary = (lv["e"] as Dictionary).duplicate()
	var spent := float(lv["cost"])
	e["a_end"] = maxf(0.0, float(e.get("a_end", 100.0)) - spent)
	# The calls' energy carries into the next round's start.
	var fb: Dictionary = f["bout"]
	if not exs.is_empty():
		fb["last_place"] = int(exs[-1].get("place", 0))
	if fb.has("energy"):
		fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - spent, 0.0, PlanPressure.ceiling(fb))
	var worked := 0
	var calls := 0
	var paid := {}
	var fix_came := 0   # S320: exchanges the fixed habit would have cost her (the next corner card says so)
	for x in exs:
		if str(lv.get("fix", "")) != "" and str(x.get("habit", "")) == str(lv.get("fix", "")):
			fix_came += 1
		if bool(x["shout"]):
			calls += 1
			worked += 1 if bool(x["won"]) and str(x["fit"]) in ["best", "ok"] else 0
		var h := str(x.get("habit", ""))
		if h != "" and h != str(lv.get("fix", "")):
			paid[h] = int(paid.get(h, 0)) + 1
	# S309: the coach saw each habit she paid for; he can fix it in the next corner.
	if not f.has("notes_seen"):
		f["notes_seen"] = []
	for h in paid.keys():
		if not (f["notes_seen"] as Array).has("habit:" + str(h)):
			(f["notes_seen"] as Array).append("habit:" + str(h))
	CornerTrust.tally(f["bout"], exs)
	m.erase("live")
	return {"n": int(lv["n"]), "won": ro["won"], "won_n": ro["won_n"], "mine": ro["mine"], "theirs": ro["theirs"],
		"corner": str(lv["plan"]), "energy": e, "exchanges": exs, "landed": ro["landed"], "calls": calls, "worked": worked,
		"fix": str(lv.get("fix", "")), "habits_paid": paid, "fix_came": fix_came, "adapt": lv.get("adapt", {}),
		"fix_hold": Exchanges.uptake(float((f.get("personality", {}) as Dictionary).get("coachability", 55.0)), 0) * FighterProfile.trust(f), "start": lv.get("start", {}),
		"talk": str(lv.get("talk_kind", "")), "setup": (lv.get("setup", {}) as Dictionary).duplicate(),
		"arrows": PlanFight.tally(exs), "plan": (fb.get("arrows", []) as Array).duplicate(true),
		"hurt_at_bell": bool(exs[-1].get("after", {}).get("hurt", [false, false])[0]) if not exs.is_empty() else false}


## The habits the corner can fix before the next round: [{id, name, paid (times this round)}]. r = the closed round.
static func fixes(f: Dictionary, r: Dictionary) -> Array:
	var out: Array = []
	var paid: Dictionary = r.get("habits_paid", {})
	for h in HabitFix.offers(f.get("habits", []), f.get("notes_seen", [])):
		out.append({"id": h, "name": habit_name(h), "paid": int(paid.get(h, 0))})
	return out


static var _names := {}


## A habit's name from Kalli's bank ("Drops the right after the jab"); the id when the bank lacks it.
static func habit_name(id: String) -> String:
	if _names.is_empty() and FileAccess.file_exists(HABITS_PATH):
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH))
		for row in (data as Dictionary).get("habits", []) if data is Dictionary else []:
			_names[str(row.get("id", ""))] = str(row.get("name", ""))
	return str(_names.get(id, id.replace("_", " ").capitalize()))


## Plays the rest of the open round with no shouts (the corner's plan). Returns the closed round.
static func finish(c: Career, f: Dictionary, m: Dictionary) -> Dictionary:
	var r := {}
	while not live(m).is_empty():
		r = exchange(c, f, m, "")
	return r
