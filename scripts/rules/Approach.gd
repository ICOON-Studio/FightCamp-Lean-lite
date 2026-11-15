extends RefCounted
## Approach - when a rival club (Eastside ABC) comes for an unhappy fighter under 35 loyalty,
## what it offers, the optional talk, and the five answers read 12 weeks on (R58 APPROACH1).
## Pure rules only: reads plain view dicts, writes no game state. No preload, no class_name.

const UNDER := 35
const WORTH_POTENTIAL := 80
const WORTH_RANK := 5
const GAP_DAYS := 84
const WINDOW_DAYS := 84
const ANSWER_DAYS := 7
const STIPEND := 250
const SHOW_COST := 3500

const TALK_BASE := 0.30
const TALK_PER := 0.60
const TALK_LANDED := 0
const TALK_FAILED := -4

const GAIN := {
	"match": 12,
	"half": 6,
	"half_landed": 10,
	"move": 12,
	"promise": 4,
	"promise_kept": 10,
}
const HOLDER_MOVE := -12
const HOLDER_HALF := -4
const TICK := -3

const TRAIN := {
	"match": 1.0,
	"half": 0.925,
	"move": 1.0,
	"holder_move": 0.85,
	"holder_half": 0.925,
}

const CAUSE_OFFER := {
	"wants_sponsor": "keep",
	"sponsor_pulled": "keep",
	"short": "keep",
	"short_running": "keep",
	"day_job": "keep",
	"offer_passed": "bout",
	"no_bout": "bout",
	"target_missed": "bout",
	"decline_pro": "debut",
	"pro_unhappy": "manager",
}

const GROUP_ORDER := ["keep", "bout", "debut", "manager"]

const OFFER_LINES := {
	"keep": "Full time: Eastside's backers pay the keep",
	"bout": "A bout on Eastside's show",
	"debut": "Eastside's promoter signs the debut",
	"manager": "A manager at 15%",
}

const BUTTON_WORDS := {
	"match": "MATCH IT",
	"half": "HALF EACH",
	"move": "MOVE THE STIPEND",
	"promise": "PROMISE: OUR SHOW",
	"let_go": "LET THEM GO",
}


## True when Eastside ABC approaches: loyalty under UNDER, worth taking, and GAP_DAYS clear.
static func due(v: Dictionary) -> bool:
	var loyalty: int = int(v.get("loyalty", 100))
	if loyalty >= UNDER:
		return false
	var potential: int = int(v.get("potential", 0))
	var rank: int = int(v.get("rank", 0))
	var is_pro: bool = bool(v.get("is_pro", false))
	var worth: bool = potential >= WORTH_POTENTIAL or (rank >= 1 and rank <= WORTH_RANK) or is_pro
	if not worth:
		return false
	var last_day: int = int(v.get("last_approach_day", -1))
	var day: int = int(v.get("day", 0))
	return last_day < 0 or day - last_day >= GAP_DAYS


## Largest negative sum per offer group inside GAP_DAYS; ties follow GROUP_ORDER.
static func offer(log: Array, day: int) -> Dictionary:
	var sums: Dictionary = {}
	for item in log:
		if not (item is Dictionary):
			continue
		var row: Dictionary = item
		var d: int = int(row.get("d", 0))
		if day - d >= GAP_DAYS:
			continue
		var n: int = int(row.get("n", 0))
		if n >= 0:
			continue
		var why: String = str(row.get("why", ""))
		if not CAUSE_OFFER.has(why):
			continue
		var grp: String = str(CAUSE_OFFER[why])
		sums[grp] = int(sums.get(grp, 0)) + n
	var best_group: String = "keep"
	var best_loss: int = 0
	for g_item in GROUP_ORDER:
		var g: String = str(g_item)
		var loss: int = int(sums.get(g, 0))
		if loss < best_loss:
			best_loss = loss
			best_group = g
	return {
		"group": best_group,
		"line": str(OFFER_LINES[best_group]),
		"loss": best_loss,
	}


## Chance a talk lands: TALK_BASE + TALK_PER * clamp(coachability, 0, 100) / 100.
static func talk_chance(coachability: int) -> float:
	return TALK_BASE + TALK_PER * float(clampi(coachability, 0, 100)) / 100.0


