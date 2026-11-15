extends SceneTree
## S488 STYLE5 - one points lever per style, real counters, tuned into the band.
## Usage: timeout 3600 godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/style5_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const StyleLevers := preload("res://scripts/rules/StyleLevers.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Career := preload("res://scripts/state/Career.gd")

const ALL_STYLES := ["Out-boxer", "Volume puncher", "Boxer-puncher", "Pressure fighter", "Slugger", "Counter-puncher"]
const N_FIGHTERS := 20
const N_BOUTS := 20
const SEED_START := 7200
const BASE_VAL := 45.0

var opp_rating_scale := 0.81   # S490 calibrated: control wins ~35-75% per opponent style (1.0 gave 1-11%: saturated)
var cur_plan: Array = []
var only: Array = []
var cur_style := ""   # S490: the cell's style; a Volume puncher cell pushes the pace in BOTH arms (its situation)


func _initialize() -> void:
	print("=== STYLE5: one points lever per style, real counters ===")
	var t0 := Time.get_ticks_msec()
	_build_plan()
	# S490 SATURATION CHECK (brief step 4): `-- scale=<f>` sets the opponents' strength; `-- calib=1` runs only the control
	# arm, 5 fighters x 5 bouts per opponent style, and prints each control win rate (target 25-75%).
	for a in OS.get_cmdline_user_args():
		if a.begins_with("only="):   # S490: `-- only=Volume puncher,Pressure fighter` runs those rows only
			only = Array(a.substr(5).split(","))
		if a.begins_with("scale="):
			opp_rating_scale = float(a.substr(6))
	print("STYLE5 opp_rating_scale=%.3f" % opp_rating_scale)
	if OS.get_cmdline_user_args().has("calib=1"):
		_calibrate()
		quit(0)
		return
	print("--- 6x6 grid (each named style vs each base style opponent) ---")
	var grid_results := _run_grid()
	if not only.is_empty():   # S490 a partial run prints its cells only (the summary needs the whole grid)
		quit(0)
		return
	print("--- LEVER COUNTS (real, from the game) ---")
	var lever_counts := _collect_levers()
	print("")
	print("=== SUMMARY ===")
	var pass_info := _compute_summary(grid_results, lever_counts)
	_write_result_doc(grid_results, lever_counts, pass_info)
	print("STYLE5 pass=%d" % (1 if bool(pass_info["all_pass"]) else 0))
	print("STYLE5 probe done (%.1fs)" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


func _calibrate() -> void:
	cur_style = ""
	for opp_style in ALL_STYLES:
		var wins := 0
		for fi in 5:
			var f_base := _make_fighter(SEED_START + fi)
			for bi in 5:
				var w := _run_bout(fi * N_BOUTS + bi, opp_style, f_base["moves"], f_base["steps"], f_base.get("combos", {}), "")
				if str(w["outcome"]) == "win":
					wins += 1
		print("CALIB scale=%.3f opp=%s ctrl_rate=%.2f" % [opp_rating_scale, opp_style, wins / 25.0])


func _build_plan() -> void:
	cur_plan = [
		{"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"},
		{"move": "roll_out", "when": "loadup"}, {"move": "push_off", "when": "press"},
		{"move": "1-1-2", "when": "press"}, {"move": "2-3", "when": "range"},
		{"move": "1-2-3b", "when": "range"}, {"move": "1-6-3", "when": "counter"},
		{"move": "slip 2-3", "when": "loadup"}, {"move": "3b-3", "when": "tiring"},
		{"move": "step_in", "when": "range"}, {"move": "feint", "when": "counter"},
		{"move": "cut_off", "when": "tiring"}, {"move": "herd", "when": "hurt"},
		{"move": "step_out", "when": "she_tired"},
	]


func _run_grid() -> Dictionary:
	var results := {}
	for style_name in ALL_STYLES:
		results[style_name] = {}
		if not only.is_empty() and not only.has(style_name):
			continue
		for opp_style in ALL_STYLES:
			if opp_style == style_name:
				continue
			StyleLevers.reset_counts()
			cur_style = style_name
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
					var w := _run_bout(bout_seed, opp_style, moves_d, steps_d, combos_d, style_name)
					if str(w["outcome"]) == "win":
						win_named += 1
				for bi in N_BOUTS:
					var bout_seed := fi * N_BOUTS + bi
					var w := _run_bout(bout_seed, opp_style, moves_d, steps_d, combos_d, "")
					if str(w["outcome"]) == "win":
						win_control += 1
			var delta := float(win_named - win_control) * 100.0 / float(total)
			var ctrl_rate := float(win_control) / float(total)
			results[style_name][opp_style] = {"win_named": win_named, "win_control": win_control, "delta": delta, "total": total, "ctrl_rate": ctrl_rate}
			var counts: Variant = StyleLevers.COUNTS.get(style_name, [0, 0])
			print("CELL style=%s opp=%s named=%d ctrl=%d ctrl_rate=%.2f delta=%.1f" % [style_name, opp_style, win_named, win_control, ctrl_rate, delta])
			print("LEVER %s reads=%d applied=%d" % [style_name, int(counts[0]), int(counts[1])])
	return results


func _collect_levers() -> Dictionary:
	var out := {}
	for style_name in ALL_STYLES:
		var c: Variant = StyleLevers.COUNTS.get(style_name, [0, 0])
		out[style_name] = {"reads": int(c[0]), "applied": int(c[1])}
	return out


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


func _run_bout(seed_offset: int, opp_style: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, named_style: String) -> Dictionary:
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
	if cur_style == "Volume puncher":
		f["round_pace"] = ["push", "push", "push"]
	if named_style != "":
		f["named_style"] = named_style
	c.coach = {}
	var opp := _make_opp(opp_style)
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	Bouts.fight_step(c, f, m, "sim")
	return {"outcome": str(m.get("outcome", ""))}


func _make_opp(style_name: String) -> Dictionary:
	var rng_local := RandomNumberGenerator.new()
	rng_local.seed = style_name.hash()
	var prof := AttrGen.generate(rng_local)
	var style_word: String = AttrGen.style_word(prof)
	var first_names := ["Maria", "Priya", "Erin", "Dana", "Kalli", "Jade"]
	var last_names := ["Ortega", "Nair", "Doyle", "Whitfield", "Voss", "Chen"]
	var idx := ALL_STYLES.find(style_name)
	if idx < 0:
		idx = 0
	var first: String = str(first_names[idx])
	var last: String = str(last_names[idx])
	var technique := clampf(50.0 + prof["shape"].get("accuracy", 0.0) * 0.5, 30.0, 80.0)
	var fight_iq := clampf(50.0 + prof["shape"].get("fight_iq", 0.0) * 0.5, 30.0, 80.0)
	var footwork := clampf(50.0 + prof["shape"].get("footwork", 0.0) * 0.5, 30.0, 80.0)
	var base_rating := 65.0 * opp_rating_scale
	var f := {
		"id": "opp_%s" % style_name, "name": "%s %s" % [first, last], "first": first, "sex": "f",
		"age": 24, "wc": "Lightweight", "limit": 60.0,
		"weight": 60.0,
		"stance": "orthodox", "style": style_word,
		"w": 5, "l": 2,
		"pot": 75, "cards": [], "focus": "conditioning", "div": "wlw",
		"diet": "hold", "fatigue": 8, "weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": {
			"power": 60.0 * opp_rating_scale, "speed": 60.0 * opp_rating_scale, "technique": technique,
			"defense": 60.0 * opp_rating_scale,
			"conditioning": 60.0, "fight_iq": fight_iq, "chin": 60.0 * opp_rating_scale,
		},
		"goal": {}, "shape": prof["shape"], "pace": float(prof["pace"]),
		"forward": float(prof["forward"]), "heart": float(prof["heart"]), "footwork": footwork,
		"rating": base_rating, "threat": "Everything", "weak": "None",
	}
	return Data.fighter_state(f, 100)


func _compute_summary(grid: Dictionary, lever_counts: Dictionary) -> Dictionary:
	var best_delta := {}
	for style_name in ALL_STYLES:
		var max_d := -999.0
		for opp_style in grid[style_name]:
			var d: float = float(grid[style_name][opp_style]["delta"])
			if d > max_d:
				max_d = d
		best_delta[style_name] = max_d
	# S490: a style is "best vs all" when, against every opponent it met, no other style's delta beats it.
	var best_vs_all := "none"
	for style_name in ALL_STYLES:
		var dominates := true
		for opp_style in grid[style_name]:
			for other_style in ALL_STYLES:
				if other_style == style_name or not grid[other_style].has(opp_style):
					continue
				if float(grid[other_style][opp_style]["delta"]) > float(grid[style_name][opp_style]["delta"]):
					dominates = false
			if not dominates:
				break
		if dominates:
			best_vs_all = style_name
			break
	var gate1 := true
	for style_name in best_delta:
		var d: float = float(best_delta[style_name])
		if d < 1.5 or d > 4.0:
			gate1 = false
	var gate2 := best_vs_all == "none"
	var all_pass := gate1 and gate2
	var dead_levers := []
	for style_name in lever_counts:
		var reads: int = int(lever_counts[style_name]["reads"])
		var applied: int = int(lever_counts[style_name]["applied"])
		if reads > 0 and float(applied) / float(reads) < 0.1:
			dead_levers.append(style_name)
	var why := ""
	if not gate1: why += "gate1_fail "
	if not gate2: why += "gate2_fail "
	if why == "": why = "all_pass"
	print("STYLE5 worth=%s best_vs_all=%s" % [str(best_delta), best_vs_all])
	print("STYLE5 dead_levers=%s" % str(dead_levers))
	print("STYLE5 pass=%d why=%s" % [1 if all_pass else 0, why.strip_edges()])
	return {"best_delta": best_delta, "best_vs_all": best_vs_all, "dead_levers": dead_levers, "lever_counts": lever_counts, "all_pass": all_pass, "why": why.strip_edges()}


func _write_result_doc(grid: Dictionary, lever_counts: Dictionary, pass_info: Dictionary) -> void:
	var f := FileAccess.open("res://docs/STYLE5_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	f.store_line("# STYLE5 Result")
	f.store_line("")
	f.store_line("Probe run: %s. N=%d bouts per fighter per cell, %d fighters, 6 styles, 6 opponents." % [dt, N_BOUTS, N_FIGHTERS])
	f.store_line("")
	f.store_line("## Lever Counts (real, from the game)")
	f.store_line("")
	f.store_line("| Style | Reads | Applied | Apply Rate |")
	f.store_line("|-------|-------|---------|------------|")
	for style_name in ALL_STYLES:
		var stats: Dictionary = lever_counts[style_name]
		var reads: int = int(stats["reads"])
		var applied: int = int(stats["applied"])
		var rate := float(applied) / float(maxi(1, reads))
		f.store_line("| %s | %d | %d | %.1f%% |" % [style_name, reads, applied, rate * 100.0])
	f.store_line("")
	f.store_line("## 6x6 Delta Grid")
	f.store_line("")
	var header := "| Style |"
	for opp_style in ALL_STYLES:
		header += " vs %s |" % opp_style
	header += " Best |"
	f.store_line(header)
	var sep := "|-------|"
	for _i in ALL_STYLES.size():
		sep += "---------|"
	sep += "------|"
	f.store_line(sep)
	for style_name in ALL_STYLES:
		var line := "| %s |" % style_name
		var max_d := -999.0
		for opp_style in ALL_STYLES:
			if opp_style == style_name:
				line += " - |"
			else:
				var d: float = float(grid[style_name][opp_style]["delta"])
				line += " %+.1f |" % d
				if d > max_d:
					max_d = d
		line += " %+.1f |" % max_d
		f.store_line(line)
	f.store_line("")
	f.store_line("## EFFECTS (before -> after)")
	f.store_line("")
	f.store_line("Before (STYLE4): each style had lever/add/mult only, no pts.")
	f.store_line("")
	f.store_line("After (STYLE5):")
	f.store_line("```")
	for style_name in ALL_STYLES:
		var row: Dictionary = StyleName.EFFECTS[style_name]
		f.store_line("\"%s\": %s" % [style_name, str(row)])
	f.store_line("```")
	f.store_line("")
	f.store_line("## Gates")
	f.store_line("")
	f.store_line("- Gate 1 (each style worth 1.5-4 wins in 100): %s" % ("PASS" if "gate1_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("- Gate 2 (no style best vs all): %s" % ("PASS" if "gate2_fail" not in str(pass_info["why"]) else "FAIL"))
	f.store_line("")
	f.store_line("STYLE5 pass=%d worth=%s dead=%s" % [1 if bool(pass_info["all_pass"]) else 0, str(pass_info["best_delta"]), str(pass_info["dead_levers"]) if not pass_info["dead_levers"].is_empty() else "none"])
	f.close()
	print("Result doc written to docs/STYLE5_RESULT.md")
