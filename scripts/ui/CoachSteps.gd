extends VBoxContainer
## S376 BJJCOACH1 (operator S375 "Yes, build it", from BJJ DOJO on the itch scan): the coach's steps of the move on Ana's
## mat, numbered under the MatPlayer. The step the film is on lights up; click a step and it plays once and holds where it
## ends (the orbit keeps turning, so the hold is seen all round); Play / Pause, 0.5x / 1x. Steps: BjjSteps (its split of
## the film's keyframes). An unfilmed move still lists its steps, unlit.
##   var s := CoachSteps.new(); s.setup(mat); add it; after mat.play_move(id): s.show_move(id, filmed)

const UI := preload("res://scripts/ui/UI.gd")
const BjjSteps := preload("res://scripts/rules/BjjSteps.gd")

const SLOW := 0.5
static var _speed := 1.0   # kept across the page's re-renders

var mat: Control
var _at := PackedFloat32Array()
var _rows: Array = []
var _lit := -2
var _list: VBoxContainer
var _play: Button
var _speeds: Dictionary = {}


func setup(player: Control) -> void:
	mat = player
	name = "CoachSteps"
	add_theme_constant_override("separation", 6)
	var head := UI.hbox(6)
	head.add_child(UI.caps("COACH'S STEPS"))
	head.add_child(UI.spacer())
	_play = UI.button("Pause", "Btn", _toggle)
	_play.name = "PlayPause"
	_play.disabled = true
	head.add_child(_play)
	for s in [SLOW, 1.0]:
		var b := UI.button("%sx" % ("0.5" if s < 1.0 else "1"), "TabOn" if is_equal_approx(s, _speed) else "Tab", _set_speed.bind(s))
		b.name = "Speed_%s" % ("slow" if s < 1.0 else "normal")
		_speeds[s] = b
		head.add_child(b)
	add_child(head)
	_list = UI.vbox(4)
	_list.name = "StepList"
	add_child(_list)
	if mat != null and mat.has_method("set_speed"):
		mat.set_speed(_speed)


## The steps of this move; `filmed` = the mat plays it (steps light up and click), else a list to read.
func show_move(id: String, filmed: bool) -> void:
	UI.clear(_list)
	_rows.clear()
	_lit = -2
	var cues := BjjSteps.steps(id)
	_at = BjjSteps.starts(mat.key_times(), cues.size()) if filmed and mat != null and not cues.is_empty() else PackedFloat32Array()
	if cues.is_empty():
		_list.add_child(UI.muted("No coach's steps for this move yet.", UI.SMALL, true))
	for i in cues.size():
		_list.add_child(_row(i, str(cues[i]), filmed))
	_play.disabled = _at.is_empty()
	_restyle(-1)


## The step the film is on now (-1 with no film).
func lit() -> int:
	return _lit


func step_count() -> int:
	return _rows.size()


func _row(i: int, cue: String, filmed: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Step_%d" % (i + 1)
	var h := UI.hbox(10)
	var n := UI.label("%d" % (i + 1), UI.SMALL, UI.GOLD, "bold")
	n.custom_minimum_size = Vector2(18, 0)
	h.add_child(n)
	h.add_child(UI.label(cue, UI.SMALL, UI.FG, "body", true))
	p.add_child(h)
	if filmed:
		p.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		p.tooltip_text = "Play this step and hold"
		p.gui_input.connect(func(e: InputEvent):
			if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
				play_step(i))
	_rows.append(p)
	return p


## Plays step i once, then the mat holds on where it ends.
func play_step(i: int) -> void:
	if _at.is_empty() or i < 0 or i >= _at.size():
		return
	var length: float = mat.key_times()[mat.key_times().size() - 1]
	mat.play_step(_at[i], BjjSteps.end_of(_at, i, length))
	_restyle(i)


func _process(_delta: float) -> void:
	if mat == null or _at.is_empty():
		return
	var i := BjjSteps.index_at(_at, mat.time())
	if i != _lit:
		_restyle(i)
	var word := "Play" if mat.paused() else "Pause"
	if _play.text != word:
		_play.text = word


func _restyle(i: int) -> void:
	_lit = i
	for k in _rows.size():
		var on: bool = k == i
		(_rows[k] as PanelContainer).add_theme_stylebox_override("panel",
			UI.box(UI.SKY if on else UI.PANEL, UI.GOLD if on else UI.LINE, 8, 2 if on else 1, 10, 6))


func _toggle() -> void:
	if mat != null and not _at.is_empty():
		mat.set_paused(not mat.paused())


func _set_speed(s: float) -> void:
	_speed = s
	if mat != null:
		mat.set_speed(s)
	for k in _speeds:
		(_speeds[k] as Button).theme_type_variation = "TabOn" if is_equal_approx(float(k), s) else "Tab"
