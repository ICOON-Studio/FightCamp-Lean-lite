extends SceneTree
## PLANREAD2 (S547, ops/research/TASK_PLANREAD2.md): why the card over-reads a written plan. Measurement only.
## Population: TURNPROBE18's ten types at week 4 (tools/tellplay1_rules.gd build_types, preloaded) x six styles x plans of
## 0,1,2,3,4,6 lines (greedy on the OLD read, PLANWORTH1's arm C chooser: blank file of the style, any-time lines), fought
## against nf real files of the style (PLANWORTH1's files_of), n paired bouts a file (bout k = day 50000 + 7k in every arm).
## Per cell: the read (win %), the bout (wins %), the read's plan term per round (round edges with the plan less without),
## and the ring's own per-exchange records (LiveRound rec): plan_edge, read_edge, plan_swing, planned, the exchange win rate.
## Stages: plans (write the plans file from the read as it is) | run (fight the plans file's plans).
## Args (after --): stage= plans=<json> out=<jsonl> n= nf= types=<i,j> styles=<i,j> counts=<0,1,..> cc=on|off (off = the ring
## without ComboCounter, its own control switch: the arm that cannot share the read's blind spot)
const R := preload("res://tools/tellplay1_rules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const PlanReadFit := preload("res://scripts/rules/PlanReadFit.gd")
const ComboCounter := preload("res://scripts/rules/ComboCounter.gd")

const STYLES := ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]
const WEAPONS := ["Never stops throwing", "Stops people", "Body hooks", "Heavy right hand", "Right hand over the jab", "Long jab"]
const WEAKS := ["Fades after round 2", "Leaves the chin open", "Walks in straight", "Slow to start", "Backs straight up"]
const CAMP := {"protocol": 2}
const WEEK := 4
const GYM := 58.0
const LAZY := 10
const COUNTS := [0, 1, 2, 3, 4, 6]
var types: Array = []
var out_path := ""
var t0 := 0
var bouts := 0
var cache := {}


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func _ints(key: String, def: Array) -> Array:
	var s := _arg(key, "")
	return def if s == "" else Array(s.split(",")).map(func(x): return int(x))


func say(d: Dictionary) -> void:
	var s := JSON.stringify(d)
	if out_path != "":
		var fh := FileAccess.open(out_path, FileAccess.READ_WRITE if FileAccess.file_exists(out_path) else FileAccess.WRITE)
		if fh != null:
			fh.seek_end()
			fh.store_line(s)
			fh.close()
	print(s)


func man(style: String, threat: String, weak: String, rating: float) -> Dictionary:
	return {"name": "M %s|%s|%s" % [style, threat, weak], "style": style, "threat": threat, "weak": weak, "rating": snappedf(rating, 0.01)}


func opp_of(ti: int, m: Dictionary) -> Dictionary:
	var f: Dictionary = types[ti]["f"]
	var opp := DebutOpp.make(f, 0.0, 0, "probe18")
	opp.merge({"name": str(m["name"]), "first": str(m["name"]).split(" ")[0], "style": str(m["style"]), "threat": str(m["threat"]),
		"weak": str(m["weak"]), "rating": float(m["rating"])}, true)
	return opp


func fx_of(ti: int, arr: Array) -> Dictionary:
	var f: Dictionary = (types[ti]["f"] as Dictionary).duplicate()
	f["pro"] = true
	f["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
	f["arrows"] = arr.duplicate(true)
	return f


func edges(ti: int, m: Dictionary, arr: Array, k: float) -> Array:
	return BoutRead.round_edges(fx_of(ti, arr), opp_of(ti, m), CAMP, k)


## The read's round edges with the plan terms in `drop` switched off (PlanReadFit.off), the caches cleared both ways.
func edges_off(ti: int, m: Dictionary, arr: Array, k: float, drop: Array) -> Array:
	BoutRead.clear_cache()
	for d in drop:
		PlanReadFit.off[d] = true
	var out := edges(ti, m, arr, k)
	PlanReadFit.off = {}
	BoutRead.clear_cache()
	return out


func mean_gap(a: Array, b: Array) -> float:
	var s := 0.0
	for r in a.size():
		s += float(a[r]) - float(b[r])
	return s / float(maxi(1, a.size()))


func read(ti: int, m: Dictionary, arr: Array, k: float) -> float:
	var key := "%d|%s|%s|%.2f" % [ti, m["name"], JSON.stringify(arr), k]
	if not cache.has(key):
		cache[key] = float(BoutRead.CardOdds.result(edges(ti, m, arr, k), BoutRead.RingDuel.FORM_SD)["win"])
	return float(cache[key])


## PLANWORTH1's bout(): one real bout, paired dice k. Returns [outcome, md].
func bout(ti: int, m: Dictionary, arr: Array, k: int, ck: float) -> Array:
	var sc := Career.new()
	sc.day = 50000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": ck}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = true
	sf["camp"] = CAMP.duplicate(true)
	sf["arrows"] = arr.duplicate(true)
	var opp := opp_of(ti, m)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 4, "pro": true, "stale": 0.0}
	sf["bout"]["mode_bias"] = R.bias(sf, opp, false)
	sc.fighters = [sf]
	var md := BoutNight.fight_modal(sf)
	BoutNight.play_out(sc, sf, md)
	bouts += 1
	return [BoutNight.outcome_of(sf, md), md]


