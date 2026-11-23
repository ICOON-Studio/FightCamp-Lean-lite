extends SceneTree
## COACHDEEP2 (S539, ops/research/TASK_COACHDEEP2.md): greybox probe of deep coaches v2 - YOU (2 evenings, every rating 8),
## Luke Reid converted and one hired coach share their evenings between pads (2 boxers an evening) and class nights; who
## coaches whom, chemistry sized, departures priced by the game, the class-night trade, the hire by club size.
## Bars: docs/COACHDEEP2_RESULT.md s2 (written before the run). Rules copy: tools/coachdeep2_rules.gd. Built from coachdeep1.
## POPULATION: the TEST CLUB (TestClub.make on Career.quick_start): Lucy, Kira (18), Josh, Ana (no-gi), their own traits.
## Usage: godot --headless --script res://tools/coachdeep2.gd -- mode=full|sweep [reps=30] [hreps=12] [size=1.0] [out=...]

const Data := preload("res://scripts/state/Data.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const R := preload("res://tools/coachdeep2_rules.gd")

const ARMS := ["LAZY", "STAT", "CHEM", "NEXT", "STAR", "SMART", "CLASS"]
const WEEKS := 104
const SIZES := {"small": {"members": 30.0, "add": 0.0}, "big": {"members": 70.0, "add": 30.0}}
const PACE := {"technique": 0.4, "defense": 0.3, "conditioning": 0.3}
const AREA := {"technique": "pads", "defense": "pads", "conditioning": "conditioning"}
const DRILL := ["Jab", "Cross"]
var base: Array = []
var rivals := {}
var rep0 := 0.0
var out_path := ""
var chem_size := 1.0
var class_v := 1.0   ## DIAGNOSTIC only (classv=): a class night's cash and members x this; the verdict runs at 1.0
var stip_v := 1.0    ## DIAGNOSTIC only (stipend=): the stipends x this; the verdict runs at 1.0

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
	class_v = float(_arg("classv", "1.0"))
	stip_v = float(_arg("stipend", "1.0"))
	var reps := int(_arg("reps", "30"))
	var c := Career.quick_start()
	c.seed = 5391
	TestClub.make(c)
	rep0 = float(c.reputation)
	for f in c.fighters:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		g["arrows"] = []
		base.append(g)
	var ana: Dictionary = (c.grapplers[0] as Dictionary).duplicate(true)
	ana["personality"] = FighterProfile.make({"id": "ana", "style": "Counter-puncher", "stats": {}}, hash("ana"))["personality"]
	ana["style"] = "Counter-puncher"
	ana["pot"] = 80
	ana["morale"] = 60.0
	base.append(ana)
	for row in c.rivals:
		var list: Array = rivals.get_or_add(str(row["div"]), [])
		list.append((row as Dictionary).duplicate(true))
	for d in rivals:
		(rivals[d] as Array).sort_custom(func(a, b): return float(a["rating"]) < float(b["rating"]))
	_say({"tag": "run", "mode": _arg("mode", "full"), "reps": reps, "rep0": rep0, "fighters": base.map(func(f): return [f["first"],
		str(f.get("style", "")), int(f.get("age", 0)), float(f.get("weekly_salary", 0)), Loyalty.value(f), f.get("personality", {})])})
	if _arg("mode", "full") == "sweep":
		for sz in [1.0, 0.6, 0.4, 0.25]:
			chem_size = sz
			var wins := {}
			for size in SIZES:
				for x in R.CANDIDATES:
					var rows := _arms(_coaches(str(x)), str(size), reps)
					var b := _best(rows)
					wins[b] = int(wins.get(b, 0)) + 1
			_say({"tag": "sweep", "size": sz, "best_counts": wins})
	else:
		chem_size = float(_arg("size", "1.0"))
		var hreps := int(_arg("hreps", "12"))
		for size in SIZES:
			var nh := _arms({"YOU": R.coach("YOU"), "REID": R.coach("REID")}, str(size), reps)
			var nb := _best(nh)
			_emit(str(size), "NOHIRE", nh, nb)
			for x in R.CANDIDATES:
				_cell(str(size), str(x), reps, hreps, nh[nb])
	print("COACHDEEP2 done %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)

func _coaches(x: String) -> Dictionary:
	return {"YOU": R.coach("YOU"), "REID": R.coach("REID"), x: R.coach(x)}

func _arms(coaches: Dictionary, size: String, reps: int) -> Dictionary:
	var rows := {}
	for arm in ARMS:
		rows[arm] = []
		for rep in reps:
			rows[arm].append(_career(coaches, str(arm), rep, true, size, -1))
	return rows

func _best(rows: Dictionary) -> String:
	var best := "LAZY"
	for arm in ARMS:
		if R.mean(rows[arm], "score") > R.mean(rows[best], "score"):
			best = str(arm)
	return best

func _emit(size: String, cell: String, rows: Dictionary, best: String) -> void:
	for k in rows:
		_say({"tag": "arm", "size": size, "cell": cell, "arm": k, "best": best, "score": R.mean(rows[k], "score"),
			"cash": R.mean(rows[k], "cash"), "rep": R.mean(rows[k], "rep"), "wl": R.mean(rows[k], "wl"), "morale": R.mean(rows[k], "morale"),
			"next": R.mean(rows[k], "next"), "left": R.mean(rows[k], "left"), "classes": R.mean(rows[k], "classes"),
			"members": R.mean(rows[k], "members"), "who_left": R.who(rows[k]), "price": R.price(rows[k]), "per": R.per_mean(rows[k], base.map(func(f): return f["first"])),
			"d_lazy": R.paired(rows[k], rows["LAZY"], "score")})

## One cell (club size x candidate): arms, CHEMOFF, ALL_REID / ALL_X, the hire v NOHIRE, the evening trade.
func _cell(size: String, x: String, reps: int, hreps: int, nohire: Array) -> void:
	var coaches := _coaches(x)
	var rows := _arms(coaches, size, reps)
	var best := _best(rows)
	rows["CHEMOFF"] = []
	for rep in reps:
		rows["CHEMOFF"].append(_career(coaches, best, rep, false, size, -1))
	for y in ["REID", x]:
		rows["ALL_" + y] = []
		for rep in reps:
			rows["ALL_" + y].append(_career(coaches, "ALL_" + y, rep, true, size, -1))
	_emit(size, x, rows, best)
	var lines := {}
	for key in ["cash", "rep", "wl", "morale", "score", "left"]:
		lines[key] = {"chem": R.paired(rows[best], rows["CHEMOFF"], key), "lazy": R.paired(rows[best], rows["LAZY"], key),
			"hire": R.paired(rows[best], nohire, key)}
	var per := {}
	for i in base.size():
		per[str(base[i]["first"])] = R.paired_per(rows["ALL_REID"], rows["ALL_" + x], i)
	_say({"tag": "cell", "size": size, "cell": x, "best": best, "lines": lines, "reid_minus_x": per})
	for w in range(4, WEEKS, 8):
		var d: Array = []
		for rep in hreps:
			var flip := _career(coaches, best, rep, true, size, w)
			if bool(flip["trade"]):
				d.append(float(flip["sign"]) * (float(flip["score"]) - float(rows[best][rep]["score"])))
		_say({"tag": "trade", "size": size, "cell": x, "arm": best, "week": w, "n": d.size(), "class_minus_pad": R.ms(d)})

func _knows(c: Dictionary, f: Dictionary) -> bool:
	return (c["arts"] as Array).has("bjj" if str(f.get("sport", "")) == "bjj" else "boxing")

func _chem(c: Dictionary, cid: String, f: Dictionary, chem_on: bool) -> float:
	if not chem_on:
		return 0.0
	return clampf(R.chemistry(c, f.get("personality", {})) + float((f["bond"] as Dictionary).get(cid, 0.0)), -1.0, 1.0)

func _bout_week(i: int, week: int) -> bool:
	return (week + 1 + i) % 4 == 0

func _career(coaches: Dictionary, arm: String, rep: int, chem_on: bool, size: String, flip: int) -> Dictionary:
	var fs: Array = []
	for f in base:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		g.merge({"low": 0, "left": false, "bond": {}, "k": 0, "w": 0, "loy": float(Loyalty.value(f)), "short_last": false,
			"short_at": -99, "p": [], "t": {"cash": 0.0, "rep": 0.0, "wl": 0.0}}, true)
		fs.append(g)
	var cfg: Dictionary = SIZES[size]
	var members := float(cfg["members"])
	var acc := {"cash": 0.0, "rep": 0.0, "wl": 0.0, "classes": 0.0}
	var prices: Array = []
	var trade := false
	var bjj := false
	for cid in coaches:
		bjj = bjj or (coaches[cid]["arts"] as Array).has("bjj")
	for week in WEEKS:
		var asks: Array = []
		for i in fs.size():
			var f: Dictionary = fs[i]
			var a := 0 if bool(f["left"]) or (str(f.get("sport", "")) == "bjj" and not bjj) else int(ClubDeal.ASK["ordinary"])
			if a > 0 and _bout_week(i, week):
				a += int(ClubDeal.ASK["fight_week_extra"])
			asks.append(a)
		var demand := R.class_demand(members)
		var pl := _assign(arm, coaches, fs, asks, week, chem_on, demand)
		var classes: int = int(pl["classes"])
		var teach := float(pl["teach"])
		var sign := 1.0
		if week == flip and classes > 0 and int(pl["free"]) == 0 and _give_back(pl, coaches, fs, asks):
			trade = true   # mirror: a class night goes back to pads for the boxers short (CLASS minus PAD = base - flip)
			sign = -1.0
			classes -= 1
		elif week == flip and int(pl["free"]) == 0 and demand > classes and not (pl["order"] as Array).is_empty():
			trade = true   # one pad evening becomes a class: the last (lowest-valued) 2 places dealt go
			var gone := 0
			while gone < R.PLACES_AN_EVENING and not (pl["order"] as Array).is_empty():
				var o: Array = (pl["order"] as Array).pop_back()
				var pi: Dictionary = pl["places"][int(o[0])]
				pi[o[1]] = int(pi[o[1]]) - 1
				if int(pi[o[1]]) <= 0:
					pi.erase(o[1])
				teach = maxf(teach, float(coaches[o[1]]["teaching"]))
				gone += 1
			classes += 1
		acc["classes"] += float(classes)
		if trade and week == flip:
			acc["sign"] = sign
		var cash := class_v * float(classes * ClubDeal.class_cash(1)) + members * float(GymBills.FEE_MONTH) / GymBills.WEEKS_A_MONTH
		for cid in coaches:
			cash -= float(coaches[cid]["wage"])
		for i in fs.size():
			var f: Dictionary = fs[i]
			if bool(f["left"]):
				continue
			cash -= stip_v * float(f.get("weekly_salary", 0))
			_train(f, pl["places"][i], coaches, chem_on)
			if asks[i] > 0:
				_loyal_week(f, _sum(pl["places"][i]) < asks[i], week)
			if _bout_week(i, week):
				var res := _bout(f, i, pl["places"][i], coaches, rep, asks[i])
				cash += float(res["cash"])
				acc["rep"] += float(res["rep"])
				acc["wl"] += float(res["wl"])
				members += float(res["members"])
				f["t"]["cash"] += float(res["cash"])
				f["t"]["rep"] += float(res["rep"])
				f["t"]["wl"] += float(res["wl"])
			f["low"] = int(f["low"]) + 1 if float(f["loy"]) < float(Loyalty.LEAVES_UNDER) else 0
			if int(f["low"]) >= 2:
				prices.append(_leave(f, fs, acc))
		acc["cash"] += cash
		var target := float(Membership.natural_members(clampi(int(rep0 + acc["rep"]), 0, 100))) + float(cfg["add"]) + class_v * R.CLASS_TARGET * float(classes) * teach / 10.0
		var room := StaffRoles.VOLUNTEER_MEMBERS + StaffRoles.COACH_MEMBERS * coaches.size()   # StaffRoles.coaching_cap
		members = minf(float(room), float(Membership.step_members(int(members), int(minf(target, float(room))))))
	var mor := 0.0
	var per: Array = []
	var gone_n := 0.0
	var nxt := 0.0
	for f in fs:
		var m := 0.0 if bool(f["left"]) else float(f.get("morale", 60.0))
		mor += m / fs.size()
		gone_n += float(bool(f["left"]))
		var y := 0.0 if bool(f["left"]) else float(_year(f)["lines"])
		nxt += y
		per.append(R.score(float(f["t"]["cash"]), float(f["t"]["rep"]), float(f["t"]["wl"]), m) + y)
	var who := ""
	for f in fs:
		if bool(f["left"]):
			who += str(f["first"]) + " "
	return {"cash": acc["cash"], "rep": acc["rep"], "wl": acc["wl"], "morale": mor, "next": nxt, "left": gone_n, "who_left": who,
		"members": members, "classes": acc["classes"], "prices": prices, "trade": trade, "sign": float(acc.get("sign", 1.0)), "per": per,
		"score": R.score(acc["cash"], acc["rep"], acc["wl"], mor) + nxt}

func _year(f: Dictionary) -> Dictionary:
	var ps: Array = f["p"]
	var p := 0.5
	if not ps.is_empty():
		p = 0.0
		for x in ps:
			p += float(x) / ps.size()
	return R.year_value(p, float(BoutRules.TICKET_CUT), stip_v * float(f.get("weekly_salary", 0)), float(BoutRules.WIN_REPUTATION), float(BoutRules.LOSS_REPUTATION))

## The game's weekly loyalty moves (Loyalty.MOVES): a short week, a short week running, a full week; a Loyal boxer's
## first short in FREE_DAYS is free (Loyalty.gd:124-125).
func _loyal_week(f: Dictionary, short: bool, week: int) -> void:
	var n := float(Loyalty.MOVES["full_week"])
	if short:
		if float(f["loy"]) >= float(Loyalty.LOYAL_AT) and week - int(f["short_at"]) >= Loyalty.FREE_DAYS / 7:
			n = 0.0
		else:
			n = float(Loyalty.MOVES["short_running"] if bool(f["short_last"]) else Loyalty.MOVES["short"])
		f["short_at"] = week
	f["short_last"] = short
	f["loy"] = clampf(float(f["loy"]) + n, 0.0, 100.0)

## She leaves (Leaving._go): reputation, team-mates under SETTLED_AT, the stipend stops (she is skipped from now on).
func _leave(f: Dictionary, fs: Array, acc: Dictionary) -> Dictionary:
	f["left"] = true
	var lr := float(Leaving.REP_LEAVE_RANKED if int(f["w"]) >= 4 else Leaving.REP_LEAVE)   # ranked: 4+ wins stands in for top 5
	acc["rep"] += lr
	for t in fs:
		if not bool(t["left"]) and float(t["loy"]) < float(Loyalty.SETTLED_AT):
			t["loy"] = maxf(0.0, float(t["loy"]) + float(Loyalty.MOVES["teammate_left"]))
	var y := _year(f)
	return {"lines": float(y["lines"]) - lr / 3.0, "cash": float(y["cash"]) / 1000.0, "rep": float(y["rep"]) / 3.0, "leave_rep": -lr / 3.0}

func _value(arm: String, c: Dictionary, cid: String, f: Dictionary, i: int, week: int, chem_on: bool) -> float:
	if not _knows(c, f):
		return -10.0
	match arm:
		"STAT":
			return float(c["pads"]) * 0.7 + float(c["conditioning"]) * 0.3
		"CHEM":
			return _chem(c, cid, f, true) + 0.5 * R.fit(c, str(f.get("style", "")))
		"NEXT":
			var d := 0
			while d < 4 and not _bout_week(i, week + d):
				d += 1
			return 10.0 * (3 - d) + float(c["tactics"]) + float(c["film"])
		"STAR":
			return float(f.get("pot", 70)) + float(c["pads"])
	return R.lift(float(c["pads"]) * 3.5 + float(c["conditioning"]) * 1.5) * R.learn_mult(c, str(f.get("style", "")),
		_chem(c, cid, f, chem_on), float(f.get("morale", 60.0)), int(f.get("age", 22)) < 21, chem_size)

## {places: [{cid: n}], order: [[i, cid]] dealt one place each, classes, free (evenings left), teach (best class teacher)}.
func _assign(arm: String, coaches: Dictionary, fs: Array, asks: Array, week: int, chem_on: bool, demand: int) -> Dictionary:
	var places: Array = []
	for f in fs:
		places.append({})
	var order: Array = []
	var ids: Array = coaches.keys()
	ids.sort_custom(func(a, b): return int(coaches[a]["teaching"]) > int(coaches[b]["teaching"]))
	var ev := {}
	for cid in ids:
		ev[cid] = int(coaches[cid]["evenings"])
	var classes := 0
	var teach := 0.0
	if arm.begins_with("ALL_"):
		for i in fs.size():
			if asks[i] > 0 and _knows(coaches[arm.trim_prefix("ALL_")], fs[i]):
				places[i][arm.trim_prefix("ALL_")] = asks[i]
		return {"places": places, "order": order, "classes": 0, "free": 0, "teach": 0.0}
	if arm == "CLASS":   # class nights first, the best teacher's evenings first
		for cid in ids:
			while classes < demand and int(ev[cid]) > 0:
				ev[cid] = int(ev[cid]) - 1
				classes += 1
				teach = maxf(teach, float(coaches[cid]["teaching"]))
	var cap := {}
	for cid in ids:
		cap[cid] = int(ev[cid]) * R.PLACES_AN_EVENING
	if arm == "LAZY":   # round robin: each coach's places spread evenly
		for cid in ids:
			var moved := true
			while int(cap[cid]) > 0 and moved:
				moved = false
				for i in fs.size():
					if int(cap[cid]) > 0 and _sum(places[i]) < asks[i] and _knows(coaches[cid], fs[i]):
						places[i][cid] = int(places[i].get(cid, 0)) + 1
						cap[cid] = int(cap[cid]) - 1
						order.append([i, cid])
						moved = true
	else:
		var opts: Array = []
		for i in fs.size():
			if asks[i] > 0:
				for cid in ids:
					opts.append([_value("SMART" if arm == "CLASS" else arm, coaches[cid], str(cid), fs[i], i, week, chem_on), i, cid])
		opts.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
		for o in opts:
			var i := int(o[1])
			var cid: String = o[2]
			var give := mini(int(asks[i]) - _sum(places[i]), int(cap[cid]))
			if give > 0 and float(o[0]) > -5.0:
				places[i][cid] = int(places[i].get(cid, 0)) + give
				cap[cid] = int(cap[cid]) - give
				for _n in give:
					order.append([i, cid])
	var free := 0
	for cid in ids:   # an evening with no place used is free: a class night if the members fill it
		var spare := int(cap[cid]) / R.PLACES_AN_EVENING
		while spare > 0 and classes < demand:
			spare -= 1
			classes += 1
			teach = maxf(teach, float(coaches[cid]["teaching"]))
		free += spare
	return {"places": places, "order": order, "classes": classes, "free": free, "teach": teach}

## A class night handed back: 2 places to the boxers most short, from a coach running a class who can teach them.
func _give_back(pl: Dictionary, coaches: Dictionary, fs: Array, asks: Array) -> bool:
	var given := 0
	for cid in coaches:
		for i in fs.size():
			while given < R.PLACES_AN_EVENING and _sum(pl["places"][i]) < int(asks[i]) and _knows(coaches[cid], fs[i]):
				pl["places"][i][cid] = int(pl["places"][i].get(cid, 0)) + 1
				given += 1
		if given > 0:
			return true
	return false

func _sum(d: Dictionary) -> int:
	var s := 0
	for k in d:
		s += int(d[k])
	return s

func _train(f: Dictionary, ev: Dictionary, coaches: Dictionary, chem_on: bool) -> void:
	var young := int(f.get("age", 22)) < 21
	var morale := float(f.get("morale", 60.0))
	var style := str(f.get("style", ""))
	var total := float(_sum(ev))
	var ord := minf(total, float(R.ORDINARY))
	var shares := {}
	var chems := {}
	var mults := {}
	var alone := 1.0
	for cid in ev:
		var c: Dictionary = coaches[cid]
		chems[cid] = _chem(c, cid, f, chem_on)
		mults[cid] = R.learn_mult(c, style, float(chems[cid]), morale, young, chem_size)
		shares[cid] = float(ev[cid]) / total * ord / float(R.ORDINARY)
		alone -= float(shares[cid])
	var stats: Dictionary = f["stats"]
	var pot := float(f.get("pot", 80))
	var keys: Array = PACE.keys() if str(f.get("sport", "")) != "bjj" else ["cardio", "composure", "strength"]
	for k in keys:
		var area := str(AREA.get(k, "pads" if k != "cardio" else "conditioning"))
		var room := clampf((pot - float(stats[k])) / 25.0, 0.10, 1.25)
		var m := maxf(0.0, alone) * R.trust(morale)
		for cid in shares:
			m += float(shares[cid]) * R.lift(R.r100(coaches[cid], area)) * float(mults[cid])
		stats[k] = minf(99.0, float(stats[k]) + float(PACE.get(k, 0.33)) * room * m / R.lift(58.0))
	if str(f.get("sport", "")) != "bjj":
		for mv in DRILL:
			var cap := MoveMastery.cap(float(stats["technique"]), float(stats.get("fight_iq", 55.0)))
			var mm := float(f["moves"].get(mv, 0.0))
			var dm := MoveMastery.gain(mm, "pads", 75.0 * maxf(0.0, alone), 0.0, 2.0, R.trust(morale), cap) - mm
			for cid in shares:
				var sp := 1.0 if (coaches[cid]["spec"] as Array).has(mv) else R.OFF_SPEC
				dm += (MoveMastery.gain(mm, "pads", 75.0 * float(shares[cid]), R.r100(coaches[cid], "pads"), 2.0, 1.0, cap) - mm) * float(mults[cid]) * sp
			f["moves"][mv] = minf(cap, mm + dm * 0.5)
	f["morale"] = R.morale_week(morale, shares, chems, coaches, chem_size)
	var loy := 0.0
	for cid in shares:
		loy += R.CHEM_LOYAL * chem_size * float(shares[cid]) * float(chems[cid])
	f["loy"] = clampf(float(f["loy"]) + loy, 0.0, 100.0)
	var bond: Dictionary = f["bond"]
	for cid in coaches:
		bond[cid] = minf(R.BOND_CAP, float(bond.get(cid, 0.0)) + R.BOND_WEEK) if shares.has(cid) else maxf(0.0, float(bond.get(cid, 0.0)) - R.BOND_FADE)

func _bout(f: Dictionary, i: int, ev: Dictionary, coaches: Dictionary, rep: int, ask: int) -> Dictionary:
	var k := int(f["k"])
	f["k"] = k + 1
	var cid := ""
	for x in ev:
		if cid == "" or int(ev[x]) > int(ev[cid]) or (int(ev[x]) == int(ev[cid]) and int(coaches[x]["tactics"]) > int(coaches[cid]["tactics"])):
			cid = str(x)
	if cid == "":
		cid = "YOU"   # nobody coached her this week: you corner her
	var c: Dictionary = coaches[cid]
	var film := _sum(ev) > R.ORDINARY or ask == 0
	var out := {"cash": 0.0, "rep": 0.0, "wl": 0.0, "members": 0.0}
	if _rng([rep, i, k, "weigh"]).randf() < R.miss_chance(c, float((f.get("personality", {}) as Dictionary).get("discipline", 50.0))):
		out["rep"] = -1.0
		f["morale"] = maxf(0.0, float(f["morale"]) - 6.0)
		return out
	var p := 0.0
	if str(f.get("sport", "")) == "bjj":
		var own := (float(f["stats"]["cardio"]) + float(f["stats"]["composure"]) + float(f["stats"]["strength"])) / 3.0
		p = R.bjj_chance(own + 1.5 * R.tapes(c, film), 50.0 + float(k) * 0.35)
	else:
		var list: Array = rivals[str(f["div"])]
		var opp: Dictionary = (list[mini(k / 3, list.size() - 1)] as Dictionary).duplicate(true)
		for _t in R.tapes(c, film):
			OppFile.tape(opp)
		f["arrows"] = []
		f["bout"] = {}
		p = BoutRead.chance(f, opp, {}, R.plan_rating(c, str(f.get("style", ""))))
	(f["p"] as Array).append(p)
	if (f["p"] as Array).size() > 3:
		(f["p"] as Array).pop_front()
	var won := _rng([rep, i, k, "bout"]).randf() < p
	out["cash"] = float(BoutRules.TICKET_CUT)
	out["rep"] = float(BoutRules.WIN_REPUTATION) if won else -float(BoutRules.LOSS_REPUTATION)
	out["members"] = float(BoutRules.WIN_MEMBERS) if won else -float(BoutRules.LOSS_MEMBERS)
	out["wl"] = 1.0 if won else -1.0
	f["w"] = int(f["w"]) + (1 if won else 0)
	var mv := float(Loyalty.MOVES["bout_won"] if won else Loyalty.MOVES["bout_lost"])
	if float(f["loy"]) >= float(Loyalty.LOYAL_AT) and mv < 0.0:
		mv = 0.0   # Loyalty.HALVED_WHEN_LOYAL: -1 -> 0
	f["loy"] = clampf(float(f["loy"]) + mv, 0.0, 100.0)
	FighterProfile.apply_morale(f, "win" if won else "loss", "probe")
	return out
