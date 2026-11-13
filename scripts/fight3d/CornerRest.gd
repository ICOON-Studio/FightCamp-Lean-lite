extends HBoxContainer
## S395 the minute's rest, on the top bar (blind review: the rings left at 62/65 and came back at 81/75 with nothing between,
## so who looked fresher flipped unexplained). Both tanks climb from the bell to the number the next round opens on, full by
## "Seconds out!", quickest at the start of the rest as a real recovery is. The second's water points move her target. Each
## side shows what the rest has given back, and the middle names who is fresher.
##   setup(names, bell, next)   aim(side, value)   tick(frac)   number(side)   at(from, to, frac)

const UI := preload("res://scripts/ui/TV.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const BLUE := Color("#6f9cf0")
const BAR := Vector2(120, 10)
## Under this gap neither looks the fresher.
const LEVEL_UNDER := 3.0

var _bell := [100.0, 100.0]
var _next := [100.0, 100.0]
var _frac := 0.0
var _nums: Array = []
var _bars: Array = []
var _gains: Array = []
var _word: Label
var _names: Array = []
var _parts: Array = [{}, {}]   # per boxer {name: [from, to]}: legs and guard (HudBars.recovered)
var _sub: Label = null


## Where a tank stands after `frac` of the rest. It never falls: the rest only gives back.
static func at(from: float, to: float, frac: float) -> float:
	var k := clampf(frac, 0.0, 1.0)
	return lerpf(from, maxf(from, to), 1.0 - (1.0 - k) * (1.0 - k))


## What the next round opens on for her: the rest (`from`), plus the second's water, less the body shots the ice left her
## (BoutNight._open spends the same points, LiveRound.her_energy takes the body off).
static func opens(from: float, points: Dictionary, menu: Dictionary) -> float:
	if menu.is_empty():
		return minf(100.0, from)
	var body := int(menu.get("body", 0))
	var did := CornerJobs.recover(points, from, body, bool(menu.get("hurt", false)))
	return minf(100.0, from + float(did["energy"]) - float(body - int(did["body"])) * Exchanges.BODY_COST)


## One boxer's line under the tanks: "LEGS 74   GUARD 88".
static func parts_text(parts: Dictionary, frac: float) -> String:
	var out: Array = []
	for k in ["legs", "guard"]:
		if parts.has(k):
			out.append("%s %d" % [str(k).to_upper(), roundi(at(float(parts[k][0]), float(parts[k][1]), frac))])
	return "   ".join(out)


## The strip's middle word. It names whoever the rest leaves fresher, once the tanks show it, and then keeps it: read off the
## live gap alone it flickered between names on the way (blind review).
static func word(_names: Array, a: float, b: float, to_a: float, to_b: float) -> String:
	var lead := signf(to_a - to_b)
	if absf(to_a - to_b) < LEVEL_UNDER or (a - b) * lead < LEVEL_UNDER:
		return "ENERGY"
	return "YOUR BOXER FRESHER" if lead > 0.0 else "OPPONENT FRESHER"   # S448: roles, the names are on the plates


func setup(names: Array, bell: Array, next: Array) -> void:
	name = "CornerRest"
	_bell = bell.duplicate()
	_next = next.duplicate()
	_names = names
	alignment = BoxContainer.ALIGNMENT_CENTER
	add_theme_constant_override("separation", 10)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in 2:
		var col: Color = UI.RED if side == 0 else BLUE
		var who := UI.label(str(names[side]).to_upper(), UI.SMALL, col, "bold")
		var num := UI.label("", UI.BODY + 2, UI.FG, "bold")
		num.custom_minimum_size = Vector2(40, 0)
		num.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if side == 0 else HORIZONTAL_ALIGNMENT_LEFT
		var gain := UI.label("", UI.SMALL, UI.GREEN, "bold")
		gain.custom_minimum_size = Vector2(44, 0)
		gain.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if side == 0 else HORIZONTAL_ALIGNMENT_LEFT
		_gains.append(gain)
		var bar := _Tank.new()
		bar.fill = col
		bar.leftward = side == 0
		_nums.append(num)
		_bars.append(bar)
		for c in ([who, bar, num, gain] if side == 0 else [gain, num, bar, who]):
			add_child(c)
		if side == 0:
			_word = UI.caps("")
			_word.add_theme_color_override("font_color", UI.FG)
			_word.custom_minimum_size = Vector2(170, 0)
			_word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			add_child(_word)
	tick(0.0)


## The second line, under the tanks.
func body_line(parts: Array, line: Label) -> void:
	_parts = parts
	_sub = line
	tick(_frac)


func aim(side: int, value: float) -> void:
	_next[side] = value
	tick(_frac)


func tick(frac: float) -> void:
	_frac = frac
	for side in 2:
		(_nums[side] as Label).text = "%d" % int(round(number(side)))
		_bars[side].frac = number(side) / 100.0
		_bars[side].queue_redraw()
		var got := int(round(number(side) - float(_bell[side])))
		(_gains[side] as Label).text = "+%d" % got if got > 0 else ""
	_word.text = word(_names, number(0), number(1), float(_next[0]), float(_next[1]))
	if _sub != null:
		_sub.text = "%s          %s" % [parts_text(_parts[0], frac), parts_text(_parts[1], frac)]


func number(side: int) -> float:
	return at(float(_bell[side]), float(_next[side]), _frac)


## A thin tank that fills from the middle of the strip outwards, as the corner table's bars do.
class _Tank extends Control:
	var frac := 0.0
	var fill := Color.WHITE
	var leftward := false

	func _init() -> void:
		custom_minimum_size = BAR
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.12))
		var w := size.x * clampf(frac, 0.0, 1.0)
		draw_rect(Rect2(Vector2(size.x - w if leftward else 0.0, 0.0), Vector2(w, size.y)), fill)
