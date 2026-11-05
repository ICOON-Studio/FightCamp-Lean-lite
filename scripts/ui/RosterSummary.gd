extends RefCounted
## S388 C236 (operator on FIGHTERS > Roster: "this should be a summary page , fill all necessary information for each fighter"): what
## a coach needs at a glance under each roster row. A boxer: the seven attributes as small bars, then style, main session, the
## move being learned, weapons and pay. A no-gi athlete: the syllabus groups as bars, then mood, next open, chance and the next belt.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

const BAR_W := 104.0


static func boxer(c: Career, f: Dictionary) -> Control:
	var v := UI.vbox(10)
	v.name = "Summary_" + str(f["id"])
	var bars := UI.hbox(14)
	bars.name = "Attributes"
	for k in Data.STATS:
		var n := float(f["stats"][k])
		bars.add_child(_bar(str(Data.LABEL[k]), "%d" % int(round(n)), n / 100.0))
	v.add_child(bars)
	var facts := UI.hbox(28)
	facts.name = "Facts"
	facts.add_child(_fact("STYLE", str(f.get("style", "-"))))
	var focus := Sim.focus_of(c, f)
	facts.add_child(_fact("MAIN SESSION", str(Data.LABEL.get(focus, focus)) if focus != "" else "not set"))
	facts.add_child(_fact("LEARNING", _learning(f)))
	facts.add_child(_fact("WEAPONS", weapons(f)))
	facts.add_child(_fact("PAY", "Purses" if bool(f.get("pro", false)) else "$250 a week stipend"))
	v.add_child(facts)
	return v


## The no-gi athlete's summary; `g` is on the belt road, so the bars are the syllabus groups at this belt.
static func grappler(c: Career, g: Dictionary) -> Control:
	var v := UI.vbox(10)
	v.name = "Summary_" + str(g["id"])
	v.add_child(UI.muted("%s, %d" % [str(g.get("wc", "")), int(g.get("age", 21))], UI.SMALL))
	var bars := UI.hbox(14)
	bars.name = "Syllabus"
	for gr in NoGi.groups_of(g):
		var share := NoGi.group_own(g, gr[1])
		bars.add_child(_bar(str(gr[0]), "%d%%" % int(round(share * 100.0)), share))
	v.add_child(bars)
	var facts := UI.hbox(28)
	facts.name = "Facts"
	facts.add_child(_fact("MOOD", FighterProfile.mood(float(g.get("morale", FighterProfile.MORALE_START)))))
	var opens := NoGi.opens_after(c.day, 1)
	facts.add_child(_fact("NEXT OPEN", "%s, %s" % [str(opens[0]["name"]), Clock.fmt(int(opens[0]["d"]))]))
	facts.add_child(_fact("CHANCE", NoGi.chance_word(NoGi.win_chance(g, c.day)).capitalize()))
	facts.add_child(_fact("BEST AT", NoGi.best_group(g)))
	var belt := BeltRoad.next_belt(str(g.get("belt", "white")))
	if belt != "":
		facts.add_child(_fact("%s BELT" % belt.to_upper(), "about %d weeks" % NoGi.weeks_to_ready(g, c.day)))
	v.add_child(facts)
	return v


## "3 of 7 moves": how many of the boxer's moves are weapons (BoutRules.WEAPON_MASTERY).
static func weapons(f: Dictionary) -> String:
	var moves: Dictionary = f.get("moves", {})
	var n := 0
	for k in moves:
		if float(moves[k]) >= BoutRules.WEAPON_MASTERY:
			n += 1
	return "%d of %d moves" % [n, moves.size()]


static func _learning(f: Dictionary) -> String:
	var learn := str(f.get("learning", ""))
	if learn == "":
		return "coach picks"
	return "%s, %s" % [learn, MoveMastery.tier(float((f.get("moves", {}) as Dictionary).get(learn, 0.0))).to_lower()]


static func _bar(head: String, value: String, frac: float) -> Control:
	var b := UI.vbox(3)
	var top := UI.hbox(6)
	top.add_child(UI.muted(head, UI.SMALL))
	top.add_child(UI.spacer())
	top.add_child(UI.label(value, UI.SMALL, UI.FG, "bold"))
	b.add_child(top)
	b.add_child(UI.meter(clampf(frac, 0.0, 1.0), UI.GREEN, [], BAR_W))
	b.custom_minimum_size.x = BAR_W
	return b


static func _fact(head: String, value: String) -> Control:
	var b := UI.vbox(1)
	b.add_child(UI.caps(head))
	b.add_child(UI.label(value, UI.SMALL, UI.FG, "bold"))
	return b
