extends RefCounted
## S537 WEIGHT3 - the scratch rules of the WEIGHT3 greybox probe (ops/research/TASK_WEIGHT3.md): the fight plan's lines a
## night is boxed on, and one bout played on them. Run by tools/weight3_probe.gd; summed by tools/weight3_probe_sum.py.
## Nothing here is in scripts/. The field and the cut model are round 5's (tools/weight2_model.gd, read only): every
## opponent took off one of the scale's cuts and pays John's table; a cut worth 15 % of Stamina or more makes him a
## fader on the game's own word. Real: Data's boxers and division sheets, AttrGen.body, every bout through BoutNight,
## and every plan line below is one the game already has (the plan's ROUND row = round_pace, the corner's call each
## round, the shout bar's aim).

const Model := preload("res://tools/weight2_model.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")

## Round 5's fit (docs/WEIGHT2_PROBE5.md section 0): rating points per 1 % of ring weight, per cm of class frame, and the
## field's offset so that our boxer wins about half at his natural class.
const FIT := {"size_rating": 0.42, "frame_rate": 0.0, "opp_off": {"club": -2.1, "champ": -2.6, "pro": -7.5}}
## The tape's read of his cut: the true cut +- this many % (1.5 = round 5's "rough" range, 3.0 = an unscouted man).
const READ_WIDTHS := [1.5, 3.0]
## A plan = {push: [from, to] the ROUND row's Push rounds; save: [from, to] its "Take this one easy" rounds; body: [from, to] rounds the aim is the body (called after the
## round's first 30 seconds, as the shout bar does); call + call_from: the corner's call from that round on, in place of
## its own pick}. Rounds are 1-based; 99 = to the last bell. FLAT = what the game boxes when nobody plans anything.
const PLANS := {
	"FLAT": {},
	"EARLY": {"push": [1, 2]},
	"P3": {"push": [3, 99]},
	"P5": {"push": [5, 99]},
	"PB3": {"push": [3, 99], "body": [3, 99]},
	"B3P5": {"push": [5, 99], "body": [3, 99]},
	"B1P5": {"push": [5, 99], "body": [1, 99]},
	"LG3": {"call": "let_go", "call_from": 3},
	"LG5": {"call": "let_go", "call_from": 5},
	"PLG5": {"push": [5, 99], "call": "let_go", "call_from": 5},
	"S1P3": {"save": [1, 2], "push": [3, 99]},
	"S1P5": {"save": [1, 2], "push": [5, 99]},
	"S1LG5": {"save": [1, 2], "call": "let_go", "call_from": 5},
	"B1LG5": {"body": [1, 99], "call": "let_go", "call_from": 5},
}
const PILOT := ["FLAT", "EARLY", "P3", "P5", "PB3", "B3P5", "B1P5", "LG3", "LG5", "PLG5", "S1P3", "S1P5"]

var n_bouts := 0

## A plan's rounds on a bout of `total` rounds: a three-round bout has one early round (1) and one late round (3).
static func span(sp: Array, total: int) -> Array:
	var from := int(sp[0]); var to := int(sp[1])
	if from <= 0:
		return [0, 0]
	if total <= 3 and from == 1 and to < 99:
		to = 1
	return [mini(from, total), mini(to, total)]

static func _in(sp: Array, n: int) -> bool:
	return int(sp[0]) > 0 and n >= int(sp[0]) and n <= int(sp[1])

## The rest of the open round: the body aim from its second 30 seconds when the plan has it, then the plan carries on.
func _rest(c: Career, f: Dictionary, m: Dictionary, plan: Dictionary, total: int) -> void:
	var n := int(m["round"])
	if _in(span(plan.get("body", [0, 0]), total), n) and not BoutNight.LiveRound.live(m).is_empty():
		BoutNight._shout(c, f, m, "|aim=body")
	BoutNight._shout_out(c, f, m)

