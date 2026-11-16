extends Control
## S491 operator on the fight hovers ("i have seen better from you . try harder"; "-14 in 100" read as nonsense): a hover
## card's odds drawn, not written. Small words over a bar centred on EVEN; the fill runs left in red (fewer wins) or right
## in green (more); the change in words under it. Used by Tips cards through spec "meter". Sized by the Text size setting.
##   TipMeter.make({shift: int, caption: String, span: int = 30}) -> TipMeter    TipMeter.words(shift) -> String

const Palette := preload("res://scripts/ui/Palette.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const GOOD := Palette.GOOD_FILL
const BAD := Palette.ACTION
const TRACK := Palette.TEXT
const INK := Palette.CARD
const W := 330.0
const H := 74.0

var shift := 0
var span := 30
var caption := ""


static func make(spec: Dictionary) -> Control:
	var m := new()
	m.name = "TipMeter"
	m.shift = int(spec.get("shift", 0))
	m.span = maxi(1, int(spec.get("span", 30)))
	m.caption = str(spec.get("caption", ""))
	var f := TextScale.factor()
	m.custom_minimum_size = Vector2(W * f, H * f)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return m


## The change in plain words: "6 more wins in 100", "14 fewer wins in 100", "No change".
static func words(n: int) -> String:
	if n == 0:
		return "No change"
	return "%d %s wins in 100" % [absi(n), "more" if n > 0 else "fewer"]


func _draw() -> void:
	var f := TextScale.factor()
	var font := get_theme_default_font()
	var small := TextScale.scaled(14, f)
	var w := size.x
	var top := float(small) + 4.0
	var bar_h := 18.0 * f
	draw_string(font, Vector2(0, small), "worse", HORIZONTAL_ALIGNMENT_LEFT, -1, small, BAD)
	draw_string(font, Vector2(0, small), "EVEN", HORIZONTAL_ALIGNMENT_CENTER, w, small, Color(INK, 0.7))
	draw_string(font, Vector2(0, small), "better", HORIZONTAL_ALIGNMENT_RIGHT, w, small, GOOD)
	draw_rect(Rect2(0, top, w, bar_h), TRACK)
	var mid := w * 0.5
	var len := clampf(float(absi(shift)) / float(span), 0.0, 1.0) * mid
	var col := GOOD if shift > 0 else BAD
	if shift > 0:
		draw_rect(Rect2(mid, top, len, bar_h), col)
	elif shift < 0:
		draw_rect(Rect2(mid - len, top, len, bar_h), col)
	draw_line(Vector2(mid, top - 3.0), Vector2(mid, top + bar_h + 3.0), INK, 2.0)
	var line := words(shift) + (", " + caption if caption != "" else "")
	draw_string(font, Vector2(0, top + bar_h + 6.0 + float(TextScale.scaled(19, f))), line, HORIZONTAL_ALIGNMENT_LEFT, w,
		TextScale.scaled(19, f), col if shift != 0 else INK)
