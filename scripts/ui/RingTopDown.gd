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
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

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
## S533 P4PBUILD1 the corner's eye (DESIGN_THREEP4P_V2 section 4). show_plan = false is the clean view: it hides the plan
## lines, their legend and the ghosts, nothing else. next = {at, want} the plan's line for the next opening ({} = the
## bell); past = the bout's settled rounds (their attempted lines are the dim ghosts). Read only: nothing here decides.
var show_plan := true
var next := {}
var past: Array = []
var _centre := Vector2.ZERO   # the ring point at the middle of the view (metres)


static func make(round_ex: Array, state: Dictionary, exchanges: int) -> Control:
	var n := new()
	n.name = "RingTopDown"
	n.exs = round_ex
	n.gas = [float(state.get("a", 100.0)), float(state.get("b", 100.0))]
	n.hurt = state.get("hurt", [false, false])
	n.next = state.get("next", {})
	n.past = state.get("past", [])
	n.total_ex = exchanges
	n.custom_minimum_size = Vector2(0, RING_PX + STRIP_H + 40.0)
	n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return n


## Over the 3D fight (FightOptions' Top-down): the round so far and the energy, redrawn as exchanges finish.
func set_round(round_ex: Array, state: Dictionary) -> void:
	exs = round_ex
	gas = [float(state.get("a", 100.0)), float(state.get("b", 100.0))]
	hurt = state.get("hurt", [false, false])
	next = state.get("next", {})
	past = state.get("past", [])
	queue_redraw()


func _ring_rect() -> Rect2:   # the on-screen view box
	var top := 98.0 if backdrop else 8.0
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
		if backdrop:   # what is settled, and when the corner can next act (the calls and the bell keep their own timing)
			draw_string(get_theme_default_font(), Vector2(12.0, 60.0), settled_line(exs.size(), total_ex), HORIZONTAL_ALIGNMENT_CENTER,
				size.x - 24.0, 16, Palette.MUTED)
			var tip := hint_line(RingMap.hint(exs, next, total_ex))
			if tip != "":
				draw_string(get_theme_default_font(), Vector2(12.0, 84.0), tip, HORIZONTAL_ALIGNMENT_CENTER, size.x - 24.0, 16, Palette.WARN)
		if show_plan:
			_draw_legend(r)
			_draw_ghosts(r)
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
	# S533: only the side the record has pinned is marked (the win-streak wash is gone: it showed a walk-down nobody
	# recorded). In the open ring nothing is claimed.
	var pin := RingMap.pinned(exs)
	if pin >= 0:
		draw_arc(a if pin == 0 else b, body + 26.0, 0.0, TAU, 48, Color(Palette.WARN, 0.7), 3.0, true)
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
	var tag_rows := maxi(tags_for(float(gas[0]), bool(hurt[0]), pin == 0).size(), tags_for(float(gas[1]), bool(hurt[1]), pin == 1).size())
	draw_string(get_theme_default_font(), (a + b) * 0.5 + Vector2(-140.0, maxf(body * 2.2 + 20.0, body + 46.0 + 22.0 * tag_rows)), words,   # under the tags, never on them
		HORIZONTAL_ALIGNMENT_CENTER, 280.0, 18, Palette.TEXT)
	if show_plan:
		_plan_arrow(RingMap.plan_mark(exs[-1]), a, b, body, 0.0)
		_plan_arrow(RingMap.next_mark(next), a, b, body, 22.0)
	_boxer(a, b, HER, float(gas[0]), bool(hurt[0]), body)
	_boxer(b, a, OPP, float(gas[1]), bool(hurt[1]), body)
	_tags(a, b, "YOUR BOXER", float(gas[0]), bool(hurt[0]), body, pin == 0)
	_tags(b, a, "OPPONENT", float(gas[1]), bool(hurt[1]), body, pin == 1)


## What is settled and when the corner can act next. The overlay offers nothing itself: the shout bar and the corner
## minute keep their own buttons and timing.
static func settled_line(done: int, total: int) -> String:
	if done >= total:
		return "Exchange %d of %d settled. Next: the bell, and the corner minute." % [done, total]
	return "Exchange %d of %d settled. Next: exchange %d - a call can go in before it." % [done, total, done + 1]


