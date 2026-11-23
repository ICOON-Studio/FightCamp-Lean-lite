extends SceneTree
## COACHDEEP7 (S542, ops/research/TASK_COACHDEEP7.md): coaches v7, a staff game - the GREYBOX probe of the map
## ops/research/DESIGN_COACHDEEP7.md (bars s10, written before any run; trial fixes s14), built from tools/coachdeep6.gd.
## POPULATION: the TEST CLUB (TestClub.make): Lucy (women's lightweight), Kira (women's featherweight), Josh (men's
## welterweight), Ana (no-gi); each cell's changes in its "cell" line. Usage: -- [reps=1] [cells=small_am,...]
const TestClub := preload("res://scripts/state/TestClub.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const CardOdds := preload("res://scripts/rules/CardOdds.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const Matchmaking := preload("res://scripts/rules/Matchmaking.gd")
const R := preload("res://tools/coachdeep7_rules.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const LadderRep := preload("res://scripts/rules/LadderRep.gd")
const MIN_WINS := 4   ## Region.RANK_MIN_WINS
const WEEKS := 104
const SIZES := {"small": {"members": 30.0, "add": 0.0}, "big": {"members": 70.0, "add": 30.0}}
const CELLS := [["small_am", "small", ""], ["big_am", "big", ""], ["small_pro", "small", "pro"], ["big_pro", "big", "pro"],
	["small_title", "small", "title"], ["big_title", "big", "title"], ["small_novice", "small", "novice"], ["big_hot", "big", "hot"],
	["small_pro_hot", "small", "pro_hot"], ["big_title_mix", "big", "title_mix"]]
const HIRES := ["NOHIRE", "L", "M", "S", "F", "K"]
const FORCED := [["fall", 26, ["back_coach", "back_boxer", "split"]], ["raise", 52, ["match", "refuse"]], ["push", 26, ["allow", "refuse"]]]
const CHEM_SIZE := 0.15
var base: Array = []
var rivals := {}
var rep0 := 0.0
var cash0 := 0.0
var swing := 0.0

func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="): return str(a).trim_prefix(key + "=")
	return def

func _say(d: Dictionary) -> void:
	print(JSON.stringify(d))

func _rng(parts: Array) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash(JSON.stringify(parts))
	return r

func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	var reps := int(_arg("reps", "1"))
	var c := Career.quick_start()
	c.seed = 5391
	TestClub.make(c)
	rep0 = float(c.reputation)
	cash0 = float(c.cash)
	swing = float(BoutRules.WIN_REPUTATION + BoutRules.LOSS_REPUTATION) / 3.0 + 4.0
	for f in c.fighters:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		g["book"] = [{"id": "own:1", "name": "Her combination", "chain": (R.BOOK.get(str(g.get("style", "")), ["jab", "cross"]) as Array).duplicate()}]
		g["own_combos"] = {}
		g["plan_combo"] = "own:1"
		base.append(g)
	var ana: Dictionary = (c.grapplers[0] as Dictionary).duplicate(true)
	ana["personality"] = FighterProfile.make({"id": "ana", "style": "Counter-puncher", "stats": {}}, hash("ana"))["personality"]
	ana["style"] = "Counter-puncher"
	ana["pot"] = 80
	ana["morale"] = 60.0
	base.append(ana)
	for row in c.rivals:
		var list: Array = rivals.get_or_add(str(row["div"]), [])
		var rr: Dictionary = (row as Dictionary).duplicate(true)
		LadderPoints.rep_of(rr)
		list.append(rr)
	for d in rivals: (rivals[d] as Array).sort_custom(func(a, b): return float(a["rating"]) < float(b["rating"]))
	var pays := {}
	for x in R.CANDIDATES: pays[x] = R.pays_at(R.coach(str(x)), float(R.COACHES[x]["wage"]), 1, float(StaffRoles.VOLUNTEER_MEMBERS + StaffRoles.COACH_MEMBERS * 2))
	_say({"tag": "run", "reps": reps, "rep0": rep0, "cash0": cash0, "pays_at": pays, "fighters": base.map(func(f): return [f["first"],
		str(f.get("style", "")), int(f.get("age", 0)), str(f.get("div", f.get("sport", ""))), f.get("personality", {})])})
	var want: Array = Array(_arg("cells", "").split(",", false))
	for cell in CELLS:
		if want.is_empty() or want.has(cell[0]): _cell(cell, reps)
	print("COACHDEEP7 done %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)

## The cell's roster (map s10): the TEST CLUB changed by kind; returns fresh copies.
func _roster(kind: String) -> Array:
	var fs: Array = []
	for f in base:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		var nm := str(g["first"])
		var bjj := str(g.get("sport", "")) == "bjj"
		if bjj and kind in ["novice", "hot", "pro_hot"]: continue
		if nm == "Josh" and kind in ["pro", "pro_hot", "title", "title_mix"]:
			var title := kind.begins_with("title")
			g["pro"] = true
			g["prank"] = 1 if title else 12
			g["champ"] = title
			g["weekly_salary"] = 0
			_lift(g, 12.0 if title else 6.0)
			if kind == "pro_hot": g["personality"]["temper"] = 82.0
		if kind == "novice" or (kind == "title_mix" and nm in ["Lucy", "Kira"]):
			if not bjj:
				g["age"] = mini(int(g.get("age", 20)), 19)
				_lift(g, -8.0)
				g["w"] = 0
				g["l"] = 0
		if kind == "hot" or (kind == "pro_hot" and nm != "Josh"): g["personality"]["temper"] = {"Lucy": 78.0, "Kira": 75.0, "Josh": 80.0}.get(nm, 75.0)
		fs.append(g)
	return fs

func _lift(g: Dictionary, d: float) -> void:
	var st: Dictionary = g["stats"]
	for k in st:
		if typeof(st[k]) in [TYPE_FLOAT, TYPE_INT]: st[k] = clampf(float(st[k]) + d, 20.0, 95.0)

## The monthly list (three of the five), drawn once per cell; the blind favourite and the one after (map s10).
func _list(cell: String) -> Array:
	var l: Array = R.CANDIDATES.duplicate()
	var r := _rng([cell, "list"])
	for i in range(l.size() - 1, 0, -1):
		var j := r.randi_range(0, i)
		var t = l[i]
		l[i] = l[j]
		l[j] = t
	return l.slice(0, 3)

func _pick(list: Array, members: float, pro: bool, skip: String) -> String:
	var best := ""; var cheap := ""
	for x in list:
		if str(x) == skip: continue
		var cc := R.coach(str(x))
		var n := R.pays_at(cc, float(cc["wage"]), 1, float(StaffRoles.VOLUNTEER_MEMBERS + StaffRoles.COACH_MEMBERS * 2))
		var ok := (n >= 0 and float(n) <= members) or (str(x) == "K" and pro)
		if ok and (best == "" or R.card_value(cc) > R.card_value(R.coach(best))): best = str(x)
		if cheap == "" or float(cc["wage"]) < float(R.coach(cheap)["wage"]): cheap = str(x)
	return best if best != "" else cheap

func _cell(cell: Array, reps: int) -> void:
	var cname := str(cell[0])
	var size := str(cell[1])
	var kind := str(cell[2])
	var fs0 := _roster(kind)
	var pro := kind in ["pro", "pro_hot", "title", "title_mix"]
	var list := _list(cname)
	var fav := _pick(list, float(SIZES[size]["members"]), pro, "")
	var alt := _pick(list, float(SIZES[size]["members"]), pro, fav)
	var rows := {}; var runs := {}
	for h in HIRES: runs[h] = {"hire": h, "line": "careful"}
	runs["TRIAL"] = {"hire": fav, "line": "careful", "trial": true, "alt": alt}
	runs["CARELESS"] = {"hire": fav, "line": "careless"}
	for fm in FORCED:
		for a in fm[2]: runs["%s_%s" % [fm[0], a]] = {"hire": fav, "line": "careful", "force": {"kind": fm[0], "week": fm[1], "ans": a}}
	for k in runs:
		rows[k] = []
		for rep in reps: rows[k].append(_career(fs0, size, runs[k], rep))
	for k in rows:
		var o := {"tag": "arm", "cell": cname, "arm": k}
		for key in ["score", "cash", "rep", "wl", "morale", "next", "lost", "lost_box", "lost_coach", "members", "catch", "classes",
				"wanted", "cash_min", "cash_end", "two_month", "bond_max", "chem_max", "loss_run", "moments", "fees", "warn"]:
			o[key] = snappedf(R.mean(rows[k], key), 0.01)
		o["who"] = R.who(rows[k])
		o["d_nohire"] = R.paired(rows[k], rows["NOHIRE"], "score")
		o["se"] = R.ms(rows[k].map(func(r): return r["score"]))[1]
		o["corner"] = {"differ": R.mean(rows[k].map(func(r): return r["corner"]), "differ"), "tac": R.mean(rows[k].map(func(r): return r["corner"]), "tac"), "bond": R.mean(rows[k].map(func(r): return r["corner"]), "bond")}
		if reps == 1: o["log"] = rows[k][0]["log"]
		_say(o)
	_say({"tag": "cell", "cell": cname, "size": size, "kind": kind, "pro": pro, "list": list, "fav": fav, "alt": alt,
		"roster": fs0.map(func(f): return [f["first"], int(f.get("age", 0)), bool(f.get("pro", false)), int(f.get("prank", 0)), float(f["personality"].get("temper", 0))]),
		"k_v_nohire": R.paired(rows["K"], rows["NOHIRE"], "score"), "trial_v_blind": R.paired(rows["TRIAL"], rows[fav], "score")})

func _chem(c: Dictionary, cid: String, f: Dictionary) -> float:
	return clampf(R.chemistry(c, f.get("personality", {})) + float((f["bond"] as Dictionary).get(cid, 0.0)), -1.0, 1.0)

func _bout_week(f: Dictionary, i: int, week: int) -> bool:
	if bool(f.get("pro", false)): return (week + 1 + i) % (12 if bool(f.get("champ", false)) else 8) == 0
	return (week + 1 + i) % 4 == 0

func _career(fs0: Array, size: String, pol: Dictionary, rep: int) -> Dictionary:
	var fs: Array = []
	for f in fs0:
		var g: Dictionary = (f as Dictionary).duplicate(true)
		var rw := int(f.get("w", 0))
		var rl := int(f.get("l", 0))
		g.merge({"low": 0, "left": false, "bond": {}, "tog": {}, "k": 0, "w": 0, "loy": float(Loyalty.value(f)), "short_last": false,
			"short_at": -99, "p": [], "t": {"cash": 0.0, "rep": 0.0, "wl": 0.0}, "rw": rw, "rl": rl, "rep": LadderPoints.seed_of(rw, rl),
			"warn": 0, "shaky": 0, "push_s": -1, "barred": [], "main": ""}, true)
		g["rank"] = 0 if str(g.get("sport", "")) == "bjj" or bool(g.get("pro", false)) else R.rank(int(g["rep"]), rw, rl, rivals.get(str(g.get("div", "")), []), MIN_WINS)
		fs.append(g)
	var hire := str(pol["hire"])
	var st := {"cash": cash0, "members": float(SIZES[size]["members"]), "known": 2, "forced": false, "fees": 0.0,
		"corner": {"differ": 0.0, "tac": 0.0, "bond": 0.0, "fights": 0.0}, "pro": fs.any(func(f): return bool(f.get("pro", false)))}
	var acc := {"cash": 0.0, "rep": 0.0, "wl": 0.0, "classes": 0.0, "wanted": 0.0, "lost_coach": 0.0, "moments": 0.0, "two": 0.0}
	if bool(pol.get("trial", false)):
		acc["cash"] -= float(R.COACHES[hire]["wage"])   # map s3: one week of his wage
		st["known"] = 0
		for f in fs:
			if R.word(R.chemistry(R.coach(hire), f.get("personality", {}))) == "clash":
				hire = str(pol["alt"])
				st["known"] = 2
				break
	var co := {"YOU": R.coach("YOU"), "REID": R.coach("REID")}
	if hire != "NOHIRE": co[hire] = R.coach(hire)
	if fs.any(func(f): return str(f.get("sport", "")) == "bjj"): co["MAT"] = R.coach("MAT")   # trial fix: a no-gi fighter came with a mat coach
	for cid in co:
		var c: Dictionary = co[cid]
		c.merge({"loy": float(c["loyalty"]) * 5.0, "warn": 0, "gone": false, "ask_at": -99, "course_to": -1, "course_s": -1, "streak": 0,
			"leave_at": -1, "ceil": {"pads": int(c["pads"]) + R.CEIL_ADD, "tactics": int(c["tactics"]) + R.CEIL_ADD, "teaching": int(c["teaching"]) + R.CEIL_ADD}}, true)
	var members := float(st["members"])
	var catch := R.catchment(float(Membership.natural_members(int(rep0))), float(SIZES[size]["add"]))
	var cash_min := cash0
	var notes: Array = []; var run := 0; var run_max := 0; var lost_month := false
	for week in WEEKS:
		var act := {}
		for cid in co:
			var c: Dictionary = co[cid]
			if int(c["leave_at"]) == week:
				c["gone"] = true
				c["counted"] = true
				acc["lost_coach"] += 1.0
				lost_month = true
				notes.append("w%d %s leaves" % [week, cid])
			if int(c["course_to"]) == week:
				var low := "pads"
				for r in ["tactics", "teaching"]:
					if int(c[r]) < int(c[low]): low = r
				c[low] = mini(int(c["ceil"][low]), int(c[low]) + R.COURSE_GAIN)
			if not bool(c["gone"]):
				c["ev_now"] = int(c["evenings"]) - (R.COURSE_EVENINGS if week < int(c["course_to"]) else 0)
				act[cid] = c
		for cid in act:
			if int(act[cid].get("sulk_to", -1)) == week:
				act[cid]["sulk_to"] = -1
				for r in ["pads", "tactics", "teaching", "motivation"]: act[cid][r] = int(act[cid][r]) + R.SULK
		if str(pol["line"]) == "careful" and week >= int(st["known"]):   # map s4: "change" is free; the careful line unpairs a clash
			for f in fs:
				for cid in act:
					if cid != "YOU" and R.word(_chem(act[cid], str(cid), f)) == "clash" and act.keys().any(func(x): return x != cid and R.knows(act[x], f)) and not (f["barred"] as Array).has(cid): f["barred"].append(cid)
		var asks: Array = []
		for i in fs.size():
			var f: Dictionary = fs[i]
			var a := 0 if bool(f["left"]) or not act.values().any(func(c): return R.knows(c, f)) else int(ClubDeal.ASK["ordinary"])
			if a > 0 and _bout_week(f, i, week): a += int(ClubDeal.ASK["fight_week_extra"])
			asks.append(a)
		var demand := R.class_demand(members)
		var pl := _assign(act, fs, asks, week >= int(st["known"]), demand)
		acc["classes"] += float(pl["classes"])
		acc["wanted"] += float(demand)
		var cash := float(ClubDeal.class_cash(1)) * R.class_share(int(pl["classes"]), members) + members * float(GymBills.FEE_MONTH) / GymBills.WEEKS_A_MONTH
		for cid in act: cash -= float(act[cid]["wage"])
		for i in fs.size():
			var f: Dictionary = fs[i]
			if bool(f["left"]): continue
			cash -= float(f.get("weekly_salary", 0))
			var ev: Dictionary = pl["places"][i]
			_train(f, ev, act)
			if asks[i] > 0: R.loyal_week(f, R.sum(ev) < asks[i], week)
			if _bout_week(f, i, week) and asks[i] > 0:
				var res := _bout(f, i, act, rep, st)
				cash += float(res["cash"])
				acc["rep"] += float(res["rep"])
				acc["wl"] += float(res["wl"])
				members = minf(members + float(res["members"]), maxf(members, catch))
				for key in ["cash", "rep", "wl"]: f["t"][key] += float(res[key])
			f["low"] = int(f["low"]) + 1 if float(f["loy"]) < float(Loyalty.LEAVES_UNDER) else 0
			if int(f["low"]) >= 2 or (int(f["warn"]) >= 2 and float(f["loy"]) < R.LEAVE_AT):
				R.leave(f, fs, acc, true, 1.0)
				lost_month = true
				notes.append("w%d %s leaves" % [week, f["first"]])
		st["members"] = members
		st["cash"] = cash0 + acc["cash"] + cash
		if week % 4 == 3:
			var said := _moment(fs, act, week, pol, rep, st)
			if said != "":
				acc["moments"] += 1.0
				notes.append("w%d %s" % [week, said])
				for cid in act:
					if bool(act[cid]["gone"]) and not bool(act[cid].get("counted", false)):
						act[cid]["counted"] = true
						acc["lost_coach"] += 1.0
						lost_month = true
				for f in fs:
					if not bool(f["left"]) and int(f["warn"]) >= 2 and float(f["loy"]) < R.LEAVE_AT:
						R.leave(f, fs, acc, true, 1.0)
						lost_month = true
			cash -= float(st.get("spend", 0.0))
			st["spend"] = 0.0
			run = run + 1 if lost_month else 0
			run_max = maxi(run_max, run)
			lost_month = false
		acc["cash"] += cash
		cash_min = minf(cash_min, cash0 + acc["cash"])
		var nat := float(Membership.natural_members(clampi(int(rep0 + acc["rep"]), 0, 100)))
		var pull := R.CLASS_TARGET * R.class_share(int(pl["classes"]), members) * float(pl["teach"]) / 10.0
		var target := R.members_target(nat, float(SIZES[size]["add"]), pull, catch)
		var room := StaffRoles.VOLUNTEER_MEMBERS + StaffRoles.COACH_MEMBERS * act.size()
		members = minf(float(room), float(Membership.step_members(int(members), int(minf(target, float(room))))))
	var mor := 0.0; var nxt := 0.0; var lost_box := 0.0; var bond_max := 0.0; var chem_max := -1.0
	for f in fs:
		mor += (0.0 if bool(f["left"]) else float(f.get("morale", 60.0))) / fs.size()
		lost_box += float(bool(f["left"]))
		if not bool(f["left"]): nxt += R.pro_year(f, co.has("K") and not bool(co["K"]["gone"])) if bool(f.get("pro", false)) else float(R.year_of(f, true, 1.0)["lines"])
		for cid in f["bond"]:
			bond_max = maxf(bond_max, float(f["bond"][cid]))
			if co.has(cid): chem_max = maxf(chem_max, _chem(co[cid], str(cid), f))
	var who := ""
	for f in fs:
		if bool(f["left"]): who += str(f["first"]) + " "
	for cid in co:
		if bool(co[cid]["gone"]): who += str(cid) + " "
	return {"score": R.score(acc["cash"], acc["rep"], acc["wl"], mor) + nxt, "cash": acc["cash"], "rep": acc["rep"], "wl": acc["wl"],
		"morale": mor, "next": nxt, "lost": lost_box + acc["lost_coach"], "lost_box": lost_box, "lost_coach": acc["lost_coach"], "who_left": who,
		"members": members, "catch": catch, "classes": acc["classes"] / WEEKS, "wanted": acc["wanted"] / WEEKS, "cash_min": cash_min,
		"cash_end": cash0 + acc["cash"], "two_month": acc["two"], "bond_max": bond_max, "chem_max": chem_max, "loss_run": run_max,
		"moments": acc["moments"], "fees": st["fees"], "warn": fs.reduce(func(s, f): return s + int(f["warn"]), 0) + co.values().reduce(func(s, c): return s + int(c["warn"]), 0),
		"corner": st["corner"], "log": notes}

func _value(c: Dictionary, cid: String, f: Dictionary, known: bool) -> float:
	if not R.knows(c, f) or (f["barred"] as Array).has(cid): return -10.0
	var pc := R.pace(str(f.get("style", "")))
	var lv := 0.0
	for k in pc: lv += float(pc[k]) * R.lift(R.area_r(c, str(k)))
	if str(f.get("sport", "")) != "bjj": lv *= R.spec_mult(c, f["book"][0]["chain"])
	return lv * R.learn_mult(c, str(f.get("style", "")), _chem(c, cid, f) if known else 0.0, float(f.get("morale", 60.0)), int(f.get("age", 22)) < 21, CHEM_SIZE)

## The week pairs itself (map s4, v6 SMART) and classes fill the free evenings up to what the members want.
func _assign(co: Dictionary, fs: Array, asks: Array, known: bool, demand: int) -> Dictionary:
	var places: Array = []
	for f in fs: places.append({})
	var cap := {}
	for cid in co: cap[cid] = int(co[cid]["ev_now"]) * R.PLACES_AN_EVENING
	var opts: Array = []
	for i in fs.size():
		if asks[i] > 0:
			for cid in co: opts.append([_value(co[cid], str(cid), fs[i], known), i, cid])
	opts.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
	for o in opts:
		var i := int(o[1])
		var cid: String = o[2]
		var give := mini(int(asks[i]) - R.sum(places[i]), int(cap[cid]))
		if give > 0 and float(o[0]) > -5.0:
			places[i][cid] = int(places[i].get(cid, 0)) + give
			cap[cid] = int(cap[cid]) - give
	var ids: Array = co.keys()
	ids.sort_custom(func(a, b): return int(co[a]["teaching"]) > int(co[b]["teaching"]))
	var classes := 0; var teach := 0.0
	for cid in ids:
		var spare := int(cap[cid]) / R.PLACES_AN_EVENING
		while spare > 0 and classes < demand:
			spare -= 1
			classes += 1
			teach = maxf(teach, float(co[cid]["teaching"]))
	return {"places": places, "classes": classes, "teach": teach}

func _train(f: Dictionary, ev: Dictionary, co: Dictionary) -> void:
	var morale := float(f.get("morale", 60.0))
	var style := str(f.get("style", ""))
	var total := float(R.sum(ev))
	var ord := minf(total, float(R.ORDINARY))
	var shares := {}; var chems := {}; var mults := {}; var alone := 1.0; var main := ""
	for cid in ev:
		var c: Dictionary = co[cid]
		chems[cid] = _chem(c, str(cid), f)
		mults[cid] = R.learn_mult(c, style, float(chems[cid]), morale, int(f.get("age", 22)) < 21, CHEM_SIZE)
		shares[cid] = float(ev[cid]) / total * ord / float(R.ORDINARY)
		alone -= float(shares[cid])
		f["tog"][cid] = int(f["tog"].get(cid, 0)) + 1
		if main == "" or int(ev[cid]) > int(ev[main]): main = str(cid)
	f["main"] = main
	var stats: Dictionary = f["stats"]
	var pc := R.pace(style)
	var bjj := str(f.get("sport", "")) == "bjj"
	for k in (pc.keys() if not bjj else ["cardio", "composure", "strength"]):
		var room := clampf((float(f.get("pot", 80)) - float(stats[k])) / 25.0, 0.10, 1.25)
		var m := maxf(0.0, alone) * R.trust(morale)
		for cid in shares:
			var ar := R.r100(co[cid], "conditioning" if k == "cardio" else "pads") if bjj else R.area_r(co[cid], str(k))
			m += float(shares[cid]) * R.lift(ar) * float(mults[cid])
		stats[k] = minf(99.0, float(stats[k]) + float(pc.get(k, 0.33)) * room * m / R.lift(58.0))
	if not bjj: R.drill(f, ev, co, mults, ord / maxf(1.0, total))
	f["morale"] = R.morale_week(morale, shares, chems, co, CHEM_SIZE)
	var loy := 0.0
	for cid in shares: loy += R.CHEM_LOYAL * CHEM_SIZE * float(shares[cid]) * float(chems[cid])
	f["loy"] = clampf(float(f["loy"]) + loy, 0.0, 100.0)
	for cid in co:   # the bond: weeks together only (one-way, loop 3)
		f["bond"][cid] = minf(R.BOND_CAP, float(f["bond"].get(cid, 0.0)) + R.BOND_WEEK) if shares.has(cid) else maxf(0.0, float(f["bond"].get(cid, 0.0)) - R.BOND_FADE)

## One bout: the corner pick (map s7), the known name's fee (s2), a pro's purse (Matchmaking), v6's amateur bout otherwise.
func _bout(f: Dictionary, i: int, co: Dictionary, rep: int, st: Dictionary) -> Dictionary:
	var k := int(f["k"])
	f["k"] = k + 1
	var bjj := str(f.get("sport", "")) == "bjj"
	var pro := bool(f.get("pro", false))
	var opp := {}
	if not bjj:
		var list: Array = rivals[str(f["div"])]
		opp = list[clampi(list.size() - 1 - int(f["prank"]) / 4, 0, list.size() - 1) if pro else mini(k / 3, list.size() - 1)]
	var ps := {}; var pick := ""; var best_v := -1e9
	for cid in co:
		var c: Dictionary = co[cid]
		if not R.knows(c, f): continue
		var p := 0.0
		if bjj:
			var own := (float(f["stats"]["cardio"]) + float(f["stats"]["composure"]) + float(f["stats"]["strength"])) / 3.0
			p = R.bjj_chance(own + 1.5 * R.tapes(c, true), 50.0 + float(k) * 0.35)
		else:
			var ce := R.corner_edge(c, str(f.get("style", "")), _chem(c, str(cid), f))
			p = _chance(f, opp, [0.0 if R.word(_chem(c, str(cid), f)) == "clash" else ce, ce], R.PUSH_SHAKY if int(f["shaky"]) > 0 else 0.0)
		ps[cid] = p
		var v := p * swing + (R.name_fee(R.purse(int(f["prank"]))) / 1000.0 if pro and cid == "K" else 0.0)
		if v > best_v:
			best_v = v
			pick = str(cid)
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
			f["champ"] = false
			f["prank"] = 3
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

## The game's read (BoutRead.round_edges, its 3-round integration) + the corner's calls before rounds 2 and 3 (map s7, trial fix:
## BoutRead.chance ignores its coach argument) + a style push's shaky rounds. A clash ignores the first call.
func _chance(f: Dictionary, opp: Dictionary, calls: Array, shaky: float) -> float:
	f["arrows"] = []
	f["bout"] = {}
	var e: Array = (BoutRead.round_edges(f, opp, {}, 0.0) as Array).duplicate()
	for r in e.size(): e[r] = float(e[r]) + shaky + (float(calls[mini(r - 1, calls.size() - 1)]) if r > 0 else 0.0)
	if e.size() != 3: return CardOdds.win(e, RingDuel.FORM_SD)
	var out := 0.0
	for j in WorldBout.GH_X.size():
		var d := float(WorldBout.GH_X[j]) * RingDuel.FORM_SD * sqrt(2.0)
		var a := ComboOdds.round_odds(float(e[0]) + d)
		var b := ComboOdds.round_odds(float(e[1]) + d)
		var c := ComboOdds.round_odds(float(e[2]) + d)
		out += float(WorldBout.GH_W[j]) * (a * b + a * c + b * c - 2.0 * a * b * c)
	return clampf(out, 0.01, 0.99)

## At most one coach moment a month (map s6): the forced one in its month (bar 3), else the first one due.
func _moment(fs: Array, co: Dictionary, week: int, pol: Dictionary, rep: int, st: Dictionary) -> String:
	var force: Dictionary = pol.get("force", {})
	var m := {}
	if not force.is_empty() and not bool(st["forced"]) and week >= int(force["week"]):
		st["forced"] = true
		m = R.forced(str(force["kind"]), fs, co, str(pol["hire"]))
		if not m.is_empty(): m["ans"] = str(force["ans"])
	if m.is_empty(): m = R.due(fs, co, week, _rng([rep, week, "moment"]), float(st["cash"]))
	if m.is_empty(): return ""
	var ans := str(m["ans"]) if m.has("ans") else R.answer(str(pol["line"]), m, fs, co, float(st["members"]), bool(st["pro"]))
	st["spend"] = R.apply(m, ans, fs, co, week)
	return "%s %s/%s:%s" % [m["kind"], m.get("cid", ""), fs[int(m["i"])]["first"] if m.has("i") else "", ans]
