extends RefCounted
## How an amateur bout is booked (copied from E:\FightCamp\Game\Godot\scripts\AmateurBooking.gd, S75/S76, stripped for the
## lean restart). Pure static functions: no class_name, no preload.
## Kept: the lead time and the novice rule. Dropped: the world record generator and its bout bands (week 4 brings the world).
##
## Lead time: a club show is permitted 8-12 weeks out and the bout sheet is final about two weeks before (England Boxing
## rule 1.6.6, SOURCED); G96's game verdict, 14-28 days from "offer accepted" to the bell, is a JUDGEMENT on those dates.
## Novice rule: USA Boxing's novice class is 0-10 bouts and the 11th bout is Open (SOURCED); a novice meets only novices.

const LEAD_WEEKS_MIN := 2
const LEAD_WEEKS_MAX := 4
const NOVICE_MAX_BOUTS := 10


## Weeks between the offer and fight night, fixed per offer id (a replay agrees).
static func lead_weeks(offer_key: String) -> int:
	var span := LEAD_WEEKS_MAX - LEAD_WEEKS_MIN + 1
	return LEAD_WEEKS_MIN + int(absi(offer_key.hash()) % span)


## The day of the Saturday `weeks` weeks after the week holding `day` (day 0 is a Monday).
static func fight_day(day: int, weeks: int) -> int:
	return day - posmod(day, 7) + 5 + weeks * 7


static func bouts_of(wins: int, losses: int, draws: int = 0) -> int:
	return wins + losses + draws


## A novice (0-10 bouts) meets only another novice; an open fighter meets anyone.
static func experience_match_ok(own_bouts: int, opponent_bouts: int) -> bool:
	if own_bouts <= NOVICE_MAX_BOUTS:
		return opponent_bouts <= NOVICE_MAX_BOUTS
	return true
