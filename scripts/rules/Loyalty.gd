extends RefCounted
## Loyalty - each fighter's LOYALTY made live: bands, dated reasons and a forecast (R58LOYAL1, S440).
## Spec: ops/research/CLUBWEEK_MAP_V41_S432.md 3.8 (what moves it, what it does) and 3.1 (holding pads, the
## sponsorship); the bands and the forecast: ops/research/RPG_LAYER_MAP_S432.md 3.
## ONE home for every fighter, boxers and Ana alike: f["loyalty"] (int 0-100), the key StripeCall and NoGi already use.
## Missing, value() reads the trait f["personality"]["loyalty"], else START. The first move writes f["loyalty"].
## Every move is dated in f["loyalty_log"]: {d, n, why} (n = the real change after the clamp; v = the value after, so
## leaves() can tell when loyalty last went under 25). The newest LOG_KEEP are kept.
## Loyalty is NOT mood (map 3.7: the deal's prices move loyalty, never morale): nothing here reads or writes f["morale"].
## "Known" (how well the coach knows the fighter, RPG 3) is read from f["known"] when present, else 0.
## Pure static; preloads only StripeCall (the stripe call's prices) and ProDebut (the professional's shares).
##   value(f) band(v, known) apply(f, cause, day) forecast(f, weekly, weeks, day) forecast_line(f, weekly, day)
##   wants_word(f, day) can_tell_straight(f, day) leaves(f, day) can_hold_pads(f, bouts) pro_share(f) reasons(f, since_day)
##   week(f, from_day, to_day): the week review's row (moves by cause, a band crossed)

const StripeCall := preload("res://scripts/rules/StripeCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")

const START := 50
const LOG_KEEP := 40
## Each band's lowest value, highest first (RPG 3). "Trusts you" also needs Known TRUST_KNOWN; without it 85+ reads Loyal.
const BANDS: Array = [["Trusts you", 85], ["Loyal", 70], ["Settled", 50], ["Wavering", 25], ["Leaving", 0]]
const TRUST_KNOWN := 4
const LOYAL_AT := 70
## Under SETTLED_AT: the WANTS A WORD card, and an outside manager at turning professional.
const SETTLED_AT := 50
const LEAVES_UNDER := 25
const LEAVE_TALKS := 2
## A short week with a short in the RUN_DAYS before it is short_running; a Loyal fighter's first short in FREE_DAYS is free.
const RUN_DAYS := 7
const FREE_DAYS := 28
## Holding pads counts at most PADS_RUN weeks running.
const PADS_RUN := 4
const WORD_DAYS := 28
const STRAIGHT_DAYS := 56
const HOLD_BOUTS := 6
const FORECAST_WEEKS := 12
const LINE_WEEKS := 4
const FREE_WHY := "short (Loyal: one week in four free)"
const PADS_WHY := "held_pads (only 4 weeks running count)"

## The map's ESTIMATES (CLUBWEEK 3.8 and 3.1), one per cause, by name. word_card moves nothing: it dates the WANTS A
## WORD card so it comes at most once in WORD_DAYS. wants_sponsor is per week (potential 80+ and no sponsorship for
## 8 weeks: the caller's test). The stripe call's prices are StripeCall's own.
const MOVES := {
	"short": -3, "short_running": -6, "full_week": 1,
	"promise_kept": 5, "promise_broken": -12,
	"sponsor_given": 5, "sponsor_pulled": -8, "sponsor_renewed": 2, "sponsor_passed_to": 5,
	"sponsor_half_up": 3, "sponsor_half_down": -4,   # S519 club week 3.5: half the sponsorship (ESTIMATE, LOYAL1)
	"held_pads": 3, "sheet_passed_ready": -2,
	"target_to_ambition": 5, "target_against": -5, "target_met": 10, "target_missed": -5,
	"overtime_refused": -2,
	"talk_back": 4, "talk_straight_landed": 4, "talk_straight_failed": -4,
	"wants_sponsor": -3,
	"stripe_now": StripeCall.NOW_LOYAL, "stripe_hold": -StripeCall.HOLD_LOYAL,
	"word_card": 0,
	"teammate_left": -2,   # S486 R58 M6: a team-mate under Settled when a boxer leaves the club (Leaving)
	# S486 R58 LOYALHOOKS1 (map R58_MAP_S439 M1, ESTIMATES): the bouts the player takes or passes, results, goals, the pro
	# decision, a signing in the same class, four idle weeks. Each prices a choice the player makes.
	"offer_passed": -3, "no_bout": -3, "bout_won": 2, "bout_lost": -1, "stopped": -3, "goal_met": 5, "goal_missed": -4,
	"decline_pro": -8, "turn_pro": 5, "signing_class": -4,
}
## A Loyal fighter (LOYAL_AT+) takes result losses at half, toward zero (map M1 THE UPSIDE): -1 -> 0, -3 -> -1.
const HALVED_WHEN_LOYAL := ["bout_lost", "stopped"]


