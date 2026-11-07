extends RefCounted
## S396 screen cut (docs/STRUCTURE_DESIGN_S395.md 5.4; mock-up STRUCTURE_MOCKUPS_S395.html#roster): every fighter in one
## sortable table, built for eight - one row each, a click on a column sorts it, a click on a row opens her page. Above it,
## one "Needs you" line: only what is wrong (CoachCheck's bad rows), not every check on every card.
## The "Run by: Coach or Me" column comes with P4 (Coach runs it); nothing is shown for it before it works.
##   RosterTable.rows(c) -> [{id, cells: {col: [text, sort, tone]}, grappler}]   RosterTable.build(main, c, sort_col)

const UI := preload("res://scripts/ui/UI.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const NextStep := preload("res://scripts/rules/NextStep.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const FIGHTER_PAGE := preload("res://scripts/ui/areas/FighterPage.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FACE := Vector2(48, 60)

const COLS := [["fighter", "Fighter", 260], ["record", "Record", 90], ["rank", "Rank", 110], ["road", "The Road", 150],
	["next", "Next", 230], ["weight", "Weight", 130], ["condition", "Condition", 120], ["goal", "Goal", 260]]
const TONE := {"ok": UI.FG, "good": UI.GREEN, "watch": UI.AMBER, "bad": UI.RED, "muted": UI.MUTED}

## The sort column the page last used (kept while the game runs).
static var sort_col := "fighter"
static var sort_down := false


static func rows(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		out.append({"id": str(f["id"]), "grappler": false, "cells": _boxer_cells(c, f), "face": Faces.stem(f)})
	for g in c.grapplers:
		out.append({"id": str(g["id"]), "grappler": true, "cells": _grappler_cells(c, g), "face": Faces.stem(g)})
	return out


static func _boxer_cells(c: Career, f: Dictionary) -> Dictionary:
	var cells := {}
	cells["fighter"] = ["%s\n%d, %s" % [f["name"], int(f["age"]), f["wc"]], str(f["name"]), "ok"]
	var pro := bool(f.get("pro", false))
	cells["record"] = ["%d-%d%s" % [int(f["w"]), int(f["l"]), " pro" if pro else ""], float(int(f["w"]) * 100 - int(f["l"])), "ok"]
	var rk := int(f.get("rank", 0))
	cells["rank"] = ["#%d" % rk if rk > 0 else "-", float(rk if rk > 0 else 999), "ok"]
	var road: Dictionary = NextStep.road(FIGHTER_PAGE._road_input(c, f), c.day)
	var lit := int(road["lit"])
	cells["road"] = ["Pro" if lit < 0 else str(road["steps"][lit]["name"]), float(lit if lit >= 0 else 99), "ok"]
	var b: Dictionary = f.get("bout", {})
	if b.has("day") and b.has("opp"):
		cells["next"] = ["%s, %s" % [str(b["opp"]["name"]), Clock.fmt(int(b["day"]))], float(int(b["day"])), "ok"]
	else:
		cells["next"] = ["No bout", 1.0e9, "watch"]
	var over := float(f["weight"]) - float(f["limit"])
	cells["weight"] = ["On weight" if over <= 0.0 else "%.1f kg over" % over, over, "good" if over <= 0.0 else ("watch" if over < 1.5 else "bad")]
	var word: Array = WB_KIT.fatigue_word(FighterProfile.fatigue(f), false)
	var w := str(word[0]).to_lower()
	cells["condition"] = [w.capitalize(), FighterProfile.fatigue(f), "good" if w == "fresh" else ("ok" if w == "ok" else ("watch" if w == "tired" else "bad"))]
	var g := Sim.goal_read(c, f)
	if g.is_empty():
		cells["goal"] = ["Talk in the office" if bool(f.get("goal_talk", false)) else "No goal set", 1.0e9, "muted"]
	else:
		var st := str(g["status"]).to_lower()
		cells["goal"] = ["%s\n%s, %d days" % [g["title"], st, int(g["left"])], float(int(g["left"])),
			{"green": "good", "amber": "watch", "red": "bad"}.get(str(g["cls"]), "ok")]
	return cells


static func _grappler_cells(c: Career, g: Dictionary) -> Dictionary:
	var cells := {}
	cells["fighter"] = ["%s\n%d, no-gi" % [g["name"], int(g.get("age", 0))], str(g["name"]), "ok"]
	cells["record"] = ["%d-%d" % [int(g.get("w", 0)), int(g.get("l", 0))], float(int(g.get("w", 0)) * 100 - int(g.get("l", 0))), "ok"]
	# S397 blind round 5 ("columns mean different things per row"): each cell answers its column - no-gi has no table
	# and no weight cut; the belt is her road.
	cells["rank"] = ["No table", 999.0, "ok"]
	cells["road"] = ["%s belt" % str(g.get("belt", "white")).capitalize(), 50.0, "ok"]
	var entered: Array = g.get("entered", [])
	var next_day := -1
	for d in entered:
		if int(d) >= c.day and (next_day < 0 or int(d) < next_day):
			next_day = int(d)
	cells["next"] = ["Open, %s" % Clock.fmt(next_day) if next_day >= 0 else "No open entered", float(next_day if next_day >= 0 else 1.0e9), "ok" if next_day >= 0 else "watch"]
	# S396 blind round 2 ("Ana's row is all dashes"): what she has - her class, her mood, the next belt.
	cells["weight"] = ["No cut", 0.0, "ok"]
	var mood := FighterProfile.mood(float(g.get("morale", FighterProfile.MORALE_START)))
	cells["condition"] = [mood, 50.0, {"Fired up": "good", "Steady": "ok", "Flat": "watch", "Low": "bad"}.get(mood, "ok")]
	var nxt := BeltRoad.next_belt(str(g.get("belt", "white")))
	var share := float(BeltRoad.readiness(g, g.get("bjj", {}), c.day)["share"])
	cells["goal"] = ["%s belt
%d%% of the way" % [nxt.capitalize(), int(round(share * 100.0))] if nxt != "" else "Top belt", 1.0e8 - share, "ok"]
	return cells


## Only what is wrong, one line: "Lucy: no bout booked. Ana: ..." ("" when nothing is). S396 blind round 3 ("Nobody needs
## you" beside an open nationals entry and a goal talk): Home's own pins come first, so the two pages agree.
static func needs_line(c: Career) -> String:
	var parts: Array = []
	for n in Needs.needs(c):
		parts.append(str(n["t"]))
	for f in c.fighters:
		var bad := CoachCheck.rows(c, f).filter(func(r): return str(r["state"]) == "bad")
		if not bad.is_empty():
			parts.append("%s: %s" % [f["first"], ", ".join(bad.map(func(r): return "%s %s" % [str(r["label"]).to_lower(), r["word"]]))])
	return ". ".join(parts) + ("." if not parts.is_empty() else "")


static func build(main: Node, c: Career) -> VBoxContainer:
	var v := UI.vbox(8)
	v.name = "RosterTable"
	# S397 blind round 4 ("one run-on red sentence, nothing clickable"): each need is a chip that goes where it is answered.
	var chips := HFlowContainer.new()
	chips.name = "NeedChips"
	chips.add_theme_constant_override("h_separation", 8)
	chips.add_theme_constant_override("v_separation", 6)
	chips.add_child(UI.label("Needs you:" if needs_line(c) != "" else "Nobody needs you this week.", UI.BODY, UI.FG if needs_line(c) != "" else UI.MUTED, "bold"))
	for n in Needs.needs(c):
		chips.add_child(UI.button(str(n["t"]), "FlagRed" if bool(n.get("red", false)) else "Flag", main.act.bind(str(n["act"]), str(n.get("arg", "")))))
	for f in c.fighters:
		var bad := CoachCheck.rows(c, f).filter(func(r): return str(r["state"]) == "bad")
		if not bad.is_empty():
			chips.add_child(UI.button("%s: %s" % [f["first"], ", ".join(bad.map(func(r): return "%s %s" % [str(r["label"]).to_lower(), r["word"]]))],
				"Flag", main.act.bind("fighter", str(f["id"]))))
	v.add_child(chips)
	var head := UI.hbox(0)
	for col in COLS:
		var id := str(col[0])
		var arrow := (" ▼" if sort_down else " ▲") if sort_col == id else ""
		var b := UI.button(str(col[1]) + arrow, "Tab", func(): _sort_by(main, id))
		b.name = "Sort_" + id
		b.custom_minimum_size = Vector2(float(col[2]), 0)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		head.add_child(b)
	v.add_child(head)
	var data := rows(c)
	data.sort_custom(func(a, b2):
		var x: Variant = a["cells"][sort_col][1]
		var y: Variant = b2["cells"][sort_col][1]
		return (x > y) if sort_down else (x < y))
	for r in data:
		v.add_child(_row(main, r))
	return v


static func _sort_by(main: Node, id: String) -> void:
	sort_down = (not sort_down) if sort_col == id else false
	sort_col = id
	main.render()


static func _row(main: Node, r: Dictionary) -> Control:
	var b := Button.new()
	b.name = "Row_" + str(r["id"])
	b.theme_type_variation = "Btn"
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.custom_minimum_size = Vector2(0, FACE.y + 12.0)
	b.pressed.connect(main.act.bind("fighter", str(r["id"])))
	var h := UI.hbox(0)
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for col in COLS:
		var cell: Array = r["cells"][str(col[0])]
		var l := UI.label(str(cell[0]), UI.SMALL if str(cell[0]).contains("\n") else UI.BODY, TONE.get(str(cell[2]), UI.FG),
			"bold" if str(col[0]) == "fighter" else "body")
		l.custom_minimum_size = Vector2(float(col[2]) - 12.0, 0)
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var pad := MarginContainer.new()
		pad.add_theme_constant_override("margin_left", 12)
		pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if str(col[0]) == "fighter":   # her face beside her name (S396: the bare table read thin with two fighters)
			var face := UI.hbox(10)
			face.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var pic: Control = PromoShot.picture(str(r.get("face", "")), FACE)
			if pic != null:
				pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
				face.add_child(pic)
				l.custom_minimum_size.x -= FACE.x + 10.0
			face.add_child(l)
			pad.add_child(face)
		else:
			pad.add_child(l)
		h.add_child(pad)
	b.add_child(h)
	return b
