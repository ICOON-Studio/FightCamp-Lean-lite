extends RefCounted
## S496 split out of WeekCards.gd (the 500-line rule): the week's two drawn bars - a tiredness bar in its zones (ZoneBar)
## and the goal row's bar (GoalBar).

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")


## A tiredness bar: the fill in its zone colour, ticks at 70 and 80; zones = true paints the zones on the track.
class ZoneBar extends Control:
	var value := 0.0
	var zones := false

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		var w := size.x
		var hh := size.y
		var dark := WoodKit.on_dark(self)
		draw_rect(Rect2(0, 0, w, hh), Color(WoodKit.SOFT, 0.22) if dark else Color("#eceff2"))
		var amber := Color(UI.AMBER, 0.55) if dark else Color("#f5d9a8")
		var red := Color(UI.RED, 0.5) if dark else Color("#f3b8b2")
		draw_rect(Rect2(w * 0.7, 0, w * 0.1, hh), amber)   # S398: the zones on every bar
		draw_rect(Rect2(w * 0.8, 0, w * 0.2, hh), red)
		if zones:
			draw_rect(Rect2(0, hh * 0.2, w * clampf(value / 100.0, 0.0, 1.0), hh * 0.6), WoodKit.fg(self))
		else:
			var col := UI.RED if value >= 80.0 else (UI.AMBER if value >= 70.0 else (WoodKit.SOFT if dark else Color("#7a8794")))
			draw_rect(Rect2(0, 0, w * clampf(value / 100.0, 0.0, 1.0), hh), col)


## The GOAL row's bar (gold = the goal): it spans today's value to the target; gold fills to Sunday, a dashed tick marks
## where this pace ends, the target's number at the right end.
class GoalBar extends Control:
	var now := 0.0
	var week := 0.0
	var pace := 0.0
	var target := 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		custom_minimum_size = Vector2(380, 30)
		tooltip_text = "%.1f now, %.1f by Sunday, %.1f at this pace, target %.0f" % [now, week, pace, target]
		resized.connect(queue_redraw)

	func _x(v: float) -> float:
		var span := maxf(0.5, target - now)
		return clampf((v - now) / span, 0.0, 1.0) * (size.x - 16.0)

	func _draw() -> void:
		var hh := 12.0
		var ink := WoodKit.fg(self)
		var dark := WoodKit.on_dark(self)
		draw_rect(Rect2(0, 0, size.x - 16.0, hh), Color(WoodKit.SOFT, 0.28) if dark else Color("#eef0f2"))
		draw_rect(Rect2(0, 0, maxf(3.0, _x(week)), hh), Color("#e0a400"))
		var px := _x(pace)
		var y := -3.0
		while y < hh + 3.0:
			draw_line(Vector2(px, y), Vector2(px, minf(y + 3.0, hh + 3.0)), Color("#b07f00"), 2.0)
			y += 5.0
		var tx := size.x - 16.0
		draw_line(Vector2(tx, -4), Vector2(tx, hh + 4), ink, 2.0)
		var f := ThemeDB.fallback_font
		draw_string(f, Vector2(tx - 8, hh + 17), "%d" % roundi(target), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, ink)
