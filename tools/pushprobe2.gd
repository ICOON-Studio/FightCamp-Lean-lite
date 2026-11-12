extends SceneTree
## PUSHPROBE2 (S443, operator Q-S294-203 "Measure now"; brief ops/research/TASK_PUSHPROBE2.md): the fight bars of PUSHTANK map
## v2 measured through the game's REAL bout - Bouts.fight_step + LiveRound + the auto corner, as tools/adapt_probe.gd and
## tools/ask_probe_honest.gd play it. Every punch, round, count and result is the game's; the probe only picks the corner's
## call (pace, the forward dial, a call) and keeps the new bars' sums (tools/pushprobe2_rules.gd). Paired dice: bout i plays on
## career day 20 + i under every arm and policy, so the same seed plays the same bout. The result is BoutNight.outcome_of
## (the game's own verdict); _finish (records, money, news) is not run, so every bout starts from the same career.
## Arms: A today's three paces | B v1's switch (Push on / off, Save -> Breathe) | C HANDS (Coast without the refill, a change is
## a shout) | D HANDS + FEET + LEGS + HEAD per exchange + the opponent's HANDS | E = D + the corner minute in seconds with neck
## ice (operator S443 "yes add it to the measurement"). holdcheck = D's path with its layers off.
##   python ops/Tools/godot_slot.py run --who pushprobe -- <godot> --headless --audio-driver Dummy --path . \
##     --script res://tools/pushprobe2.gd -- n=20 cells=c3_level lens=3,6 arms=A,B,C,D pilot=1
const R := preload("res://tools/pushprobe2_rules.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const Aftermath := preload("res://scripts/rules/Aftermath.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")

var n := 20
var cells: Array = []
var lens: Array = [3, 6]
var arms: Array = ["A", "B", "C", "D", "E"]
var pilot := false
var c: Career
var base_f: Array = []
var agg := {}
var ms := {}


func _initialize() -> void:
	var want := "all"
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() != 2:
			continue
		match kv[0]:
			"n": n = int(kv[1])
			"cells": want = kv[1]
			"lens": lens = Array(kv[1].split(",")).map(func(x): return int(x))
			"arms": arms = Array(kv[1].split(","))
			"pilot": pilot = kv[1] == "1"
	for cl in R.CELLS:
		if want == "all" or (want.split(",") as PackedStringArray).has(str(cl["id"])):
			cells.append(cl)
	c = Career.quick_start()
	base_f = [Data.fighter_state(Data.lucy(), c.day), Data.fighter_state(_jo(), c.day)]
	for f in base_f:
		f["morale"] = 60.0
		var a := Attrs.of(f)
		print("P2 POP fighter %s (%s, %s) power %.1f stamina %.0f footwork %.0f chin %.0f forward %.0f heart %.0f" % [f["name"], f["style"],
			f["stance"], BoutRules.fight_power(f["stats"], {}, 0, ""), Duels.v(a, "stamina"), Duels.v(a, "footwork"), Duels.v(a, "chin"),
			Duels.v(a, "forward"), Duels.v(a, "heart")])
		if pilot:   # the dial round trip FEET uses must leave the fighter as she was
			var g: Dictionary = f.duplicate(true)
			var a0: Dictionary = Attrs.of(g).duplicate()
			var p0 := float(g["style_dials"]["pressure"])
			g["style_dials"]["pressure"] = R.PRESS_DIAL
			Attrs.of(g)
			g["style_dials"]["pressure"] = p0
			var a1 := Attrs.of(g)
			var worst := 0.0
			for k in a0:
				if typeof(a0[k]) == TYPE_FLOAT:
					worst = maxf(worst, absf(float(a0[k]) - float(a1.get(k, -999.0))))
			print("P2 DIALCHECK %s: dial %.1f -> 75 -> back, biggest attribute change %.6f" % [f["first"], p0, worst])
	print("P2 POP opponents per cell: two fictional (A orthodox at our paper power + the cell's offset, B southpaw +1.5), style by cell;")
	print("P2 POP bout i: fighter i%%2, opponent (i/2)%%2, career day 20+i (paired dice), film 1, no camp, morale 60; n=%d a cell" % n)
	var t0 := Time.get_ticks_msec()
	for L in lens:
		for cl in cells:
			if bool(cl.get("only6", false)) and int(L) != 6:
				continue
			for i in n:
				for arm in arms:
					for pol in R.POLS[arm]:
						_run(str(arm), str(pol), cl, int(L), i)
				if pilot and str(cl["id"]) == "c3_level":
					_run("H", "holdcheck", cl, int(L), i)
	print("P2 WALL %.1f s for %d bouts" % [(Time.get_ticks_msec() - t0) / 1000.0, _bouts()])
	for k in ms:
		print("P2 MS %s %.2f ms a bout (%d bouts)" % [k, float(ms[k][0]) / float(ms[k][1]), int(ms[k][1])])
	if pilot:   # the full run's cost at this machine's pace: every cell, every arm and policy, both lengths
		var per := 0.0
		for L in lens:
			var nc := 0
			for cl in R.CELLS:
				nc += 0 if bool(cl.get("only6", false)) and int(L) != 6 else 1
			for arm in arms:
				var k := "%s L%d" % [arm, int(L)]
				per += float(ms[k][0]) / float(ms[k][1]) * (R.POLS[arm] as Array).size() * nc
		print("P2 PROJECT one paired bout of every arm, policy and cell = %.1f s; 400 a cell = %.1f min; fits 90 min: n = %d" % [per / 1000.0,
			per * 400.0 / 60000.0, int(90.0 * 60000.0 / per)])
	R.report(agg, arms, lens, cells, pilot)
	quit(0)


func _jo() -> Dictionary:   # the second fighter of our side: a southpaw boxer-puncher, never Lucy's numbers
	return Data.lucy().merged({"id": "jo", "name": "Jo Brennan", "first": "Jo", "stance": "southpaw", "style": "Boxer-puncher",
		"stats": {"power": 61.5, "speed": 59.0, "technique": 57.5, "defense": 58.5, "conditioning": 64.5, "fight_iq": 57.0, "chin": 62.0}}, true)


func _bouts() -> int:
	var t := 0
	for k in ms:
		t += int(ms[k][1])
	return t


func _run(arm: String, pol: String, cl: Dictionary, L: int, i: int) -> void:
	var t := Time.get_ticks_usec()
	var r := _bout(arm, pol, cl, L, i)
	var mk := "%s L%d" % [arm, L]
	var mm: Array = ms.get(mk, [0.0, 0])
	ms[mk] = [float(mm[0]) + (Time.get_ticks_usec() - t) / 1000.0, int(mm[1]) + 1]
	var key := "%s|%d|%s|%s" % [arm, L, cl["id"], pol]
	if not agg.has(key):
		agg[key] = {"n": 0, "w": 0, "d": 0, "sl": 0, "sw": 0, "rest": 0.0, "head": 0.0, "ohead": 0.0, "wind": [], "legs": [], "low": 0, "late": 0,
			"out": PackedByteArray()}
	var g: Dictionary = agg[key]
	g["n"] += 1
	g["w"] += 1 if r["out"] == "win" else 0
	g["d"] += 1 if r["out"] == "draw" else 0
	g["sl"] += 1 if r["stop"] != "" and r["out"] == "loss" else 0
	g["sw"] += 1 if r["stop"] != "" and r["out"] == "win" else 0
	g["rest"] += float(r["rest"])
	g["late"] += int(r["late"])
	g["head"] += float(r["head"])
	g["ohead"] += float(r["ohead"])
	g["low"] += 1 if bool(r["legs_low"]) else 0
	var ob: PackedByteArray = g["out"]   # a packed array is a value: append on the copy, then store it back
	ob.append(2 if r["out"] == "win" else (1 if r["out"] == "draw" else 0))
	g["out"] = ob
	for k in ["wind", "legs"]:
		var sums: Array = g[k]
		var vals: Array = r[k]
		for j in vals.size():
			if sums.size() <= j:
				sums.append([0.0, 0])
			sums[j] = [float(sums[j][0]) + float(vals[j]), int(sums[j][1]) + 1]


## One bout, the game's own loop; st carries the probe's sums.
func _bout(arm: String, pol: String, cl: Dictionary, L: int, i: int) -> Dictionary:
	c.day = 20 + i
	var f: Dictionary = (base_f[i % 2] as Dictionary).duplicate(true)
	c.fighters = [f]
	f["camp"] = {}
	f["notes_seen"] = []
	f["round_pace"] = []
	if cl.has("temper"):
		f["personality"]["temper"] = float(cl["temper"])
	var opp := _opp(cl, f, (i / 2) % 2)
	var stale := float(cl.get("stale", 0.0))
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": L, "stale": stale}
	var m := {"fid": f["id"], "step": "tape", "total": L}
	var layers := arm in ["D", "E", "H"]
	var st := {"arm": arm, "pol": pol, "L": L, "on": arm in ["D", "E"], "feet_on": layers, "iced": false, "cold": false, "icecut": 0.0,
		"late": 0, "drop": [0.0, 0.0], "legs": [100.0 - R.LEGS_CUT_SHARE * stale, 100.0],
		"lr": [0.0, 0.0], "bnow": [0.0, 0.0], "bnext": [0.0, 0.0], "changes": 0, "feet": "hold", "ohands": "steady", "oextra": 0.0,
		"seen": 0, "rseen": 0, "flog": {}, "count_round": -1, "legs_bells": [], "oq": 0.0, "cell": cl}
	var a := Attrs.of(f)
	st["base"] = {"dial": float((f.get("style_dials", {}) as Dictionary).get("pressure", Duels.v(a, "forward")))}
	for k in R.LEGS_KEYS + ["hand_speed", "power"]:
		st["base"][k] = Duels.v(a, k)
	st["fit"] = [Duels.v(a, "stamina"), Duels.v(a, "footwork"), Duels.v(a, "chin"), Duels.v(a, "heart")]
	var b := RingDuel.opp(opp)
	st["ofit"] = [Duels.v(b, "stamina"), Duels.v(b, "footwork"), Duels.v(b, "chin"), Duels.v(b, "heart")]
	if layers:
		opp["shape"] = (AttrGen.shape_of(opp) as Dictionary).duplicate()
		st["oshape"] = (opp["shape"] as Dictionary).duplicate()
	var start := int(cl.get("s%d" % L, 1))
	# Round 1: the first bell (plan "" for everyone, the game's round 1).
	_minute(st, f, m, 1, start)
	Bouts.fight_step(c, f, m, "start")
	_after(st, f, m)
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			var s := _seen(st, f, m, int(m["round"]))
			var shout := _choose(st, f, m, s, int(m["round"]) >= start)
			var e := 0.0
			if bool(st["on"]):
				e = R.opp_edge(str(st["ohands"]), RingDuel.opp_energy(lv, (lv["ex"] as Array).size()))
				lv["base"] = float(lv["base"]) + e
			Bouts.fight_step(c, f, m, "shout:" + shout)
			if not LiveRound.live(m).is_empty() and e != 0.0:
				LiveRound.live(m)["base"] = float(LiveRound.live(m)["base"]) - e
			_after(st, f, m)
		var rn := int(m["round"])
		if rn >= L or Bouts.stopped(m) != "":
			break
		var corner := _minute(st, f, m, rn + 1, start)
		Bouts.fight_step(c, f, m, corner)
		if rn + 1 == start:
			var lv0 := LiveRound.live(m)
			if bool(cl.get("hurt", false)) and not lv0.is_empty():
				lv0["her_hurt"] = true
			if bool(cl.get("ohurt", false)) and not lv0.is_empty():
				lv0["opp_hurt"] = true
		_after(st, f, m)
	var rounds: Array = m["rounds"]
	var out := BoutNight.outcome_of(f, m)
	var stop := Bouts.stopped(m)
	var e_last: Dictionary = (rounds[-1] as Dictionary).get("energy", {})
	var toll := Aftermath.toll(0.0, float(e_last.get("a_end_calls", e_last.get("a_end", 100.0))), stop != "" and out == "loss")
	var wind: Array = []
	for r in rounds:
		wind.append(float((r["energy"] as Dictionary).get("a_end", 0.0)))
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	var lb: Array = st["legs_bells"]
	return {"out": out, "stop": stop, "rest": Aftermath.rest_days(toll), "head": float(dmg["a"]), "ohead": float(dmg["b"]),
		"wind": wind, "late": int(st["late"]), "legs": lb if bool(st["on"]) else [], "legs_low": bool(st["on"]) and lb.size() >= 3 and float(lb[2]) < 50.0}


func _opp(cl: Dictionary, f: Dictionary, oi: int) -> Dictionary:
	var kind := str(cl.get("opp", "even"))
	var w: Array = R.OPPS[kind]
	var o: Dictionary = (Data.OPPONENTS[oi] as Dictionary).duplicate(true)
	o["name"] = "%s %s" % [["Ana", "Bea"][oi], kind.capitalize()]
	o["first"] = ["Ana", "Bea"][oi]
	o["style"] = w[0]
	o["threat"] = w[1]
	o["weak"] = w[2]
	o["stance"] = "orthodox" if oi == 0 else "southpaw"
	o["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "") + float(cl.get("off", 0.0)) + 1.5 * oi
	return o


## What the corner sees before exchange i of round rn (i = 0: the minute before it).
func _seen(st: Dictionary, f: Dictionary, m: Dictionary, rn: int) -> Dictionary:
	var lv := LiveRound.live(m)
	var fb: Dictionary = f["bout"]
	var opp: Dictionary = fb["opp"]
	var rounds: Array = m.get("rounds", [])
	var won_r := 0
	for r in rounds:
		won_r += 1 if bool(r["won"]) else 0
	var s := {"n": rn, "total": int(st["L"]), "won_r": won_r, "lost_r": rounds.size() - won_r, "ex_w": 0, "ex_l": 0,
		"legs": float(st["legs"][0]), "hurt": false, "ohurt": false, "pinned": false, "style": str(opp["style"]),
		"threat": str(opp["threat"]), "weak": str(opp["weak"]), "head": float((m.get("damage", {"a": 0.0}) as Dictionary)["a"]),
		"stale": float(fb.get("stale", 0.0)), "count_fresh": rn == int(st["count_round"]), "temper": float(f["personality"].get("temper", 50.0)),
		"lost_last": not rounds.is_empty() and not bool(rounds[-1]["won"]), "stamina": st["fit"][0], "chin": st["fit"][2],
		"ostamina": st["ofit"][0], "ochin": st["ofit"][2]}
	if lv.is_empty():
		var en: Dictionary = fb.get("energy", {"a": 100.0 - float(fb.get("stale", 0.0)), "b": 100.0})
		s["i"] = 0
		s["wind"] = float(en["a"])
		s["owind"] = float(en["b"])
		return s
	var exs: Array = lv["ex"]
	s["i"] = exs.size()
	s["wind"] = RingDuel.her_energy(lv, exs.size())
	s["owind"] = RingDuel.opp_energy(lv, exs.size())
	s["hurt"] = bool(lv["her_hurt"])
	s["ohurt"] = bool(lv["opp_hurt"])
	s["pinned"] = not exs.is_empty() and bool(exs[-1].get("pinned", false))
	for x in exs:
		s["ex_w"] += 1 if bool(x["won"]) else 0
		s["ex_l"] += 0 if bool(x["won"]) else 1
	return s


## The arm's pace word for HANDS (B has no Coast: v1's switch is Push on / off, Save went into Breathe).
func _pace(arm: String, hands: String) -> String:
	if arm == "B":
		return "push" if hands == "push" else "steady"
	return str(R.PACE_OF[hands])


## A shout for exchange i: the call and the pace / feet change ("" = say nothing).
func _choose(st: Dictionary, f: Dictionary, m: Dictionary, s: Dictionary, mine: bool) -> String:
	var lv := LiveRound.live(m)
	var arm := str(st["arm"])
	var d := R.decide(_hf(st) if mine else "hold", s)
	st["cold"] = false   # E: cold shoulders last the round's first 30 s only
	var call := str(d["call"])
	if arm == "B" and str(d["hands"]) == "coast" and call == "":
		call = "calm"
	var pace := _pace(arm, str(d["hands"]))
	var feet := _feet(st, str(d["feet"]))
	var now := str(lv["pace"])
	var change := pace != now or feet != str(st["feet"])
	if change and arm in ["C", "D", "E", "H"]:
		if int(st["changes"]) >= R.SHOUT_CHANGES:
			pace = now
			feet = str(st["feet"])
		else:
			st["changes"] = int(st["changes"]) + 1
			if call == "":
				lv["shouts"] = int(lv["shouts"]) + 1
	st["feet"] = feet
	st["flog"][int(s["i"])] = feet
	_apply(st, f, m, float(s["wind"]), float(s["owind"]), int(s["n"]))
	return call + ("|pace=" + pace if pace != now else "")


## The policy that sets HANDS and FEET: arm E fights every ice policy on the coach's HANDS and FEET.
func _hf(st: Dictionary) -> String:
	return "coach" if str(st["arm"]) == "E" else str(st["pol"])


func _feet(st: Dictionary, want: String) -> String:
	if not bool(st["feet_on"]):
		return "hold"
	if want == "press" and float(st["legs"][0]) < R.LEGS_NO_PRESS:
		return "hold"
	return want


## The corner minute before round rn: HANDS and FEET set free, the round's plan, the cell's starting state at its bell.
func _minute(st: Dictionary, f: Dictionary, m: Dictionary, rn: int, start: int) -> String:
	var fb: Dictionary = f["bout"]
	if rn == start and rn > 1:
		_inject(st, f, m, rn)
	if rn == int(_cell_of(st).get("switch", -1)):
		fb["opp"]["stance"] = "southpaw" if str(fb["opp"]["stance"]) == "orthodox" else "orthodox"
	var s := _seen(st, f, m, rn)
	var d := R.decide(_hf(st) if rn >= start else "hold", s)
	var arm := str(st["arm"])
	var rec := ""
	if arm == "E" and rn > 1:   # the minute in seconds (pushprobe2_rules minute_plan): water, rib ice, talk, rub, neck ice
		var taken := 0
		for x in (m["rounds"][-1] as Dictionary)["exchanges"]:
			taken += int(x["body"][1])
		var mp := R.minute_plan(str(st["pol"]) if rn >= start else "ice_never", s, str(d["talk"]) != "", bool(st["iced"]), taken)
		rec = "|rec=water:%d,ice:%d" % [int(mp["water"]), int(mp["ribs"])]
		st["icecut"] = R.ice_cut(float(mp["ice"]))
		st["iced"] = float(mp["ice"]) > 0.0
		st["cold"] = bool(mp["cold"])
		st["late"] = int(st["late"]) + (1 if bool(mp["late"]) else 0)
	f["round_pace"] = PlanFile.set_pace([], rn, _pace(arm, str(d["hands"])))
	st["feet"] = _feet(st, str(d["feet"]))
	st["flog"] = {0: st["feet"]}
	st["changes"] = 0
	var rounds: Array = m.get("rounds", [])
	var opp: Dictionary = fb["opp"]
	var won_r := 0
	for r in rounds:
		won_r += 1 if bool(r["won"]) else 0
	st["ohands"] = R.opp_hands(str(opp["style"]), str(opp["weak"]), rn, int(st["L"]), rounds.size() - won_r, won_r) if bool(st["on"]) else "steady"
	_apply(st, f, m, float(s["wind"]), float(s["owind"]), rn)
	if rn == 1:
		return "start"
	var plan := str(d["plan"])
	if plan == "":
		plan = "calm" if arm == "B" and str(d["hands"]) == "coast" else BoutRules.auto_corner(f["stats"])
	return "corner:" + plan + ("|talk=" + str(d["talk"]) if str(d["talk"]) != "" else "") + rec


func _cell_of(st: Dictionary) -> Dictionary:
	return st.get("cell", {})


## The cell's starting state at the bell of the round the policy takes over.
func _inject(st: Dictionary, f: Dictionary, m: Dictionary, rn: int) -> void:
	var cl := _cell_of(st)
	var sc: Array = cl.get("sc%d" % int(st["L"]), [])
	var rounds: Array = m["rounds"]
	if sc.size() == 2:
		for j in rounds.size():
			rounds[j]["won"] = j < int(sc[0])
	if cl.has("odrop") and f["bout"].has("energy"):
		f["bout"]["energy"]["b"] = maxf(0.0, float(f["bout"]["energy"]["b"]) - float(cl["odrop"]))
	if cl.has("dmg"):
		var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
		dmg["a"] = float(dmg["a"]) + float(cl["dmg"])
		m["damage"] = dmg
	if bool(cl.get("count", false)):
		var cn: Dictionary = m.get("counts", {"a": 0, "b": 0})
		cn["a"] = int(cn["a"]) + 1
		m["counts"] = cn
		st["count_round"] = rn


## The probe's layers before an exchange: the forward dial for FEET, the legs side of the fade for LEGS (ours and theirs).
func _apply(st: Dictionary, f: Dictionary, m: Dictionary, wind: float, owind: float, rn: int) -> void:
	if not bool(st["feet_on"]):
		return
	var dial := float(st["base"]["dial"])
	if str(st["feet"]) == "press":
		dial = R.PRESS_DIAL
	elif str(st["feet"]) == "move":
		dial = R.MOVE_DIAL
	if f.has("style_dials"):
		f["style_dials"]["pressure"] = dial
	var a := Attrs.of(f)
	a["forward"] = dial
	if not bool(st["on"]):
		return
	if str(st["arm"]) == "E":
		for k in ["hand_speed", "power"]:
			a[k] = float(st["base"][k]) - (R.COLD_SNAP if bool(st["cold"]) else 0.0)
	var sh := R.legs_shift(wind, rn >= 3, float(st["fit"][3]), float(st["legs"][0]))
	for k in R.LEGS_KEYS:
		a[k] = float(st["base"][k]) + sh
	var q := snappedf(R.legs_shift(owind, rn >= 3, float(st["ofit"][3]), float(st["legs"][1])), 0.5)
	if q != float(st["oq"]):
		st["oq"] = q
		var shape: Dictionary = (st["oshape"] as Dictionary).duplicate()
		shape["footwork"] = float(shape.get("footwork", 0.0)) + q
		shape["defence"] = float(shape.get("defence", 0.0)) + q
		f["bout"]["opp"]["shape"] = shape


## After a fight_step: the new exchanges' sums, then the round's close.
func _after(st: Dictionary, f: Dictionary, m: Dictionary) -> void:
	var lv := LiveRound.live(m)
	var rounds: Array = m.get("rounds", [])
	var closed := rounds.size() > int(st["rseen"])
	var exs: Array = (rounds[-1] as Dictionary)["exchanges"] if closed else lv.get("ex", [])
	for j in range(int(st["seen"]), exs.size()):
		_on_ex(st, f, m, exs[j] as Dictionary, j, closed and j == exs.size() - 1, lv, rounds[-1] if closed else {})
	st["seen"] = exs.size()
	if closed:
		_on_close(st, f, m, rounds[-1])


func _on_ex(st: Dictionary, f: Dictionary, m: Dictionary, x: Dictionary, j: int, last: bool, lv: Dictionary, r: Dictionary) -> void:
	var arm := str(st["arm"])
	var fb: Dictionary = f["bout"]
	if not last and bool(st["on"]):   # the round's even drain (the bell rewrites the record's ends): [ours, theirs] an exchange
		var e: Dictionary = lv["e"]
		st["drop"] = [maxf(0.0, float(e["a"]) - float(e["a_end"])) / 6.0, maxf(0.0, float(e["b"]) - float(e["b_end"])) / 6.0]
	var back := 0.0
	if arm in ["C", "D", "E"] and str(x["pace"]) == "save":
		back = PaceAim.SAVE_RECOVER - R.COAST_REFILL
	back -= float(st["drop"][0]) * float(st["icecut"])   # E: neck ice slows this round's drain
	if back != 0.0:   # Coast: the game's save pace, its flat refill taken back
		if last:
			fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - back, 0.0, 100.0)
			for k in ["a_end", "a_end_calls"]:
				r["energy"][k] = maxf(0.0, float(r["energy"].get(k, 0.0)) - back)
		else:
			lv["cost"] = float(lv["cost"]) + back
	if not bool(st["on"]):
		return
	var aft: Dictionary = x.get("after", {"a": 100.0, "b": 100.0})
	var wa := float(aft["a"])
	var wb := float(aft["b"])
	var feet_a := str(st["flog"].get(j, st["feet"]))
	var feet_b := R.opp_feet(str(x["mode"]))
	var inside := int(x.get("place", 0)) == Duels.INSIDE
	var pa := feet_b == "press" or (feet_b == "move" and feet_a == "press")
	var pb := feet_a == "press" or (feet_a == "move" and feet_b == "press")
	var body: Array = x.get("body", [0, 0])
	var sa := R.legs_spend(feet_a, pa, wa, float(st["fit"][0]), float(st["fit"][1]), inside) + float(st["bnext"][0]) / 6.0
	var sb := R.legs_spend(feet_b, pb, wb, float(st["ofit"][0]), float(st["ofit"][1]), inside) + float(st["bnext"][1]) / 6.0
	st["legs"] = [maxf(0.0, float(st["legs"][0]) - sa), maxf(0.0, float(st["legs"][1]) - sb)]
	st["lr"] = [float(st["lr"][0]) + sa, float(st["lr"][1]) + sb]
	st["bnow"] = [float(st["bnow"][0]) + R.LEGS_PER_BODY * int(body[1]), float(st["bnow"][1]) + R.LEGS_PER_BODY * int(body[0])]
	var won := bool(x["won"])
	var hp := str(x["sit"]) == "she_hurt" and str(x["pace"]) == "push" and not won
	var hd := R.head_ex(float(x["margin"]), won, R.head_links(wa, float(st["legs"][0]), hp), R.head_links(wb, float(st["legs"][1]), false))
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	dmg["a"] = float(dmg["a"]) + float(hd[0])
	dmg["b"] = float(dmg["b"]) + float(hd[1])
	m["damage"] = dmg
	# The opponent's HANDS: its drain x1.35 (Push) or x0.6 (Coast), never refilled.
	var extra := float(st["drop"][1]) * (PaceAim.spend(str(R.PACE_OF[str(st["ohands"])])) - 1.0)
	if not last:
		lv["e"]["b"] = float(lv["e"]["b"]) - extra
		lv["e"]["b_end"] = float(lv["e"]["b_end"]) - extra
	st["oextra"] = float(st["oextra"]) + extra


func _on_close(st: Dictionary, f: Dictionary, m: Dictionary, r: Dictionary) -> void:
	st["rseen"] = int(st["rseen"]) + 1
	st["seen"] = 0
	if str(r.get("down", "")) == "a" and int(r.get("counts", 0)) > 0:
		st["count_round"] = int(r["n"]) + 1
	if not bool(st["on"]):
		return
	# Head per exchange replaces the round's band damage (Knockdowns.round_counts added it to the loser and 2 to the winner).
	var loser := "b" if bool(r["won"]) else "a"
	var winner := "a" if loser == "b" else "b"
	var dmg: Dictionary = m["damage"]
	dmg[loser] = maxf(0.0, float(dmg[loser]) - float(Knockdowns.DAMAGE_PER_ROUND[RoundScript.margin(r)]))
	dmg[winner] = maxf(0.0, float(dmg[winner]) - Knockdowns.WINNER_DAMAGE)
	for s in 2:
		st["legs"][s] = minf(100.0, float(st["legs"][s]) + R.LEGS_REST * float(st["lr"][s]))
	st["lr"] = [0.0, 0.0]
	st["bnext"] = (st["bnow"] as Array).duplicate()
	st["bnow"] = [0.0, 0.0]
	(st["legs_bells"] as Array).append(float(st["legs"][0]))
	var fb: Dictionary = f["bout"]
	fb["energy"]["b"] = clampf(float(fb["energy"]["b"]) - float(st["oextra"]), 0.0, 100.0)
	st["oextra"] = 0.0
