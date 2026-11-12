extends Control
## S381 G1 (gym idea 5, survivor 1): the thin threshold bar on each camp card - from now to fight night, with a gold tick at
## the stat number that changes the night (BoutRules.NIGHT_LINES: power past 60 the body call, technique past 61 "jab and
## move", Stamina at BoutRules.FADE_STAMINA no round-3 fade, S434 CARDIO1). The bar turns gold when the forecast crosses the tick. It replaces the text
## line under the card. Today's part is ink, the camp's gain green (gold once over the line); `end` tweens on from the last
## shown forecast (operator: animated meters) and the colour flips the moment the count passes the tick.
##   NightBar.make(stat, now, end, from) -> NightBar "NightBar"     window(now, end, at) -> Vector2     frac(x, win) -> float

const UI := preload("res://scripts/ui/UI.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

const H := 18.0
const BAR_H := 8.0
const TWEEN_S := 0.45
const TRACK := Color("#dfe6eb")
## Whole points of room either side of the numbers the bar shows.
const PAD := 1.0

var stat := ""
var now := 0.0
var end := 0.0:
	set(value):
		end = value
		queue_redraw()
var at := -1.0   # the night line; < 0 = none


## The bar for one card: now -> the fight-night forecast `end`; it counts on from `from` when that differs.
static func make(stat_key: String, now_v: float, end_v: float, from: float) -> Control:
	var b: Control = load("res://scripts/ui/NightBar.gd").new()
	b.name = "NightBar"
	b.stat = stat_key
	b.now = now_v
	var l := BoutRules.night_line(stat_key)
	b.at = float(l["at"]) if not l.is_empty() else -1.0
	b.custom_minimum_size = Vector2(0, H)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.end = end_v
	if absf(end_v - from) >= 0.001:
		b.end = from
		var go := func() -> void:
			b.create_tween().tween_property(b, "end", end_v, TWEEN_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		b.ready.connect(go, CONNECT_ONE_SHOT)
	return b


## The stretch of the stat the bar spans: whole points from PAD under the lower of now / the line to PAD over the higher of
## the forecast / the line (at < 0: no line). x = low end, y = high end.
static func window(now_v: float, end_v: float, at_v: float) -> Vector2:
	var lo := minf(now_v, at_v) if at_v >= 0.0 else now_v
	var hi := maxf(maxf(end_v, now_v), at_v)
	lo -= TrainingPreview.progress_to_next(lo)   # down to its whole point
	return Vector2(lo - PAD, ceilf(hi) + PAD)


## Where `x` sits along the window, 0..1.
static func frac(x: float, win: Vector2) -> float:
	return clampf((x - win.x) / maxf(win.y - win.x, 0.001), 0.0, 1.0)


## True when the forecast on screen is over the line (the bar is gold).
func crossed() -> bool:
	return at >= 0.0 and BoutRules.clears_night_line(stat, end)


func _draw() -> void:
	var win := window(now, end, at)
	var y := (size.y - BAR_H) / 2.0
	var w := size.x
	draw_style_box(_round(TRACK), Rect2(Vector2(0, y), Vector2(w, BAR_H)))
	var x_now := frac(now, win) * w
	var x_end := frac(maxf(end, now), win) * w
	var gain := UI.GOLD if crossed() else UI.GREEN
	if x_end > x_now:
		draw_style_box(_round(gain), Rect2(Vector2(0, y), Vector2(maxf(x_end, BAR_H), BAR_H)))
	draw_style_box(_round(UI.WoodKit.muted(self)), Rect2(Vector2(0, y), Vector2(maxf(x_now, BAR_H), BAR_H)))
	if at >= 0.0:   # the gold tick, standing proud of the bar, edged in white so it reads on a gold fill too
		var x := frac(at, win) * w
		draw_rect(Rect2(Vector2(x - 3.0, 0.0), Vector2(6.0, size.y)), UI.PANEL)
		draw_rect(Rect2(Vector2(x - 1.5, 0.0), Vector2(3.0, size.y)), UI.GOLD)


static func _round(c: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = c
	s.set_corner_radius_all(int(BAR_H / 2.0))
	s.anti_aliasing = true
	return s
