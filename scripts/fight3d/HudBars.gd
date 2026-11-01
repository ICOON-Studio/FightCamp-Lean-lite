extends Node
## S345 FIGHTHUD2 (operator Q-S294-69 "Yes, build it"; Game Godot/research/FIGHTHUD_S344.md, "gotta beat this" - the UFC 6
## fight HUD): six bars a boxer in her top corner - head, body, legs, stamina, guard, heart - icons, no numbers (they live
## in each row's tooltip), and the round edge meter under the round clock in the middle. FightMeters reads the values off
## the ring (BodyLive's map, BodyBurn's eased Burn and guard drop, the live round's energy, the bout's counts and hurt
## moments). What beats theirs: the opponent's guard and heart show "?" until scouting found them (her file), every bar
## eases and pulses on a band change (operator: animated meters), a body shot flashes her body and stamina bars together
## (the grey end of the tank grows), and when her scouted guard sinks the corner says so.
##   attach(view) -> HudBars   edge (the centre meter, FightHud places it)   paint(snap, scored, round start)

const FightMeters := preload("res://scripts/rules/FightMeters.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const UI := preload("res://scripts/ui/TV.gd")

const EDGE := 28.0
const TOP := 24.0
const BAR_SIZE := Vector2(260, 12)
const ICON_PX := 16
const SIDE_COLOUR := [Color(0.95, 0.4, 0.35), Color(0.5, 0.65, 1.0)]
const ICON := {"head": "user", "body": "shirt", "legs": "footprints", "stamina": "zap", "guard": "shield", "heart": "heart"}
const WORDS := {
	"head": "Head: the worst of her head, eyes and nose. The grey never comes back this fight (cuts, swelling).",
	"body": "Body: her ribs. Every body shot also greys the end of her stamina.",
	"legs": "Legs: tired legs take shorter, slower steps - she cannot cut the ring off.",
	"stamina": "Stamina: her tank. The minute's rest gives some back; the grey end is gone for the fight.",
	"guard": "Guard: how high her hands stay. It sinks as her shoulders tire.",
	"heart": "Heart: how far she is from quitting. Standing counts and hurt moments wear it down.",
}
const UNKNOWN := {
	"guard": "Guard: not scouted. Find one of her habits on tape (the tape room or tape study in camp).",
	"heart": "Heart: not scouted. Her file shows it once tape study reaches her weakness.",
}
## Her scouted guard under this and the corner tells her to go over the top (once a round).
const GUARD_LOW := 0.55
const READ_S := 0.25

var view: Control
var edge: Control
var blocks: Array = []
var meters: Array = [{}, {}]
var _hurt: Array = []
var _known := [{"guard": true, "heart": true}, {"guard": true, "heart": true}]
var _snap: Dictionary = {}
var _scored: Array = []
var _start: Dictionary = {}
var _read_left := 0.0
var _body_seen := [-1, -1]
var _low_said := -1


static func attach(v: Control) -> Node:
	var hb := new()
	hb.name = "HudBars"
	hb.view = v
	v.add_child(hb)
	hb._build()
	return hb


func _build() -> void:
	var opp := _opp()
	if not opp.is_empty():
		_known[1] = {"guard": FightMeters.guard_known(opp), "heart": FightMeters.heart_known(opp)}
	for side in 2:
		var panel := PanelContainer.new()
		panel.name = "Bars%d" % side
		panel.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.82), UI.LINE, 6, 1, 14, 10))
		var col := UI.vbox(5)
		panel.add_child(col)
		var top := UI.hbox(8)
		top.alignment = BoxContainer.ALIGNMENT_BEGIN if side == 0 else BoxContainer.ALIGNMENT_END
		var who := UI.label(str(view._names[side]).to_upper(), UI.TINY, SIDE_COLOUR[side], "bold")
		var hurt := UI.label("HURT", UI.TINY, UI.RED, "bold")
		hurt.visible = false
		for c in ([who, hurt] if side == 0 else [hurt, who]):
			top.add_child(c)
		col.add_child(top)
		_hurt.append(hurt)
		for key in FightMeters.ORDER:
			var row := UI.hbox(8)
			row.alignment = BoxContainer.ALIGNMENT_BEGIN if side == 0 else BoxContainer.ALIGNMENT_END
			var m := Meter.new()
			m.name = "Meter_" + key
			m.custom_minimum_size = BAR_SIZE
			m.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			m.mirror = side == 1
			m.kind = key
			var ic := Icons.icon(ICON[key], ICON_PX, UI.FG)
			for c in ([ic, m] if side == 0 else [m, ic]):
				row.add_child(c)
			row.mouse_filter = Control.MOUSE_FILTER_PASS
			col.add_child(row)
			meters[side][key] = m
		view.add_child(panel)
		if side == 0:
			panel.position = Vector2(EDGE, TOP)
		else:
			panel.anchor_left = 1.0
			panel.anchor_right = 1.0
			panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			panel.offset_left = -EDGE
			panel.offset_right = -EDGE
			panel.offset_top = TOP
		blocks.append(panel)
	edge = EdgeMeter.new()
	edge.name = "RoundEdge"
	edge.custom_minimum_size = Vector2(300, 14)
	edge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER


