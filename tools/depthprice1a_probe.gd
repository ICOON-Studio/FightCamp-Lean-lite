extends SceneTree
## DEPTHPRICE1A (S534, DEPTH_SCOPE_S534 change 1; brief ops/research/TASK_DEPTHPRICE1A.md): a PRICE for each of the four solved
## fight-night choices, measured on a greybox before any critic or build. MEASUREMENT ONLY: nothing under scripts/ is touched.
## Every punch, round and result is the game's (Bouts.fight_step + LiveRound, BoutNight.outcome_of, as tools/pushprobe2.gd and
## tools/partner_probe.gd play it). Each price is a flagged local rule laid on top; arms = today (control) and priced. Paired
## dice: bout i of a cell plays on the same career day under every option and both arms.
##   row=pace     27 Push / Steady / Save      price: Push spends more wind (PX push_spend), Save loses its flat refill
##   row=corner   30 the corner minute          price: every job (talk, habit fix) costs one of the second's 3 points
##   row=week     21 the fight week's load stop price: Train through keeps its tiredness (carried into the next fight week)
##   row=partner  22 the sparring partner       price: a closer partner is a harder night (the night's tank by the match)
## Bars (DEPTH_SCOPE_S534): an informed pick beats the laziest by 3+ wins in 100, and no option is best in more than 6 of 10 cells.
##   python ops/Tools/godot_slot.py run --who depthprice1a -- <godot> --headless --audio-driver Dummy --path . \
##     --script res://tools/depthprice1a_probe.gd -- row=pace n=300 [push_spend=2.2 save_refill=0]
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")
const Aftermath := preload("res://scripts/rules/Aftermath.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const Report := preload("res://tools/depthprice1a_report.gd")

## ---- the prices (PX). The control arm runs on TODAY: every value below is the game's own number. ----
const TODAY := {"push_spend": 1.35, "save_refill": 6.0, "job_points": 0, "water_x": 1.0, "rest_edge": 0.0, "tt_tank": 12.0, "tt_after": 6.0, "tick_after": 0.0,
	"close_tank": 3.0, "part_tank": 3.0, "loose_tank": 3.0}
var px := {"push_spend": 2.2, "save_refill": 0.0, "job_points": 1, "water_x": 1.0, "rest_edge": 0.0, "tt_tank": 12.0, "tt_after": 14.0, "tick_after": 0.0,
	"close_tank": 8.0, "part_tank": 5.0, "loose_tank": 3.0}
## ---- probe-only modelling numbers (ESTIMATE, named; none is a price) ----
const WEEK_BOUTS := 4            # the week row: four weekly amateur bouts in a row (S428: a bout 1 to 2 weeks out)
const WEEK_GAIN := 12.0          # mastery a full week of pads puts on ONE drilled line (CLAUDE.md: a weapon, 30, in 2-3 weeks)
const DAYS_BETWEEN := 7
const ARROWS := ["1-2", "3b-3", "1-1-2"]   # the plan of tools/partner_probe.gd
const MASTERY := [70.0, 40.0, 65.0]
## The styled opponents of tools/pushprobe2_rules.gd (fictional, probe-only): [style, threat, weak].
const OPPS := {"even": ["Boxer-puncher", "Straight right", "Stands still after combinations"],
	"body": ["Pressure fighter", "Left hook to the body", "Leaves the chin open"],
	"mover": ["Out-boxer", "Long jab, keeps you on the end of it", "Backs straight onto the ropes"],
	"slow": ["Counter-puncher", "Right hand counter over the jab", "Slow to start"],
	"fader": ["Boxer-puncher", "Straight right", "Fades after round 2"],
	"swarmer": ["Swarmer", "Never stops throwing", "Leaves the chin open"],
	"volume": ["Volume puncher", "Never stops throwing", "Leaves the chin open"]}
const RING_CELLS := [{"id": "even"}, {"id": "body", "opp": "body"}, {"id": "mover", "opp": "mover"}, {"id": "slow", "opp": "slow"},
	{"id": "fader", "opp": "fader"}, {"id": "swarmer", "opp": "swarmer"}, {"id": "volume", "opp": "volume"},
	{"id": "cut20", "stale": 20.0}, {"id": "underdog", "off": 5.0}, {"id": "favourite", "off": -5.0}]
## The three calibrated matchups of tools/fightweek_probe.gd / partner_probe.gd (three different boxers).
const PAIRS := {
	"even": {"name": "Priya Nair", "target": 50, "style": "Out-boxer", "threat": "Long jab", "weak": "Backs off", "w": 6, "l": 2, "height": 170, "reach": 173, "age": 22},
	"edge": {"name": "Erin Doyle", "target": 70, "style": "Pressure fighter", "threat": "Body hooks", "weak": "Fades late", "w": 4, "l": 4, "height": 164, "reach": 165, "age": 25},
	"under": {"name": "Maria Ortega", "target": 30, "style": "Counter-puncher", "threat": "Right cross", "weak": "Slow start", "w": 9, "l": 1, "height": 168, "reach": 171, "age": 24}}
const WEEK_CELLS := [["even", 20, "near"], ["even", 20, "far"], ["even", 35, "near"], ["even", 35, "far"], ["edge", 20, "near"],
	["edge", 35, "near"], ["edge", 35, "far"], ["under", 20, "near"], ["under", 20, "far"], ["under", 35, "near"]]
const MAST_START := {"near": [24.0, 52.0, 40.0], "far": [35.0, 65.0, 45.0]}
const PARTNER_CELLS := [["even", 35, 3], ["even", 45, 1], ["even", 55, 3], ["even", 60, 1], ["even", 70, 3],
	["edge", 35, 1], ["edge", 55, 1], ["edge", 60, 3], ["under", 45, 3], ["under", 70, 1]]
const POLS := {"pace": ["steady", "push", "push45", "push55", "p5s1", "push_r1", "push_r3", "push_close"],
	"corner_today": ["none", "water3", "ice_first", "need3", "all_water3", "all_need3"],
	"corner_priced": ["water3", "need3", "talk_water", "fix_water", "talk_fix", "coach"],
	"week": ["rest", "tick", "through", "card", "coach"], "partner": ["none", "loose", "part", "close"]}
const LAZY := {"pace": "steady", "corner_today": "water3", "corner_priced": "water3", "week": "tick", "partner": "loose"}

var row := "pace"
var n := 300
var arms: Array = ["today", "priced"]
var c: Career
var base_f: Array = []
var cal := {}
var agg := {}
var pilot := false


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() != 2:
			continue
		if kv[0] == "row":
			row = kv[1]
		elif kv[0] == "n":
			n = int(kv[1])
		elif kv[0] == "arms":
			arms = Array(kv[1].split(","))
		elif kv[0] == "pilot":
			pilot = kv[1] == "1"
		elif px.has(kv[0]):
			px[kv[0]] = float(kv[1])
	c = Career.quick_start()
	base_f = [Data.fighter_state(Data.lucy(), c.day), Data.fighter_state(_jo(), c.day)]
	(base_f[1] as Dictionary)["personality"] = (base_f[1]["personality"] as Dictionary).merged({"temper": 70.0, "discipline": 40.0}, true)
	for f in base_f:
		f["morale"] = 60.0
		print("DP1A POP %s (%s, %s) fight power %.1f personality %s habits %s" % [f["name"], f["style"], f["stance"],
			BoutRules.fight_power(f["stats"], {}, 0, ""), str(f.get("personality", {})), str(f.get("habits", []))])
	print("DP1A row=%s n=%d arms=%s PX=%s TODAY=%s" % [row, n, str(arms), str(px), str(TODAY)])
	var t0 := Time.get_ticks_msec()
	var bouts := 0
	match row:
		"pace", "corner":
			print("DP1A POP opponents: two a cell (A orthodox at our fight power + the cell's offset, B southpaw +1.5), styled by cell; 3 rounds; bout i: our fighter i%2, opponent (i/2)%2, day 20+i")
			for cl in RING_CELLS:
				for i in n:
					for arm in arms:
						for pol in _pols(arm):
							_add(arm, str(cl["id"]), pol, _ring_bout(arm, pol, cl, i))
							bouts += 1
		"week", "partner":
			_calibrate_all()
			var cells: Array = WEEK_CELLS if row == "week" else PARTNER_CELLS
			for ci in cells.size():
				for i in n:
					for arm in arms:
						for pol in _pols(arm):
							if row == "week":
								for o in _week_run(arm, pol, cells[ci], ci, i):
									_add(arm, _cid(cells[ci]), pol, o)
									bouts += 1
							else:
								_add(arm, _cid(cells[ci]), pol, _partner_bout(arm, pol, cells[ci], ci, i))
								bouts += 1
	var secs := (Time.get_ticks_msec() - t0) / 1000.0
	print("DP1A WALL %.0f s, %d bouts, %.1f ms a bout" % [secs, bouts, secs * 1000.0 / maxf(1.0, bouts)])
	for arm in arms:
		Report.report(agg, row, str(arm), _pols(str(arm)), _lazy(str(arm)), "TODAY" if str(arm) == "today" else "PRICED " + str(px), WEEK_BOUTS if row == "week" else 1)
	quit(0)


func _pols(arm: String) -> Array:
	return POLS["corner_" + arm] if row == "corner" else POLS[row]


func _lazy(arm: String) -> String:
	return str(LAZY["corner_" + arm]) if row == "corner" else str(LAZY[row])


func _p(arm: String, key: String) -> float:
	return float(px[key]) if arm == "priced" else float(TODAY[key])


func _cid(cl: Array) -> String:
	return "%s_%s_%s" % [cl[0], cl[1], cl[2]]


func _jo() -> Dictionary:   # our second fighter (pushprobe2): a southpaw boxer-puncher, never Lucy's numbers
	return Data.lucy().merged({"id": "jo", "name": "Jo Brennan", "first": "Jo", "stance": "southpaw", "style": "Boxer-puncher",
		"stats": {"power": 61.5, "speed": 59.0, "technique": 57.5, "defense": 58.5, "conditioning": 64.5, "fight_iq": 57.0, "chin": 62.0}}, true)


func _add(arm: String, cid: String, pol: String, o: Dictionary) -> void:
	var key := "%s|%s|%s" % [arm, cid, pol]
	if not agg.has(key):
		agg[key] = {"out": PackedByteArray(), "wind": 0.0, "x": 0.0}
	var g: Dictionary = agg[key]
	var ob: PackedByteArray = g["out"]
	ob.append(2 if o["out"] == "win" else (1 if o["out"] == "draw" else 0))
	g["out"] = ob
	g["wind"] = float(g["wind"]) + float(o.get("tank_end", 0.0))
	g["x"] = float(g["x"]) + float(o.get("x", 0.0))


## ---- rows 27 and 30: one 3-round bout against a styled opponent ----
func _ring_bout(arm: String, pol: String, cl: Dictionary, i: int) -> Dictionary:
	c.day = 20 + i
	var f: Dictionary = (base_f[i % 2] as Dictionary).duplicate(true)
	var oi := (i / 2) % 2
	var w: Array = OPPS[str(cl.get("opp", "even"))]
	var o: Dictionary = (Data.OPPONENTS[oi] as Dictionary).duplicate(true)
	o.merge({"name": "%s %s" % [["Ana", "Bea"][oi], cl["id"]], "first": ["Ana", "Bea"][oi], "style": w[0], "threat": w[1], "weak": w[2],
		"stance": "orthodox" if oi == 0 else "southpaw", "rating": BoutRules.fight_power(f["stats"], {}, 0, "") + float(cl.get("off", 0.0)) + 1.5 * oi}, true)
	f["bout"] = {"opp": o, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": 3, "stale": float(cl.get("stale", 0.0))}
	var st := {"arm": arm, "pace": pol if row == "pace" else "steady", "corner": pol if row == "corner" else "water3",
		"jobs": int(_p(arm, "job_points")) if row == "corner" else 0}
	return _fight(f, st)


## One bout on the game's own loop. st: arm, pace (policy), corner (policy), jobs (points a corner job costs).
func _fight(f: Dictionary, st: Dictionary) -> Dictionary:
	c.fighters = [f]
	f["camp"] = {}
	f["notes_seen"] = []
	f["injury"] = {}
	f["round_pace"] = []
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	st["seen"] = 0
	st["rseen"] = 0
	st["drop"] = 0.0
	st["x"] = 0.0
	_open_pace(f, m, st, 1)
	Bouts.fight_step(c, f, m, "start")
	_after(st, f, m)
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			var want := _pace(str(st["pace"]), _seen(f, m))
			Bouts.fight_step(c, f, m, "shout:" + ("|pace=" + want if want != str(lv["pace"]) else ""))
			_after(st, f, m)
		if int(m["round"]) >= 3 or Bouts.stopped(m) != "":
			break
		_open_pace(f, m, st, int(m["round"]) + 1)
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]) + _jobs(st, f, m))
		var lvn := LiveRound.live(m)   # the corner re-size: a water point worth water_x times the game's (the round it is given for, as the game)
		if row == "corner" and not lvn.is_empty() and _p(str(st["arm"]), "water_x") != 1.0:
			var more := (_p(str(st["arm"]), "water_x") - 1.0) * float((lvn.get("did", {}) as Dictionary).get("energy", 0.0))
			lvn["e"]["a"] = float(lvn["e"]["a"]) + more
			lvn["e"]["a_end"] = float(lvn["e"]["a_end"]) + more
		_after(st, f, m)
	var rounds: Array = m["rounds"]
	var out := BoutNight.outcome_of(f, m)
	var e: Dictionary = (rounds[-1] as Dictionary).get("energy", {})
	return {"out": out, "tank_end": float(e.get("a_end", 0.0)), "stopped_loss": Bouts.stopped(m) != "" and out == "loss", "x": float(st["x"])}


