extends RefCounted
## S496 TRAININGK1: the Training screen's week for the selected boxer - Mon to Sun columns: the date, the coach's evening
## (TrainCoach), the morning (session picture, Light / Normal / Hard, kilos, the stat gain) and the evening (pads with her
## coach minutes and the move's mastery bar; sparring's Fight IQ; film; rest). A morning takes a session dragged from the
## tray, an evening takes Pads / Sparring / Rest; a click on an evening opens it on the right.
##   make(model, cb) -> HBoxContainer   cb: {am_drop(dow, id), pm_drop(dow, kind), level(dow, intensity), day(dow),
##   split(dow, edge, left_min)}   sel_day: the evening shown on the right

const B := preload("res://scripts/ui/TrainBits.gd")
const TrainCoach := preload("res://scripts/ui/TrainCoach.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const DrillCard := preload("res://scripts/ui/DrillCard.gd")

const COL_W := 146.0
const TILE_H := 124.0
const LABEL_W := 92.0
const LEVELS := [["L", "light"], ["N", "normal"], ["H", "hard"]]


static func make(model: Dictionary, cb: Dictionary, sel_day: int, f: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "TrainGrid"
	row.add_theme_constant_override("separation", 8)
	row.add_child(_labels())
	for d in model["days"]:
		row.add_child(_column(d, model, cb, sel_day, f))
	return row


static func _labels() -> VBoxContainer:
	var v := VBoxContainer.new()
	v.custom_minimum_size = Vector2(LABEL_W, 0)
	v.add_theme_constant_override("separation", 6)
	v.add_child(B.lab("", 16))
	v.add_child(_side_label("COACH", "drag the white line to share", 42))
	v.add_child(_side_label("MORNING", "one stat", TILE_H - 18))
	var eve := _side_label("EVENING", "moves", 40)
	v.add_child(eve)
	var key := GridContainer.new()
	key.columns = 1
	key.add_theme_constant_override("v_separation", -2)
	v.add_child(key)
	for k in [["had", "she had"], ["now", "tonight"], ["ghost", "+1 night"], ["flag", "Usable"]]:
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 4)
		var sw := ColorRect.new()
		sw.custom_minimum_size = Vector2(12, 10)
		sw.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		sw.color = {"had": Palette.sunk(Palette.ELITE), "now": Palette.ELITE, "ghost": Palette.PAGE, "flag": Palette.GOOD_FILL}[k[0]]
		h.add_child(sw)
		h.add_child(B.lab(str(k[1]), 16, Palette.MUTED, "body"))
		key.add_child(h)
	return v


static func _side_label(title: String, sub: String, h: float) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.custom_minimum_size = Vector2(LABEL_W, h)
	v.add_theme_constant_override("separation", 0)
	v.add_child(B.lab(title, 17, Palette.HEADER, "caps"))
	var s := B.lab(sub, 16, Palette.MUTED, "body")
	s.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	s.custom_minimum_size = Vector2(LABEL_W, 0)
	v.add_child(s)
	return v


static func _column(d: Dictionary, model: Dictionary, cb: Dictionary, sel_day: int, f: Dictionary) -> VBoxContainer:
	var i := int(d["dow"])
	var v := VBoxContainer.new()
	v.name = "Day_%d" % i
	v.custom_minimum_size = Vector2(COL_W, 0)
	v.add_theme_constant_override("separation", 6)
	var head := B.lab(str(d["date"]), 18, Palette.CHOSEN if i == sel_day else Palette.HEADER, "caps")
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(head)
	v.add_child(TrainCoach.cell(d["coach"], i, str(model["sel"]), cb.get("split", Callable()), cb.get("day", Callable())))
	v.add_child(_morning(d, cb))
	v.add_child(_evening(d, cb, sel_day, f))
	return v


static func _morning(d: Dictionary, cb: Dictionary) -> Control:
	var i := int(d["dow"])
	var am: Dictionary = d["am"]
	var t := Drop.new()
	t.name = "Morning_%d" % i
	t.accepts = "am"
	t.on_drop = func(id: String): (cb["am_drop"] as Callable).call(i, id)
	t.custom_minimum_size = Vector2(COL_W, TILE_H)
	var edge := Palette.ACCENT if bool(am["changed"]) else Palette.LINE
	t.add_theme_stylebox_override("panel", B.panel(Palette.CARD, edge, 10, 4, 2 if bool(am["changed"]) else 1))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 1)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.add_child(v)
	if bool(am["work"]):
		var w := B.lab("WORK", 20, Palette.WARN, "caps")
		w.name = "Work_%d" % i
		w.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(w)
		var why := B.lab("day job: no morning session", 16, Palette.MUTED, "body")
		why.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		why.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(why)
		t.tooltip_text = "Off the gym sponsorship she works two mornings a week."
		return t
	var pic := B.icon(str(am["id"]), 58, Palette.WARN if bool(am["red"]) else Palette.LINE)
	pic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(pic)
	var name := str(WeekPlan.session(str(am["id"]))["name"])
	if bool(am["rest"]):
		var off := B.lab("day off", 16, Palette.MUTED, "body")
		off.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(off)
		var g := B.lab("-%d Tiredness" % roundi(float(am["drop"])), 20, Palette.GOOD, "bold")
		g.name = "Gain_%d" % i
		g.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		v.add_child(g)
		t.tooltip_text = "Rest: tiredness %d lower by tonight." % roundi(float(am["drop"]))
		return t
	var lv := HBoxContainer.new()
	lv.add_theme_constant_override("separation", 1)
	for pair in LEVELS:
		var b := Button.new()
		b.name = "Level_%d_%s" % [i, pair[0]]
		b.text = str(pair[0])
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(18, 20)
		var on := str(am["intensity"]) == str(pair[1])
		for st in ["normal", "hover", "pressed"]:
			b.add_theme_stylebox_override(st, UI.box(Palette.WARN if on else (Palette.HOVER if st == "hover" else Palette.TILE), Palette.CLEAR, 4, 0, 3, 0))
		b.add_theme_color_override("font_color", Palette.ON_LIGHT if on else Palette.MUTED)
		b.add_theme_color_override("font_hover_color", Palette.TEXT)
		b.add_theme_font_size_override("font_size", 16)
		var lvl := str(pair[1])
		b.pressed.connect(func(): (cb["level"] as Callable).call(i, lvl))
		lv.add_child(b)
	var kg := B.lab("%+.2f kg" % float(am["kg"]), 16, Palette.ACCENT, "bold")
	kg.clip_text = true
	kg.tooltip_text = "Weight this morning: %+.2f kg" % float(am["kg"])
	kg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kg.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lv.add_child(kg)
	v.add_child(lv)
	var gl := B.lab("%+.2f %s" % [float(am["gain"]), B.stat_word(str(am["stat"]))] if str(am["stat"]) != "" else name, 18,
		Palette.GOOD if float(am["gain"]) > 0.0 else Palette.TEXT, "bold")
	gl.name = "Gain_%d" % i
	gl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gl.clip_text = true
	gl.tooltip_text = gl.text
	v.add_child(gl)
	t.tooltip_text = "%s, %s: %s, %+.2f kg." % [name, str(am["intensity"]).capitalize(), gl.text, float(am["kg"])]
	return t


