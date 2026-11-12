extends Control
## S384 GAMETREE1: the map panel of Ana's Playbook centre column - "ANA'S GAME" (design 7 node view, mockup r2). Her plan's
## positions in a row from the feet, the selected position with its ins and outs (the reachable ring), the plan's miss
## landings. Columns are hops from the feet. Arrow states: yellow owned, half-yellow FELT (15-29, tried in opens at weaker
## odds), grey learning, purple dotted a belt ahead (half rate), thin grey everyone's moves (BASE), red dashed where a miss
## lands. A HOLE stamp on every position where Ana owns no move out. Positions are Tree_<node>, arrows MapEdge_<edge>.
##   map.setup(f, info (MatTreeInfo.map_nodes), steps, sel, holes, on_node(node), on_edge(eid), on_hover(eid or ""))

const UI := preload("res://scripts/ui/UI.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const Info := preload("res://scripts/ui/MatTreeInfo.gd")
const MatGlyph := preload("res://scripts/ui/MatGlyph.gd")

const BG := Color("#1d1e22")
const BOX := Color("#2a2c31")
const INK := Color("#ffd54a")
const FELT := Color(1.0, 0.835, 0.29, 0.55)
const LEARN := Color("#8d929c")
const AHEAD := Color("#a98bff")
const BASE := Color(0.84, 0.85, 0.87, 0.55)
const MISS := Color("#ff6a5c")
const TEXT := Color("#eef0f3")
const DIM := Color("#a3a8b2")
const TOP := 68.0
const FOOT := 34.0
const BOX_H := 40.0
const STATE_COLOR := {"owned": INK, "signature": INK, "felt": FELT, "learning": LEARN, "ahead": AHEAD, "base": BASE,
	"illegal": Color("#5d6068")}

var f: Dictionary = {}
var info: Dictionary = {}
var steps: Array = []
var sel := "standing"
var holes: Array = []
var on_node: Callable
var on_edge: Callable
var on_hover: Callable
var rects := {}      # node -> Rect2
var _states := {}    # edge -> state
var _rl := {}
var _built := false
var _taken: Array = []   # rects already used by a box, a stamp or a label (labels never sit on each other)


func setup(fd: Dictionary, inf: Dictionary, st: Array, selected: String, hl: Array, node_cb: Callable, edge_cb: Callable,
		hover_cb: Callable) -> void:
	f = fd
	info = inf
	steps = st
	sel = selected
	holes = hl
	on_node = node_cb
	on_edge = edge_cb
	on_hover = hover_cb
	_rl = Info.rules(f)
	_states = {}
	for id in info["edges"]:
		_states[id] = Info.edge_state(f, BjjTree.edge(str(id)), _rl)
	clip_contents = true
	if not resized.is_connected(_rebuild):
		resized.connect(_rebuild)
	_rebuild()


func _rebuild() -> void:
	if info.is_empty() or size.x < 50.0:
		return
	for k in get_children():
		remove_child(k)
		k.queue_free()
	_layout()
	_taken = [Rect2(0, 0, size.x, TOP - 14.0)]
	for n in rects:
		_taken.append((rects[n] as Rect2).grow(3.0))
		if holes.has(n):
			_taken.append(Rect2((rects[n] as Rect2).end.x - 48.0, (rects[n] as Rect2).position.y - 18.0, 48.0, 18.0))
	_header()
	for n in info["nodes"]:
		_node_box(str(n))
	for id in info["edges"]:
		_edge_label(str(id))
	for id in info["miss"]:
		_miss_label(str(id))
	_built = true
	queue_redraw()


func _layout() -> void:
	rects = {}
	var cols: Dictionary = info["cols"]
	var ncol := 1
	for n in cols:
		ncol = maxi(ncol, int(cols[n]) + 1)
	var bw := clampf((size.x - 40.0) / float(ncol) - 40.0, 100.0, 142.0)
	var span := size.x - 40.0 - bw
	var by_col := {}
	for n in info["nodes"]:
		(by_col.get_or_add(int(cols[n]), []) as Array).append(str(n))
	var mid := TOP + (size.y - TOP - FOOT) * 0.5
	var row_h := (size.y - TOP - FOOT - BOX_H) / 4.0
	for c in by_col:
		var list: Array = by_col[c]
		var plan_n: Array = list.filter(func(n): return (info["plan_nodes"] as Array).has(n))
		var rest: Array = list.filter(func(n): return not plan_n.has(n))
		var order := plan_n + rest
		var x := 20.0 + (span * float(c) / float(ncol - 1) if ncol > 1 else 0.0)
		for i in order.size():
			# the plan's row in the middle, the rest alternating below and above it
			var k := 0 if i == 0 else (int((i + 1) / 2) * (1 if i % 2 == 1 else -1))
			var y := clampf(mid + k * row_h - BOX_H * 0.5, TOP, size.y - FOOT - BOX_H)
			rects[order[i]] = Rect2(x, y, bw, BOX_H)
	# centre the drawn block between the header and the legend
	var lo := INF
	var hi := -INF
	for n in rects:
		lo = minf(lo, (rects[n] as Rect2).position.y)
		hi = maxf(hi, (rects[n] as Rect2).end.y)
	var shift := (TOP + 10.0 + size.y - FOOT) * 0.5 - (lo + hi) * 0.5
	for n in rects:
		rects[n] = Rect2((rects[n] as Rect2).position + Vector2(0, shift), (rects[n] as Rect2).size)


func _header() -> void:
	var h := UI.hbox(12)
	h.position = Vector2(16, 10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(UI.label("%s'S GAME" % str(f.get("first", "Ana")).to_upper(), 26, TEXT, "display"))
	var lv := BjjTree.levels(f)
	var owned := 0
	var felt := 0
	for id in lv:
		var s := BjjTree.state(float(lv[id]))
		owned += 1 if s in ["owned", "signature"] else 0
		felt += 1 if s == "felt" else 0
	var sub := UI.label("%d moves owned - %d felt - %d holes  |  %s" % [owned, felt, BjjTree.holes(f, _rl).size(),
		str(BjjTree.node(sel).get("name", sel))], UI.TINY, DIM, "semi")
	sub.name = "MapSummary"
	h.add_child(sub)
	add_child(h)


func _node_box(n: String) -> void:
	if not rects.has(n):
		return
	var r: Rect2 = rects[n]
	var b := Button.new()
	b.name = "Tree_" + n
	b.position = r.position
	b.size = r.size
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var on_plan := (info["plan_nodes"] as Array).has(n)
	var col := INK if on_plan else Color("#5b5f68")
	var sb := UI.box(BOX, col, 8, 3 if n == sel else (2 if on_plan else 1), 6, 4)
	if n == sel:
		sb.shadow_color = Color(1.0, 0.84, 0.3, 0.35)
		sb.shadow_size = 6
	for st in ["normal", "hover", "pressed", "focus"]:
		b.add_theme_stylebox_override(st, sb)
	var h := UI.hbox(6)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.position = Vector2(6, 4)
	h.size = r.size - Vector2(12, 8)
	var g := MatGlyph.make(MatGlyph.node_kind(n, str(BjjTree.node(n).get("side", ""))), Vector2(22, 30))
	g.set("tile", false)
	h.add_child(g)
	var l := UI.label(str(BjjTree.node(n).get("name", n)).to_upper(), 12, TEXT, "display")
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.max_lines_visible = 2
	l.custom_minimum_size = Vector2(r.size.x - 40.0, 0)
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.size_flags_vertical = Control.SIZE_FILL
	h.add_child(l)
	b.add_child(h)
	b.pressed.connect(func(): on_node.call(n))
	add_child(b)
	if holes.has(n):
		var stamp := PanelContainer.new()
		stamp.name = "Hole_" + n
		stamp.add_theme_stylebox_override("panel", UI.box(Color(0.89, 0.28, 0.24, 0.12), MISS, 3, 2, 5, 0))
		stamp.add_child(UI.label("HOLE", 12, MISS, "bold"))
		stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stamp.position = Vector2(r.end.x - 46.0, r.position.y - 16.0)
		add_child(stamp)


## Where an arrow leaves `a` and enters `b`: right side to left side going forward, else top/bottom.
func _ends(a: Rect2, b: Rect2) -> Array:
	if b.position.x > a.end.x + 4.0:
		return [Vector2(a.end.x, a.get_center().y), Vector2(b.position.x, b.get_center().y)]
	if b.end.x < a.position.x - 4.0:
		return [Vector2(a.position.x, a.get_center().y), Vector2(b.end.x, b.get_center().y)]
	if b.position.y > a.position.y:
		return [Vector2(a.get_center().x, a.end.y), Vector2(b.get_center().x, b.position.y)]
	return [Vector2(a.get_center().x, a.position.y), Vector2(b.get_center().x, b.end.y)]


func _edge_label(id: String) -> void:
	var e := BjjTree.edge(id)
	if not (rects.has(str(e["from"])) and rects.has(str(e["ok"]))):
		return
	var pe := _ends(rects[str(e["from"])], rects[str(e["ok"])])
	var mid: Vector2 = (pe[0] + pe[1]) * 0.5
	var st := str(_states.get(id, "learning"))
	var on_plan := steps.has(id)
	var txt := BjjTree.move_name(str(e["move"]))
	if st == "learning" or st == "felt":
		txt += " %d" % int(BjjTree.mastery(f, str(e["move"])))
	var b := Button.new()
	b.name = "MapEdge_" + id
	b.text = txt
	var num := _step_no(id)
	if num > 0:
		# a plan arrow: its step number in a yellow disc on the arrow (the strip above carries its name)
		b.text = str(num)
		b.focus_mode = Control.FOCUS_NONE
		b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		b.add_theme_font_size_override("font_size", 16)
		b.add_theme_font_override("font", UI.font("bold"))
		for k in ["font_color", "font_hover_color", "font_pressed_color"]:
			b.add_theme_color_override(k, BG)
		var disc := UI.box(INK, BG, 12, 2, 0, 0)
		for k in ["normal", "hover", "pressed"]:
			b.add_theme_stylebox_override(k, disc)
		b.custom_minimum_size = Vector2(24, 24)
		add_child(b)
		b.size = Vector2(24, 24)
		b.position = mid - Vector2(12, 12)
		_taken.append(Rect2(b.position, b.size))
		b.pressed.connect(func(): on_edge.call(id))
		b.mouse_entered.connect(func(): on_hover.call(id, b))
		b.mouse_exited.connect(func(): on_hover.call("", b))
		return
	b.flat = true
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_size_override("font_size", 16)
	b.add_theme_font_override("font", UI.font("bold" if on_plan else "semi"))
	var col: Color = INK if on_plan else STATE_COLOR.get(st, LEARN)
	if col.a < 1.0:
		col.a = 0.9
	for k in ["font_color", "font_hover_color", "font_pressed_color"]:
		b.add_theme_color_override(k, col)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(BG, 0.78)
	sb.set_corner_radius_all(4)
	sb.content_margin_left = 3
	sb.content_margin_right = 3
	for k in ["normal", "hover", "pressed"]:
		b.add_theme_stylebox_override(k, sb)
	add_child(b)
	b.reset_size()
	b.position = _free_spot(pe[0], pe[1], b.size)
	b.pressed.connect(func(): on_edge.call(id))
	b.mouse_entered.connect(func(): on_hover.call(id, b))
	b.mouse_exited.connect(func(): on_hover.call("", b))


## The plan step number of an arrow (non-BASE steps counted, as on the strip's cards); 0 off the plan or for a BASE step.
func _step_no(id: String) -> int:
	var k := 0
	for sid in steps:
		if BjjTree.is_base(str(BjjTree.edge(str(sid))["move"])):
			if str(sid) == id:
				return 0
			continue
		k += 1
		if str(sid) == id:
			return k
	return 0


func _miss_label(id: String) -> void:
	var e := BjjTree.edge(id)
	if not (rects.has(str(e["from"])) and rects.has(str(e["bad"]))):
		return
	var pe := _ends(rects[str(e["from"])], rects[str(e["bad"])])
	var l := UI.label("%s missed" % BjjTree.move_name(str(e["move"])).to_lower(), 12, MISS, "italic")
	l.name = "Miss_" + id
	add_child(l)
	l.reset_size()
	var at := _free_spot(pe[0], pe[1], l.size, false)
	l.position = at
	l.visible = at.x >= 0.0


## A label's place along its arrow: the first spot (middle out, either side) that covers no box, stamp or other label.
func _free_spot(a: Vector2, b: Vector2, sz: Vector2, fallback: bool = true) -> Vector2:
	var d := (b - a).normalized()
	var nrm := Vector2(-d.y, d.x)
	var first := Vector2.ZERO
	for t in [0.5, 0.4, 0.6, 0.3, 0.7, 0.2, 0.8, 0.12, 0.88]:
		for side in [-1.0, 1.0, 0.0, -2.2, 2.2]:
			var c: Vector2 = a.lerp(b, t) + nrm * side * (sz.y * 0.5 + 3.0)
			var r := Rect2(c - sz * 0.5, sz)
			if first == Vector2.ZERO:
				first = r.position
			if r.position.x < 2.0 or r.end.x > size.x - 2.0 or r.position.y < TOP - 12.0 or r.end.y > size.y - FOOT:
				continue
			if not _taken.any(func(x): return (x as Rect2).intersects(r)):
				_taken.append(r)
				return r.position
	return first if fallback else Vector2(-1, -1)


func _draw() -> void:
	draw_style_box(UI.box(BG, Color(0, 0, 0, 0), 12, 0, 0, 0), Rect2(Vector2.ZERO, size))
	if not _built:
		return
	for id in info["miss"]:
		var e := BjjTree.edge(str(id))
		if rects.has(str(e["from"])) and rects.has(str(e["bad"])):
			var pe := _ends(rects[str(e["from"])], rects[str(e["bad"])])
			draw_dashed_line(pe[0], pe[1], MISS, 2.0, 7.0, true, true)
			_head(pe[1], (pe[1] - pe[0]).normalized(), MISS, 9.0)
	for id in info["edges"]:
		var e := BjjTree.edge(str(id))
		if not (rects.has(str(e["from"])) and rects.has(str(e["ok"]))):
			continue
		var pe := _ends(rects[str(e["from"])], rects[str(e["ok"])])
		var st := str(_states.get(id, "learning"))
		var col: Color = STATE_COLOR.get(st, LEARN)
		var on_plan := steps.has(id)
		var w := 3.0 if st in ["owned", "signature"] else (2.5 if st == "felt" else 1.6)
		if on_plan:
			draw_line(pe[0], pe[1], Color(1.0, 0.84, 0.3, 0.22), 12.0, true)
			col = INK if st != "felt" else Color(INK, 0.8)
			w = 4.0
		if st in ["ahead", "illegal"]:
			draw_dashed_line(pe[0], pe[1], col, w, 3.0, true, true)
		else:
			draw_line(pe[0], pe[1], col, w, true)
		_head(pe[1], (pe[1] - pe[0]).normalized(), col, 10.0 if on_plan else 8.0)
	_legend()


func _head(tip: Vector2, dir: Vector2, col: Color, s: float) -> void:
	var n := Vector2(-dir.y, dir.x)
	draw_colored_polygon(PackedVector2Array([tip, tip - dir * s + n * s * 0.5, tip - dir * s - n * s * 0.5]), Color(col, 1.0))


func _legend() -> void:
	var y := size.y - 16.0
	var x := 16.0
	var fnt := UI.font("semi")
	for row in [["owned", INK, false], ["felt (15+)", FELT, false], ["learning", LEARN, false], ["a belt ahead (x0.5)", AHEAD, true],
			["everyone's", BASE, false], ["a miss lands", MISS, true]]:
		if row[2]:
			draw_dashed_line(Vector2(x, y), Vector2(x + 26, y), row[1], 2.5, 4.0, true, true)
		else:
			draw_line(Vector2(x, y), Vector2(x + 26, y), row[1], 3.0, true)
		x += 32.0
		draw_string(fnt, Vector2(x, y + 5), str(row[0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, DIM)
		x += fnt.get_string_size(str(row[0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x + 18.0
	draw_string(UI.font("bold"), Vector2(x, y + 5), "HOLE", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, MISS)
	x += 40.0
	draw_string(fnt, Vector2(x, y + 5), "no owned move out", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, DIM)
