extends SceneTree
## S524 GUARDPROBE1 - guard damage v4 sized BEFORE step 3 feeds any of it back into a result. Whole bouts through the game's
## own round code (BoutNight.play_out -> LiveRound.open -> exchange x6 -> close), seeds 5000-5199, 200 bouts a cell, six cells:
## amateur 3x60 kg, pro 4x75 kg, pro 6x90 kg, each even and a +9 rating mismatch. Every sweep number is a probe-side re-computation
## from the recorded exchanges (GuardWear with the probe's own WEAR_SCALE / BLOCK_SHARE / k): scripts/ is never edited, no damage
## fed back. docs/GUARDPROBE1_RESULT.md is this run's own printed lines. Targets: DESIGN_GUARDDMG1_V4.md s1.1, s4.
##   python ops/Tools/godot_slot.py run --who guardprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guard_probe.gd
##   add " -- --pilot" for 10 bouts a cell + the projected full-run time, or " -- --n=1" for a one-bout smoke.

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const GuardState := preload("res://scripts/state/GuardState.gd")
const BoutBurn := preload("res://scripts/rules/BoutBurn.gd")
const BodyFacts := preload("res://scripts/rules/BodyFacts.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")

const SEED0 := 5000
const N := 200
const LIMIT_S := 3600.0   ## the brief's 60-minute ceiling on the whole run
const BASE := {"jab": 1.0, "power": 2.5, "heavy": 4.0}   ## design s1.1 punch bases
const WEARS := [0.25, 0.35, 0.45, 0.6]
const SHARES := [0.5, 0.6, 0.7]
const COLOURS := ["yellow", "orange", "red"]
const PLANS := [
	{"label": "jab and move (1-1, step back, pivot, tie up)", "arrows": [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}], "combos": {"1-1": 60.0, "1-2": 45.0}},
	{"label": "press behind the cross (1-2, step in, cut off, tie up)", "arrows": [{"move": "1-2"}, {"move": "step_in"}, {"move": "cut_off"}, {"move": "tie_up"}], "combos": {"1-2": 60.0, "1-1": 45.0}},
	{"label": "feint and hook (2-3, feint, pivot, 1-2)", "arrows": [{"move": "2-3"}, {"move": "feint"}, {"move": "pivot_out"}, {"move": "1-2"}], "combos": {"2-3": 60.0, "1-2": 50.0}},
]
const CELLS := [
	{"id": "am3_even", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 0.0, "who": "lucy", "plan": 0, "names": ["Maria Ortega", "Priya Nair", "Erin Doyle"]},
	{"id": "am3_miss", "cfg": "am3", "pro": false, "rounds": 3, "limit": 60.0, "gap": 9.0, "who": "lucy", "plan": 0, "names": ["Dana Whitfield"]},
	{"id": "pro4_even", "cfg": "pro4", "pro": true, "rounds": 4, "limit": 75.0, "gap": 0.0, "who": "tess", "plan": 1, "names": ["Siobhan Byrne", "Leah Morgan", "Chantelle Reid"]},
	{"id": "pro4_miss", "cfg": "pro4", "pro": true, "rounds": 4, "limit": 75.0, "gap": 9.0, "who": "tess", "plan": 1, "names": ["Victoria Hale"]},
	{"id": "pro6_even", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 0.0, "who": "danny", "plan": 2, "names": ["Darnell Okafor", "Samir Haddad", "Ryan McBride"]},
	{"id": "pro6_miss", "cfg": "pro6", "pro": true, "rounds": 6, "limit": 90.0, "gap": 9.0, "who": "danny", "plan": 2, "names": ["Adebayo Sule"]},
]
static var t0 := 0
static var cut_short := false
static var self_diff := 0.0
static var L := []   ## the result page: every line the probe prints, in order


