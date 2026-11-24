extends SceneTree
## S546 (owner C501 on the boxer's profile after "Not yet": "confidence should raise even when amateur with wins andstreak ,
## when its high its indication to go pro"): CONFIDENCE is the boxer's bar from the first amateur bout, not from the first
## pro offer. Amateur wins raise it (more on a winning run), losses lower it, a stoppage most; the pro start takes it
## over instead of a flat 50; the profile shows it for an amateur; the result page says what the bout did to it.
##   1. the rule (ProStart.amateur_after / from_record / new_state(conf))
##   2. the wire: a fought amateur bout moves the bar and prints the line; the first pro offer starts from it; an amateur
##      bout fought after "Not yet" moves the same bar
##   3. the profile row for an amateur with no pro offer yet
## Prints AMATEUR_CONF failures=<n>.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")
const ProPair := preload("res://scripts/state/ProPair.gd")
const ProBars := preload("res://scripts/ui/ProBars.gd")

var failures := 0


func _initialize() -> void:
	_test_rule()
	_test_wire()
	_test_profile()
	print("AMATEUR_CONF failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _test_rule() -> void:
	_check(ProStart.amateur_after(50, "win", 0) == 53, "a first win: +3 (%d)" % ProStart.amateur_after(50, "win", 0))
	_check(ProStart.amateur_after(50, "win", 1) == 54 and ProStart.amateur_after(50, "win", 2) == 55, "a winning run adds one more a win")
	_check(ProStart.amateur_after(50, "win", 3) == 56 and ProStart.amateur_after(50, "win", 9) == 56, "the run's bonus stops at +3")
	_check(ProStart.amateur_after(50, "points", 4) == 42, "a loss on the cards: -8")
	_check(ProStart.amateur_after(50, "ko", 4) == 30, "a stoppage loss: -20")
	_check(ProStart.amateur_after(98, "win", 5) == 100 and ProStart.amateur_after(5, "ko", 0) == 0, "the bar stays inside 0-100")
	_check(ProStart.from_record(0, 0) == 50, "no bouts: 50")
	_check(ProStart.from_record(9, 1) == 78 and ProStart.from_record(4, 2) == 50, "a record read as a bar: 9-1 -> 78, 4-2 -> 50")
	_check(ProStart.from_record(30, 0) == 90 and ProStart.from_record(0, 9) == 10, "a record never reads past 10-90")
	_check(int(ProStart.new_state(78)["conf"]) == 78 and int(ProStart.new_state()["conf"]) == 50, "the pro start takes the bar it is given")
	# a strong amateur reads high, a struggling one low: the call's signal
	var strong := 50
	var run := 0
	for won in [true, true, true, false, true, true, true, true, true]:   # 8-1
		strong = ProStart.amateur_after(strong, "win" if won else "points", run)
		run = run + 1 if won else 0
	var weak := 50
	run = 0
	for won in [true, false, true, false, false, true, false]:   # 3-4
		weak = ProStart.amateur_after(weak, "win" if won else "points", run)
		run = run + 1 if won else 0
	_check(strong >= 75 and weak <= 35, "8-1 reads high (%d), 3-4 reads low (%d)" % [strong, weak])


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 4242
	c.fighters.clear()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 2
	f["l"] = 0
	f["offers"] = []
	f.erase("conf")
	return c


func _fight(c: Career, f: Dictionary) -> Dictionary:
	f["bout"]["day"] = c.day
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": f["id"], "step": "tape", "total": int(f["bout"].get("rounds", 3))}
	Bouts.fight_step(c, f, m, "sim")
	Bouts.after_fight(c, f)
	return m


func _book(c: Career, f: Dictionary) -> void:
	var opp: Dictionary = c.rival(load("res://scripts/state/AskFlow.gd").sheet_name(c, f)).duplicate(true)
	var o: Dictionary = Bouts._offer("%s:t%d" % [f["id"], c.day], opp, c.day + 14, c.day, 2)
	f["offers"] = [o]
	Bouts.accept(c, str(o["id"]))


func _test_wire() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	_check(ProPair.conf_of(f) == 58, "a 2-0 boxer with no bar yet reads from the record: 58 (%d)" % ProPair.conf_of(f))
	_book(c, f)
	_check(not (f["bout"] as Dictionary).is_empty(), "a bout is booked")
	var before := ProPair.conf_of(f)
	var w0 := int(f["w"])
	var m := _fight(c, f)
	var won := int(f["w"]) > w0
	var after := ProPair.conf_of(f)
	_check(after != before and (after > before) == won, "the amateur bout moved the bar the result's way (%d -> %d, won %s)" % [before, after, won])
	_check(str(m.get("bar_line", "")) == "Confidence %d → %d" % [before, after], "the result page's line (%s)" % str(m.get("bar_line", "")))
	_check(int(f.get("win_run", -1)) == (1 if won else 0), "the winning run is kept (%d)" % int(f.get("win_run", -1)))
	# the pro start takes the bar over
	f["conf"] = 81
	var s := ProPair.state(f)
	_check(int(s["conf"]) == 81 and int(s["hunger"]) == ProStart.HUNGER_START, "the first pro offer starts confidence at the boxer's own bar (%d)" % int(s["conf"]))
	# after "Not yet" an amateur bout moves the same bar (the pro state's)
	ProStart.not_yet(s)
	f["win_run"] = 0
	c.day += Bouts.AFTER_FIGHT + 1
	_book(c, f)
	w0 = int(f["w"])
	_fight(c, f)
	won = int(f["w"]) > w0
	_check(int(f["pro_start"]["conf"]) != 81 and (int(f["pro_start"]["conf"]) > 81) == won and ProPair.conf_of(f) == int(f["pro_start"]["conf"]),
		"an amateur bout after Not yet moves the pro start's confidence (81 -> %d, won %s)" % [int(f["pro_start"]["conf"]), won])


func _test_profile() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	var rows: Array = ProBars.rows(f, 400)
	var names: Array = rows.map(func(r): return str(r.name))
	_check(names == ["Bar_conf"], "an amateur with no pro offer shows the confidence bar alone (%s)" % str(names))
	var tip := str(rows[0].tooltip_text) if not rows.is_empty() else ""
	_check(tip.contains("58") and tip.to_lower().contains("pro"), "its hover says what it is for (%s)" % tip)
	for r in rows:
		r.free()
	var g: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	g["sport"] = "bjj"
	_check(ProBars.rows(g, 400).is_empty(), "a no-gi athlete has no confidence bar")


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", label)
	else:
		print("ok   ", label)
