extends RefCounted
## CORNERCMD1 local rules (flagged, probe only; nothing under scripts/ reads this). STEP 0: today's eight calls, a reader who
## shouts the call Exchanges.MODES marks best for the moment. The commands' numbers (ESTIMATES) come below the step-0 block.
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

## Ten cells that differ in what the opponent does (opponent style / weapon / weakness / rating offset / stance switch).
const CELLS := [
	{"id": "presser", "style": "Pressure fighter", "threat": "Never stops throwing", "weak": "Leaves the chin open"},
	{"id": "mover", "style": "Out-boxer", "threat": "Long jab", "weak": "Backs straight up"},
	{"id": "counter", "style": "Counter-puncher", "threat": "Right hand over the jab", "weak": "Leaves the chin open"},
	{"id": "loader", "style": "Slugger", "threat": "Heavy right hand", "weak": "Walks in straight"},
	{"id": "fader", "style": "Volume puncher", "threat": "Never stops throwing", "weak": "Fades after round 2"},
	{"id": "slow", "style": "Boxer-puncher", "threat": "Stops people", "weak": "Slow to start"},
	{"id": "body", "style": "Boxer-puncher", "threat": "Body hooks", "weak": "Leaves the chin open"},
	{"id": "switch", "style": "Boxer-puncher", "threat": "Right hand over the jab", "weak": "Leaves the chin open", "stance": "southpaw", "switch": 2},
	{"id": "favourite", "style": "Boxer-puncher", "threat": "Stops people", "weak": "Leaves the chin open", "off": 3.0},
	{"id": "underdog", "style": "Boxer-puncher", "threat": "Stops people", "weak": "Leaves the chin open", "off": -3.0},
]
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const PerkFight := preload("res://scripts/rules/PerkFight.gd")

## THE COMMANDS (DESIGN_CORNERCMD1.md table). call = the game's call it IS (shouted each exchange for its real effects: body
## share, place, wind cost) or "" (a NEW command: a local edge on the exchange's base). needs = Exchanges.grade's values.
## wind = energy an exchange on top of the call's own cost (ESTIMATE for the new ones). head = head damage added on an exchange
## lost while it is on (ESTIMATE). best / ok / wrong = the moments (Exchanges situations) it answers.
const CMD := {
	"body": {"label": "Go to the body", "call": "body", "needs": ["hooks", "power"], "wind": 0.0, "head": 0.0,
		"best": ["range"], "ok": ["press", "tiring"], "wrong": ["loadup"]},
	"levels": {"label": "Change levels", "call": "", "needs": ["hooks", "ring_iq"], "wind": 1.0, "head": 0.0,
		"best": ["counter"], "ok": ["range", "loadup"], "wrong": ["press"]},
	"let_go": {"label": "Let your hands go", "call": "let_go", "needs": ["engine", "hand_speed"], "wind": 0.0, "head": 0.5,
		"best": ["tiring"], "ok": ["hurt"], "wrong": ["press", "counter", "she_tired"]},
	"first": {"label": "Be first", "call": "", "needs": ["hand_speed", "timing"], "wind": 1.5, "head": 0.5,
		"best": ["loadup"], "ok": ["range", "press"], "wrong": ["counter", "she_tired"]},
	"sit": {"label": "Sit down on your shots", "call": "", "needs": ["power", "timing"], "wind": 1.0, "head": 1.5,
		"best": ["tiring"], "ok": ["hurt", "press"], "wrong": ["range", "counter"]},
	"hands": {"label": "Hands up", "call": "hands", "needs": ["guard", "head_movement"], "wind": 0.0, "head": 0.0,
		"best": ["loadup"], "ok": ["press", "she_hurt", "she_tired"], "wrong": ["tiring", "hurt"]},
	"reset": {"label": "Reset", "call": "calm", "needs": ["discipline", "heart"], "wind": 0.0, "head": 0.0,
		"best": ["she_tired", "she_hurt"], "ok": ["counter"], "wrong": ["tiring", "hurt"]},
	"get_out": {"label": "Get out of there", "call": "long", "needs": ["jab", "footwork"], "wind": 0.0, "head": 0.0,
		"best": ["press"], "ok": ["counter", "loadup"], "wrong": ["range"]},
}
const FIGHT := ["body", "levels", "let_go", "first", "sit", "hands", "reset", "get_out"]
## The RING slot (a three-stop slider). step = the learned steps it is done with (their best mastery, 0-100, graded at
## RING_GOOD / RING_OK like a call), with footwork. cut = the share taken off the opponent's range game this round
## (RingDuel.step_bias's ring_cut, what a cut_off step does); clear = our ropes count cleared (Duels pins).
const RING := {
	"cut": {"label": "Cut the ring off", "steps": ["cut_off", "herd"], "wind": 1.0, "cut": 0.5,
		"best": ["range"], "ok": ["tiring"], "wrong": ["press", "counter"]},
	"ropes": {"label": "Stay away from the ropes", "steps": ["pivot_out", "roll_out", "step_out"], "wind": 0.5, "clear": true,
		"best": ["press"], "ok": ["loadup"], "wrong": ["range", "tiring"]},
}
static var RING_SCALE := 0.6     # ESTIMATE: the feet choose where the fight happens; the hands decide it - a ring edge is 0.6 of a call's
const RING_GOOD := 55.0
const RING_OK := 40.0
const RESET_GIVE := -3.0    # ESTIMATE: Reset in a moment it does not answer gives a little now (the old calm's "gives a little now")
static var COACH_A := 0.0   # the corner coach rule: he follows the reader with chance clamp((tactics - COACH_A) / COACH_B, 0, 1)
static var COACH_B := 100.0
static var ARMS: Array = []
static var LOG := false
## DIAGNOSTIC only (stage=fix): the round's call from the opponent's file (his favourite game's best call) instead of auto_corner.
static var FAVPLAN := false
static var RING_WIND := {"cut": 1.0, "ropes": 0.5}   # the one-rep trial's walk: every exchange into st["log"]


