extends RefCounted
## S414 operator on Q-S294-143 (dark panels or cream pages): "Show me one real page first". The fighter's Overview in the dark
## look: a full-height boxer on the left, dark panels with a red top edge, big numbers, thick bars, exactly one red button.
## Every number and every action is the one the cream Overview had (AttrBoard.rows, Sim.goal_read, the same main.act calls).
##   panel(title) -> [PanelContainer, VBoxContainer]   make(page, main, c, f, g)   ink(node)   dim_wall(main)   main_style(button)

const UI := preload("res://scripts/ui/UI.gd")
const RankRow := preload("res://scripts/ui/RankRow.gd")
const WarmKit := preload("res://scripts/ui/WarmKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const NationalsView := preload("res://scripts/ui/NationalsView.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const CoachNotes := preload("res://scripts/rules/CoachNotes.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Aftermath := preload("res://scripts/rules/Aftermath.gd")

const PANEL_BG := Color(0.095, 0.075, 0.066, 0.94)
const INSET := Color(0.05, 0.04, 0.035, 0.9)
const EDGE := Color("#c8402f")
const SIDE := Color("#3a2f28")
const INK := Color("#f1e8da")
const SOFT := Color("#c9b9a2")
const HEAD := Color("#ffd54a")
const TRACK := Color(1, 1, 1, 0.09)
const WALL_DARK := Color(0.30, 0.28, 0.27)
const BAND := {"weak": Color("#e2483d"), "fair": Color("#f08a24"), "solid": Color("#3f7fe0"), "strong": Color("#2fb56e"), "elite": Color("#a36cff")}
const TONE := {"green": Color("#2fb56e"), "red": Color("#e2483d"), "amber": Color("#f08a24"), "gold": Color("#3f7fe0"), "": SOFT}
const LEFT_W := 440
const SIDE_W := 440


## A hand-drawn bar: skewed, thick, with the ceiling tick.
class Bar extends Control:
	var frac := 0.0
	var tick := -1.0
	var colour := Color.WHITE

	func _init() -> void:
		custom_minimum_size = Vector2(130, 24)
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var skew := 8.0
		var w: float = size.x
		var h: float = size.y
		draw_colored_polygon(PackedVector2Array([Vector2(skew, 0), Vector2(w, 0), Vector2(w - skew, h), Vector2(0, h)]), TRACK)
		var fw: float = clampf(frac, 0.0, 1.0) * (w - skew)
		if fw > 0.0:
			draw_colored_polygon(PackedVector2Array([Vector2(skew, 0), Vector2(skew + fw, 0), Vector2(fw, h), Vector2(0, h)]), colour)
			draw_colored_polygon(PackedVector2Array([Vector2(skew, 0), Vector2(skew + fw, 0), Vector2(skew * 0.5 + fw, h * 0.5), Vector2(skew * 0.5, h * 0.5)]), Color(1, 1, 1, 0.18))
		if tick >= 0.0:
			var x: float = clampf(tick, 0.0, 1.0) * (w - skew)
			draw_line(Vector2(x + skew, -2), Vector2(x, h + 2), Color.WHITE, 3.0, true)


## A ring with the number inside.
class Ring extends Control:
	var frac := 0.0
	var colour := Color.WHITE

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var c: Vector2 = size * 0.5
		var r: float = minf(size.x, size.y) * 0.5 - 8.0
		draw_arc(c, r, 0.0, TAU, 96, TRACK, 13.0, true)
		if frac > 0.0:
			draw_arc(c, r, -PI * 0.5, -PI * 0.5 + TAU * clampf(frac, 0.0, 1.0), 96, colour, 13.0, true)


static func dim_wall(main: Node) -> void:
	var r: TextureRect = main.get_node_or_null("PaintedWall")
	if r != null:
		r.modulate = WALL_DARK


## Words the page builders made for cream cards take the light inks; anything already coloured keeps its colour.
static func ink(n: Node) -> void:
	for c in n.get_children():
		if c is Label:
			var was: Color = (c as Label).get_theme_color("font_color")
			if was == UI.FG or was == UI.GOLD:
				(c as Label).add_theme_color_override("font_color", INK)
			elif was == UI.MUTED:
				(c as Label).add_theme_color_override("font_color", SOFT)
		ink(c)


static func panel(title: String = "") -> Array:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"   # the page and its tests still find a card
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var wood := UI.WoodKit.slate(22, 26)   # the frame is 22 px; the old 34 px pad ran the page past 1920
	wood.content_margin_bottom = 24
	p.add_theme_stylebox_override("panel", wood)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	p.add_child(v)
	if title != "":
		v.add_child(UI.label(title, 22, HEAD, "bold"))
	return [p, v]


## The page's one primary button: the theme's Go piece. The others keep Btn.
static func main_style(b: Button) -> void:
	b.theme_type_variation = "Go"
	b.add_theme_font_override("font", UI.font("bold"))
	b.add_theme_font_size_override("font_size", 24)
	b.custom_minimum_size.y = 62.0


static func _quiet(b: Button) -> Button:
	b.theme_type_variation = "Btn"
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b


static func make(page: Container, main: Node, c: Career, f: Dictionary, g: Dictionary) -> void:
	var root := UI.hbox(16)
	root.name = "DarkOverview"
	root.add_child(_boxer(f, c))
	var right := UI.vbox(14)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var top := UI.hbox(14)
	top.size_flags_vertical = Control.SIZE_EXPAND_FILL
	top.add_child(_attributes(f))
	top.add_child(_glance(f))
	right.add_child(top)
	var low := UI.hbox(14)
	low.add_child(_goal(main, c, f, g))
	low.add_child(_body(c, f))
	right.add_child(low)
	root.add_child(right)
	page.add_child(root)


static func _boxer(f: Dictionary, c: Career = null) -> Control:
	var col := UI.vbox(0)
	col.custom_minimum_size.x = LEFT_W
	var nm := str(f["name"]).to_upper()
	col.add_child(UI.display(nm, clampi(int(float(LEFT_W) / (float(nm.length()) * 0.62)), 36, 60), Color.WHITE))
	col.add_child(UI.label("%s, %d, %s, amateur %d-%d" % [f["wc"], f["age"], f["stance"], f["w"], f["l"]], UI.BODY, SOFT, "semi"))
	# S437 RANKSHOWUI: where she stands, always: a number, or how many wins from a number (RankLine's own words).
	var standing: Control = RankRow.build(c, f) if c != null else null
	if standing != null:
		standing.add_theme_color_override("font_color", SOFT)
		col.add_child(standing)
	col.add_child(condition(f))
	var holder := Control.new()
	# S430 (operator: "this screen on the bottom is clipped"): 690 pushed the goal and body row off a 1080 screen.
	holder.custom_minimum_size = Vector2(LEFT_W, 560)
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pic: Control = RosterCards.body(Faces.stem(f))
	if pic != null:
		holder.add_child(pic)
		pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		pic.offset_left = -125.0   # the picture is square with empty sides: wider than the column makes the boxer full height
		pic.offset_right = 125.0
	var g: Dictionary = AttrBoard.glance(f)
	var ring := _ring(float(g["fight_avg"]) / 100.0, Color("#ffd54a"), str(int(g["overall"])), "OF 100", 130.0)   # S443: StatBlock.overall, the roster's ring too
	ring.position = Vector2(LEFT_W - 136, 8)
	holder.add_child(ring)
	col.add_child(holder)
	return col


## S430 (operator: "after the fight i need to clearly see somewhere (probably in the fighters prifile) his stamina level
## to figure out how long i need to rest him and plan his next training"): her tiredness as a bar and a number under her
## name, with the rest days it takes to be fresh. The same number the week plan and a fight (Aftermath.toll) move.
static func condition(f: Dictionary) -> Control:
	var v: float = FighterProfile.fatigue(f)
	var days: int = Aftermath.rest_days(v)
	var tone: Color = TONE["green"] if days == 0 else (TONE["red"] if v >= 80.0 else TONE["amber"])
	var row := UI.hbox(10)
	row.name = "Condition"
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	row.tooltip_text = "Tiredness %d of 100. Under 50 is fresh. A fight and hard training raise it; a full rest day takes off about an eighth. Over 80 the next morning's training counts only 60%%." % int(round(v))
	row.add_child(UI.label("TIREDNESS", UI.BODY, SOFT, "bold"))
	var bar := Bar.new()
	bar.frac = v / 100.0
	bar.tick = Aftermath.FRESH_UNDER / 100.0
	bar.colour = tone
	bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	bar.custom_minimum_size = Vector2(120, 22)
	row.add_child(bar)
	row.add_child(UI.label("%d" % int(round(v)), 26, tone, "bold"))
	var words := UI.label(Aftermath.tired_word(v) if days == 0 else "%s: %d rest day%s" % [Aftermath.tired_word(v), days, "" if days == 1 else "s"], UI.BODY, INK, "semi")
	words.name = "ConditionWords"
	row.add_child(words)
	return row


static func _ring(frac: float, colour: Color, big: String, small: String, px: float) -> Control:
	var r := Ring.new()
	r.frac = frac
	r.colour = colour
	r.custom_minimum_size = Vector2(px, px)
	r.size = Vector2(px, px)
	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", -4)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var b := UI.label(big, int(px * 0.3), Color.WHITE, "bold")
	b.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(b)
	if small != "":
		var s := UI.label(small, UI.TINY, SOFT, "semi")
		s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(s)
	r.add_child(v)
	return r


static func _attributes(f: Dictionary) -> PanelContainer:
	var c: Array = panel("ATTRIBUTES")
	var pot := float(f.get("pot", 0.0))
	var groups: Array = AttrBoard.rows(f)
	var cols := UI.hbox(16)   # S416: one column a group; 14 attributes in two columns ran past the screen
	for g in groups:
		var col := UI.vbox(9)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_group(col, g, pot)
		cols.add_child(col)
	c[1].add_child(cols)
	if pot > 0.0:
		# S417 collect: the colour key as swatches, not a sentence (operator: "use graphics ... less text").
		var key := UI.hbox(6)
		key.name = "BandKey"
		key.add_child(UI.label("White tick = ceiling %d" % int(pot), UI.TINY, SOFT))
		for band in AttrBoard.BANDS:
			var sw := UI.dot(BAND[str(band[1])])
			sw.custom_minimum_size = Vector2(10, 10)
			key.add_child(sw)
			key.add_child(UI.label(str(band[1]).capitalize(), UI.TINY, SOFT))
		c[1].add_child(key)
	return c[0]


static func _group(parent: VBoxContainer, g: Dictionary, pot: float) -> void:
	parent.add_child(UI.label(str(g["title"]), UI.SMALL, SOFT, "caps"))
	for r in g["rows"]:
		parent.add_child(_row(r, pot))


static func _row(r: Dictionary, pot: float) -> Control:
	var key := str(r["key"])
	var v := float(r["value"])
	var col: Color = BAND[str(r["band"])]
	var h := UI.hbox(5)
	h.tooltip_text = "%s %.1f\n%s" % [r["name"], v, r["why"]]
	h.mouse_filter = Control.MOUSE_FILTER_PASS
	h.add_child(Icons.icon(str(AttrBoard.ICON.get(key, "info")), 20, SOFT))
	var lab := UI.label(str(r["name"]), UI.BODY, INK, "semi")
	lab.custom_minimum_size.x = 120
	h.add_child(lab)
	if key == "temper":
		var tag := PanelContainer.new()
		tag.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), col, 4, 1, 12, 3))
		tag.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tag.add_child(UI.label("Trades" if v >= 60.0 else ("Patient" if v <= 40.0 else "Even"), UI.SMALL, Color.WHITE, "bold"))
		h.add_child(tag)
		return h
	var bar := Bar.new()
	bar.custom_minimum_size.x = 50
	bar.frac = v / 100.0
	bar.colour = col
	if pot > 0.0 and not AttrBoard.PERSONALITY.has(key):
		bar.tick = pot / 100.0
	h.add_child(bar)
	var n := UI.label(str(int(floorf(v))), 24, col.lightened(0.15), "bold")
	n.custom_minimum_size.x = 32
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(n)
	var d := float(r["delta"])
	var change := UI.label("" if absf(d) < 0.05 else ("+%.1f wk" % d if d > 0.0 else "%.1f wk" % d), UI.TINY, TONE["green"] if d > 0.0 else TONE["red"], "mono")
	change.custom_minimum_size.x = 58
	change.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(change)
	return AttrBoard.with_line(h, r, SOFT)   # S439 T17: the Stamina row's line printed under it