## Called with the HUD's state after the watched exchanges (LiveRound.state) and the exchanges scored so far this round.
func paint(snap: Dictionary, scored: Array, start: Dictionary) -> void:
	if not snap.is_empty():
		_snap = snap
	_scored = scored
	_start = start


func _process(delta: float) -> void:
	for b in blocks:
		(b as Control).visible = view._bug_box.visible
	_read_left -= delta
	if _read_left > 0.0 or _snap.is_empty():
		return
	_read_left = READ_S
	for side in 2:
		var bars := FightMeters.bars(_source(side))
		for key in FightMeters.ORDER:
			var m: Meter = meters[side][key]
			m.set_bar(bars[key])
			m.tooltip_text = _tip(side, key, bars[key])
		(_hurt[side] as Label).visible = bool((_snap.get("hurt", [false, false]) as Array)[side])
		var taken := int((_snap.get("body", [0, 0]) as Array)[side])
		if _body_seen[side] >= 0 and taken > int(_body_seen[side]):
			(meters[side]["body"] as Meter).flash()
			(meters[side]["stamina"] as Meter).flash()
		_body_seen[side] = taken
		if side == 1:
			_guard_call(bars["guard"])
	var e := FightMeters.edge(_scored)
	(edge as EdgeMeter).want = e
	var won := _scored.filter(func(x): return bool(x.get("won", false))).size()
	edge.tooltip_text = "Who has this round: %s %d, %s %d exchanges" % [view._names[0], won, view._names[1], _scored.size() - won]


## The values FightMeters reads for side 0 (her) / 1 (the opponent).
func _source(side: int) -> Dictionary:
	var who := "a" if side == 0 else "b"
	var src := {"energy": float(_snap.get(who, 100.0)), "body_taken": int((_snap.get("body", [0, 0]) as Array)[side]),
		"guard_known": bool(_known[side]["guard"]), "heart_known": bool(_known[side]["heart"])}
	src["energy_start"] = float(_start.get(who, src["energy"]))
	var live: Node = view.get("body")
	if live != null:
		var places := {}
		for p in BodyMap.PLACES:
			places[p] = BodyMap.value(live.map, who, p)
		src["places"] = places
	var burn: Node = view.get("burn")
	if burn != null:
		var shown: Dictionary = (burn.get("_shown") as Array)[side]
		var parts := {}
		for part in BodyLoad.PARTS:
			parts[part] = float(shown.get("b_" + part, 0.0))
		src["burn"] = parts
		src["drop"] = {"lead": float(shown.get("lead", 0.0)), "rear": float(shown.get("rear", 0.0))}
	var main: Node = view.get("main")
	if main != null:
		src["counts"] = int((main.modal.get("counts", {}) as Dictionary).get(who, 0))
		src["hurts"] = FightMeters.hurt_moments(_bout_exchanges(), side)
		var f: Dictionary = main.career.fighter_by_id(view.fid)
		src["heart_attr"] = float((f.get("personality", {}) as Dictionary).get("heart", 55.0)) if side == 0 \
			else float(_opp().get("heart", 55.0))
	return src


## Every exchange of the bout the player has seen: the closed rounds before this one, then this round's scored ones.
func _bout_exchanges() -> Array:
	var out: Array = []
	var rounds: Array = view.main.modal.get("rounds", [])
	for i in mini(rounds.size(), int(view.round_n) - 1):
		out.append_array((rounds[i] as Dictionary).get("exchanges", []))
	out.append_array(_scored)
	return out


func _opp() -> Dictionary:
	var main: Node = view.get("main")
	if main == null:
		return {}
	var f: Dictionary = main.career.fighter_by_id(view.fid)
	return (f.get("bout", {}) as Dictionary).get("opp", {})


func _tip(side: int, key: String, bar: Dictionary) -> String:
	if not bool(bar["known"]):
		return str(UNKNOWN.get(key, ""))
	var lost := int(round(100.0 * (1.0 - float(bar["keep"]))))
	var line := "%s\n%d of 100" % [WORDS[key], int(round(100.0 * float(bar["fill"])))]
	return line + (", %d gone for the fight" % lost if lost > 0 and key == "stamina" else "")


## Her guard was scouted and it is sinking: the corner tells her (once a round) - the tape room's homework paying off.
func _guard_call(bar: Dictionary) -> void:
	var n := int(view.round_n)
	if not bool(bar["known"]) or float(bar["fill"]) >= GUARD_LOW or _low_said == n or not bool(view.playing):
		return
	if float(view.get("_caption_left")) > 0.0:
		return
	_low_said = n
	view._say("Corner: \"Her hands are coming down - over the top!\"")