static func arms() -> Array:
	var a: Array = ["plan", "push45"]
	for c in FIGHT:
		a.append("c:" + str(c))
	for r in RING:
		a.append("r:" + str(r))
	for c in FIGHT:
		for r in RING:
			a.append("p:%s+%s" % [c, r])
	a += ["reader", "coach40", "coach58", "coach75", "alt"]
	return a


## {word, mult} of a FIGHT command for her (Exchanges.grade on the command's needs).
static func cgrade(id: String, vals: Dictionary) -> Dictionary:
	var needs: Array = CMD[id]["needs"]
	var sum := 0.0
	for k in needs:
		sum += float(vals.get(k, 55.0))
	var mean := sum / float(needs.size())
	var word := "Good" if mean >= Exchanges.GOOD_AT else ("OK" if mean >= Exchanges.OK_AT else "Poor")
	var mult: float = float(Exchanges.GRADE["Poor"])
	if mean >= Exchanges.GOOD_AT:
		mult = 1.0
	elif mean >= Exchanges.SPREAD_FROM:
		mult = 0.6 + 0.4 * (mean - Exchanges.SPREAD_FROM) / (Exchanges.GOOD_AT - Exchanges.SPREAD_FROM)
	elif mean >= Exchanges.OK_AT:
		mult = 0.6
	return {"word": word, "mult": mult}


static func rgrade(id: String, f: Dictionary, vals: Dictionary) -> Dictionary:
	var best := 0.0
	for s in RING[id]["steps"]:
		best = maxf(best, float((f.get("steps", {}) as Dictionary).get(s, 0.0)))
	var mean := 0.5 * best + 0.5 * float(vals.get("footwork", 55.0))
	var word := "Good" if mean >= RING_GOOD else ("OK" if mean >= RING_OK else "Poor")
	return {"word": word, "mult": float(Exchanges.GRADE[word]), "mean": mean}


static func cfit(row: Dictionary, sit: String) -> String:
	for k in ["best", "ok", "wrong"]:
		if (row[k] as Array).has(sit):
			return k
	return "none"


## The power points a command is worth in this moment, as the exchange gets it (heard = uptake x trust at the change).
static func cmd_edge(id: String, sit: String, g: Dictionary, heard: float) -> float:
	var k := cfit(CMD[id], sit)
	var e := float(Exchanges.EDGE[k])
	if id == "reset" and k == "none":
		e = RESET_GIVE
	if e > 0.0:
		return e * float(g["mult"]) * heard
	return e * heard * float(Exchanges.COMMIT[str(g["word"])])


