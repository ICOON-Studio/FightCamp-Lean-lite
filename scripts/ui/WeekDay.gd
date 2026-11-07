extends RefCounted
## One day of the Training tab's week strip (S359 split out of WeekBoard; S382 DRILLCARD1 rebuilt as ink session cards,
## TRAINING_SCREEN_S381.md section 3 and the approved mockup): the day's head (MON 26 Jan, 'undo' on a changed morning),
## the AM card (her body at the morning's station, its name; LIGHT / HARD, a twist and a tired day as tags on the
## picture; the numbers on its index card - Tips) and the PM card (PmCard): PADS carries its drill cards (one whole, or
## two split - the share badge cycles 50/50 -> 70/30 -> 30/70), the gain each gets that night, the coach and pad-tier
## chips; SPARRING names the cards she spars (the usable ones); FILM; REST. A PADS night takes a dragged drill card, or a
## click after a tray card was clicked; right-click clears it (right-click one of two cards: that card off).
## Click a morning: a row of 9 picture cards (picker) opens under the mornings; a pick closes it. A card under the cursor
## calls ghost(dow, card) - THIS CAMP ghosts that week's dry run on its gauges (S382 G5); ghost(dow, []) when it leaves.
##   head(i, day, mine, coach_card, act, ghost)  am(f, i, m, planned, r, red, mine, twist, on_open)  pm(spec) -> PmCard
##   picker(f, i, current, on_pick, ghost) -> "Picker"   kind(m)

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const Data := preload("res://scripts/state/Data.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const DrillCard := preload("res://scripts/ui/DrillCard.gd")

const DAYS := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
const AM_H := 128.0
const AM_PIC := 90.0
const PM_H := 180.0   # S397: the coach / kit chips left the cards (WeekBoard._helps)
const PIC_H := 96.0
## A split night's card name: the room a 1920-px strip's slot leaves it beside its picture and share badge.
const SLOT_NAME_W := 76.0
## How far down the picture the AM / PM boxes cut (0 = the top, 0.5 = the middle).
const PIC_TOP := 0.05
## The morning sessions' station pictures (assets/ui/training; intervals on the road, weights at the bag).
const STATION := {"roadwork": "roadwork", "intervals": "roadwork", "heavy_bag": "heavy_bag", "strength": "heavy_bag",
	"speed_bag": "speed_bag", "slip_rope": "slip_rope", "shadow": "shadow", "neck": "neck"}
const PM_WORDS := {"pads": "PADS", "sparring": "SPARRING", "film": "FILM", "rest": "REST"}
const SOFT := Color("#f6f7f9")
const CHIP := Color("#eceff3")


## MON ... 26 Jan, with 'undo' when the morning is her change (back to the coach's card).
static func head(i: int, day: int, mine: bool, coach_card: Array, act: Callable, ghost := Callable()) -> Control:
	var h := UI.hbox(6)
	h.name = "Head_%d" % i
	h.add_child(UI.label(DAYS[i], 17, UI.FG, "caps"))
	if mine and coach_card.size() == 2:
		var undo := Button.new()
		undo.name = "Undo_%d" % i
		undo.text = "undo"
		undo.flat = true
		undo.focus_mode = Control.FOCUS_NONE
		undo.add_theme_font_override("font", UI.font("handbold"))
		undo.add_theme_font_size_override("font_size", 15)
		undo.add_theme_color_override("font_color", UI.GOLD)
		undo.add_theme_color_override("font_hover_color", WB.RED)
		for k in ["normal", "hover", "pressed", "focus"]:
			undo.add_theme_stylebox_override(k, StyleBoxEmpty.new())
		undo.tooltip_text = "Back to the coach's card: %s" % WeekPhase.card(coach_card)
		undo.pressed.connect(func(): act.call(i, coach_card))
		if ghost.is_valid():
			undo.mouse_entered.connect(func(): ghost.call(i, coach_card))
			undo.mouse_exited.connect(func(): ghost.call(i, []))
		h.add_child(undo)
	h.add_child(UI.spacer())
	h.add_child(UI.label(Clock.fmt(day).substr(4), 15, UI.MUTED, "body"))
	return h


## The morning card: her body at the station, the session's name; a click opens the picker.
static func am(f: Dictionary, i: int, m: Array, planned: Array, r: Dictionary, red: bool, mine: bool, twist: String,
		on_open: Callable) -> Button:
	var b := _shell("Session_%d" % i, Color(0, 0, 0, 0) if str(m[0]) == "rest" else UI.PANEL, UI.ROWLINE if str(m[0]) == "rest" else UI.LINE)   # S397: rest is quiet
	b.custom_minimum_size = Vector2(0, AM_H)
	b.pressed.connect(func(): on_open.call(i))
	var v := _inner(b, 6)
	var rest := str(m[0]) == "rest"
	var pic := Control.new()
	pic.custom_minimum_size = Vector2(0, AM_PIC)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pic.clip_contents = true
	v.add_child(pic)
	if rest:
		var bg := ColorRect.new()
		bg.color = Color(0, 0, 0, 0)
		bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.add_child(bg)
		var word := UI.label("rest", 20, Color(UI.MUTED, 0.7), "hand")
		word.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		word.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		pic.add_child(word)
	else:
		pic.add_child(_tex(DrillCard.station(f, str(STATION.get(str(m[0]), "shadow")))))
	var tags := UI.hbox(4)
	tags.position = Vector2(4, 4)
	pic.add_child(tags)
	if not rest:   # S397 blind Week critic ("only Thursday shows a load"): every session wears its load
		tags.add_child(_tag(WB.level(str(m[1])), WB.RED if str(m[1]) == "hard" else (UI.GOLD if str(m[1]) == "light" else Color("#5b6472"))))
	if m != planned:
		tags.add_child(_tag("TWIST", UI.AMBER))
	var fat := float(r.get("fatigue", 0.0))
	if fat >= WB.AMBER_AT or red:
		var fw := WB.fatigue_word(fat, red)
		var t := _tag(str(fw[0]), fw[2])
		t.name = "Fatigue_%d" % i
		tags.add_child(t)
	var row := UI.hbox(4)
	row.add_child(UI.label("Rest" if rest else _cap(str(WeekPhase.NAMES.get(str(m[0]), str(m[0])))), 18, UI.FG, "semi"))
	row.add_child(UI.spacer())
	row.add_child(UI.label("AM", 13, UI.MUTED, "caps"))
	v.add_child(row)
	Tips.card(b, func(): return _magnet_card(m, planned, r, red, mine, twist))
	return b


## The evening card. spec: {i, kind, entries [{card, share}], rows {card: {dow: [before, after]}}, f, chips [text],
## picked (a tray card waits), spar_cards [title], camp, partner ("southpaw mate" or ""), on_drop(dow, card), on_click(dow), on_clear(dow),
## on_remove(dow, card), on_split(dow)}.
static func pm(spec: Dictionary) -> PmCard:
	var p := PmCard.new()
	var i := int(spec["i"])
	var k := str(spec["kind"])
	p.name = "Night_%d" % i
	p.dow = i
	p.kind = k
	p.spec = spec
	p.custom_minimum_size = Vector2(0, PM_H)
	if k == "rest":   # S397 blind Week critic ("rest nights take a third of the screen"): a one-line strip
		p.custom_minimum_size = Vector2(0, 0)
		p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		p.tooltip_text = "A rest night. More pad nights: Hard, above the week."
	var pads := k == "pads"
	var lit := pads and bool(spec.get("picked", false))
	p.add_theme_stylebox_override("panel", UI.box(Color("#dce8ff") if lit else (Color("#fbfaf7") if pads else (Color(0, 0, 0, 0) if k == "rest" else SOFT)),
		Color(0, 0, 0, 0) if pads else (UI.ROWLINE if k == "rest" else UI.LINE), 10, 0 if pads else 1, 8, 8))   # S397: rest nights quiet
	var v := UI.vbox(4)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(v)
	var h := UI.hbox(4)
	var word := UI.label(str(PM_WORDS.get(k, "REST")), 14, UI.FG if k != "rest" else UI.MUTED, "caps")
	word.name = "Evening_%d" % i
	h.add_child(word)
	h.add_child(UI.spacer())
	h.add_child(UI.label("PM", 13, UI.MUTED, "caps"))
	v.add_child(h)
	var f: Dictionary = spec["f"]
	var entries: Array = spec.get("entries", [])
	match k:
		"pads":
			if entries.is_empty():
				var empty := _tex(DrillCard.station(f, "pads"), PIC_H)
				empty.modulate = Color(1, 1, 1, 0.35)
				v.add_child(empty)
				v.add_child(UI.label("drop a card here", 18, UI.MUTED, "hand"))
			elif entries.size() == 1:
				var c := str(entries[0]["card"])
				v.add_child(_tex(DrillCard.picture(f, c), PIC_H))
				v.add_child(UI.label(PadEdit.title(f, c), 22, UI.FG, "bold"))   # S397: "1-1" in the brush font read ")-)"
				v.add_child(_gain(f, c, spec, i))
			else:
				for at in entries.size():
					var e: Dictionary = (entries[at] as Dictionary).duplicate()
					e["at"] = at
					v.add_child(_slot(f, e, spec, i))
			var gap := Control.new()
			gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
			gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
			v.add_child(gap)
			if not (spec.get("chips", []) as Array).is_empty():
				var chips := UI.hbox(6)
				chips.mouse_filter = Control.MOUSE_FILTER_IGNORE
				for t in spec["chips"]:
					chips.add_child(_chip(str(t)))
				v.add_child(chips)
		"sparring":
			var tex := _tex(DrillCard.station(f, "sparring"), PIC_H)
			v.add_child(tex)
			if str(spec.get("partner", "")) != "":   # S382 PLANTRAY1: the outside mate the camp booked (CampMatch)
				tex.add_child(_mate(str(spec["partner"])))
			v.add_child(UI.label("Plan test" if bool(spec.get("camp", false)) else "Sparring", 18, UI.FG, "semi"))
			var who: Array = spec.get("spar_cards", [])
			var line := UI.label("spars " + ", ".join(who) if not who.is_empty() else "nothing usable to spar yet", 14, UI.MUTED, "body")
			line.clip_text = true
			v.add_child(line)
		"film":
			v.add_child(_tex(DrillCard.station(f, "shadow"), PIC_H))
			v.add_child(UI.label("Film", 18, UI.FG, "semi"))
			v.add_child(UI.label("tape study", 14, UI.MUTED, "body"))
		_:
			pass   # REST on the strip's one line says it
	return p


## "+5.2 ★ usable" - the night's gain on the card (the star and the tier word when this night crosses it).
static func _gain(f: Dictionary, c: String, spec: Dictionary, i: int) -> Label:
	var rows: Dictionary = (spec.get("rows", {}) as Dictionary).get(c, {})
	if not rows.has(i):
		return UI.label("", 16, UI.GREEN, "bold")
	var b := float(rows[i][0])
	var a := float(rows[i][1])
	var txt := "%+.1f learned" % (a - b)   # S397 blind Week critic: "+2.8" of what
	var col := UI.GREEN
	for t in PadEdit.TIERS:
		if b < float(t[0]) and a >= float(t[0]):
			txt += " ★ %s" % t[1]
			col = DrillCard.GOLD_INK
	var l := UI.label(txt, 16, col, "bold")
	l.name = "Gain_%d" % i
	return l


## One of two cards on a split night: its picture, name, the night's gain and its share; right-click takes it off.
static func _slot(f: Dictionary, e: Dictionary, s: Dictionary, i: int) -> PanelContainer:
	var c := str(e["card"])
	var p := PanelContainer.new()
	p.name = "Slot_%d_%s" % [i, c.replace(":", "_").replace(" ", "_")]
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 6, 1, 6, 4))
	p.gui_input.connect(func(ev: InputEvent):
		var mb := ev as InputEventMouseButton
		if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_RIGHT:
			(s["on_remove"] as Callable).call(i, c)
			p.accept_event())
	var h := UI.hbox(8)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(h)
	var t := _tex(DrillCard.picture(f, c), 58.0)
	t.custom_minimum_size = Vector2(58, 58)
	h.add_child(t)
	var v := UI.vbox(0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var title := PadEdit.title(f, c)
	# The name shares its line with the share badge; a long one steps its size down instead of losing letters.
	var fs := 20
	while fs > 14 and UI.font("bold").get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > SLOT_NAME_W:
		fs -= 1
	var top := UI.hbox(4)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var name := UI.label(title, fs, UI.FG, "bold")
	name.clip_text = true
	name.custom_minimum_size = Vector2(40, 0)
	name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(name)
	v.add_child(top)
	v.add_child(_gain(f, c, s, i))
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	# The share badge cycles the split (50/50 -> 70/30 -> 30/70).
	var badge := Button.new()
	badge.name = "Split_%d" % i if int(e.get("at", 0)) == 0 else "Split_%d_b" % i
	badge.text = "%d%%" % roundi(100.0 * float(e["share"]))
	badge.focus_mode = Control.FOCUS_NONE
	badge.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	badge.tooltip_text = "Click: 50/50 -> 70/30 -> 30/70"
	badge.add_theme_font_override("font", UI.font("bold"))
	badge.add_theme_font_size_override("font_size", 13)
	for k in ["font_color", "font_hover_color", "font_pressed_color"]:
		badge.add_theme_color_override(k, Color.WHITE)
	for st in ["normal", "hover", "pressed", "focus"]:
		badge.add_theme_stylebox_override(st, UI.box(UI.FG if st != "hover" else UI.GOLD, Color(0, 0, 0, 0), 8, 0, 7, 1))
	badge.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	badge.pressed.connect(func(): (s["on_split"] as Callable).call(i))
	top.add_child(badge)
	return p


## The picker: 9 picture cards (the 8 sessions and rest) under the mornings; a click picks it at the day's intensity.
static func picker(f: Dictionary, i: int, current: Array, on_pick: Callable, ghost := Callable()) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Picker"
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD, 10, 2, 10, 10))
	var row := UI.hbox(10)
	p.add_child(row)
	var level := "normal" if str(current[0]) == "rest" else str(current[1])
	for s in WeekPhase.SESSIONS + ["rest"]:
		var card: Array = [s, "normal" if s == "rest" else level]
		var on: bool = str(current[0]) == str(s)
		var b := _shell("Pick_%s" % s, Color("#eef4ff") if on else UI.PANEL, UI.GOLD if on else UI.LINE)
		b.custom_minimum_size = Vector2(0, 150)
		b.pressed.connect(func(): on_pick.call(i, card))
		if ghost.is_valid():
			b.mouse_entered.connect(func(): ghost.call(i, card if not on else []))
			b.mouse_exited.connect(func(): ghost.call(i, []))
		var v := _inner(b, 4)
		if s == "rest":
			var w := UI.label("rest", 22, UI.MUTED, "hand")
			w.custom_minimum_size = Vector2(0, 96)
			w.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			w.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			v.add_child(w)
		else:
			v.add_child(_tex(DrillCard.station(f, str(STATION[s])), 96.0))
		v.add_child(UI.label("Rest" if s == "rest" else _cap(str(WeekPhase.NAMES[s])), 16, UI.FG, "semi"))
		var st := str(WeekPlan.session(s).get("stat", ""))
		v.add_child(UI.label(str(Data.LABEL.get(st, "")) + (" +" if st != "" else ""), 13, UI.GREEN, "bold"))
		row.add_child(b)
	return p


