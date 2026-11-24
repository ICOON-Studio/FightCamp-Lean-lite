extends RefCounted
## CORNERCMD2 local rules (S545, ops/research/TASK_CORNERCMD2.md; flagged, probe only; nothing under scripts/ reads this).
## Round 1's rules (tools/cornercmd1_rules.gd) with the four changes of DESIGN_CORNERCMD1.md "Round 2" as flags:
## HONEST (1, honest wind), OPEN_CALL (2, round 1 opens on the plan's call; the probe does it), RING2 (3, the ring moves the
## fight, no flat edge), GRADES2 (4, wider grades + the loading-up tie). All off = round 1 as it ran.
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
static var RING_WIND := {"cut": 1.0, "ropes": 0.5}   # round 1's ring wind (HONEST off)
static var HONEST := true
static var OPEN_CALL := true
static var RING2 := true
static var GRADES2 := true
const WIND2 := {"levels": 0.5, "first": 1.0, "sit": 0.5}   # change 1c: the built calls' scale (ESTIMATE)
const RING_WIND2 := {"cut": 0.5, "ropes": 0.0}             # change 1d (ESTIMATE)
const GRADE2 := {"Good": 1.25, "OK": 0.6, "Poor": 0.25}    # change 4a: a positive edge by grade (ESTIMATE)
const COMMIT2 := {"Good": 1.5, "OK": 1.0, "Poor": 1.0}     # change 4a: a wrong one committed - a Poor command costs in full
const PLACE_PTS := 5.0     # PlaceEdge.ROPES: the place's own unit (an OK call); the ring's wrong-moment cost (ESTIMATE)
const RING_READ := 2.0     # the reader's guess of a right ring stop's worth an exchange (one in three on his ropes x 5)
const RING2_FIT := {"cut": {"best": ["range", "counter"], "wrong": ["press", "loadup"]},
	"ropes": {"best": ["press", "loadup"], "wrong": ["range"]}}
const REFILL_SITS := ["she_tired", "she_hurt"]


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
	var gt: Dictionary = GRADE2 if GRADES2 else Exchanges.GRADE
	var mult: float = float(gt["Poor"])
	if mean >= Exchanges.GOOD_AT:
		mult = float(gt["Good"])
	elif mean >= Exchanges.SPREAD_FROM:
		mult = float(gt["OK"]) + (float(gt["Good"]) - float(gt["OK"])) * (mean - Exchanges.SPREAD_FROM) / (Exchanges.GOOD_AT - Exchanges.SPREAD_FROM)
	elif mean >= Exchanges.OK_AT:
		mult = float(gt["OK"])
	return {"word": word, "mult": mult, "mean": mean}


static func commit(word: String) -> float:
	return float((COMMIT2 if GRADES2 else Exchanges.COMMIT)[word])


static func cmd_wind(id: String) -> float:
	return float(WIND2.get(id, CMD[id]["wind"])) if HONEST else float(CMD[id]["wind"])


static func ring_wind(id: String) -> float:
	return float((RING_WIND2 if HONEST else RING_WIND)[id])


## Change 4b: at "loading up" the boxer's own answer is best, the other only OK.
static func loadup_own(vals: Dictionary) -> String:
	var hu := 0.5 * (float(vals.get("guard", 55.0)) + float(vals.get("head_movement", 55.0)))
	var bf := 0.5 * (float(vals.get("hand_speed", 55.0)) + float(vals.get("timing", 55.0)))
	return "hands" if hu > bf else "first"


static func rgrade(id: String, f: Dictionary, vals: Dictionary) -> Dictionary:
	var best := 0.0
	for s in RING[id]["steps"]:
		best = maxf(best, float((f.get("steps", {}) as Dictionary).get(s, 0.0)))
	var mean := 0.5 * best + 0.5 * float(vals.get("footwork", 55.0))
	var word := "Good" if mean >= RING_GOOD else ("OK" if mean >= RING_OK else "Poor")
	return {"word": word, "mult": float((GRADE2 if GRADES2 else Exchanges.GRADE)[word]), "mean": mean}


static func cfit(row: Dictionary, sit: String) -> String:
	for k in ["best", "ok", "wrong"]:
		if (row.get(k, []) as Array).has(sit):
			return k
	return "none"


