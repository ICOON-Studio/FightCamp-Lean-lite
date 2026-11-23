extends RefCounted
## FWLOAD2 report (tools/fwload2_probe.gd): per cell and rule arm, each load's and policy's win rate on paired dice; the
## five bars of ops/research/DESIGN_FWLOAD2.md s5 (fixed before any run); the tank check; bar 5 from the careers.

const LOAD_SHORT := {"rest_up": "REST", "tick_over": "TICK", "train_through": "THRU"}


static func _cid(cl: Array) -> String:
	return "t%d_%s_%s%s" % [int(cl[0]), "near" if bool(cl[1]) else "far", str(cl[2]), "_bout6" if bool(cl[3]) else ""]


## win% of the bouts fought for (rule, policy) in cell ci over rows with i % 2 == half (half -1 = all).
static func win(rows: Array, ci: int, rule: String, pol: String, half: int) -> float:
	var won := 0
	var fought := 0
	for r in rows:
		if int(r["cell"]) != ci or (half >= 0 and int(r["i"]) % 2 != half) or (r["picks"] as Dictionary).is_empty():
			continue
		var load := str(r["picks"][pol])
		var o: Dictionary = r["out"].get("%s|%s" % [rule, load], {})
		if bool(o.get("fought", false)):
			fought += 1
			won += int(bool(o["won"]))
	return 100.0 * won / maxf(1.0, float(fought))


static func mean(rows: Array, ci: int, rule: String, load: String, key: String) -> float:
	var s := 0.0
	var k := 0
	for r in rows:
		if int(r["cell"]) != ci:
			continue
		var o: Dictionary = r["out"].get("%s|%s" % [rule, load], {})
		if bool(o.get("fought", false)):
			s += float(o.get(key, 0.0)); k += 1
	return s / maxf(1.0, float(k))


static func cells(rows: Array, cl_list: Array, pols: Array, loads: Array, trial: bool) -> void:
	var tank_bad := 0
	var tank_n := 0
	var stale_lo := 999.0
	var stale_hi := -999.0
	for r in rows:
		for k in (r["out"] as Dictionary):
			var o: Dictionary = r["out"][k]
			if not bool(o.get("fought", false)):
				continue
			tank_n += 1
			stale_lo = minf(stale_lo, float(o["stale"])); stale_hi = maxf(stale_hi, float(o["stale"]))
			if str(k).begins_with("today") and absf(float(o["stale"]) - float(o["tank_game"])) > 0.01:
				tank_bad += 1
			if trial:
				print("FWLOAD2 TRIAL %s i%d %s won=%s t0=%d t_bell=%.1f tank_lock=%.0f tank_read=%.0f tank_game=%.1f stale=%.1f r1=%.1f m112=%.1f used112=%d toll=%.1f picks=%s" % [
					_cid(cl_list[int(r["cell"])]), int(r["i"]), str(k), str(o["won"]), int(o["t0"]), float(o["t_bell"]), float(o["tank_lock"]),
					float(o["tank_read"]), float(o["tank_game"]), float(o["stale"]), float(o["r1_edge"]), float(o["m112"]), int(o["used112"]),
					float(o["toll"]), str(r["picks"])])
	print("FWLOAD2 TANK CHECK: %d of %d TODAY bouts where bout.stale != BoutRules.tank_parts_for at the bell; stale range %.1f..%.1f" % [tank_bad, tank_n / 2, stale_lo, stale_hi])
	for rule in ["today", "changed"]:
		print("\nFWLOAD2 RULE %s - win%% by cell (paired dice; n per cell = rows)" % rule.to_upper())
		print("  cell                    REST  TICK  THRU | best  | pick(built) pickF reader | t_bell R/T/X        | m112 at bell R/T/X  | reader/pick picks")
		var best_n := {"rest_up": 0, "tick_over": 0, "train_through": 0}
		var gain := [0.0, 0.0]
		var beats_pick := 0
		var pick_right := 0
		var pickf_right := 0
		var oracle := 0.0
		for ci in cl_list.size():
			var w := {}
			w["rest_up"] = win(rows, ci, rule, "rest", -1); w["tick_over"] = win(rows, ci, rule, "tick", -1); w["train_through"] = win(rows, ci, rule, "through", -1)
			var top := maxf(float(w["rest_up"]), maxf(float(w["tick_over"]), float(w["train_through"])))
			var bests: Array = []
			for ld in loads:
				if float(w[ld]) >= top - 0.001:
					bests.append(ld); best_n[ld] = int(best_n[ld]) + 1
			var pk := win(rows, ci, rule, "pick", -1)
			var pf := win(rows, ci, rule, "pickf", -1)
			var rd := win(rows, ci, rule, "reader", -1)
			for h in 2:
				gain[h] = float(gain[h]) + win(rows, ci, rule, "reader", h) - win(rows, ci, rule, "tick", h)
				# the oracle: the best load picked on the other half, scored on this one
				var ob := "rest"
				for p in ["rest", "tick", "through"]:
					if win(rows, ci, rule, p, 1 - h) > win(rows, ci, rule, ob, 1 - h) + 0.001:
						ob = p
				oracle += win(rows, ci, rule, ob, h) - win(rows, ci, rule, "tick", h)
			beats_pick += int(rd - pk >= 2.0)
			pick_right += int(pk >= top - 2.0)
			pickf_right += int(pf >= top - 2.0)
			var pks := _pick_words(rows, ci)
			print("  %-22s %5.1f %5.1f %5.1f | %-5s | %5.1f %5.1f %5.1f | %4.1f/%4.1f/%4.1f | %4.1f/%4.1f/%4.1f | %s" % [_cid(cl_list[ci]),
				float(w["rest_up"]), float(w["tick_over"]), float(w["train_through"]), "/".join(bests.map(func(x): return LOAD_SHORT[x])),
				pk, pf, rd, mean(rows, ci, rule, "rest_up", "t_bell"), mean(rows, ci, rule, "tick_over", "t_bell"), mean(rows, ci, rule, "train_through", "t_bell"),
				mean(rows, ci, rule, "rest_up", "m112"), mean(rows, ci, rule, "tick_over", "m112"), mean(rows, ci, rule, "train_through", "m112"), pks])
		var nc := float(cl_list.size())
		var g0 := float(gain[0]) / nc
		var g1 := float(gain[1]) / nc
		print("FWLOAD2 %s BEST COUNT rest %d tick %d through %d (of %d)" % [rule, int(best_n["rest_up"]), int(best_n["tick_over"]), int(best_n["train_through"]), int(nc)])
		print("FWLOAD2 %s BAR1 no load best in more than half: %s" % [rule, "PASS" if maxi(int(best_n["rest_up"]), maxi(int(best_n["tick_over"]), int(best_n["train_through"]))) <= int(nc / 2) else "FAIL"])
		print("FWLOAD2 %s BAR2 each load best in 3+: %s" % [rule, "PASS" if mini(int(best_n["rest_up"]), mini(int(best_n["tick_over"]), int(best_n["train_through"]))) >= 3 else "FAIL"])
		print("FWLOAD2 %s BAR3 reader - always Tick over, wins in 100: half A %+.2f half B %+.2f -> %s" % [rule, g0, g1, "PASS" if g0 >= 3.0 and g1 >= 3.0 else "FAIL"])
		print("FWLOAD2 %s BAR4 reader beats the pick as built by 2+ in %d cells (need 4); the pick within 2 of the best in %d of %d, pick with the facts in %d -> %s" % [rule, beats_pick, pick_right, int(nc), pickf_right, "PASS" if beats_pick >= 4 else ("PICK PLAYS IT" if pick_right >= 16 else "FAIL")])
		print("FWLOAD2 %s ORACLE (best load chosen on the other half) - always Tick over: %+.2f wins in 100 (mean of halves)" % [rule, oracle / (2.0 * nc)])


