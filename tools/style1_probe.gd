extends SceneTree
## STYLE1 - does any named style dominate, and is each one worth having?
## Part A: each style's worth in the played bout (60 fighters x 6 styles x 4 opponents x N bouts)
## Part B: the road to each style over the prog_probe week loop
## Pure measurement; no game script changes.
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/style1_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Career := preload("res://scripts/state/Career.gd")
const S1Rules := preload("res://tools/style1_probe_rules.gd")

const OPPS := [
	{"name": "Maria Ortega", "style": "Pressure fighter"},
	{"name": "Priya Nair", "style": "Counter-puncher"},
	{"name": "Erin Doyle", "style": "Volume puncher"},
	{"name": "Dana Whitfield", "style": "Boxer-puncher"},
]
const PLAN := [
	{"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"},
	{"move": "roll_out", "when": "loadup"}, {"move": "push_off", "when": "press"},
	{"move": "1-1-2", "when": "press"}, {"move": "2-3", "when": "range"},
	{"move": "1-2-3b", "when": "range"}, {"move": "1-6-3", "when": "counter"},
	{"move": "slip 2-3", "when": "loadup"}, {"move": "3b-3", "when": "tiring"},
	{"move": "step_in", "when": "range"}, {"move": "feint", "when": "counter"},
	{"move": "cut_off", "when": "tiring"}, {"move": "herd", "when": "hurt"},
	{"move": "step_out", "when": "she_tired"},
]
const N_FIGHTERS := 60
const SEED_START := 7100
const BASE_VAL := 45.0
const SEEDS := [4481, 4482, 4483]
const WEEKS_PER_SEASON := 52

var opp_rating := {}
var cur_plan: Array = PLAN.duplicate(true)
var rng := RandomNumberGenerator.new()


