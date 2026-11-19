extends RefCounted
## S496 TRAININGK1: the Training screen's TIREDNESS row - the selected boxer's tiredness at the end of each day (WeekPlan:
## a night keeps 87 %, the day's work adds), the carried-in start, the "too tired: gains drop" line (WeekPlan.OVERREACHED: a
## morning from there trains at 60 %), the fresh line (BoutRules.FRESH_FATIGUE) and, with a bout, the first bell's estimate;
## beside it the DIET box (Normal / Cut harder) with the scale's forecast.
##   make(model, col_x: Array of day-centre x, on_diet: Callable(diet)) -> HBoxContainer

const B := preload("res://scripts/ui/TrainBits.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const INJURY_ICON := preload("res://assets/ui/art/injury/injury_risk.png")   # S528 Ludo (1.5 credits, 3 tries)

const H := 130.0


static func make(model: Dictionary, left_w: float, col_w: float, gap: float, on_diet: Callable) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "TrainTired"
	row.add_theme_constant_override("separation", 8)
	var lab := VBoxContainer.new()
	lab.custom_minimum_size = Vector2(left_w, H)
	lab.add_theme_constant_override("separation", 0)
	lab.alignment = BoxContainer.ALIGNMENT_CENTER
	lab.add_child(B.lab("TIREDNESS", 17, Palette.HEADER, "caps"))
	var sub := B.lab("end of each day", 16, Palette.MUTED, "body")
	sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lab.add_child(sub)
	lab.add_child(_risk_row(model["tired"]))
	row.add_child(lab)
	var ch := Chart.new()
	ch.name = "TiredChart"
	var t: Dictionary = model["tired"]
	ch.start = float(t["start"])
	ch.ends = t["ends"]
	ch.limit = float(t["limit"])
	ch.fresh = float(t["fresh"])
	ch.bell = float(t.get("bell", -1.0))
	ch.col_w = col_w
	ch.gap = gap
	ch.custom_minimum_size = Vector2(col_w * 7.0 + gap * 6.0, H)
	ch.tooltip_text = "Tiredness at the end of each day: %s. From %d a morning trains at 60%%." % [
		", ".join((t["ends"] as Array).map(func(x): return "%d" % roundi(float(x)))), roundi(float(t["limit"]))]
	row.add_child(ch)
	row.add_child(_diet(model, on_diet))
	return row


static func _diet(model: Dictionary, on_diet: Callable) -> PanelContainer:
	var d: Dictionary = model["diet"]
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 4)
	v.add_child(B.lab("DIET", 17, Palette.HEADER, "caps"))
	var sw := HBoxContainer.new()
	sw.add_theme_constant_override("separation", 0)
	for pair in [["Normal", "hold"], ["Cut harder", "cut"]]:
		var b := Button.new()
		b.name = "Diet_" + str(pair[1])
		b.text = str(pair[0])
		b.focus_mode = Control.FOCUS_NONE
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var on := str(d["diet"]) == str(pair[1])
		for st in ["normal", "hover", "pressed"]:
			b.add_theme_stylebox_override(st, UI.box(Palette.ACCENT if on else (Palette.HOVER if st == "hover" else Palette.PAGE), Palette.LINE, 5, 1, 6, 2))
		b.add_theme_color_override("font_color", Palette.ON_LIGHT if on else Palette.MUTED)
		b.add_theme_color_override("font_hover_color", Palette.TEXT)
		b.add_theme_font_size_override("font_size", 16)
		b.tooltip_text = "Eats for the training." if pair[1] == "hold" else "500 kcal a day less: about half a kilo a week."
		var k := str(pair[1])
		b.pressed.connect(func(): on_diet.call(k))
		sw.add_child(b)
	v.add_child(sw)
	var line := ""
	if bool(d["booked"]) and d.has("fight_kg"):
		line = "Fight day %.1f kg est.\nlimit %.1f kg" % [float(d["fight_kg"]), float(d["limit"])]
	else:
		line = "Sunday %.1f kg\nlimit %.1f kg" % [float(d["end_kg"]), float(d["limit"])]
	var l := B.lab(line, 16, Palette.TEXT, "bold")
	l.name = "DietLine"
	v.add_child(l)
	var p := B.wrap(v, Palette.PAGE, Palette.LINE, 8, 8)
	p.name = "Diet"
	p.custom_minimum_size = Vector2(170, 0)
	p.size_flags_vertical = Control.SIZE_SHRINK_END
	return p