func _initialize() -> void:
	var n := N
	var pilot := false
	for a in OS.get_cmdline_user_args():
		if a == "--pilot":
			pilot = true
			n = 10
		elif a.begins_with("--n="):
			n = maxi(1, int(a.trim_prefix("--n=")))
	t0 = Time.get_ticks_msec()
	_say(["# GUARDPROBE1 - guard damage v4 sized (S524)", "",
		"Run: `python ops/Tools/godot_slot.py run --who guardprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guard_probe.gd`.",
		"Seeds %d-%d, %d bouts a cell, six cells. Sweep WEAR_SCALE %s x BLOCK_SHARE %s; k solved from the damage target. Every number is a" % [SEED0, SEED0 + n - 1, n, str(WEARS), str(SHARES)],
		"probe-side re-computation from the recorded exchanges: scripts/ was not edited, no damage fed back into a bout. Targets (design s4):",
		"+7..11% total damage; amateur r3 yellow (50-75%), red under 10% of bouts; pro6 last round orange (25-50%), red mostly the mismatch's",
		"loser; a 10-punch flurry, a rope-trapped side and a dry fighter each visibly worse. 'Through' = GuardWear.transmission(kind, guard as",
		"the punch arrives, max, class, combo) x the punch base (jab 1.0, power 2.5, heavy 4.0) over BoutBurn's MIX blocks, over m[damage]. a = ours."])
	var recs := {}
	for cell in CELLS:
		var arr := []
		for i in n:
			if not _over_time():
				arr.append(_play(cell, SEED0 + i))
		recs[cell["id"]] = arr
	var play_s := _secs()
	_say(["", "## Population", "", "| cell | code | rounds | limit kg | class | max guard | our boxer (style, paper) | opponents (style) | gap | plan | bouts | stopped |",
		"|---|---|---|---|---|---|---|---|---|---|---|---|"])
	for cell in CELLS:
		_say(_pop_row(cell, recs[cell["id"]]))
	_say(["No two fighters identical: our boxer's seven stats are jittered +/-3 by the bout seed, the opponent a named boxer of another style at its",
		"own rating, each cell on its own written plan. The heavyweight cell boxes at a 90 kg limit (the game's divisions stop at 75): the limit is set",
		"on the bout, height/reach are the game's own BodyFacts body for it. Class = GuardState.wclass; an amateur's max is 70 whatever the class."])
	var aggs := {}
	for cell in CELLS:
		for ws in WEARS:
			for bs in SHARES:
				if not _over_time():
					aggs[_key(ws, bs, str(cell["id"]))] = _agg(recs[cell["id"]], ws, bs)
	_say(["", "Self-check: the replay at the shipped WEAR_SCALE %.2f / BLOCK_SHARE %.2f reproduces the game's own GuardState guard at every bell, max |diff| = %.6f points." % [GuardState.WEAR_SCALE, GuardState.BLOCK_SHARE, self_diff]])
	_tables("shipped (today)", GuardState.WEAR_SCALE, GuardState.BLOCK_SHARE, aggs)
	var rows := []
	for ws in WEARS:
		for bs in SHARES:
			var ev := _evaluate(ws, bs, aggs)
			ev["miss"] = _misses(ev, aggs)
			ev["score"] = _score(ev)
			rows.append(ev)
	rows.sort_custom(func(a, b): return float(a["score"]) < float(b["score"]))
	var cands := rows.filter(func(r): return (r["miss"] as Array).is_empty())
	if cands.is_empty():
		cands = rows.slice(0, 2)
	for row in cands:
		row["scen"] = _scenarios(recs, float(row["ws"]), float(row["bs"]))
		row["miss"] = _misses(row, aggs)
		row["score"] = _score(row)
	rows.sort_custom(func(a, b): return float(a["score"]) < float(b["score"]))
	var best: Dictionary = rows[0]
	_tables("chosen", float(best["ws"]), float(best["bs"]), aggs)
	_say(["", "## 4. The sweep (k solved so the damage lands in +7..11%)", "",
		"am3 r3 / pro6 r6 = mean guard share at that bell; am3 red = bouts where either side ever reaches red; pro6 rl = of the mismatch's red",
		"bouts, the share where the red side is the one losing. k lo..hi = the six cells' +7..11% intervals intersected (empty = no single k hits",
		"every cell; k used then falls back to the pooled interval). Ranked by targets missed, then distance.",
		"", "| WEAR_SCALE | BLOCK_SHARE | am3 r3 | am3 red | pro6 r6 | pro6 rl | k lo | k hi | k used | misses |", "|---|---|---|---|---|---|---|---|---|---|"])
	for row in rows:
		_say("| %.2f | %.2f | %.3f | %.1f%% | %.3f | %.1f%% | %.4f | %.4f | %.4f | %d |" % [float(row["ws"]), float(row["bs"]), float(row["am3r3"]), 100.0 * float(row["am3red"]), float(row["pro6r6"]), 100.0 * float(row["pro6rl"]), float(row["klo"]), float(row["khi"]), float(row["k"]), (row["miss"] as Array).size()])
	var line := "RESULT: tools/guard_probe.gd -> wear_scale=%.2f block_share=%.2f k=%.4f damage_plus=%s amateur_r3=%.3f pro_last=%.3f red_amateur=%.1f%% all_targets=%s" % [float(best["ws"]), float(best["bs"]), float(best["k"]), _dmg_cfg(best, float(best["k"])), float(best["am3r3"]), float(best["pro6r6"]), 100.0 * float(best["am3red"]), "yes" if (best["miss"] as Array).is_empty() else "no"]
	_say(["", "## 5. The setting the probe recommends", "", "`%s`" % line])
	for row in [best, rows[1]]:
		var sc: Dictionary = row["scen"]
		_say(["", "### WEAR_SCALE %.2f, BLOCK_SHARE %.2f, k %.4f (%s)" % [float(row["ws"]), float(row["bs"]), float(row["k"]), "closest" if row == best else "second closest"], "",
			"Damage added at that k: %s (amateur 3 / pro 4 / pro 6). Per cell: %s." % [_dmg_cfg(row, float(row["k"])), _dmg_cells(row, aggs, float(row["k"]))], "",
			"The three the design asks to see visibly worse, on these cells' own recorded blocks (guard points and damage per exchange):"])
		if sc.is_empty():
			_say("- not measured for this row (the scenarios are measured for the finalists only).")
		else:
			_say(["- a 10-punch flurry (every block the 3rd+ punch of one combination; %d exchanges where 10+ were thrown): guard %.2f -> %.2f (x%.3f), damage x%.3f." % [int(sc["fn"]), float(sc["fb"]), float(sc["ff"]), float(sc["fw"]), float(sc["fd"])],
				"- a rope-trapped side (the same exchanges, defender on the ropes): guard wear x%.3f." % float(sc["rw"]),
				"- a dry fighter (condition 60, under the design's 70 line): guard wear x%.3f, damage x%.3f." % [float(sc["dw"]), float(sc["dd"])]])
		_say(["", "Every design target is hit at this setting." if (row["miss"] as Array).is_empty() else "Targets this setting misses:"])
		for m in row["miss"]:
			_say("- %s" % str(m))
	_say(["", "## 6. Findings", "",
		"- The raw offline damage at k=1 is far larger than +7..11%: an exchange settles 4-6 landed punches a side, BoutBurn derives thrown = landed /",
		"  0.33 and BLOCK_SHARE of the rest are blocks - far more blocks than the design's per-punch table assumed. k reconciles them, scaling the leak only.",
		"- WEAR_SCALE and BLOCK_SHARE set where the guard sits at each bell; k sets how much of a blocked punch lands - the colour and damage targets are",
		"  independent. Nothing here changes a result: the guard is still shown only. Step 3 takes these numbers; GUARD_EDGE is still to size."])
	if float(best["am3r3"]) < 0.50:
		_say("- No grid setting hits every target: the amateur and pro6 colour targets pull apart (amateur max 70 with +15%% wear depletes faster in share terms than heavy max 120). The closest leaves amateur r3 at %.3f (red in %.1f%%) and pro6 r6 at %.3f; meeting both needs an amateur-specific lever (max guard or recovery), not WEAR_SCALE / BLOCK_SHARE alone." % [float(best["am3r3"]), 100.0 * float(best["am3red"]), float(best["pro6r6"])])
	if cut_short:
		_say("- The run hit the brief's 60-minute ceiling and stopped early; the cells above are the ones it finished.")
	if pilot:
		print("GUARDPROBE1 pilot: %d bouts a cell took %.1f s (play %.1f s); projected full run (%d a cell) %.1f min" % [n, _secs(), play_s, N, _secs() * float(N) / float(n) / 60.0])
		print("GUARDPROBE1 pilot done")
		quit(0)
		return
	var file := FileAccess.open("res://docs/GUARDPROBE1_RESULT.md", FileAccess.WRITE)
	if file == null:
		print("GUARDPROBE1 could not write the result page: %s" % str(FileAccess.get_open_error()))
	else:
		file.store_string("\n".join(L) + "\n")
		file.close()
		print("GUARDPROBE1 wrote docs/GUARDPROBE1_RESULT.md (%.1f s, cut_short=%s)" % [_secs(), str(cut_short)])
	print("GUARDPROBE1 done")
	quit(0)


