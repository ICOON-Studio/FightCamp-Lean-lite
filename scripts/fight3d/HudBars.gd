extends Node
## S345 FIGHTHUD2 (operator Q-S294-69 "Yes, build it"; Game Godot/research/FIGHTHUD_S344.md, "gotta beat this" - the UFC 6
## fight HUD): six bars a boxer in her top corner - head, body, legs, stamina, guard, heart - icons, no numbers (they live
## in each row's tooltip), and the round edge meter under the round clock in the middle. FightMeters reads the values off
## the ring (BodyLive's map, BodyBurn's eased Burn and guard drop, the live round's energy, the bout's counts and hurt
## moments). What beats theirs: the opponent's guard and heart show "?" until scouting found them (her file), every bar
## eases and pulses on a band change (operator: animated meters), a body shot flashes her body and stamina bars together
## (the grey end of the tank grows), and when her scouted guard sinks the corner says so.
## S346 (operator C186/C187 on the bars: "bad, try 2 circles inside one another divided by 3 parts each?"): the six bars
## are two rings, one inside the other, each cut in three - the inner ring her body (head on top, body, legs), the outer
## her engine (stamina on top, guard, heart); an icon at each arc, "HURT" in the middle, the numbers on hover.
##   attach(view) -> HudBars   edge (the centre meter, FightHud places it)   paint(snap, scored, round start)

const FightMeters := preload("res://scripts/rules/FightMeters.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const UI := preload("res://scripts/ui/TV.gd")

const EDGE := 28.0
const TOP := 24.0
const RINGS_PX := 200.0
const ICON_PX := 16
const SIDE_COLOUR := [Color(0.95, 0.4, 0.35), Color(0.5, 0.65, 1.0)]
const IVORY := Color("#efe8dc")
const ICON := {"head": "user", "body": "shirt", "legs": "footprints", "stamina": "zap", "guard": "shield", "heart": "heart"}
const WORDS := {
	"head": "Head: the worst of head, eyes and nose. The grey never comes back this fight (cuts, swelling).",
	"body": "Body: the ribs. Every body shot also greys the end of the stamina bar.",
	"legs": "Legs: tired legs take shorter, slower steps - she cannot cut the ring off.",
	"stamina": "Stamina: the tank. The minute's rest gives some back; the grey end is gone for the fight.",
	"guard": "Guard: how high the hands stay. It sinks as the shoulders tire.",
	"heart": "Heart: how far she is from quitting. Standing counts and hurt moments wear it down.",
}
const UNKNOWN := {
	"guard": "Guard: not scouted. Find one of the opponent's habits on tape (the tape room or tape study in camp).",
	"heart": "Heart: not scouted. The file shows it once tape study reaches the weakness.",
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
		# S347 (operator: "lighten the ui/hud"): a faint glass panel, no frame.
		panel.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.38), Color(0, 0, 0, 0), 10, 0, 14, 10))
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
		var rings := Rings.new()
		rings.name = "Rings"
		rings.custom_minimum_size = Vector2(RINGS_PX, RINGS_PX)
		rings.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN if side == 0 else Control.SIZE_SHRINK_END
		rings.mirror = side == 1
		col.add_child(rings)
		for key in FightMeters.ORDER:
			var m := Arc.new()
			m.kind = key
			m.side = side
			rings.arcs[key] = m
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
			var m: Arc = meters[side][key]
			m.set_bar(bars[key])
			m.tooltip_text = _tip(side, key, bars[key])
		(_hurt[side] as Label).visible = bool((_snap.get("hurt", [false, false]) as Array)[side])
		var ring := (blocks[side] as Control).find_child("Rings", true, false) as Rings
		if ring != null:
			ring.hurt = (_hurt[side] as Label).visible
		var taken := int((_snap.get("body", [0, 0]) as Array)[side])
		if _body_seen[side] >= 0 and taken > int(_body_seen[side]):
			(meters[side]["body"] as Arc).flash()
			(meters[side]["stamina"] as Arc).flash()
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
	view._say("Corner: \"The hands are coming down - over the top!\"")


## One of the six: fill eases to its target, the end past `keep` is gone for the fight, unknown = a dashed "?" arc.
class Arc extends RefCounted:
	const EASE_S := 0.35
	var kind := ""
	var side := 0
	var fill := -1.0
	var keep := 1.0
	var known := true
	var tooltip_text := ""
	var _want := 1.0
	var _want_keep := 1.0
	var _flash := 0.0
	var _band := -1

	func set_bar(b: Dictionary) -> void:
		known = bool(b["known"])
		_want = float(b["fill"])
		_want_keep = float(b["keep"])
		if fill < 0.0:
			fill = _want
			keep = _want_keep
		var band := band_of(_want)
		if _band >= 0 and band != _band:
			_flash = maxf(_flash, 0.7)
		_band = band

	func flash() -> void:
		_flash = 1.0

	func tick(delta: float) -> void:
		var k := 1.0 - exp(-delta / EASE_S)
		fill = lerpf(fill, _want, k)
		keep = lerpf(keep, _want_keep, k)
		_flash = maxf(0.0, _flash - delta * 2.0)

	static func band_of(v: float) -> int:
		return 0 if v >= 0.6 else (1 if v >= 0.35 else 2)

	func colour() -> Color:
		var v := maxf(fill, 0.0)
		# S347 (operator C193: "it reminds ufc6 too much"): no rainbow of yellow / white / purple / green. Her engine
		# (stamina, guard, heart) in her corner's colour, her body (head, body, legs) ivory while fine - amber, then red,
		# only when it matters, so the eye goes where something happened.
		if kind in ["stamina", "guard", "heart"]:
			return SIDE_COLOUR[side] if v >= 0.3 else Color("#f0a020")
		return [IVORY, Color("#f0a020"), Color("#e0503c")][band_of(v)]


