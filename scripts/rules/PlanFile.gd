extends RefCounted
## S375 SCOUTPLAN1 - the plan board reads the opponent's file (S369 playtest, ops/research/S369_PLAYTEST_TWO_FIGHTERS.md:
## "the plan board rates only the archetype, never the unlocked weapon/habit/weakness; no round-by-round line"). Each tell
## the tape has opened names the situation the ring plays it as (OppFile's answers, Exchanges.next_mode, PlanFight.refine):
## her best weapon "right hand over the jab" is her counter game, "fades after round 2" is the tiring game in round 3, "slow
## to start" is round 1's first minute. rows() finds the line of the plan that fires there - the "When ..." line for that
## situation, else the any-time line on the card the situation puts the fight on (PlanBoard.pick, exactly as the bout picks
## it) - and rates it the way the bout scores it (PlanFight.value minus what she does there without a plan).
## The ROUND row: a pace per round (push / steady / save, PaceAim) the bout opens each round on (LiveRound.open); "" = the
## corner's default (steady; the shout bar changes it inside a round). Against a slow starter a round-1 push pays COLD_EDGE more in the first COLD_EXCHANGES (she is cold).
##   rows(opp, arrows, mastery, combos) -> [{id, what, value, known, sit, round, share, place, when, move, name, fit, edge,
##       best, best_name, best_edge, say}]
##   round_hints(opp) -> {round n: [pace, why]}   cold_edge(opp, pace, n, i) -> power points   pace_for(f, n) -> pace or ""
## Pure static.

const SM := preload("res://scripts/rules/StrikeMap.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")

const PACES := ["push", "steady", "save"]
## Round 1's first exchanges against a slow starter (Exchanges.next_mode plays them as her counter game): a push there
## catches her cold. ESTIMATE, half of PaceAim's push edge (6), so a push still costs its 1.35x gas.
const COLD_EDGE := 3.0
const COLD_EXCHANGES := 2
## A habit's situation in the ring (Exchanges.next_mode / PlanFight.refine) and its round (0 = any).
const HABIT_SIT := {"fades_late": ["tiring", 3], "slow_starter": ["counter", 1], "loads_up_when_hurt": ["hurt", 0],
	"digs_body_when_hurt": ["hurt", 0]}
const SLOW_WORDS := ["slow to start", "gives away round 1"]
const FADE_WORDS := ["fades", "legs late"]


static func rows(opp: Dictionary, arrows: Array, mastery: Dictionary, combos: Dictionary) -> Array:
	var out: Array = []
	var habits := RoundStyle.opponent_habits(opp)
	for t in OppFile.tells(opp):
		var id := str(t["id"])
		if id == "look":
			continue
		var r := {"id": id, "what": str(t["what"]), "value": str(t["value"]), "known": OppFile.known(opp, id), "sit": "",
			"round": 0, "share": 0.0, "place": "", "when": "", "move": "", "name": "", "fit": "none", "edge": 0.0,
			"best": "", "best_name": "", "best_edge": 0.0, "say": str(t.get("counter", ""))}
		if not bool(r["known"]):
			r["say"] = "Not found yet: watch the tape."
			out.append(r)
			continue
		var sr := _sit_round(id, str(t.get("when", "")), str(t["value"]))
		r["sit"] = sr[0]
		r["round"] = sr[1]
		if str(r["sit"]) == "":
			out.append(r)
			continue
		r["share"] = float((Exchanges.STYLE_MODES.get(str(opp.get("style", "")), {}) as Dictionary).get(r["sit"], 0.0))
		var psit := "hurt_danger" if r["sit"] == "hurt" and habits.any(func(h): return PlanFight.HITS_BACK_HURT.has(str(h))) else str(r["sit"])
		var place := str(PlanFight.GAME_CARD.get(r["sit"], "long"))
		r["place"] = place
		var move := PlanBoard.pick(arrows, SM.MOVES, place, "", str(r["sit"]))
		var base := PlanFight.card_mean(place, psit, mastery, combos)
		if move != "" and PlanFight.can_do(SM.move(move), mastery):
			r["move"] = move
			r["name"] = str(SM.move(move).get("name", move))
			r["when"] = str(r["sit"]) if PlanLines.find(arrows, place, str(r["sit"])) >= 0 else ""
			r["fit"] = PlanFight.fit(move, psit)
			r["edge"] = PlanFight.value(move, psit, PlanFight.rate(move, combos)) - base
		for o in PlanLines.options(place, psit, mastery, combos):
			if str(o["why"]) == "":
				r["best"] = str(o["id"])
				r["best_name"] = str(o["name"])
				r["best_edge"] = float(o["edge"])
				break
		r["say"] = _say(r)
		out.append(r)
	# A habit the weakness already names (fades late = "Fades after round 2"): one row, in the weakness's words.
	var weak: Array = out.filter(func(x): return str(x["id"]) == "weakness" and bool(x["known"]) and str(x["sit"]) != "")
	if not weak.is_empty():
		out = out.filter(func(x): return not (str(x["id"]).begins_with("habit:") and str(x["sit"]) == str(weak[0]["sit"])
			and int(x["round"]) == int(weak[0]["round"])))
	return out


