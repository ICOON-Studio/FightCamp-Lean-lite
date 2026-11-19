extends "res://scripts/ui/GamePlan.gd"
## S482 PLANFLOW1 stage 1 (his Q-240 "Yes, build it": one Game plan page, the list goes; drawing
## docs/mockups/s481/plan_flowchart_v2.png, map ops/research/DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI.md section 3).
## The plan drawn as a chart: the BELL BOX (what the boxer does at each range when no IF holds = the place lines), one
## DIAMOND per IF (a situation line, "IF the opponent presses") with an arrow to its ANSWER, and a dashed "+ Add an IF"
## whose list is the opponent's file (what film found first). Set up in four clicks: the bell box, + Add an IF, pick the
## answer, Test it. The chart IS fighter.arrows (no second plan system): every pick goes through GamePlan._pick/_write,
## so the bout reads it unchanged. Left: the opponent's file; top: the buttons and the plan's worth; bottom: the checks.
## Not built yet (map stage 1 rows P1-P3, P5 uses lines, P6, P11): presets per style, guesses, uses a round, main bet,
## "Your coach rewrites it", Save / Load - none is drawn until it works (S439: buttons follow what the game allows).
##   PlanChart.chart(main, fighter, on_play: Callable(move_id)) -> the page (named "GamePlan")

const PlanAuto := preload("res://scripts/rules/PlanAuto.gd")   # the plans the chart writes (coach, last bout)
const Shapes := preload("res://scripts/ui/PlanChartShapes.gd")   # the wires and the diamond

const COL_L := 380.0
const COL_R := 320.0
const TextScale := preload("res://scripts/ui/TextScale.gd")
const BELL_W := 450.0   # S518 ONELOOK1: 360 cut "Pivot off t"; S529: 420 left it 140 px at Largest (needs 159)
const BELL_ROW := 34.0
const DIA := Vector2(220, 100)
const ANS := Vector2(320, 92)
const ROW_H := 122.0
const X_DIA := 480.0
const X_ANS := 740.0
const POP_W := 570.0
const POP_MAX := 520.0
const INK := Palette.TEXT
const SOFT := Palette.MUTED

static var adding_if := false   # the "+ Add an IF" list is open


static func chart(m: Node, fighter: Dictionary, play: Callable) -> Control:
	var g := new()
	g.name = "GamePlan"
	g.main = m
	g.f = fighter
	g.on_play = play
	var saved: Array = fighter.get("arrows", [])
	g.arrows = (saved if not saved.is_empty() else PlanAuto.suggestion(fighter, g._game())).duplicate(true)
	g.add_theme_constant_override("separation", 14)
	g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	g._build()
	return g



func _build() -> void:
	UI.clear(self)
	_bouts = {}
	for r in PlanRecord.rates(main.career.results if main != null and main.get("career") != null else [], str(f.get("id", ""))):
		_bouts[str(r["move"])] = r
	var top := UI.hbox(10)
	top.add_child(_buttons())
	add_child(top)
	var worth := UI.hbox(0)   # the worth bar on its own row: its words are long (S482 still: the page ran off the screen)
	worth.add_child(UI.spacer())
	worth.add_child(_meter())
	add_child(worth)
	if plans:
		add_child(_templates())
	var page := UI.hbox(18)
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.add_child(_left())
	page.add_child(_centre())
	page.add_child(_right())
	add_child(page)
	add_child(GamePlanRows.rounds(self))   # the rounds each line lives in and the go-to combination stay under the chart
	add_child(GamePlanRows.go_to(self))
	var checks := _checks()
	if checks.get_child_count() > 1:
		add_child(checks)


