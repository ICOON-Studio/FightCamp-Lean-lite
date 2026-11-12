extends RefCounted
## S398 Week v8 (docs/WEEK_REDESIGN_S397.md, mock-up docs/week_mock/week_v8.png; built on the main session's call after
## twelve blind critics held the paper version at 7): the pieces the Week board is built from.
## - ONE effort scale: tiredness 0-100 (WeekPlan's fatigue: a night keeps 87 %, 70-80 heavy, 80+ overreached).
## - Every number carries its name ("Conditioning +0.20", "+6 tired", "mastery +7 -> 33").
## - Colours: an attribute's own tile colour (used for nothing else), blue = what the player sets, green = a gain, gold = the
##   goal, amber / red = tiredness zones only. Labels and icons come from the attribute key (Data.LABEL / AttrBoard.ICON),
##   never a fixed stat list, so the named attributes the fighter model brings draw with no change here.
## - One edit grammar: click a card, a popover opens (pop / morning_pop / evening_pop) with a segment row on top (how hard,
##   or what kind of evening) and the list under it, each row with its gain and its tiredness.
##   tile(key)  chip(text, kind)  am(...) -> Button  night_body(...)  tired_line(i, start, end)  meter(...)  totals(...)
##   morning_pop(...)  evening_pop(...)  pop(anchor, body, left, on_close) -> Pop

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const Data := preload("res://scripts/state/Data.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")

const DAY_NAMES := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
## Attribute tile colours: none of them is a gain green, a settable blue, the goal gold or a tiredness amber / red.
const TILE := {"conditioning": "#be185d", "power": "#9a3412", "speed": "#7c3aed", "fight_iq": "#0e7490", "technique": "#4338ca",
	"defense": "#475569", "chin": "#6b5e4b", "footwork": "#0f766e", "pads": "#334155", "film": "#52525b"}
const SPARE := ["#86198f", "#155e75", "#3f6212", "#7c2d12", "#1e3a8a", "#581c87"]
const NIGHT_ICON := {"pads": "hand-fist", "film": "tv"}
const BLUE := Color("#2f6fdb")
const OVER := 80.0
const HEAVY := 70.0
const AM_H := 96.0
const PM_H := 96.0


## The attribute's square tile: its icon, white, on its own colour (a new attribute gets a spare colour by its name).
static func tile(key: String, px := 52) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Tile"
	var col := Color(str(TILE[key])) if TILE.has(key) else Color(str(SPARE[absi(key.hash()) % SPARE.size()]))
	if key == "":
		col = Color("#cfd6dd")
	p.add_theme_stylebox_override("panel", UI.box(col, Color(0, 0, 0, 0), 8, 0, 0, 0))
	p.custom_minimum_size = Vector2(px, px)
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if key != "":
		var ic := Icons.icon(str(NIGHT_ICON.get(key, AttrBoard.ICON.get(key, "target"))), int(px * 0.55), Color.WHITE)
		ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(ic)
	return p


## A small word chip: kind "light" / "normal" / "hard" (a morning's effort), "twist", "red", or "plain".
static func chip(text: String, kind := "plain") -> PanelContainer:
	var inks := {"light": WoodKit.SOFT, "normal": WoodKit.BLUE, "hard": WoodKit.HEAD, "twist": WoodKit.HEAD,
		"red": UI.RED, "plain": WoodKit.SOFT}
	var ink: Color = inks.get(kind, WoodKit.SOFT)
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Color(ink, 0.16), Color(ink, 0.55), 9, 1, 7, 1))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.add_child(UI.label(text, 12, ink, "bold"))
	return p


static func label_of(key: String) -> String:
	return str(Data.LABEL.get(key, key.capitalize()))


## "Conditioning +0.20" (two decimals: Light, Normal and Hard read apart).
static func gain_words(key: String, g: float) -> String:
	return "%s %+.2f" % [label_of(key), g]


static func tired_words(n: float) -> String:
	return "+%d fatigue" % roundi(n) if n >= 0.5 else "no work"


