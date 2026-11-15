extends SceneTree
## PARTNERPROBE1 (task brief, S480): what a close sparring partner is worth on fight night, in wins.
## A measurement only: no rule changes. The probe copies the bout loop from tools/fightweek_probe.gd
## (Career.quick_start, the three calibrated PAIRS, the bout loop, the seeds).
##
## The arms (each the SAME boxer, opponent and seeds; only these keys differ):
##   NONE:    r1_edge 0.0, unsparred = all three ids
##   LOOSE:   r1_edge 0.0, unsparred = the last two ids (the night readied 1)
##   PART:    r1_edge 0.5, unsparred = the last one id (readied 2)
##   CLOSE:   r1_edge 1.0, unsparred = [] (readied all 3)
##   EDGE_ONLY: r1_edge 1.0, unsparred = all three ids (control to split the two effects)
##   LINES_ONLY: r1_edge 0.0, unsparred = [] (control)
##
## The plan's three arrows: one combination at Sharp (70), one at Usable (40), one at Sharp (65).
## All three are "changed since she last sparred" (unsparred) before the night in the NONE arm.
##
##   <godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/partner_probe.gd -- [nb=400] [seed=4801]
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Career := preload("res://scripts/state/Career.gd")
const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

## Three matchups, three different boxers (never two identical fighters). Same as fightweek_probe.gd.
const PAIRS := [
	{"tag": "even", "name": "Priya Nair", "gap": 0.5, "target": 50, "style": "Out-boxer", "threat": "Long jab", "weak": "Backs off",
		"w": 6, "l": 2, "height": 170, "reach": 173, "age": 22},
	{"tag": "edge", "name": "Erin Doyle", "gap": -4.0, "target": 70, "style": "Pressure fighter", "threat": "Body hooks", "weak": "Fades late",
		"w": 4, "l": 4, "height": 164, "reach": 165, "age": 25},
	{"tag": "under", "name": "Maria Ortega", "gap": 4.0, "target": 30, "style": "Counter-puncher", "threat": "Right cross", "weak": "Slow start",
		"w": 9, "l": 1, "height": 168, "reach": 171, "age": 24},
]
## The plan's three arrows (move ids). Chosen to cover the cards each opponent creates most:
##   ARROWS[0] = "1-2" (long card, answers "range" and "counter") - at Sharp 70
##   ARROWS[1] = "3b-3" (mid card, answers "press" as ok) - at Usable 40
##   ARROWS[2] = "1-1-2" (outside card, answers "counter") - at Sharp 65
## Order matters: the first arrow is the first to be readied by the sparring night.
## Note: Lucy's starting punches are Jab 51, Cross 45, Lead hook 37, Body hook 30, Uppercut 0, Check hook 0.
## So she can throw 1-2, 1-1, 1-1-2, 2-3, 3b-3, 1-2-3b but NOT slip 2-3 or 1-6-3.
const ARROWS := ["1-2", "3b-3", "1-1-2"]
const MASTERY := [70.0, 40.0, 65.0]
## The arms: each sets r1_edge and unsparred (the move ids not readied).
const ARMS := [
	{"name": "NONE", "edge": 0.0, "unsparred": [0, 1, 2]},
	{"name": "LOOSE", "edge": 0.0, "unsparred": [1, 2]},
	{"name": "PART", "edge": 0.5, "unsparred": [2]},
	{"name": "CLOSE", "edge": 1.0, "unsparred": []},
	{"name": "EDGE_ONLY", "edge": 1.0, "unsparred": [0, 1, 2]},
	{"name": "LINES_ONLY", "edge": 0.0, "unsparred": []},
]

