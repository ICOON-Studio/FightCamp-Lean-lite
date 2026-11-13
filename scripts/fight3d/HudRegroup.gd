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

const ReactionBubbles := preload("res://scripts/fight3d/ReactionBubbles.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const SMALL := [Rect2(8, 228, 200, 320), Rect2(1712, 228, 200, 320)]   # under each plate's bars, at its outer edge (S452 C363 bigger)
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
	"Legs": [[80, "Light on the feet"], [60, "Legs working"], [40, "Legs heavy"], [0, "Legs gone"]],
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
	_shout_cloud(delta)


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


## S445 his "should we make this fill up with time and make it the shout call ?" -> "Yes, build it": the corner's shout and
## the call box are ONE thing. A call is picked in the pause at an exchange and runs for that exchange's 30 seconds, so the
## shout ("Feint! Draw the lead!") stands where the call box stands, on the line to her head, tagged at once Heard / Half
## heard / Not heard (ReactionBubbles.heard_word, the game's shout rule), and a wash fills it as the exchange plays out
## (the corner bar's ring: the one counter). Full = the exchange is over: the tag turns to Worked / Did not work (the same
## result the CALLS WORKED box ticks), holds a moment, then gives way to the short call name, which fades (his C330 point 2).
const SHOUT_W := 440.0
const SHOUT_H := 64.0
const SHOUT_HOLD_S := 1.2
const SHOUT_TOP := 244.0   # under the CARDS row and the name plates
const SHOUT_OFF := Vector2(-80.0 - SHOUT_W, -96.0)   # up and left of her head: clear of the shoulders and gloves
var _shout_on := false   # a shout is filling or holding its tag
var _shout_text := ""
var _shout_f0 := 1.0     # the ring's share left when the shout began
var _shout_fill := 0.0
var _shout_hold := 0.0   # > 0: full, tagged, counting down
var _shout_tag := ""
var _shout_won := false  # the exchange this call runs in, already settled: shown only when the fill is full
var _sbox: PanelContainer   # the shout's own box: the game's caption line stays free for its other captions
var _slab: Label
var _wash: Wash
var _head := Vector2.ZERO


class Wash extends Control:
	var fill := 0.0
	var flash := 0.0
	var tag := ""
	var tag_col := Color.WHITE
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		var w := size.x * clampf(fill, 0.0, 1.0)
		if w > 1.0:
			var c := Color(0.08, 0.06, 0.04, 0.16 + 0.10 * flash)   # S448: a dark wash reads over a green, amber or red bubble
			draw_rect(Rect2(Vector2(10, 4), Vector2(maxf(0.0, w - 20.0), size.y - 8.0)), c)
		if tag != "":
			var f := ThemeDB.fallback_font
			var tw := f.get_string_size(tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
			var r := Rect2(Vector2(size.x - tw - 26.0, -16.0), Vector2(tw + 18.0, 28.0))
			draw_rect(r, tag_col)
			draw_string(f, r.position + Vector2(9, 21), tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("#14100c"))


## The ring's share of time left (1 = the wait just began, 0 = the exchange is here). -1 when there is no ring.
func _ring_left() -> float:
	var bar := view.find_child("CornerBar", true, false)
	if bar == null:
		return -1.0
	var ring: Variant = bar.get("_ring")
	return float((ring as Object).get("frac")) if ring != null else -1.0


func _shout_cloud(delta: float) -> void:
	var box := view.get("_cap_box") as Control
	var cap := view.get("_caption") as Label
	if box == null or cap == null:
		return
	if _sbox == null:
		_build_shout()
	var t := cap.text
	if t.begins_with("Corner: "):
		var said := t.trim_prefix("Corner: ").trim_prefix("\"").trim_suffix("\"")
		if said != _shout_text:
			_shout_begin(said)
		box.modulate.a = 0.0   # the corner's line is said in the shout box, not on the caption line
	elif box.modulate.a < 1.0:
		box.modulate.a = 1.0
	# The game's other path for the same shout: a bubble pinned to our corner post (S442 BUBBLES, when the post is on
	# screen). The shout box says it instead; the bubble never draws.
	var rbs := view.get_node_or_null("ReactionBubbles")
	if rbs != null:
		for e in rbs.get("live"):
			if str(e.get("kind", "")) != "shout" or not is_instance_valid(e["node"]):
				continue
			var node := e["node"] as CanvasItem
			if not node.has_meta("shout_taken"):
				node.set_meta("shout_taken", true)
				_shout_begin(_said_now())
			node.visible = false
	if not _shout_on:
		_sbox.visible = false
		_wash.visible = false
		return
	var left := _ring_left()
	if _shout_hold <= 0.0:
		if left < 0.0 or left > _shout_f0 + 0.05:   # a new exchange began: the ring refilled
			_shout_fill = 1.0
		else:
			_shout_fill = maxf(_shout_fill, clampf((_shout_f0 - left) / maxf(0.01, _shout_f0), 0.0, 1.0))
		if _shout_fill >= 0.999:
			_shout_hold = SHOUT_HOLD_S
			_shout_tag = "Worked" if _shout_won else "Did not work"
			_wash.tag_col = Color("#7fd18b") if _shout_won else Color("#ff8a6a")
	else:
		_shout_hold -= delta
		if _shout_hold <= 0.0:
			_shout_on = false   # said and in force: the call box on the line takes over, bright, then fading
			_chip_t = CHIP_BRIGHT_S
			_sbox.visible = false
			_wash.visible = false
			return
	_sbox.visible = true
	_wash.visible = true
	_wash.fill = _shout_fill
	_wash.flash = clampf(_shout_hold / SHOUT_HOLD_S, 0.0, 1.0)
	_wash.tag = _shout_tag
	_wash.position = _sbox.position
	_wash.size = _sbox.size
	_wash.queue_redraw()


## The shout's place: up and left of her head, never over the name plates or the small map.
## The side away from the middle of the ring: where the camera puts her right of centre, the shout goes to her right.
func _shout_at() -> Vector2:
	var right := _head.x > view.size.x * 0.5
	var x := _head.x + 80.0 if right else _head.x + SHOUT_OFF.x
	x = clampf(x, SMALL[0].end.x + 12.0, SMALL[1].position.x - 12.0 - SHOUT_W)
	return Vector2(x, maxf(SHOUT_TOP, _head.y + SHOUT_OFF.y))


## The corner's words for the exchange that just began (its call if taken in, else what was said).
func _said_now() -> String:
	var ex: Array = view.call("_exchanges") if view.has_method("_exchanges") else []
	if ex.is_empty() or not ex[-1] is Dictionary:
		return ""
	var x: Dictionary = ex[-1]
	var call := str(x["call"]) if bool(x.get("shout", false)) else str(x.get("said", ""))
	return str(Exchanges.CALLS.get(call, {}).get("shout", call))


func _build_shout() -> void:
	_sbox = PanelContainer.new()
	_sbox.name = "ShoutBox"
	_sbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.97, 0.95, 0.9, 0.94)
	sb.set_corner_radius_all(32)
	sb.content_margin_left = 22
	sb.content_margin_right = 22
	_sbox.add_theme_stylebox_override("panel", sb)
	_slab = Label.new()
	_slab.add_theme_font_size_override("font_size", 26)
	_slab.add_theme_color_override("font_color", Color("#2a1d14"))
	_slab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_slab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_sbox.add_child(_slab)
	_sbox.custom_minimum_size = Vector2(SHOUT_W, SHOUT_H)
	_sbox.size = Vector2(SHOUT_W, SHOUT_H)
	_sbox.visible = false
	view.add_child(_sbox)
	_wash = Wash.new()
	_wash.name = "ShoutWash"
	_wash.visible = false
	view.add_child(_wash)   # over the box: a see-through wash, the words still read through it


func _shout_begin(said: String) -> void:
	_shout_on = true
	_shout_text = said
	_slab.text = said
	_shout_fill = 0.0
	_shout_hold = 0.0
	var ex: Array = view.call("_exchanges") if view.has_method("_exchanges") else []
	var x: Dictionary = ex[-1] if not ex.is_empty() and ex[-1] is Dictionary else {}
	_shout_won = bool(x.get("won", false))
	_shout_tag = ReactionBubbles.heard_word(int(x.get("shouts_before", 0)), bool(x.get("shout", true)))
	_wash.tag_col = {"Heard": Color("#7fd18b"), "Half heard": Color("#f2c14e")}.get(_shout_tag, Color("#ff8a6a"))
	# S448 (operator on Q-208: "make the buble green when heard , red when ignored"): the whole bubble takes the colour.
	var sb := _sbox.get_theme_stylebox("panel") as StyleBoxFlat
	if sb != null:
		sb.bg_color = {"Heard": Color("#9fe0a8"), "Half heard": Color("#f5d27a")}.get(_shout_tag, Color("#f4a593"))
		sb.bg_color.a = 0.95
	var left := _ring_left()
	_shout_f0 = left if left > 0.02 else 1.0
	var chip := view.get_node_or_null("IntentChip0") as Control
	if chip != null and chip.visible:   # _call_box already kept _head this frame
		chip.visible = false
	if _head == Vector2.ZERO:
		_head = Vector2(view.size.x * 0.4, 330.0)
	_sbox.position = _shout_at()


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
	var shout := _sbox
	if _shout_on and shout != null:
		if chip != null and chip.visible:
			_head = chip.position + Vector2(chip.size.x * 0.5, chip.size.y)
			chip.visible = false
		if _head == Vector2.ZERO:
			_head = Vector2(view.size.x * 0.4, 330.0)
		var at := _shout_at()
		shout.position = at
		_line.visible = shout.visible
		_line.a = at + Vector2(0.0 if at.x > _head.x else shout.size.x, shout.size.y * 0.5)
		_line.b = _head + Vector2(0, 14)
		_line.col = Color(1, 0.55, 0.5, 0.85)
		_line.queue_redraw()
		return
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
	_head = head
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
	# S448 (operator on Q-208, point 3: "wtf is that ?"): the three lines had no heading and sat under the worst place's word
	# (RIBS / EYE). The organ map already shows the place, so the word goes on both plates and the lines say whose read it is.
	for p in ["SidePanel0", "SidePanel1"]:
		var host := view.find_child(p, true, false)
		var tag := host.find_child("WorstTag", true, false) as CanvasItem if host != null else null
		if tag != null: tag.visible = false
	if _notes.is_empty():
		panel.add_child(_read_lab("ReadHead", "YOUR CORNER'S READ", 20, 40.0, Color("#d8cfc2")))
		for i in KINDS.size():
			_notes.append(_read_lab("Read" + KINDS[i], "", 26, 74.0 + float(i) * 36.0, Color.WHITE))
			panel.add_child(_notes[-1])
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
			lab.text = ("Stamina " + ("?" if num != null and num.text.contains("-") else str(roundi(v))) if k == "Energy" else read_word(k, v) + ("  ?" if num != null and num.text.contains("-") else ""))   # S458 his "Stamina ?": a range hides the number
			lab.add_theme_color_override("font_color", READ_COL[_band(v)])


static func _mid(text: String) -> float:
	var t := text.strip_edges()
	if t == "":
		return -1.0
	if t.contains("-"):
		var p := t.split("-")
		return (p[0].to_float() + p[1].to_float()) * 0.5
	return t.to_float()

static func _read_lab(id: String, text: String, fs: int, y: float, col: Color) -> Label:
	var lab := Label.new()
	lab.name = id
	lab.text = text
	lab.add_theme_font_size_override("font_size", fs)
	lab.add_theme_constant_override("outline_size", 6)
	lab.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	lab.add_theme_color_override("font_color", col)
	lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lab.position = Vector2(140, y)
	lab.size = Vector2(450, 34)
	return lab
