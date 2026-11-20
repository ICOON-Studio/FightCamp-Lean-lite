extends RefCounted
## S531 THE COACH'S READ (owner: "build 1, 2 and 3 but it has to be distinct from theirs"; DESIGN_THREE_FROM_P4P_S531 s2).
## On every bout offer the head coach says what this bout does to THIS boxer - one verdict and two reasons, one for and one
## against - read only from her own state: the strength gap, rest since her last bout, the weight to make by that day, her
## run of results, the ladder places, her goal. Not hype and not a betting line: a step in one career.
## With no coach hired it is the owner's own guess: shorter (one reason) and marked as a guess.
## Pure: the caller (OfferCard.facts) hands in the facts.
##   read(facts) -> {"verdict": String, "for": String, "against": String, "tone": "go"|"care"|"stop", "guess": bool}
## facts: gap (int, + = she is the stronger), unsafe (bool), rest (days since her last bout, -1 none), over (kg over on the
## day, 0 = makes it), hot (bool, on a run), streak_words (String), her_rank / opp_rank (int, 0 unranked), goal (String,
## the goal's title, "" none), coach (bool), opp_style (String).

const EVEN := 3          # BoutCompare.EVEN: within this the bout is even
const UNEVEN := 7        # BoutCompare.UNEVEN: past this it is a mismatch
const SHORT_REST := 21   # days: under three weeks since her last bout is quick for an amateur
const HEAVY_CUT := 2.0   # kg over on the day the coach calls a hard cut


static func read(x: Dictionary) -> Dictionary:
	var gap := int(x.get("gap", 0))
	var pros: Array = []
	var cons: Array = []
	# Against, most serious first.
	if bool(x.get("unsafe", false)):
		cons.append("not safe yet - the experience gap is too wide")
	if gap <= -UNEVEN:
		cons.append("your boxer is the weaker by a distance (%d)" % gap)
	elif gap < -EVEN:
		cons.append("a real step up: the opponent is the stronger (%d)" % gap)
	var rest := int(x.get("rest", -1))
	if rest >= 0 and rest < SHORT_REST:
		cons.append("only %d days since the last bout" % rest)
	var over := float(x.get("over", 0.0))
	if over >= HEAVY_CUT:
		cons.append("%.1f kg still to lose by the day" % over)
	elif over > 0.0:
		cons.append("a small cut to make (%.1f kg)" % over)
	if gap >= UNEVEN:
		cons.append("little to learn from it")
	# For, best first.
	var opp_rank := int(x.get("opp_rank", 0))
	var her_rank := int(x.get("her_rank", 0))
	if opp_rank > 0 and (her_rank == 0 or opp_rank < her_rank):
		pros.append("a win over the #%d moves your boxer up the ladder" % opp_rank)
	if bool(x.get("hot", false)):
		pros.append(str(x.get("streak_words", "on a run")).to_lower())
	if str(x.get("goal", "")) != "" and gap > -UNEVEN:
		pros.append("it counts toward the goal (%s)" % str(x["goal"]).to_lower())
	if absi(gap) <= EVEN:
		pros.append("an even fight - the kind that teaches")
	elif gap > EVEN:
		pros.append("your boxer should win this (+%d)" % gap)
	# The verdict.
	var verdict := "Take it"
	var tone := "go"
	if bool(x.get("unsafe", false)) or gap <= -UNEVEN:
		verdict = "Too soon"
		tone = "stop"
	elif gap < -EVEN or over >= HEAVY_CUT or (rest >= 0 and rest < SHORT_REST):
		verdict = "Take it, but camp hard"
		tone = "care"
	elif gap >= UNEVEN:
		verdict = "Free points"
	var coach := bool(x.get("coach", true))
	var out := {"verdict": verdict, "tone": tone, "guess": not coach,
		"for": str(pros[0]) if not pros.is_empty() else "",
		"against": str(cons[0]) if not cons.is_empty() else "nothing that worries me"}
	if not coach:   # the owner's own guess: one reason, the louder one
		if tone == "go":
			out["against"] = ""
		else:
			out["for"] = ""
	return out


## One line for the card: 'Coach: "Take it, but camp hard." For: ... Against: ...' (or 'Your guess: ...').
static func line(r: Dictionary, coach_name: String) -> String:
	# S532 (owner S448 "names are only mentioned on the header"; Arena critic: the coach's name in the line): "Coach:", no name.
	var head := ("Your guess: %s." % r["verdict"]) if bool(r["guess"]) else ("Coach: \"%s.\"" % r["verdict"])
	var bits: Array = [head]
	if str(r["for"]) != "":
		bits.append("For: %s." % r["for"])
	if str(r["against"]) != "":
		bits.append("Against: %s." % r["against"])
	return "  ".join(bits)
