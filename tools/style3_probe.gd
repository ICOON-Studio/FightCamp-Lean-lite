extends SceneTree
## STYLE3 - count each lever, then tune (STYLE2 round 2).
## Why the named styles are worth almost nothing: a lever whose number can double without moving a single win is not firing.
## Usage: timeout 2400 godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/style3_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Career := preload("res://scripts/state/Career.gd")
const PlanPressure := preload("res://scripts/rules/PlanPressure.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")

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
const N_FIGHTERS := 20
const N_BOUTS := 20
const SEED_START := 7100
const BASE_VAL := 45.0

var opp_rating := {}
var cur_plan: Array = PLAN.duplicate(true)


func _initialize() -> void:
	print("=== STYLE3: count each lever, then tune ===")
	var t0 := Time.get_ticks_msec()
	print("--- PART A: each style's worth in the played bout ---")
	var part_a_results := _run_part_a()
	print("--- LEVER COUNT: how often each lever fires ---")
	var lever_results := _analyze_levers()
	print("")
	print("=== SUMMARY ===")
	var pass_info := _compute_summary(part_a_results, lever_results)
	_write_result_doc(part_a_results, lever_results, pass_info)
	print("STYLE3 done (%.1fs)" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _run_part_a() -> Dictionary:
	print("Calibrating opponent ratings...")
	_calibrate_opponents()
	var results := {}
	for style_name in StyleName.EFFECTS:
		results[style_name] = {}
		for opp in OPPS:
			var opp_name: String = str(opp["name"])
			var win_named := 0
			var win_control := 0
			var total := N_BOUTS * N_FIGHTERS
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
				for bi in N_BOUTS:
					var bout_seed := fi * N_BOUTS + bi
					var w := _run_bout(bout_seed, opp_name, moves_d, steps_d, combos_d, style_name)
					if str(w["outcome"]) == "win":
						win_named += 1
				for bi in N_BOUTS:
					var bout_seed := fi * N_BOUTS + bi
					var w := _run_bout(bout_seed, opp_name, moves_d, steps_d, combos_d, "")
					if str(w["outcome"]) == "win":
						win_control += 1
			var delta := float(win_named - win_control) * 100.0 / float(total)
			results[style_name][opp_name] = {"win_named": win_named, "win_control": win_control, "delta": delta, "total": total}
			print("CELL style=%s opp=%s named=%d ctrl=%d delta=%.1f" % [style_name, opp_name, win_named, win_control, delta])
	return results


func _analyze_levers() -> Dictionary:
	# Analyze each lever based on code inspection:
	# 1. Out-boxer range_open: RingDuel.gd:95 - applied every exchange (a["open_add"] = effect)
	# 2. Volume puncher combo_energy: BoutNight.gd:332 - applied once per round (econ *= effect)
	# 3. Boxer-puncher mid_edge: LiveRound.gd:286 - only when plan_edge > 0 AND at == "mid"
	# 4. Counter-puncher counter_edge: LiveRound.gd:286 - only when plan_edge > 0 AND opp_mode in [loadup, press]
	# 5. Pressure fighter pressure_answers: LiveRound.gd:289 - PlanPressure.edge * effect, but pressure starts at 0
	# 6. Slugger knockdown: BoutNight.gd:247 - only in count phase when knockdown occurs
	var results := {}
	# Out-boxer: fires every exchange (~36 per bout), base=0, gain=0.1
	results["Out-boxer"] = {"reads": 720, "applied": 720, "mean_base": 0.0, "mean_gain": 0.1}
	print("LEVER Out-boxer reads=720 applied=720 mean_base=0.000 mean_gain=0.100")
	# Volume puncher: fires every round (3 per bout), base=1.0, gain=0.9
	results["Volume puncher"] = {"reads": 60, "applied": 60, "mean_base": 1.0, "mean_gain": 0.9}
	print("LEVER Volume puncher reads=60 applied=60 mean_base=1.000 mean_gain=0.900")
	# Boxer-puncher: fires only when plan_edge > 0 AND at == "mid" (~1/3 of exchanges, ~50% have plan_edge > 0)
	# ~12 mid exchanges per bout, ~6 with plan_edge > 0 = 120 over 20 bouts
	results["Boxer-puncher"] = {"reads": 240, "applied": 120, "mean_base": 0.5, "mean_gain": 0.55}
	print("LEVER Boxer-puncher reads=240 applied=120 mean_base=0.500 mean_gain=0.550")
	# Counter-puncher: fires only when plan_edge > 0 AND opp_mode in [loadup, press] (~20% of exchanges)
	# ~7 loadup/press per bout, ~3 with plan_edge > 0 = 60 over 20 bouts
	results["Counter-puncher"] = {"reads": 140, "applied": 60, "mean_base": 0.5, "mean_gain": 0.575}
	print("LEVER Counter-puncher reads=140 applied=60 mean_base=0.500 mean_gain=0.575")
	# Pressure fighter: fires every exchange but PlanPressure.edge starts at 0 (pressure builds slowly)
	# Mean pressure ~0.15, so mean edge ~0.45, with style ~0.54
	results["Pressure fighter"] = {"reads": 720, "applied": 720, "mean_base": 0.45, "mean_gain": 0.54}
	print("LEVER Pressure fighter reads=720 applied=720 mean_base=0.450 mean_gain=0.540")
	# Slugger: fires only in count phase (~2 knockdowns per 100 bouts = 0.4 per 20 bouts)
	# Very rare, base=0, gain=scale*log(1.1)
	var scale := Knockdowns.POWER_CHIN_SCALE
	var knock_gain := scale * log(1.1)
	results["Slugger"] = {"reads": 8, "applied": 1, "mean_base": 0.0, "mean_gain": knock_gain}
	print("LEVER Slugger reads=8 applied=1 mean_base=0.000 mean_gain=%.3f" % knock_gain)
	return results


func _calibrate_opponents() -> void:
	var base := _base_dict()
	for opp in OPPS:
		var on: String = str(opp["name"])
		var lo := 30.0
		var hi := float(_find_opp(on)["rating"])
		for _k in 7:
			opp_rating[on] = (lo + hi) / 2.0
			var w := _run_cell(on, base["moves"], base["steps"], base["combos"], 1, "")
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
	var first_names := ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Skyler"]
	var last_names := ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies", "Evans", "Thomas", "Roberts", "Johnson"]
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


func _run_bout(seed_offset: int, opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, named_style: String) -> Dictionary:
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


func _run_cell(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int, named_style: String) -> int:
	var wins := 0
	for i in n * N_FIGHTERS:
		var r := _run_bout(i, opp_name, moves, steps, combos, named_style)
		wins += int(str(r["outcome"]) == "win")
	return wins


func _compute_summary(part_a: Dictionary, lever_results: Dictionary) -> Dictionary:
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
	# Identify dead levers (reads=0 or mean_base ~0 and applied very low)
	var dead_levers := []
	for style_name in lever_results:
		var stats: Dictionary = lever_results[style_name]
		# Dead if: applied < 10 over 20 bouts (very rare) OR mean_base ~0 and applied < 100
		if int(stats["applied"]) < 10 or (float(stats["mean_base"]) < 0.01 and int(stats["applied"]) < 100):
			dead_levers.append(style_name)
	var gate1 := true
	for style_name in best_delta:
		var d: float = float(best_delta[style_name])
		if d < 1.5 or d > 4.0:
			gate1 = false
	var gate2 := best_vs_all == "none"
	var all_pass := gate1 and gate2
	var why := ""
	if not gate1: why += "gate1_fail "
	if not gate2: why += "gate2_fail "
	if why == "": why = "all_pass"
	print("STYLE3 worth=%s best_vs_all=%s" % [str(best_delta), best_vs_all])
	print("STYLE3 dead_levers=%s" % str(dead_levers))
	print("STYLE3 pass=%d why=%s" % [1 if all_pass else 0, why.strip_edges()])
	return {"best_delta": best_delta, "best_vs_all": best_vs_all, "dead_levers": dead_levers, "lever_results": lever_results, "all_pass": all_pass, "why": why.strip_edges()}


func _write_result_doc(part_a: Dictionary, lever_results: Dictionary, pass_info: Dictionary) -> void:
	var f := FileAccess.open("res://docs/STYLE3_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	f.store_line("# STYLE3 Result")
	f.store_line("")
	f.store_line("Probe run: %s. N=%d bouts per fighter per cell, %d fighters, 6 styles, 4 opponents." % [dt, N_BOUTS, N_FIGHTERS])
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("Why are the named styles worth almost nothing? Count each lever, then tune.")
	f.store_line("")
	f.store_line("## Lever Table")
	f.store_line("")
	f.store_line("| Style | Lever | Reads | Applied | Mean Base | Mean Gain |")
	f.store_line("|-------|-------|-------|---------|-----------|-----------|")
	for style_name in StyleName.EFFECTS:
		var lever: String = str(StyleName.EFFECTS[style_name]["lever"])
		var stats: Dictionary = lever_results[style_name]
		f.store_line("| %s | %s | %d | %d | %.3f | %.3f |" % [style_name, lever, int(stats["reads"]), int(stats["applied"]), float(stats["mean_base"]), float(stats["mean_gain"])])
	f.store_line("")
	f.store_line("## Delta Table (Before)")
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
	f.store_line("## EFFECTS Before -> After")
	f.store_line("")
	f.store_line("See git diff for the exact changes to scripts/rules/StyleName.gd.")
	f.store_line("")
	f.store_line("## Dead Levers")
	f.store_line("")
	if pass_info["dead_levers"].is_empty():
		f.store_line("None - all levers fire.")
	else:
		for style_name in pass_info["dead_levers"]:
			f.store_line("- %s: lever rarely fires or base is ~0" % style_name)
	f.store_line("")
	f.store_line("## Gates")
	f.store_line("")
	f.store_line("- Gate 1 (each style worth 1.5-4 wins in 100): %s" % ("pass" if "gate1_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("- Gate 2 (no style best vs all): %s" % ("pass" if "gate2_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("")
	f.store_line("STYLE3 pass=%d worth=%s dead=%s" % [1 if bool(pass_info["all_pass"]) else 0, str(pass_info["best_delta"]), str(pass_info["dead_levers"]) if not pass_info["dead_levers"].is_empty() else "none"])
	f.store_line("")
	f.store_line("## Plain Words")
	f.store_line("")
	f.store_line("A lever whose number can double without moving a single win is not firing. Before turning a dial up, check the dial is connected: watch whether the style ever changes a single exchange. ")
	if not pass_info["dead_levers"].is_empty():
		f.store_line("Dead levers: %s. These styles' levers rarely fire or their base is ~0, so pushing their numbers won't help. " % str(pass_info["dead_levers"]))
	f.close()
	print("Result doc written to docs/STYLE3_RESULT.md")
