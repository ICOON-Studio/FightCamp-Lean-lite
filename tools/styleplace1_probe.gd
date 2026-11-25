extends "res://tools/planimpact2_probe.gd"
## STYLEPLACE1 (S551, ops/research/TASK_STYLEPLACE1.md; levers and bars written before any run: ops/research/DESIGN_STYLEPLACE1.md).
## PLANIMPACT2's probe (five women, CORNERCMD2's ten cells, the reader corner) and PLANIMPACT1's PW harness (ten TELLPLAY1 types,
## corner off, BoutNight.play_out), with the OPPONENT tables switched by tools/styleplace1_rules.gd (patched in memory at start).
## PLANIMPACT2's plan rule stays at strength 0 in every arm. Measurement only.
## Stages (after --): check | paper | plans | cb | cbx | pw | pwx | film ; cfg=off|L1|L1h|L2|L2h|L12 (one per process: BoutRead's
##  cache) out=<jsonl> cpf=<re-picked plans json> lens=3 cells=<ids|all> boxers=<i,j> n=<dice> k0=<offset> arms=<corner:plan,...>
##  plan: none|coach|C (re-picked for cfg)|C0 (PLANIMPACT1's frozen)|K2|E|C@sj|K2@sj ; pw arms A|B58|C|C0|E|C@sj ; types=<i,j>
const SP := preload("res://tools/styleplace1_rules.gd")
const FilmBout := preload("res://scripts/rules/FilmBout.gd")
const ModeTells := preload("res://scripts/rules/ModeTells.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const CELL_OF := {"Pressure fighter": "presser", "Out-boxer": "mover", "Counter-puncher": "counter", "Slugger": "loader",
	"Volume puncher": "fader", "Boxer-puncher": "slow"}
var cfg := "off"
var cplans := {}


func cb_plan(pk: String, ti: int, style: String) -> Array:
	if pk.contains("@"):
		return super.cb_plan(pk, ti, style)
	SP.use(style)
	if pk == "C":
		return cplans.get("C|%d|%d" % [ti, STYLES.find(style)], [])
	if pk == "C0":
		return super.cb_plan("C", ti, style)
	return super.cb_plan(pk, ti, style)


## What the bout's exchanges were fought on: {pc: {card: n}, rin: [inside per round], rn: [exchanges per round], top: share}.
func places(m: Dictionary) -> Dictionary:
	var pc := {}
	var rin: Array = []
	var rn: Array = []
	for r in m.get("rounds", []):
		var a := 0
		var b := 0
		for x in (r as Dictionary).get("exchanges", []):
			var at := str((x as Dictionary).get("at", ""))
			pc[at] = int(pc.get(at, 0)) + 1
			a += 1 if at == "inside" else 0
			b += 1
		rin.append(a); rn.append(b)
	var tot := 0
	var top := 0
	for c in pc:
		tot += int(pc[c]); top = maxi(top, int(pc[c]))
	return {"pc": pc, "rin": rin, "rn": rn, "top": float(top) / float(maxi(1, tot))}


## PLANIMPACT2's cb_bout, line for line, with the bout's style tables (SP.begin) and the exchange count for the half coin.
func cb_bout(ti: int, cl: Dictionary, L: int, k: int, arm: Array) -> Dictionary:
	var corner := str(arm[0])
	var pk := str(arm[1])
	P.L1 = 0.0; P.L2 = 0.0; P.L3 = 0.0
	P2.STRENGTH = 0.0
	var pol := "reader_nr" if corner == "reader" else "skill58"
	var sc := Career.new()
	sc.day = 70000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": Sim.NO_COACH_RATING if pk == "none" else built_coach}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = false
	sf["camp"] = {"protocol": 2}
	var plan := cb_plan(pk, ti, str(cl["style"]))
	SP.begin(str(cl["style"]), hash([ti, k, L, str(cl["id"])]))
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
			var add := R2.before(st, ctx, d, sf, m, lv)
			var nx := (lv["ex"] as Array).size()
			Bouts.fight_step(sc, sf, m, "shout:" + str(d.get("shout", "")))
			SP.EX += 1
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
	SP.EX = -1
	var out := places(m)
	out["out"] = BoutNight.outcome_of(sf, m)
	return out