var nb := 400
var seed := 4801
var edge_key := "r1_edge"   # S482: "spar_edge" = the partner edge over rounds 1-2 (BoutRules.spar_edge)
var edge_x := 1.0   # S482: scales every arm's round-1 edge (a tuning run of PartnerMatch.EDGE)
var c: Career
var cal := {}   # "<div>|<pair tag>" -> calibrated rating


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2 and kv[0] == "nb":
			nb = int(kv[1])
		elif kv.size() == 2 and kv[0] == "key":
			edge_key = str(kv[1])
		elif kv.size() == 2 and kv[0] == "edge_x":
			edge_x = float(kv[1])
		elif kv.size() == 2 and kv[0] == "seed":
			seed = int(kv[1])
	c = Career.quick_start()
	c.seed = seed
	var t0 := Time.get_ticks_msec()
	print("PARTNERPROBE1 seed=%d nb=%d (bouts a cell)" % [seed, nb])
	print("ARROWS=%s mastery=%s" % [str(ARROWS), str(MASTERY)])
	_calibrate_all()
	_check_arrows()
	_run_all()
	print("\nPARTNERPROBE1 done in %ds" % ((Time.get_ticks_msec() - t0) / 1000))
	quit(0)


## Bisection on the opponent's rating (higher rating = fewer wins) at tank 0, round 1 sharp, 120 bouts a step, 9 steps.
func _calibrate_all() -> void:
	var base := _ours()
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("== CALIBRATION (tank 0, round 1 sharp, 120 bouts a step) ==")
	for p in PAIRS:
		_calibrate(base, own, p)


func _calibrate(base: Dictionary, own: float, p: Dictionary) -> void:
	var lo := own - 25.0
	var hi := own + 25.0
	var keep := nb
	nb = 120
	var r := own
	var got := 0
	for i in 9:
		r = (lo + hi) * 0.5
		cal[str(p["tag"])] = r
		got = int(_cell(base, _opp(p, own), 7777777 + i * 1000, _arm_dict("NONE"))["win"])
		if got > int(p["target"]):
			lo = r
		else:
			hi = r
	nb = keep
	print("CAL pair=%s %s rating=%.1f (our fight power %.1f, gap %+.1f) win~%d target=%d" % [p["tag"], p["name"], r, own, r - own, got, p["target"]])


## Before the full run: print how many times each arrow was picked in rounds 1-2 in 50 bouts of NONE arm.
## With 3 arrows on 3 different cards and ~12 exchanges in rounds 1-2, each arrow can be picked at most
## ~4 times on average (if its card comes up every exchange). A realistic threshold is >= 1.0 per bout.
func _check_arrows() -> void:
	var base := _ours()
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("\n== ARROW CHECK (50 bouts, NONE arm, rounds 1-2 picks) ==")
	var check_nb := 50
	var keep := nb
	nb = check_nb
	for pi in PAIRS.size():
		var opp := _opp(PAIRS[pi], own)
		var counts := {ARROWS[0]: 0, ARROWS[1]: 0, ARROWS[2]: 0}
		for bi in check_nb:
			var picks := _fight_picks(base, opp, seed * 100000 + pi * 10000 + bi, _arm_dict("NONE"))
			for arrow_id in picks:
				if counts.has(arrow_id):
					counts[arrow_id] = int(counts[arrow_id]) + 1
		var line := "PAIR %s:" % PAIRS[pi]["tag"]
		for arrow_id in ARROWS:
			var avg := float(counts[arrow_id]) / float(check_nb)
			line += " %s=%.1f" % [arrow_id, avg]
		print(line)
		for arrow_id in ARROWS:
			var avg := float(counts[arrow_id]) / float(check_nb)
			if avg < 1.0:
				print("  WARNING: %s picked %.1f times/bout (need >= 1.0)" % [arrow_id, avg])
	nb = keep


