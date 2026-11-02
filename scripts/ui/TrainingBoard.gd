extends PanelContainer
## S349 FIGHTERS > Training as his MMA home-training picture (Q-S294-72; his answer on the S348 mockup: "the text has nothing
## to do with the picture, combo and learning like wtf ? everythingis wrong in the boxes"): her own body in the middle, her
## week's eight sessions round her (TrainingWeek), each card's line ending on the part that session builds. A card says
## what she does (the session, its hours), what it builds (the stat's real gain this week, Sim.daily_gain) and why; her
## main session is the focus (click a card to make it main). The pads card holds the new move and the combo; load and
## weight are settings, so they sit in the header, not in cards.
##   TrainingBoard.make(main, career, fighter) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const TW := preload("res://scripts/rules/TrainingWeek.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const SCRIPT_PATH := "res://scripts/ui/TrainingBoard.gd"

const CARD_W := 440.0
const BOARD_H := 640.0
const CAMP_WHY := "In fight camp - the plan is set until fight night"
const DARK := Color("#22262e")
const PIC := 112.0
const PIC_BG := Color("#1b1714")   # the baked pictures' charcoal tile
const PICS := "res://assets/ui/training"

var _fig: Control = null
var _lines: Control = null
var _portrait := {}
var _cards: Array = []    # [{card: Control, point: String, side: -1 left / +1 right, role: String}]


