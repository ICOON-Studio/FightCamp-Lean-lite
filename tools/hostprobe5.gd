extends SceneTree
## HOSTPROBE5 (S541, ops/research/TASK_HOSTPROBE5.md): the greybox probe of club show map v8 (ops/research/DESIGN_HOSTSHOW1_V8.md),
## run BEFORE any critic scores it. Measurement only: nothing under scripts/ is touched; v8's rules are the flagged copy
## tools/hostprobe5_rules.gd. Base: tools/hostprobe4.gd. Bars and method: docs/HOSTPROBE5_RESULT.md s2-s3 (committed before the run).
## Stages (stage=): road (the game's own careers: calibrates W_BELOW, B8) | hall | card | rank | all (not road).
## POPULATION (as HOSTPROBE1-4): the TEST CLUB (TestClub.make on Career.quick_start): Lucy (wlw), Kira (wfw), Josh (mww) against
## their classes' named rivals; each WEAK / STRONG (+5 every stat) x AS-IS / PRO-CHASE (6 wins, one counted win from the line).
## v8 card cells add the CLUB (young / mid / grown) on the hall its read names: the main event's posters and the night move.
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
const V5 := preload("res://tools/hostprobe5_rules.gd")   # v8 rules (name kept from the base)
const Bouts := preload("res://scripts/state/Bouts.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const CLUBS := {"young": {"members": 40, "rep": 10, "places": 16}, "mid": {"members": 58, "rep": 24, "places": 22},
	"grown": {"members": 120, "rep": 60, "places": 40}}
const ROUTES := ["above_asis", "above_favour", "above_promise", "below", "wait"]
const WAIT_ABOVE_AT := 0.40   ## PROBE bot (as HOSTPROBE1): after the region show, wait asks the name above at this win chance
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
	_say({"tag": "lines", "w_below": V5.W_BELOW, "pools": _scan(c, boxers)})
	if stage in ["hall", "all"]:
		_hall()
	if stage in ["card", "all"]:
		_card(c, boxers)
	if stage in ["rank", "all"]:
		_rank(c, boxers)
	if stage == "road":
		_road(Array(_arg("boxers", "0,1,2,3,4,5").split(",")), int(_arg("seeds", "24")), int(_arg("from", "0")))
	print("HOSTPROBE5 done %s %.1f s" % [stage, (Time.get_ticks_msec() - t0) / 1000.0])
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
		_say({"tag": "read", "club": club, "hall": rd["hall"], "close": rd["close"], "likely": rd["likely"]})
		for hall in V5.HALL_ORDER:
			for res in [0, 1, 2]:
				var acc := {"cash": 0.0, "rep": 0.0, "full": 0.0, "half": 0.0, "short": 0.0, "sold": 0.0}
				var cashes: Array = []
				var m := rolls * 4
				for k in m:
					var n: Dictionary = V5.night(CLUBS[club], hall, [5, 5], res, _rng(["hall", club, k]), int(V5.MAIN_POSTERS[hall]))
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
	g["wwins"] = float(g["w"])   # v8 (result s2): the chase boxer is ONE COUNTED WIN from the line (6.0); as-is: every win counted
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
	if won:   # v8 4.4: weighed before the bout (theirs above ours = 1, else W_BELOW)
		fo["wwins"] = float(fo.get("wwins", fo["w"])) + V5.weight(LadderPoints.rep_of(o), LadderPoints.rep_of(fo))
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
func _roll(g: Dictionary, pool0: Dictionary, nm: Dictionary, route: String, lvl: int, cell: String, k: int, club: String, hall: String) -> Dictionary:
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
	var u3 := ry.randf()
	var opp := ""
	var main := false
	var promised := false
	var posters := 0   # v8: the name above = MAIN_POSTERS[hall]; the name below booked in time = POSTERS_BELOW; late or wait = 0
	var fav := 0.0
	if route.begins_with("above_"):
		var how := route.trim_prefix("above_")
		if how == "favour":
			fav = -1.0
		if u1 < V5.yes10("above", hall, lead, how) / 10.0:
			opp = above
			main = true
			posters = int(V5.MAIN_POSTERS[hall])
			promised = how == "promise"
		elif below != "":   # v7 4.3: the no lands after the posters LATE_NO of the time
			var late := u3 < V5.LATE_NO
			if u2 < (V5.LATE_BELOW_YES if late else V5.BELOW_YES) / 10.0:
				opp = below
				posters = 0 if late else V5.POSTERS_BELOW
	elif route == "below":
		if u1 < V5.BELOW_YES / 10.0:
			opp = below
			posters = V5.POSTERS_BELOW
	for p in _pairs(pool, [opp] if opp != "" else [], rr):
		_rival_bout(pool, str(p[0]), str(p[1]), rr)
	if route == "wait":
		var up := above != "" and BoutRead.chance(fo, pool[above], {}) >= WAIT_ABOVE_AT
		var pick := above if up else below
		if pick != "" and u1 < (V5.yes10("above", hall, lead, "asis") if up else V5.BELOW_YES) / 10.0:
			opp = pick
	var res := {"rep": 0.0, "members": 0.0, "seats": 0.0, "pro": 0.0, "pro_night": 0.0, "cash": 0.0, "boxed": 0.0, "won": 0.0,
		"fav": fav, "promised": 1.0 if promised else 0.0, "ret_won": 0.0, "ladder": 0.0, "pro_built_night": 0.0}
	if opp != "":
		var b1 := _box(pool, fo, opp, rb, BoutRules.WIN_REPUTATION if opp == above else V5.BELOW_WIN_REP)
		res["boxed"] = 1.0
		res["won"] = 1.0 if bool(b1["won"]) else 0.0
		res["rep"] = float(b1["rep"]) + (float(V5.MAIN_REP if bool(b1["won"]) else -V5.MAIN_REP) if main else 0.0)
		res["members"] = float(b1["members"])
		res["seats"] = float(V5.following(int(g["w"])) + posters)
	# v8: the night itself (the club's read hall, one other home boxer at 5 wins, two reserves, this roll's luck and pull-outs):
	# the bout's following and posters move seats, cash and the full / half-empty reputation (HOSTPROBE4 s7 item 3).
	var rnt := _rng([cell, k, "night"])
	var luck := rnt.randf_range(0.70, 1.15)
	var falls: Array = []
	for i in int(V5.HALLS[hall]["card"]):
		falls.append(i > 0 and rnt.randf() < V5.PULL_OUT)
	var nt: Dictionary = V5.night_of(CLUBS[club], hall, [int(g["w"]), 5] if opp != "" else [5], V5.RESERVES_DEFAULT, luck, falls, posters)
	res["night_cash"] = float(nt["cash"])
	res["night_rep"] = float(nt["rep"])
	res["sold"] = float(nt["sold"])
	res["full"] = 1.0 if bool(nt["full"]) else 0.0
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
	res["V"] = res["night_cash"] + (res["rep"] + res["night_rep"]) * REP_D + res["members"] * MEMBER_D + res["pro"] * PRO_D + res["cash"] + res["fav"] * V5.FAVOUR_PRICE
	return res