static func _glance(f: Dictionary) -> PanelContainer:
	var c: Array = panel("AT A GLANCE")
	(c[0] as Control).custom_minimum_size.x = SIDE_W
	(c[0] as Control).size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var g: Dictionary = AttrBoard.glance(f)
	var names := func(rs: Array) -> String: return ", ".join(rs.map(func(r): return str(r["name"])))
	c[1].add_child(_note("Best", names.call(g["best"]), TONE["green"]))
	c[1].add_child(_note("Work on", names.call(g["work"]), TONE["amber"]))
	if bool(g["hot"]):
		c[1].add_child(_note("Temper", "Trades when hit", TONE["red"]))
	if float(g["pot"]) > 0.0:
		var room := int(g["pot"]) - int(g["overall"])
		c[1].add_child(_note("Room to grow", "A lot" if room >= 20 else ("Some" if room >= 8 else "Close to the ceiling"), TONE["green"]))
	if str(g.get("wants", "")) != "":
		c[1].add_child(_note("In the ring", str(g["wants"]), TONE["green"]))
	if str(g["style"]) != "":
		c[1].add_child(_note("Style", str(g["style"]), TONE["amber"]))
	return c[0]


static func _note(key: String, value: String, edge: Color) -> Control:
	var p := PanelContainer.new()
	var s := UI.box(INSET, Color(0, 0, 0, 0), 6, 0, 16, 11)
	s.border_color = edge
	s.border_width_left = 5
	p.add_theme_stylebox_override("panel", s)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var h := UI.hbox(14)
	var k := UI.label(key, UI.BODY, SOFT, "bold")
	k.custom_minimum_size.x = 84
	h.add_child(k)
	h.add_child(UI.label(value, 21, INK, "bold", true))
	p.add_child(h)
	return p


