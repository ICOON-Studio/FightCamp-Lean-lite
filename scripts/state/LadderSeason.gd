extends RefCounted
## S517 LADDERWIRE stage 3 (ops/research/LADDERWIRE_SCOPE_S515.md; map DESIGN_LADDER1_V6_DOLA.md R10 "Season carries Rep
## forward - final season table in Records"): on 1 January the amateur season ends. Ladder points carry over untouched;
## each division's final table is kept on the career (c.seasons, newest last) and every one of our ranked amateurs gets a
## line in Records ("... finishes 3rd of 9 in the lightweight rankings on 41 ladder points"). Region.day_events calls it.

const Data := preload("res://scripts/state/Data.gd")
const KEEP_ROWS := 10   # the final table keeps the top 10 and our own rows


## True on the first day of a year (Clock: day 0 is Mon 5 Jan 2026, so the first season end is day 361).
static func is_season_end(day: int) -> bool:
	if day <= 0:
		return false
	var d: Dictionary = load("res://scripts/state/Clock.gd")._date(day)
	return int(d["month"]) == 1 and int(d["day"]) == 1


## Closes the season that just ended: one saved table a division with rows, and our boxers' lines. Returns the tables.
static func close(c: Career) -> Array:
	var region: GDScript = load("res://scripts/state/Region.gd")
	var year := int(load("res://scripts/state/Clock.gd")._date(c.day)["year"]) - 1
	var tables: Array = []
	for div in Data.DIVISIONS.keys():
		var rows: Array = region.rankings(c, div)
		if rows.is_empty():
			continue
		var kept: Array = []
		for i in rows.size():
			var r: Dictionary = rows[i]
			if i < KEEP_ROWS or bool(r["ours"]):
				kept.append({"pos": i + 1, "name": r["name"], "club": r["club"], "w": r["w"], "l": r["l"], "rep": int(r["rep"]),
					"ours": bool(r["ours"]), "fid": str(r["fid"])})
		var t := {"year": year, "div": div, "rows": kept, "size": rows.size()}
		tables.append(t)
		for r in kept:
			if bool(r["ours"]):
				var f := c.fighter_by_id(str(r["fid"]))
				c.add_news("Season %d ends: %s finishes %s of %d in the %s rankings on %d ladder points (top: %s, %d)." % [
					year, f.get("first", r["name"]), ordinal(int(r["pos"])), rows.size(), Data.DIVISIONS[div]["short"],
					int(r["rep"]), rows[0]["name"], int(rows[0]["rep"])])
	c.seasons.append_array(tables)
	load("res://scripts/state/RivalOfferWire.gd").season_reset(c)   # S517b R9: "Not this show" is free again
	return tables


static func ordinal(n: int) -> String:
	var suffix := "th"
	if n % 100 < 11 or n % 100 > 13:
		suffix = ["th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"][n % 10]
	return "%d%s" % [n, suffix]


## World > Rankings: last season's final table for a division in one line, or "" before the first season ends.
static func last_line(c: Career, div: String) -> String:
	for i in range(c.seasons.size() - 1, -1, -1):
		var t: Dictionary = c.seasons[i]
		if str(t["div"]) != div:
			continue
		var parts: Array = []
		for r in (t["rows"] as Array).slice(0, 3):
			parts.append("%d %s %d" % [int(r["pos"]), r["name"], int(r["rep"])])
		for r in t["rows"]:
			if bool(r["ours"]) and int(r["pos"]) > 3:
				parts.append("%s %s, %d" % [str(r["name"]).get_slice(" ", 0), ordinal(int(r["pos"])), int(r["rep"])])
		return "LAST SEASON (%d): %s" % [int(t["year"]), "  ·  ".join(parts)]
	return ""
