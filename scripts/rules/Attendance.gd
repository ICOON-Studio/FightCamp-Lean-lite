extends RefCounted
## S395 (operator on the sound: "make it like an arena according to the attendance as real as possible"): how many people a bout
## draws, and the room that holds them. A club show is a few hundred in a hall, a national final a few thousand, a pro main event
## an arena. The fight's sound scales from this (FightSfx), and the seats can follow it later.
##   of(bout) -> people    room(people) -> "hall" | "venue" | "arena"    share(people) -> 0..1, how full the sound is

const CLUB := 220
const CHAMP := [400, 600, 900, 1200, 1800, 2500, 4000]   # by the championship's stage (Champs: regional, then national)
const PRO_MIN := 900
const PRO_MAX := 12000
const PRO_PER_PURSE := 2.0
const HALL_UP_TO := 700
const VENUE_UP_TO := 3000


static func of(bout: Dictionary) -> int:
	if bout.has("champ"):
		return int(CHAMP[clampi(int(bout["champ"]), 0, CHAMP.size() - 1)])
	if bool(bout.get("pro", false)):
		return clampi(int(float(bout.get("purse", 0)) * PRO_PER_PURSE), PRO_MIN, PRO_MAX)
	return CLUB


static func room(people: int) -> String:
	return "hall" if people <= HALL_UP_TO else ("venue" if people <= VENUE_UP_TO else "arena")


## On a log scale: a crowd ten times the size is not ten times as loud.
static func share(people: int) -> float:
	return clampf(log(float(people) / CLUB) / log(float(PRO_MAX) / CLUB), 0.0, 1.0)
