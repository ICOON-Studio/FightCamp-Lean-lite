extends RefCounted
## S308: the round being fought, exchange by exchange (Exchanges has the rules). Bouts opens it with the corner's plan and
## the round's energy, then hands each 30 seconds a shout ("" = say nothing: the plan carries on). The sixth exchange
## closes it into the round dict Bouts has always kept ({n, won, mine, theirs, corner, energy, ...} + exchanges).
## Lives in the fight moment as m["live"]. No preload of Bouts (Bouts preloads this).

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")


## Her values a call is done with: the fight stats, her footwork and her personality.
static func values(f: Dictionary) -> Dictionary:
	var v: Dictionary = (f.get("stats", {}) as Dictionary).duplicate()
	v.merge(f.get("personality", {}) as Dictionary)
	v["footwork"] = float(f.get("footwork", v.get("speed", 55.0)))
	return v


static func _rng(c: Career, f: Dictionary, n: int, i: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 31 + n * 7 + i * 101 + 3 + c.fighters.find(f) * 1009
	return rng


## Opens round n. plan = the corner minute's call ("" before round 1); e = Bouts._energy's round.
static func open(c: Career, f: Dictionary, m: Dictionary, n: int, plan: String, e: Dictionary) -> void:
	var opp: Dictionary = f["bout"]["opp"]
	var base := BoutRules.fight_power(f["stats"], f["camp"], int(f["bout"]["film"]), "") \
		+ BoutRules.weapons_edge(BoutRules.weapons(f.get("moves", {}))) + float(e.get("bonus", 0.0)) - float(opp.get("rating", 60.0))
	if n >= BoutRules.ROUNDS and float(f["stats"].get("conditioning", 0.0)) < BoutRules.FADE_CONDITIONING:
		base -= BoutRules.OWN_FADE
	if n >= BoutRules.ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
		base += BoutRules.OPP_FADE
	var rng := _rng(c, f, n, 0)
	var mode := Exchanges.next_mode(str(opp.get("style", "")), str(opp.get("weak", "")), n, 0, "", float(e.get("b", 100.0)), false, rng)
	m["live"] = {"n": n, "plan": plan, "ex": [], "shouts": 0, "mode": mode, "her_hurt": false, "opp_hurt": false,
		"cost": 0.0, "e": e, "base": base}


static func live(m: Dictionary) -> Dictionary:
	return m.get("live", {})


## Her energy as exchange i starts (the round's start -> bell, less what the calls spent).
static func her_energy(lv: Dictionary, i: int) -> float:
	var e: Dictionary = lv["e"]
	return lerpf(float(e.get("a", 100.0)), float(e.get("a_end", 100.0)), float(i) / Exchanges.EXCHANGES) - float(lv["cost"])


static func opp_energy(lv: Dictionary, i: int) -> float:
	var e: Dictionary = lv["e"]
	return lerpf(float(e.get("b", 100.0)), float(e.get("b_end", 100.0)), float(i) / Exchanges.EXCHANGES)


## What the corner sees before the next exchange: {sit, clue, offers, coach, grades {call: word}, at (seconds into the
## round)}. With full film study (depth 3) the corner reads her NEXT game; without, the one she just showed. Our own
## fighter's state is always seen.
static func preview(f: Dictionary, m: Dictionary) -> Dictionary:
	var lv := live(m)
	if lv.is_empty():
		return {}
	var i := (lv["ex"] as Array).size()
	var opp: Dictionary = f["bout"]["opp"]
	var seen := str(lv["mode"])
	if int(f["bout"]["film"]) < BoutRules.FILM_DEPTH_WITH_STUDY and i > 0:
		seen = str((lv["ex"][i - 1] as Dictionary)["mode"])
	var sit := Exchanges.situation(seen, her_energy(lv, i), bool(lv["her_hurt"]))
	var names := [str(f["first"]), str(opp["first"])]
	var vals := values(f)
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = Exchanges.grade(str(k), vals)["word"]
	return {"sit": sit, "clue": Exchanges.clue(sit, names, i + int(lv["n"]) * 3), "offers": Exchanges.offers(sit),
		"coach": str(Exchanges.MODES[sit]["best"]), "grades": grades, "at": i * Exchanges.EX_SECONDS, "i": i,
		"shouts": int(lv["shouts"])}


## Fights the next exchange with this shout ("" = say nothing). Returns the closed round after the sixth, else {}.
static func exchange(c: Career, f: Dictionary, m: Dictionary, shout: String) -> Dictionary:
	var lv := live(m)
	if lv.is_empty():
		return {}
	var exs: Array = lv["ex"]
	var i := exs.size()
	var n := int(lv["n"])
	var opp: Dictionary = f["bout"]["opp"]
	var vals := values(f)
	var sit := Exchanges.situation(str(lv["mode"]), her_energy(lv, i), bool(lv["her_hurt"]))
	var shouted := shout != "" and Exchanges.CALLS.has(shout)
	var call := shout if shouted else str(lv["plan"])
	var coach := float((f.get("personality", {}) as Dictionary).get("coachability", 55.0))
	var heard := Exchanges.uptake(coach, int(lv["shouts"]) if shouted else 0)
	if shouted:
		lv["shouts"] = int(lv["shouts"]) + 1
	var same_game := i > 0 and str((exs[i - 1] as Dictionary)["mode"]) == str(lv["mode"])
	var finds := same_game and float(vals.get("fight_iq", 55.0)) >= Exchanges.IQ_FINDS
	var d := float(lv["base"]) + Exchanges.call_edge(call, sit, vals, heard, finds)
	var rng := _rng(c, f, n, i + 1)
	var s := Exchanges.settle(d, rng.randf(), rng.randf())
	var names := [str(f["first"]), str(opp["first"])]
	var rec := {"i": i, "mode": str(lv["mode"]), "sit": sit, "call": call, "shout": shouted, "fit": Exchanges.fit(call, sit),
		"won": s["won"], "margin": s["margin"], "landed": s["landed"], "verdict": Exchanges.verdict(call, sit, bool(s["won"]), names)}
	exs.append(rec)
	if call != "":
		lv["cost"] = float(lv["cost"]) + float(Exchanges.CALLS[call]["cost"])
	# A big exchange can leave the loser hurt for the next one.
	var rating := float(opp.get("rating", 60.0))
	lv["opp_hurt"] = float(s["margin"]) > Exchanges.HURT_AT and rng.randf() < clampf(0.3 + (float(vals.get("power", 55.0)) - 55.0) / 100.0, 0.1, 0.6)
	lv["her_hurt"] = float(s["margin"]) < -Exchanges.HURT_AT and rng.randf() < clampf(0.3 + (rating - float(vals.get("chin", 55.0))) / 100.0, 0.1, 0.6)
	lv["mode"] = Exchanges.next_mode(str(opp.get("style", "")), str(opp.get("weak", "")), n, i + 1, str(lv["mode"]),
		opp_energy(lv, i + 1), bool(lv["opp_hurt"]), rng)
	if exs.size() < Exchanges.EXCHANGES:
		return {}
	return close(f, m)


static func close(f: Dictionary, m: Dictionary) -> Dictionary:
	var lv := live(m)
	var exs: Array = lv["ex"]
	var ro := Exchanges.round_of(exs)
	var e: Dictionary = (lv["e"] as Dictionary).duplicate()
	var spent := float(lv["cost"])
	e["a_end"] = maxf(0.0, float(e.get("a_end", 100.0)) - spent)
	# The calls' energy carries into the next round's start.
	var fb: Dictionary = f["bout"]
	if fb.has("energy"):
		fb["energy"]["a"] = clampf(float(fb["energy"]["a"]) - spent, 0.0, 100.0)
	var worked := 0
	var calls := 0
	for x in exs:
		if bool(x["shout"]):
			calls += 1
			worked += 1 if bool(x["won"]) and str(x["fit"]) in ["best", "ok"] else 0
	m.erase("live")
	return {"n": int(lv["n"]), "won": ro["won"], "won_n": ro["won_n"], "mine": ro["mine"], "theirs": ro["theirs"],
		"corner": str(lv["plan"]), "energy": e, "exchanges": exs, "landed": ro["landed"], "calls": calls, "worked": worked}


## Plays the rest of the open round with no shouts (the corner's plan). Returns the closed round.
static func finish(c: Career, f: Dictionary, m: Dictionary) -> Dictionary:
	var r := {}
	while not live(m).is_empty():
		r = exchange(c, f, m, "")
	return r
