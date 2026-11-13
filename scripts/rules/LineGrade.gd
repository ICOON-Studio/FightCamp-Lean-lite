extends RefCounted
## S442 LINEGRADE1: how THIS boxer does each plan line (Good / OK / Poor). The corner calls' grading rule
## (Exchanges.grade, GOOD_AT 62 / OK_AT 50) applied to plan moves. Each move names two attributes; their mean
## grades it. A plus is multiplied by PLUS, a minus by Exchanges.COMMIT (a wrong move done well costs more).
## Pure static; preloads only the modules it reads. No wiring into PlanFight or the bout.

const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

## Each move's two attributes, keyed by PlanFight.base_id. The map's table (PLAYBOOK_MAP 4.1).
const DONE_WITH := {
	"1-1": ["accuracy", "speed"],
	"1-2": ["accuracy", "speed"],
	"1-1-2": ["footwork", "accuracy"],
	"2-3": ["timing", "speed"],
	"1-2-3": ["timing", "speed"],
	"1-2-3-2": ["speed", "stamina"],
	"1-2-3b": ["strength", "inside"],
	"3b-3": ["strength", "inside"],
	"1-6-3": ["inside", "explosiveness"],
	"slip 2-3": ["defence", "timing"],
	"step_in": ["footwork", "explosiveness"],
	"step_out": ["footwork", "speed"],
	"step_back": ["footwork", "speed"],
	"cut_off": ["footwork", "fight_iq"],
	"herd": ["footwork", "fight_iq"],
	"feint": ["fight_iq", "timing"],
	"pivot_out": ["footwork", "composure"],
	"roll_out": ["defence", "flexibility"],
	"tie_up": ["inside", "strength"],
	"push_off": ["strength", "durability"],
}

## The grade multipliers on a positive edge (the map's ESTIMATE; LINEGRADE1 sets them). GRADE1: a static var so the
## probe can test different tables; the fight and the forecast read it through LineGrade.edge.
## Centred on the roster's grade distribution (16% Good, 84% OK, 0% Poor): mean_mult 1.017, right_plan_GOOD within
## 10 of the ungraded baseline, Good vs Poor gap 22.2 per 100 (tools/grade_probe.gd, docs/GRADE1_RESULT.md).
static var PLUS := {"Good": 1.15, "OK": 0.99, "Poor": 0.90}

## GRADE1: the wiring switch. true = the edge reads the boxer's attributes (graded); false = ungraded (PlanFight.edge).
static var wired := true


## The boxer's attributes for grading. Attrs.of(f) when wired, {} when not ({} = ungraded baseline).
static func attrs_for(f: Dictionary) -> Dictionary:
	if not wired:
		return {}
	return Attrs.of(f)


## The boxer's grade on a move: {word, mean, pair}. Forced or unknown moves return {}.
static func grade(move_id: String, attrs: Dictionary) -> Dictionary:
	var id := PlanFight.base_id(move_id)
	if not DONE_WITH.has(id):
		return {}
	var keys: Array = DONE_WITH[id]
	var a: float = float(attrs.get(str(keys[0]), 55.0))
	var b: float = float(attrs.get(str(keys[1]), 55.0))
	var mean := (a + b) * 0.5
	var word := "Good" if mean >= Exchanges.GOOD_AT else ("OK" if mean >= Exchanges.OK_AT else "Poor")
	return {"word": word, "mean": mean, "pair": [[str(keys[0]), a], [str(keys[1]), b]]}


## What a move is worth with the grade: PlanFight.value x PLUS on a plus, x COMMIT on a minus, 0 stays 0.
static func graded_value(move_id: String, sit: String, rate_mult: float, attrs: Dictionary) -> float:
	var base := PlanFight.value(move_id, sit, rate_mult)
	if base == 0.0:
		return 0.0
	var g := grade(move_id, attrs)
	if g.is_empty():
		return base
	var word: String = str(g["word"])
	if base > 0.0:
		return base * float(PLUS[word])
	return base * float(Exchanges.COMMIT[word])


## S459 INTEGRATE1 (PROGRESSION_MAP_S448 M5 GRADE): the planned line's edge in the fight, graded - PlanFight.edge with the
## move's value through this boxer's grade (x PLUS on a plus, x COMMIT on a minus) over the ungraded no-plan baseline.
## attrs {} = ungraded (PlanFight.edge).
static func edge(pick: Dictionary, sit: String, rate_mult: float, base: float, attrs: Dictionary) -> float:
	if not bool(pick.get("planned", false)):
		return 0.0
	if attrs.is_empty():
		return PlanFight.edge(pick, sit, rate_mult, base)
	return graded_value(str(pick["move"]), sit, rate_mult, attrs) - base


