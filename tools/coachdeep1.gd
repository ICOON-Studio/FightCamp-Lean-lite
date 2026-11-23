extends SceneTree
## COACHDEEP1 (S539, ops/research/TASK_COACHDEEP1.md): greybox probe of the CORE lever of coaches as people - which coach
## spends his limited evenings on which boxer, when chemistry (personality v personality, a bond that grows), his playbook
## (his way of boxing v her style) and his attributes all matter. Nothing under scripts/ changes; the new rules are the
## flagged copy tools/coachdeep1_rules.gd. Bars: docs/COACHDEEP1_RESULT.md s2 (written before the run).
## POPULATION: the TEST CLUB (TestClub.make on Career.quick_start): Lucy (wlw Out-boxer), Kira (wfw Out-boxer, 18), Josh (mww
## Pressure fighter), Ana (no-gi). Their own personalities (Data.PROSPECTS / FighterProfile.make), stats, potentials.
## CELLS: the 10 pairs of five coaches (rules COACHES A-E), 3 evenings each = 6 coached evenings for 8 wanted.
## 104 weeks; a bout every 4 weeks each (staggered), her division's named rivals in rising order; the game's fight read
## (BoutRead.chance, her corner's plan via CoachPlan.write at his tactics, his film opening OppFile tells) and the dice on
## the fight day. Common random numbers: one rng per (rep, fighter, bout, event), the same in every arm.
## Usage: godot --headless --script res://tools/coachdeep1.gd -- [reps=30] [cells=all|AB,CD] [out=E:/FightCamp/tmp/coachdeep1/x.jsonl]

