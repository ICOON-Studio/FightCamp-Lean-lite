extends Control
## S389 CLASH: the belt match's screen. A panel each side (the fighter's numbers, gas and every move tried, with why it worked or
## not), the score on top, and in the middle the two skills colliding: attack from one side, defence from the other, the winner
## pushes through, then the odds bar with the roll on it. Words and numbers come from BjjClash; this only draws them.

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Bar := preload("res://scripts/ui/Bar.gd")

const SIDE_W := 310.0
const LOG_ROWS := 5
const STAGE_W := 760.0
const CHIP_W := 250.0
const BIG_HOLD_S := 1.5
const SMALL_HOLD_S := 0.6
const TAP_HOLD_S := 3.0
const SIDE_COLOR := [UI.RED, UI.GOLD]

var score: Label
var clock: Label
var where: Label
var calls: Label
var gas: Array = []
var offers: VBoxContainer
var _logs: Array = []
var _stage: Control
var _tween: Tween


func build(names: Array, belt: String, numbers: Array) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in 2:
		add_child(_side(i, str(names[i]), belt, numbers[i]))
	add_child(_top())
	_stage = Control.new()
	_stage.anchor_left = 0.5
	_stage.anchor_right = 0.5
	_stage.anchor_top = 0.72
	_stage.anchor_bottom = 0.72
	_stage.offset_left = -STAGE_W / 2.0
	_stage.offset_right = STAGE_W / 2.0
	_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_stage)
	offers = UI.vbox(8)
	offers.anchor_left = 0.5
	offers.anchor_right = 0.5
	offers.anchor_top = 1.0
	offers.anchor_bottom = 1.0
	offers.offset_left = -330.0
	offers.offset_right = 330.0
	offers.offset_bottom = -14.0
	offers.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(offers)


func _panel_box() -> StyleBoxFlat:
	var c := UI.PANEL
	c.a = 0.93
	return UI.box(c, UI.LINE, 10, 1, 14, 12)


func _side(i: int, who: String, belt: String, nums: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.name = "Side_%d" % i
	p.add_theme_stylebox_override("panel", _panel_box())
	p.anchor_left = float(i)
	p.anchor_right = float(i)
	p.anchor_bottom = 1.0
	p.offset_left = 16.0 if i == 0 else -SIDE_W - 16.0
	p.offset_right = SIDE_W + 16.0 if i == 0 else -16.0
	p.offset_top = 16.0
	p.offset_bottom = -16.0
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(8)
	p.add_child(v)
	v.add_child(UI.display(who, 34, SIDE_COLOR[i]))
	v.add_child(UI.caps("%s BELT" % belt.to_upper()))
	for row in [["brain", "Technique", "skill"], ["biceps-flexed", "Strength", "strength"], ["heart-pulse", "Cardio", "cardio"]]:
		var h := UI.hbox(8)
		h.add_child(Icons.icon(str(row[0]), 20, UI.FG, str(row[1])))
		h.add_child(UI.label(str(row[1]), UI.SMALL, UI.FG, "body"))
		h.add_child(UI.spacer())
		h.add_child(UI.label("%d" % int(nums[row[2]]), UI.BODY, UI.FG, "bold"))
		v.add_child(h)
	var g := UI.hbox(8)
	g.add_child(UI.caps("GAS"))
	var bar := Bar.new()
	bar.custom_minimum_size = Vector2(SIDE_W - 90.0, 12)
	bar.fill = SIDE_COLOR[i]
	g.add_child(bar)
	gas.append(bar)
	v.add_child(g)
	if i == 0:
		calls = UI.label("", UI.SMALL, UI.GOLD, "bold")
		v.add_child(calls)
	v.add_child(UI.caps("MOVES TRIED"))
	var log_box := UI.vbox(8)
	v.add_child(log_box)
	_logs.append(log_box)
	return p


func _top() -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _panel_box())
	p.anchor_left = 0.5
	p.anchor_right = 0.5
	p.offset_left = -270.0
	p.offset_right = 270.0
	p.offset_top = 12.0
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(2)
	p.add_child(v)
	score = UI.display("", 40, UI.FG)
	score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(score)
	clock = UI.label("", UI.BODY, UI.FG, "bold")
	clock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(clock)
	where = UI.label("", UI.SMALL, UI.MUTED, "body")
	where.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(where)
	return p


## One attempt: a row on the mover's panel, and the clash. `r` from BjjClash.read.
func attempt(me: int, title: String, hit: bool, odds: float, roll: float, r: Dictionary) -> void:
	_log(me, str(r["attack"][1]), title, hit, "%s. %s" % [r["chance"], r["reason"]])
	_clash(me, title, hit, odds, roll, r)


## The result, big, once the bodies have finished.
func banner(text: String, color: Color) -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	UI.clear(_stage)
	_stage.modulate.a = 1.0
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _panel_box())
	p.custom_minimum_size = Vector2(STAGE_W, 0)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var word := UI.display(text, 40, color)
	word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	word.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	p.add_child(word)
	_stage.add_child(p)


## A hold or a plain step: a row only.
func note(me: int, title: String) -> void:
	_log(me, "heart-pulse", title, true, "")


func _log(me: int, icon: String, title: String, hit: bool, line: String) -> void:
	var box: VBoxContainer = _logs[me]
	var row := UI.hbox(8)
	row.add_child(Icons.icon(icon, 22, UI.GREEN if hit else UI.RED, title))
	var t := UI.vbox(0)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.add_child(UI.label(title, UI.SMALL, UI.FG, "bold", true))
	if line != "":
		t.add_child(UI.muted(line, UI.TINY, true))
	row.add_child(t)
	box.add_child(row)
	box.move_child(row, 0)
	while box.get_child_count() > LOG_ROWS:
		var old := box.get_child(box.get_child_count() - 1)
		box.remove_child(old)
		old.queue_free()


