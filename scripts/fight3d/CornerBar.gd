extends Control
## The corner plank across the bottom for the whole round. Pace and aim stay in force (they write the live
## round at once). Calls, Say nothing, 2x and the skips sit here. The pick still waits ShoutBar.SHOW_S real
## seconds at each exchange; the ring, the pulse and the NOW plate all read that one counter.

const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const HoverLabel := preload("res://scripts/ui/HoverLabel.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const Ink := preload("res://scripts/ui/UI.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const NowPlateSc := preload("res://scripts/fight3d/NowPlate.gd")
const ShoutBar := preload("res://scripts/fight3d/ShoutBar.gd")
const RoundBoard := preload("res://scripts/fight3d/RoundBoard.gd")
const CornerIcons := preload("res://scripts/fight3d/CornerIcons.gd")
const FightSeam := preload("res://scripts/fight3d/FightSeam.gd")
const SharedHolo := preload("res://scripts/fight3d/SharedHolo.gd")
const FX_W := 276.0
const DOCK_W := 340.0   # FIGHTDISPLAY4: the heard pips and the habit card dock here (SidePanel._gap)
const CALL_Y := 90.0
const CALL_H := 66.0

const PACE_LABEL := {"push": "Push", "steady": "Steady", "save": "Save"}
const AIM_LABEL := {"": "Take initiative", "head": "Head", "body": "Body", "left_ribs": "Left ribs",
	"right_ribs": "Right ribs", "head_hurt": "The hurt head"}

var view: Node
var _plate: Button
var _body: Control
var _ring: CornerIcons.Ring
var _speed: Button
var _calls: Control
var _sig := ""


static func attach(v: Node) -> Control:
	var bar := new()
	bar.name = "CornerBar"
	bar.view = v
	v.add_child(bar)
	v.set_meta("corner", bar)
	bar._mount()
	var plate := NowPlateSc.new()
	plate.setup(v)
	v.add_child(plate)
	bar._plate = plate
	return bar


func _mount() -> void:
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_left = 16.0
	offset_right = -16.0
	offset_top = -175.0
	offset_bottom = -5.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var wood := Panel.new()
	wood.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wood.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	wood.add_theme_stylebox_override("panel", WoodKit.bar(8, 6))
	add_child(wood)
	_speed = _btn("1x", "Speed", func(): view.call("_toggle_speed"))
	_put_right(_speed, 8, 44)
	HoverLabel.attach(_speed, "Speed (Space)", "left")   # S443: the small 1x / 2x shows its word on hover, beside it (Skip round is under it)
	var skip := _btn("Skip round", "SkipRound", func(): view.call("skip_round"))
	_put_right(skip, 54, 40)
	var bout := _btn("Skip bout", "SkipBout", func(): view.call("skip_bout"))
	_put_right(bout, 96, 36)
	visible = false


func draw_speed() -> void:
	if _speed == null or view == null:
		return
	_speed.text = "2x" if float(view.call("pace")) > 1.0 else "1x"


func _process(_delta: float) -> void:
	if view == null:
		return
	var playing := bool(view.get("playing"))
	visible = playing and float(view.get("_bell_left")) < 0.0
	var pv := _preview()
	var now: Dictionary = {}
	var raw: Variant = pv.get("now", {})
	if raw is Dictionary:
		now = raw
	var waiting := false   # S459 FIGHTSEAM1: no bar waits at a join any more
	var left := -1.0
	if _plate != null:
		_plate.visible = visible and not now.is_empty()
		if _plate.visible:
			_plate.call("show_offer", now, left, waiting)
	if not visible:
		return
	var wide := int(size.x) if size.x > 400.0 else 1888
	var sig := "%s|%s|%s|%s|%d|%s|%d|%s" % [pv.get("offers", []), pv.get("pace", ""), pv.get("aim", ""), _mark_key(), wide,
		FightSeam.armed(view), FightSeam.landed_ex(view)[0]["landed"].hash(), SharedHolo.hurt_of(view)]
	if sig != _sig:
		_sig = sig
		_rebuild(pv, wide)
	_tick(waiting, left)
	if _calls != null:
		_calls.modulate.a = 0.72 + 0.28 * absf(sin(left * TAU)) if waiting else 1.0


func _set_pace(p: String) -> void:
	_write("pace", p)


func _set_aim(a: String) -> void:
	_write("aim", a)


func _write(key: String, value: String) -> void:
	var main: Node = view.get("main")
	if main == null:
		return
	var m: Dictionary = main.get("modal")
	var lv: Dictionary = {}
	var raw: Variant = m.get("live", {})
	if raw is Dictionary:
		lv = raw
	if not lv.is_empty():
		lv[key] = value
	var w: Node = view.get("_shouting")
	if w != null:
		w.set(key, value)
	_sig = ""


## S459 FIGHTSEAM1 (his "calls any time"): a click arms the call; the next exchange is fought on it (FightSeam.take).
func _shout(call: String) -> void:
	FightSeam.arm(view, call)
	_sig = ""


func _rebuild(pv: Dictionary, wide: int) -> void:
	if _body != null:
		remove_child(_body)
		_body.queue_free()
	_body = Control.new()
	_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_body.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_body)
	var x := 8.0
	_tag("PACE", x, 4, 80)
	var pace := str(pv.get("pace", "steady"))
	for p in PaceAim.PACES:
		var b := _btn(str(PACE_LABEL[p]), "Pace_" + str(p), _set_pace.bind(str(p)))
		b.tooltip_text = PaceAim.pace_tip(str(p))
		_wood(b, str(p) == pace)
		_place(_body, b, x, 36, 92, 44)
		x += 96.0
	# S459 operator C371 point 7 ("how save and own game work together?"): PACE and AIM read as one row of five buttons.
	# A wide gap with a divider between the two groups, each heading over its own buttons.
	x += 14.0
	var div := ColorRect.new()
	div.name = "PaceAimDivider"
	div.color = Color("#6b5338")
	div.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(_body, div, x, 8, 3, 72)
	x += 17.0
	_tag("AIM", x, 4, 70)
	var aim := str(pv.get("aim", ""))
	var aims: Array = pv.get("aims", ["", "head", "body"])
	for a in aims:
		var label := str(AIM_LABEL.get(a, a))
		var bw := 150.0 if str(a) == "" else 84.0   # S458: "Take initiative" (his rename of "Own game")
		var named := "Aim_" + (str(a) if str(a) != "" else "own")
		var b := _btn(label, named, _set_aim.bind(str(a)))
		b.tooltip_text = PaceAim.aim_tip(str(a), _opp(pv))
		_wood(b, str(a) == aim)
		_place(_body, b, x, 36, bw, 44)
		x += bw + 6.0
	x += 8.0   # S459 FIGHTSEAM1: no countdown ring to the next join (it marked the seam)
	_effects(x, pace, aim, _opp(pv))
	x += FX_W
	# S427 (his marks on the bar, Feedback/2026-11-10-20): the calls are smaller and sit on the left under pace and aim;
	# the right of the bar is the live round board.
	var offers: Array = pv.get("offers", [])
	var right := float(wide) - 156.0
	var say_w := 112.0
	var gaps := 8.0 * float(offers.size())
	var each := maxf(150.0, (x - 8.0 - say_w - gaps) / float(maxi(offers.size(), 1)))
	_calls = Control.new()
	_calls.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_body.add_child(_calls)
	var sit := str(pv.get("sit", ""))
	var names: Array = pv.get("names", [])
	var force := FightSeam.armed(view) if FightSeam.armed(view) != "" else _in_force()
	var cx := 8.0
	for call in offers:
		var frame := _call(str(call), sit, names, str(call) == force, each, pv.get("grades", {}))
		_place(_calls, frame, cx, CALL_Y, each, CALL_H)
		cx += each + 8.0
	var say := _btn("Say nothing", "SayNothing", _shout.bind(""))
	say.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	say.tooltip_text = "No shout. The boxer sticks to the plan"
	_wood(say, false)
	say.add_theme_font_size_override("font_size", 20)
	_place(_calls, say, cx, CALL_Y, say_w, CALL_H)
	x += DOCK_W
	_place(_body, RoundBoard.build(_ex_over(), sit, names, right - x - 16.0, 150.0, FightSeam.landed_ex(view), SharedHolo.holo_of(view), SharedHolo.hurt_of(view)), x + 8.0, 6, right - x - 16.0, 150)