func _seen(f: Dictionary, m: Dictionary) -> Dictionary:
	var lv := LiveRound.live(m)
	var fb: Dictionary = f["bout"]
	if lv.is_empty():
		var en: Dictionary = fb.get("energy", {"a": 100.0 - float(fb.get("stale", 0.0))})
		return {"n": int(m.get("round", 0)) + 1, "i": 0, "wind": float(en["a"]), "ex_w": 0, "ex_l": 0}
	var exs: Array = lv["ex"]
	var s := {"n": int(lv["n"]), "i": exs.size(), "wind": RingDuel.her_energy(lv, exs.size()), "ex_w": 0, "ex_l": 0}
	for x in exs:
		s["ex_w"] += 1 if bool(x["won"]) else 0
		s["ex_l"] += 0 if bool(x["won"]) else 1
	return s


func _pace(pol: String, s: Dictionary) -> String:
	var wind := float(s["wind"])
	match pol:
		"push":
			return "push"
		"push45":
			return "push" if wind > 45.0 else "steady"
		"push55":
			return "push" if wind > 55.0 else "steady"
		"p5s1":
			return "save" if int(s["i"]) == 5 else "push"
		"push_r1":
			return "push" if int(s["n"]) == 1 else "steady"
		"push_r3":
			return "push" if int(s["n"]) == 3 else "steady"
		"push_close":
			return "push" if int(s["i"]) >= 2 and absi(int(s["ex_w"]) - int(s["ex_l"])) <= 1 else "steady"
	return "steady"


