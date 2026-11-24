extends SceneTree
## CORNERCMD1 (S544, ops/research/TASK_CORNERCMD1.md; design ops/research/DESIGN_CORNERCMD1.md). A GREYBOX of the owner's corner
## commands on the REAL bout: every punch, round and verdict is the game's (Bouts.fight_step "start" / "shout:" / "corner:" +
## LiveRound, the loop BoutNight._box_out plays, as tools/pushprobe2.gd drives it). The new commands are flagged local rules in
## tools/cornercmd1_rules.gd: an edge added to the exchange's base before it is fought and taken back after, a wind cost on the
## round's cost, head on the bout's damage. Nothing under scripts/ or tests/ changes.
## Population: TELLPLAY1's types (tools/tellplay1_rules.gd build_types, week 4), our two WOMEN, opponents of their own sex and
## class (DebutOpp.make), styled per cell. Paired dice: bout k is career day 70000 + 7k under every arm.
## Stages (after --): stage=step0 | check | trial | full ; n=<bouts a cell> lens=3,6 cells=<ids|all> out=<jsonl> coach=<rating>
const T := preload("res://tools/tellplay1_rules.gd")
const R := preload("res://tools/cornercmd1_rules.gd")
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
	if stage_now == "step0":
		st["step0"] = true
	if pol == "playout":
		BoutNight.play_out(sc, sf, m)
		return R.finish_state(st, sf, m, BoutNight.outcome_of(sf, m))
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
		Bouts.fight_step(sc, sf, m, "corner:" + R.corner_call(st, sf, m))
		if LiveRound.live(m).is_empty() and Bouts.stopped(m) != "":
			break
	return R.finish_state(st, sf, m, BoutNight.outcome_of(sf, m))


## The one-rep trial's print: one bout exchange by exchange (moment seen, moment fought, command, ring, edge, won).
func walk(ti: int, cl: Dictionary, L: int, arm: String) -> void:
	R.LOG = true
	var r := bout(ti, cl, L, 0, arm)
	R.LOG = false
	for row in r["st"].get("log", []):
		print("CC1 WALK round %d ex %d | seen %s | fought %s | cmd %s | ring %s | finish %s | edge %.1f (plan's call %.1f) | wind %.1f head %.1f | %s" % row)
	say({"tag": "walk", "boxer": types[ti]["name"], "cell": cl["id"], "L": L, "arm": arm, "out": r["out"], "picks": r["st"]["picks"],
		"wind": r["st"]["wind"], "head": r["st"]["head"], "fits": r["st"]["fits"]})


func run_cells(stage: String, pols: Array, cells: Array, lens: Array, n: int) -> void:
	for L in lens:
		for cl in cells:
			for oi in ours.size():
				var ti := int(ours[oi])
				var rows := {}
				for pol in pols:
					rows[pol] = R.agg_new()
				for k in n:
					for pol in pols:
						var p := str(pol)
						var ck := -1.0
						if p.begins_with("coach"):
							ck = float(p.trim_prefix("coach"))
						R.agg_add(rows[pol], bout(ti, cl, int(L), k, p, ck), k)
				for pol in pols:
					say({"tag": stage, "L": L, "cell": cl["id"], "boxer": types[ti]["name"], "pol": pol, "agg": R.agg_out(rows[pol])})
			print("CC1 %s L%d %s done, %d bouts, %.1f s" % [stage, int(L), cl["id"], bouts, (Time.get_ticks_msec() - t0) / 1000.0])


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
	var stage := _arg("stage", "step0")
	stage_now = stage
	k0 = int(_arg("k0", "0"))
	R.FAVPLAN = _arg("favplan", "0") == "1"
	R.RING_SCALE = float(_arg("ring_scale", str(R.RING_SCALE)))
	R.RING_WIND = {"cut": float(_arg("cut_wind", "1.0")), "ropes": float(_arg("ropes_wind", "0.5"))}
	R.COACH_A = float(_arg("coach_a", str(R.COACH_A)))
	R.COACH_B = float(_arg("coach_b", str(R.COACH_B)))
	R.ARMS = R.arms() if _arg("arms", "all") == "all" else Array(_arg("arms", "").split(","))
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
			R.trained(f), R.new_state("plan", 3, coach, f)["gr"], R.new_state("plan", 3, coach, f)["rg"].keys().map(func(k): return [k, R.new_state("plan", 3, coach, f)["rg"][k]]), R.heard_of(f)])
	say({"tag": "run", "stage": stage, "coach": coach, "n": n, "lens": lens, "population": pop,
		"cells": cells.map(func(c): return [c["id"], c["style"], c["threat"], c["weak"], c.get("off", 0.0), c.get("switch", 0)])})
	match stage:
		"step0": run_cells("step0", _arg("pols", "plan,reader0,reader0_save").split(","), cells, lens, n)
		"check": run_cells("check", ["playout", "plan"], cells, lens, n)
		"trial": run_cells("trial", R.ARMS, cells, lens, n)
		"walk": walk(int(ours[0]), cells[0], int(lens[0]), _arg("arm", "reader"))
		"full", "fix": run_cells(stage, R.ARMS, cells, lens, n)
	print("CORNERCMD1 done: stage %s, %.1f s, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, bouts])
	quit(0)
