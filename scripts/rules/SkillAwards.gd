extends RefCounted
## S370 GOALTESTS1 (operator Q-S294-92 "Yes, build it": training goals you can feel - a goal is a test she takes, a boxer
## who never competes still climbs). The road is the club skills awards England Boxing runs for boxers who train
## (research/J_TESTS1_JOHN.md: GB Boxing Awards - six grades, each 8 sessions ending in an assessment, a medal and a
## certificate). Each grade's assessment is the coach marking its moves clean on the pads: here, each of the grade's moves
## a weapon (Combos.LEARN_AT, 30 on the pads - the game's own mark for "she can throw it in a fight"); Gold's tactical
## sparring asks them SHARP (MoveMastery 60); Platinum is a bout in the ring. Her engine is read as the bleep test
## (women's norms: an average adult 21-30 reaches level 6.6, a national team about 9 - BrianMac norms, Korean national
## team study 2024, both in J_TESTS1). Pure static functions; the state lives on the fighter:
##   f["awards"] = [{"id", "d"}] passed, oldest first; f["award_sessions"] = coached sessions toward the next grade.
##   next_award(f) -> row | {}   progress(f) -> {...}   count_session(f, evening)   assess(f, day) -> row passed | {}
##   bleep(conditioning) -> level   bleep_words(level) -> String

const SESSIONS := 8
const WEAPON := 30.0    # Combos.LEARN_AT: a move she can throw in a fight
const SHARP := 60.0     # MoveMastery.tier SHARP
## The coached evenings that count as award sessions (WeekPlan.EVENINGS): pads and drills, sparring.
const COACHED := ["pads", "sparring"]

## The six grades (J_TESTS1 Q4: what each tests), and what the game asks for each assessment.
const AWARDS: Array[Dictionary] = [
	{"id": "preliminary", "name": "Preliminary", "tests": "the basics: stance, guard, moving, no contact", "moves": {}},
	{"id": "standard", "name": "Standard", "tests": "jab and rear hand while moving, the double jab, straight combinations",
		"moves": {"Jab": WEAPON, "Cross": WEAPON}},
	{"id": "bronze", "name": "Bronze", "tests": "hooks to head and body, defences, the rules, non-contact sparring",
		"moves": {"Lead hook": WEAPON, "Body hook": WEAPON}},
	{"id": "silver", "name": "Silver", "tests": "uppercuts, counters, conditioned sparring, circuits",
		"moves": {"Uppercut": WEAPON, "Check hook": WEAPON}},
	{"id": "gold", "name": "Gold", "tests": "tactical sparring, an equipment circuit, coaching others",
		"moves": {"Jab": SHARP, "Cross": SHARP, "Lead hook": SHARP, "Body hook": SHARP}},
	{"id": "platinum", "name": "Platinum", "tests": "a skills bout in the ring", "moves": {}, "bout": true},
]

## Bleep test, women: the level an average untrained adult (21-30) reaches and the national team's (J_TESTS1 Q2).
const BLEEP_ADULT := 6.6
const BLEEP_NATIONAL := 9.0
## CALIBRATION (Claude S370, for Kalli's review): the conditioning that reads as each of those two levels. A walk-in club
## boxer (conditioning 50-60) reads 7.1-7.7.
const BLEEP_ADULT_AT := 40.0
const BLEEP_NATIONAL_AT := 85.0
## S372 men (John J_TESTS3, research/J_TESTS3_ANSWER.md): an average untrained man 21-30 reaches about level 9 (MEASURED
## norm table, Bizley 2010 via BrianMac); club boxers about 12-13 and national/elite about 13-15 (DERIVED from shuttle
## distance and VO2max - no men's national team was measured on the bleep test). Read at TestDay's calibration points:
## 40 a beginner, 60 a club boxer, 85 elite.
const BLEEP_MEN_ADULT := 9.0
const BLEEP_MEN_NATIONAL := 14.0
const BLEEP_MEN_AT := [[40.0, BLEEP_MEN_ADULT], [60.0, 12.5], [85.0, BLEEP_MEN_NATIONAL]]
const BLEEP_SEXES := ["f", "m"]