## One bar: fill eases to its target, the grey end past `keep` is gone for the fight, unknown = a dashed "?" box.
class Meter extends Control:
	const EASE_S := 0.35
	var kind := ""
	var mirror := false
	var fill := -1.0
	var keep := 1.0
	var known := true
	var _want := 1.0
	var _want_keep := 1.0
	var _flash := 0.0
	var _band := -1
	var _q: Label

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_PASS
		_q = Label.new()
		_q.text = "?"
		_q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_q.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_q.add_theme_font_size_override("font_size", 16)
		_q.add_theme_color_override("font_color", Color("#e9b84a"))   # gold: homework still to do
		_q.add_theme_constant_override("outline_size", 4)
		_q.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		_q.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		_q.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_q.visible = false
		add_child(_q)

	func set_bar(b: Dictionary) -> void:
		known = bool(b["known"])
		_want = float(b["fill"])
		_want_keep = float(b["keep"])
		if fill < 0.0:
			fill = _want
			keep = _want_keep
		var band := _band_of(_want)
		if _band >= 0 and band != _band:
			_flash = maxf(_flash, 0.7)
		_band = band
		if _q != null:
			_q.visible = not known

	func flash() -> void:
		_flash = 1.0

	func _process(delta: float) -> void:
		var k := 1.0 - exp(-delta / EASE_S)
		fill = lerpf(fill, _want, k)
		keep = lerpf(keep, _want_keep, k)
		_flash = maxf(0.0, _flash - delta * 2.0)
		queue_redraw()

	func _band_of(v: float) -> int:
		return 0 if v >= 0.6 else (1 if v >= 0.35 else 2)

	func colour() -> Color:
		var v := maxf(fill, 0.0)
		match kind:
			"stamina":
				return Color("#f2c94c") if v >= 0.3 else Color("#f0a020")
			"guard":
				return Color("#e9e6f2") if v >= 0.5 else Color("#f0a020")
			"heart":
				return Color("#a37bff") if v >= 0.3 else Color("#e0503c")
		return [Color("#6cc27a"), Color("#f0a020"), Color("#e0503c")][_band_of(v)]

	func _seg(a: float, b: float, c: Color) -> void:
		if b <= a:
			return
		var w := size.x
		var x0 := w * (1.0 - b) if mirror else w * a
		draw_rect(Rect2(x0, 0, w * (b - a), size.y), c)

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.10))
		if not known:
			var dash := Color(1, 1, 1, 0.35)
			for x in range(0, int(size.x), 8):
				draw_line(Vector2(x, 0), Vector2(minf(x + 4, size.x), 0), dash)
				draw_line(Vector2(x, size.y), Vector2(minf(x + 4, size.x), size.y), dash)
			return
		var f := clampf(fill, 0.0, 1.0)
		var kp := clampf(maxf(keep, f), 0.0, 1.0)
		var c := colour()
		_seg(f, kp, Color(c.r, c.g, c.b, 0.22))   # spent, can come back at the bell
		_seg(0.0, f, c)
		_seg(kp, 1.0, Color(0.42, 0.42, 0.44, 0.75))   # gone for the fight
		if kp < 0.999:
			var x0 := 0.0 if mirror else size.x * kp
			var x1 := size.x * (1.0 - kp) if mirror else size.x
			for x in range(int(x0), int(x1), 5):
				draw_line(Vector2(x, size.y), Vector2(minf(x + size.y, x1), 0), Color(0.2, 0.2, 0.22, 0.8))
		if _flash > 0.0:
			draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.55 * _flash))


## Who has the round: from the centre toward red's side (left) or blue's (right), ticks at each third.
class EdgeMeter extends Control:
	var want := 0.0
	var value := 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_PASS

	func _process(delta: float) -> void:
		value = lerpf(value, want, 1.0 - exp(-delta / 0.4))
		queue_redraw()

	func _draw() -> void:
		var w := size.x
		var h := size.y
		var mid := w / 2.0
		draw_rect(Rect2(0, 0, mid, h), Color(0.95, 0.4, 0.35, 0.16))   # a tug of war: red's half, blue's half
		draw_rect(Rect2(mid, 0, mid, h), Color(0.5, 0.65, 1.0, 0.16))
		var v := clampf(value, -1.0, 1.0)
		if v > 0.0:
			draw_rect(Rect2(mid - mid * v, 0, mid * v, h), Color(0.95, 0.4, 0.35))
		elif v < 0.0:
			draw_rect(Rect2(mid, 0, mid * -v, h), Color(0.5, 0.65, 1.0))
		for i in range(1, 6):
			var x := w * i / 6.0
			draw_line(Vector2(x, 0.0 if i == 3 else h * 0.55), Vector2(x, h), Color(1, 1, 1, 0.8 if i == 3 else 0.35), 2.0 if i == 3 else 1.0)
