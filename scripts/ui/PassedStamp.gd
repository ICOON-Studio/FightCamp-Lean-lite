extends RefCounted
## S373 PASSEDSTAMP1 (operator: the test-day moment): when a grade passes, the week review lands a stamp card -
## big "PASSED" in the grade's colour, the award line, one chip per graded move ("Jab: 8% less gas"), and what's next.
## Static builder like AwardCard.gd; uses only UI.gd helpers.

const UI := preload("res://scripts/ui/UI.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")


static func make(f: Dictionary, award_name: String) -> PanelContainer:
	var award_id := ""
	var moves: Dictionary = {}
	for a in SkillAwards.AWARDS:
		if str(a["name"]) == award_name:
			award_id = str(a["id"])
			moves = (a.get("moves", {}) as Dictionary)
			break
	var color := UI.GOLD
	if SkillAwards.GRADE_COLOR.has(award_id):
		color = SkillAwards.GRADE_COLOR[award_id]
	var parts := UI.card()
	var p: PanelContainer = parts[0]
	p.name = "PassedStamp"
	var v: VBoxContainer = parts[1]
	var stamp := UI.display("PASSED", 48, color)
	stamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(stamp)
	v.add_child(UI.label("%s award - a medal and a certificate" % award_name, UI.BODY, UI.FG, "body", true))
	if not moves.is_empty():
		var h := UI.hbox(6)
		for mv_name in moves:
			var pct := roundi(100.0 * (1.0 - float(SkillAwards.ECONOMY.get(award_id, 1.0))))
			h.add_child(UI.chip("%s: %d%% less gas" % [mv_name, pct], "green"))
		v.add_child(h)
	var nxt := SkillAwards.next_award(f)
	if nxt.is_empty():
		v.add_child(UI.label("Every award passed", UI.BODY, UI.GOLD, "bold"))
	else:
		v.add_child(UI.label("Next: %s" % str(nxt["name"]), UI.BODY, UI.MUTED, "body"))
	return p