static func _pick_words(rows: Array, ci: int) -> String:
	for r in rows:
		if int(r["cell"]) == ci and not (r["picks"] as Dictionary).is_empty():
			return "%s/%s/%s" % [LOAD_SHORT[str(r["picks"]["reader"])], LOAD_SHORT[str(r["picks"]["pick"])], LOAD_SHORT[str(r["picks"]["pickf"])]]
	return "-"


## Bar 5: tiredness at each of 8 weekly bells per arm; the tank inside 0-100.
static func careers(table: Dictionary, rules: Array, pols: Array) -> void:
	var bad := 0
	for rule in rules:
		for pol in pols:
			var tb: Array = table["%s|%s" % [rule, pol]]
			var line := "FWLOAD2 CAREER %s %-7s t_bell by week:" % [rule, pol]
			var prev := -1.0
			var ups := 0
			var first := 0.0
			var last := 0.0
			var wins := 0
			var fought := 0
			var lo := 999.0
			var hi := -999.0
			var loads := {}
			for w in tb.size():
				var s := 0.0
				var k := 0
				for e in tb[w]:
					s += float(e["t_bell"]); k += 1
					if bool(e["fought"]):
						fought += 1; wins += int(bool(e["won"]))
						lo = minf(lo, float(e["stale"])); hi = maxf(hi, float(e["stale"]))
					loads[str(e["load"])] = int(loads.get(str(e["load"]), 0)) + 1
				var mt := s / maxf(1.0, float(k))
				line += " %.1f" % mt
				if prev >= 0.0 and mt > prev + 0.05:
					ups += 1
				if w == 1:
					first = mt
				last = mt
				prev = mt
			var runaway := ups >= tb.size() - 1 or last > first + 10.0 or lo < 0.0 or hi > 100.0
			bad += int(runaway)
			print("%s | rises %d of %d | tank off %.1f..%.1f | win %.1f%% of %d | loads %s | %s" % [line, ups, tb.size() - 1, lo, hi, 100.0 * wins / maxf(1.0, float(fought)), fought, str(loads), "RUNAWAY" if runaway else "ok"])
	print("FWLOAD2 BAR5 nothing runs away: %s (%d arms flagged)" % ["PASS" if bad == 0 else "FAIL", bad])
