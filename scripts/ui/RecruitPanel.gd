extends RefCounted
## S354 the reception as an RPG recruit (operator: "get it more rpg elements to this"; mockup docs/mockups/
## S354_reception_rpg.png): class + potential stars, attributes against their ceiling, who the fighter is (two traits, a
## habit, the signature move, an ambition), ONE starting focus (the pick), and the perk road. Used by the walk-in
## (Interview, act "pickcard") and the trial (Trial, act "trialcard"). The preview is the signed fighter itself
## (Data.fighter_state: personality and habits come from the fighter's id).
##   RecruitPanel.build(main, career, applicant, picks, act) -> VBoxContainer   focus_of(picks) -> String

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Data := preload("res://scripts/state/Data.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const PerkRoad := preload("res://scripts/rules/PerkRoad.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const HABITS_PATH := "res://assets/data/fight_habits.json"


static func focus_of(picks: Array) -> String:
	for p in picks:
		if Recruit.FOCUS.has(str(p)):
			return str(p)
	return ""


const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const STAT_ICON := {"power": "hands", "speed": "energy", "technique": "pads", "defense": "guard", "conditioning": "roadwork", "fight_iq": "film", "chin": "injured"}


static func build(main: Node, c: Career, a: Dictionary, picks: Array, act: String) -> VBoxContainer:
	var f := Data.fighter_state(a.duplicate(true), c.day)
	var v := UI.vbox(10)
	var top := UI.hbox(14)
	var cl := Recruit.class_of(str(f.get("style", "")))
	top.add_child(_chip("%s - %s; %s" % [str(f.get("style", "")).to_upper(), cl[0], cl[1]], "gold"))
	var eye := HeadCoach.sees_potential(c.head)   # S397 the amateur coach's eye for talent: the exact value, not a range
	var st := Recruit.stars(int(f["pot"]), eye)
	var full := int(floor(float(st[1])))
	var stars_txt := "★".repeat(full) + "☆".repeat(5 - full)
	top.add_child(UI.label(stars_txt, UI.BODY + 10, UI.AMBER, "bold"))
	top.add_child(UI.muted("potential %s stars (your eye for talent: exact)" % _s(float(st[0])) if eye else
		"potential %s to %s stars (a guess until the trial)" % [_s(float(st[0])), _s(float(st[1]))], UI.BODY))
	v.add_child(top)
	var grid := UI.hbox(22)
	v.add_child(grid)
	grid.add_child(_attributes(f))
	grid.add_child(_who(main, f, picks, act))
	v.add_child(_perks(f))
	return v


static func _s(x: float) -> String:
	return str(int(x)) if is_equal_approx(x, floorf(x)) else "%.1f" % x


static func _attributes(f: Dictionary) -> VBoxContainer:
	var col := UI.vbox(6)
	col.custom_minimum_size = Vector2(500, 0)
	col.add_child(UI.caps("ATTRIBUTES"))
	col.add_child(UI.muted("Green is now, blue is how high it can go.", UI.SMALL))
	# S398 menus (first-hour critics: "/84" six times read as a template): the ceiling most attributes share is said once
	# under the bars; a row prints its own ceiling only when it differs.
	var caps := {}
	for key in Data.STATS:
		var k := int(Recruit.ceiling(f, key))
		caps[k] = int(caps.get(k, 0)) + 1
	var common := -1
	for k in caps:
		if common < 0 or int(caps[k]) > int(caps[common]):
			common = int(k)
	for key in Data.STATS:
		var row := UI.hbox(8)
		row.add_child(KitIcon.icon(str(STAT_ICON.get(key, "star")), 24, WoodKit.HEAD))
		var l := UI.label(str(Data.LABEL[key]), UI.BODY)
		l.custom_minimum_size = Vector2(130, 0)
		row.add_child(l)
		var now := float(f["stats"][key])
		var cap := Recruit.ceiling(f, key)
		var stack := Control.new()
		stack.custom_minimum_size = Vector2(220, 18)
		stack.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var ceil_bar: Control = Bar.new()
		ceil_bar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ceil_bar.track = Color(WoodKit.SOFT, 0.28)
		ceil_bar.fill = WoodKit.BLUE
		ceil_bar.frac = cap / 100.0
		stack.add_child(ceil_bar)
		var now_bar: Control = Bar.new()
		now_bar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		now_bar.track = Color(0, 0, 0, 0)
		now_bar.fill = UI.GREEN
		now_bar.frac = now / 100.0
		stack.add_child(now_bar)
		row.add_child(stack)
		row.add_child(UI.label("%d" % int(now) + ("  up to %d" % int(cap) if int(cap) != common else ""), UI.BODY, UI.FG, "bold"))
		col.add_child(row)
	col.add_child(UI.muted("Most can climb to about %d (a guess until training shows the truth)." % common, UI.SMALL, true))
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
		col.add_child(_line("SIGNATURE", "", sig, "mastery %d%s" % [int(float(f["moves"][sig])), " - already usable" if float(f["moves"][sig]) >= 30.0 else ""]))
	# S396 truth pass: the AMBITION line promised "met: morale up; missed: loyalty drops" and nothing did that. It comes back
	# with P8 (promises and loyalty, docs/STRUCTURE_DESIGN_S395.md), when keeping it does something.
	col.add_child(UI.caps("CHOOSE ONE STARTING FOCUS - IT SETS THE FIRST MONTH"))
	var row := UI.hbox(8)
	var pick := focus_of(picks)
	for id in ["signature", "habit", "ceiling"]:
		var fc: Dictionary = Recruit.FOCUS[id]
		var gain := "%s +10 mastery now" % sig if id == "signature" and sig != "" else str(fc["short"])
		var b := UI.button2(str(fc["name"]), "%s\n%s" % [gain, fc["cost"]], "ChoiceOn" if pick == id else "Choice",
			main.act.bind(act, id), Vector2(216, 96), UI.FG, UI.MUTED, false, UI.BODY, UI.SMALL)
		_slate_choice(b, pick == id)
		b.name = "Focus_" + id
		b.tooltip_text = "%s. %s" % [fc["gain"], fc["why"]]
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(b)
	col.add_child(row)
	return col


static func _line(tag: String, colour: String, name: String, effect: String) -> HBoxContainer:
	var h := UI.hbox(8)
	var c := _chip(tag, colour)
	c.custom_minimum_size = Vector2(96, 0)
	h.add_child(c)
	# S408 "tone of text": the name in big words, what it does on hover.
	var t := UI.label(name, UI.BODY + 2, UI.FG, "semi", true)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.custom_minimum_size = Vector2(360, 0)
	t.mouse_filter = Control.MOUSE_FILTER_PASS
	t.tooltip_text = effect
	h.tooltip_text = effect
	h.add_child(t)
	return h


## S408: the closest perks as one row of chips; what each does is on hover.
static func _perks(f: Dictionary) -> HFlowContainer:
	var row := HFlowContainer.new()
	row.name = "Perks"
	row.add_theme_constant_override("h_separation", 10)
	row.add_child(UI.caps("CLOSEST PERKS"))
	# S398 menus (first-hour critics: every walk-in showed the same road): this fighter's open perks and the nearest ones,
	# four at most; the rest wait on the fighter page.
	var road: Array = PerkRoad.status(f)
	road.sort_custom(func(a, b): return (0.0 if bool(a["open"]) else float(a["gap"])) < (0.0 if bool(b["open"]) else float(b["gap"])))
	for s in road.slice(0, 4):
		var chip := _chip("%s - %s" % [str(s["name"]), "open" if bool(s["open"]) else str(s["need"])], "green" if bool(s["open"]) or bool(s["near"]) else "")
		chip.tooltip_text = str(s["effect"])
		chip.mouse_filter = Control.MOUSE_FILTER_PASS
		row.add_child(chip)
	return row


## A tag on the slate: see-through, a thin chalk edge. The word keeps its UI colour; the ink pass turns paper inks to chalk.
static func _chip(text: String, colour_key: String) -> PanelContainer:
	var p := UI.chip(text, colour_key)
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 10, 3))
	return p


## One starting focus: a see-through tile, the chosen one edged in gold. Pad stays 0 so the 216x96 size holds.
static func _slate_choice(b: Button, on: bool) -> void:
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var hot: bool = state == "hover" and not on
		var edge := Color(WoodKit.HEAD) if on else (Color(WoodKit.BLUE) if hot else Color(WoodKit.SOFT, 0.35))
		b.add_theme_stylebox_override(state, UI.box(Color(1, 1, 1, 0.04), edge, 4, 2 if on or hot else 1, 0, 0))


static func _habit(id: String) -> Dictionary:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(HABITS_PATH)) if FileAccess.file_exists(HABITS_PATH) else null
	for row in (data as Dictionary).get("habits", []) if data is Dictionary else []:
		if str(row.get("id", "")) == id:
			return row
	return {}