func _open_pace(f: Dictionary, m: Dictionary, st: Dictionary, rn: int) -> void:
	var s := _seen(f, m)
	s["n"] = rn
	f["round_pace"] = PlanFile.set_pace([], rn, _pace(str(st["pace"]), s))


## The PRICE of row 27, laid on the game's own exchange: Push's extra wind (push_spend against the game's 1.35) and Save's
## flat refill taken back (save_refill against the game's 6). The trick is pushprobe2's: lv["cost"], and the bell's records.
func _after(st: Dictionary, f: Dictionary, m: Dictionary) -> void:
	var lv := LiveRound.live(m)
	var rounds: Array = m.get("rounds", [])
	var closed := rounds.size() > int(st["rseen"])
	var exs: Array = (rounds[-1] as Dictionary)["exchanges"] if closed else lv.get("ex", [])
	var arm := str(st["arm"])
	for j in range(int(st["seen"]), exs.size()):
		var x: Dictionary = exs[j]
		var last := closed and j == exs.size() - 1
		if not last:
			var e: Dictionary = lv["e"]
			st["drop"] = maxf(0.0, float(e["a"]) - float(e["a_end"])) / 6.0
		var back := 0.0
		if str(x["pace"]) == "push":
			back = float(st["drop"]) * (_p(arm, "push_spend") - float(PaceAim.PACE_SPEND["push"]))
		elif str(x["pace"]) == "save":
			back = PaceAim.SAVE_RECOVER - _p(arm, "save_refill")
		if back == 0.0 or row != "pace":
			continue
		if last:
			var fb: Dictionary = f["bout"]
			fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - back, 0.0, 100.0)
			var r: Dictionary = rounds[-1]
			for k in ["a_end", "a_end_calls"]:
				r["energy"][k] = maxf(0.0, float(r["energy"].get(k, 0.0)) - back)
		else:
			lv["cost"] = float(lv["cost"]) + back
	st["seen"] = 0 if closed else exs.size()
	if closed:
		st["rseen"] = int(st["rseen"]) + 1


