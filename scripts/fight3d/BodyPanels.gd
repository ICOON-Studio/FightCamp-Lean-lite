extends Node
## S405 the holo on each side of the live round is back (operator: "i told you to put the holo on each side and blink the area
## that gets hit, on critical hits pop up the right organ flashing, and the wholo changes colors on the damaged or tired
## areas"; the S318-S379 panels came out at S381 HOLOOFF, this is their return).
## Each boxer's muscle holo stands free at an edge of the screen. A landed punch blinks the struck place. A
## critical hit (a big punch, or a place dropping a band) pops that place's organ out, flashing. The figure keeps the colours:
## this round's hits, the damage bands, and the tired parts (BodyBurn's track).
##   attach(view, live) -> BodyPanels   struck(side, before, lost, move, big)   critical_place(before, after, lost, big)

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BandWords := preload("res://scripts/rules/BandWords.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const BodyTurn := preload("res://scripts/ui/BodyTurn.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const RoundHits := preload("res://scripts/ui/RoundHits.gd")

const FIG_SIZE := Vector2(320, 540)   # free at the edge: no plate behind it, so only the figure shows
const HOME := [Rect2(20, 350, 320, 540), Rect2(1580, 350, 320, 540)]
const CORNER := ["red", "blue"]
const CORNER_WHO := ["a", "b"]
const PAINT_S := 0.5   # the corner's jobs and the tired parts change between punches
const KEY_WORDS := "Own colours = fresh. Green = warm, yellow = hot, red = burning: how hard that part has worked.\nRed skin on the face or ribs = hurt there."

var view: Control
var live: Node   # BodyLive: the bout's map, what each place took, the punch stats
var figures: Array = []
var panels: Array = []
var words: Array = []   # S405 the number of punches per area this round, over each figure (RoundHits)
var _paint_left := 0.0


static func attach(v: Control, bl: Node) -> Node:
	var p := new()
	p.name = "BodyPanels"
	p.view = v
	p.live = bl
	v.add_child(p)
	p._build()
	return p


func _build() -> void:
	for side in 2:
		var panel := Control.new()
		panel.name = "BodyPanel%d" % side
		panel.visible = false   # up with the scorebug (_process)
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var fig: Control = BodyFigure.new()
		fig.custom_minimum_size = FIG_SIZE
		fig.set("blink", true)
		fig.set("no_plate", true)
		var glb := str(view.get("bodies")[side]) if view.get("bodies") != null else ""
		var still: Dictionary = BodyFigure.portrait_for(glb, CORNER[side])
		if still.get("holo", false) or not BodyTurn.attach(fig, glb, CORNER[side]):
			fig.set_portrait(still)
		panel.add_child(fig)
		fig.tip_fn = _fig_tip.bind(fig, side)
		BodyTip.attach(fig)
		var layer := RoundHits.lay_on(fig, {})
		layer.set("size_px", 26)
		words.append(layer)   # S405 operator: "a number on each part ... how many hits each area has received"
		var co := BodyCallouts.attach(fig, still, -1.0 if side == 0 else 1.0, _card_tip.bind(side))
		if co != null:
			co.set("line_fn", _no_line)
			co.set("marks", live.map[CORNER_WHO[side]])
			co.call("go_live")
		view.add_child(panel)
		var home: Rect2 = HOME[side]
		panel.position = home.position
		panel.size = home.size
		panel.custom_minimum_size = home.size
		fig.custom_minimum_size = home.size
		fig.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		panels.append(panel)
		figures.append(fig)
	_repaint(0)
	_repaint(1)


## The place whose organ pops: on a big punch the place that lost most, otherwise a place that just dropped a damage band;
## "" when neither. Pure.
static func critical_place(before: Dictionary, after: Dictionary, lost: Dictionary, big: bool) -> String:
	var worst := ""
	for p in lost:
		if worst == "" or float(lost[p]) > float(lost[worst]):
			worst = str(p)
	if big:
		return worst
	for p in lost:
		if BodyMap.band(float(after.get(p, 100.0))) != BodyMap.band(float(before.get(p, 100.0))):
			return str(p)
	return ""


## A landed punch on boxer `side`: every struck place blinks, the colours update, and a critical hit pops its organ.
func struck(side: int, before: Dictionary, lost: Dictionary, move: String, big: bool) -> void:
	if figures.size() < 2:
		return
	var fig: Control = figures[side]
	for p in lost:
		fig.hit(p, move.replace("_", " "))
	_repaint(side)
	var co: Node = fig.get_node_or_null("BodyCallouts")
	if co == null:
		return
	var after := {}
	for p in lost:
		after[p] = BodyMap.value(live.map, CORNER_WHO[side], p)
	var place := critical_place(before, after, lost, big)
	if place != "":
		co.call("struck", place)


func _repaint(side: int) -> void:
	var fig: Control = figures[side]
	var round_n := int(view.get("round_n")) if view.get("round_n") != null else 1
	var hits: Dictionary = live.round_hits(side, round_n)
	fig.set("round_hits", hits)
	words[side].set("hits", hits)
	(words[side] as Control).queue_redraw()
	var burn: Node = view.get("burn")
	if burn != null:
		fig.set_track(burn.track(side))
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(live.map, CORNER_WHO[side], p)
	fig.set_values(vals)
	var st: Dictionary = live.stats[side]
	var acc := 0 if int(st["thrown"]) == 0 else int(round(100.0 * int(st["landed"]) / int(st["thrown"])))
	fig.set("extra_tip", "%s\nPunches landed: %d of %d thrown (%d%%)\nJabs landed: %d of %d\nPower punches landed: %d of %d\nLanded to the body: %d\n\n%s\n%s" % [
		str(view.get("_names")[side]).to_upper(), st["landed"], st["thrown"], acc,
		st["jab_l"], st["jab_t"], st["pow_l"], st["pow_t"], st["body"], KEY_WORDS, BandWords.key()])   # DEFECTS1: the band legend from the one table


func _place_tip(place: String, side: int) -> String:
	return live.place_tip(live.map, CORNER_WHO[side], live.taken[side], place)


## The card's hover text: the short organ line, then the place. The line is not drawn across the organ picture.
func _card_tip(place: String, side: int) -> String:
	var line := ""
	var k := BodyCallouts.spot_of(place)
	if k >= 0:
		line = _spot_line(BodyCallouts.SPOTS[k], side)
	var more := _place_tip(place, side)
	if line == "":
		return more
	if more == "":
		return line
	return "%s\n%s" % [line, more]


static func _no_line(_s: Dictionary) -> String:
	return ""


## The figure's tooltip on a place: none where a close-up covers it (that card is the tooltip).
func _fig_tip(place: String, fig: Control, side: int) -> String:
	if fig.get_node_or_null("BodyCallouts") != null and BodyCallouts.spot_of(place) >= 0:
		return ""
	return _place_tip(place, side)


func _spot_line(s: Dictionary, side: int) -> String:
	return live.spot_line(live.map, CORNER_WHO[side], live.taken[side], s)


func _process(delta: float) -> void:
	for p in panels:
		(p as Control).visible = view._bug_box.visible   # they come and go with the scorebug (intro, corner minute, result)
	_paint_left -= delta
	if _paint_left > 0.0 or figures.size() < 2:
		return
	_paint_left = PAINT_S
	_repaint(0)
	_repaint(1)


## The side panel's drawn meters (SidePanel). They live here so that file stays under 500 lines.
class Tank extends Control:
	var fill := 1.0
	var mark := -1.0
	var hatched := false
	var col := Color("#f2c14e")
	var band_lo := -1.0
	var band_hi := -1.0

	func set_fill(v: float, dashed: float) -> void:
		fill = clampf(v, 0.0, 1.0)
		mark = dashed
		hatched = false
		band_lo = -1.0
		band_hi = -1.0

	func set_known(v: float, known: bool) -> void:
		hatched = not known
		fill = clampf(v, 0.0, 1.0)
		mark = -1.0
		band_lo = -1.0
		band_hi = -1.0

	func set_range(truth: float, scouted: bool) -> void:
		var half := 3.0 if scouted else 8.0
		band_lo = clampf((truth - half) / 100.0, 0.0, 1.0)
		band_hi = clampf((truth + half) / 100.0, 0.0, 1.0)
		hatched = false
		mark = -1.0
		fill = truth / 100.0

	func _draw() -> void:
		var wide := size.x >= size.y
		draw_rect(Rect2(Vector2.ZERO, size), Color("#0f0d0b"))
		if hatched:
			var y := 0.0
			while y < size.y + size.x:
				draw_line(Vector2(0, y), Vector2(size.x, y - size.x), Color("#2b2520"), 5.0)
				y += 12.0
			return
		if band_lo >= 0.0:
			if wide:
				var x0 := size.x * band_lo
				var x1 := size.x * band_hi
				draw_rect(Rect2(x0, 0, maxf(4.0, x1 - x0), size.y), col)
			else:
				var y0 := size.y * (1.0 - band_hi)
				var y1 := size.y * (1.0 - band_lo)
				draw_rect(Rect2(0, y0, size.x, maxf(4.0, y1 - y0)), col)
			return
		if wide:
			draw_rect(Rect2(0, 0, size.x * fill, size.y), col)
			if mark < 0.0:
				return
			var mx := size.x * clampf(mark, 0.0, 1.0)
			var tick := 0.0
			while tick < size.y:
				draw_line(Vector2(mx, tick), Vector2(mx, minf(tick + 4.0, size.y)), Color("#fff4cc"), 2.0)
				tick += 7.0
			return
		var h := size.y * fill
		draw_rect(Rect2(0, size.y - h, size.x, h), col)
		if mark < 0.0:
			return
		var my := size.y * (1.0 - clampf(mark, 0.0, 1.0))
		var x := 0.0
		while x < size.x:
			draw_line(Vector2(x, my), Vector2(minf(x + 5.0, size.x), my), Color("#fff4cc"), 3.0)
			x += 9.0


class Ear extends Control:
	var lit := true

	func _draw() -> void:
		var c := Color("#f2c14e") if lit else Color("#b8a88f")
		draw_arc(size * 0.5, minf(size.x, size.y) * 0.38, -1.3, 1.3, 18, c, 4.0, true)
		draw_circle(size * 0.55, 3.5, c)


class Pip extends Control:
	var on := false

	func _draw() -> void:
		draw_circle(size * 0.5, minf(size.x, size.y) * 0.42, Color("#f2c14e") if on else Color("#5a4a3a"))