## The bout rows: wins string, place counts, bouts where inside climbed every round, bouts with one place over 70%, top share sum.
func row_add(row: Dictionary, b: Dictionary) -> void:
	row["s"] = str(row.get("s", "")) + ("w" if b["out"] == "win" else ("d" if b["out"] == "draw" else "l"))
	var pc: Dictionary = row.get_or_add("pc", {})
	for c in b["pc"]:
		pc[c] = int(pc.get(c, 0)) + int(b["pc"][c])
	var rin: Array = b["rin"]
	var rn: Array = b["rn"]
	var climb := rin.size() >= 2
	for i in range(1, rin.size()):
		climb = climb and float(rin[i]) / maxf(1.0, float(rn[i])) > float(rin[i - 1]) / maxf(1.0, float(rn[i - 1]))
	row["climb"] = int(row.get("climb", 0)) + (1 if climb else 0)
	row["over70"] = int(row.get("over70", 0)) + (1 if float(b["top"]) > 0.7 else 0)
	row["topsum"] = float(row.get("topsum", 0.0)) + float(b["top"])


func stage_cb(tag: String, arms: Array, cells: Array, lens: Array, n: int, k0: int) -> void:
	for L in lens:
		for cl in cells:
			for bi in ints("boxers", "0,1,2,3,4"):
				var ti: int = five[bi]
				var g := {}
				for a in arms:
					g[a] = {}
				for k in n:
					for a in arms:
						row_add(g[a], cb_bout(ti, cl, int(L), k0 + k, str(a).split(":")))
				for a in arms:
					var row: Dictionary = g[a]
					row.merge({"tag": tag, "cfg": cfg, "L": L, "cell": cl["id"], "style": cl["style"], "bi": bi, "boxer": types[ti]["name"],
						"arm": a, "n": n, "k0": k0, "plan": cb_plan(str(a).split(":")[1], ti, str(cl["style"])).map(func(l): return str(l["move"]))}, true)
					say(row)
			print("SP1 %s %s L%d %s, %d bouts, %.1f s" % [tag, cfg, int(L), cl["id"], bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## Cross play (bar 3): each style's plan (C@sj, K2@sj) against the six single-style cells.
func stage_cbx2(n: int, k0: int) -> void:
	var arms: Array = []
	for f in ["C", "K2"]:
		for sj in 6:
			arms.append("reader:%s@%d" % [f, sj])
	var cells: Array = R2.CELLS.filter(func(c): return CELL_OF.values().has(str(c["id"])))
	stage_cb("cbx", arms, cells, [3], n, k0)


## ---- PW (the ten types, corner off, the plain bout) ----
func pw_plan(arm: String, ti: int, si: int) -> Array:
	SP.use(STYLES[si])
	if arm.begins_with("C@"):
		return cplans.get("C|%d|%s" % [ti, arm.trim_prefix("C@")], [])
	match arm:
		"C": return cplans.get("C|%d|%d" % [ti, si], [])
		"C0": return plans.get("C|%d|%d" % [ti, si], [])
		"E": return P.careless(types[ti]["f"], STYLES[si], lim_of(ti))
	return []


func pw_bout2(ti: int, fl: Array, plan: Array, k: int, ck: float) -> Dictionary:
	var sc := Career.new()
	sc.day = 50000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": ck}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = true
	sf["camp"] = CAMP.duplicate(true)
	sf["arrows"] = plan.duplicate(true)
	var opp := pw_opp(ti, fl)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 4, "pro": true, "stale": 0.0}
	sf["bout"]["mode_bias"] = T.bias(sf, opp, false)
	sc.fighters = [sf]
	var md := BoutNight.fight_modal(sf)
	SP.begin(str(fl[0]), hash([ti, k, str(fl)]))
	if SP.L1 in [0.0, 1.0] and SP.L2 in [0.0, 1.0]:
		BoutNight.play_out(sc, sf, md)
	else:   # play_out = fight_step("start") + _box_out (PLANIMPACT1's loop), counting exchanges for the half coin
		BoutNight.fight_step(sc, sf, md, "start")
		while not LiveRound.live(md).is_empty():
			BoutNight._shout(sc, sf, md, ""); SP.EX += 1
		var nr := BoutNight.rounds_of(sf)
		while int(md["round"]) < nr and not BoutNight.stopped(md) and not TowelWire.coach_pull(sc, sf, md) and not CrackWire.bell(sc, sf, md, nr):
			BoutNight._open(sc, sf, md, BoutRules.auto_corner(sf["stats"]))
			while not LiveRound.live(md).is_empty():
				BoutNight._shout(sc, sf, md, ""); SP.EX += 1
	SP.EX = -1
	bouts += 1
	var out := places(md)
	out["out"] = BoutNight.outcome_of(sf, md)
	return out


func stage_pw2(tag: String, arms: Array, n: int, k0: int, nf: int) -> void:
	for ti in ints("types", "0,1,2,3,4,5,6,7,8,9"):
		for si in ints("styles", "0,1,2,3,4,5"):
			for fl in files_of(ti, si, nf):
				for arm in arms:
					var row := {}
					var plan := pw_plan(str(arm), ti, si)
					var ck := Sim.NO_COACH_RATING if str(arm) == "A" else GYM
					for k in n:
						row_add(row, pw_bout2(ti, fl, plan, k0 + k, ck))
					row.merge({"tag": tag, "cfg": cfg, "ti": ti, "type": types[ti]["name"], "si": si, "style": fl[0], "threat": fl[1], "weak": fl[2],
						"arm": arm, "n": n, "k0": k0, "plan": plan.map(func(l): return str(l["move"]))}, true)
					say(row)
			print("SP1 %s %s type %d style %d, %d bouts, %.1f s" % [tag, cfg, ti, si, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## Re-picked best plans for this cfg: PLANIMPACT1's read greedy (greedy_c) for every type x style, written to cpf.
func stage_plans(path: String) -> void:
	var outp := {}
	for ti in ints("types", "0,1,2,3,4,5,6,7,8,9,10,11"):
		for si in 6:
			SP.use(STYLES[si])
			outp["C|%d|%d" % [ti, si]] = greedy_c(ti, [STYLES[si], "", ""], lim_of(ti))
			say({"tag": "cplan", "cfg": cfg, "ti": ti, "type": types[ti]["name"], "si": si, "style": STYLES[si], "plan": outp["C|%d|%d" % [ti, si]]})
		print("SP1 plans %s type %d, %.1f s" % [cfg, ti, (Time.get_ticks_msec() - t0) / 1000.0])
	var fh := FileAccess.open(path, FileAccess.WRITE)
	fh.store_string(JSON.stringify(outp))
	fh.close()


## PAPER (no bouts): for each cfg, the best lines against each style (a card her style fights on x a best answer to the game she
## brings there, the coach's own rule), and the 6 x 6 share of X's lines that are also best against Y; also per boxer (lines she fires).
func stage_paper2() -> void:
	for c in ["off", "L1", "L2", "L12"]:
		SP.cfg(c)
		for ti in [-1] + ints("types", "0,1,2,3,4,5,6,7,8,9,10,11"):
			var sets: Array = []
			for sty in STYLES:
				SP.use(str(sty))
				var s := {}
				for cg in CoachPlan.cards(str(sty)):
					for row in StrikeMap.outs(str(cg[0])):
						var id := str(row["id"])
						if PlanFight.fit(id, str(cg[1])) == "best" and (ti < 0 or P2.fires(types[ti]["f"], id)):
							s["%s|%s" % [cg[0], id]] = true
				sets.append(s)
			var tab: Array = []
			for x in 6:
				var r: Array = []
				for y in 6:
					var both := 0
					for kk in sets[x]:
						both += 1 if (sets[y] as Dictionary).has(kk) else 0
					r.append(snappedf(float(both) / float(maxi(1, (sets[x] as Dictionary).size())), 0.01))
				tab.append(r)
			var cards: Array = []
			for sty in STYLES:
				SP.use(str(sty))
				cards.append(CoachPlan.cards(str(sty)))
			say({"tag": "paper", "cfg": c, "ti": ti, "type": "generic" if ti < 0 else types[ti]["name"], "share": tab,
				"lines": sets.map(func(s): return (s as Dictionary).keys()), "cards": cards if ti < 0 else []})
	SP.cfg(cfg)


## Bar 7: the one-film line. 200 seeded film nights a style (FilmBout.build, the game's film); the film's top game (ties in
## ModeTells.MODES order) -> its place under the cfg; right when it equals the style's main place from her true mix.
func stage_film(nfilm: int) -> void:
	for sty in STYLES:
		var mix: Dictionary = Exchanges.STYLE_MODES[sty]
		var truth := SP.place_of_mix(str(sty), mix)
		var main := OppFile.main_game({"style": sty})
		var right := 0
		var said := {}
		for j in nfilm:
			var fb := FilmBout.build({"id": "sp1film%d" % j, "style": sty, "threat": "", "weak": "", "habits": []},
				{"d": 900 + j * 7, "vs": "x", "win": j % 2 == 0, "how": "points"}, 3)
			var mc := FilmBout.mode_counts(fb)
			var top := ""
			for md in ModeTells.MODES:
				if mc.has(md) and (top == "" or int(mc[md]) > int(mc[top])):
					top = str(md)
			var p := SP.place_of_mix(str(sty), {top: 1.0}) if top != "" else ""
			said[p] = int(said.get(p, 0)) + 1
			right += 1 if p == truth else 0
		var sh := ModeTells.shown(mix, 1)
		var shown_mix := {}
		for md in sh:
			if int(sh[md]) > 0 and mix.has(md):
				shown_mix[md] = float(mix[md])
		say({"tag": "film", "cfg": cfg, "style": sty, "truth": truth, "line": SP.line(str(sty), main, truth), "films": nfilm, "right": right,
			"said": said, "modetells_one_film": SP.place_of_mix(str(sty), shown_mix)})


## Self-test of the patch (no bouts): the tables read live, the hooks answer, the coach's cards follow.
func stage_check() -> void:
	SP.cfg("L12")
	SP.use("Slugger")
	say({"tag": "check", "slugger_cards": CoachPlan.cards("Slugger"), "fit_step_back_loadup": PlanFight.fit("step_back", "loadup"),
		"where_lost_loadup": PlanFight.where_next("3b-3", false, "loadup"), "cards_live": CoachPlan.cards("Pressure fighter")})
	SP.cfg("L1h")
	SP.begin("Slugger", 7)
	var w := {}
	for i in 40:
		SP.EX = i
		var p := PlanFight.where_next("3b-3", false, "loadup")
		w[p] = int(w.get(p, 0)) + 1
	SP.cfg("off")
	SP.use("Slugger")
	say({"tag": "check", "half_where": w, "off_cards": CoachPlan.cards("Slugger"), "off_fit": PlanFight.fit("step_back", "loadup")})


func _initialize() -> void:
	var err := SP.patch()
	if err != "":
		print("STYLEPLACE1 PATCH FAILED: " + err)
		quit(1)
		return
	cfg = _arg("cfg", "off")
	SP.cfg(cfg)
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
	var cpf := _arg("cpf", "")
	if cpf != "" and FileAccess.file_exists(cpf):
		cplans = JSON.parse_string(FileAccess.get_file_as_string(cpf))
	var stage := _arg("stage", "check")
	P.NARROW = true   # as PLANIMPACT2 (its K control arm)
	var cells: Array = []
	for cl in R2.CELLS:
		if _arg("cells", "all") == "all" or (_arg("cells", "all").split(",") as PackedStringArray).has(str(cl["id"])):
			cells.append(cl)
	say({"tag": "run", "probe": "STYLEPLACE1", "stage": stage, "cfg": cfg, "L1": SP.L1, "L2": SP.L2, "cplans": cplans.size(), "plans": plans.size(),
		"five": five.map(func(i): return [i, types[i]["name"]]),
		"population": types.map(func(t): return [t["name"], t["sex"], t["style"], snappedf(float(t["night0"]), 0.01), t["f"]["stats"]])})
	var n := int(_arg("n", "40"))
	var k0 := int(_arg("k0", "0"))
	var arms: Array = Array(_arg("arms", "").split(",", false))
	match stage:
		"check": stage_check()
		"paper": stage_paper2()
		"plans": stage_plans(cpf)
		"cb": stage_cb("cb", arms, cells, ints("lens", "3"), n, k0)
		"cbx": stage_cbx2(n, k0)
		"pw": stage_pw2("pw", arms, n, k0, int(_arg("nf", "3")))
		"film": stage_film(int(_arg("films", "200")))
	print("STYLEPLACE1 done: stage %s cfg %s, %.1f s, %d bouts" % [stage, cfg, (Time.get_ticks_msec() - t0) / 1000.0, bouts])
	quit(0)
