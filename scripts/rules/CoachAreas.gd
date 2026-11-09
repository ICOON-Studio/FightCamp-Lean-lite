extends RefCounted
## What a coach is good at (S411). Five areas, and the lift of each against training alone.
## The areas' average is the coach's overall rating, which fight-plan lines still read.
## Pure: no scene, no career. WeekPlan asks rating_for for the session in front of it.

## Same rating Sim uses when nobody is hired: the coach factor 0.5 + r x 0.7 / 100 is 0.60 here.
const ALONE := 100.0 / 7.0
const ALONE_FACTOR := 0.6
const AREAS: Array[String] = ["pads", "bag", "conditioning", "strength", "sparring"]

## Morning and evening ids from WeekPlan. Rest and film train nothing, so they have no area.
const SESSION := {
	"roadwork": "conditioning", "intervals": "conditioning", "mobility": "conditioning",
	"strength": "strength", "neck": "strength",
	"heavy_bag": "bag", "speed_bag": "bag", "shadow": "bag", "slip_rope": "bag",
	"pads": "pads", "sparring": "sparring",
}
const NAME := {
	"pads": "pad work", "bag": "bag work", "conditioning": "conditioning",
	"strength": "strength", "sparring": "sparring",
}
const SHORT := {
	"pads": "Pads", "bag": "Bag", "conditioning": "Conditioning",
	"strength": "Strength", "sparring": "Sparring",
}
const ICON := {
	"pads": "pads", "bag": "bag", "conditioning": "roadwork",
	"strength": "weights", "sparring": "sparring",
}


static func area_of(session_id: String) -> String:
	return str(SESSION.get(session_id, ""))


static func label(area: String) -> String:
	return str(NAME.get(area, area))


static func short(area: String) -> String:
	return str(SHORT.get(area, area))


static func icon(area: String) -> String:
	return str(ICON.get(area, "coach"))


## No coach, or a session with no area and no rating to fall back on: the alone value.
static func rating_for(coach_or_empty, session_id: String) -> float:
	if typeof(coach_or_empty) != TYPE_DICTIONARY or (coach_or_empty as Dictionary).is_empty():
		return ALONE
	var coach: Dictionary = coach_or_empty
	var area := area_of(session_id)
	var areas: Dictionary = coach.get("areas", {})
	if area != "" and areas.has(area):
		return float(areas[area])
	if coach.has("rating"):
		return float(coach["rating"])
	return ALONE


## How much more a session teaches than training alone, as a fraction. 0.70 means +70%.
static func lift(rating: float) -> float:
	return (0.5 + rating * 0.7 / 100.0) / ALONE_FACTOR - 1.0


static func pct(rating: float) -> String:
	return "%+d%%" % roundi(lift(rating) * 100.0)


## S413 pad work teaches moves (MoveMastery: 1 + 0.40 x rating / 100, against no coach), not attribute points.
static func lift_for(area: String, rating: float) -> float:
	return rating * 0.40 / 100.0 if area == "pads" else lift(rating)


static func pct_for(area: String, rating: float) -> String:
	return "%+d%%" % roundi(lift_for(area, rating) * 100.0)


## Strongest area first. A missing area falls back to the overall rating.
static func ranked(coach: Dictionary) -> Array:
	var areas: Dictionary = coach.get("areas", {})
	var fallback := float(coach.get("rating", ALONE))
	var rows: Array = []
	for id in AREAS:
		rows.append({"id": id, "rating": float(areas[id]) if areas.has(id) else fallback})
	rows.sort_custom(func(a, b): return float(a["rating"]) > float(b["rating"]))
	return rows


static func best(coach: Dictionary) -> String:
	var rows := ranked(coach)
	return "" if rows.is_empty() else str(rows[0]["id"])


## "Lucy, pad work: +0.16 → +0.27 a week"
static func line(who: String, area: String, alone: float, coached: float) -> String:
	return "%s, %s: %+.2f → %+.2f a week" % [who, label(area), alone, coached]


## "Lucy, pad work: moves +3.1 → +4.0 a week"
static func move_line(who: String, area: String, alone: float, coached: float) -> String:
	return "%s, %s: moves %+.1f → %+.1f a week" % [who, label(area), alone, coached]