## The corner minute's jobs for the next round. RECOVER has the game's 3 points; with jobs > 0 (the PRICE of row 30) the talk
## and the habit fix each take that many of the same 3.
func _jobs(st: Dictionary, f: Dictionary, m: Dictionary) -> String:
	var pol := str(st["corner"])
	if pol == "none":
		return "|rec=water:0"
	var last: Dictionary = (m["rounds"] as Array)[-1]
	var hurt := bool(last.get("hurt_at_bell", false))
	var body := int((f["bout"].get("body", {}) as Dictionary).get("a", 0))
	var wind := float((last["energy"] as Dictionary).get("a_end", 100.0))
	var talk := ""
	var talk_edge := 0.0
	for k in CornerJobs.TALKS:
		var e := float(CornerJobs.talk(str(k), f.get("personality", {}))["edge"])
		if e > talk_edge:
			talk_edge = e
			talk = str(k)
	var fix := ""
	var paid := 0
	for h in LiveRound.fixes(f, last):
		if int(h["paid"]) > paid:
			paid = int(h["paid"])
			fix = str(h["id"])
	var want_talk := pol in ["talk_water", "talk_fix", "all_water3", "all_need3"]
	var want_fix := pol in ["fix_water", "talk_fix", "all_water3", "all_need3"]
	var need := pol in ["need3", "all_need3", "coach"]
	if pol == "coach":   # reads the minute: a paid habit first, the talk when it is worth 1.5, never when she is hurt or empty
		want_fix = paid >= 2
		want_talk = talk_edge >= 1.5 and not hurt and wind >= CornerJobs.WEARY_AT
	var left := CornerJobs.RECOVER_POINTS
	var cost := int(st["jobs"])
	var out := ""
	if want_fix and fix != "" and left >= cost:
		out += "|fix=" + fix
		left -= cost
	if want_talk and talk != "" and left >= cost:
		out += "|talk=" + talk
		left -= cost
		st["x"] = float(st["x"]) + 1.0
	var head := 1 if hurt and (need or pol == "ice_first") and left > 0 else 0
	left -= head
	var ice := mini(left, body / CornerJobs.ICE_HITS) if (need or pol == "ice_first") else 0
	left -= ice
	return out + "|rec=water:%d,ice:%d,head:%d" % [left, ice, head]