## Run all pairs x arms and print results.
func _run_all() -> void:
	var base := _ours()
	var own := BoutRules.fight_power(base["stats"], {}, 0, "")
	print("\n== MAIN RUN (nb=%d bouts a cell) ==" % nb)
	var results := {}   # "pair|arm" -> {win, n}
	for pi in PAIRS.size():
		var opp := _opp(PAIRS[pi], own)
		for arm in ARMS:
			var arm_name: String = str(arm["name"])
			var arm_d := _arm_dict(arm_name)
			var s := _cell(base, opp, seed * 100000 + pi * 1000, arm_d)   # S482: SAME dice for every arm (paired); the arm used to change the seed
			results[str(PAIRS[pi]["tag"]) + "|" + arm_name] = s
			print("PARTNER pair=%s arm=%s wins=%d of=%d win=%d moves=%s" % [
				PAIRS[pi]["tag"], arm_name, s["win"], nb, s["win"], ",".join(ARROWS)])
	# Deltas per pair
	print("\n== DELTAS ==")
	var close_v_loose_sum := 0.0
	var part_v_loose_sum := 0.0
	var edge_only_sum := 0.0
	var lines_only_sum := 0.0
	var deltas: Array = []
	for pi in PAIRS.size():
		var tag: String = str(PAIRS[pi]["tag"])
		var none_w: int = int(results[tag + "|NONE"]["win"])
		var loose_w: int = int(results[tag + "|LOOSE"]["win"])
		var part_w: int = int(results[tag + "|PART"]["win"])
		var close_w: int = int(results[tag + "|CLOSE"]["win"])
		var edge_only_w: int = int(results[tag + "|EDGE_ONLY"]["win"])
		var lines_only_w: int = int(results[tag + "|LINES_ONLY"]["win"])
		var cvl := close_w - loose_w
		var pvl := part_w - loose_w
		var eo := edge_only_w - none_w
		var lo := lines_only_w - none_w
		close_v_loose_sum += float(cvl)
		part_v_loose_sum += float(pvl)
		edge_only_sum += float(eo)
		lines_only_sum += float(lo)
		deltas.append(cvl)
		deltas.append(pvl)
		print("PARTNER_DELTA pair=%s close_v_loose=%d part_v_loose=%d edge_only=%d lines_only=%d" % [tag, cvl, pvl, eo, lo])
	# Summary
	var n_pairs := float(PAIRS.size())
	var cvl_mean := close_v_loose_sum / n_pairs
	var pvl_mean := part_v_loose_sum / n_pairs
	# 1 s.d. of a delta in 100: for a binomial, var(win) = n*p*(1-p), var(diff) = 2*n*p*(1-p) for paired
	# Use the observed deltas to estimate
	var mean_d := 0.0
	for d in deltas:
		mean_d += float(d)
	mean_d /= float(deltas.size())
	var sum_sq := 0.0
	for d in deltas:
		sum_sq += (float(d) - mean_d) * (float(d) - mean_d)
	sum_sq /= float(deltas.size())
	var sd_d := sqrt(sum_sq)
	# Gate: CLOSE beats LOOSE by 3 to 5 wins in 100 on the mean of the three pairs, and PART sits between them.
	var gate_ok = (cvl_mean >= 3.0) and (cvl_mean <= 5.0) and (pvl_mean >= 0.0) and (pvl_mean <= float(cvl_mean))
	var gate_pass := 0
	if gate_ok:
		gate_pass = 1
	var why := "close_v_loose=%.1f (gate 3-5) part_v_loose=%.1f (between 0 and close_v_loose)" % [cvl_mean, pvl_mean]
	if gate_pass == 0:
		why += " FAIL"
	print("\nPARTNERPROBE1 close_v_loose=%.1f part_v_loose=%.1f dice=%.1f pass=%d why=%s" % [cvl_mean, pvl_mean, sd_d, gate_pass, why])


## Build the arm dict with r1_edge and unsparred.
func _arm_dict(arm_name: String) -> Dictionary:
	for arm in ARMS:
		if str(arm["name"]) == arm_name:
			var unsparred_ids: Array = []
			for idx in arm["unsparred"]:
				unsparred_ids.append(ARROWS[int(idx)])
			return {edge_key: float(arm["edge"]) * edge_x, "unsparred": unsparred_ids}
	return {"r1_edge": 0.0, "unsparred": ARROWS.duplicate()}


