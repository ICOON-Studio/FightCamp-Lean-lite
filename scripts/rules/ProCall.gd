extends RefCounted
## TURNPRO1A: the pure rules for turning pro - who calls, the two promoters' terms, one ask with a counter,
## the money apart. Pure static module: plain Dictionaries and Arrays in, plain Dictionaries out.
## Only ProDebut.gd is preloaded (its numbers are reused, never copied).
## Game text never says he, she, her or him; names only in headers.

const ProDebut := preload("res://scripts/rules/ProDebut.gd")

## ESTIMATE constants - every number the map tags ESTIMATE is here.
const BAND := 15  ## ESTIMATE
const SHORT_TICKET := 25  ## ESTIMATE
const PURSE_FLOOR := 500  ## ESTIMATE
const LOST_CUT_A_WEEK := 75  ## ESTIMATE
const AGE_STOP := 32  ## ESTIMATE
const WINDOW_DAYS := 14  ## ESTIMATE
## Roster PRO_SECOND_TERMS mirrored here (pass-in or mirror; mirror with comment naming Roster).
const SECOND_TERMS := 0.9  ## mirrors Roster.PRO_SECOND_TERMS
## Ask numbers - all ESTIMATE.
const LATER2_PURSE_CUT := 150  ## ESTIMATE
const LATER4_PURSE_CUT := 300  ## ESTIMATE
const SPLIT_TAKE_SHARE := 0.10  ## ESTIMATE
const SPLIT_TAKE_OPP := 0.5  ## ESTIMATE
const SPLIT_COUNTER_SHARE := 0.05  ## ESTIMATE
const SPLIT_TAKE_OVER := 20  ## ESTIMATE
const SPLIT_COUNTER_OVER := 5  ## ESTIMATE
const PRICE_TICKET := 40  ## ESTIMATE
const PRICE_EXTRA_TICKETS := 15  ## ESTIMATE
const COSTS_BASE_ADD := 100  ## ESTIMATE
const COSTS_RUNWAY_ADD := 200  ## ESTIMATE
const COSTS_RUNWAY_THRESHOLD := 8  ## ESTIMATE
const SOFTER_OPP_ADD := 0.5  ## ESTIMATE
const SOFTER_TUNE_UPS := 2  ## ESTIMATE


static func promoters() -> Dictionary:
	return {
		"bow": {
			"name": "Bow Lane Promotions",
			"purse": 1500,
			"step": 500,
			"top": 3000,
			"break_even": ProDebut.BREAK_EVEN,
			"share": ProDebut.HER_SHARE,
			"debut_weeks": 4,
			"opp_gap": 1.0,
			"guaranteed": false,
		},
		"hf": {
			"name": "Harrow & Finch Boxing",
			"purse": 1800,
			"step": 400,
			"top": 3000,
			"break_even": 70,
			"share": 0.3,
			"debut_weeks": 6,
			"opp_gap": 1.5,
			"guaranteed": true,
		},
	}


## Who calls based on the ticket forecast. forecast = tickets the boxer would sell (ProDebut.tickets_sold).
static func who_calls(forecast: int) -> Array:
	var bow_be: int = ProDebut.BREAK_EVEN
	if forecast >= bow_be + BAND:
		return ["bow"]
	if forecast <= bow_be - BAND:
		return ["hf"]
	return ["bow", "hf"]


## The row's money at 0.9x after a decline unless a title came since.
static func terms(key: String, declines: int, title_since_decline: bool) -> Dictionary:
	var rows: Dictionary = promoters()
	if not rows.has(key):
		return {}
	var row: Dictionary = rows[key]
	var factor: float = 1.0
	if declines > 0 and not title_since_decline:
		factor = SECOND_TERMS
		for i in range(declines - 1):
			factor *= SECOND_TERMS
	return {
		"key": key,
		"name": row["name"],
		"purse": int(round(float(row["purse"]) * factor)),
		"step": int(round(float(row["step"]) * factor)),
		"top": int(round(float(row["top"]) * factor)),
		"break_even": row["break_even"],
		"share": row["share"],
		"debut_weeks": row["debut_weeks"],
		"opp_gap": row["opp_gap"],
		"guaranteed": row["guaranteed"],
		"factor": factor,
	}


