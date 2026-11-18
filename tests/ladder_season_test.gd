extends SceneTree
## S517 LADDERWIRE stage 3: 1 January closes the amateur season - points carry over, each division's final table is kept
## on the career (c.seasons), and our ranked boxer gets a Records line with her place and points. Population: a
## quick-start club with Lucy (made 6-1, ranked) against the region's own named rivals (different records, ratings).
## Prints LADDER_SEASON failures=N.

const Data := preload("res://scripts/state/Data.gd")
const LadderSeason := preload("res://scripts/state/LadderSeason.gd")
const Region := preload("res://scripts/state/Region.gd")
const Records := preload("res://scripts/rules/Records.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")

var _fails := 0


func _initialize() -> void:
	_check(not LadderSeason.is_season_end(0) and not LadderSeason.is_season_end(360), "5 Jan and 31 Dec are not a season end")
	_check(LadderSeason.is_season_end(361), "day 361 is 1 Jan 2027: the season ends (%s)" % Clock.fmt(361))
	_check(LadderSeason.is_season_end(361 + 365), "and 1 Jan 2028 (day 726)")
	_check(LadderSeason.ordinal(1) == "1st" and LadderSeason.ordinal(2) == "2nd" and LadderSeason.ordinal(3) == "3rd"
		and LadderSeason.ordinal(11) == "11th" and LadderSeason.ordinal(22) == "22nd", "ordinals")
	var c := Career.quick_start()
	c.seed = 31
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["w"] = 6
	f["l"] = 1
	f["rep"] = 44
	var before := int(f["rep"])
	var rival_reps := {}
	for r in c.rivals:
		rival_reps[str(r["name"])] = RankLine.rep(r)
	c.day = 361
	Region.day_events(c)
	_check(int(f["rep"]) == before, "points carry over: %d -> %d" % [before, int(f["rep"])])
	var moved := false
	for r in c.rivals:
		moved = moved or (r.has("rep") and int(r["rep"]) != int(rival_reps[str(r["name"])]))
	_check(not moved or Region.is_show_day(361), "no rival's points reset at the season end")
	_check(not c.seasons.is_empty(), "the season's tables are kept: %d" % c.seasons.size())
	var wlw: Array = c.seasons.filter(func(t): return str(t["div"]) == "wlw")
	_check(wlw.size() == 1 and int(wlw[0]["year"]) == 2026, "one wlw table, season 2026")
	var ours: Array = (wlw[0]["rows"] as Array).filter(func(r): return bool(r["ours"])) if not wlw.is_empty() else []
	_check(ours.size() == 1 and int(ours[0]["rep"]) == 44, "Lucy's row is in it with her 44 points")
	var line := ""
	for row in Records.rows(c):
		if str(row["t"]).begins_with("Season 2026 ends: Lucy"):
			line = str(row["t"])
			_check(str(row["kind"]) == "Honours", "the Records line is an Honour")
	_check(line.contains(" of ") and line.contains("44 ladder points"), "Records: %s" % line)
	var c2 := SaveGame.from_dict(SaveGame.to_dict(c))
	_check(c2.seasons.size() == c.seasons.size(), "the season tables survive save and load")
	var last := LadderSeason.last_line(c, "wlw")
	_check(last.begins_with("LAST SEASON (2026): 1 ") and last.contains("Lucy"), "World > Rankings line: %s" % last)
	_check(LadderSeason.last_line(Career.quick_start(), "wlw") == "", "no line before the first season ends")
	c.day = 362
	var n := c.seasons.size()
	Region.day_events(c)
	_check(c.seasons.size() == n, "2 Jan closes nothing")
	# R8 (S517b): a rival with no bout in 52 weeks is off the table; a bout puts her back.
	var c5 := Career.quick_start()
	var idle: Dictionary = c5.rivals.filter(func(x): return str(x["div"]) == "wlw")[0]
	idle["bouts"] = [{"d": -10, "vs": "x", "vs_club": "y", "win": true, "how": "ud", "ours": false}]
	c5.day = 300
	_check(Region.rankings(c5, "wlw").any(func(r): return str(r["name"]) == str(idle["name"])), "boxed 310 days ago: still on the table")
	c5.day = 400
	_check(not Region.rankings(c5, "wlw").any(func(r): return str(r["name"]) == str(idle["name"])), "410 days without a bout: off the table")
	(idle["bouts"] as Array).push_front({"d": 395, "vs": "x", "vs_club": "y", "win": false, "how": "ud", "ours": false})
	_check(Region.rankings(c5, "wlw").any(func(r): return str(r["name"]) == str(idle["name"])), "a bout puts her back")
	print("LADDER_SEASON failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   %s" % what)
	else:
		_fails += 1
		print("  FAIL %s" % what)
