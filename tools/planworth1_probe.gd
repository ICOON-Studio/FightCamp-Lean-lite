extends SceneTree
## PLANWORTH1 (S544, ops/research/TASK_PLANWORTH1.md). Measurement only: nothing under scripts/ or tests/ changes.
## What the player's WHOLE plan is worth against the coach's, in real bouts. Population: TURNPROBE18's ten types at week 4
## (tools/tellplay1_rules.gd build_types, preloaded, not edited) against 30 of the 180 opponent files a type (5 per style,
## weapons and weaknesses rotated as tellplay1_probe stage_bout_base). The bout is tellplay1_probe.gd's bout() copied (rule A
## off = the game's own mode_bias). The read is the game's: BoutRead.CardOdds.result(BoutRead.round_edges(...)).
## Arms: A no plan + no coach; B40/B58/B74 the coach writes (empty board, the bout's coach at that rating); C greedy on the
## style only (any-time lines, chosen on a blank-file opponent of that style); C2 greedy on the whole file (when lines too);
## D C2's single best line alone; E careless (highest-mastery moves where they are not the best answer); F the read's worst
## plan; C-i = C minus line i. C/C2/D/E/F/C-i play with the bout's coach at 58 (the gym's coach; the rating changes only the
## coach's own plan and the line limit in the bout, BoutNight.gd:196-211).
## Args (after --): stage=trial|full n=<bouts a file-arm> types=<i,j> out=<jsonl> nf=<files a style>.
const R := preload("res://tools/tellplay1_rules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const STYLES := ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]
const WEAPONS := ["Never stops throwing", "Stops people", "Body hooks", "Heavy right hand", "Right hand over the jab", "Long jab"]
const WEAKS := ["Fades after round 2", "Leaves the chin open", "Walks in straight", "Slow to start", "Backs straight up"]
const CAMP := {"protocol": 2}
const WEEK := 4
const GYM := 58.0
const LAZY := 10
var types: Array = []
var out_path := ""
var t0 := 0
var reads := 0
var bouts := 0
var cache := {}


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


func man(style: String, threat: String, weak: String, rating: float) -> Dictionary:
	return {"name": "M %s|%s|%s" % [style, threat, weak], "style": style, "threat": threat, "weak": weak, "rating": snappedf(rating, 0.01)}


func opp_of(ti: int, m: Dictionary) -> Dictionary:
	var f: Dictionary = types[ti]["f"]
	var opp := DebutOpp.make(f, 0.0, 0, "probe18")
	opp.merge({"name": str(m["name"]), "first": str(m["name"]).split(" ")[0], "style": str(m["style"]), "threat": str(m["threat"]),
		"weak": str(m["weak"]), "rating": float(m["rating"])}, true)
	return opp


## The game's read of type ti against file m on these arrows; an empty plan lets the coach at rating k write (BoutRead:272).
func read(ti: int, m: Dictionary, arr: Array, k: float) -> float:
	var key := "%d|%s|%s|%.2f" % [ti, m["name"], JSON.stringify(arr), k]
	if cache.has(key):
		return float(cache[key])
	var f: Dictionary = (types[ti]["f"] as Dictionary).duplicate()
	f["pro"] = true
	f["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": 4}
	f["arrows"] = arr.duplicate(true)
	var p := float(BoutRead.CardOdds.result(BoutRead.round_edges(f, opp_of(ti, m), CAMP, k), BoutRead.RingDuel.FORM_SD)["win"])
	reads += 1
	cache[key] = p
	return p


## tellplay1_probe.bout() copied: one real bout, paired dice k; arrows empty = the coach at ck writes at the first bell.
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
	var first: Array = []
	var rounds: Array = md.get("rounds", [])
	if not rounds.is_empty():
		first = (rounds[0] as Dictionary).get("plan", [])
	return [BoutNight.outcome_of(sf, md), first]


func limit_of(ti: int) -> int:
	return StyleName.limit(types[ti]["f"], PlanBoard.arrow_limit(GYM))


## Every line she can throw: any-time lines on every place; with when=true, also a line per situation on its place
## (PlanLines.place_for) and the ropes card a press / load-up loses to (PlanFight.LOST_CARD).
func candidates(ti: int, with_when: bool) -> Array:
	var f: Dictionary = types[ti]["f"]
	var out: Array = []
	for place in PlanLines.PLACES:
		for o in PlanLines.options(place, "", f.get("moves", {}), f.get("combos", {})):
			if str(o["why"]) == "":
				out.append({"move": str(o["id"])})
	if with_when:
		for w in FightFlow.WHEN_WORDS:
			var places := [PlanLines.place_for(str(w))]
			if PlanFight.LOST_CARD.has(w):
				places.append(str(PlanFight.LOST_CARD[w]))
			for place in places:
				for o in PlanLines.options(place, str(w), f.get("moves", {}), f.get("combos", {})):
					if str(o["why"]) == "":
						out.append({"move": str(o["id"]), "when": str(w)})
	return out


func slot(l: Dictionary) -> String:
	return "%s|%s" % [str(StrikeMap.move(str(l["move"])).get("from", "")), str(l.get("when", ""))]


## Greedy on the read, lazy after the first step (re-read the LAZY best of the last step's gains). sign 1 = best, -1 = worst.
func greedy(ti: int, m: Dictionary, cands: Array, sign: float, lim: int) -> Dictionary:
	var plan: Array = []
	var cur := read(ti, m, [], GYM)   # the empty board reads as the coach's plan: first step is against no plan below
	cur = read(ti, m, [], Sim.NO_COACH_RATING)
	var gains := {}
	var used := {}
	var steps: Array = []
	for i in cands.size():
		gains[i] = sign * (read(ti, m, [cands[i]], GYM) - cur)
	var first := true
	while plan.size() < lim:
		var order: Array = gains.keys().filter(func(i): return not used.has(slot(cands[i])))
		if order.is_empty():
			break
		order.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
		if not first:
			for i in order.slice(0, LAZY):
				gains[i] = sign * (read(ti, m, plan + [cands[i]], GYM) - cur)
			order = order.slice(0, LAZY)
			order.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
		first = false
		var bi: int = order[0]
		if float(gains[bi]) <= 0.0001:
			break
		plan.append(cands[bi])
		used[slot(cands[bi])] = true
		cur = read(ti, m, plan, GYM)
		steps.append(snappedf(100.0 * float(gains[bi]) * sign, 0.01))
		gains.erase(bi)
	return {"plan": plan, "steps": steps}


## The careless plan: her highest-mastery moves (punches, combinations, steps by their bars) each as an any-time line on its
## place, where it is NOT the best answer to the game the style brings there (CoachPlan.cards), until the limit.
func careless(ti: int, style: String, lim: int) -> Array:
	var f: Dictionary = types[ti]["f"]
	var game_on := {}
	for cg in CoachPlan.cards(style):
		game_on[str(cg[0])] = str(cg[1])
	var pool: Array = []
	for d in [f.get("moves", {}), f.get("combos", {}), f.get("steps", {})]:
		for id in d:
			var row := StrikeMap.move(str(id))
			if row.is_empty() or not PlanFight.can_do(row, f.get("moves", {})) or PlanFight.rate(str(id), f.get("combos", {})) < 1.0:
				continue
			pool.append([str(id), float(d[id])])
	pool.sort_custom(func(a, b): return float(a[1]) > float(b[1]))
	var plan: Array = []
	var used := {}
	for p in pool:
		if plan.size() >= lim:
			break
		var place := str(StrikeMap.move(str(p[0]))["from"])
		if used.has(place):
			continue
		if PlanFight.fit(str(p[0]), str(game_on.get(place, ""))) == "best":
			continue
		plan.append({"move": str(p[0])})
		used[place] = true
	return plan


func files_of(ti: int, si: int, nf: int) -> Array:
	var out: Array = []
	for j in nf:
		var idx := (j * 7 + si * 3 + ti) % (WEAPONS.size() * WEAKS.size())
		out.append([STYLES[si], WEAPONS[idx / WEAKS.size()], WEAKS[idx % WEAKS.size()]])
	return out


## n paired bouts: "w"/"l"/"d" per dice k.
func play(ti: int, m: Dictionary, arr: Array, ck: float, n: int) -> String:
	var s := ""
	for k in n:
		var o: String = bout(ti, m, arr, k, ck)[0]
		s += "w" if o == "win" else ("d" if o == "draw" else "l")
	return s


## STAGE b58: the coach's plan alone (empty board, the bout's coach at 58) on the same files and dice as stage full (rerun
## for run a, whose B58 arm the empty-plan guard had played with no coach).
func stage_b58(n: int, nf: int, want: Array) -> void:
	for ti in types.size():
		if not want.is_empty() and not want.has(ti):
			continue
		var r0 := float(types[ti]["night0"])
		for si in STYLES.size():
			for fl in files_of(ti, si, nf):
				var m := man(fl[0], fl[1], fl[2], r0)
				say({"tag": "b58", "ti": ti, "style": fl[0], "threat": fl[1], "weak": fl[2], "n": n,
					"read": snappedf(100.0 * read(ti, m, [], 58.0), 0.01), "bout": play(ti, m, [], 58.0, n)})
		print("PW1 b58 type %d done, %d bouts, %.1f s" % [ti, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


func stage_full(n: int, nf: int, want: Array) -> void:
	for ti in types.size():
		if not want.is_empty() and not want.has(ti):
			continue
		var r0 := float(types[ti]["night0"])
		var f: Dictionary = types[ti]["f"]
		var lim := limit_of(ti)
		var c_any := candidates(ti, false)
		var c_all := candidates(ti, true)
		say({"tag": "type", "ti": ti, "type": types[ti]["name"], "tstyle": types[ti]["style"], "limit": lim, "cands_any": c_any.size(),
			"cands_all": c_all.size(), "coach_reads": [CoachPlan.reads(40.0), CoachPlan.reads(58.0), CoachPlan.reads(74.0)],
			"limits": [PlanBoard.arrow_limit(Sim.NO_COACH_RATING), PlanBoard.arrow_limit(40.0), PlanBoard.arrow_limit(58.0), PlanBoard.arrow_limit(74.0)]})
		for si in STYLES.size():
			var blank := man(STYLES[si], "", "", r0)
			var gc := greedy(ti, blank, c_any, 1.0, lim)
			var cplan: Array = gc["plan"]
			var eplan := careless(ti, STYLES[si], lim)
			var bplan := {}
			for k in [40.0, 58.0, 74.0]:
				bplan[k] = CoachPlan.write(STYLES[si], k, f.get("moves", {}), f.get("combos", {}), f.get("steps", {}))
			say({"tag": "style_plans", "ti": ti, "style": STYLES[si], "C": cplan, "C_steps": gc["steps"], "E": eplan,
				"B40": bplan[40.0], "B58": bplan[58.0], "B74": bplan[74.0]})
			for fl in files_of(ti, si, nf):
				var m := man(fl[0], fl[1], fl[2], r0)
				var g2 := greedy(ti, m, c_all, 1.0, lim)
				var gf := greedy(ti, m, c_all, -1.0, lim)
				var c2plan: Array = g2["plan"]
				var dplan: Array = c2plan.slice(0, 1)
				var arms := {"A": [[], Sim.NO_COACH_RATING], "B40": [[], 40.0], "B58": [[], 58.0], "B74": [[], 74.0],
					"C": [cplan, GYM], "C2": [c2plan, GYM], "D": [dplan, GYM], "E": [eplan, GYM], "F": [gf["plan"], GYM]}
				for i in cplan.size():
					var less: Array = cplan.duplicate(true)
					less.remove_at(i)
					arms["C-%d" % i] = [less, GYM]
				var row := {"tag": "file", "ti": ti, "type": types[ti]["name"], "style": fl[0], "threat": fl[1], "weak": fl[2], "n": n,
					"C2": c2plan, "C2_steps": g2["steps"], "F": gf["plan"], "F_steps": gf["steps"], "read": {}, "bout": {}}
				for a in arms:
					var arr: Array = arms[a][0]
					var ck: float = arms[a][1]
					if arr.is_empty() and not a.begins_with("A") and not a.begins_with("B"):
						ck = Sim.NO_COACH_RATING   # a player plan the greedy left empty: no lines (the empty board would bring the coach back)
						row["empty_" + a] = true
					row["read"][a] = snappedf(100.0 * read(ti, m, arr, ck), 0.01)
					row["bout"][a] = play(ti, m, arr, ck, n)
				say(row)
			print("PW1 type %d style %d done, %d reads, %d bouts, %.1f s" % [ti, si, reads, bouts, (Time.get_ticks_msec() - t0) / 1000.0])


## One type against six files, every arm, one bout each printed with the first round's plan; plus the checks.
func stage_trial(ti: int) -> void:
	var r0 := float(types[ti]["night0"])
	var f: Dictionary = types[ti]["f"]
	var lim := limit_of(ti)
	var c_any := candidates(ti, false)
	var c_all := candidates(ti, true)
	say({"tag": "trial_type", "type": types[ti]["name"], "limit": lim, "cands_any": c_any.size(), "cands_all": c_all.size()})
	var six := [["Pressure fighter", "Body hooks", "Fades after round 2"], ["Counter-puncher", "Long jab", "Leaves the chin open"],
		["Volume puncher", "Right hand over the jab", "Walks in straight"], ["Boxer-puncher", "Heavy right hand", "Slow to start"],
		["Out-boxer", "Stops people", "Backs straight up"], ["Slugger", "Never stops throwing", "Fades after round 2"]]
	for fl in six:
		var tr := Time.get_ticks_msec()
		var r_before := reads
		var m := man(fl[0], fl[1], fl[2], r0)
		var cplan: Array = greedy(ti, man(fl[0], "", "", r0), c_any, 1.0, lim)["plan"]
		var c2: Array = greedy(ti, m, c_all, 1.0, lim)["plan"]
		var fp: Array = greedy(ti, m, c_all, -1.0, lim)["plan"]
		var b58 := CoachPlan.write(fl[0], 58.0, f.get("moves", {}), f.get("combos", {}), f.get("steps", {}))
		var arms := {"A": [[], Sim.NO_COACH_RATING], "B58": [[], 58.0], "B58x": [b58, 58.0], "C": [cplan, GYM], "C2": [c2, GYM],
			"D": [c2.slice(0, 1), GYM], "E": [careless(ti, fl[0], lim), GYM], "F": [fp, GYM]}
		var row := {"tag": "trial", "file": fl, "B58_write": b58, "read_ms": 0, "arms": {}}
		row["read_ms"] = (Time.get_ticks_msec() - tr) / maxf(1.0, float(reads - r_before))
		for a in arms:
			var b: Array = bout(ti, m, arms[a][0], 0, arms[a][1])
			row["arms"][a] = {"arrows": arms[a][0], "first_round_plan": b[1], "outcome": b[0], "read": snappedf(100.0 * read(ti, m, arms[a][0], arms[a][1]), 0.01)}
		row["game_usual_read"] = snappedf(100.0 * read(ti, m, [], 58.0), 0.01)
		var same := 0
		for k in 20:
			same += int(bout(ti, m, [], k, 58.0)[0] == bout(ti, m, b58, k, 58.0)[0])
		row["B58_vs_written_same_of_20"] = same
		say(row)
	var tb := Time.get_ticks_msec()
	for k in 20:
		bout(ti, man(STYLES[0], WEAPONS[0], WEAKS[0], r0), [], k, 58.0)
	say({"tag": "timing", "ms_a_bout": (Time.get_ticks_msec() - tb) / 20.0, "reads": reads})


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	out_path = _arg("out", "")
	var built := R.build_types(WEEK)
	types = built[0]
	var stage := _arg("stage", "trial")
	var want: Array = []
	if _arg("types", "") != "":
		want = Array(_arg("types", "").split(",")).map(func(x): return int(x))
	say({"tag": "run", "stage": stage, "gym_coach": GYM, "built_coach": built[1], "no_coach": Sim.NO_COACH_RATING, "read_at": CoachPlan.READ_AT,
		"population": types.map(func(t): return [t["name"], t["sex"], t["style"], snappedf(float(t["night0"]), 0.01), t["f"]["stats"]])})
	match stage:
		"trial": stage_trial(int(_arg("ti", "0")))
		"full": stage_full(int(_arg("n", "24")), int(_arg("nf", "5")), want)
		"b58": stage_b58(int(_arg("n", "24")), int(_arg("nf", "5")), want)
	print("PLANWORTH1 done: stage %s, %.1f s, %d reads, %d bouts" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, reads, bouts])
	quit(0)
