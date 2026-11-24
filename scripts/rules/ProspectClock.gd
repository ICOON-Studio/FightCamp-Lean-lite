extends RefCounted
## KNOWBUILD1 (S545): the prospect's clock and the card's numbers, pure static (map ops/research/DESIGN_KNOW_STAKES1_V9.md
## sections 3A-3D, with the owner's interview S543 K1-K4 on top; docs/KNOWSTAKES9_RESULT.md measured them on a greybox).
##   truths(p) / merit(p)                  the prospect's true groups (body, skills, under fire, ceiling) and merit
##   ranges(k, p) / estimate(r)            the card's read as ranges and what the card says the prospect is worth
##   rival_likes(p, level) / window(..)    the rival club's look and its 7-day window (3C)
##   rival_day(from, to, u)                the day inside the window the rival signs
##   odds_tomorrow(day, from, to)          "1 in 5": the chance the rival decides tomorrow, read off the window
##   odds_before(bout, from, to)           the window's days before the bout ("3 in 7")
##   season_end(day)                       the end of the season a signing is held to (K1, the place not dollars)
##   why(before, after, level)             the one "why" line a read gives (map 0.8)
## Preloads Knowledge.gd and SeasonPath.gd only. No he/she (S412).

const K := preload("res://scripts/rules/Knowledge.gd")
const SeasonPath := preload("res://scripts/rules/SeasonPath.gd")

## 3C: the rival decides inside a 7-day window; the last day is 7 when the rival's look is above the level, 14 when not,
## plus 0-6 (the prospect's own die). ESTIMATE, measured on the greybox (KNOWSTAKES9 B1-B4 pass).
const WINDOW := 7
const LAST_LIKED := 7
const LAST_LOOKING := 14
const LAST_SPREAD := 6
## 0.1: every scouted name boxes 4 to 18 days out (the region show the scout saw them at).
const BOUT_MIN := 4
const BOUT_MAX := 18
## 3D / v7 2C: one new name every 4-6 weeks, at most two open at once.
const ARRIVE_MIN := 28
const ARRIVE_MAX := 42
const OPEN_MAX := 2
## 3D: the scout brings names whose first look sits within 2 of the level (MEASURED: the first look's call is then wrong
## 33.0% of the time).
const SCOUT_BAND := 2.0
const SIGN_ODDS := "1 in 3"   ## MEASURED (KNOWSTAKES9): first looks like this that end under the level
## The ceiling's half-width before the pad test (the greybox's CEIL_HW); the pad test halves it.
const CEIL_HW := 14.0
## Watching the bout opens under fire rough (v7: about 23 wide).
const BOUT_HW := 11.5
## The rival looks with its own eyes: its own seed beside the prospect's.
const RIVAL_SEED := 7777
## K1: a signing holds its place to the season's end - the national final (SeasonPath) at least MIN_CLUB_DAYS ahead, the
## three months a new boxer must be registered to enter at all; a signing later than that is held to the next season's.
const FINAL_OFFSET := SeasonPath.REGIONAL_START + SeasonPath.REGIONAL_GAP + SeasonPath.NATIONALS_GAP + 8   # last national round
const HOLD_MIN := SeasonPath.MIN_CLUB_DAYS


## The prospect's true groups from the seven stats and the potential: body (power, speed, conditioning), skills
## (technique, defense, fight IQ), under fire (chin), ceiling (potential).
static func truths(p: Dictionary) -> Dictionary:
	var s: Dictionary = p.get("stats", {})
	var b := (float(s.get("power", 55.0)) + float(s.get("speed", 55.0)) + float(s.get("conditioning", 55.0))) / 3.0
	var k := (float(s.get("technique", 55.0)) + float(s.get("defense", 55.0)) + float(s.get("fight_iq", 55.0))) / 3.0
	return {"body": b, "skills": k, "fire": float(s.get("chin", 55.0)), "ceiling": float(p.get("pot", 70))}


## The greybox's merit (KNOWSTAKES9): 0.6 x (0.4 body + 0.4 skills + 0.2 under fire) + 0.4 x (ceiling - 12).
static func merit(p: Dictionary) -> float:
	var t := truths(p)
	return _worth(float(t["body"]), float(t["skills"]), float(t["fire"]), float(t["ceiling"]))