static func ring_edge(id: String, sit: String, g: Dictionary, heard: float) -> float:
	var k := cfit(RING[id], sit)
	var e := float(Exchanges.EDGE[k]) * RING_SCALE
	if e > 0.0:
		return e * float(g["mult"]) * heard
	return e * heard * float(Exchanges.COMMIT[str(g["word"])])


static func heard_of(f: Dictionary) -> float:
	return Exchanges.uptake(float((f.get("personality", {}) as Dictionary).get("coachability", 55.0)), 0) * FighterProfile.trust(f)


## The reader's pick for a moment: the FIGHT command (or none) and the RING stop (or centre) with the most edge for HER.
static func best_for(sit: String, gr: Dictionary, rg: Dictionary, heard: float) -> Array:
	var bc := ""
	var be := 0.0
	for c in FIGHT:
		var e := cmd_edge(str(c), sit, gr[c], heard)
		if e > be + 0.01:
			be = e; bc = str(c)
	var br := ""
	var bre := 0.0
	for r in RING:
		var e := ring_edge(str(r), sit, rg[r], heard)
		if e > bre + 0.01:
			bre = e; br = str(r)
	return [bc, br]


## The values the commands are graded on: Exchanges.grade's needs for every call, by its own merge (LiveRound.values).
static func trained(f: Dictionary) -> Dictionary:
	var vals := LiveRound.values(f)
	var out := {}
	for c in Exchanges.CALLS.keys():
		out[c] = Exchanges.grade(str(c), vals)["word"]
	return out


static func new_state(pol: String, L: int, ck: float, f: Dictionary) -> Dictionary:
	var vals := LiveRound.values(f)
	var gr := {}
	for c in FIGHT:
		gr[c] = cgrade(str(c), vals)
	var rg := {}
	for r in RING:
		rg[r] = rgrade(str(r), f, vals)
	var rng := RandomNumberGenerator.new()
	rng.seed = 4242 + L
	var tac := ck
	if pol.begins_with("coach"):
		tac = float(pol.trim_prefix("coach"))
	return {"pol": pol, "L": L, "coach": ck, "tactics": tac, "ce": 0.0, "ce_plan": 0.0, "nx": 0, "fits": {}, "sits": {}, "wind": [],
		"head": [], "shouts": 0, "vals": vals, "gr": gr, "rg": rg, "heard": heard_of(f), "rng": rng, "cmd": "", "ring": "",
		"picks": {}, "cmd_on": 0, "right": 0, "wrong": 0, "changes": 0}


## What the corner sees before the next exchange (the clue line is the opponent's game: lv["mode"]).
static func seen(f: Dictionary, m: Dictionary, lv: Dictionary) -> Dictionary:
	var exs: Array = lv["ex"]
	var i := exs.size()
	var her := RingDuel.her_energy(lv, i)
	var sit := Exchanges.situation(str(lv["mode"]), her, bool(lv["her_hurt"]))
	var rounds: Array = m.get("rounds", [])
	var won_r := 0
	for r in rounds:
		won_r += 1 if bool(r["won"]) else 0
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	var ex_w := 0
	for x in exs:
		ex_w += 1 if bool(x["won"]) else 0
	return {"i": i, "n": int(lv["n"]), "sit": sit, "mode": str(lv["mode"]), "wind": her, "owind": RingDuel.opp_energy(lv, i),
		"head": float(dmg.get("a", 0.0)), "ohead": float(dmg.get("b", 0.0)), "won_r": won_r, "lost_r": rounds.size() - won_r,
		"ex_w": ex_w, "ex_l": i - ex_w, "plan": str(lv["plan"]), "shouts": int(lv["shouts"]), "ohurt": bool(lv["opp_hurt"]),
		"hurt": bool(lv["her_hurt"]), "place": int(lv.get("place", 0)),
		"sit_seen": Exchanges.situation(str((exs[i - 1] as Dictionary)["mode"]) if i > 0 else str(lv["mode"]), her, bool(lv["her_hurt"]))}


## The power points a call is worth this exchange as LiveRound reckons it (call_edge x uptake x trust; finds left out).
static func edge_of(call: String, sit: String, f: Dictionary, vals: Dictionary, shouted: bool, shouts: int) -> float:
	var coach := float((f.get("personality", {}) as Dictionary).get("coachability", 55.0))
	var heard := Exchanges.uptake(coach, shouts if shouted else 0) * FighterProfile.trust(f)
	return Exchanges.call_edge(call, sit, vals, heard, false)