## A FIGHT command's fit, with change 4b's loading-up rule (own = loadup_own of the boxer).
static func cfit_c(id: String, sit: String, own: String) -> String:
	var k := cfit(CMD[id], sit)
	if GRADES2 and sit == "loadup" and id in ["hands", "first"] and id != own:
		return "ok"
	return k


static func rfit(id: String, sit: String) -> String:
	return cfit(RING2_FIT[id], sit) if RING2 else cfit(RING[id], sit)


## The power points a command is worth in this moment, as the exchange gets it (heard = uptake x trust at the change).
static func cmd_edge(id: String, sit: String, g: Dictionary, heard: float, own: String = "") -> float:
	var k := cfit_c(id, sit, own)
	var e := float(Exchanges.EDGE[k])
	if id == "reset" and k == "none":
		e = RESET_GIVE
	if e > 0.0:
		return e * float(g["mult"]) * heard
	return e * heard * commit(str(g["word"]))


## Round 1: a flat ring edge. RING2: what the READER expects of a ring stop (RING_READ right, the place's cost wrong); the
## ring's real effect is the fight it moves (before()), never a flat edge on a right moment.
static func ring_edge(id: String, sit: String, g: Dictionary, heard: float) -> float:
	var k := rfit(id, sit)
	if RING2:
		if k == "best":
			return RING_READ * float(g["mult"]) * heard
		return -PLACE_PTS * heard * commit(str(g["word"])) if k == "wrong" else 0.0
	var e := float(Exchanges.EDGE[k]) * RING_SCALE
	if e > 0.0:
		return e * float(g["mult"]) * heard
	return e * heard * commit(str(g["word"]))


static func heard_of(f: Dictionary) -> float:
	return Exchanges.uptake(float((f.get("personality", {}) as Dictionary).get("coachability", 55.0)), 0) * FighterProfile.trust(f)


## The reader's pick for a moment: the FIGHT command (or none) and the RING stop (or centre) with the most edge for HER.
static func best_for(sit: String, gr: Dictionary, rg: Dictionary, heard: float, own: String = "") -> Array:
	var bc := ""
	var be := 0.0
	for c in FIGHT:
		var e := cmd_edge(str(c), sit, gr[c], heard, own)
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


## The command grade words of a boxer (the third boxer is picked by them).
static func trained_cmd(f: Dictionary) -> Dictionary:
	var vals := LiveRound.values(f)
	var out := {}
	for c in FIGHT:
		out[c] = str(cgrade(str(c), vals)["word"])
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
		"picks": {}, "cmd_on": 0, "right": 0, "wrong": 0, "changes": 0, "own": loadup_own(vals), "rope_saves": 0, "cut_pins": 0}


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


## The arm's choice for the next exchange: {cmd, ring, finish, pace, shout}.
static func decide(st: Dictionary, ctx: Dictionary, f: Dictionary) -> Dictionary:
	var pol := str(st["pol"])
	var sit := str(ctx["sit"])
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
	elif pol == "reader" or pol == "reader_nr" or pol.begins_with("coach"):
		var pick := best_for(seen_sit, st["gr"], st["rg"], float(st["heard"]), str(st["own"]))
		var follow := true
		if pol.begins_with("coach"):   # the unwatched round: he reads it right with chance by tactics, else keeps what he had
			var p := clampf((float(st["tactics"]) - COACH_A) / COACH_B, 0.0, 1.0)
			follow = (st["rng"] as RandomNumberGenerator).randf() < p
		if follow:
			d["cmd"] = pick[0]; d["ring"] = pick[1] if pol != "reader_nr" else ""   # reader_nr: the reader with the ring at Centre (a measurement)
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
		var want := cmd_edge(cmd, sit, st["gr"][cmd], heard, str(st["own"]))
		var real := str(CMD[cmd]["call"])
		if cmd == "reset" and bool(ctx["hurt"]):
			real = "tie"
		if real != "":
			shout = real
			lv["shouts"] = 0   # spec 7: no shout limit - a command is heard once, at the change, by uptake x trust
			add = want - PerkFight.call_edge(f, Exchanges.call_edge(real, sit, vals, heard, finds))
		else:
			add = want - plan_ce
		lv["cost"] = float(lv["cost"]) + cmd_wind(cmd) + honest_fix(real, sit)
		total = want
		var fk := cfit_c(cmd, sit, str(st["own"]))
		st["fits"][fk] = int(st["fits"].get(fk, 0)) + 1
		st["cmd_on"] = int(st["cmd_on"]) + 1
	var ring := str(d["ring"])
	if ring != "" and RING2:
		var re2 := ring2(st, ring, sit, lv)
		add += re2
		total += re2
		lv["cost"] = float(lv["cost"]) + ring_wind(ring)
	elif ring != "":
		var rg: Dictionary = st["rg"][ring]
		var re := ring_edge(ring, sit, rg, heard)
		add += re
		total += re
		lv["cost"] = float(lv["cost"]) + ring_wind(ring)
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
		var fk := cfit_c(cmd, str(x["sit"]), str(st["own"]))
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
static func corner_call(st: Dictionary, f: Dictionary, m: Dictionary) -> String:
	var cmd := str(st.get("cmd", ""))
	if cmd != "" and str(CMD[cmd]["call"]) != "":
		if HONEST and cmd == "reset":   # change 1a: "calm" from the stool only when she comes back tired or hurt
			var rounds: Array = m.get("rounds", [])
			var last: Dictionary = rounds[-1] if not rounds.is_empty() else {}
			var tired := float((last.get("energy", {}) as Dictionary).get("a_end", 100.0)) < Exchanges.SHE_TIRED
			if not (tired or bool(last.get("hurt_at_bell", false))):
				return BoutRules.auto_corner(f["stats"])
		return str(CMD[cmd]["call"])
	return BoutRules.auto_corner(f["stats"])


