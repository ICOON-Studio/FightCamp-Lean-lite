extends SceneTree
## TURNPROBE17 (S542, ops/research/TASK_TURNPRO17.md): the GREYBOX probe of turning pro v17 (DESIGN_TURNPRO1_V17.md), run
## BEFORE any critic. Measurement only: nothing under scripts/ changes. Rules: tools/turnprobe17_rules.gd. The win chance
## of every bout is the GAME'S read (DebutRead.card: the same walk of the bout the pro offer prints), the boxer's weeks of
## training are the game's (TrainingPreview.plan_gain with the gym's coach), the gaps, purse and rest are the game's
## constants (ProLadder, Roster, Matchmaking). TEN boxer types (5 women, 5 men), each against their own sex and class.
## ARMS: SAFE (turn now, safe x6), RISKY (turn now, risky x6), WAIT (Not yet twice, then safe x6), ALT (turn now, safe /
## risky in turn), READER (plans on the printed chances, the boxer's chin and the two bars; no hidden number).
## Args (after --): stage=trial|full reps=2000 out=<jsonl>.

const DebutRead := preload("res://scripts/rules/DebutRead.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProLean := preload("res://scripts/state/ProLean.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Data := preload("res://scripts/state/Data.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const R := preload("res://tools/turnprobe17_rules.gd")

const ARMS := ["safe", "risky", "wait", "alt", "reader"]
const HABITS := ["safe", "risky", "wait", "alt"]
const MAX_WEEK := 120
const GONE_PLAN := 40.0      ## the reader's planner: losing the boxer costs about this much standing (a typical score)
const WAIT_MARGIN := 0.5     ## the reader says Not yet only when waiting plans better by this much
var types: Array = []
var pools := {}
var raw_cache := {}
var dp_cache := {}
var coach := 0.0
var out_path := ""
var t0 := 0


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


func _person(base: Dictionary, over: Dictionary) -> Dictionary:
	var p := base.duplicate(true)
	p.merge(over, true)
	return p


## The ten types: Data's six (Lucy and the five prospects) and four more, each a different style, frame, plan and potential.
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
	return ps


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
			"rec": "%d-%d" % [int(f["w"]), int(f["l"])], "frame": FRAMES[i], "keys": (f.keys() as Array).size()})


## The game's read of type ti at week wk against a man of this rating.
func _read_at(ti: int, wk: int, rating: float) -> float:
	var ty: Dictionary = types[ti]
	var f: Dictionary = (ty["f"] as Dictionary).duplicate()
	f["stats"] = ty["stats_at"][mini(wk, MAX_WEEK)]
	var gap := DebutOpp.night(f["stats"]) - rating
	return float(DebutRead.card(f, {"opp_gap": gap, "name": "probe17"}, 0, coach)["win"])


## Each sex's pools: the SAFE man is the one the game's tune-up aims at (ProLadder.TUNE_AIM) for that sex's middle boxer at
## the offer; the RISKY man the game's step up (ProLadder.STEP_READ). Fixed ratings: a better boxer reads higher against the
## same men, and the band then holds the printed chance inside 75-90 / 40-55.
func _pools() -> void:
	for sex in ["f", "m"]:
		var idx: Array = []
		for i in types.size():
			if types[i]["sex"] == sex:
				idx.append(i)
		idx.sort_custom(func(a, b): return float(types[a]["night0"]) < float(types[b]["night0"]))
		var mid: int = idx[idx.size() / 2]
		var n0 := float(types[mid]["night0"])
		pools[sex] = {"mid": types[mid]["name"], "safe": _solve(mid, n0, ProLadder.TUNE_AIM), "risky": _solve(mid, n0, ProLadder.STEP_READ)}


func _solve(ti: int, n0: float, want: float) -> float:
	var lo := n0 - 15.0
	var hi := n0 + 15.0   # a higher rating = a harder man = a lower read
	for _i in 24:
		var m := (lo + hi) * 0.5
		if _read_at(ti, 0, m) > want:
			lo = m
		else:
			hi = m
	return snappedf((lo + hi) * 0.5, 0.01)


