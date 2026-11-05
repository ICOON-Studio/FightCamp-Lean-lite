extends Control
## S384 GAMETREE1: the glyph tile a BJJ card shows until its pose card reads ("card pending": Ludo cannot draw BJJ
## technique, S383; the pose cards come from move_pic_bjj.gd). Ink on a charcoal tile:
##   a node: Ana's bar (red) and the opponent's (blue) - red over blue on top, blue over red underneath, side by side on
##   the feet; tap_win a yellow ring with a tick, tap_loss a red ring with a cross;
##   an edge: a yellow mark for its kind (takedown, sweep, pass, submission, back take, escape, entry, transition, base).
##   MatGlyph.node_kind(node_id) -> "top" | "bottom" | "neutral" | "tap_win" | "tap_loss"

const UI := preload("res://scripts/ui/UI.gd")
const CHARCOAL := Color("#26272b")
const INK := Color("#ffd54a")
const ANA := Color("#e2483d")
const OPP := Color("#2f6fdb")
const PENDING := Color("#b9bcc4")

var kind := "neutral"
var pending := false      # writes "card pending" along the bottom
var tile := true          # false: no charcoal square (the mark on the map's own dark panel)


static func make(k: String, sz: Vector2, is_pending: bool = false) -> Control:
	var g = load("res://scripts/ui/MatGlyph.gd").new()
	g.kind = k
	g.pending = is_pending
	g.custom_minimum_size = sz
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return g


static func node_kind(node_id: String, side: String) -> String:
	if node_id == "tap_win" or node_id == "tap_loss":
		return node_id
	return side if side in ["top", "bottom"] else "neutral"


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	if tile:
		draw_style_box(_box(), r)
	var c := size * 0.5
	if pending:
		c.y -= size.y * 0.08
	var s := minf(size.x, size.y) * (0.36 if pending else 0.42)
	match kind:
		"top", "bottom", "neutral":
			_bars(c, s)
		"tap_win":
			draw_arc(c, s, 0.0, TAU, 32, INK, maxf(2.0, s * 0.16), true)
			draw_polyline(PackedVector2Array([c + Vector2(-0.45, 0.0) * s, c + Vector2(-0.1, 0.38) * s, c + Vector2(0.5, -0.36) * s]), INK, maxf(2.0, s * 0.18), true)
		"tap_loss":
			draw_arc(c, s, 0.0, TAU, 32, ANA, maxf(2.0, s * 0.16), true)
			_x(c, s * 0.45, ANA)
		"submission":
			_x(c, s * 0.62, INK)
		"sweep", "back_take":
			draw_arc(c, s * 0.62, -PI * 0.15, PI * 1.35, 24, INK, maxf(2.0, s * 0.15), true)
			var tip := c + Vector2(cos(-PI * 0.15), sin(-PI * 0.15)) * s * 0.62
			_head(tip, Vector2(0.3, -1.0).normalized() * -1.0, s * 0.32)
		"pass", "entry":
			_arrow(c + Vector2(-0.6, 0.0) * s, c + Vector2(0.6, 0.0) * s, s)
		"takedown":
			_arrow(c + Vector2(-0.5, -0.5) * s, c + Vector2(0.5, 0.5) * s, s)
		"escape":
			_arrow(c + Vector2(0.0, 0.6) * s, c + Vector2(0.0, -0.6) * s, s)
		"transition":
			_arrow(c + Vector2(-0.5, 0.5) * s, c + Vector2(0.5, -0.5) * s, s)
		"swap":
			_arrow(c + Vector2(-0.7, -0.3) * s, c + Vector2(0.7, -0.3) * s, s * 0.8)
			_arrow(c + Vector2(0.7, 0.35) * s, c + Vector2(-0.7, 0.35) * s, s * 0.8)
		_:
			draw_arc(c, s * 0.35, 0.0, TAU, 24, PENDING, maxf(2.0, s * 0.12), true)
	if pending:
		var f := UI.font("italic")
		var fs := int(clampf(size.y * 0.11, 10.0, 15.0))
		draw_string(f, Vector2(6, size.y - 6), "card pending", HORIZONTAL_ALIGNMENT_LEFT, size.x - 8, fs, PENDING)


func _box() -> StyleBoxFlat:
	var b := StyleBoxFlat.new()
	b.bg_color = CHARCOAL
	b.set_corner_radius_all(6)
	b.anti_aliasing = true
	return b


## Ana red, the opponent blue: stacked by who is on top, side by side on the feet.
func _bars(c: Vector2, s: float) -> void:
	var w := s * 1.3
	var h := s * 0.36
	if kind == "neutral":
		var bw := s * 0.36
		var bh := s * 1.2
		_bar(Rect2(c + Vector2(-bw * 1.25, -bh * 0.5), Vector2(bw, bh)), ANA)
		_bar(Rect2(c + Vector2(bw * 0.25, -bh * 0.5), Vector2(bw, bh)), OPP)
		return
	var upper := ANA if kind == "top" else OPP
	var lower := OPP if kind == "top" else ANA
	_bar(Rect2(c + Vector2(-w * 0.5, -h * 1.15), Vector2(w, h)), upper)
	_bar(Rect2(c + Vector2(-w * 0.5, h * 0.15), Vector2(w, h)), lower)


func _bar(r: Rect2, col: Color) -> void:
	var b := StyleBoxFlat.new()
	b.bg_color = col
	b.set_corner_radius_all(int(minf(r.size.x, r.size.y) * 0.4))
	b.anti_aliasing = true
	draw_style_box(b, r)


func _x(c: Vector2, s: float, col: Color) -> void:
	var w := maxf(2.0, s * 0.28)
	draw_line(c + Vector2(-s, -s), c + Vector2(s, s), col, w, true)
	draw_line(c + Vector2(-s, s), c + Vector2(s, -s), col, w, true)


func _arrow(a: Vector2, b: Vector2, s: float) -> void:
	draw_line(a, b, INK, maxf(2.0, s * 0.15), true)
	_head(b, (b - a).normalized(), s * 0.36)


func _head(tip: Vector2, dir: Vector2, s: float) -> void:
	var n := Vector2(-dir.y, dir.x)
	draw_colored_polygon(PackedVector2Array([tip + dir * s * 0.2, tip - dir * s + n * s * 0.6, tip - dir * s - n * s * 0.6]), INK)
