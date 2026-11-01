extends RefCounted
## S339 the coach's plan in the bout (operator Q-S294-61 "Yes, in that order", step 4 of STRIKEMAP_S335.md: "she follows
## it, the corner changes one arrow a round"). Each 30-second exchange is fought on one of StrikeMap's cards. She keeps the
## card her arrow took her to when she won the last exchange; otherwise the opponent's game puts the fight where she wants
## it (a presser at mid range, a range boxer at the end of her jab). On that card she throws the plan's arrow; with none
## (or one she cannot throw yet) she does whatever she has there - any of the moves out of the card she can do (shown as
## the first, her instinct). A move is worth how it answers the opponent's game (the corner calls' reading, Exchanges.MODES
## best/ok/wrong, at move level) x the pad time behind it; the plan's edge is the arrow's worth MINUS the average worth of
## everything she can do on that card. So a fighter with no plan fights exactly as the game was balanced (edge 0), an arrow
## that answers the opponent beats her average, a wrong one costs her.
## Pure static; preloads only the move map and the plan board.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

## Power points a move is worth in its exchange. Under a best shout's 15 (Exchanges.EDGE): the plan is her habit, the
## corner's shout the moment. A wrong move costs in full, drilled or not (she does the wrong thing well).
const EDGE := {"best": 9.0, "ok": 3.0, "none": 0.0, "wrong": -7.0}

## Where the opponent's game puts the fight (and where our fighter's own trouble does).
const GAME_CARD := {"press": "mid", "range": "long", "counter": "long", "loadup": "mid", "tiring": "inside",
	"hurt": "opp_ropes", "she_tired": "inside", "she_hurt": "own_ropes"}
## Losing an exchange to this game leaves her here (a presser walks her onto the ropes).
const LOST_CARD := {"press": "own_ropes", "loadup": "own_ropes"}

## The moves that answer each game (base ids: "3b-3@corner" answers as "3b-3"). The boxing reading, as the calls have it:
## press - turn her, step back, slip and counter (call "Jab and move"); walking in or cutting the ring into her is wrong.
## range - close the distance, body-head (call "Go to the body"); stepping out or trading jabs at her range is wrong.
## counter - feint, single jabs (call "Make her lead"); long combinations into her counter are wrong.
## loadup - slip, roll, step back (call "Hands up"); standing in front of her or dropping for the body is wrong.
## tiring / hurt - long combinations, herd her to the ropes (calls "Let your hands go" / "Go get her"); giving her rest is wrong.
## she_tired / she_hurt - tie up, step out, turn off the ropes (calls "Breathe" / "Tie her up"); long combinations are wrong.
const ANSWERS := {
	"press": {"best": ["step_back", "pivot_out", "slip 2-3", "roll_out", "1-1"], "ok": ["3b-3", "1-2-3b", "tie_up"],
		"wrong": ["step_in", "1-2-3-2", "cut_off", "herd"]},
	"range": {"best": ["step_in", "1-1-2", "2-3", "1-2-3b", "3b-3", "cut_off"], "ok": ["1-2", "feint"],
		"wrong": ["step_out", "step_back", "1-1"]},
	"counter": {"best": ["feint", "1-1", "1-1-2"], "ok": ["1-2", "step_in", "step_out"],
		"wrong": ["1-2-3-2", "1-2-3", "1-6-3", "2-3"]},
	"loadup": {"best": ["slip 2-3", "roll_out", "step_back", "1-1"], "ok": ["1-2", "tie_up", "pivot_out"],
		"wrong": ["3b-3", "1-6-3", "step_in", "1-2-3b"]},
	"tiring": {"best": ["1-2-3-2", "1-2-3", "3b-3", "cut_off", "herd"], "ok": ["1-2", "1-2-3b", "1-1-2", "step_in"],
		"wrong": ["step_out", "feint", "tie_up", "step_back"]},
	"hurt": {"best": ["herd", "1-6-3", "3b-3", "1-2-3-2", "cut_off"], "ok": ["1-2", "1-2-3", "2-3"],
		"wrong": ["step_out", "feint", "tie_up", "step_back"]},
	"she_tired": {"best": ["tie_up", "step_back", "step_out", "1-1"], "ok": ["roll_out", "pivot_out", "push_off"],
		"wrong": ["1-2-3-2", "1-6-3", "herd", "cut_off"]},
	"she_hurt": {"best": ["tie_up", "pivot_out", "roll_out", "step_out"], "ok": ["step_back", "1-1", "push_off"],
		"wrong": ["1-2-3-2", "1-6-3", "3b-3", "herd", "step_in", "slip 2-3"]},
}