static func _evening(d: Dictionary, cb: Dictionary, sel_day: int, f: Dictionary) -> Control:
	var i := int(d["dow"])
	var pm: Dictionary = d["pm"]
	var kind := str(pm["kind"])
	var t := Drop.new()
	t.name = "Evening_%d" % i
	t.kind = kind
	t.accepts = "pm" if kind != "fight" else ""
	t.on_drop = func(k: String): (cb["pm_drop"] as Callable).call(i, k)
	t.on_click = func(): (cb["day"] as Callable).call(i)
	t.custom_minimum_size = Vector2(COL_W, TILE_H)
	t.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	t.add_theme_stylebox_override("panel", B.panel(Palette.CARD, Palette.CHOSEN if i == sel_day else Palette.LINE, 10, 4, 3 if i == sel_day else 1))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.add_child(v)
	var cards: Array = pm["cards"]
	match kind:
		"pads":
			var top := HBoxContainer.new()
			top.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var mins := B.lab("%d min" % roundi(_coach_min(d, f)), 16, Palette.TEXT, "bold")
			mins.name = "Mins_%d" % i
			top.add_child(mins)
			v.add_child(top)
			if cards.is_empty():
				v.add_child(B.icon("pads", 56, Palette.LINE))
				v.add_child(_center("Pads: the coach picks the drill", 16, Palette.MUTED))
			else:
				var c0: Dictionary = cards[0]
				var pic := TextureRect.new()
				pic.texture = DrillCard.picture(f, str(c0["card"]))
				pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				pic.custom_minimum_size = Vector2(0, 46)
				pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
				v.add_child(pic)
				var nm := _center(str(c0["title"]) + ("  ✓" if bool(c0["crosses"]) else ""), 17, Palette.GOOD if bool(c0["usable"]) else Palette.ELITE)
				nm.name = "Move_%d" % i
				v.add_child(nm)
				var bar := B.MBar.new()
				bar.name = "Bar_%d" % i
				bar.had = float(c0["before"])
				bar.now = float(c0["after"])
				bar.ghost = minf(B.USABLE + 0.5, float(c0["after"]) + (float(c0["after"]) - float(c0["before"]))) if float(c0["after"]) < B.USABLE else 0.0
				bar.custom_minimum_size = Vector2(0, 18)
				v.add_child(bar)
				t.tooltip_text = "%s: mastery %.1f → %.1f tonight (Usable at 30)." % [str(c0["title"]), float(c0["before"]), float(c0["after"])]
		"sparring":
			v.add_child(_pic("sparring"))
			var g := _center("Fight IQ %+.2f" % float(pm["gain2"]), 18, Palette.GOOD)
			g.name = "Spar_%d" % i
			v.add_child(g)
			if not cards.is_empty():
				v.add_child(_center("drills %d usable move%s" % [cards.size(), "" if cards.size() == 1 else "s"], 16, Palette.MUTED))
			t.tooltip_text = "Sparring: Fight IQ, and the moves she can already use get ring time."
		"film":
			v.add_child(_pic("film"))
			v.add_child(_center("Film", 18, Palette.TEXT))
		"fight":
			v.add_child(_pic("sparring"))
			v.add_child(_center("FIGHT NIGHT", 18, Palette.BAD))
		_:
			v.add_child(_pic("rest_night"))
			v.add_child(_center("Rest", 18, Palette.MUTED))
	return t


static func _pic(id: String) -> Control:
	var p := B.icon(id, 62, Palette.LINE)
	p.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return p


static func _center(text: String, px: int, col: Color) -> Label:
	var l := B.lab(text, px, col, "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.clip_text = true
	l.tooltip_text = text
	return l


## Her coach minutes on that pad night (the coach cell's slice).
static func _coach_min(d: Dictionary, f: Dictionary) -> float:
	for s in (d["coach"] as Dictionary)["slices"]:
		if str(s["fid"]) == str(f.get("id", "")):
			return float(s["min"])
	return 0.0


## A tile that takes a session dropped from the tray ({tk: "am" | "pm", id}); a click calls on_click.
class Drop extends PanelContainer:
	var accepts := ""
	var kind := ""
	var on_drop := Callable()
	var on_click := Callable()

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP

	func _can_drop_data(_at: Vector2, data: Variant) -> bool:
		return accepts != "" and data is Dictionary and str((data as Dictionary).get("tk", "")) == accepts

	func _drop_data(_at: Vector2, data: Variant) -> void:
		if on_drop.is_valid():
			on_drop.call(str((data as Dictionary)["id"]))

	func _gui_input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT and on_click.is_valid():
			on_click.call()
			accept_event()
