extends RefCounted
## S461 INTEGRATE1 #4: R26 THE TOWEL in the fight. Towel.gd is pure; this builds its state from the bout after every
## round (BoutNight._shout -> m["towel"], the corner minute card reads it) and settles the corner's answer:
##   pull     -> the bout ends retired ("RTD", a loss): PULL_DAYS out, PULL_MORALE, loyalty by band, no injury roll
##   box_safe -> the next round on "Hands up, move your head" at Save pace (PlanFile.pace_for reads bout.towel_safe)
##   one_more -> the round as called (its stoppage price is the normal KO suspension)
## When nobody answers (SKIP BOUT / the coach's own calls) the coach pulls at the line by himself (Towel.coach_pulls).
## The line (careful / normal / brave) is bout.towel_line, else the fighter's towel_line, else normal.
## Our fighter is side "a". `sides` comes from BoutNight.count_sides (passed in: no preload loop).

const Towel := preload("res://scripts/rules/Towel.gd")
const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const TRIALS := 200
const SAFE_LOSE_ADD := 0.10   # Box safe throws less: it loses a round more often, but by less (Towel softens the margin)
const DAMAGE_TO_HEAD := 2.2   # Injuries.DAMAGE_TO_WORST: the head value the bout's damage leaves (100 = fresh)
const BASE_MARGINS := {"close": 0.5, "clear": 0.35, "dominant": 0.15}


static func line_of(f: Dictionary) -> String:
	var ln := str((f.get("bout", {}) as Dictionary).get("towel_line", f.get("towel_line", "normal")))
	return ln if Towel.LINES.has(ln) else "normal"


## Towel's state from the bout after its last closed round. {} before round 1 closes.
static func state(f: Dictionary, m: Dictionary, sides: Dictionary) -> Dictionary:
	var rounds: Array = m.get("rounds", [])
	if rounds.is_empty():
		return {}
	var r: Dictionary = rounds[-1]
	sides["a"]["power"] = float(sides["a"].get("power", 60.0)) + StyleName.knock_power(f, Knockdowns.POWER_CHIN_SCALE)
	# The next round looks like the last one: lose it as often as she lost its exchanges, by the margin it had.
	var p_lose := clampf(1.0 - float(r.get("won_n", 3)) / float(Exchanges.EXCHANGES), 0.10, 0.90)
	var margins := BASE_MARGINS.duplicate()
	if not bool(r.get("won", false)):
		var last := RoundScript.margin(r)
		for k in margins.keys():
			margins[k] = 0.6 if k == last else 0.2
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	var eye := false
	var bm = m.get("body_map", {})
	if bm is Dictionary and (bm as Dictionary).has("a"):
		for p in ["left_eye", "right_eye"]:
			eye = eye or BodyMap.value(bm as Dictionary, "a", p) <= BodyMap.CRITICAL
	return {"sides": sides, "damage": dmg.duplicate(), "counts": (m.get("counts", {"a": 0, "b": 0}) as Dictionary).duplicate(),
		"p_lose": p_lose, "p_lose_safe": minf(0.95, p_lose + SAFE_LOSE_ADD), "margins": margins,
		"counts_last_round": int(r.get("counts", 0)) if str(r.get("down", "")) == "a" else 0,
		"head_v": clampf(100.0 - float(dmg.get("a", 0.0)) * DAMAGE_TO_HEAD, 0.0, 100.0), "eye_closing": eye}


## The corner minute's towel card: {comes, reasons, risk, words, coach_pulls, line}; {} when no corner follows.
static func card(c, f: Dictionary, m: Dictionary, sides: Dictionary, total: int) -> Dictionary:
	var rounds: Array = m.get("rounds", [])
	if rounds.is_empty() or rounds.size() >= total or str((rounds[-1] as Dictionary).get("stopped", "")) != "":
		return {}
	var st := state(f, m, sides)
	var ln := line_of(f)
	var risk := Towel.risk(st, TRIALS, int(c.day) * 31 + rounds.size() * 7 + 1)
	var why := Towel.reasons(st, ln, risk)
	return {"comes": not why.is_empty(), "reasons": why, "risk": risk, "words": Towel.words(risk, ln),
		"coach_pulls": Towel.coach_pulls(risk, ln), "line": ln, "round": rounds.size()}


## The corner's answer before the next round. Returns the plan to open the round on ("" = the plan's own default); a pull
## retires her instead (BoutNight then opens no round: stopped(m) == "RTD").
static func answer(c, f: Dictionary, m: Dictionary, kind: String, plan: String) -> String:
	var tc: Dictionary = m.get("towel", {})
	if kind == "" or tc.is_empty():
		return plan
	m["towel_answer"] = kind
	if kind == "pull":
		pull(c, f, m, "pulled me out")
		return plan
	if kind == "box_safe":
		f["bout"]["towel_safe"] = int(tc.get("round", 0)) + 1
		return "hands"
	return plan


## The coach's own pull when nobody answered the card (SKIP BOUT, the coach's calls). True = the bout is over.
static func coach_pull(c, f: Dictionary, m: Dictionary) -> bool:
	var tc: Dictionary = m.get("towel", {})
	if tc.is_empty() or not bool(tc.get("coach_pulls", false)):
		return false
	pull(c, f, m, "the coach pulled me out")
	return true


## Retired: the last round carries the stoppage (BoutNight.outcome_of reads "RTD" as her loss) and the lasting price is
## booked now (Injuries.after_bout skips an RTD: Towel's answer says no injury roll).
static func pull(c, f: Dictionary, m: Dictionary, mark: String) -> void:
	var rounds: Array = m["rounds"]
	var r: Dictionary = rounds[-1]
	r["stopped"] = "RTD"
	(r["lines"] as Array).append("The towel comes in: your corner retires your boxer on the stool.")
	var band := Loyalty.band(Loyalty.value(f), int(f.get("known", 0)))
	var price := Towel.answer("pull", {"band": band, "day": int(c.day)})
	m["towel_price"] = price
	f["morale"] = clampf(float(f.get("morale", FighterProfile.MORALE_START)) + float(price["morale"]), 0.0, 100.0)
	Loyalty.commit(f, int(price["loyalty"]), "towel: " + mark, int(c.day))
	var days := int(price["days_out"])
	f["injury"] = {"type": "ko", "days_out": days, "until_day": int(c.day) + days, "choice": "", "why": "retired on the stool"}
	f["next_offer_day"] = maxi(int(f.get("next_offer_day", 0)), int(c.day) + days)