## ---- rows 21 and 22: the calibrated pairs, Lucy with a three-line plan ----
func _plan_f(mast: Array) -> Dictionary:
	var g: Dictionary = (base_f[0] as Dictionary).duplicate(true)
	g["stance"] = "orthodox"
	g["combos"] = {}
	g["arrows"] = []
	for k in ARROWS.size():
		var cid := str(StrikeMap.move(ARROWS[k]).get("combo", ""))
		if cid != "":
			g["combos"][cid] = float(mast[k])
		g["arrows"].append({"move": ARROWS[k]})
	g["ko_history"] = []
	g["offers"] = []
	return g


func _pair_opp(tag: String) -> Dictionary:
	var p: Dictionary = PAIRS[tag]
	return {"name": str(p["name"]), "first": str(p["name"]).get_slice(" ", 0), "club": "Visitor ABC", "age": int(p["age"]), "stance": "orthodox",
		"style": str(p["style"]), "w": int(p["w"]), "l": int(p["l"]), "height": int(p["height"]), "reach": int(p["reach"]),
		"rating": float(cal.get(tag, 58.0)), "threat": str(p["threat"]), "weak": str(p["weak"]), "div": "wlw"}


func _plan_bout(mast: Array, tag: String, day: int, keys: Dictionary) -> Dictionary:
	var g := _plan_f(mast)
	c.day = day
	g["bout"] = {"opp": _pair_opp(tag), "day": day, "weighed": true, "made": true, "done": false, "film": 1, "hurt": 0.0}
	(g["bout"] as Dictionary).merge(keys, true)
	return _fight(g, {"arm": "today", "pace": "steady", "corner": "water3", "jobs": 0})


