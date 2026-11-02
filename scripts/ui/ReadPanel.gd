extends RefCounted
## S333 THE READ on screen (operator S332: "make it look as good and how UFC would make it" - their broadcast style, never
## their branding): a dark slab with the red corner's bar, condensed capitals, the read meter sweeping up to how much of
## the opponent's habit our fighter has read, a white tick where she pulls the trigger, and the two corner calls -
## WAIT FOR IT (hold the trigger up) and TAKE IT NOW (fire on what she has). read = LiveRound.read_view; pick(call).

const UI := preload("res://scripts/ui/TV.gd")

const SLAB := Color(0.04, 0.04, 0.05, 0.92)
const CORNER := Color("#d4202a")
const READY := Color("#f5c518")
const STEEL := Color("#2a2d33")


static func build(read: Dictionary, read_call: String, names: Array, pick: Callable) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "ReadPanel"
	var sb := UI.box(SLAB, Color(0, 0, 0, 0), 0, 0, 0, 0)
	sb.border_width_left = 8
	sb.border_color = CORNER
	p.add_theme_stylebox_override("panel", sb)
	if read.is_empty():
		return p
	var m := MarginContainer.new()
	for side in ["left", "right"]:
		m.add_theme_constant_override("margin_" + side, 16)
	m.add_theme_constant_override("margin_top", 8)
	m.add_theme_constant_override("margin_bottom", 8)
	p.add_child(m)
	var h := UI.hbox(18)
	m.add_child(h)
	var tag := UI.vbox(0)
	tag.add_child(UI.label("THE READ", 30, Color.WHITE, "display"))
	tag.add_child(UI.label(str(read["temper"]).to_upper(), UI.TINY, READY if str(read["temper"]) == "gambler" else UI.MUTED, "caps"))
	h.add_child(tag)
	var mid := UI.vbox(4)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var top := UI.hbox(10)
	var ready := float(read["read"]) >= float(read["trig"])
	top.add_child(UI.label("%s %s" % [str(names[1]).to_upper(), str(read["label"]).to_upper()], 22, Color.WHITE, "display"))
	top.add_child(UI.spacer())
	var pct := UI.label("%d%%" % roundi(float(read["read"]) * 100.0), 30, READY if ready else Color.WHITE, "display")
	pct.name = "ReadPct"
	top.add_child(pct)
	mid.add_child(top)
	var meter := Meter.new()
	meter.name = "ReadMeter"
	meter.trig = float(read["trig"])
	meter.is_ready = ready
	mid.add_child(meter)
	meter.create_tween().tween_property(meter, "frac", clampf(float(read["read"]), 0.0, 1.0), 0.7) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var sub := "%s - COUNTER: %s" % [("READ IT" if ready else "STILL READING"), str(read["counter"]).to_upper()]
	if bool(read.get("dropped", false)):
		sub = "SHE HAS DROPPED IT"
	mid.add_child(UI.label(sub, UI.TINY + 1, READY if ready else UI.MUTED, "caps"))
	h.add_child(mid)
	for k in [["wait", "WAIT FOR IT", "hold the punch back"], ["take", "TAKE IT NOW", "throw it on %d%%" % roundi(float(read["read"]) * 100.0)]]:
		var on: bool = read_call == str(k[0])
		var b := UI.button2(k[1], k[2], "Choice", pick.bind(k[0]), Vector2(170, 58), Color.WHITE if not on else Color("#14110f"),
			UI.MUTED if not on else Color("#3a2a10"), false, 20, UI.TINY)
		b.name = "Read_" + k[0]
		var bg := READY if on else STEEL
		b.add_theme_stylebox_override("normal", UI.box(bg, Color(1, 1, 1, 0.18), 0, 1, 12, 6))
		b.add_theme_stylebox_override("hover", UI.box(bg.lightened(0.12), Color(1, 1, 1, 0.4), 0, 1, 12, 6))
		for l in b.find_children("*", "Label", true, false):
			if (l as Label).text == k[1]:
				(l as Label).add_theme_font_override("font", UI.font("display"))
		h.add_child(b)
	return p


## The read meter: a flat steel track, the red corner's fill (gold once she has read it), a white tick at her trigger.
class Meter extends Control:
	var trig := 0.7
	var is_ready := false
	var frac := 0.0:
		set(v):
			frac = v
			queue_redraw()

	func _init() -> void:
		custom_minimum_size = Vector2(0, 16)
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#2a2d33"))
		var w := size.x * clampf(frac, 0.0, 1.0)
		draw_rect(Rect2(0, 0, w, size.y), Color("#f5c518") if is_ready else Color("#d4202a"))
		# A lighter stripe on the top third: the broadcast bars' sheen.
		draw_rect(Rect2(0, 0, w, size.y * 0.3), Color(1, 1, 1, 0.18))
		var x := size.x * clampf(trig, 0.0, 1.0)
		draw_rect(Rect2(x - 2, -4, 4, size.y + 8), Color.WHITE)