func _initialize() -> void:
	print("=== STYLE1: does any named style dominate, and is each one worth having? ===")
	var t0 := Time.get_ticks_msec()
	print("--- PART A: each style's worth in the played bout ---")
	var part_a_results := _run_part_a()
	print("--- PART B: the road to each style ---")
	var part_b_results := _run_part_b()
	print("")
	print("=== SUMMARY ===")
	var pass_info := _compute_summary(part_a_results, part_b_results)
	_write_result_doc(part_a_results, part_b_results, pass_info)
	print("STYLE1 done (%.1fs)" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _run_part_a() -> Dictionary:
	print("Calibrating opponent ratings...")
	_calibrate_opponents()
	var n := 10
	print("Using N=%d bouts per fighter per cell (%d total per cell)" % [n, n * N_FIGHTERS])
	var pilot_n := 5
	var t0 := Time.get_ticks_msec()
	var base := _base_dict()
	for pi in pilot_n:
		_run_bout(pi, str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"], "", "")
	var pilot_ms := Time.get_ticks_msec() - t0
	var total_cells := 6 * OPPS.size()
	var proj_min := float(pilot_ms) / float(pilot_n) * float(total_cells * N_FIGHTERS * 2) / 60000.0
	print("Pilot: %d ms for %d bouts -> projected %.1f min for full run" % [pilot_ms, pilot_n, proj_min])
	var results := {}
	for style_name in StyleName.EFFECTS:
		results[style_name] = {}
		for opp in OPPS:
			var opp_name: String = str(opp["name"])
			var win_named := 0
			var win_control := 0
			var total := n * N_FIGHTERS
			for fi in N_FIGHTERS:
				var seed_val := SEED_START + fi
				var f_base := _make_fighter(seed_val)
				var moves_d: Dictionary = (f_base["moves"] as Dictionary).duplicate()
				var steps_d: Dictionary = (f_base["steps"] as Dictionary).duplicate()
				var style_moves: Array = MoveTree.STYLES[style_name]
				for mv in style_moves:
					if MoveTree.PUNCH_IDS.has(str(mv)):
						moves_d[str(mv)] = 60.0
					else:
						steps_d[str(mv)] = 60.0
				var combos_d: Dictionary = {}
				for k in MoveTree.COMBO_PUNCHES:
					combos_d[k] = BASE_VAL
				for mv in style_moves:
					if MoveTree.PUNCH_IDS.has(str(mv)):
						for cid in MoveTree.COMBO_PUNCHES:
							if (MoveTree.COMBO_PUNCHES[cid] as Array).has(str(mv)):
								combos_d[cid] = 60.0
				for bi in n:
					var bout_seed := fi * n + bi
					var w := _run_bout(bout_seed, opp_name, moves_d, steps_d, combos_d, style_name, "")
					if str(w["outcome"]) == "win":
						win_named += 1
				for bi in n:
					var bout_seed := fi * n + bi
					var w := _run_bout(bout_seed, opp_name, moves_d, steps_d, combos_d, "", "")
					if str(w["outcome"]) == "win":
						win_control += 1
			var delta := float(win_named - win_control) * 100.0 / float(total)
			results[style_name][opp_name] = {"win_named": win_named, "win_control": win_control, "delta": delta, "total": total}
			print("STYLE style=%s opp=%s win_named=%d win_control=%d delta=%.1f" % [style_name, opp_name, win_named, win_control, delta])
	return results


func _run_part_b() -> Dictionary:
	var seasons := 2
	var tw := seasons * WEEKS_PER_SEASON
	var careers := []
	for seed_val in SEEDS:
		rng.seed = seed_val
		var fighters := S1Rules.make_population(rng)
		for f in fighters:
			var career := S1Rules.sim_career(f, tw)
			careers.append(career)
	var first_week := {}
	var named_count := {}
	var two_held_count := 0
	var total_careers := careers.size()
	for style_name in StyleName.EFFECTS:
		first_week[style_name] = []
		named_count[style_name] = 0
	for career in careers:
		for style_name in StyleName.EFFECTS:
			if career["first_held"].has(style_name):
				first_week[style_name].append(int(career["first_held"][style_name]))
			if career["named_styles"].has(style_name):
				named_count[style_name] += 1
		if career["two_held_ever"]:
			two_held_count += 1
	return {"first_week": first_week, "named_count": named_count, "two_held_count": two_held_count, "total_careers": total_careers}


func _calibrate_opponents() -> void:
	var base := _base_dict()
	for opp in OPPS:
		var on: String = str(opp["name"])
		var lo := 30.0
		var hi := float(_find_opp(on)["rating"])
		for _k in 7:
			opp_rating[on] = (lo + hi) / 2.0
			var w := _run_cell(on, base["moves"], base["steps"], base["combos"], 1, "", "")
			if w > N_FIGHTERS / 2:
				lo = float(opp_rating[on])
			else:
				hi = float(opp_rating[on])
		print("  %s: calibrated %.2f" % [on, float(opp_rating[on])])


func _find_opp(name: String) -> Dictionary:
	for opp in Data.OPPONENTS:
		if str(opp["name"]) == name:
			return (opp as Dictionary).duplicate(true)
	if Data.MISMATCH["name"] == name:
		return (Data.MISMATCH as Dictionary).duplicate(true)
	return {}


func _make_fighter(seed_val: int) -> Dictionary:
	var rng_local := RandomNumberGenerator.new()
	rng_local.seed = seed_val
	var prof := AttrGen.generate(rng_local)
	var style_word: String = AttrGen.style_word(prof)
	var first_names := ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Skyler",
		"Jamie", "Drew", "Blake", "Cameron", "Dakota", "Emerson", "Finley", "Harper", "Hayden", "Jesse",
		"Kai", "Lane", "Logan", "Parker", "Reese", "Rowan", "Sage", "Spencer", "Tatum", "Winter"]
	var last_names := ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies", "Evans", "Thomas", "Roberts", "Johnson",
		"Walker", "Wright", "Robinson", "White", "Thompson", "Moore", "Clark", "Lewis", "Hall", "Young",
		"King", "Baker", "Lee", "Green", "Adams", "Nelson", "Mitchell", "Harris", "Turner", "Fox"]
	var first: String = str(first_names[rng_local.randi_range(0, first_names.size() - 1)])
	var last: String = str(last_names[rng_local.randi_range(0, last_names.size() - 1)])
	var technique := clampf(50.0 + prof["shape"].get("accuracy", 0.0) * 0.5 + rng_local.randf_range(-5.0, 5.0), 30.0, 80.0)
	var fight_iq := clampf(50.0 + prof["shape"].get("fight_iq", 0.0) * 0.5 + rng_local.randf_range(-5.0, 5.0), 30.0, 80.0)
	var footwork := clampf(50.0 + prof["shape"].get("footwork", 0.0) * 0.5 + rng_local.randf_range(-5.0, 5.0), 30.0, 80.0)
	var f := {
		"id": "tv_%d" % seed_val, "name": "%s %s" % [first, last], "first": first, "sex": "f",
		"age": 22 + rng_local.randi_range(-3, 5), "wc": "Lightweight", "limit": 60.0,
		"weight": 60.0 + rng_local.randf_range(-1.0, 1.0),
		"stance": "orthodox" if rng_local.randf() < 0.7 else "southpaw", "style": style_word,
		"w": 3 + rng_local.randi_range(0, 5), "l": 1 + rng_local.randi_range(0, 3),
		"pot": 70 + rng_local.randi_range(-10, 15), "cards": [], "focus": "conditioning", "div": "wlw",
		"diet": "hold", "fatigue": 8, "weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": {
			"power": clampf(55.0 + rng_local.randf_range(-10.0, 10.0), 35.0, 80.0),
			"speed": clampf(55.0 + rng_local.randf_range(-10.0, 10.0), 35.0, 80.0),
			"technique": technique, "defense": clampf(55.0 + rng_local.randf_range(-10.0, 10.0), 35.0, 80.0),
			"conditioning": clampf(55.0 + rng_local.randf_range(-10.0, 10.0), 35.0, 80.0),
			"fight_iq": fight_iq, "chin": clampf(55.0 + rng_local.randf_range(-10.0, 10.0), 35.0, 80.0),
		},
		"goal": {}, "shape": prof["shape"], "pace": float(prof["pace"]),
		"forward": float(prof["forward"]), "heart": float(prof["heart"]), "footwork": footwork,
	}
	return Data.fighter_state(f, 40 + (seed_val - SEED_START))