## The buttons that work today: a real fight plan (preset), Test it (a sparring night), the move map.
func _buttons() -> Control:
	var h := UI.hbox(8)
	h.add_child(UI.button("Use a preset", "PillOn" if plans else "Btn", func():
		plans = not plans
		_refresh()))
	if not _bout().is_empty():
		var day := int((main.career as Career).day)
		var none_left := PlanTest.left(f, day) == 0
		var tb := UI.button(PlanTest.NONE_LEFT if none_left else PlanTest.button(f, day), "BtnSolid", _test, none_left, PlanTest.NONE_LEFT)
		tb.name = "TestIt"
		h.add_child(tb if tb.disabled else Icons.tip(tb, "20 quick bouts against the opponent with this plan."))
	h.add_child(UI.button("Your coach rewrites it", "Btn", func():   # P6: every found moment answered with a line she fires
		var plan := PlanAuto.coach(f, PlanFile.rows(_bout()["opp"], arrows, f.get("moves", {}), f.get("combos", {})) if not _bout().is_empty() else [], _game(), _limit())
		if plan.is_empty():
			main.toast("Your coach has nothing your boxer can fire yet: put a line on the pads first.")
			return
		_write(plan)
		_refresh()))
	var last := PlanAuto.last_bout(f, main.career.results, _limit())
	h.add_child(UI.button("Start from last bout", "Btn", func():
		_write(last["arrows"])
		_refresh(), not bool(last["ok"]), str(last["why"])))
	h.add_child(UI.button("Open the move map", "Btn", _map))
	return h


## Left: who the plan is rated against, then the opponent's file (tells found on film, each with the plan's answer).
func _left() -> Control:
	var card := PanelContainer.new()
	card.name = "PlanLeft"
	card.custom_minimum_size = Vector2(COL_L, 0)
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 16, 12))
	var v := UI.vbox(10)
	card.add_child(v)
	var b := _bout()
	var own := OppFile.main_game(b["opp"]) if not b.is_empty() else ""
	v.add_child(UI.label("Next opponent: %s" % str(OppFile.GAME_WORDS.get(own, own)) if own != "" else
		"No bout booked: try the plan against each kind of opponent.", UI.BODY, UI.FG, "bold", true))
	v.add_child(UI.caps("RATE AGAINST"))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 6)
	flow.add_theme_constant_override("v_separation", 6)
	for g in OppFile.GAME_WORDS:
		var gid := str(g)
		flow.add_child(UI.button(("Next opponent: " if gid == own else "") + str(OppFile.GAME_WORDS[gid]), "PillOn" if gid == _game() else "Pill", func():
			vs = "" if gid == own else gid
			_refresh()))
	v.add_child(flow)
	if not b.is_empty() and vs == "":
		v.add_child(_file_compact())
	return card


## The opponent's file in a narrow column (PlanFile.rows): each tell, what it is, the plan's answer to it, and the better
## answer one click away. Names stay in headers (S448): the rows say "the opponent".
func _file_compact() -> Control:
	var box := UI.vbox(10)
	box.name = "PlanFile"
	box.add_child(UI.caps("WHAT FILM FOUND"))
	for r in PlanFile.rows(_bout()["opp"], arrows, f.get("moves", {}), f.get("combos", {})):
		var rr: Dictionary = r
		var v := UI.vbox(2)
		v.name = "File_" + str(rr["id"]).replace(":", "_")
		var top := UI.hbox(8)
		var what := UI.caps(str(rr["what"]).to_upper())
		what.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top.add_child(what)
		var fit := str(rr["fit"])
		if not bool(rr["known"]):
			top.add_child(UI.chip("NOT FOUND", ""))
		elif str(rr["sit"]) != "" and str(rr["move"]) == "":
			top.add_child(UI.chip("NO ANSWER", "amber"))
		elif str(rr["sit"]) != "" and fit != "none":
			top.add_child(UI.chip(str(PlanLines.FIT_WORDS[fit]).to_upper(), {"best": "green", "ok": "", "wrong": "red"}[fit]))
		v.add_child(top)
		var when_txt := ""
		if int(rr["round"]) > 0:
			when_txt = " (round %d)" % int(rr["round"])
		elif float(rr["share"]) > 0.0 and str(rr.get("band", "")) == "":
			when_txt = " (%d%% of the exchanges)" % roundi(100.0 * float(rr["share"]))
		v.add_child(UI.label(str(rr["value"]) + when_txt if bool(rr["known"]) else "Not on film yet: a film night finds it.",
			UI.SMALL, UI.FG if bool(rr["known"]) else UI.MUTED, "semi", true))
		if bool(rr["known"]) and str(rr["say"]) != "":
			v.add_child(UI.muted(str(rr["say"]), UI.TINY, true))
		if bool(rr["known"]) and str(rr["sit"]) != "" and str(rr["best"]) != "" and str(rr["best"]) != str(rr["move"]) 				and float(rr["best_edge"]) > float(rr["edge"]) + 0.5:
			if not Shapes.fires(f, str(rr["best"])):   # S482: an answer under Usable never fires - pads first, no button
				v.add_child(UI.label("Best answer: %s - still learning, it needs pad work before it fires." % str(rr["best_name"]), UI.TINY, UI.AMBER, "semi", true))
			else:
				var b := UI.button("Answer it: %s" % str(rr["best_name"]), "BtnQuiet", func():
					_pick(str(rr["place"]), str(rr["sit"]), str(rr["best"]), false))
				b.name = "Answer_" + str(rr["id"]).replace(":", "_")
				v.add_child(b)
		box.add_child(v)
	return box