## Change 1: the wind a built call gives back outside the moment it answers is returned (calm / tie outside REFILL_SITS,
## long while Get out is the command). 0 with HONEST off.
static func honest_fix(call: String, sit: String) -> float:
	if not HONEST:
		return 0.0
	if call in ["calm", "tie"] and not REFILL_SITS.has(sit):
		return -float(Exchanges.CALLS[call]["cost"])
	if call == "long":
		return 0.5
	return 0.0


## The round's first exchange is fought inside the corner step on the corner's call: when that call is the command's own,
## the same honest correction (its sit is on the record).
static func after_open(st: Dictionary, m: Dictionary, call: String) -> void:
	var lv := LiveRound.live(m)
	var cmd := str(st.get("cmd", ""))
	if lv.is_empty() or cmd == "" or str(CMD[cmd]["call"]) != call or (lv["ex"] as Array).is_empty():
		return
	var real := "tie" if call == "calm" and bool(lv["ex"][0].get("sit", "") == "she_hurt") else call
	lv["cost"] = float(lv["cost"]) + honest_fix(real, str(lv["ex"][0].get("sit", "")))


## Change 3: the ring moves the fight. Cut (his range / counter): ring_cut for the round and his ropes count +1 with chance
## grade x heard; Ropes (press / loadup): her ropes count, pins and an own-ropes card cleared with chance grade x heard. A
## wrong moment leaves her open: -PLACE_PTS x commit x heard. Returns the points added (0 on a right moment).
static func ring2(st: Dictionary, ring: String, sit: String, lv: Dictionary) -> float:
	var rg: Dictionary = st["rg"][ring]
	var heard := float(st["heard"])
	var k := rfit(ring, sit)
	if k == "wrong":
		return -PLACE_PTS * heard * commit(str(rg["word"]))
	if k != "best":
		return 0.0
	var p := minf(1.0, float(rg["mult"]) * heard)
	var hit := (st["rng"] as RandomNumberGenerator).randf() < p
	if ring == "cut":
		lv["ring_cut"] = maxf(float(lv.get("ring_cut", 0.0)), minf(0.9, 0.5 * float(rg["mult"]) * heard))
		if hit:
			lv["opp_ropes"] = int(lv.get("opp_ropes", 0)) + 1
			st["cut_pins"] = int(st["cut_pins"]) + 1
	elif hit:
		lv["ropes"] = 0
		var pins: Array = lv.get("pins", [0, 0])
		pins[0] = 0
		lv["pins"] = pins
		if str(lv.get("at", "")) == "own_ropes":
			lv["at"] = ""   # LiveRound deals the moment's own card (PlanFight.GAME_CARD)
			st["rope_saves"] = int(st["rope_saves"]) + 1
	return 0.0


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