func _base_dict() -> Dictionary:
	var moves := {}
	var steps := {}
	var combos := {}
	for k in Data.MOVES:
		moves[k] = BASE_VAL
	for k in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		steps[k] = BASE_VAL
	for k in MoveTree.COMBO_PUNCHES:
		combos[k] = BASE_VAL
	return {"moves": moves, "steps": steps, "combos": combos}


func _run_bout(seed_offset: int, opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, named_style: String, _extra: String) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(_make_fighter(SEED_START + (seed_offset % N_FIGHTERS)))
	c.day = 40 + seed_offset
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["morale"] = 60.0
	f["moves"] = moves.duplicate()
	f["steps"] = steps.duplicate()
	f["combos"] = combos.duplicate()
	f["arrows"] = cur_plan.duplicate(true)
	if named_style != "":
		f["named_style"] = named_style
	c.coach = {}
	var opp: Dictionary = _find_opp(opp_name)
	if opp_rating.has(opp_name):
		opp["rating"] = float(opp_rating[opp_name])
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	return {"outcome": str(m.get("outcome", ""))}


func _run_cell(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int, named_style: String, _extra: String) -> int:
	var wins := 0
	for i in n * N_FIGHTERS:
		var r := _run_bout(i, opp_name, moves, steps, combos, named_style, "")
		wins += int(str(r["outcome"]) == "win")
	return wins