func _card(c: Career, boxers: Array) -> void:
	for club in CLUBS:
		var hall := str(V5.hall_read(CLUBS[club], [5, 5])["hall"])
		_card_club(c, boxers, club, hall)


func _card_club(c: Career, boxers: Array, club: String, hall: String) -> void:
	for bi in boxers.size():
		var f: Dictionary = boxers[bi]
		var pool0 := _pool(c, str(f["div"]))
		for strong in [false, true]:
			for chase in [false, true]:
				var g := _state(f, strong, chase)
				var nm := _names(pool0, g)
				for lvl in [0, 1, 2]:
					var cell := "%s|%s|%s|%s|f%d" % [club, f["first"], "strong" if strong else "weak", "chase" if chase else "asis", lvl]
					for route in ROUTES:
						if route.begins_with("above") and str(nm["above"]) == "" or route == "below" and str(nm["below"]) == "":
							continue
						if route == "above_favour" and lvl < 1:
							continue
						var acc := {}
						for k in rolls:
							var one := _roll(g, pool0, nm, route, lvl, cell, k, club, hall)
							for key in one:
								acc[key] = float(acc.get(key, 0.0)) + float(one[key]) / rolls
						acc.merge({"tag": "card", "cell": cell, "club": club, "hall": hall, "who": f["first"], "strong": strong, "chase": chase, "lvl": lvl, "route": route,
							"above": nm["above"], "below": nm["below"], "rank0": _rank_of(pool0, g)})
						_say(acc)

## ---------- B6: the printed "No. 3 or better", now with each bout's stoppage share (v5 4.3) ----------
## Each rival pair alone: P(a by stop), P(a on points), P(b by stop), P(b on points) (a draw splits as the night does);
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

