extends RefCounted
## S394 HOME's next fight as a matchup: the two real faces, red corner and blue corner, the days to fight night and the way to
## Fight prep. With no bout it says so and points at the offers.

const UI := preload("res://scripts/ui/UI.gd")
const HomeLook := preload("res://scripts/ui/HomeLook.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const HomeRows := preload("res://scripts/ui/HomeRows.gd")

const FACE := Vector2(128, 128)
const CAMP_TAB := 5   # FighterPage.TABS: "Camp", where the opponent's file and the camp sit
const EDGE := 5.0


## The fighter with the soonest bout, else the first.
static func hero(c: Career) -> Dictionary:
	var best: Dictionary = {}
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if fb.has("opp") and fb.has("day") and (best.is_empty() or best["bout"].is_empty() or int(fb["day"]) < int(best["bout"]["day"])):
			best = f
	if best.is_empty() and not c.fighters.is_empty():
		best = c.fighters[0]
	return best


## Null with no fighters: the first week's needs say what to do.
static func build(main: Node, c: Career) -> Control:
	var f := hero(c)
	if f.is_empty():
		return null
	var fb: Dictionary = f["bout"]
	var booked: bool = fb.has("opp") and fb.has("day")
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 12, 1, 0, 0))
	p.name = "NextFight"
	p.clip_contents = true
	var row := UI.hbox(0)
	p.add_child(row)
	row.add_child(_edge(UI.RED))
	var m := MarginContainer.new()
	m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 14)
	row.add_child(m)
	row.add_child(_edge(UI.GOLD if booked else Color(0, 0, 0, 0)))
	var h := UI.hbox(18)
	m.add_child(h)
	var stems: Array = Faces.pair(f, fb["opp"]) if booked else [Faces.stem(f)]
	_add(h, HomeLook.face(str(stems[0]), FACE))
	h.add_child(_who(str(f["name"]), "Your fighter, %s" % _record(f), HORIZONTAL_ALIGNMENT_LEFT))
	h.add_child(_middle(main, c, f, booked))
	if booked:
		var o: Dictionary = fb["opp"]
		h.add_child(_who(str(o["name"]), "%s, %s" % [str(o.get("club", "")), _record(o)], HORIZONTAL_ALIGNMENT_RIGHT))
		_add(h, HomeLook.face(str(stems[1]), FACE))
	else:   # the same widths as a matchup, so the middle stays in the middle
		var gap := Control.new()
		gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(gap)
		var face_gap := Control.new()
		face_gap.custom_minimum_size = FACE
		h.add_child(face_gap)
	return p


static func _add(h: Container, face: Control) -> void:
	if face != null:
		h.add_child(face)


## A corner's colour, a rounded bar inside the card's rounded edge.
static func _edge(col: Color) -> Control:
	var m := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 8 if side == "left" or side == "right" else 14)
	var e := Panel.new()
	e.add_theme_stylebox_override("panel", UI.box(col, Color(0, 0, 0, 0), 3, 0, 0, 0))
	e.custom_minimum_size = Vector2(EDGE, 0)
	m.add_child(e)
	return m


static func _record(x: Dictionary) -> String:
	if bool(x.get("pro", false)):
		if int(x.get("pro_w", 0)) + int(x.get("pro_l", 0)) == 0:
			return "pro debut"
		return "%d and %d pro" % [int(x.get("pro_w", 0)), int(x.get("pro_l", 0))]
	return "%d and %d" % [int(x.get("w", 0)), int(x.get("l", 0))]


static func _who(name: String, line: String, side: HorizontalAlignment) -> Control:
	var v := UI.vbox(2)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var n := UI.label(name, 30, UI.FG, "bold")
	n.horizontal_alignment = side
	v.add_child(n)
	var l := UI.label(line, 17, UI.MUTED)
	l.horizontal_alignment = side
	v.add_child(l)
	return v


static func _middle(main: Node, c: Career, f: Dictionary, booked: bool) -> Control:
	var v := UI.vbox(2)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.custom_minimum_size = Vector2(230, 0)
	var big := "No fight booked"
	var line := ""
	var date := ""
	var press: Callable = main.act.bind("go", "fights:0")
	var word := "Find a fight"
	if booked:
		var days := int(f["bout"]["day"]) - c.day
		big = str(days) if days > 0 else "TONIGHT"
		line = "day to fight night" if days == 1 else ("days to fight night" if days > 0 else "fight night")
		date = Clock.fmt(int(f["bout"]["day"]))
		word = "Fight prep"
		press = func():
			main.act("fighter", str(f["id"]))
			main.act("ftab", str(CAMP_TAB))
	elif not HomeRows.open_offers(f).is_empty():
		word = "See the offers"
	for x in [[big, 40 if booked else 26, UI.GOLD, "bold"], [line, 17, UI.FG, "semi"], [date, 15, UI.MUTED, "body"]]:
		if str(x[0]) != "":
			var l := UI.label(str(x[0]), int(x[1]), x[2], str(x[3]))
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			v.add_child(l)
	var tonight: bool = booked and int(f["bout"]["day"]) <= c.day
	var b := UI.button("Go to fight night" if tonight else word, "BtnSolid" if tonight else "Btn", main.act.bind("go_btn", "") if tonight else press)
	b.name = "FightPrep"
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(b)
	return v