const Data := preload("res://scripts/state/Data.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const R := preload("res://tools/coachdeep1_rules.gd")

const ARMS := ["LAZY", "STAT", "CHEM", "NEXT", "STAR", "SMART"]
const WEEKS := 104
const TICKET := 450.0   ## CLAUDE.md decided: an amateur bout pays the club a $450 ticket cut
## Cash = ticket cuts only (a missed weight or a boxer gone = no cut). Members from wins are reported, not paid out as dues:
## WIN_MEMBERS x dues over the remaining weeks counted each early win 50+ times in the smoke run.
const PACE := {"technique": 0.4, "defense": 0.3, "conditioning": 0.3}   ## the 1.0 a focused week (CLAUDE.md), split
const AREA := {"technique": "pads", "defense": "pads", "conditioning": "conditioning"}
const DRILL := ["Jab", "Cross"]
var base: Array = []      ## the four fighters as the test club signs them
var rivals := {}          ## div -> Array of opponent rows, rising rating
var out_path := ""


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
	var reps := int(_arg("reps", "30"))
	var c := Career.quick_start()
	c.seed = 5391
	TestClub.make(c)
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
	for row in c.rivals:   # the career's named rivals, every division (as tools/hostprobe2.gd _pool)
		var list: Array = rivals.get_or_add(str(row["div"]), [])
		list.append((row as Dictionary).duplicate(true))
	for d in rivals:
		(rivals[d] as Array).sort_custom(func(a, b): return float(a["rating"]) < float(b["rating"]))
	var pairs: Array = []
	var ids := ["A", "B", "C", "D", "E"]
	for i in ids.size():
		for j in range(i + 1, ids.size()):
			pairs.append(ids[i] + ids[j])
	var want := _arg("cells", "all")
	if want != "all":
		pairs = pairs.filter(func(p): return want.split(",").has(p))
	_say({"tag": "rivals", "per_div": rivals.keys().map(func(d): return [d, (rivals[d] as Array).map(func(r): return [r["name"], r["rating"], r["style"]])])})
	_say({"tag": "run", "reps": reps, "cells": pairs, "fighters": base.map(func(f): return [f["first"], str(f.get("div", "nogi")), str(f.get("style", "")), f.get("personality", {})])})
	for p in pairs:
		_cell(str(p), reps)
	print("COACHDEEP1 done %d cells %.1f s" % [pairs.size(), (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


## One cell: every arm, then the chemistry-off control of the cell's best arm, then the two one-coach diagnostics.
func _cell(pair: String, reps: int) -> void:
	var coaches := {pair[0]: R.coach(pair[0]), pair[1]: R.coach(pair[1])}
	var rows := {}
	for arm in ARMS:
		rows[arm] = []
		for rep in reps:
			rows[arm].append(_career(coaches, str(arm), rep, true))
	var best := "LAZY"
	for arm in ARMS:
		if _mean(rows[arm], "score") > _mean(rows[best], "score"):
			best = str(arm)
	rows["CHEMOFF"] = []
	for rep in reps:
		rows["CHEMOFF"].append(_career(coaches, best, rep, false))
	for x in [pair[0], pair[1]]:
		rows["ALL_" + x] = []
		for rep in reps:
			rows["ALL_" + x].append(_career(coaches, "ALL_" + x, rep, true))
	for k in rows:
		_say({"tag": "arm", "cell": pair, "arm": k, "best": best, "n": reps, "score": _mean(rows[k], "score"),
			"cash": _mean(rows[k], "cash"), "rep": _mean(rows[k], "rep"), "wl": _mean(rows[k], "wl"), "morale": _mean(rows[k], "morale"),
			"misses": _mean(rows[k], "misses"), "left": _mean(rows[k], "left"), "members": _mean(rows[k], "members"), "who_left": _who(rows[k]),
			"per": _per_mean(rows[k]), "d_lazy": _paired(rows[k], rows["LAZY"], "score"),
			"d_best": _paired(rows[k], rows[best], "score")})
	# raw paired diffs the result needs: best v CHEMOFF on each line, best v LAZY on each line, per boxer ALL_x v ALL_y
	var lines := {}
	for key in ["cash", "rep", "wl", "morale", "score"]:
		lines[key] = {"chem": _paired(rows[best], rows["CHEMOFF"], key), "lazy": _paired(rows[best], rows["LAZY"], key)}
	var per := {}
	for i in base.size():
		var nm := str(base[i]["first"])
		per[nm] = _paired_per(rows["ALL_" + pair[0]], rows["ALL_" + pair[1]], i)
	_say({"tag": "cell", "cell": pair, "best": best, "lines": lines, "boxer_a_minus_b": per})


func _mean(rs: Array, k: String) -> float:
	var s := 0.0
	for r in rs:
		s += float(r[k])
	return s / maxf(1.0, rs.size())


func _who(rs: Array) -> Dictionary:
	var out := {}
	for r in rs:
		for n in str(r["who_left"]).split(" ", false):
			out[n] = int(out.get(n, 0)) + 1
	return out


func _per_mean(rs: Array) -> Dictionary:
	var out := {}
	for i in base.size():
		var s := 0.0
		for r in rs:
			s += float(r["per"][i])
		out[str(base[i]["first"])] = s / maxf(1.0, rs.size())
	return out


## [mean, standard error] of a - b, paired by rep.
func _paired(a: Array, b: Array, k: String) -> Array:
	var d: Array = []
	for i in a.size():
		d.append(float(a[i][k]) - float(b[i][k]))
	return _ms(d)


func _paired_per(a: Array, b: Array, fi: int) -> Array:
	var d: Array = []
	for i in a.size():
		d.append(float(a[i]["per"][fi]) - float(b[i]["per"][fi]))
	return _ms(d)


func _ms(d: Array) -> Array:
	var n := float(d.size())
	var m := 0.0
	for x in d:
		m += float(x)
	m /= maxf(1.0, n)
	var v := 0.0
	for x in d:
		v += (float(x) - m) * (float(x) - m)
	var se := sqrt(v / maxf(1.0, n - 1.0) / maxf(1.0, n))
	return [snappedf(m, 0.001), snappedf(se, 0.001)]


## The line score: $1,000, 3 reputation, 0.5 of a win less loss, 5 morale each count one.
static func score(cash: float, rep: float, wl: float, morale: float) -> float:
	return cash / 1000.0 + rep / 3.0 + wl / 0.5 + morale / 5.0


func _career(coaches: Dictionary, arm: String, rep: int, chem_on: bool) -> Dictionary:
	var fs: Array = []
	for f in base:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		g["low_weeks"] = 0
		g["left"] = false
		g["bond"] = {}
		g["k"] = 0
		g["t"] = {"cash": 0.0, "rep": 0.0, "wl": 0.0}
		fs.append(g)
	var members := 30.0
	var acc := {"cash": 0.0, "rep": 0.0, "wl": 0.0, "misses": 0.0}
	for week in WEEKS:
		var plan := _assign(arm, coaches, fs, week, chem_on)
		for i in fs.size():
			var f: Dictionary = fs[i]
			if bool(f["left"]):
				continue
			_train(f, plan[i], coaches, chem_on)
			if _bout_week(i, week):
				var res := _bout(f, i, plan[i], coaches, rep, chem_on)
				acc["misses"] += float(res["miss"])
				acc["cash"] += float(res["cash"])
				acc["rep"] += float(res["rep"])
				acc["wl"] += float(res["wl"])
				members += float(res["members"])
				f["t"]["cash"] += float(res["cash"])
				f["t"]["rep"] += float(res["rep"])
				f["t"]["wl"] += float(res["wl"])
	var mor := 0.0
	var per: Array = []
	var gone := 0.0
	for f in fs:
		var m := 0.0 if bool(f["left"]) else float(f.get("morale", 60.0))
		mor += m / fs.size()
		gone += float(bool(f["left"]))
		per.append(score(float(f["t"]["cash"]), float(f["t"]["rep"]), float(f["t"]["wl"]), m))
	var who := ""
	for f in fs:
		if bool(f["left"]):
			who += str(f["first"]) + " "
	return {"cash": acc["cash"], "rep": acc["rep"], "wl": acc["wl"], "morale": mor, "misses": acc["misses"], "left": gone, "members": members, "who_left": who,
		"score": score(acc["cash"], acc["rep"], acc["wl"], mor), "per": per}


func _bout_week(i: int, week: int) -> bool:
	return (week + 1 + i) % 4 == 0


func _weeks_to_bout(i: int, week: int) -> int:
	for d in 4:
		if _bout_week(i, week + d):
			return d
	return 4


func _chem(c: Dictionary, cid: String, f: Dictionary, chem_on: bool) -> float:
	if not chem_on:
		return 0.0
	return clampf(R.chemistry(c, f.get("personality", {})) + float((f["bond"] as Dictionary).get(cid, 0.0)), -1.0, 1.0)


func _knows(c: Dictionary, f: Dictionary) -> bool:
	return (c["arts"] as Array).has("bjj" if str(f.get("sport", "")) == "bjj" else "boxing")


## {coach id: evenings} for each fighter this week.
func _assign(arm: String, coaches: Dictionary, fs: Array, week: int, chem_on: bool) -> Array:
	var plan: Array = []
	for f in fs:
		plan.append({})
	var ids: Array = coaches.keys()
	if arm.begins_with("ALL_"):
		for i in fs.size():
			plan[i][arm.trim_prefix("ALL_")] = R.WANT
		return plan
	if arm == "LAZY":
		for i in fs.size():
			for cid in ids:
				plan[i][cid] = float(coaches[cid]["hours"]) / float(fs.size())
		return plan
	var opts: Array = []   # [value, fighter, coach]
	for i in fs.size():
		var f: Dictionary = fs[i]
		if bool(f["left"]):
			continue
		for cid in ids:
			var c: Dictionary = coaches[cid]
			var v := 0.0
			if not _knows(c, f):
				v = -10.0
			elif arm == "STAT":
				v = float(c["pads"]) * 0.7 + float(c["conditioning"]) * 0.3
			elif arm == "CHEM":
				v = _chem(c, cid, f, true) + 0.5 * R.fit(c, str(f.get("style", "")))
			elif arm == "NEXT":
				v = 10.0 * (3 - _weeks_to_bout(i, week)) + float(c["tactics"]) + float(c["film"])
			elif arm == "STAR":
				v = float(f.get("pot", 70)) + float(c["pads"])
			elif arm == "SMART":
				v = R.lift(float(c["pads"]) * 3.5 + float(c["conditioning"]) * 1.5) * R.learn_mult(c, str(f.get("style", "")),
					_chem(c, cid, f, chem_on), float(f.get("morale", 60.0)), int(f.get("age", 22)) < 21, true)
			opts.append([v, i, cid])
	opts.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
	var left := {}
	for cid in ids:
		left[cid] = float(coaches[cid]["hours"])
	for o in opts:
		var i := int(o[1])
		var cid := str(o[2])
		var room := R.WANT - _sum(plan[i])
		var give := minf(room, float(left[cid]))
		if give > 0.0 and float(o[0]) > -5.0:
			plan[i][cid] = float(plan[i].get(cid, 0.0)) + give
			left[cid] = float(left[cid]) - give
	return plan


func _sum(d: Dictionary) -> float:
	var s := 0.0
	for k in d:
		s += float(d[k])
	return s


func _train(f: Dictionary, ev: Dictionary, coaches: Dictionary, chem_on: bool) -> void:
	var young := int(f.get("age", 22)) < 21
	var morale := float(f.get("morale", 60.0))
	var style := str(f.get("style", ""))
	var shares := {}
	var chems := {}
	var mults := {}
	var alone := 1.0
	for cid in ev:
		var c: Dictionary = coaches[cid]
		var s := float(ev[cid]) / R.WANT
		chems[cid] = _chem(c, cid, f, chem_on)
		mults[cid] = R.learn_mult(c, style, float(chems[cid]), morale, young, _knows(c, f))
		if float(mults[cid]) > 0.0:
			shares[cid] = s
			alone -= s
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
			var dm := MoveMastery.gain(mm, "pads", R.PAD_MIN * maxf(0.0, alone), 0.0, 2.0, R.trust(morale), cap) - mm
			for cid in shares:
				dm += (MoveMastery.gain(mm, "pads", R.PAD_MIN * float(shares[cid]), R.r100(coaches[cid], "pads"), 2.0, 1.0, cap) - mm) * float(mults[cid])
			f["moves"][mv] = minf(cap, mm + dm * 0.5)
	f["morale"] = R.morale_week(morale, shares, chems, coaches)
	var bond: Dictionary = f["bond"]
	for cid in coaches:
		if shares.has(cid):
			bond[cid] = minf(R.BOND_CAP, float(bond.get(cid, 0.0)) + R.BOND_WEEK)
		else:
			bond[cid] = maxf(0.0, float(bond.get(cid, 0.0)) - R.BOND_FADE)
	f["low_weeks"] = int(f["low_weeks"]) + 1 if float(f["morale"]) < 30.0 else 0
	if int(f["low_weeks"]) >= R.LEAVE_LOW_WEEKS:
		f["left"] = true


func _corner(ev: Dictionary, coaches: Dictionary) -> String:
	var best := ""
	for cid in ev:
		if best == "" or float(ev[cid]) > float(ev[best]) or (float(ev[cid]) == float(ev[best]) and int(coaches[cid]["tactics"]) > int(coaches[best]["tactics"])):
			best = str(cid)
	return best if best != "" else str(coaches.keys()[0])


func _bout(f: Dictionary, i: int, ev: Dictionary, coaches: Dictionary, rep: int, chem_on: bool) -> Dictionary:
	var k := int(f["k"])
	f["k"] = k + 1
	var cid := _corner(ev, coaches)
	var c: Dictionary = coaches[cid]
	var out := {"miss": 0.0, "cash": 0.0, "rep": 0.0, "wl": 0.0, "members": 0.0}
	if _rng([rep, i, k, "weigh"]).randf() < R.miss_chance(c, float((f.get("personality", {}) as Dictionary).get("discipline", 50.0))):
		out["miss"] = 1.0
		out["rep"] = -1.0
		f["morale"] = maxf(0.0, float(f["morale"]) - 6.0)
		return out
	var p := 0.0
	if str(f.get("sport", "")) == "bjj":
		var own := (float(f["stats"]["cardio"]) + float(f["stats"]["composure"]) + float(f["stats"]["strength"])) / 3.0
		p = R.bjj_chance(own + 1.5 * R.tapes(c), 50.0 + float(k) * 0.35)
	else:
		var list: Array = rivals[str(f["div"])]
		var opp: Dictionary = (list[mini(k / 3, list.size() - 1)] as Dictionary).duplicate(true)
		for _t in R.tapes(c):
			OppFile.tape(opp)
		f["arrows"] = []
		f["bout"] = {}
		p = BoutRead.chance(f, opp, {}, R.plan_rating(c, str(f.get("style", ""))))
	var won := _rng([rep, i, k, "bout"]).randf() < p
	out["cash"] = TICKET
	out["rep"] = float(BoutRules.WIN_REPUTATION) if won else -float(BoutRules.LOSS_REPUTATION)
	out["members"] = float(BoutRules.WIN_MEMBERS) if won else -float(BoutRules.LOSS_MEMBERS)
	out["wl"] = 1.0 if won else -1.0
	FighterProfile.apply_morale(f, "win" if won else "loss", "probe")
	return out
