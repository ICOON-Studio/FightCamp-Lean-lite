extends RefCounted
## S496 TRAININGK1: the COACH row of the Training screen - the boxing coach's evening on each weekday. A pad night is a bar
## split by face (each boxer's minutes, CoachNights); the white line between two faces drags to share the 75 minutes
## (snaps to 5, everyone keeps 5). Sparring night (he referees), in the corner (a bout that night), closed Sunday and no
## coaching are dashed boxes with their name.
##   cell(cell, dow, sel_fid, on_split: Callable(dow, edge, left_min), on_day: Callable(dow)) -> Control

const B := preload("res://scripts/ui/TrainBits.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const CoachNights := preload("res://scripts/rules/CoachNights.gd")

const H := 42.0
const WORDS := {"spar": ["SPARRING NIGHT", "referee only"], "corner": ["IN THE CORNER", "fight day"], "closed": ["CLOSED", "Sunday"],
	"none": ["NO COACHING", "rest evening"]}


static func cell(c: Dictionary, dow: int, sel: String, on_split: Callable, on_day: Callable) -> Control:
	if str(c["kind"]) != "pads":
		return _note(str(c["kind"]), dow)
	var bar := Split.new()
	bar.name = "Coach_%d" % dow
	bar.dow = dow
	bar.total = float(c.get("total", CoachNights.NIGHT_MIN))
	bar.slices = (c["slices"] as Array).duplicate(true)
	bar.sel = sel
	bar.on_split = on_split
	bar.on_day = on_day
	bar.custom_minimum_size = Vector2(0, H)
	return bar


static func _note(kind: String, dow: int) -> PanelContainer:
	var w: Array = WORDS.get(kind, WORDS["none"])
	var p := PanelContainer.new()
	p.name = "Coach_%d" % dow
	p.custom_minimum_size = Vector2(0, H)
	var col := Palette.BAD if kind == "corner" else (Palette.ELITE if kind == "spar" else Palette.MUTED)
	p.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, Palette.alpha(col, 0.8), 7, 2, 2, 0))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", -4)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(v)
	for k in 2:
		var l := B.lab(str(w[k]), 16, col if k == 0 else Palette.MUTED, "caps" if k == 0 else "bold")
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.clip_text = true
		l.tooltip_text = "%s: %s" % [str(w[0]).capitalize(), str(w[1])]
		v.add_child(l)
	p.tooltip_text = {"spar": "Sparring night: your coach referees, no pads.", "corner": "A bout tonight: your coach works the corner.",
		"closed": "The gym is closed on Sunday evening."}.get(kind, "No coached evening.")
	return p


## The shared pad night: slices by minutes (a face and the minutes on each), white lines between them that drag.
class Split extends Control:
	var dow := 0
	var total := 75.0
	var slices: Array = []
	var sel := ""
	var on_split := Callable()
	var on_day := Callable()
	var _drag := -1
	var _row: HBoxContainer

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_HSIZE if slices.size() > 1 else Control.CURSOR_POINTING_HAND
		clip_contents = true
		_row = HBoxContainer.new()
		_row.add_theme_constant_override("separation", 0)
		_row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(_row)
		for i in slices.size():
			_row.add_child(_slice(i))
		tooltip_text = "Your coach's %d minutes tonight, shared by the boxers on the pads. Drag a white line to give one more." % roundi(total)
		resized.connect(queue_redraw)
		_ratios()

	func _slice(i: int) -> PanelContainer:
		var s: Dictionary = slices[i]
		var mine := str(s["fid"]) == sel
		var p := PanelContainer.new()
		p.name = "Slice_%s" % str(s["fid"])
		p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		p.add_theme_stylebox_override("panel", UI.box(Palette.WARN if mine else Palette.ACCENT, Palette.PAGE, 0, 1, 3, 0))
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 3)
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.clip_contents = true
		p.add_child(h)
		h.add_child(B.face(str(s["stem"]), 28, Palette.PAGE))
		var l := B.lab("%d" % roundi(float(s["min"])) + (" min" if slices.size() == 1 else ""), 17, Palette.ON_LIGHT, "bold")
		l.name = "Min"
		l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(l)
		return p

	func _ratios() -> void:
		for i in slices.size():
			(_row.get_child(i) as Control).size_flags_stretch_ratio = maxf(1.0, float(slices[i]["min"]))
			var l := _row.get_child(i).find_child("Min", true, false) as Label
			if l != null:
				l.text = "%d" % roundi(float(slices[i]["min"])) + (" min" if slices.size() == 1 else "")
		queue_redraw()

	func _edges() -> Array:
		var out: Array = []
		var acc := 0.0
		for i in slices.size() - 1:
			acc += float(slices[i]["min"])
			out.append(size.x * acc / total)
		return out

	func _draw() -> void:
		for x in _edges():   # the white line and its grip
			draw_rect(Rect2(float(x) - 2.0, 0, 4, size.y), Palette.TEXT)
			draw_rect(Rect2(float(x) - 6.0, size.y * 0.5 - 9.0, 12, 18), Palette.TEXT)
			draw_rect(Rect2(float(x) - 6.0, size.y * 0.5 - 9.0, 12, 18), Palette.PAGE, false, 1.5)

	func _gui_input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb != null and mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_drag = -1
				var e := _edges()
				for i in e.size():
					if absf(mb.position.x - float(e[i])) <= 10.0:
						_drag = i
				if _drag < 0 and on_day.is_valid():
					on_day.call(dow)
			elif _drag >= 0:
				var edge := _drag
				_drag = -1
				if on_split.is_valid():
					on_split.call(dow, edge, _left_min(mb.position.x))
			accept_event()
		var mm := ev as InputEventMouseMotion
		if mm != null and _drag >= 0:
			var ids: Array = slices.map(func(s): return str(s["fid"]))
			var now := {}
			for s in slices:
				now[str(s["fid"])] = float(s["min"])
			var d := CoachNights.drag(ids, now, _drag, _left_min(mm.position.x))
			for s in slices:
				s["min"] = float(d[str(s["fid"])])
			_ratios()
			accept_event()

	func _left_min(x: float) -> float:
		return clampf(x / maxf(size.x, 1.0), 0.0, 1.0) * total