func _call(call: String, sit: String, names: Array, on: bool, _wide: float, pv_grades: Dictionary = {}) -> Control:
	var frame := Panel.new()
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var edge := StyleBoxFlat.new()
	edge.bg_color = Color(0, 0, 0, 0)
	edge.border_color = Color("#6b5338")
	edge.set_border_width_all(3)
	edge.set_corner_radius_all(10)
	frame.add_theme_stylebox_override("panel", edge)
	if on:
		Halo.ring(frame, WoodKit.HEAD, 10.0)
	var b := Button.new()
	b.name = "Call_" + call
	b.focus_mode = Control.FOCUS_NONE
	b.clip_text = false
	_wood(b, on)
	b.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	b.offset_left = 4
	b.offset_top = 4
	b.offset_right = -4
	b.offset_bottom = -4
	var row: Dictionary = Exchanges.CALLS[call]
	b.tooltip_text = Exchanges.named("%s\n%s" % [row["when"], row["expect"]], names)
	b.pressed.connect(_shout.bind(call))
	frame.add_child(b)
	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 0)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 6
	box.offset_right = -6
	b.add_child(box)
	var words := str(row["label"]).to_upper()
	var title := TV.label(words, 22, WoodKit.INK if not on else WoodKit.DARK_INK, "bold")
	title.name = "CallTitle_" + call
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var under := HBoxContainer.new()
	under.alignment = BoxContainer.ALIGNMENT_CENTER
	under.add_theme_constant_override("separation", 8)
	under.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(under)
	# S459 (operator C371 points 4-6: "remove, show what it affects, numbers and icons and use tooltip for text"): no grade
	# word. A glove in the fit's colour + what the call does to her chance of winning these 30 seconds; the words on hover.
	var fit := Exchanges.fit(call, sit)
	var grade_word := str((pv_grades.get(call, "OK")))
	var shift := Exchanges.win_shift(call, sit, grade_word)
	var glove := CornerIcons.Glove.new()
	glove.name = "Glove_" + call
	glove.col = _fit_color(fit) if fit != "none" else WoodKit.SOFT
	glove.custom_minimum_size = Vector2(22, 24)
	glove.mouse_filter = Control.MOUSE_FILTER_IGNORE
	under.add_child(glove)
	var lab := TV.label(("+" if shift > 0 else "") + str(shift) + "%", 20, _shift_ink(shift, on), "bold")
	lab.name = "Grade_" + call
	lab.set_meta("shift", shift)
	lab.custom_minimum_size = Vector2(52, 22)
	under.add_child(lab)
	b.tooltip_text = "%s
