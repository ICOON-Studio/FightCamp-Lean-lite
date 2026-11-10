extends Control
## Seven day tiles under the tiredness curve. The column gap is WeekBoard's, so each tile's centre is the
## curve's column centre. A click selects that day (the caller sets WeekBoard.picking).
## Rest has no bed icon in the set (heart stands in). Fight night has no bell (star stands in); the glove is hand-fist.
##   make(fid, days, evs, fight_dow, selected, gap, on_pick) -> WeekTiles

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")

const SHORT := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

var gap := 12.0
var _tiles: Array = []


static func session_icon(id: String) -> String:
	if id == "rest":
		return "heart"   # no bed / sleep icon in the set
	var stat := str(WeekPlan.session(id).get("stat", ""))
	return str(WeekCards.NIGHT_ICON.get(stat, AttrBoard.ICON.get(stat, "target")))


static func evening_icon(kind: String) -> String:
	match kind:
		"pads":
			return "hand-fist"
		"sparring":
			return "brain"
		"film":
			return "tv"
		_:
			return "heart"


static func make(days: Array, evs: Array, fight_dow: int, selected: int, col_gap: float, on_pick: Callable) -> Control:
	var host := new()
	host.name = "WeekTiles"
	host.gap = col_gap
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	host.custom_minimum_size = Vector2(0, 128)
	for i in 7:
		host._tiles.append(host._tile(i, days[i], str(evs[i]), i == fight_dow, i == selected, on_pick))
		host.add_child(host._tiles[i])
	return host


func _ready() -> void:
	resized.connect(_place)
	call_deferred("_place")


func _place() -> void:
	if size.x < 8.0 or _tiles.is_empty():
		return
	var col := (size.x - gap * 6.0) / 7.0
	for i in _tiles.size():
		var t := _tiles[i] as Control
		t.position = Vector2(float(i) * (col + gap), 0.0)
		t.size = Vector2(maxf(col, 1.0), size.y)


func _tile(i: int, morning: Array, eve: String, fight: bool, on: bool, on_pick: Callable) -> Button:
	var b := Button.new()
	b.name = "DayTile_%d" % i
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.pressed.connect(on_pick.bind(i))
	var bg := Color(0.16, 0.09, 0.08, 0.96) if fight else (Color(0.28, 0.22, 0.10, 0.96) if on else Color(0.13, 0.14, 0.15, 0.96))
	var edge := UI.RED if fight else (WoodKit.HEAD if on else Color(WoodKit.SOFT, 0.55))
	for st in ["normal", "hover", "pressed", "focus"]:
		var hot: bool = st == "hover"
		b.add_theme_stylebox_override(st, UI.box(bg.lightened(0.08) if hot else bg, edge, 8, 3 if on or fight else 2, 4, 4))
	var session := str(WeekPlan.session(str(morning[0]))["name"])
	var night := str((WeekPlan.EVENINGS.get(eve, WeekPlan.EVENINGS["rest"]) as Dictionary)["name"])
	b.tooltip_text = "Fight night" if fight else "%s. Evening: %s." % [session, night]
	var v := UI.vbox(2)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	b.add_child(v)
	var day := UI.label(SHORT[i], 28, WoodKit.INK, "bold")
	day.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(day)
	var halves := UI.hbox(6)
	halves.alignment = BoxContainer.ALIGNMENT_CENTER
	halves.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(halves)
	if fight:
		halves.add_child(_ico("star", "Fight night"))
		halves.add_child(_ico("hand-fist", "Fight night"))
	else:
		var left := UI.vbox(2)
		left.mouse_filter = Control.MOUSE_FILTER_IGNORE
		left.alignment = BoxContainer.ALIGNMENT_CENTER
		left.add_child(_ico(session_icon(str(morning[0])), session))
		if str(morning[0]) != "rest":
			var lv := 1 if str(morning[1]) == "light" else (3 if str(morning[1]) == "hard" else 2)
			left.add_child(_pips(lv))
		halves.add_child(left)
		halves.add_child(_ico(evening_icon(eve), night))
	return b


func _ico(icon_name: String, tip: String) -> TextureRect:
	var r := Icons.icon(icon_name, 36, WoodKit.INK, tip)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


func _pips(level: int) -> HBoxContainer:
	var h := UI.hbox(4)
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for k in 3:
		var d := ColorRect.new()
		d.custom_minimum_size = Vector2(12, 12)
		d.mouse_filter = Control.MOUSE_FILTER_IGNORE
		d.color = WoodKit.HEAD if k < level else Color(1, 1, 1, 0.18)
		h.add_child(d)
	return h