## S528: the risk line, with Ludo's wrapped-fist icon in front when the risk is raised (x1.05 and up).
static func _risk_row(t: Dictionary) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.name = "InjuryRiskRow"
	h.add_theme_constant_override("separation", 4)
	if float(t.get("injury_x", 1.0)) >= 1.05:
		var ic := TextureRect.new()
		ic.name = "InjuryIcon"
		ic.texture = INJURY_ICON
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.custom_minimum_size = Vector2(22, 22)
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(ic)
	var l := _risk(t)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(l)
	return h


## S528: the week's injury risk (Injuries' week-end roll): hours against her usual x the week's peak tiredness.
static func _risk(t: Dictionary) -> Label:
	var x := float(t.get("injury_x", 1.0))
	var words := "injury risk normal" if x < 1.05 else "injury risk x%.1f" % x
	var l := B.lab(words, 16, Palette.GOOD if x < 1.05 else (Palette.WARN if x < 2.0 else Palette.BAD), "bold")
	l.name = "InjuryRisk"
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	l.tooltip_text = "This week's hours are %.1fx the usual and tiredness peaks at %d. The week-end injury roll climbs from 1.3x the usual hours and from 72 tiredness: x2 at 76, x3 from 80." % [
		float(t.get("load", 1.0)), roundi(float(t.get("peak", 0.0)))]
	return l


## The line: a hollow dot for the tiredness carried in, a dot and its number at each day's end (over each day's column),
## the dashed red line where gains drop, the dashed green fresh line, and the first bell's estimate with a bout.
class Chart extends Control:
	var start := 0.0
	var ends: Array = []
	var limit := 80.0
	var fresh := 50.0
	var bell := -1.0
	var col_w := 150.0
	var gap := 8.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		resized.connect(queue_redraw)

	func _y(v: float) -> float:
		return 22.0 + (size.y - 44.0) * (1.0 - clampf(v / 100.0, 0.0, 1.0))

	func _cx(i: int) -> float:
		return col_w * 0.5 + float(i) * (col_w + gap)

	func _draw() -> void:
		var f := UI.font("bold")
		draw_rect(Rect2(0, 0, size.x, size.y), Palette.alpha(Palette.PAGE, 0.6))
		_dash(_y(limit), Palette.BAD_FILL)
		draw_string(f, Vector2(6, _y(limit) - 6), "too tired: gains drop %d" % roundi(limit), HORIZONTAL_ALIGNMENT_LEFT, -1, _px(16), Palette.BAD)
		_dash(_y(fresh), Palette.GOOD_FILL)
		draw_string(f, Vector2(size.x - 60, _y(fresh) - 6), "fresh %d" % roundi(fresh), HORIZONTAL_ALIGNMENT_LEFT, -1, _px(16), Palette.GOOD)
		var pts := PackedVector2Array([Vector2(4, _y(start))])
		for i in ends.size():
			pts.append(Vector2(_cx(i), _y(float(ends[i]))))
		draw_polyline(pts, Palette.ACCENT, 3.0, true)
		draw_circle(pts[0], 6, Palette.PAGE)
		draw_arc(pts[0], 6, 0, TAU, 20, Palette.ACCENT, 2.0)
		draw_string(f, pts[0] + Vector2(6, 22), "%d" % roundi(start), HORIZONTAL_ALIGNMENT_LEFT, -1, _px(16), Palette.MUTED)
		var peak := 0
		for i in ends.size():
			if float(ends[i]) > float(ends[peak]):
				peak = i
		for i in ends.size():
			var p := pts[i + 1]
			var hot := float(ends[i]) >= limit
			draw_circle(p, 6 if i == peak else 5, Palette.BAD_FILL if hot else Palette.ACCENT)
			draw_string(f, p + Vector2(-10, 24), "%d" % roundi(float(ends[i])), HORIZONTAL_ALIGNMENT_LEFT, -1, _px(20), Palette.BAD if hot else Palette.TEXT)
		if bell >= 0.0:
			draw_string(f, Vector2(size.x - 190, size.y - 6), "first bell %d est." % roundi(bell), HORIZONTAL_ALIGNMENT_LEFT, -1, _px(18), Palette.GOOD if bell < fresh else Palette.WARN)

	func _px(px: int) -> int:
		return TextScale.scaled(px, TextScale.factor())

	func _dash(y: float, col: Color) -> void:
		var x := 0.0
		while x < size.x:
			draw_line(Vector2(x, y), Vector2(minf(x + 8.0, size.x), y), col, 2.0)
			x += 14.0
