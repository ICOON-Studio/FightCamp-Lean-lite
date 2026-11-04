extends RefCounted
## S379 CAMPCARDS (operator on docs/mockups/fight_camp_cards.png: "looks ok, build it in the game"): the FIGHT CAMP modal's
## pieces - one camp card per focus (the training-station picture on this fighter's body, the title, "<Stat> ++", now ->
## fight night, a plain line on what the camp does; the chosen card outlined with a check mark, a click picks it), one
## option box for the protocol row and film study, and the count-up every changing number uses (operator: animated meters).
##   card(main, f, key, chosen, now, end, from, pop) -> Button "Focus_<key>"     picture(f, key) -> Texture2D
##   option(name, title, line, risk, risk_col, on, press, h) -> Button       count(l, from, to, fmt)   pulse(c)

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

const CARD_H := 340.0
const PIC_H := 178.0
const INSET := 6
const BLUE_SOFT := Color("#e8efff")
const BLUE_RING := Color("#c9d8ff")
const SUB := Color("#4b5563")
const TWEEN_S := 0.45
## The station picture for each camp focus (assets/ui/training/<body>_<station>.png, tools/bake_session_pics.gd).
const STATION := {"conditioning": "roadwork", "power": "heavy_bag", "technique": "pads", "defense": "slip_rope",
	"speed": "speed_bag"}
## What the camp does, in two halves: the work and what it buys on the night (the second half reads "near the ceiling"
## once headroom is small - TrainingPreview.headroom).
const WHAT := {
	"conditioning": ["intervals, roadwork, extra rounds", "lasts into round 3"],
	"power": ["heavy bag, sit-down shots", "hurts on the body"],
	"technique": ["shadow and pads", "cleaner combinations"],
	"defense": ["slip rope, head movement", "takes fewer clean shots"],
	"speed": ["speed bag, fast hands", "lands first"],
}
const NEAR_CAP := 0.4
const PICS := "res://assets/ui/training/"
const FALLBACK := "mh_boxer_10"


static func card(main: Node, f: Dictionary, key: String, chosen: bool, now: float, end: float, from: float,
		pop: bool) -> Button:
	var b := _shell("Focus_" + key, chosen, main.act.bind("cfocus", key))
	b.custom_minimum_size = Vector2(0, CARD_H)
	b.tooltip_text = "%s camp: %s %.1f now, %.1f by fight night" % [Data.LABEL[key], str(Data.LABEL[key]).to_lower(), now, end]
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
	count(fc, from, end, func(x: float) -> String: return "%.1f -> %.1f by fight night" % [now, x])
	w.add_child(fc)
	var what: Array = WHAT[key]
	var pay := "near the ceiling" if TrainingPreview.headroom(int(f["pot"]), now) <= NEAR_CAP else str(what[1])
	w.add_child(UI.label("%s - %s" % [what[0], pay], 16, UI.MUTED, "hand", true))
	if chosen:
		b.add_child(_check(pop))
	return b


## Her own body's picture for the focus; another boxer's when hers is missing (the men have none baked yet).
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
		v.add_child(UI.label(line, 15, SUB, "body", true))
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


static func _frame(on: bool, hover: bool) -> StyleBoxFlat:
	var s := UI.box(BLUE_SOFT if on else UI.PANEL, UI.GOLD if on else (UI.MUTED if hover else UI.LINE), 12, 2, 0, 0)
	if on:
		s.shadow_color = BLUE_RING
		s.shadow_size = 4
	return s


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
