extends RefCounted
## S496 TRAININGK1: the COACH row of the Training screen - the boxing coach's evening on each weekday. A pad night is a row
## of the faces on the pads, each with the full session (S498, his Q-S294-260 "full pads, no sharing": nothing to drag;
## a click opens that evening on the right). Sparring night (he referees), in the corner (a bout that night), closed Sunday and no
## coaching are dashed boxes with their name.
##   cell(cell, dow, sel_fid, on_day: Callable(dow), wide) -> Control   (a day column fits two numbers; three or more
##   boxers show faces only there - the row label says 75 min each; wide = the right panel, numbers always)

const B := preload("res://scripts/ui/TrainBits.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")

const H := 42.0
const WORDS := {"spar": ["SPARRING", "night - referee only"], "corner": ["IN THE CORNER", "fight day"], "closed": ["CLOSED", "Sunday"],
	"none": ["NO COACHING", "rest evening"], "class": ["CLASS NIGHT", "boxers on the bag"]}


static func cell(c: Dictionary, dow: int, sel: String, on_day: Callable, wide: bool = false) -> Control:
	if str(c["kind"]) != "pads":
		return _note(str(c["kind"]), dow)
	var bx: Array = c["boxers"]
	# a plain Control holds the faces so three faces never widen the day's column (they clip inside it)
	var row := Control.new()
	row.name = "Coach_%d" % dow
	row.custom_minimum_size = Vector2(0, H)
	row.clip_contents = true
	row.mouse_filter = Control.MOUSE_FILTER_STOP
	row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var faces := HBoxContainer.new()
	faces.name = "Faces"
	faces.add_theme_constant_override("separation", 2)
	faces.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	faces.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(faces)
	row.tooltip_text = "Pads tonight: each boxer on the pads gets your coach's full %d minutes." % roundi(float(bx[0]["min"]))
	if on_day.is_valid():
		row.gui_input.connect(func(ev: InputEvent):
			var mb := ev as InputEventMouseButton
			if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
				on_day.call(dow))
	for s in bx:
		faces.add_child(_boxer(s, str(s["fid"]) == sel, bx.size() == 1, wide or bx.size() <= 2))
	return row


## One boxer on the pads: her face and her minutes (the full session), the selected boxer in the warm colour.
static func _boxer(s: Dictionary, mine: bool, alone: bool, number: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Pads_%s" % str(s["fid"])
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Palette.WARN if mine else Palette.ACCENT, Palette.PAGE, 4, 1, 3, 0))
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 3)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.clip_contents = true
	p.add_child(h)
	h.add_child(B.face(str(s["stem"]), 28, Palette.PAGE))
	if not number:
		h.alignment = BoxContainer.ALIGNMENT_CENTER
		return p
	var l := B.lab("%d" % roundi(float(s["min"])) + (" min" if alone else ""), 17, Palette.ON_LIGHT, "bold")
	l.name = "Min"
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(l)
	return p


static func _note(kind: String, dow: int) -> PanelContainer:
	var w: Array = WORDS.get(kind, WORDS["none"])
	var p := PanelContainer.new()
	p.name = "Coach_%d" % dow
	p.custom_minimum_size = Vector2(0, H)
	var col := Palette.BAD if kind == "corner" else (Palette.ELITE if kind == "spar" else (Palette.GOOD if kind == "class" else Palette.MUTED))
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
		"closed": "The gym is closed on Sunday evening.", "class": "Class night: your coach teaches a paying class (+$117); the boxers drill on the bag at half the rate."}.get(kind, "No coached evening.")
	return p