## RingMap.hint in words: the existing control, its real price, and that silence stays an answer.
static func hint_line(kind: String) -> String:
	if kind == "bell":
		return "At the bell: the corner minute can swap one plan line (its old answer is given up), or keep the plan."
	if kind == "tie":
		var tie: Dictionary = Exchanges.CALLS.get("tie", {})
		return "On the ropes with no ready exit: %s on the shout bar (one call, energy %+d), or say nothing and keep the call." % [
			str(tie.get("label", "Tie up")), -roundi(float(tie.get("cost", 0.0)))]
	return ""


## The tags under a boxer: HURT and TIRED (gas under 35) can both show, and ON THE ROPES for the pinned side.
static func tags_for(g: float, is_hurt: bool, is_pinned: bool) -> Array:
	var out: Array = []
	if is_hurt:
		out.append("HURT")
	if g < 35.0:
		out.append("TIRED")
	if is_pinned:
		out.append("ON THE ROPES")
	return out


## The plan's line, drawn from your boxer, by what the exchange recorded (RingMap.LEGEND): solid = thrown and won, a
## cross = thrown and lost, hollow = held, dotted = not ready, faint = the plan's line for the next opening. A punch
## line (no direction) is said, not drawn. drop = the label's extra offset, so two marks never sit on each other.
func _plan_arrow(m: Dictionary, a: Vector2, b: Vector2, body: float, drop: float) -> void:
	if m.is_empty():
		return
	var st := str(m["state"])
	var col := Color(HER, 0.95) if st == "worked" else (Color(HER, 0.35) if st == "faint" else Color(Palette.MUTED, 0.9))
	var word := ("next: the plan has %s here" if st == "faint" else "plan: %s - " + str(RingMap.STATE_WORDS.get(st, st))) % str(m["name"]).to_lower()
	if str(m.get("why", "")) != "":
		word += ": " + str(m["why"])
	var font := get_theme_default_font()
	if str(m["dir"]) == "":
		draw_string(font, _word_at(Vector2(a.x - 150.0, minf(a.y, b.y) - body - 46.0 - drop)), word, HORIZONTAL_ALIGNMENT_CENTER, 300.0, 16, col)
		return
	var d := (b - a).normalized()
	var dir := -d if str(m["dir"]) == "back" else (d if str(m["dir"]) == "in" else Vector2(-d.y, d.x))
	var from := a + dir * (body + 10.0)
	var reach := body + 0.75 * _scale()
	if str(m["dir"]) == "in":   # never drawn through the other boxer
		reach = clampf(a.distance_to(b) - body - 22.0, body + 14.0, reach)
	var to := a + dir * reach
	_mark_line(from, to, st, col)
	draw_string(font, _word_at(Vector2(a.x - 150.0, minf(a.y, b.y) - body - 46.0 - drop)), word, HORIZONTAL_ALIGNMENT_CENTER, 300.0, 16, col)   # above the pair: never under a boxer


## A plan label's place (300 px wide), kept inside the view and clear of the small ring in its top right corner.
func _word_at(p: Vector2) -> Vector2:
	var r := _ring_rect()
	p.x = clampf(p.x, r.position.x + 6.0, r.end.x - 306.0)
	p.y = clampf(p.y, r.position.y + 20.0, r.end.y - 8.0)
	if p.x + 300.0 > r.end.x - MINI - 16.0 and p.y < r.position.y + MINI + 34.0:
		p.y = r.position.y + MINI + 34.0
	return p