func _compute_summary(part_a: Dictionary, part_b: Dictionary) -> Dictionary:
	var best_delta := {}
	for style_name in StyleName.EFFECTS:
		var max_d := -999.0
		for opp_name in part_a[style_name]:
			var d: float = float(part_a[style_name][opp_name]["delta"])
			if d > max_d:
				max_d = d
		best_delta[style_name] = max_d
	var best_style := ""
	var best_val := -999.0
	for style_name in best_delta:
		if best_delta[style_name] > best_val:
			best_val = best_delta[style_name]
			best_style = style_name
	var best_vs_all := "none"
	if best_style != "":
		var dominates := true
		for opp in OPPS:
			var opp_name: String = str(opp["name"])
			for style_name in StyleName.EFFECTS:
				if style_name != best_style:
					if float(part_a[style_name][opp_name]["delta"]) > float(part_a[best_style][opp_name]["delta"]):
						dominates = false
						break
			if not dominates:
				break
		if dominates:
			best_vs_all = best_style
	var named_share := {}
	var total_careers: int = int(part_b["total_careers"])
	for style_name in StyleName.EFFECTS:
		var count: int = int(part_b["named_count"][style_name])
		named_share[style_name] = float(count) / float(maxi(1, total_careers))
	var two_held_share := float(int(part_b["two_held_count"])) / float(maxi(1, total_careers))
	var median_weeks := {}
	for style_name in StyleName.EFFECTS:
		var weeks: Array = part_b["first_week"][style_name]
		if weeks.is_empty():
			median_weeks[style_name] = -1
		else:
			weeks.sort()
			median_weeks[style_name] = int(weeks[weeks.size() / 2])
	var medians_only: Array = []
	for style_name in median_weeks:
		if int(median_weeks[style_name]) >= 0:
			medians_only.append(int(median_weeks[style_name]))
	var spread_weeks := 0
	if not medians_only.is_empty():
		medians_only.sort()
		spread_weeks = int(medians_only[medians_only.size() - 1]) - int(medians_only[0])
	var gate1 := true
	for style_name in best_delta:
		var d: float = float(best_delta[style_name])
		if d < 1.5 or d > 4.0:
			gate1 = false
	var gate2 := best_vs_all == "none"
	var gate3 := true
	for style_name in named_share:
		if float(named_share[style_name]) > 1.0 / 3.0:
			gate3 = false
	var gate4 := two_held_share < 1.0 / 4.0
	var gate5 := spread_weeks <= 3
	var all_pass := gate1 and gate2 and gate3 and gate4 and gate5
	var why := ""
	if not gate1: why += "gate1_fail "
	if not gate2: why += "gate2_fail "
	if not gate3: why += "gate3_fail "
	if not gate4: why += "gate4_fail "
	if not gate5: why += "gate5_fail "
	if why == "": why = "all_pass"
	print("STYLE1 worth=%s best_vs_all=%s named_share=%s two_held=%.3f" % [str(best_delta), best_vs_all, str(named_share), two_held_share])
	print("STYLE1 weeks=%s spread_weeks=%d" % [str(median_weeks), spread_weeks])
	print("STYLE1 pass=%d why=%s" % [1 if all_pass else 0, why.strip_edges()])
	return {"best_delta": best_delta, "best_vs_all": best_vs_all, "named_share": named_share,
		"two_held_share": two_held_share, "median_weeks": median_weeks, "spread_weeks": spread_weeks,
		"all_pass": all_pass, "why": why.strip_edges()}


