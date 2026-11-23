extends SceneTree
## HOSTPROBE1 (S539, ops/research/TASK_HOSTPROBE1.md): the greybox probe of club show map v4 (DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI.md
## s9), run BEFORE any critic scores it. Measurement only: nothing under scripts/ is touched; v4's new rules are the flagged
## copy tools/hostprobe1_rules.gd. Bars and method: docs/HOSTPROBE1_RESULT.md s2-s3 (committed before the run).
## Stages (stage=): scan | hall | card | weight | boxerc | rank | favours | all. One JSON line a cell to out=<jsonl>.
## POPULATION: the TEST CLUB (TestClub.make on Career.quick_start): Lucy (wlw), Kira (wfw), Josh (mww) against their classes'
## named rivals; each WEAK (as signed) / STRONG (+5 every stat) x AS-IS record / PRO-CHASE (6 wins). Clubs young / mid / grown.
## DICE: one rng per (cell, roll, event), the same for every option of the cell (common random numbers).

const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const V4 := preload("res://tools/hostprobe1_rules.gd")

const CLUBS := {"young": {"members": 40, "rep": 10, "places": 16}, "mid": {"members": 58, "rep": 24, "places": 22},
	"grown": {"members": 120, "rep": 60, "places": 40}}
const ROUTES := ["above_asis", "above_favour", "above_promise", "below", "below_swap", "wait"]
const WAIT_ABOVE_AT := 0.40   ## PROBE bot: after the region show, wait asks the name above when its win chance is at least this
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
	if stage in ["hall", "all"]:
		_hall()
	if stage in ["card", "all"]:
		_card(c, boxers)
	if stage in ["weight", "all"]:
		_weight(c, boxers)
	if stage in ["boxerc", "all"]:
		_boxer_c(c, boxers)
	if stage in ["rank", "all"]:
		_rank(c, boxers)
	if stage in ["favours", "all"]:
		_favours(c, boxers)
	print("HOSTPROBE1 done %s %.1f s" % [stage, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


## ---------- B2 halls, reserves and the ticket read ----------
func _hall() -> void:
	for club in CLUBS:
		for hall in V4.HALL_ORDER:
			if not V4.open(hall, int(CLUBS[club]["places"])):
				_say({"tag": "hall", "club": club, "hall": hall, "open": false})
				continue
			for res in [0, 1, 2]:
				for read in ["keep", "door", "sell", "down", "cancel"]:
					var acc := {"cash": 0.0, "rep": 0.0, "fav": 0.0, "mastery": 0.0, "full": 0.0, "half": 0.0, "short": 0.0}
					var terc := [[0.0, 0.0, 0], [0.0, 0.0, 0], [0.0, 0.0, 0]]
					var cashes: Array = []
					for k in rolls * 4:
						var rng := _rng(["hall", club, k])
						var luck_peek := _rng(["hall", club, k]).randf_range(0.7, 1.15)
						var n: Dictionary = V4.night(CLUBS[club], hall, [5, 5], res, read, rng)
						for key in ["cash", "rep", "fav", "mastery"]:
							acc[key] += float(n[key])
						for key2 in ["full", "half", "short"]:
							acc[key2] += 1.0 if bool(n[key2]) else 0.0
						cashes.append(int(n["cash"]))
						var t := clampi(int((luck_peek - 0.7) / 0.15), 0, 2)
						terc[t][0] += float(n["cash"])
						terc[t][1] += float(n["rep"])
						terc[t][2] += 1
					cashes.sort()
					var m := float(rolls * 4)
					_say({"tag": "hall", "club": club, "hall": hall, "res": res, "read": read, "cash": acc["cash"] / m, "rep": acc["rep"] / m,
						"fav": acc["fav"] / m, "mastery": acc["mastery"] / m, "full": acc["full"] / m, "half": acc["half"] / m, "short": acc["short"] / m,
						"p10": cashes[int(m * 0.1)], "terc": terc.map(func(x): return [x[0] / maxf(1, x[2]), x[1] / maxf(1, x[2]), x[2]])})


## ---------- the card: who to ask, and how (B1b, B1c, B3) ----------
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


## Our place in the division table (Region.before order, our row ranked from RANK_MIN_WINS), 0 unranked.
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


## The names v4's tiles offer: the nearest legal name above (ladder points) and below, and the ladder pair (two legal names above).
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
	var pair: Array = []
	for i in ups.size():
		for j in range(i + 1, ups.size()):
			if pair.is_empty() and _legal(pool[ups[i]], pool[ups[j]]):
				pair = [ups[i], ups[j]]
	return {"above": ups[0] if not ups.is_empty() else "", "below": downs[0] if not downs.is_empty() else "", "pair": pair}


func _rival_bout(pool: Dictionary, a: String, b: String, rng: RandomNumberGenerator) -> void:
	var r := WorldBout.fast(pool[a], pool[b], 3, rng)
	var a_won := str(r["winner"]) == "a" or (str(r["winner"]) == "" and rng.randf() < 0.5)
	var win: Dictionary = pool[a] if a_won else pool[b]
	var lose: Dictionary = pool[b] if a_won else pool[a]
	LadderPoints.settle(win, lose, "win", "stop" if bool(r["stopped"]) else "ud")
	win["w"] = int(win["w"]) + 1
	lose["l"] = int(lose["l"]) + 1


func _pairs(pool: Dictionary, held: Array, rng: RandomNumberGenerator) -> Array:
	var free: Array = pool.keys().filter(func(n): return not held.has(n))
	for i in range(free.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t: Variant = free[i]
		free[i] = free[j]
		free[j] = t
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


## One roll of one route. fav = {club: n} from the cell's level; the result's fav is the sum of the changes (cap 2, floor -2).
func _roll(g: Dictionary, pool0: Dictionary, nm: Dictionary, route: String, lvl: int, cell: String, k: int) -> Dictionary:
	var pool: Dictionary = pool0.duplicate(true)
	var fo: Dictionary = g.duplicate(true)
	var ry := _rng([cell, k, "yes"])
	var rb := _rng([cell, k, "bout"])
	var rr := _rng([cell, k, "region"])
	var rs := _rng([cell, k, "swap"])
	var favs := {}
	var fav := func(club: String, d: int) -> void:
		var now: int = int(favs.get(club, lvl))
		favs[club] = clampi(now + d, -2, V4.FAV_CAP)
	var above := str(nm["above"])
	var below := str(nm["below"])
	var lead := float(pool[above].get("rating", 0.0)) - Attrs.overall(Attrs.of(g)) if above != "" else 0.0
	var u1 := ry.randf()
	var u2 := ry.randf()
	var opp := ""
	var main := false
	var promised := false
	var swapped := false
	if route.begins_with("above_"):
		var how := route.trim_prefix("above_")
		if how == "favour":
			fav.call(str(pool[above]["club"]), -1)
		if u1 < V4.yes10("above", "community", lead, how) / 10.0:
			opp = above
			main = true
			promised = how == "promise"
		elif below != "" and u2 < V4.BELOW_YES / 10.0:
			opp = below
	elif route.begins_with("below"):
		if u1 < V4.BELOW_YES / 10.0:
			opp = below
		if route == "below_swap" and rs.randf() < V4.SWAP_YES * V4.SWAP_YES:
			swapped = true
			fav.call(str(pool[nm["pair"][0]]["club"]), -1)
			fav.call(str(pool[nm["pair"][1]]["club"]), -1)
	var held: Array = [opp] if opp != "" else []
	if swapped:
		held += nm["pair"]
	for p in _pairs(pool, held, rr):
		_rival_bout(pool, str(p[0]), str(p[1]), rr)
	if route == "wait":
		var up := above != "" and BoutRead.chance(fo, pool[above], {}) >= WAIT_ABOVE_AT
		var pick := above if up else below
		if pick != "" and u1 < (V4.yes10("above", "community", lead, "asis") if up else V4.BELOW_YES) / 10.0:
			opp = pick
	if swapped:
		_rival_bout(pool, str(nm["pair"][0]), str(nm["pair"][1]), rs)
	var res := {"rep": 0.0, "members": 0.0, "seats": 0.0, "pro": 0.0, "top3": 0.0, "boxed": 0.0, "won": 0.0, "ladder": 0.0, "fav": 0.0}
	if opp != "":
		var o: Dictionary = pool[opp]
		var won := rb.randf() < BoutRead.chance(fo, o, {})
		var stop := not won and rb.randf() < V4.PROBE_STOP_SHARE
		res["boxed"] = 1.0
		res["won"] = 1.0 if won else 0.0
		res["rep"] = float((BoutRules.WIN_REPUTATION if opp == above else V4.BELOW_WIN_REP) if won else -(BoutRules.STOPPED_LOSS_REPUTATION if stop else BoutRules.LOSS_REPUTATION))
		if main:
			res["rep"] += float(V4.MAIN_REP if won else -V4.MAIN_REP)
		res["members"] = float(BoutRules.WIN_MEMBERS if won else -(BoutRules.STOPPED_LOSS_MEMBERS if stop else BoutRules.LOSS_MEMBERS))
		res["seats"] = float(V4.following(int(fo["w"])) + (V4.POSTERS if main else 0))
		_apply(pool, fo, o, won, "stop" if stop else "ud")
		fav.call(str(o["club"]), 1)   # v4 4.5 earn 3: that club's boxer boxed on our main card
	var r := _rank_of(pool, fo)
	var fc: Dictionary = fo.duplicate(true)
	fc["rank"] = r
	res["top3"] = 1.0 if r > 0 and r <= 3 else 0.0
	res["pro"] = 1.0 if Roster.pro_ready(fc) else 0.0
	if promised:
		fav.call(str(pool[opp]["club"]), V4.BROKEN_PROMISE if res["pro"] > 0.0 else 1)   # v4 4.3: the return bout earns (4.5 earn 2), turning pro breaks it
	res["ladder"] = float(int(fo["rep"]) - int(g["rep"]))
	for club in favs:
		res["fav"] += float(int(favs[club]) - lvl)
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
						if route.begins_with("above") and str(nm["above"]) == "" or route.begins_with("below") and str(nm["below"]) == "":
							continue
						if (route == "above_favour" or route == "below_swap") and lvl < 1 or route == "below_swap" and (nm["pair"] as Array).is_empty():
							continue
						var acc := {}
						for k in rolls:
							var one := _roll(g, pool0, nm, route, lvl, cell, k)
							for key in one:
								acc[key] = float(acc.get(key, 0.0)) + float(one[key]) / rolls
						acc.merge({"tag": "card", "cell": cell, "who": f["first"], "strong": strong, "chase": chase, "lvl": lvl, "route": route,
							"above": nm["above"], "below": nm["below"], "pair": nm["pair"], "rank0": _rank_of(pool0, g)})
						_say(acc)


## ---------- B6: the printed "No. 3 or better" against the table ----------
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
				var pa: Array = []
				for p in pairs:
					var won_a := 0
					for k in 400:
						var r := WorldBout.fast(pool0[p[0]], pool0[p[1]], 3, _rng([cell, "alone", p[0], k]))
						won_a += 1 if str(r["winner"]) == "a" else 0
					pa.append(won_a / 400.0)
				var p_win := BoutRead.chance(g, pool0[opp], {})
				var printed := 0.0
				for mask in int(pow(2, pairs.size())):
					var pr := 1.0
					for i in pairs.size():
						pr *= pa[i] if (mask >> i) & 1 else 1.0 - pa[i]
					for ours_won in [true, false]:
						var pool: Dictionary = pool0.duplicate(true)
						var fo: Dictionary = g.duplicate(true)
						for i2 in pairs.size():
							_apply(pool, pool[pairs[i2][0]], pool[pairs[i2][1]], (mask >> i2) & 1 == 1, "ud")
						_apply(pool, fo, pool[opp], ours_won, "ud")
						var rk := _rank_of(pool, fo)
						printed += pr * (p_win if ours_won else 1.0 - p_win) * (1.0 if rk > 0 and rk <= 3 else 0.0)
				var hits := 0
				var n := rolls * 10
				for k2 in n:
					var pool2: Dictionary = pool0.duplicate(true)
					var fo2: Dictionary = g.duplicate(true)
					var rr := _rng([cell, "real", k2])
					for p2 in pairs:
						_rival_bout(pool2, str(p2[0]), str(p2[1]), rr)
					var won := rr.randf() < p_win
					_apply(pool2, fo2, pool2[opp], won, "stop" if not won and rr.randf() < V4.PROBE_STOP_SHARE else "ud")
					var rk2 := _rank_of(pool2, fo2)
					hits += 1 if rk2 > 0 and rk2 <= 3 else 0
				_say({"tag": "rank", "cell": cell, "pairs": pairs, "p_alone": pa, "p_win": p_win, "printed": printed * 100.0, "measured": hits * 100.0 / n, "n": n})


## ---------- B4 weight on our own show (v4 4.4 as written; code arm = today's WeighGap) ----------
func _weight(c: Career, boxers: Array) -> void:
	var f: Dictionary = boxers[0]
	var pool0 := _pool(c, str(f["div"]))
	var lim := float(f["limit"])
	for strong in [false, true]:
		var g := _state(f, strong, false)
		var p := BoutRead.chance(g, pool0[str(_names(pool0, g)["above"])], {})
		for over in [0.05, 0.25, 0.65]:
			for lvl in [0, 1]:
				for opt in ["keep", "ask", "harder", "stand"]:
					if opt == "ask" and (lvl < 1 or over > V4.CORNER_MAX_KG):
						continue
					var on := 0.0
					var favd := 0.0
					var rep := 0.0
					var n := rolls * 5
					for k in n:
						var rng := _rng(["weight", strong, over, k])
						var day: float = float(over) + rng.randfn(0.0, V4.PROBE_DAY_SD) - (V4.HARDER_KG if opt == "harder" else 0.0)
						var u := rng.randf()
						if opt == "stand":
							favd -= 1.0
						elif opt == "ask":
							favd -= 1.0
							if u < V4.CORNER_YES or day <= BoutRules.WEIGH_TOLERANCE:
								on += 1.0
							else:
								rep -= 2.0
								favd -= 1.0
						elif day <= BoutRules.WEIGH_TOLERANCE or (day - BoutRules.WEIGH_TOLERANCE <= V4.CORNER_MAX_KG and u < V4.CORNER_YES):
							on += 1.0
						else:
							rep -= 2.0
							favd -= 1.0
					_say({"tag": "weight", "strong": strong, "over": over, "lvl": lvl, "opt": opt, "on": on / n, "fav": favd / n, "rep": rep / n,
						"p": p + (V4.HARDER_WIN if opt == "harder" else 0.0), "code_margin": WeighGap.margin(lim + over, lim, lim)})


## ---------- B5 the boxer with a goal (v4 4.3 boxer C; GOALFIX1 as v4 asks: stat goals judged at the deadline) ----------
func _boxer_c(c: Career, boxers: Array) -> void:
	for f in boxers:
		var pool0 := _pool(c, str(f["div"]))
		var g := _state(f, false, false)
		var nm := _names(pool0, g)
		var ref: Dictionary = pool0[str(nm["below"]) if str(nm["below"]) != "" else str(nm["above"])]
		g["morale"] = 58.0
		var p58 := BoutRead.chance(g, ref, {})
		for cond in ["safe_steady", "safe_flat", "tight"]:
			var gm: Dictionary = g.duplicate(true)
			gm["morale"] = 41.0 if cond == "safe_flat" else 58.0
			var p := 0.5 + BoutRead.chance(gm, ref, {}) - p58
			var d := func(kind: String) -> float:
				return float(FighterProfile.apply_morale(gm.duplicate(true), kind, "")["delta"])
			var goal := float(d.call("goal_missed")) if cond == "tight" else 0.0
			_say({"tag": "boxerc", "who": f["first"], "cond": cond, "opt": "novice", "p": p, "morale": d.call("booked") + p * d.call("win") + (1.0 - p) * d.call("loss") + goal,
				"rep": p * V4.BELOW_WIN_REP - (1.0 - p) * 2.4, "members": p * 8.0 - (1.0 - p) * 1.2, "seats": V4.NOVICE_SEATS, "cash": -V4.NOVICE_FEE})
			_say({"tag": "boxerc", "who": f["first"], "cond": cond, "opt": "skills", "p": p, "morale": d.call("booked") + goal, "rep": 0.0, "members": 0.0,
				"seats": V4.NOVICE_SEATS, "cash": -V4.NOVICE_FEE})
			_say({"tag": "boxerc", "who": f["first"], "cond": cond, "opt": "leave", "p": p, "morale": float(d.call("goal_met")) if cond == "tight" else 0.0,
				"rep": 0.0, "members": 0.0, "seats": 0, "cash": 0})


## ---------- B1a favours earned a year under v4 4.5 (test club, 3 boxers) ----------
func _favours(c: Career, boxers: Array) -> void:
	var clubs: Array = []
	for f in boxers:
		clubs.append(_pool(c, str(f["div"])).values().map(func(r): return str(r["club"])))
	for reading in ["strict", "loose"]:
		for bot in ["hoard", "use"]:
			var st := {"earned": 0, "held": 0, "spent": 0}
			for s in 2000:
				var rng := _rng(["fav", reading, bot, s])
				var favs := {}
				var last := {}
				var due: Array = []
				for i in 3:   # v4: 1 with up to 3 clubs already boxed cleanly
					favs[clubs[i][rng.randi_range(0, clubs[i].size() - 1)]] = 1
				var earn := func(cl: String, day: int) -> void:
					if int(favs.get(cl, 0)) < V4.FAV_CAP:
						favs[cl] = int(favs.get(cl, 0)) + 1
						st["earned"] += 1
					last[cl] = day
				for day in range(0, 364, 7):
					for cl in favs:
						if int(favs[cl]) > 0 and day - int(last.get(cl, 0)) >= V4.FAV_LAPSE_DAYS:
							favs[cl] = 0
					if rng.randf() < 0.3 / 52.0:   # FAVOURPROBE1: 0.3 late asks taken a year
						earn.call(clubs[rng.randi_range(0, 2)].pick_random(), day)
					if reading == "loose" and rng.randf() < 11.0 / 52.0:   # FAVOURPROBE1: ~13.8 bouts a year, ~11 away
						earn.call(clubs[rng.randi_range(0, 2)].pick_random(), day)
					for dd in due.duplicate():
						if int(dd[0]) <= day:
							earn.call(str(dd[1]), day)
							due.erase(dd)
					if day % 112 == 105:   # our show night, every 16 weeks
						for i in 3:
							if rng.randf() < 0.85 * (1.0 - V4.PULL_OUT):   # PROBE: on the card 85 in 100, boxed after the pull-out roll
								var cl: String = clubs[i][rng.randi_range(0, clubs[i].size() - 1)]
								if bot == "use" and int(favs.get(cl, 0)) > 0 and rng.randf() < 1.0 / 3.0:
									favs[cl] = int(favs[cl]) - 1
									st["spent"] += 1
								earn.call(cl, day)
								if rng.randf() < 1.0 / 3.0:   # PROBE: one ask in three is a promised return bout
									due.append([day + rng.randi_range(28, 84), cl])
				for cl in favs:
					st["held"] += maxi(0, int(favs[cl]))
			_say({"tag": "favours", "reading": reading, "bot": bot, "earned_yr": st["earned"] / 2000.0, "held_end": st["held"] / 2000.0, "spent_yr": st["spent"] / 2000.0})
