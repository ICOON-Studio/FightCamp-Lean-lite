extends Control
## S342 C158 (operator on the attributes board: "better but still needs a lot of improvement"): one attribute as a bar -
## filled to her value in its band colour, a dark tick at her potential (how far she can still go), the scale 0-100 so
## every bar reads the same. Grows in when it appears (operator S2xx: every meter tweens). `scale_mode` draws a
## two-ended scale instead (temper: patient <-> trader) - a dot on a track, no fill.

const UI := preload("res://scripts/ui/UI.gd")
const GROW_S := 0.45
const H := 12.0

var value := 50.0
var pot := 0.0
var colour := UI.MUTED
var scale_mode := false
var grow := 0.0:
	set(v):
		grow = v
		queue_redraw()


func _init() -> void:
	custom_minimum_size = Vector2(120, 18)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	var tw := create_tween()
	tw.tween_property(self, "grow", 1.0, GROW_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _draw() -> void:
	var y := (size.y - H) * 0.5
	var w := size.x
	draw_rect(Rect2(0, y, w, H), Color(UI.LINE, 0.55), true)
	var x := w * clampf(value / 100.0, 0.0, 1.0) * grow
	if scale_mode:
		draw_line(Vector2(w * 0.5, y - 2), Vector2(w * 0.5, y + H + 2), UI.MUTED, 1.0)
		draw_circle(Vector2(x, y + H * 0.5), H * 0.75, colour)
		return
	draw_rect(Rect2(0, y, x, H), colour, true)
	if pot > 0.0:
		var px := w * clampf(pot / 100.0, 0.0, 1.0)
		draw_rect(Rect2(px - 1.5, y - 3, 3, H + 6), UI.FG, true)
