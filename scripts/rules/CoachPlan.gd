extends RefCounted
## S397 rank 3, rule 1 (docs/STRUCTURE_DESIGN_S395.md 5.3a): "If you write nothing, the coach writes one. Its worth depends
## on coach skill: from close to no plan at all, up to about half of a well-read plan. It never reads an opponent as well as
## you can." The coach plans from the tape's style only, one card at a time, most-fought card first: on each card he reads
## he writes the best answer (PlanFight.ANSWERS) to the game her style brings there most, as long as she can throw it drilled.
## Cards he does not read get no arrow, so she improvises there exactly as with no plan: a coach's plan is safe, never
## a wrong one. How many cards he reads comes from his rating (READ_AT); no coach reads none.
## No "when" arrows, no habits, no second game on a card: those are the player's to find, so the player's plan stays best.
##   CoachPlan.reads(rating) -> int   CoachPlan.cards(style) -> Array   CoachPlan.write(style, rating, mastery, combos) -> Array

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

## A card read at each of these ratings (Data.COACHES: Reid 58 reads one, Hale 74 two; no coach, Sim.NO_COACH_RATING, none).
## Two at most: measured S397 (tools/plan_effect_probe.gd, 600 close bouts vs a presser), none 45.0%, one card 52.8%, two
## 57.2% (about half of a well-read plan's 69.0%), three 67.7% - a third card would make the coach as good as the player.
const READ_AT := [50.0, 70.0]
## Losing to these games leaves her on her own ropes (PlanFight.LOST_CARD): the coach plans that card at this share.
const ROPES_SHARE := 0.5


static func reads(rating: float) -> int:
	return READ_AT.filter(func(r): return rating >= float(r)).size()


## [[card, game], ...] the cards her style puts the fight on, most first, with the game she brings to each most.
static func cards(style: String) -> Array:
	var weights: Dictionary = Exchanges.STYLE_MODES.get(style, Exchanges.STYLE_MODES["Boxer-puncher"])
	var per := {}   # card -> {game: weight}
	for g in weights:
		_add(per, str(PlanFight.GAME_CARD.get(g, "long")), str(g), float(weights[g]))
		if PlanFight.LOST_CARD.has(g):
			_add(per, str(PlanFight.LOST_CARD[g]), str(g), float(weights[g]) * ROPES_SHARE)
	var out: Array = []
	for card in per:
		var games: Dictionary = per[card]
		var top := ""
		var total := 0.0
		for g in games:
			total += float(games[g])
			if top == "" or float(games[g]) > float(games[top]):
				top = str(g)
		out.append([str(card), top, total])
	out.sort_custom(func(a, b): return float(a[2]) > float(b[2]))
	return out.map(func(x): return [x[0], x[1]])


static func _add(per: Dictionary, card: String, game: String, w: float) -> void:
	var row: Dictionary = per.get_or_add(card, {})
	row[game] = float(row.get(game, 0.0)) + w


## The coach's plan: one arrow on each card he reads, the first best answer there she can throw at full rate.
static func write(style: String, rating: float, mastery: Dictionary, combos: Dictionary) -> Array:
	var plan: Array = []
	for cg in cards(style).slice(0, reads(rating)):
		for m in StrikeMap.outs(str(cg[0])):
			var id := str(m["id"])
			if PlanFight.fit(id, str(cg[1])) == "best" and PlanFight.can_do(m, mastery) and PlanFight.rate(id, combos) >= 1.0:
				plan.append({"move": id, "coach": true})
				break
	return plan