## "3b-3@corner" -> "3b-3": the move as it answers a game, wherever it is thrown.
static func base_id(move_id: String) -> String:
	return move_id.get_slice("@", 0)


## "best" / "ok" / "wrong" / "none" for a move against a situation.
static func fit(move_id: String, sit: String) -> String:
	var row: Dictionary = ANSWERS.get(sit, {})
	var id := base_id(move_id)
	for k in ["best", "ok", "wrong"]:
		if (row.get(k, []) as Array).has(id):
			return k
	return "none"


## Whether she can do a move now: not one that happens to her, and every punch in it learned (Combos.LEARN_AT).
static func can_do(row: Dictionary, mastery: Dictionary) -> bool:
	return not row.is_empty() and str(row.get("kind", "")) != "forced" and StrikeMap.grey_reason(row, mastery) == ""


## {move, planned, instinct}: the plan's arrow on this card if she can throw it, else her instinct - the first move out of
## the card she can do (the map lists the textbook move first; "" when she has none). mastery = her punches (Data.MOVES).
static func choose(plan: Array, at: String, mastery: Dictionary) -> Dictionary:
	var instinct := ""
	for m in StrikeMap.outs(at):
		if can_do(m, mastery):
			instinct = str(m["id"])
			break
	var id := PlanBoard.pick(plan, StrikeMap.MOVES, at)
	if id != "" and can_do(StrikeMap.move(id), mastery):
		return {"move": id, "planned": true, "instinct": instinct}
	return {"move": instinct, "planned": false, "instinct": instinct}


## 1.0 for a step, a defence or a combination with its pad time (combos = her combination mastery, Combos.LEARN_AT);
## PlanBoard.UNDRILLED for a combination she has not drilled.
static func rate(move_id: String, combos: Dictionary) -> float:
	var row := StrikeMap.move(move_id)
	if str(row.get("kind", "")) != "combo":
		return 1.0
	return 1.0 if float(combos.get(str(row.get("combo", "")), 0.0)) >= Combos.LEARN_AT else PlanBoard.UNDRILLED


## What a move is worth against a situation: its fit x its rate on a plus; a wrong move in full.
static func value(move_id: String, sit: String, rate_mult: float) -> float:
	if move_id == "":
		return 0.0
	var e := float(EDGE[fit(move_id, sit)])
	return e * rate_mult if e > 0.0 else e


## The average worth of everything she can do on a card against this situation (what she brings without a plan).
static func card_mean(at: String, sit: String, mastery: Dictionary, combos: Dictionary) -> float:
	var total := 0.0
	var n := 0
	for m in StrikeMap.outs(at):
		if can_do(m, mastery):
			total += value(str(m["id"]), sit, rate(str(m["id"]), combos))
			n += 1
	return total / float(n) if n > 0 else 0.0


## The plan's power points for this exchange (pick = choose(); base = card_mean of her card): the arrow's worth minus her
## average there; 0 without an arrow.
static func edge(pick: Dictionary, sit: String, rate_mult: float, base: float) -> float:
	if not bool(pick.get("planned", false)):
		return 0.0
	return value(str(pick["move"]), sit, rate_mult) - base


## The card the next exchange is fought on: the move's own card when she won it; else where the game puts her.
static func where_next(move_id: String, won: bool, sit: String) -> String:
	if won and move_id != "":
		return str(StrikeMap.move(move_id).get("to", GAME_CARD.get(sit, "long")))
	if not won and LOST_CARD.has(sit):
		return str(LOST_CARD[sit])
	return str(GAME_CARD.get(sit, "long"))


## The plan a coach suggests before he knows her opponent (the plan board opens on it until she has her own): jab at long
## range, step back from mid, tie up inside, turn off the ropes. Four arrows - what the newest coach can hold.
static func starter() -> Array:
	return [{"move": "1-2"}, {"move": "step_back"}, {"move": "tie_up"}, {"move": "pivot_out"}]