static func make(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var b: PanelContainer = load(SCRIPT_PATH).new()
	b.build(main, c, f)
	return b


func build(main: Node, c: Career, f: Dictionary) -> void:
	theme_type_variation = "Card"
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var fid := str(f["id"])
	name = "TrainingBoard_" + fid
	var v := UI.vbox(10)
	add_child(v)
	var in_camp := not (f["camp"] as Dictionary).is_empty()
	v.add_child(_header(main, c, f, in_camp))
	if in_camp:
		v.add_child(UI.muted("In camp: the camp sets the main session (%s) and cuts the weight."
			% TW.session(TW.session_for(Sim.focus_of(c, f)))["name"], UI.BODY, true))
	v.add_child(_board(main, c, f, in_camp))
	v.add_child(_expected(c, f))


## The name, then the week's settings: load (+ the gauge against her usual), weight, the coach.
func _header(main: Node, c: Career, f: Dictionary, in_camp: bool) -> Control:
	var fid := str(f["id"])
	var h := UI.hbox(18)
	h.add_child(UI.display("%s'S WEEK" % str(f["name"]).to_upper(), 40))
	h.add_child(UI.spacer())
	var load := OptionButton.new()
	load.name = "Load_" + fid
	for i in TrainingLoad.ORDER.size():
		var k: String = TrainingLoad.ORDER[i]
		load.add_item("%s week, %d h (gains x%.2f)" % [TrainingLoad.SETTINGS[k]["label"], int(TrainingLoad.hours(k)), TrainingLoad.gain(k)], i)
	load.select(TrainingLoad.ORDER.find(Injuries.setting(f)))
	load.item_selected.connect(func(i): main.act("trainload", "%s|%s" % [fid, TrainingLoad.ORDER[i]]))
	var injured := Injuries.out(c, f)
	load.disabled = injured
	if injured:
		var w := InjuryRoll.weeks_out(int((f["injury"] as Dictionary)["until_day"]) - c.day)
		load.tooltip_text = "Injured - back in %s" % ("1 week" if w == 1 else "%d weeks" % w)
	else:
		load.tooltip_text = "How hard the week is: harder = faster gains, more injury risk; a jump over the usual load is what hurts"
	var r := Injuries.ratio(f)
	var gauge_col: Color = {"safe": UI.GREEN, "high": UI.AMBER, "spike": UI.RED}[TrainingLoad.band(r)]
	var gauge := UI.label(Injuries.line(c, f) + ": resting" if injured else TrainingLoad.gauge_line(r), UI.SMALL, gauge_col, "bold")
	gauge.name = "LoadGauge_" + fid
	h.add_child(_setting("LOAD", [load, gauge]))
	var focus := Sim.focus_of(c, f)
	if not in_camp and Sim.plan_of(c, f) != TrainingPlan.default_plan(focus, str(TrainingPreview.PARTNER.get(focus, ""))):
		var reset := UI.button("Coach's week", "Btn", main.act.bind("focus", "%s|%s" % [fid, focus]))
		reset.name = "CoachWeek_" + fid
		reset.tooltip_text = "Back to the coach's week for the main session"
		h.add_child(_setting("PLAN", [reset]))
	var diet := OptionButton.new()
	diet.name = "Diet_" + fid
	diet.add_item("Hold weight", 0)
	diet.add_item("Cut toward the limit", 1)
	diet.select(1 if str(f["diet"]) == "cut" or in_camp else 0)
	diet.item_selected.connect(func(i): main.act("diet", "%s|%s" % [fid, "cut" if i == 1 else "hold"]))
	diet.disabled = in_camp
	diet.tooltip_text = CAMP_WHY if in_camp else ""
	var over := float(f["weight"]) - float(f["limit"])
	var wl := UI.label("%.1f kg, limit %.1f" % [f["weight"], f["limit"]], UI.SMALL, UI.AMBER if over > 0.0 else UI.GREEN, "bold")
	h.add_child(_setting("WEIGHT", [diet, wl]))
	var coach_parts: Array = []
	if c.coach.is_empty():
		coach_parts.append(UI.muted("none: training runs at 60%"))
		coach_parts.append(UI.button("Hire one", "Btn", main.act.bind("go", "gym:1")))
	else:
		coach_parts.append(UI.label(str(c.coach["name"]), UI.BODY, UI.FG, "bold"))
		coach_parts.append(UI.muted(str(c.coach["spec"]).to_lower()))
	h.add_child(_setting("COACH", coach_parts))
	return h


func _setting(title: String, parts: Array) -> Control:
	var v := UI.vbox(2)
	v.add_child(UI.caps(title))
	for p in parts:
		v.add_child(p)
	return v


## Her body in the middle, four session cards each side, the lines drawn over both.
func _board(main: Node, c: Career, f: Dictionary, in_camp: bool) -> Control:
	var board := MarginContainer.new()   # the row and the lines both fill it; its height follows the taller column
	board.name = "Board"
	board.custom_minimum_size = Vector2(0, BOARD_H)
	board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var row := UI.hbox(24)
	board.add_child(row)
	var left := UI.vbox(14)
	var right := UI.vbox(14)
	for col in [left, right]:
		col.custom_minimum_size = Vector2(CARD_W, 0)
		col.alignment = BoxContainer.ALIGNMENT_CENTER
	var fig := BodyFigure.new()
	fig.name = "Her"
	fig.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_portrait = BodyFigure.portrait_for(Faces.glb(Faces.stem(f)), "red")
	row.add_child(left)
	row.add_child(fig)
	row.add_child(right)
	fig.clay = 0.0   # S351 her own kit, not the fight holo's clay
	fig.set_portrait(_portrait)
	fig.set_track({"core": 0.0, "left_shoulder": 0.0, "right_shoulder": 0.0, "left_arm": 0.0, "right_arm": 0.0, "legs": 0.0})
	fig.mouse_filter = Control.MOUSE_FILTER_IGNORE   # (a track keeps the fight's hurt rings off her; all fresh = her own colours)
	_fig = fig
	var plan := Sim.plan_of(c, f)
	var main_id := TrainingPlan.main_of(plan)
	var hours: Dictionary = TrainingPlan.hours(plan, TrainingLoad.hours(Injuries.setting(f)))
	var gain := Sim.daily_gain(c, f)
	var southpaw := str(f.get("stance", "orthodox")) == "southpaw"
	# Each session to the side its point is on (the middle ones balance the columns), top to bottom by height.
	var placed := {-1: [], 1: []}
	var centre: Array = []
	for s in TW.SESSIONS:
		var pt := TW.body_side(TW.point(str(s["id"]), str(f.get("learning", ""))), southpaw)
		var fr := _frac(pt)
		var item := {"s": s, "point": pt, "y": fr.y}
		if fr.x < 0.46:
			placed[-1].append(item)
		elif fr.x > 0.54:
			placed[1].append(item)
		else:
			centre.append(item)
	centre.sort_custom(func(a, b): return a["y"] < b["y"])
	for item in centre:
		placed[-1 if (placed[-1] as Array).size() <= (placed[1] as Array).size() else 1].append(item)
	var n := 0
	for side in [-1, 1]:
		var items: Array = placed[side]
		items.sort_custom(func(a, b): return a["y"] < b["y"])
		for item in items:
			n += 1
			var s: Dictionary = item["s"]
			var role := "pads" if s["id"] == "pads" else ("main" if s["id"] == main_id else "")
			var card := _session_card(main, c, f, s, n, role, plan, float(hours[s["id"]]), gain, in_camp)
			(left if side == -1 else right).add_child(card)
			_cards.append({"card": card, "point": item["point"], "side": side, "role": role})
	_lines = Control.new()
	_lines.name = "Lines"
	_lines.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lines.draw.connect(_draw_lines)
	board.add_child(_lines)
	row.sort_children.connect(_lines.queue_redraw)
	board.resized.connect(_lines.queue_redraw)
	return board


## One session as his poster's exercise card (S351): her picture doing it on the left; number and name, the week's amount
## in real units with the - / + blocks that set it, what it builds this week, the coach's why and her drills.
func _session_card(main: Node, c: Career, f: Dictionary, s: Dictionary, n: int, role: String, plan: Dictionary, h: float,
		gain: Dictionary, in_camp: bool) -> Control:
	var fid := str(f["id"])
	var id := str(s["id"])
	var p := PanelContainer.new()
	p.name = "Session_%s_%s" % [id, fid]
	var border: Color = {"main": UI.GOLD, "pads": UI.PURPLE}.get(role, UI.LINE)
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, border, 10, 3 if role == "main" else 2, 10, 8))
	var row := UI.hbox(10)
	p.add_child(row)
	row.add_child(_picture(f, s, int(plan.get(id, 0)) == 0))
	var v := UI.vbox(3)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(v)
	var top := UI.hbox(8)
	top.add_child(_number(n, {"main": UI.GOLD, "pads": UI.PURPLE}.get(role, UI.FG)))
	top.add_child(UI.label(str(s["name"]).to_upper(), UI.BODY + 1, UI.FG, "bold"))
	top.add_child(UI.spacer())
	if role == "main":
		top.add_child(UI.chip("MAIN", "gold"))
	v.add_child(top)
	var amount := UI.hbox(6)
	var amt := TrainingPlan.amount_text(id, h)
	var al := UI.label(amt.to_upper(), UI.BODY, UI.GOLD if amt != "off" else UI.MUTED, "bold")
	al.name = "Amount_%s_%s" % [id, fid]
	amount.add_child(al)
	if str(TrainingPlan.UNIT[id]) != "min" and amt != "off":
		amount.add_child(UI.muted(TW.hours_text(h), UI.TINY))
	amount.add_child(UI.spacer())
	amount.add_child(_stepper(main, fid, id, plan, in_camp))
	v.add_child(amount)
	if role == "pads":
		_pads_rows(main, c, f, v)
	else:
		var stat := str(s["stat"])
		var g := float(gain.get(stat, 0.0)) * 7.0
		var builds := UI.hbox(6)
		builds.add_child(UI.label(str(Data.LABEL[stat]), UI.SMALL, UI.FG, "bold"))
		builds.add_child(UI.mono("%d" % int(floorf(float(f["stats"][stat]))), UI.SMALL, UI.FG))
		builds.add_child(UI.mono(UI.gain_text(g).strip_edges() if g >= 0.005 else "+0", UI.SMALL, UI.GREEN if g >= 0.005 else UI.MUTED))
		builds.add_child(UI.muted("this week", UI.TINY))
		v.add_child(builds)
		v.add_child(UI.muted(str(s["why"]), UI.TINY, true))
	var drills := TW.drills(id, f["cards"])
	if not drills.is_empty():
		var foot := UI.hbox(8)
		for d in drills:
			foot.add_child(Icons.tip(UI.chip("drill: %s" % d, "green"), "One of the three week cards: this session drills it"))
		v.add_child(foot)
	return p


