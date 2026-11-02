extends RefCounted
## S354 the reception as an RPG recruit (operator: "get it more rpg elements to this"; mockup docs/mockups/
## S354_reception_rpg.png): class + potential stars, attributes against their ceiling, who the fighter is (two traits, a
## habit, the signature move, an ambition), ONE starting focus (the pick), and the perk road. Used by the walk-in
## (Interview, act "pickcard") and the trial (Trial, act "trialcard"). The preview is the signed fighter itself
## (Data.fighter_state: personality and habits come from the fighter's id).
##   RecruitPanel.build(main, career, applicant, picks, act) -> VBoxContainer   focus_of(picks) -> String

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const PerkRoad := preload("res://scripts/rules/PerkRoad.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"


static func focus_of(picks: Array) -> String:
	for p in picks:
		if Recruit.FOCUS.has(str(p)):
			return str(p)
	return ""


static func build(main: Node, c: Career, a: Dictionary, picks: Array, act: String) -> VBoxContainer:
	var f := Data.fighter_state(a.duplicate(true), c.day)
	var v := UI.vbox(10)
	var top := UI.hbox(14)
	var cl := Recruit.class_of(str(f.get("style", "")))
	top.add_child(UI.chip("%s - %s; %s" % [str(f.get("style", "")).to_upper(), cl[0], cl[1]], "gold"))
	var st := Recruit.stars(int(f["pot"]))
	var full := int(floor(float(st[1])))
	var stars_txt := "★".repeat(full) + "☆".repeat(5 - full)
	top.add_child(UI.label(stars_txt, UI.BODY + 4, UI.AMBER, "bold"))
	top.add_child(UI.muted("potential %s to %s stars (the coach's guess)" % [_s(float(st[0])), _s(float(st[1]))], UI.SMALL))
	v.add_child(top)
	var grid := UI.hbox(22)
	v.add_child(grid)
	grid.add_child(_attributes(f))
	grid.add_child(_who(main, f, picks, act))
	grid.add_child(_perks(f))
	return v


static func _s(x: float) -> String:
	return str(int(x)) if is_equal_approx(x, floorf(x)) else "%.1f" % x


static func _attributes(f: Dictionary) -> VBoxContainer:
	var col := UI.vbox(6)
	col.custom_minimum_size = Vector2(430, 0)
	col.add_child(UI.caps("ATTRIBUTES - GREEN NOW, BLUE = HOW HIGH IT CAN GO"))
	for key in Data.STATS:
		var row := UI.hbox(8)
		var l := UI.label(str(Data.LABEL[key]), UI.SMALL)
		l.custom_minimum_size = Vector2(110, 0)
		row.add_child(l)
		var now := float(f["stats"][key])
		var cap := Recruit.ceiling(f, key)
		var stack := Control.new()
		stack.custom_minimum_size = Vector2(200, 12)
		stack.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var ceil_bar: Control = Bar.new()
		ceil_bar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ceil_bar.fill = Color("#bfd8ff")
		ceil_bar.frac = cap / 100.0
		stack.add_child(ceil_bar)
		var now_bar: Control = Bar.new()
		now_bar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		now_bar.track = Color(0, 0, 0, 0)
		now_bar.frac = now / 100.0
		stack.add_child(now_bar)
		row.add_child(stack)
		row.add_child(UI.label("%d / %d" % [int(now), int(cap)], UI.SMALL, UI.FG, "mono"))
		col.add_child(row)
	col.add_child(UI.muted("The ceilings are a guess: training, sparring and fights show the truth.", UI.TINY, true))
	return col


static func _who(main: Node, f: Dictionary, picks: Array, act: String) -> VBoxContainer:
	var col := UI.vbox(6)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(UI.caps("WHO %s IS" % str(f["first"]).to_upper()))
	var tr := Recruit.traits(f.get("personality", {}))
	col.add_child(_line("TRAIT", "green", str(tr[0][0]), str(tr[0][1])))
	col.add_child(_line("TRAIT", "red", str(tr[1][0]), str(tr[1][1])))
	var hs: Array = f.get("habits", [])
	if not hs.is_empty():
		var h: Dictionary = _habit(str(hs[0]))
		col.add_child(_line("HABIT", "amber", str(h.get("name", hs[0])), str(h.get("effect", "")) + " Can be trained out."))
	var sig := Recruit.signature(f)
	if sig != "":
		col.add_child(_line("SIGNATURE", "", sig, "mastery %d%s" % [int(float(f["moves"][sig])), " - already a weapon" if float(f["moves"][sig]) >= 30.0 else ""]))
	col.add_child(_line("AMBITION", "gold", Recruit.ambition(f), "met: morale up; missed: loyalty drops"))
	col.add_child(UI.caps("CHOOSE ONE STARTING FOCUS - IT SETS THE FIRST MONTH"))
	var row := UI.hbox(8)
	var pick := focus_of(picks)
	for id in ["signature", "habit", "ceiling"]:
		var fc: Dictionary = Recruit.FOCUS[id]
		var gain := "%s +10 mastery now" % sig if id == "signature" and sig != "" else str(fc["short"])
		var b := UI.button2(str(fc["name"]), "%s\n%s" % [gain, fc["cost"]], "ChoiceOn" if pick == id else "Choice",
			main.act.bind(act, id), Vector2(196, 76), UI.FG, UI.MUTED, false, UI.SMALL + 1, UI.TINY)
		b.name = "Focus_" + id
		b.tooltip_text = "%s. %s" % [fc["gain"], fc["why"]]
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(b)
	col.add_child(row)
	return col


static func _line(tag: String, colour: String, name: String, effect: String) -> HBoxContainer:
	var h := UI.hbox(8)
	var c := UI.chip(tag, colour)
	c.custom_minimum_size = Vector2(96, 0)
	h.add_child(c)
	var t := UI.label("%s - %s" % [name, effect], UI.SMALL, UI.FG, "body", true)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.custom_minimum_size = Vector2(380, 0)
	h.add_child(t)
	return h


static func _perks(f: Dictionary) -> VBoxContainer:
	var col := UI.vbox(4)
	col.custom_minimum_size = Vector2(430, 0)
	col.add_child(UI.caps("THE PERK ROAD - PERKS OPEN AS TRAINING BUILDS THE ATTRIBUTES"))
	for s in PerkRoad.status(f):
		var row := UI.hbox(8)
		var n := UI.label(str(s["name"]), UI.SMALL, UI.GREEN if bool(s["open"]) or bool(s["near"]) else UI.FG, "bold")
		n.custom_minimum_size = Vector2(118, 0)
		row.add_child(n)
		var e := UI.label(str(s["effect"]), UI.TINY, UI.MUTED, "body", true)
		e.custom_minimum_size = Vector2(190, 0)
		e.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(e)
		row.add_child(UI.label("OPEN" if bool(s["open"]) else str(s["need"]), UI.TINY, UI.GREEN if bool(s["open"]) or bool(s["near"]) else UI.MUTED, "mono"))
		col.add_child(row)
	col.add_child(UI.muted("Green = open or close: the next weeks of training can open it.", UI.TINY, true))
	return col


static func _habit(id: String) -> Dictionary:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH)) if FileAccess.file_exists(HABITS_PATH) else null
	for row in (data as Dictionary).get("habits", []) if data is Dictionary else []:
		if str(row.get("id", "")) == id:
			return row
	return {}
