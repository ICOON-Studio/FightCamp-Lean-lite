extends RefCounted
## PAGES2B: small drawn pieces for one Fighters roster row (ring, upright bar, tick bar, tag, face pin, name plate).
## S440 (review fix): every word is a real Label, so WoodKit.ink and SlateWalk read it and its font size is the real one;
## colours come from UI / WoodKit only; pins and rings keep their own size inside the row (round, never stretched).
## S440 round 2 (fixer): the rings tween like the bars; the need badge carries a drawn envelope; the key line under the rows.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const FaceFrame := preload("res://scripts/ui/FaceFrame.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

const PIN := 120.0
const NAVY := UI.GOLD_LIP
const RIM := WoodKit.INK
const TRACK := Color(WoodKit.INK, 0.12)
const BAR_SLOT := 40.0
## Upright bar: the number on top, the track, the gold dot, then the group word on one of two lines.
const BAR_TOP := 26.0
const BAR_H := 64.0
const WORD_A := 102.0
const WORD_B := 120.0
const BAR_TALL := 140.0
const BAND := [
	[40.0, UI.RED], [55.0, UI.AMBER], [70.0, WoodKit.BLUE],
	[85.0, UI.GREEN], [101.0, UI.PURPLE],
]


static func tone_col(tone: String) -> Color:
	return {"good": UI.GREEN, "ok": WoodKit.INK, "watch": UI.AMBER, "bad": UI.RED,
		"muted": WoodKit.SOFT}.get(tone, WoodKit.INK)


static func band_col(v: float) -> Color:
	for pair in BAND:
		if v < float(pair[0]):
			return pair[1] as Color
	return UI.PURPLE


## One word on the row: a Label. `clip` trims a long line to its column with "..." instead of pushing the next column.
static func ink(text: String, size: int, col: Color = WoodKit.INK, kind: String = "body", clip: bool = false) -> Label:
	var l := UI.label(text, size, col, kind)
	if clip:
		l.clip_text = true
		l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l


## A Label placed by hand (outside a container), centred on `cx`.
static func _word_at(text: String, size: int, col: Color, kind: String, cx: float, y: float) -> Label:
	var l := ink(text, size, col, kind)
	var w: float = UI.font(kind).get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x + 2.0
	l.position = Vector2(cx - w * 0.5, y)
	l.size = Vector2(w, size + 6)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


static func face_pin(stem: String, needs_you: bool) -> Control:
	var host := Control.new()
	host.name = "FacePin"
	host.custom_minimum_size = Vector2(PIN, PIN)
	host.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	host.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var disc := Panel.new()
	disc.name = "Disc"
	disc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	disc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disc.add_theme_stylebox_override("panel", UI.box(NAVY, RIM, int(PIN / 2.0), 4, 0, 0))
	disc.clip_contents = true
	host.add_child(disc)
	var pic: Control = PromoShot.picture(stem, Vector2(PIN - 8.0, PIN - 8.0))
	if pic != null:
		pic.position = Vector2(4, 4)
		FaceFrame.fit(pic as TextureRect, FaceFrame.box_for((pic as TextureRect).texture), Vector2(PIN - 8.0, PIN - 8.0), true)
		# Round mask (JPG faces have no alpha for Halo.cutout); chalk ring via Halo.ring on the host.
		_circle_mask(pic as TextureRect)
		disc.add_child(pic)
	Halo.ring(host, RIM, PIN * 0.5, 0.45, 0.0)
	if needs_you:
		var badge := PanelContainer.new()
		badge.name = "NeedBadge"
		badge.position = Vector2(PIN - 42.0, -8.0)
		badge.custom_minimum_size = Vector2(40, 40)
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.add_theme_stylebox_override("panel", UI.box(UI.RED, RIM, 20, 3, 0, 0))
		var env := Envelope.new()
		env.name = "Envelope"
		env.custom_minimum_size = Vector2(40, 40)
		env.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.add_child(env)
		host.add_child(badge)
	return host


static func _circle_mask(pic: TextureRect) -> void:
	var sh := Shader.new()
	sh.code = "shader_type canvas_item;\nvoid fragment() {\n\tvec2 p = UV - vec2(0.5);\n\tfloat d = length(p);\n\tvec4 c = texture(TEXTURE, UV);\n\tif (d > 0.50) discard;\n\tfloat edge = smoothstep(0.50, 0.46, d);\n\tCOLOR = vec4(c.rgb, c.a * edge);\n}\n"
	var mat := ShaderMaterial.new()
	mat.shader = sh
	pic.material = mat


