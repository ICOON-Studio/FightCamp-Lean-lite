extends RefCounted
## Fight week events: the Monday pull-out roll, late replacement asks, favours with a host.
## Pure static functions: no class_name, no preload, no game state. Dice come in as floats in [0, 1).

const PULL_OUT_CHANCE := 0.35
const ROLL_DAYS_OUT := 5
const ASK_CHANCE := 1.0 / 6.0
const FAVOURS_MAX := 3
const GO_HOME_MOOD := -6
const REPLACEMENT_REP_X := 2


## The Monday of fight week the roll fires: bout_day - 5.
static func roll_day(bout_day: int) -> int:
	return bout_day - ROLL_DAYS_OUT


## True when the opponent pulls out (roll < 0.35).
static func pulls_out(roll: float) -> bool:
	return roll < PULL_OUT_CHANCE


## The fall-through card's three answers in order: take_replacement, go_home, next_month.
static func answers(favours: int, host: String) -> Array:
	var take_replacement := {
		"id": "take_replacement",
		"ok": true,
		"why": "",
		"mood": 0,
		"favours": 0,
		"rep_x": REPLACEMENT_REP_X,
	}

	var go_home := {
		"id": "go_home",
		"ok": true,
		"why": "",
		"mood": GO_HOME_MOOD,
		"favours": 0,
		"rep_x": 1,
	}

	var next_month_ok := favours >= 1
	var next_month_why := ""
	if not next_month_ok:
		next_month_why = "no favour with %s" % host

	var next_month := {
		"id": "next_month",
		"ok": next_month_ok,
		"why": next_month_why,
		"mood": 0,
		"favours": -1 if next_month_ok else 0,
		"rep_x": 1,
	}

	return [take_replacement, go_home, next_month]


## A banked week always stays, a commute that already happened refunds nothing.
static func kept_on_pull_out(banked: int, commute_paid: int) -> Dictionary:
	return {"banked": banked, "refund": 0}


## A host asks at most once per show, only when the boxer fits the gap and is READY.
static func asks(roll: float, fits_gap: bool, ready: bool, asked_this_show: bool) -> bool:
	if asked_this_show:
		return false
	if not fits_gap:
		return false
	if not ready:
		return false
	return roll < ASK_CHANCE


## Favours after filling a late gap: min(favours + 1, 3).
static func fill_gap(favours: int) -> int:
	return mini(favours + 1, FAVOURS_MAX)


## Spend favours: ok when favours >= n.
static func spend(favours: int, n: int) -> Dictionary:
	var ok := favours >= n
	return {"ok": ok, "favours": favours - n if ok else favours}


## True when the clock may still stop for this boxer's bout (at most one stop per boxer per bout).
static func one_stop(stops_this_bout: int) -> bool:
	return stops_this_bout < 1
