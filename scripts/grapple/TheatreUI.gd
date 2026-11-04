extends RefCounted
## S379 the Grappling theatre's 2D chrome, dark like a screening room: the top bar (title, Director / Free orbit, back to
## the ground moves), the row of chain PICTURE cards (operator rule: pictures over text menus - each card a still of the
## chain's key position on our two women, tools/theatre_film.gd `cards=1`), the documentary lower third (move name + one
## plain line), and the transport (previous / play / next move, 0.25x 0.5x 1x, loop, the clock). Builders only; the
## theatre (GrappleTheatre.gd) owns the state and hands its callbacks in.

const UI := preload("res://scripts/ui/UI.gd")
const BG := Color("#0f1216")
const PANEL := Color("#171b21")
const RAISED := Color("#202630")
const LINE := Color("#2a313a")
const TEXT := Color("#eef2f6")
const MUTED := Color("#8f9aa6")
const ACCENT := Color("#ffb020")
const BLUE := Color("#5b93ff")
const CARD_W := 196
const CARD_H := 110
const CARD_DIR := "res://assets/ui/theatre/"


static func box(bg: Color, border: Color = Color(0, 0, 0, 0), radius: int = 6, pad_h: int = 12, pad_v: int = 8) -> StyleBoxFlat:
	return UI.box(bg, border, radius, 2 if border.a > 0.0 else 0, pad_h, pad_v)


static func panel(bg: Color, pad_h: int = 14, pad_v: int = 8) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", box(bg, Color(0, 0, 0, 0), 0, pad_h, pad_v))
	return p


## A dark button; `on` = the toggled look (accent border, light text).
static func btn(text: String, on_press: Callable, on: bool = false, min_w: int = 0) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.custom_minimum_size = Vector2(min_w, 38)
	b.add_theme_font_override("font", UI.font("semi"))
	b.add_theme_font_size_override("font_size", 17)
	style(b, on)
	b.pressed.connect(on_press)
	return b


static func style(b: Button, on: bool) -> void:
	var border := ACCENT if on else LINE
	b.add_theme_stylebox_override("normal", box(RAISED if on else PANEL, border, 6, 14, 6))
	b.add_theme_stylebox_override("hover", box(RAISED, ACCENT if on else MUTED, 6, 14, 6))
	b.add_theme_stylebox_override("pressed", box(RAISED, ACCENT, 6, 14, 6))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for c in ["font_color", "font_hover_color", "font_pressed_color"]:
		b.add_theme_color_override(c, TEXT if on or c != "font_color" else MUTED.lightened(0.25))


static func top_bar(on_mode: Callable, on_back: Callable) -> Dictionary:
	var bar := panel(PANEL, 18, 8)
	var h := UI.hbox(14)
	bar.add_child(h)
	h.add_child(UI.label("GRAPPLING THEATRE", 30, TEXT, "display"))
	var sub := UI.label("GrappleMap chains played straight from the recording - watch how the moves join", 16, MUTED)
	sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(sub)
	h.add_child(UI.spacer())
	var mode := btn("Director", on_mode, true, 150)
	h.add_child(mode)
	h.add_child(btn("Ground moves", on_back, false))
	return {"bar": bar, "mode": mode}


## The chain cards: picture, title, the moves it strings together. `pick` is called with the chain id.
static func cards(chains: Array, pick: Callable) -> Dictionary:
	var scroll := ScrollContainer.new()
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size = Vector2(0, CARD_H + 74)
	var outer := panel(BG, 14, 8)
	outer.add_child(scroll)
	var row := UI.hbox(12)
	scroll.add_child(row)
	var by_id := {}
	for c in chains:
		var id := str(c["id"])
		var b := Button.new()
		b.focus_mode = Control.FOCUS_NONE
		b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		b.custom_minimum_size = Vector2(CARD_W + 12, CARD_H + 64)
		b.tooltip_text = "%s: %s" % [str(c["title"]), str(c["sub"])]
		b.pressed.connect(func(): pick.call(id))
		var v := UI.vbox(3)
		v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		v.offset_left = 6
		v.offset_top = 6
		v.offset_right = -6
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var pic := TextureRect.new()
		pic.custom_minimum_size = Vector2(CARD_W, CARD_H)
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		pic.texture = card_texture(id)
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(pic)
		var t := UI.label(str(c["title"]), 15, TEXT, "semi")
		t.clip_text = true
		t.custom_minimum_size = Vector2(CARD_W, 0)
		v.add_child(t)
		var n := UI.label("%d moves" % (c["steps"] as Array).size(), 13, MUTED)
		v.add_child(n)
		b.add_child(v)
		row.add_child(b)
		by_id[id] = b
	return {"box": outer, "buttons": by_id}