static func overall_ring(value: int) -> Control:
	var r := dial("OverallRing", 92.0, float(value), 100.0, str(value), WoodKit.HEAD, 36)
	r.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	r.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	return r


## A ring filled to value / goal with its number (a Label, bold sans) in the middle.
static func dial(name: String, side: float, value: float, goal: float, big: String, colour: Color, font_size: int) -> Control:
	var r := Dial.new()
	r.name = name
	r.custom_minimum_size = Vector2(side, side)
	r.value = value
	r.goal = goal
	r.big = big
	r.colour = colour
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l := ink(big, font_size, WoodKit.INK, "bold")
	l.name = "Big"
	l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	r.add_child(l)
	return r


## One group bar: its number on top (Label), the track, a gold dot when the roster's best, its group word under it.
## `low` puts the word on the second line, so five words of up to ~70 px never run together in 40 px slots.
static func upright(group: String, value: float, gold_dot: bool, low: bool) -> Control:
	var c := UprightBar.new()
	c.name = "Bar_" + group
	c.value = value
	c.colour = band_col(value)
	c.gold_dot = gold_dot
	c.custom_minimum_size = Vector2(BAR_SLOT, BAR_TALL)
	c.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	c.mouse_filter = Control.MOUSE_FILTER_PASS
	c.tooltip_text = "%s %d%s" % [group, int(round(value)), ", the best of the roster" if gold_dot else ""]
	var num := _word_at(str(int(round(value))), 18, c.colour, "bold", BAR_SLOT * 0.5, 0.0)
	num.name = "Num"
	c.add_child(num)
	var word := _word_at(group, 16, WoodKit.SOFT, "body", BAR_SLOT * 0.5, WORD_B if low else WORD_A)
	word.name = "Word"
	c.add_child(word)
	return c


static func tick_bar(value: float, tick_at: float, colour: Color, show_zone: bool = false) -> Control:
	var c := TickBar.new()
	c.name = "TickBar"
	c.value = value
	c.tick_at = tick_at
	c.colour = colour
	c.show_zone = show_zone
	c.custom_minimum_size = Vector2(110, 18)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


## A small tag (OFFER / BOOKED / OPEN / FIX / REST / DRILL), as painted: a dark plate, a blue edge, its word in pale chalk.
static func tag_chip(text: String) -> PanelContainer:
	var t := PanelContainer.new()
	t.name = "Tag"
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	t.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	t.add_theme_stylebox_override("panel", UI.box(UI.DARK, WoodKit.BLUE, 3, 2, 8, 1))
	var l := ink(text.to_upper(), 18, WoodKit.INK, "bold")
	l.name = "TagWord"
	t.add_child(l)
	return t


