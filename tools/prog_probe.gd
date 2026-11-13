extends SceneTree
## PROGPROBE1R2 - progression cadence and the hold rule over two seasons.
## MEASUREMENT ONLY: no rule module changes. Modelled rules in prog_probe_rules.gd.
## Population: 4 quick-start fighters + 60 generated walk-ins. Two seasons (104 weeks), seeds 4481-4483.
## ARM A = today's game. ARM B = the map (learning slot, hold rule, step mastery).
## Test: godot --headless --audio-driver Dummy --path . --script res://tools/prog_probe.gd -- seasons=2
## Pass: PROG_PROBE done cells=<n>

const Data := preload("res://scripts/state/Data.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const LearnSlots := preload("res://scripts/rules/LearnSlots.gd")
const ProgRules := preload("res://tools/prog_probe_rules.gd")

const SEEDS := [4481, 4482, 4483]
const WEEKS_PER_SEASON := 52
var args := {}; var seasons := 2; var rng := RandomNumberGenerator.new()
func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=", true, 1)
		if kv.size() == 2: args[kv[0]] = kv[1]
	seasons = int(args.get("seasons", "2"))
	var t0 := Time.get_ticks_msec()
	print("PROG_PROBE1R2 seasons=%d seeds=%s" % [seasons, str(SEEDS)])
	var total_cells := 0
	for seed_val in SEEDS:
		rng.seed = seed_val
		var fighters := _make_population()
		total_cells += _run_arm(fighters, "A")
		total_cells += _run_arm(fighters, "B")
	_control_validate()
	_run_hold_sweep()
	_run_hold_units_sweep()
	print("PROG_PROBE done cells=%d (%.1fs)" % [total_cells, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)
func _make_population() -> Array:
	var pop: Array = []
	for p in Data.PROSPECTS: pop.append(_from_prospect(p))
	for i in 60: pop.append(_make_walkin(i))
	return pop
func _from_prospect(p: Dictionary) -> Dictionary:
	var f := {"id": str(p["id"]), "name": str(p["name"]), "first": str(p["first"]),
		"sex": str(p["sex"]), "age": int(p["age"]), "style": str(p["style"]),
		"stats": (p["stats"] as Dictionary).duplicate(true), "pot": int(p.get("pot", 75))}
	_init_state(f); return f
func _make_walkin(idx: int) -> Dictionary:
	var styles := ["Out-boxer", "Swarmer", "Pressure fighter", "Slugger", "Counter-puncher", "Volume puncher"]
	var f := {"id": "w%d" % idx, "name": "W%d" % idx, "first": "W%d" % idx,
		"sex": "f" if idx % 2 == 0 else "m", "age": 18 + rng.randi() % 12, "style": styles[idx % 6],
		"stats": {"power": 50.0 + rng.randf() * 20.0, "speed": 50.0 + rng.randf() * 20.0,
			"technique": 45.0 + rng.randf() * 20.0, "defense": 50.0 + rng.randf() * 15.0,
			"conditioning": 50.0 + rng.randf() * 20.0, "fight_iq": 45.0 + rng.randf() * 20.0,
			"chin": 50.0 + rng.randf() * 20.0}, "pot": 65 + rng.randi() % 25}
	_init_state(f); return f
func _init_state(f: Dictionary) -> void:
	var tech := float(f["stats"]["technique"])
	var moves := {}
	for m in Data.MOVES: moves[m] = maxf(30.0, PunchStart.mastery(tech, m))
	f["moves"] = moves; f["steps"] = MoveTree.day0_steps(float(f["stats"].get("speed", 55.0)))
	f["combos"] = {}; f["awards"] = []; f["award_sessions"] = 0; f["bout"] = {}
	f["phase"] = "base"; f["phase_day"] = 0; f["injured"] = false
	f["learning"] = "Uppercut"; f["learning_slots"] = []; f["cards"] = []; f["tray"] = []
func _run_arm(fighters: Array, arm: String) -> int:
	var cadence := {}; var cells := 0; var diag_printed := false
	for f in fighters:
		var fc: Dictionary = f.duplicate(true)
		var d: Dictionary = _sim_fighter(fc, arm)
		cadence[fc["id"]] = d; cells += d["cells"]
		if arm == "B" and not diag_printed:
			_print_arm_b_diagnostic(fc["id"], d); diag_printed = true
	_print_cadence(arm, cadence); return cells
func _sim_fighter(f: Dictionary, arm: String) -> Dictionary:
	var tw := seasons * WEEKS_PER_SEASON; var crossed := 0; var empty := 0; var picks := 0
	var fpw := -1; var r2w := -1; var r3w := -1; var styw := -1; var silw := -1; var cells := 0
	var pick_weeks: Array = []; var diag_weeks: Array = []
	for week in tw:
		var day := week * 7; f["phase_day"] = day
		var before := _snapshot_mastery(f)
		var wr: Dictionary
		if arm == "A": wr = _sim_week_arm_a(f, day)
		else:
			wr = _sim_fighter_arm_b_week(f, day, week, pick_weeks)
			if week < 4: diag_weeks.append({"week": week + 1, "cards": wr.get("cards_str", ""),
				"mins": wr.get("total_mins", 0.0), "mastery": _mastery_summary(f)})
			if week % 3 == 2:
				var pk := _pick_for(f, week)
				if not pk.is_empty(): picks += 1; if fpw < 0: fpw = week + 1
		cells += 1
		if _crossed(before, f): crossed += 1
		else: empty += 1
		if r2w < 0 and MoveTree.row_open(f, 2): r2w = week + 1
		if r3w < 0 and MoveTree.row_open(f, 3): r3w = week + 1
		if styw < 0 and not MoveTree.styles_held(f).is_empty(): styw = week + 1
		if silw < 0 and SkillAwards.passed(f).has("silver"): silw = week + 1
	return {"cells": cells, "crossed": crossed, "empty": empty, "picks": picks, "fpw": fpw,
		"r2w": r2w, "r3w": r3w, "styw": styw, "silw": silw, "tw": tw,
		"pick_weeks": pick_weeks, "diag_weeks": diag_weeks}
func _snapshot_mastery(f: Dictionary) -> Dictionary:
	var snap := {}
	for mv in f.get("moves", {}): snap["m:" + mv] = float(f["moves"][mv])
	for sid in f.get("steps", {}): snap["s:" + sid] = float(f["steps"][sid])
	return snap
func _crossed(before: Dictionary, f: Dictionary) -> bool:
	for k in before:
		var b: float = float(before[k])
		var a: float
		if k.begins_with("m:"): a = float(f["moves"].get(k.substr(2), 0.0))
		else: a = float(f["steps"].get(k.substr(2), 0.0))
		if (b < 30.0 and a >= 30.0) or (b < 60.0 and a >= 60.0) or (b < 85.0 and a >= 85.0): return true
	return false
func _mastery_summary(f: Dictionary) -> String:
	var parts: Array = []
	for mv in ["Jab", "Cross", "Lead hook"]:
		parts.append("%s=%d" % [mv, roundi(float(f["moves"].get(mv, 0.0)))])
	for sid in ["step_in", "step_out"]:
		parts.append("%s=%d" % [sid, roundi(float(f["steps"].get(sid, 0.0)))])
	return " ".join(parts)
func _sim_week_arm_a(f: Dictionary, day: int) -> Dictionary:
	var learn := str(f.get("learning", ""))
	if learn != "" and float(f.get("moves", {}).get(learn, 0.0)) >= 30.0:
		for m in Data.MOVES:
			if float(f.get("moves", {}).get(m, 0.0)) < 30.0: f["learning"] = m; break
	var nights := PadWeek.nights_for(1, false, false, false)
	var days: Array = nights.get("pads", [])
	var wp := {}; var all_p := ProgRules.all_punches_for_cards(f)
	if not days.is_empty() and not all_p.is_empty():
		var combo := ""; var ni := 0
		for p in all_p:
			if float(f.get("moves", {}).get(str(p), 0.0)) >= 30.0:
				combo = _combo_for(f, str(p)); if combo != "": break
		if combo != "" and ni < days.size():
			wp[PadWeek.DAYS[days[ni]]] = [{"card": "combo:" + combo, "share": 1.0}]; ni += 1
		var rem := days.size() - ni
		if rem > 0:
			var si := ((day / 7) * rem) % all_p.size()
			for ri in rem:
				wp[PadWeek.DAYS[days[ni + ri]]] = [{"card": "move:" + str(all_p[(si + ri) % all_p.size()]), "share": 1.0}]
	else: wp = PadWeek.defaults(f, nights)
	var r := PadWeek.run_week(f, nights, wp, 58.0, PadWeek.STATION_TIER, {}, [])
	for d in 7:
		if (nights.get("pads", []) as Array).has(d): SkillAwards.count_session(f, "pads")
		if (nights.get("spar", []) as Array).has(d): SkillAwards.count_session(f, "sparring")
	if day % 7 == 6: SkillAwards.assess(f, day)
	return r
func _sim_fighter_arm_b_week(f: Dictionary, day: int, week: int, pick_weeks: Array) -> Dictionary:
	var nights := PadWeek.nights_for(1, false, false, false)
	var slot := ProgRules.slot_moves(f, 58.0); var at30 := ProgRules.all_punches_for_cards(f)
	var days: Array = nights.get("pads", []); var wp := {}; var cl: Array = []; var tm := 0.0
	if not days.is_empty():
		var ni := 0
		for sm in slot:  # slot moves (under 30)
			if ni >= days.size(): break
			cl.append("move:" + str(sm)); wp[PadWeek.DAYS[days[ni]]] = [{"card": "move:" + str(sm), "share": 1.0}]; ni += 1
		var combo := ""  # one combo night
		for p in at30:
			if float(f.get("moves", {}).get(str(p), 0.0)) >= 30.0:
				combo = _combo_for(f, str(p)); if combo != "": break
		if combo != "" and ni < days.size():
			cl.append("combo:" + combo); wp[PadWeek.DAYS[days[ni]]] = [{"card": "combo:" + combo, "share": 1.0}]; ni += 1
		var rem := days.size() - ni  # remaining nights: rotate punches
		if rem > 0 and not at30.is_empty():
			var si := (week * rem) % at30.size()
			for ri in rem:
				var pc := "move:" + str(at30[(si + ri) % at30.size()])
				if not cl.has(pc): cl.append(pc)
				wp[PadWeek.DAYS[days[ni + ri]]] = [{"card": pc, "share": 1.0}]
	var r := PadWeek.run_week(f, nights, wp, 58.0, PadWeek.STATION_TIER, {}, [])
	for d in 7:
		if (nights.get("pads", []) as Array).has(d): SkillAwards.count_session(f, "pads")
		if (nights.get("spar", []) as Array).has(d): SkillAwards.count_session(f, "sparring")
	if day % 7 == 6: SkillAwards.assess(f, day)
	var shadow := ProgRules.shadow_mornings(f, 58.0, PadWeek.STATION_TIER)
	var units := {}
	for card in r.get("drilled", {}): _attr_units(units, str(card), float(r["drilled"][card]))
	for sid in shadow: _attr_units(units, str(sid), float(shadow[sid]))
	ProgRules.apply_hold(f, units, ProgRules.SHARP_HOLD_DEFAULT, ProgRules.SIGNATURE_HOLD_DEFAULT, ProgRules.is_frozen(f))
	_free_completed_slots(f)
	for c in cl: tm += PadWeek.minutes_for(c, wp, nights)
	return {"drilled": r.get("drilled", {}), "cards_str": ",".join(cl), "total_mins": tm, "shadow": shadow}
func _pick_for(f: Dictionary, week: int) -> Array:
	_free_completed_slots(f)
	var ls: Array = f.get("learning_slots", [])
	var sc: int = ProgRules.slot_count(58.0)
	if ls.size() >= sc:
		return []
	var gains := {}
	for n in MoveTree.NODES:
		gains[str(n["id"])] = ProgRules.SHADOW_MORNING_RATE * 1.0
	var cards := ProgRules.coach_cards(f, "Out-boxer", gains)
	if cards.is_empty():
		return []
	# Pick the first card that actually needs training (under 30)
	for card in cards:
		var cid := str(card["id"])
		if MoveTree.mastery(f, cid) < 30.0:
			if LearnSlots.pick(f, cid, sc):
				return [cid]
	# If all cards are at 30+ (already usable), try to pick any open node under 30
	for n in MoveTree.NODES:
		var nid := str(n["id"])
		if MoveTree.state(f, nid) == "open" and MoveTree.mastery(f, nid) < 30.0:
			if LearnSlots.pick(f, nid, sc):
				return [nid]
	return []
func _free_completed_slots(f: Dictionary) -> void:
	var ls: Array = f.get("learning_slots", [])
	var to_remove: Array = []
	for mv in ls:
		var m := MoveTree.mastery(f, str(mv))
		if m >= 30.0:
			to_remove.append(mv)
	for mv in to_remove:
		ls.erase(mv)
func _combo_for(f: Dictionary, mv: String) -> String:
	for b in Combos.BOOK:
		var moves := b["moves"] as Array
		if moves.has(mv):
			var ok := true
			for m in moves:
				if float(f.get("moves", {}).get(str(m), 0.0)) < Combos.LEARN_AT: ok = false; break
			if ok: return str(b["id"])
	return ""
func _attr_units(u: Dictionary, card: String, mins: float) -> void:
	if card.begins_with("move:"): u[card.substr(5)] = float(u.get(card.substr(5), 0.0)) + mins
	elif card.begins_with("combo:"):
		var row := Combos.row(card.substr(6)); var moves := row.get("moves", []) as Array
		if moves.is_empty(): return
		var sh := mins / float(moves.size())
		for m in moves: u[str(m)] = float(u.get(str(m), 0.0)) + sh
func _print_cadence(arm: String, data: Dictionary) -> void:
	var nf := data.size(); var tw := 0; var tc := 0; var te := 0; var tp := 0
	var fps := 0; var fpc := 0; var r2s := 0; var r2c := 0; var r3s := 0; var r3c := 0
	var sts := 0; var stc := 0; var sis := 0; var sic := 0
	var all_wtu: Array = []; var never_30 := 0
	for fid in data:
		var d: Dictionary = data[fid]; tw += int(d["tw"]); tc += int(d["crossed"]); te += int(d["empty"])
		tp += int(d["picks"])
		if int(d["fpw"]) > 0: fps += int(d["fpw"]); fpc += 1
		if int(d["r2w"]) > 0: r2s += int(d["r2w"]); r2c += 1
		if int(d["r3w"]) > 0: r3s += int(d["r3w"]); r3c += 1
		if int(d["styw"]) > 0: sts += int(d["styw"]); stc += 1
		if int(d["silw"]) > 0: sis += int(d["silw"]); sic += 1
		for pw in (d.get("pick_weeks", []) as Array):
			var wtu: int = int(pw["wtu"])
			if wtu > 0: all_wtu.append(wtu)
			else: never_30 += 1
	var cp := 100.0 * float(tc) / float(maxi(1, tw))
	var pp := float(tp) / float(maxi(1, nf))
	var fpa: String = ("%.0f" % (float(fps) / float(maxi(1, fpc)))) if fpc > 0 else "none"
	var r2a: String = ("%.0f" % (float(r2s) / float(maxi(1, r2c)))) if r2c > 0 else "none"
	var r3a: String = ("%.0f" % (float(r3s) / float(maxi(1, r3c)))) if r3c > 0 else "none"
	var sta: String = ("%.0f" % (float(sts) / float(maxi(1, stc)))) if stc > 0 else "none"
	var sia: String = ("%.0f" % (float(sis) / float(maxi(1, sic)))) if sic > 0 else "none"
	var wtu_str: String = "n/a"
	if not all_wtu.is_empty():
		all_wtu.sort()
		wtu_str = "%.0f" % float(all_wtu[all_wtu.size() / 2])
	print("CADENCE arm=%s crossed_weeks=%.0f%% picks_per_fighter=%.1f first_pick_week=%s row2_week=%s row3_week=%s style_week=%s silver_week=%s wtu_median=%s never_reached_30=%d" % [
		arm, cp, pp, fpa, r2a, r3a, sta, sia, wtu_str, never_30])
	print("EMPTY_GYM_WEEKS arm=%s n=%d" % [arm, te])
func _print_arm_b_diagnostic(fid: String, d: Dictionary) -> void:
	print("\nARM_B_DIAG fighter=%s" % fid)
	for w in (d.get("diag_weeks", []) as Array):
		print("  week=%d cards=%s mins=%.0f mastery=%s" % [int(w["week"]), str(w["cards"]), float(w["mins"]), str(w["mastery"])])
func _run_hold_sweep() -> void:
	print("\nHOLD1 SWEEP")
	for policy in ProgRules.HOLD_POLICIES:
		for ps in [4, 6, 7]: _run_hold_policy(policy, ps)
func _run_hold_policy(policy: String, ps: int) -> void:
	var fighters: Array = []
	for i in 4:
		var f := _make_walkin(100 + i)
		# Give varied moves at 60+ so hold policies have something to work with
		f["moves"]["Jab"] = 65.0 + i * 3.0; f["moves"]["Cross"] = 62.0 + i * 2.0
		f["moves"]["Lead hook"] = 61.0 + i; f["steps"]["step_in"] = 60.0 + i * 2.0
		if i > 1: f["moves"]["Body hook"] = 63.0 + i  # extra sharp for variety
		fighters.append(f)
	var plan: Array = []
	for node in MoveTree.NODES:
		if plan.size() >= ps: break
		plan.append(str(node["id"]))
	var tw := 2 * WEEKS_PER_SEASON; var shs := 0.0; var sgs := 0.0; var shc := 0; var sgc := 0; var hs := {}
	var pick_starts: Array = []; var wtu_vals: Array = []; var never_30 := 0
	for week in tw:
		for f in fighters:
			f["phase_day"] = week * 7
			var nights := PadWeek.nights_for(1, false, false, false)
			var wp := _hold_week_with_new(f, plan, policy, "Uppercut", week)
			var r := PadWeek.run_week(f, nights, wp, 58.0, PadWeek.STATION_TIER, {}, [])
			var shadow := ProgRules.shadow_mornings(f, 58.0, PadWeek.STATION_TIER)
			var u := {}
			for card in r.get("drilled", {}): _attr_units(u, str(card), float(r["drilled"][card]))
			for sid in shadow: _attr_units(u, str(sid), float(shadow[sid]))
			ProgRules.apply_hold(f, u, ProgRules.SHARP_HOLD_DEFAULT, ProgRules.SIGNATURE_HOLD_DEFAULT, false)
			if week == 0 and float(f["moves"].get("Uppercut", 0.0)) < 30.0:
				pick_starts.append({"fid": f["id"], "week": 0, "wtu": 0})
			if float(f["moves"].get("Uppercut", 0.0)) >= 30.0:
				for ps2 in pick_starts:
					if str(ps2["fid"]) == str(f["id"]) and int(ps2["wtu"]) <= 0:
						ps2["wtu"] = week + 1
	for f in fighters:
		for mv in f["moves"]:
			var m := float(f["moves"][mv])
			if m >= 60.0 and m < 85.0: shs += m; shc += 1
			elif m >= 85.0: sgs += m; sgc += 1
		var hk := ""
		for mv in f["moves"]:
			if float(f["moves"][mv]) >= 60.0: hk += mv + ","
		for sid in f["steps"]:
			if float(f["steps"][sid]) >= 60.0: hk += sid + ","
		hs[hk] = true
	for ps2 in pick_starts:
		var wtu: int = int(ps2.get("wtu", 0))
		if wtu > 0: wtu_vals.append(wtu)
		else: never_30 += 1
	var wtu_med: float = 0.0
	if not wtu_vals.is_empty():
		wtu_vals.sort(); wtu_med = float(wtu_vals[wtu_vals.size() / 2])
	print("HOLD policy=%s plan=%d sharp_held=%.1f signature_held=%.1f weeks_to_usable=%.1f never_30=%d distinct_sets=%d" % [
		policy, ps, shs / float(maxi(1, shc)), sgs / float(maxi(1, sgc)), wtu_med, never_30, hs.size()])
func _hold_week(f: Dictionary, plan: Array, policy: String) -> Dictionary:
	var targets := ProgRules.hold_targets(f, plan, policy); var nights := [0, 2]; var out := {}
	if targets.is_empty(): return out
	for i in nights.size():
		var mv: String = str(targets[i % targets.size()])
		out[PadWeek.DAYS[nights[i]]] = [{"card": "move:" + mv, "share": 1.0}]
	return out

## Hold week with remaining nights given to a new move being learned.
func _hold_week_with_new(f: Dictionary, plan: Array, policy: String, new_move: String, week: int) -> Dictionary:
	var targets := ProgRules.hold_targets(f, plan, policy)
	var all_nights := [0, 2, 4]  # Mon, Wed, Fri (Standard = 3 pad nights)
	var out := {}
	var used := 0
	# First 2 nights: hold targets
	for i in mini(2, all_nights.size()):
		if targets.is_empty():
			break
		var mv: String = str(targets[i % targets.size()])
		out[PadWeek.DAYS[all_nights[i]]] = [{"card": "move:" + mv, "share": 1.0}]
		used += 1
	# Remaining nights: new move (if it can be drilled, i.e. in f["moves"])
	if used < all_nights.size() and f["moves"].has(new_move):
		out[PadWeek.DAYS[all_nights[used]]] = [{"card": "move:" + new_move, "share": 1.0}]
	return out
func _run_hold_units_sweep() -> void:
	print("\nHOLD UNITS SWEEP")
	var best: Array = []; var bs := 999.0
	for sh in [10.0, 20.0, 30.0]:
		for sg in [20.0, 40.0, 60.0]:
			var r: Dictionary = _test_hu(sh, sg)
			var sc: float = float(r["wtu"]) + (100.0 if not bool(r["ok"]) else 0.0)
			if sc < bs: bs = sc; best = [sh, sg]
			print("  Sharp=%.0f Sig=%.0f holds_4sharp_1sig=%s weeks_to_usable=%.1f" % [sh, sg, str(r["ok"]), r["wtu"]])
	print("BEST PAIR: Sharp=%.0f Signature=%.0f" % [best[0], best[1]])
func _test_hu(sh: float, sg: float) -> Dictionary:
	var f := _make_walkin(200)
	var plan := ["Jab", "Cross", "Lead hook", "Body hook", "step_in"]
	f["moves"]["Jab"] = 65.0; f["moves"]["Cross"] = 62.0; f["moves"]["Lead hook"] = 61.0
	f["moves"]["Body hook"] = 63.0; f["steps"]["step_in"] = 60.0
	f["moves"]["Uppercut"] = 5.0
	var wtu := -1; var ok := false
	for week in 20:
		f["phase_day"] = week * 7
		var nights := PadWeek.nights_for(1, false, false, false)
		var wp := _hold_week_with_new(f, plan, "COACH", "Uppercut", week)
		var r := PadWeek.run_week(f, nights, wp, 58.0, PadWeek.STATION_TIER, {}, [])
		var shadow := ProgRules.shadow_mornings(f, 58.0, PadWeek.STATION_TIER)
		var u := {}
		for card in r.get("drilled", {}): _attr_units(u, str(card), float(r["drilled"][card]))
		for sid in shadow: _attr_units(u, str(sid), float(shadow[sid]))
		ProgRules.apply_hold(f, u, sh, sg, false)
		if wtu < 0 and float(f["moves"].get("Uppercut", 0.0)) >= 30.0: wtu = week + 1
		var sc := 0; var gc := 0
		for mv in f["moves"]:
			var m := float(f["moves"][mv])
			if m >= 60.0 and m < 85.0: sc += 1
			elif m >= 85.0: gc += 1
		for sid in f["steps"]:
			var m := float(f["steps"][sid])
			if m >= 60.0 and m < 85.0: sc += 1
			elif m >= 85.0: gc += 1
		if sc >= 4 and gc >= 1: ok = true
	return {"wtu": float(wtu if wtu >= 0 else 20), "ok": ok}
func _control_validate() -> void:
	print("\nCONTROL")
	var lucy := Data.PROSPECTS[0]
	var f := {"stats": (lucy["stats"] as Dictionary).duplicate(true),
		"moves": {}, "steps": MoveTree.day0_steps(float(lucy["stats"].get("speed", 55.0))), "learning_slots": []}
	var tech := float(f["stats"]["technique"])
	for m in Data.MOVES: f["moves"][m] = PunchStart.mastery(tech, m)
	var coach := 58.0; var tier := PadWeek.STATION_TIER; var cv := MoveMastery.cap(tech, float(f["stats"]["fight_iq"]))
	var sm0 := float(f["steps"]["step_in"])
	var sp := ProgRules.drill_step_def(f, "step_in", PadWeek.PAD_NIGHT_MINUTES, coach, tier)
	var sd := MoveMastery.gain(sm0, "shadowbox", PadWeek.PAD_NIGHT_MINUTES, coach, tier, 1.0, cv)
	var ok: bool = abs(sp - sd) < 0.01
	print("CONTROL jab_gain_per_pad_night=%.2f project=%.0f step_gain_per_shadow=%.2f" % [
		MoveMastery.gain(float(f["moves"]["Jab"]), "pads", PadWeek.PAD_NIGHT_MINUTES, coach, tier, 1.0, cv) - float(f["moves"]["Jab"]),
		PadWeek.PAD_NIGHT_MINUTES, sp - sm0])
	print("CONTROL_FORMULA probe_step=%.4f direct_step=%.4f %s" % [sp, sd, "OK" if ok else "MISMATCH"])
	if not ok: print("PROG_PROBE void: control")
	var f2 := {"stats": (lucy["stats"] as Dictionary).duplicate(true), "moves": {}, "steps": {}, "learning_slots": []}
	for m in Data.MOVES: f2["moves"][m] = PunchStart.mastery(tech, m)
	var jm0 := float(f2["moves"]["Jab"])
	var jp := MoveMastery.gain(jm0, "pads", PadWeek.PAD_NIGHT_MINUTES, coach, tier, 1.0, cv)
	var jd := PadWeek.drill(f2, "move:Jab", PadWeek.PAD_NIGHT_MINUTES, coach, tier, "pads")
	var ok2: bool = abs(jp - jd) < 0.01
	print("CONTROL_PAD pad_gain=%.4f drill_gain=%.4f %s" % [jp, jd, "OK" if ok2 else "MISMATCH"])
	print("CONTROL_HARNESS lucy_26w_crossed=%d" % _count_harness_lines(26))
func _count_harness_lines(weeks: int) -> int:
	var lucy := Data.PROSPECTS[0]
	var f := {"stats": (lucy["stats"] as Dictionary).duplicate(true),
		"moves": {}, "steps": MoveTree.day0_steps(float(lucy["stats"].get("speed", 55.0))),
		"combos": {}, "awards": [], "award_sessions": 0, "bout": {},
		"phase": "base", "phase_day": 0, "injured": false, "learning": "Uppercut",
		"learning_slots": [], "cards": [], "tray": []}
	var tech := float(f["stats"]["technique"])
	for m in Data.MOVES: f["moves"][m] = PunchStart.mastery(tech, m)
	var crossed := 0
	for week in weeks:
		var before := _snapshot_mastery(f)
		var nights := PadWeek.nights_for(1, false, false, false)
		var wp := PadWeek.defaults(f, nights)
		PadWeek.run_week(f, nights, wp, 58.0, PadWeek.STATION_TIER, {}, [])
		if _crossed(before, f): crossed += 1
	return crossed