## Her picture doing the session (TRAINCLIPS1's baked card, a dark photo tile); until it is baked, the session's icon on
## the same tile. A session she skips this week is dimmed.
func _picture(f: Dictionary, s: Dictionary, off: bool) -> Control:
	var tile := PanelContainer.new()
	tile.name = "Pic_%s" % s["id"]
	tile.custom_minimum_size = Vector2(PIC, PIC)
	tile.add_theme_stylebox_override("panel", UI.box(PIC_BG, Color(0, 0, 0, 0), 8, 0, 0, 0))
	var path := PICS.path_join("%s_%s.png" % [Faces.stem(f), s["id"]])
	if ResourceLoader.exists(path):
		var t := TextureRect.new()
		t.texture = load(path)
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tile.add_child(t)
	else:
		var ic := Icons.icon(str(s["icon"]), 44, UI.YELLOW, str(s["name"]))
		ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tile.add_child(ic)
	if off:
		tile.modulate = Color(1, 1, 1, 0.35)
	return tile


## - [blocks] +: one block is a sixteenth of her usual week; her main follows the biggest session.
func _stepper(main: Node, fid: String, id: String, plan: Dictionary, in_camp: bool) -> Control:
	var h := UI.hbox(3)
	h.name = "Blocks_%s_%s" % [id, fid]
	var minus := UI.button("-", "Btn", main.act.bind("weekplan", "%s|%s|-1" % [fid, id]),
		in_camp or not TrainingPlan.can_step(plan, id, -1), CAMP_WHY if in_camp else "Less time on this session")
	minus.name = "Less_%s_%s" % [id, fid]
	var plus := UI.button("+", "Btn", main.act.bind("weekplan", "%s|%s|1" % [fid, id]),
		in_camp or not TrainingPlan.can_step(plan, id, 1), CAMP_WHY if in_camp else "More time on this session")
	plus.name = "More_%s_%s" % [id, fid]
	for b in [minus, plus]:
		(b as Button).custom_minimum_size = Vector2(30, 30)
	h.add_child(minus)
	var k := int(plan.get(id, 0))
	for i in TrainingPlan.MAX_BLOCKS:
		var pip := ColorRect.new()
		pip.custom_minimum_size = Vector2(9, 16)
		pip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		pip.color = UI.GOLD if i < k else UI.LINE
		pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(pip)
	h.add_child(plus)
	return h


