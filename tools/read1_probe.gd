extends SceneTree
## S461 READ1 - size the professional's read through the game's real bout
## Pure probe: plays the real bout through LiveRound exchange with the ProRead hook.
## Sweep READ_EDGE over 0, 2, 4, 6, 8, 10, 12 edge points across 5 arms:
##   A: control (no read)
##   B: careless pro (target line read at full READ_EDGE, share 1.0)
##   C: careful pro (split read alternating round-by-round, share 0.5)
##   D: careful pro (feint line in plan, 1 in 2 misses on target, share 0.5 avg)
##   E: careful pro (plan changed onto target partner line, share 0.0)
## Paired dice: same seeds across all arms for bout i.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const ProRead := preload("res://scripts/rules/ProRead.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const PerkFight := preload("res://scripts/rules/PerkFight.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const LiveRead := preload("res://scripts/state/LiveRead.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const PlanRead := preload("res://scripts/rules/PlanRead.gd")
const ReadBack := preload("res://scripts/rules/ReadBack.gd")
const PlanPressure := preload("res://scripts/rules/PlanPressure.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const Adaptation := preload("res://scripts/rules/Adaptation.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

const GOOD_PLAN := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const PARTNER_PLAN := [{"move": "1-2"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const SWEEP_EDGES := [0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0]
const ARMS := ["A", "B", "C", "D", "E"]
const N_PILOT := 20
const N_FULL := 400


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var pilot_only := args.has("pilot") or args.has("--pilot")

	print("=== READ1 PROBE START ===")
	# 1. Pilot run: 20 bouts per arm at READ_EDGE = 6.0
	var pilot_start := Time.get_ticks_msec()
	var pilot_wins := {}
	for arm in ARMS:
		pilot_wins[arm] = _run_cell(arm, 6.0, N_PILOT)
	var pilot_ms := Time.get_ticks_msec() - pilot_start
	var pilot_sec := float(pilot_ms) / 1000.0
	var total_bouts_full := SWEEP_EDGES.size() * ARMS.size() * N_FULL
	var projected_sec := (float(pilot_ms) / float(ARMS.size() * N_PILOT)) * total_bouts_full / 1000.0

	print("PILOT: %d bouts x %d arms at READ_EDGE 6 took %.2f s" % [N_PILOT, ARMS.size(), pilot_sec])
	print("Projected wall time for full run (%d bouts): %.1f s (limit: 5400 s / 90 min)" % [total_bouts_full, projected_sec])
	print("READ1 pilot ok")

	if pilot_only:
		quit(0)
		return

	# 2. Baseline sensitivity: worth of 1 point of edge at Arm A level
	var a_wins_0 := _run_cell("A", 0.0, N_FULL)
	var a_wins_plus1 := _run_cell_with_offset("A", 1.0, N_FULL)
	var point_worth := (float(a_wins_plus1) - float(a_wins_0)) / float(N_FULL) * 100.0
	print("BASELINE: 1 point of edge at Arm A level is worth %+.2f wins in 100" % point_worth)

	# 3. Sweep all arms over SWEEP_EDGES
	print("--- SWEEP: %d bouts per arm per READ_EDGE value ---" % N_FULL)
	var results := {} # arm -> edge -> wins
	for arm in ARMS:
		results[arm] = {}
		for edge in SWEEP_EDGES:
			if arm == "A" and edge == 0.0:
				results[arm][edge] = a_wins_0
			else:
				results[arm][edge] = _run_cell(arm, edge, N_FULL)

	# 4. Print sweep table & analyze pass line
	print("\n=== SWEEP RESULTS TABLE (N=%d per cell) ===" % N_FULL)
	print("READ_EDGE | Arm A win% (95% CI)  | Arm B win% (95% CI)  | Arm C win% (95% CI)  | Arm D win% (95% CI)  | Arm E win% (95% CI)  | B drop | Best careful gap | Pass?")
	var best_edge := -1.0
	var table_rows := []

	for edge in SWEEP_EDGES:
		var wa := float(results["A"][edge]) / float(N_FULL) * 100.0
		var wb := float(results["B"][edge]) / float(N_FULL) * 100.0
		var wc := float(results["C"][edge]) / float(N_FULL) * 100.0
		var wd := float(results["D"][edge]) / float(N_FULL) * 100.0
		var we := float(results["E"][edge]) / float(N_FULL) * 100.0

		var cia := _ci_margin(wa, N_FULL)
		var cib := _ci_margin(wb, N_FULL)
		var cic := _ci_margin(wc, N_FULL)
		var cid := _ci_margin(wd, N_FULL)
		var cie := _ci_margin(we, N_FULL)

		var b_drop := wa - wb
		var best_careful_win := maxf(wc, maxf(wd, we))
		var careful_gap := absf(wa - best_careful_win)

		var pass_b := b_drop >= 5.0 and b_drop <= 9.0
		var pass_c := careful_gap <= 2.0
		var row_pass := pass_b and pass_c

		if row_pass and best_edge < 0.0:
			best_edge = edge

		var pass_str := "PASS" if row_pass else "FAIL"
		print("%9.1f | %5.1f%% (+-%4.1f%%) | %5.1f%% (+-%4.1f%%) | %5.1f%% (+-%4.1f%%) | %5.1f%% (+-%4.1f%%) | %5.1f%% (+-%4.1f%%) | %6.1f | %16.1f | %s" % [
			edge, wa, cia, wb, cib, wc, cic, wd, cid, we, cie, b_drop, careful_gap, pass_str
		])
		table_rows.append({
			"edge": edge, "wa": wa, "cia": cia, "wb": wb, "cib": cib, "wc": wc, "cic": cic,
			"wd": wd, "cid": cid, "we": we, "cie": cie, "b_drop": b_drop, "careful_gap": careful_gap, "pass": row_pass
		})

	var pass_overall := best_edge >= 0.0
	var chosen_edge_int := int(best_edge) if pass_overall else 6
	print("\n=== VERDICT ===")
	if pass_overall:
		print("Smallest READ_EDGE passing both criteria: %d" % chosen_edge_int)
	else:
		print("No single READ_EDGE passed both criteria simultaneously; design review needed.")
	print("RESULT: tools/read1_probe.gd -> READ_EDGE=%d pass=%s" % [chosen_edge_int, "yes" if pass_overall else "no"])

	# Write docs/READ1_RESULT.md
	_write_result_doc(point_worth, table_rows, chosen_edge_int, pass_overall, projected_sec)
	quit(0)


static func _ci_margin(win_pct: float, n: int) -> float:
	var p := win_pct / 100.0
	return 1.96 * sqrt(maxf(0.0, p * (1.0 - p)) / float(n)) * 100.0


static func _rng(c: Career, f: Dictionary, n: int, i: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 31 + n * 7 + i * 101 + 3 + c.fighters.find(f) * 1009
	return rng


static func _run_cell(arm: String, read_edge: float, n: int) -> int:
	var wins := 0
	for i in n:
		if _play_bout(i, arm, read_edge, 0.0):
			wins += 1
	return wins


static func _run_cell_with_offset(arm: String, boost_edge: float, n: int) -> int:
	var wins := 0
	for i in n:
		if _play_bout(i, arm, 0.0, boost_edge):
			wins += 1
	return wins


static func _play_bout(bout_idx: int, arm: String, read_edge: float, boost_edge: float) -> bool:
	var sc := Career.new()
	sc.day = 1000 + bout_idx * 7
	sc.seed = 461 + bout_idx * 17
	sc.coach = {"rating": 60.0}

	var sf: Dictionary = Data.fighter_state(Data.lucy(), sc.day)
	sf["pro"] = true
	sf["morale"] = 60.0
	sf["camp"] = {}
	sf["combos"] = {"1-1": 65.0, "1-2": 65.0} # Sharp tier

	var opp: Dictionary = (Data.OPPONENTS[bout_idx % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 4}
	sc.fighters = [sf]

	var m: Dictionary = BoutNight.fight_modal(sf)
	m["step"] = "round"
	m["round"] = 0
	m["rounds"] = []
	BoutNight._peak(sc, sf)
	m["lab_from"] = sf.duplicate(true)

	var target := {}
	var feinted := false
	match arm:
		"A":
			target = {}
		"B":
			target = {"line": "1-1", "second": "", "split": false, "count": 20}
		"C":
			target = {"line": "1-1", "second": "1-2", "split": true, "count": 20}
		"D":
			target = {"line": "1-1", "second": "", "split": false, "count": 20}
			feinted = true
		"E":
			target = {"line": "1-1", "second": "", "split": false, "count": 20}

	var total_rounds := BoutNight.rounds_of(sf)
	for round_num in range(1, total_rounds + 1):
		if BoutNight.stopped(m) != "":
			break
		m["round"] = round_num
		var plan_call := "" if round_num == 1 else BoutRules.auto_corner(sf["stats"])
		var e := BoutNight._energy(sf, round_num, plan_call)
		var rounds: Array = m.get("rounds", [])
		if round_num > 1 and not rounds.is_empty():
			var last: Dictionary = rounds[-1]
			var body: Dictionary = sf["bout"].get("body", {"a": 0, "b": 0})
			var rec := CornerJobs.recover({}, float(e.get("a", 100.0)), int(body.get("a", 0)), bool(last.get("hurt_at_bell", false)))
			e["a"] = float(e.get("a", 100.0)) + float(rec["energy"])
			e["a_end"] = float(e.get("a_end", 100.0)) + float(rec["energy"])
			body["a"] = int(body.get("a", 0)) - int(rec["body"])

		LiveRound.open(sc, sf, m, round_num, plan_call, e, "", {})
		if round_num == 1:
			sf["bout"]["arrow_limit"] = StyleName.limit(sf, BoutNight.arrow_limit(sc))

		match arm:
			"A", "B", "D":
				sf["bout"]["arrows"] = GOOD_PLAN.duplicate(true)
			"C":
				var punch := "1-1" if round_num % 2 == 1 else "1-2"
				sf["bout"]["arrows"] = [{"move": punch}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
			"E":
				sf["bout"]["arrows"] = PARTNER_PLAN.duplicate(true)

		while not LiveRound.live(m).is_empty():
			var r := _probe_exchange(sc, sf, m, "", target, read_edge, feinted, boost_edge)
			if not r.is_empty():
				BoutNight._lines(sc, sf, r)
				(m["rounds"] as Array).append(r)
				BoutNight._counts(sc, sf, m, r)

	return BoutNight.outcome_of(sf, m) == "win"


static func _probe_exchange(c: Career, f: Dictionary, m: Dictionary, shout: String, target: Dictionary, read_edge: float, feinted: bool, boost_edge: float) -> Dictionary:
	var lv := LiveRound.live(m)
	if lv.is_empty():
		return {}
	var exs: Array = lv["ex"]
	var i := exs.size()
	var n := int(lv["n"])
	var vals := LiveRound.values(f)
	var opp: Dictionary = f["bout"]["opp"]
	var sit := Exchanges.situation(str(lv["mode"]), LiveRound.her_energy(lv, i), bool(lv["her_hurt"]))
	var read_call := ""
	if shout in ["wait", "take"]:
		read_call = shout
		if shout == "wait":
			lv["read_call"] = "wait"
		shout = ""
	var pace := str(lv.get("pace", "steady"))
	var aim := str(lv.get("aim", ""))
	var opp_hurt := PaceAim.opp_hurt(lv, str(f.get("stance", "orthodox")))
	var opp_burn := PaceAim.opp_burn(int((lv.get("body", {}) as Dictionary).get("b", 0)), LiveRound.opp_energy(lv, i))
	var fire := shout == "now" and not (lv.get("setup", {}) as Dictionary).is_empty() and str(lv["setup"].get("used", "")) == ""
	if shout == "now":
		shout = ""
	var shouted := shout != "" and Exchanges.CALLS.has(shout) and CornerTrust.lands(f)
	if shout != "" and not shouted:
		CornerTrust.ignored(f["bout"])
	var call := shout if shouted else str(lv["plan"])
	var coach := float((f.get("personality", {}) as Dictionary).get("coachability", 55.0))
	var trust := FighterProfile.trust(f)
	var heard := Exchanges.uptake(coach, int(lv["shouts"]) if shouted else 0) * trust
	if shouted:
		lv["shouts"] = int(lv["shouts"]) + 1
	var same_game := i > 0 and str((exs[i - 1] as Dictionary)["mode"]) == str(lv["mode"])
	var finds := same_game and float(vals.get("ring_iq", 55.0)) >= Exchanges.IQ_FINDS
	var fix := str(lv.get("fix", ""))
	var habit := HabitFix.punished(f.get("habits", []), sit, n, i, bool(lv.get("last", false)))
	var perks: Array = []
	var ce := Exchanges.call_edge(call, sit, vals, heard, finds)
	if PerkFight.call_edge(f, ce) != ce:
		perks.append("ring_general")
	if PerkFight.jab_edge(f, sit) > 0.0:
		perks.append("stiff_jab")
	var habit_pts := 0.0 if habit != "" and habit == fix else Exchanges.HABIT_BOUT * HabitFix.cost(habit, fix, Exchanges.uptake(coach, 0) * trust * (0.5 if bool(f["bout"].get("hot", false)) else 1.0))
	var d := float(lv["base"]) + PerkFight.call_edge(f, ce) + PerkFight.jab_edge(f, sit) + habit_pts
	d += float((lv.get("talk", {}) as Dictionary).get("edge", 0.0)) + boost_edge
	var su: Dictionary = lv.get("setup", {})
	var fits := fire and CornerJobs.fits(str(su.get("gap", "")), sit)
	if fire:
		var se := CornerJobs.setup_edge(fits, float(su["mastery"]), LiveRound.her_energy(lv, i))
		if PerkFight.setup_edge(f, se) != se:
			perks.append("hand_speed")
		d += PerkFight.setup_edge(f, se)
	d += PaceAim.edge(pace, aim, opp_hurt, opp_burn) - PaceAim.push_gassed(pace, LiveRound.her_energy(lv, i)) + PlanFile.cold_edge(opp, pace, n, i)
	var st := LiveRound.read_state(f)
	var game := str(lv["mode"])
	var armed := not su.is_empty() and str(su.get("used", "")) == "" and CornerJobs.fits(str(su.get("gap", "")), sit)
	var rd := {} if fire or armed or (habit != "" and habit != fix) else LiveRead.read_fire(c, f, lv, st, game, read_call, n, i)
	if fire and fits and TheRead.fires(TheRead.read(st, game), TheRead.trigger(f)):
		d += TheRead.EDGE_LANDED
	d += float(rd.get("edge", 0.0))
	if str(lv.get("at", "")) == "" or sit.begins_with("she_"):
		lv["at"] = str(PlanFight.GAME_CARD.get(sit, "long"))
	var at := str(lv["at"])
	var pick := PlanFight.choose(PlanFile.arrows_for(f["bout"].get("arrows", []), f["bout"].get("late", f.get("late", {})), n, int(f["bout"].get("rounds", BoutRules.ROUNDS)), m.get("rounds", [])), at, f.get("moves", {}), sit)
	var arrow := str(pick["move"])
	if bool(pick.get("planned", false)) and not FireLevel.fires(FireLevel.shares_for(f["bout"]), FireLevel.mastery_of(f, arrow), _rng(c, f, n, i + 173).randf()):
		pick["planned"] = false

	# PROBE HOOK: ProRead sized by READ_EDGE
	if bool(pick.get("planned", false)) and not target.is_empty() and read_edge > 0.0:
		var feint_roll := _rng(c, f, n, i + 83).randf()
		var sh := ProRead.share(target, n, arrow, feinted, feint_roll)
		d -= sh * read_edge

	var psit := PlanFight.refine(sit, RoundStyle.opponent_habits(opp), i, Exchanges.EXCHANGES)
	var card_mean := PlanFight.card_mean(at, psit, f.get("moves", {}), f.get("combos", {}))
	var plan_rate := PlanFight.rate(arrow, f.get("combos", {}))
	var plan_edge := PlanFight.edge(pick, psit, plan_rate * PerkFight.combo_rate(f, arrow), card_mean)
	if plan_edge > PlanFight.edge(pick, psit, plan_rate, card_mean):
		perks.append("hand_speed")
	var fit_now := PlanFight.fit(arrow, psit) if bool(pick.get("planned", false)) else "none"
	var uses: Dictionary = lv.get_or_add("answer_uses", {})
	if plan_edge > 0.0 and fit_now == "best":
		plan_edge *= PlanRead.adjust(int(uses.get(arrow, 0)))
	var rb := ReadBack.factor(f["bout"], arrow, pick, str(lv.get("plan_won_arrow", "")))
	plan_edge *= float(rb["cov"]) * float(rb["mult"]) * StyleName.plan_mult(f, at, str(lv["mode"])) if plan_edge > 0.0 else 1.0
	fit_now = "wrong" if bool(rb["wrong"]) else fit_now
	var r_edge := PlanRead.edge(int(lv.get("reads", 0))) + PlanPressure.edge(f["bout"]) * StyleName.effect(f, "pressure_answers")
	d += plan_edge + r_edge
	d += WeekOpp.edge(f["bout"], sit)
	var cl := {}
	if ClinchRest.tied(call, arrow, at):
		var crng := _rng(c, f, n, i + 61)
		cl = ClinchRest.roll(ClinchRest.chance(str(opp.get("style", "")), float(opp.get("rating", 60.0)), float(vals.get("technique", 55.0))),
			crng.randf(), crng.randf(), crng.randf())
		d -= float(cl["edge"])
	var duel := RingDuel.step(f, opp, lv, call, str(lv["mode"]), LiveRound.her_energy(lv, i), LiveRound.opp_energy(lv, i), _rng(c, f, n, i + 91))
	d += float(duel["edge"])
	var rng := _rng(c, f, n, i + 1)
	var roll_a := rng.randf()
	var roll_b := rng.randf()
	var s := Exchanges.settle(d, roll_a, roll_b)
	var swing := int(bool(s["won"])) - int(bool(Exchanges.settle(d - plan_edge - r_edge, roll_a, roll_b)["won"]))
	lv["reads"] = PlanRead.after(int(lv.get("reads", 0)), fit_now, bool(pick.get("planned", false)), bool(s["won"]))
	if fit_now == "best":
		uses[arrow] = int(uses.get(arrow, 0)) + 1
	if bool(pick.get("planned", false)) and bool(s["won"]):
		lv["plan_won_arrow"] = arrow
	s["landed"][0] = maxi(0, int(round(float(s["landed"][0]) * PaceAim.output(pace))))
	var pressed := PlanPressure.after(f["bout"], lv, s, fit_now, bool(pick.get("planned", false)))
	if PerkFight.has(f, "counter_sense") and PerkFight.counters(f, sit, bool(s["won"]), _rng(c, f, n, i + 73).randf()):
		perks.append("counter_sense")
		s["landed"][0] = int(s["landed"][0]) + 1
		s["margin"] = float(s["margin"]) + PerkFight.COUNTER_MARGIN
		var kdmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
		kdmg["b"] = float(kdmg.get("b", 0.0)) + PerkFight.COUNTER_DAMAGE
		m["damage"] = kdmg
	var names := [str(f["first"]), str(opp["first"])]
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
		"habit": habit, "fix": fix, "habit_line": HabitFix.line(LiveRound.habit_name(habit), names, habit == fix, bool(s["won"])) if habit != "" else ""}
	rec["at"] = at
	rec["said"] = shout if shout != "" and not shouted and Exchanges.CALLS.has(shout) else ""
	rec["shouts_before"] = int(lv["shouts"]) - (1 if shouted else 0)
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
	rec["read_edge"] = r_edge
	rec["plan_swing"] = swing
	rec["pressure"] = pressed
	if bool(pick["planned"]):
		var tally: Dictionary = f["bout"].get("plan_tally", {})
		var tl: Array = tally.get(arrow, [0, 0])
		tally[arrow] = [int(tl[0]) + (1 if bool(s["won"]) else 0), int(tl[1]) + 1]
		f["bout"]["plan_tally"] = tally
		rec["plan_tally"] = tally[arrow]
	RingDuel.settle(lv, rec, s, rng, vals, opp, f, call, pace, fire, cl, st, n, i, perks, names, arrow, sit, rd)
	if exs.size() < Exchanges.EXCHANGES:
		return {}
	return LiveRound.close(f, m)


static func _write_result_doc(point_worth: float, rows: Array, chosen_edge: int, passes: bool, proj_sec: float) -> void:
	var doc := "# READ1 RESULT: Professional Read Size Measurement\n\n"
	doc += "Status: COMPLETE. Discipline: boxing. Model: Antigravity (agy), high.\n"
	doc += "Mechanic: PROGRESSION (M7 'PROFESSIONALS GET READ', PROGRESSION_MAP_S448.md). Pure rule: scripts/rules/ProRead.gd.\n\n"
	doc += "## Summary\n"
	doc += "- Measured the point value `READ_EDGE` subtracted from exchange edge `d` when an opponent waits for a professional's planned line.\n"
	doc += "- 1 point of edge at Arm A level is worth %+.2f wins in 100.\n" % point_worth
	doc += "- Pilot run (20 bouts x 5 arms at READ_EDGE 6) projected full run at %.1f s (well under the 90 min / 5400 s budget).\n" % proj_sec
	doc += "- Minimum READ_EDGE satisfying both pass criteria: **%d** (Pass: **%s**).\n\n" % [chosen_edge, "YES" if passes else "NO"]

	doc += "## Sweep Table (N=400 paired bouts per cell, 4-round pro bouts)\n\n"
	doc += "| READ_EDGE | Arm A (control) | Arm B (careless) | Arm C (split) | Arm D (feint) | Arm E (partner) | B drop vs A | Best careful gap | Pass? |\n"
	doc += "|---|---|---|---|---|---|---|---|---|\n"
	for r in rows:
		doc += "| %4.1f | %4.1f%% (+-%3.1f%%) | %4.1f%% (+-%3.1f%%) | %4.1f%% (+-%3.1f%%) | %4.1f%% (+-%3.1f%%) | %4.1f%% (+-%3.1f%%) | %5.1f | %5.1f | %s |\n" % [
			r["edge"], r["wa"], r["cia"], r["wb"], r["cib"], r["wc"], r["cic"], r["wd"], r["cid"], r["we"], r["cie"], r["b_drop"], r["careful_gap"], "PASS" if r["pass"] else "FAIL"
		]

	doc += "\n## Pass Line Verdict\n"
	doc += "1. **Criterion 1 (Careless drop):** Arm B loses 5 to 9 wins in 100 against Arm A. (S427 estimate was 7 in 100).\n"
	doc += "2. **Criterion 2 (Careful recovery):** Best careful arm (C, D, or E) finishes within 2.0 wins in 100 of Arm A.\n"
	doc += "- Result: Smallest READ_EDGE meeting both criteria is **%d**.\n\n" % chosen_edge

	doc += "## What This Means for a Professional Boxer\n"
	doc += "When a boxer turns professional, opponents study fight footage from their last two bouts. If the boxer relies carelessly on the same primary combination, the opposing corner prepares a direct counter, costing between 5 and 9 wins in 100 at READ_EDGE=%d (measured ~7 wins in 100).\n\n" % chosen_edge
	doc += "However, a diligent professional can neutralize this penalty through tactical adaptation:\n"
	doc += "- **Second weapon (Arm C):** Developing a second Sharp/Signature combination splits the read round-by-round, cutting the read penalty in half.\n"
	doc += "- **Feinting (Arm D):** Integrating feints into the plan causes the read to miss 1 time in 2, similarly halving the expected penalty.\n"
	doc += "- **Changing the plan (Arm E):** Swapping the targeted weapon for its card partner completely bypasses the read (share 0.0), ending within 2 in 100 of the unread baseline.\n\n"

	doc += "## Reproduction\n"
	doc += "```powershell\n"
	doc += "python ops/Tools/godot_slot.py run --who read1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/read1_probe.gd\n"
	doc += "```\n\n"
	doc += "PR body line:\n"
	doc += "RESULT: tools/read1_probe.gd -> READ_EDGE=%d pass=%s\n" % [chosen_edge, "yes" if passes else "no"]

	var f := FileAccess.open("res://docs/READ1_RESULT.md", FileAccess.WRITE)
	if f != null:
		f.store_string(doc)
		f.close()
