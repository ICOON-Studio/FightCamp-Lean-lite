extends "res://tools/coachdeep9.gd"
## COACHMAP2 (S551, ops/research/TASK_COACHMAP2.md; rules and bars written before any run: ops/research/DESIGN_COACHMAP2.md).
## COACHDEEP9's season probe (tools/coachdeep9.gd, extended, not copied) with Kalli's three changes as switches, and a bout stage
## on CORNERBASE1's real bout (tools/coachmap2_rules.gd bout) for change 1. Every override is a pass-through with its switch off,
## so stage=ctrl IS COACHDEEP9 (the control). Usage (after --):
##   stage=ctrl [reps=100] [cells=..]                       - COACHDEEP9 unchanged (must equal its full.txt)
##   stage=season c1=0|0.5|1 limit=0|1 c3=0|1 dtab=<json> reps=40 rosters=1|10 weeks=104 cells=..
##   stage=corner lens=3 n=40 cells=all arms=<list|all>    - the bout probe (five women of CORNERBASE1, ten cells)
## POPULATION: season = the TEST CLUB (TestClub.make) + 9 trait redraws (c3); corner = CORNERBASE1's five women (printed).
const M := preload("res://tools/coachmap2_rules.gd")
const CC2 := preload("res://tools/cornercmd2_rules.gd")
var C1 := 0.0
var LIMIT := false
var KNOWN0 := false
var C3 := false
var dtab := {}
var cur := {}
var cur_line := ""
var weeks_n := 104

func _initialize() -> void:
	var stage := _arg("stage", "season")
	if stage == "ctrl":
		super()
		return
	if stage == "corner":
		_corner_stage()
	else:
		_season_stage()
	quit(0)