static func _shell(name: String, bg: Color, edge: Color) -> Button:
	var b := Button.new()
	b.name = name
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for st in ["normal", "hover", "pressed", "focus"]:
		b.add_theme_stylebox_override(st, UI.box(bg, UI.MUTED if st == "hover" else edge, 8, 2, 0, 0))
	return b


static func _inner(b: Button, pad: int) -> VBoxContainer:
	var m := MarginContainer.new()
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, pad)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(m)
	var v := UI.vbox(4)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(v)
	return v


## A station / drill picture filling its box (covered), cut nearer the top than the middle so her head stays in the
## wide AM and PM boxes (S382 final proof: a centred cut kept hips-to-knees).
static func _tex(t: Texture2D, h := 0.0) -> TopPic:
	var r := TopPic.new()
	r.texture = t
	r.clip_contents = true
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if h > 0.0:
		r.custom_minimum_size = Vector2(0, h)
	else:
		r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return r


static func _tag(text: String, col: Color) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(col, Color(0, 0, 0, 0), 4, 0, 5, 1))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(UI.label(text, 12, Color.WHITE, "bold"))
	return p


## The partner chip on a sparring night's picture, bottom right: "southpaw mate".
static func _mate(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Partner"
	p.add_theme_stylebox_override("panel", UI.box(Color(0.08, 0.09, 0.11, 0.86), Color(0, 0, 0, 0), 12, 0, 9, 3))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	p.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	p.grow_vertical = Control.GROW_DIRECTION_BEGIN
	p.offset_right = -6
	p.offset_bottom = -6
	p.add_child(UI.label(text, 14, Color.WHITE, "bold"))
	return p


static func _chip(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(CHIP, Color(0, 0, 0, 0), 4, 0, 6, 2))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(UI.label(text, 13, UI.FG, "semi"))
	return p


## The morning card's index card: the session, what it builds, where she ends the day, and what that means.
static func _magnet_card(m: Array, planned: Array, r: Dictionary, red: bool, mine: bool, twist: String) -> Dictionary:
	var rows: Array = []
	for k in [["stat", "gain"], ["stat2", "gain2"]]:
		var st := str(r.get(k[0], ""))
		if st != "":
			var g := float(r[k[1]])
			rows.append([str(Data.LABEL.get(st, st)), "%+.2f" % g, "▲" if g > 0.0 else "", "good" if g > 0.0 else ""])
	rows.append(["Weight", "%+.2f kg" % float(r.get("kg", 0.0)), "", ""])
	var fat := float(r.get("fatigue", 0.0))
	var fw := WB.fatigue_word(fat, red)
	rows.append(["Tired by night", "%d / 100" % int(round(fat)), str(fw[0]),
		"bad" if fat >= WB.RED_AT or red else ("watch" if fat >= WB.AMBER_AT else "")])
	var means := "a %s day; %s" % [kind(m), str(fw[1]).get_slice(": ", 1).to_lower() if str(fw[1]).contains(": ") else ""]
	if m != planned:
		means = "the twist (%s) replaced %s. %s" % [twist, WeekPhase.card(planned), _cap(means)]
	elif mine:
		means = "your change - 'undo' on the day puts the coach's card back. " + _cap(means)
	return {"title": "%s - morning" % WeekPhase.card(m), "rows": rows, "means": _cap(means.strip_edges()),
		"keys": ["fatigue", "phase"] + (["twist"] if m != planned else []), "hint": [["click", "change the day"]]}


## The day's kind in the coach's shorthand: rest, hard, engine (conditioning), skill.
static func kind(m: Array) -> String:
	if str(m[0]) == "rest":
		return "rest"
	if str(m[1]) == "hard":
		return "hard"
	return "engine" if str(WeekPlan.session(str(m[0]))["stat"]) == "conditioning" else "skill"


static func _cap(s: String) -> String:
	return s.left(1).to_upper() + s.substr(1)


## The PM card: a PADS night takes a drill card (drag, or a click after a tray card was clicked); right-click clears it.
class PmCard extends PanelContainer:
	var dow := 0
	var kind := ""
	var spec := {}

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		size_flags_horizontal = Control.SIZE_EXPAND_FILL

	func _ready() -> void:
		if kind == "pads":
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			draw.connect(_dashes)

	## The drop target's dashed blue edge.
	func _dashes() -> void:
		var r := Rect2(Vector2(1, 1), size - Vector2(2, 2))
		var col := UI.GOLD
		var pts := [[r.position, Vector2(r.end.x, r.position.y)], [Vector2(r.end.x, r.position.y), r.end],
			[r.end, Vector2(r.position.x, r.end.y)], [Vector2(r.position.x, r.end.y), r.position]]
		for seg in pts:
			draw_dashed_line(seg[0], seg[1], col, 2.0, 6.0)

	func _can_drop_data(_at: Vector2, data: Variant) -> bool:
		return kind == "pads" and data is Dictionary and (data as Dictionary).has("drill")

	func _drop_data(_at: Vector2, data: Variant) -> void:
		(spec["on_drop"] as Callable).call(dow, str(data["drill"]))

	func _gui_input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb == null or not mb.pressed or kind != "pads":
			return
		if mb.button_index == MOUSE_BUTTON_LEFT:
			(spec["on_click"] as Callable).call(dow)
			accept_event()
		elif mb.button_index == MOUSE_BUTTON_RIGHT:
			(spec["on_clear"] as Callable).call(dow)
			accept_event()


## A covered picture cut PIC_TOP of the way down instead of through the middle.
class TopPic extends Control:
	var texture: Texture2D

	func _ready() -> void:
		resized.connect(queue_redraw)

	func _draw() -> void:
		if texture == null or size.x <= 0.0 or size.y <= 0.0:
			return
		var ts := texture.get_size()
		var k := maxf(size.x / ts.x, size.y / ts.y)
		var d := ts * k
		draw_texture_rect(texture, Rect2(Vector2((size.x - d.x) * 0.5, (size.y - d.y) * PIC_TOP), d), false)
