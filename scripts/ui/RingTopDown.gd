extends Control
## S531 TOPDOWN1: the live round seen from above (RingMap reads the positions off the round's own exchanges). Her boxer
## red and the opponent blue, the corners the 3D fight dresses them in; the ring round each boxer is the gas left, a red
## halo is hurt, solid lines are punches that landed this exchange and a dashed one a miss, the dots behind her are her
## last steps. A strip of the round's exchanges runs under the ring. Draws only; the page passes the round in.
## S531 (owner: "Zoom in on them"): the view follows the pair - VIEW_M metres top to bottom at true scale (a boxer is
## ~0.5 m wide), the ropes and posts only where they fall in view, a 1 m grid on the canvas, the gap in metres, the two
## gloves showing which way each faces, and a small whole-ring map in the corner so the place in the ring is never lost.

const RingMap := preload("res://scripts/rules/RingMap.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

const RING_PX := 360.0      # the view's height on the words page
const STRIP_H := 54.0
const VIEW_M := 3.4         # metres the zoomed view shows top to bottom
const BODY_M := 0.24        # a boxer's drawn radius in metres (shoulders ~0.5 m)
const MINI := 120.0         # the whole-ring map's side in px
const HER := Color("#df4639")   # the red corner, as the 3D fight dresses her
const OPP := Color("#6fa0e6")
const CANVAS := Color("#3b4a57")
const ROPE := Color("#cfd6dd")

var exs: Array = []
var gas := [100.0, 100.0]
var hurt := [false, false]
var total_ex := 12
var ring_px := RING_PX
var backdrop := false   # true over the 3D fight: a solid page behind the ring
var _centre := Vector2.ZERO   # the ring point at the middle of the view (metres)


static func make(round_ex: Array, state: Dictionary, exchanges: int) -> Control:
	var n := new()
	n.name = "RingTopDown"
	n.exs = round_ex
	n.gas = [float(state.get("a", 100.0)), float(state.get("b", 100.0))]
	n.hurt = state.get("hurt", [false, false])
	n.total_ex = exchanges
	n.custom_minimum_size = Vector2(0, RING_PX + STRIP_H + 40.0)
	n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return n


## Over the 3D fight (FightOptions' Top-down): the round so far and the energy, redrawn as exchanges finish.
func set_round(round_ex: Array, state: Dictionary) -> void:
	exs = round_ex
	gas = [float(state.get("a", 100.0)), float(state.get("b", 100.0))]
	hurt = state.get("hurt", [false, false])
	queue_redraw()


func _ring_rect() -> Rect2:   # the on-screen view box
	var top := 52.0 if backdrop else 8.0
	var h := (size.y - STRIP_H - top - 30.0) if backdrop else ring_px
	return Rect2(16.0, top, size.x - 32.0, h)


func _scale() -> float:   # px per metre
	return _ring_rect().size.y / VIEW_M


func _to_px(p: Vector2) -> Vector2:
	return _ring_rect().get_center() + (p - _centre) * _scale()


## The view sits on the pair's midpoint, kept so it never shows more than half a metre past the ropes.
func _aim(f: Dictionary) -> void:
	var mid: Vector2 = ((f["a"] as Vector2) + (f["b"] as Vector2)) * 0.5
	var r := _ring_rect()
	var half := r.size * 0.5 / _scale()
	var lim := Vector2(maxf(0.0, RingMap.HALF + 0.5 - half.x), maxf(0.0, RingMap.HALF + 0.5 - half.y))
	_centre = Vector2(clampf(mid.x, -lim.x, lim.x), clampf(mid.y, -lim.y, lim.y))


func _draw() -> void:
	if backdrop:
		draw_rect(Rect2(Vector2.ZERO, size), Palette.PAGE)
	var r := _ring_rect()
	var f: Dictionary = RingMap.frame(exs, exs.size() - 1) if not exs.is_empty() else {}
	if not f.is_empty():
		_aim(f)
	draw_rect(r, Palette.PAGE)
	var ring := Rect2(_to_px(Vector2(-RingMap.HALF, -RingMap.HALF)), Vector2.ONE * RingMap.HALF * 2.0 * _scale())
	var canvas := ring.intersection(r)
	draw_rect(canvas, CANVAS)
	var grid := Color(ROPE, 0.08)
	for m in range(-int(RingMap.HALF), int(RingMap.HALF) + 1):
		var gx := _to_px(Vector2(m, 0)).x
		var gy := _to_px(Vector2(0, m)).y
		if gx > canvas.position.x and gx < canvas.end.x:
			draw_line(Vector2(gx, canvas.position.y), Vector2(gx, canvas.end.y), grid, 1.0)
		if gy > canvas.position.y and gy < canvas.end.y:
			draw_line(Vector2(canvas.position.x, gy), Vector2(canvas.end.x, gy), grid, 1.0)
	for k in 3:   # three ropes, each side drawn only where it lies inside the view
		var rr := ring.grow(-k * 0.08 * _scale())
		var col := Color(ROPE, 1.0 - k * 0.3)
		_rope(Vector2(rr.position.x, rr.position.y), Vector2(rr.end.x, rr.position.y), r, col, 4.0 - k)
		_rope(Vector2(rr.end.x, rr.position.y), Vector2(rr.end.x, rr.end.y), r, col, 4.0 - k)
		_rope(Vector2(rr.end.x, rr.end.y), Vector2(rr.position.x, rr.end.y), r, col, 4.0 - k)
		_rope(Vector2(rr.position.x, rr.end.y), Vector2(rr.position.x, rr.position.y), r, col, 4.0 - k)
	var post := Vector2(18, 18)
	for c in [[ring.position, HER], [ring.end, OPP], [Vector2(ring.end.x, ring.position.y), ROPE], [Vector2(ring.position.x, ring.end.y), ROPE]]:
		if r.grow(-1.0).has_point(c[0]):
			draw_rect(Rect2((c[0] as Vector2) - post * 0.5, post), c[1])
	if not f.is_empty():
		_draw_frame(f)
		_draw_mini(f, Rect2(r.end.x - MINI - 10.0, r.position.y + 10.0, MINI, MINI))
		var said := str((exs[-1] as Dictionary).get("verdict", ""))
		if backdrop and said != "":
			draw_string(get_theme_default_font(), Vector2(12.0, 32.0), "Exchange %d: %s" % [exs.size(), said],
				HORIZONTAL_ALIGNMENT_CENTER, size.x - 24.0, 20, Palette.TEXT)
	_draw_strip(Rect2(16.0, r.end.y + 16.0, size.x - 32.0, STRIP_H))


## A straight rope side (horizontal or vertical) clipped to the view box; nothing if it lies outside.
func _rope(p0: Vector2, p1: Vector2, box: Rect2, col: Color, w: float) -> void:
	if p0.y == p1.y and (p0.y < box.position.y or p0.y > box.end.y):
		return
	if p0.x == p1.x and (p0.x < box.position.x or p0.x > box.end.x):
		return
	var a := p0.clamp(box.position, box.end)
	var b := p1.clamp(box.position, box.end)
	if a.distance_to(b) > 1.0:
		draw_line(a, b, col, w)


func _draw_frame(f: Dictionary) -> void:
	var body := BODY_M * _scale()
	var a := _to_px(f["a"])
	var b := _to_px(f["b"])
	var apart := body * 2.0 + 6.0
	if a.distance_to(b) < apart:   # a clinch at true scale overlaps: drawn just touching
		var mid := (a + b) * 0.5
		var u := (b - a).normalized() if a.distance_to(b) > 0.01 else Vector2.RIGHT
		a = mid - u * apart * 0.5
		b = mid + u * apart * 0.5
	# S531 THE CORNER'S EYE: who owns the ring - a soft wash of the winner's colour behind the boxer being walked back,
	# deeper with each exchange won in a row.
	var own := RingMap.owner(exs)
	if int(own["run"]) > 0:
		var back_of := b if int(own["side"]) == 0 else a
		var push := (back_of - (a if int(own["side"]) == 0 else b)).normalized()
		var wash: Color = HER if int(own["side"]) == 0 else OPP
		for k in 4:
			draw_circle(back_of + push * body * 2.0, body * (5.5 - k), Color(wash, 0.035 * mini(int(own["run"]), 4)))
	var prev := a
	var trail: Array = f["trail"]
	for k in range(trail.size() - 1, -1, -1):
		var p := _to_px(trail[k])
		draw_dashed_line(p, prev, Color(HER, 0.6), 3.0, 8.0)
		draw_circle(p, 6.0, Color(HER, 0.5))
		prev = p
	var d := (b - a).normalized()
	var side := Vector2(-d.y, d.x)
	var counts := [0, 0]
	for ln in f["lines"]:
		var who := int(ln["who"])
		var off := side * (float(counts[who]) - 1.0) * body * 0.45
		counts[who] += 1
		var from := (a if who == 0 else b) + off
		var to := (b if who == 0 else a) + off
		var col: Color = HER if who == 0 else OPP
		var u := (to - from).normalized()
		if bool(ln["landed"]):
			draw_line(from + u * body, to - u * body * 0.8, col, 5.0, true)
			draw_circle(to - u * body * 0.8, 6.0, col)
		else:
			draw_dashed_line(from + u * body, to - u * body * 1.4, Color(col, 0.8), 4.0, 9.0)
	var where := str(StrikeMap.card(str(f.get("at", ""))).get("name", ""))
	var gap_m := (f["a"] as Vector2).distance_to(f["b"])
	var words := ("%s  -  %.1f m apart" % [where, gap_m]) if where != "" else ("%.1f m apart" % gap_m)
	draw_string(get_theme_default_font(), (a + b) * 0.5 + Vector2(-140.0, body * 2.2 + 20.0), words,
		HORIZONTAL_ALIGNMENT_CENTER, 280.0, 18, Palette.TEXT)
	_plan_arrow(RingMap.plan_mark(exs[-1]), a, b, body)
	_boxer(a, b, HER, float(gas[0]), bool(hurt[0]), body)
	_boxer(b, a, OPP, float(gas[1]), bool(hurt[1]), body)
	_tags(a, b, "YOUR BOXER", float(gas[0]), bool(hurt[0]), body)
	_tags(b, a, "OPPONENT", float(gas[1]), bool(hurt[1]), body)


## The plan's step for this exchange, drawn from her: where the coach told her to go. Solid = she took it, a cross = she
## read it was wrong and held it, dashed = the plan had it and she did not get it off.
func _plan_arrow(m: Dictionary, a: Vector2, b: Vector2, body: float) -> void:
	if m.is_empty():
		return
	var d := (b - a).normalized()
	var dir := -d if str(m["dir"]) == "back" else (d if str(m["dir"]) == "in" else Vector2(-d.y, d.x))
	var from := a + dir * (body + 10.0)
	var to := a + dir * (body + 0.75 * _scale())
	var st := str(m["state"])
	var col := Color(HER, 0.9) if st == "fired" else Color(Palette.MUTED, 0.85)
	if st == "missed":
		draw_dashed_line(from, to, col, 4.0, 10.0)
	else:
		draw_line(from, to, col, 5.0, true)
	var s := Vector2(-dir.y, dir.x)
	draw_colored_polygon(PackedVector2Array([to + dir * 16.0, to + s * 11.0, to - s * 11.0]), col)
	if st == "held":
		var mid := (from + to) * 0.5
		draw_line(mid + Vector2(-12, -12), mid + Vector2(12, 12), Palette.BAD_FILL, 4.0, true)
		draw_line(mid + Vector2(-12, 12), mid + Vector2(12, -12), Palette.BAD_FILL, 4.0, true)
	var word: String = str({"fired": "plan: %s", "held": "plan: %s - held", "missed": "plan: %s - not got off"}[st]) % str(m["name"]).to_lower()
	draw_string(get_theme_default_font(), to + dir * 20.0 + Vector2(-130.0, 34.0), word, HORIZONTAL_ALIGNMENT_CENTER, 260.0, 16, col)


## A role word above each boxer; HURT (red) or TIRED (amber, gas under 35) under her - what the corner shouts about.
func _tags(p: Vector2, other: Vector2, role: String, g: float, is_hurt: bool, body: float) -> void:
	var font := get_theme_default_font()
	var away := signf(p.x - other.x) if absf(p.x - other.x) > 1.0 else 1.0   # the role word leans away from the other boxer
	draw_string(font, p + Vector2(-80.0 + away * 40.0, -body - 22.0), role, HORIZONTAL_ALIGNMENT_CENTER, 160.0, 14, Palette.MUTED)
	var tag := "HURT" if is_hurt else ("TIRED" if g < 35.0 else "")
	if tag != "":
		draw_string(font, p + Vector2(-60.0, body + 40.0), tag, HORIZONTAL_ALIGNMENT_CENTER, 120.0, 20,
			Palette.BAD_FILL if is_hurt else Palette.WARN)


## The whole ring small in the corner: where in the ring the zoomed view is.
func _draw_mini(f: Dictionary, box: Rect2) -> void:
	draw_rect(box.grow(4.0), Color(Palette.PAGE, 0.85))
	draw_rect(box, CANVAS)
	draw_rect(box, ROPE, false, 2.0)
	var k := box.size.x * 0.5 / RingMap.HALF
	var half := _ring_rect().size * 0.5 / _scale()
	var view := Rect2(box.get_center() + (_centre - half) * k, half * 2.0 * k)
	draw_rect(view.intersection(box), Color(ROPE, 0.6), false, 1.5)
	draw_circle(box.get_center() + (f["a"] as Vector2) * k, 4.0, HER)
	draw_circle(box.get_center() + (f["b"] as Vector2) * k, 4.0, OPP)


func _boxer(p: Vector2, facing: Vector2, col: Color, g: float, is_hurt: bool, body: float) -> void:
	if is_hurt:
		draw_arc(p, body + 16.0, 0.0, TAU, 48, Palette.BAD_FILL, 3.0, true)
	draw_arc(p, body + 6.0, 0.0, TAU, 48, Palette.LINE, 7.0, true)
	var share := clampf(g / 100.0, 0.0, 1.0)
	var gcol: Color = Palette.GOOD_FILL if g >= 60.0 else (Palette.WARN if g >= 35.0 else Palette.BAD_FILL)
	if share > 0.0:
		draw_arc(p, body + 6.0, -PI * 0.5, -PI * 0.5 + TAU * share, 48, gcol, 7.0, true)
	draw_circle(p, body, col)
	var d := (facing - p).normalized()   # the two gloves: which way she faces
	var s := Vector2(-d.y, d.x)
	draw_circle(p + d * body * 0.9 + s * body * 0.35, body * 0.3, col.lightened(0.35))
	draw_circle(p + d * body * 0.6 - s * body * 0.5, body * 0.3, col.lightened(0.2))


func _draw_strip(box: Rect2) -> void:
	var font := get_theme_default_font()
	var n := maxi(total_ex, exs.size())
	var w := (box.size.x - (n - 1) * 6.0) / float(n)
	var ticks := RingMap.ticks(exs)
	for k in n:
		var cell := Rect2(box.position.x + k * (w + 6.0), box.position.y, w, box.size.y)
		var fill := Palette.TILE
		if k < ticks.size():
			fill = Color(HER, 0.45) if bool(ticks[k]["won"]) else Color(OPP, 0.40)
		draw_rect(cell, fill)
		if k == ticks.size() - 1:
			draw_rect(cell, Palette.TEXT, false, 2.0)
		var sub := ""
		if k < ticks.size():
			var l: Array = ticks[k]["landed"]
			sub = "%d-%d  %s" % [int(l[0]), int(l[1]), str(ticks[k]["word"])]
		draw_string(font, cell.position + Vector2(0, 22), str(k + 1), HORIZONTAL_ALIGNMENT_CENTER, w, 16, Palette.TEXT)
		if sub != "":
			draw_string(font, cell.position + Vector2(0, 44), sub, HORIZONTAL_ALIGNMENT_CENTER, w, 14, Palette.MUTED)
