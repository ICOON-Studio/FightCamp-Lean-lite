extends SceneTree
## HOSTPROBE2 (S539, ops/research/TASK_HOSTPROBE2.md): the greybox probe of club show map v5 (ops/research/DESIGN_HOSTSHOW1_V5.md),
## run BEFORE any critic scores it. Measurement only: nothing under scripts/ is touched; v5's new rules are the flagged copy
## tools/hostprobe2_rules.gd. Bars and method: docs/HOSTPROBE2_RESULT.md s2-s3 (committed before the run).
## Stages (stage=): scan | hall | card | boxerc | rank | favours | all. One JSON line a cell to out=<jsonl>.
## POPULATION (as HOSTPROBE1): the TEST CLUB (TestClub.make on Career.quick_start): Lucy (wlw), Kira (wfw), Josh (mww) against
## their classes' named rivals; each WEAK (as signed) / STRONG (+5 every stat) x AS-IS record / PRO-CHASE (6 wins).
## DICE: one rng per (cell, roll, event), the same for every option of the cell (common random numbers).

const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const V5 := preload("res://tools/hostprobe2_rules.gd")

const CLUBS := {"young": {"members": 40, "rep": 10, "places": 16}, "mid": {"members": 58, "rep": 24, "places": 22},
	"grown": {"members": 120, "rep": 60, "places": 40}}
const ROUTES := ["above_asis", "above_favour", "above_promise", "below", "wait"]
const WAIT_ABOVE_AT := 0.40   ## PROBE bot (as HOSTPROBE1): after the region show, wait asks the name above at this win chance
## The exchange (HOSTPROBE1 s2): 1 rep = $333, 1 in 100 pro offer = $333, a seat $30, a member $100; a favour = its CODE price.
const REP_D := 333.0
const PRO_D := 33300.0
const SEAT_D := 30.0
const MEMBER_D := 100.0
var out_path := ""
var rolls := 400
var base_seed := 5390
var sell_price := {}   ## per boxer first name: $ one fight-week pad night is worth (PadWeek -> BoutRead.chance)


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func _say(d: Dictionary) -> void:
	var s := JSON.stringify(d)
	if out_path != "":
		var fh := FileAccess.open(out_path, FileAccess.READ_WRITE if FileAccess.file_exists(out_path) else FileAccess.WRITE)
		if fh != null:
			fh.seek_end()
			fh.store_line(s)
			fh.close()
	print(s)


