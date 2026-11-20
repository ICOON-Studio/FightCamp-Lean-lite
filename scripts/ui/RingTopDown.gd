extends Control
## S531 TOPDOWN1: the live round seen from above (RingMap reads the positions off the round's own exchanges). Her boxer
## red and the opponent blue, the corners the 3D fight dresses them in; the ring round each boxer is the gas left, a red halo is hurt, solid lines are punches that
## landed this exchange and a dashed one a miss, the dots behind her are her last steps. A strip of the round's exchanges
## runs under the ring. Draws only; the page (FightNight._live) passes the round in.

const RingMap := preload("res://scripts/rules/RingMap.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

const RING_PX := 360.0      # the ring square's side on screen
const STRIP_H := 54.0
const MIN_APART := 80.0     # px between the two boxers' centres on screen
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


func _ring_rect() -> Rect2:
	var px := minf(ring_px, size.y - STRIP_H - 90.0) if backdrop else ring_px
	return Rect2((size.x - px) * 0.5, 8.0 if not backdrop else 52.0, px, px)


func _to_px(p: Vector2) -> Vector2:
	var r := _ring_rect()
	return r.get_center() + p / RingMap.HALF * (r.size.x * 0.5)


func _draw() -> void:
	if backdrop:
		draw_rect(Rect2(Vector2.ZERO, size), Palette.PAGE)
	var r := _ring_rect()
	draw_rect(r.grow(14.0), Palette.PAGE)
	draw_rect(r, CANVAS)
	for k in 3:
		draw_rect(r.grow(-k * 9.0), Color(ROPE, 1.0 - k * 0.3), false, 3.0 - k)
	var post := Vector2(14, 14)
	draw_rect(Rect2(r.position - post * 0.5, post), HER)
	draw_rect(Rect2(r.end - post * 0.5, post), OPP)
	draw_rect(Rect2(Vector2(r.end.x, r.position.y) - post * 0.5, post), ROPE)
	draw_rect(Rect2(Vector2(r.position.x, r.end.y) - post * 0.5, post), ROPE)
	if not exs.is_empty():
		_draw_frame(RingMap.frame(exs, exs.size() - 1))
		var said := str((exs[-1] as Dictionary).get("verdict", ""))
		if backdrop and said != "":
			draw_string(get_theme_default_font(), Vector2(12.0, 32.0), "Exchange %d: %s" % [exs.size(), said],
				HORIZONTAL_ALIGNMENT_CENTER, size.x - 24.0, 20, Palette.TEXT)
	_draw_strip(Rect2(16.0, r.end.y + 26.0, size.x - 32.0, STRIP_H))


func _draw_frame(f: Dictionary) -> void:
	var a := _to_px(f["a"])
	var b := _to_px(f["b"])
	if a.distance_to(b) < MIN_APART:   # at true scale two boxers inside touch: drawn a readable step apart
		var mid := (a + b) * 0.5
		var u := (b - a).normalized() if a.distance_to(b) > 0.01 else Vector2.RIGHT
		a = mid - u * MIN_APART * 0.5
		b = mid + u * MIN_APART * 0.5
	var prev := a
	var trail: Array = f["trail"]
	for k in range(trail.size() - 1, -1, -1):
		var p := _to_px(trail[k])
		draw_dashed_line(p, prev, Color(HER, 0.6), 2.0, 6.0)
		draw_circle(p, 4.0, Color(HER, 0.5))
		prev = p
	var d := (b - a).normalized()
	var side := Vector2(-d.y, d.x)
	var counts := [0, 0]
	for ln in f["lines"]:
		var who := int(ln["who"])
		var off := side * (float(counts[who]) - 1.0) * 7.0
		counts[who] += 1
		var from := (a if who == 0 else b) + off
		var to := (b if who == 0 else a) + off
		var col: Color = HER if who == 0 else OPP
		if bool(ln["landed"]):
			draw_line(from + (to - from).normalized() * 12.0, to - (to - from).normalized() * 12.0, col, 3.0, true)
		else:
			draw_dashed_line(from + (to - from).normalized() * 12.0, to - (to - from).normalized() * 18.0, Color(col, 0.8), 3.0, 7.0)
	var where := str(StrikeMap.card(str(f.get("at", ""))).get("name", ""))
	if where != "":
		draw_string(get_theme_default_font(), (a + b) * 0.5 + Vector2(-80.0, 44.0), where, HORIZONTAL_ALIGNMENT_CENTER, 160.0, 16, Palette.MUTED)
	_boxer(a, b, HER, float(gas[0]), bool(hurt[0]))
	_boxer(b, a, OPP, float(gas[1]), bool(hurt[1]))


func _boxer(p: Vector2, facing: Vector2, col: Color, g: float, is_hurt: bool) -> void:
	if is_hurt:
		draw_arc(p, 22.0, 0.0, TAU, 40, Palette.BAD_FILL, 2.5, true)
	draw_arc(p, 16.0, 0.0, TAU, 40, Palette.LINE, 5.0, true)
	var share := clampf(g / 100.0, 0.0, 1.0)
	var gcol: Color = Palette.GOOD_FILL if g >= 60.0 else (Palette.WARN if g >= 35.0 else Palette.BAD_FILL)
	if share > 0.0:
		draw_arc(p, 16.0, -PI * 0.5, -PI * 0.5 + TAU * share, 40, gcol, 5.0, true)
	draw_circle(p, 11.0, col)
	draw_line(p, p + (facing - p).normalized() * 13.0, Palette.PAGE, 3.0, true)


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
		var top := str(k + 1)
		var sub := ""
		if k < ticks.size():
			var l: Array = ticks[k]["landed"]
			sub = "%d-%d  %s" % [int(l[0]), int(l[1]), str(ticks[k]["word"])]
		draw_string(font, cell.position + Vector2(0, 22), top, HORIZONTAL_ALIGNMENT_CENTER, w, 16, Palette.TEXT)
		if sub != "":
			draw_string(font, cell.position + Vector2(0, 44), sub, HORIZONTAL_ALIGNMENT_CENTER, w, 14, Palette.MUTED)
