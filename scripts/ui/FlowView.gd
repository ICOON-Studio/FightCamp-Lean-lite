extends Control
## S340 the fight flow on the gym whiteboard (FightFlow; operator Q-S294-64 "Yes, boxing and wrestling now"): the plan's
## places as sticky notes top to bottom in the order she reaches them, each with the coach's key ideas, and a marker arrow
## for every planned move labelled with WHEN. Lit after a fight: green it worked, red it didn't, grey it never came up,
## with how often. A move that keeps her where she is is written on its own note. Over the whole game until Close.
##   var v := FlowView.new(); v.setup(flow, opts); main.add_child(v)
##   opts = {title, sub, place_name: Callable(id) -> String, move_name: Callable(id) -> String, lit: bool}

const UI := preload("res://scripts/ui/UI.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const CARD := Vector2(310, 104)
const GAP := Vector2(70, 150)
const LOOP_H := 24.0
const MARGIN := 40.0
const LIT_COLOUR := {"worked": UI.GREEN, "failed": UI.RED, "unused": UI.MUTED}

var flow: Dictionary = {}
var opts: Dictionary = {}
var _canvas: Control
var _rects := {}


func setup(f: Dictionary, o: Dictionary) -> void:
	flow = f
	opts = o


func _ready() -> void:
	name = "FlowView"
	theme = UI.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = UI.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var rows := UI.vbox(0)
	rows.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(rows)
	var bar := PanelContainer.new()
	bar.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	var h := UI.hbox(10)
	bar.add_child(h)
	h.add_child(UI.label(str(opts.get("title", "THE FLOW")), 22, UI.FG, "bold"))
	h.add_child(UI.muted("  " + str(opts.get("sub", "")), UI.SMALL))
	h.add_child(UI.spacer())
	if bool(opts.get("lit", false)):
		for k in ["worked", "failed", "unused"]:
			h.add_child(UI.label({"worked": "worked", "failed": "didn't work", "unused": "never came up"}[k], UI.SMALL, LIT_COLOUR[k], "bold"))
	var close := UI.button("Close", "BtnSolid", queue_free)
	close.name = "CloseFlow"
	h.add_child(close)
	rows.add_child(bar)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rows.add_child(scroll)
	_canvas = Control.new()
	_canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_canvas.draw.connect(_draw_flow)
	_canvas.resized.connect(_layout)
	scroll.add_child(_canvas)
	_layout()


static func _loops(f: Dictionary, id: String) -> Array:
	return (f.get("edges", []) as Array).filter(func(e): return str(e["from"]) == id and str(e["to"]) == id)


## The lines a card's stay-here moves take: a branch ("if she tires:") writes its move on a second line (S341: one line
## cut "Body hook, head hook" off at the card's edge).
static func _loop_lines(f: Dictionary, id: String) -> int:
	var n := 0
	for e in _loops(f, id):
		n += 2 if str(e.get("when", "")) != "" else 1
	return n


## Card rectangles: rows by depth, each row centred on the canvas.
func _layout() -> void:
	var by_depth := {}
	for n in flow.get("nodes", []):
		by_depth[int(n["depth"])] = int(by_depth.get(int(n["depth"]), 0)) + 1
	var widest := 1
	for d in by_depth:
		widest = maxi(widest, int(by_depth[d]))
	var w := maxf(_canvas.size.x, MARGIN * 2.0 + widest * CARD.x + (widest - 1) * GAP.x)
	var y_of := {}
	var y := MARGIN
	var depths: Array = by_depth.keys()
	depths.sort()
	var tallest := {}
	for n in flow.get("nodes", []):
		var hgt := CARD.y + LOOP_H * _loop_lines(flow, str(n["id"]))
		tallest[int(n["depth"])] = maxf(float(tallest.get(int(n["depth"]), 0.0)), hgt)
	for d in depths:
		y_of[d] = y
		y += float(tallest[d]) + GAP.y
	_rects.clear()
	for n in flow.get("nodes", []):
		var d := int(n["depth"])
		var cnt := int(by_depth[d])
		var x0 := (w - (cnt * CARD.x + (cnt - 1) * GAP.x)) * 0.5
		var hgt := CARD.y + LOOP_H * _loop_lines(flow, str(n["id"]))
		_rects[str(n["id"])] = Rect2(Vector2(x0 + int(n["col"]) * (CARD.x + GAP.x), float(y_of[d])), Vector2(CARD.x, hgt))
	_canvas.custom_minimum_size = Vector2(w, y)
	_canvas.queue_redraw()


func _colour(e: Dictionary) -> Color:
	return LIT_COLOUR[str(e.get("state", "unused"))] if bool(opts.get("lit", false)) else UI.GOLD


func _text(e: Dictionary) -> String:
	var t := FightFlow.label(e, str((opts["move_name"] as Callable).call(str(e["move"]))))
	if bool(opts.get("lit", false)):
		t += "  %d/%d" % [int(e.get("worked", 0)), int(e.get("used", 0))]
	return t


func _draw_flow() -> void:
	var font := UI.font("handbold")
	var labels: Array = []
	var pair := {}
	for e in flow.get("edges", []):
		if str(e["from"]) == str(e["to"]) or not _rects.has(str(e["from"])) or not _rects.has(str(e["to"])):
			continue
		# S341: arrows round the right-hand side count per pair of places either way (Mid -> Long and a Long -> Mid that skips
		# a row would share one curve and one label spot), so the second goes round further out.
		var key := str(e["from"]) + ">" + str(e["to"])
		if _round_right(_rects[str(e["from"])], _rects[str(e["to"])]):
			var ends := [str(e["from"]), str(e["to"])]
			ends.sort()
			key = "R" + "|".join(ends)
		var k := int(pair.get(key, 0))
		pair[key] = k + 1
		labels.append(_edge(e, _rects[str(e["from"])], _rects[str(e["to"])], k))
	for n in flow.get("nodes", []):
		_card(str(n["id"]), _rects[str(n["id"])], str(n["id"]) == str(flow.get("start", "")))
	# Labels last, over the lines and the cards.
	for l in labels:
		var ts := font.get_string_size(str(l["text"]), HORIZONTAL_ALIGNMENT_LEFT, -1, UI.SMALL)
		var pos: Vector2 = l["at"]
		var r := Rect2(pos - Vector2(0.0 if bool(l["right"]) else ts.x * 0.5 + 8, ts.y * 0.5 + 3), ts + Vector2(16, 6))
		if bool(l["right"]):
			r.position.x += 10.0
		_canvas.draw_style_box(UI.box(UI.PANEL, l["col"], 10, 2, 0, 0), r)
		_canvas.draw_string(font, Vector2(r.position.x + 8, r.position.y + ts.y * 0.8 + 3), str(l["text"]), HORIZONTAL_ALIGNMENT_LEFT, -1, UI.SMALL, UI.FG)


## Not down to the next row with nothing between, not along one row: the arrow goes round the right of the cards.
func _round_right(a: Rect2, b: Rect2) -> bool:
	var lo := minf(a.position.y, b.position.y)
	var hi := maxf(a.position.y, b.position.y)
	var between := _rects.values().filter(func(r): return r.position.y > lo + 1.0 and r.position.y < hi - 1.0)
	return not ((b.position.y > a.position.y + 1.0 and between.is_empty()) or absf(b.position.y - a.position.y) <= 1.0)


## A marker arrow: down from the bottom of a card to the top of the next; back up round the right-hand side.
func _edge(e: Dictionary, a: Rect2, b: Rect2, k: int) -> Dictionary:
	var col := _colour(e)
	var p0: Vector2
	var p1: Vector2
	var c0: Vector2
	var c1: Vector2
	var at := 17 - 9 * k   # where on the curve its label sits (of 24): a second arrow between the same two labels higher
	var right := false
	var lo := minf(a.position.y, b.position.y)
	var hi := maxf(a.position.y, b.position.y)
	var between := _rects.values().filter(func(r): return r.position.y > lo + 1.0 and r.position.y < hi - 1.0)
	if b.position.y > a.position.y + 1.0 and between.is_empty():
		# Down to the next row: bottom to top; a second arrow between the same pair spreads out to the right.
		var off := Vector2(36.0 * k, 0)
		p0 = Vector2(a.get_center().x, a.end.y) + off
		p1 = Vector2(b.get_center().x, b.position.y) + off
		c0 = p0 + Vector2(120.0 * k, GAP.y * 0.6)
		c1 = p1 + Vector2(120.0 * k, -GAP.y * 0.6)
	elif absf(b.position.y - a.position.y) <= 1.0:
		# Same row: side to side, bowed under the cards (a second one bows deeper).
		var dx := signf(b.get_center().x - a.get_center().x)
		p0 = Vector2(a.get_center().x + dx * a.size.x * 0.5, a.get_center().y + 16.0 * k)
		p1 = Vector2(b.get_center().x - dx * b.size.x * 0.5, b.get_center().y + 16.0 * k)
		c0 = p0 + Vector2(dx * 40.0, 70.0 + 50.0 * k)
		c1 = p1 + Vector2(-dx * 40.0, 70.0 + 50.0 * k)
		at = 12
	else:
		# Back up, or down past a row: round the right of every card in between, never through one.
		var x := maxf(a.end.x, b.end.x)
		for r in between:
			x = maxf(x, (r as Rect2).end.x)
		x += 70.0 + 70.0 * k
		p0 = Vector2(a.end.x, a.get_center().y + 14.0 * k)
		p1 = Vector2(b.end.x, b.get_center().y - 14.0 * k)
		c0 = Vector2(x, p0.y)
		c1 = Vector2(x, p1.y)
		at = 12
		right = true
	var pts := PackedVector2Array()
	for i in 25:
		var t := float(i) / 24.0
		pts.append(p0.bezier_interpolate(c0, c1, p1, t))
	var unused := bool(opts.get("lit", false)) and str(e.get("state", "")) == "unused"
	if unused:
		for i in range(0, pts.size() - 1, 2):
			_canvas.draw_line(pts[i], pts[i + 1], col, 3.0, true)
	else:
		_canvas.draw_polyline(pts, col, 3.5, true)
	var dir := (pts[24] - pts[22]).normalized()
	var side := Vector2(-dir.y, dir.x)
	_canvas.draw_colored_polygon(PackedVector2Array([p1, p1 - dir * 14 + side * 7, p1 - dir * 14 - side * 7]), col)
	return {"text": _text(e), "at": pts[clampi(at, 2, 22)], "col": col, "right": right}


## A sticky note: the place in marker, the coach's ideas in hand, a move that keeps her there at the foot.
func _card(id: String, r: Rect2, start: bool) -> void:
	_canvas.draw_style_box(UI.box(UI.YELLOW, UI.YELLOW_EDGE, 4, 1, 0, 0), r)
	var marker := UI.font("marker")
	var hand := UI.font("hand")
	var title := str((opts["place_name"] as Callable).call(id))
	_canvas.draw_string(marker, r.position + Vector2(14, 30), title, HORIZONTAL_ALIGNMENT_LEFT, r.size.x - 28, 20, UI.FG)
	if start:
		_canvas.draw_string(UI.font("caps"), Vector2(r.end.x - 70, r.position.y + 20), "START", HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.GOLD)
	var y := r.position.y + 56
	for idea in FightFlow.IDEAS.get(id, []):
		_canvas.draw_string(hand, Vector2(r.position.x + 14, y), "- " + str(idea), HORIZONTAL_ALIGNMENT_LEFT, r.size.x - 28, UI.SMALL, UI.FG)
		y += 22
	for e in _loops(flow, id):
		var w := str(e.get("when", ""))
		var lines := ["stays here: " + _text(e)] if w == "" else [
			"stays here, if %s:" % str(FightFlow.WHEN_WORDS.get(w, w)),
			"   " + _text(e).get_slice(": ", 1)]
		for line in lines:
			_canvas.draw_string(UI.font("handbold"), Vector2(r.position.x + 14, y + 6), str(line), HORIZONTAL_ALIGNMENT_LEFT,
				r.size.x - 28, UI.SMALL, _colour(e))
			y += LOOP_H
