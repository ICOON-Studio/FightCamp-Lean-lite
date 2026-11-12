extends Node
## S444 Q-196 (operator: "Show me it in the game first"): the UX audit's fight-screen regroup
## (docs/mockups/s442/ux/ux_c_fight_hud.png), as a PREVIEW only: on when the run has the user arg `hudregroup`, off in the
## game the player gets until he says yes. It moves what is already built; it adds no reading of its own.
##   1. The two full-height body holos (BodyPanels, 320 x 540 over the ring) become small maps under the name plates;
##      each hit count sits on its organ's picture (his C331: "instead of empty circle use the organ icon").
##   2. One read of her mode: the box over her head (IntentChip1) and the habit card in the bar go.
##   3. Speed / Skip round / Skip bout sit at 35% until the mouse is near them (full in 0.12 s, back after 1.5 s).
##   4. STAMINA / LEGS / GUARD in capitals (his Q-195 "Stamina"; C330 point 4 "what is energy ? is it stamina ?").
##   5. Our call box leaves her head: it stands off to the side on a thin line to her, bright when the call changes, then
##      fades (his C330 point 2).
##   6. The round box loses its wood: a see-through dark box (his C330 point 1; C327 on the bubbles: "make it transparent").
##   7. Her plate is the corner's read in words, not game bars (his C330 point 3: "reminds way too much other games").
##   attach(view) -> HudRegroup (null when the preview is off)   enabled() -> bool   read_word(kind, value) -> String

const SMALL := [Rect2(16, 232, 176, 270), Rect2(1728, 232, 176, 270)]   # under each plate's bars, at its outer edge
const NUM_SHIFT := 34.0   # STAMINA is wider than "energy": the number moves right so the two never touch
const DIM := 0.35
const NEAR_PX := 260.0
const UP_S := 0.12
const HOLD_S := 1.5
const CONTROLS := ["Speed", "SkipRound", "SkipBout"]
const CHIP_OFF := Vector2(-230, 46)   # our call box: left of her head and a little lower, off the head and the gloves
const CHIP_BRIGHT_S := 2.5
const CHIP_REST := 0.4
const KINDS := ["Energy", "Legs", "Guard"]
const READ := {
	"Energy": [[80, "Fresh"], [60, "Working"], [40, "Tiring"], [0, "Running on empty"]],
	"Legs": [[80, "Light on her feet"], [60, "Legs working"], [40, "Legs heavy"], [0, "Legs gone"]],
	"Guard": [[80, "Guard tight"], [60, "Guard holding"], [40, "Guard slipping"], [0, "Hands down"]],
}
const READ_COL := [Color("#7fd18b"), Color("#f2c14e"), Color("#ff9a3c"), Color("#e2483d")]

var view: Control
var _hold := 0.0
var _alpha := DIM
var _line: Line
var _chip_word := ""
var _chip_t := 0.0
var _notes: Array = []


class Line extends Control:
	var a := Vector2.ZERO
	var b := Vector2.ZERO
	var col := Color(1, 1, 1, 0.8)
	func _draw() -> void:
		if a == b:
			return
		draw_line(a, b, col, 3.0, true)
		draw_circle(b, 5.0, col)


static func enabled() -> bool:
	return OS.get_cmdline_user_args().has("hudregroup")


static func attach(v: Control) -> Node:
	if not enabled():
		return null
	var r := new()
	r.name = "HudRegroup"
	r.view = v
	r.process_priority = 100   # after IntentChip and SidePanel have placed themselves this frame
	v.add_child(r)
	return r


## The corner's word for a reading 0-100 (her stamina is a scouted range: pass its middle).
static func read_word(kind: String, value: float) -> String:
	for step in READ.get(kind, []):
		if value >= float(step[0]):
			return str(step[1])
	return ""


static func _band(value: float) -> int:
	return 0 if value >= 80.0 else (1 if value >= 60.0 else (2 if value >= 40.0 else 3))


func _process(delta: float) -> void:
	if view == null:
		return
	_small_maps()
	_one_read()
	_caps()
	_dim_controls(delta)
	_call_box(delta)
	_glass_bug()
	_notepad()
	_costs()
	_shout_cloud()


## His C334 point 7: "display the stamina cost ... with icons+numbers": each call's card shows a stamina cell and the
## stamina it takes (or gives back) each exchange, instead of "Rests" / "Tires".
func _costs() -> void:
	var bar := view.find_child("CornerBar", true, false)
	if bar == null:
		return
	for lab in bar.find_children("Cost_*", "Label", true, false):
		var l := lab as Label
		if l.has_meta("shown") or not l.has_meta("cost"):
			continue
		var cost := float(l.get_meta("cost"))
		var delta := -cost
		l.text = "        %s%s" % ["+" if delta > 0.0 else "", ("%.1f" % delta).trim_suffix(".0")] if delta != 0.0 else "        0"
		l.add_theme_color_override("font_color", Color("#7fd18b") if delta > 0.0 else (Color("#ff8a6a") if delta < 0.0 else Color("#d8d0c0")))
		l.tooltip_text = "Stamina each exchange while this call runs"
		var cell := Cell.new()
		cell.position = Vector2(0, 3)
		cell.size = Vector2(26, 16)
		l.add_child(cell)
		l.set_meta("shown", true)


