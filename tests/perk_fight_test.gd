extends SceneTree
## S355 the perks' fight effects (PerkFight + its hooks in BoutNight / LiveRound / Knockdowns): each of the eight perks,
## on vs off for the same fighter on the same nights (same seeds), moves its own number the way its card says; without a
## perk the hooks fire nothing. Bounds, never exact counts; the measured effects are printed (they feed the perk cards).
## Population: Lucy (Data.lucy: out-boxer, chin 66) vs Maria (pressure fighter 61.5), Erin (volume puncher 65.5) and Dana
## (Data.MISMATCH, boxer-puncher 72); a hard-hit Lucy (chin 50) vs Dana for the counts; a heavy-handed Lucy (power 80) vs
## Maria for the stoppages; Lucy with a drilled double jab in her plan for Fast hands. NIGHTS each.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PF := preload("res://scripts/rules/PerkFight.gd")
const NIGHTS := 160
const MARIA := 0   # Data.OPPONENTS; -1 = Data.MISMATCH (Dana)
const ERIN := 2
const DANA := -1

var _fails := 0


func _initialize() -> void:
	_units()
	var none_m := _arm(MARIA, [], {})
	_check(none_m["fired"].is_empty() and int(none_m["staggers"]) == 0, "no perks: the hooks fire nothing (%s)" % str(none_m["fired"]))

	var hit := {"stats": {"chin": 50.0}}
	var ic0 := _arm(DANA, [], hit)
	var ic1 := _arm(DANA, ["iron_chin"], hit)
	print("  Iron chin (chin 50 vs Dana): her counts %d -> %d, staggers %d, stopped %d -> %d" % [ic0["her_counts"], ic1["her_counts"],
		ic1["staggers"], ic0["her_stopped"], ic1["her_stopped"]])
	_check(int(ic1["staggers"]) >= 5 and int(ic1["staggers"]) <= NIGHTS, "Iron chin: the first count becomes a stagger, at most once a bout (%d)" % ic1["staggers"])
	_check(int(ic1["her_counts"]) < int(ic0["her_counts"]) and int(ic1["her_stopped"]) <= int(ic0["her_stopped"]), "Iron chin: fewer counts, no more stoppages")

	var sw0 := _arm(MARIA, [], {})
	var sw1 := _arm(MARIA, ["second_wind"], {})
	var lift := float(sw1["r3_energy"]) - float(sw0["r3_energy"])
	print("  Second wind: round-3 energy at the bell %.1f -> %.1f" % [sw0["r3_energy"], sw1["r3_energy"]])
	_check(lift >= 5.0 and lift <= PF.SECOND_WIND + 0.01, "Second wind: round 3 starts with up to +10 energy (+%.1f)" % lift)

	for row in [["stiff_jab", MARIA, {}], ["ring_general", ERIN, {}], ["counter_sense", MARIA, {}]]:
		var a0 := _arm(int(row[1]), [], row[2])
		var a1 := _arm(int(row[1]), [str(row[0])], row[2])
		print("  %s vs %s: rounds won %d -> %d, landed %d -> %d, bouts she counts the opponent %d -> %d, stoppages %d -> %d, fired %d" % [
			PF.NAMES[row[0]], _opp(int(row[1]))["first"], a0["won"], a1["won"], a0["landed"], a1["landed"], a0["opp_counted"],
			a1["opp_counted"], a0["opp_stopped"], a1["opp_stopped"], int(a1["fired"].get(row[0], 0))])
		_check(int(a1["fired"].get(row[0], 0)) > 0, "%s fires" % PF.NAMES[row[0]])
		if row[0] == "counter_sense":
			# A counter is a punch after the exchange is settled: more landed and more damage, not more exchanges won (and
			# the stoppages it brings end bouts early, so rounds won is the wrong measure).
			_check(int(a1["landed"]) > int(a0["landed"]) and int(a1["opp_counted"]) >= int(a0["opp_counted"]), "Counter sense: more punches landed, no fewer counts")
		else:
			_check(int(a1["won"]) > int(a0["won"]), "%s: more rounds won (%d -> %d)" % [PF.NAMES[row[0]], a0["won"], a1["won"]])

	var bs0 := _arm(MARIA, [], {"stats": {"power": 66.0}})
	var bs1 := _arm(MARIA, ["body_snatcher"], {"stats": {"power": 66.0}})
	print("  Body snatcher: Maria's energy at the last bell %.1f -> %.1f" % [bs0["opp_end"], bs1["opp_end"]])
	_check(float(bs1["opp_end"]) < float(bs0["opp_end"]), "Body snatcher: the opponent ends the fight emptier")

	var big := {"stats": {"power": 80.0}}
	var fi0 := _arm(MARIA, [], big)
	var fi1 := _arm(MARIA, ["finisher"], big)
	print("  Finisher (power 80 vs Maria): bouts she counts Maria %d, stoppages %d -> %d" % [fi0["opp_counted"], fi0["opp_stopped"], fi1["opp_stopped"]])
	_check(int(fi0["opp_counted"]) >= 10, "Finisher population: Maria is counted in some bouts (%d)" % fi0["opp_counted"])
	_check(int(fi1["opp_stopped"]) > int(fi0["opp_stopped"]), "Finisher: more stoppages once she is counted")

	var plan := {"arrows": [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}], "combos": {"1-1": 60.0}}
	var fh0 := _arm(MARIA, [], plan)
	var fh1 := _arm(MARIA, ["hand_speed"], plan)
	print("  Fast hands (double jab drilled 60): rounds won %d -> %d, fired %d" % [fh0["won"], fh1["won"], int(fh1["fired"].get("hand_speed", 0))])
	_check(int(fh1["fired"].get("hand_speed", 0)) > 0, "Fast hands fires on the drilled combination")
	_check(int(fh1["won"]) >= int(fh0["won"]), "Fast hands: no fewer rounds won")
	print("FAILURES %d" % _fails)
	quit(1 if _fails > 0 else 0)


