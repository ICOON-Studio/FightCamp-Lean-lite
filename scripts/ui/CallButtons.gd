extends RefCounted
## S308: the corner's calls as buttons, the same in words and in 3D. A shout row (the three calls that fit the clue + Say
## nothing) and the corner minute's grid (all eight). Each button says when to use it or what to expect, and whether she can
## do it (Exchanges.grade); the corner's read is marked "coach".

const UI := preload("res://scripts/ui/UI.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const GRADE_COLOR := {"Good": Color("#6cc27a"), "OK": Color("#f0a020"), "Poor": Color("#e06060")}


static func _small(call: String, grades: Dictionary, line: String) -> String:
	return "%s.  Can: %s" % [line, str(grades.get(call, "OK"))]


## The shout bar's row. pick(call) gets "" for Say nothing.
static func shout_row(offers: Array, grades: Dictionary, coach: String, pick: Callable) -> HBoxContainer:
	var row := UI.hbox(10)
	for k in offers:
		var c: Dictionary = Exchanges.CALLS[k]
		var big := "\"%s\"%s" % [c["label"], "  (coach)" if str(k) == coach else ""]
		var b := UI.button2(big, _small(str(k), grades, "Expect: " + str(c["expect"])), "Choice", pick.bind(str(k)), Vector2(0, 64),
			UI.FG, GRADE_COLOR.get(str(grades.get(k, "OK")), UI.MUTED), false, UI.BODY, UI.SMALL)
		b.name = "Shout_" + str(k)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.tooltip_text = "When: %s" % c["when"]
		row.add_child(b)
	var quiet := UI.button2("Say nothing", "She keeps her focus; your next shout lands stronger", "BtnQuiet", pick.bind(""),
		Vector2(0, 64), UI.FG, UI.MUTED, false, UI.BODY, UI.SMALL)
	quiet.name = "SayNothing"
	quiet.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(quiet)
	return row


## The corner minute: all eight calls, four to a row. pick(call).
static func corner_grid(grades: Dictionary, coach: String, pick: Callable) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	for k in Exchanges.CALLS.keys():
		var c: Dictionary = Exchanges.CALLS[k]
		var big := "%s%s" % [c["label"], "  (coach)" if str(k) == coach else ""]
		var b := UI.button2(big, _small(str(k), grades, str(c["when"])), "Choice", pick.bind(str(k)),
			Vector2(240, 60), UI.FG, GRADE_COLOR.get(str(grades.get(k, "OK")), UI.MUTED), false, UI.SMALL + 1, UI.TINY)
		b.name = "Corner_" + str(k)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.tooltip_text = "Expect: %s" % c["expect"]
		grid.add_child(b)
	return grid
