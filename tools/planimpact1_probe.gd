extends SceneTree
## PLANIMPACT1 (S548, ops/research/TASK_PLANIMPACT1.md; rules written before any run: ops/research/DESIGN_PLANIMPACT1.md,
## switched in tools/planimpact1_rules.gd). Measurement only: nothing under scripts/ or tests/ changes.
## Two harnesses, both the game's real bout:
##  PW = PLANWORTH1's (tools/planworth1_probe.gd bout(): ten TELLPLAY1 types at week 4 + CORNERBASE1's Cara and Jade, the debut
##       4 rounds, paired dice day 50000 + 7k, the gym's coach 58, BoutNight.play_out; with twins in a plan the same loop as
##       play_out / _box_out with the L1 filter written onto bout["arrows"] before every exchange).
##  CB = CORNERBASE1's (tools/cornerbase1_probe.gd bout(): five women, CORNERCMD2's ten cells, 3 / 6 rounds, day 70000 + 7k; the
##       corner = reader_nr or skill58 (FILE+SKILL 58)), with a written plan, L1's filter, L2's grades and L3's silence.
## Stages (after --): ctl | cpick | vpick | pw | cb | cbx ; out=<jsonl> types=<i,j> styles=<i,j> n=<dice> k0=<dice offset>
##  arms=<list> pfile=<plans json> nf=<files a style> nfx=<files a cross cell> lens=3,6 cells=<ids|all> boxers=<i,j>
const T := preload("res://tools/tellplay1_rules.gd")
const R2 := preload("res://tools/cornercmd2_rules.gd")
const C := preload("res://tools/cornerbase1_rules.gd")
const P := preload("res://tools/planimpact1_rules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const TowelWire := preload("res://scripts/state/TowelWire.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const CC := preload("res://scripts/rules/ComboCounter.gd")

const STYLES := ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]
const WEAPONS := ["Never stops throwing", "Stops people", "Body hooks", "Heavy right hand", "Right hand over the jab", "Long jab"]
const WEAKS := ["Fades after round 2", "Leaves the chin open", "Walks in straight", "Slow to start", "Backs straight up"]
const CAMP := {"protocol": 2}
const GYM := 58.0
const FIVE := ["Lucy Jackson", "Samira Khan", "Tess Reilly", "CARA", "JADE"]
var types: Array = []
var five: Array = []
var built_coach := 58.0
var plans := {}
var out_path := ""
var t0 := 0
var bouts := 0
var cache := {}


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).trim_prefix(key + "=")
	return def


func ints(key: String, def: String) -> Array:
	var s := _arg(key, def)
	return [] if s == "" else Array(s.split(",")).map(func(x): return int(x))


func say(d: Dictionary) -> void:
	var s := JSON.stringify(d)
	if out_path != "":
		var fh := FileAccess.open(out_path, FileAccess.READ_WRITE if FileAccess.file_exists(out_path) else FileAccess.WRITE)
		if fh != null:
			fh.seek_end()
			fh.store_line(s)
			fh.close()
	print(s)


func lim_of(ti: int) -> int:
	return StyleName.limit(types[ti]["f"], PlanBoard.arrow_limit(GYM))


func files_of(ti: int, si: int, nf: int) -> Array:
	var out: Array = []
	for j in nf:
		var idx := (j * 7 + si * 3 + ti) % (WEAPONS.size() * WEAKS.size())
		out.append([STYLES[si], WEAPONS[idx / WEAKS.size()], WEAKS[idx % WEAKS.size()]])
	return out


func pw_opp(ti: int, fl: Array) -> Dictionary:
	var opp := DebutOpp.make(types[ti]["f"], 0.0, 0, "probe18")
	var nm := "M %s|%s|%s" % [fl[0], fl[1], fl[2]]
	opp.merge({"name": nm, "first": nm.split(" ")[0], "style": str(fl[0]), "threat": str(fl[1]), "weak": str(fl[2]),
		"rating": snappedf(float(types[ti]["night0"]), 0.01)}, true)
	return opp


## The bout's plan exchanges and countered ones (ComboCounter records on each exchange).
func cc_stats(m: Dictionary) -> Array:
	var pl := 0
	var ct := 0
	var mv := {}
	for r in m.get("rounds", []):
		for x in (r as Dictionary).get("exchanges", []):
			if bool((x as Dictionary).get("planned", false)):
				pl += 1
				ct += 1 if bool(((x as Dictionary).get("cc", {}) as Dictionary).get("countered", false)) else 0
				var a := str((x as Dictionary).get("arrow", ""))
				mv[a] = int(mv.get(a, 0)) + 1
	return [pl, ct, mv]


