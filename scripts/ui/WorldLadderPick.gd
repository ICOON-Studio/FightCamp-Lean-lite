extends RefCounted
## S516: the World ladder's pure lookups, out of WorldLadder.gd (the 500-line rule) - rows by id, our row missing, a
## rival's hover line, the booked day, our fighter in a division, the gym's divisions.

const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const Tip := preload("res://scripts/ui/Tip.gd")

## S533 TIPFIX3: why Ask and Scout are grey for an amateur (was "The pro debut comes first.", too short to say it).
const DEBUT_FIRST := "Box the pro debut first; then ask a ranked rival."


static func row_by_id(rows: Array, id: String) -> Dictionary:
	for r in rows:
		var row: Dictionary = r
		if str(row["id"]) == id:
			return row
	return {}

static func ours_missing(rows: Array) -> bool:
	for r in rows:
		if bool((r as Dictionary).get("ours", false)):
			return false
	return true

## A rival's hover, as a SHORT card (S533 TIPFIX3: was "Club. beat <name>"; a card names nobody): the club, the last bout.
static func tip(who: Dictionary, club: String) -> Dictionary:
	var last: Array = RivalPast.shown(who, 1)
	if last.is_empty() and club == "":
		return {}
	var what := "The club this boxer fights for." if last.is_empty() else \
		("Won the last bout on record." if bool(last[0]["win"]) else "Lost the last bout on record.")
	return {"title": club if club != "" else "Last bout", "what": what, "do": "Click to set this boxer side by side."}

## The row name's card (row "tip" from tip(); {} = none).
static func attach_tip(b: Control, spec: Variant) -> void:
	if spec is Dictionary and not (spec as Dictionary).is_empty():
		Tip.short(b, str(spec["title"]), str(spec["what"]), str(spec["do"]))

## The win band's card: the range, what it is, and what narrows it (scouted 0 none, 1 the weapon, 2 the weakness).
static func band_card(bar: Control, lo: float, hi: float, scouted: int) -> void:
	var todo: String = ["A scout narrows the range.", "A full scout narrows it more.", ""][clampi(scouted, 0, 2)]
	Tip.short(bar, "Win chance %d-%d%%" % [roundi(lo * 100.0), roundi(hi * 100.0)], "The chance to win this bout, as a range.", todo)

static func booked_day(f: Dictionary) -> int:
	var bout: Dictionary = f.get("bout", {})
	return int(bout["day"]) if bout.has("opp") and bout.has("day") else 0

static func fighter_in(c: Career, div: String) -> Dictionary:
	for f in c.fighters:
		if str(f["div"]) == div:
			return f
	return {}

static func gym_divs(c: Career) -> Array:
	var divs: Array = []
	for f in c.fighters:
		if not divs.has(str(f["div"])):
			divs.append(str(f["div"]))
	if divs.is_empty():
		divs.append("wlw")
	return divs