## The fighter's loyalty: f["loyalty"], else the personality trait, else START.
static func value(f: Dictionary) -> int:
	if f.has("loyalty"):
		return clampi(int(f["loyalty"]), 0, 100)
	var p: Dictionary = f.get("personality", {})
	if p.has("loyalty"):
		return clampi(int(round(float(p["loyalty"]))), 0, 100)
	return START


## The band's name for a value (RPG 3). 85 and up reads "Trusts you" only with Known TRUST_KNOWN, else "Loyal".
static func band(v: int, known := 0) -> String:
	for b in BANDS:
		if v >= int(b[1]):
			if str(b[0]) == "Trusts you" and known < TRUST_KNOWN:
				return "Loyal"
			return str(b[0])
	return "Leaving"


## The dated moves (oldest first). Never adds the key.
static func log_of(f: Dictionary) -> Array:
	var book: Array = f.get("loyalty_log", [])
	return book


## True when the log holds a move whose why begins with `prefix`, dated from_day <= d < to_day.
static func logged(book: Array, prefix: String, from_day: int, to_day: int) -> bool:
	for e in book:
		var d: int = int(e.get("d", 0))
		if d >= from_day and d < to_day and str(e.get("why", "")).begins_with(prefix):
			return true
	return false


## How many weeks running pads were held before `day` (counted up to PADS_RUN).
static func pads_run(book: Array, day: int) -> int:
	var run := 0
	var t := day
	while run < PADS_RUN:
		var found := -1
		for e in book:
			var d: int = int(e.get("d", 0))
			if d >= t - RUN_DAYS and d < t and str(e.get("why", "")).begins_with("held_pads"):
				found = d
		if found < 0:
			break
		run += 1
		t = found
	return run


## The move a cause makes on `day`, by apply's rules: {n, why}; {} for an unknown cause.
static func move_for(f: Dictionary, cause: String, day: int) -> Dictionary:
	if not MOVES.has(cause):
		return {}
	var book := log_of(f)
	if cause == "short":
		if value(f) >= LOYAL_AT and not logged(book, "short", day - FREE_DAYS + 1, day):
			return {"n": 0, "why": FREE_WHY}
		if logged(book, "short", day - RUN_DAYS, day):
			return {"n": int(MOVES["short_running"]), "why": "short_running"}
	if cause == "held_pads" and pads_run(book, day) >= PADS_RUN:
		return {"n": 0, "why": PADS_WHY}
	if HALVED_WHEN_LOYAL.has(cause) and value(f) >= LOYAL_AT:
		return {"n": int(float(MOVES[cause]) / 2.0), "why": cause}   # int() cuts toward zero
	return {"n": int(MOVES[cause]), "why": cause}


## Moves loyalty by n (clamped 0-100, the house pattern of StripeCall._add) and dates it in the log.
static func commit(f: Dictionary, n: int, why: String, day: int) -> Dictionary:
	var known := int(f.get("known", 0))
	var before := value(f)
	var after := clampi(before + n, 0, 100)
	f["loyalty"] = after
	var book: Array = f.get_or_add("loyalty_log", [])
	book.append({"d": day, "n": after - before, "why": why, "v": after})
	while book.size() > LOG_KEEP:
		book.remove_at(0)
	return {"before": before, "after": after, "delta": after - before,
		"band_before": band(before, known), "band_after": band(after, known)}


