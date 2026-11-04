extends RefCounted
## S381 C229 stage 4 (operator "Yes, build both"; the C229 real-fight-camp design): film is earned. A phone video of her is
## only worth what the coach turns into a plan (Roach saw Hatton load up, drilled the short right hook). Each tell tape study
## has found in her file (OppFile.found) that her Playbook plan or a drilled book combination answers (PlanLines.answers)
## is worth BoutRules.FILM_PER_ANSWER on the night, at most BoutRules.FILM_EDGE_MAX. The FIGHT CAMP Film card shows
## "N/M answered" (M = the tape tells in her file a plan can answer - "Leaves the chin open" names no situation, so it is
## not counted); an opponent with no bouts on her record has "no tape" (OppFile.has_tape).
##   rows(f) -> [{id, what, value, sit, answered}] (her found tells)   answered(f) -> int   summary(f) -> {n, of, found, tape, edge}
## Pure static; reads the fighter dict (f["bout"]["opp"], f["arrows"], f["moves"], f["combos"]), changes nothing.

const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")


static func _opp(f: Dictionary) -> Dictionary:
	return (f.get("bout", {}) as Dictionary).get("opp", {})


## Her found tells, each with the situation that answers it and whether her plan does.
static func rows(f: Dictionary) -> Array:
	var opp := _opp(f)
	if opp.is_empty():
		return []
	var found := OppFile.found(opp)
	var game := OppFile.main_game(opp)
	var arrows: Array = f.get("arrows", [])
	var mastery: Dictionary = f.get("moves", {})
	var combos: Dictionary = f.get("combos", {})
	var out: Array = []
	for t in OppFile.tells(opp):
		if not found.has(str(t["id"])):
			continue
		out.append({"id": str(t["id"]), "what": str(t["what"]), "value": str(t["value"]), "sit": PlanLines.tell_sit(t),
			"answered": PlanLines.answers(arrows, t, game, mastery, combos)})
	return out


## The found tells her plan answers (the number BoutRules.fight_power reads).
static func answered(f: Dictionary) -> int:
	return rows(f).filter(func(r): return bool(r["answered"])).size()


## {n answered, of = the answerable tape tells in her file, found, tape = a video exists, edge = power points on the night}.
static func summary(f: Dictionary) -> Dictionary:
	var opp := _opp(f)
	var n := answered(f)
	var of := 0
	if not opp.is_empty():
		of = OppFile.tells(opp).filter(func(t): return str(t["how"]) != "booking" and PlanLines.tell_sit(t) != "").size()
	return {"n": n, "of": of, "found": OppFile.found(opp).size() if not opp.is_empty() else 0,
		"tape": OppFile.has_tape(opp), "edge": BoutRules.film_edge(n)}
