extends RefCounted
## S360 the game plan written as lines (operator Q-S294-91: "build it make it interactive for player, with meaningful options
## and not chores and visually and progressively rewarding"; Game Godot/research/PLAYBOOK_CLARITY_S359.md). A LINE is a place
## in the ring plus, optionally, a situation: "At long range -> One-two", "When she presses -> Step back". The lines ARE the
## plan's arrows (fighter.arrows, PlanBoard: one arrow per place + when), so the bout reads them unchanged.
## Each option is rated the way the bout scores it (PlanFight): its fit against the opponent's game (best / ok / wrong) x her
## pad time, minus what she does there without a plan - the same edge PlanFight.edge adds to the exchange.
##   lines(arrows) -> [{place, when, move, i}]   options(place, sit, mastery, combos) -> [{id, name, to, fit, why, rate, edge}]
##   set_line / clear_line -> a new arrows Array   strength(arrows, game, mastery, combos) -> {edge, beats, works, walks, untrained}
##   skill_for(n) -> the coach rating that holds n lines
##   tell_sit(tell) -> the situation that answers a tell   answers(arrows, tell, game, mastery, combos) -> bool
## Pure static; preloads the move map, the plan board and the plan fight table.

const SM := preload("res://scripts/rules/StrikeMap.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

## Ring order: where a bout goes, from outside to the corner.
const PLACES := ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]
const PLACE_WORDS := {"outside": "From outside", "long": "At long range", "mid": "At mid range", "inside": "Inside",
	"clinch": "In the clinch", "own_ropes": "On the ropes", "opp_ropes": "Opponent on the ropes", "corner": "Opponent in the corner"}
## The fit as the coach says it (no his/her on screen, S354).
const FIT_WORDS := {"best": "Beats it", "ok": "Works", "none": "", "wrong": "Walks into it"}
const FIT_ORDER := {"best": 0, "ok": 1, "none": 2, "wrong": 3}
## S381 C229 stage 4 (film is earned): the situation a found tell (OppFile.tells) is answered in. A tell names its plan
## situation (`when`); else its corner call's situation (Exchanges.CALLS "Use when ..."); a habit the ring plays goes by
## what it opens: hands that drop late or a slow start ask for long combinations (tiring), a dropped right or a lunging jab
## for straight shots / stepping off, a fighter who still hits back hurt for the hurt answers. "" = nothing to answer.
const CALL_SITS := {"long": "press", "body": "range", "lead": "counter", "hands": "loadup", "let_go": "tiring",
	"finish": "hurt", "tie": "she_hurt", "calm": "she_tired"}
const HABIT_SITS := {"fades_late": "tiring", "slow_starter": "tiring", "admires_her_work": "tiring",
	"drops_right_after_jab": "range", "lunges_with_jab": "press", "digs_body_when_hurt": "hurt", "loads_up_when_hurt": "hurt"}


## Every arrow as a line, in ring order (any-time first on a place, then its situations).
static func lines(arrows: Array) -> Array:
	var out: Array = []
	for i in arrows.size():
		var row := SM.move(str(arrows[i]["move"]))
		if row.is_empty():
			continue
		out.append({"place": str(row["from"]), "when": str(arrows[i].get("when", "")), "move": str(arrows[i]["move"]), "i": i})
	out.sort_custom(func(a, b):
		var pa := PLACES.find(a["place"])
		var pb := PLACES.find(b["place"])
		if pa != pb:
			return pa < pb
		return str(a["when"]) < str(b["when"]))
	return out


## The arrow index of the line at this place and situation, or -1.
static func find(arrows: Array, place: String, when := "") -> int:
	for i in arrows.size():
		if str(SM.move(str(arrows[i]["move"])).get("from", "")) == place and str(arrows[i].get("when", "")) == when:
			return i
	return -1


## The plan with this line's answer set to `move_id` (replaced, or a new line). A move from another place is refused.
static func set_line(arrows: Array, place: String, when: String, move_id: String) -> Array:
	if str(SM.move(move_id).get("from", "")) != place:
		return arrows
	var out: Array = arrows.duplicate(true)
	var arrow := {"move": move_id, "when": when} if when != "" else {"move": move_id}
	var i := find(arrows, place, when)
	if i >= 0:
		out[i] = arrow
	else:
		out.append(arrow)
	return out


static func clear_line(arrows: Array, place: String, when := "") -> Array:
	var out: Array = arrows.duplicate(true)
	var i := find(arrows, place, when)
	if i >= 0:
		out.remove_at(i)
	return out


## The situation a line is rated against: its own when, else the opponent's main game ("" = not known).
static func sit_for(when: String, game: String) -> String:
	return when if when != "" else game


## Where a situation puts the fight (a presser at mid range): a new "When ..." line starts on that place.
static func place_for(when: String) -> String:
	return str(PlanFight.GAME_CARD.get(when, "long"))