func _chip(icon: String, title: String, sub: String, color: Color, big: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, color, 12, 3, 12, 8))
	# Fixed size, no wrapped text: a wrapped label measures tall before it has a width, and a free-standing panel never shrinks back.
	p.custom_minimum_size = Vector2(CHIP_W if big else CHIP_W * 0.7, 78.0 if big else 50.0)
	p.size = p.custom_minimum_size
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var h := UI.hbox(10)
	p.add_child(h)
	var pic := Icons.icon(icon, 44 if big else 26, color, title)
	pic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(pic)
	var v := UI.vbox(0)
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var name_label := UI.label(title, UI.BODY if big else UI.SMALL, UI.FG, "bold")
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(name_label)
	if big:
		v.add_child(UI.caps(sub))
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	return p


func _clash(me: int, title: String, hit: bool, odds: float, roll: float, r: Dictionary) -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	UI.clear(_stage)
	var big := bool(r["big"])
	var a := _chip(str(r["attack"][1]), title, str(r["attack"][0]), SIDE_COLOR[me], big)
	var d := _chip(str(r["defence"][1]), str(r["defence"][0]), "DEFENCE", SIDE_COLOR[1 - me], big)
	_stage.add_child(a)
	_stage.add_child(d)
	var w: float = a.custom_minimum_size.x
	var dir := 1.0 if me == 0 else -1.0                # the way the attack travels
	var mid := STAGE_W / 2.0
	var a_meet := mid - w - 2.0 if me == 0 else mid + 2.0
	var d_meet := mid + 2.0 if me == 0 else mid - w - 2.0
	a.position = Vector2(a_meet - dir * 240.0, 0.0)
	d.position = Vector2(d_meet + dir * 240.0, 0.0)
	a.modulate.a = 0.0
	d.modulate.a = 0.0
	var word := UI.display(str(r["word"]), 54 if big else 30, UI.GREEN if hit else UI.RED)
	word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	word.size = Vector2(STAGE_W, 60)
	word.position = Vector2(0, 80 if big else 52)
	word.modulate.a = 0.0
	_stage.add_child(word)
	var flash := Icons.icon("zap", 72 if big else 40, UI.GOLD, "")
	flash.position = Vector2(mid - flash.size.x / 2.0 - (36.0 if big else 20.0), 2.0)
	flash.modulate.a = 0.0
	_stage.add_child(flash)
	var why: Control = _why(odds, roll, r, hit) if big else null
	if why != null:
		why.modulate.a = 0.0
		_stage.add_child(why)
	var hold: float = (TAP_HOLD_S if bool(r["sub"]) and hit else BIG_HOLD_S) if big else SMALL_HOLD_S
	var t := create_tween()
	_tween = t
	t.set_parallel(true)
	t.tween_property(a, "modulate:a", 1.0, 0.12)
	t.tween_property(d, "modulate:a", 1.0, 0.12)
	t.tween_property(a, "position:x", a_meet, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(d, "position:x", d_meet, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.chain().tween_property(flash, "modulate:a", 1.0, 0.04)
	var winner: Control = a if hit else d
	var loser: Control = d if hit else a
	var push: float = dir * (1.0 if hit else -1.0) * 70.0
	t.chain().tween_property(flash, "modulate:a", 0.0, 0.2)
	t.tween_property(winner, "position:x", winner.position.x * 0.0 + (a_meet if hit else d_meet) + push, 0.18)
	t.tween_property(loser, "position:x", (d_meet if hit else a_meet) + push * 2.4, 0.22)
	t.tween_property(loser, "modulate:a", 0.25, 0.22)
	t.tween_property(word, "modulate:a", 1.0, 0.1)
	if why != null:
		t.tween_property(why, "modulate:a", 1.0, 0.15)
	t.chain().tween_interval(hold)
	t.chain().tween_property(_stage, "modulate:a", 0.0, 0.2)
	_stage.modulate.a = 1.0
	t.chain().tween_callback(func():
		UI.clear(_stage)
		_stage.modulate.a = 1.0)


## The odds as a bar: green is the chance, the mark is what came up. Under the mark's line, the plain reason.
func _why(odds: float, roll: float, r: Dictionary, hit: bool) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _panel_box())
	p.position = Vector2(150.0, 144.0)
	p.custom_minimum_size = Vector2(STAGE_W - 300.0, 0)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(4)
	p.add_child(v)
	v.add_child(UI.label("%s, rolled %d" % [r["chance"], roundi(roll * 100.0)], UI.SMALL, UI.FG, "bold"))
	var track := ColorRect.new()
	track.custom_minimum_size = Vector2(STAGE_W - 330.0, 12)
	track.color = UI.LINE
	var fill := ColorRect.new()
	fill.color = UI.GREEN
	fill.size = Vector2(track.custom_minimum_size.x * clampf(odds, 0.0, 1.0), 12)
	track.add_child(fill)
	var mark := ColorRect.new()
	mark.color = UI.FG if hit else UI.RED
	mark.size = Vector2(4, 20)
	mark.position = Vector2(track.custom_minimum_size.x * clampf(roll, 0.0, 1.0) - 2.0, -4.0)
	track.add_child(mark)
	v.add_child(track)
	v.add_child(UI.muted(str(r["reason"]), UI.SMALL, true))
	return p
