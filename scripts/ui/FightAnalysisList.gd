extends VBoxContainer
## FIGHTPAGE1 THE PUNCHES (mockup docs/mockups/s495/fight_analysis/fight_analysis_v3.html, map FIGHTFILM1 v3 2.1): SHOW ME
## pickers, the count line, the camera line under an After pick, and one list for both corners in order with a divider each
## exchange naming their game. The list is virtual: a small pool of rows is laid over the visible part of the scroll, so a
## 200-line bout never builds 200 rows. Also the page's shared helpers (lines over a bout, punch words, game words).
##   var l = FightAnalysisList.new(); l.build(); l.load_lines(film_lines(film)); l.picked -> shown index

signal picked(i: int)

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const FightLog := preload("res://scripts/rules/FightLog.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")

## The game in words, with no one named (S512: on your own bout both corners share one list, and "Round 2 - walks the other
## down" had no subject; a picker, a divider and the report's legend read these as they are).
const GAME_WORDS := {"press": "pressing forward", "range": "boxing at range", "counter": "waiting to counter",
	"loadup": "loading up big shots", "tiring": "tiring", "hurt": "hurt"}
const PUNCH_ORDER := ["jab", "cross", "hook", "uppercut"]
const PUNCH_PLURAL := {"jab": "jabs", "cross": "crosses", "hook": "hooks", "uppercut": "uppercuts", "": "punches"}
const RESULT_ORDER := ["Landed", "Clean", "Blocked", "Slipped", "Missed"]
const RANGE_ORDER := ["long", "mid", "inside", "ropes"]
const AFTER_ORDER := ["guard up", "right low", "left low", "lunged in", "stood still", "threw on"]
## [pick key, picker word, first item]
const PICKERS := [["hand", "Hand", "Any"], ["punch", "Punch", "Any"], ["result", "Result", "Any"], ["range", "Range", "Any"],
	["round", "Round", "All"], ["game", "Their game", "Any"], ["after", "After", "Any"]]
const ORDERS := {"hand": ["lead", "rear"], "punch": PUNCH_ORDER, "result": RESULT_ORDER, "range": RANGE_ORDER,
	"after": AFTER_ORDER, "round": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]}
const ROW_PX := 27
const SIT_PX := 24
const TXT := 16

var all: Array = []
var shown: Array = []
var sel := -1
var picks: Dictionary = {}
var count_label: Label
var camera_label: Label
var _corner_btns: Dictionary = {}
var _opts: Dictionary = {}
var _scroll: ScrollContainer
var _content: Control
var _items: Array = []
var _pool: Array = []
var _cols: Dictionary = {}
var _f := 1.0

# --- shared helpers ------------------------------------------------------------------------------------------------

## Every punch line of a FilmBout.build bout, round by round (FightLog.lines takes one round's exchanges).
static func film_lines(film: Dictionary) -> Array:
	var out: Array = []
	var exs: Array = film.get("exchanges", [])
	for rn in range(1, int(film.get("rounds", 3)) + 1):
		out.append_array(FightLog.lines(exs.filter(func(e): return int((e as Dictionary).get("round", 1)) == rn), rn))
	return out

## "Jab", "Lead hook", "Rear uppercut" (the hand only where it tells something).
static func punch_name(line: Dictionary) -> String:
	var p: String = str(line.get("punch", ""))
	if p == "jab" or p == "cross":
		return p.capitalize()
	return "%s %s" % [str(line.get("hand", "")).capitalize(), p]

## The report's name for a punch: Jab, Cross, Body cross, Lead hook, Rear hook, Body hook, Uppercut.
static func report_name(line: Dictionary) -> String:
	var p: String = str(line.get("punch", ""))
	var body: bool = str(line.get("target", "")) == "body"
	if p == "uppercut":
		return "Uppercut"
	if body and (p == "hook" or p == "cross"):
		return "Body " + p
	return punch_name(line)

static func clock_words(line: Dictionary) -> String:
	return "R%d %s" % [int(line.get("round", 1)), FightLog.clock(float(line.get("t", 0.0)))]

static func game_word(mode: String) -> String:
	return str(GAME_WORDS.get(mode, mode))