## The answers she has at a place, rated against `sit`: usable first, then best -> wrong. why = what she must learn first.
## edge = the power points over her no-plan average there (PlanFight.edge); 0 for a move she cannot throw yet.
static func options(place: String, sit: String, mastery: Dictionary, combos: Dictionary) -> Array:
	var base := PlanFight.card_mean(place, sit, mastery, combos) if sit != "" else 0.0
	var out: Array = []
	for m in SM.outs(place):
		var id := str(m["id"])
		var fit := PlanFight.fit(id, sit) if sit != "" else "none"
		var why := SM.grey_reason(m, mastery)
		var rate := PlanFight.rate(id, combos)
		var edge := PlanFight.value(id, sit, rate) - base if why == "" and sit != "" else 0.0
		out.append({"id": id, "name": str(m["name"]), "to": str(m["to"]), "kind": str(m["kind"]), "fit": fit, "why": why,
			"rate": rate, "edge": edge})
	out.sort_custom(func(a, b):
		if (a["why"] == "") != (b["why"] == ""):
			return a["why"] == ""
		if a["fit"] != b["fit"]:
			return int(FIT_ORDER[a["fit"]]) < int(FIT_ORDER[b["fit"]])
		return float(a["edge"]) > float(b["edge"]))
	return out


## The plan as a whole against this opponent: the summed edge of its lines and how many beat / suit / walk into the game,
## and how many lines lean on a combination she has not drilled (80% until she does).
static func strength(arrows: Array, game: String, mastery: Dictionary, combos: Dictionary) -> Dictionary:
	var s := {"edge": 0.0, "beats": 0, "works": 0, "walks": 0, "untrained": 0}
	for l in lines(arrows):
		var sit := sit_for(str(l["when"]), game)
		var row := SM.move(str(l["move"]))
		if sit == "" or not PlanFight.can_do(row, mastery):
			continue
		var rate := PlanFight.rate(str(l["move"]), combos)
		var fit := PlanFight.fit(str(l["move"]), sit)
		s["edge"] = float(s["edge"]) + PlanFight.value(str(l["move"]), sit, rate) - PlanFight.card_mean(str(l["place"]), sit, mastery, combos)
		match fit:
			"best": s["beats"] = int(s["beats"]) + 1
			"ok": s["works"] = int(s["works"]) + 1
			"wrong": s["walks"] = int(s["walks"]) + 1
		if rate < 1.0:
			s["untrained"] = int(s["untrained"]) + 1
	return s


## The coach rating that holds n lines (PlanBoard.arrow_limit inverted): 0 for what the newest coach holds.
static func skill_for(n: int) -> int:
	if n <= PlanBoard.NEW_COACH:
		return 0
	return 12 * n - 24


## The situation that answers a found tell ({id, call, when}, OppFile.tells): its when, its habit's, its call's, or "".
static func tell_sit(tell: Dictionary) -> String:
	var when := str(tell.get("when", ""))
	if when != "":
		return when
	var id := str(tell.get("id", ""))
	if id.begins_with("habit:"):
		return str(HABIT_SITS.get(id.trim_prefix("habit:"), ""))
	return str(CALL_SITS.get(str(tell.get("call", "")), ""))


## Whether her plan answers a tell: a line for its situation (its own WHEN, or an any-time line when the situation is her
## main `game`) with a move that beats it or works and that she can throw - or a drilled book combination that beats it.
static func answers(arrows: Array, tell: Dictionary, game: String, mastery: Dictionary, combos: Dictionary) -> bool:
	var sit := tell_sit(tell)
	if sit == "":
		return false
	for l in lines(arrows):
		if sit_for(str(l["when"]), game) != sit or not PlanFight.can_do(SM.move(str(l["move"])), mastery):
			continue
		if ["best", "ok"].has(PlanFight.fit(str(l["move"]), sit)):
			return true
	for m in SM.MOVES:
		if str(m.get("kind", "")) == "combo" and PlanFight.rate(str(m["id"]), combos) >= 1.0 \
				and PlanFight.fit(str(m["id"]), sit) == "best":
			return true
	return false


## S397 blind round 3 ("2 beat it · 1 work · 0 walk into it · 1 untrained"): the tally in words, zeros left out.
static func tally_words(s: Dictionary) -> String:
	var parts: Array = []
	for k in [["beats", "%d beat the opponent's game"], ["works", "%d work"], ["walks", "%d walk into it"], ["untrained", "%d not drilled yet"]]:
		if int(s.get(k[0], 0)) > 0:
			parts.append(str(k[1]) % int(s[k[0]]))
	return ("Answers: " + ", ".join(parts) + ".") if not parts.is_empty() else "No answers written yet: she improvises."