## Applies a cause to f (changed in place): {before, after, delta, band_before, band_after}.
## "short" is short_running with a short in the RUN_DAYS before; a Loyal fighter's first short in FREE_DAYS costs 0
## (logged as FREE_WHY); held_pads past PADS_RUN weeks running logs 0; an unknown cause changes and logs nothing.
static func apply(f: Dictionary, cause: String, day: int) -> Dictionary:
	var m := move_for(f, cause, day)
	if m.is_empty():
		var v := value(f)
		var b := band(v, int(f.get("known", 0)))
		return {"before": v, "after": v, "delta": 0, "band_before": b, "band_after": b}
	return commit(f, int(m["n"]), str(m["why"]), day)


## The week's causes repeated `weeks` times on a COPY of f (f is never changed), by apply's own rules:
## [{week, v, band}], week 1 dealt on `day`, each next week 7 days on.
static func forecast(f: Dictionary, weekly: Array, weeks: int, day: int) -> Array:
	var c: Dictionary = f.duplicate(true)
	var known := int(f.get("known", 0))
	var out: Array = []
	for w in range(1, weeks + 1):
		var d: int = day + RUN_DAYS * (int(w) - 1)
		for cause in weekly:
			apply(c, str(cause), d)
		var v := value(c)
		out.append({"week": int(w), "v": v, "band": band(v, known)})
	return out


## "66 now; as dealt 70 in 4 weeks, Loyal in 4": the next band up or down named only when the forecast reaches it
## inside FORECAST_WEEKS.
static func forecast_line(f: Dictionary, weekly: Array, day: int) -> String:
	var now := value(f)
	var here := band(now, int(f.get("known", 0)))
	var fc := forecast(f, weekly, FORECAST_WEEKS, day)
	var line := "%d now; as dealt %d in %d weeks" % [now, int(fc[LINE_WEEKS - 1]["v"]), LINE_WEEKS]
	for row in fc:
		if str(row["band"]) != here:
			return line + (", %s in %d" % [str(row["band"]), int(row["week"])])
	return line


## The WANTS A WORD card: under SETTLED_AT and no word card (cause "word_card") in the last WORD_DAYS.
static func wants_word(f: Dictionary, day: int) -> bool:
	return value(f) < SETTLED_AT and not logged(log_of(f), "word_card", day - WORD_DAYS + 1, day + 1)


## Tell it straight: not again for that fighter for 8 weeks (STRAIGHT_DAYS after a talk_straight_*).
static func can_tell_straight(f: Dictionary, day: int) -> bool:
	return not logged(log_of(f), "talk_straight", day - STRAIGHT_DAYS + 1, day + 1)


## Under 25 after two talks (any talk_* cause) since loyalty last went under 25: the fighter leaves (the caller picks
## the next Monday). A talk that itself took loyalty under 25 counts.
static func leaves(f: Dictionary, day: int) -> bool:
	var cur := value(f)
	if cur >= LEAVES_UNDER:
		return false
	var talks := 0
	var book := log_of(f)
	for i in range(book.size() - 1, -1, -1):
		var e: Dictionary = book[i]
		if int(e.get("d", 0)) > day:
			continue
		var after: int = int(e.get("v", cur))
		if after >= LEAVES_UNDER:
			break
		if str(e.get("why", "")).begins_with("talk_"):
			talks += 1
		cur = after - int(e.get("n", 0))
		if cur >= LEAVES_UNDER:
			break
	return talks >= LEAVE_TALKS


## Only a Loyal fighter (70+) with HOLD_BOUTS or more bouts can hold pads (map 3.1).
static func can_hold_pads(f: Dictionary, bouts: int) -> bool:
	return value(f) >= LOYAL_AT and bouts >= HOLD_BOUTS


## The club's share of a professional's purse: manager and trainer at SETTLED_AT and up; under it an outside manager
## signs the boxer and the club keeps the trainer's share alone (map 3.8).
static func pro_share(f: Dictionary) -> float:
	if value(f) >= SETTLED_AT:
		return ProDebut.MANAGER + ProDebut.TRAINER
	return ProDebut.TRAINER


