extends RefCounted
## One day of the Week tab (S359 split out of WeekBoard): the day's head (MON 9 Feb, 'undo' on a changed morning), the
## evening card (PmCard; S398 Week v8: WeekCards.night_body inside, any evening takes a dropped drill card and becomes a pads
## night, a click opens the evening popover) and the morning's index card (Tips). The morning card itself is WeekCards.am.
##   head(i, day, mine, coach_card, act, ghost)  pm(spec) -> PmCard  magnet_card(m, planned, r, red, mine, twist)  kind(m)

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const Data := preload("res://scripts/state/Data.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")

const DAYS := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]


## MON ... 26 Jan, with 'undo' when the morning is her change (back to the coach's card).
static func head(i: int, day: int, mine: bool, coach_card: Array, act: Callable, ghost := Callable()) -> Control:
	var h := UI.hbox(6)
	h.name = "Head_%d" % i
	h.add_child(UI.label(DAYS[i], 17, UI.FG, "caps"))
	if mine and coach_card.size() == 2:
		var undo := Button.new()
		undo.name = "Undo_%d" % i
		undo.text = "undo"
		undo.flat = true
		undo.focus_mode = Control.FOCUS_NONE
		undo.add_theme_font_override("font", UI.font("handbold"))
		undo.add_theme_font_size_override("font_size", 15)
		undo.add_theme_color_override("font_color", WoodKit.BLUE)
		undo.add_theme_color_override("font_hover_color", WB.RED)
		for k in ["normal", "hover", "pressed", "focus"]:
			undo.add_theme_stylebox_override(k, StyleBoxEmpty.new())
		undo.tooltip_text = "Back to the coach's card: %s" % WeekPhase.card(coach_card)
		undo.pressed.connect(func(): act.call(i, coach_card))
		if ghost.is_valid():
			undo.mouse_entered.connect(func(): ghost.call(i, coach_card))
			undo.mouse_exited.connect(func(): ghost.call(i, []))
		h.add_child(undo)
	h.add_child(UI.spacer())
	h.add_child(UI.label(Clock.fmt(day).substr(4), 15, UI.MUTED, "body"))
	return h


## The evening card (S398 Week v8): WeekCards.night_body inside; a click opens its popover (or, with a tray card held,
## puts that card on this night - any evening takes it and becomes a pads night); right-click clears a pads night.
## spec: {i, kind, entries, rows, f, picked, spar_cards, camp, partner, cost, key2, gain2, on_drop, on_click, on_clear,
## on_open}
static func pm(spec: Dictionary) -> PmCard:
	var p := PmCard.new()
	var i := int(spec["i"])
	var k := str(spec["kind"])
	p.name = "Night_%d" % i
	p.dow = i
	p.kind = k
	p.spec = spec
	p.custom_minimum_size = Vector2(0, WeekCards.PM_H)
	var held := bool(spec.get("picked", false)) and k != "film"
	var empty_pads := k == "pads" and (spec.get("entries", []) as Array).is_empty()
	var edge := Color(WoodKit.HEAD) if held else (Color(0, 0, 0, 0) if empty_pads else Color(WoodKit.SOFT, 0.35))
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), edge, 4, 2 if held else 1, 9, 9))
	p.add_child(WeekCards.night_body(spec))
	if held and k != "pads":
		p.tooltip_text = "Drop here to make this a pads night"
	return p


## The morning card's index card: the session, what it builds, where she ends the day, and what that means.
static func magnet_card(m: Array, planned: Array, r: Dictionary, red: bool, mine: bool, twist: String) -> Dictionary:
	var rows: Array = []
	for k in [["stat", "gain"], ["stat2", "gain2"]]:
		var st := str(r.get(k[0], ""))
		if st != "":
			var g := float(r[k[1]])
			rows.append([str(Data.LABEL.get(st, st)), "%+.2f" % g, "▲" if g > 0.0 else "", "good" if g > 0.0 else ""])
	rows.append(["Weight", "%+.2f kg" % float(r.get("kg", 0.0)), "", ""])
	var fat := float(r.get("fatigue", 0.0))
	var fw := WB.fatigue_word(fat, red)
	rows.append(["Tired by night", "%d / 100" % int(round(fat)), str(fw[0]),
		"bad" if fat >= WB.RED_AT or red else ("watch" if fat >= WB.AMBER_AT else "")])
	var means := "a %s day; %s" % [kind(m), str(fw[1]).get_slice(": ", 1).to_lower() if str(fw[1]).contains(": ") else ""]
	if m != planned:
		means = "the twist (%s) replaced %s. %s" % [twist, WeekPhase.card(planned), _cap(means)]
	elif mine:
		means = "your change - 'undo' on the day puts the coach's card back. " + _cap(means)
	return {"title": "%s - morning" % WeekPhase.card(m), "rows": rows, "means": _cap(means.strip_edges()),
		"keys": ["fatigue", "phase"] + (["twist"] if m != planned else []), "hint": [["click", "change the day"]]}


## The day's kind in the coach's shorthand: rest, hard, engine (conditioning), skill.
static func kind(m: Array) -> String:
	if str(m[0]) == "rest":
		return "rest"
	if str(m[1]) == "hard":
		return "hard"
	return "engine" if str(WeekPlan.session(str(m[0]))["stat"]) == "conditioning" else "skill"


static func _cap(s: String) -> String:
	return s.left(1).to_upper() + s.substr(1)


## The evening card's panel: takes a dropped drill card on any evening but film; a click opens its popover or places
## the held tray card; right-click clears a pads night.
class PmCard extends PanelContainer:
	var dow := 0
	var kind := ""
	var spec := {}

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		size_flags_horizontal = Control.SIZE_EXPAND_FILL

	func _ready() -> void:
		if kind != "film":
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		if kind == "pads" and (spec.get("entries", []) as Array).is_empty():
			draw.connect(_dashes)

	## An empty pads night's dashed blue edge.
	func _dashes() -> void:
		var r := Rect2(Vector2(1, 1), size - Vector2(2, 2))
		var pts := [[r.position, Vector2(r.end.x, r.position.y)], [Vector2(r.end.x, r.position.y), r.end],
			[r.end, Vector2(r.position.x, r.end.y)], [Vector2(r.position.x, r.end.y), r.position]]
		for seg in pts:
			draw_dashed_line(seg[0], seg[1], WoodKit.BLUE, 2.0, 6.0)

	func _can_drop_data(_at: Vector2, data: Variant) -> bool:
		return kind != "film" and data is Dictionary and (data as Dictionary).has("drill")

	func _drop_data(_at: Vector2, data: Variant) -> void:
		(spec["on_drop"] as Callable).call(dow, str(data["drill"]))

	func _gui_input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb == null or not mb.pressed or kind == "film":
			return
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if bool(spec.get("picked", false)):
				(spec["on_click"] as Callable).call(dow)
			elif spec.has("on_open"):
				(spec["on_open"] as Callable).call(dow)
			accept_event()
		elif mb.button_index == MOUSE_BUTTON_RIGHT and kind == "pads":
			(spec["on_clear"] as Callable).call(dow)
			accept_event()
