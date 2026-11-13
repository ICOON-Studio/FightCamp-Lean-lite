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

## S391 (operator: "the circles need to be a bit bigger ... not so close to the sides ... maybe a bit transparent"): half as large again,
## further in, and see-through.
const EDGE := 72.0
const TOP := 36.0
const RINGS_PX := 300.0
const RINGS_ALPHA := 0.82
const ICON_PX := 16
const Arc := preload("res://scripts/fight3d/HudArc.gd")
const SIDE_COLOUR := Arc.SIDE_COLOUR
const IVORY := Arc.IVORY
const ICON := {"head": "user", "body": "shirt", "legs": "footprints", "stamina": "zap", "guard": "shield", "heart": "heart"}
const WORDS := {
	"head": "Head: the worst of head, eyes and nose. The grey never comes back this fight (cuts, swelling).",
	"body": "Body: the ribs. Every body shot also greys the end of the stamina bar.",
	"legs": "Legs: tired legs take shorter, slower steps - no cutting the ring off.",
	"stamina": "Stamina: the tank. The minute's rest gives some back; the grey end is gone for the fight.",
	"guard": "Guard: how high the hands stay. It sinks as the shoulders tire.",
	"heart": "Heart: how far from quitting. Standing counts and hurt moments wear it down.",
}
const UNKNOWN := {
	"guard": "Guard: not scouted. Find one of the opponent's habits on tape (the tape room or tape study in camp).",
	"heart": "Heart: not scouted. The file shows it once tape study reaches the weakness.",
}
## Her scouted guard under this and the corner tells her to go over the top (once a round).
const GUARD_LOW := 0.55
const READ_S := 0.25
## S392 (operator: "flash according to the damage done"): a flash is damage / FLASH_FULL, BodyMap's biggest loss; never under LEAST.
const LEAN_PER_PUNCH := 0.02
const LEAN_MOST := 0.125
const EVEN_UNDER := 0.08
const FLASH_FULL := 3.0
const FLASH_LEAST := 0.25   # S394 (blind review: "a 1-point and a 2-point hit get the same flash"): was 0.6, which floored both

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
var _low_said := -1
## S394 punches landed since the last scored exchange, per corner: the round edge leans with them before the verdict.
var _landed := [0, 0]
var _scored_seen := 0
## S395 the bell's rest refills legs at once; the rings hold what the round ended on until the corner takes the screen.
var held := false


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
		panel.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.2), Color(0, 0, 0, 0), 10, 0, 14, 10))
		var col := UI.vbox(5)
		panel.add_child(col)
		var top := UI.hbox(8)
		top.alignment = BoxContainer.ALIGNMENT_BEGIN if side == 0 else BoxContainer.ALIGNMENT_END
		var who := UI.label(str(view._names[side]).to_upper(), UI.SMALL, SIDE_COLOUR[side], "bold")
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
		rings.modulate.a = RINGS_ALPHA
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
	edge.custom_minimum_size = Vector2(380, 46)
	edge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER


## S392 how bright a hit flashes, 0-1. A big punch is full whatever it took.
static func strength(loss: float, big: bool) -> float:
	if loss <= 0.0:
		return 0.0
	return 1.0 if big else clampf(loss / FLASH_FULL, FLASH_LEAST, 1.0)


## S392 a landed punch at the glove's contact (BodyLive): `lost` = {place: points}. The arcs answer now, not at the next read.
func hit(side: int, lost: Dictionary, big: bool) -> void:
	var head := 0.0
	var body := 0.0
	for p in lost:
		if str(p).ends_with("_ribs"):
			body = maxf(body, float(lost[p]))
		else:
			head = maxf(head, float(lost[p]))
	if head > 0.0:
		(meters[side]["head"] as Arc).flash(strength(head, big), true)
	if body > 0.0:
		(meters[side]["body"] as Arc).flash(strength(body, big), true)
		(meters[side]["stamina"] as Arc).flash(strength(body, big) * 0.5)   # S393 at the contact; S394 fainter than the part struck
	_landed[1 - side] += 1
	if big and lost.has("right_ribs"):
		var ring := (blocks[side] as Control).find_child("Rings", true, false) as Rings
		if ring != null:
			ring.liver_hit()
	_read_left = 0.0


## Called with the HUD's state after the watched exchanges (LiveRound.state) and the exchanges scored so far this round.
func paint(snap: Dictionary, scored: Array, start: Dictionary) -> void:
	if not snap.is_empty():
		_snap = snap
	_scored = scored
	_start = start


func _process(delta: float) -> void:
	for b in blocks:
		(b as Control).visible = view._bug_box.visible and bool(view.playing)   # S394 the corner's letterbox cut them in half
	_read_left -= delta
	if _read_left > 0.0 or _snap.is_empty() or held:
		return
	_read_left = READ_S
	_read()