## The logged moves since a day, newest first, each {d, n, why} (the bar's "last three moves").
static func reasons(f: Dictionary, since_day: int) -> Array:
	var out: Array = []
	var book := log_of(f)
	for i in range(book.size() - 1, -1, -1):
		var e: Dictionary = book[i]
		if int(e.get("d", 0)) >= since_day:
			out.append({"d": int(e.get("d", 0)), "n": int(e.get("n", 0)), "why": str(e.get("why", ""))})
	return out


## The week review's words for a cause (APPROACHUI3); a cause not named here reads as its code, spaced.
const WEEK_WORDS := {"short": "a short week", "short_running": "short again", "full_week": "a full week",
	"held_pads": "you held pads", "offer_passed": "an offer passed", "no_bout": "no bout", "bout_won": "a win",
	"bout_lost": "a loss", "stopped": "stopped", "teammate_left": "a team-mate left", "signing_class": "a signing in the class"}


## The loyalty moves dated from_day <= d < to_day, summed by cause (APPROACHUI3, map R58 s7: "loyalty moves by cause;
## band crossed"). {} when nothing moved. {kind up|down|same, before, after, band_before, band_after, crossed, causes
## [{n, word}] biggest first, text}.
static func week(f: Dictionary, from_day: int, to_day: int) -> Dictionary:
	var by: Dictionary = {}
	var order: Array = []
	var first := -1
	var last := -1
	var book := log_of(f)
	for i in book.size():
		var e: Dictionary = book[i]
		var d := int(e.get("d", 0))
		if d < from_day or d >= to_day or int(e.get("n", 0)) == 0:
			continue
		if first < 0:
			first = i
		last = i
		var key := str(e.get("why", "")).split(" (")[0]
		if not by.has(key):
			order.append(key)
		by[key] = int(by.get(key, 0)) + int(e.get("n", 0))
	if first < 0:
		return {}
	var after := int(book[last].get("v", value(f)))
	var before := clampi(int(book[first].get("v", after)) - int(book[first].get("n", 0)), 0, 100)
	var known := int(f.get("known", 0))
	var causes: Array = []
	for k in order:
		if int(by[k]) != 0:
			causes.append({"n": int(by[k]), "word": str(WEEK_WORDS.get(k, str(k).replace("_", " ")))})
	causes.sort_custom(func(a, b): return absi(int(a["n"])) > absi(int(b["n"])))
	var bb := band(before, known)
	var ba := band(after, known)
	var kind := "up" if after > before else ("down" if after < before else "same")
	var text := "%d to %d" % [before, after] if kind != "same" else "Held at %d" % after
	text += (", %s to %s." % [bb, ba]) if bb != ba else (", %s." % ba)
	var parts: Array = causes.map(func(c): return "%s %+d" % [c["word"], int(c["n"])])
	if not parts.is_empty():
		var said := ", ".join(parts)
		text += " " + said.substr(0, 1).to_upper() + said.substr(1) + "."
	return {"kind": kind, "before": before, "after": after, "band_before": bb, "band_after": ba, "crossed": bb != ba,
		"causes": causes, "text": text}


## S519 club week v11 3.6: the 4-week trend beside the band word (no raw number needed): the log's moves in the
## TREND_DAYS before `day` summed; +TREND_AT or more = rising, -TREND_AT or less = falling, else steady.
## {n, word, arrow}.
const TREND_DAYS := 28
const TREND_AT := 3


static func trend(f: Dictionary, day: int) -> Dictionary:
	var n := 0
	for e in log_of(f):
		var d := int(e.get("d", 0))
		if d >= day - TREND_DAYS and d < day + 1:
			n += int(e.get("n", 0))
	if n >= TREND_AT:
		return {"n": n, "word": "rising", "arrow": "↑"}
	if n <= -TREND_AT:
		return {"n": n, "word": "falling", "arrow": "↘"}
	return {"n": n, "word": "steady", "arrow": "→"}
