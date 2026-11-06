extends RefCounted
## S388 the Why panel on the result screen (rules/FightWhy.gd): the plan's grade, what it did, what went against the boxer, what to do next.

const UI := preload("res://scripts/ui/TV.gd")   # fight graphics keep the dark TV look
const FightWhy := preload("res://scripts/rules/FightWhy.gd")

const GRADE_COL := {"good": Color(0.35, 0.8, 0.5), "mixed": Color(0.95, 0.75, 0.3), "wrong": Color(0.95, 0.4, 0.35), "none": Color(0.7, 0.72, 0.76)}


static func build(rounds: Array, first: String, opp: String) -> Control:
	var read := FightWhy.read(rounds, first, opp)
	var v := UI.vbox(8)
	v.name = "WhyCard"
	var top := UI.hbox(14)
	top.add_child(UI.caps("WHY"))
	var grade := UI.label(str(FightWhy.GRADES[read["grade"]]), UI.BODY + 3, GRADE_COL[read["grade"]], "bold")
	grade.name = "WhyGrade"
	top.add_child(grade)
	v.add_child(top)
	for row in [["YOUR PLAN", "plan"], ["AGAINST YOU", "against"], ["NEXT", "next"]]:
		var h := UI.hbox(16)
		var head := UI.caps(str(row[0]))
		head.custom_minimum_size = Vector2(150, 0)
		h.add_child(head)
		var line := UI.label(str(read[row[1]]), UI.BODY, UI.FG, "body", true)
		line.name = "Why_" + str(row[1])
		h.add_child(line)
		v.add_child(h)
	return v