static func _worth(b: float, s: float, f: float, c: float) -> float:
	return 0.6 * (0.4 * b + 0.4 * s + 0.2 * f) + 0.4 * (c - 12.0)


## The card's read: {body, skills, fire, ceiling} each {lo, hi, c} (the truth is always inside: "the range never lies").
static func ranges(k: Dictionary, p: Dictionary) -> Dictionary:
	var t := truths(p)
	var hw := float(k.get("ceil_hw", CEIL_HW))
	var cc := float(t["ceiling"]) + K._offset(k, "ceiling") * hw
	return {"body": _r(K.range_of(k, "strength", float(t["body"]))), "skills": _r(K.range_of(k, "accuracy", float(t["skills"]))),
		"fire": _r(K.range_of(k, "durability", float(t["fire"]))),
		"ceiling": {"lo": maxf(0.0, cc - hw), "hi": minf(100.0, cc + hw), "c": cc}}


static func _r(r: Dictionary) -> Dictionary:
	return {"lo": float(r["lo"]), "hi": float(r["hi"]), "c": float(r["centre"])}


## What the card says the prospect is worth (the middle of each range in the merit sum).
static func estimate(r: Dictionary) -> float:
	return _worth(float(r["body"]["c"]), float(r["skills"]["c"]), float(r["fire"]["c"]), float(r["ceiling"]["c"]))


## The rival club's own look at body and skills (a fresh read on its own seed) is above the level.
static func rival_likes(p: Dictionary, seed: int, level: float) -> bool:
	var t := truths(p)
	var k := K.fresh(seed + RIVAL_SEED)
	var b := float(K.range_of(k, "strength", float(t["body"]))["centre"])
	var s := float(K.range_of(k, "accuracy", float(t["skills"]))["centre"])
	return 0.5 * (b + s) > level


## The region show the prospect boxes on: a Saturday BOUT_MIN to BOUT_MAX days out (there are two), by the die u (0..1).
static func bout_day(arrived: int, u: float) -> int:
	var sats: Array = []
	for d in range(arrived + BOUT_MIN, arrived + BOUT_MAX + 1):
		if posmod(d, 7) == 5:   # day 0 is a Monday (Clock)
			sats.append(d)
	return int(sats[clampi(int(floor(u * sats.size())), 0, sats.size() - 1)])


## The rival's window, days from the prospect's arrival day: {from, to}.
static func window(arrived: int, likes: bool, spread: int) -> Dictionary:
	var last := arrived + (LAST_LIKED if likes else LAST_LOOKING) + clampi(spread, 0, LAST_SPREAD)
	return {"from": maxi(arrived + 1, last - WINDOW + 1), "to": last}


## The day the rival signs: one of the window's days, by the prospect's die u (0..1).
static func rival_day(from: int, to: int, u: float) -> int:
	return clampi(from + int(floor(clampf(u, 0.0, 0.999) * float(to - from + 1))), from, to)


## The chance the rival decides tomorrow, as [n, d] ("1 in 5"): 0 in 7 before the window, 1 in (days left) inside it.
static func odds_tomorrow(day: int, from: int, to: int) -> Array:
	var t := day + 1
	if t < from:
		return [0, WINDOW]
	if t > to:
		return [1, 1]
	return [1, to - t + 1]


## The window's days that fall before the bout (the rival may sign before the player has watched it): [n, WINDOW].
static func odds_before(bout: int, from: int, to: int) -> Array:
	var n := 0
	for d in range(from, to + 1):
		if d < bout:
			n += 1
	return [n, WINDOW]


## The day a signing made today is held to: the season's national final, at least HOLD_MIN days ahead.
static func season_end(day: int) -> int:
	var end := SeasonPath.ENTRY_CLOSE_DAY + FINAL_OFFSET
	while end < day + HOLD_MIN:
		end += SeasonPath.YEAR_DAYS
	return end


## The why line (map 0.8): where the read now sits against the level, worded from the range and the level only.
static func why(before: Dictionary, after: Dictionary, level: float) -> String:
	var lo := float(after["lo"])
	var hi := float(after["hi"])
	if lo > level:
		return "now clear of the level" if float(before["lo"]) <= level else "still clear of the level"
	if hi < level:
		return "now under the level" if float(before["hi"]) >= level else "still under the level"
	return "still across the level"