static func name_plate(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "NamePlate"
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	p.add_theme_stylebox_override("panel", UI.box(NAVY, Color(0, 0, 0, 0), 8, 0, 12, 4))
	var l := ink(text, 22, WoodKit.INK, "bold")
	l.name = "Name"
	p.add_child(l)
	return p


static func goal_ring(frac: float, big: String, colour: Color) -> Control:
	var r := dial("GoalRing", 56.0, clampf(frac, 0.0, 1.0), 1.0, big, colour, 20)
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	return r


## The key under the rows, in words with the marks they explain: the best dot (with two boxers or more), the tick, the
## level colours of the group bars, the needs-you badge.
static func key_line(with_best: bool) -> Control:
	var h := HBoxContainer.new()
	h.name = "KeyLine"
	h.add_theme_constant_override("separation", 10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	h.custom_minimum_size = Vector2(0, 36)
	if with_best:
		h.add_child(_swatch(WoodKit.HEAD, 10.0, 5))
		h.add_child(ink("best of the roster", 16, WoodKit.SOFT))
		h.add_child(_gap())
	h.add_child(_swatch(WoodKit.INK, 3.0, 0, 18.0))
	h.add_child(ink("weight limit, too tired from 80", 16, WoodKit.SOFT))
	h.add_child(_gap())
	h.add_child(ink("Level", 16, WoodKit.SOFT))
	for pair in BAND:
		h.add_child(_swatch(pair[1] as Color, 14.0, 2))
	h.add_child(ink("Elite", 16, WoodKit.SOFT))
	h.add_child(_gap())
	h.add_child(_swatch(UI.RED, 14.0, 7))
	h.add_child(ink("needs you", 16, WoodKit.SOFT))
	for l in h.get_children():
		(l as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return h


static func _swatch(col: Color, w: float, radius: int, h: float = -1.0) -> Panel:
	var p := Panel.new()
	p.custom_minimum_size = Vector2(w, w if h < 0.0 else h)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_theme_stylebox_override("panel", UI.box(col, Color(0, 0, 0, 0), radius, 0, 0, 0))
	return p


static func _gap() -> Control:
	var g := Control.new()
	g.custom_minimum_size = Vector2(28, 1)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return g


static func need_wash() -> StyleBoxFlat:
	# The warm red-brown plate behind a row that needs the player (UI.RED, darkened and see-through).
	return UI.box(Color(UI.RED.darkened(0.45), 0.34), Color(0, 0, 0, 0), 16, 0, 0, 0)


static func row_line() -> StyleBoxFlat:
	var s := UI.box(Color(0, 0, 0, 0), Color(WoodKit.INK, 0.10), 0, 0, 0, 0)
	s.border_width_bottom = 1
	return s


class Dial extends Control:
	var value := 0.0
	var goal := 1.0
	var big := ""
	var colour := WoodKit.HEAD
	var grow := 0.0:
		set(v):
			grow = v
			queue_redraw()

	func _ready() -> void:   # the house rule: every bar tweens to its value (MenuFx.instant in tests and stills)
		if MenuFx.instant:
			grow = 1.0
		else:
			create_tween().tween_property(self, "grow", 1.0, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	func _draw() -> void:
		var c := size / 2.0
		var w := maxf(4.0, size.x * 0.08)
		var r := minf(size.x, size.y) / 2.0 - w * 0.5 - 1.0
		draw_arc(c, r, 0.0, TAU, 64, TRACK, w, true)
		var part := clampf(value / maxf(goal, 0.001), 0.0, 1.0) * grow
		if part > 0.0:
			draw_arc(c, r, -PI / 2.0, -PI / 2.0 + TAU * part, 64, colour, w, true)


class UprightBar extends Control:
	var value := 0.0
	var colour := Color.WHITE
	var gold_dot := false
	var grow := 0.0:
		set(v):
			grow = v
			queue_redraw()

	func _ready() -> void:
		if MenuFx.instant:
			grow = 1.0
		else:
			create_tween().tween_property(self, "grow", 1.0, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	func _draw() -> void:
		var x := (size.x - 16.0) * 0.5
		draw_rect(Rect2(x, BAR_TOP, 16, BAR_H), TRACK, true)
		var h := BAR_H * clampf(value / 100.0, 0.0, 1.0) * grow
		draw_rect(Rect2(x, BAR_TOP + BAR_H - h, 16, h), colour, true)
		if gold_dot:
			draw_circle(Vector2(size.x * 0.5, BAR_TOP + BAR_H + 6.0), 4.0, WoodKit.HEAD)


class TickBar extends Control:
	var value := 0.0
	## Where the white tick sits (0-100); below 0 or from 100 there is no tick (the mood bar has none).
	var tick_at := 80.0
	var colour := Color.WHITE
	var show_zone := false
	var grow := 0.0:
		set(v):
			grow = v
			queue_redraw()

	func _ready() -> void:
		if MenuFx.instant:
			grow = 1.0
		else:
			create_tween().tween_property(self, "grow", 1.0, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	func _draw() -> void:
		var y := 4.0
		var h := 10.0
		var w := size.x
		draw_rect(Rect2(0, y, w, h), TRACK, true)
		var has_tick := tick_at >= 0.0 and tick_at < 100.0
		if show_zone and has_tick:
			var zx := w * (tick_at / 100.0)
			draw_rect(Rect2(zx, y, w - zx, h), Color(UI.RED, 0.42), true)
		var fill_w := w * clampf(value / 100.0, 0.0, 1.0) * grow
		draw_rect(Rect2(0, y, fill_w, h), colour, true)
		if has_tick:
			var tx := w * (tick_at / 100.0)
			draw_rect(Rect2(tx - 1.5, y - 4.0, 3.0, h + 8.0), WoodKit.INK, true)


## A small envelope drawn on the need badge (the painting's mark for "a message waits").
class Envelope extends Control:
	func _draw() -> void:
		var r := Rect2(size.x * 0.24, size.y * 0.32, size.x * 0.52, size.y * 0.36)
		draw_rect(r, WoodKit.INK, false, 2.0)
		draw_polyline(PackedVector2Array([r.position, Vector2(r.get_center().x, r.position.y + r.size.y * 0.55),
			Vector2(r.end.x, r.position.y)]), WoodKit.INK, 2.0, true)
