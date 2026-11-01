extends RefCounted
## The fight view's scorebug, caption box, banner and button row (moved out of FightView, S308, to keep it under 500
## lines). build(view) creates them on the view and sets its _bug_box / _bug / _clock / _buttons / _cap_box / _caption / _banner.
## S345 FIGHTHUD2 (Q-S294-69 "Yes, build it"): the scorebug is the round box top centre (round, clock, the round edge
## meter); each boxer's six bars stand in her top corner (HudBars) - the text rows (ENERGY 82, BODY TAKEN 4) are gone.

const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const BodyLive := preload("res://scripts/fight3d/BodyLive.gd")
const BodyBurn := preload("res://scripts/fight3d/BodyBurn.gd")
const HudBars := preload("res://scripts/fight3d/HudBars.gd")


## The round's exchanges scored by round time t. S312 (Ziva review: the caption said the 30 s was won while the score
## still read 0-0): an exchange counts from its verdict caption; the energy display still waits for the 30 s line.
static func scored(exchanges: Array, t: float) -> Array:
	return exchanges.slice(0, int((t + ExchangeBeats.VERDICT_LEAD_S) / Exchanges.EX_SECONDS))


static func build(view: Control) -> void:
	var bug := PanelContainer.new()
	bug.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.86), UI.LINE, 6, 1, 14, 8))
	view.add_child(bug)
	pin(bug, Vector4(0.5, 0, 0.5, 0), Vector4(0, 24, 0, 24))
	bug.grow_horizontal = Control.GROW_DIRECTION_BOTH
	view._bug_box = bug
	var bv := UI.vbox(3)
	bug.add_child(bv)
	view._bug = UI.label("", UI.SMALL, UI.FG, "bold")
	view._bug.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bv.add_child(view._bug)
	view._clock = UI.mono("", UI.BODY, UI.FG)
	view._clock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bv.add_child(view._clock)
	view.bars = HudBars.attach(view)   # S345 the six bars a boxer + the round edge
	bv.add_child(view.bars.edge)
	view.body = BodyLive.attach(view)   # S318 the body map figures, under the bars
	view.burn = BodyBurn.attach(view)   # S322 per-part Burn: guard, steps, punch snap
	view._buttons = UI.hbox(8)
	view._buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	view.add_child(view._buttons)
	pin(view._buttons, Vector4(0.5, 0, 0.5, 0), Vector4(-320, 132, 320, 172))
	view._cap_box = PanelContainer.new()
	view._cap_box.add_theme_stylebox_override("panel", UI.box(Color(0.04, 0.03, 0.03, 0.78), Color(0, 0, 0, 0), 6, 0, 22, 10))
	view._cap_box.visible = false
	view.add_child(view._cap_box)
	pin(view._cap_box, Vector4(0.5, 1, 0.5, 1), Vector4(-620, -78, 620, -22))
	view._caption = UI.label("", 26, UI.FG, "body", true)
	view._caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	view._caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	view._cap_box.add_child(view._caption)
	view._banner = UI.display("", 64)
	view._banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	view._banner.add_theme_constant_override("outline_size", 10)
	view._banner.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	view.add_child(view._banner)
	pin(view._banner, Vector4(0.5, 0, 0.5, 0), Vector4(-640, 190, 640, 290))


## Anchors (left, top, right, bottom) and offsets in pixels from them.
static func pin(c: Control, anchors: Vector4, offsets: Vector4) -> void:
	c.anchor_left = anchors.x
	c.anchor_top = anchors.y
	c.anchor_right = anchors.z
	c.anchor_bottom = anchors.w
	c.offset_left = offsets.x
	c.offset_top = offsets.y
	c.offset_right = offsets.z
	c.offset_bottom = offsets.w


## The speed and skip buttons (shown while a round plays; moved out of FightView S312).
static func draw_buttons(view: Control) -> void:
	var row: HBoxContainer = view._buttons
	UI.clear(row)
	var speed := UI.button("2x" if view.pace() > 1.0 else "1x", "BtnQuiet", view._toggle_speed)
	speed.tooltip_text = "Speed (Space)"
	row.add_child(speed)
	var skip := UI.button("Skip round", "Btn", view.skip_round)
	skip.name = "SkipRound"
	row.add_child(skip)
	var bout := UI.button("Skip bout", "Btn", view.skip_bout)
	bout.name = "SkipBout"
	row.add_child(bout)
	row.visible = bool(view.playing)


## snap = LiveRound.state after the watched exchanges (energy a/b, body [hers, theirs], hurt [hers, theirs]); scored =
## this round's exchanges scored so far (the round edge). S310's rule holds: painted only from what was watched.
static func paint(view: Control, snap: Dictionary, scored_now: Array) -> void:
	if view.get("bars") != null:
		view.bars.paint(snap, scored_now, round_start(view))


## The fight display before this round's first exchange: the live round's start, or the closed round's.
static func round_start(view: Control) -> Dictionary:
	var main: Node = view.main
	if main == null:
		return {}
	var lv := LiveRound.live(main.modal)
	if not lv.is_empty():
		return lv.get("start", {})
	var rounds: Array = main.modal.get("rounds", [])
	var n := int(view.round_n)
	return (rounds[n - 1] as Dictionary).get("start", {}) if n >= 1 and rounds.size() >= n else {}