## The arm's choice for the next exchange: {cmd, ring, finish, pace, shout}.
static func decide(st: Dictionary, ctx: Dictionary, f: Dictionary) -> Dictionary:
	var pol := str(st["pol"])
	var sit := str(ctx["sit"])
	if pol.begins_with("reader0") or pol == "plan" and st.has("step0"):
		var best := str(Exchanges.MODES[sit]["best"])
		var shout := ""
		if pol == "reader0":
			shout = best
		elif pol == "reader0_seen":
			shout = str(Exchanges.MODES[str(ctx["sit_seen"])]["best"])
		elif pol == "reader0_save":
			shout = best if Exchanges.fit(str(ctx["plan"]), sit) != "best" else ""
		var call := shout if shout != "" else str(ctx["plan"])
		st["ce"] = float(st["ce"]) + edge_of(call, sit, f, st["vals"], shout != "", int(ctx["shouts"]))
		st["nx"] = int(st["nx"]) + 1
		var fk := Exchanges.fit(call, sit)
		st["fits"][fk] = int(st["fits"].get(fk, 0)) + 1
		st["shouts"] = int(st["shouts"]) + (1 if shout != "" else 0)
		return {"shout": shout, "step0": true}
	var d := {"cmd": "", "ring": "", "finish": false, "pace": "", "shout": ""}
	var seen_sit := str(ctx["sit_seen"])
	if pol == "push45":
		d["pace"] = "push" if float(ctx["wind"]) > 45.0 else "steady"
	elif pol.begins_with("c:"):
		d["cmd"] = pol.trim_prefix("c:")
	elif pol.begins_with("r:"):
		d["ring"] = pol.trim_prefix("r:")
	elif pol.begins_with("p:"):
		var pr := pol.trim_prefix("p:").split("+")
		d["cmd"] = pr[0]; d["ring"] = pr[1]
	elif pol == "alt":
		d["cmd"] = "let_go" if int(ctx["i"]) % 2 == 0 else "reset"
	elif pol == "reader" or pol.begins_with("coach"):
		var pick := best_for(seen_sit, st["gr"], st["rg"], float(st["heard"]))
		var follow := true
		if pol.begins_with("coach"):   # the unwatched round: he reads it right with chance by tactics, else keeps what he had
			var p := clampf((float(st["tactics"]) - COACH_A) / COACH_B, 0.0, 1.0)
			follow = (st["rng"] as RandomNumberGenerator).randf() < p
		if follow:
			d["cmd"] = pick[0]; d["ring"] = pick[1]
			d["finish"] = seen_sit == "hurt"
		else:
			d["cmd"] = st["cmd"]; d["ring"] = st["ring"]
	if str(d["cmd"]) != str(st["cmd"]) or str(d["ring"]) != str(st["ring"]):
		st["changes"] = int(st["changes"]) + 1
	st["cmd"] = d["cmd"]; st["ring"] = d["ring"]
	return d