## One mark in its state's stroke (also the legend's samples).
func _mark_line(from: Vector2, to: Vector2, st: String, col: Color) -> void:
	var dir := (to - from).normalized()
	var s := Vector2(-dir.y, dir.x)
	var k := clampf(from.distance_to(to) / 60.0, 0.45, 1.0)
	var head := PackedVector2Array([to + dir * 16.0 * k, to + s * 11.0 * k, to - s * 11.0 * k])
	if st == "not_ready":
		draw_dashed_line(from, to, col, 4.0 * k, 5.0)
	elif st == "held":
		draw_line(from + s * 4.0 * k, to + s * 4.0 * k, col, 2.0, true)
		draw_line(from - s * 4.0 * k, to - s * 4.0 * k, col, 2.0, true)
	else:
		draw_line(from, to, col, (3.0 if st == "faint" else 5.0) * k, true)
	if st == "held" or st == "not_ready":
		draw_polyline(PackedVector2Array([head[0], head[1], head[2], head[0]]), col, 2.0, true)
	else:
		draw_colored_polygon(head, col)
	if st == "lost":
		var mid := (from + to) * 0.5
		draw_line(mid + Vector2(-12, -12) * k, mid + Vector2(12, 12) * k, Palette.BAD_FILL, 4.0 * k, true)
		draw_line(mid + Vector2(-12, 12) * k, mid + Vector2(12, -12) * k, Palette.BAD_FILL, 4.0 * k, true)


## The legend, bottom left of the view: one sample stroke and its words per state.
func _draw_legend(r: Rect2) -> void:
	var font := get_theme_default_font()
	var rows: Array = RingMap.LEGEND
	var box := Rect2(r.position.x + 10.0, r.end.y - 24.0 * rows.size() - 16.0, 300.0, 24.0 * rows.size() + 10.0)
	draw_rect(box, Color(Palette.PAGE, 0.85))
	for k in rows.size():
		var y := box.position.y + 18.0 + 24.0 * k
		var st := str(rows[k][0])
		var col := Color(HER, 0.95) if st == "worked" else (Color(HER, 0.35) if st == "faint" else Color(Palette.MUTED, 0.9))
		_mark_line(Vector2(box.position.x + 10.0, y - 5.0), Vector2(box.position.x + 44.0, y - 5.0), st, col)
		draw_string(font, Vector2(box.position.x + 66.0, y), str(rows[k][2]), HORIZONTAL_ALIGNMENT_LEFT, 230.0, 14, Palette.TEXT)


## The last two settled rounds' attempted lines, dim, top left, each under its round's label.
func _draw_ghosts(r: Rect2) -> void:
	var font := get_theme_default_font()
	var y := r.position.y + 24.0
	for g in RingMap.ghosts(past):
		draw_string(font, Vector2(r.position.x + 12.0, y), "ROUND %d" % int(g["n"]), HORIZONTAL_ALIGNMENT_LEFT, 300.0, 13, Color(Palette.MUTED, 0.9))
		y += 18.0
		for row in g["rows"]:
			draw_string(font, Vector2(r.position.x + 12.0, y), "%s: worked %d, lost %d" % [str(row["name"]).to_lower(), int(row["worked"]), int(row["lost"])],
				HORIZONTAL_ALIGNMENT_LEFT, 320.0, 14, Color(Palette.TEXT, 0.55))
			y += 18.0
		y += 6.0


## A role word above each boxer; under it HURT (red), TIRED (amber) and ON THE ROPES, each on its own line - together
## when they are true together. Static: nothing pulses, so nothing is lost with motion turned down.
func _tags(p: Vector2, other: Vector2, role: String, g: float, is_hurt: bool, body: float, is_pinned: bool) -> void:
	var font := get_theme_default_font()
	var away := signf(p.x - other.x) if absf(p.x - other.x) > 1.0 else 1.0   # the role word leans away from the other boxer
	draw_string(font, p + Vector2(-80.0 + away * 40.0, -body - 22.0), role, HORIZONTAL_ALIGNMENT_CENTER, 160.0, 14, Palette.MUTED)
	var y := body + 40.0
	for tag in tags_for(g, is_hurt, is_pinned):
		draw_string(font, p + Vector2(-90.0, y), tag, HORIZONTAL_ALIGNMENT_CENTER, 180.0, 20 if tag != "ON THE ROPES" else 15,
			Palette.BAD_FILL if tag == "HURT" else Palette.WARN)
		y += 22.0


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