## The chart: the bell box, a diamond and its answer per IF, the dashed "+ Add an IF", and the open list on top.
func _centre() -> Control:
	var card := PanelContainer.new()
	card.name = "PlanChart"
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 16, 12))
	var v := UI.vbox(10)
	card.add_child(v)
	v.add_child(UI.caps("YOUR PLAN: IF THE OPPONENT DOES THIS, THEN DO THAT"))
	var ifs: Array = []
	for l in PlanLines.lines(arrows):
		if str(l["when"]) != "":
			ifs.append({"when": str(l["when"]), "place": str(l["place"])})
	if adding != "" and not ifs.any(func(x): return x["when"] == adding):
		ifs.append({"when": adding, "place": PlanLines.place_for(adding)})
	var rows := ifs.size() + 1
	var bell := _bell()
	var bell_h := maxf(64.0 + BELL_ROW * PlanLines.PLACES.size(), bell.get_combined_minimum_size().y)
	var h := maxf(rows * ROW_H, bell_h + 20.0)
	var canvas := Control.new()
	canvas.name = "ChartCanvas"
	var wires := Shapes.Wires.new()
	wires.colour = UI.GOLD
	canvas.add_child(wires)
	var bell_y := (h - bell_h) / 2.0
	_put(canvas, bell, Vector2(0, bell_y), Vector2(BELL_W, bell_h))
	var from := Vector2(BELL_W, bell_y + bell_h / 2.0)
	var y0 := (h - rows * ROW_H) / 2.0   # the IF column centred on the bell box
	var pop_at := Vector2.ZERO
	for i in rows:
		var y := y0 + i * ROW_H + (ROW_H - DIA.y) / 2.0
		var last := i == ifs.size()
		var when := "" if last else str(ifs[i]["when"])
		var place := "" if last else str(ifs[i]["place"])
		var d := Shapes.Diamond.new()
		d.name = "AddIf" if last else "If_" + when
		d.dashed = last
		d.fill = UI.PANEL
		d.edge = UI.GOLD
		var words := "+ Add an IF" if last else "IF " + str(FightFlow.WHEN_WORDS.get(when, when))
		var lab := UI.label(words, UI.SMALL, UI.GOLD, "bold", true)
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		d.add_child(lab)
		lab.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		lab.offset_left = 34
		lab.offset_right = -34
		lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var key := place + "|" + when
		d.on_click = func():
			if last:
				adding_if = not adding_if
				open = ""
			else:
				open = "" if open == key else key
				adding_if = false
			_refresh()
		d.tooltip_text = "The opponent's file: what film found comes first." if last else "Click to change the answer."
		_put(canvas, d, Vector2(X_DIA, y), DIA)
		wires.curves.append([from, Vector2(X_DIA, y + DIA.y / 2.0), last])
		if last:
			if adding_if:
				pop_at = Vector2(X_DIA - 60.0, y)
			continue
		var ans := _answer(place, when)
		_put(canvas, ans, Vector2(X_ANS, y0 + i * ROW_H + (ROW_H - ANS.y) / 2.0), ANS)
		wires.arrows.append([Vector2(X_DIA + DIA.x, y + DIA.y / 2.0), Vector2(X_ANS, y + DIA.y / 2.0)])
		if open == key:
			pop_at = Vector2(X_DIA, y + DIA.y + 6.0)   # under its diamond: the IF it answers stays in sight
	if open != "" and open.ends_with("|"):   # a range in the bell box
		var p := open.trim_suffix("|")
		pop_at = Vector2(BELL_W - 40.0, bell_y + 56.0 + BELL_ROW * (PlanLines.PLACES.find(p) + 1))
	var pop: Control = null
	if adding_if:
		pop = _add_list()
	elif open != "":
		var parts := open.split("|")
		pop = _answers(parts[0], parts[1] if parts.size() > 1 else "")
	if pop != null:
		var ph := pop.get_combined_minimum_size().y
		pop_at.y = maxf(pop_at.y, 0.0)   # the chart grows to hold it (S482 still: clamping lifted it over its IF)
		h = maxf(h, pop_at.y + ph)
		_put(canvas, pop, pop_at, Vector2(POP_W, ph))
	canvas.custom_minimum_size = Vector2(X_ANS + ANS.x, h)
	wires.size = canvas.custom_minimum_size
	v.add_child(canvas)
	return card


