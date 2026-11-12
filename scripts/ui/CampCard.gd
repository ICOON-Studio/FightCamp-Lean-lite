extends RefCounted
## S379 CAMPCARDS (operator on docs/mockups/fight_camp_cards.png: "looks ok, build it in the game"): the FIGHT CAMP modal's
## pieces - one camp card per focus (the training-station picture on this fighter's body, the title, "<Stat> ++", now ->
## fight night, S381 G1 the threshold bar (NightBar: now -> fight night, a gold tick at the number that changes the night,
## gold once the forecast crosses it) with its one caption; the chosen card outlined with a check mark, a click picks it), one
## option box for the protocol row and film study, and the count-up every changing number uses (operator: animated meters).
##   card(main, f, key, chosen, now, end, from, pop) -> Button "Focus_<key>"     picture(f, key) -> Texture2D
##   option(name, title, line, risk, risk_col, on, press, h) -> Button       count(l, from, to, fmt)   pulse(c)

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Data := preload("res://scripts/state/Data.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const NightBar := preload("res://scripts/ui/NightBar.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

const CARD_H := 340.0
const PIC_H := 178.0
const INSET := 6
## The quiet line Camp.gd still asks for. On the slate that is the quiet chalk, not the old grey.
const SUB := WoodKit.SOFT
const TWEEN_S := 0.45
## The station picture for each camp focus (assets/ui/training/<body>_<station>.png, tools/bake_session_pics.gd).
const STATION := {"conditioning": "roadwork", "power": "heavy_bag", "technique": "pads", "defense": "slip_rope",
	"speed": "speed_bag"}
const PICS := "res://assets/ui/training/"
## S434 CARDIO1 (CORE_LOOP C3): the Cardio camp (conditioning, the mean of Stamina and Recovery) shows the Stamina line, on
## Stamina's own number, never the mean's: the face's forecast ("Stamina 57.6 -> 62.4 by fight night"), the bar and the
## caption. S439 round 3: its fight-night end is the forecast's own Stamina (CampForecast.run "attrs", the days trained as
## Sim.step_day trains them), never Stamina now + the mean's gain (the camp's roadwork and intervals train Stamina by name,
## so Stamina moves more than the mean: 57.6 -> 62.4 where the mean's gain said 60.6). Others show their own.
const LINE_OF := {"conditioning": "stamina"}
const FALLBACK := "mh_boxer_10"


static func card(main: Node, f: Dictionary, key: String, chosen: bool, now: float, end: float, from: float,
		pop: bool, night: Dictionary = {}, line_from := -1.0) -> Button:
	var b := _shell("Focus_" + key, chosen, main.act.bind("cfocus", key))
	b.custom_minimum_size = Vector2(0, CARD_H)
	# S434 CARDIO1 round 2 (C3: Stamina is the number on every row, line and goal): a card whose line reads another number
	# (the Cardio card, LINE_OF) prints THAT number, named, on its face, so the forecast, the bar and the caption agree.
	var ln := line_numbers(f, key, now, end, from, night, line_from)
	var named := str(ln["key"]) != key
	var nm := (str(Attrs.LABEL[ln["key"]]) + " ") if named else ""
	b.tooltip_text = "%s camp: %s %.1f now, %.1f by fight night" % [Data.LABEL[key],
		(nm.strip_edges() if named else str(Data.LABEL[key])).to_lower(), float(ln["now"]), float(ln["end"])]
	var v := _fill(b, INSET, 0)
	var pic := TextureRect.new()
	pic.name = "Pic"
	pic.custom_minimum_size = Vector2(0, PIC_H)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	pic.texture = picture(f, key)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(pic)
	var words := MarginContainer.new()
	for side in ["left", "right"]:
		words.add_theme_constant_override("margin_" + side, 8)
	words.add_theme_constant_override("margin_top", 8)
	words.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(words)
	var w := UI.vbox(2)
	w.mouse_filter = Control.MOUSE_FILTER_IGNORE
	words.add_child(w)
	w.add_child(UI.label(str(Data.LABEL[key]), 23, UI.FG, "marker"))
	w.add_child(UI.label("%s ++" % Data.LABEL[key], 17, UI.GREEN, "bold"))
	var fc := UI.label("", 16, UI.FG, "body")
	fc.name = "Forecast"
	var ln_now := float(ln["now"])
	count(fc, float(ln["from"]), float(ln["end"]), func(x: float) -> String: return "%s%.1f -> %.1f by fight night" % [nm, ln_now, x])
	w.add_child(fc)
	_gap(w, 4)
	var bar := NightBar.make(str(ln["key"]), float(ln["now"]), float(ln["end"]), float(ln["from"]))   # S381 G1: replaces the line on what the camp does
	w.add_child(bar)
	var words_at := BoutRules.night_line_words(str(ln["key"]))
	if words_at != "":
		var cap := UI.label(words_at, 15, UI.GOLD if BoutRules.clears_night_line(str(ln["key"]), float(ln["end"])) else UI.MUTED, "bold")
		cap.name = "NightLine"
		# The line's colour is checked as the paper ink, so it sits on a light chip (a piece the look keeps) and the
		# ink pass leaves it. Chalk fill, not the old cream. The rest of the card is chalk words on the slate.
		var hold := PanelContainer.new()
		hold.theme_type_variation = "Chip"
		hold.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hold.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		hold.add_theme_stylebox_override("panel", UI.box(WoodKit.INK, Color(WoodKit.SOFT, 0.45), 4, 1, 6, 1))
		hold.add_child(cap)
		w.add_child(hold)
		b.tooltip_text += " - " + words_at
	if chosen:
		b.add_child(_check(pop))
	return b


## The number the card's night bar and caption read: {key, now, end, from} - the card's own stat, or the line's ability
## (LINE_OF): today's value and fight night's from `night` (CampForecast.run's "attrs"); `line_from` is the end the card
## showed before (the count starts there), -1 for none. A Cardio card with no forecast's attributes is a caller's error:
## it shows today's Stamina as the end rather than a number derived from the mean.
static func line_numbers(f: Dictionary, key: String, now: float, end: float, from: float, night: Dictionary = {},
		line_from := -1.0) -> Dictionary:
	if not LINE_OF.has(key):
		return {"key": key, "now": now, "end": end, "from": from}
	var lk := str(LINE_OF[key])
	var v := float(Attrs.of(f)[lk])
	var e := float(night.get(lk, v))
	return {"key": lk, "now": v, "end": e, "from": line_from if line_from >= 0.0 else v}


## The fighter's own body's picture for the focus; another boxer's when it is missing (S380: the five men are baked too).
static func picture(f: Dictionary, key: String) -> Texture2D:
	var station := str(STATION.get(key, "heavy_bag"))
	var stems: Array = [Faces.stem(f), FALLBACK]
	var women: Array = Faces.CM.keys()
	women.sort()
	stems.append_array(women)
	for s in stems:
		var path := "%s%s_%s.png" % [PICS, s, station]
		if ResourceLoader.exists(path):
			return load(path)
	return null


## One box of the protocol row / film study: a bold title, a line under it and a small risk line (wraps in its box).
static func option(name: String, title: String, line: String, risk: String, risk_col: Color, on: bool, press: Callable,
		h: float) -> Button:
	var b := _shell(name, on, press)
	b.custom_minimum_size = Vector2(0, h)
	var v := _fill(b, 14, 10)
	v.add_child(UI.label(title, 20, UI.FG, "bold", true))
	if line != "":
		v.add_child(UI.label(line, 15, UI.MUTED, "body", true))
	if risk != "":
		var r := UI.label(risk, 14, risk_col, "body", true)
		r.name = "Risk"
		v.add_child(r)
	return b


## Sets the label's (or button's) text to fmt(to); when `from` differs it counts there from `from` once it is on screen.
static func count(l: Control, from: float, to: float, fmt: Callable) -> void:
	l.set("text", fmt.call(to))
	if absf(to - from) < 0.001:
		return
	l.set("text", fmt.call(from))
	var go := func() -> void:
		l.create_tween().tween_method(func(x: float) -> void: l.set("text", fmt.call(x)), from, to, TWEEN_S) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if l.is_inside_tree():
		go.call()
	else:
		l.ready.connect(go, CONNECT_ONE_SHOT)


## A short colour pulse when a value changes band (operator: animated meters).
static func pulse(c: CanvasItem) -> void:
	var go := func() -> void:
		c.modulate = Color(1.0, 0.8, 0.35)
		c.create_tween().tween_property(c, "modulate", Color.WHITE, 0.6).set_ease(Tween.EASE_OUT)
	if c.is_inside_tree():
		go.call()
	else:
		c.ready.connect(go, CONNECT_ONE_SHOT)


static func _shell(name: String, on: bool, press: Callable) -> Button:
	var b := Button.new()
	b.name = name
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for st in ["normal", "hover", "pressed", "disabled", "focus"]:
		b.add_theme_stylebox_override(st, _frame(on, st == "hover" or st == "pressed"))
	b.pressed.connect(press)
	return b


## See-through on the slate. The chosen card takes a gold edge; the cursor turns the edge blue. The fill stays clear in
## every state: the ink pass reads "normal", and a pale fill would keep dark words on the slate.
static func _frame(on: bool, hover: bool) -> StyleBoxFlat:
	var edge := Color(WoodKit.HEAD) if on else (Color(WoodKit.BLUE) if hover else Color(WoodKit.SOFT, 0.35))
	return UI.box(Color(1, 1, 1, 0.04), edge, 4, 2 if on else 1, 0, 0)


## The box's inner column, filling the button with `pad` (sides) and `pad_v` (top and bottom).
static func _fill(b: Button, pad: int, pad_v: int) -> VBoxContainer:
	var m := MarginContainer.new()
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		m.add_theme_constant_override("margin_" + side, pad)
	m.add_theme_constant_override("margin_top", pad if pad_v == 0 else pad_v)
	m.add_theme_constant_override("margin_bottom", pad_v)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(m)
	var v := UI.vbox(2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(v)
	return v


## The chosen card's check mark: a blue disc with a white tick, top right of the picture; it pops in when just picked.
static func _check(pop: bool) -> Control:
	var c := Control.new()
	c.name = "Check"
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	c.offset_left = -INSET - 44
	c.offset_right = -INSET - 10
	c.offset_top = INSET + 10
	c.offset_bottom = INSET + 44
	c.pivot_offset = Vector2(17, 17)
	c.draw.connect(func() -> void:
		c.draw_circle(Vector2(17, 17), 17.0, UI.GOLD)
		c.draw_polyline(PackedVector2Array([Vector2(9, 18), Vector2(15, 24), Vector2(25, 11)]), Color.WHITE, 3.5, true))
	if not pop:
		return c
	c.ready.connect(func() -> void:
		c.scale = Vector2(0.4, 0.4)
		c.create_tween().tween_property(c, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT), CONNECT_ONE_SHOT)
	return c


static func _gap(box: Container, h: int) -> void:
	var g := Control.new()
	g.custom_minimum_size = Vector2(0, h)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(g)