## NIGHTS bouts of a fresh Lucy (tweak: {"stats": {...}} merged, other keys set) with these perks against one opponent.
func _arm(opp_i: int, perks: Array, tweak: Dictionary) -> Dictionary:
	var out := {"won": 0, "landed": 0, "her_counts": 0, "her_stopped": 0, "opp_counted": 0, "opp_stopped": 0, "staggers": 0,
		"r3_energy": 0.0, "opp_end": 0.0, "fired": {}}
	var c := Career.quick_start()
	c.fighters.insert(0, {})
	var r3 := 0
	for i in NIGHTS:
		c.day = 20 + i
		c.news.clear()
		var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
		for k in tweak.keys():
			if k == "stats":
				(f["stats"] as Dictionary).merge(tweak[k], true)
			else:
				f[k] = str_to_var(var_to_str(tweak[k]))   # a fresh copy a night (the bout may train her combos)
		f["perks"] = {}
		for p in perks:
			f["perks"][p] = 1
		c.fighters[0] = f
		f["bout"] = {"opp": _opp(opp_i), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		f["camp"] = {}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		var rounds: Array = m["rounds"]
		for r in rounds:
			out["won"] = int(out["won"]) + int(bool(r["won"]))
			out["landed"] = int(out["landed"]) + int((r["landed"] as Array)[0])
			if str(r.get("down", "")) == "a":
				out["her_counts"] = int(out["her_counts"]) + int(r["counts"])
			out["staggers"] = int(out["staggers"]) + int(bool(r.get("stagger", false)))
			for x in r["exchanges"]:
				for id in (x as Dictionary).get("perks", []):
					out["fired"][id] = int(out["fired"].get(id, 0)) + 1
		if rounds.size() >= 3:
			out["r3_energy"] = float(out["r3_energy"]) + float((rounds[2]["energy"] as Dictionary)["a"])
			r3 += 1
		var last_ex: Dictionary = (rounds[-1]["exchanges"] as Array)[-1]
		out["opp_end"] = float(out["opp_end"]) + float(last_ex["after"]["b"])
		if rounds.any(func(r): return str(r.get("down", "")) == "b"):
			out["opp_counted"] = int(out["opp_counted"]) + 1
		var stop := str(m.get("stopped", ""))
		if stop != "":
			var key := "her_stopped" if str(rounds[-1]["down"]) == "a" else "opp_stopped"
			out[key] = int(out[key]) + 1
	out["r3_energy"] = float(out["r3_energy"]) / maxf(1.0, float(r3))
	out["opp_end"] = float(out["opp_end"]) / float(NIGHTS)
	return out


func _opp(i: int) -> Dictionary:
	return ((Data.MISMATCH if i < 0 else Data.OPPONENTS[i]) as Dictionary).duplicate(true)


func _units() -> void:
	var with := {"perks": {"iron_chin": 1, "stiff_jab": 1, "second_wind": 1, "ring_general": 1, "counter_sense": 1,
		"body_snatcher": 1, "finisher": 1, "hand_speed": 1}}
	var without := {"perks": {}}
	var one: Dictionary = PF.iron_chin({"counts": 1, "up_at": [6], "how": "", "stopped": false, "waved": false, "ko": false}, 0)
	_check(int(one["counts"]) == 0 and str(one["how"]) == "" and bool(one["stagger"]), "Iron chin: one count -> a stagger, no stoppage")
	var waved: Dictionary = PF.iron_chin({"counts": 1, "up_at": [6], "how": "RSC", "stopped": true, "waved": true, "ko": false}, 0)
	_check(str(waved["how"]) == "" and not bool(waved["stopped"]), "Iron chin: no count left, nothing to wave off")
	var three: Dictionary = PF.iron_chin({"counts": 3, "up_at": [6, 6, 7], "how": "RSC", "stopped": true, "waved": false, "ko": false}, 0)
	_check(int(three["counts"]) == 2 and str(three["how"]) == "", "Iron chin: three counts -> two, under the round's stop")
	var late: Dictionary = PF.iron_chin({"counts": 2, "up_at": [6, 6], "how": "RSC", "stopped": true, "waved": false, "ko": false}, 3)
	_check(str(late["how"]) == "RSC", "Iron chin: the bout's fourth count still stops it")
	_check(PF.stop_mult(with) == 1.5 and PF.stop_mult(without) == 1.0, "Finisher: 1.5x the referee's stoppage odds")
	_check(PF.second_wind(with, 3, 40.0) == 50.0 and PF.second_wind(with, 3, 95.0) == 100.0 and PF.second_wind(with, 2, 40.0) == 40.0
		and PF.second_wind(without, 3, 40.0) == 40.0, "Second wind: +10 at round 3 only, capped at the tank")
	_check(PF.jab_edge(with, "press") == 3.0 and PF.jab_edge(with, "range") == 0.0 and PF.jab_edge(without, "press") == 0.0, "Stiff jab: +3 against pressure only")
	_check(PF.call_edge(with, 10.0) == 12.5 and PF.call_edge(with, -7.0) == -7.0 and PF.call_edge(without, 10.0) == 10.0, "Ring general: a helping call x1.25, a wrong one unchanged")
	_check(PF.counters(with, "press", true, 0.1) and not PF.counters(with, "press", true, 0.5) and not PF.counters(with, "range", true, 0.1)
		and not PF.counters(with, "loadup", false, 0.1) and not PF.counters(without, "press", true, 0.1), "Counter sense: 30% on an attack she beats")
	_check(is_equal_approx(PF.body_cost(with), 1.2 * 1.15) and PF.body_cost(without) == 1.2, "Body snatcher: body shots cost 15% more")
	_check(PF.combo_rate(with, "1-2") == PF.FAST_HANDS and PF.combo_rate(with, "step_back") == 1.0 and PF.combo_rate(without, "1-2") == 1.0, "Fast hands: combinations only")
	_check(is_equal_approx(PF.setup_edge(with, 10.0), 10.0 * PF.FAST_HANDS) and PF.setup_edge(with, -4.0) == -4.0, "Fast hands: a set-up that helps x1.25")
	var line: String = PF.round_line([{"perks": ["stiff_jab"]}, {"perks": ["stiff_jab", "ring_general"]}, {}], "Lucy")
	_check(line == "Lucy's perks at work: Stiff jab x2, Ring general x1." and PF.round_line([{}], "Lucy") == "", "the round's perk line: %s" % line)


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