static func _goal(main: Node, c: Career, f: Dictionary, g: Dictionary) -> PanelContainer:
	var card: Array = panel("GOAL")
	var nb: Dictionary = f["bout"]
	var entering: bool = NationalsView.enter_button(main, c, f) != null
	var talk: bool = g.is_empty() and bool(f["goal_talk"])
	var needs_bout: bool = nb.is_empty()
	var row := UI.hbox(24)
	var next_bout := UI.label("Next bout: vs %s, %s" % [nb["opp"]["name"], Clock.fmt(int(nb["day"]))] if not nb.is_empty() else "Next bout: none booked", UI.BODY, INK, "semi")
	if g.is_empty():
		row.add_child(UI.label("Waiting in your office for the next goal." if talk else "No goal set.", UI.BODY, INK, "body", true))
	else:
		var tone: Color = TONE.get(str(g["cls"]), SOFT)
		row.add_child(_ring(float(g["share"]), tone, "%d%%" % int(float(g["share"]) * 100.0), "", 112.0))   # small: the guide's bubble sits below it in the first hour
		var text := UI.vbox(4)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var title := UI.label(str(g["title"]), 28, Color.WHITE, "bold", true)
		title.tooltip_text = str(g["line"])
		title.mouse_filter = Control.MOUSE_FILTER_PASS
		text.add_child(title)
		text.add_child(UI.label("%s, %d days left" % [g["row"], g["left"]], UI.BODY, SOFT))
		text.add_child(UI.label(str(g["status"]), UI.BODY, tone, "bold"))
		text.add_child(next_bout)
		row.add_child(text)
	card[1].add_child(row)
	if g.is_empty():
		card[1].add_child(next_bout)
	var buttons := UI.hbox(10)
	buttons.add_child(UI.spacer())   # right-hand end: the guide's bubble covers the left of this panel in the first hour
	var arrows: int = (f.get("arrows", []) as Array).size()
	var red: Button = null
	if talk:
		red = UI.button("Talk to %s" % str(f["first"]), "Btn", main.act.bind("goaltalk", f["id"]))
		buttons.add_child(red)
	var plan := UI.button("Plan the week", "Btn", main.act.bind("ftab", "3"))
	var fight_plan := UI.button("Fight plan (%d arrows)" % arrows if arrows > 0 else "Fight plan", "Btn", main.act.bind("plan", f["id"]))
	var find := UI.button("Find a bout", "Btn", main.act.bind("go", "fights:0"))
	if red == null and not entering:
		red = find if needs_bout else plan
	for b in ([find, plan, fight_plan] if red == find else [plan, find, fight_plan]):
		if b == red:
			main_style(b)
		else:
			_quiet(b)
		buttons.add_child(b)
	if red != null and red != find and red != plan:
		main_style(red)
	card[1].add_child(buttons)
	return card[0]


