extends RefCounted
## SPLIT500: end-of-exchange bookkeeping lifted out of LiveRound.exchange so the file stays under the
## 500-line limit. Called once from exchange after the plan tally; updates lv and rec in place.

const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")


## Her energy as exchange i starts (the round's start -> bell, less what the calls spent and the body shots she took).
static func her_energy(lv: Dictionary, i: int) -> float:
	var e: Dictionary = lv["e"]
	return lerpf(float(e.get("a", 100.0)), float(e.get("a_end", 100.0)), float(i) / Exchanges.EXCHANGES) \
		- float(lv["cost"]) - float((lv.get("body", {}) as Dictionary).get("a", 0)) * Exchanges.BODY_COST


static func opp_energy(lv: Dictionary, i: int) -> float:
	var e: Dictionary = lv["e"]
	return lerpf(float(e.get("b", 100.0)), float(e.get("b_end", 100.0)), float(i) / Exchanges.EXCHANGES) \
		- float((lv.get("body", {}) as Dictionary).get("b", 0)) * float(lv.get("body_cost_b", Exchanges.BODY_COST))


## S310 what the fight display shows after i exchanges.
static func state(lv: Dictionary, i: int) -> Dictionary:
	var bt: Dictionary = lv.get("body", {})
	return {"a": maxf(0.0, her_energy(lv, i)), "b": maxf(0.0, opp_energy(lv, i)),
		"body": [int(bt.get("a", 0)), int(bt.get("b", 0))],
		"hurt": [bool(lv.get("her_hurt", false)), bool(lv.get("opp_hurt", false))]}


## End-of-exchange bookkeeping: pace cost, hurt, next mode. Updates lv and rec in place.
## The trap: dictionaries are passed by reference so changes land on the caller's copies.
static func after_exchange(lv: Dictionary, rec: Dictionary, s: Dictionary, rng: RandomNumberGenerator,
		vals: Dictionary, opp: Dictionary, call: String, pace: String, fire: bool, cl: Dictionary,
		st: Dictionary, n: int, i: int, perks: Array, names: Array) -> void:
	var exs: Array = lv["ex"]
	rec["clinch"] = cl
	rec["clinch_line"] = ClinchRest.line(cl, names, ClinchRest.why(str(opp.get("style", "")), float(opp.get("rating", 60.0)), float(vals.get("technique", 55.0))))
	rec["perks"] = perks
	rec["perk_line"] = "%s makes %s miss and counters - Counter sense." % names if perks.has("counter_sense") else ""
	lv["at"] = PlanFight.where_next(str(rec["arrow"]), bool(s["won"]), str(rec["sit"]))
	exs.append(rec)
	if call != "":
		lv["cost"] = float(lv["cost"]) + float(Exchanges.CALLS[call]["cost"])
	if not cl.is_empty():
		lv["cost"] = float(lv["cost"]) - ClinchRest.refill(call)
	# S323 the pace's price: Push spends the round's own drop faster, Save slower and she breathes back a little.
	var e0: Dictionary = lv["e"]
	var drop := maxf(0.0, float(e0.get("a", 100.0)) - float(e0.get("a_end", 100.0))) / Exchanges.EXCHANGES
	lv["cost"] = float(lv["cost"]) + drop * (PaceAim.spend(pace) - 1.0) - PaceAim.recover(pace)
	var su: Dictionary = lv.get("setup", {})
	lv["cost"] = float(lv["cost"]) + float((lv.get("talk", {}) as Dictionary).get("cost", 0.0)) \
		+ (Combos.combo_cost((Combos.row(str(su.get("combo", ""))).get("moves", []) as Array).size()) if fire else 0.0)
	# A big exchange can leave the loser hurt for the next one.
	var rating := float(opp.get("rating", 60.0))
	lv["opp_hurt"] = (float(s["margin"]) > Exchanges.HURT_AT and rng.randf() < clampf(0.3 + (float(vals.get("power", 55.0)) - 55.0) / 100.0, 0.1, 0.6)) \
		or str(rec["setup"]) == "landed"
	var rd: Dictionary = rec.get("read", {}) if rec.get("read", {}) is Dictionary else {}
	lv["her_hurt"] = float(s["margin"]) < -Exchanges.HURT_AT and rng.randf() < clampf((0.3 + (rating - float(vals.get("chin", 55.0))) / 100.0) \
		* float((lv.get("talk", {}) as Dictionary).get("hurt", 1.0)) * (1.6 if str(rec["setup"]) == "missed" or str(rd.get("result", "")) == "missed" else 1.0), 0.1, 0.8)
	rec["after"] = state(lv, i + 1)
	var run := 0
	for j in range(exs.size() - 1, -1, -1):
		if str((exs[j] as Dictionary)["mode"]) != str(lv["mode"]):
			break
		run += 1
	lv["mode"] = Exchanges.next_mode(str(opp.get("style", "")), str(opp.get("weak", "")), n, i + 1, str(lv["mode"]),
		opp_energy(lv, i + 1), bool(lv["opp_hurt"]), rng, run)
	if TheRead.dropped(st, str(lv["mode"])):   # S333: a habit punished twice is gone; she fights another way
		lv["mode"] = TheRead.swap(st, str(lv["mode"]), n + i)
