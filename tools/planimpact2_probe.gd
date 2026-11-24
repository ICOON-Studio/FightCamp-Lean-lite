extends "res://tools/planimpact1_probe.gd"
## PLANIMPACT2 (S550, ops/research/TASK_PLANIMPACT2.md; the rule written before any run: ops/research/DESIGN_PLANIMPACT2.md,
## switched in tools/planimpact2_rules.gd). PLANIMPACT1's probe (its PW/CB harness, five women, CORNERCMD2's ten cells) with
## ONE switch: the rule's strength. PLANIMPACT1's own levers stay off in every arm. Measurement only.
## Stages (after --): paper | cb | cbx ; out=<jsonl> lens=3,6 cells=<ids|all> boxers=<i,j> n=<dice> k0=<offset>
##  arms=<corner:plan:strength,...>  corner reader|file; plan none|coach|C|K|K2|D2|E|C@sj|K2@sj (sj = the style the plan is
##  written for, fought against the cell's style). paper: no bouts - what each plan prepares against each style.
const P2 := preload("res://tools/planimpact2_rules.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")


func cb_plan(pk: String, ti: int, style: String) -> Array:
	var f: Dictionary = types[ti]["f"]
	if pk.contains("@"):
		var sj := int(pk.get_slice("@", 1))
		return cb_plan(pk.get_slice("@", 0), ti, STYLES[sj])
	var key := "P2|%s|%d|%s" % [pk, ti, style]
	if cache.has(key):
		return cache[key]
	var plan: Array = []
	match pk:
		"K2": plan = P2.corner_plan(f, style, lim_of(ti))
		"D2": plan = P2.corner_plan(f, style, lim_of(ti)).slice(0, 1)
		"coach": plan = []
		_: plan = super.cb_plan(pk, ti, style)
	cache[key] = plan
	return plan


## The plan as fought (the coach writes his at the first bell when the board is empty and the plan arm is "coach").
func fought_of(pk: String, ti: int, style: String) -> Array:
	if pk == "coach":
		var f: Dictionary = types[ti]["f"]
		return CoachPlan.write(style, built_coach, f.get("moves", {}), f.get("combos", {}), f.get("steps", {}))
	return cb_plan(pk, ti, style)


## One CB bout (PLANIMPACT1's cb_bout with its levers off and P2's rule at arm[2]).
func cb_bout(ti: int, cl: Dictionary, L: int, k: int, arm: Array) -> Dictionary:
	var corner := str(arm[0])
	var pk := str(arm[1])
	P.L1 = 0.0; P.L2 = 0.0; P.L3 = 0.0
	P2.STRENGTH = float(arm[2]) if arm.size() > 2 else 0.0
	var pol := "reader_nr" if corner == "reader" else "skill58"
	var sc := Career.new()
	sc.day = 70000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": Sim.NO_COACH_RATING if pk == "none" else built_coach}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = false
	sf["camp"] = {"protocol": 2}
	var plan := cb_plan(pk, ti, str(cl["style"]))
	sf["arrows"] = plan.duplicate(true)
	var opp := cb_opp(ti, cl)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": L, "pro": false, "stale": 0.0}
	sc.fighters = [sf]
	var m := BoutNight.fight_modal(sf)
	bouts += 1
	var st := R2.new_state(pol, L, built_coach, sf)
	var cs: Dictionary = C.coach_new(pol, opp, L, str(cl["id"]), str(types[ti]["name"]), k) if C.is_coach(pol) else {}
	st["cs"] = cs
	var fought: Array = plan
	if plan.is_empty() and pk == "coach":
		fought = CoachPlan.write(str(cl["style"]), built_coach, sf.get("moves", {}), sf.get("combos", {}), sf.get("steps", {}))
	var raised: Array = P2.sharpen(st, fought, str(cl["style"]), sf) if corner == "reader" else []
	var cmds := 0
	var up := 0
	m["step"] = "round"
	m["round"] = 0
	m["rounds"] = []
	BoutNight._peak(sc, sf)
	ProReadWire.open(sf)
	m["lab_from"] = sf.duplicate(true)
	BoutNight._open(sc, sf, m, C.open_call(cs, sf))
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			var ctx := R2.seen(sf, m, lv)
			var d: Dictionary = R2.decide(st, ctx, sf)
			if str(d["cmd"]) != "":
				cmds += 1
				up += 1 if raised.has(str(d["cmd"])) else 0
			var add := R2.before(st, ctx, d, sf, m, lv)
			var nx := (lv["ex"] as Array).size()
			Bouts.fight_step(sc, sf, m, "shout:" + str(d.get("shout", "")))
			R2.after(st, ctx, d, sf, m, add, nx)
		var rn := int(m["round"])
		R2.bell(st, sf, m)
		if rn >= L or Bouts.stopped(m) != "" or TowelWire.coach_pull(sc, sf, m):
			break
		if int(cl.get("switch", 0)) > 0 and rn + 1 >= int(cl["switch"]):
			opp["stance"] = "southpaw" if str(opp["stance"]) == "orthodox" else "orthodox"
		var call := C.corner(cs, sf, m) if C.is_coach(pol) else R2.corner_call(st, sf, m)
		Bouts.fight_step(sc, sf, m, "corner:" + call)
		R2.after_open(st, m, call)
		if LiveRound.live(m).is_empty() and Bouts.stopped(m) != "":
			break
	P2.STRENGTH = 0.0
	var s := cc_stats(m)
	return {"out": BoutNight.outcome_of(sf, m), "pl": s[0], "ct": s[1], "mv": s[2], "cmds": cmds, "up": up, "raised": raised, "fought": fought}


