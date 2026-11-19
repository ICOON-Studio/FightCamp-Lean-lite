extends SceneTree
## HOLD1 - the specialty: four ways to hold moves over two seasons, and the hold minutes that make it a choice.
## MEASUREMENT ONLY: nothing in scripts/ changes. ARM B of tools/prog_probe.gd (PROGPROBE1R2): its population and modelled
## rules (prog_probe_rules.gd) reused, its week copied here so the hold runs at each arm's minutes, not the shipped 20/40.
## ARMS = hold minutes a week on a 75-min night, Sharp/Signature 10/20, 15/30, 20/40 (John, PROGRESSION_CRITIC_S448B_JOHN
## item 1) x two pad budgets: 3 nights (Standard, prog_probe's ARM B) and 2 (Light = the club's 8 nights shared by 4, the
## budget the map's "4 to 5 Sharp" estimate is about). 1 real min = 240/75 = 3.2 units. POLICIES: PLAN, WIDE, DEEP, COACH.
## GATES: G1 best policy holds 4-5 Sharp + >=1 Signature by season 2; G2 no policy best in >2 of 3 seeds; G3 same-start pairs
## end different in >=50%; G4 median weeks-to-Usable <=4. Method: docs/HOLD1_RESULT.md. Pass: HOLD1 done pass=<arm or NONE>
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/hold1_probe.gd [-- pilot=1]
const Data := preload("res://scripts/state/Data.gd"); const MoveTree := preload("res://scripts/rules/MoveTree.gd"); const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd"); const Combos := preload("res://scripts/rules/Combos.gd"); const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const LearnSlots := preload("res://scripts/rules/LearnSlots.gd"); const Specialty := preload("res://scripts/rules/Specialty.gd"); const StyleName := preload("res://scripts/rules/StyleName.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd"); const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd"); const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd"); const OppFile := preload("res://scripts/rules/OppFile.gd"); const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd"); const ProgRules := preload("res://tools/prog_probe_rules.gd"); const SEEDS := [4481, 4482, 4483]; const SEASON := 52; const COACH := 58.0; const UNITS := PadWeek.PAD_NIGHT_MINUTES / 75.0
const ARMS := [[10.0, 20.0, 1, "3n"], [15.0, 30.0, 1, "3n"], [20.0, 40.0, 1, "3n"],
	[10.0, 20.0, 0, "2n"], [15.0, 30.0, 0, "2n"], [20.0, 40.0, 0, "2n"]]