func raw(ti: int, wk: int, kind: String, fight: int) -> float:
	var key := "%d|%d|%s|%d" % [ti, wk, kind, fight]
	if not raw_cache.has(key):
		var rating := float(pools[types[ti]["sex"]][kind]) + R.OPP_RISE * float(fight - 1)
		raw_cache[key] = _read_at(ti, wk, rating)
	return raw_cache[key]


## ---------- the READER's planner: printed chances, the boxer's chin, the two bars (no hidden number) ----------
## V[i][conf/2][hunger][warnings] = the best expected standing still to come, the chances held as printed today.
func _idx(i: int, c: int, h: int, w: int) -> int:
	return ((i * 51 + c / 2) * 101 + h) * 3 + w


func _q(V: PackedFloat32Array, ti: int, rs: float, rr: float, i: int, c: int, h: int, kind: String) -> float:
	var raw_k := rs if kind == "safe" else rr
	var p := R.shown(raw_k, kind, c)
	var ko := R.ko_share(float(types[ti]["chin"]), kind)
	var risky := kind == "risky"
	var hr := int(R.HUNGER["risky"]) if risky else 0
	var w_name := R.NAME_RISKY if risky else R.NAME_SAFE
	var cw := clampi(c + int(R.CONF[kind + "_win"]), 0, 100)
	var hw := clampi(h + (hr if risky else int(R.HUNGER["safe_win"])), 0, 100)
	var cp := clampi(c + int(R.CONF["points_loss"]), 0, 100)
	var hp := clampi(h + hr, 0, 100)
	var ck := clampi(c + int(R.CONF["ko_loss"]), 0, 100)
	var hk := clampi(h + hr + int(R.HUNGER["idle_4w"]) * int(R.MM.STOP_REST_WEEKS / 4), 0, 100)
	var pay := R.SCORE_GYM * float(R.purse(_wins, kind)) * Roster.GYM_SHARE   # paid win or lose
	return pay + p * (R.SCORE_W + R.SCORE_NAME * w_name + V[_idx(i + 1, cw, hw, _w)]) \
		+ (1.0 - p) * (1.0 - ko) * (R.SCORE_L + V[_idx(i + 1, cp, hp, _w)]) \
		+ (1.0 - p) * ko * (R.SCORE_L + V[_idx(i + 1, ck, hk, _w)])

var _w := 0
var _wins := 0   ## the planner holds the purse at today's step of the ladder, as it holds the chances


func _plan(ti: int, rs: float, rr: float) -> PackedFloat32Array:
	var key := "%d|%d|%d|%d" % [ti, roundi(rs * 50.0), roundi(rr * 50.0), _wins]
	if dp_cache.has(key):
		return dp_cache[key]
	rs = roundi(rs * 50.0) / 50.0
	rr = roundi(rr * 50.0) / 50.0
	var n := ProLean.LEAN_FIGHTS
	var V := PackedFloat32Array()
	V.resize((n + 1) * 51 * 101 * 3)
	for c in range(0, 101, 2):
		for h in 101:
			for w in 3:
				V[_idx(n, c, h, w)] = -GONE_PLAN if (h <= 0 and w + 1 > R.WARNINGS) else R.SCORE_CONF * float(c - 50)
	for i in range(n - 1, -1, -1):
		for c in range(0, 101, 2):
			for h in 101:
				for w in 3:
					var w2 := w
					if i >= 1 and h <= 0:
						w2 = w + 1
						if w2 > R.WARNINGS:
							V[_idx(i, c, h, w)] = -GONE_PLAN
							continue
					_w = w2
					V[_idx(i, c, h, w)] = maxf(_q(V, ti, rs, rr, i, c, h, "safe"), _q(V, ti, rs, rr, i, c, h, "risky"))
	dp_cache[key] = V
	return V


func _reader_kind(ti: int, wk: int, k: int, s: Dictionary) -> String:
	var rs := raw(ti, wk, "safe", k)
	var rr := raw(ti, wk, "risky", k)
	_wins = mini(int(s["w"]), 3)
	var V := _plan(ti, rs, rr)
	_w = int(s["warn"])
	var c := int(s["conf"]) - int(s["conf"]) % 2
	var h := int(s["hunger"])
	_w = int(s["warn"])
	return "risky" if _q(V, ti, roundi(rs * 50.0) / 50.0, roundi(rr * 50.0) / 50.0, k - 1, c, h, "risky") > _q(V, ti, roundi(rs * 50.0) / 50.0, roundi(rr * 50.0) / 50.0, k - 1, c, h, "safe") else "safe"