## The pads: the move she is learning and the combination she is drilling (the same two choices as before).
func _pads_rows(main: Node, c: Career, f: Dictionary, v: VBoxContainer) -> void:
	var fid := str(f["id"])
	var moves: Dictionary = f["moves"]
	var learn := OptionButton.new()
	learn.name = "Learn_" + fid
	for mv in Data.MOVES:
		learn.add_item("%s (%s)" % [mv, MoveMastery.tier(float(moves[mv])).to_lower()])
	learn.select(maxi(0, Data.MOVES.find(str(f.get("learning", "")))))
	learn.item_selected.connect(func(i): main.act("learn", "%s|%s" % [fid, Data.MOVES[i]]))
	learn.tooltip_text = "Pad time on one new move: a weapon in 2-3 weeks"
	var combo := OptionButton.new()
	combo.name = "Combo_" + fid
	var ids: Array = Combos.unlocked(moves)
	var drilling := str(f.get("combo_learning", ""))
	if drilling == "" and not ids.is_empty():
		drilling = Combos.next_to_learn(moves, f.get("combos", {}))
	for id in ids:
		combo.add_item("%s (%s)" % [id, MoveMastery.tier(float((f.get("combos", {}) as Dictionary).get(id, 0.0))).to_lower()])
	combo.select(maxi(0, ids.find(drilling)))
	combo.item_selected.connect(func(i): main.act("combo", "%s|%s" % [fid, ids[i]]))
	combo.disabled = ids.is_empty()
	if ids.is_empty():
		combo.add_item("none yet")
		combo.tooltip_text = "No combos yet - a combo opens when each of its punches reaches 30 on the pads"
	elif drilling != "":
		combo.tooltip_text = "Coach: \"%s\"" % ComboWords.line(drilling, "coach_learning", str(f["first"]), c.day / 7)
	for pair in [["Move", learn], ["Combo", combo]]:
		var r := UI.hbox(8)
		var l := UI.label(pair[0], UI.SMALL, UI.FG, "bold")
		l.custom_minimum_size = Vector2(58, 0)
		r.add_child(l)
		(pair[1] as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL
		r.add_child(pair[1])
		v.add_child(r)


func _number(n: int, col: Color) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(col, Color(0, 0, 0, 0), 18, 0, 0, 0))
	p.custom_minimum_size = Vector2(34, 34)
	var l := UI.label(str(n), UI.BODY, Color.WHITE, "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	p.add_child(l)
	return p


## The dark strip under the board: every stat now and what this week adds.
func _expected(c: Career, f: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(DARK, Color(0, 0, 0, 0), 10, 0, 20, 12))
	var h := UI.hbox(26)
	p.add_child(h)
	h.add_child(UI.label("EXPECTED THIS WEEK", UI.BODY + 3, UI.YELLOW, "display"))
	var gain := Sim.daily_gain(c, f)
	var focus := Sim.focus_of(c, f)
	for key in Data.STATS:
		var one := UI.hbox(5)
		one.add_child(UI.label("%s %d" % [Data.LABEL[key], int(floorf(float(f["stats"][key])))], UI.SMALL,
			UI.YELLOW if key == focus else Color.WHITE, "bold"))
		one.add_child(UI.mono(UI.gain_text(float(gain[key]) * 7.0).strip_edges(), UI.TINY, UI.MINT))
		h.add_child(one)
	return p


## A point on her picture as a fraction of it (portrait anchors + the baked limb strokes).
func _frac(pt: String) -> Vector2:
	var a: Dictionary = _portrait.get("anchors", {}) if not _portrait.is_empty() else {}
	if a.is_empty():
		a = BodyFigure.portrait_for(Faces.glb("mh_boxer_10"), "red").get("anchors", {})
	var track: Dictionary = a.get("track", {})
	var head: Array = a.get("head", [0.5, 0.12, 0.17, 0.086])
	match pt:
		"head":
			return Vector2(float(head[0]), float(head[1]) - float(head[3]) * 0.55)
		"neck":
			return Vector2(float(head[0]), float(head[1]) + float(head[3]) * 1.3)
		"core":
			return _along(track.get("core", {}), 0.5, Vector2(0.5, 0.54))
		"legs":
			return _along(track.get("legs_left", {}), 0.4, Vector2(0.68, 0.76))
	var parts := pt.split("_")   # left_shoulder / right_arm / left_fist
	if parts.size() == 2:
		match parts[1]:
			"shoulder":
				return _along(track.get(parts[0] + "_shoulder", {}), 1.0, Vector2(0.5, 0.3))
			"arm":
				return _along(track.get(parts[0] + "_arm", {}), 0.45, Vector2(0.5, 0.45))
			"fist":
				return _along(track.get(parts[0] + "_arm", {}), 1.0, Vector2(0.5, 0.6))
	return Vector2(0.5, 0.5)


## The point at fraction t along a baked stroke {"pts": [[x, y], ...]}.
func _along(stroke: Dictionary, t: float, fallback: Vector2) -> Vector2:
	var pts: Array = stroke.get("pts", [])
	if pts.is_empty():
		return fallback
	if pts.size() == 1:
		return Vector2(float(pts[0][0]), float(pts[0][1]))
	var x := clampf(t, 0.0, 1.0) * float(pts.size() - 1)
	var i := mini(int(floorf(x)), pts.size() - 2)
	var a := Vector2(float(pts[i][0]), float(pts[i][1]))
	var b := Vector2(float(pts[i + 1][0]), float(pts[i + 1][1]))
	return a.lerp(b, x - float(i))


## The point in the Lines overlay's own pixels (the figure fits her picture centred, as BodyFigure draws it).
func point_px(pt: String) -> Vector2:
	var tex := _portrait.get("tex") as Texture2D
	var fr := _frac(pt)
	var fs := _fig.size
	var ts := Vector2(tex.get_size()) if tex != null else Vector2(90, 150)
	var k := minf(fs.x / ts.x, fs.y / ts.y)
	var rect := Rect2((fs - ts * k) * 0.5, ts * k)
	var local := rect.position + fr * rect.size
	return local + _fig.global_position - _lines.global_position


func _draw_lines() -> void:
	if _fig == null or _fig.size.x <= 0.0:
		return
	for e in _cards:
		var card: Control = e["card"]
		var role: String = e["role"]
		var r := Rect2(card.global_position - _lines.global_position, card.size)
		var from := Vector2(r.end.x if int(e["side"]) == -1 else r.position.x, r.position.y + 27.0)
		var to := point_px(str(e["point"]))
		var col: Color = {"main": UI.GOLD, "pads": UI.PURPLE}.get(role, Color(UI.GOLD, 0.55))
		_lines.draw_line(from, to, col, 3.0 if role == "main" else 2.0, true)
		_lines.draw_circle(from, 4.0, col)
		_lines.draw_circle(to, 9.0, Color.WHITE)
		_lines.draw_circle(to, 6.0, col)