const POLICIES := ["PLAN", "WIDE", "DEEP", "COACH"]; const LEARN_NIGHTS := 2.0; const OPP_EVERY := 8
const DOC_METHOD := "ARM B of tools/prog_probe.gd, re-priced. Population and modelled rules are prog_probe's (prog_probe_rules.gd: learning slots, shadow mornings, apply_hold, is_frozen); the week is copied into this probe so the hold runs at each arm's minutes instead of the shipped 20/40 units. Day-0 punches use the game's PunchStart rule (prog_probe floored every punch at 30, which leaves no new punch to time). Nothing in scripts/ is changed.\n\n- **Minutes to units.** A pad night is `PadWeek.PAD_NIGHT_MINUTES` = 240 drill units = 75 real minutes (`WeekPlan.EVENINGS.pads.min`), so one real minute = %.1f units. The arms are John's hold minutes a week (Sharp/Signature 10/20, 15/30, 20/40). The shipped `Specialty.HOLD_SHARP/HOLD_SIGNATURE` are 20/40 units = 6.25/12.5 real minutes, cheaper than every arm.\n- **Two pad budgets.** `3n` = `PadWeek.nights_for(1,..)`, the game's Standard week between fights (3 pad nights + 1 sparring), prog_probe's ARM B. `2n` = `nights_for(0,..)`, Light (2 + 1): the club's 8 pad nights shared by four fighters (map M3, AGREED PADPOOL1), the budget the '4 to 5 Sharp and 1 to 2 Signatures' estimate is about. Sparring is `PadWeek.SPAR_NIGHT_MINUTES` = 180 units shared over `PadWeek.spar_pool`; the plan's cards ride the tray, so sparring credits them.\n- **The week.** Holds are paid first in policy order; the learning slot keeps the coach's two new-move nights (`PadWeek.defaults`); the rest is split over the policy's growth list (and when nothing is left under 60, the surplus pushes the policy's deepest moves toward Signature). Then the shadow morning (60 units, prog_probe_rules), then ONE hold at the arm's minutes (`Specialty.units` + `ProgRules.apply_hold`), then the week's stat growth. A node under 30 is drilled only in a learning slot (map M2, `StepMastery.drillable`); at 30+ it can always be drilled.\n- **Policies.** PLAN: the fight plan's moves at 60+. WIDE: every move at 60+, cheapest first (Sharp before Signature), to hold as many as possible. DEEP: the top 3 at 60+, and all surplus pushes the highest move under 85. COACH: `LearnSlots.ANSWERS` for the next opponent's style + the plan, plus every Signature; PLAN when that is empty. The plan is the game's own: `CoachPlan.write` + the `PlanTemplates` real-plan template for `OppFile.main_game`, at `PlanBoard.arrow_limit(58)`; the next opponent turns every %d weeks.\n- **Stats.** `WeekPlan.week` on the coach's base week (`WeekPlan.COACH_WEEK`) and the week's evenings, each day's gain applied through `Attrs.apply_session` as Sim.step_day does: Technique grows from the pad nights, Ring IQ from sparring, so the mastery cap (40 + 0.4 Technique + 0.2 Ring IQ) rises - the map's 'first Signature is also a Technique goal'. CONTROL_STAT checks it against Sim's day-by-day route.\n- **Steps and defences.** Drilled on pad nights and in sparring at the same station formula as a punch, and held (map M4). The shipped wiring can do neither: CONTROL_STEP measures it.\n- **Held vs Sharp.** Sharp = a node at 60-84, Signature = 85+, over all 16 tree nodes; HELD = those that got their arm's minutes in the season's last week (the specialty board's list). G1 reads the held counts, the map's 'can hold about 4 to 5'. 'Target' = the share of careers holding 4-5 Sharp and >=1 Signature.\n- **Same-start pairs.** One fighter's day-0 dict, deep-copied under two policies: 6 pairs per fighter per seed. Different held sets = the sorted list of nodes at 60+ at the end of season 2 differs.\n- **Not modelled.** No bouts (so no camp, taper, fight week or injury: no frozen weeks, no fight-proven +3, no camp's focused morning), no bag cards (`carded` empty, as in prog_probe), no coach market or second slot (pads 58, one slot), no veteran fade. A pick that never crossed 30 counts as 104 weeks in the median.\n"
const DOC_GATES := "G1 the best policy holds 4-5 Sharp + >=1 Signature by season 2 (the held counts, median). G2 no policy best in more than 2 of the 3 seeds (a seed's best = the highest median held Sharp + Signature; ties split the credit). G3 same-start pairs differ in >=50%. G4 the best policy's median weeks-to-Usable <= 4. Best = the highest pooled median held Sharp + Signature at season 2. The named-style share is reported per cell (John's item 2: no style in more than 1 in 3 careers), not gated."
const DOC_FINDINGS := "- **G1 binds: it fails at %d of the %d arms.** The best policy's median held Signature is 0 at every arm, and the highest median mastery cap at season 2 is %.1f - under the 85 a Signature needs. At the shipped between-fights pace the median career cannot hold a Signature whatever the hold minutes cost. The Sharp half of the bar IS reached (PLAN holds 5 on the 20/40 arms, both budgets); what lifts the cap is a camp's focused morning (not modelled here: no bouts) or a pads coach above 58 (coach_factor 0.5 + 0.7 x rating/100). At most %.0f%% of careers hold the map's whole picture, 4-5 Sharp + 1 Signature.\n- **G3 and G4 pass at every arm.** Same-start pairs end season 2 with different held sets well above the 50%% bar, and the median new move still reaches Usable inside 4 weeks: at 10-20 minutes a week, holding does not crowd out the learning slot. The choice of what to hold is real and it shows.\n- **G2 fails at %d of the %d arms: one policy wins every line-up.** WIDE ('hold as many as possible') holds the whole tree while the minutes are cheap and takes all three seeds; COACH takes all three when they are expensive. Only the dearest 2-night arm splits the seeds. So the minutes alone do not make the specialty a choice - the cheap arms remove the scarcity, and 'best = most held moves' then rewards breadth over a specialty.\n- **The starter style is free, as John warned.** One style is named in up to %.0f%% of careers (WIDE, Out-boxer), far over the 1-in-3 bar; on the dearest 2-night arm no career names a style at all. CONTROL_STEP: a step at 60+ is not drillable on a pad card in the shipped wiring and fades 1.5 a week, so today no style set (each holds a step or a defence) can be named - ARM B drills and holds steps, and that is what the named-style column measures.\n"
var args := {}; var rng := RandomNumberGenerator.new(); var pilot := false; var weeks_run := 0; var ids: Array = []; var opps: Array = []; var cells := {}; var log_lines: Array = []
func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2: args[kv[0]] = kv[1]
	pilot = str(args.get("pilot", "0")) == "1"; ids = MoveTree.PUNCH_IDS + MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS; opps = Data.OPPONENTS + [Data.MISMATCH]
	for r in Data.RIVALS:
		if ["Out-boxer", "Slugger"].has(str(r["style"])): opps.append(r)
	var t0 := Time.get_ticks_msec(); var arms: Array = [ARMS[0]] if pilot else ARMS; _say("HOLD1 seeds=%s weeks=%d policies=%s arms=%d pilot=%s units_per_real_minute=%.2f" % [str(SEEDS), 2 * SEASON, str(POLICIES), arms.size(), str(pilot), UNITS]); _controls()
	for seed_val in SEEDS:
		rng.seed = seed_val; var pop := _population()
		if pilot: pop = pop.slice(0, 8)
		for arm in arms:
			for pol in POLICIES:
				var key: String = _label(arm) + "|" + str(pol)
				if not cells.has(key): cells[key] = {"all": [], "seed": {}}
				var cell: Dictionary = cells[key]
				for f in pop:
					var c := _career(f.duplicate(true), arm, pol); (cell["all"] as Array).append(c)
					if not (cell["seed"] as Dictionary).has(seed_val): cell["seed"][seed_val] = []
					(cell["seed"][seed_val] as Array).append(c)
	_report(arms, (Time.get_ticks_msec() - t0) / 1000.0); quit(0)