## ---------- B1a favours a year: not re-run. That stage reads only built rules (FightWeekEvents.card_bout / fill_gap) and v7's
## use bot, both unchanged in v8, on the same seed: HOSTPROBE4's numbers (docs/HOSTPROBE4_RESULT.md s9) stand. ----------

## ---------- B8 / the calibration: the game's own careers (TURNPROBE15's road, tools/turnprobe15.gd _build) ----------
## Each signable person (Data.lucy + Data.PROSPECTS) from signing, the game's own clock (stat growth, newcomers, the idle
## clock, region shows), a bot that takes every legal bout. The pro offer is cleared each day so the road runs on past the
## built call (ROAD_BOUTS bouts or ROAD_WEEKS weeks). After each bout one point: [bouts, w, l, ladder points, rank (Region.
## our_rank), the built call (Roster.pro_ready), opponent's points and ours BEFORE the bout]. v8's weighed count is read off
## them afterwards (it changes no booking). v8 (HOSTPROBE4 s7 item 5): the first bout is taken only from day WAIT after signing
## (WAIT = (37 s + 11 b) mod 50: offers before it are declined) so the seeds' calendars, rivals and fight days differ.
const ROAD_BOUTS := 30
const ROAD_WEEKS := 156
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
func _road(which: Array, seeds: int, from: int) -> void:
	var people: Array = [Data.lucy()] + Data.PROSPECTS
	for s in range(from, seeds):
		for bs in which:
			var who: Dictionary = people[int(bs)]
			var c := Career.quick_start()
			c.seed = 7000 + int(bs) * 137 + s * 1009
			c.first_hour = {}
			FirstWeek.skip(c)
			c.applicant = who.duplicate(true)
			Sim.sign(c, PICKS.duplicate())
			Sim.hire(c, "reid")
			var f: Dictionary = c.fighter()
			var traj: Array = []
			var last := int(f["w"]) + int(f["l"]) + int(f.get("d", 0))
			var guard := 0
			var wait := c.day + (37 * s + 11 * int(bs)) % 50
			var pre := [0, 0]
			while c.day < ROAD_WEEKS * 7 and not c.closed and traj.size() < ROAD_BOUTS and guard < 5000:
				guard += 1
				c.pro_offer = {}
				c.cash = maxi(c.cash, 3000)
				if c.day < wait:
					for o3 in (f["offers"] as Array).duplicate():
						if not bool(o3["answered"]):
							Bouts.decline(c, str(o3["id"]))
				else:
					if Bouts.fight_day(c, f) and not (f["bout"] as Dictionary).is_empty():
						pre = [LadderPoints.rep_of(c.rival(str(f["bout"]["opp"]["name"]))), LadderPoints.rep_of(f)]
					_road_day(c, f)
				Sim.step_day(c)
				var n := int(f["w"]) + int(f["l"]) + int(f.get("d", 0))
				if n != last:
					last = n
					var fc: Dictionary = f.duplicate(true)
					fc["rank"] = Region.our_rank(c, f)
					traj.append([n, int(f["w"]), int(f["l"]), LadderPoints.rep_of(f), int(fc["rank"]), Roster.pro_ready(fc), pre[0], pre[1]])
			_say({"tag": "road", "b": int(bs), "who": str(who["name"]), "seed": s, "start": [int(who.get("w", 0)), int(who.get("l", 0))], "traj": traj, "day": c.day, "wait": wait})


## A day's answers (tools/turnprobe15.gd _day, the amateur road only).
func _road_day(c: Career, f: Dictionary) -> void:
	for o2 in (f["offers"] as Array).duplicate():
		if bool(o2["answered"]) or bool(o2["mismatch"]):
			continue
		if not (f["bout"] as Dictionary).is_empty():
			Bouts.decline(c, str(o2["id"]))
		else:
			Bouts.accept(c, str(o2["id"]))
	if Bouts.camp_due(c, f):
		Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary).get("opp", {})), false)
	if Bouts.weigh_in_today(c, f):
		Bouts.weigh(c, f)
	if Bouts.fight_day(c, f):
		Bouts.fight_step(c, f, Bouts.fight_modal(f), "sim")
		Bouts.after_fight(c, f)
	if bool(f.get("goal_talk", false)):
		Bouts.set_goal(c, f, "five_round_engine")