func _put(canvas: Control, n: Control, at: Vector2, sz: Vector2) -> void:
	canvas.add_child(n)
	n.position = at
	n.custom_minimum_size = sz
	n.size = sz


## The bell box: one row per range, its answer when no IF holds (the place lines). Click a row to pick.
func _bell() -> Control:
	var card := PanelContainer.new()
	card.name = "BellBox"
	card.add_theme_stylebox_override("panel", UI.box(UI.DARK, UI.DARK_LIP, 10, 2, 14, 10))
	var v := UI.vbox(2)
	card.add_child(v)
	var head := UI.label("AT THE BELL: WHEN NO \"IF\" HOLDS", UI.TINY, Palette.HEADER, "bold")
	v.add_child(head)
	v.add_child(UI.label("Most of the fight runs on these.", UI.TINY, SOFT))
	for p in PlanLines.PLACES:
		var place := str(p)
		var row := UI.hbox(8)
		row.name = "Line_%s_" % place
		row.custom_minimum_size = Vector2(0, BELL_ROW - 2.0)
		var where := UI.label(str(PlanLines.PLACE_WORDS[place]), UI.TINY, SOFT)
		where.custom_minimum_size = Vector2(118, 0)
		row.add_child(where)
		var i := PlanLines.find(arrows, place, "")
		var mid := str(arrows[i]["move"]) if i >= 0 else ""
		var b := UI.button(str(SM.move(mid).get("name", mid)) if i >= 0 else "Write a line", "BtnQuiet", func():
			open = "" if open == place + "|" else place + "|"
			adding_if = false
			_refresh())
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.clip_text = true
		TextScale.fit_on_resize(b, 16)   # S529 ONELOOK1: a long move shrinks to 16 px at most, then "..." + hover
		row.add_child(b)
		var st := Shapes.stamp(f, mid)
		if st != null:
			row.add_child(st)
		var spots := PlanLines.blind(arrows, place)   # S493 WHYGRADE1: a line with no IF is thrown whatever happens here
		if not spots.is_empty():
			row.add_child(Icons.icon("info", 16, UI.AMBER, "Walks into it when %s.
With no IF, this line is thrown whatever happens here: add an IF for that." % " or ".join(PackedStringArray(spots.map(func(w): return str(FightFlow.WHEN_WORDS[w]))))))
		v.add_child(row)
		if i >= 0 and _bouts.has(mid):   # S373 FLOWBOUT1: how the range's move has done in real bouts, under its row
			var said := UI.hbox(0)
			_in_bouts(said, mid)
			if said.get_child_count() > 0:
				v.add_child(said)
	return card


## The answer box beside a diamond: the move, how well it is drilled, how it scores against that moment.
func _answer(place: String, when: String) -> Control:
	var card := PanelContainer.new()
	card.name = "Line_%s_%s" % [place, when]
	var is_open := open == place + "|" + when
	card.add_theme_stylebox_override("panel", UI.box(Palette.TILE, UI.LINE, 8, 1, 12, 8))
	if is_open: Halo.ring(card, UI.GOLD, 8.0)   # S427: the chosen thing glows (Halo), never a border
	var v := UI.vbox(4)
	card.add_child(v)
	var i := PlanLines.find(arrows, place, when)
	var top := UI.hbox(8)
	v.add_child(top)
	if i < 0:
		top.add_child(UI.button("Write a line", "Btn", func():
			open = "" if is_open else place + "|" + when
			adding_if = false
			_refresh()))
		v.add_child(UI.muted("No answer: your boxer improvises here.", UI.TINY, true))
		return card
	var mid := str(arrows[i]["move"])
	var name_b := UI.button(str(SM.move(mid).get("name", mid)), "BtnQuiet", func():
		open = "" if is_open else place + "|" + when
		adding_if = false
		_refresh())
	name_b.clip_text = true
	name_b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	top.add_child(name_b)
	var st := Shapes.stamp(f, mid)
	if st != null:
		top.add_child(st)
	var row := UI.hbox(6)
	v.add_child(row)
	_rating(row, GamePlanRows.film_fit(self, _opt(PlanLines.options(place, PlanLines.sit_for(when, _game()), f.get("moves", {}), f.get("combos", {})), mid), when))
	_in_bouts(row, mid)
	GamePlanRows.phase_tag(self, row, i)
	return card


## The answers for one box (or a bell row), rated against that moment; the picked one marked; Clear and Close.
func _answers(place: String, when: String) -> Control:
	var card := PanelContainer.new()
	card.name = "AnswerList"
	card.add_theme_stylebox_override("panel", UI.box(UI.DARK, UI.GOLD, 10, 2, 12, 10))
	var v := UI.vbox(8)
	card.add_child(v)
	var title := ("IF " + str(FightFlow.WHEN_WORDS.get(when, when))) if when != "" else str(PlanLines.PLACE_WORDS.get(place, place))
	v.add_child(UI.label("ANSWER TO \"%s\"" % title.to_upper(), UI.TINY, Palette.HEADER, "bold", true))
	var i := PlanLines.find(arrows, place, when)
	var list := UI.vbox(6)
	for o in PlanLines.options(place, PlanLines.sit_for(when, _game()), f.get("moves", {}), f.get("combos", {})):
		var row := UI.hbox(8)   # the drill stamp beside each answer: LEARNING never fires (FireLevel), whatever it beats
		row.add_child(_option(place, when, o, i >= 0 and str(arrows[i]["move"]) == str(o["id"])))
		var st := Shapes.stamp(f, str(o["id"]))
		if st != null:
			row.add_child(st)
		list.add_child(row)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size = Vector2(POP_W - 24.0, minf(list.get_combined_minimum_size().y, POP_MAX))
	scroll.add_child(list)
	v.add_child(scroll)
	var foot := UI.hbox(8)
	if i >= 0 or (adding == when and when != ""):
		foot.add_child(UI.button("Clear this line", "BtnQuiet", func():
			_write(PlanLines.clear_line(arrows, place, when))
			if adding == when:
				adding = ""
			open = ""
			_refresh()))
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Close", "BtnQuiet", func():
		open = ""
		_refresh()))
	v.add_child(foot)
	return card


