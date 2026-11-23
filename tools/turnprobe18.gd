extends SceneTree
## TURNPROBE18 (S543, ops/research/TASK_TURNPRO18.md): the GREYBOX probe of turning pro v18 (ops/research/DESIGN_TURNPRO1_V18.md).
## Measurement only: nothing under scripts/ changes. Rules: tools/turnprobe18_rules.gd (v17's, with v18's). Every chance is the
## GAME'S read of THIS boxer with THIS plan against THIS opponent: the opponent as DebutOpp.make builds it (style, weapon,
## weakness and rating set per man), the walk BoutRead.round_edges, the 4-round card CardOdds.result - DebutRead.card's own
## steps. The plan: none written = the coach's (CoachPlan.write, as BoutRead._read_copy); a line = the coach's plan + one
## "when" arrow on the situation a tell names (OppFile.tells). Training: TrainingPreview.plan_gain with the gym's coach.
## TEN boxer types (5 women, 5 men), each against their own sex and class. Stage (after --): stage=measure [limit=<files>]
## out=<jsonl>. Run: godot --headless --audio-driver Dummy --path . --script res://tools/turnprobe18.gd -- stage=measure
## (about 80 s on one slot, 33,631 reads). The career stages were not built: the measure-first gate stopped the probe.

const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const CardOdds := preload("res://scripts/rules/CardOdds.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Data := preload("res://scripts/state/Data.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const R := preload("res://tools/turnprobe18_rules.gd")

const MAX_WEEK := 140
## The catalogue of opponent files: the styles the game's read tells apart (Exchanges.STYLE_MODES, RoundStyle.from_opponent),
## BoutRead.ANY_WEAPON / ANY_WEAK's words plus the other phrases OppFile maps to a plan situation.
const STYLES := ["Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Out-boxer", "Slugger"]
const WEAPONS := ["Never stops throwing", "Stops people", "Body hooks", "Heavy right hand", "Right hand over the jab", "Long jab"]
const WEAKS := ["Fades after round 2", "Leaves the chin open", "Walks in straight", "Slow to start", "Backs straight up"]
var types: Array = []
var coach := 0.0
var out_path := ""
var t0 := 0
var reads := 0
var cache := {}
var line_cache := {}


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


func _person(base: Dictionary, over: Dictionary) -> Dictionary:
	var p := base.duplicate(true)
	p.merge(over, true)
	return p


## v17's ten types (Data's six and four more), with v18's two new axes set on purpose: the confidence trait at both ends
## (Fragile 35 or less, Confident 65 or more) and loyalty (two under 50: the club keeps only the trainer's 10%).
const CONF_TRAIT := [30.0, 58.0, 66.0, 70.0, 82.0, 38.0, 25.0, 75.0, 45.0, 33.0]
const LOYALTY := [60.0, 60.0, 82.0, 66.0, 44.0, 70.0, 60.0, 40.0, 60.0, 60.0]
const NATIONALS := [false, false, false, false, false, false, false, true, false, false]   ## Reece: the offer lands in a live nationals run


func _people() -> Array:
	var tpl: Dictionary = Data.PROSPECTS[0]
	var lucy := Data.lucy()
	lucy["personality"] = (tpl["personality"] as Dictionary).duplicate()
	var ps: Array = [lucy]
	for p in Data.PROSPECTS:
		ps.append(p.duplicate(true))
	ps.append(_person(tpl, {"id": "nell", "name": "Nell Ward", "first": "Nell", "sex": "f", "age": 27, "wc": "Light middleweight", "div": "wlm", "weight": 70.8,
		"stance": "southpaw", "style": "Counter-puncher", "pot": 72, "note": "near the ceiling",
		"stats": {"power": 60.0, "speed": 61.0, "technique": 66.0, "defense": 65.0, "conditioning": 60.0, "fight_iq": 66.0, "chin": 60.0}}))
	ps.append(_person(tpl, {"id": "reece", "name": "Reece Doyle", "first": "Reece", "sex": "m", "age": 19, "wc": "Featherweight", "div": "mfw", "weight": 55.8,
		"stance": "orthodox", "style": "Out-boxer", "pot": 90, "note": "raw, fast learner",
		"stats": {"power": 52.0, "speed": 63.0, "technique": 56.0, "defense": 55.0, "conditioning": 57.0, "fight_iq": 54.0, "chin": 58.0}}))
	ps.append(_person(tpl, {"id": "bayo", "name": "Bayo Adams", "first": "Bayo", "sex": "m", "age": 29, "wc": "Middleweight", "div": "mmw", "weight": 75.9,
		"stance": "orthodox", "style": "Slugger", "pot": 70, "note": "hits hard, old for a debut",
		"stats": {"power": 70.0, "speed": 54.0, "technique": 57.0, "defense": 53.0, "conditioning": 58.0, "fight_iq": 57.0, "chin": 70.0}}))
	ps.append(_person(tpl, {"id": "kai", "name": "Kai Turner", "first": "Kai", "sex": "m", "age": 22, "wc": "Light welterweight", "div": "mlm", "weight": 65.8,
		"stance": "orthodox", "style": "Volume puncher", "pot": 80, "note": "busy, thin chin",
		"stats": {"power": 57.0, "speed": 62.0, "technique": 60.0, "defense": 58.0, "conditioning": 66.0, "fight_iq": 58.0, "chin": 55.0}}))
	for i in ps.size():
		var pe: Dictionary = (ps[i]["personality"] as Dictionary).duplicate()
		pe["confidence"] = CONF_TRAIT[i]
		pe["loyalty"] = LOYALTY[i]
		ps[i]["personality"] = pe
	return ps


## A pro-ready amateur's book by style (7-10 amateur wins of pad time; the signing's defaults are the same for all ten and
## drill no combination, so no written line could fire - measured, measure0). Punches (Data.MOVES), drilled combinations
## (Combos.LEARN_AT 30 = usable) and step bars (StepMastery; under FireLevel.USABLE_AT 30 a step never fires). Each type's
## book is its style's, scaled by its own factor. ESTIMATE, a population choice, printed in the run line.
const TECH := {
	"Out-boxer": [{"Jab": 70, "Cross": 58, "Lead hook": 45, "Body hook": 32, "Uppercut": 20, "Check hook": 15},
		{"1-1": 60, "1-2": 62, "1-1-2": 45, "2-3": 35}, {"step_in": 50, "step_out": 60, "step_back": 55, "pivot_out": 45, "feint": 40}],
	"Slugger": [{"Jab": 50, "Cross": 68, "Lead hook": 62, "Body hook": 50, "Uppercut": 45, "Check hook": 10},
		{"1-2": 45, "2-3": 55, "3b-3": 50, "1-6-3": 40, "1-2-3": 35}, {"step_in": 55, "cut_off": 40, "herd": 35, "tie_up": 45, "push_off": 45}],
	"Pressure fighter": [{"Jab": 52, "Cross": 58, "Lead hook": 64, "Body hook": 66, "Uppercut": 40, "Check hook": 10},
		{"3b-3": 60, "1-2-3b": 50, "1-2": 40, "1-2-3-2": 35, "1-6-3": 35}, {"cut_off": 55, "herd": 50, "step_in": 55, "tie_up": 40, "push_off": 40}],
	"Boxer-puncher": [{"Jab": 62, "Cross": 62, "Lead hook": 55, "Body hook": 45, "Uppercut": 35, "Check hook": 20},
		{"1-2": 58, "1-2-3": 48, "2-3": 40, "slip 2-3": 35, "1-2-3b": 35}, {"step_in": 45, "step_out": 45, "step_back": 45, "pivot_out": 40, "feint": 35}],
	"Counter-puncher": [{"Jab": 60, "Cross": 62, "Lead hook": 55, "Body hook": 38, "Uppercut": 30, "Check hook": 50},
		{"slip 2-3": 58, "1-2": 50, "2-3": 45, "1-1": 40}, {"step_back": 60, "pivot_out": 55, "roll_out": 50, "feint": 45, "step_out": 45}],
	"Volume puncher": [{"Jab": 62, "Cross": 58, "Lead hook": 56, "Body hook": 50, "Uppercut": 32, "Check hook": 10},
		{"1-2-3-2": 55, "1-2": 58, "1-2-3": 50, "3b-3": 40, "1-1": 45}, {"step_in": 50, "cut_off": 40, "herd": 35, "tie_up": 30}],
}
const TECH_FACTOR := [1.0, 0.92, 1.05, 1.0, 1.0, 0.9, 1.08, 0.85, 1.0, 0.95]
const STEP_FLOOR := 20.0   ## a step the style does not drill: under usable (never fires)


func _book(i: int, style: String) -> Array:
	var t: Array = TECH.get(style, TECH["Boxer-puncher"])
	var k := float(TECH_FACTOR[i])
	var mv := {}
	for m in t[0]:
		mv[m] = snappedf(float(t[0][m]) * k, 0.1)
	var co := {}
	for c in t[1]:
		co[c] = snappedf(float(t[1][c]) * k, 0.1)
	var stp := {}
	for s in ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off"]:
		stp[s] = snappedf(float(t[2].get(s, STEP_FLOOR)) * (k if t[2].has(s) else 1.0), 0.1)
	return [mv, co, stp]


const PLANS := [["speed", "technique", "defense"], ["speed", "conditioning"], ["power", "defense"], ["conditioning", "power"],
	["technique", "speed"], ["conditioning", "power"], ["fight_iq", "defense"], ["technique", "defense"], ["power"], ["conditioning", "speed"]]
const FRAMES := [[168, 170], [163, 168], [172, 171], [176, 178], [173, 176], [178, 182], [174, 177], [167, 172], [182, 185], [175, 175]]
const RECORDS := [[8, 2], [9, 1], [7, 3], [9, 4], [8, 1], [7, 2], [10, 3], [7, 1], [9, 2], [8, 3]]


func _build_types() -> void:
	var ps := _people()
	for i in ps.size():
		var c := Career.quick_start()
		c.seed = 9100 + i * 37; c.first_hour = {}; FirstWeek.skip(c)
		c.applicant = (ps[i] as Dictionary).duplicate(true)
		Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"]); Sim.hire(c, "reid")
		coach = float(c.coach.get("rating", 0.0))
		var f: Dictionary = c.fighter().duplicate(true)
		f["w"] = RECORDS[i][0]; f["l"] = RECORDS[i][1]
		f["height"] = FRAMES[i][0]; f["reach"] = FRAMES[i][1]
		f["personality"] = (ps[i]["personality"] as Dictionary).duplicate()
		f.erase("loyalty")
		var bk := _book(i, str(f.get("style", "")))
		f["moves"] = bk[0]; f["combos"] = bk[1]; f["steps"] = bk[2]
		f["arrows"] = []   # the usual plan: none written, the coach writes it (BoutRead._read_copy)
		var st_at: Array = []
		var st: Dictionary = (f["stats"] as Dictionary).duplicate()
		var plan: Array = PLANS[i]
		for wk in MAX_WEEK + 1:
			st_at.append(st.duplicate())
			var gain := TrainingPreview.plan_gain(st, int(f.get("pot", 75)), str(plan[wk % plan.size()]), coach)
			for k in gain:
				st[k] = float(st[k]) + float(gain[k])
		types.append({"name": str(f["name"]), "sex": str(f.get("sex", "f")), "f": f, "pot": int(f.get("pot", 75)), "plan": plan,
			"chin": float((f["stats"] as Dictionary).get("chin", 60.0)), "stats_at": st_at, "night0": DebutOpp.night(f["stats"]),
			"style": str(f.get("style", "")), "div": str(f.get("div", "")), "stance": str(f.get("stance", "")), "age": int(f.get("age", 0)),
			"rec": "%d-%d" % [int(f["w"]), int(f["l"])], "frame": FRAMES[i], "conf_trait": CONF_TRAIT[i], "loyalty": LOYALTY[i],
			"nationals": NATIONALS[i]})


## A man of the division: {name, style, threat, weak, rating}.
func man(name: String, style: String, threat: String, weak: String, rating: float) -> Dictionary:
	return {"name": name, "style": style, "threat": threat, "weak": weak, "rating": snappedf(rating, 0.01)}


## The game's read: type ti at week wk against this man, on the usual plan (line {}) or the coach's plan + one line.
func read(ti: int, wk: int, m: Dictionary, line: Dictionary) -> float:
	var key := "%d|%d|%s|%.2f|%s|%s" % [ti, wk, str(m["name"]), float(m["rating"]), str(line.get("move", "")), str(line.get("when", ""))]
	if cache.has(key):
		return float(cache[key])
	var ty: Dictionary = types[ti]
	var f: Dictionary = (ty["f"] as Dictionary).duplicate()
	f["stats"] = ty["stats_at"][mini(wk, MAX_WEEK)]
	var opp := DebutOpp.make(f, 0.0, 0, "probe18")
	opp.merge({"name": str(m["name"]), "first": str(m["name"]).split(" ")[0], "style": str(m["style"]), "threat": str(m["threat"]),
		"weak": str(m["weak"]), "rating": float(m["rating"])}, true)
	var fx := f.duplicate()
	fx["pro"] = true
	fx["bout"] = {"tank_ahead": 0.0, "pro": true, "rounds": DebutRead.ROUNDS}
	if not line.is_empty():
		fx["arrows"] = CoachPlan.write(str(m["style"]), coach, f.get("moves", {}), f.get("combos", {}), f.get("steps", {})) + [line]
	var p := float(CardOdds.result(BoutRead.round_edges(fx, opp, {"protocol": BoutRead.USUAL_CAMP}, coach), BoutRead.RingDuel.FORM_SD)["win"])
	reads += 1
	cache[key] = p
	return p


## The lines the boxer can write against this man: for each plan situation his file names (OppFile.tells: the style's
## game, the weapon's and the weakness's situation), every move out of that situation's card the boxer can throw.
func lines_for(ti: int, m: Dictionary) -> Array:
	var key := "%d|%s|%s|%s" % [ti, str(m["style"]), str(m["threat"]), str(m["weak"])]
	if line_cache.has(key):
		return line_cache[key]
	var f: Dictionary = types[ti]["f"]
	var tells := OppFile.tells({"style": m["style"], "threat": m["threat"], "weak": m["weak"], "w": 6, "l": 6})
	var out: Array = []
	var seen := {}
	for t in tells:
		var sit := str(t.get("when", ""))
		if sit == "" or not PlanFight.GAME_CARD.has(sit) or str(t["id"]) not in ["style", "weapon", "weakness"]:
			continue
		for o in PlanLines.options(str(PlanFight.GAME_CARD[sit]), sit, f.get("moves", {}), f.get("combos", {})):
			if str(o["why"]) != "":
				continue
			var k := "%s|%s" % [o["id"], sit]
			if seen.has(k):
				continue
			seen[k] = true
			out.append({"move": str(o["id"]), "when": sit, "tell": str(t["id"]), "fit": str(o["fit"]),
				"grade": str(LineGrade.grade(str(o["id"]), LineGrade.Attrs.of(f)).get("word", ""))})
	line_cache[key] = out
	return out


## {usual, best, worst, best_line, worst_line}: the read on the usual plan and with each line the boxer can write.
func card_read(ti: int, wk: int, m: Dictionary) -> Dictionary:
	var u := read(ti, wk, m, {})
	var out := {"usual": u, "best": u, "worst": u, "best_line": {}, "worst_line": {}, "sit": {}}
	for l in lines_for(ti, m):
		var p := read(ti, wk, m, {"move": l["move"], "when": l["when"]})
		var sd: Array = out["sit"].get_or_add(str(l["when"]), [0.0, 0.0])
		sd[0] = maxf(float(sd[0]), p - u); sd[1] = minf(float(sd[1]), p - u)
		if p > float(out["best"]):
			out["best"] = p; out["best_line"] = l
		if p < float(out["worst"]):
			out["worst"] = p; out["worst_line"] = l
	return out


func _q(xs: Array, q: float) -> float:
	var s := xs.duplicate()
	s.sort()
	return float(s[clampi(int(q * float(s.size() - 1) + 0.5), 0, s.size() - 1)])


## The rating at which type ti's usual plan reads 'want' at week wk against a plain man (the promoter's aim).
func _aim(ti: int, wk: int, want: float) -> float:
	var lo := float(types[ti]["night0"]) - 15.0
	var hi := float(types[ti]["night0"]) + 15.0
	for _i in 22:
		var mid := (lo + hi) * 0.5
		if read(ti, wk, man("aim", "Boxer-puncher", "", "", mid), {}) > want:
			lo = mid
		else:
			hi = mid
	return snappedf((lo + hi) * 0.5, 0.01)


## One sweep of every file at one rating: the usual read's spread, the best line's gain, best - worst, per situation.
func _sweep(ti: int, wk: int, rating: float, limit: int) -> Dictionary:
	var gains: Array = []; var spreads: Array = []; var usuals: Array = []
	var per := {}
	var top := {"gain": 0.0, "raw": 0.0}
	var low := {"cost": 0.0, "raw": 0.0}
	var n := 0
	for s in STYLES:
		for w in WEAPONS:
			for k in WEAKS:
				if limit > 0 and n >= limit:
					continue
				n += 1
				var m := man("M %s|%s|%s" % [s, w, k], s, w, k, rating)
				var r := card_read(ti, wk, m)
				usuals.append(float(r["usual"])); gains.append(float(r["best"]) - float(r["usual"])); spreads.append(float(r["best"]) - float(r["worst"]))
				for sit in r["sit"]:
					var pv: Array = per.get_or_add(sit, [[], []])
					pv[0].append(float(r["sit"][sit][0])); pv[1].append(float(r["sit"][sit][1]))
				if float(r["best"]) - float(r["usual"]) > float(top["raw"]):
					top = {"raw": float(r["best"]) - float(r["usual"]), "gain": snappedf(100.0 * (float(r["best"]) - float(r["usual"])), 0.1), "man": m["name"], "line": r["best_line"]}
				if float(r["usual"]) - float(r["worst"]) > float(low["raw"]):
					low = {"raw": float(r["usual"]) - float(r["worst"]), "cost": snappedf(100.0 * (float(r["usual"]) - float(r["worst"])), 0.1), "man": m["name"], "line": r["worst_line"]}
	var sits := {}
	for sit in per:
		sits[sit] = {"files": per[sit][0].size(), "best_gain_median": snappedf(100.0 * _q(per[sit][0], 0.5), 0.1), "best_gain_max": snappedf(100.0 * _q(per[sit][0], 1.0), 0.1),
			"worst_median": snappedf(100.0 * _q(per[sit][1], 0.5), 0.1), "worst_min": snappedf(100.0 * _q(per[sit][1], 0.0), 0.1)}
	return {"files": n, "rating": rating, "usual_p10": snappedf(100.0 * _q(usuals, 0.1), 0.1), "usual_p50": snappedf(100.0 * _q(usuals, 0.5), 0.1),
		"usual_p90": snappedf(100.0 * _q(usuals, 0.9), 0.1), "usual_min": snappedf(100.0 * _q(usuals, 0.0), 0.1), "usual_max": snappedf(100.0 * _q(usuals, 1.0), 0.1),
		"gain_median_pts": snappedf(100.0 * _q(gains, 0.5), 0.1), "gain_p90_pts": snappedf(100.0 * _q(gains, 0.9), 0.1), "gain_max_pts": snappedf(100.0 * _q(gains, 1.0), 0.1),
		"spread_median_pts": snappedf(100.0 * _q(spreads, 0.5), 0.1), "spread_max_pts": snappedf(100.0 * _q(spreads, 1.0), 0.1),
		"share_spread_4plus": snappedf(float(spreads.filter(func(x): return x >= 0.04).size()) / float(n), 0.001),
		"share_gain_4plus": snappedf(float(gains.filter(func(x): return x >= 0.04).size()) / float(n), 0.001), "by_situation": sits, "top_gain": top, "worst_cost": low}


## MEASURE FIRST (rule 1): per type, the same-rated man (DebutOpp gap 0) across every file, and the same at the tune-up's
## aim (the rating where the usual plan reads ProLadder.TUNE_AIM against a plain man), at the debut week.
func _measure(limit: int) -> void:
	var nt := types.size()
	var weak_types := 0
	var max_gain := 0.0
	var wk := 4
	for ti in nt:
		var ty: Dictionary = types[ti]
		var same := _sweep(ti, wk, float(ty["night0"]), limit)
		var tune_r := _aim(ti, wk, ProLadder.TUNE_AIM)
		var step_r := _aim(ti, wk, ProLadder.STEP_READ)
		var tune := _sweep(ti, wk, tune_r, limit)
		var plain_now := read(ti, wk, man("aim", "Boxer-puncher", "", "", tune_r), {})
		var plain_4w := read(ti, wk + R.NOT_YET_WEEKS, man("aim", "Boxer-puncher", "", "", tune_r), {})
		var f: Dictionary = ty["f"]
		var tiers: Array = []
		for t in 3:
			tiers.append(R.tier_purse(t, float(ty["night0"])).merged({"points": snappedf(R.tier_points(t, float(ty["night0"]), f), 0.01)}))
		weak_types += int(float(same["spread_median_pts"]) < 4.0)
		max_gain = maxf(max_gain, float(same["gain_max_pts"]))
		say({"tag": "measure", "type": ty["name"], "pot": ty["pot"], "ambition": "title" if R.title_chaser(int(ty["pot"])) else "steady",
			"conf_trait": ty["conf_trait"], "ko_hit": R.ko_hit(float(ty["conf_trait"])), "share": Roster_share(f),
			"same_rated": same, "tune_aim": tune, "tune_rating": tune_r, "step_rating": step_r,
			"not_yet_plain_tune": [snappedf(plain_now, 0.001), snappedf(plain_4w, 0.001)],
			"bar_lines": [R.bar_line(plain_now, 66, 70, true), R.bar_line(plain_now, 30, 15, true), R.bar_line(plain_now, 90, 95, true), R.bar_line(plain_now, 90, 95, false)],
			"tiers": tiers, "reads": reads, "t": (Time.get_ticks_msec() - t0) / 1000.0})
	say({"tag": "measure_verdict", "types_under_4pts": weak_types, "stop": weak_types > nt / 2, "max_plan_gain_pts": max_gain,
		"cap_over_10": max_gain > 10.0})


func Roster_share(f: Dictionary) -> float:
	return R.Roster.signing_share(f)


func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var stage := _arg("stage", "measure")
	out_path = _arg("out", "")
	_build_types()
	say({"tag": "run", "stage": stage, "coach": coach, "arrows0": types[0]["f"].get("arrows", []), "moves0": types[0]["f"].get("moves", {}), "books": types.map(func(t): return [t["name"], t["f"].get("moves", {}), t["f"].get("combos", {}), t["f"].get("steps", {})]),
		"t_setup": (Time.get_ticks_msec() - t0) / 1000.0})
	if stage == "measure":
		_measure(int(_arg("limit", "0")))
	else:
		# The careers (arms, the reader's planner, bars 1-10) were never built: rule 1's measure-first gate stopped the
		# probe (docs/TURNPROBE18_RESULT.md). The task forbids a career run before that gate passes.
		say({"tag": "refused", "stage": stage, "why": "measure-first gate: STOP (see docs/TURNPROBE18_RESULT.md)"})
	print("TURNPROBE18 done: stage %s, %.1f s, %d reads" % [stage, (Time.get_ticks_msec() - t0) / 1000.0, reads])
	quit(0)
