extends Control
## S443 C322 (operator on the plan cards' "Good at it, saves energy": "remove the good at it etc , shot the costs of energy
## instead"): a call's energy price drawn, not written. Read off Exchanges.CALLS "cost" (energy per 30-second exchange on
## top of the round's; below 0 gives energy back): green arrows up = saves, amber arrows down = costs, red = costs a lot,
## a grey dash = even. More arrows = more energy. The number itself is the hover.
##   count(cost) -> 0..3   colour(cost) -> Color   tip(cost) -> String   make(cost) -> EnergyPips

const SAVE := Color("#6cc27a")
const COST := Color("#f0a020")
const HEAVY := Color("#e0503c")
const EVEN := Color("#b5a595")
## A cost at or over this is "a lot" (CallButtons.energy_words used the same line).
const HEAVY_AT := 3.0
const MAX := 3
const PIP := Vector2(11, 10)
const GAP := 3.0

var cost := 0.0


## Arrows for a cost: one per energy point, rounded up, 1 to MAX; 0 for an even call.
static func count(c: float) -> int:
	if is_zero_approx(c):
		return 0
	return clampi(ceili(absf(c) - 0.001), 1, MAX)


static func colour(c: float) -> Color:
	if is_zero_approx(c):
		return EVEN
	if c < 0.0:
		return SAVE
	return HEAVY if c >= HEAVY_AT else COST


## "Energy +3 each 30 seconds" (the number the arrows are drawn from).
static func tip(c: float) -> String:
	if is_zero_approx(c):
		return "Energy: even"
	return "Energy %s%s each 30 seconds" % ["+" if c < 0.0 else "-", _num(absf(c))]


static func make(c: float) -> Control:
	var p: Control = load("res://scripts/ui/EnergyPips.gd").new()
	p.cost = c
	p.name = "EnergyPips"
	p.custom_minimum_size = Vector2(MAX * (PIP.x + GAP), PIP.y + 2.0)
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.tooltip_text = tip(c)
	return p


static func _num(v: float) -> String:
	return "%d" % int(v) if is_equal_approx(v, roundf(v)) else "%.1f" % v


func _draw() -> void:
	var n := count(cost)
	var col := colour(cost)
	var y0 := (size.y - PIP.y) * 0.5
	if n == 0:
		draw_rect(Rect2(Vector2(0.0, y0 + PIP.y * 0.5 - 1.5), Vector2(PIP.x * 1.4, 3.0)), col)
		return
	for i in n:
		var x := i * (PIP.x + GAP)
		var up := cost < 0.0
		var tri := PackedVector2Array([Vector2(x, y0 + (PIP.y if up else 0.0)), Vector2(x + PIP.x, y0 + (PIP.y if up else 0.0)),
			Vector2(x + PIP.x * 0.5, y0 + (0.0 if up else PIP.y))])
		draw_colored_polygon(tri, col)