## nb bouts; percentages of nb.
func _cell(base: Dictionary, opp: Dictionary, dice0: int, arm: Dictionary) -> Dictionary:
	var w := 0
	for bi in nb:
		var r := _fight(base, opp, dice0 + bi, 0, arm)
		if bool(r["won"]):
			w += 1
	return {"win": w * 100 / nb}


## One real bout (ask_probe2 pattern): the corner's auto call between rounds, the shout path inside each live round.
func _fight(base: Dictionary, opp: Dictionary, dice: int, tank: int, arm: Dictionary) -> Dictionary:
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
	# Set up the combos mastery
	g["combos"] = {}
	for i in ARROWS.size():
		var row := StrikeMap.move(ARROWS[i])
		var combo_id: String = str(row.get("combo", ""))
		if combo_id != "":
			g["combos"][combo_id] = MASTERY[i]
	# Set up the plan arrows
	g["arrows"] = []
	for arrow_id in ARROWS:
		g["arrows"].append({"move": arrow_id})
	g["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1,
		"stale": float(tank), "hurt": 0.0, "r1_edge": float(arm.get("r1_edge", 0.0)), "spar_edge": float(arm.get("spar_edge", 0.0)),
		"unsparred": (arm.get("unsparred", []) as Array).duplicate()}
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
	c.results.clear()
	c.fighters = keep
	return {"won": won}


## Same as _fight but returns the arrows picked in rounds 1-2.
func _fight_picks(base: Dictionary, opp: Dictionary, dice: int, arm: Dictionary) -> Array:
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
	g["combos"] = {}
	for i in ARROWS.size():
		var row := StrikeMap.move(ARROWS[i])
		var combo_id: String = str(row.get("combo", ""))
		if combo_id != "":
			g["combos"][combo_id] = MASTERY[i]
	g["arrows"] = []
	for arrow_id in ARROWS:
		g["arrows"].append({"move": arrow_id})
	g["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1,
		"stale": 0.0, "hurt": 0.0, "r1_edge": float(arm.get("r1_edge", 0.0)), "spar_edge": float(arm.get("spar_edge", 0.0)),
		"unsparred": (arm.get("unsparred", []) as Array).duplicate()}
	var m := {"fid": g["id"], "step": "tape", "total": 3}
	var picks: Array = []
	Bouts.fight_step(c, g, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			var n := int(lv.get("n", 0))
			var i := int((lv.get("ex", []) as Array).size())
			# Track arrows in rounds 1-2
			if n <= 2:
				Bouts.fight_step(c, g, m, "shout:")
				# After the exchange, check what arrow was picked
				var exs: Array = LiveRound.live(m).get("ex", [])
				if exs.size() > i:
					var last_ex: Dictionary = exs[i]
					var arrow := str(last_ex.get("arrow", ""))
					if arrow != "" and not picks.has(arrow):
						picks.append(arrow)
			else:
				Bouts.fight_step(c, g, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(g) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, g, m, "corner:" + BoutRules.auto_corner(g["stats"]))
	Bouts.fight_step(c, g, m, "end")
	c.results.clear()
	c.fighters = keep
	return picks


func _ours() -> Dictionary:
	var raw: Dictionary = Data.lucy()
	var f: Dictionary = Data.fighter_state(raw, c.day)
	f["stance"] = "orthodox"
	return f


## The pair's opponent (orthodox, never the southpaw twin - this probe measures partner match, not stance).
func _opp(p: Dictionary, own: float) -> Dictionary:
	var o := {"name": str(p["name"]), "first": str(p["name"]).get_slice(" ", 0), "club": "Visitor ABC", "age": int(p["age"]),
		"stance": "orthodox", "style": str(p["style"]), "w": int(p["w"]), "l": int(p["l"]),
		"height": int(p["height"]), "reach": int(p["reach"]), "rating": float(cal.get(str(p["tag"]), own + float(p["gap"]))),
		"threat": str(p["threat"]), "weak": str(p["weak"]), "div": "wlw"}
	return o