func _calibrate_all() -> void:
	var own := BoutRules.fight_power((base_f[0] as Dictionary)["stats"], {}, 0, "")
	for tag in PAIRS:
		var lo := own - 25.0
		var hi := own + 25.0
		var got := 0.0
		for step in 9:
			cal[tag] = (lo + hi) * 0.5
			var w := 0
			for b in 120:
				w += 1 if _plan_bout(MASTERY, tag, 7777777 + step * 1000 + b, {"stale": 0.0, "unsparred": []})["out"] == "win" else 0
			got = w / 1.2
			if got > float(PAIRS[tag]["target"]):
				lo = float(cal[tag])
			else:
				hi = float(cal[tag])
		print("DP1A CAL pair=%s %s rating=%.1f (our fight power %.1f) win~%.0f target=%d" % [tag, PAIRS[tag]["name"], float(cal[tag]), own, got, int(PAIRS[tag]["target"])])


## Row 21: WEEK_BOUTS weekly bouts on one habit. cl = [pair, the week's training tiredness, mastery start]. The stop sets the
## tank and round 1 (FightWeek, the game's rules); the week banks BANK_SHARE of WEEK_GAIN on her lowest line; tiredness
## carries: the bout's toll (Aftermath.toll) rested DAYS_BETWEEN days at Aftermath.REST_KEEP, plus the week's training,
## plus what the stop adds after the bell (the PRICE: tt_after against the game's 6).
func _week_run(arm: String, pol: String, cl: Array, ci: int, i: int) -> Array:
	var load := float(cl[1])
	var tired := 28.0 + load
	var mast: Array = (MAST_START[str(cl[2])] as Array).duplicate()
	var outs: Array = []
	for k in WEEK_BOUTS:
		var t := int(round(tired))
		var stop := _stop(pol, t, mast)
		var keys := {"stale": float(FightWeek.tank(t, stop, [], false)["off"]), "r1_edge": float(FightWeek.round_one(t, stop)["edge"]), "unsparred": []}
		if stop == "rest_up" and _p(arm, "rest_edge") != 0.0:   # the re-size: Rest up is flat at every tiredness (the game: -2 / -1 / 0 by band)
			keys["r1_edge"] = _p(arm, "rest_edge")
		if stop == "train_through":   # the re-size: Train through's tank (the game: FightWeek.STOP_TANK 12)
			keys["stale"] = float(keys["stale"]) + _p(arm, "tt_tank") - float(FightWeek.STOP_TANK["train_through"])
		var o := _plan_bout(mast, str(cl[0]), 300000 + ci * 100000 + i * 10 + k, keys)
		var low := 0
		for q in mast.size():
			if float(mast[q]) < float(mast[low]):
				low = q
		mast[low] = minf(100.0, float(mast[low]) + WEEK_GAIN * float(FightWeek.BANK_SHARE[stop]))
		var bell := float(FightWeek.REST_UP_TIRED_TO) if stop == "rest_up" else tired
		var toll := Aftermath.toll(bell, float(o["tank_end"]), bool(o["stopped_loss"]))
		var after := _p(arm, "tt_after") if stop == "train_through" else (_p(arm, "tick_after") if stop == "tick_over" else 0.0)
		tired = clampf(toll * pow(Aftermath.REST_KEEP, DAYS_BETWEEN) + load + after, 0.0, 100.0)
		o["x"] = float(t)
		outs.append(o)
	return outs