func _rng(parts: Array) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash(JSON.stringify(parts))
	return r


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	out_path = _arg("out", "")
	rolls = int(_arg("rolls", "400"))
	base_seed = int(_arg("seed", "5390"))
	var stage := _arg("stage", "all")
	var c := Career.quick_start()
	c.seed = base_seed
	TestClub.make(c)
	var boxers: Array = c.fighters.filter(func(f): return Data.DIVISIONS.has(str(f.get("div", ""))))
	_say({"tag": "run", "stage": stage, "rolls": rolls, "seed": base_seed, "boxers": boxers.map(func(f): return "%s %s %d-%d ovr %.1f" % [f["name"], f["div"], f["w"], f["l"], Attrs.overall(Attrs.of(f))])})
	_prices(c, boxers)
	if stage in ["hall", "all"]:
		_hall()
	if stage in ["card", "all"]:
		_card(c, boxers)
	if stage in ["boxerc", "all"]:
		_boxer_c(c, boxers)
	if stage in ["rank", "all"]:
		_rank(c, boxers)
	if stage in ["favours", "all"]:
		_favours(c, boxers)
	print("HOSTPROBE2 done %s %.1f s" % [stage, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


## The $ a win is worth over a loss on an away bout (BoutRules: rep +5 / -2 or -4, members +8 / -1 or -2).
func _win_gap() -> float:
	var s := V5.PROBE_STOP_SHARE
	var rep_l := (1.0 - s) * BoutRules.LOSS_REPUTATION + s * BoutRules.STOPPED_LOSS_REPUTATION
	var mem_l := (1.0 - s) * BoutRules.LOSS_MEMBERS + s * BoutRules.STOPPED_LOSS_MEMBERS
	return (BoutRules.WIN_REPUTATION + rep_l) * REP_D + (BoutRules.WIN_MEMBERS + mem_l) * MEMBER_D


## v5 4.9 BOXERS SELL priced by the game: one fight-week (taper) pad night less, run through PadWeek.run_week on a copy, read by
## BoutRead.chance against the boxer's nearest legal name, times the win gap. No pad night that week = $0.
func _prices(c: Career, boxers: Array) -> void:
	for f in boxers:
		var inp: Dictionary = DrillWeek.inputs(c, f)
		var nights: Dictionary = PadWeek.nights_for(PadWeek.step_of(f), false, false, true)
		var less: Dictionary = nights.duplicate(true)
		var pads: Array = (less["pads"] as Array).duplicate()
		var dropped := -1
		if not pads.is_empty():
			dropped = int(pads.pop_back())
		less["pads"] = pads
		var a: Dictionary = f.duplicate(true)
		var b: Dictionary = f.duplicate(true)
		PadWeek.run_week(a, nights, PadWeek.week_of(a, nights), float(inp["skill"]), PadWeek.STATION_TIER, {}, inp.get("carded", []))
		PadWeek.run_week(b, less, PadWeek.week_of(b, less), float(inp["skill"]), PadWeek.STATION_TIER, {}, inp.get("carded", []))
		var pool0 := _pool(c, str(f["div"]))
		var g := _state(f, false, false)
		var nm := _names(pool0, g)
		var ref_n := str(nm["below"]) if str(nm["below"]) != "" else str(nm["above"])
		var pa := BoutRead.chance(a, pool0[ref_n], {})
		var pb := BoutRead.chance(b, pool0[ref_n], {})
		sell_price[str(f["first"])] = maxf(0.0, pa - pb) * _win_gap()
		_say({"tag": "price", "who": f["first"], "pads": nights["pads"], "dropped": dropped, "skill": inp["skill"], "vs": ref_n,
			"p_full": pa, "p_less": pb, "sell_price": sell_price[str(f["first"])], "win_gap": _win_gap(), "favour": V5.FAVOUR_PRICE})


## ---------- B2 halls, reserves and the ticket read ----------
func _hall() -> void:
	var sp := 0.0
	for k in sell_price:
		sp += float(sell_price[k]) / maxf(1, sell_price.size())
	for club in CLUBS:
		for hall in V5.HALL_ORDER:
			if not V5.open(hall, int(CLUBS[club]["places"])):
				_say({"tag": "hall", "club": club, "hall": hall, "open": false})
				continue
			for res in [0, 1, 2]:
				for read in ["keep", "sell"]:
					var acc := {"cash": 0.0, "rep": 0.0, "full": 0.0, "half": 0.0, "short": 0.0, "sold": 0.0}
					var cashes: Array = []
					var m := rolls * 4
					for k in m:
						var n: Dictionary = V5.night(CLUBS[club], hall, [5, 5], res, read, _rng(["hall", club, k]))
						var cash := float(n["cash"]) - sp * int(n["sold_pads"])
						acc["cash"] += cash
						acc["rep"] += float(n["rep"])
						acc["sold"] += float(n["sold"])
						for key2 in ["full", "half", "short"]:
							acc[key2] += 1.0 if bool(n[key2]) else 0.0
						cashes.append(int(cash))
					cashes.sort()
					for key in acc:
						acc[key] = float(acc[key]) / m
					acc.merge({"tag": "hall", "club": club, "hall": hall, "res": res, "read": read, "p10": cashes[int(m * 0.1)],
						"reach": V5.reach(hall, int(CLUBS[club]["rep"])), "sell_price": sp, "V": float(acc["cash"]) + float(acc["rep"]) * REP_D})
					_say(acc)


## ---------- the card: who to ask, and how (B1b, B3) ----------
func _state(f: Dictionary, strong: bool, chase: bool) -> Dictionary:
	var g: Dictionary = f.duplicate(true)
	if strong:
		for s in g["stats"]:
			g["stats"][s] = float(g["stats"][s]) + 5.0
	if chase:
		g["w"] = 6
	g.erase("rep")
	g["rep"] = LadderPoints.seed_of(int(g["w"]), int(g["l"]))
	g["bout"] = {}
	return g


func _pool(c: Career, div: String) -> Dictionary:
	var out := {}
	for r in c.rivals:
		if str(r["div"]) == div:
			var x: Dictionary = r.duplicate(true)
			LadderPoints.rep_of(x)
			out[str(x["name"])] = x
	return out


func _bouts(x: Dictionary) -> int:
	return AmateurBooking.bouts_of(int(x["w"]), int(x["l"]))


func _legal(a: Dictionary, b: Dictionary) -> bool:
	return AmateurBooking.experience_match_ok(_bouts(a), _bouts(b)) and AmateurBooking.experience_match_ok(_bouts(b), _bouts(a))


func _rank_of(pool: Dictionary, g: Dictionary) -> int:
	var rows: Array = []
	for n in pool:
		var r: Dictionary = pool[n]
		rows.append({"name": n, "w": int(r["w"]), "l": int(r["l"]), "rating": float(r.get("rating", 0.0)), "rep": int(r["rep"]), "ours": false})
	if int(g["w"]) >= Region.RANK_MIN_WINS:
		rows.append({"name": "@ours", "w": int(g["w"]), "l": int(g["l"]), "rating": 0.0, "rep": int(g["rep"]), "ours": true})
	rows.sort_custom(Region.before)
	for i in rows.size():
		if bool(rows[i]["ours"]):
			return i + 1
	return 0


## v5 tiles: the nearest legal name above (ladder points) and below; no legal name above = the tile drops (v5 4.3).
func _names(pool: Dictionary, g: Dictionary) -> Dictionary:
	var ups: Array = []
	var downs: Array = []
	for n in pool:
		var r: Dictionary = pool[n]
		if not _legal(g, r):
			continue
		if int(r["rep"]) > int(g["rep"]):
			ups.append(n)
		else:
			downs.append(n)
	ups.sort_custom(func(a, b): return int(pool[a]["rep"]) < int(pool[b]["rep"]))
	downs.sort_custom(func(a, b): return int(pool[a]["rep"]) > int(pool[b]["rep"]))
	return {"above": ups[0] if not ups.is_empty() else "", "below": downs[0] if not downs.is_empty() else ""}


func _rival_bout(pool: Dictionary, a: String, b: String, rng: RandomNumberGenerator) -> void:
	var r := WorldBout.fast(pool[a], pool[b], 3, rng)
	var a_won := str(r["winner"]) == "a" or (str(r["winner"]) == "" and rng.randf() < 0.5)
	_apply(pool, pool[a], pool[b], a_won, "stop" if bool(r["stopped"]) else "ud")


func _pairs(pool: Dictionary, held: Array, rng: RandomNumberGenerator) -> Array:
	var free: Array = pool.keys().filter(func(n): return not held.has(n))
	for i in range(free.size() - 1, 0, -1):
		var j := rng.randi_range(0, i); var t: Variant = free[i]; free[i] = free[j]; free[j] = t
	var out: Array = []
	while free.size() >= 2 and out.size() < Region.SHOW_BOUTS:
		var a: String = free.pop_front()
		for k in free.size():
			if _legal(pool[a], pool[free[k]]):
				out.append([a, str(free.pop_at(k))])
				break
	return out


func _apply(pool: Dictionary, a: Dictionary, b: Dictionary, a_won: bool, method: String) -> void:
	var win: Dictionary = a if a_won else b
	var lose: Dictionary = b if a_won else a
	LadderPoints.settle(win, lose, "win", method)
	win["w"] = int(win["w"]) + 1
	lose["l"] = int(lose["l"]) + 1


## Our bout (home or away): {won, stop}; moves fo, o, ladder points; returns its rep, members.
func _box(pool: Dictionary, fo: Dictionary, opp: String, rng: RandomNumberGenerator, win_rep: int) -> Dictionary:
	var o: Dictionary = pool[opp]
	var won := rng.randf() < BoutRead.chance(fo, o, {})
	var stop := not won and rng.randf() < V5.PROBE_STOP_SHARE
	_apply(pool, fo, o, won, "stop" if stop else "ud")
	return {"won": won, "rep": float(win_rep if won else -(BoutRules.STOPPED_LOSS_REPUTATION if stop else BoutRules.LOSS_REPUTATION)),
		"members": float(BoutRules.WIN_MEMBERS if won else -(BoutRules.STOPPED_LOSS_MEMBERS if stop else BoutRules.LOSS_MEMBERS))}


func _pro(pool: Dictionary, fo: Dictionary) -> bool:
	var fc: Dictionary = fo.duplicate(true)
	fc["rank"] = _rank_of(pool, fo)
	return Roster.pro_ready(fc)


## One roll of one route over the 12 weeks after our night: our night, then the next bout (v5 4.3: a promised boxer's next bout
## is the return bout, away vs the same name, and NO pro call before it - Roster.check_pro skips a boxer with f.bout, Roster.gd:207;
## anyone else's next bout is the free pick, the legal name with the best win chance). A pro call at our night ends the chase.
func _roll(g: Dictionary, pool0: Dictionary, nm: Dictionary, route: String, lvl: int, cell: String, k: int) -> Dictionary:
	var pool: Dictionary = pool0.duplicate(true)
	var fo: Dictionary = g.duplicate(true)
	var ry := _rng([cell, k, "yes"])
	var rb := _rng([cell, k, "bout"])
	var rr := _rng([cell, k, "region"])
	var rn := _rng([cell, k, "next"])
	var above := str(nm["above"])
	var below := str(nm["below"])
	var lead := float(pool[above].get("rating", 0.0)) - Attrs.overall(Attrs.of(g)) if above != "" else 0.0
	var u1 := ry.randf()
	var u2 := ry.randf()
	var opp := ""
	var main := false
	var promised := false
	var fav := 0.0
	if route.begins_with("above_"):
		var how := route.trim_prefix("above_")
		if how == "favour":
			fav = -1.0
		if u1 < V5.yes10("above", "community", lead, how) / 10.0:
			opp = above
			main = true
			promised = how == "promise"
		elif below != "" and u2 < V5.BELOW_YES / 10.0:
			opp = below
	elif route == "below":
		if u1 < V5.BELOW_YES / 10.0:
			opp = below
	for p in _pairs(pool, [opp] if opp != "" else [], rr):
		_rival_bout(pool, str(p[0]), str(p[1]), rr)
	if route == "wait":
		var up := above != "" and BoutRead.chance(fo, pool[above], {}) >= WAIT_ABOVE_AT
		var pick := above if up else below
		if pick != "" and u1 < (V5.yes10("above", "community", lead, "asis") if up else V5.BELOW_YES) / 10.0:
			opp = pick
	var res := {"rep": 0.0, "members": 0.0, "seats": 0.0, "pro": 0.0, "pro_night": 0.0, "cash": 0.0, "boxed": 0.0, "won": 0.0,
		"fav": fav, "promised": 1.0 if promised else 0.0, "ret_won": 0.0, "ladder": 0.0}
	if opp != "":
		var b1 := _box(pool, fo, opp, rb, BoutRules.WIN_REPUTATION if opp == above else V5.BELOW_WIN_REP)
		res["boxed"] = 1.0
		res["won"] = 1.0 if bool(b1["won"]) else 0.0
		res["rep"] = float(b1["rep"]) + (float(V5.MAIN_REP if bool(b1["won"]) else -V5.MAIN_REP) if main else 0.0)
		res["members"] = float(b1["members"])
		res["seats"] = float(V5.following(int(g["w"])) + (V5.POSTERS if main else 0))
	if not promised and _pro(pool, fo):
		res["pro"] = 1.0
		res["pro_night"] = 1.0
	else:
		var nxt := above if promised else ""
		if nxt == "":
			var best := -1.0
			for n in pool:
				if _legal(fo, pool[n]):
					var pc := BoutRead.chance(fo, pool[n], {})
					if pc > best:
						best = pc
						nxt = str(n)
		if nxt != "":
			var b2 := _box(pool, fo, nxt, rn, BoutRules.WIN_REPUTATION)
			res["rep"] += float(b2["rep"])
			res["members"] += float(b2["members"])
			res["cash"] += float(BoutRules.TICKET_CUT)
			res["ret_won"] = 1.0 if promised and bool(b2["won"]) else 0.0
		res["pro"] = 1.0 if _pro(pool, fo) else 0.0
	res["ladder"] = float(int(fo["rep"]) - int(g["rep"]))
	res["V"] = res["seats"] * SEAT_D + res["rep"] * REP_D + res["members"] * MEMBER_D + res["pro"] * PRO_D + res["cash"] + res["fav"] * V5.FAVOUR_PRICE
	return res


func _card(c: Career, boxers: Array) -> void:
	for bi in boxers.size():
		var f: Dictionary = boxers[bi]
		var pool0 := _pool(c, str(f["div"]))
		for strong in [false, true]:
			for chase in [false, true]:
				var g := _state(f, strong, chase)
				var nm := _names(pool0, g)
				for lvl in [0, 1, 2]:
					var cell := "%s|%s|%s|f%d" % [f["first"], "strong" if strong else "weak", "chase" if chase else "asis", lvl]
					for route in ROUTES:
						if route.begins_with("above") and str(nm["above"]) == "" or route == "below" and str(nm["below"]) == "":
							continue
						if route == "above_favour" and lvl < 1:
							continue
						var acc := {}
						for k in rolls:
							var one := _roll(g, pool0, nm, route, lvl, cell, k)
							for key in one:
								acc[key] = float(acc.get(key, 0.0)) + float(one[key]) / rolls
						acc.merge({"tag": "card", "cell": cell, "who": f["first"], "strong": strong, "chase": chase, "lvl": lvl, "route": route,
							"above": nm["above"], "below": nm["below"], "rank0": _rank_of(pool0, g)})
						_say(acc)


## ---------- B6: the printed "No. 3 or better", now with each bout's stoppage share (v5 4.3) ----------
## Each rival pair alone: P(a by stop), P(a on points), P(b by stop), P(b on points) (a draw splits as the night does);
## ours: a win on points, a loss a stoppage PROBE_STOP_SHARE of the time. The tree walks every outcome.
func _rank(c: Career, boxers: Array) -> void:
	for bi in boxers.size():
		var f: Dictionary = boxers[bi]
		var pool0 := _pool(c, str(f["div"]))
		for strong in [false, true]:
			var g := _state(f, strong, true)
			var nm := _names(pool0, g)
			for opp in [str(nm["above"]), str(nm["below"])]:
				if opp == "":
					continue
				var cell := "%s|%s|chase|%s" % [f["first"], "strong" if strong else "weak", opp]
				var pairs := _pairs(pool0, [opp], _rng([cell, "pairing"]))
				var pq: Array = []
				var alone := rolls * 2
				for p in pairs:
					var q := [0.0, 0.0, 0.0, 0.0]
					for k in alone:
						var ra := _rng([cell, "alone", p[0], k])
						var r := WorldBout.fast(pool0[p[0]], pool0[p[1]], 3, ra)
						var st := bool(r["stopped"])
						if str(r["winner"]) == "a":
							q[0 if st else 1] += 1.0
						elif str(r["winner"]) == "b":
							q[2 if st else 3] += 1.0
						else:
							q[1] += 0.5
							q[3] += 0.5
					pq.append(q.map(func(x): return x / alone))
				var p_win := BoutRead.chance(g, pool0[opp], {})
				var ours := [[true, "ud", p_win], [false, "ud", (1.0 - p_win) * (1.0 - V5.PROBE_STOP_SHARE)], [false, "stop", (1.0 - p_win) * V5.PROBE_STOP_SHARE]]
				var printed := 0.0
				for mask in int(pow(4, pairs.size())):
					var pr := 1.0
					var pool: Dictionary = pool0.duplicate(true)
					for i in pairs.size():
						var o := (mask >> (2 * i)) & 3
						pr *= float(pq[i][o])
						_apply(pool, pool[pairs[i][0]], pool[pairs[i][1]], o < 2, "stop" if o % 2 == 0 else "ud")
					for oc in ours:
						var pl: Dictionary = pool.duplicate(true)
						var fo: Dictionary = g.duplicate(true)
						_apply(pl, fo, pl[opp], bool(oc[0]), str(oc[1]))
						var rk := _rank_of(pl, fo)
						printed += pr * float(oc[2]) * (1.0 if rk > 0 and rk <= 3 else 0.0)
				var hits := 0
				var n := rolls * 10
				for k2 in n:
					var pool2: Dictionary = pool0.duplicate(true)
					var fo2: Dictionary = g.duplicate(true)
					var rr := _rng([cell, "real", k2])
					for p2 in pairs:
						_rival_bout(pool2, str(p2[0]), str(p2[1]), rr)
					var won := rr.randf() < p_win
					_apply(pool2, fo2, pool2[opp], won, "stop" if not won and rr.randf() < V5.PROBE_STOP_SHARE else "ud")
					var rk2 := _rank_of(pool2, fo2)
					hits += 1 if rk2 > 0 and rk2 <= 3 else 0
				_say({"tag": "rank", "cell": cell, "pairs": pairs, "p_alone": pq, "p_win": p_win, "printed": printed * 100.0,
					"measured": hits * 100.0 / n, "n": n, "alone": alone})


## ---------- B5 the boxer with a goal (v5: Outside novice / Leave off; the Skills bout is cut) ----------
## Morale is priced by the game: the mood it leaves moves BoutRead.chance (FighterProfile.trust, BoutRead.gd:235) at the next
## bout against the same reference name, times the win gap (PROBE: the mood holds to that bout).
func _boxer_c(c: Career, boxers: Array) -> void:
	var gap := _win_gap()
	for f in boxers:
		var pool0 := _pool(c, str(f["div"]))
		var g := _state(f, false, false)
		var nm := _names(pool0, g)
		var ref: Dictionary = pool0[str(nm["below"]) if str(nm["below"]) != "" else str(nm["above"])]
		g["morale"] = 58.0
		BoutRead.clear_cache(); var p58 := BoutRead.chance(g, ref, {})   # the edge cache key has no morale (BoutRead.gd:224)
		for cond in ["safe_steady", "safe_flat", "tight"]:
			var gm: Dictionary = g.duplicate(true)
			var m0 := 41.0 if cond == "safe_flat" else 58.0
			gm["morale"] = m0
			BoutRead.clear_cache(); var p := 0.5 + BoutRead.chance(gm, ref, {}) - p58
			var d := func(kind: String) -> float:
				return float(FighterProfile.apply_morale(gm.duplicate(true), kind, "")["delta"])
			var goal := float(d.call("goal_missed")) if cond == "tight" else 0.0
			var next_p := func(m: float) -> float:
				var x: Dictionary = gm.duplicate(true)
				x["morale"] = clampf(m, 0.0, 100.0); BoutRead.clear_cache()
				return BoutRead.chance(x, ref, {})
			var m_win: float = m0 + d.call("booked") + d.call("win") + goal
			var m_loss: float = m0 + d.call("booked") + d.call("loss") + goal
			var nov_next: float = p * float(next_p.call(m_win)) + (1.0 - p) * float(next_p.call(m_loss))
			var rep_n := p * V5.BELOW_WIN_REP - (1.0 - p) * 2.4
			var mem_n := p * 8.0 - (1.0 - p) * 1.2
			var v_nov := V5.NOVICE_SEATS * SEAT_D + rep_n * REP_D + mem_n * MEMBER_D - V5.NOVICE_FEE + nov_next * gap
			var m_leave: float = m0 + (float(d.call("goal_met")) if cond == "tight" else 0.0)
			var leave_next: float = next_p.call(m_leave)
			_say({"tag": "boxerc", "who": f["first"], "cond": cond, "opt": "novice", "p": p, "morale_after": [m_win, m_loss], "next_p": nov_next,
				"rep": rep_n, "members": mem_n, "seats": V5.NOVICE_SEATS, "cash": -V5.NOVICE_FEE, "V": v_nov})
			_say({"tag": "boxerc", "who": f["first"], "cond": cond, "opt": "leave", "p": p, "morale_after": [m_leave], "next_p": leave_next,
				"rep": 0.0, "members": 0.0, "seats": 0, "cash": 0, "V": leave_next * gap})


## ---------- B1a favours earned a year under the BUILT rules (FightWeekEvents.card_bout / fill_gap, start 1, cap 3) ----------
## v5 adds no earn; our show only spends. FAVOURPROBE1 rates: ~11 away bouts a year across the three boxers, 0.3 late asks taken.
func _favours(c: Career, boxers: Array) -> void:
	var clubs: Array = []
	for f in boxers:
		clubs.append(_pool(c, str(f["div"])).values().map(func(r): return str(r["club"])))
	for bot in ["hoard", "use"]:
		var st := {"earned": 0, "spent": 0, "held": 0, "hosts": 0}
		for s in 2000:
			var rng := _rng(["fav2", bot, s])
			var favs := {}
			var count := {}
			for day in range(0, 364, 7):
				if rng.randf() < 11.0 / 52.0:   # an away bout, hosted by the opponent's club
					var cl: String = clubs[rng.randi_range(0, 2)].pick_random()
					var r := FightWeekEvents.card_bout(int(count.get(cl, 0)), int(favs.get(cl, V5.FAVOURS_START)))
					count[cl] = int(r["count"])
					favs[cl] = int(r["favours"])
					st["earned"] += 1 if bool(r["earned"]) else 0
				if rng.randf() < 0.3 / 52.0:
					var cl2: String = clubs[rng.randi_range(0, 2)].pick_random()
					var before := int(favs.get(cl2, V5.FAVOURS_START))
					favs[cl2] = FightWeekEvents.fill_gap(before)
					st["earned"] += 1 if int(favs[cl2]) > before else 0
				if bot == "use" and day % 112 == 105:   # our show: one ask in three with a favour, on a random name above's club
					for i in 3:
						var cl3: String = clubs[i][rng.randi_range(0, clubs[i].size() - 1)]
						if rng.randf() < 1.0 / 3.0 and int(favs.get(cl3, V5.FAVOURS_START)) > 0:
							favs[cl3] = int(favs.get(cl3, V5.FAVOURS_START)) - 1
							st["spent"] += 1
			st["hosts"] += favs.size()
			for cl4 in favs:
				st["held"] += int(favs[cl4])
		_say({"tag": "favours", "bot": bot, "earned_yr": st["earned"] / 2000.0, "spent_yr": st["spent"] / 2000.0,
			"held_end_touched": st["held"] / 2000.0, "touched": st["hosts"] / 2000.0})
