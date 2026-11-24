extends RefCounted
## CORNERBASE1 local rules (S547, ops/research/TASK_CORNERBASE1.md; probe only; nothing under scripts/ reads this).
## The coach in the other chair, as ops/research/DESIGN_CORNERBASE1.md wrote it BEFORE any run: FILE reads the opponent's
## style word (free at booking) and calls that style's main game's best call; between rounds Hands up when she was hurt,
## Reset (calm) under the wind line, else the same call. FILE + SKILL r: the file read is right with chance r / 100.
## Also the two extra boxers of the population (build_extra). CORNERCMD2's commands and rules are not touched.
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const T := preload("res://tools/tellplay1_rules.gd")
const R := preload("res://tools/cornercmd2_rules.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const ALL_ROUND := ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]

static var ON := true                         # off = every coach arm plays BLIND (the step-0 control)
static var WIND_LINE := Exchanges.SHE_TIRED   # 35, Exchanges.gd l.52 (the design's line; moved once only on the >half rest stop)


static func is_coach(pol: String) -> bool:
	return pol == "file" or pol.begins_with("skill")


## The coach's read of the file before the bout. k = the bout's dice number (paired across ratings).
static func coach_new(pol: String, opp: Dictionary, L: int, cell: String, boxer: String, k: int) -> Dictionary:
	var g := OppFile.main_game(opp)   # OppFile.gd l.113: the style's heaviest game (STYLE_MODES, Exchanges.gd l.156)
	var right := true
	var read := g
	if pol.begins_with("skill"):
		var p := float(pol.trim_prefix("skill")) / 100.0
		var rng := RandomNumberGenerator.new()
		rng.seed = hash([boxer, cell, L, k, "cornerbase1"])
		var u1 := rng.randf()
		var u2 := rng.randf()
		right = u1 < p
		if not right:
			var mix: Dictionary = Exchanges.STYLE_MODES.get(str(opp.get("style", "")), Exchanges.STYLE_MODES["Boxer-puncher"])
			var tot := 0.0
			for x in mix:
				if str(x) != g:
					tot += float(mix[x])
			var roll := u2 * tot
			for x in mix:
				if str(x) == g:
					continue
				read = str(x)
				roll -= float(mix[x])
				if roll <= 0.0:
					break
	return {"pol": pol, "game": g, "read": read, "right": right, "open": str(Exchanges.MODES[read]["best"]),
		"corners": 0, "rests": 0, "hands": 0}


## The round-1 call (the probe opens round 1 on it, as CORNERCMD2's OPEN_CALL did with the plan's call).
static func open_call(cs: Dictionary, f: Dictionary) -> String:
	if cs.is_empty() or not ON:
		return BoutRules.auto_corner(f["stats"])
	return str(cs["open"])


## Hurt in the round just fought: an exchange fought as "your fighter is hurt" (LiveRound.gd l.156) or hurt at the bell (l.453).
static func hurt_in(last: Dictionary) -> bool:
	if bool(last.get("hurt_at_bell", false)):
		return true
	for x in last.get("exchanges", []):
		if str((x as Dictionary).get("sit", "")) == "she_hurt":
			return true
	return false


## One call for the next round, set in the corner (never by the exchange).
static func corner(cs: Dictionary, f: Dictionary, m: Dictionary) -> String:
	if cs.is_empty() or not ON:
		return BoutRules.auto_corner(f["stats"])
	var rounds: Array = m.get("rounds", [])
	var last: Dictionary = rounds[-1] if not rounds.is_empty() else {}
	cs["corners"] = int(cs["corners"]) + 1
	if hurt_in(last):
		cs["hands"] = int(cs["hands"]) + 1
		return str(R.CMD["hands"]["call"])   # Hands up
	if float((last.get("energy", {}) as Dictionary).get("a_end", 100.0)) < WIND_LINE:   # LiveRound.gd l.418
		cs["rests"] = int(cs["rests"]) + 1
		return str(R.CMD["reset"]["call"])   # Reset = calm
	return str(cs["open"])


## The two boxers who do not grade alike. TELLPLAY1's ten all grade 0-2 commands Poor (stats 52-66, training only adds), so
## the raw ones come from the game's own scouting draw (ProspectGen._draw: a Data.PROSPECTS template, stats +-7, personality
## +-25) and go through TELLPLAY1's route (route(): quick start, sign, hire reid, the book, weeks of TrainingPreview.plan_gain).
## POOR = the woman with the most Poor command grades at week 0 (signed, never trained); GOOD = the woman with the most Good
## after wk_good weeks of an all-round plan (every stat in turn). Draws 1..DRAWS, women only (opponents of their own sex).
static var DRAWS := 300
const ProspectGen := preload("res://scripts/rules/ProspectGen.gd")


static func route(p: Dictionary, wk: int, plan: Array) -> Dictionary:
	var c := Career.quick_start()
	c.seed = 9100; c.first_hour = {}; T.FirstWeek.skip(c)
	c.applicant = p.duplicate(true)
	T.Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"]); T.Sim.hire(c, "reid")
	var coach := float(c.coach.get("rating", 0.0))
	var f: Dictionary = c.fighter().duplicate(true)
	f["w"] = int(p.get("w", 0)); f["l"] = int(p.get("l", 0))
	f["height"] = T.FRAMES[0][0]; f["reach"] = T.FRAMES[0][1]
	f["personality"] = (p.get("personality", {}) as Dictionary).duplicate()
	f.erase("loyalty")
	var bk := T._book(0, str(f.get("style", "")))
	f["moves"] = bk[0]; f["combos"] = bk[1]; f["steps"] = bk[2]
	f["arrows"] = []
	var t := {"name": str(f["name"]), "sex": str(f.get("sex", "f")), "style": str(f.get("style", "")), "f": f, "night0": T.DebutOpp.night(f["stats"])}
	return train(t, plan, wk, coach)


static func _mean(f: Dictionary) -> float:
	var vals := R.LiveRound.values(f)
	var s := 0.0
	for c in R.FIGHT:
		s += float(R.cgrade(str(c), vals)["mean"])
	return s / float(R.FIGHT.size())


static var PICK := [0, 0]   # [poor draw, good draw]: set from a stage=pop search (0 = search 1..DRAWS)
static var PICKED := [0, 0]


static func build_extra(taken: Array, wk_good: int) -> Array:
	var bp: Dictionary = {}
	var bps := -1.0
	var bg: Dictionary = {}
	var bgs := -1.0
	var ns: Array = range(1, DRAWS + 1) if int(PICK[0]) == 0 else [int(PICK[0]), int(PICK[1])]
	for n in ns:
		var p := ProspectGen._draw(n, 5470 + n * 13, T.Data.PROSPECTS)
		if str(p.get("sex", "")) != "f" or taken.has(str(p["name"])):
			continue
		var t0 := route(p, 0, ALL_ROUND)
		var sp := float(_count(R.trained_cmd(t0["f"]), "Poor")) - _mean(t0["f"]) / 1000.0
		if sp > bps and (int(PICK[0]) == 0 or n == int(PICK[0])):
			bps = sp; bp = t0; PICKED[0] = n
		var tg := route(p, wk_good, ALL_ROUND)
		var sg := float(_count(R.trained_cmd(tg["f"]), "Good")) + _mean(tg["f"]) / 1000.0
		if sg > bgs and str(tg["name"]) != str(bp.get("name", "")) and (int(PICK[1]) == 0 or n == int(PICK[1])):
			bgs = sg; bg = tg; PICKED[1] = n
	bp["name"] = "%s (raw, week 0)" % str(bp["name"])
	bg["name"] = "%s (all-round, week %d)" % [str(bg["name"]), wk_good]
	return [bp, bg]


static func _count(d: Dictionary, word: String) -> int:
	var n := 0
	for k in d:
		n += 1 if str(d[k]) == word else 0
	return n


## TELLPLAY1's training loop (T.build_types l.278-283) from week-0 stats, for wk weeks of plan (a different history).
static func train(t: Dictionary, plan: Array, wk: int, coach: float) -> Dictionary:
	var out: Dictionary = t.duplicate(true)
	var f: Dictionary = out["f"]
	var st: Dictionary = (f["stats"] as Dictionary).duplicate()
	for w in wk:
		var gain := TrainingPreview.plan_gain(st, int(f.get("pot", 75)), str(plan[w % plan.size()]), coach)
		for k in gain:
			st[k] = float(st[k]) + float(gain[k])
	f["stats"] = st
	return out


## stage=pop: every type's command grades under each history (how the two extra boxers were chosen).
static func pop_table(weeks: Array) -> Array:
	var built: Array = T.build_types(0)
	var out: Array = []
	for t in built[0]:
		for h in [["own", 0]] + weeks.map(func(w): return ["all", int(w)]):
			var tt: Dictionary = train(t, ALL_ROUND, int(h[1]), float(built[1])) if str(h[0]) == "all" else t
			var g := R.trained_cmd(tt["f"])
			out.append({"hist": "%s%d" % [h[0], h[1]], "name": t["name"], "sex": t["sex"], "style": t["style"], "poor": _count(g, "Poor"),
				"ok": _count(g, "OK"), "good": _count(g, "Good"), "grades": g, "stats": tt["f"]["stats"]})
	return out