## L1's hook: one line a place onto the bout, on the counts as this exchange starts (bell = the counts after the next bell).
func hook(sf: Dictionary, plan: Array, coin: RandomNumberGenerator, bell: bool) -> void:
	var cc: Dictionary = (sf["bout"] as Dictionary).get("cc", {})
	sf["bout"]["arrows"] = P.filter(plan, CC.bell(cc) if bell else cc, coin.randf())


## One PW bout (PLANWORTH1's bout(), paired dice k): arrows empty = the coach at ck writes at the first bell.
func pw_bout(ti: int, fl: Array, plan: Array, k: int, ck: float) -> Dictionary:
	var sc := Career.new()
	sc.day = 50000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": ck}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = true
	sf["camp"] = CAMP.duplicate(true)
	var twins := P.L1 > 0.0 and P.has_twins(plan)
	var coin := RandomNumberGenerator.new()
	coin.seed = hash([ti, k, "planimpact1"])
	sf["arrows"] = P.filter(plan, {}, coin.randf()) if twins else plan.duplicate(true)
	var opp := pw_opp(ti, fl)
	sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 4, "pro": true, "stale": 0.0}
	sf["bout"]["mode_bias"] = T.bias(sf, opp, false)
	sc.fighters = [sf]
	var md := BoutNight.fight_modal(sf)
	if not twins:
		BoutNight.play_out(sc, sf, md)
	else:   # BoutNight.play_out = fight_step("start") + _box_out, with the hook before every exchange
		BoutNight.fight_step(sc, sf, md, "start")
		while not LiveRound.live(md).is_empty():
			hook(sf, plan, coin, false)
			BoutNight._shout(sc, sf, md, "")
		var nr := BoutNight.rounds_of(sf)
		while int(md["round"]) < nr and not BoutNight.stopped(md) and not TowelWire.coach_pull(sc, sf, md) and not CrackWire.bell(sc, sf, md, nr):
			hook(sf, plan, coin, true)
			BoutNight._open(sc, sf, md, BoutRules.auto_corner(sf["stats"]))
			while not LiveRound.live(md).is_empty():
				hook(sf, plan, coin, false)
				BoutNight._shout(sc, sf, md, "")
	bouts += 1
	var s := cc_stats(md)
	return {"out": BoutNight.outcome_of(sf, md), "pl": s[0], "ct": s[1], "mv": s[2]}


## n paired PW bouts from dice k0: {s: "wld", pl, ct}.
func pw_play(ti: int, fl: Array, plan: Array, ck: float, n: int, k0: int) -> Dictionary:
	var g := {"s": "", "pl": 0, "ct": 0, "mv": {}}
	for k in n:
		var b := pw_bout(ti, fl, plan, k0 + k, ck)
		g["s"] = str(g["s"]) + ("w" if b["out"] == "win" else ("d" if b["out"] == "draw" else "l"))
		g["pl"] = int(g["pl"]) + int(b["pl"])
		g["ct"] = int(g["ct"]) + int(b["ct"])
		for kk in b["mv"]:
			g["mv"][kk] = int(g["mv"].get(kk, 0)) + int(b["mv"][kk])
	return g


## The arm's plan, writer rating and switches: [plan, ck, L1, counter on].
func pw_arm(arm: String, ti: int, si: int, fl: Array) -> Array:
	var cp: Array = plans.get("C|%d|%d" % [ti, si], [])
	var vp: Array = plans.get("V|%d|%d" % [ti, si], cp)
	match arm:
		"A": return [[], Sim.NO_COACH_RATING, 0.0, true]
		"B58": return [[], 58.0, 0.0, true]
		"C": return [cp, GYM, 0.0, true]
		"Coff": return [cp, GYM, 0.0, false]
		"V": return [vp, GYM, 1.0, true]
		"Vh": return [vp, GYM, 0.5, true]
		"Voff": return [vp, GYM, 1.0, false]
		"D": return [plans.get("D|%d|%s|%s|%s" % [ti, fl[0], fl[1], fl[2]], []), GYM, 0.0, true]
		"E": return [P.careless(types[ti]["f"], str(fl[0]), lim_of(ti)), GYM, 0.0, true]
	return [[], GYM, 0.0, true]