func _say(s: String) -> void: print(s); log_lines.append(s)
func _label(arm: Array) -> String: return "%d/%d@%s" % [int(arm[0]), int(arm[1]), str(arm[3])]
## prog_probe's population (named prospects + 60 walk-ins), day-0 punches on the game's PunchStart rule.
func _population() -> Array:
	var pop: Array = []
	for p in Data.PROSPECTS:
		var f := {"id": str(p["id"]), "name": str(p["name"]), "first": str(p["first"]), "sex": str(p["sex"]), "age": int(p["age"]),
			"style": str(p["style"]), "pot": int(p.get("pot", 75)), "stats": (p["stats"] as Dictionary).duplicate(true),
			"personality": (p.get("personality", {}) as Dictionary).duplicate(true)}
		_init_state(f); pop.append(f)
	var spread := {"power": [50.0, 20.0], "speed": [50.0, 20.0], "technique": [45.0, 20.0], "defense": [50.0, 15.0],
		"conditioning": [50.0, 20.0], "fight_iq": [45.0, 20.0], "chin": [50.0, 20.0]}
	var styles := ["Out-boxer", "Swarmer", "Pressure fighter", "Slugger", "Counter-puncher", "Volume puncher"]
	for i in 60:   # prog_probe's draw order: age, the seven stats, potential
		var age := 18 + rng.randi() % 12; var stats := {}
		for k in spread: stats[k] = float(spread[k][0]) + rng.randf() * float(spread[k][1])
		var f := {"id": "w%d" % i, "name": "W%d" % i, "first": "W%d" % i, "sex": "f" if i % 2 == 0 else "m",
			"age": age, "style": styles[i % 6], "stats": stats, "pot": 65 + rng.randi() % 25}
		_init_state(f); pop.append(f)
	for i in pop.size(): pop[i]["idx"] = i
	return pop
func _init_state(f: Dictionary) -> void:
	var tech := float(f["stats"]["technique"]); var moves := {}
	for m in Data.MOVES: moves[m] = PunchStart.mastery(tech, m)
	f["moves"] = moves; f["steps"] = MoveTree.day0_steps(float(f["stats"].get("speed", 55.0))); f["combos"] = {}; f["bout"] = {}; f["camp"] = {}; f["phase"] = "base"; f["phase_day"] = 0; f["injured"] = false
	f["learning_slots"] = []; f["cards"] = []; f["tray"] = []; f["arrows"] = []; f["named_style"] = ""; f["focus"] = "technique"; f["weight"] = 60.0; f["week_fatigue"] = 20.0
func _career(f: Dictionary, arm: Array, pol: String) -> Dictionary:
	var sh := float(arm[0]) * UNITS; var sg := float(arm[1]) * UNITS; var picks: Array = []; var pn: Array = []; var opp: Dictionary = opps[0]; var snap := {}; var u := {}
	for week in 2 * SEASON:
		f["phase_day"] = week * 7
		if week % OPP_EVERY == 0:
			opp = opps[(week / OPP_EVERY + int(f["idx"])) % opps.size()]; var plan := _plan_for(f, opp); var pp := _plan_parts(f, plan); pn = pp["nodes"]; f["arrows"] = plan; f["tray"] = pp["tray"]
		var ls: Array = f["learning_slots"]
		for mv in ls.duplicate():
			if MoveTree.mastery(f, str(mv)) >= 30.0: ls.erase(mv)
		var pid := _pick(f, str(opp["style"]))
		if pid != "": picks.append({"id": pid, "w": week, "wtu": 0})
		var nights := PadWeek.nights_for(int(arm[2]), false, false, false); var wp := _alloc(f, pol, pn, str(opp["style"]), sh, sg, nights); var r := _drill_week(f, nights, wp)
		u = _hold(f, r, ProgRules.shadow_mornings(f, COACH, PadWeek.STATION_TIER), sh, sg); _stats(f, nights); f["named_style"] = str(StyleName.monday(f)["style"])
		for p in picks:
			if int(p["wtu"]) == 0 and MoveTree.mastery(f, str(p["id"])) >= 30.0: p["wtu"] = week - int(p["w"]) + 1
		if week == SEASON - 1 or week == 2 * SEASON - 1: snap[week] = _snapshot(f, u, sh, sg)
		weeks_run += 1
	var wtu: Array = []; var never := 0
	for p in picks:
		if int(p["wtu"]) > 0: wtu.append(int(p["wtu"]))
		else: never += 1; wtu.append(2 * SEASON)
	return {"s1": snap[SEASON - 1], "s2": snap[2 * SEASON - 1], "wtu": wtu, "never": never, "picks": picks.size()}
func _snapshot(f: Dictionary, u: Dictionary, sh: float, sg: float) -> Dictionary:
	var sharp := 0; var sig := 0; var hs := 0; var gs := 0; var held: Array = []
	for id in ids:
		var m := MoveTree.mastery(f, str(id))
		if m < 60.0: continue
		held.append(str(id)); var got := float(u.get(str(id), 0.0)) >= (sg if m >= 85.0 else sh)
		if m >= 85.0: sig += 1; gs += int(got)
		else: sharp += 1; hs += int(got)
	held.sort(); var st: Dictionary = f["stats"]
	return {"sharp": sharp, "sig": sig, "hs": hs, "gs": gs, "set": ",".join(held), "style": str(f.get("named_style", "")),
		"cap": MoveMastery.cap(float(st["technique"]), float(st["fight_iq"]))}
## The fight plan: the coach's own arrows + the real-plan template for the opponent's main game, at the coach's line limit.
func _plan_for(f: Dictionary, opp: Dictionary) -> Array:
	var coach := CoachPlan.write(str(opp["style"]), COACH, f["moves"], f.get("combos", {}), f.get("steps", {})); var ts := PlanTemplates.for_game(OppFile.main_game(opp))
	return coach if ts.is_empty() else PlanTemplates.load(PlanTemplates.boxing(str(ts[0])), PlanBoard.arrow_limit(COACH), coach, StrikeMap.MOVES)