static func passed(f: Dictionary) -> Array:
	return (f.get("awards", []) as Array).map(func(a): return str(a["id"]))


## The grade she works toward next; {} once Platinum is passed.
static func next_award(f: Dictionary) -> Dictionary:
	var done := passed(f)
	for a in AWARDS:
		if not done.has(str(a["id"])):
			return a
	return {}


## Where she stands on the next grade: sessions, each move against its mark, the bout, ready for the assessment or not.
static func progress(f: Dictionary) -> Dictionary:
	var a := next_award(f)
	if a.is_empty():
		return {"award": {}, "done": true}
	var sessions := mini(SESSIONS, int(f.get("award_sessions", 0)))
	var moves: Dictionary = f.get("moves", {})
	var rows: Array = []
	var ok := sessions >= SESSIONS
	for mv in (a["moves"] as Dictionary).keys():
		var now := float(moves.get(mv, 0.0))
		var need := float(a["moves"][mv])
		rows.append({"name": str(mv), "now": now, "need": need, "ok": now >= need})
		ok = ok and now >= need
	var bout_ok := int(f.get("w", 0)) + int(f.get("l", 0)) > 0
	if bool(a.get("bout", false)):
		ok = ok and bout_ok
	return {"award": a, "done": false, "sessions": sessions, "need": SESSIONS, "moves": rows, "bout": bool(a.get("bout", false)),
		"bout_ok": bout_ok, "ready": ok, "index": AWARDS.find(a)}


## One coached evening (pads and drills, sparring) toward the next grade.
static func count_session(f: Dictionary, evening: String) -> void:
	if COACHED.has(evening) and not next_award(f).is_empty():
		f["award_sessions"] = mini(SESSIONS, int(f.get("award_sessions", 0)) + 1)


## The coach's assessment (Sim runs it each Sunday): a ready grade is passed - kept with its day - and the sessions start
## again for the next one. Returns the grade passed, or {}.
static func assess(f: Dictionary, day: int) -> Dictionary:
	var p := progress(f)
	if bool(p.get("done", false)) or not bool(p["ready"]):
		return {}
	(f.get_or_add("awards", []) as Array).append({"id": str(p["award"]["id"]), "d": day})
	f["award_sessions"] = 0
	return p["award"]


## The bleep-test level from conditioning: women linear between their two anchors (4.0-12.0 at the ends), men through
## their three (4.0-16.0).
static func bleep(conditioning: float, sex: String = "f") -> float:
	if sex == "m":
		var i := 1
		while i < BLEEP_MEN_AT.size() - 1 and conditioning > float(BLEEP_MEN_AT[i][0]):
			i += 1
		var u := (conditioning - float(BLEEP_MEN_AT[i - 1][0])) / (float(BLEEP_MEN_AT[i][0]) - float(BLEEP_MEN_AT[i - 1][0]))
		return snappedf(clampf(lerpf(float(BLEEP_MEN_AT[i - 1][1]), float(BLEEP_MEN_AT[i][1]), u), 4.0, 16.0), 0.1)
	var t := (conditioning - BLEEP_ADULT_AT) / (BLEEP_NATIONAL_AT - BLEEP_ADULT_AT)
	return snappedf(clampf(lerpf(BLEEP_ADULT, BLEEP_NATIONAL, t), 4.0, 12.0), 0.1)


## True when the bleep norms exist for that sex ("f" / "m").
static func bleep_known(sex: String) -> bool:
	return BLEEP_SEXES.has(sex)


## The average untrained adult's level and the national team's, for that sex.
static func bleep_norms(sex: String = "f") -> Vector2:
	return Vector2(BLEEP_MEN_ADULT, BLEEP_MEN_NATIONAL) if sex == "m" else Vector2(BLEEP_ADULT, BLEEP_NATIONAL)


## Where a level sits against the norms, in words.
static func bleep_words(level: float, sex: String = "f") -> String:
	var n := bleep_norms(sex)
	if level >= n.y:
		return "national-team level"
	if level >= (n.x + n.y) * 0.5:
		return "well above an average adult"
	if level >= n.x:
		return "above an average adult (%.1f)" % n.x
	return "below an average adult (%.1f)" % n.x
