extends RefCounted
## S434 PUNCHSTART1 round 1: a plan in a round, in expectation (BoutRead.chance). LiveRound fights each exchange on a CARD:
## the round opens on the card the opponent's game puts her on (PlanFight.GAME_CARD); after that, a won exchange leaves her
## on the card her move goes to and a lost one where the game puts her (PlanFight.where_next). Her arrow is thrown only on
## its own card. BoutRead read every exchange as fought on the game's card, so a plan that keeps her where its arrows live
## (a double jab won keeps her at long) was under-read and one whose card she rarely holds (a step back from mid against a
## presser who walks her to the ropes) was over-read (measured on real bouts: tests/bout_read_test.gd).
## This walks the card chain exactly over the game mix, with her chance of winning an exchange, and returns the plan's edge
## per exchange on the mean (PlanFight.edge, as LiveRound adds it; BoutRead.PLAN_CARRY adds the reads and pressure it builds).
## Pure static; one preload (PlanFight).

const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

static var _cells := {}


## {card: {sit: [edge, card if won, card if lost]}} for the cards she can stand on: what her plan does there.
static func _table(arrows: Array, moves: Dictionary, combos: Dictionary, sits: Array) -> Dictionary:
	var key := "%s|%s|%s|%s" % [str(arrows), str(moves), str(combos), str(sits)]
	if _cells.has(key):
		return _cells[key]
	var out := {}
	var todo: Array = []
	for sit in sits:
		todo.append(str(PlanFight.GAME_CARD.get(sit, "long")))
	while not todo.is_empty():
		var card := str(todo.pop_back())
		if out.has(card):
			continue
		out[card] = {}
		for sit in sits:
			var pick := PlanFight.choose(arrows, card, moves, sit)
			var mv := str(pick["move"])
			var e := PlanFight.edge(pick, sit, PlanFight.rate(mv, combos), PlanFight.card_mean(card, sit, moves, combos))
			# S459 (bout_read red since S450 FIRELEVEL3): the fight fires a planned line only on its level's share of uses
			# (LiveRound: not fired = not planned, no edge); the read takes the same share, on the mean.
			e *= FireLevel.share(FireLevel.shares_for({}), FireLevel.mastery_of({"combos": combos}, mv))
			var won := PlanFight.where_next(mv, true, sit)
			var lost := PlanFight.where_next(mv, false, sit)
			out[card][sit] = [e, won, lost]
			todo.append(won)
			todo.append(lost)
	_cells[key] = out
	return out


## The plan's edge per exchange on the mean over a round of `exchanges`: mix = {game: share}, p_win = her chance of an
## exchange.
static func round_mean(arrows: Array, moves: Dictionary, combos: Dictionary, mix: Dictionary, p_win: float, exchanges: int) -> float:
	var steps: Array = []
	for _i in maxi(exchanges, 0):
		steps.append(mix)
	return walk(arrows, moves, combos, steps, p_win, [])


## S434 round 2: the same walk over a round whose situations change by the exchange: steps[i] = {situation: share} of
## exchange i (her own trouble, the opponent tiring, the games). A she_ situation puts her on its own card, as LiveRound
## does; the card she ends on carries to the next exchange either way. The edge of a situation in `skip` is not added (the
## caller reads it elsewhere: BoutRead's she_tired and tiring), but its card moves still count.
static func walk(arrows: Array, moves: Dictionary, combos: Dictionary, steps: Array, p_win: float, skip: Array) -> float:
	var out := 0.0
	if arrows.is_empty() or steps.is_empty():
		return out
	var sits := {}
	for st in steps:
		for sit in st:
			sits[sit] = true
	var t := _table(arrows, moves, combos, sits.keys())
	var on := {"": 1.0}   # "" = the round's first exchange: the game's own card
	for st in steps:
		var nx := {}
		for card in on:
			for sit in st:
				var w := float(on[card]) * float(st[sit])
				if w <= 0.0:
					continue
				var here := str(PlanFight.GAME_CARD.get(sit, "long")) if card == "" or str(sit).begins_with("she_") else str(card)
				var cell: Array = t[here][sit]
				if not skip.has(sit):
					out += w * float(cell[0])
				nx[cell[1]] = float(nx.get(cell[1], 0.0)) + w * p_win
				nx[cell[2]] = float(nx.get(cell[2], 0.0)) + w * (1.0 - p_win)
		on = nx
	return out / float(steps.size())