## Before the exchange: the command's edge in for the plan's call (base), its wind on the round's cost, the ring's share off the
## range game / the ropes cleared. Returns the base added (taken back after the exchange).
static func before(st: Dictionary, ctx: Dictionary, d: Dictionary, f: Dictionary, _m: Dictionary, lv: Dictionary) -> float:
	if d.has("step0"):
		return 0.0
	var sit := str(ctx["sit"])
	var vals: Dictionary = st["vals"]
	var heard := float(st["heard"])
	var exs: Array = lv["ex"]
	var i := exs.size()
	var finds := i > 0 and str((exs[i - 1] as Dictionary)["mode"]) == str(lv["mode"]) and float(vals.get("ring_iq", 55.0)) >= Exchanges.IQ_FINDS
	var plan_ce := PerkFight.call_edge(f, Exchanges.call_edge(str(lv["plan"]), sit, vals, heard, finds))
	var add := 0.0
	var total := plan_ce
	var cmd := str(d["cmd"])
	var shout := ""
	if bool(d["finish"]):
		shout = "finish"
		lv["shouts"] = 0
		total = PerkFight.call_edge(f, Exchanges.call_edge("finish", sit, vals, heard, finds))
	elif cmd != "":
		var want := cmd_edge(cmd, sit, st["gr"][cmd], heard)
		var real := str(CMD[cmd]["call"])
		if cmd == "reset" and bool(ctx["hurt"]):
			real = "tie"
		if real != "":
			shout = real
			lv["shouts"] = 0   # spec 7: no shout limit - a command is heard once, at the change, by uptake x trust
			add = want - PerkFight.call_edge(f, Exchanges.call_edge(real, sit, vals, heard, finds))
		else:
			add = want - plan_ce
		lv["cost"] = float(lv["cost"]) + float(CMD[cmd]["wind"])
		total = want
		var fk := cfit(CMD[cmd], sit)
		st["fits"][fk] = int(st["fits"].get(fk, 0)) + 1
		st["cmd_on"] = int(st["cmd_on"]) + 1
	var ring := str(d["ring"])
	if ring != "":
		var rg: Dictionary = st["rg"][ring]
		var re := ring_edge(ring, sit, rg, heard)
		add += re
		total += re
		lv["cost"] = float(lv["cost"]) + float(RING_WIND[ring])
		if RING[ring].has("cut"):
			lv["ring_cut"] = maxf(float(lv.get("ring_cut", 0.0)), float(RING[ring]["cut"]) * float(rg["mult"]) * heard)
		if bool(RING[ring].get("clear", false)) and (st["rng"] as RandomNumberGenerator).randf() < float(rg["mult"]) * heard:
			var pins: Array = lv.get("pins", [0, 0])
			pins[0] = 0
			lv["pins"] = pins
	var key := (cmd if cmd != "" else "-") + "|" + (ring if ring != "" else "-") + ("|F" if bool(d["finish"]) else "")
	st["picks"][key] = int(st["picks"].get(key, 0)) + 1
	st["sits"][sit] = int(st["sits"].get(sit, 0)) + 1
	st["ce"] = float(st["ce"]) + total
	st["ce_plan"] = float(st["ce_plan"]) + plan_ce
	st["nx"] = int(st["nx"]) + 1
	if LOG:
		if not st.has("log"):
			st["log"] = []
		(st["log"] as Array).append([int(ctx["n"]), int(ctx["i"]), str(ctx["sit_seen"]), sit, cmd, ring, bool(d["finish"]), snappedf(total, 0.1),
			snappedf(plan_ce, 0.1), snappedf(float(ctx["wind"]), 0.1), snappedf(float(ctx["head"]), 0.1)])
	if str(d["pace"]) != "":
		shout += "|pace=" + str(d["pace"])
	d["shout"] = shout
	lv["base"] = float(lv["base"]) + add
	return add


static func after(st: Dictionary, _ctx: Dictionary, d: Dictionary, _f: Dictionary, m: Dictionary, add: float, nx: int) -> void:
	if d.has("step0"):
		return
	var lv := LiveRound.live(m)
	var x: Dictionary
	if not lv.is_empty():
		lv["base"] = float(lv["base"]) - add
		x = lv["ex"][nx]
	else:
		var rounds: Array = m["rounds"]
		x = rounds[-1]["exchanges"][nx]
	var won := bool(x["won"])
	if LOG and st.has("log") and not (st["log"] as Array).is_empty():
		(st["log"][-1] as Array).append("WON" if won else "lost")
	var cmd := str(d["cmd"])
	if cmd != "" and not bool(d["finish"]):
		var fk := cfit(CMD[cmd], str(x["sit"]))
		if not won and float(CMD[cmd]["head"]) > 0.0:
			var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
			dmg["a"] = float(dmg.get("a", 0.0)) + float(CMD[cmd]["head"])
			m["damage"] = dmg
		if fk in ["best", "ok"] and won:
			st["right"] = int(st["right"]) + 1
		elif fk == "wrong" and not won:
			st["wrong"] = int(st["wrong"]) + 1


static func bell(st: Dictionary, _f: Dictionary, m: Dictionary) -> void:
	var rounds: Array = m.get("rounds", [])
	if rounds.size() > (st["wind"] as Array).size():
		(st["wind"] as Array).append(float((rounds[-1]["energy"] as Dictionary).get("a_end", 0.0)))
		(st["head"] as Array).append(float((m.get("damage", {"a": 0.0}) as Dictionary).get("a", 0.0)))