## The round's arrows: {used, worked (won), improvised, moves: {id: [worked, used]}} from its exchange records.
static func tally(exs: Array) -> Dictionary:
	var t := {"used": 0, "worked": 0, "improvised": 0, "moves": {}}
	for x in exs:
		var id := str((x as Dictionary).get("arrow", ""))
		if id == "":
			continue
		if not bool(x.get("planned", false)):
			t["improvised"] = int(t["improvised"]) + 1
			continue
		var won := bool(x.get("won", false))
		t["used"] = int(t["used"]) + 1
		t["worked"] = int(t["worked"]) + int(won)
		var per: Array = t["moves"].get(id, [0, 0])
		t["moves"][id] = [int(per[0]) + int(won), int(per[1]) + 1]
	return t


## The corner minute's one change: arrow `index` becomes `move_id` (index == plan.size() adds one). A change that breaks
## the plan (two arrows at one place, past the coach's limit, a move that happens to her) leaves it as it was.
static func corner_change(plan: Array, index: int, move_id: String, limit: int) -> Array:
	if index < 0 or index > plan.size() or StrikeMap.move(move_id).is_empty():
		return plan
	var out: Array = PlanBoard.change_one(plan, index, move_id) if index < plan.size() else plan + [{"move": move_id}]
	return out if PlanBoard.validate(out, StrikeMap.MOVES, limit)["ok"] else plan


## The corner minute's choices (one is taken): [{i, move, from, was}] - for each arrow, the other moves out of its card she
## can do; then, under the coach's limit, a first arrow on a card she was fought on with none. Cards she was fought on
## (`fought`, most first) lead the list. was = the arrow it replaces ("" for a new one).
static func corner_options(plan: Array, mastery: Dictionary, limit: int, fought: Array) -> Array:
	var out: Array = []
	var has := {}
	for i in plan.size():
		var row := StrikeMap.move(str(plan[i]["move"]))
		if row.is_empty():
			continue
		has[str(row["from"])] = true
		for m in StrikeMap.outs(str(row["from"])):
			var id := str(m["id"])
			if id != str(plan[i]["move"]) and can_do(m, mastery) and corner_change(plan, i, id, limit) != plan:
				out.append({"i": i, "move": id, "from": str(row["from"]), "was": str(plan[i]["move"])})
	if plan.size() < limit:
		for card in fought:
			if has.has(str(card)):
				continue
			has[str(card)] = true
			for m in StrikeMap.outs(str(card)):
				if can_do(m, mastery):
					out.append({"i": plan.size(), "move": str(m["id"]), "from": str(card), "was": ""})
	var rank := func(o: Dictionary) -> int: return fought.find(o["from"]) if fought.has(o["from"]) else 99
	out.sort_custom(func(a, b): return rank.call(a) < rank.call(b))
	return out


## The cards a round was fought on, most exchanges first.
static func fought_cards(exs: Array) -> Array:
	var n := {}
	for x in exs:
		var at := str((x as Dictionary).get("at", ""))
		if at != "":
			n[at] = int(n.get(at, 0)) + 1
	var cards: Array = n.keys()
	cards.sort_custom(func(a, b): return int(n[a]) > int(n[b]))
	return cards


## The ring beat a planned step or defence opens its exchange with (FightStage moves); a tie-up is the clinch's own.
const STEP_BEAT := {"step_in": "step_in", "cut_off": "step_in", "herd": "step_in", "step_out": "step_out",
	"step_back": "step_out", "push_off": "step_out", "pivot_out": "slip", "roll_out": "slip", "feint": "slip"}


## "Plan (Mid range): Step back - it worked." / "No arrow on Long range: she does her own thing." ("" before a plan exists).
static func arrow_line(x: Dictionary, names: Array) -> String:
	var id := str(x.get("arrow", ""))
	var card := str(StrikeMap.card(str(x.get("at", ""))).get("name", ""))
	if card == "":
		return ""
	if not bool(x.get("planned", false)):
		return "No arrow on %s: %s does her own thing." % [card, names[0]]
	return "Plan (%s): %s - %s." % [card, str(StrikeMap.move(id).get("name", id)),
		"it worked" if bool(x.get("won", false)) else "it didn't come off"]
