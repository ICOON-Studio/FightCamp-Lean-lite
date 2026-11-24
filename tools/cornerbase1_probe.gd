extends SceneTree
## CORNERBASE1 (S547, ops/research/TASK_CORNERBASE1.md; design ops/research/DESIGN_CORNERBASE1.md): CORNERCMD2's probe with
## three coaches in the other chair (tools/cornerbase1_rules.gd: arms file, skill35, skill58, skill80; plan = BLIND) and five
## boxers (boxers=5: CORNERCMD2's three + a POOR and a GOOD one, build_extra). coaches=0 = every coach arm plays BLIND (step 0).
## Extra stage: pop (weeks=0,4,12,24,40) prints every woman's command grades. CORNERCMD2's header follows.
## CORNERCMD2 (S545, ops/research/TASK_CORNERCMD2.md; design ops/research/DESIGN_CORNERCMD1.md "Round 2"): round 1's probe with
## the four changes as flags (ch=1,2,3,4 all on by default; ch=0 = round 1 as it ran; tools/cornercmd2_rules.gd), a THIRD boxer
## of ours with a different trained set (boxers=2 keeps round 1's two). Round 1's header follows.
## CORNERCMD1 (S544, ops/research/TASK_CORNERCMD1.md; design ops/research/DESIGN_CORNERCMD1.md). A GREYBOX of the owner's corner
## commands on the REAL bout: every punch, round and verdict is the game's (Bouts.fight_step "start" / "shout:" / "corner:" +
## LiveRound, the loop BoutNight._box_out plays, as tools/pushprobe2.gd drives it). The new commands are flagged local rules in
## tools/cornercmd1_rules.gd: an edge added to the exchange's base before it is fought and taken back after, a wind cost on the
## round's cost, head on the bout's damage. Nothing under scripts/ or tests/ changes.
## Population: TELLPLAY1's types (tools/tellplay1_rules.gd build_types, week 4), our two WOMEN, opponents of their own sex and
## class (DebutOpp.make), styled per cell. Paired dice: bout k is career day 70000 + 7k under every arm.
## Stages (after --): stage=check | trial | walk | full ; n=<bouts a cell> lens=3,6 cells=<ids|all> out=<jsonl> ch=<1,2,3,4|0>
## arms=<all|list> boxers=<3|2> k0=<dice offset>
const T := preload("res://tools/tellplay1_rules.gd")
const R := preload("res://tools/cornercmd2_rules.gd")
const C := preload("res://tools/cornerbase1_rules.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

var types: Array = []
var ours: Array = []   # indices into types: our two women
var coach := 58.0
var out_path := ""
var t0 := 0
var bouts := 0
var stage_now := ""
var k0 := 0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func say(d: Dictionary) -> void:
	var s := JSON.stringify(d)
	if out_path != "":
		var fh := FileAccess.open(out_path, FileAccess.READ_WRITE if FileAccess.file_exists(out_path) else FileAccess.WRITE)
		if fh != null:
			fh.seek_end()
			fh.store_line(s)
			fh.close()
	print(s)


func opp_of(ti: int, cl: Dictionary) -> Dictionary:
	var f: Dictionary = types[ti]["f"]
	var opp := DebutOpp.make(f, 0.0, 0, "cc1")
	var nm := "Opp %s" % str(cl["id"])
	opp.merge({"name": nm, "first": "Opp", "style": str(cl["style"]), "threat": str(cl["threat"]), "weak": str(cl["weak"]),
		"rating": snappedf(float(types[ti]["night0"]) + float(cl.get("off", 0.0)), 0.01), "stance": str(cl.get("stance", "orthodox"))}, true)
	return opp


## One real bout. pol = the arm (R.decide reads it); st = the probe's own sums for the bout (commands on, wind/head at bells).
func bout(ti: int, cl: Dictionary, L: int, k: int, pol: String, ck: float = -1.0) -> Dictionary:
	var sc := Career.new()
	sc.day = 70000 + (k + k0) * 7
	sc.seed = 387
	sc.coach = {"rating": coach}   # the plan's writer stays the same coach in every arm; ck is the corner's tactics only
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = false
	sf["camp"] = {"protocol": 2}
	sf["arrows"] = []
	var opp := opp_of(ti, cl)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": L, "pro": false, "stale": 0.0}
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	bouts += 1
	var st := R.new_state(pol, L, ck if ck >= 0.0 else coach, sf)
	var cs: Dictionary = C.coach_new(pol, opp, L, str(cl["id"]), str(types[ti]["name"]), k + k0) if C.is_coach(pol) else {}
	st["cs"] = cs
	if pol == "playout":
		BoutNight.play_out(sc, sf, m)
		return R.finish_state(st, sf, m, BoutNight.outcome_of(sf, m))
	if R.OPEN_CALL:   # change 2: fight_step("start")'s own steps, with the plan's call (BoutNight.gd l.70-77)
		m["step"] = "round"
		m["round"] = 0
		m["rounds"] = []
		BoutNight._peak(sc, sf)
		ProReadWire.open(sf)
		m["lab_from"] = sf.duplicate(true)
		BoutNight._open(sc, sf, m, C.open_call(cs, sf))
	else:
		Bouts.fight_step(sc, sf, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			var ctx := R.seen(sf, m, lv)
			var d := R.decide(st, ctx, sf)
			var add := R.before(st, ctx, d, sf, m, lv)
			var nx := (lv["ex"] as Array).size()
			Bouts.fight_step(sc, sf, m, "shout:" + str(d.get("shout", "")))
			R.after(st, ctx, d, sf, m, add, nx)
		var rn := int(m["round"])
		R.bell(st, sf, m)
		if rn >= L or Bouts.stopped(m) != "" or TowelWire.coach_pull(sc, sf, m):
			break
		if int(cl.get("switch", 0)) > 0:   # the switch-hitter changes stance every round from the cell's round
			if rn + 1 >= int(cl["switch"]):
				opp["stance"] = "southpaw" if str(opp["stance"]) == "orthodox" else "orthodox"
		var cc := C.corner(cs, sf, m) if C.is_coach(pol) else R.corner_call(st, sf, m)
		Bouts.fight_step(sc, sf, m, "corner:" + cc)
		R.after_open(st, m, cc)
		if LiveRound.live(m).is_empty() and Bouts.stopped(m) != "":
			break
	var calls := {}
	for r in m["rounds"]:
		calls[str(r.get("corner", ""))] = int(calls.get(str(r.get("corner", "")), 0)) + 1
	st["callhist"] = calls
	return R.finish_state(st, sf, m, BoutNight.outcome_of(sf, m))


## The one-rep trial's print: one bout exchange by exchange (moment seen, moment fought, command, ring, edge, won).
func walk(ti: int, cl: Dictionary, L: int, arm: String) -> void:
	R.LOG = true
	var r := bout(ti, cl, L, 0, arm)
	R.LOG = false
	for row in r["st"].get("log", []):
		print("CC2 WALK round %d ex %d | seen %s | fought %s | cmd %s | ring %s | finish %s | edge %.1f (plan's call %.1f) | wind %.1f head %.1f | %s" % row)
	say({"tag": "walk", "boxer": types[ti]["name"], "cell": cl["id"], "L": L, "arm": arm, "out": r["out"], "picks": r["st"]["picks"],
		"wind": r["st"]["wind"], "head": r["st"]["head"], "fits": r["st"]["fits"]})


func run_cells(stage: String, pols: Array, cells: Array, lens: Array, n: int) -> void:
	for L in lens:
		for cl in cells:
			for oi in ours.size():
				if _arg("only", "") != "" and not (_arg("only", "").split(",") as PackedStringArray).has(str(oi)):
					continue
				var ti := int(ours[oi])
				var rows := {}
				for pol in pols:
					rows[pol] = agg_new()
				for k in n:
					for pol in pols:
						var p := str(pol)
						var ck := -1.0
						if p.begins_with("coach"):
							ck = float(p.trim_prefix("coach"))
						agg_add(rows[pol], bout(ti, cl, int(L), k, p, ck), k)
				for pol in pols:
					say({"tag": stage, "L": L, "cell": cl["id"], "boxer": types[ti]["name"], "pol": pol, "agg": agg_out(rows[pol])})
			print("CB1 %s L%d %s done, %d bouts, %.1f s" % [stage, int(L), cl["id"], bouts, (Time.get_ticks_msec() - t0) / 1000.0])


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	out_path = _arg("out", "")
	var built := T.build_types(4)
	types = built[0]
	coach = float(_arg("coach", str(built[1])))
	for i in types.size():   # our two women: the first, then the first woman of another style
		if str(types[i]["sex"]) != "f":
			continue
		if ours.is_empty() or (ours.size() == 1 and str(types[i]["style"]) != str(types[ours[0]]["style"]) and str(_arg("second", "")) in ["", str(types[i]["name"])]):
			ours.append(i)
	if int(_arg("boxers", "5")) >= 3:   # the third: another style, another loading-up answer (change 4b), then the grade words that differ most
		var best_i := -1
		var best_d := -1
		var g0 := [R.trained_cmd(types[ours[0]]["f"]), R.trained_cmd(types[ours[1]]["f"])]
		for i in types.size():
			if str(types[i]["sex"]) != "f" or ours.has(i):
				continue
			var gi := R.trained_cmd(types[i]["f"])
			var dd := 0
			if str(R.new_state("plan", 3, coach, types[i]["f"])["own"]) != str(R.new_state("plan", 3, coach, types[ours[0]]["f"])["own"]):
				dd += 20
			if not [str(types[ours[0]]["style"]), str(types[ours[1]]["style"])].has(str(types[i]["style"])):
				dd += 10
			for k in gi:
				dd += (1 if gi[k] != g0[0][k] else 0) + (1 if gi[k] != g0[1][k] else 0)
			if dd > best_d:
				best_d = dd; best_i = i
		if best_i >= 0:
			ours.append(best_i)
	if int(_arg("boxers", "5")) >= 5:   # the POOR and the GOOD boxer (tools/cornerbase1_rules.gd build_extra)
		C.DRAWS = int(_arg("draws", "300"))
		C.PICK = Array(_arg("pick", "49,1249").split(",")).map(func(x): return int(x))
		var taken: Array = ours.map(func(i): return str(types[i]["name"]))
		for t in C.build_extra(taken, int(_arg("wk_good", "80"))):
			types.append(t)
			ours.append(types.size() - 1)
	C.ON = _arg("coaches", "1") != "0"
	C.WIND_LINE = float(_arg("wind_line", str(C.WIND_LINE)))
	print("CB1 extra boxers from draws %s" % str(C.PICKED))
	var stage := _arg("stage", "trial")
	stage_now = stage
	k0 = int(_arg("k0", "0"))
	var ch := _arg("ch", "1,2,3,4").split(",")
	R.HONEST = ch.has("1"); R.OPEN_CALL = ch.has("2"); R.RING2 = ch.has("3"); R.GRADES2 = ch.has("4")
	R.COACH_A = float(_arg("coach_a", "30"))   # round 1's tuned coach rule, (tactics - 30) / 50
	R.COACH_B = float(_arg("coach_b", "50"))
	R.ARMS = ["plan", "file", "skill35", "skill58", "skill80", "reader_nr"] + R.FIGHT.map(func(c): return "c:" + str(c)) if _arg("arms", "all") == "all" else Array(_arg("arms", "").split(","))
	var n := int(_arg("n", "50"))
	var lens: Array = Array(_arg("lens", "3,6").split(",")).map(func(x): return int(x))
	var want := _arg("cells", "all")
	var cells: Array = []
	for cl in R.CELLS:
		if want == "all" or (want.split(",") as PackedStringArray).has(str(cl["id"])):
			cells.append(cl)
	var pop: Array = []
	for ti in ours:
		var f: Dictionary = types[ti]["f"]
		pop.append([types[ti]["name"], types[ti]["sex"], types[ti]["style"], f.get("stance", ""), snappedf(float(types[ti]["night0"]), 0.01), f["stats"],
			(f.get("personality", {}) as Dictionary).get("coachability", 0.0), (f.get("moves", {}) as Dictionary).keys(), (f.get("steps", {}) as Dictionary),
			R.trained(f), R.new_state("plan", 3, coach, f)["gr"], R.new_state("plan", 3, coach, f)["rg"].keys().map(func(k): return [k, R.new_state("plan", 3, coach, f)["rg"][k]]), R.heard_of(f),
			R.new_state("plan", 3, coach, f)["own"]])
	say({"tag": "run", "stage": stage, "ch": ch, "coach": coach, "n": n, "lens": lens, "population": pop,
		"cells": cells.map(func(c): return [c["id"], c["style"], c["threat"], c["weak"], c.get("off", 0.0), c.get("switch", 0)])})
	match stage:
		"check": run_cells("check", ["playout", "plan"], cells, lens, n)
		"pop": say({"tag": "pop", "rows": C.pop_table(Array(_arg("weeks", "0,4,12,24,40").split(",")))})
		"walk": walk(int(ours[int(_arg("who", "0"))]), cells[0], int(lens[0]), _arg("arm", "reader"))
		_: run_cells(stage, R.ARMS, cells, lens, n)
	print("CORNERBASE1 done: stage %s, %.1f s, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, bouts])
	quit(0)


func agg_new() -> Dictionary:
	return {"n": 0, "w": 0, "d": 0, "stopw": 0, "stopl": 0, "outs": "", "rw": 0, "ce": 0.0, "ce_plan": 0.0, "nx": 0, "fits": {}, "sits": {},
		"wind": [], "head": [], "shouts": 0, "picks": {}, "cmd_on": 0, "right": 0, "wrong": 0, "changes": 0, "rope_saves": 0, "cut_pins": 0, "wind_min": 999.0, "wind_low60": 0, "head_max": 0.0,
		"c_corners": 0, "c_rests": 0, "c_hands": 0, "c_right": 0, "c_bouts": 0}


func agg_add(g: Dictionary, r: Dictionary, _k: int) -> void:
	var st: Dictionary = r["st"]
	var cs: Dictionary = st.get("cs", {})
	if not cs.is_empty():
		for kk in ["corners", "rests", "hands"]:
			g["c_" + kk] = int(g["c_" + kk]) + int(cs[kk])
		g["c_right"] = int(g["c_right"]) + (1 if bool(cs["right"]) else 0)
		g["c_bouts"] = int(g["c_bouts"]) + 1
	if not g.has("calls"):
		g["calls"] = {}
	for kk in (st.get("callhist", {}) as Dictionary):
		g["calls"][kk] = int(g["calls"].get(kk, 0)) + int(st["callhist"][kk])
	g["n"] = int(g["n"]) + 1
	g["w"] = int(g["w"]) + (1 if r["out"] == "win" else 0)
	g["d"] = int(g["d"]) + (1 if r["out"] == "draw" else 0)
	g["stopw"] = int(g["stopw"]) + (1 if r["stop"] != "" and r["out"] == "win" else 0)
	g["stopl"] = int(g["stopl"]) + (1 if r["stop"] != "" and r["out"] == "loss" else 0)
	g["outs"] = str(g["outs"]) + ("2" if r["out"] == "win" else ("1" if r["out"] == "draw" else "0"))
	g["rw"] = int(g["rw"]) + int(r["rw"])
	for k in ["ce", "ce_plan"]:
		g[k] = float(g[k]) + float(st[k])
	for k in ["nx", "shouts", "cmd_on", "right", "wrong", "changes", "rope_saves", "cut_pins"]:
		g[k] = int(g[k]) + int(st[k])
	for k in ["fits", "sits", "picks"]:
		for kk in (st[k] as Dictionary):
			g[k][kk] = int(g[k].get(kk, 0)) + int(st[k][kk])
	for k in ["wind", "head"]:
		var vals: Array = st[k]
		var sums: Array = g[k]
		for j in vals.size():
			if sums.size() <= j:
				sums.append([0.0, 0])
			sums[j] = [float(sums[j][0]) + float(vals[j]), int(sums[j][1]) + 1]
	var w: Array = st["wind"]
	for v in w:
		g["wind_min"] = minf(float(g["wind_min"]), float(v))
	var low := false
	for v in w:
		low = low or float(v) < 60.0
	g["wind_low60"] = int(g["wind_low60"]) + (1 if low else 0)
	var h: Array = st["head"]
	if not h.is_empty():
		g["head_max"] = maxf(float(g["head_max"]), float(h[-1]))


func agg_out(g: Dictionary) -> Dictionary:
	var o := g.duplicate(true)
	for k in ["wind", "head"]:
		o[k] = (g[k] as Array).map(func(p): return snappedf(float(p[0]) / maxf(1.0, float(p[1])), 0.1))
	o["ce_ex"] = snappedf(float(g["ce"]) / maxf(1.0, float(g["nx"])), 0.01)
	o["ce_plan_ex"] = snappedf(float(g["ce_plan"]) / maxf(1.0, float(g["nx"])), 0.01)
	o.erase("ce")
	o.erase("ce_plan")
	return o