## A small stamina cell in the STAMINA bar's yellow (the icon for the number beside it).
class Cell extends Control:
	func _draw() -> void:
		var y := Color("#f2c14e")
		draw_rect(Rect2(0, 0, 22, 16), y, false, 2.0)
		draw_rect(Rect2(22, 5, 3, 6), y)
		draw_rect(Rect2(3, 3, 12, 10), y)


## His C334 points 4-6: "use a cloud-like icon for the text and move it towards the corner it's coming from": our corner's
## shout leaves the bottom middle for a speech cloud by our side (left); any other caption stays where it was.
var _cap_home := {}
var _cloud_on := false
var _cloud_text := ""
var _tail: Control


func _shout_cloud() -> void:
	var box := view.get("_cap_box") as Control
	var cap := view.get("_caption") as Label
	if box == null or cap == null:
		return
	if _cap_home.is_empty():
		_cap_home = {"al": box.anchor_left, "at": box.anchor_top, "ar": box.anchor_right, "ab": box.anchor_bottom,
			"ol": box.offset_left, "ot": box.offset_top, "or": box.offset_right, "ob": box.offset_bottom,
			"sb": box.get_theme_stylebox("panel")}
	var t := cap.text
	if t.begins_with("Corner: "):
		cap.text = t.trim_prefix("Corner: ").trim_prefix("\"").trim_suffix("\"")
		_cloud_text = cap.text
		if not _cloud_on:
			_cloud_on = true
			box.set_anchors_preset(Control.PRESET_TOP_LEFT)
			box.position = Vector2(210, 520)
			box.size = Vector2(440, 64)
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.97, 0.95, 0.9, 0.94)
			sb.set_corner_radius_all(32)
			sb.content_margin_left = 22
			sb.content_margin_right = 22
			box.add_theme_stylebox_override("panel", sb)
			cap.add_theme_color_override("font_color", Color("#2a1d14"))
			cap.add_theme_constant_override("outline_size", 0)
			if _tail == null:
				_tail = Tail.new()
				_tail.name = "CloudTail"
				view.add_child(_tail)
	if _tail != null:   # outside the bubble: a PanelContainer lays out its own children
		_tail.visible = _cloud_on and box.visible
		_tail.position = box.position + Vector2(34, box.size.y - 2.0)
	if t.begins_with("Corner: "):
		pass
	elif t != "" and _cloud_on and t != _cloud_text:
		_cloud_on = false
		box.anchor_left = _cap_home["al"]; box.anchor_top = _cap_home["at"]
		box.anchor_right = _cap_home["ar"]; box.anchor_bottom = _cap_home["ab"]
		box.offset_left = _cap_home["ol"]; box.offset_top = _cap_home["ot"]
		box.offset_right = _cap_home["or"]; box.offset_bottom = _cap_home["ob"]
		box.add_theme_stylebox_override("panel", _cap_home["sb"])
		cap.remove_theme_color_override("font_color")
		cap.add_theme_constant_override("outline_size", 8)


## The cloud's tail, pointing down to our side of the ring.
class Tail extends Control:
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		size = Vector2(60, 40)
	func _draw() -> void:
		var c := Color(0.97, 0.95, 0.9, 0.94)
		draw_colored_polygon(PackedVector2Array([Vector2(8, 0), Vector2(44, 0), Vector2(-6, 30)]), c)


func _small_maps() -> void:
	var live: Node = view.get("body")
	if live == null:
		return
	var holo: Node = live.get("holo")
	if holo == null:
		return
	var panels: Array = holo.get("panels")
	var figures: Array = holo.get("figures")
	for side in panels.size():
		var p := panels[side] as Control
		var r: Rect2 = SMALL[side]
		if p.position != r.position or p.size != r.size:
			if side < figures.size():
				(figures[side] as Control).custom_minimum_size = r.size
			p.custom_minimum_size = r.size
			p.position = r.position
			p.size = r.size
	for layer in holo.get("words"):
		if layer != null and not bool((layer as Node).get("icons")):
			(layer as Node).set("size_px", 20)
			(layer as Node).set("icons", true)
			(layer as CanvasItem).queue_redraw()


func _one_read() -> void:
	var chip := view.get_node_or_null("IntentChip1") as CanvasItem
	if chip != null and chip.visible:
		chip.visible = false
	var card := view.find_child("HabitCard", true, false) as CanvasItem
	if card != null and card.visible:
		card.visible = false


