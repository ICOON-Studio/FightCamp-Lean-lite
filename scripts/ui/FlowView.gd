extends Control
## S340 the fight flow (FightFlow; operator Q-S294-64 "Yes, boxing and wrestling now"): the plan's places top to bottom in
## the order she reaches them and an arrow for every planned move labelled with WHEN. Lit after a fight: green it worked,
## red it didn't, grey it never came up, with how often. A move that keeps her where she is is written on its own card.
## S344 TAPEFLOW1 - the tape room's GrappleFlows look (S343: "the tape room IS the reference now"): a white card per place
## with a still of the position (assets/ui/flow/<id>.png, tools/bake_flow_stills.gd), its name and the coach's first cue
## (both cues on hover), the arrow's words in a pill on the line. Over the whole game until Close.
## S344 (operator C162 on the flow: "maybe some special visual effects and animations ?"): as it opens the cards rise in
## row by row and the arrows draw themselves in; then a dot keeps running along each arrow the way the fight flows.
##   var v := FlowView.new(); v.setup(flow, opts); main.add_child(v)
##   opts = {title, sub, place_name: Callable(id) -> String, move_name: Callable(id) -> String, lit: bool}

const UI := preload("res://scripts/ui/UI.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const CARD := Vector2(480, 118)
const PIC := Vector2(150, 100)
const GAP := Vector2(80, 130)
const LOOP_H := 22.0
const MARGIN := 40.0
const STILLS := "res://assets/ui/flow/%s.png"
const LIT_COLOUR := {"worked": UI.GREEN, "failed": UI.RED, "unused": UI.MUTED}
const RISE_S := 0.35
const ROW_DELAY_S := 0.12
const DRAW_S := 0.9
const DOT_PERIOD_S := 2.4

var flow: Dictionary = {}
var opts: Dictionary = {}
var _canvas: Control
var _rects := {}
var _lines: Array = []      # each arrow's curve: {pts, col, dashed}
var _reveal := 1.0          # how much of each arrow is drawn (0..1) while the flow opens
var _shown := false
var _clock := 0.0


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
	_canvas.draw.connect(_draw_lines)
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


## The baked still of a place (null when there is none, e.g. a tie-up: the card is words only).
static func still(id: String) -> Texture2D:
	var path := STILLS % id
	return load(path) as Texture2D if ResourceLoader.exists(path) else null


## Card rectangles: rows by depth, each row centred on the canvas; then the cards, the arrows and their pills.
func _layout() -> void:
	var by_depth := {}
	for n in flow.get("nodes", []):
		by_depth[int(n["depth"])] = int(by_depth.get(int(n["depth"]), 0)) + 1
	var widest := 1
	for d in by_depth:
		widest = maxi(widest, int(by_depth[d]))
	var w := maxf(_canvas.size.x, MARGIN * 2.0 + widest * CARD.x + (widest - 1) * GAP.x + 240.0)
	var y_of := {}
	var y := MARGIN
	var depths: Array = by_depth.keys()
	depths.sort()
	var tallest := {}
	for n in flow.get("nodes", []):
		var hgt := _height(str(n["id"]))
		tallest[int(n["depth"])] = maxf(float(tallest.get(int(n["depth"]), 0.0)), hgt)
	for d in depths:
		y_of[d] = y
		y += float(tallest[d]) + GAP.y
	_rects.clear()
	for n in flow.get("nodes", []):
		var d := int(n["depth"])
		var cnt := int(by_depth[d])
		var x0 := (w - (cnt * CARD.x + (cnt - 1) * GAP.x)) * 0.5
		var hgt := _height(str(n["id"]))
		_rects[str(n["id"])] = Rect2(Vector2(x0 + int(n["col"]) * (CARD.x + GAP.x), float(y_of[d])), Vector2(CARD.x, hgt))
	_canvas.custom_minimum_size = Vector2(w, y)
	UI.clear(_canvas)
	for n in flow.get("nodes", []):
		var card := _card(str(n["id"]), _rects[str(n["id"])], str(n["id"]) == str(flow.get("start", "")))
		card.set_meta("row", int(n["depth"]))
		_canvas.add_child(card)
	_lines.clear()
	var pills: Array = []
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
		var pe := _edge(e, _rects[str(e["from"])], _rects[str(e["to"])], k)
		pe["row"] = _depth(str(e["to"])) + 1
		pills.append(pe)
	# The pills last, over the lines and the cards.
	var i := 0
	for p in pills:
		var pill := _pill(p, i)
		pill.set_meta("row", int(p["row"]))
		_canvas.add_child(pill)
		i += 1
	_canvas.queue_redraw()
	if not _shown and _canvas.size.x > 0.0:
		_shown = true
		_open()


## The opening: each card rises into place a row after the one above, its pills with it, and the arrows draw in.
func _open() -> void:
	_reveal = 0.0
	var tw := create_tween().set_parallel(true)
	for c in _canvas.get_children():
		var ctl := c as Control
		var d := ROW_DELAY_S * float(ctl.get_meta("row", 0))
		var to := ctl.position
		ctl.modulate.a = 0.0
		ctl.position = to + Vector2(0, 16)
		tw.tween_property(ctl, "modulate:a", 1.0, RISE_S).set_delay(d)
		tw.tween_property(ctl, "position", to, RISE_S).set_delay(d).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_method(_set_reveal, 0.0, 1.0, DRAW_S).set_delay(ROW_DELAY_S)


func _set_reveal(v: float) -> void:
	_reveal = v
	_canvas.queue_redraw()


func _process(delta: float) -> void:
	if _canvas != null and not _lines.is_empty():
		_clock = fmod(_clock + delta, DOT_PERIOD_S)
		_canvas.queue_redraw()


func _depth(id: String) -> int:
	for n in flow.get("nodes", []):
		if str(n["id"]) == id:
			return int(n["depth"])
	return 0


## The picture's height holds the name, the cue and two stay-here lines; each one more adds a line.
func _height(id: String) -> float:
	return CARD.y + LOOP_H * maxi(0, _loop_lines(flow, id) - 2)


func _colour(e: Dictionary) -> Color:
	return LIT_COLOUR[str(e.get("state", "unused"))] if bool(opts.get("lit", false)) else UI.GOLD


func _text(e: Dictionary) -> String:
	var t := FightFlow.label(e, str((opts["move_name"] as Callable).call(str(e["move"]))))
	if bool(opts.get("lit", false)):
		t += "  %d/%d" % [int(e.get("worked", 0)), int(e.get("used", 0))]
	return t


func _draw_lines() -> void:
	for l in _lines:
		var all: PackedVector2Array = l["pts"]
		var col: Color = l["col"]
		var pts := all.slice(0, maxi(3, int(ceil(all.size() * _reveal))))
		if bool(l["dashed"]):
			for j in range(0, pts.size() - 1, 2):
				_canvas.draw_line(pts[j], pts[j + 1], col, 3.0, true)
		else:
			_canvas.draw_polyline(pts, col, 3.0, true)
		var p1 := pts[pts.size() - 1]
		var dir := (p1 - pts[pts.size() - 3]).normalized()
		var side := Vector2(-dir.y, dir.x)
		_canvas.draw_colored_polygon(PackedVector2Array([p1, p1 - dir * 13 + side * 7, p1 - dir * 13 - side * 7]), col)
		# The running dot (not on an arrow that never came up).
		if _reveal >= 1.0 and not bool(l["dashed"]):
			var at := all[int(_clock / DOT_PERIOD_S * float(all.size() - 1))]
			_canvas.draw_circle(at, 7.0, Color(col, 0.25))
			_canvas.draw_circle(at, 4.0, col)


## Not down to the next row with nothing between, not along one row: the arrow goes round the right of the cards.
func _round_right(a: Rect2, b: Rect2) -> bool:
	var lo := minf(a.position.y, b.position.y)
	var hi := maxf(a.position.y, b.position.y)
	var between := _rects.values().filter(func(r): return r.position.y > lo + 1.0 and r.position.y < hi - 1.0)
	return not ((b.position.y > a.position.y + 1.0 and between.is_empty()) or absf(b.position.y - a.position.y) <= 1.0)


## An arrow: down from the bottom of a card to the top of the next; back up round the right-hand side. Keeps the curve for
## the canvas and returns where its pill goes.
func _edge(e: Dictionary, a: Rect2, b: Rect2, k: int) -> Dictionary:
	var col := _colour(e)
	var p0: Vector2
	var p1: Vector2
	var c0: Vector2
	var c1: Vector2
	var at := 12 - 7 * k   # where on the curve its pill sits (of 24): a second arrow between the same two cards higher
	var lo := minf(a.position.y, b.position.y)
	var hi := maxf(a.position.y, b.position.y)
	var between := _rects.values().filter(func(r): return r.position.y > lo + 1.0 and r.position.y < hi - 1.0)
	if b.position.y > a.position.y + 1.0 and between.is_empty():
		# Down to the next row: bottom to top; a second arrow between the same pair spreads out to the right.
		var off := Vector2(40.0 * k, 0)
		p0 = Vector2(a.get_center().x, a.end.y) + off
		p1 = Vector2(b.get_center().x, b.position.y) + off
		c0 = p0 + Vector2(120.0 * k, GAP.y * 0.6)
		c1 = p1 + Vector2(120.0 * k, -GAP.y * 0.6)
	elif absf(b.position.y - a.position.y) <= 1.0:
		# Same row: out of the bottom of one, under through the gap, into the bottom of the other (a second dips deeper).
		var dx := signf(b.get_center().x - a.get_center().x)
		p0 = Vector2(a.get_center().x + dx * a.size.x * 0.3, a.end.y)
		p1 = Vector2(b.get_center().x - dx * b.size.x * 0.3, b.end.y)
		c0 = p0 + Vector2(0, 60.0 + 30.0 * k)
		c1 = p1 + Vector2(0, 60.0 + 30.0 * k)
	else:
		# S344 back up, or down past a row: out through the gap beside its row, along a lane right of every card, in through
		# the gap beside the other's row - never behind a card (the first S344 still ran Step back behind Inside).
		var path := _route_right(a, b, k)
		return _keep(e, col, _resample(_round_corners(path), 25), (path[2] + path[3]) * 0.5)
	var pts := PackedVector2Array()
	for i in 25:
		pts.append(p0.bezier_interpolate(c0, c1, p1, float(i) / 24.0))
	return _keep(e, col, pts, pts[clampi(at, 2, 22)])


## Keeps an arrow's points for the canvas; returns its pill.
func _keep(e: Dictionary, col: Color, pts: PackedVector2Array, at: Vector2) -> Dictionary:
	var dashed := bool(opts.get("lit", false)) and str(e.get("state", "")) == "unused"
	_lines.append({"pts": pts, "col": col, "dashed": dashed})
	return {"text": _text(e), "at": at, "col": col}


## The corners of an arrow that goes round: leave a, its gap, the lane, the lane at b's gap, b's gap, into b.
func _route_right(a: Rect2, b: Rect2, k: int) -> PackedVector2Array:
	var x := 0.0
	for r in _rects.values():
		x = maxf(x, (r as Rect2).end.x)
	x += 50.0 + 60.0 * k
	var up := b.position.y < a.position.y
	var x0 := a.end.x - 40.0 - 26.0 * k
	var x1 := b.end.x - 40.0 - 26.0 * k
	var p0 := Vector2(x0, a.position.y if up else a.end.y)
	var p1 := Vector2(x1, b.end.y if up else b.position.y)
	var ya := p0.y + (-1.0 if up else 1.0) * (GAP.y * 0.35 + 8.0 * k)
	var yb := p1.y + (1.0 if up else -1.0) * (GAP.y * 0.35 + 8.0 * k)
	return PackedVector2Array([p0, Vector2(x0, ya), Vector2(x, ya), Vector2(x, yb), Vector2(x1, yb), p1])


## Rounds a polyline's corners (two passes of corner cutting, the ends kept).
static func _round_corners(path: PackedVector2Array) -> PackedVector2Array:
	var out := path
	for pass_i in 2:
		var cut := PackedVector2Array([out[0]])
		for i in out.size() - 1:
			cut.append(out[i].lerp(out[i + 1], 0.25))
			cut.append(out[i].lerp(out[i + 1], 0.75))
		cut.append(out[out.size() - 1])
		out = cut
	return out


## n points evenly spaced along a polyline (the drawing-in and the running dot keep an even pace).
static func _resample(path: PackedVector2Array, n: int) -> PackedVector2Array:
	var total := 0.0
	for i in path.size() - 1:
		total += path[i].distance_to(path[i + 1])
	var out := PackedVector2Array([path[0]])
	var seg := 0
	var walked := 0.0
	for j in range(1, n):
		var want := total * float(j) / float(n - 1)
		while seg < path.size() - 2 and walked + path[seg].distance_to(path[seg + 1]) < want:
			walked += path[seg].distance_to(path[seg + 1])
			seg += 1
		var len_s := path[seg].distance_to(path[seg + 1])
		out.append(path[seg].lerp(path[seg + 1], clampf((want - walked) / maxf(len_s, 0.001), 0.0, 1.0)))
	return out


## The arrow's words in a pill across its line (GrappleFlows' edge, the tape room's pill).
func _pill(p: Dictionary, i: int) -> PanelContainer:
	var pill := PanelContainer.new()
	pill.name = "Edge%d" % i
	pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pill.add_theme_stylebox_override("panel", UI.box(UI.PANEL, p["col"], 12, 2, 10, 2))
	pill.add_child(UI.label(str(p["text"]), UI.TINY, UI.FG, "bold"))
	var sz := pill.get_combined_minimum_size()
	var at: Vector2 = p["at"]
	pill.position = at - sz * 0.5
	pill.size = sz
	return pill


## A place's card: the still of the position, its name, the coach's first cue (both cues on hover), and a move that keeps
## her there at the foot in its arrow's colour.
func _card(id: String, r: Rect2, start: bool) -> PanelContainer:
	var card := PanelContainer.new()
	card.name = "Card_" + id
	card.mouse_filter = Control.MOUSE_FILTER_PASS
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD if start else UI.LINE, 10, 3 if start else 1, 8, 8))
	card.position = r.position
	card.custom_minimum_size = r.size
	card.size = r.size
	var ideas: Array = FightFlow.IDEAS.get(id, [])
	var tip: Array = ideas.map(func(s): return "- " + str(s))
	var h := UI.hbox(12)
	card.add_child(h)
	var tex := still(id)
	if tex != null:
		var pic := TextureRect.new()
		pic.name = "Still"
		pic.custom_minimum_size = PIC
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		pic.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		pic.texture = tex
		h.add_child(pic)
	var words := UI.vbox(2)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(words)
	var top := UI.hbox(6)
	top.add_child(UI.label(str((opts["place_name"] as Callable).call(id)), UI.BODY, UI.FG, "bold"))
	if start:
		top.add_child(UI.chip("START", "gold"))
	words.add_child(top)
	if not ideas.is_empty():
		words.add_child(_fit(UI.muted(str(ideas[0]), UI.SMALL)))
	for e in _loops(flow, id):
		var w := str(e.get("when", ""))
		var lines := ["stays here: " + _text(e)] if w == "" else [
			"stays here, if %s:" % str(FightFlow.WHEN_WORDS.get(w, w)),
			"   " + _text(e).get_slice(": ", 1)]
		for line in lines:
			words.add_child(_fit(UI.label(str(line), UI.SMALL, _colour(e), "bold")))
		tip.append(str(lines[0]) + ("" if lines.size() == 1 else " " + str(lines[1]).strip_edges()))
	card.tooltip_text = "\n".join(tip)
	return card


## A line that never widens its card: cut with "..." at the edge (the whole of it is on hover).
static func _fit(l: Label) -> Label:
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l
