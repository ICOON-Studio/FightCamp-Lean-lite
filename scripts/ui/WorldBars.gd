extends RefCounted
## Win-chance bars and the side-by-side ranges on World > Rankings (LOOKSLATE6).
## The track is quiet chalk, the fill stays the ring blue, and a range still being scouted is hatched so it reads on slate.

const WoodKit := preload("res://scripts/ui/WoodKit.gd")


class ChanceBar extends Control:
	var lo := 0.0
	var hi := 1.0
	var scouted := 0

	func _ready() -> void:
		custom_minimum_size = Vector2(64, 10)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(WoodKit.SOFT, 0.30))
		var x := clampf(lo, 0.0, 1.0) * size.x
		var span := maxf(4.0, (clampf(hi, 0.0, 1.0) - clampf(lo, 0.0, 1.0)) * size.x)
		var rect := Rect2(Vector2(x, 1.0), Vector2(span, maxf(1.0, size.y - 2.0)))
		var fill := WoodKit.blue(self)
		draw_rect(rect, fill)
		if scouted < 2:
			_hatch(rect, Color(WoodKit.SOFT, 0.5))
		draw_rect(rect, fill, false, 1.0)

	func _hatch(rect: Rect2, ink: Color) -> void:
		var h := rect.size.y
		var x := rect.position.x - h
		var guard := 0
		while x < rect.end.x and guard < 48:
			var x0 := maxf(x, rect.position.x)
			var x1 := minf(x + h, rect.end.x)
			if x1 > x0:
				draw_line(Vector2(x0, rect.position.y + (x0 - x)), Vector2(x1, rect.position.y + (x1 - x)), ink, 2.0)
			x += 4.0
			guard += 1


class RangeMark extends Control:
	var lo := 0.0
	var hi := 1.0
	var mark := 0.5

	func _ready() -> void:
		custom_minimum_size = Vector2(140, 12)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(WoodKit.SOFT, 0.30))
		var x := clampf(lo, 0.0, 1.0) * size.x
		var w := maxf(4.0, (clampf(hi, 0.0, 1.0) - clampf(lo, 0.0, 1.0)) * size.x)
		var rect := Rect2(Vector2(x, 1.0), Vector2(w, maxf(1.0, size.y - 2.0)))
		var fill := WoodKit.blue(self)
		draw_rect(rect, Color(fill, 0.45))
		_hatch(rect, Color(WoodKit.SOFT, 0.5))
		var at := clampf(mark, 0.0, 1.0) * size.x
		draw_rect(Rect2(Vector2(at - 2.0, -2.0), Vector2(4.0, size.y + 4.0)), fill)

	func _hatch(rect: Rect2, ink: Color) -> void:
		var h := rect.size.y
		var x := rect.position.x - h
		var guard := 0
		while x < rect.end.x and guard < 48:
			var x0 := maxf(x, rect.position.x)
			var x1 := minf(x + h, rect.end.x)
			if x1 > x0:
				draw_line(Vector2(x0, rect.position.y + (x0 - x)), Vector2(x1, rect.position.y + (x1 - x)), ink, 2.0)
			x += 4.0
			guard += 1