## PAPER: no bouts. The six styles' cards; for each command, the lines that prepare it against each style; for every boxer
## (the five women and PLANIMPACT1's ten types) and style, what each plan prepares and how many of its lines prepare anything.
func stage_paper() -> void:
	for sty in STYLES:
		var per := {}
		for cg in CoachPlan.cards(str(sty)):
			for c in R2.FIGHT:
				if (R2.CMD[c]["best"] as Array).has(str(cg[1])):
					var lines: Array = []
					for row in StrikeMap.outs(str(cg[0])):
						var id := str(row.get("id", ""))
						if not (str(row.get("kind", "")) in ["", "forced"]) and PlanFight.fit(id, str(cg[1])) == "best":
							lines.append(id)
					per[str(c)] = per.get(str(c), []) + ["%s/%s: %s" % [cg[0], cg[1], ", ".join(lines)]]
		say({"tag": "cards", "style": sty, "cards": CoachPlan.cards(str(sty)), "prepares": per})
	var tis: Array = ints("types", "0,1,2,3,4,5,6,7,8,9,10,11")
	for ti in tis:   # her own grade of each command (the reader's state at the first bell): a Good one cannot be raised
		var st := R2.new_state("reader_nr", 3, built_coach, types[ti]["f"])
		var gw := {}
		for c in R2.FIGHT:
			gw[str(c)] = "%s %.2f" % [str(st["gr"][c]["word"]), float(st["gr"][c]["mult"])]
		say({"tag": "grades", "ti": ti, "type": types[ti]["name"], "gr": gw})
	for ti in tis:
		for si in 6:
			var sty := str(STYLES[si])
			var row := {"tag": "paper", "ti": ti, "type": types[ti]["name"], "si": si, "style": sty}
			for pk in ["coach", "C", "K2", "D2", "E", "K"]:
				var pl := fought_of(pk, ti, sty)
				var n_lines := 0
				for l in pl:
					n_lines += 1 if not P2.line_prepares(l, sty, types[ti]["f"]).is_empty() else 0
				row[pk] = {"plan": pl.map(func(l): return str(l["move"])), "lines": pl.size(), "lines_prep": n_lines,
					"prep": P2.prepared_set(pl, sty, types[ti]["f"])}
			say(row)


## Cross play (bar 4): each style's plan (C@sj or K2@sj) against each style's cell, rule on.
func stage_cbx(fam: Array, cells: Array, L: int, n: int, k0: int, strength: float) -> void:
	var arms: Array = []
	for f in fam:
		for sj in 6:
			arms.append("reader:%s@%d:%s" % [f, sj, str(strength)])
	stage_cb("cbx", arms, cells, [L], n, k0)


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	out_path = _arg("out", "")
	var built := T.build_types(4)
	types = built[0]
	built_coach = float(built[1])
	C.PICK = [49, 1249]
	var taken: Array = types.map(func(t): return str(t["name"]))
	for t in C.build_extra(taken, 80):
		types.append(t)
	for nm in FIVE:
		for i in types.size():
			var tn := str(types[i]["name"])
			if tn == nm or (nm == "CARA" and i == types.size() - 2) or (nm == "JADE" and i == types.size() - 1):
				five.append(i)
				break
	var pf := _arg("pfile", "E:/FightCamp/tmp/planimpact1/plans.json")
	if FileAccess.file_exists(pf):
		plans = JSON.parse_string(FileAccess.get_file_as_string(pf))
	var stage := _arg("stage", "paper")
	P.NARROW = true   # PLANIMPACT1's K (old corner plan, control arm) was built with the narrowed mapping
	var cells: Array = []
	for cl in R2.CELLS:
		if _arg("cells", "all") == "all" or (_arg("cells", "all").split(",") as PackedStringArray).has(str(cl["id"])):
			cells.append(cl)
	say({"tag": "run", "probe": "PLANIMPACT2", "stage": stage, "built_coach": built_coach, "plans": plans.size(), "five": five.map(func(i): return [i, types[i]["name"]]),
		"population": types.map(func(t): return [t["name"], t["sex"], t["style"], snappedf(float(t["night0"]), 0.01), t["f"]["stats"]])})
	var n := int(_arg("n", "40"))
	var k0 := int(_arg("k0", "0"))
	var lens: Array = ints("lens", "3,6")
	var arms: Array = Array(_arg("arms", "").split(",", false))
	match stage:
		"paper": stage_paper()
		"cb": stage_cb("cb", arms, cells, lens, n, k0)
		"cbx": stage_cbx(Array(_arg("fam", "C,K2").split(",", false)), cells, int(lens[0]), n, k0, float(_arg("strength", "1")))
	print("PLANIMPACT2 done: stage %s, %.1f s, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, bouts])
	quit(0)
