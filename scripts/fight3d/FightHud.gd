extends RefCounted
## The fight view's scorebug, caption box, banner and button row (moved out of FightView, S308, to keep it under 500
## lines). build(view) creates them on the view and sets its _bug_box / _bug / _clock / _buttons / _cap_box / _caption / _banner.
## S345 FIGHTHUD2 (Q-S294-69 "Yes, build it"): the scorebug is the round box top centre (round, clock, the round edge
## meter); each boxer's six bars stand in her top corner (HudBars) - the text rows (ENERGY 82, BODY TAKEN 4) are gone.

const FightCalls := preload("res://scripts/fight3d/FightCalls.gd")
const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const BodyLive := preload("res://scripts/fight3d/BodyLive.gd")
const BodyBurn := preload("res://scripts/fight3d/BodyBurn.gd")
const SidePanel := preload("res://scripts/fight3d/SidePanel.gd")
const IntentChip := preload("res://scripts/fight3d/IntentChip.gd")
const HudRegroup := preload("res://scripts/fight3d/HudRegroup.gd")
const ScoreBug := preload("res://scripts/fight3d/ScoreBug.gd")
const CornerBar := preload("res://scripts/fight3d/CornerBar.gd")
const HoverLabel := preload("res://scripts/ui/HoverLabel.gd")


## The round's exchanges scored by round time t. S312 (Ziva review: the caption said the 30 s was won while the score
## still read 0-0): an exchange counts from its verdict caption; the energy display still waits for the 30 s line.
static func scored(exchanges: Array, t: float) -> Array:
	return exchanges.slice(0, int((t + ExchangeBeats.VERDICT_LEAD_S) / Exchanges.EX_SECONDS))


static func build(view: Control) -> void:
	ScoreBug.attach(view)   # the round box: clock, the two totals, six dots, the cards
	view.bars = SidePanel.attach(view)   # a card each side; the rings are no longer built
	view.body = BodyLive.attach(view)   # S318 the body map; the holo is a child of each side panel
	view.burn = BodyBurn.attach(view)   # S322 per-part Burn: guard, steps, punch snap
	view._buttons = UI.hbox(8)
	view._buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	view.add_child(view._buttons)
	pin(view._buttons, Vector4(0.5, 0, 0.5, 0), Vector4(-320, 176, 320, 216))
	view._cap_box = PanelContainer.new()
	view._cap_box.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	view._cap_box.visible = false
	view.add_child(view._cap_box)
	pin(view._cap_box, Vector4(0.5, 1, 0.5, 1), Vector4(-620, -239, 620, -181))
	view._caption = UI.label("", 26, UI.FG, "body", true)
	view._caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	view._caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	view._caption.add_theme_constant_override("outline_size", 8)
	view._caption.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	view._cap_box.add_child(view._caption)
	view._banner = UI.display("", 64)
	view._banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	view._banner.add_theme_constant_override("outline_size", 10)
	view._banner.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	view.add_child(view._banner)
	pin(view._banner, Vector4(0.5, 0, 0.5, 0), Vector4(-640, 226, 640, 326))
	FightCalls.attach(view, pin)   # S395 the TV line and the big-shot moment
	CornerBar.attach(view)   # the plank across the bottom, on for the whole round
	IntentChip.attach(view)   # a status word over each head, up with the scorebug
	HudRegroup.attach(view)   # S444 Q-196 preview only (user arg `hudregroup`): the UX audit's regroup, for his stills


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
const FADE_S := 0.35


static func draw_buttons(view: Control) -> void:
	var row: HBoxContainer = view._buttons
	UI.clear(row)
	row.visible = false
	if view.has_meta("corner"):
		view.get_meta("corner").call("draw_speed")
		return
	var speed := UI.button("2x" if view.pace() > 1.0 else "1x", "BtnQuiet", view._toggle_speed)
	row.add_child(speed)
	HoverLabel.attach(speed, "Speed (Space)")   # S443: the small 1x / 2x shows its word on hover
	var skip := UI.button("Skip round", "Btn", view.skip_round)
	skip.name = "SkipRound"
	row.add_child(skip)
	var bout := UI.button("Skip bout", "Btn", view.skip_bout)
	bout.name = "SkipBout"
	row.add_child(bout)
	row.visible = bool(view.playing)


## S395 (blind review: the bar goes back to even each round and nothing on screen says who leads the fight): the round line.
static func round_line(n: int, total: int, rounds_done: Array, names: Array) -> String:
	var line := "ROUND %d OF %d" % [n, total]
	var won := rounds_done.filter(func(x): return bool((x as Dictionary).get("won", false))).size()
	var lost := rounds_done.size() - won
	if rounds_done.is_empty():
		return line
	if won == lost:
		return "%s   LEVEL %d-%d" % [line, won, lost]
	return "%s   %s LEADS %d-%d" % [line, str(names[0 if won > lost else 1]).get_slice(" ", 0).to_upper(), maxi(won, lost), mini(won, lost)]


## S395 (blind review: everything cut out on one frame at the bell): it goes in the bell's last moments, before the corner.
static func fade_out(view: Control) -> void:
	var tw := view.create_tween().set_parallel(true)
	for c in [view._bug_box, view._banner] + (view.bars.blocks as Array):
		tw.tween_property(c, "modulate:a", 0.0, FADE_S)


## S395 (blind review: the whole HUD popped back on one frame after the corner).
static func fade_in(view: Control) -> void:
	view._banner.modulate.a = 1.0
	var tw := view.create_tween().set_parallel(true)
	for c in [view._bug_box, view._buttons] + (view.bars.blocks as Array):
		(c as Control).modulate.a = 0.0
		tw.tween_property(c, "modulate:a", 1.0, 0.4)


## snap = LiveRound.state after the watched exchanges (energy a/b, body [hers, theirs], hurt [hers, theirs]); scored =
## this round's exchanges scored so far (the round edge). S310's rule holds: painted only from what was watched.
static func paint(view: Control, snap: Dictionary, scored_now: Array) -> void:
	if view.get("bars") != null:
		view.bars.paint(snap, scored_now, round_start(view))


## S395 (film: rings 67/69 at the bell, the corner card 62/65): the display after the exchanges finished by t, with both
## tanks easing through the one being fought, so the last 30 s is not one jump at the bell. Body and hurt stay on the line.
static func shown(exchanges: Array, t: float, start: Dictionary) -> Dictionary:
	var k := int(t / Exchanges.EX_SECONDS)
	var done: Dictionary = start
	if k >= 1 and not exchanges.is_empty():
		done = (exchanges[mini(k, exchanges.size()) - 1] as Dictionary).get("after", {})
	if k >= exchanges.size():
		return done
	var now: Dictionary = (exchanges[k] as Dictionary).get("after", {})
	var out := done.duplicate()
	var part := fmod(t, Exchanges.EX_SECONDS) / Exchanges.EX_SECONDS
	for who in ["a", "b"]:
		if done.has(who) and now.has(who):
			out[who] = lerpf(float(done[who]), float(now[who]), part)
	return out


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