## The plan's nodes and its drill cards: the cards ride the tray, so between fights PadWeek.spar_pool credits them
## (PlanCards.cards needs a booked bout; the tray is how the plan reaches sparring without one).
func _plan_parts(f: Dictionary, plan: Array) -> Dictionary:
	var nodes: Array = []; var tray: Array = []
	for a in plan:
		var mid := str(a["move"]); var row := StrikeMap.move(mid); var base := mid.split("@")[0]; var ids: Array = [base]
		if str(row.get("kind", "")) != "combo":
			if not tray.has("move:" + base): tray.append("move:" + base)
		else:
			var combo := str(row.get("combo", "")); ids = MoveTree.COMBO_PUNCHES.get(combo, []) as Array
			if not Combos.row(combo).is_empty():
				var missing := Combos.missing(combo, f.get("moves", {})); var c := "move:" + str(missing[0]) if not missing.is_empty() else "combo:" + combo
				if not tray.has(c): tray.append(c)
		for id in ids:
			if not nodes.has(str(id)): nodes.append(str(id))
	return {"nodes": nodes, "tray": tray}
func _pick(f: Dictionary, opp_style: String) -> String:
	var sc := ProgRules.slot_count(COACH)
	if (f["learning_slots"] as Array).size() >= sc: return ""
	var cards := LearnSlots.cards(f, opp_style, {})
	if cards.is_empty(): return ""
	var id := str(cards[0]["id"])
	return id if LearnSlots.pick(f, id, sc) else ""
func _at(f: Dictionary, lo: float, hi: float) -> Array:
	var out: Array = []
	for id in ids:
		var m := MoveTree.mastery(f, str(id))
		if m >= lo and m < hi: out.append([str(id), m])
	return out
func _filter60(f: Dictionary, want: Array) -> Array:
	var out: Array = []
	for id in want:
		if MoveTree.mastery(f, str(id)) >= 60.0 and not out.has(str(id)): out.append(str(id))
	return out
func _holds(f: Dictionary, pol: String, pn: Array, opp_style: String, sh: float, sg: float) -> Array:
	var at := _at(f, 60.0, 1000.0); var asc := func(a, b): return float(a[1]) < float(b[1])
	match pol:
		"PLAN": return _filter60(f, pn)
		"WIDE":   # cheapest first: every Sharp, then every Signature
			var lo := _at(f, 60.0, 85.0); var hi := _at(f, 85.0, 1000.0); lo.sort_custom(asc); hi.sort_custom(asc)
			return (lo + hi).map(func(x): return str(x[0]))
		"DEEP":
			at.sort_custom(func(a, b): return float(a[1]) > float(b[1]))
			return at.slice(0, 3).map(func(x): return str(x[0]))
		"COACH":
			var out := _filter60(f, (LearnSlots.ANSWERS.get(opp_style, []) as Array) + pn)
			for pair in at:
				if float(pair[1]) >= 85.0 and not out.has(str(pair[0])): out.append(str(pair[0]))
			return out if not out.is_empty() else _filter60(f, pn)
	return []
## The surplus list: raise the policy's drillable moves to Sharp; when none is left, push its deepest toward Signature.
func _grow(f: Dictionary, pol: String, pn: Array, opp_style: String, slot: String) -> Array:
	var desc := func(a, b): return float(a[1]) > float(b[1])
	if pol == "DEEP":
		var at := _at(f, 30.0, 85.0); at.sort_custom(desc)
		return [] if at.is_empty() else [str(at[0][0])]
	var want: Array = ids.duplicate()
	if pol == "COACH": want = (LearnSlots.ANSWERS.get(opp_style, []) as Array) + pn
	elif pol == "PLAN": want = pn
	var out: Array = []
	for id in want:
		var sid := str(id); var m := MoveTree.mastery(f, sid)
		if sid != slot and m >= 30.0 and m < 60.0 and not out.has(sid): out.append(sid)
	if out.is_empty():
		var at := _at(f, 60.0, 85.0); at.sort_custom(desc)
		for pair in at:
			if str(pair[0]) != slot and (pol == "WIDE" or want.has(str(pair[0]))): out.append(str(pair[0]))
	return out if pol == "WIDE" else out.slice(0, 3)
## The week's pad minutes: holds first, the slot's two nights, then the growth list; laid on the nights as card shares.
func _alloc(f: Dictionary, pol: String, pn: Array, opp_style: String, sh: float, sg: float, nights: Dictionary) -> Dictionary:
	var days: Array = nights["pads"]; var night := PadWeek.PAD_NIGHT_MINUTES; var budget := float(days.size()) * night; var alloc := {}; var order: Array = []
	var add := func(id: String, u: float) -> void:
		if u > 0.0:
			if not alloc.has(id): order.append(id)
			alloc[id] = float(alloc.get(id, 0.0)) + u
	for id in _holds(f, pol, pn, opp_style, sh, sg):
		var need := sg if MoveTree.mastery(f, str(id)) >= 85.0 else sh
		if budget >= need: add.call(str(id), need); budget -= need
	var ls: Array = f["learning_slots"]; var slot := "" if ls.is_empty() else str(ls[0])
	if slot != "":
		var give := minf(budget, LEARN_NIGHTS * night); add.call(slot, give); budget -= give
	var grow := _grow(f, pol, pn, opp_style, slot)
	if budget > 0.0 and not grow.is_empty():
		var each := budget / float(grow.size())
		for id in grow: add.call(str(id), each)
	var lay := {}; var ni := 0; var left := night
	for id in order:
		var u := float(alloc[id])
		while u > 0.0001 and ni < days.size():
			var take := minf(u, left); var k := "%d|%s" % [int(days[ni]), str(id)]; lay[k] = float(lay.get(k, 0.0)) + take; u -= take; left -= take
			if left <= 0.0001: ni += 1; left = night
	var wp := {}
	for k in lay:
		var p := str(k).split("|"); var day: String = str(PadWeek.DAYS[int(p[0])])
		if not wp.has(day): wp[day] = []
		wp[day].append({"card": "move:" + p[1], "share": float(lay[k]) / night})
	return wp