## One bout on fight night's own code, boxed on `plan`. ni = Model.night's sums of the night (ours and his); rating =
## his strength; limit = the class. Returns {outcome, stop, rounds ("1" won / "0" lost a round), e3b (his energy as
## round 3 opens, -1 if it never did), ea (ours at the last bell)}.
## tank_off >= 0 is the WHAT-IF arm (not round 5's model, not in the game): his cut comes off HIS tank, as ours does off
## ours (bout "stale"), from round 2 on; he gets no fade word. -1 = round 5's model.
func bout(t: Dictionary, sc: Dictionary, ni: Dictionary, rating: float, limit: float, seed_i: int, k: int, grown: float, plan: Dictionary, tank_off: float = -1.0) -> Dictionary:
	var day := Model.DAY0 + seed_i * 211 + k * 7
	var f := Data.fighter_state(t.duplicate(true), day)
	for st in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		f["stats"][st] = float(f["stats"][st]) + grown
	var mult: Dictionary = ni.get("mult", {})
	var add: Dictionary = ni.get("add", {})
	for st in mult:
		f["stats"][st] = float(f["stats"][st]) * float(mult[st])
	for st in add:
		f["stats"][st] = float(f["stats"][st]) + float(add[st])
	for st in ["power", "speed", "chin", "conditioning", "defense", "fight_iq"]:
		f["stats"][st] = clampf(float(f["stats"][st]), 20.0, 95.0)
	var pl: Dictionary = Model.PLANS[1 if bool(sc["pro"]) else 0]
	var total := int(sc["rounds"])
	var ps: Array = span(plan.get("push", [0, 0]), total)
	var sv: Array = span(plan.get("save", [0, 0]), total)
	var rp: Array = []
	for n in range(1, total + 1):
		rp.append("push" if _in(ps, n) else ("save" if _in(sv, n) else ""))
	f = f.merged({"pro": bool(sc["pro"]), "morale": 60.0, "camp": {}, "week_fatigue": 20.0, "notes_seen": [], "limit": limit, "round_pace": rp,
		"arrows": (pl["arrows"] as Array).duplicate(true), "combos": (pl["combos"] as Dictionary).duplicate()}, true)
	f.erase("last_bout_day")
	var pool: Array = _pool(str(t["sex"]), limit)
	var opp: Dictionary = (pool[(seed_i * 7 + k * 3 + int(day)) % pool.size()] as Dictionary).duplicate(true)
	opp["rating"] = rating
	opp.erase("height"); opp.erase("reach")
	var rng := RandomNumberGenerator.new()
	rng.seed = hash([str(opp["name"]), limit])
	var bd: Dictionary = AttrGen.body(rng, "men" if str(t["sex"]) == "m" else "f", limit)
	opp["height"] = bd["height"]; opp["reach"] = bd["reach"]
	# The night's truth is his cut: a hard cutter fades on the game's word; a man who did not cut that hard never does
	# (a sheet opponent who fades by nature would sit in the wrong column of every table).
	var w := str(opp.get("weak", "")).to_lower()
	if bool(ni.get("fade", false)) and tank_off < 0.0:
		opp["weak"] = "Fades after round 2"
	elif w.contains("fades") or w.contains("legs late"):
		opp["weak"] = ""
	f["bout"] = {"opp": opp, "day": day, "weighed": true, "made": true, "done": false, "film": 1, "rounds": total, "stale": float(ni.get("tank", 0.0))}
	var c := Career.new()
	c.day = day; c.seed = seed_i + 1; c.coach = {"rating": 60.0}; c.fighters = [f]
	var m := {"type": "fight", "fid": f["id"], "step": "tape", "round": 0, "rounds": [], "total": total}
	BoutNight.fight_step(c, f, m, "start")
	if tank_off > 0.0:
		f["bout"]["energy"]["b"] = maxf(0.0, float(f["bout"]["energy"]["b"]) - tank_off)
	_rest(c, f, m, plan, total)
	while int(m["round"]) < total and BoutNight.stopped(m) == "" and not BoutNight.TowelWire.coach_pull(c, f, m) and not BoutNight.CrackWire.bell(c, f, m, total):
		var n := int(m["round"]) + 1
		var call := BoutRules.auto_corner(f["stats"])
		if plan.has("call") and n >= mini(int(plan["call_from"]), total):
			call = str(plan["call"])
		BoutNight._open(c, f, m, call)
		_rest(c, f, m, plan, total)
	n_bouts += 1
	var won := ""
	var e3b := -1.0; var ea := -1.0
	for r in m["rounds"]:
		won += "1" if bool(r["won"]) else "0"
		var e: Dictionary = r.get("energy", {})
		if int(r["n"]) == 3:
			e3b = float(e.get("b", -1.0))
		ea = float(e.get("a_end", -1.0))
	return {"outcome": BoutNight.outcome_of(f, m), "stop": BoutNight.stopped(m) != "", "rounds": won, "e3b": e3b, "ea": ea}

var _model: Model = Model.new()

func _pool(sex: String, limit: float) -> Array:
	return _model.pool_of(sex, limit)

## The night's sums on round 5's model (our boxer at his natural class: the STAY plan).
func night(t: Dictionary, stay: Dictionary, sc: Dictionary, share: float, day: int, cut: float) -> Dictionary:
	return _model.night(t, stay, sc, "", share, day, cut)

## The what-if arm's sums: his cut's Stamina cost as points off his tank (the cap our own boxer's has), and what is left
## in his rating (punch and reading only). Returns [tank_off, drop].
static func tank_arm(sc: Dictionary, cut: float, day: int) -> Array:
	var dm := 1.0
	for i in day:
		dm = 1.0 + float(Model.MODEL["carry"]) * dm
	var oc := Model.cost(sc, cut, dm)
	return [minf(BoutRules.TANK_MAX, float(oc["cond"])), (float(oc["power"]) + 2.0 * float(oc["read"])) * float(Model.MODEL["opp_stat"]) / 100.0 / 6.0]

## Would the plan call him a fader on this read of his cut? (the same line the model fades him at)
static func reads_fade(sc: Dictionary, seen: float, day: int) -> bool:
	var dm := 1.0
	for i in day:
		dm = 1.0 + float(Model.MODEL["carry"]) * dm
	return float(Model.cost(sc, maxf(0.0, seen), dm)["cond"]) >= float(Model.MODEL["fade_at"])
