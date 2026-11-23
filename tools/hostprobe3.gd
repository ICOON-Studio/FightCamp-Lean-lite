extends SceneTree
## HOSTPROBE3 (S540, ops/research/TASK_HOSTPROBE3.md): the greybox probe of club show map v6 (ops/research/DESIGN_HOSTSHOW1_V6.md),
## run BEFORE any critic scores it. Measurement only: nothing under scripts/ is touched; v6's new rules are the flagged copy
## tools/hostprobe3_rules.gd. Base: tools/hostprobe2.gd. Bars and method: docs/HOSTPROBE3_RESULT.md s2-s3 (committed before the run).
## Stages (stage=): hall | card | rank | favours | career | all. One JSON line a cell to out=<jsonl>.
## POPULATION (as HOSTPROBE1/2): the TEST CLUB (TestClub.make on Career.quick_start): Lucy (wlw), Kira (wfw), Josh (mww) against
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
const V5 := preload("res://tools/hostprobe3_rules.gd")   # v6 rules (name kept from the base)

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
	_say({"tag": "lines", "pro_points": V5.pro_points(), "pro_points_any": V5.pro_points_any(), "pools": _scan(c, boxers)})
	if stage in ["hall", "all"]:
		_hall()
	if stage in ["card", "all"]:
		_card(c, boxers)
	if stage in ["rank", "all"]:
		_rank(c, boxers)
	if stage in ["favours", "all"]:
		_favours(c, boxers)
	if stage in ["career", "all"]:
		_career(c, boxers)
	print("HOSTPROBE3 done %s %.1f s" % [stage, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


## Each division's ladder points (what the lines read), and each boxer's state per cell.
func _scan(c: Career, boxers: Array) -> Dictionary:
	var out := {}
	for f in boxers:
		var pool0 := _pool(c, str(f["div"]))
		var pts: Array = pool0.values().map(func(r): return "%s %d-%d %d" % [r["name"], r["w"], r["l"], r["rep"]])
		var cells := {}
		for chase in [false, true]:
			var g := _state(f, false, chase)
			var nm := _names(pool0, g)
			cells["chase" if chase else "asis"] = {"pts": g["rep"], "rank": _rank_of(pool0, g), "above": nm["above"], "below": nm["below"]}
		out[str(f["first"])] = {"pool": pts, "cells": cells}
	return out


## ---------- B2 the hall read and B4 the reserves default (v6: halls Community / Town, no read at day 12 but Keep) ----------
func _hall() -> void:
	for club in CLUBS:
		var rd: Dictionary = V5.hall_read(CLUBS[club], [5, 5])
		_say({"tag": "read", "club": club, "hall": rd["hall"], "likely": rd["likely"]})
		for hall in V5.HALL_ORDER:
			for res in [0, 1, 2]:
				var acc := {"cash": 0.0, "rep": 0.0, "full": 0.0, "half": 0.0, "short": 0.0, "sold": 0.0}
				var cashes: Array = []
				var m := rolls * 4
				for k in m:
					var n: Dictionary = V5.night(CLUBS[club], hall, [5, 5], res, _rng(["hall", club, k]))
					acc["cash"] += float(n["cash"])
					acc["rep"] += float(n["rep"])
					acc["sold"] += float(n["sold"])
					for key2 in ["full", "half", "short"]:
						acc[key2] += 1.0 if bool(n[key2]) else 0.0
					cashes.append(int(n["cash"]))
				cashes.sort()
				for key in acc:
					acc[key] = float(acc[key]) / m
				acc.merge({"tag": "hall", "club": club, "hall": hall, "res": res, "p10": cashes[int(m * 0.1)],
					"reach": V5.reach(hall, int(CLUBS[club]["rep"])), "V": float(acc["cash"]) + float(acc["rep"]) * REP_D})
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


## v5 tiles: the nearest legal name above (ladder points) and below; no legal name above = the tile drops (v6 4.3).
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


## v6: the pro call on ladder points (V5.pro_ready); built = Roster.pro_ready (7 wins + top 3, or 9 wins), kept for comparison.
func _pro(pool: Dictionary, fo: Dictionary, built := false) -> bool:
	var fc: Dictionary = fo.duplicate(true)
	fc["rank"] = _rank_of(pool, fo)
	return Roster.pro_ready(fc) if built else V5.pro_ready(fc)


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
		"fav": fav, "promised": 1.0 if promised else 0.0, "ret_won": 0.0, "ladder": 0.0, "pro_built_night": 0.0}
	if opp != "":
		var b1 := _box(pool, fo, opp, rb, BoutRules.WIN_REPUTATION if opp == above else V5.BELOW_WIN_REP)
		res["boxed"] = 1.0
		res["won"] = 1.0 if bool(b1["won"]) else 0.0
		res["rep"] = float(b1["rep"]) + (float(V5.MAIN_REP if bool(b1["won"]) else -V5.MAIN_REP) if main else 0.0)
		res["members"] = float(b1["members"])
		res["seats"] = float(V5.following(int(g["w"])) + (V5.POSTERS if main else 0))
	if not promised and _pro(pool, fo, true):
		res["pro_built_night"] = 1.0
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


## ---------- B1a favours earned a year under the BUILT rules (FightWeekEvents.card_bout / fill_gap, start 1, cap 3) ----------
## v6 adds no earn; our show only spends. FAVOURPROBE1 rates: ~11 away bouts a year across the three boxers, 0.3 late asks taken.
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


## ---------- B8 the pro line over a career, built rule against v6 ----------
## A season of up to CAREER_BOUTS bouts, one every 4 weeks, a region show (Region.SHOW_BOUTS rival pairs) before each. Bots:
## "sensible" asks the nearest legal name above when its win chance is 40 in 100 or better, else the name below; "easy" always
## takes the legal name with the best win chance. After each bout: the call under the rule (rank by Region.before on ladder
## points). PROBE: stats do not grow, the pool has no newcomers, no idle clock.
const CAREER_BOUTS := 30
func _career(c: Career, boxers: Array) -> void:
	var seasons := maxi(50, int(rolls / 4))
	for f in boxers:
		var pool0 := _pool(c, str(f["div"]))
		for strong in [false, true]:
			for bot in ["sensible", "easy"]:
				for rule in ["built", "v6"]:
					var at: Array = []
					var above_wins := 0.0
					var wins := 0.0
					for s in seasons:
						var pool: Dictionary = pool0.duplicate(true)
						var fo := _state(f, strong, false)
						var rr := _rng(["career", f["first"], strong, bot, s])   # the same dice for both rules
						var call := -1
						for b in CAREER_BOUTS:
							var nm := _names(pool, fo)
							var opp := ""
							if bot == "sensible":
								var up := str(nm["above"]) != "" and BoutRead.chance(fo, pool[str(nm["above"])], {}) >= WAIT_ABOVE_AT
								opp = str(nm["above"]) if up else str(nm["below"])
							if opp == "":
								var best := -1.0
								for n in pool:
									if _legal(fo, pool[n]):
										var pc := BoutRead.chance(fo, pool[n], {})
										if pc > best:
											best = pc
											opp = str(n)
							for p in _pairs(pool, [opp] if opp != "" else [], rr):
								_rival_bout(pool, str(p[0]), str(p[1]), rr)
							if opp == "":
								continue
							var was_above := int(pool[opp]["rep"]) > int(fo["rep"])
							var r := _box(pool, fo, opp, rr, BoutRules.WIN_REPUTATION)
							if bool(r["won"]):
								wins += 1.0
								above_wins += 1.0 if was_above else 0.0
							if _pro(pool, fo, rule == "built"):
								call = b + 1
								break
						at.append(call)
					var called: Array = at.filter(func(x): return x > 0)
					called.sort()
					_say({"tag": "career", "who": f["first"], "strong": strong, "bot": bot, "rule": rule, "seasons": seasons,
						"called": called.size() * 1.0 / seasons, "by24": at.filter(func(x): return x > 0 and x <= 24).size() * 1.0 / seasons,
						"median": called[int(called.size() / 2)] if not called.is_empty() else -1, "wins_a_season": wins / seasons,
						"above_share": above_wins / maxf(1.0, wins)})