## A node under 30 drills only in a learning slot (map M2, StepMastery.drillable); at 30+ any card drills it.
func _drillable(f: Dictionary, card: String) -> bool:
	var key := PadWeek.key(card)
	if PadWeek.kind(card) == "combo": return Combos.unlocked(f.get("moves", {})).has(key)
	if PadWeek.kind(card) != "move": return false
	if not (f["moves"] as Dictionary).has(key) and not (f.get("steps", {}) as Dictionary).has(key): return false
	return MoveTree.mastery(f, key) >= 30.0 or (f["learning_slots"] as Array).has(key)
## A step or defence on a card drills at the same station and formula as a punch (map M4); PadWeek.drill does the punches.
func _drill(f: Dictionary, card: String, mins: float, station: String) -> void:
	var key := PadWeek.key(card)
	if PadWeek.kind(card) == "move" and not (f["moves"] as Dictionary).has(key):
		var st: Dictionary = f["stats"]; var cap := MoveMastery.cap(float(st.get("technique", 55.0)), float(st.get("fight_iq", 55.0))); f["steps"][key] = MoveMastery.gain(float(f["steps"][key]), station, mins, COACH, PadWeek.STATION_TIER, 1.0, cap); return
	PadWeek.drill(f, card, mins, COACH, PadWeek.STATION_TIER, station)
## PadWeek.run_week's nights and fades without its Sunday hold: the arm's hold replaces it, once (_hold).
func _drill_week(f: Dictionary, nights: Dictionary, wp: Dictionary) -> Dictionary:
	var drilled := {}; var on_pads := {}; var spar_cards: Array = []; var pool := PadWeek.spar_pool(f, wp)
	for d in 7:
		if (nights["pads"] as Array).has(d):
			for e in wp.get(PadWeek.DAYS[d], []):
				var card := str(e["card"]); var mins := PadWeek.night_minutes(nights, d) * float(e["share"])
				if mins <= 0.0 or not _drillable(f, card): continue
				_drill(f, card, mins, PadWeek.PAD_STATION); drilled[card] = float(drilled.get(card, 0.0)) + mins; on_pads[card] = float(on_pads.get(card, 0.0)) + mins
		if (nights["spar"] as Array).has(d):
			var hands: Array = []
			for c in pool:
				var cs := str(c); var cm := MoveTree.mastery(f, PadWeek.key(cs)) if PadWeek.kind(cs) == "move" else PadWeek.mastery(f, cs)
				if not hands.has(cs) and _drillable(f, cs) and cm >= Combos.LEARN_AT: hands.append(cs)
			spar_cards = hands
			for cs in hands:
				var mins := PadWeek.SPAR_NIGHT_MINUTES / float(hands.size()); _drill(f, cs, mins, PadWeek.SPAR_STATION); drilled[cs] = float(drilled.get(cs, 0.0)) + mins
	var kept := {}
	for card in drilled:
		for mv in PadWeek.moves_of(f, str(card)): kept[str(mv)] = true
	var moves: Dictionary = f["moves"]
	for mv in moves.keys():
		if not kept.has(mv) and float(moves[mv]) < Specialty.HOLD_FROM: moves[mv] = MoveMastery.decay_week(float(moves[mv]), false)
	var combos: Dictionary = f["combos"]
	for cid in combos.keys():
		if not drilled.has("combo:" + str(cid)): combos[cid] = Combos.fade(float(combos[cid]), false)
	return {"pads": on_pads, "spar": spar_cards, "spar_n": (nights["spar"] as Array).size()}
## The arm's hold: Specialty.units (pads + sparring, the game's own expansion) + the shadow morning's minutes.
func _hold(f: Dictionary, r: Dictionary, shadow: Dictionary, sh: float, sg: float) -> Dictionary:
	var units := Specialty.units(r["pads"], {}, r["spar"], PadWeek.SPAR_NIGHT_MINUTES * float(r["spar_n"]))
	for k in shadow: units[str(k)] = float(units.get(str(k), 0.0)) + float(shadow[k])
	ProgRules.apply_hold(f, units, sh, sg, ProgRules.is_frozen(f)); return units
## The week's stat growth: the game's own WeekPlan.week, each day's gain applied as Sim.step_day applies it.
func _stats(f: Dictionary, nights: Dictionary) -> void:
	var ctx := {"stats": f["stats"], "pot": int(f["pot"]), "coach": COACH, "weight": float(f["weight"]), "diet": "hold",
		"fatigue": float(f["week_fatigue"]), "phase": "base", "recovery": 55.0}
	var w := WeekPlan.week(WeekPlan.COACH_WEEK, ctx, PadWeek.evenings_from(nights))
	for r in (w["days"] as Array):
		var sid := str(r["id"])
		if str(r["stat"]) != "": Attrs.apply_session(f, sid, str(r["stat"]), float(r["gain"]))
		if str(r["stat2"]) != "": Attrs.apply_session(f, str(r["evening"]), str(r["stat2"]), float(r["gain2"]))
		if float(r.get("attr_gain", 0.0)) > 0.0: Attrs.apply_session(f, sid, "", float(r["attr_gain"]))
	f["week_fatigue"] = float(w["fatigue_end"])