## Two rings, one inside the other, three arcs each (C186): the inner her body, the outer her engine. Each arc fills from
## its start (from its end on the blue corner's mirrored block), its icon beside it; hover an arc for its words and
## numbers; "HURT" sits in the middle.
class Rings extends Control:
	const R_IN := 52.0
	const R_OUT := 73.0
	const WIDTH := 15.0
	const SPAN := 108.0           # degrees of each arc (the rest of its third is the gap)
	const INNER := ["head", "body", "legs"]
	const OUTER := ["stamina", "guard", "heart"]
	const ICONS := {"head": "user", "body": "shirt", "legs": "footprints", "stamina": "zap", "guard": "shield", "heart": "heart"}
	var arcs := {}
	var mirror := false
	var hurt := false
	var _tex := {}

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_PASS
		for k in ICONS:
			_tex[k] = Icons.texture(str(ICONS[k]), 16)

	func _process(delta: float) -> void:
		for a in arcs.values():
			(a as Arc).tick(delta)
		queue_redraw()

	## The middle of slot i in degrees: on top, then lower right, lower left (swapped on the mirrored block).
	func mid_deg(i: int) -> float:
		var mids: Array = [-90.0, 30.0, 150.0] if not mirror else [-90.0, 150.0, 30.0]
		return float(mids[i])

	func _centre() -> Vector2:
		return size * 0.5

	func _draw() -> void:
		var c := _centre()
		for i in 3:
			_arc(c, R_IN, mid_deg(i), arcs.get(INNER[i]) as Arc, str(INNER[i]), false)
			_arc(c, R_OUT, mid_deg(i), arcs.get(OUTER[i]) as Arc, str(OUTER[i]), true)
		if hurt:
			var f := ThemeDB.fallback_font
			var w := f.get_string_size("HURT", HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x
			draw_string(f, c + Vector2(-w * 0.5, 6), "HURT", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("#e0503c"))

	## One arc: its dark track, the spent part (comes back at the bell), the fill, the grey end gone for the fight.
	func _arc(c: Vector2, r: float, mid: float, a: Arc, key: String, outer: bool) -> void:
		var a0 := deg_to_rad(mid - SPAN * 0.5)
		var a1 := deg_to_rad(mid + SPAN * 0.5)
		draw_arc(c, r, a0, a1, 32, Color(1, 1, 1, 0.10), WIDTH, true)
		var icon_r := r + WIDTH * 0.5 + 12.0 if outer else r - WIDTH * 0.5 - 12.0
		var ic: Texture2D = _tex.get(key)
		var at := c + Vector2.from_angle(deg_to_rad(mid)) * icon_r
		if ic != null:
			draw_texture_rect(ic, Rect2(at - Vector2(8, 8), Vector2(16, 16)), false, Color("#f3ece2"))
		if a == null:
			return
		if not a.known:
			for k in range(0, 9, 2):
				draw_arc(c, r, lerpf(a0, a1, float(k) / 9.0), lerpf(a0, a1, float(k + 1) / 9.0), 4, Color(1, 1, 1, 0.38), 2.0, true)
			var f := ThemeDB.fallback_font
			var qs := f.get_string_size("?", HORIZONTAL_ALIGNMENT_LEFT, -1, 30)
			var q := c + Vector2.from_angle(deg_to_rad(mid)) * r + Vector2(-qs.x * 0.5, qs.y * 0.32)
			draw_string_outline(f, q, "?", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, 6, Color(0, 0, 0, 0.9))
			draw_string(f, q, "?", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("#e9b84a"))   # gold: homework still to do
			return
		var fl := clampf(a.fill, 0.0, 1.0)
		var kp := clampf(maxf(a.keep, fl), 0.0, 1.0)
		var col := a.colour()
		_part(c, r, a0, a1, fl, kp, Color(col.r, col.g, col.b, 0.22))   # spent, can come back at the bell
		_part(c, r, a0, a1, 0.0, fl, col)
		_part(c, r, a0, a1, kp, 1.0, Color(0.42, 0.42, 0.44, 0.85))   # gone for the fight
		if a._flash > 0.0:
			draw_arc(c, r, a0, a1, 32, Color(1, 1, 1, 0.55 * a._flash), WIDTH, true)

	## The share [u0, u1] of an arc, filling from its start (from its end on the mirrored block).
	func _part(c: Vector2, r: float, a0: float, a1: float, u0: float, u1: float, col: Color) -> void:
		if u1 - u0 <= 0.002:
			return
		var s0 := lerpf(a0, a1, u0) if not mirror else lerpf(a1, a0, u1)
		var s1 := lerpf(a0, a1, u1) if not mirror else lerpf(a1, a0, u0)
		draw_arc(c, r, s0, s1, maxi(3, int(32.0 * (u1 - u0))), col, WIDTH, true)

	## Hover: the arc (or its icon) under the mouse says its words and numbers.
	func _get_tooltip(at_position: Vector2) -> String:
		var d := at_position - _centre()
		var r := d.length()
		var keys: Array = []
		if r >= R_IN - WIDTH * 0.5 - 22.0 and r <= R_IN + WIDTH * 0.5 + 2.0:
			keys = INNER
		elif r > R_IN + WIDTH * 0.5 + 2.0 and r <= R_OUT + WIDTH * 0.5 + 22.0:
			keys = OUTER
		else:
			return ""
		var ang := rad_to_deg(d.angle())
		var best := 0
		var best_d := 999.0
		for i in 3:
			var dd := absf(wrapf(ang - mid_deg(i), -180.0, 180.0))
			if dd < best_d:
				best_d = dd
				best = i
		var a: Arc = arcs.get(keys[best])
		return a.tooltip_text if a != null else ""


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