## ---- the season (design s5) ----
func _season_stage() -> void:
	var t0 := Time.get_ticks_msec()
	C1 = float(_arg("c1", "0")); LIMIT = _arg("limit", "0") == "1"; C3 = _arg("c3", "0") == "1"; KNOWN0 = true
	cut["fall"] = "back_coach"   # S548: the falling-out by the rule (THE CUT)
	var dp := _arg("dtab", "")
	if dp != "":
		dtab = JSON.parse_string(FileAccess.get_file_as_string(dp))
	var reps := int(_arg("reps", "40")); var rosters := int(_arg("rosters", "1"))
	var c := Career.quick_start()
	c.seed = 5391
	TestClub.make(c)
	rep0 = float(c.reputation); cash0 = float(c.cash)
	swing = float(BoutRules.WIN_REPUTATION + BoutRules.LOSS_REPUTATION) / 3.0 + 4.0
	for f in c.fighters:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		g["book"] = [{"id": "own:1", "name": "Her combination", "chain": (R.BOOK.get(str(g.get("style", "")), ["jab", "cross"]) as Array).duplicate()}]
		g["own_combos"] = {}; g["plan_combo"] = "own:1"
		base.append(g)
	var ana: Dictionary = (c.grapplers[0] as Dictionary).duplicate(true)
	ana["personality"] = FighterProfile.make({"id": "ana", "style": "Counter-puncher", "stats": {}}, hash("ana"))["personality"]
	ana["style"] = "Counter-puncher"; ana["pot"] = 80; ana["morale"] = 60.0
	base.append(ana)
	for row in c.rivals:
		var list: Array = rivals.get_or_add(str(row["div"]), [])
		var rr: Dictionary = (row as Dictionary).duplicate(true)
		LadderPoints.rep_of(rr)
		list.append(rr)
	for d in rivals: (rivals[d] as Array).sort_custom(func(a, b): return float(a["rating"]) < float(b["rating"]))
	_say({"tag": "run", "stage": "season", "c1": C1, "limit": LIMIT, "c3": C3, "reps": reps, "rosters": rosters, "dtab": dtab,
		"fighters": base.map(func(f): return [f["first"], str(f.get("style", "")), int(f.get("age", 0)), f.get("personality", {})])})
	var want: Array = Array(_arg("cells", "").split(",", false))
	for cell in CELLS:
		if want.is_empty() or want.has(cell[0]):
			for r in rosters: _gym(cell, r, reps)
	print("COACHMAP2 season done %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))

## One gym (a cell x roster): the hire arms, the careful pick, the careless owner, the forced raise and push (fall is cut).
func _gym(cell: Array, r: int, reps: int) -> void:
	var cname := str(cell[0]); var size := str(cell[1]); var kind := str(cell[2])
	var b0 := base
	base = M.redraw(b0, r)
	var fs0 := _roster(kind)
	base = b0
	var pro := kind in ["pro", "pro_hot", "title", "title_mix"]
	var list := _list(cname)
	var members := float(SIZES[size]["members"])
	var blind := _pick(list, members, pro, "")
	var fav := _pick_word(list, members, pro, fs0) if C3 else blind
	var runs := {}
	for h in HIRES: runs[h] = {"hire": h, "line": "careful"}
	runs["PICK"] = {"hire": fav, "line": "careful"}
	runs["CARELESS"] = {"hire": blind, "line": "careless"}
	for fm in FORCED:
		if fm[0] == "fall": continue
		for a in fm[2]: runs["%s_%s" % [fm[0], a]] = {"hire": fav, "line": "careful", "force": {"kind": fm[0], "week": fm[1], "ans": a}}
	var rows := {}; var wd := {}
	for k in runs:
		rows[k] = []; wd[k] = []
		for j in reps:
			cur = {"wd": 0, "wk": 0}
			cur_line = str(runs[k]["line"])
			rows[k].append(_career(fs0, size, runs[k], r * 1000 + j))
			wd[k].append(float(cur["wd"]) / maxf(1.0, float(cur["wk"])))
	for k in rows:
		var o := {"tag": "arm", "cell": cname, "roster": r, "arm": k}
		for key in ["score", "cash", "rep", "wl", "morale", "next", "lost", "lost_box", "lost_coach", "members", "catch", "cash_end",
				"cash_min", "two_month", "bond_max", "chem_max", "moments", "fees", "warn"]:
			o[key] = snappedf(R.mean(rows[k], key), 0.01)
		o["lost_coach_max"] = rows[k].reduce(func(s, x): return maxf(s, float(x["lost_coach"])), 0.0)
		o["se"] = R.ms(rows[k].map(func(x): return x["score"]))[1]
		o["d_nohire"] = R.paired(rows[k], rows["NOHIRE"], "score")
		o["wdiff"] = snappedf(R.ms(wd[k])[0], 0.001)
		o["corner"] = {"differ": R.mean(rows[k].map(func(x): return x["corner"]), "differ"), "tac": R.mean(rows[k].map(func(x): return x["corner"]), "tac"), "bond": R.mean(rows[k].map(func(x): return x["corner"]), "bond")}
		o["who"] = R.who(rows[k])
		if reps == 1: o["log"] = rows[k][0]["log"]
		_say(o)
	var boxers: Array = fs0.filter(func(f): return str(f.get("sport", "")) != "bjj")
	var fc := R.coach(fav) if fav != "NOHIRE" else R.coach("REID")
	var pushed: Dictionary = boxers[0]
	for f in boxers:
		if R.fit(fc, str(f.get("style", ""))) < R.fit(fc, str(pushed.get("style", ""))): pushed = f
	var top: Dictionary = boxers[0]
	for f in boxers:
		if bool(f.get("pro", false)) or (not bool(top.get("pro", false)) and _mstat(f) > _mstat(top)): top = f
	_say({"tag": "gym", "cell": cname, "roster": r, "size": size, "kind": kind, "pro": pro, "list": list, "fav": fav, "blind": blind,
		"hot": boxers.any(func(f): return float(f["personality"].get("temper", 0)) > 60.0), "young": boxers.any(func(f): return int(f.get("age", 22)) < 21),
		"push_word": R.word(R.chemistry(fc, pushed.get("personality", {}))), "raise_word": R.word(R.chemistry(fc, top.get("personality", {}))),
		"roster_p": fs0.map(func(f): return [f["first"], int(f.get("age", 0)), bool(f.get("pro", false)), (f["personality"] as Dictionary).duplicate()])})

func _mstat(f: Dictionary) -> float:
	var s := 0.0; var n := 0.0
	for k in f["stats"]:
		if typeof(f["stats"][k]) in [TYPE_FLOAT, TYPE_INT]: s += float(f["stats"][k]); n += 1.0
	return s / maxf(1.0, n)

## Change 3's careful hire: among the affordable cards (as _pick), the highest card line "X more a season" (_gain).
func _pick_word(list: Array, members: float, pro: bool, fs0: Array) -> String:
	var fs: Array = []
	for f in fs0:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		g.merge({"left": false, "k": 0, "bond": {}, "p": [], "wc": false}, true)   # "wc" is the game's weight class until warn_tick writes the warned flag
		fs.append(g)
	var best := ""; var bv := -1e9; var cheap := ""
	for x in list:
		var cc := R.coach(str(x))
		var n := R.pays_at(cc, float(cc["wage"]), 1, float(StaffRoles.VOLUNTEER_MEMBERS + StaffRoles.COACH_MEMBERS * 2))
		var ok := (n >= 0 and float(n) <= members) or (str(x) == "K" and pro)
		var v := _gain(cc, str(x), fs)
		if ok and v > bv: bv = v; best = str(x)
		if cheap == "" or float(cc["wage"]) < float(R.coach(cheap)["wage"]): cheap = str(x)
	return best if best != "" else cheap

## ---- change 2: the limit; KNOWN0: the word from week 0 (no trial) ----
func _assign(co: Dictionary, fs: Array, asks: Array, known: bool, demand: int) -> Dictionary:
	var kn := known or KNOWN0
	if KNOWN0 and cur_line == "careful":   # the careful line unpairs a clash from week 0 (the word is on the hire card)
		for f in fs:
			for cid in co:
				if cid != "YOU" and R.word(_chem(co[cid], str(cid), f)) == "clash" and co.keys().any(func(x): return x != cid and R.knows(co[x], f)) and not (f["barred"] as Array).has(cid): f["barred"].append(cid)
	var free: Dictionary = super(co, fs, asks, kn, demand)
	if not LIMIT: return free
	var lim := _assign_lim(co, fs, asks, kn, demand)
	cur["wk"] = int(cur.get("wk", 0)) + 1
	for i in fs.size():
		if _main(free["places"][i]) != _main(lim["places"][i]):
			cur["wd"] = int(cur.get("wd", 0)) + 1
			break
	return lim

func _main(ev: Dictionary) -> String:
	var mn := ""
	for cid in ev:
		if mn == "" or int(ev[cid]) > int(ev[mn]): mn = str(cid)
	return mn

## COACHDEEP9's _assign with the limit: a coach takes no new boxer past his limit (M.limit_of).
func _assign_lim(co: Dictionary, fs: Array, asks: Array, known: bool, demand: int) -> Dictionary:
	var places: Array = []
	for f in fs: places.append({})
	var cap := {}; var nb := {}
	for cid in co:
		cap[cid] = int(co[cid]["ev_now"]) * R.PLACES_AN_EVENING
		nb[cid] = []
	var opts: Array = []
	for i in fs.size():
		if asks[i] > 0:
			for cid in co: opts.append([_value(co[cid], str(cid), fs[i], known), i, cid])
	opts.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
	for o in opts:
		var i := int(o[1])
		var cid: String = o[2]
		if not (nb[cid] as Array).has(i) and (nb[cid] as Array).size() >= M.limit_of(co[cid]): continue
		var give := mini(int(asks[i]) - R.sum(places[i]), int(cap[cid]))
		if give > 0 and float(o[0]) > -5.0:
			places[i][cid] = int(places[i].get(cid, 0)) + give
			cap[cid] = int(cap[cid]) - give
			if not (nb[cid] as Array).has(i): nb[cid].append(i)
	var ids: Array = co.keys()
	ids.sort_custom(func(a, b): return int(co[a]["teaching"]) > int(co[b]["teaching"]))
	var classes := 0; var teach := 0.0
	for cid in ids:
		var spare := int(cap[cid]) / R.PLACES_AN_EVENING
		while spare > 0 and classes < demand:
			spare -= 1; classes += 1
			teach = maxf(teach, float(co[cid]["teaching"]))
	return {"places": places, "classes": classes, "teach": teach}

## ---- change 1 in the season (design s2 (e)): everyone gets Reid's call price, plus the coach's measured live difference ----
func _c1_p(f: Dictionary, opp: Dictionary, c: Dictionary, cid: String, shaky: float) -> float:
	var ce0 := R.corner_edge(R.coach("REID"), str(f.get("style", "")), 0.0)
	var add := M.season_add(dtab, cid, _chem(c, cid, f), f.get("wc", false) is bool and bool(f["wc"]), bool(f.get("pro", false)), C1)
	return clampf(R.chance(f, opp, [ce0, ce0], shaky) + add, 0.01, 0.99)

func _bout(f: Dictionary, i: int, co: Dictionary, rep: int, st: Dictionary) -> Dictionary:
	if C1 <= 0.0: return super(f, i, co, rep, st)
	var k := int(f["k"]); f["k"] = k + 1
	var bjj := str(f.get("sport", "")) == "bjj"; var pro := bool(f.get("pro", false)); var opp := _opp(f, k)
	var ps := {}; var pick := ""; var best_v := -1e9
	for cid in co:
		var c: Dictionary = co[cid]
		if not R.knows(c, f): continue
		var p := 0.0
		if bjj:
			var own := (float(f["stats"]["cardio"]) + float(f["stats"]["composure"]) + float(f["stats"]["strength"])) / 3.0
			p = R.bjj_chance(own + 1.5 * R.tapes(c, true), 50.0 + float(k) * 0.35)
		else:
			p = _c1_p(f, opp, c, str(cid), R.PUSH_SHAKY if int(f["shaky"]) > 0 else 0.0)
		ps[cid] = p
		var v := p * swing + (R.name_fee(R.purse(int(f["prank"]))) / 1000.0 if pro and cid == "K" else 0.0)
		if v > best_v:
			best_v = v; pick = str(cid)
	if not bjj and ps.size() > 1:
		var tac := ""; var bond := ""; var bp := ""
		for cid in ps:
			if tac == "" or int(co[cid]["tactics"]) > int(co[tac]["tactics"]): tac = str(cid)
			if bond == "" or _chem(co[cid], str(cid), f) > _chem(co[bond], bond, f): bond = str(cid)
			if bp == "" or float(ps[cid]) > float(ps[bp]): bp = str(cid)
		var cs: Dictionary = st["corner"]
		cs["fights"] += 1.0
		if tac != bond:
			cs["differ"] += 1.0
			cs["tac"] += 1.0 if bp == tac else 0.0
			cs["bond"] += 1.0 if bp == bond else 0.0
	f["shaky"] = maxi(0, int(f["shaky"]) - 1)
	var c: Dictionary = co[pick]
	var out := {"cash": 0.0, "rep": 0.0, "wl": 0.0, "members": 0.0}
	if _rng([rep, i, k, "weigh"]).randf() < R.miss_chance(c, float((f.get("personality", {}) as Dictionary).get("discipline", 50.0))):
		out["rep"] = -1.0
		f["morale"] = maxf(0.0, float(f["morale"]) - 6.0)
		return out
	var p: float = ps[pick]
	(f["p"] as Array).append(p)
	if (f["p"] as Array).size() > 3: (f["p"] as Array).pop_front()
	var won := _rng([rep, i, k, "bout"]).randf() < p
	if pro:
		var pu := R.purse(int(f["prank"]))
		var fee := R.name_fee(pu) if pick == "K" else 0.0
		st["fees"] += fee
		out["cash"] = pu * Matchmaking.GYM_SHARE + fee
		out["rep"] = (float(BoutRules.WIN_REPUTATION) + (R.NAME_REP if pick == "K" else 0.0)) if won else -float(BoutRules.LOSS_REPUTATION)
		if won: f["prank"] = maxi(1, int(f["prank"]) - 1)
		elif bool(f.get("champ", false)):
			f["champ"] = false; f["prank"] = 3
		else: f["prank"] = mini(20, int(f["prank"]) + 2)
	else:
		out["cash"] = float(R.bout_pay(int(f["rank"]), BoutRules.TICKET_CUT))
		out["rep"] = float(BoutRules.WIN_REPUTATION) if won else -float(BoutRules.LOSS_REPUTATION)
		if not bjj:
			f["rep"] = LadderRep.apply(int(f["rep"]), LadderRep.change(int(f["rep"]), int(opp["rep"]), "win" if won else "loss", "ud"))
			f["rw"] = int(f["rw"]) + (1 if won else 0)
			f["rl"] = int(f["rl"]) + (0 if won else 1)
			f["rank"] = R.rank(int(f["rep"]), int(f["rw"]), int(f["rl"]), rivals[str(f["div"])], MIN_WINS)
	c["streak"] = int(c["streak"]) + 1 if won else 0
	if won and bool(f.get("champ", false)): c["streak"] = maxi(int(c["streak"]), R.RAISE_WINS)
	out["members"] = float(BoutRules.WIN_MEMBERS) if won else -float(BoutRules.LOSS_MEMBERS)
	out["wl"] = 1.0 if won else -1.0
	f["w"] = int(f["w"]) + (1 if won else 0)
	var mv := float(Loyalty.MOVES["bout_won"] if won else Loyalty.MOVES["bout_lost"])
	if float(f["loy"]) >= float(Loyalty.LOYAL_AT) and mv < 0.0: mv = 0.0
	f["loy"] = clampf(float(f["loy"]) + mv, 0.0, 100.0)
	FighterProfile.apply_morale(f, "win" if won else "loss", "probe")
	return out

## The hire card's "X more a season" with change 1: the corner part is the measured one (design s2 (e)).
func _gain(c: Dictionary, cid: String, fs: Array) -> float:
	if C1 <= 0.0: return super(c, cid, fs)
	var x := 0.0
	for f in fs:
		if bool(f["left"]) or not R.knows(c, f): continue
		var g: Dictionary = (f as Dictionary).duplicate(true)
		var bjj := str(f.get("sport", "")) == "bjj"
		var mor := float(f.get("morale", 60.0))
		var pc := R.pace(str(f.get("style", "")))
		var lm := R.learn_mult(c, str(f.get("style", "")), _chem(c, cid, f), mor, int(f.get("age", 22)) < 21, CHEM_SIZE)
		for k in (pc.keys() if not bjj else ["cardio", "composure", "strength"]):
			var ar := R.r100(c, "conditioning" if k == "cardio" else "pads") if bjj else R.area_r(c, str(k))
			var room := clampf((float(f.get("pot", 80)) - float(f["stats"][k])) / 25.0, 0.10, 1.25)
			g["stats"][k] = minf(99.0, float(f["stats"][k]) + 26.0 * float(pc.get(k, 0.33)) * room * maxf(0.0, R.lift(ar) * lm - R.trust(mor)) / R.lift(58.0))
		var k0 := int(f["k"])
		var n := 26.0 / (12.0 if bool(f.get("champ", false)) else 8.0) if bool(f.get("pro", false)) else 6.5
		if bjj:
			var o := 50.0 + float(k0) * 0.35
			var s0 := (float(f["stats"]["cardio"]) + float(f["stats"]["composure"]) + float(f["stats"]["strength"])) / 3.0
			var s1 := (float(g["stats"]["cardio"]) + float(g["stats"]["composure"]) + float(g["stats"]["strength"])) / 3.0
			x += n * (R.bjj_chance(s1 + 1.5 * R.tapes(c, true), o) - R.bjj_chance(s0, o))
		else:
			var opp := _opp(f, k0)
			x += n * (_c1_p(g, opp, c, cid, 0.0) - R.chance(f, opp, [0.0, 0.0], 0.0))
	return x

## ---- the bout stage (design s5): change 1 on CORNERBASE1's real bout ----
func _corner_stage() -> void:
	var t0 := Time.get_ticks_msec()
	var pop := M.population()
	var types: Array = pop[0]; var ours: Array = pop[1]; var coach := float(pop[2])
	var arms: Array = []
	if _arg("arms", "all") == "all":
		arms = ["reader", "file"]
		for cid in M.COACHES: arms.append("live:" + cid)
		arms += ["live:REID:b", "live:REID:x", "live:REID:w", "live:K:x"]
		for cid in M.COACHES: arms.append("sim:" + cid)
		arms += ["liveh:F", "liveh:REID:b", "simh:YOU", "simh:K"]
	else:
		arms = Array(_arg("arms", "").split(","))
	var n := int(_arg("n", "40"))
	var lens: Array = Array(_arg("lens", "3").split(",")).map(func(x): return int(x))
	var want := _arg("cells", "all")
	var only := _arg("only", "")
	var cells: Array = CC2.CELLS.filter(func(cl): return want == "all" or (want.split(",") as PackedStringArray).has(str(cl["id"])))
	_say({"tag": "run", "stage": "corner", "n": n, "lens": lens, "arms": arms, "coach": coach, "cells": cells.map(func(c): return c["id"]),
		"population": ours.map(func(i): return [types[i]["name"], types[i]["style"], types[i]["f"]["stats"], (types[i]["f"].get("personality", {}) as Dictionary).get("coachability", 0.0)])})
	var nb := 0
	for L in lens:
		for cl in cells:
			for oi in ours.size():
				if only != "" and not (only.split(",") as PackedStringArray).has(str(oi)): continue
				var ti := int(ours[oi])
				var g := {}
				for a in arms: g[a] = {"n": 0, "w": 0, "outs": "", "clue_wrong": 0, "ex": 0, "rec": 0, "ignored": 0, "hm": 0.0, "rests": 0, "hands": 0, "corners": 0}
				for k in n:
					for a in arms:
						var r := M.bout(types, ti, cl, int(L), k, str(a), coach)
						nb += 1
						var s: Dictionary = g[a]
						s["n"] = int(s["n"]) + 1
						s["w"] = int(s["w"]) + (1 if r["out"] == "win" else 0)
						s["outs"] = str(s["outs"]) + ("2" if r["out"] == "win" else ("1" if r["out"] == "draw" else "0"))
						for kk in ["clue_wrong", "ex", "rec", "ignored"]: s[kk] = int(s[kk]) + int(r["ev"][kk])
						s["hm"] = float(s["hm"]) + float(r["ev"]["hm"])
						for kk in ["rests", "hands", "corners"]: s[kk] = int(s[kk]) + int((r["cs"] as Dictionary).get(kk, 0))
				for a in arms: _say({"tag": "bout", "L": L, "cell": cl["id"], "boxer": types[ti]["name"], "arm": a, "agg": g[a]})
			print("CM2 corner L%d %s done, %d bouts, %.1f s" % [int(L), cl["id"], nb, (Time.get_ticks_msec() - t0) / 1000.0])
	print("COACHMAP2 corner done %.1f s, %d bouts" % [(Time.get_ticks_msec() - t0) / 1000.0, nb])
