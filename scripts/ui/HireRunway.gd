extends RefCounted
## S515 COACHROLES1 (coach roles r6, R5; ops/research/DESIGN_COACHSPEC1_R6_DOLA.md 3.5): the weeks of money left before and
## after a hire, on the Staff page's hire cards (StaffCard). The numbers are CoachRoles.hire_line; it warns, never blocks.

const UI := preload("res://scripts/ui/UI.gd")
const CoachRoles := preload("res://scripts/rules/CoachRoles.gd")


static func text_for(c: Career, wage_change: int, income: int) -> String:
	return text(CoachRoles.hire_line(float(c.cash), float(net(c)), float(wage_change), float(income)))


## S515 COACHROLES1 (coach roles r6, R5): what a hire does to the weeks of money left, before any member growth. Amber
## under 8 weeks (the game's closing count), red under 6; it warns, never blocks.
static func line(c: Career, wage_change: int, income: int, id: String) -> Control:
	var rl := CoachRoles.hire_line(float(c.cash), float(net(c)), float(wage_change), float(income))
	var col := UI.RED if str(rl["band"]) == "red" else (UI.AMBER if str(rl["band"]) == "amber" else UI.FG)
	var l := UI.label(text(rl), 16, col, "bold")
	l.name = "Runway_" + id
	l.tooltip_text = "Weeks of cash left, before and after this hire (members not counted)."
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	return l


static func weeks(n: int) -> String:
	return "no end" if n >= CoachRoles.RUNWAY_SAFE else str(n)


static func text(rl: Dictionary) -> String:
	return "Money lasts %s -> %s weeks" % [weeks(int(rl["before"])), weeks(int(rl["after"]))]


static func net(c: Career) -> int:
	return int(load("res://scripts/state/Needs.gd").money_net(c))