## S395 (blind review: round 2 opened on round 1's lead and tanks, then rolled to the real ones in 1.5 s): a new round starts
## on its own numbers, with no ease from the last one.
func fresh_round() -> void:
	held = false
	_landed = [0, 0]
	_scored_seen = 0
	for side in 2:
		for key in FightMeters.ORDER:
			var m: Arc = meters[side][key]
			m.fill = -1.0
			m.chunk = -1.0
	if not _snap.is_empty():
		_read()
	(edge as EdgeMeter).value = (edge as EdgeMeter).want


func _read() -> void:
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
			var live: Node = view.get("body")
			ring.liver_bad = ring.hurt or (live != null and BodyMap.value(live.map, "a" if side == 0 else "b", "right_ribs") <= BodyMap.HURT)
		if side == 1:
			_guard_call(bars["guard"])
	if _scored.size() != _scored_seen:
		_scored_seen = _scored.size()
		_landed = [0, 0]
	var e := clampf(FightMeters.edge(_scored) + clampf((_landed[0] - _landed[1]) * LEAN_PER_PUNCH, -LEAN_MOST, LEAN_MOST), -1.0, 1.0)
	(edge as EdgeMeter).want = e
	(edge as EdgeMeter).word = "THIS ROUND: EVEN" if absf(e) < EVEN_UNDER else ("YOUR BOXER IS WINNING THIS ROUND" if e > 0.0 else "THE OPPONENT IS WINNING THIS ROUND")   # S419 operator on "LUCY JACKSON AHEAD": "wtf is that"
	var won := _scored.filter(func(x): return bool(x.get("won", false))).size()
	edge.tooltip_text = "Who has this round: your boxer %d, the opponent %d exchanges" % [won, _scored.size() - won]   # S448: roles


## S394 the stamina the ring shows, 0-100, so the corner's table reads the same number; < 0 before the first read.
func stamina(side: int) -> float:
	return float(FightMeters.bars(_source(side))["stamina"]["fill"]) * 100.0 if not _snap.is_empty() else -1.0


## S395 (blind review: legs and guard came back from the corner higher, with nothing shown): {name: [what the ring holds, what
## the next round opens on]} for a tank of `tank`. The bell's rest is already in BodyBurn; the rings are held until the round.
func recovered(side: int, tank: float) -> Dictionary:
	var src := _source(side)
	src["energy"] = tank
	src["energy_start"] = tank
	var burn: Node = view.get("burn")
	if burn != null:
		var to: Dictionary = (burn.get("_to") as Array)[side]
		var parts := {}
		for part in BodyLoad.PARTS:
			parts[part] = float(to.get("b_" + part, 0.0))
		src["burn"] = parts
		src["drop"] = {"lead": float(to.get("lead", 0.0)), "rear": float(to.get("rear", 0.0))}
	var after := FightMeters.bars(src)
	var out := {"legs": [meters[side]["legs"].fill * 100.0, float(after["legs"]["fill"]) * 100.0]}
	if bool(_known[side]["guard"]):
		out["guard"] = [meters[side]["guard"].fill * 100.0, float(after["guard"]["fill"]) * 100.0]
	return out


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


