extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1, STRUCTURE_DESIGN_S395 P11; operator Q-S294-114 "Yes" to a plain
## list): the gym's upgrades and its premises. An upgrade is bought once, works after a week of fitters, costs a small
## upkeep a week and moves ONE number the player can see. Premises are tiers: a bigger place carries more members and
## more roster places, and costs more rent for good - the one bill that grows with the club.
## Prices are real fit-out and lease costs in game dollars (GBP x 1.25, section 2); effect sizes are GAME values, sized so
## nothing but the fitness classes (which need a $280-a-week assistant coach) pays for itself inside a year.
## Pure: effects take the owned ids (Career.upgrades) and return numbers.

const FIT_DAYS := 7
const LIST: Array[Dictionary] = [
	{"id": "mats", "name": "Matted floor and new ring canvas", "price": 2400, "upkeep": 15,
		"effect": "Training injury risk down 15%", "kind": "train_risk", "value": 0.85},
	{"id": "strength", "name": "Strength corner: racks, bars, a sled", "price": 3600, "upkeep": 22,
		"effect": "Power and conditioning sessions gain 10% more; the racks take room for 10 members", "kind": "gain", "value": 1.10,
		"stats": ["power", "conditioning"], "room": 10},
	{"id": "fitkit", "name": "Fitness class kit: mornings and lunchtimes", "price": 1500, "upkeep": 15,
		"effect": "Fitness classes, +$420 a week, while a second club coach runs them", "kind": "fitness", "value": 420, "needs": "assistant"},
	{"id": "youth", "name": "Youth section: DBS checks, a welfare course, juniors' nights", "price": 1800, "upkeep": 0,
		"effect": "20 juniors' dues, and a home-grown prospect at the term intakes", "kind": "youth", "value": 1},
]
## S397 designer pass (Qwen v2.1, MONEY_BITES 7.2): upkeeps +50%, the floor at the owner's fair $2,400, the youth section
## $1,800 with its DBS checks and welfare course.
## Premises by tier: members carried, rent a month, roster places, the cost of moving in (tier 0 is the opening unit). A
## bigger place also brings a bigger sponsor to the table (SPONSORS, S397 designer pass: a move is a double decision).
const PREMISES: Array[Dictionary] = [
	{"name": "Unit, 1,500 sq ft", "cap": 70, "rent": 1800, "places": 3, "move": 0},
	{"name": "Bigger unit, 3,000 sq ft, a second ring", "cap": 140, "rent": 3400, "places": 5, "move": 12000},
	{"name": "Club building, two floors", "cap": 250, "rent": 5500, "places": 7, "move": 25000},
]


const SPONSORS: Array[Dictionary] = [
	{},
	{"id": "thamesgate", "name": "Thamesgate Builders", "per": 400, "what": "their name on the ring apron", "after_win": false},
	{"id": "northline", "name": "Northline Energy", "per": 800, "what": "a patch on every fight-night robe", "after_win": false},
]
## A belt brings a title sponsor to any gym (designer pass 2: a champion lifts the whole club).
const TITLE_SPONSOR := {"id": "meridian", "name": "Meridian Bank", "per": 1000, "what": "the gym's name on the champion's banner", "after_win": false}


static func item(id: String) -> Dictionary:
	for u in LIST:
		if str(u["id"]) == id:
			return u
	return {}


## Owned rows are {"id", "day"} (the day bought); an upgrade works FIT_DAYS after.
static func ids(owned: Array) -> Array:
	return owned.map(func(o): return str((o as Dictionary).get("id", "")))


static func has(owned: Array, id: String) -> bool:
	return ids(owned).has(id)


static func ready(owned: Array, id: String, day: int) -> bool:
	for o in owned:
		if str(o["id"]) == id:
			return day >= int(o["day"]) + FIT_DAYS
	return false


## S397 designer pass 2 (Qwen v2.3, critic B "every item takes something scarce"): floor space - the members' room an
## upgrade takes (a strength zone needs 400-600 sq ft of a 1,500 sq ft unit).
static func room(owned: Array) -> int:
	var n := 0
	for id in ids(owned):
		n += int(item(id).get("room", 0))
	return n


static func upkeep(owned: Array) -> int:
	var total := 0
	for id in ids(owned):
		total += int(item(id).get("upkeep", 0))
	return total


## The product of every working upgrade of this kind's value (1.0 when none).
static func mult(owned: Array, kind: String, day: int) -> float:
	var m := 1.0
	for o in owned:
		var u := item(str(o["id"]))
		if str(u.get("kind", "")) == kind and ready(owned, str(o["id"]), day):
			m *= float(u["value"])
	return m


## A training session's gain multiplier on this stat from the working upgrades.
static func gain_mult(owned: Array, stat: String, day: int) -> float:
	var m := 1.0
	for o in owned:
		var u := item(str(o["id"]))
		if str(u.get("kind", "")) == "gain" and (u.get("stats", []) as Array).has(stat) and ready(owned, str(o["id"]), day):
			m *= float(u["value"])
	return m


## Why an upgrade cannot be bought now ("" = it can).
static func blocked(id: String, owned: Array, cash: int) -> String:
	var u := item(id)
	if u.is_empty():
		return "no such upgrade"
	if has(owned, id):
		return "owned"
	if cash < int(u["price"]):
		return "$%d short of the price" % (int(u["price"]) - cash)
	return ""


## Whether a bought upgrade is working: one that needs a staff role sits idle without it.
static func working(id: String, staff: Array) -> bool:
	var need := str(item(id).get("needs", ""))
	return need == "" or staff.has(need)


static func premises(tier: int) -> Dictionary:
	return PREMISES[clampi(tier, 0, PREMISES.size() - 1)]


## The next premises' move ("" = can move now): the top tier has none, and the move is paid in cash.
static func move_blocked(tier: int, cash: int) -> String:
	if tier >= PREMISES.size() - 1:
		return "the biggest premises already"
	var cost := int(PREMISES[tier + 1]["move"])
	return "$%d short of the price" % (cost - cash) if cash < cost else ""