## [situation, round] a tell is played as in the ring ("" = THE READ's job: the corner shouts it, no plan line).
static func _sit_round(id: String, when: String, value: String) -> Array:
	var v := value.to_lower()
	if id.begins_with("habit:"):
		return HABIT_SIT.get(id.trim_prefix("habit:"), ["", 0])
	if SLOW_WORDS.any(func(w): return v.contains(w)):
		return ["counter", 1]
	if FADE_WORDS.any(func(w): return v.contains(w)):
		return ["tiring", 3]
	return [when, 0]


## The coach's line for a rated tell: what fires, how it scores, and the better answer when there is one.
static func _say(r: Dictionary) -> String:
	var place := str(PlanLines.PLACE_WORDS.get(r["place"], r["place"]))
	var head := ""
	if str(r["move"]) == "":
		head = "%s: no line - improvising" % place
	else:
		head = "%s -> %s: %s %+.0f" % [place, r["name"], str(PlanLines.FIT_WORDS.get(r["fit"], "")) if r["fit"] != "none" else "even",
			float(r["edge"])]
	if str(r["best"]) != "" and str(r["best"]) != str(r["move"]) and float(r["best_edge"]) > float(r["edge"]) + 0.5:
		head += "  ·  better: %s %+.0f" % [r["best_name"], float(r["best_edge"])]
	return head


## What the file says about the rounds: {n: [pace, why]} for a slow starter (push round 1) and a fader (push the round she
## fades in) - only from what the tape has found.
static func round_hints(opp: Dictionary) -> Dictionary:
	var out := {}
	for t in OppFile.tells(opp):
		var id := str(t["id"])
		if id == "look" or not OppFile.known(opp, id):
			continue
		var sr := _sit_round(id, str(t.get("when", "")), str(t["value"]))
		if int(sr[1]) == 1:
			out[1] = ["push", "Slow to start: push round 1 and bank it (+%d in its first minute, 1.35x gas)" % int(COLD_EDGE)]
		elif int(sr[1]) == 3:
			out[3] = ["push", "Fades late: save your legs for round 3 and push when the opponent tires"]
	return out


## Power points a push in round 1's first exchanges earns against a slow starter (0 otherwise).
static func cold_edge(opp: Dictionary, pace: String, n: int, i: int) -> float:
	if pace != "push" or n != 1 or i >= COLD_EXCHANGES:
		return 0.0
	var w := str(opp.get("weak", "")).to_lower()
	return COLD_EDGE if SLOW_WORDS.any(func(x): return w.contains(x)) else 0.0


## The pace the plan opens round n on ("" = the corner's default).
static func pace_for(f: Dictionary, n: int) -> String:
	var rp: Array = f.get("round_pace", [])
	if n < 1 or n > rp.size():
		return ""
	var p := str(rp[n - 1])
	return p if PACES.has(p) else ""


## The plan's round paces with round n set to `pace` ("" clears it), padded to n.
static func set_pace(rp: Array, n: int, pace: String) -> Array:
	var out: Array = rp.duplicate()
	while out.size() < n:
		out.append("")
	out[n - 1] = pace if PACES.has(pace) else ""
	while not out.is_empty() and str(out[-1]) == "":
		out.pop_back()
	return out