## A filled circle for a corner dot inside a button.
static func dot_icon(c: Color, px: int) -> ImageTexture:
	var img := Image.create(px, px, false, Image.FORMAT_RGBA8)
	var r: float = float(px) * 0.5
	for y in px:
		for x in px:
			var d: float = Vector2(float(x) + 0.5 - r, float(y) + 0.5 - r).length()
			img.set_pixel(x, y, c if d <= r - 0.5 else Palette.CLEAR)
	return ImageTexture.create_from_image(img)

static func text_w(text: String, kind: String, px: int) -> float:
	return UI.font(kind).get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x

## The camera line: what the ringside camera saw after the picked punch (FightLog.seen_count over the lines it saw).
static func camera_words(lines: Array, punch: String, after: String) -> String:
	var seen: Array = []
	var total := 0
	for l in lines:
		var ld: Dictionary = l
		total += 1 if str(ld["who"]) == "b" and (punch == "" or str(ld["punch"]) == punch) else 0
		if str(ld["who"]) == "b" and str(ld["after"]) != "":
			seen.append(ld)
	var sc: Dictionary = FightLog.seen_count(seen, punch, after)
	var k: int = int(sc["k"])
	var n: int = int(sc["n"])
	if punch == "":
		k += int(sc["k_other"])
		n += int(sc["n_other"])
	return "seen on camera: %s after %d of %d %s - %d not seen" % [after, k, n, str(PUNCH_PLURAL.get(punch, "punches")), total - n]

# --- build -----------------------------------------------------------------------------------------------------------

func build() -> void:
	name = "Punches"
	_f = TextScale.factor()
	add_theme_constant_override("separation", 8)
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(UI.label("SHOW ME", TXT, Palette.MUTED, "caps"))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 7)
	flow.add_theme_constant_override("v_separation", 7)
	add_child(flow)
	for c in [["b", "Them", Palette.BLUE_CORNER], ["a", "The other", Palette.RED_CORNER], ["", "Both", Palette.CLEAR]]:
		var key: String = str(c[0])
		var b := UI.button(str(c[1]), "Pill", set_corner.bind(key))
		b.name = "Corner_" + (key if key != "" else "both")
		var col: Color = c[2]
		if col.a > 0.0:
			b.icon = dot_icon(col, 12)
		_corner_btns[key] = b
		flow.add_child(b)
	for p in PICKERS:
		flow.add_child(_picker(str(p[0]), str(p[1]), str(p[2])))
	count_label = UI.label("", TXT, Palette.MUTED, "semi")
	count_label.name = "CountLine"
	add_child(count_label)
	camera_label = UI.label("", TXT, Palette.TEXT, "semi", true)
	camera_label.name = "CameraLine"
	camera_label.custom_minimum_size.x = 300
	camera_label.visible = false
	add_child(camera_label)
	_measure()
	add_child(_head_row())
	_scroll = ScrollContainer.new()
	_scroll.name = "ListScroll"
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.custom_minimum_size.y = 120
	_content = Control.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.mouse_filter = Control.MOUSE_FILTER_PASS
	_scroll.add_child(_content)
	add_child(_scroll)
	_scroll.get_v_scroll_bar().value_changed.connect(func(_v: float): _layout())
	_scroll.resized.connect(_layout)
	_content.resized.connect(_layout)
	_mark_corner()

func _picker(key: String, word: String, first: String) -> Control:
	var h := UI.hbox(4)
	h.add_child(UI.label(word, TXT, Palette.MUTED, "semi"))
	var o := OptionButton.new()
	o.name = "Pick_" + key
	o.fit_to_longest_item = false
	o.focus_mode = Control.FOCUS_NONE
	o.add_theme_font_override("font", UI.font("semi"))
	o.add_theme_font_size_override("font_size", TXT)
	for st in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		o.add_theme_color_override(st, Palette.TEXT)
	o.add_item(first)
	o.set_item_metadata(0, 0 if key == "round" else "")
	o.item_selected.connect(func(i: int): _on_pick(key, o.get_item_metadata(i)))
	_opts[key] = o
	_style_pick(o, false)
	h.add_child(o)
	return h

func _style_pick(o: OptionButton, on: bool) -> void:
	var edge: Color = Palette.CHOSEN if on else Palette.LINE
	for st in ["normal", "hover", "pressed", "disabled", "focus"]:
		o.add_theme_stylebox_override(st, UI.box(Palette.TILE, Palette.CHOSEN if st == "hover" else edge, 4, 2 if on else 1, 8, 2))