## The morning card (a Button, "Session_<i>"): the attribute tile, the session (gold dot when it feeds the goal), its gain,
## its effort chip and its tiredness. A click opens the morning popover.
static func am(i: int, m: Array, planned: Array, r: Dictionary, cost: float, start: float, goal_key: String, card: Callable,
		on_open: Callable) -> Button:
	var b := shell("Session_%d" % i, str(m[0]) == "rest")
	b.custom_minimum_size = Vector2(0, AM_H)
	b.pressed.connect(func(): on_open.call(i))
	var h := UI.hbox(10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fill(b, h)
	var rest := str(m[0]) == "rest"
	var key := "" if rest else str(WeekPlan.session(str(m[0])).get("stat", ""))
	if not rest:
		h.add_child(tile(key))
	var v := UI.vbox(3)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(v)
	var top := UI.hbox(6)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var nm := UI.label("Rest" if rest else str(WeekPlan.session(str(m[0]))["name"]), 18, UI.MUTED if rest else UI.FG, "bold")
	nm.name = "Name_%d" % i
	nm.clip_text = true
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(nm)
	if not rest and key == goal_key:
		var dot := ColorRect.new()
		dot.name = "GoalDot"
		dot.color = Color("#e0a400")
		dot.custom_minimum_size = Vector2(9, 9)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top.add_child(dot)
	v.add_child(top)
	if not rest:
		var gl := UI.label(gain_words(key, float(r.get("gain", 0.0))), 15, UI.FG, "body")
		gl.name = "Gain_%d" % i
		v.add_child(gl)
		var row := UI.hbox(8)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(chip(str(m[1]).to_upper(), str(m[1])))
		var t := UI.label(tired_words(cost), 14, UI.MUTED, "semi")
		t.name = "Cost_%d" % i
		row.add_child(t)
		if m != planned:
			row.add_child(chip("TWIST", "twist"))
		if start >= OVER:   # the overreach cost is paid where it lands: this morning trains at 60 %
			row.add_child(chip("TRAINS AT 60%", "red"))
		v.add_child(row)
	Tips.card(b, card)
	return b


## The evening card's inside (WeekDay.PmCard holds it): pads with its drill, an empty pads night, sparring, film or rest.
## spec: {i, kind, entries, rows, f, spar_cards, camp, partner, gain2, key2, cost, on_clear}
static func night_body(spec: Dictionary) -> Control:
	var i := int(spec["i"])
	var k := str(spec["kind"])
	var f: Dictionary = spec["f"]
	var h := UI.hbox(10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var entries: Array = spec.get("entries", [])
	var v := UI.vbox(3)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var cost := float(spec.get("cost", 0.0))
	match k:
		"pads":
			h.add_child(tile("pads"))
			h.add_child(v)
			if entries.is_empty():
				v.add_child(UI.label("Pads", 18, UI.FG, "bold"))
				v.add_child(UI.label("drop a drill here, or click", 14, WoodKit.BLUE, "body"))
			elif entries.size() >= 2:   # a split night: one line per card, its share badge cycles 50/50 -> 70/30 -> 30/70
				v.add_child(UI.label("Pads, split", 15, UI.FG, "bold"))
				for at in entries.size():
					v.add_child(_slot(spec, entries[at] as Dictionary, at))
			else:
				var names: Array = []
				for e in entries:
					names.append(PadEdit.title(f, str(e["card"])))
				var nm := UI.label(" + ".join(names), 18, UI.FG, "bold")
				nm.name = "NightDrill_%d" % i
				nm.clip_text = true
				v.add_child(nm)
				for e in entries:
					var row: Dictionary = (spec.get("rows", {}) as Dictionary).get(str(e["card"]), {})
					if row.has(i):
						var g := UI.label("mastery %d → %d" % [roundi(float(row[i][0])), roundi(float(row[i][1]))], 15, UI.FG, "body")   # S398: the tray's rounding
						g.name = "Gain_%d" % i
						v.add_child(g)
			var pk2 := str(spec.get("key2", ""))
			if pk2 != "":   # a camp's pads night also drills the camp's attribute
				v.add_child(UI.label(gain_words(pk2, float(spec.get("gain2", 0.0))), 14, UI.FG, "body"))
			v.add_child(UI.label(tired_words(cost), 14, UI.MUTED, "semi"))
			if not entries.is_empty():   # x: the drill back to the tray (the night stays a pads night)
				var x := Button.new()
				x.name = "Off_%d" % i
				x.text = "x"
				x.flat = true
				x.focus_mode = Control.FOCUS_NONE
				x.tooltip_text = "Take the drill off: it goes back to the tray"
				x.custom_minimum_size = Vector2(26, 26)
				x.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
				x.add_theme_font_override("font", UI.font("bold"))
				x.add_theme_font_size_override("font_size", 17)
				x.add_theme_color_override("font_color", WoodKit.SOFT)
				x.add_theme_color_override("font_hover_color", WoodKit.BLUE)
				x.pressed.connect(func(): (spec["on_clear"] as Callable).call(i))
				h.add_child(x)
		"sparring":
			h.add_child(tile("fight_iq"))
			h.add_child(v)
			v.add_child(UI.label("Plan test" if bool(spec.get("camp", false)) else "Sparring", 18, UI.FG, "bold"))
			var key2 := str(spec.get("key2", ""))
			if key2 != "":
				v.add_child(UI.label(gain_words(key2, float(spec.get("gain2", 0.0))), 15, UI.FG, "body"))
			var sg: Array = spec.get("spar_gains", [])
			if not sg.is_empty():
				var sl := UI.label("spars " + ", ".join(sg), 14, UI.FG, "body")
				sl.clip_text = true
				v.add_child(sl)
			var low := UI.hbox(6)
			low.mouse_filter = Control.MOUSE_FILTER_IGNORE
			low.add_child(UI.label(tired_words(cost), 13, UI.MUTED, "semi"))
			var mate := str(spec.get("partner", ""))
			if mate != "":   # S382 PLANTRAY1: the outside mate the camp booked (CampMatch)
				var pc := chip(mate, "plain")
				pc.name = "Partner"
				low.add_child(pc)
			v.add_child(low)
		"film":
			h.add_child(tile("film"))
			h.add_child(v)
			v.add_child(UI.label("Film", 18, UI.FG, "bold"))
			v.add_child(UI.label("the opponent's tape", 14, UI.MUTED, "body"))
		_:
			h.add_child(v)
			v.add_child(UI.label("Rest", 17, UI.MUTED, "bold"))
	return h


## One card on a split night: its name, the night's gain, the share badge (Split_<i>, Split_<i>_b); right-click takes it off.
static func _slot(spec: Dictionary, e: Dictionary, at: int) -> PanelContainer:
	var i := int(spec["i"])
	var c := str(e["card"])
	var p := PanelContainer.new()
	p.name = "Slot_%d_%s" % [i, c.replace(":", "_").replace(" ", "_")]
	p.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	p.gui_input.connect(func(ev: InputEvent):
		var mb := ev as InputEventMouseButton
		if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_RIGHT:
			(spec["on_remove"] as Callable).call(i, c)
			p.accept_event())
	var h := UI.hbox(6)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(h)
	var row: Dictionary = (spec.get("rows", {}) as Dictionary).get(c, {})
	var gain := " %+d" % roundi(float(row[i][1]) - float(row[i][0])) if row.has(i) else ""
	var nm := UI.label(PadEdit.title(spec["f"], c) + gain, 14, UI.FG, "semi")
	nm.clip_text = true
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(nm)
	var badge := Button.new()
	badge.name = "Split_%d" % i if at == 0 else "Split_%d_b" % i
	badge.text = "%d%%" % roundi(100.0 * float(e["share"]))
	badge.focus_mode = Control.FOCUS_NONE
	badge.tooltip_text = "Click: 50/50 → 70/30 → 30/70"
	badge.add_theme_font_override("font", UI.font("bold"))
	badge.add_theme_font_size_override("font_size", 16)
	for k in ["font_color", "font_hover_color", "font_pressed_color"]:
		badge.add_theme_color_override(k, WoodKit.INK)
	for st in ["normal", "hover", "pressed", "focus"]:
		badge.add_theme_stylebox_override(st, UI.box(BLUE if st == "hover" else Color("#334155"), Color(0, 0, 0, 0), 8, 0, 6, 1))
	badge.pressed.connect(func(): (spec["on_split"] as Callable).call(i))
	h.add_child(badge)
	return p


## The day's line under its evening: "tired 49" and a bar of the day's end in its zone colour, ticks at 70 and 80.
static func tired_line(i: int, start: float, end: float, cost: float) -> HBoxContainer:
	var h := UI.hbox(8)
	h.name = "Tired_%d" % i
	h.mouse_filter = Control.MOUSE_FILTER_STOP
	h.tooltip_text = "Fatigue: slept from %d to %d, %s today = %d at night" % [roundi(start / WeekPlan.FATIGUE_KEEP) if i > 0 else roundi(start),
		roundi(start), tired_words(cost), roundi(end)]
	var lab := UI.hbox(4)
	lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lab.custom_minimum_size = Vector2(70, 0)
	lab.add_child(UI.label("Fatigue", 14, UI.MUTED, "body"))
	var n := UI.label("%d" % roundi(end), 16, zone(end) if end >= HEAVY else UI.FG, "bold")
	n.name = "TiredN_%d" % i
	lab.add_child(n)
	# S398 critics ("37 +5 +9 shows 46"): the night's recovery is said beside the number
	var slept := roundi(start / WeekPlan.FATIGUE_KEEP - start)
	if slept > 0:
		lab.add_child(UI.label("(-%d night)" % slept, 12, UI.MUTED, "body"))
	h.add_child(lab)
	var bar := ZoneBar.new()
	bar.value = end
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.custom_minimum_size = Vector2(60, 12)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(bar)
	return h


static func zone(v: float) -> Color:
	return UI.RED if v >= OVER else (UI.AMBER if v >= HEAVY else WoodKit.SOFT)


static func zone_word(v: float) -> String:
	return "overreached" if v >= OVER else ("heavy" if v >= HEAVY else ("fine" if v >= 50.0 else "fresh"))


## WEEK TIREDNESS: a 300 px track (pale to 70, amber to 80, red past) with the week's peak; "starts at 30 - peak 56 on Fri".
static func meter(start: float, peak: float, peak_day: int, heavy_days: String) -> HBoxContainer:
	var h := UI.hbox(12)
	h.name = "WeekTired"
	h.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(UI.caps("WEEK FATIGUE"))
	var bar := ZoneBar.new()
	bar.value = peak
	bar.zones = true
	bar.custom_minimum_size = Vector2(300, 14)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(bar)
	var w := UI.hbox(5)
	w.add_child(UI.label("starts at %d -" % roundi(start), 15, UI.MUTED, "body"))
	var pk := UI.label("peak fatigue %d" % roundi(peak), 15, zone(peak) if peak >= HEAVY else UI.FG, "bold")
	pk.name = "Peak"
	w.add_child(pk)
	w.add_child(UI.label("on %s - %s" % [DAY_NAMES[clampi(peak_day, 0, 6)].left(3), zone_word(peak)], 15, UI.MUTED, "body"))
	w.mouse_filter = Control.MOUSE_FILTER_STOP
	w.tooltip_text = "Heaviest days: %s. From 80 a morning trains at 60 %%." % heavy_days
	h.add_child(w)
	return h


## PLAN TOTALS: what the week gains, in one line ("Conditioning +0.60 - Power +0.40 - 2 moves reach Usable").
static func totals(gains: Dictionary, usable: int) -> HBoxContainer:
	var h := UI.hbox(16)
	h.name = "PlanTotals"
	h.add_child(UI.caps("PLAN TOTALS"))
	var keys := gains.keys()
	keys.sort_custom(func(a, b): return float(gains[a]) > float(gains[b]))
	for k in keys:
		if float(gains[k]) >= 0.005:
			var l := UI.label(gain_words(str(k), float(gains[k])), 18, UI.FG, "bold")
			l.name = "Total_%s" % str(k)
			h.add_child(l)
	if usable > 0:
		var u := UI.label("%d move%s reach%s Usable" % [usable, "" if usable == 1 else "s", "es" if usable == 1 else ""], 18, UI.GREEN, "bold")
		u.name = "TotalMoves"
		h.add_child(u)
	return h


## A card's button: see-through, a thin chalk edge (fainter on a rest); the edge turns blue under the cursor.
static func shell(name: String, quiet := false) -> Button:
	var b := Button.new()
	b.name = name
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for st in ["normal", "hover", "pressed", "focus"]:
		var hot: bool = st == "hover"
		var edge := Color(WoodKit.BLUE, 0.9) if hot else Color(WoodKit.SOFT, 0.2 if quiet else 0.35)
		b.add_theme_stylebox_override(st, UI.box(Color(1, 1, 1, 0.04), edge, 4, 1, 0, 0))
	return b


static func fill(b: Control, inner: Control) -> void:
	var m := MarginContainer.new()
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 9)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(m)
	m.add_child(inner)


## A segment row (Light | Normal | Hard, Rest | Pads | Sparring): the chosen one filled blue; one click sets it.
static func segments(prefix: String, words: Array, keys: Array, on: String, pick: Callable, ghost := Callable(), off := false) -> HBoxContainer:
	var row := UI.hbox(0)
	row.name = prefix + "Row"
	for n in words.size():
		var b := Button.new()
		b.name = "%s_%s" % [prefix, str(keys[n])]
		b.text = str(words[n])
		b.focus_mode = Control.FOCUS_NONE
		b.disabled = off
		b.custom_minimum_size = Vector2(0, 32)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.add_theme_font_override("font", UI.font("semi"))
		b.add_theme_font_size_override("font_size", 16)
		var lit := str(keys[n]) == on
		for c in ["font_color", "font_hover_color", "font_pressed_color"]:
			b.add_theme_color_override(c, WoodKit.INK)
		b.add_theme_color_override("font_disabled_color", WoodKit.SOFT)
		for st in ["normal", "hover", "pressed", "focus", "disabled"]:
			var hot: bool = st == "hover" and not lit
			var bg := Color(BLUE, 0.95) if lit else Color(1, 1, 1, 0.08 if hot else 0.04)
			var edge := Color(WoodKit.HEAD if lit else (WoodKit.BLUE if hot else WoodKit.SOFT), 1.0 if lit or hot else 0.35)
			b.add_theme_stylebox_override(st, UI.box(bg, edge, 0, 2 if lit else 1, 0, 0))
		var key := str(keys[n])
		b.pressed.connect(func(): pick.call(key))
		if ghost.is_valid():
			b.mouse_entered.connect(func(): ghost.call(key))
			b.mouse_exited.connect(func(): ghost.call(""))
		row.add_child(b)
	return row


## A popover row: tile, name, and on the right its gain over its tiredness.
static func pop_row(name: String, key: String, title: String, gain: String, cost: String, on: bool, pick: Callable,
		ghost := Callable(), goal_key := "") -> Button:
	var b := Button.new()
	b.name = name
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(0, 44)
	for st in ["normal", "hover", "pressed", "focus"]:
		var hot: bool = st == "hover" and not on
		var edge := Color(WoodKit.HEAD if on else (WoodKit.BLUE if hot else WoodKit.SOFT), 1.0 if on or hot else 0.35)
		b.add_theme_stylebox_override(st, UI.box(Color(1, 1, 1, 0.04), edge, 4, 2 if on else 1, 0, 0))
	b.pressed.connect(pick)
	if ghost.is_valid():
		b.mouse_entered.connect(func(): ghost.call(true))
		b.mouse_exited.connect(func(): ghost.call(false))
	var h := UI.hbox(10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fill(b, h)
	h.add_child(tile(key, 30))
	var t := UI.label(title, 16, UI.FG, "bold")
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(t)
	if goal_key != "" and key == goal_key:   # S398 critics: the goal's mark in the popover too
		var dot := ColorRect.new()
		dot.color = Color("#e0a400")
		dot.custom_minimum_size = Vector2(9, 9)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(dot)
	var r := UI.vbox(0)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.add_child(UI.label(gain, 14, UI.FG, "body"))
	r.add_child(UI.label(cost, 13, UI.MUTED, "body"))
	for l in r.get_children():
		(l as Label).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(r)
	return b


## The popover's frame: a title ("Wednesday morning"), "Esc to close", then the body. Floats over the board (top_level),
## placed beside its card by WeekBoard once the page is laid out.
static func pop(name: String, title: String, body: Control, on_close: Callable) -> Pop:
	var p := Pop.new()
	p.name = name
	p.on_close = on_close
	var v := UI.vbox(8)
	p.add_child(v)
	var h := UI.hbox(8)
	h.add_child(UI.label(title, 17, UI.FG, "bold"))
	h.add_child(UI.spacer())
	h.add_child(UI.label("Esc to close", 13, UI.MUTED, "body"))
	v.add_child(h)
	v.add_child(body)
	return p


## The floating popover: Esc or a click outside closes it.
class Pop extends PanelContainer:
	var on_close := Callable()
	var anchor: Control = null
	var left := false

	func _init() -> void:
		top_level = true
		z_index = 50
		custom_minimum_size = Vector2(360, 0)
		mouse_filter = Control.MOUSE_FILTER_STOP
		add_theme_stylebox_override("panel", WoodKit.slate(26, 18))

	func _ready() -> void:
		_place.call_deferred()

	func _place() -> void:
		if anchor == null or not is_instance_valid(anchor):
			return
		var r := anchor.get_global_rect()
		var w := maxf(size.x, custom_minimum_size.x)
		var x := r.position.x - w - 10.0 if left else r.end.x + 10.0
		var vp := get_viewport_rect().size
		global_position = Vector2(clampf(x, 8.0, vp.x - w - 8.0), clampf(r.position.y, 8.0, maxf(8.0, vp.y - size.y - 8.0)))

	func _unhandled_input(ev: InputEvent) -> void:
		if ev.is_action_pressed("ui_cancel") and on_close.is_valid():
			on_close.call()
			get_viewport().set_input_as_handled()

	func _input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb != null and mb.pressed and not get_global_rect().has_point(mb.global_position) and on_close.is_valid():
			if anchor != null and is_instance_valid(anchor) and anchor.get_global_rect().has_point(mb.global_position):
				return   # the card's own click toggles it
			on_close.call_deferred()


## A tiredness bar: the fill in its zone colour, ticks at 70 and 80; zones = true paints the zones on the track.
class ZoneBar extends Control:
	var value := 0.0
	var zones := false

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		var w := size.x
		var hh := size.y
		var dark := WoodKit.on_dark(self)
		draw_rect(Rect2(0, 0, w, hh), Color(WoodKit.SOFT, 0.22) if dark else Color("#eceff2"))
		var amber := Color(UI.AMBER, 0.55) if dark else Color("#f5d9a8")
		var red := Color(UI.RED, 0.5) if dark else Color("#f3b8b2")
		draw_rect(Rect2(w * 0.7, 0, w * 0.1, hh), amber)   # S398: the zones on every bar
		draw_rect(Rect2(w * 0.8, 0, w * 0.2, hh), red)
		if zones:
			draw_rect(Rect2(0, hh * 0.2, w * clampf(value / 100.0, 0.0, 1.0), hh * 0.6), WoodKit.fg(self))
		else:
			var col := UI.RED if value >= 80.0 else (UI.AMBER if value >= 70.0 else (WoodKit.SOFT if dark else Color("#7a8794")))
			draw_rect(Rect2(0, 0, w * clampf(value / 100.0, 0.0, 1.0), hh), col)


## The GOAL row's bar (gold = the goal): it spans today's value to the target; gold fills to Sunday, a dashed tick marks
## where this pace ends, the target's number at the right end.
class GoalBar extends Control:
	var now := 0.0
	var week := 0.0
	var pace := 0.0
	var target := 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		custom_minimum_size = Vector2(380, 30)
		tooltip_text = "%.1f now, %.1f by Sunday, %.1f at this pace, target %.0f" % [now, week, pace, target]
		resized.connect(queue_redraw)

	func _x(v: float) -> float:
		var span := maxf(0.5, target - now)
		return clampf((v - now) / span, 0.0, 1.0) * (size.x - 16.0)

	func _draw() -> void:
		var hh := 12.0
		var ink := WoodKit.fg(self)
		var dark := WoodKit.on_dark(self)
		draw_rect(Rect2(0, 0, size.x - 16.0, hh), Color(WoodKit.SOFT, 0.28) if dark else Color("#eef0f2"))
		draw_rect(Rect2(0, 0, maxf(3.0, _x(week)), hh), Color("#e0a400"))
		var px := _x(pace)
		var y := -3.0
		while y < hh + 3.0:
			draw_line(Vector2(px, y), Vector2(px, minf(y + 3.0, hh + 3.0)), Color("#b07f00"), 2.0)
			y += 5.0
		var tx := size.x - 16.0
		draw_line(Vector2(tx, -4), Vector2(tx, hh + 4), ink, 2.0)
		var f := ThemeDB.fallback_font
		draw_string(f, Vector2(tx - 8, hh + 17), "%d" % roundi(target), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, ink)