## The debut purse: hf = purse (guaranteed); bow = purse minus 25 a ticket under break_even, floor 500.
static func debut_purse(t: Dictionary, sold: int) -> int:
	var purse: int = int(t.get("purse", 0))
	if bool(t.get("guaranteed", false)):
		return purse
	var be: int = int(t.get("break_even", 0))
	if sold >= be:
		return purse
	var short: int = be - sold
	var reduced: int = purse - SHORT_TICKET * short
	return maxi(reduced, PURSE_FLOOR)


## The money breakdown: gym and boxer apart.
static func money(t: Dictionary, sold: int, costs: int, gym_share: float, stipend_paid: bool, stipend: int = 250) -> Dictionary:
	var purse: int = debut_purse(t, sold)
	var be: int = int(t.get("break_even", 0))
	var share_rate: float = float(t.get("share", 0.0))
	var above: int = maxi(0, sold - be)
	var ticket_share: int = int(round(float(above) * float(t.get("price", ProDebut.TICKET_PRICE)) * share_rate))   # S529: the deal's own price (the price ask)
	var gym_purse_cut: int = int(round(float(purse) * gym_share))
	var gym_ticket_cut: int = int(round(float(ticket_share) * gym_share))
	var gym_at_signing: int = gym_purse_cut + gym_ticket_cut - costs
	var weekly_after: int = (stipend if stipend_paid else 0) - LOST_CUT_A_WEEK
	var boxer: int = purse + ticket_share - gym_purse_cut - gym_ticket_cut
	var dw: int = int(t.get("debut_weeks", 4))
	var by_debut: int = gym_at_signing + weekly_after * dw
	var even_week: int = -1
	if weekly_after > 0:
		for w in range(1, 1000):
			if gym_at_signing + weekly_after * w >= 0:
				even_week = w
				break
	return {
		"purse": purse,
		"ticket_share": ticket_share,
		"gym_at_signing": gym_at_signing,
		"weekly_after": weekly_after,
		"by_debut": by_debut,
		"even_week": even_week,
		"boxer": boxer,
	}


## The pays-back line.
static func pays_back_line(m: Dictionary) -> String:
	var ew: int = int(m.get("even_week", -1))
	if ew > 0:
		return "The gym is about even %d weeks after signing." % ew
	return "The gym gets its money back once your boxer is ranked."


## The ask kinds available.
static func asks() -> Array:
	return ["later2", "later4", "softer", "split", "price", "costs"]


## The answers for each ask, shown before it is pressed.
static func ask_answers(t: Dictionary, forecast: int, runway_weeks: int) -> Array:
	var out: Array = []
	var be: int = int(t.get("break_even", 0))
	var key: String = str(t.get("key", ""))
	var over: int = forecast - be
	# later2
	out.append({
		"kind": "later2",
		"label": "Later debut (+2 weeks)",
		"answer": "take",
		"words": "The promoter agrees: +2 weeks for $%d less." % LATER2_PURSE_CUT,
		"after": _apply_later(t, 2, LATER2_PURSE_CUT),
	})
	# later4
	out.append({
		"kind": "later4",
		"label": "Later debut (+4 weeks)",
		"answer": "take",
		"words": "The promoter agrees: +4 weeks for $%d less." % LATER4_PURSE_CUT,
		"after": _apply_later(t, 4, LATER4_PURSE_CUT),
	})
	# softer
	out.append({
		"kind": "softer",
		"label": "Softer opponent",
		"answer": "take",
		"words": "The promoter agrees: a softer opponent, and the next %d pro offers are tune-ups." % SOFTER_TUNE_UPS,
		"after": _apply_softer(t),
	})
	# split
	var split_entry: Dictionary = _split_entry(t, over)
	out.append(split_entry)
	# price
	var price_entry: Dictionary = _price_entry(t, key)
	out.append(price_entry)
	# costs
	var costs_entry: Dictionary = _costs_entry(t, key, runway_weeks)
	out.append(costs_entry)
	return out


static func _apply_later(t: Dictionary, weeks: int, cut: int) -> Dictionary:
	var out: Dictionary = t.duplicate()
	out["debut_weeks"] = int(t.get("debut_weeks", 4)) + weeks
	out["purse"] = maxi(0, int(t.get("purse", 0)) - cut)
	return out