func _write_result_doc(part_a: Dictionary, part_b: Dictionary, pass_info: Dictionary) -> void:
	var f := FileAccess.open("res://docs/STYLE1_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	f.store_line("# STYLE1 Result")
	f.store_line("")
	f.store_line("Probe run: %s. N=10 bouts per fighter per cell, 60 fighters, 6 styles, 4 opponents." % dt)
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("Does any named style dominate, and is each one worth having?")
	f.store_line("Gate: each style's effect worth 1.5 to 4 wins in 100 against its best opponent.")
	f.store_line("")
	f.store_line("## Method")
	f.store_line("")
	f.store_line("Part A: 60 generated fighters (seeds 7100-7159), 6 named styles, 4 style opponents.")
	f.store_line("For each fighter x style: set the style's 3 moves to 60 mastery, set named_style, play 10 bouts vs each opponent.")
	f.store_line("Control: same fighter, same moves at 60, no named_style.")
	f.store_line("Delta = win% with named style minus win% without.")
	f.store_line("")
	f.store_line("Part B: 3 seeds x 64 fighters (4 prospects + 60 walk-ins), 2 seasons (104 weeks).")
	f.store_line("Track first week each style held, style named, two_held at any Monday.")
	f.store_line("")
	f.store_line("## Part A: Delta Table")
	f.store_line("")
	f.store_line("| Style | vs Pressure | vs Counter | vs Volume | vs Boxer-puncher | Best Delta |")
	f.store_line("|-------|-------------|------------|-----------|------------------|------------|")
	for style_name in StyleName.EFFECTS:
		var line := "| %s |" % style_name
		var max_d := -999.0
		for opp in OPPS:
			var opp_name: String = str(opp["name"])
			var d: float = float(part_a[style_name][opp_name]["delta"])
			line += " %+.1f |" % d
			if d > max_d:
				max_d = d
		line += " %+.1f |" % max_d
		f.store_line(line)
	f.store_line("")
	f.store_line("## Part B: Road to Each Style")
	f.store_line("")
	f.store_line("| Style | Median Weeks | Named Share |")
	f.store_line("|-------|--------------|-------------|")
	for style_name in StyleName.EFFECTS:
		var med: int = int(pass_info["median_weeks"][style_name])
		var share: float = float(pass_info["named_share"][style_name])
		f.store_line("| %s | %s | %.3f |" % [style_name, str(med) if med >= 0 else "never", share])
	f.store_line("")
	f.store_line("Two held at once: %.3f of careers" % float(pass_info["two_held_share"]))
	f.store_line("Spread of medians: %d weeks" % int(pass_info["spread_weeks"]))
	f.store_line("")
	f.store_line("## Gates")
	f.store_line("")
	f.store_line("- Gate 1 (each style worth 1.5-4 wins in 100): %s" % ("pass" if "gate1_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("- Gate 2 (no style best vs all): %s" % ("pass" if "gate2_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("- Gate 3 (no style named >1/3 careers): %s" % ("pass" if "gate3_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("- Gate 4 (two_held <1/4 careers): %s" % ("pass" if "gate4_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("- Gate 5 (spread of medians <=3 weeks): %s" % ("pass" if "gate5_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("")
	f.store_line("**STYLE1 pass=%d why=%s**" % [1 if bool(pass_info["all_pass"]) else 0, str(pass_info["why"])])
	f.store_line("")
	f.store_line("## Plain Words")
	f.store_line("")
	var best_style := ""
	var best_val := -999.0
	for style_name in pass_info["best_delta"]:
		if float(pass_info["best_delta"][style_name]) > best_val:
			best_val = float(pass_info["best_delta"][style_name])
			best_style = style_name
	f.store_line("A named style is worth having if its best delta is positive and in the 1.5-4 range. ")
	if best_val >= 1.5 and best_val <= 4.0:
		f.store_line("%s is worth having (%.1f wins in 100 against its best opponent). " % [best_style, best_val])
	else:
		f.store_line("No style's effect is in the 1.5-4 range. ")
	if pass_info["best_vs_all"] != "none":
		f.store_line("%s dominates all four opponents. " % str(pass_info["best_vs_all"]))
	else:
		f.store_line("No style dominates all four opponents. ")
	f.store_line("The effect to change is %s's %s (%s). " % [best_style, str(StyleName.EFFECTS[best_style]), str(best_val)])
	if best_val > 4.0:
		f.store_line("Reduce it so the delta is closer to 3.")
	elif best_val < 1.5:
		f.store_line("Increase it so the delta is closer to 2.")
	else:
		f.store_line("It is in range; no change needed.")
	f.close()
	print("Result doc written to docs/STYLE1_RESULT.md")