## Resolves the optional talk from a uniform [0, 1) roll.
static func talk(coachability: int, roll: float) -> Dictionary:
	var landed: bool = roll < talk_chance(coachability)
	var delta: int = TALK_LANDED if landed else TALK_FAILED
	return {"landed": landed, "delta": delta}


## The five answer columns in fixed order: match, half, move, promise, let_go.
static func answers(v: Dictionary) -> Array:
	var loyalty: int = int(v.get("loyalty", 0))
	var talk_state: String = str(v.get("talk", ""))
	var group: String = str(v.get("group", "keep"))
	var raw_holder: Variant = v.get("holder", {})
	var holder: Dictionary = raw_holder if raw_holder is Dictionary else {}
	var has_holder: bool = not holder.is_empty()
	var holder_loyalty: int = int(holder.get("loyalty", 0)) if has_holder else -1
	var can_book: bool = bool(v.get("can_book", false))
	var ticks_after_show: int = int(v.get("ticks_after_show", 0))
	var holder_ticks: int = int(v.get("holder_ticks", 0))
	var day: int = int(v.get("day", 0))
	var end_day: int = day + WINDOW_DAYS

	var match_cash: int = -STIPEND * 12 if group == "keep" else 0
	var match_col: Dictionary = {
		"id": "match",
		"available": true,
		"why_not": "",
		"cash": match_cash,
		"loyalty_end": clampi(loyalty + int(GAIN["match"]), 0, 100),
		"holder_end": holder_loyalty,
		"train": float(TRAIN["match"]),
		"holder_train": 1.0,
		"locked_to": end_day,
	}

	var half_ok: bool = group == "keep" and has_holder and talk_state != "failed"
	var half_why: String = ""
	if not half_ok:
		if talk_state == "failed":
			half_why = "the talk failed"
		elif not has_holder:
			half_why = "nobody holds the stipend"
		else:
			half_why = "not a stipend offer"
	var half_gain: int = int(GAIN["half_landed"]) if talk_state == "landed" else int(GAIN["half"])
	var half_col: Dictionary = {
		"id": "half",
		"available": half_ok,
		"why_not": half_why,
		"cash": 0,
		"loyalty_end": clampi(loyalty + half_gain, 0, 100),
		"holder_end": clampi(holder_loyalty + HOLDER_HALF, 0, 100) if has_holder else -1,
		"train": float(TRAIN["half"]),
		"holder_train": float(TRAIN["holder_half"]) if has_holder else 1.0,
		"locked_to": end_day,
	}

	var move_why: String = "" if has_holder else "nobody holds the stipend"
	var move_end_holder: int = -1
	if has_holder:
		move_end_holder = clampi(holder_loyalty + HOLDER_MOVE + TICK * holder_ticks, 0, 100)
	var move_col: Dictionary = {
		"id": "move",
		"available": has_holder,
		"why_not": move_why,
		"cash": 0,
		"loyalty_end": clampi(loyalty + int(GAIN["move"]), 0, 100),
		"holder_end": move_end_holder,
		"train": float(TRAIN["move"]),
		"holder_train": float(TRAIN["holder_move"]) if has_holder else 1.0,
		"locked_to": end_day,
	}

	var promise_why: String = "" if can_book else "no show can be booked now"
	var promise_gain: int = int(GAIN["promise"]) + int(GAIN["promise_kept"]) + TICK * ticks_after_show
	var promise_col: Dictionary = {
		"id": "promise",
		"available": can_book,
		"why_not": promise_why,
		"cash": -SHOW_COST,
		"loyalty_end": clampi(loyalty + promise_gain, 0, 100),
		"holder_end": holder_loyalty,
		"train": 1.0,
		"holder_train": 1.0,
		"locked_to": -1,
	}

	var let_go_col: Dictionary = {
		"id": "let_go",
		"available": true,
		"why_not": "",
		"cash": 0,
		"loyalty_end": -1,
		"holder_end": holder_loyalty,
		"train": 1.0,
		"holder_train": 1.0,
		"locked_to": -1,
	}

	return [match_col, half_col, move_col, promise_col, let_go_col]


## Button label for a column, appending " - <why_not>" when unavailable.
static func card_line(col: Dictionary) -> String:
	var id: String = str(col.get("id", ""))
	var word: String = str(BUTTON_WORDS.get(id, id))
	if not bool(col.get("available", true)):
		var why: String = str(col.get("why_not", ""))
		if why != "":
			return "%s - %s" % [word, why]
	return word
