extends RefCounted
## S516: the World ladder's pure lookups, out of WorldLadder.gd (the 500-line rule) - rows by id, our row missing, a
## rival's hover line, the booked day, our fighter in a division, the gym's divisions.

const RivalPast := preload("res://scripts/rules/RivalPast.gd")


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

static func tip(who: Dictionary, club: String) -> String:
	var last: Array = RivalPast.shown(who, 1)
	if last.is_empty():
		return club
	var bit := "%s %s" % ["beat" if bool(last[0]["win"]) else "lost to", str(last[0]["vs"])]
	return bit if club == "" else "%s. %s" % [club, bit]

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