func _measure() -> void:
	var px: int = TextScale.scaled(TXT, _f)
	_cols = {"clock": _widest(["R3 2:59", "R3 0:00", "R1 1:11"], "semi", px), "range": _widest(RANGE_ORDER, "semi", px),
		"after": _widest(AFTER_ORDER, "semi", px), "result": _widest(RESULT_ORDER, "bold", px),
		"dot": 12.0, "row_h": round(float(ROW_PX) * _f), "sit_h": round(float(SIT_PX) * _f)}

static func _widest(words: Array, kind: String, px: int) -> float:
	var w := 0.0
	for t in words:
		w = maxf(w, text_w(str(t), kind, px))
	return w + 4.0

func _cell(text: String, w: float, color: Color, kind: String, right: bool = false) -> Label:
	var l := UI.label(text, TXT, color, kind)
	l.clip_text = true
	l.custom_minimum_size.x = w
	l.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN if w > 0.0 else Control.SIZE_EXPAND_FILL
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if right:
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	return l

func _head_row() -> Control:
	var h := UI.hbox(8)
	h.name = "ListHead"
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 8)
	m.add_theme_constant_override("margin_right", 14)
	m.add_child(h)
	for c in [["CLOCK", "clock"], ["", "dot"], ["PUNCH", ""], ["RANGE", "range"], ["AFTER", "after"], ["RESULT", "result"]]:
		var key: String = str(c[1])
		var w: float = float(_cols.get(key, 0.0))
		var l := _cell(str(c[0]), w, Palette.MUTED, "caps", key == "result")
		h.add_child(l)
		if str(c[0]) != "" and w > 0.0:
			TextScale.fit(l, w, TXT - 2, 10)
	return m

# --- data --------------------------------------------------------------------------------------------------------------

## A new film's lines: pickers refilled from them (Any first), every filter cleared, the first line selected.
func load_lines(lines: Array) -> void:
	all = lines
	picks = {}
	for p in PICKERS:
		_fill(str(p[0]))
	_mark_corner()
	_apply(-1)

func _fill(key: String) -> void:
	var o: OptionButton = _opts[key]
	while o.item_count > 1:
		o.remove_item(o.item_count - 1)
	o.select(0)
	_style_pick(o, false)
	var found: Dictionary = {}
	for l in all:
		var ld: Dictionary = l
		var v = ld.get(key if key != "game" else "sit", "")
		if str(v) != "" and str(v) != "0":
			found[v] = true
	var order: Array = ORDERS.get(key, GAME_WORDS.keys())
	for v in order:
		if not found.has(v):
			continue
		var words: String = game_word(str(v)) if key == "game" else (str(v) if key == "round" or key == "after" else str(v).capitalize())
		o.add_item(words)
		o.set_item_metadata(o.item_count - 1, v)

func _on_pick(key: String, v) -> void:
	picks[key] = int(v) if key == "round" else str(v)
	_style_pick(_opts[key], str(v) != "" and str(v) != "0")
	_apply(_cur_line_id())

## Sets one picker by value (the After cell, a test); false when the value is not offered.
func set_pick(key: String, v) -> bool:
	var o: OptionButton = _opts[key]
	for i in o.item_count:
		if str(o.get_item_metadata(i)) == str(v):
			o.select(i)
			_on_pick(key, o.get_item_metadata(i))
			return true
	return false

func set_corner(key: String) -> void:
	picks["corner"] = key
	_mark_corner()
	_apply(_cur_line_id())

func _mark_corner() -> void:
	var cur: String = str(picks.get("corner", ""))
	for k in _corner_btns:
		(_corner_btns[k] as Button).theme_type_variation = "PillOn" if str(k) == cur else "Pill"

## Shows every line again (a combination time outside the filter).
func clear_picks() -> void:
	picks = {}
	for p in PICKERS:
		var o: OptionButton = _opts[str(p[0])]
		o.select(0)
		_style_pick(o, false)
	_mark_corner()

func _cur_line_id() -> int:
	return all.find(shown[sel]) if sel >= 0 and sel < shown.size() else -1

