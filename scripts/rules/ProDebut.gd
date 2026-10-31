extends RefCounted

const LICENCE := 230
const MEDICALS := 875
const CORNER_LICENCE := 140
const TICKETS := 100
const TICKET_PRICE := 50
const BREAK_EVEN := 60
const HER_SHARE := 0.5
const MANAGER := 0.15
const TRAINER := 0.10
const FAMILY := 20
const PER_MEMBER := 0.5
const PER_WIN := 2
const PER_TITLE := 10


static func start_costs(first_licence: bool, trainer_licensed: bool) -> int:
	var cost: int = LICENCE
	if first_licence:
		cost += MEDICALS
	if not trainer_licensed:
		cost += CORNER_LICENCE
	return cost


static func tickets_sold(members: int, am_wins: int, titles: int) -> int:
	var m: int = max(0, members)
	var w: int = max(0, am_wins)
	var t: int = max(0, titles)
	var sold: int = FAMILY + int(floor(m * PER_MEMBER)) + PER_WIN * w + PER_TITLE * t
	return clamp(sold, 0, TICKETS)


static func night(sold: int, terms: float) -> Dictionary:
	var s: int = clamp(sold, 0, TICKETS)
	var money: int = s * TICKET_PRICE
	var above: int = max(0, s - BREAK_EVEN)
	var share: int = int(round(above * TICKET_PRICE * HER_SHARE * terms))
	var gym: int = int(round(share * (MANAGER + TRAINER)))
	var her: int = share - gym
	return {"sold": s, "money": money, "above": above, "share": share, "gym": gym, "her": her}


static func sheet(members: int, am_wins: int, titles: int, first_licence: bool, trainer_licensed: bool, terms: float) -> Dictionary:
	var costs: int = start_costs(first_licence, trainer_licensed)
	var sold: int = tickets_sold(members, am_wins, titles)
	var n: Dictionary = night(sold, terms)
	return {"costs": costs, "sold": sold, "night": n, "gym_net": n["gym"] - costs}