static func mark_card(buttons: Dictionary, selected: String) -> void:
	for id in buttons:
		var b: Button = buttons[id]
		var on := str(id) == selected
		b.add_theme_stylebox_override("normal", box(RAISED if on else PANEL, ACCENT if on else LINE, 8, 0, 0))
		b.add_theme_stylebox_override("hover", box(RAISED, ACCENT if on else MUTED, 8, 0, 0))
		b.add_theme_stylebox_override("pressed", box(RAISED, ACCENT, 8, 0, 0))
		b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


## The card's still (an imported texture in the game; the raw PNG straight after tools/theatre_film.gd made it).
static func card_texture(id: String) -> Texture2D:
	var path := CARD_DIR + id + ".png"
	if ResourceLoader.exists(path):
		return load(path)
	if FileAccess.file_exists(path):
		var img := Image.load_from_file(ProjectSettings.globalize_path(path))
		if img != null:
			return ImageTexture.create_from_image(img)
	return null


## The lower third: an amber bar, "MOVE 2 OF 5 - <chain>", the move's name big, its plain line under it.
static func caption() -> Dictionary:
	var holder := MarginContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	holder.grow_vertical = Control.GROW_DIRECTION_BEGIN
	holder.offset_left = 36
	holder.offset_bottom = -30
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", box(Color(0.06, 0.07, 0.09, 0.82), Color(0, 0, 0, 0), 4, 0, 0))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(p)
	var h := UI.hbox(0)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(h)
	var bar := ColorRect.new()
	bar.color = ACCENT
	bar.custom_minimum_size = Vector2(7, 0)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(bar)
	var m := MarginContainer.new()
	for side in ["left", "right"]:
		m.add_theme_constant_override("margin_" + side, 18)
	m.add_theme_constant_override("margin_top", 10)
	m.add_theme_constant_override("margin_bottom", 12)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(m)
	var v := UI.vbox(0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(v)
	var kicker := UI.label("", 14, ACCENT, "caps")
	var name := UI.label("", 46, TEXT, "display")
	var line := UI.label("", 19, Color("#c9d2db"))
	line.custom_minimum_size = Vector2(520, 0)
	line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for l in [kicker, name, line]:
		v.add_child(l)
	return {"box": holder, "kicker": kicker, "name": name, "line": line}


static func controls(cb: Dictionary) -> Dictionary:
	var bar := panel(PANEL, 18, 8)
	var h := UI.hbox(10)
	bar.add_child(h)
	h.add_child(btn("< Prev move", cb["prev"], false))
	var play := btn("Pause", cb["play"], true, 110)
	h.add_child(play)
	h.add_child(btn("Next move >", cb["next"], false))
	h.add_child(UI.label("   SPEED", 14, MUTED, "caps"))
	var speeds := {}
	for s in [0.25, 0.5, 1.0]:
		var sp: float = s
		var b := btn({0.25: "0.25x", 0.5: "0.5x", 1.0: "1x"}[sp], func(): cb["speed"].call(sp), sp == 1.0, 64)
		speeds[sp] = b
		h.add_child(b)
	var loop := btn("Loop chain", cb["loop"], true)
	h.add_child(loop)
	h.add_child(UI.spacer())
	var clock := UI.label("0.0 / 0.0 s", 17, MUTED, "mono")
	h.add_child(clock)
	return {"box": bar, "play": play, "speeds": speeds, "loop": loop, "clock": clock}
