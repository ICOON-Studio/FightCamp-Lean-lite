extends SceneTree
## S340 the clinch's price (operator: "during clinch a small stamina refill but risk of getting hit"): ClinchRest's rules,
## then real bouts. Population: Lucy Jackson (Data.lucy, out-boxer, technique 60) against Maria Ortega (Data.OPPONENTS[0],
## pressure fighter, rating 61.5) - two different fighters; 60 bouts on 60 different days. Control arm: the same days with
## a plan that never ties up (its exchanges carry no clinch record, so the rule cannot touch them).

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ClinchRest := preload("res://scripts/rules/ClinchRest.gd")
const ClinchBeats := preload("res://scripts/rules/ClinchBeats.gd")

const TIES := [{"move": "1-1"}, {"move": "tie_up"}, {"move": "tie_up@own_ropes"}, {"move": "step_back"}]
const NO_TIE := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}]
const BOUTS := 60

var failures := 0


func _initialize() -> void:
	_rules()
	var with := _bouts(TIES)
	var without := _bouts(NO_TIE)
	print("  ties: %d tied exchanges of %d, hit in %.2f, refill %.2f a tie, body shots taken %.2f a bout" % [with["tied"], with["all"],
		float(with["hit"]) / maxf(1.0, float(with["tied"])), float(with["refill"]) / maxf(1.0, float(with["tied"])), float(with["body"]) / BOUTS])
	print("  no tie: %d tied exchanges, body shots taken %.2f a bout" % [without["tied"], float(without["body"]) / BOUTS])
	_check(int(with["tied"]) > 0, "the tie-up plan ties up in real bouts")
	_check(int(with["mismatch"]) == 0 and int(without["mismatch"]) == 0,
		"a clinch record on exactly the exchanges she ties up in (call, arrow or instinct, clinch card): %d / %d off" % [with["mismatch"], without["mismatch"]])
	var share := float(with["hit"]) / maxf(1.0, float(with["tied"]))
	_check(share > 0.25 and share < 0.65, "a presser lands in the clinch in a bounded share of tie-ups (%.2f)" % share)
	_check(int(with["lines"]) == int(with["tied"]), "every tie-up has its words")
	print("PASS clinch_rest_test" if failures == 0 else "FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _rules() -> void:
	_check(ClinchRest.tied("tie", "", "long") and ClinchRest.tied("", "tie_up@own_ropes", "own_ropes") and ClinchRest.tied("", "", "clinch"),
		"a tie is the call, the arrow (any card) or the clinch card")
	_check(not ClinchRest.tied("long", "1-2", "long"), "a jab exchange is no tie")
	_check(is_equal_approx(ClinchRest.refill("tie"), 0.0) and ClinchRest.refill("") > 0.0 and ClinchRest.refill("") < 3.0,
		"a small refill, not on top of the corner's own tie call")
	var presser := ClinchRest.chance("Pressure fighter", 61.5, 60.0)
	var boxer := ClinchRest.chance("Out-boxer", 61.5, 60.0)
	_check(presser > boxer, "a presser works the clinch more than an out-boxer (%.2f > %.2f)" % [presser, boxer])
	_check(ClinchRest.chance("Pressure fighter", 61.5, 75.0) < presser, "a tighter tie (technique) keeps her free hand quiet")
	_check(ClinchRest.chance("Slugger", 99.0, 20.0) <= ClinchRest.CHANCE_MAX and ClinchRest.chance("Out-boxer", 20.0, 99.0) >= ClinchRest.CHANCE_MIN,
		"the chance is bounded")
	var miss := ClinchRest.roll(0.3, 0.9, 0.0, 0.0)
	_check(not bool(miss["hit"]) and is_equal_approx(float(miss["edge"]), 0.0), "a roll over the chance: nothing lands")
	var two := ClinchRest.roll(0.3, 0.1, 0.1, 0.9)
	_check(int(two["shots"]) == 2 and not bool(two["head"]) and is_equal_approx(float(two["edge"]), ClinchRest.HIT_EDGE * 2.0), "two digs to the ribs")
	var brk := ClinchRest.roll(0.3, 0.1, 0.9, 0.1)
	_check(bool(brk["head"]) and float(brk["damage"]) > 0.0, "one on the break hurts")
	var names := ["Lucy", "Maria"]
	_check(ClinchRest.line({}, names) == "", "no tie: no words")
	_check(ClinchRest.line(miss, names) == "Lucy ties Maria up and gets a breather.", "a clean tie-up's words")
	_check(ClinchRest.line(two, names).contains("Maria digs two short ones to the ribs"), "the digs in words")
	_check(ClinchRest.line(brk, names).contains("lands one on the break"), "the break in words")
	# The ring shows it: a tied exchange has her clinch, carrying the opponent's digs (Clinch.gd plays them).
	var shown := 0
	for k in 20:
		var beats: Array = [{"t": 3.0, "who": "a", "move": "jab", "result": "landed"}, {"t": 18.0, "who": "b", "move": "cross", "result": "landed"}]
		var rng := RandomNumberGenerator.new()
		rng.seed = 500 + k
		var added := ClinchBeats.apply(beats, {"n": 1, "sit": "range", "tie": two}, rng)
		var mine := added.filter(func(b): return str(b["move"]) == "clinch" and str(b["who"]) == "a" and int(b.get("digs", 0)) == 2 and str(b.get("digger", "")) == "b")
		shown += int(not mine.is_empty())
	_check(shown >= 18, "a tied exchange shows her clinch with the digs in 18+ of 20 (%d)" % shown)


## {all, tied, mismatch, hit, refill, body, lines} over BOUTS bouts with this saved plan.
func _bouts(arrows: Array) -> Dictionary:
	var out := {"all": 0, "tied": 0, "mismatch": 0, "hit": 0, "refill": 0.0, "body": 0, "lines": 0}
	for i in BOUTS:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = arrows.duplicate(true)
		f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		for r in m["rounds"]:
			for x in r["exchanges"]:
				out["all"] += 1
				out["body"] += int((x["body"] as Array)[1])
				var cl: Dictionary = x.get("clinch", {})
				if cl.is_empty() == ClinchRest.tied(str(x.get("call", "")), str(x.get("arrow", "")), str(x.get("at", ""))):
					out["mismatch"] += 1
				if cl.is_empty():
					continue
				out["tied"] += 1
				out["hit"] += int(bool(cl["hit"]))
				out["refill"] += ClinchRest.refill(str(x.get("call", "")))
				out["lines"] += int(str(x.get("clinch_line", "")) != "")
	return out


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
