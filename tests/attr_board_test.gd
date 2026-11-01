extends SceneTree
## S340 C157: her attributes board shows every value the bout reads (the 7 stats, footwork, her personality), grouped,
## banded, with this week's change, and the radar draws the 8 fight attributes against her potential. Overview and the
## Attributes tab both carry it.

const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")
const AttrRadar := preload("res://scripts/ui/AttrRadar.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	_pure()
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	main.career.seed = 1
	main.act("go_btn")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await process_frame
	var c: Career = main.career
	main.act("fighter", str(c.fighter()["id"]))
	for tab in ["0", "1"]:
		main.act("ftab", tab)
		await process_frame
		var page: Node = main._shell.find_child("FighterPage", true, false)
		_check(page != null, "fighter page open (tab %s)" % tab)
		if page == null:
			continue
		var radars := page.find_children("*", "Control", true, false).filter(func(n): return n.get_script() == AttrRadar)
		_check(radars.size() == 1, "tab %s has one radar (%d)" % [tab, radars.size()])
		var text := _texts(page)
		for word in ["FIGHTING", "BODY", "MIND", "AT A GLANCE", "Footwork", "Heart", "Discipline", "Coachability", "Temper", "Ring IQ"]:
			_check(text.contains(word), "tab %s shows %s" % [tab, word])
		_check(not text.contains("BAR = WAY TO THE NEXT POINT"), "tab %s: the old bar card is gone" % tab)
	print("PASS attr_board_test" if failures == 0 else "FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _pure() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	f["week_start"] = (f["stats"] as Dictionary).duplicate()
	f["stats"]["power"] = float(f["stats"]["power"]) + 0.6
	f["personality"]["temper"] = 80.0
	f["personality"]["heart"] = 80.0
	var groups := AttrBoard.rows(f)
	_check(groups.size() == 3, "three groups")
	var all := {}
	for g in groups:
		for r in g["rows"]:
			all[r["key"]] = r
	_check(all.size() == 13, "13 values (%d)" % all.size())
	for key in Data.STATS:
		_check(all.has(key), "stat %s shown" % key)
		if all.has(key):
			_check(is_equal_approx(float(all[key]["value"]), float(f["stats"][key])), "%s value matches" % key)
	_check(is_equal_approx(float(all["footwork"]["value"]), float(f["footwork"])), "footwork from her profile")
	_check(is_equal_approx(float(all["power"]["delta"]), 0.6), "power +0.6 this week (%.2f)" % float(all["power"]["delta"]))
	_check(is_equal_approx(float(all["speed"]["delta"]), 0.0), "speed unchanged this week")
	_check(str(all["heart"]["band"]) == "elite", "heart 80 is elite (%s)" % all["heart"]["band"])
	_check(str(all["temper"]["band"]) == "weak", "a hot temper (80) reads weak (%s)" % all["temper"]["band"])
	_check(AttrBoard.band("power", 44.0) == "weak" and AttrBoard.band("power", 60.0) == "solid" and AttrBoard.band("power", 70.0) == "strong",
		"bands by value")
	for key in all:
		_check(str(all[key]["why"]) != "", "%s says what it does" % key)
	_check(is_equal_approx(AttrRadar.frac(25.0), 0.0) and is_equal_approx(AttrRadar.frac(90.0), 1.0) and is_equal_approx(AttrRadar.frac(57.5), 0.5),
		"radar scale 25..90")
	var g := AttrBoard.glance(f)
	_check(str(g["best"][0]["key"]) == "heart", "best value is heart 80 (%s)" % g["best"][0]["key"])
	_check(bool(g["hot"]), "temper 80 reads hot")
	_check((g["best"] + g["work"]).all(func(r): return str(r["key"]) != "temper"), "temper is never a best or work-on value")
	_check(float(g["work"][0]["value"]) <= float(g["work"][1]["value"]), "work-on lists the lowest first")


func _texts(n: Node) -> String:
	var out := ""
	for l in n.find_children("*", "Label", true, false):
		out += (l as Label).text + "\n"
	return out


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
