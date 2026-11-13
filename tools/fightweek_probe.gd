extends SceneTree
## FIGHTWEEKPROBE1 (S449 brief, Qwen draft, finished by Claude S450): the price of the tank and a flat round 1 in wins, through
## the game's real bout (Bouts.fight_step + LiveRound, the ask_probe2 loop). A measurement only: no rule changes.
## The tank: bout["stale"] = energy off at the first bell (BoutNight._peak skips its own forecast when the key is present, line ~109;
## BoutNight._energy line ~311: a = Combos.TANK - hurt - stale). The flat round 1: LiveRound line ~73 adds BoutRules.stance_edge,
## -NEVER_FACED (0.6) in round 1 when our orthodox boxer meets a southpaw with no partner/lefty week. Each pair's FLAT variant is
## the SAME opponent with stance southpaw (her twin); every other cell is orthodox, so the stance never leaks into the tank curve.
## 0.3 and 1.0 cannot be set without editing NEVER_FACED (a const), so section 2 measures 0.0 and 0.6 only.
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/fightweek_probe.gd -- [nb=400] [seed=4421]
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Career := preload("res://scripts/state/Career.gd")
const TANKS := [0, 4, 8, 12, 16, 20, 25]
## Three matchups, three different boxers (never two identical fighters). Since S398 the duel builds an opponent from her rating
## (AttrGen.attrs_of) and fights it exchange by exchange against our attributes, so a rating gap to BoutRules.fight_power is not a
## win chance (Lucy won ~5 in 100 against "fight power + 0.5"). Each pair's rating is CALIBRATED at tank 0, round 1 sharp, to its
## target win share (EVEN 50, EDGE 70, UNDER 30) and printed; "gap" is only the search's starting point.
const PAIRS := [
	{"tag": "even", "name": "Priya Nair", "gap": 0.5, "target": 50, "style": "Out-boxer", "threat": "Long jab", "weak": "Backs off",
		"w": 6, "l": 2, "height": 170, "reach": 173, "age": 22},
	{"tag": "edge", "name": "Erin Doyle", "gap": -4.0, "target": 70, "style": "Pressure fighter", "threat": "Body hooks", "weak": "Fades late",
		"w": 4, "l": 4, "height": 164, "reach": 165, "age": 25},
	{"tag": "under", "name": "Maria Ortega", "gap": 4.0, "target": 30, "style": "Counter-puncher", "threat": "Right cross", "weak": "Slow start",
		"w": 9, "l": 1, "height": 168, "reach": 171, "age": 24},
]
## The map's three week shapes (AMATEURWEEK1_MAP_V3_S449 section 4): tank at the bell + round 1 flat or sharp.
const SHAPES := [
	{"name": "Rest up", "tank": 0, "flat": true},
	{"name": "Tick over", "tank": 8, "flat": false},
	{"name": "Train through", "tank": 12, "flat": false},
]
var nb := 400
var seed := 4421
var c: Career
var cal := {}   # "<div>|<pair tag>" -> calibrated rating
var probe2 := false   # S450 FIGHTWEEKPROBE2: `probe2=1` prices a flat round 1 at 1.0 / 2.0 / 3.0 through bout["r1_flat"]
var r1_flat := 0.0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2 and kv[0] == "nb":
			nb = int(kv[1])
		elif kv.size() == 2 and kv[0] == "seed":
			seed = int(kv[1])
		elif kv.size() == 2 and kv[0] == "probe2":
			probe2 = kv[1] == "1"
	c = Career.quick_start()
	c.seed = seed
	var t0 := Time.get_ticks_msec()
	var cells := 0
	print("FIGHTWEEKPROBE1 seed=%d nb=%d (bouts a cell)" % [seed, nb])
	_calibrate_all()
	if probe2:
		cells += _p2_flat()
		print("
FIGHTWEEK_PROBE done cells=%d in %ds" % [cells, (Time.get_ticks_msec() - t0) / 1000])
		quit(0)
		return
	cells += _s1_tank()
	cells += _s2_r1()
	cells += _s3_shapes()
	cells += _s4_robust()
	print("\nFIGHTWEEK_PROBE done cells=%d in %ds" % [cells, (Time.get_ticks_msec() - t0) / 1000])
	quit(0)


## Bisection on the opponent's rating (higher rating = fewer wins) at tank 0, sharp, 120 bouts a step, 9 steps.
func _calibrate_all() -> void:
	var base := _ours("wlw")
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("== 0 CALIBRATION (tank 0, round 1 sharp, 120 bouts a step) ==")
	for p in PAIRS:
		_calibrate(base, own, p, "wlw")


func _calibrate(base: Dictionary, own: float, p: Dictionary, div: String) -> void:
	var lo := own - 25.0
	var hi := own + 25.0
	var keep := nb
	nb = 120
	var r := own
	var got := 0
	for i in 9:
		r = (lo + hi) * 0.5
		cal[div + "|" + str(p["tag"])] = r
		got = int(_cell(base, _opp(p, own, false, div), 7777777 + i * 1000, 0)["win"])
		if got > int(p["target"]):
			lo = r
		else:
			hi = r
	nb = keep
	print("CAL pair=%s %s rating=%.1f (our fight power %.1f, gap %+.1f) win~%d target=%d" % [p["tag"], p["name"], r, own, r - own, got, p["target"]])


## FIGHTWEEKPROBE2: a flat round 1 at 1.0 / 2.0 / 3.0 (bout["r1_flat"]), then the three shapes with the flat at 2.0.
func _p2_flat() -> int:
	var base := _ours("wlw")
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("== P2 FLAT ROUND 1 through bout[\"r1_flat\"] (tank 0, orthodox opponents) ==")
	var cells := 0
	for pi in PAIRS.size():
		var opp := _opp(PAIRS[pi], own, false, "wlw")
		for fl in [0.0, 1.0, 2.0, 3.0]:
			r1_flat = fl
			var s := _cell(base, opp, seed * 100000 + 60000 + pi * 1000, 0)
			print("P2 flat=%.1f pair=%s win=%d r1_won=%d" % [fl, PAIRS[pi]["tag"], s["win"], s["r1"]])
			cells += 1
	print("
== P2 SHAPES with Rest up flat at 2.0 (tank 0 / 8 / 12) ==")
	for pi in PAIRS.size():
		var opp := _opp(PAIRS[pi], own, false, "wlw")
		var row := "P2 SHAPES pair=%s" % PAIRS[pi]["tag"]
		for sh in [["Rest up", 0, 2.0], ["Tick over 6", 6, 0.0], ["Tick over 8", 8, 0.0], ["Train through", 12, 0.0]]:
			r1_flat = float(sh[2])
			var s := _cell(base, opp, seed * 100000 + 80000 + pi * 1000, int(sh[1]))
			row += " | %s %d" % [sh[0], s["win"]]
			cells += 1
		print(row)
	r1_flat = 0.0
	return cells


func _s1_tank() -> int:
	var base := _ours("wlw")
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("== 1 TANK PRICE CURVE (Lucy, wlw, fight power %.1f; all orthodox, round 1 sharp) ==" % own)
	var cells := 0
	for pi in PAIRS.size():
		var opp := _opp(PAIRS[pi], own, false, "wlw")
		print("pair %s: %s rating %.1f (target %d in 100)" % [PAIRS[pi]["tag"], opp["name"], float(opp["rating"]), int(PAIRS[pi]["target"])])
		for t in TANKS:
			var s := _cell(base, opp, seed * 100000 + pi * 10000 + int(t) * 100, int(t))
			print("TANK off=%d pair=%s win=%d stoppage_won=%d stoppage_lost=%d r3_lost=%d" % [t, PAIRS[pi]["tag"], s["win"], s["sw"], s["sl"], s["r3l"]])
			cells += 1
	return cells


func _s2_r1() -> int:
	var base := _ours("wlw")
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("\n== 2 ROUND-1 PRICE (tank 0; edge 0.6 = the same opponent as a southpaw; 0.3 and 1.0 not settable without a rule edit) ==")
	var cells := 0
	for pi in PAIRS.size():
		for flat in [false, true]:
			var opp := _opp(PAIRS[pi], own, flat, "wlw")
			var s := _cell(base, opp, seed * 100000 + 50000 + pi * 1000, 0)
			print("R1 edge=%.1f pair=%s win=%d r1_won=%d" % [0.6 if flat else 0.0, PAIRS[pi]["tag"], s["win"], s["r1"]])
			cells += 1
	return cells


func _s3_shapes() -> int:
	var base := _ours("wlw")
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("\n== 3 THE THREE WEEK SHAPES ==")
	var cells := 0
	for pi in PAIRS.size():
		var lo := 101
		var hi := -1
		var best := ""
		for sh in SHAPES:
			var opp := _opp(PAIRS[pi], own, bool(sh["flat"]), "wlw")
			var s := _cell(base, opp, seed * 100000 + 70000 + pi * 1000, int(sh["tank"]))
			print("SHAPE %s pair=%s win=%d" % [sh["name"], PAIRS[pi]["tag"], s["win"]])
			cells += 1
			if int(s["win"]) > hi:
				hi = int(s["win"])
				best = str(sh["name"])
			lo = mini(lo, int(s["win"]))
		print("  pair=%s best=%s spread best-worst=%d" % [PAIRS[pi]["tag"], best, hi - lo])
	return cells


func _s4_robust() -> int:
	print("\n== 4 ROBUSTNESS: seeds 4421-4423 (even + under, tank 0/8/12/25, flat round 1) and the men's lightweight ==")
	var base := _ours("wlw")
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	var cells := 0
	for pi in [0, 2]:
		for key in ["0", "8", "12", "25", "flat"]:
			var line := "SEEDS pair=%s %s" % [PAIRS[pi]["tag"], ("tank=" + key) if key != "flat" else "flat_r1"]
			var lo := 101
			var hi := -1
			for sd in [4421, 4422, 4423]:
				var flat: bool = key == "flat"
				var opp := _opp(PAIRS[pi], own, flat, "wlw")
				var s := _cell(base, opp, int(sd) * 100000 + 90000 + pi * 1000, 0 if flat else int(key))
				line += " s%d=%d" % [sd, s["win"]]
				lo = mini(lo, int(s["win"]))
				hi = maxi(hi, int(s["win"]))
				cells += 1
			print(line + " spread=%d" % (hi - lo))
	var men := _ours("mlw")
	var own_m := BoutRules.fight_power(men["stats"], {}, 0, "")
	var mp := {"tag": "mlw_even", "name": "Dean Clarke", "gap": 0.5, "style": "Counter-puncher", "threat": "Times the jab",
		"weak": "Slow start", "w": 6, "l": 3, "height": 176, "reach": 180, "age": 23}
	mp["target"] = 50
	_calibrate(men, own_m, mp, "mlw")
	var opp_m := _opp(mp, own_m, false, "mlw")
	print("men's lightweight: %s (power %.1f) vs %s rating %.1f" % [men["name"], own_m, opp_m["name"], float(opp_m["rating"])])
	for t in [0, 8, 12, 25]:
		var s := _cell(men, opp_m, seed * 100000 + 99000 + int(t) * 100, int(t))
		print("TANK off=%d pair=mlw_even win=%d stoppage_lost=%d" % [t, s["win"], s["sl"]])
		cells += 1
	var flat_m := _opp(mp, own_m, true, "mlw")
	print("R1 edge=0.6 pair=mlw_even win=%d r1_won=%d" % [_cell(men, flat_m, seed * 100000 + 99500, 0)["win"], _cell(men, flat_m, seed * 100000 + 99500, 0)["r1"]])
	cells += 1
	return cells


## nb bouts; percentages of nb.
func _cell(base: Dictionary, opp: Dictionary, dice0: int, tank: int) -> Dictionary:
	var w := 0
	var sw := 0
	var sl := 0
	var r3l := 0
	var r1 := 0
	for bi in nb:
		var r := _fight(base, opp, dice0 + bi, tank)
		if bool(r["won"]):
			w += 1
			if bool(r["stopped"]):
				sw += 1
		elif bool(r["stopped"]):
			sl += 1
		else:
			r3l += 1
		if bool(r["r1_won"]):
			r1 += 1
	return {"win": w * 100 / nb, "sw": sw * 100 / nb, "sl": sl * 100 / nb, "r3l": r3l * 100 / nb, "r1": r1 * 100 / nb}


## One real bout (ask_probe2 pattern): the corner's auto call between rounds, the shout path inside each live round.
func _fight(base: Dictionary, opp: Dictionary, dice: int, tank: int) -> Dictionary:
	var keep: Array = c.fighters
	var g: Dictionary = base.duplicate(true)
	c.day = 200000 + dice
	c.fighters = [g]
	g["camp"] = {}
	g["morale"] = 60.0
	g["notes_seen"] = []
	g["injury"] = {}
	g["ko_history"] = []
	g["offers"] = []
	g["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1, "stale": float(tank), "hurt": 0.0, "r1_flat": r1_flat}
	var m := {"fid": g["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, g, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, g, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(g) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, g, m, "corner:" + BoutRules.auto_corner(g["stats"]))
	var stopped := Bouts.stopped(m) != ""
	Bouts.fight_step(c, g, m, "end")
	var won := str(m.get("outcome", "")) == "win"
	var ra: Array = m.get("rounds", [])
	var r1w := not ra.is_empty() and bool((ra[0] as Dictionary).get("won", false))
	c.results.clear()
	c.fighters = keep
	return {"won": won, "stopped": stopped, "r1_won": r1w}


func _ours(div: String) -> Dictionary:
	var raw: Dictionary = Data.lucy() if div == "wlw" else _first_of(div)
	var f: Dictionary = Data.fighter_state(raw, c.day)
	f["stance"] = "orthodox"
	return f


func _first_of(div: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str((p as Dictionary).get("div", "")) == div:
			return p
	return Data.PROSPECTS[0]


## The pair's opponent; flat = her southpaw twin (only the stance differs).
func _opp(p: Dictionary, own: float, flat: bool, div: String) -> Dictionary:
	var o := {"name": str(p["name"]), "first": str(p["name"]).get_slice(" ", 0), "club": "Visitor ABC", "age": int(p["age"]),
		"stance": "southpaw" if flat else "orthodox", "style": str(p["style"]), "w": int(p["w"]), "l": int(p["l"]),
		"height": int(p["height"]), "reach": int(p["reach"]), "rating": float(cal.get(div + "|" + str(p["tag"]), own + float(p["gap"]))), "threat": str(p["threat"]),
		"weak": str(p["weak"]), "div": div}
	return o