## The pop-up prints fight 1's two chances today and the trainer's forecast for four weeks on (the game's own training read).
func _reader_waits(ti: int, s: Dictionary) -> bool:
	_wins = 0
	var wk := int(s["week"]) + Roster.PRO_DEBUT_WEEKS
	var now := _plan(ti, raw(ti, wk, "safe", 1), raw(ti, wk, "risky", 1))[_idx(0, int(s["conf"]) - int(s["conf"]) % 2, int(s["hunger"]), 0)]
	var wk2 := wk + R.NOT_YET_WEEKS
	var h2 := clampi(int(s["hunger"]) + R.NOT_YET_HUNGER, 0, 100)
	var later := _plan(ti, raw(ti, wk2, "safe", 1), raw(ti, wk2, "risky", 1))[_idx(0, int(s["conf"]) - int(s["conf"]) % 2, h2, 0)]
	return later > now + WAIT_MARGIN


## ---------- one career ----------
func play(ti: int, arm: String, rng: RandomNumberGenerator, trace: bool) -> Dictionary:
	var s := R.new_state()
	var lines: Array = []
	if arm == "wait":
		while R.not_yet(s):
			pass
	elif arm == "reader":
		while int(s["patience"]) > 1 and _reader_waits(ti, s):
			R.not_yet(s)
	s["week"] = int(s["week"]) + Roster.PRO_DEBUT_WEEKS
	s["max_shift"] = 0.0
	s["f6_gap"] = 0.0
	for k in range(1, ProLean.LEAN_FIGHTS + 1):
		if k > 1:
			R.booking_check(s)
			if bool(s["gone"]):
				break
		var wk := int(s["week"])
		var kind := "safe"
		match arm:
			"risky": kind = "risky"
			"alt": kind = "safe" if k % 2 == 1 else "risky"
			"reader": kind = _reader_kind(ti, wk, k, s)
		var rw := raw(ti, wk, kind, k)
		var p := R.shown(rw, kind, int(s["conf"]))
		var p50 := R.shown(rw, kind, 50)
		s["max_shift"] = maxf(float(s["max_shift"]), absf(p - p50))
		if k == ProLean.LEAN_FIGHTS:
			s["f6_gap"] = p - p50
		var outcome := "win"
		if rng.randf() >= p:
			outcome = "ko" if rng.randf() < R.ko_share(float(types[ti]["chin"]), kind) else "points"
		if k >= 4:
			s["late_n"] = int(s["late_n"]) + 1
			s["late_w"] = int(s["late_w"]) + int(outcome == "win")
		R.after_fight(s, kind, outcome, Roster.GYM_SHARE)
		if trace:
			lines.append("%d %s wk%d raw %.2f shown %.2f %s conf %d hunger %d" % [k, kind, wk, rw, p, outcome, int(s["conf"]), int(s["hunger"])])
	if not bool(s["gone"]):
		R.booking_check(s)   # the booking after fight 6: the normal booking's first call
	s["score"] = R.score(s)
	s["parts"] = R.score_parts(s)
	if trace:
		s["log"] = lines
	return s


