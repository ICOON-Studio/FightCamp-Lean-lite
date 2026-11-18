extends RefCounted
## S519 club week v11 3.2 (his Q-S294-272 "Yes, build it"; pads kept FULL per his Q-S294-260, so a class is a whole
## evening): an EXTRA class night. The coach's usual adult class money (GameMoney.CLASSES_WITH_COACH, $350 a week, a
## decided number) is untouched; on top, the player may turn a weekday pad evening into a class: +$117 that week
## (ClubDeal.class_cash), a new member every 16 class nights (ClubDeal.class_members_4w: 0.25 a night every 4 weeks), and
## every boxer on pads that evening drills at the bag's rate (half the minutes: bag night 1.05 vs pads 2.1 mastery an hour).
## Pure; the nights live in career.coach["classes"] (dows 0-4), so no coach = no classes.
##   nights(coach) -> Array   toggle(coach, dow) -> Array   cash(coach) -> int   members(carry, n) -> {joined, carry}
##   words(n) -> String

const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")

const KEY := "classes"
const WEEKDAYS := [0, 1, 2, 3, 4]
const BAG_SHARE := 0.5
## ESTIMATE (MONEYFOUR2): ClubDeal.class_members_4w(1) / 4 weeks.
const MEMBER_A_NIGHT := 0.0625


static func nights(coach: Dictionary) -> Array:
	if coach.is_empty():
		return []
	return (coach.get(KEY, []) as Array).filter(func(d): return WEEKDAYS.has(int(d)))


static func on(coach: Dictionary, dow: int) -> bool:
	return nights(coach).has(dow)


## Flips one weekday evening; returns the new list (sorted). A Saturday or Sunday never takes a class.
static func toggle(coach: Dictionary, dow: int) -> Array:
	if coach.is_empty() or not WEEKDAYS.has(dow):
		return nights(coach)
	var n: Array = nights(coach).duplicate()
	if n.has(dow):
		n.erase(dow)
	else:
		n.append(dow)
	n.sort()
	coach[KEY] = n
	return n


static func cash(coach: Dictionary) -> int:
	return ClubDeal.class_cash(nights(coach).size())


## A week's class nights grow the club slowly: the fraction carries week to week.
static func members(carry: float, n: int) -> Dictionary:
	var c := carry + MEMBER_A_NIGHT * float(n)
	var joined := int(floor(c))
	return {"joined": joined, "carry": c - float(joined)}


## The coach row / evening panel's line.
static func words(n: int) -> String:
	if n <= 0:
		return ""
	return "%d class night%s: +%s a week, the boxers on the bag those evenings" % [n, "" if n == 1 else "s",
		"$%d" % ClubDeal.class_cash(n)]