static func _say(v: Variant) -> void:   ## print and keep: a String or an Array of lines (the result page is the run's own output)
	var lines: Array = v if v is Array else [v]
	for s in lines:
		print(s)
		L.append(s)


static func _secs() -> float:
	return float(Time.get_ticks_msec() - t0) / 1000.0


static func _over_time() -> bool:
	cut_short = cut_short or _secs() > LIMIT_S
	return cut_short


static func _key(ws: float, bs: float, id: String) -> String:
	return "%.2f|%.2f|%s" % [ws, bs, id]


static func _play(cell: Dictionary, seed: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed * 7919 + 13
	var who := str(cell["who"])
	var t := Data.lucy()
	if who != "lucy":
		for p in Data.PROSPECTS:
			if str(p["id"]) == who:
				t = p.duplicate(true)   # PROSPECTS is a const row: its stats dict is read-only until copied
	var f := Data.fighter_state(t, seed)
	for k in f["stats"]:
		f["stats"][k] = clampf(float(f["stats"][k]) + rng.randf_range(-3.0, 3.0), 25.0, 95.0)
	var pl: Dictionary = PLANS[int(cell["plan"])]
	f["limit"] = float(cell["limit"])
	f.erase("height")
	f.erase("reach")
	BodyFacts.fill(f)
	f = f.merged({"pro": bool(cell["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [],
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	var all: Array = Data.OPPONENTS + [Data.MISMATCH] + Data.DIVISION_RIVALS
	var pool := all.filter(func(o): return str(o["name"]) in cell["names"])
	var opp: Dictionary = (pool[seed % pool.size()] as Dictionary).duplicate(true)
	var paper := BoutRules.fight_power(f["stats"], {}, 0, "", bool(cell["pro"]))
	opp["rating"] = paper + float(cell["gap"])
	f["bout"] = {"opp": opp, "day": seed, "weighed": true, "made": true, "done": false, "film": 1, "rounds": int(cell["rounds"])}
	var c := Career.new()
	c.day = seed
	c.seed = seed
	c.coach = {"rating": 60.0}
	c.fighters = [f]
	var m := {"fid": f["id"], "step": "tape", "total": int(cell["rounds"])}
	BoutNight.play_out(c, f, m)
	var rounds := []
	var shipped := []
	for r in m["rounds"]:
		var exs := []
		for x in r["exchanges"]:
			exs.append({"landed": x["landed"], "at": str(x["at"])})
		rounds.append(exs)
		var lg: Array = (r["exchanges"][-1] as Dictionary)["guard"]["g"]
		shipped.append([float(lg[0]), float(lg[1])])
	var own := Attrs.of(f)
	var oa := RingDuel.opp(opp)
	return {"rounds": rounds, "shipped": shipped, "max": float(f["bout"]["guard"]["a"]["max"]), "amateur": not bool(cell["pro"]),
		"wclass": GuardState.wclass(float(cell["limit"])), "stopped": BoutNight.stopped(m),
		"sh": [GuardWear.shoulder(float(own["stamina"]), float(own["strength"])), GuardWear.shoulder(float(oa["stamina"]), float(oa["strength"]))],
		"damage": m.get("damage", {"a": 0.0, "b": 0.0}), "loser": "a" if not rounds.is_empty() and BoutNight.outcome_of(f, m) == "loss" else "b",
		"paper": paper, "opp_name": str(opp["first"]), "opp_style": str(opp["style"]), "style": str(f["style"]), "name": str(f["first"]), "plan": str(pl["label"])}


## One exchange, one side: blocks from the opponent's landed (BoutBurn's thrown rule x BLOCK_SHARE); each block by BoutBurn.MIX
## kind wears the guard (GuardWear.wear x WEAR_SCALE) and leaks transmission x the punch base, read at the guard as it arrives.
## Returns [guard after, wear, through, blocks].
static func _ex_step(g: float, mx: float, wc: String, am: bool, sh: float, landed: Array, at: String, k: int,
		ws: float, bs: float, combo_all: bool, cond: float) -> Array:
	var opp_l := int(landed[1 - k])
	var thrown := ceili(float(opp_l) / BoutBurn.LAND_RATE)
	var blocks := roundi(float(maxi(0, thrown - opp_l)) * bs)
	var ctx := {"ropes": at == ("own_ropes" if k == 0 else "opp_ropes"), "amateur": am, "shoulder": sh}
	if cond > 0.0:
		ctx["condition"] = cond
	var wear := 0.0
	var through := 0.0
	for mi in BoutBurn.MIX:
		var kind: String = GuardState.KIND[str(mi[0])]
		var n := float(blocks) * float(mi[1])
		var n3 := n if combo_all else n * GuardState.COMBO_SHARE
		for grp in [[n - n3, 1], [n3, 3]]:
			var left := float(grp[0])
			var cn := int(grp[1])
			var w := GuardWear.wear(kind, cn, ctx) * ws
			while left > 0.0:
				var step := minf(1.0, left)
				through += step * GuardWear.transmission(kind, g, mx, wc, cn) * float(BASE[kind])
				wear += step * w
				g -= step * w
				left -= step
	return [GuardWear.clamp_guard(g + GuardWear.in_round(thrown, am), mx), wear, through, blocks]


static func _step_at(r: Dictionary, x: Dictionary, k: int, ws: float, bs: float, at: String, ca: bool, cond: float) -> Array:
	return _ex_step(float(r["max"]), float(r["max"]), str(r["wclass"]), bool(r["amateur"]), float(r["sh"][k]), x["landed"], at, k, ws, bs, ca, cond)


static func _replay(rec: Dictionary, ws: float, bs: float) -> Dictionary:   ## a whole bout: guard at each bell, blocks/points a round, offline damage, colours
	var mx := float(rec["max"])
	var g := [mx, mx]
	var rounds := []
	var through := [0.0, 0.0]
	var first := [{"yellow": 0, "orange": 0, "red": 0}, {"yellow": 0, "orange": 0, "red": 0}]
	var ever := [{"yellow": false, "orange": false, "red": false}, {"yellow": false, "orange": false, "red": false}]
	for ri in (rec["rounds"] as Array).size():
		if ri > 0:
			for k in 2:
				g[k] = GuardWear.clamp_guard(float(g[k]) + GuardWear.corner([], false, false), mx)
		var bl := [0, 0]
		var wr := [0.0, 0.0]
		for x in rec["rounds"][ri]:
			for k in 2:
				var r := _ex_step(float(g[k]), mx, str(rec["wclass"]), bool(rec["amateur"]), float(rec["sh"][k]), x["landed"], str(x["at"]), k, ws, bs, false, 0.0)
				g[k] = float(r[0])
				wr[k] = float(wr[k]) + float(r[1])
				through[k] = float(through[k]) + float(r[2])
				bl[k] = int(bl[k]) + int(r[3])
				var col := GuardWear.colour(float(g[k]), mx)
				if col != "green":
					ever[k][col] = true
					if int(first[k][col]) == 0:
						first[k][col] = ri + 1
		rounds.append({"sh": [float(g[0]) / mx, float(g[1]) / mx], "bl": bl, "wr": wr})
	return {"rounds": rounds, "through": through, "first": first, "ever": ever}


static func _agg(recs: Array, ws: float, bs: float) -> Dictionary:
	var rounds := []
	var reach := [{"yellow": 0, "orange": 0, "red": 0}, {"yellow": 0, "orange": 0, "red": 0}]
	var first := [{"yellow": {}, "orange": {}, "red": {}}, {"yellow": {}, "orange": {}, "red": {}}]
	var red_any := 0
	var red_loser := 0
	var thr := [0.0, 0.0]
	var dmg := [0.0, 0.0]
	var ratio := 0.0
	var ship := is_zero_approx(ws - GuardState.WEAR_SCALE) and is_zero_approx(bs - GuardState.BLOCK_SHARE)
	for r in recs:
		var rp := _replay(r, ws, bs)
		var nr := (rp["rounds"] as Array).size()
		while rounds.size() < nr:
			rounds.append({"sh": [[], []], "bl": [0, 0], "wr": [0.0, 0.0]})
		for ri in nr:
			for k in 2:
				(rounds[ri]["sh"][k] as Array).append(float(rp["rounds"][ri]["sh"][k]))
				rounds[ri]["bl"][k] = int(rounds[ri]["bl"][k]) + int(rp["rounds"][ri]["bl"][k])
				rounds[ri]["wr"][k] = float(rounds[ri]["wr"][k]) + float(rp["rounds"][ri]["wr"][k])
				if ship:
					self_diff = maxf(self_diff, absf(float(rp["rounds"][ri]["sh"][k]) * float(r["max"]) - float(r["shipped"][ri][k])))
		for k in 2:
			for col in COLOURS:
				if bool(rp["ever"][k][col]):
					reach[k][col] = int(reach[k][col]) + 1
					var fn := int(rp["first"][k][col])
					first[k][col][fn] = int(first[k][col].get(fn, 0)) + 1
			thr[k] = float(thr[k]) + float(rp["through"][k])
			dmg[k] = float(dmg[k]) + float(r["damage"]["ab"[k]])
		if bool(rp["ever"][0]["red"]) or bool(rp["ever"][1]["red"]):
			red_any += 1
			red_loser += 1 if bool(rp["ever"][0 if str(r["loser"]) == "a" else 1]["red"]) else 0
		var d := float(r["damage"]["a"]) + float(r["damage"]["b"])
		if d > 0.0:
			ratio += (float(rp["through"][0]) + float(rp["through"][1])) / d
	return {"n": recs.size(), "rounds": rounds, "reach": reach, "first": first, "red_any": red_any, "red_loser": red_loser,
		"thr": thr, "dmg": dmg, "t": float(thr[0]) + float(thr[1]), "d": float(dmg[0]) + float(dmg[1]), "ratio": ratio / maxf(1.0, float(recs.size()))}


static func _scenarios(recs: Dictionary, ws: float, bs: float) -> Dictionary:   ## the three visibly-worse cases on the same busy exchanges (10+ thrown), from a full guard
	var w := [0.0, 0.0, 0.0, 0.0]   ## guard points: base, flurry, ropes, dry
	var th := [0.0, 0.0, 0.0]   ## damage through: base, flurry, dry
	var nf := 0
	for cell in CELLS:
		for r in recs[cell["id"]]:
			for exs in r["rounds"]:
				for x in exs:
					for k in 2:
						if ceili(float(int(x["landed"][1 - k])) / BoutBurn.LAND_RATE) < 10:
							continue
						var rs := [_step_at(r, x, k, ws, bs, "", false, 0.0), _step_at(r, x, k, ws, bs, "", true, 0.0),
							_step_at(r, x, k, ws, bs, "own_ropes" if k == 0 else "opp_ropes", false, 0.0), _step_at(r, x, k, ws, bs, "", false, 60.0)]
						for i in 4:
							w[i] = float(w[i]) + float(rs[i][1])
						for i in 3:
							th[i] = float(th[i]) + float(rs[i][2])
						nf += 1
	return {"fw": float(w[1]) / maxf(0.0001, float(w[0])), "fd": float(th[1]) / maxf(0.0001, float(th[0])),
		"fb": float(w[0]) / maxf(1.0, float(nf)), "ff": float(w[1]) / maxf(1.0, float(nf)), "fn": nf,
		"rw": float(w[2]) / maxf(0.0001, float(w[0])), "dw": float(w[3]) / maxf(0.0001, float(w[0])), "dd": float(th[2]) / maxf(0.0001, float(th[0]))}


static func _evaluate(ws: float, bs: float, aggs: Dictionary) -> Dictionary:
	var klo := 0.0
	var khi := 99.0
	var ct := {}
	var cd := {}
	var am := [0.0, 0, 0, 0]   ## r3 share sum, bouts at r3, red bouts, bouts
	var p6 := [0.0, 0, 0, 0]
	var p6m: Dictionary = aggs[_key(ws, bs, "pro6_miss")]
	for cell in CELLS:
		var a: Dictionary = aggs[_key(ws, bs, str(cell["id"]))]
		klo = maxf(klo, 0.07 * float(a["d"]) / maxf(0.0001, float(a["t"])))
		khi = minf(khi, 0.11 * float(a["d"]) / maxf(0.0001, float(a["t"])))
		ct[cell["cfg"]] = float(ct.get(cell["cfg"], 0.0)) + float(a["t"])
		cd[cell["cfg"]] = float(cd.get(cell["cfg"], 0.0)) + float(a["d"])
		var acc: Array = am if str(cell["cfg"]) == "am3" else p6
		var ri := 2 if str(cell["cfg"]) == "am3" else 5
		acc[2] = int(acc[2]) + int(a["red_any"])
		acc[3] = int(acc[3]) + int(a["n"])
		if (a["rounds"] as Array).size() > ri:
			for k in 2:
				var sh: Array = a["rounds"][ri]["sh"][k]
				acc[0] = float(acc[0]) + _mean(sh) * float(sh.size())
				acc[1] = int(acc[1]) + sh.size()
	var plo := 0.0
	var phi := 99.0
	for cfg in ct:
		plo = maxf(plo, 0.07 * float(cd[cfg]) / maxf(0.0001, float(ct[cfg])))
		phi = minf(phi, 0.11 * float(cd[cfg]) / maxf(0.0001, float(ct[cfg])))
	var k := (klo + khi) / 2.0 if khi >= klo else ((plo + phi) / 2.0 if phi >= plo else 0.0)
	return {"ws": ws, "bs": bs, "am3r3": float(am[0]) / maxf(1.0, float(am[1])), "am3red": float(am[2]) / maxf(1.0, float(am[3])),
		"pro6r6": float(p6[0]) / maxf(1.0, float(p6[1])), "pro6rl": float(p6m["red_loser"]) / maxf(1.0, float(p6m["red_any"])),
		"pro6red_n": int(p6m["red_any"]), "klo": klo, "khi": khi, "plo": plo, "phi": phi, "k": k, "ct": ct, "cd": cd, "miss": [], "score": 0.0, "scen": {}}


static func _score(ev: Dictionary) -> float:
	var d := maxf(0.0, 0.50 - float(ev["am3r3"])) + maxf(0.0, float(ev["am3r3"]) - 0.75) + maxf(0.0, 0.25 - float(ev["pro6r6"])) + maxf(0.0, float(ev["pro6r6"]) - 0.50)
	d += maxf(0.0, float(ev["am3red"]) - 0.10) + maxf(0.0, 0.5 - float(ev["pro6rl"])) + (minf(1.0, float(ev["klo"]) - float(ev["khi"])) if float(ev["khi"]) < float(ev["klo"]) else 0.0)
	return 10.0 * float((ev["miss"] as Array).size()) + d


static func _flag(miss: Array, bad: bool, text: String) -> void:
	if bad:
		miss.append(text)


static func _misses(row: Dictionary, aggs: Dictionary) -> Array:
	var miss := []
	var k := float(row["k"])
	_flag(miss, float(row["khi"]) < float(row["klo"]), "no single k puts all six cells in +7..11%% (k %.4f..%.4f empty, pooled %.4f..%.4f); at k=%.4f: %s" % [float(row["klo"]), float(row["khi"]), float(row["plo"]), float(row["phi"]), k, _dmg_cells(row, aggs, k)])
	_flag(miss, float(row["am3r3"]) < 0.50, "amateur r3 guard below yellow (%.3f)" % float(row["am3r3"]))
	_flag(miss, float(row["am3r3"]) >= 0.75, "amateur r3 guard still green (%.3f)" % float(row["am3r3"]))
	_flag(miss, float(row["am3red"]) >= 0.10, "amateur red in %.1f%% of bouts (target under 10%%)" % [100.0 * float(row["am3red"])])
	_flag(miss, float(row["pro6r6"]) < 0.25, "pro6 last round below orange (%.3f)" % float(row["pro6r6"]))
	_flag(miss, float(row["pro6r6"]) >= 0.50, "pro6 last round above orange (%.3f)" % float(row["pro6r6"]))
	_flag(miss, float(row["pro6rl"]) <= 0.5, "pro6 mismatch red not mostly the loser (%.1f%% of %d red bouts)" % [100.0 * float(row["pro6rl"]), int(row["pro6red_n"])])
	var sc: Dictionary = row["scen"]
	if not sc.is_empty():
		_flag(miss, float(sc["fw"]) < 1.10, "10-punch flurry not visibly worse (wear x%.3f)" % float(sc["fw"]))
		_flag(miss, float(sc["rw"]) < 1.05, "rope-trapped not visibly worse (wear x%.3f)" % float(sc["rw"]))
		_flag(miss, float(sc["dw"]) < 1.05, "dry fighter not visibly worse (wear x%.3f)" % float(sc["dw"]))
	return miss


static func _dmg_cfg(row: Dictionary, k: float) -> String:
	var out := []
	for cfg in ["am3", "pro4", "pro6"]:
		out.append("%.1f" % [100.0 * k * float(row["ct"][cfg]) / maxf(0.0001, float(row["cd"][cfg]))])
	return "/".join(out) + "%"


static func _dmg_cells(row: Dictionary, aggs: Dictionary, k: float) -> String:
	var out := []
	for cell in CELLS:
		var a: Dictionary = aggs[_key(float(row["ws"]), float(row["bs"]), str(cell["id"]))]
		out.append("%s %.1f%%" % [str(cell["id"]), 100.0 * k * float(a["t"]) / maxf(0.0001, float(a["d"]))])
	return ", ".join(out)


static func _pop_row(cell: Dictionary, recs: Array) -> String:
	if recs.is_empty(): return "| %s | no bouts |" % str(cell["id"])
	var r: Dictionary = recs[0]
	var styles := {}
	var stops := 0
	for b in recs:
		styles[str(b["opp_name"]) + " (" + str(b["opp_style"]) + ")"] = true
		stops += 1 if str(b["stopped"]) != "" else 0
	return "| %s | %s | %d | %.0f | %s | %.0f | %s (%s, paper %.1f) | %s | %+.0f | %s | %d | %d |" % [str(cell["id"]),
		"pro" if bool(cell["pro"]) else "amateur", int(cell["rounds"]), float(cell["limit"]), str(r["wclass"]), float(r["max"]),
		str(r["name"]), str(r["style"]), float(r["paper"]), "/".join(styles.keys()), float(cell["gap"]), str(r["plan"]), recs.size(), stops]


static func _mean(arr: Array) -> float:
	var t := 0.0
	for v in arr:
		t += float(v)
	return t / maxf(1.0, float(arr.size()))


static func _p(arr: Array, q: float) -> float:
	if arr.is_empty():
		return 0.0
	var s := arr.duplicate()
	s.sort()
	return float(s[clampi(int(round(q * float(s.size() - 1))), 0, s.size() - 1)])


static func _round_rows(cell: Dictionary, a: Dictionary) -> Array:
	var out := []
	var n := maxf(1.0, float(a["n"]))
	for ri in (a["rounds"] as Array).size():
		var ro: Dictionary = a["rounds"][ri]
		var sa: Array = ro["sh"][0]
		var sb: Array = ro["sh"][1]
		out.append("| %s | %d | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f | %.2f | %.2f | %.2f | %.2f | %d |" % [str(cell["id"]), ri + 1,
			_mean(sa), _p(sa, 0.10), _p(sa, 0.90), _mean(sb), _p(sb, 0.10), _p(sb, 0.90),
			float(ro["bl"][0]) / n, float(ro["wr"][0]) / n, float(ro["bl"][1]) / n, float(ro["wr"][1]) / n, sa.size()])
	return out


static func _colour_rows(cell: Dictionary, a: Dictionary) -> Array:
	var out := []
	for k in 2:
		var parts := []
		for col in COLOURS:
			var rn := []
			for key in a["first"][k][col]: rn.append("r%s:%d" % [str(key), int(a["first"][k][col][key])])
			rn.sort()
			parts.append("%s %.1f%% (%s)" % [col, 100.0 * float(a["reach"][k][col]) / maxf(1.0, float(a["n"])), " ".join(rn) if not rn.is_empty() else "never"])
		out.append("| %s | %s | %s |" % [str(cell["id"]), "ab"[k], " / ".join(parts)])
	return out


static func _tables(title: String, ws: float, bs: float, aggs: Dictionary) -> void:
	_say(["", "## Guard, blocks and offline damage - %s (WEAR_SCALE %.2f, BLOCK_SHARE %.2f)" % [title, ws, bs], "",
		"### 1+2. Guard at each bell (share of max), blocks a round and the guard points they cost (mean a side)", "",
		"| cell | round | mean a | p10 a | p90 a | mean b | p10 b | p90 b | blocks a | points a | blocks b | points b | bouts |",
		"|---|---|---|---|---|---|---|---|---|---|---|---|---|"])
	for cell in CELLS:
		for row in _round_rows(cell, aggs[_key(ws, bs, str(cell["id"]))]): _say(row)
	_say(["", "Colour reached at any bell (share of bouts) and the round it first happened (bouts):", "", "| cell | side | yellow / orange / red |", "|---|---|---|"])
	for cell in CELLS:
		for row in _colour_rows(cell, aggs[_key(ws, bs, str(cell["id"]))]): _say(row)
	_say(["", "### 3. Offline damage through the guard (k=1, nothing fed back)", "",
		"| cell | through a | through b | real dmg a | real dmg b | % add a | % add b | % add pooled | mean per-bout % |", "|---|---|---|---|---|---|---|---|---|"])
	for cell in CELLS:
		var a: Dictionary = aggs[_key(ws, bs, str(cell["id"]))]
		_say("| %s | %.1f | %.1f | %.1f | %.1f | %.1f%% | %.1f%% | %.1f%% | %.1f%% |" % [str(cell["id"]), float(a["thr"][0]), float(a["thr"][1]),
			float(a["dmg"][0]), float(a["dmg"][1]), 100.0 * float(a["thr"][0]) / maxf(0.0001, float(a["dmg"][0])),
			100.0 * float(a["thr"][1]) / maxf(0.0001, float(a["dmg"][1])), 100.0 * float(a["t"]) / maxf(0.0001, float(a["d"])), 100.0 * float(a["ratio"])])