## The corner minute's call for the next round: a held FIGHT command with a call of its own is the round's call from its first
## 30 s (that exchange is fought inside the corner step); otherwise the plan's call as built.
static func corner_call(st: Dictionary, f: Dictionary, _m: Dictionary) -> String:
	var cmd := str(st.get("cmd", ""))
	if cmd != "" and str(CMD[cmd]["call"]) != "":
		return str(CMD[cmd]["call"])
	if FAVPLAN:
		return str(Exchanges.MODES[Exchanges.favourite(str(f["bout"]["opp"].get("style", "")))]["best"])
	return BoutRules.auto_corner(f["stats"])


static func finish_state(st: Dictionary, _f: Dictionary, m: Dictionary, out: String) -> Dictionary:
	bell(st, _f, m)
	var stop := ""
	var rounds: Array = m.get("rounds", [])
	if not rounds.is_empty():
		stop = str((rounds[-1] as Dictionary).get("stopped", ""))
	var rw := 0
	for r in rounds:
		rw += 1 if bool(r["won"]) else 0
	return {"out": out, "stop": stop, "rw": rw, "rn": rounds.size(), "st": st}


static func agg_new() -> Dictionary:
	return {"n": 0, "w": 0, "d": 0, "stopw": 0, "stopl": 0, "outs": "", "rw": 0, "ce": 0.0, "ce_plan": 0.0, "nx": 0, "fits": {}, "sits": {},
		"wind": [], "head": [], "shouts": 0, "picks": {}, "cmd_on": 0, "right": 0, "wrong": 0, "changes": 0, "wind_min": 999.0, "wind_low60": 0, "head_max": 0.0}


static func agg_add(g: Dictionary, r: Dictionary, _k: int) -> void:
	var st: Dictionary = r["st"]
	g["n"] = int(g["n"]) + 1
	g["w"] = int(g["w"]) + (1 if r["out"] == "win" else 0)
	g["d"] = int(g["d"]) + (1 if r["out"] == "draw" else 0)
	g["stopw"] = int(g["stopw"]) + (1 if r["stop"] != "" and r["out"] == "win" else 0)
	g["stopl"] = int(g["stopl"]) + (1 if r["stop"] != "" and r["out"] == "loss" else 0)
	g["outs"] = str(g["outs"]) + ("2" if r["out"] == "win" else ("1" if r["out"] == "draw" else "0"))
	g["rw"] = int(g["rw"]) + int(r["rw"])
	for k in ["ce", "ce_plan"]:
		g[k] = float(g[k]) + float(st[k])
	for k in ["nx", "shouts", "cmd_on", "right", "wrong", "changes"]:
		g[k] = int(g[k]) + int(st[k])
	for k in ["fits", "sits", "picks"]:
		for kk in (st[k] as Dictionary):
			g[k][kk] = int(g[k].get(kk, 0)) + int(st[k][kk])
	for k in ["wind", "head"]:
		var vals: Array = st[k]
		var sums: Array = g[k]
		for j in vals.size():
			if sums.size() <= j:
				sums.append([0.0, 0])
			sums[j] = [float(sums[j][0]) + float(vals[j]), int(sums[j][1]) + 1]
	var w: Array = st["wind"]
	for v in w:
		g["wind_min"] = minf(float(g["wind_min"]), float(v))
	var low := false
	for v in w:
		low = low or float(v) < 60.0
	g["wind_low60"] = int(g["wind_low60"]) + (1 if low else 0)
	var h: Array = st["head"]
	if not h.is_empty():
		g["head_max"] = maxf(float(g["head_max"]), float(h[-1]))


static func agg_out(g: Dictionary) -> Dictionary:
	var o := g.duplicate(true)
	for k in ["wind", "head"]:
		o[k] = (g[k] as Array).map(func(p): return snappedf(float(p[0]) / maxf(1.0, float(p[1])), 0.1))
	o["ce_ex"] = snappedf(float(g["ce"]) / maxf(1.0, float(g["nx"])), 0.01)
	o["ce_plan_ex"] = snappedf(float(g["ce_plan"]) / maxf(1.0, float(g["nx"])), 0.01)
	o.erase("ce")
	o.erase("ce_plan")
	return o