func candidates(ti: int) -> Array:
	var f: Dictionary = types[ti]["f"]
	var out: Array = []
	for place in PlanLines.PLACES:
		for o in PlanLines.options(place, "", f.get("moves", {}), f.get("combos", {})):
			if str(o["why"]) == "":
				out.append({"move": str(o["id"])})
	return out


func slot(l: Dictionary) -> String:
	return "%s|%s" % [str(StrikeMap.move(str(l["move"])).get("from", "")), str(l.get("when", ""))]


## PLANWORTH1's greedy (sign 1), arm C: the read against a blank file of the style.
func greedy(ti: int, m: Dictionary, cands: Array, lim: int) -> Array:
	var plan: Array = []
	var cur := read(ti, m, [], Sim.NO_COACH_RATING)
	var gains := {}
	var used := {}
	for i in cands.size():
		gains[i] = read(ti, m, [cands[i]], GYM) - cur
	var first := true
	while plan.size() < lim:
		var order: Array = gains.keys().filter(func(i): return not used.has(slot(cands[i])))
		if order.is_empty():
			break
		order.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
		if not first:
			for i in order.slice(0, LAZY):
				gains[i] = read(ti, m, plan + [cands[i]], GYM) - cur
			order = order.slice(0, LAZY)
			order.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
		first = false
		var bi: int = order[0]
		if float(gains[bi]) <= 0.0001:
			break
		plan.append(cands[bi])
		used[slot(cands[bi])] = true
		cur = read(ti, m, plan, GYM)
		gains.erase(bi)
	return plan


func files_of(ti: int, si: int, nf: int) -> Array:
	var out: Array = []
	for j in nf:
		var idx := (j * 7 + si * 3 + ti) % (WEAPONS.size() * WEAKS.size())
		out.append([STYLES[si], WEAPONS[idx / WEAKS.size()], WEAKS[idx % WEAKS.size()]])
	return out


func stage_plans(path: String) -> void:
	var plans := {}
	for ti in types.size():
		var lim := StyleName.limit(types[ti]["f"], PlanBoard.arrow_limit(GYM))
		var cands := candidates(ti)
		for si in STYLES.size():
			var c: Array = greedy(ti, man(STYLES[si], "", "", float(types[ti]["night0"])), cands, lim)
			plans["%d|%d" % [ti, si]] = c
			say({"tag": "plan", "ti": ti, "type": types[ti]["name"], "style": STYLES[si], "limit": lim, "C": c})
	var fh := FileAccess.open(path, FileAccess.WRITE)
	fh.store_string(JSON.stringify(plans))
	fh.close()