%s
%s Chance to win these 30 seconds: %s%d in 100. %s" % [Exchanges.named(str(row["when"]), names),
		Exchanges.named(str(row["expect"]), names), _grade_word(fit), "+" if shift > 0 else "", shift,
		Exchanges.named(str(Exchanges.GRADE_LINE.get(grade_word, "")), names) + "."]
	var cost := float(row["cost"])
	var spend := TV.label(_cost_word(cost), 20, WoodKit.HEAD if not on else Color("#6b3d00"), "bold")   # S427: gold on the lit plate could not be read
	spend.name = "Cost_" + call
	spend.set_meta("cost", cost)   # S444 the regroup preview shows it as a number (HudRegroup._costs)
	spend.set_meta("ink", _shift_ink(signi(roundi(-cost * 10.0)), on))   # S459: dark ink on the lit plate
	spend.custom_minimum_size = Vector2(60, 22)
	under.add_child(spend)
	return frame


## S430 (operator: "do these affect anything , they take effect immediately or how they work ?"; and on the LAST CALL box
## that sat here: "whats the point of htis ?" - the round board already shows every call with its ticks): what the pace
## and the aim in force do, and when they count.
func _effects(x: float, pace: String, aim: String, opp: String) -> void:
	var panel := Panel.new()
	panel.name = "Effects"
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#1a1512")
	sb.border_color = Color("#5a4a3a")
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", sb)
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.tooltip_text = "%s

%s" % [PaceAim.pace_tip(pace), PaceAim.aim_tip(aim, opp)]
	_place(_body, panel, x, 4, FX_W - 8.0, 80)
	var head := TV.label("FROM THE NEXT EXCHANGE", 20, WoodKit.SOFT, "bold")
	head.name = "EffectsTag"
	_place(panel, head, 10, 2, FX_W - 28.0, 24)
	var p := TV.label(PaceAim.pace_effect(pace), 20, WoodKit.HEAD if pace != "steady" else WoodKit.INK)
	p.name = "PaceEffect"
	_place(panel, p, 10, 26, FX_W - 28.0, 24)
	var a := TV.label(PaceAim.aim_effect(aim, opp), 20, WoodKit.HEAD if aim != "" else WoodKit.INK)
	a.name = "AimEffect"
	_place(panel, a, 10, 50, FX_W - 28.0, 24)


func _opp(_pv: Dictionary) -> String:
	return "the opponent"   # S448 operator: names only in the header


func _tick(waiting: bool, left: float) -> void:
	if _ring == null:
		return
	var secs: float
	var span: float
	if waiting:
		secs = left
		span = ShoutBar.SHOW_S
	else:
		var boundary := float(int(view.get("_ex_done"))) * 30.0
		secs = maxf(0.0, boundary - float(view.get("t")))
		span = 30.0
	var show := int(ceil(maxf(0.0, secs)))
	_ring.caption = "%d:%02d" % [show / 60, show % 60]
	_ring.frac = clampf(secs / maxf(0.01, span), 0.0, 1.0)
	_ring.hot = show <= 5
	_ring.queue_redraw()