func _apply(keep_id: int) -> void:
	shown = FightLog.filter(all, picks)
	count_label.text = FightLog.count_line(shown, all)
	var after: String = str(picks.get("after", ""))
	camera_label.visible = after != ""
	if after != "":
		camera_label.text = camera_words(all, str(picks.get("punch", "")), after)
	var at: int = shown.find(all[keep_id]) if keep_id >= 0 else -1
	sel = at if at >= 0 else (0 if not shown.is_empty() else -1)
	_rebuild_items()
	picked.emit(sel)

func _rebuild_items() -> void:
	_items = []
	var y := 0.0
	var last_ex := -1
	var rh: float = float(_cols["row_h"])
	var sh: float = float(_cols["sit_h"])
	for i in shown.size():
		var ld: Dictionary = shown[i]
		var ex_key: int = int(ld["round"]) * 100 + int(ld["ex"])
		if ex_key != last_ex:
			last_ex = ex_key
			var words: String = "Round %d - %s" % [int(ld["round"]), game_word(str(ld["sit"]))]
			_items.append({"sit": words.to_upper(), "y": y, "h": sh})
			y += sh
		_items.append({"i": i, "y": y, "h": rh})
		y += rh
	_content.custom_minimum_size.y = y
	_layout()

## Shown index -> select it, keep it on screen, tell the page.
func select(i: int) -> void:
	if i < 0 or i >= shown.size():
		return
	sel = i
	for it in _items:
		var itd: Dictionary = it
		if int(itd.get("i", -1)) == i:
			var top: float = float(itd["y"])
			if top < float(_scroll.scroll_vertical) or top + float(itd["h"]) > float(_scroll.scroll_vertical) + _scroll.size.y:
				_scroll.scroll_vertical = int(maxf(0.0, top - _scroll.size.y * 0.4))
			break
	_layout()
	picked.emit(sel)

## Selects a line by its dict (combination time); clears the filter first when it is hidden.
func select_line(line: Dictionary) -> void:
	var at: int = shown.find(line)
	if at < 0:
		clear_picks()
		_apply(all.find(line))
		at = shown.find(line)
	select(at)

func line_rows() -> int:
	return _items.filter(func(it): return (it as Dictionary).has("i")).size()

# --- the virtual list ------------------------------------------------------------------------------------------------

func _layout() -> void:
	if _content == null:
		return
	var top: float = float(_scroll.scroll_vertical)
	var bottom: float = top + maxf(_scroll.size.y, 1.0)
	var w: float = _content.size.x
	var used := 0
	for it in _items:
		var itd: Dictionary = it
		var y: float = float(itd["y"])
		var h: float = float(itd["h"])
		if y + h < top or y > bottom:
			continue
		if used >= _pool.size():
			_pool.append(_new_row())
		var row: Control = _pool[used]
		used += 1
		row.visible = true
		row.position = Vector2(0, y)
		row.size = Vector2(w, h)
		_fill_row(row, itd)
	for j in range(used, _pool.size()):
		(_pool[j] as Control).visible = false

func _new_row() -> Control:
	var row := Control.new()
	row.mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := Panel.new()
	bg.name = "Bg"
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.add_child(bg)
	var h := UI.hbox(8)
	h.name = "Cells"
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h.offset_left = 8
	h.offset_right = -8
	row.add_child(h)
	h.add_child(_cell("", float(_cols["clock"]), Palette.MUTED, "semi"))
	h.add_child(UI.dot(Palette.BLUE_CORNER))
	h.add_child(_cell("", 0.0, Palette.TEXT, "body"))
	h.add_child(_cell("", float(_cols["range"]), Palette.MUTED, "semi"))
	var after := _cell("", float(_cols["after"]), Palette.TEXT, "semi")
	after.mouse_filter = Control.MOUSE_FILTER_STOP
	after.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	after.gui_input.connect(_after_click.bind(row))
	h.add_child(after)
	h.add_child(_cell("", float(_cols["result"]), Palette.MUTED, "bold", true))
	var sit := _cell("", 0.0, Palette.HEADER, "caps")
	sit.name = "Sit"
	sit.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sit.offset_left = 8
	row.add_child(sit)
	row.gui_input.connect(_row_click.bind(row))
	_content.add_child(row)
	return row