## Two rings, one inside the other, three arcs each (C186): the inner her body, the outer her engine. Each arc fills from
## its start (from its end on the blue corner's mirrored block), its icon beside it; hover an arc for its words and
## numbers; "HURT" sits in the middle.
class Rings extends Control:
	const R_IN := 78.0
	const R_OUT := 109.0
	const WIDTH := 23.0
	const SPAN := 108.0           # degrees of each arc (the rest of its third is the gap)
	const NUM_SIZE := 21          # S369 the value drawn on each arc
	const MID_SIZE := 46          # S395 her stamina in the ring's middle
	const HURT_SIZE := 26
	const INNER := ["head", "body", "legs"]
	const OUTER := ["stamina", "guard", "heart"]
	const ICONS := {"head": "user", "body": "shirt", "legs": "footprints", "stamina": "zap", "guard": "shield", "heart": "heart"}
	var arcs := {}
	var mirror := false
	var hurt := false
	var _tex := {}
	## S392 (operator: "make the liver flash red quickly and keep it showing the duration of the effect"): a big liver shot flashes it
	## in the ring's middle; it holds LIVER_MIN_S, and stays while liver_bad (hurt, or BodyMap's hurt band). Not a panel: S381 stands.
	const LIVER_MIN_S := 3.0
	const LIVER_PX := 92.0
	const LIVER_FLASH_RATE := 3.0
	const LIVER_PIC := preload("res://assets/ui/body/organ_liver.png")
	var liver_flash := 0.0
	var liver_bad := false
	var _liver_left := 0.0
	var _liver_on := false
	var _liver_t := 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_PASS
		for k in ICONS:
			_tex[k] = Icons.texture(str(ICONS[k]), 24)

	func _process(delta: float) -> void:
		for a in arcs.values():
			(a as Arc).tick(delta)
		tick_liver(delta, liver_bad)
		queue_redraw()


	func liver_hit() -> void:
		liver_flash = 1.0
		_liver_left = LIVER_MIN_S
		_liver_on = true


	func liver_lit() -> bool:
		return _liver_on


	func tick_liver(delta: float, bad: bool) -> void:
		liver_flash = maxf(0.0, liver_flash - delta * LIVER_FLASH_RATE)
		_liver_left -= delta
		_liver_t += delta
		if _liver_on and _liver_left <= 0.0 and not bad:
			_liver_on = false

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
		if _liver_on:
			var px := LIVER_PX * (1.0 + 0.18 * liver_flash)
			var tint := Color(1.0, 0.22, 0.16, 1.0).lerp(Color(1.0, 0.75, 0.7, 1.0), liver_flash)
			tint.a = minf(1.0, 0.62 + 0.14 * sin(_liver_t * 5.0) + liver_flash)
			draw_texture_rect(LIVER_PIC, Rect2(c - Vector2(px, px) * 0.5, Vector2(px, px)), false, tint)
		var f := ThemeDB.fallback_font
		var st := arcs.get("stamina") as Arc
		var word := "HURT" if hurt else ("" if _liver_on or st == null else "%d" % roundi(clampf(st.fill, 0.0, 1.0) * 100.0))
		var px := HURT_SIZE if hurt else MID_SIZE
		var at := c + Vector2(-f.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x * 0.5, 48.0 if _liver_on else px * 0.36)
		draw_string_outline(f, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 6, Color(0, 0, 0, 0.9))
		draw_string(f, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color("#e0503c") if hurt else (st.colour() if st != null else Color.WHITE))

	## One arc: its dark track, the spent part (comes back at the bell), the fill, the grey end gone for the fight.
	func _arc(c: Vector2, r: float, mid: float, a: Arc, key: String, outer: bool) -> void:
		var a0 := deg_to_rad(mid - SPAN * 0.5)
		var a1 := deg_to_rad(mid + SPAN * 0.5)
		draw_arc(c, r, a0, a1, 32, Color(1, 1, 1, 0.10), WIDTH, true)
		var icon_r := r + WIDTH * 0.5 + 16.0 if outer else r - WIDTH * 0.5 - 16.0
		var ic: Texture2D = _tex.get(key)
		var at := c + Vector2.from_angle(deg_to_rad(mid)) * icon_r
		if ic != null:
			draw_texture_rect(ic, Rect2(at - Vector2(12, 12), Vector2(24, 24)), false, Color("#f3ece2"))
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
		if a.chunk >= 0.0:
			_part(c, r, a0, a1, a.chunk_span().x, a.chunk_span().y, Color(1.0, 0.95, 0.9, 0.95))   # S392 what this hit took
		if a._flash > 0.0:
			draw_arc(c, r, a0, a1, 32, Color(1.0, 0.32, 0.22, 0.9 * a._flash), WIDTH + 6.0 * a._flash, true)   # S394 white on ivory did not read
		# S369 (operator, on the ring: "also add numbers here?"): her value on the arc, 0-100, so the corner can read who is
		# the more tired without judging arc lengths.
		if not Arc.number_on_arc(key, fl):
			return
		var nf := ThemeDB.fallback_font
		var txt := "%d" % roundi(fl * 100.0)
		var ts := nf.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, NUM_SIZE)
		var tp := c + Vector2.from_angle(deg_to_rad(mid)) * r + Vector2(-ts.x * 0.5, ts.y * 0.32)
		draw_string_outline(nf, tp, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, NUM_SIZE, 4, Color(0, 0, 0, 0.9))
		draw_string(nf, tp, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, NUM_SIZE, Color.WHITE)

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
	const BAR_H := 18.0
	const WORD_PX := 22
	var want := 0.0
	var value := 0.0
	var word := ""
	func _ready() -> void: mouse_filter = Control.MOUSE_FILTER_PASS

	func _process(delta: float) -> void:
		value = lerpf(value, want, 1.0 - exp(-delta / 0.4))
		queue_redraw()

	func _draw() -> void:
		var w := size.x
		var h := BAR_H
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
		if word != "":   # S394 (blind review: "the only lead cue is unlabelled"): the bar says what it means
			var f := ThemeDB.fallback_font
			var at := Vector2((w - f.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, WORD_PX).x) * 0.5, size.y - 2.0)   # S396: "AHEAD" too small
			draw_string_outline(f, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1, WORD_PX, 6, Color(0, 0, 0, 0.85))
			draw_string(f, at, word, HORIZONTAL_ALIGNMENT_LEFT, -1, WORD_PX, Color(0.95, 0.45, 0.4) if v > 0.05 else (Color(0.55, 0.7, 1.0) if v < -0.05 else Color(0.94, 0.91, 0.86)))