## "+ Add an IF": every moment the plan can answer, the opponent's file first (found on film, the opponent's game).
func _add_list() -> Control:
	var card := PanelContainer.new()
	card.name = "AddIfList"
	card.add_theme_stylebox_override("panel", UI.box(Palette.TILE, UI.GOLD, 10, 2, 12, 10))
	var v := UI.vbox(6)
	card.add_child(v)
	v.add_child(UI.caps("+ ADD AN IF: WHAT THE OPPONENT DOES"))
	var have := {}
	for l in PlanLines.lines(arrows):
		have[str(l["when"])] = true
	var found := {}
	var b := _bout()
	if not b.is_empty() and vs == "":
		found[OppFile.main_game(b["opp"])] = "THEIR GAME"
		for r in PlanFile.rows(b["opp"], arrows, f.get("moves", {}), f.get("combos", {})):
			if bool(r["known"]) and str(r["sit"]) != "" and not found.has(str(r["sit"])):   # S483 a mode tell: its band
				found[str(r["sit"])] = "FOUND" + (": " + str(r["band"]).to_upper() if str(r.get("band", "")) != "" else "")
	var order: Array = FightFlow.WHEN_WORDS.keys()
	order.sort_custom(func(a, c): return found.has(a) and not found.has(c))
	for w in order:
		var wid := str(w)
		var row := UI.hbox(8)
		var pick := UI.button("IF " + str(FightFlow.WHEN_WORDS[wid]), "BtnQuiet", func():
			adding = wid
			open = PlanLines.place_for(wid) + "|" + wid
			adding_if = false
			_refresh(), have.has(wid), "Already on the chart.")
		pick.name = "AddIf_" + wid
		pick.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		pick.alignment = HORIZONTAL_ALIGNMENT_LEFT
		row.add_child(pick)
		if have.has(wid):
			row.add_child(UI.chip("ON THE CHART", ""))
		elif found.has(wid):
			row.add_child(UI.chip(str(found[wid]), "green"))
		elif not b.is_empty() and wid.begins_with("she_") == false:
			row.add_child(UI.muted("not on film yet", UI.TINY))
		v.add_child(row)
	v.add_child(UI.button("Close", "BtnQuiet", func():
		adding_if = false
		_refresh()))
	return card


