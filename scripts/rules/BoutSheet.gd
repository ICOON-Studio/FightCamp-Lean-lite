extends RefCounted
## The amateur bout sheet: slots, swap, pass, refusals, rematch, rest window.
## Pure static functions, no class_name, no preload, no game state.
## A boxer is {"id": String, "sex": "f"|"m", "div": String, "last_bout_day": int, "ready_day": int}.
## A slot is {"show": String, "day": int, "sex": String, "div": String, "named": bool, "opp": String}.

const MAX_CARDS := 3
const REFUSE_LIMIT := 2
const REFUSE_WINDOW_DAYS := 56
const LOCKOUT_DAYS := 56
const LEAD_WEEKS_MIN := 1
const LEAD_WEEKS_MAX := 3
const REST_WINDOWS := [3, 5, 8]
const REST_DEFAULT := 3
const RUST_WEEKS := 6


## Deterministic 1..3 from hash(key) (same idea as AmateurBooking.lead_weeks).
static func lead_weeks(key: String) -> int:
	var span := LEAD_WEEKS_MAX - LEAD_WEEKS_MIN + 1
	return LEAD_WEEKS_MIN + int(absi(key.hash()) % span)


## The latest of last_bout_day + 7*window_weeks, suspension_end and stop_rest_end.
## window_weeks not in REST_WINDOWS -> REST_DEFAULT.
static func rest_ready_day(last_bout_day: int, window_weeks: int, suspension_end: int, stop_rest_end: int) -> int:
	var w := window_weeks
	if not REST_WINDOWS.has(w):
		w = REST_DEFAULT
	var ready := last_bout_day + 7 * w
	if suspension_end > ready:
		ready = suspension_end
	if stop_rest_end > ready:
		ready = stop_rest_end
	return ready


## Boxers of the slot's sex and div whose ready_day <= slot.day, ordered by
## who has waited longer (lowest last_bout_day first; -1 = never boxed = longest wait; tie -> id order).
static func eligible(boxers: Array, slot: Dictionary) -> Array:
	var out := []
	for b in boxers:
		if b.sex == slot.sex and b.div == slot.div and b.ready_day <= slot.day:
			out.append(b)
	out.sort_custom(func(a, b):
		if a.last_bout_day != b.last_bout_day:
			return a.last_bout_day < b.last_bout_day
		return a.id < b.id
	)
	return out


## The boxer id the slot goes to: first eligible, unless swapped has key slot_key(slot) naming another eligible id.
## "" when nobody is eligible.
static func holder(boxers: Array, slot: Dictionary, swapped: Dictionary) -> String:
	var el := eligible(boxers, slot)
	if el.is_empty():
		return ""
	var sk := slot_key(slot)
	if swapped.has(sk):
		var sid: String = swapped[sk]
		for b in el:
			if b.id == sid:
				return sid
	return el[0].id


## "%s:%d:%s" % [show, day, div].
static func slot_key(slot: Dictionary) -> String:
	return "%s:%d:%s" % [slot.show, slot.day, slot.div]


## Gives the slot to the next eligible boxer after the current holder (wraps around).
## Writes swapped[slot_key] = that id and returns it. "" when fewer than two eligible.
static func swap(boxers: Array, slot: Dictionary, swapped: Dictionary) -> String:
	var el := eligible(boxers, slot)
	if el.size() < 2:
		return ""
	var cur := holder(boxers, slot, swapped)
	var idx := -1
	for i in el.size():
		if el[i].id == cur:
			idx = i
			break
	var nxt := (idx + 1) % el.size()
	var sk := slot_key(slot)
	swapped[sk] = el[nxt].id
	return el[nxt].id


## "this slot went to your other %s boxer".
static func swap_note(div_short: String) -> String:
	return "this slot went to your other %s boxer" % div_short


## The slots this boxer holds, skipping shows in locked whose value (unlock day) > day;
## at most MAX_CARDS, soonest first.
static func sheet(boxer: Dictionary, slots: Array, boxers: Array, swapped: Dictionary, locked: Dictionary, day: int) -> Array:
	var out := []
	for s in slots:
		if holder(boxers, s, swapped) != boxer.id:
			continue
		if locked.has(s.show) and locked[s.show] > day:
			continue
		out.append(s)
	out.sort_custom(func(a, b):
		return a.day < b.day
	)
	if out.size() > MAX_CARDS:
		out = out.slice(0, MAX_CARDS)
	return out


## refusals maps show -> Array of refusal days. Adds day, drops days older than REFUSE_WINDOW_DAYS.
## Returns {"count": n, "locked_until": day + 56 when n >= 2 else -1}.
static func refuse(refusals: Dictionary, show: String, day: int) -> Dictionary:
	if not refusals.has(show):
		refusals[show] = []
	var arr: Array = refusals[show]
	arr.append(day)
	var cutoff := day - REFUSE_WINDOW_DAYS
	var kept := []
	for d in arr:
		if d > cutoff:
			kept.append(d)
	refusals[show] = kept
	var n := kept.size()
	var locked_until := -1
	if n >= REFUSE_LIMIT:
		locked_until = day + LOCKOUT_DAYS
	return {"count": n, "locked_until": locked_until}


## "refused %d of 2" counting only days within the window.
static func refused_line(refusals: Dictionary, show: String, day: int) -> String:
	if not refusals.has(show):
		return "refused 0 of 2"
	var cutoff := day - REFUSE_WINDOW_DAYS
	var n := 0
	for d in refusals[show]:
		if d > cutoff:
			n += 1
	return "refused %d of 2" % n


## True when opp is in history.
static func rematch(history: Array, opp: String) -> bool:
	return opp in history


## True when she has been ready RUST_WEEKS*7 days or more without a bout.
static func rusty(ready_since_day: int, day: int, last_bout_day: int) -> bool:
	var base := maxi(ready_since_day, last_bout_day)
	return (day - base) >= RUST_WEEKS * 7
