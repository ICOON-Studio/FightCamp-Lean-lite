extends RefCounted
## S496 TRAININGK1: the SESSIONS tray at the foot of the Training screen - every morning session (its picture, its stat gain
## at Normal for the selected boxer, WeekPlan.day) and the evenings (Pads: mastery a night on her first card; Sparring:
## Fight IQ; Rest). Drag a morning onto a day's morning, an evening onto a day's evening. Film comes with a booked bout's
## camp (shown, not dragged).
##   make(model, ctx, f_cards) -> PanelContainer

const B := preload("res://scripts/ui/TrainBits.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")


## ctx: WeekPlan's context for the selected boxer (Sim.week_ctx); pads_night: [before, after] of a pad night on her card.
static func make(ctx: Dictionary, pads_night: Array, booked: bool) -> PanelContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 12)
	h.add_child(B.caps("SESSIONS", 22))
	var s := B.lab("drag a morning onto a day · drag an evening onto a day's evening", 16, Palette.MUTED, "bold")
	s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(s)
	v.add_child(h)
	var am := HBoxContainer.new()
	am.name = "TrayMornings"
	am.add_theme_constant_override("separation", 6)
	am.add_child(_side("MORNING", "one stat"))
	for id in WeekPlan.ORDER:
		var r := WeekPlan.day(str(id), "normal", ctx, float(ctx.get("fatigue", 20.0)))
		var val := ""
		if str(id) == "rest":
			val = "recovers"
		elif str(r["stat"]) != "":
			val = "%+.2f %s" % [float(r["gain"]), B.stat_word(str(r["stat"]))]
		else:
			val = "loosens up"
		am.add_child(item("am", str(id), str(WeekPlan.session(str(id))["name"]), val))
	v.add_child(am)
	var pm := HBoxContainer.new()
	pm.name = "TrayEvenings"
	pm.add_theme_constant_override("separation", 6)
	pm.add_child(_side("EVENING", "moves, with the coach"))
	var pads_val := "+%.1f a night" % (float(pads_night[1]) - float(pads_night[0])) if pads_night.size() == 2 else "moves"
	pm.add_child(item("pm", "pads", "Pads", pads_val))
	var spar := WeekPlan.full_day("rest", "normal", "sparring", ctx, float(ctx.get("fatigue", 20.0)))
	pm.add_child(item("pm", "sparring", "Sparring", "%+.2f Fight IQ" % float(spar.get("gain2", 0.0))))
	var film := item("", "film", "Film", "the camp's" if booked else "with a bout")
	film.modulate = Palette.fade(1.0 if booked else 0.5)
	film.tooltip_text = "Film night comes with a booked bout: the camp sets it."
	pm.add_child(film)
	pm.add_child(item("pm", "rest", "Rest", "recovers"))
	v.add_child(pm)
	var p := B.wrap(v, Palette.CARD, Palette.LINE, 12, 12)
	p.name = "SessionTray"
	return p


static func _side(title: String, sub: String) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.custom_minimum_size = Vector2(92, 0)
	v.add_theme_constant_override("separation", 0)
	v.add_child(B.lab(title, 17, Palette.HEADER, "caps"))
	var s := B.lab(sub, 16, Palette.MUTED, "body")
	s.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	s.custom_minimum_size = Vector2(92, 0)
	v.add_child(s)
	return v


## One session in the tray: picture, name, value. tk "am" / "pm" makes it draggable; "" shows it only.
static func item(tk: String, id: String, title: String, val: String) -> Control:
	var it := Item.new()
	it.name = "Tray_%s" % id
	it.tk = tk
	it.id = id
	it.custom_minimum_size = Vector2(114, 0)
	it.mouse_default_cursor_shape = Control.CURSOR_DRAG if tk != "" else Control.CURSOR_ARROW
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	it.add_child(v)
	var pic := B.icon("rest_night" if tk == "pm" and id == "rest" else id, 54, Palette.LINE)
	pic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(pic)
	for pair in [[title, Palette.TEXT, 16], [val, Palette.GOOD if val.begins_with("+") else Palette.MUTED, 16]]:
		var l := B.lab(str(pair[0]), int(pair[2]), pair[1], "bold")
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.clip_text = true
		v.add_child(l)
	it.tooltip_text = "%s: %s. Drag it onto a day." % [title, val] if tk != "" else title
	return it


## A tray session you can drag: {tk, id}; the picture follows the mouse.
class Item extends PanelContainer:
	var tk := ""
	var id := ""

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		add_theme_stylebox_override("panel", StyleBoxEmpty.new())

	func _get_drag_data(_at: Vector2) -> Variant:
		if tk == "":
			return null
		var prev := B.icon("rest_night" if tk == "pm" and id == "rest" else id, 54, Palette.CHOSEN)
		set_drag_preview(prev)
		return {"tk": tk, "id": id}
