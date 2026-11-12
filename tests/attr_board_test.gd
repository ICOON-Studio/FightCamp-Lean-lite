extends SceneTree
## S340 C157: her attributes board shows every value the bout reads, grouped, banded, with this week's change, and the
## radar. S398 the fighter model: the 20 attributes + heart + the personality in PHYSICAL / SKILL / MIND, the radar on the
## six keys (Duels.keys), the signature line and where the fighter wants the fight. Overview and the Attributes tab both.

const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")
const AttrRadar := preload("res://scripts/ui/AttrRadar.gd")
const Data := preload("res://scripts/state/Data.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

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
		_check(radars.size() == 0, "tab %s: no radar, the bars carry the numbers (S398) (%d)" % [tab, radars.size()])
		var text := _texts(page)
		for word in ["PHYSICAL", "SKILL", "MIND", "AT A GLANCE", "Footwork", "Heart", "Discipline", "Coachability", "Temper", "Fight IQ",
				"In the ring", "Defence"]:
			_check(text.contains(word), "tab %s shows %s" % [tab, word])
		_check(not text.contains("BAR = WAY TO THE NEXT POINT"), "tab %s: the old bar card is gone" % tab)
		# S439 CARDIO1 round 3 (TRAINING_MAP T17: "Printed on the row", not on hover): the Stamina row's own line in a label
		# the player reads without hovering - what her points under it cost and where it ends, in game words (S439 merge prep:
		# "From round 3: fights 0.61 weaker; Stamina 60 stops it", never the bare "fade 0.61 · none at 60"; S439: not "every stat
		# 0.61 lower" either - in the live fight the fade comes off her fight strength, which only approximates every stat).
		var st := float(Attrs.of(c.fighter())["stamina"])
		var want := ("From round 3: fights %.2f weaker; Stamina %d stops it" % [BoutRules.own_fade(st), int(BoutRules.FADE_STAMINA)]) \
			if BoutRules.own_fade(st) > 0.0 else ("From round 3: fights no weaker (Stamina %d or more)" % int(BoutRules.FADE_STAMINA))
		_check(not text.contains("none at %d" % int(BoutRules.FADE_STAMINA)), "tab %s: no old 'fade · none at' caption" % tab)
		_check(not text.contains("From round 3: every stat"), "tab %s: no old 'every stat ... lower' caption" % tab)
		_check(text.contains(want), "tab %s: the Stamina row prints its line on the row (Stamina %.2f): '%s'" % [tab, st, want])
	print("PASS attr_board_test" if failures == 0 else "FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _pure() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	f["attrs_week"] = Attrs.of(f).duplicate()
	f["stats"]["power"] = float(f["stats"]["power"]) + 0.6   # an old-stat writer: the board sees it on the attribute
	f["personality"]["temper"] = 80.0
	f["personality"]["heart"] = 80.0
	var groups := AttrBoard.rows(f)
	_check(groups.size() == 3, "three groups")
	var all := {}
	for g in groups:
		for r in g["rows"]:
			all[r["key"]] = r
	_check(all.size() == Attrs.ABILITIES.size() + 5, "every attribute and the personality (%d)" % all.size())
	var a := Attrs.of(f)
	for key in Attrs.ABILITIES:
		_check(all.has(key), "attribute %s shown" % key)
		if all.has(key):
			_check(is_equal_approx(float(all[key]["value"]), float(a[key])), "%s value matches" % key)
	_check(is_equal_approx(float(all["footwork"]["value"]), float(f["footwork"])), "footwork is the profile's")
	_check(is_equal_approx(float(all["strength"]["delta"]), 0.6), "strength +0.6 this week (%.2f)" % float(all["strength"]["delta"]))
	_check(is_equal_approx(float(all["explosiveness"]["delta"]), 0.6), "explosiveness +0.6 this week (%.2f)" % float(all["explosiveness"]["delta"]))
	_check(is_equal_approx(float(all["speed"]["delta"]), 0.0), "speed unchanged this week")
	_check(str(all["heart"]["band"]) == "elite", "heart 80 is elite (%s)" % all["heart"]["band"])
	_check(str(all["temper"]["band"]) == "weak", "a hot temper (80) reads weak (%s)" % all["temper"]["band"])
	_check(AttrBoard.band("power", 44.0) == "weak" and AttrBoard.band("power", 60.0) == "solid" and AttrBoard.band("power", 70.0) == "strong",
		"bands by value")
	for key in all:
		_check(str(all[key]["why"]) != "", "%s says what it does" % key)
	# S434 CARDIO1 (TRAINING_MAP T17): the Stamina row's hover carries its own fade line, read on its own number.
	var fade_line := "In a bout: " + BoutRules.fade_words(float(a["stamina"]))
	_check(str(all["stamina"]["why"]).ends_with(fade_line) and str(all["stamina"]["why"]).contains("from round 3"),
		"the Stamina row says its fade line (%s)" % str(all["stamina"]["why"]).get_slice("\n", 1))
	_check(is_equal_approx(AttrRadar.frac(25.0), 0.0) and is_equal_approx(AttrRadar.frac(90.0), 1.0) and is_equal_approx(AttrRadar.frac(57.5), 0.5),
		"radar scale 25..90")
	var g := AttrBoard.glance(f)
	_check(str(g["best"][0]["key"]) == "heart", "best value is heart 80 (%s)" % g["best"][0]["key"])
	_check(bool(g["hot"]), "temper 80 reads hot")
	_check((g["best"] + g["work"]).all(func(r): return str(r["key"]) != "temper"), "temper is never a best or work-on value")
	_check(float(g["work"][0]["value"]) <= float(g["work"][1]["value"]), "work-on lists the lowest first")
	_check(str(g["wants"]) != "", "where the fighter wants the fight, in words (%s)" % g["wants"])


func _texts(n: Node) -> String:
	var out := ""
	for l in n.find_children("*", "Label", true, false):
		out += (l as Label).text + "\n"
	return out


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