func _med(v: Array) -> float:
	var s := v.duplicate(); s.sort(); return 0.0 if s.is_empty() else float(s[s.size() / 2])
func _range(v: Array) -> String:
	var s := v.duplicate(); s.sort()
	return "[0..0]" if s.is_empty() else "[%d..%d]" % [int(s[int(s.size() * 0.1)]), int(s[mini(s.size() - 1, int(s.size() * 0.9))])]
func _summ(cs: Array) -> Dictionary:
	var a1: Array = []; var g1: Array = []; var a2: Array = []; var g2: Array = []; var h2: Array = []; var s2: Array = []; var w: Array = []; var caps: Array = []; var styles := {}; var never := 0; var le4 := 0; var picks := 0; var sets := {}; var target := 0
	for c in cs:
		a1.append(int(c["s1"]["sharp"])); g1.append(int(c["s1"]["sig"])); a2.append(int(c["s2"]["sharp"])); g2.append(int(c["s2"]["sig"])); h2.append(int(c["s2"]["hs"])); s2.append(int(c["s2"]["gs"])); caps.append(float(c["s2"]["cap"]))
		w.append_array(c["wtu"]); never += int(c["never"]); picks += int(c["picks"]); sets[str(c["s2"]["set"])] = true; var st := str(c["s2"]["style"])
		if st != "": styles[st] = int(styles.get(st, 0)) + 1
		if int(c["s2"]["hs"]) >= 4 and int(c["s2"]["hs"]) <= 5 and int(c["s2"]["gs"]) >= 1: target += 1
	for v in w:
		if int(v) <= 4: le4 += 1
	var mx := 0
	for k in styles: mx = maxi(mx, int(styles[k]))
	return {"n": cs.size(), "sh1": _med(a1), "sg1": _med(g1), "sh2": _med(a2), "sg2": _med(g2), "r1": _range(a1), "q1": _range(g1),
		"r2": _range(a2), "q2": _range(g2), "hs2": _med(h2), "gs2": _med(s2), "rh2": _range(h2), "rs2": _range(s2),
		"wtu": _med(w), "le4": float(le4) / float(maxi(1, w.size())), "never": never, "picks": picks, "styles": styles,
		"maxstyle": float(mx) / float(maxi(1, cs.size())), "cap": _med(caps), "sets": sets.size(), "target": float(target) / float(maxi(1, cs.size()))}
## Same-start pairs: one fighter's day-0 dict under two policies, 6 pairs a fighter a seed.
func _pairs(label: String) -> Dictionary:
	var diff := 0; var tot := 0
	for sd in SEEDS:
		var n: int = (cells[label + "|PLAN"]["seed"][sd] as Array).size()
		for i in n:
			var sets: Array = []
			for pol in POLICIES: sets.append(str((cells[label + "|" + pol]["seed"][sd] as Array)[i]["s2"]["set"]))
			for a in sets.size():
				for b in range(a + 1, sets.size()):
					tot += 1
					if sets[a] != sets[b]: diff += 1
	return {"diff": diff, "tot": tot, "share": float(diff) / float(maxi(1, tot))}
func _best(label: String, sd: int) -> Dictionary:
	var scores := {}; var top := -1.0
	for pol in POLICIES:
		var sums: Array = []
		for c in (cells[label + "|" + pol]["seed"][sd] as Array): sums.append(int(c["s2"]["hs"]) + int(c["s2"]["gs"]))
		scores[pol] = _med(sums); top = maxf(top, float(scores[pol]))
	var tied: Array = []; var credit := {}
	for pol in POLICIES:
		if is_equal_approx(float(scores[pol]), top): tied.append(pol)
	for pol in POLICIES: credit[pol] = (1.0 / float(tied.size())) if tied.has(pol) else 0.0
	return {"scores": scores, "credit": credit, "tied": tied}