## ---------- run and bars ----------
func _initialize() -> void:
	t0 = Time.get_ticks_msec()
	var stage := _arg("stage", "trial")
	var reps := int(_arg("reps", "1" if stage == "trial" else "2000"))
	out_path = _arg("out", "")
	R.conf0 = int(_arg("conf0", "50"))   # S546: the start of the confidence bar (the amateur record's read)
	_build_types()
	_pools()
	var pop: Array = []
	for i in types.size():
		var ty: Dictionary = types[i]
		pop.append("%d %s (%s, %s, %s, %s, age %d, pot %d, %s, frame %s, plan %s, chin %.0f, night %.1f; read safe %.2f risky %.2f at the offer, %.2f / %.2f 8 weeks on)" % [
			i, ty["name"], ty["sex"], ty["div"], ty["style"], ty["stance"], ty["age"], ty["pot"], ty["rec"], str(ty["frame"]), "/".join(ty["plan"]), ty["chin"], ty["night0"],
			raw(i, Roster.PRO_DEBUT_WEEKS, "safe", 1), raw(i, Roster.PRO_DEBUT_WEEKS, "risky", 1), raw(i, Roster.PRO_DEBUT_WEEKS + 8, "safe", 1), raw(i, Roster.PRO_DEBUT_WEEKS + 8, "risky", 1)])
	_say({"tag": "run", "stage": stage, "reps": reps, "coach": coach, "pools": pools, "population": pop, "arms": ARMS,
		"game": {"tune_aim": ProLadder.TUNE_AIM, "step_read": ProLadder.STEP_READ, "next_weeks": R.MM.NEXT_WEEKS, "stop_rest": R.MM.STOP_REST_WEEKS,
			"debut_weeks": Roster.PRO_DEBUT_WEEKS, "lean_fights": ProLean.LEAN_FIGHTS, "gym_share": Roster.GYM_SHARE, "purse": Roster.PRO_PURSE},
		"t_setup": (Time.get_ticks_msec() - t0) / 1000.0})
	var agg := {}
	for ti in types.size():
		for arm in ARMS:
			var rng := RandomNumberGenerator.new()
			rng.seed = hash("%d|%s|17" % [ti, "dice"])   # the same dice stream for every arm of a type
			var a := {"n": 0, "sum": 0.0, "sq": 0.0, "kept": 0.0, "wins": 0.0, "losses": 0.0, "name": 0.0, "conf": 0.0, "W": 0, "L": 0, "KO": 0, "nm": 0,
				"gone": 0, "purse": 0, "gym": 0, "safe": 0, "risky": 0, "not_yet": 0, "conf_end": 0, "hun_end": 0, "hun_fight": [0, 0, 0, 0, 0, 0], "hun_fight_n": [0, 0, 0, 0, 0, 0],
				"gym_pts": 0.0, "worst_run": 0, "late_ko_w": 0, "late_ko_n": 0, "late_ok_w": 0, "late_ok_n": 0, "max_shift": 0.0, "f6_gap": 0.0,
				"conf_lo": 100, "conf_hi": 0, "hun_lo": 100, "hun_hi": 0, "careers_lost_fight": 0}
			for r in reps:
				var s := play(ti, arm, rng, stage == "trial")
				if stage == "trial":
					_say({"tag": "career", "type": types[ti]["name"], "arm": arm, "score": s["score"], "parts": s["parts"], "W": s["w"], "L": s["l"], "KO": s["ko"],
						"name": s["name"], "conf": s["conf"], "hunger": s["hunger"], "warn": s["warn"], "gone": s["gone"], "not_yet": s["not_yet"],
						"purse": s["purse"], "gym": s["gym"], "fights": s["log"]})
				a["n"] += 1; a["sum"] += float(s["score"]); a["sq"] += float(s["score"]) * float(s["score"])
				for pk in ["kept", "wins", "losses", "name", "conf", "gym"]:
					a["p_" + pk] = float(a.get("p_" + pk, 0.0)) + float(s["parts"][pk])
				a["W"] += int(s["w"]); a["L"] += int(s["l"]); a["KO"] += int(s["ko"]); a["nm"] += int(s["name"]); a["gone"] += int(bool(s["gone"]))
				a["purse"] += int(s["purse"]); a["gym"] += int(s["gym"]); a["safe"] += int(s["safe"]); a["risky"] += int(s["risky"]); a["not_yet"] += int(s["not_yet"])
				a["conf_end"] += int(s["conf"]); a["hun_end"] += int(s["hunger"]); a["careers_lost_fight"] += int(int(s["l"]) > 0)
				for j in (s["hunger_by_fight"] as Array).size():
					a["hun_fight"][j] += int(s["hunger_by_fight"][j]); a["hun_fight_n"][j] += 1
				a["worst_run"] = maxi(int(a["worst_run"]), int(s["worst_run"]))
				var tag := "late_ko_" if bool(s["ko_early"]) else "late_ok_"
				a[tag + "w"] += int(s["late_w"]); a[tag + "n"] += int(s["late_n"])
				a["max_shift"] = maxf(float(a["max_shift"]), float(s["max_shift"])); a["f6_gap"] = maxf(float(a["f6_gap"]), absf(float(s["f6_gap"])))
				a["conf_lo"] = mini(int(a["conf_lo"]), int(s["conf_lo"])); a["conf_hi"] = maxi(int(a["conf_hi"]), int(s["conf_hi"]))
				a["hun_lo"] = mini(int(a["hun_lo"]), int(s["hun_lo"])); a["hun_hi"] = maxi(int(a["hun_hi"]), int(s["hun_hi"]))
			agg["%d|%s" % [ti, arm]] = a
			_say({"tag": "cell", "type": ti, "who": types[ti]["name"], "arm": arm, "agg": _brief(a), "t": (Time.get_ticks_msec() - t0) / 1000.0})
	_bars(agg)
	print("TURNPROBE17 done: stage %s, %d reps, %.1f s" % [stage, reps, (Time.get_ticks_msec() - t0) / 1000.0])
	quit(0)