func _preview() -> Dictionary:
	var main: Node = view.get("main")
	if main == null:
		return {}
	var career: Object = main.get("career")
	if career == null:
		return {}
	var f: Dictionary = career.call("fighter_by_id", str(view.get("fid")))
	var m: Dictionary = main.get("modal")
	return LiveRound.preview(f, m)


func _live(key: String, fallback: String) -> String:
	var main: Node = view.get("main")
	if main == null:
		return fallback
	var m: Dictionary = main.get("modal")
	var raw: Variant = m.get("live", {})
	if raw is Dictionary and (raw as Dictionary).has(key):
		return str((raw as Dictionary)[key])
	return fallback


func _ex() -> Array:
	if view.has_method("_exchanges"):
		return view.call("_exchanges")
	return []


## S445: only the exchanges whose 30 seconds are over. The live round settles an exchange when it starts, so reading
## them all put this exchange's landed punches and its call's tick or cross on the board before a punch was thrown.
func _ex_over() -> Array:
	var ex := _ex()
	var t := float(view.get("t")) if view.get("t") != null else 1e9
	var n := 0
	for i in ex.size():
		if float(i + 1) * 30.0 <= t + 0.05:
			n = i + 1
	return ex.slice(0, n)


func _in_force() -> String:
	var ex := _ex()
	if ex.is_empty():
		return _live("plan", "")
	return str((ex[-1] as Dictionary).get("call", ""))


func _mark_key() -> String:
	var ex := _ex_over()
	var bits := ""
	for e in ex:
		bits += str((e as Dictionary).get("call", "")) + ("1" if bool((e as Dictionary).get("won", false)) else "0")
	return bits


## What the call does to her energy, in words (S426 operator on the bolt and arrows: "what are these symbols ??").
func _cost_word(cost: float) -> String:
	if cost <= -1.5:
		return "Rests well"
	if cost < 0.0:
		return "Rests"
	if cost >= 2.25:
		return "Tires a lot"
	if cost > 0.0:
		return "Tires"
	return "Even"


func _grade_word(fit: String) -> String:
	if fit == "best":
		return "Beats the opponent's game."
	if fit == "ok":
		return "Works against the opponent's game."
	if fit == "wrong":
		return "Risky: plays into the opponent's game."
	return "No answer to the opponent's game."


func _shift_ink(shift: int, on: bool) -> Color:
	if shift > 0:
		return Color("#2f6b2a") if on else Color("#7fd18b")
	if shift < 0:
		return Color("#9a2a1a") if on else Color("#ff8a6a")
	return WoodKit.DARK_INK if on else Color("#d8d0c0")



func _fit_color(fit: String) -> Color:
	if fit == "best":
		return Ink.GREEN
	if fit == "ok":
		return Ink.AMBER
	return Ink.RED


func _tag(text: String, x: float, y: float, w: float) -> Label:
	var l := TV.label(text, 20, WoodKit.SOFT, "bold")
	_place(_body, l, x, y, w, 28)
	return l


func _btn(text: String, named: String, on_press: Callable) -> Button:
	var b := Button.new()
	b.name = named
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.clip_text = false
	_wood(b, false)
	b.pressed.connect(on_press)
	return b


func _wood(b: Button, on: bool) -> void:
	var t := Theme.new()
	var kind := "ChoiceOn" if on else "Choice"
	WoodKit.plates(t, kind, 8, 6)
	for state in ["normal", "hover", "pressed", "disabled"]:
		b.add_theme_stylebox_override(state, t.get_stylebox(state, kind))
	var ink: Color = WoodKit.DARK_INK if on else WoodKit.INK
	b.add_theme_color_override("font_color", ink)
	b.add_theme_color_override("font_hover_color", ink)
	b.add_theme_color_override("font_pressed_color", ink)
	b.add_theme_font_size_override("font_size", 22)


func _put_right(c: Control, y: float, h: float) -> void:
	add_child(c)
	c.anchor_left = 1.0
	c.anchor_right = 1.0
	c.anchor_top = 0.0
	c.anchor_bottom = 0.0
	c.offset_left = -148.0
	c.offset_right = -8.0
	c.offset_top = y
	c.offset_bottom = y + h


func _place(parent: Control, c: Control, x: float, y: float, w: float, h: float) -> void:
	parent.add_child(c)
	c.anchor_left = 0.0
	c.anchor_top = 0.0
	c.anchor_right = 0.0
	c.anchor_bottom = 0.0
	c.offset_left = x
	c.offset_top = y
	c.offset_right = x + w
	c.offset_bottom = y + h
