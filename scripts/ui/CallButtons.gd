extends RefCounted
## S308: the corner's calls as buttons, the same in words and in 3D. A shout row (the three calls that fit the clue + Say
## nothing) and the corner minute's grid (all eight). Each button says when to use it or what to expect, and whether she can
## do it (Exchanges.grade); the corner's read is marked "coach's pick" (on a shout only with film study, S310).
## S309 (operator on update 9: "fix the wording"): two women in the ring, so every line names who it means
## (names = [hers, the opponent's]); the grade reads as a sentence, coloured by how well she does it.

const UI := preload("res://scripts/ui/UI.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const GRADE_COLOR := {"Good": Color("#6cc27a"), "OK": Color("#f0a020"), "Poor": Color("#e06060")}
const PICK := "   - coach's pick"
## S310 the shout bar's mark comes from her tapes (LiveRound.preview "mark"): her usual game, not what she does now.
const PICK_FILM := "   - coach's pick (from film)"


static func _small(call: String, grades: Dictionary, line: String, names: Array) -> String:
	var g := str(grades.get(call, "OK"))
	return "%s\n%s" % [Exchanges.named(line, names), Exchanges.named(str(Exchanges.GRADE_LINE.get(g, "")), names)]


## The shout bar's row. pick(call) gets "" for Say nothing.
static func shout_row(offers: Array, grades: Dictionary, coach: String, names: Array, pick: Callable) -> HBoxContainer:
	var row := UI.hbox(10)
	for k in offers:
		var c: Dictionary = Exchanges.CALLS[k]
		var big := "\"%s\"%s" % [c["label"], PICK_FILM if str(k) == coach else ""]
		# S310: with no mark (no film study) the clue is matched to each call's "when" line, as on the corner grid.
		var b := UI.button2(big, _small(str(k), grades, str(c["when"]), names), "Choice", pick.bind(str(k)), Vector2(0, 80),
			UI.FG, GRADE_COLOR.get(str(grades.get(k, "OK")), UI.MUTED), false, UI.BODY, UI.SMALL)
		b.name = "Shout_" + str(k)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.tooltip_text = Exchanges.named(str(c["expect"]), names)
		row.add_child(b)
	var quiet := UI.button2("Say nothing", "%s sticks to the plan\nNo shout used" % names[0], "BtnQuiet",
		pick.bind(""), Vector2(0, 80), UI.FG, UI.MUTED, false, UI.BODY, UI.SMALL)
	quiet.name = "SayNothing"
	quiet.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(quiet)
	return row


## S309 the corner's one fix for a habit: a button per habit the coach can work on ({id, name, paid} from
## LiveRound.fixes) and No fix. The picked one stays lit. pick(id) gets "" for No fix. Empty when there is nothing to fix.
static func fix_row(fixes: Array, names: Array, chosen: String, pick: Callable) -> HBoxContainer:
	var row := UI.hbox(8)
	if fixes.is_empty():
		return row
	for h in fixes:
		var paid := int(h["paid"])
		var small := "%s made %s pay %d time%s this round" % [names[1], names[0], paid, "" if paid == 1 else "s"] if paid > 0 \
			else "Your coach has seen it"
		var b := UI.button2("Fix: " + str(h["name"]), small, "Choice", pick.bind(str(h["id"])), Vector2(0, 56),
			UI.FG, UI.AMBER if paid > 0 else UI.MUTED, false, UI.SMALL + 1, UI.TINY)
		b.name = "Fix_" + str(h["id"])
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.modulate = Color(1, 1, 1, 1.0 if chosen == "" or chosen == str(h["id"]) else 0.45)
		row.add_child(b)
	var none := UI.button2("No fix", "Just the plan", "BtnQuiet", pick.bind(""), Vector2(160, 56), UI.FG, UI.MUTED, false,
		UI.SMALL + 1, UI.TINY)
	none.name = "FixNone"
	none.modulate = Color(1, 1, 1, 1.0 if chosen == "" else 0.45)
	row.add_child(none)
	return row


## The corner minute: all eight calls, four to a row. pick(call).
static func corner_grid(grades: Dictionary, coach: String, names: Array, pick: Callable) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	for k in Exchanges.CALLS.keys():
		var c: Dictionary = Exchanges.CALLS[k]
		var big := "%s%s" % [c["label"], PICK if str(k) == coach else ""]
		var b := UI.button2(big, _small(str(k), grades, str(c["when"]), names), "Choice", pick.bind(str(k)),
			Vector2(240, 66), UI.FG, GRADE_COLOR.get(str(grades.get(k, "OK")), UI.MUTED), false, UI.SMALL + 1, UI.TINY)
		b.name = "Corner_" + str(k)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.tooltip_text = Exchanges.named(str(c["expect"]), names)
		grid.add_child(b)
	return grid