func stage_pw(arms: Array, n: int, k0: int, nf: int) -> void:
	for ti in ints("types", "0,1,2,3,4,5,6,7,8,9"):
		for si in ints("styles", "0,1,2,3,4,5"):
			for fl in files_of(ti, si, nf):
				for arm in arms:
					var a := pw_arm(str(arm), ti, si, fl)
					P.L1 = float(a[2])
					CC.on = bool(a[3])
					var g := pw_play(ti, fl, a[0], float(a[1]), n, k0)
					P.L1 = 0.0
					CC.on = true
					say({"tag": "pw", "ti": ti, "type": types[ti]["name"], "si": si, "style": fl[0], "threat": fl[1], "weak": fl[2], "arm": arm,
						"plan": a[0], "n": n, "k0": k0, "s": g["s"], "pl": g["pl"], "ct": g["ct"], "mv": g["mv"]})
			print("PI1 pw type %d style %d, %d bouts, %.1f s" % [ti, si, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## Cross play (bar 3): each style's V plan (L1 on) against each style's files.
func stage_x(n: int, k0: int, nfx: int) -> void:
	P.L1 = 1.0
	for ti in ints("types", "0,1,2,3,4,5,6,7,8,9"):
		for si in 6:
			for fl in files_of(ti, si, nfx):
				for sj in 6:
					var vp: Array = plans.get("V|%d|%d" % [ti, sj], plans.get("C|%d|%d" % [ti, sj], []))
					var g := pw_play(ti, fl, vp, GYM, n, k0)
					say({"tag": "x", "ti": ti, "type": types[ti]["name"], "si": si, "sj": sj, "style": fl[0], "threat": fl[1], "weak": fl[2], "n": n, "s": g["s"]})
		print("PI1 x type %d, %d bouts, %.1f s" % [ti, bouts, (Time.get_ticks_msec() - t0) / 1000.0])
	P.L1 = 0.0


## L1's chooser: one step from C on SEPARATE dice (k 1000..1019, the cell's first three files); kept only if it beats C there.
func stage_vpick(n: int) -> void:
	P.L1 = 1.0
	for ti in ints("types", "0,1,2,3,4,5,6,7,8,9"):
		for si in ints("styles", "0,1,2,3,4,5"):
			var cp: Array = plans.get("C|%d|%d" % [ti, si], [])
			var fls := files_of(ti, si, 5).slice(0, 3)
			var base := 0
			for fl in fls:
				base += pw_play(ti, fl, cp, GYM, n, 1000)["s"].count("w")
			var best: Array = cp
			var bw := base
			var tried: Array = []
			for o in P.twin_options(types[ti]["f"], cp, lim_of(ti)):
				var w := 0
				for fl in fls:
					w += pw_play(ti, fl, o["plan"], GYM, n, 1000)["s"].count("w")
				tried.append([o["kind"], (o["plan"] as Array).map(func(l): return str(l["move"])), w])
				if w > bw:
					bw = w; best = o["plan"]
			say({"tag": "vplan", "ti": ti, "type": types[ti]["name"], "si": si, "style": STYLES[si], "C": cp, "V": best, "base": base, "best": bw,
				"bouts_each": n * fls.size(), "tried": tried})
			print("PI1 vpick type %d style %d, %d bouts, %.1f s" % [ti, si, bouts, (Time.get_ticks_msec() - t0) / 1000.0])
	P.L1 = 0.0


## ---- the read greedy (PLANWORTH1's chooser of arm C, copied: for Cara and Jade, who are not in its frozen plans) ----
func read(ti: int, fl: Array, arr: Array, k: float) -> float:
	var key := "%d|%s|%s|%.2f" % [ti, str(fl), JSON.stringify(arr), k]
	if cache.has(key):
		return float(cache[key])
	var f: Dictionary = (types[ti]["f"] as Dictionary).duplicate()
	f["pro"] = true
	f["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
	f["arrows"] = arr.duplicate(true)
	var p := float(BoutRead.CardOdds.result(BoutRead.round_edges(f, pw_opp(ti, fl), CAMP, k), BoutRead.RingDuel.FORM_SD)["win"])
	cache[key] = p
	return p


func slot(l: Dictionary) -> String:
	return "%s|%s" % [str(StrikeMap.move(str(l["move"])).get("from", "")), str(l.get("when", ""))]


func greedy_c(ti: int, fl: Array, lim: int) -> Array:
	var f: Dictionary = types[ti]["f"]
	var cands: Array = []
	for place in PlanLines.PLACES:
		for o in PlanLines.options(place, "", f.get("moves", {}), f.get("combos", {})):
			if str(o["why"]) == "":
				cands.append({"move": str(o["id"])})
	var plan: Array = []
	var cur := read(ti, fl, [], Sim.NO_COACH_RATING)
	var gains := {}
	var used := {}
	for i in cands.size():
		gains[i] = read(ti, fl, [cands[i]], GYM) - cur
	var first := true
	while plan.size() < lim:
		var order: Array = gains.keys().filter(func(i): return not used.has(slot(cands[i])))
		if order.is_empty():
			break
		order.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
		if not first:
			for i in order.slice(0, 10):
				gains[i] = read(ti, fl, plan + [cands[i]], GYM) - cur
			order = order.slice(0, 10)
			order.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
		first = false
		var bi: int = order[0]
		if float(gains[bi]) <= 0.0001:
			break
		plan.append(cands[bi])
		used[slot(cands[bi])] = true
		cur = read(ti, fl, plan, GYM)
		gains.erase(bi)
	return plan


func stage_cpick() -> void:
	for ti in ints("types", "10,11"):
		for si in 6:
			var plan := greedy_c(ti, [STYLES[si], "", ""], lim_of(ti))
			say({"tag": "cplan", "ti": ti, "type": types[ti]["name"], "si": si, "style": STYLES[si], "plan": plan})


## ---- CB harness ----
func cb_opp(ti: int, cl: Dictionary) -> Dictionary:
	var opp := DebutOpp.make(types[ti]["f"], 0.0, 0, "cc1")
	opp.merge({"name": "Opp %s" % str(cl["id"]), "first": "Opp", "style": str(cl["style"]), "threat": str(cl["threat"]), "weak": str(cl["weak"]),
		"rating": snappedf(float(types[ti]["night0"]) + float(cl.get("off", 0.0)), 0.01), "stance": str(cl.get("stance", "orthodox"))}, true)
	return opp


func cb_plan(pk: String, ti: int, style: String) -> Array:
	var f: Dictionary = types[ti]["f"]
	if pk.begins_with("K@"):
		style = STYLES[int(pk.trim_prefix("K@"))]
		pk = "K"
	var si := STYLES.find(style)
	var key := "%s|%d|%s" % [pk, ti, style]
	if cache.has(key):
		return cache[key]
	var plan: Array = []
	match pk:
		"C": plan = plans.get("C|%d|%d" % [ti, si], [])
		"V": plan = plans.get("V|%d|%d" % [ti, si], plans.get("C|%d|%d" % [ti, si], []))
		"K": plan = P.corner_plan(f, style, lim_of(ti))
		"D": plan = P.corner_plan(f, style, lim_of(ti)).slice(0, 1)
		"E": plan = P.careless(f, style, lim_of(ti))
	cache[key] = plan
	return plan


## One CB bout. arm = [corner reader|file, plan none|coach|C|V|K|D|E|K@si, L2, L3, L1].
func cb_bout(ti: int, cl: Dictionary, L: int, k: int, arm: Array) -> Dictionary:
	var corner := str(arm[0])
	var pk := str(arm[1])
	P.L2 = float(arm[2]); P.L3 = float(arm[3]); P.L1 = float(arm[4])
	var pol := "reader_nr" if corner == "reader" else "skill58"
	var sc := Career.new()
	sc.day = 70000 + k * 7
	sc.seed = 387
	sc.coach = {"rating": Sim.NO_COACH_RATING if pk == "none" else built_coach}
	var sf: Dictionary = (types[ti]["f"] as Dictionary).duplicate(true)
	sf["pro"] = false
	sf["camp"] = {"protocol": 2}
	var plan := cb_plan(pk, ti, str(cl["style"]))
	var twins := P.L1 > 0.0 and P.has_twins(plan)
	var coin := RandomNumberGenerator.new()
	coin.seed = hash([ti, k, L, str(cl["id"]), "planimpact1"])
	sf["arrows"] = P.filter(plan, {}, coin.randf()) if twins else plan.duplicate(true)
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
	var raised: Array = P.sharpen(st, fought) if corner == "reader" else []
	var cmds := 0
	var up := 0
	m["step"] = "round"   # CORNERBASE1's OPEN_CALL start (BoutNight fight_step("start") with the corner's round-1 call)
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
			var d: Dictionary = {"cmd": "", "ring": "", "finish": false, "pace": "", "shout": ""}
			if corner != "reader" or P.may_speak(int(ctx["n"]), int(ctx["i"])):
				d = R2.decide(st, ctx, sf)
			if str(d["cmd"]) != "":
				cmds += 1
				up += 1 if raised.has(str(d["cmd"])) else 0
			var add := R2.before(st, ctx, d, sf, m, lv)
			var nx := (lv["ex"] as Array).size()
			if twins:
				hook(sf, plan, coin, false)
			Bouts.fight_step(sc, sf, m, "shout:" + str(d.get("shout", "")))
			R2.after(st, ctx, d, sf, m, add, nx)
		var rn := int(m["round"])
		R2.bell(st, sf, m)
		if rn >= L or Bouts.stopped(m) != "" or TowelWire.coach_pull(sc, sf, m):
			break
		if int(cl.get("switch", 0)) > 0 and rn + 1 >= int(cl["switch"]):
			opp["stance"] = "southpaw" if str(opp["stance"]) == "orthodox" else "orthodox"
		if corner == "reader" and P.L3 >= 1.0 and rn == 1:   # L3: his first command, set at the round-1 corner
			var exs: Array = (m["rounds"][-1] as Dictionary).get("exchanges", [])
			var seen_sit := str((exs[-1] as Dictionary).get("sit", "range")) if not exs.is_empty() else "range"
			st["cmd"] = str(R2.best_for(seen_sit, st["gr"], st["rg"], float(st["heard"]), str(st["own"]))[0])
		var call := C.corner(cs, sf, m) if C.is_coach(pol) else R2.corner_call(st, sf, m)
		if twins:
			hook(sf, plan, coin, true)
		Bouts.fight_step(sc, sf, m, "corner:" + call)
		R2.after_open(st, m, call)
		if LiveRound.live(m).is_empty() and Bouts.stopped(m) != "":
			break
	P.L1 = 0.0; P.L2 = 0.0; P.L3 = 0.0
	var s := cc_stats(m)
	return {"out": BoutNight.outcome_of(sf, m), "pl": s[0], "ct": s[1], "mv": s[2], "cmds": cmds, "up": up, "raised": raised, "fought": fought}


func stage_cb(tag: String, arms: Array, cells: Array, lens: Array, n: int, k0: int) -> void:
	for L in lens:
		for cl in cells:
			for bi in ints("boxers", "0,1,2,3,4"):
				var ti: int = five[bi]
				var g := {}
				for a in arms:
					g[a] = {"s": "", "pl": 0, "ct": 0, "cmds": 0, "up": 0, "raised": [], "fought": []}
				for k in n:
					for a in arms:
						var b := cb_bout(ti, cl, int(L), k0 + k, str(a).split(":"))
						var row: Dictionary = g[a]
						row["s"] = str(row["s"]) + ("w" if b["out"] == "win" else ("d" if b["out"] == "draw" else "l"))
						for kk in ["pl", "ct", "cmds", "up"]:
							row[kk] = int(row[kk]) + int(b[kk])
						row["raised"] = b["raised"]; row["fought"] = b["fought"]
				for a in arms:
					var row: Dictionary = g[a]
					row.merge({"tag": tag, "L": L, "cell": cl["id"], "style": cl["style"], "bi": bi, "boxer": types[ti]["name"], "arm": a, "n": n, "k0": k0}, true)
					say(row)
			print("PI1 %s L%d %s, %d bouts, %.1f s" % [tag, int(L), cl["id"], bouts, (Time.get_ticks_msec() - t0) / 1000.0])


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
	var stage := _arg("stage", "ctl")
	P.NARROW = _arg("narrow", "0") == "1"   # DESIGN: the narrowed mapping, taken once after the trial's 80.7% raised under C
	var cells: Array = []
	for cl in R2.CELLS:
		if _arg("cells", "all") == "all" or (_arg("cells", "all").split(",") as PackedStringArray).has(str(cl["id"])):
			cells.append(cl)
	say({"tag": "run", "stage": stage, "narrow": P.NARROW, "built_coach": built_coach, "plans": plans.size(), "five": five.map(func(i): return [i, types[i]["name"]]),
		"population": types.map(func(t): return [t["name"], t["sex"], t["style"], snappedf(float(t["night0"]), 0.01), t["f"]["stats"]])})
	var n := int(_arg("n", "30"))
	var k0 := int(_arg("k0", "0"))
	var lens: Array = ints("lens", "3,6")
	var arms: Array = Array(_arg("arms", "").split(",", false))
	match stage:
		"ctl":
			stage_pw(["A", "B58", "C"], 30, 0, 5)
			stage_cb("ctlcb", ["reader:coach:0:0:0", "file:coach:0:0:0"], [R2.CELLS[0]], [3], 70, 0)
		"cpick": stage_cpick()
		"vpick": stage_vpick(n)
		"pw": stage_pw(arms, n, k0, int(_arg("nf", "5")))
		"x": stage_x(n, k0, int(_arg("nfx", "2")))
		"cb": stage_cb("cb", arms, cells, lens, n, k0)
	print("PLANIMPACT1 done: stage %s, %.1f s, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, bouts])
	quit(0)