func _stop(pol: String, tired: int, mast: Array) -> String:
	match pol:
		"rest":
			return "rest_up"
		"through":
			return "train_through"
		"card":   # the line printed on each stop (FightWeek.BEST_WHEN): Rest up from 65, else Tick over
			return "rest_up" if tired >= 65 else "tick_over"
		"coach":   # Rest up when tired, Train through when fresh and a line is one full week from its next level, else Tick over
			if tired >= 60:
				return "rest_up"
			var lowest := 100.0
			for v in mast:
				lowest = minf(lowest, float(v))
			var to_line := (FireLevel.USABLE_AT if lowest < FireLevel.USABLE_AT else (FireLevel.SHARP_AT if lowest < FireLevel.SHARP_AT else FireLevel.SIGNATURE_AT)) - lowest
			return "train_through" if tired <= 50 and to_line <= WEEK_GAIN else "tick_over"
	return "tick_over"


## Row 22: one bout. cl = [pair, start tiredness, lines unsparred]. The stop is the card's (Tick over under 65, else Rest
## up); one sparring night 7 days out. The match sets the lines readied and the rounds 1-2 edge (PartnerMatch, the game's);
## the PRICE: the night's tank by the match (close_tank / part_tank / loose_tank against the game's flat 3).
func _partner_bout(arm: String, pol: String, cl: Array, ci: int, i: int) -> Dictionary:
	var t := int(cl[1])
	var stop := "rest_up" if t >= 65 else "tick_over"
	var word := pol.to_upper()
	var tank := float(FightWeek.tank(t, stop, [], false)["off"])
	var ready := 0
	var edge := 0.0
	if pol != "none":
		tank += _p(arm, pol + "_tank")
		ready = int(PartnerMatch.LINES[word])
		edge = float(PartnerMatch.EDGE[word])
	var keys := {"stale": tank, "r1_edge": float(FightWeek.round_one(t, stop)["edge"]), "spar_edge": edge,
		"unsparred": ARROWS.slice(0, int(cl[2])).slice(ready)}
	return _plan_bout(MASTERY, str(cl[0]), 500000 + ci * 100000 + i, keys)