func stage_run(path: String, n: int, nf: int, want_t: Array, want_s: Array, counts: Array) -> void:
	var plans: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	for ti in types.size():
		if not want_t.is_empty() and not want_t.has(ti):
			continue
		var r0 := float(types[ti]["night0"])
		for si in STYLES.size():
			if not want_s.is_empty() and not want_s.has(si):
				continue
			var full: Array = plans["%d|%d" % [ti, si]]
			for kc in counts:
				if kc > 0 and kc > full.size():
					continue
				var arr: Array = full.slice(0, kc)
				var ck := GYM if kc > 0 else Sim.NO_COACH_RATING
				var row := {"tag": "cell", "ti": ti, "type": types[ti]["name"], "style": STYLES[si], "lines": kc, "plan": arr, "n": n * nf,
					"read": 0.0, "term": 0.0, "wins": 0, "draws": 0, "ex": 0, "ex_won": 0, "planned": 0, "plan_edge": 0.0, "read_edge": 0.0,
					"swing": 0, "p_ex_read": 0.0, "t_tired": 0.0, "t_chain": 0.0, "t_tiring": 0.0, "ring": {}}
				var ring := {"she_tired": [0, 0.0, 0], "tiring": [0, 0.0, 0], "game": [0, 0.0, 0]}   # [exchanges, plan+read edge, planned]
				for fl in files_of(ti, si, nf):
					var m := man(fl[0], fl[1], fl[2], r0)
					row["read"] = float(row["read"]) + 100.0 * read(ti, m, arr, ck) / float(nf)
					var e1 := edges(ti, m, arr, ck)
					var e0 := edges(ti, m, [], Sim.NO_COACH_RATING)
					for r in e1.size():
						row["term"] = float(row["term"]) + (float(e1[r]) - float(e0[r])) / float(e1.size() * nf)
						row["p_ex_read"] = float(row["p_ex_read"]) + ComboOdds.win_odds(float(e1[r])) / float(e1.size() * nf)
					var full_e := edges_off(ti, m, arr, ck, [])
					row["t_tired"] = float(row["t_tired"]) + mean_gap(full_e, edges_off(ti, m, arr, ck, ["tired"])) / float(nf)
					row["t_chain"] = float(row["t_chain"]) + mean_gap(full_e, edges_off(ti, m, arr, ck, ["chain"])) / float(nf)
					row["t_tiring"] = float(row["t_tiring"]) + mean_gap(full_e, edges_off(ti, m, arr, ck, ["tiring"])) / float(nf)
					for k in n:
						var b: Array = bout(ti, m, arr, k, ck)
						row["wins"] = int(row["wins"]) + int(b[0] == "win")
						row["draws"] = int(row["draws"]) + int(b[0] == "draw")
						for rd in (b[1] as Dictionary).get("rounds", []):
							for x in (rd as Dictionary).get("exchanges", []):
								row["ex"] = int(row["ex"]) + 1
								row["ex_won"] = int(row["ex_won"]) + int(bool(x.get("won", false)))
								row["planned"] = int(row["planned"]) + int(bool(x.get("planned", false)))
								row["plan_edge"] = float(row["plan_edge"]) + float(x.get("plan_edge", 0.0))
								row["read_edge"] = float(row["read_edge"]) + float(x.get("read_edge", 0.0))
								row["swing"] = int(row["swing"]) + int(x.get("plan_swing", 0))
								var sk := str(x.get("sit", ""))
								var bk: Array = ring["she_tired" if sk == "she_tired" else ("tiring" if sk == "tiring" else "game")]
								bk[0] = int(bk[0]) + 1
								bk[1] = float(bk[1]) + float(x.get("plan_edge", 0.0)) + float(x.get("read_edge", 0.0))
								bk[2] = int(bk[2]) + int(bool(x.get("planned", false)))
				var ex := maxf(1.0, float(row["ex"]))
				for key in ring:
					var bk: Array = ring[key]
					row["ring"][key] = [snappedf(float(bk[0]) / ex, 0.001), snappedf(float(bk[1]) / ex, 0.001), snappedf(float(bk[2]) / ex, 0.001)]   # share of exchanges, edge per exchange of the bout, planned share
				for key in ["t_tired", "t_chain", "t_tiring"]:
					row[key] = snappedf(float(row[key]), 0.001)
				for key in ["plan_edge", "read_edge"]:
					row[key] = snappedf(float(row[key]) / ex, 0.001)
				row["ex_rate"] = snappedf(float(row["ex_won"]) / ex, 0.0001)
				row["planned_rate"] = snappedf(float(row["planned"]) / ex, 0.0001)
				row["swing_rate"] = snappedf(float(row["swing"]) / ex, 0.0001)
				row["bout"] = snappedf(100.0 * float(row["wins"]) / float(n * nf), 0.01)
				row["read"] = snappedf(float(row["read"]), 0.01)
				row["term"] = snappedf(float(row["term"]), 0.001)
				row["p_ex_read"] = snappedf(float(row["p_ex_read"]), 0.0001)
				say(row)
			print("PR2 type %d style %d done, %d bouts, %.1f s" % [ti, si, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## One cell's exchanges, one line each: [margin, plan_edge, read_edge, won, sit, swing, planned, at, round].
func stage_ex(path: String, n: int, ti: int, si: int, kc: int) -> void:
	var plans: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	var arr: Array = (plans["%d|%d" % [ti, si]] as Array).slice(0, kc)
	var fl: Array = files_of(ti, si, 1)[0]
	var m := man(fl[0], fl[1], fl[2], float(types[ti]["night0"]))
	for k in n:
		var b: Array = bout(ti, m, arr, k, GYM if kc > 0 else Sim.NO_COACH_RATING)
		var rn := 0
		for rd in (b[1] as Dictionary).get("rounds", []):
			rn += 1
			for x in (rd as Dictionary).get("exchanges", []):
				say({"tag": "ex", "k": k, "r": rn, "m": snappedf(float(x.get("margin", 0.0)), 0.01), "pe": snappedf(float(x.get("plan_edge", 0.0)), 0.01),
					"re": snappedf(float(x.get("read_edge", 0.0)), 0.01), "won": bool(x.get("won", false)), "sit": str(x.get("sit", "")),
					"sw": int(x.get("plan_swing", 0)), "pl": bool(x.get("planned", false)), "at": str(x.get("at", "")), "de": snappedf(float(x.get("duel_edge", 0.0)), 0.01)})


## The fighters of types `tis` as JSON (tests/plan_read_fit_test.gd freezes them), with their style plans from the plans file.
func stage_dump(path: String, tis: Array) -> void:
	var plans: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(path))
	var out: Array = []
	for ti in tis:
		var ps := {}
		for si in STYLES.size():
			ps[STYLES[si]] = plans["%d|%d" % [ti, si]]
		out.append({"name": types[ti]["name"], "night0": types[ti]["night0"], "f": types[ti]["f"], "plans": ps})
	say({"tag": "dump", "types": out})


## PLANWORTH1's table again (S547 step 5): its own plans (E:/FightCamp/tmp/planworth1 full_a/full_b, chosen on the read
## before S547, so both columns fight the same plans), the read as it is now, n fresh paired bouts a file and arm.
func stage_pw(srcs: Array, n: int, want_t: Array) -> void:
	var sp := {}
	var rows: Array = []
	for src in srcs:
		for line in FileAccess.get_file_as_string(str(src)).split("\n"):
			if line.strip_edges() == "":
				continue
			var d: Variant = JSON.parse_string(line)
			if typeof(d) != TYPE_DICTIONARY:
				continue
			if str(d.get("tag", "")) == "style_plans":
				sp["%d|%s" % [int(d["ti"]), str(d["style"])]] = d
			elif str(d.get("tag", "")) == "file":
				rows.append(d)
	for d in rows:
		var ti := int(d["ti"])
		if not want_t.is_empty() and not want_t.has(ti):
			continue
		var s: Dictionary = sp["%d|%s" % [ti, str(d["style"])]]
		var m := man(str(d["style"]), str(d["threat"]), str(d["weak"]), float(types[ti]["night0"]))
		var c2: Array = d["C2"]
		var arms := {"A": [[], Sim.NO_COACH_RATING], "B58": [[], 58.0], "B74": [[], 74.0], "C": [s["C"], GYM], "C2": [c2, GYM],
			"D": [c2.slice(0, 1), GYM], "E": [s["E"], GYM], "F": [d["F"], GYM]}
		var row := {"tag": "pw", "ti": ti, "type": types[ti]["name"], "style": d["style"], "threat": d["threat"], "weak": d["weak"], "n": n,
			"old_read": d["read"], "read": {}, "bout": {}}
		for a in arms:
			var arr: Array = arms[a][0]
			var ck: float = arms[a][1]
			if arr.is_empty() and not a.begins_with("A") and not a.begins_with("B"):
				ck = Sim.NO_COACH_RATING
			row["read"][a] = snappedf(100.0 * read(ti, m, arr, ck), 0.01)
			var w := 0
			for k in n:
				w += int(bout(ti, m, arr, k, ck)[0] == "win")
			row["bout"][a] = snappedf(100.0 * float(w) / float(n), 0.01)
		say(row)
	print("PR2 pw done, %d bouts, %.1f s" % [bouts, (Time.get_ticks_msec() - t0) / 1000.0])


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	out_path = _arg("out", "")
	types = R.build_types(WEEK)[0]
	var stage := _arg("stage", "run")
	ComboCounter.on = _arg("cc", "on") != "off"   # the control arm: the ring without S540's combo counter (its own switch)
	var plans := _arg("plans", "E:/FightCamp/tmp/planread2/plans.json")
	match stage:
		"plans": stage_plans(plans)
		"pw": stage_pw(_arg("src", "E:/FightCamp/tmp/planworth1/full_a.jsonl,E:/FightCamp/tmp/planworth1/full_b.jsonl").split(","), int(_arg("n", "100")), _ints("types", []))
		"dump": stage_dump(plans, _ints("types", [1, 5, 9]))
		"ex": stage_ex(plans, int(_arg("n", "100")), int(_arg("ti", "0")), int(_arg("si", "0")), int(_arg("lines", "4")))
		"run": stage_run(plans, int(_arg("n", "100")), int(_arg("nf", "5")), _ints("types", []), _ints("styles", []), _ints("counts", COUNTS))
	print("PLANREAD2 done: stage %s, %.1f s, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, bouts])
	quit(0)
