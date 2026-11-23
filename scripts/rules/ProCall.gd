extends RefCounted
## TURNPRO1A, shrunk by S543 TURNPROBUILD17 (turning pro v17, owner Q-S294-320 / Q-S294-323): what is left of the v2 pro
## call rules once the two promoter houses, who calls by seats, the five asks and their counter-offers and the 0.9x second
## terms were cut (map DESIGN_TURNPRO1_V17.md section 6). One promoter makes one offer (ProOfferWire.make).
## What stays: the age the first calls stop at, the ambition's morale on the offer, the amateur ticket cut a week lost.
## Pure static module. Game text never says he, she, her or him; names only in headers.

const LOST_CUT_A_WEEK := 75  ## ESTIMATE: the club's amateur ticket cut a week that ends with the amateur career
const AGE_STOP := 32  ## ESTIMATE: no FIRST call at this age (a call already made returns after a Not yet)


## Morale change from the boxer's ambition and the decision.
static func morale(ambition: String, stay: bool, before_nationals: bool) -> int:
	var kind: String = ambition_kind(ambition)
	if kind == "pro":
		return -5 if stay else 5
	if kind == "title":
		if stay:
			return 0
		if before_nationals:
			return -5
		return 0
	return 0


## The ambition kind from the signing card's words.
static func ambition_kind(words: String) -> String:
	var lower: String = words.to_lower()
	if lower.contains("title"):
		return "title"
	if lower.contains("pro"):
		return "pro"
	return "other"


## The age line for the offer screen.
static func age_line(age: int) -> String:
	if age >= AGE_STOP:
		return "First calls have stopped at 32."
	if age >= 29:
		return "Age %d: first calls stop at 32." % age
	return ""


## Whether first calls are still open at this age.
static func calls_open(age: int) -> bool:
	return age < AGE_STOP