static func _body(c: Career, f: Dictionary) -> PanelContainer:
	var card: Array = panel("BODY")
	(card[0] as Control).custom_minimum_size.x = SIDE_W
	(card[0] as Control).size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var kg := UI.hbox(8)
	kg.add_child(UI.label("%.1f kg" % float(f["weight"]), 40, INK, "bold"))
	var limit := UI.label("limit %.1f kg" % float(f["limit"]), 18, SOFT, "bold")
	limit.size_flags_vertical = Control.SIZE_SHRINK_END
	kg.add_child(limit)
	card[1].add_child(kg)
	var over: float = float(f["weight"]) - float(f["limit"])
	if over > 0.05 and not (f.get("bout", {}) as Dictionary).is_empty():   # S416: no fight, nothing to cut for
		card[1].add_child(_note("Over", "%.1f kg to cut" % over, TONE["red"]))
	var v: float = FighterProfile.fatigue(f)
	var word: Array = WB_KIT.fatigue_word(v, false)
	var pips := UI.hbox(7)
	pips.tooltip_text = str(word[1])
	pips.mouse_filter = Control.MOUSE_FILTER_PASS
	var fresh: int = clampi(5 - int(round(v / 20.0)), 0, 5)
	for i in 5:
		var dot := ColorRect.new()
		dot.custom_minimum_size = Vector2(22, 22)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.color = TONE["green"] if i < fresh else TRACK
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pips.add_child(dot)
	pips.add_child(UI.label(str(word[0]).capitalize(), UI.BODY, INK, "bold"))
	card[1].add_child(pips)
	if Injuries.out(c, f):
		card[1].add_child(_note("Out", Injuries.line(c, f), TONE["red"]))
	var coach := UI.label(Sim.coach_line(c, f), UI.BODY, SOFT, "italic", true)
	var known: Array = CoachNotes.progress(f)
	var notes: Array = CoachNotes.card(f, Bouts.notes_bank())
	coach.mouse_filter = Control.MOUSE_FILTER_PASS
	coach.tooltip_text = "Coach's notes, %d of %d\n%s" % [int(known[0]), int(known[1]),
		"\n".join(notes.map(func(n): return str(n["line"]))) if not notes.is_empty() else "Fights and sparring fill this in."]
	card[1].add_child(coach)
	return card[0]