func _fill_row(row: Control, it: Dictionary) -> void:
	var bg: Panel = row.get_node("Bg")
	var cells: HBoxContainer = row.get_node("Cells")
	var sit: Label = row.get_node("Sit")
	row.set_meta("i", int(it.get("i", -1)))
	if it.has("sit"):
		cells.visible = false
		sit.visible = true
		sit.text = str(it["sit"])
		TextScale.fit(sit, maxf(row.size.x - 16.0, 40.0), TXT, 12)
		bg.add_theme_stylebox_override("panel", UI.box(Color(Palette.HEADER, 0.06), Palette.CLEAR, 0, 0, 0, 0))
		return
	cells.visible = true
	sit.visible = false
	var i: int = int(it["i"])
	var ld: Dictionary = shown[i]
	var on: bool = i == sel
	bg.add_theme_stylebox_override("panel", UI.box(Palette.TILE if on else Palette.CLEAR, Palette.CHOSEN if on else Palette.CLEAR, 2, 2, 0, 0))
	var c: Array = cells.get_children()
	(c[0] as Label).text = clock_words(ld)
	(c[1] as ColorRect).color = Palette.BLUE_CORNER if str(ld["who"]) == "b" else Palette.RED_CORNER
	var p: Label = c[2]
	p.text = "%s to the %s" % [punch_name(ld), str(ld["target"])]
	TextScale.fit(p, maxf(row.size.x - 16.0 - _fixed_w(), 30.0), TXT, 12)
	(c[3] as Label).text = str(ld["range"])
	var after: String = str(ld["after"])
	(c[4] as Label).text = after if after != "" else "-"
	var r: Label = c[5]
	var res: String = str(ld["result"])
	r.text = res
	r.add_theme_color_override("font_color", Palette.GOOD if res == "Landed" or res == "Clean" else Palette.MUTED)
	r.add_theme_font_override("font", UI.font("bold" if res == "Clean" else "semi"))

func _fixed_w() -> float:
	return float(_cols["clock"]) + float(_cols["dot"]) + float(_cols["range"]) + float(_cols["after"]) + float(_cols["result"]) + 40.0

static func _click(ev: InputEvent) -> bool:
	return ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT

func _row_click(ev: InputEvent, row: Control) -> void:
	if _click(ev) and int(row.get_meta("i", -1)) >= 0:
		select(int(row.get_meta("i", -1)))

func _after_click(ev: InputEvent, row: Control) -> void:
	var i: int = int(row.get_meta("i", -1))
	if _click(ev) and i >= 0 and i < shown.size():
		var a: String = str((shown[i] as Dictionary)["after"])
		if a != "":
			get_viewport().set_input_as_handled()
			set_pick("after", a)

# --- the timeline under the film: three rounds, a tick a shown line, the cursor at the selected one ---------------------

func _x_of(l: Dictionary, w: float, rounds: int) -> float:
	return (float(int(l["round"]) - 1) * 180.0 + float(l["t"])) / (180.0 * float(rounds)) * w

func draw_timeline(c: Control, rounds: int) -> void:
	var sz: Vector2 = c.size
	c.draw_rect(Rect2(Vector2.ZERO, sz), Palette.PAGE)
	c.draw_rect(Rect2(Vector2.ZERO, sz), Palette.LINE, false, 1.0)
	var px: int = TextScale.scaled(11, TextScale.factor())
	for r in rounds:
		var x: float = sz.x * float(r) / float(rounds)
		if r > 0:
			c.draw_dashed_line(Vector2(x, 0), Vector2(x, sz.y), Palette.LINE, 1.0, 4.0)
		c.draw_string(UI.font("bold"), Vector2(x + 3.0, float(px)), "R%d" % (r + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, px, Palette.MUTED)
	for l in shown:
		c.draw_rect(Rect2(_x_of(l, sz.x, rounds), 9.0, 3.0, sz.y - 16.0), Color(Palette.MUTED, 0.8))
	if sel >= 0 and sel < shown.size():
		c.draw_rect(Rect2(_x_of(shown[sel], sz.x, rounds), -4.0, 2.0, sz.y + 8.0), Palette.TEXT)

## A click on the timeline selects the nearest shown line.
func timeline_click(ev: InputEvent, c: Control, rounds: int) -> void:
	if not _click(ev):
		return
	var x: float = (ev as InputEventMouseButton).position.x
	var best := -1
	var gap := INF
	for i in shown.size():
		var d: float = absf(_x_of(shown[i], c.size.x, rounds) - x)
		if d < gap:
			gap = d
			best = i
	select(best)