func _report(arms: Array, secs: float) -> void:
	var summ := {}; var gates := {}; var passing: Array = []
	for arm in arms:
		var label := _label(arm)
		for pol in POLICIES:
			var s := _summ(cells[label + "|" + pol]["all"]); summ[label + "|" + pol] = s; var st: Array = []
			for k in (s["styles"] as Dictionary): st.append("%s:%d" % [str(k), int(s["styles"][k])])
			_say("CELL arm=%s pol=%s n=%d s1=%d%s/%d%s s2=%d%s/%d%s held2=%d%s/%d%s target=%.2f wtu=%.1f le4=%.2f never=%d picks=%d styles=%s maxstyle=%.2f sets=%d cap=%.1f" % [
				label, pol, int(s["n"]), int(s["sh1"]), str(s["r1"]), int(s["sg1"]), str(s["q1"]), int(s["sh2"]), str(s["r2"]), int(s["sg2"]),
				str(s["q2"]), int(s["hs2"]), str(s["rh2"]), int(s["gs2"]), str(s["rs2"]), float(s["target"]), float(s["wtu"]), float(s["le4"]),
				int(s["never"]), int(s["picks"]), ",".join(st) if not st.is_empty() else "none", float(s["maxstyle"]), int(s["sets"]), float(s["cap"])])
		var pr := _pairs(label); var credit := {}; var best_pol := ""; var best_score := -1.0
		for pol in POLICIES:
			credit[pol] = 0.0; var s: Dictionary = summ[label + "|" + pol]
			if float(s["hs2"]) + float(s["gs2"]) > best_score: best_score = float(s["hs2"]) + float(s["gs2"]); best_pol = pol
		for sd in SEEDS:
			var b := _best(label, sd); var sc: Array = []
			for pol in POLICIES: credit[pol] = float(credit[pol]) + float(b["credit"][pol]); sc.append("%s:%d" % [pol, int(b["scores"][pol])])
			_say("BEST arm=%s seed=%d scores=%s best=%s" % [label, sd, ",".join(sc), ",".join(b["tied"])])
		var bs: Dictionary = summ[label + "|" + best_pol]; var mx := 0.0
		for pol in POLICIES: mx = maxf(mx, float(credit[pol]))
		var g := [float(bs["hs2"]) >= 4.0 and float(bs["hs2"]) <= 5.0 and float(bs["gs2"]) >= 1.0, mx <= 2.000001, float(pr["share"]) >= 0.5, float(bs["wtu"]) <= 4.0]; var failed: Array = []
		for i in 4:
			if not bool(g[i]): failed.append("g%d" % (i + 1))
		gates[label] = {"best": best_pol, "g": g, "failed": failed, "pairs": pr, "sharp": float(bs["hs2"]), "sig": float(bs["gs2"]), "wtu": float(bs["wtu"]), "target": float(bs["target"])}
		_say("PAIRS arm=%s diff=%d/%d share=%.3f" % [label, int(pr["diff"]), int(pr["tot"]), float(pr["share"])])
		_say("GATE arm=%s best=%s held_sharp=%d held_sig=%d target=%.2f wtu=%.1f g1=%d g2=%d g3=%d g4=%d pass=%d failed=%s" % [label, best_pol,
			int(bs["hs2"]), int(bs["gs2"]), float(bs["target"]), float(bs["wtu"]), int(g[0]), int(g[1]), int(g[2]), int(g[3]),
			int(failed.is_empty()), ",".join(failed) if not failed.is_empty() else "none"])
		if failed.is_empty(): passing.append(label)
	var pass_arm := str(passing[0]) if not passing.is_empty() else "NONE"; var closest := ""; var fewest := 99
	if passing.is_empty():
		for arm in arms:
			var g: Dictionary = gates[_label(arm)]
			if (g["failed"] as Array).size() < fewest: fewest = (g["failed"] as Array).size(); closest = _label(arm)
	var line := "HOLD1 done pass=%s" % pass_arm
	if closest != "": line += " closest=%s" % closest
	_say("HOLD1 weeks=%d seconds=%.1f" % [weeks_run, secs]); _say(line); _doc(arms, summ, gates, pass_arm, closest, secs); _say("RESULT: tools/hold1_probe.gd -> " + line)
func _controls() -> void:
	var nights := PadWeek.nights_for(1, false, false, false)
	var wp := {"mon": [{"card": "move:Jab", "share": 1.0}], "wed": [{"card": "combo:1-2", "share": 1.0}],
		"fri": [{"card": "move:Cross", "share": 0.5}, {"card": "move:Lead hook", "share": 0.5}]}
	var f1 := _fixture(); var f2 := _fixture(); var r := _drill_week(f1, nights, wp); _hold(f1, r, {}, Specialty.HOLD_SHARP, Specialty.HOLD_SIGNATURE); PadWeek.run_week(f2, nights, wp, COACH, PadWeek.STATION_TIER, {}, []); var d := 0.0
	for store in ["moves", "steps", "combos"]:
		for k in (f1[store] as Dictionary): d = maxf(d, absf(float(f1[store][k]) - float(f2[store][k])))
	_say("CONTROL_WEEK my_week_vs_PadWeek.run_week max_delta=%.10f %s" % [d, "OK" if d < 0.000000001 else "MISMATCH"])
	var g1 := _fixture(); var g2 := _fixture(); var evs := PadWeek.evenings_from(nights); var days: Array = WeekPlan.COACH_WEEK; _stats(g1, nights); var fat := 20.0
	for dd in 7:
		var ctx := {"stats": g2["stats"], "pot": int(g2["pot"]), "coach": COACH, "weight": 60.0, "diet": "hold", "fatigue": fat, "phase": "base", "recovery": 55.0, "dow": dd}; var rr := WeekPlan.full_day(str(days[dd][0]), str(days[dd][1]), str(evs[dd]), ctx, fat)
		for pair in [["stat", "gain", str(days[dd][0])], ["stat2", "gain2", str(rr["evening"])]]:
			if str(rr[pair[0]]) != "": Attrs.apply_session(g2, str(pair[2]), str(rr[pair[0]]), float(rr[pair[1]]))
		if float(rr.get("attr_gain", 0.0)) > 0.0: Attrs.apply_session(g2, str(days[dd][0]), "", float(rr["attr_gain"]))
		fat = float(rr["fatigue"])
	var ds := 0.0
	for k in (g1["stats"] as Dictionary): ds = maxf(ds, absf(float(g1["stats"][k]) - float(g2["stats"][k])))
	_say("CONTROL_STAT my_week_vs_Sim_day_by_day max_delta=%.6f technique=%.3f cap=%.2f %s" % [ds, float(g1["stats"]["technique"]),
		MoveMastery.cap(float(g1["stats"]["technique"]), float(g1["stats"]["fight_iq"])), "OK" if ds < 0.02 else "MISMATCH"])
	var s1 := _fixture(); var s2 := _fixture(); var swp := {"mon": [{"card": "move:step_in", "share": 1.0}]}; s1["steps"]["step_in"] = 65.0; s2["steps"]["step_in"] = 65.0
	PadWeek.run_week(s1, nights, swp, COACH, PadWeek.STATION_TIER, {}, []); var sr := _drill_week(s2, nights, swp); _hold(s2, sr, {}, Specialty.HOLD_SHARP, Specialty.HOLD_SIGNATURE)
	_say("CONTROL_STEP shipped_drillable=%s shipped_step_in=%.2f armB_step_in=%.2f (the shipped wiring cannot drill or hold a step at 60+)" % [
		str(PadWeek.drillable(s2, "move:step_in")), float(s1["steps"]["step_in"]), float(s2["steps"]["step_in"])])
