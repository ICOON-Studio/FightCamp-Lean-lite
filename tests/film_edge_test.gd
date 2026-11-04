extends SceneTree
## S381 C229 stage 4: film is earned. Population: Lucy (Data.lucy) against Maria Ortega (OPPONENTS[0]: pressure fighter,
## "Left hook to the body", "Fades after round 2"; habits fades_late + digs_body_when_hurt), and Erin Doyle (OPPONENTS[2],
## "Leaves the chin open": a tell no plan situation answers).
##   1. PlanLines.tell_sit: a tell's own WHEN, a habit's situation, the corner call's situation, "" for the chin.
##   2. PlanLines.answers: a WHEN line that beats or works answers; a wrong move does not; a drilled book combination that
##      beats the situation answers, an undrilled one does not; nothing found = nothing to answer.
##   3. FilmEdge: answered counts found tells only (0 before tape, 1 with her weapon found); the card's M counts the
##      answerable tells; the edge is 0.4 a tell, capped at 1.2; ComboOdds.gap (the bout's opening gap) moves by exactly it.
##   4. OppFile.has_tape: a record means tape; a debutant (0-0) or a "no_tape" opponent has none.

const Data := preload("res://scripts/state/Data.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")

var failures := 0


func _initialize() -> void:
	var maria: Dictionary = Data.OPPONENTS[0].duplicate(true)
	var tells := {}
	for t in OppFile.tells(maria):
		tells[str(t["id"])] = t
	# 1. Situations.
	_check(PlanLines.tell_sit(tells["weapon"]) == "press", "her left hook to the body is answered against the press (%s)" % PlanLines.tell_sit(tells["weapon"]))
	_check(PlanLines.tell_sit(tells["habit:fades_late"]) == "tiring" and PlanLines.tell_sit(tells["habit:digs_body_when_hurt"]) == "hurt",
		"habits: hands drop late -> tiring, body when hurt -> hurt")
	_check(PlanLines.tell_sit(tells["weakness"]) == "tiring", "fades after round 2 -> tiring")
	_check(PlanLines.tell_sit({"id": "weakness", "call": "let_go", "when": ""}) == "tiring", "no WHEN: the corner call's situation")
	var erin: Dictionary = Data.OPPONENTS[2].duplicate(true)
	var chin: Dictionary = OppFile.tells(erin).filter(func(t): return str(t["id"]) == "weakness")[0]
	_check(PlanLines.tell_sit(chin) == "", "'Leaves the chin open' names no situation")
	# 2. Answers.
	var lucy: Dictionary = Data.lucy()
	var mastery := {}
	for mv in Data.MOVES:
		mastery[mv] = 60.0   # every punch learned (Data.lucy carries no move mastery)
	lucy["moves"] = mastery
	var back := [{"move": "step_back", "when": "press"}]
	_check(PlanLines.answers(back, tells["weapon"], "press", mastery, {}), "'when she presses: step back' answers the hook to the body")
	_check(PlanLines.answers([{"move": "step_back"}], tells["weapon"], "press", mastery, {}),
		"an any-time step back answers it too: pressing is her main game")
	_check(not PlanLines.answers([{"move": "step_in", "when": "press"}], tells["weapon"], "press", mastery, {}),
		"walking in on a presser (wrong) does not answer it")
	_check(PlanLines.answers([], tells["weakness"], "press", mastery, {"1-2-3-2": 40.0}), "a drilled 1-2-3-2 answers the fade")
	_check(not PlanLines.answers([], tells["weakness"], "press", mastery, {"1-2-3-2": 10.0}), "an undrilled one does not")
	_check(not PlanLines.answers(back, chin, "press", mastery, {"1-2-3-2": 40.0}), "nothing answers the chin tell")
	# 3. FilmEdge.
	var f: Dictionary = lucy.duplicate(true)
	f["arrows"] = back.duplicate(true)
	f["combos"] = {"1-2-3-2": 40.0}
	f["bout"] = {"opp": maria, "film": 1}
	var s0 := FilmEdge.summary(f)
	_check(int(s0["n"]) == 0 and int(s0["of"]) == 4 and bool(s0["tape"]) and is_equal_approx(float(s0["edge"]), 0.0),
		"before tape: 0/4 answered, +0.0 (%s)" % str(s0))
	var bare_gap := ComboOdds.gap(f, maria)
	OppFile.tape(maria)
	_check(FilmEdge.answered(f) == 1 and is_equal_approx(float(FilmEdge.summary(f)["edge"]), 0.4), "her weapon found and answered: 1, +0.4")
	OppFile.open_all(maria)
	var s4 := FilmEdge.summary(f)
	_check(int(s4["n"]) == 4 and int(s4["of"]) == 4 and is_equal_approx(float(s4["edge"]), BoutRules.FILM_EDGE_MAX),
		"her whole file answered: 4/4, capped at +1.2 (%s)" % str(s4))
	_check(is_equal_approx(ComboOdds.gap(f, maria) - bare_gap, BoutRules.FILM_EDGE_MAX), "the bout's opening gap moves by the film edge (%.2f)"
		% (ComboOdds.gap(f, maria) - bare_gap))
	f["arrows"] = []
	f["combos"] = {}
	_check(FilmEdge.answered(f) == 0, "the same file with no plan and nothing drilled: tape alone is worth nothing")
	var fe: Dictionary = lucy.duplicate(true)
	fe["bout"] = {"opp": erin}
	OppFile.open_all(erin)
	_check(int(FilmEdge.summary(fe)["of"]) == OppFile.found(erin).size() - 1, "the chin tell is not counted in M (%s)" % str(FilmEdge.summary(fe)))
	# 4. Tape.
	_check(OppFile.has_tape(Data.OPPONENTS[0]), "Maria (4-2) has tape")
	_check(not OppFile.has_tape({"name": "New Girl", "w": 0, "l": 0}), "a 0-0 debutant has no tape")
	_check(not OppFile.has_tape({"w": 3, "l": 1, "no_tape": true}), "a no_tape opponent has none")
	print("FILM_EDGE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