func _brief(a: Dictionary) -> Dictionary:
	var n := float(a["n"])
	var m := float(a["sum"]) / n
	var sd := sqrt(maxf(0.0, float(a["sq"]) / n - m * m))
	var hf: Array = []
	for j in 6:
		hf.append(snappedf(float(a["hun_fight"][j]) / maxf(1.0, float(a["hun_fight_n"][j])), 0.1))
	return {"n": a["n"], "score": snappedf(m, 0.01), "se": snappedf(sd / sqrt(n), 0.001),
		"parts": {"kept": snappedf(float(a["p_kept"]) / n, 0.001), "wins": snappedf(float(a["p_wins"]) / n, 0.01), "losses": snappedf(float(a["p_losses"]) / n, 0.01),
			"name": snappedf(float(a["p_name"]) / n, 0.01), "conf": snappedf(float(a["p_conf"]) / n, 0.01), "gym": snappedf(float(a["p_gym"]) / n, 0.01)},
		"W": snappedf(float(a["W"]) / n, 0.01), "L": snappedf(float(a["L"]) / n, 0.01), "KO": snappedf(float(a["KO"]) / n, 0.01), "name_pts": snappedf(float(a["nm"]) / n, 0.01),
		"gone": snappedf(float(a["gone"]) / n, 0.001), "purse": roundi(float(a["purse"]) / n), "gym": roundi(float(a["gym"]) / n),
		"safe": snappedf(float(a["safe"]) / n, 0.01), "risky": snappedf(float(a["risky"]) / n, 0.01), "not_yet": snappedf(float(a["not_yet"]) / n, 0.01),
		"conf_end": snappedf(float(a["conf_end"]) / n, 0.1), "hun_end": snappedf(float(a["hun_end"]) / n, 0.1), "hun_by_fight": hf,
		"worst_run": a["worst_run"], "never_lost": 1.0 - float(a["careers_lost_fight"]) / n,
		"late_win_ko_early": snappedf(float(a["late_ko_w"]) / maxf(1.0, float(a["late_ko_n"])), 0.001), "late_n_ko_early": a["late_ko_n"],
		"late_win_no_ko": snappedf(float(a["late_ok_w"]) / maxf(1.0, float(a["late_ok_n"])), 0.001), "late_n_no_ko": a["late_ok_n"],
		"max_shift": snappedf(float(a["max_shift"]), 0.0001), "f6_gap": snappedf(float(a["f6_gap"]), 0.0001),
		"conf_range": [a["conf_lo"], a["conf_hi"]], "hunger_range": [a["hun_lo"], a["hun_hi"]]}


const LOST := 0.20   ## a type "loses the boxer" under an arm when 20% or more of its careers end with the boxer gone