static func _apply_softer(t: Dictionary) -> Dictionary:
	var out: Dictionary = t.duplicate()
	out["opp_gap"] = float(t.get("opp_gap", 1.0)) + SOFTER_OPP_ADD
	out["tune_ups"] = SOFTER_TUNE_UPS
	return out


static func _split_entry(t: Dictionary, over: int) -> Dictionary:
	if over >= SPLIT_TAKE_OVER:
		var after: Dictionary = t.duplicate()
		after["share"] = float(t.get("share", 0.0)) + SPLIT_TAKE_SHARE
		after["opp_gap"] = float(t.get("opp_gap", 1.0)) - SPLIT_TAKE_OPP
		return {
			"kind": "split",
			"label": "Better split",
			"answer": "take",
			"words": "The promoter agrees: +10 share points, but the opponent is 0.5 higher.",
			"after": after,
		}
	if over >= SPLIT_COUNTER_OVER:
		var after: Dictionary = t.duplicate()
		after["share"] = float(t.get("share", 0.0)) + SPLIT_COUNTER_SHARE
		return {
			"kind": "split",
			"label": "Better split",
			"answer": "counter",
			"words": "The promoter counters: +5 share points, opponent unchanged.",
			"after": after,
		}
	return {
		"kind": "split",
		"label": "Better split",
		"answer": "wont",
		"words": "The promoter will not improve the split: the forecast is too close to break-even.",
		"after": t.duplicate(),
	}


static func _price_entry(t: Dictionary, key: String) -> Dictionary:
	if key == "bow":
		var after: Dictionary = t.duplicate()
		after["price"] = PRICE_TICKET
		after["extra_tickets"] = PRICE_EXTRA_TICKETS
		return {
			"kind": "price",
			"label": "Own ticket price",
			"answer": "take",
			"words": "The promoter agrees: $%d tickets, +%d extra tickets." % [PRICE_TICKET, PRICE_EXTRA_TICKETS],
			"after": after,
		}
	return {
		"kind": "price",
		"label": "Own ticket price",
		"answer": "wont",
		"words": "The guarantee house will not change the ticket price: the purse is fixed.",
		"after": t.duplicate(),
	}


static func _costs_entry(t: Dictionary, key: String, runway_weeks: int) -> Dictionary:
	if key == "hf":
		var add: int = COSTS_RUNWAY_ADD if runway_weeks < COSTS_RUNWAY_THRESHOLD else COSTS_BASE_ADD
		var after: Dictionary = t.duplicate()
		after["costs_covered"] = true
		after["costs_from_purse"] = add
		var counter_words: String = "+$%d from the purse" % add
		return {
			"kind": "costs",
			"label": "Costs from the purse",
			"answer": "counter",
			"words": "The promoter counters: the promoter pays the signing costs and takes %s." % counter_words,
			"after": after,
		}
	return {
		"kind": "costs",
		"label": "Costs from the purse",
		"answer": "wont",
		"words": "The ticket house will not cover costs: the purse depends on the gate.",
		"after": t.duplicate(),
	}


## Apply one ask to the terms. "wont" returns t unchanged.
static func apply_ask(t: Dictionary, entry: Dictionary, take_counter: bool) -> Dictionary:
	var answer: String = str(entry.get("answer", "wont"))
	if answer == "wont":
		return t.duplicate()
	var after: Dictionary = entry.get("after", t.duplicate())
	if answer == "counter" and not take_counter:
		return t.duplicate()
	return after


## Morale change from the boxer's ambition and the decision.
static func morale(ambition: String, stay: bool, before_nationals: bool) -> int:
	var kind: String = ambition_kind(ambition)
	if kind == "pro":
		return -5 if stay else 5
	if kind == "title":
		if stay:
			return 0
		if before_nationals:
			return -5
		return 0
	return 0


## The ambition kind from the signing card's words.
static func ambition_kind(words: String) -> String:
	var lower: String = words.to_lower()
	if lower.contains("title"):
		return "title"
	if lower.contains("pro"):
		return "pro"
	return "other"


## The age line for the offer screen.
static func age_line(age: int) -> String:
	if age >= AGE_STOP:
		return "First calls have stopped at 32."
	if age >= 29:
		return "Age %d: first calls stop at 32." % age
	return ""


## Whether first calls are still open at this age.
static func calls_open(age: int) -> bool:
	return age < AGE_STOP


## The day the offer expires.
static func expires(day: int) -> int:
	return day + WINDOW_DAYS