## The line's worth a use: fire_share x (graded_value - the no-plan baseline card_mean).
static func worth(move_id: String, at: String, sit: String, mastery: Dictionary, combos: Dictionary,
		attrs: Dictionary, fire_share := 1.0) -> float:
	var rm := PlanFight.rate(move_id, combos)
	var gv := graded_value(move_id, sit, rm, attrs)
	var base := PlanFight.card_mean(at, sit, mastery, combos)
	return fire_share * (gv - base)


## An own chain is graded on the mean of its moves' pair means.
static func chain_grade(move_ids: Array, attrs: Dictionary) -> Dictionary:
	if move_ids.is_empty():
		return {}
	var total := 0.0
	var n := 0
	for id in move_ids:
		var g := grade(str(id), attrs)
		if g.is_empty():
			continue
		total += float(g["mean"])
		n += 1
	if n == 0:
		return {}
	var mean := total / float(n)
	var word := "Good" if mean >= Exchanges.GOOD_AT else ("OK" if mean >= Exchanges.OK_AT else "Poor")
	return {"word": word, "mean": mean, "pair": []}


## What each attribute must reach for OK and for Good with the other held. -1 when already there or above HI.
static func next_line(move_id: String, attrs: Dictionary) -> Array:
	var id := PlanFight.base_id(move_id)
	if not DONE_WITH.has(id):
		return []
	var keys: Array = DONE_WITH[id]
	var out: Array = []
	for i in 2:
		var other_i := 1 - i
		var other_val: float = float(attrs.get(str(keys[other_i]), 55.0))
		var need_ok: float = 2.0 * Exchanges.OK_AT - other_val
		var need_good: float = 2.0 * Exchanges.GOOD_AT - other_val
		var this_val: float = float(attrs.get(str(keys[i]), 55.0))
		var ok_at: float = -1.0 if this_val >= need_ok else (need_ok if need_ok <= Attrs.HI else -1.0)
		var good_at: float = -1.0 if this_val >= need_good else (need_good if need_good <= Attrs.HI else -1.0)
		out.append({"key": str(keys[i]), "ok_at": ok_at, "good_at": good_at})
	return out


## OK or Good: the coach's own plan writes only these (map 4.1 LINKS).
static func coach_ok(move_id: String, attrs: Dictionary) -> bool:
	var g := grade(move_id, attrs)
	if g.is_empty():
		return false
	return str(g["word"]) != "Poor"


## The best OTHER move out of the same card this boxer can do and whose worth is higher; {} when none.
static func swap_hint(move_id: String, sit: String, mastery: Dictionary, combos: Dictionary,
		attrs: Dictionary) -> Dictionary:
	var row := StrikeMap.move(move_id)
	if row.is_empty():
		return {}
	var from_card: String = str(row["from"])
	var cur_w := worth(move_id, from_card, sit, mastery, combos, attrs)
	var cur_g := grade(move_id, attrs)
	var cur_word: String = str(cur_g.get("word", ""))
	var best_id := ""
	var best_w := cur_w
	var best_word := cur_word
	for m in StrikeMap.outs(from_card):
		var mid: String = str(m["id"])
		if mid == move_id:
			continue
		if not PlanFight.can_do(m, mastery):
			continue
		var w := worth(mid, from_card, sit, mastery, combos, attrs)
		if w <= best_w:
			continue
		best_id = mid
		best_w = w
		var g := grade(mid, attrs)
		best_word = str(g.get("word", ""))
	if best_id == "":
		return {}
	return {"move": best_id, "worth": best_w, "was_worth": cur_w, "word": best_word, "was_word": cur_word}


## "<name> does it: Poor (Footwork 47, Speed 52)". "" for a forced move. No pronoun anywhere.
static func words(move_id: String, attrs: Dictionary, name: String) -> String:
	var g := grade(move_id, attrs)
	if g.is_empty():
		return ""
	var pair: Array = g["pair"]
	var parts: Array = []
	for p in pair:
		var key: String = str(p[0])
		var val: float = float(p[1])
		var label: String = str(Attrs.LABEL.get(key, key))
		parts.append("%s %d" % [label, roundi(val)])
	return "%s does it: %s (%s)" % [name, str(g["word"]), ", ".join(parts)]