func _bars(agg: Dictionary) -> void:
	var nt := types.size()
	var best_count := {}
	var best_by_type: Array = []
	var reader_beats := 0
	var waits: Array = []
	var nevers: Array = []
	var lost_safe: Array = []
	var lost_wait: Array = []
	var lost_reader: Array = []
	var rs := 0.0
	var rr := 0.0
	var ko_d := 0.0
	var ko_wsum := 0.0
	var ko_var := 0.0
	var shift_max := 0.0
	var conf_lo := 100
	var conf_hi := 0
	var hun_lo := 100
	var hun_hi := 0
	for ti in nt:
		var best := ""
		var bm := -1e9
		for arm in ARMS:
			var b := _brief(agg["%d|%s" % [ti, arm]])
			if float(b["score"]) > bm:
				bm = float(b["score"]); best = arm
			shift_max = maxf(shift_max, float(b["max_shift"]))
			conf_lo = mini(conf_lo, int(b["conf_range"][0])); conf_hi = maxi(conf_hi, int(b["conf_range"][1]))
			hun_lo = mini(hun_lo, int(b["hunger_range"][0])); hun_hi = maxi(hun_hi, int(b["hunger_range"][1]))
			if arm in ["risky", "alt", "reader"]:
				var n1 := float(b["late_n_ko_early"])
				var n2 := float(b["late_n_no_ko"])
				if n1 >= 30 and n2 >= 30:
					var p1 := float(b["late_win_ko_early"])
					var p2 := float(b["late_win_no_ko"])
					var wgt := n1
					ko_d += wgt * (p2 - p1); ko_wsum += wgt
					ko_var += wgt * wgt * (p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2)
		best_by_type.append(best)
		best_count[best] = int(best_count.get(best, 0)) + 1
		var rb := _brief(agg["%d|reader" % ti])
		var beats := true
		for h in HABITS:
			var hb := _brief(agg["%d|%s" % [ti, h]])
			if float(rb["score"]) - float(hb["score"]) <= 2.0 * sqrt(pow(float(rb["se"]), 2) + pow(float(hb["se"]), 2)):
				beats = false
		reader_beats += int(beats)
		rs += float(rb["safe"]); rr += float(rb["risky"])
		if float(rb["not_yet"]) >= 0.5:
			waits.append(types[ti]["name"])
		elif float(rb["not_yet"]) < 0.05:
			nevers.append(types[ti]["name"])
		if float(_brief(agg["%d|safe" % ti])["gone"]) >= LOST:
			lost_safe.append(types[ti]["name"])
		if float(_brief(agg["%d|wait" % ti])["gone"]) >= LOST:
			lost_wait.append(types[ti]["name"])
		if float(rb["gone"]) >= LOST:
			lost_reader.append(types[ti]["name"])
	var top_habit := 0
	for h in HABITS:
		top_habit = maxi(top_habit, int(best_count.get(h, 0)))
	var tot := rs + rr
	var lost_either: Array = lost_safe.duplicate()
	for x in lost_wait:
		if not lost_either.has(x):
			lost_either.append(x)
	var ko_mark := ko_d / maxf(1.0, ko_wsum)
	var ko_se := sqrt(ko_var) / maxf(1.0, ko_wsum)
	var bars := {
		"1_no_habit": {"pass": top_habit <= 6, "best_by_type": best_by_type, "count": best_count},
		"2_reader": {"pass": reader_beats >= 5, "types_reader_beats_every_habit": reader_beats},
		"3_both_alive": {"pass": tot > 0 and rs / tot >= 0.25 and rr / tot >= 0.25, "safe_share": snappedf(rs / maxf(1.0, tot), 0.001), "risky_share": snappedf(rr / maxf(1.0, tot), 0.001)},
		"4_waiting": {"pass": waits.size() >= 2 and nevers.size() >= 2, "reader_waits": waits, "reader_never": nevers},
		"5_mistakes": {"pass": lost_either.size() >= 2 and lost_reader.size() <= 1 and ko_mark >= 0.02 and ko_mark > 2.0 * ko_se,
			"lost_safe": lost_safe, "lost_wait": lost_wait, "lost_reader": lost_reader, "ko_mark_late_win_drop": snappedf(ko_mark, 0.001), "ko_mark_se": snappedf(ko_se, 0.001)},
		"6_no_runaway": {"pass": shift_max <= 0.05 + 1e-6 and conf_lo >= 0 and conf_hi <= 100 and hun_lo >= 0 and hun_hi <= 100,
			"max_shift": snappedf(shift_max, 0.0001), "conf": [conf_lo, conf_hi], "hunger": [hun_lo, hun_hi]}}
	var passed := 0
	for k in bars:
		passed += int(bool(bars[k]["pass"]))
	_say({"tag": "bars", "passed": passed, "of": bars.size(), "bars": bars})
