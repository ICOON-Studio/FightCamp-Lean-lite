extends SceneTree
## S442: one amateur bout through the game's own fight-night path (Bouts.accept -> weigh -> BoutNight.fight_step), dumped
## as JSON for the result-page drawing; every value comes from the bout's records or the game's rule modules.
## Usage: --script res://tools/result_dump.gd -- out=<file.json> seed=<offer day> [cf=<fight nights>] [scan=<from>-<to>]
## cf = plan and corner variants replayed on this night and on that many other fight nights (measured); scan = one line a day.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const Region := preload("res://scripts/state/Region.gd")
const AfterFight := preload("res://scripts/state/AfterFight.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const StandDown := preload("res://scripts/rules/StandDown.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

## The written plan: A any time at long range, B for pressing (at mid), C for a counter-puncher (at long). C is the
## wrong answer by PlanFight.ANSWERS: long combinations into a waiting counter-puncher.
const PLAN := [{"move": "1-2"}, {"move": "step_back", "when": "press"}, {"move": "1-2-3", "when": "counter"}]
const LINE_C := 2
const OPP_INDEX := 1   # Data.DIVISIONS.wlw.opponents[1] = Priya Nair, the counter-puncher
const SHOUT_AT := [2, 4]   # the player shouts the corner's read on the 3rd and 5th exchange of each round


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2:
			args[kv[0]] = kv[1]
	var seed_day := int(args.get("seed", "40"))
	if args.has("scan"):
		var se := str(args["scan"]).split("-")
		for d in range(int(se[0]), int(se[1]) + 1):
			var cf := _setup(d)
			var m := _fight(cf[0], cf[1], PLAN, true)
			var rs: Array = m["rounds"]
			var wrong := 0
			for r in rs:
				for x in r["exchanges"]:
					wrong += int(bool(x["planned"]) and str(x["arrow_fit"]) == "wrong")
			print("SCAN %d %s %s cards=%s wrong_uses=%d xwon=%d" % [d, m["outcome"], str(rs.map(func(r): return int(r["won_n"]))),
				str(m["cards"]), wrong, rs.reduce(func(s, r): return s + int(r["won_n"]), 0)])
		quit(0)
		return
	var out := _dump(seed_day)
	var n_cf := int(args.get("cf", "0"))
	if n_cf > 0:
		out["counterfactual"] = _counterfactual(seed_day, n_cf, out)
	var fa := FileAccess.open(str(args.get("out", "user://bout.json")), FileAccess.WRITE)
	fa.store_string(JSON.stringify(out, "  ", false))
	fa.close()
	print("RESULT_DUMP seed=%d outcome=%s cards=%s -> %s" % [seed_day, out["outcome"], str(out["cards"]), args.get("out", "")])
	quit(0)


## A career on the offer day: Lucy alone on the books, the next legal offer (Priya Nair) accepted, weighed in, fight night.
static func _setup(day: int) -> Array:
	var c := Career.quick_start()
	c.seed = 442
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["weight"] = float(f["limit"]) - 0.3   # she holds the class limit (no cut week to model)
	f["opp_index"] = OPP_INDEX
	# S461: the plan's combinations at Sharp - since S450 FIRELEVEL3 a line under Usable (30) never fires, and this bout
	# (drawn S442, when every line fired) fought no plan at all: result_defects_test 2 read "Write a plan" (no line to replace).
	var combos: Dictionary = f.get_or_add("combos", {})
	for a in PLAN:
		var row := StrikeMap.move(str(a["move"]))
		if str(row.get("kind", "")) == "combo":
			combos[str(row["combo"])] = maxf(float(combos.get(str(row["combo"]), 0.0)), 60.0)
	c.day = day
	f["next_offer_day"] = day
	Bouts.day_events(c)
	Bouts.accept(c, str(f["offers"][0]["id"]))
	c.day = int(f["bout"]["day"]) - 1
	Bouts.weigh(c, f)
	c.day = int(f["bout"]["day"])
	return [c, f]


## Fight night on the game's own steps: shouts on SHOUT_AT from the corner's clue (LiveRound.preview "coach"); between rounds
## the coach's read (Exchanges.read) and a habit fix when one is offered (LiveRound.fixes). finish = book the result.
## opts: "open" = the minute's call answers how her rounds open (her file's main game, OppFile.main_game) instead of the
## coach's read of the last round; "push" = Push from the 4th exchange of the last round (the pace option on a shout).
static func _fight(c: Career, f: Dictionary, plan: Array, finish: bool, opts: Dictionary = {}) -> Dictionary:
	f["arrows"] = plan.duplicate(true)
	var m := Bouts.fight_modal(f)
	var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
	BoutNight.fight_step(c, f, m, "start")
	for n in BoutNight.rounds_of(f):
		if n > 0:
			if BoutNight.stopped(m) != "":
				break
			var last: Dictionary = (m["rounds"] as Array)[-1]
			var call := str(Exchanges.MODES[OppFile.main_game(f["bout"]["opp"])]["best"]) if opts.has("open") else str(Exchanges.read(last["exchanges"], names)["call"])
			var act := "corner:" + call
			var top := {}
			for h in LiveRound.fixes(f, last):
				if int(h["paid"]) > int(top.get("paid", 0)):
					top = h
			if not top.is_empty():
				act += "|fix=" + str(top["id"])
			BoutNight.fight_step(c, f, m, act)
		while not LiveRound.live(m).is_empty():
			var pv := LiveRound.preview(f, m)
			var sh := str(pv["coach"]) if SHOUT_AT.has(int(pv["i"])) else ""
			if opts.has("push") and n == BoutNight.rounds_of(f) - 1 and int(pv["i"]) == 3:
				sh += "|pace=push"
			BoutNight.fight_step(c, f, m, "shout:" + sh)
	if finish:
		BoutNight.fight_step(c, f, m, "end")
	else:
		m["outcome"] = BoutNight.outcome_of(f, m)
		m["cards"] = BoutRules.cards_of(m["rounds"])
	return m


static func _table(c: Career, f: Dictionary, name: String) -> Dictionary:
	return RankLine.before(AfterFight.rows(c, f), name, Region.RANK_MIN_WINS)


static func _dump(day: int) -> Dictionary:
	var cf := _setup(day)
	var c: Career = cf[0]
	var f: Dictionary = cf[1]
	var opp: Dictionary = f["bout"]["opp"]
	var rival := c.rival(str(opp["name"]))
	var before := {"record": [int(f["w"]), int(f["l"])], "opp_record": [int(rival["w"]), int(rival["l"])],
		"rank": _table(c, f, str(f["name"])), "opp_rank": _table(c, f, str(opp["name"])), "season": Champs.home_line(c, f),
		"opp_file": OppFile.tells(opp).map(func(t): return (t as Dictionary).merged({"known": OppFile.known(opp, str(t["id"]))})),
		"film": int(f["bout"].get("film", 0))}
	var m := _fight(c, f, PLAN, true)
	var rounds: Array = m["rounds"]
	var after := {"record": [int(f["w"]), int(f["l"])], "opp_record": [int(rival["w"]), int(rival["l"])],
		"rank": _table(c, f, str(f["name"])), "opp_rank": _table(c, f, str(opp["name"])), "season": Champs.home_line(c, f),
		"season_check": Champs.check(c, f)}
	var st := FightStats.of(rounds)
	var sd: Dictionary = f.get("stand_down", {})
	var out := {"seed_offer_day": day, "fight_day": c.day, "fight_date": Clock.fmt(c.day),
		"how": "Career.quick_start, Lucy on the books, Bouts.day_events offer accepted (Bouts.accept), Bouts.weigh, BoutNight.fight_step start/shout/corner/end",
		"fighter": {"name": f["name"], "first": f["first"], "stance": f["stance"], "style": f["style"], "age": f["age"],
			"wc": f["wc"], "habits": f.get("habits", []), "moves": f.get("moves", {}), "combos": f.get("combos", {})},
		"opponent": opp, "before": before, "after": after,
		"plan": _plan_rows(f, opp), "rounds": rounds, "cards": m["cards"], "flip_round": BoutRules.flip_round(rounds),
		"outcome": m["outcome"], "stopped": m.get("stopped", ""), "why": m.get("why", []), "counts": m.get("counts", {}),
		"damage": m.get("damage", {}), "rank_words": m.get("rank_words", ""), "members_lost": m.get("members_lost", 0),
		"fight_why": FightWhy.read(rounds, str(f["first"]), str(opp["first"])), "fight_stats": st,
		"fight_stats_rows": FightStats.rows(st), "plan_record": PlanRecord.summary(rounds),
		"plan_tally": f["bout"].get("plan_tally", {}), "body_report": m.get("body_report", {}),
		"body_change": m.get("body_change", ""), "injury": m.get("injury", ""), "injury_state": f.get("injury", {}),
		"injury_out": Injuries.out(c, f), "stand_down": sd,
		"stand_down_words": StandDown.reason(sd, Clock.fmt(int(sd.get("open_day", 0)))) if not sd.is_empty() else "",
		"aftermath": m.get("aftermath", []), "body_map": m.get("body_map", {}), "tank_why": f["bout"].get("tank_why", ""),
		"stale": f["bout"].get("stale", 0.0)}
	out.merge(_marks(c, f, rounds, m.get("body_map", {})))
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = Exchanges.grade(str(k), LiveRound.values(f))["word"]
	out["call_grades"] = grades   # how well she does each call (the shout bar's Good / OK / Poor)
	out["new_line_options"] = {"mid|loadup": PlanLines.options("mid", "loadup", f.get("moves", {}), f.get("combos", {}))}
	out["drillable"] = {"combo:1-1": PadWeek.drillable(f, "combo:1-1"), "combo:1-2-3": PadWeek.drillable(f, "combo:1-2-3")}
	out["words"] = {"calls": Exchanges.CALLS, "modes": Exchanges.MODES, "edge_word": Exchanges.EDGE_WORD,
		"fit_words": PlanLines.FIT_WORDS, "place_words": PlanLines.PLACE_WORDS, "when_words": FightFlow.WHEN_WORDS,
		"ring_place": RingDuel.PLACE_WORD_CAP, "she_tired": Exchanges.SHE_TIRED, "hurt_at": Exchanges.HURT_AT,
		"bands": {"hurt": BodyMap.HURT, "critical": BodyMap.CRITICAL, "doctor": BodyMap.DOCTOR},
		"landed_bands": Exchanges.LANDED, "sit_words": FightWhy.SIT_WORDS}
	return out


## The three lines as the Playbook shows them, each with its fit against its own situation and the Playbook's options.
static func _plan_rows(f: Dictionary, opp: Dictionary) -> Array:
	var out: Array = []
	var game := Exchanges.favourite(str(opp.get("style", "")))
	for i in PLAN.size():
		var a: Dictionary = PLAN[i]
		var row := StrikeMap.move(str(a["move"]))
		var when := str(a.get("when", ""))
		var sit := PlanLines.sit_for(when, game)
		out.append({"i": i, "letter": "ABC"[i], "move": a["move"], "move_name": row["name"], "place": row["from"],
			"place_words": PlanLines.PLACE_WORDS[row["from"]], "to": row["to"], "when": when,
			"when_words": str(FightFlow.WHEN_WORDS.get(when, "")), "rated_against": sit, "fit": PlanFight.fit(str(a["move"]), sit),
			"can_do": PlanFight.can_do(row, f.get("moves", {})),
			"options": PlanLines.options(str(row["from"]), sit, f.get("moves", {}), f.get("combos", {}))})
	return out


## The bout's marks as BoutMarks.build makes them, per round: body map at each bell, landed by punch, what hit each place.
static func _marks(c: Career, f: Dictionary, rounds: Array, final_map: Dictionary) -> Dictionary:
	var map := BodyMap.fresh()
	var opp: Dictionary = f["bout"]["opp"]
	var south := {"a": str(f.get("stance", "")).to_lower() == "southpaw", "b": str(opp.get("stance", "")).to_lower() == "southpaw"}
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	var won_last := false
	var per_round: Array = []
	var cause := {"a": {}, "b": {}}
	for i in rounds.size():
		var r: Dictionary = rounds[i]
		var ctx := {"n": i + 1, "plan": str(r.get("corner", "")), "a_style": str(f.get("style", "")),
			"b_style": str(opp.get("style", "")), "seed": c.day * 97 + i + 1, "profiles": profiles, "f": f, "opp": opp,
			"names": [str(f.get("first", "")), str(opp.get("first", ""))], "day": c.day, "won_last": won_last}
		var e: Dictionary = r.get("energy", {})
		var exs: Array = r.get("exchanges", [])
		var landed := {"a": {}, "b": {}}
		var per_ex: Array = []
		for k in exs.size():
			for side in ["a", "b"]:
				var e0 := float(e.get(side, 100.0))
				var e1 := float(e.get(side + "_end", e0))
				profiles[side]["energy"] = lerpf(e0, e1, float(k) / Exchanges.EXCHANGES)
				profiles[side]["energy_end"] = lerpf(e0, e1, float(k + 1) / Exchanges.EXCHANGES)
			var beats := ExchangeBeats.build(exs[k], k, r if k == exs.size() - 1 else {}, ctx)
			var cnt := [0, 0]
			for b in beats:
				if not BodyMap.PUNCHES.has(str(b.get("move", ""))) or str(b.get("result", "")) != "lands":
					continue
				var who := str(b["who"])
				cnt[0 if who == "a" else 1] += 1
				landed[who][b["move"]] = int(landed[who].get(b["move"], 0)) + 1
				var def := "b" if who == "a" else "a"
				var was := {}
				for p in BodyMap.PLACES:
					was[p] = BodyMap.value(map, def, p)
				BodyMap.add_beats(map, [b], south)
				for p in BodyMap.PLACES:
					if BodyMap.value(map, def, p) < float(was[p]):
						var key := "%s|%d" % [str(b["move"]), i + 1]
						var pc: Dictionary = cause[def].get_or_add(p, {})
						pc[key] = int(pc.get(key, 0)) + 1
			per_ex.append(cnt)
		BodyMap.end_round(map)
		won_last = bool(r.get("won", false))
		var snap := {"a": {}, "b": {}}
		for side in ["a", "b"]:
			for p in BodyMap.PLACES:
				snap[side][p] = BodyMap.value(map, side, p)
		per_round.append({"n": i + 1, "places": snap, "cuts": {"a": (map["a"]["cuts"] as Dictionary).keys(),
			"b": (map["b"]["cuts"] as Dictionary).keys()}, "landed_by_punch": landed, "beats_landed_per_exchange": per_ex})
	var same := true
	for side in ["a", "b"]:
		for p in BodyMap.PLACES:
			if not final_map.is_empty() and absf(BodyMap.value(final_map, side, p) - BodyMap.value(map, side, p)) > 0.001:
				same = false
	return {"marks_by_round": per_round, "place_causes": cause, "marks_match_body_map": same}


## Plan and corner variants (line C rewritten to the Playbook's top answer, ...) replayed on this night and n other nights.
static func _counterfactual(day: int, n: int, dumped: Dictionary) -> Dictionary:
	var c_row: Dictionary = (dumped["plan"] as Array)[LINE_C]
	var best: Dictionary = (c_row["options"] as Array)[0]
	var rewrite: Array = PLAN.duplicate(true)
	rewrite[LINE_C] = {"move": str(best["id"]), "when": str(c_row["when"])}
	var cut: Array = PLAN.duplicate(true)
	cut.remove_at(LINE_C)
	# A fourth line for the game the fighter lost most (Priya loading up, at mid range): the Playbook's top answer there.
	var load_best: Dictionary = (dumped["new_line_options"]["mid|loadup"] as Array)[0]
	var plus: Array = PLAN.duplicate(true) + [{"move": str(load_best["id"]), "when": "loadup"}]
	var both: Array = rewrite.duplicate(true) + [{"move": str(load_best["id"]), "when": "loadup"}]
	var plans := {"as_written": PLAN, "rewrite_c": rewrite, "no_line_c": cut, "add_loadup_line": plus, "rewrite_c_and_loadup": both,
		"open_call": PLAN, "push_last": PLAN}
	var opt := {"open_call": {"open": true}, "push_last": {"push": true}}
	var same := {}
	for k in plans.keys():
		var s0 := _setup(day)
		var sm := _fight(s0[0], s0[1], plans[k], false, opt.get(k, {}))
		same[k] = {"outcome": sm["outcome"], "cards": sm["cards"], "rounds_won_n": (sm["rounds"] as Array).map(func(r): return int(r["won_n"])),
			"exchanges": (sm["rounds"] as Array).map(func(r): return (r["exchanges"] as Array).map(func(x): return [int(x["won"]), str(x["arrow"]) if bool(x["planned"]) else ""]))}
	# Other fight nights: offer days after this one, one bout per distinct fight night (two offer days can book one night).
	var wins := {}
	for k in plans.keys():
		wins[k] = 0
	var seen := {int(dumped["fight_day"]): true}
	var d := day
	var nights: Array = []
	while nights.size() < n:
		d += 1
		var probe := _setup(d)
		var night := int((probe[0] as Career).day)
		if seen.has(night):
			continue
		seen[night] = true
		nights.append(night)
		for k in plans.keys():
			var s := _setup(d) if k != "as_written" else probe
			wins[k] = int(wins[k]) + int(str(_fight(s[0], s[1], plans[k], false, opt.get(k, {}))["outcome"]) == "win")
	return {"measured": true, "options": opt, "rewrite_move": best["id"], "rewrite_name": best["name"], "rewrite_fit": best["fit"],
		"loadup_move": load_best["id"], "loadup_name": load_best["name"], "loadup_fit": load_best["fit"],
		"plans": plans, "same_bout": same, "n": n, "fight_nights": [nights[0], nights[-1]], "wins": wins,
		"note": "Same opponent, same corner policy, one bout per fight night; only the plan changes. Wins out of n bouts."}