func _caps() -> void:
	for w in KINDS:
		for side in 2:
			var panel := view.get_node_or_null("SidePanel%d" % side)
			if panel == null:
				continue
			var lab := panel.find_child(w + "Word", true, false) as Label
			var want: String = "STAMINA" if w == "Energy" else w.to_upper()
			if lab != null and lab.text != want:
				lab.text = want
				var num := panel.find_child(w + "Num", true, false) as Control
				if num != null:
					num.position.x += NUM_SHIFT


func _dim_controls(delta: float) -> void:
	var bar := view.find_child("CornerBar", true, false) as Control
	if bar == null:
		return
	var nodes: Array = []
	var box := Rect2()
	for n in CONTROLS:
		var c := bar.find_child(n, true, false) as Control
		if c == null:
			continue
		nodes.append(c)
		var g := c.get_global_rect()
		box = g if box.size == Vector2.ZERO else box.merge(g)
	if nodes.is_empty():
		return
	if box.grow(NEAR_PX).has_point(view.get_global_mouse_position()):
		_hold = HOLD_S
	else:
		_hold = maxf(0.0, _hold - delta)
	var goal := 1.0 if _hold > 0.0 else DIM
	var step := delta * (1.0 - DIM) / UP_S if goal > _alpha else delta * (1.0 - DIM) / 0.4
	_alpha = move_toward(_alpha, goal, step)
	for c in nodes:
		(c as CanvasItem).modulate.a = _alpha


## IntentChip0 has placed itself over her head this frame: stand it off to the side, draw the line back to the head.
func _call_box(delta: float) -> void:
	var chip := view.get_node_or_null("IntentChip0") as Control
	if _line == null:
		_line = Line.new()
		_line.name = "CallLine"
		_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_line.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		view.add_child(_line)
	if chip == null or not chip.visible:
		_line.visible = false
		return
	var word_l := chip.find_child("ChipWord", true, false) as Label
	var word := word_l.text if word_l != null else ""
	if word != _chip_word:
		_chip_word = word
		_chip_t = CHIP_BRIGHT_S
	_chip_t = maxf(0.0, _chip_t - delta)
	var head := chip.position + Vector2(chip.size.x * 0.5, chip.size.y)
	var to := chip.position + CHIP_OFF
	to.x = maxf(SMALL[0].end.x + 12.0, to.x)
	chip.position = to
	var bright := clampf(_chip_t / 0.6, 0.0, 1.0) if _chip_t < 0.6 else 1.0
	var a := lerpf(CHIP_REST, 1.0, bright)
	chip.modulate.a = a
	_line.visible = true
	_line.a = to + Vector2(chip.size.x, chip.size.y * 0.5)
	_line.b = head + Vector2(0, 14)
	_line.col = Color(1, 0.55, 0.5, 0.85 * a)
	_line.queue_redraw()


func _glass_bug() -> void:
	var bug := view.get("_bug_box") as Control
	if bug == null or bug.has_meta("glass"):
		return
	for child in bug.get_children():
		if child is Panel:
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.05, 0.05, 0.07, 0.55)
			sb.set_corner_radius_all(14)
			(child as Panel).add_theme_stylebox_override("panel", sb)
			break
	bug.set_meta("glass", true)


## Her plate: the bars, numbers and labels give way to three lines of what the corner reads off her.
func _notepad() -> void:
	var panel := view.get_node_or_null("SidePanel1") as Control
	if panel == null:
		return
	if _notes.is_empty():
		for i in KINDS.size():
			var lab := Label.new()
			lab.name = "Read" + KINDS[i]
			lab.add_theme_font_size_override("font_size", 26)
			lab.add_theme_constant_override("outline_size", 6)
			lab.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
			lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			lab.position = Vector2(140, 74.0 + float(i) * 36.0)
			lab.size = Vector2(450, 34)
			panel.add_child(lab)
			_notes.append(lab)
	for i in KINDS.size():
		var k: String = KINDS[i]
		for part in ["Word", "Num", "Bar"]:
			var n := panel.find_child(k + part, true, false) as CanvasItem
			if n != null and n.visible:
				n.visible = false
		var num := panel.find_child(k + "Num", true, false) as Label
		var v := _mid(num.text if num != null else "")
		var lab := _notes[i] as Label
		lab.visible = v >= 0.0
		if v >= 0.0:
			lab.text = read_word(k, v) + ("  (a guess)" if num != null and num.text.contains("-") else "")
			lab.add_theme_color_override("font_color", READ_COL[_band(v)])


static func _mid(text: String) -> float:
	var t := text.strip_edges()
	if t == "":
		return -1.0
	if t.contains("-"):
		var p := t.split("-")
		return (p[0].to_float() + p[1].to_float()) * 0.5
	return t.to_float()
