extends SceneTree
## S439 NOCAMP1 round 3 (the S434 skeptic: "no test reads the bout page's fight-night chance on the path the player
## sees"): the bout page (FighterPage tab 5, FightPrep._tale -> CampForecast.for_read -> BoutRead.band) shows what a
## NO-CAMP amateur bout's Tank costs. Population: the golden path's quick-start career (seed 1) - Lucy signed with three
## cards, Luke Reid hired, her first even offer accepted, NO camp set (the amateur fight week, SCOPE S428).
##   1. The same Lucy, the same booked bout, read twice on the page: fresh (tiredness 20, no bout behind her) and worn
##      (tiredness 80 and a bout 4 days ago, 11 before fight night). The bout is 7 days out (the fight week). The worn read shows a lower win chance (the PrepChance label's "about N%").
##   2. The worn read is the band on fight night's Tank: the label's numbers equal BoutRead.band on CampForecast.for_read's
##      copy, whose "tank_ahead" is > 0. (S439 merge prep: the old second half, tank_ahead == CampForecast.run's "stale"
##      on the same inputs, compared the forecast with itself and is gone; the independent value is check 3's.)
##   3. Stepping her real days (Sim.step_day, no camp) to fight night, the Tank the bout plays (BoutNight._peak, bout
##      "stale") is within 1 of the one the page read.
## Red on main (no camp = no Tank anywhere: the two reads are equal). The S434 API is called by name (call), so main
## prints FAIL lines instead of a parse error.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	_check(not f.is_empty(), "Lucy has an even bout booked")
	if f.is_empty():
		_done()
		return
	var c: Career = main.career
	_check((f.get("camp", {}) as Dictionary).is_empty(), "no camp set (the amateur fight week)")
	var opp: Dictionary = f["bout"]["opp"]
	# The amateur fight week (SCOPE S428: no camp, the bout 1 to 2 weeks out): the booked bout moved to 7 days ahead (the
	# classic offer books 25), so a tired week and a recent bout can still be in her on the night.
	f["bout"]["day"] = c.day + 7
	var bd := int(f["bout"]["day"])
	print("  population: %s vs %s, bout day %d (today %d, %d days), no camp" % [str(f["name"]), str(opp.get("name", "?")), bd, c.day, bd - c.day])
	# 1. Fresh, then worn.
	f["week_fatigue"] = 20.0
	f.erase("last_bout_day")
	var fresh := await _page_chance(f)
	f["week_fatigue"] = 80.0
	f["last_bout_day"] = c.day - 4
	var worn := await _page_chance(f)
	print("  the page: fresh '%s' / worn '%s'" % [fresh["text"], worn["text"]])
	_check(int(fresh["mid"]) > 0 and int(worn["mid"]) > 0, "the page shows a win chance both times")
	_check(int(worn["mid"]) <= int(fresh["mid"]) - 2,
		"a worn no-camp fighter reads a lower chance on the bout page: about %d%% against %d%% fresh" % [int(worn["mid"]), int(fresh["mid"])])
	# 2. The page's numbers are the band on fight night's Tank.
	var has_read := false
	for mth in (CampForecast as GDScript).get_script_method_list():
		if str(mth["name"]) == "for_read":
			has_read = true
	_check(has_read, "CampForecast.for_read exists (the bout page's fight-night copy)")
	var ahead := -1.0
	if has_read:
		var g: Dictionary = _by_name("res://scripts/state/CampForecast.gd").call("for_read", c, f, opp)
		ahead = float((g.get("bout", {}) as Dictionary).get("tank_ahead", -1.0))
		var b := BoutRead.band(g, opp, BoutRead.camp_for(f, bd - c.day), c.seed, float(c.coach.get("rating", 0.0)))
		var lo := roundi(float(b["lo"]) * 100.0)
		var hi := roundi(float(b["hi"]) * 100.0)
		_check(ahead > 0.0, "the worn read carries a fight-night Tank of %.2f, not 0 (check 3 holds it to the Tank played)" % ahead)
		_check(int(worn["lo"]) == lo and int(worn["hi"]) == hi,
			"the page's %d to %d%% is the band on that Tank (%d to %d%%)" % [int(worn["lo"]), int(worn["hi"]), lo, hi])
	# 3. The bout plays the Tank the page read.
	while c.day < bd:
		Sim.step_day(c)
	f["bout"].erase("stale")
	var two_args := false
	for mth in (BoutNight as GDScript).get_script_method_list():
		if str(mth["name"]) == "_peak" and (mth["args"] as Array).size() == 2:
			two_args = true
	if two_args:
		_by_name("res://scripts/state/BoutNight.gd").call("_peak", c, f)
	else:
		_by_name("res://scripts/state/BoutNight.gd").call("_peak", f)
	var played := float(f["bout"].get("stale", -1.0))
	_check(ahead >= 0.0 and absf(played - ahead) < 1.0,
		"fight night plays a Tank of %.2f, the page read %.2f" % [played, ahead])
	_done()


## Opens Lucy's bout page (FighterPage tab 5) and reads PrepChance: "Win chance about N% (...: lo to hi%) ...".
func _page_chance(f: Dictionary) -> Dictionary:
	main.act("fighter", str(f["id"]))
	main.act("ftab", "5")
	await process_frame
	await process_frame
	var page: Node = main._shell.find_child("FightPrep", true, false)
	var lbl := page.find_child("PrepChance", true, false) as Label if page != null else null
	var out := {"text": lbl.text if lbl != null else "?", "mid": -1, "lo": -1, "hi": -1}
	if lbl != null:
		var re := RegEx.create_from_string("about (\\d+)% \\([^:]*: (\\d+) to (\\d+)%\\)")
		var m := re.search(lbl.text)
		if m != null:
			out["mid"] = int(m.get_string(1))
			out["lo"] = int(m.get_string(2))
			out["hi"] = int(m.get_string(3))
	return out


## The golden path's first weeks: quick start, Lucy signed with three cards, Luke Reid hired, her first even offer taken.
func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			return f
	return {}


## The script as an untyped value, so a function main does not have is a FAIL line there, not a parse error.
func _by_name(path: String):
	return load(path)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _done() -> void:
	print("NOCAMP_PAGE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
