extends RefCounted
## R19WORTH1 what the next film buys: a hidden tell shown as a RANGE of worth. The player cannot tell whether the next
## tape session is worth a pad place until the tell is open. This module is the pure rule: no screen, no wiring.
## The unit is the plan's own worth (PlanFight power points, the unit of PlanLines' edge); turning it into exchanges
## waits for LEVERS1's table and is NOT done here.
##   candidates(kind) -> Array   kind_of(tell_id) -> String   worth_a_use(sit, mastery, combos) -> float
##   uses_a_bout(sit, opp, rounds) -> float   range_of(opp, tell_id, mastery, combos, rounds) -> Dictionary
##   next_film(opp, mastery, combos, rounds) -> Dictionary   file(opp, mastery, combos, rounds) -> Array
## Pure static; preloads OppFile, PlanLines, Exchanges.

const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

## One round's exchanges for non-game situations (tiring, hurt, ...); an ESTIMATE. LEVERS1 replaces it.
const OTHER_USES := Exchanges.EXCHANGES


## The situations a hidden tell of that kind could name, from the tables themselves (never typed).
static func candidates(kind: String) -> Array:
	var out: Dictionary = {}
	if kind == "weapon":
		for r in OppFile.WEAPON_ANSWERS:
			out[str(r[3])] = true
	elif kind == "weakness":
		for r in OppFile.WEAKNESS_ANSWERS:
			out[str(r[3])] = true
	elif kind == "habit":
		for k in PlanLines.HABIT_SITS:
			out[str(PlanLines.HABIT_SITS[k])] = true
	return out.keys()


## The kind of a tell id: "weapon", "weakness", "habit", or "".
static func kind_of(tell_id: String) -> String:
	if tell_id == "weapon":
		return "weapon"
	if tell_id == "weakness":
		return "weakness"
	if tell_id.begins_with("habit:"):
		return "habit"
	return ""


## The best usable answer's edge at this situation, floored at 0. 0 for sit "".
static func worth_a_use(sit: String, mastery: Dictionary, combos: Dictionary) -> float:
	if sit == "":
		return 0.0
	var place := PlanLines.place_for(sit)
	var opts := PlanLines.options(place, sit, mastery, combos)
	var best := 0.0
	for o in opts:
		if str(o["why"]) == "":
			var e := float(o["edge"])
			if e > best:
				best = e
	return maxf(best, 0.0)


## How many exchanges a bout has in this situation. For the four games (STYLE_MODES keys): style share x EXCHANGES x rounds.
## For other situations (tiring, hurt, ...): OTHER_USES (one round's exchanges; an ESTIMATE; LEVERS1 replaces it).
## REVIEW3: a game situation is one of the four games of ANY style row (not only this opponent's row), so a style the table
## does not know plays that game 0 times instead of falling to OTHER_USES.
static func uses_a_bout(sit: String, opp: Dictionary, rounds: int) -> float:
	var modes: Dictionary = Exchanges.STYLE_MODES.get(str(opp.get("style", "")), {})
	for row in Exchanges.STYLE_MODES.values():
		if (row as Dictionary).has(sit):
			return float(modes.get(sit, 0.0)) * float(Exchanges.EXCHANGES) * float(rounds)
	return float(OTHER_USES)


## The range of worth for a tell. Known: lo == hi for its real situation. Hidden: min/max over candidates.
static func range_of(opp: Dictionary, tell_id: String, mastery: Dictionary, combos: Dictionary, rounds: int) -> Dictionary:
	var kind := kind_of(tell_id)
	var is_known := OppFile.known(opp, tell_id)
	if is_known:
		var sit := _real_sit(opp, tell_id)
		var w := worth_a_use(sit, mastery, combos)
		var u := uses_a_bout(sit, opp, rounds)
		return {"lo": w * u, "hi": w * u, "known": true, "sits": [sit]}
	var cands := candidates(kind)
	var lo := INF
	var hi := -INF
	var sits: Array = []
	for s in cands:
		var ss := str(s)
		var w := worth_a_use(ss, mastery, combos)
		var u := uses_a_bout(ss, opp, rounds)
		var v := w * u
		if v < lo:
			lo = v
		if v > hi:
			hi = v
		sits.append(ss)
	if cands.is_empty():
		lo = 0.0
		hi = 0.0
	return {"lo": lo, "hi": hi, "known": false, "sits": sits}


## The tell the next tape session would open (first of OppFile.hidden), with its range. {} when nothing hidden or no tape.
static func next_film(opp: Dictionary, mastery: Dictionary, combos: Dictionary, rounds: int) -> Dictionary:
	if not OppFile.has_tape(opp):
		return {}
	var hidden := OppFile.hidden(opp)
	if hidden.is_empty():
		return {}
	var id := str(hidden[0])
	var r := range_of(opp, id, mastery, combos, rounds)
	var tells := OppFile.tells(opp)
	var what := ""
	for t in tells:
		if str(t["id"]) == id:
			what = str(t["what"])
			break
	return {"id": id, "what": what, "lo": r["lo"], "hi": r["hi"]}


## range_of for every "tape" tell, in the file's order.
static func file(opp: Dictionary, mastery: Dictionary, combos: Dictionary, rounds: int) -> Array:
	var out: Array = []
	for t in OppFile.tells(opp):
		if str(t["how"]) == "tape":
			out.append(range_of(opp, str(t["id"]), mastery, combos, rounds))
	return out


## The real situation of a known tell (from PlanLines.tell_sit of the tell in OppFile.tells).
static func _real_sit(opp: Dictionary, tell_id: String) -> String:
	for t in OppFile.tells(opp):
		if str(t["id"]) == tell_id:
			return PlanLines.tell_sit(t)
	return ""