## Right: how to set it up (four clicks a line), and the last test.
func _right() -> Control:
	var card := PanelContainer.new()
	card.name = "PlanRight"
	card.custom_minimum_size = Vector2(COL_R, 0)
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 16, 12))
	var v := UI.vbox(12)
	card.add_child(v)
	v.add_child(Shapes.steps())
	var tested: Dictionary = _bout().get("plan_test", {})
	if not tested.is_empty():
		v.add_child(UI.sep())
		v.add_child(_test_result(tested))
	return card


## The checks under the chart, three at most, each with the button that fixes it.
func _checks() -> Control:
	var box := UI.vbox(6)
	box.name = "PlanChecks"
	box.add_child(UI.caps("CHECKS"))
	var said := 0
	var b := _bout()
	if not b.is_empty() and vs == "":
		for r in PlanFile.rows(b["opp"], arrows, f.get("moves", {}), f.get("combos", {})):
			if said < 3 and bool(r["known"]) and str(r["sit"]) != "" and str(r["move"]) == "":
				var sit := str(r["sit"])
				box.add_child(_check_row("%s: found on film, the plan has no answer." % str(r["value"]), "Add it", func():
					adding = sit
					open = PlanLines.place_for(sit) + "|" + sit
					_refresh()))
				said += 1
	for l in PlanLines.lines(arrows):
		if said >= 3:
			break
		var place := str(l["place"])
		var when := str(l["when"])
		var o := _opt(PlanLines.options(place, PlanLines.sit_for(when, _game()), f.get("moves", {}), f.get("combos", {})), str(l["move"]))
		var nm := str(SM.move(str(l["move"])).get("name", l["move"]))
		if not o.is_empty() and str(o["fit"]) == "wrong":
			box.add_child(_check_row("%s walks into the opponent's game." % nm, "Change it", func():
				open = place + "|" + when
				_refresh()))
			said += 1
		elif not o.is_empty() and float(o["rate"]) < 1.0:
			box.add_child(_check_row("%s: not drilled yet, lands 80%% as well until it is drilled on the pads." % nm, "", Callable()))
			said += 1
	return box


func _check_row(text: String, fix: String, act: Callable) -> Control:
	var row := UI.hbox(10)
	row.add_child(UI.dot(UI.AMBER))
	row.add_child(UI.label(text, UI.SMALL, UI.FG, "body", true))
	if fix != "":
		row.add_child(UI.button(fix, "Btn", act))
	return row


func _pick(place: String, when: String, id: String, locked: bool) -> void:
	if not locked:
		open = ""
	super(place, when, id, locked)