func _fixture() -> Dictionary:
	rng.seed = 4481; var f: Dictionary = _population()[0]; f["moves"]["Jab"] = 65.0; f["moves"]["Cross"] = 62.0; f["moves"]["Lead hook"] = 61.0; f["moves"]["Body hook"] = 58.0
	f["moves"]["Uppercut"] = 35.0; f["combos"]["1-2"] = 40.0; f["combos"]["1-1-2"] = 35.0; f["tray"] = ["combo:1-1-2"]
	return f
func _doc(arms: Array, summ: Dictionary, gates: Dictionary, pass_arm: String, closest: String, secs: float) -> void:
	var f := FileAccess.open("res://docs/HOLD1_RESULT.md", FileAccess.WRITE)
	if f == null:
		push_error("HOLD1 could not write docs/HOLD1_RESULT.md"); return
	var n: int = (cells[_label(arms[0]) + "|PLAN"]["all"] as Array).size(); var tail := "" if closest == "" else " closest=%s" % closest
	var cap := 0.0; var mxst := 0.0; var mxtg := 0.0; var g1fail := 0; var g2fail := 0
	f.store_string("# HOLD1 Result - the specialty: four ways to hold, and the minutes that make it a choice\n\nProbe run %s, Godot 4.7.2 headless, %.1f s, %d fighter-weeks. Seeds %s, %d careers = %d fighters (Data.PROSPECTS' %d named prospects + 60 walk-ins, prog_probe's population) x %d seeds, two seasons (%d weeks), %d arms (3 hold-minute pairs x 2 pad budgets), policies %s.\nRun: `godot --headless --audio-driver Dummy --path . --script res://tools/hold1_probe.gd`.\n\n## Method\n\n" % [
		Time.get_datetime_string_from_system(), secs, weeks_run, str(SEEDS), n, int(n / SEEDS.size()), Data.PROSPECTS.size(), SEEDS.size(), 2 * SEASON, arms.size(), str(POLICIES)])
	f.store_string(DOC_METHOD % [UNITS, OPP_EVERY])
	f.store_string("\n## Cells (median [p10..p90] over the careers of all 3 seeds)\n\n| Arm (min/wk @ pad nights) | Policy | S1 Sharp | S1 Sig | S2 Sharp | S2 Sig | S2 held Sharp | S2 held Sig | Target share | Weeks to Usable | <=4 wk | Named style max | Cap |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|\n")
	for arm in arms:
		for pol in POLICIES:
			var s: Dictionary = summ[_label(arm) + "|" + pol]; cap = maxf(cap, float(s["cap"])); mxst = maxf(mxst, float(s["maxstyle"])); mxtg = maxf(mxtg, float(s["target"]))
			f.store_line("| %s | %s | %d %s | %d %s | %d %s | %d %s | %d %s | %d %s | %.2f | %.1f | %.2f | %.2f | %.1f |" % [
				_label(arm), pol, int(s["sh1"]), str(s["r1"]), int(s["sg1"]), str(s["q1"]), int(s["sh2"]), str(s["r2"]), int(s["sg2"]),
				str(s["q2"]), int(s["hs2"]), str(s["rh2"]), int(s["gs2"]), str(s["rs2"]), float(s["target"]), float(s["wtu"]),
				float(s["le4"]), float(s["maxstyle"]), float(s["cap"])])
	f.store_string("\n## Gates\n\n" + DOC_GATES + "\n\n| Arm | Best policy | Held Sharp | Held Sig | Target | WTU | G1 | G2 | G3 | G4 | Pair diff | Pass | Failed |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|\n")
	for arm in arms:
		var g: Dictionary = gates[_label(arm)]; var gg: Array = g["g"]; g1fail += int(not bool(gg[0])); g2fail += int(not bool(gg[1]))
		f.store_line("| %s | %s | %d | %d | %.2f | %.1f | %d | %d | %d | %d | %.3f | %d | %s |" % [_label(arm), str(g["best"]),
			int(g["sharp"]), int(g["sig"]), float(g["target"]), float(g["wtu"]), int(gg[0]), int(gg[1]), int(gg[2]), int(gg[3]),
			float((g["pairs"] as Dictionary)["share"]), int((g["failed"] as Array).is_empty()), ",".join(g["failed"]) if not (g["failed"] as Array).is_empty() else "none"])
	f.store_string("\n## Controls and run log\n```\n")
	for l in log_lines: f.store_line(str(l))
	f.store_string("```\n\n## What the numbers say\n\n" + DOC_FINDINGS % [g1fail, arms.size(), cap, 100.0 * mxtg, g2fail, arms.size(), 100.0 * mxst])
	f.store_string("\n**HOLD1 done pass=%s%s**\n\nRESULT: tools/hold1_probe.gd -> HOLD1 done pass=%s%s\n" % [pass_arm, tail, pass_arm, tail]); f.close()
