extends Control
## S307 the corner minute's screen (docs/FIGHT_NIGHT_SCRIPT.md v2): letterbox bars (2.39:1 on the 16:9 frame), the rest
## clock, the coach's lines as captions in the lower bar, the corner card (what worked, what hurt, the coach's call) with
## the three calls to pick while the minute runs, and SKIP TO THE BELL.
##   build(card, names)  clock(left_s)  say(text)  show_card(on)  picked(call)   signals: chose(call), skip

const UI := preload("res://scripts/ui/UI.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

signal chose(call: String)
signal skip

## Each bar's share of the frame height: (1 - (16/9) / 2.39) / 2.
const BAR := 0.128
const BAR_COLOUR := Color(0, 0, 0, 1)

var _clock: Label
var _caption: Label
var _card: PanelContainer
var _calls: HBoxContainer
var _said: Label


func build(card: Dictionary, names: Array) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for top in [true, false]:
		var bar := ColorRect.new()
		bar.color = BAR_COLOUR
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bar)
		_pin(bar, Vector4(0, 0 if top else 1.0 - BAR, 1, BAR if top else 1), Vector4.ZERO)
	_clock = UI.mono("", UI.SMALL, UI.MUTED)
	add_child(_clock)
	_pin(_clock, Vector4(0, 0, 0, 0), Vector4(32, 30, 420, 70))
	var sk := UI.button("Skip to the bell", "BtnQuiet", func(): skip.emit())
	sk.name = "SkipCorner"
	add_child(sk)
	_pin(sk, Vector4(1, 0, 1, 0), Vector4(-300, 22, -28, 70))
	_caption = UI.label("", 28, UI.FG, "body", true)
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(_caption)
	_pin(_caption, Vector4(0.08, 1.0 - BAR, 0.92, 1), Vector4.ZERO)
	_card = PanelContainer.new()
	_card.add_theme_stylebox_override("panel", UI.box(Color(0.05, 0.04, 0.04, 0.88), UI.LINE, 6, 1, 18, 14))
	add_child(_card)
	_pin(_card, Vector4(1, 1.0 - BAR, 1, 1.0 - BAR), Vector4(-900, -230, -28, -16))
	var v := UI.vbox(6)
	_card.add_child(v)
	v.add_child(UI.caps("IN THE CORNER: WHAT DO YOU TELL %s?" % str(names[0]).to_upper()))
	for row in [["WORKED", card["worked"], UI.GREEN], ["HURT", card["hurt"], UI.RED], ["COACH", "%s" % card["why"], UI.AMBER]]:
		var line := UI.hbox(10)
		var tag := UI.caps(str(row[0]))
		tag.custom_minimum_size = Vector2(84, 0)
		tag.add_theme_color_override("font_color", row[2])
		line.add_child(tag)
		var said := UI.label(str(row[1]), 18, UI.FG, "body", true)
		said.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.add_child(said)
		v.add_child(line)
	_calls = UI.hbox(6)
	for k in BoutRules.CORNER.keys():
		var b := UI.button(BoutRules.CORNER[k] + ("  (coach)" if str(k) == str(card["call"]) else ""), "Choice", func(): chose.emit(str(k)))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.name = "Corner_" + str(k)
		_calls.add_child(b)
	v.add_child(_calls)
	_said = UI.muted("", UI.SMALL)
	_said.visible = false
	v.add_child(_said)
	_card.visible = false


func clock(left_s: float, round_next: int) -> void:
	_clock.text = "CORNER   0:%02d   ROUND %d NEXT" % [int(ceilf(maxf(0.0, left_s))), round_next]


func say(text: String) -> void:
	_caption.text = text


func show_card(on: bool) -> void:
	_card.visible = on


## The call is made: the buttons go, the call stays on the card.
func picked(call: String) -> void:
	_calls.visible = false
	_said.text = "Your call: \"%s\"" % BoutRules.CORNER[call]
	_said.visible = true


func _pin(c: Control, anchors: Vector4, offsets: Vector4) -> void:
	c.anchor_left = anchors.x
	c.anchor_top = anchors.y
	c.anchor_right = anchors.z
	c.anchor_bottom = anchors.w
	c.offset_left = offsets.x
	c.offset_top = offsets.y
	c.offset_right = offsets.z
	c.offset_bottom = offsets.w
