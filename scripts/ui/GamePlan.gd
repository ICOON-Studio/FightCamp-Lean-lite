extends VBoxContainer
## S360 PLAYBOOK > Game plan (operator Q-S294-91: "build it make it interactive for player, with meaningful options and not
## chores and visually and progressively rewarding"; Game Godot/research/PLAYBOOK_CLARITY_S359.md). The coach's game plan
## written as lines, the way a corner writes it on a card: "At long range -> One-two", "When she presses -> Step back".
## - Meaningful: every answer is rated against the opponent's game the way the bout scores it (PlanLines / PlanFight: Beats
##   it / Works / Walks into it, and its edge over improvising); "Rate against" tries the plan on another kind of opponent.
## - Not a chore: a pick saves at once (no Save button); hovering an answer plays it on her body; Real fight plans fill
##   the lines in one click.
## - Rewarding: the plan's edge fills a bar that moves with every pick; the coach's empty lines wait as locks ("coach 60+
##   teaches line 7"); each Test it shows the wins against the last test.
## The lines ARE fighter.arrows (PlanBoard), so the fight reads them unchanged; the map stays behind Open the map.
##   GamePlan.make(main, fighter, on_play: Callable(move_id)) -> GamePlan

const StyleName := preload("res://scripts/rules/StyleName.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanTest := preload("res://scripts/state/PlanTest.gd")
const PlanPanel := preload("res://scripts/ui/PlanPanel.gd")
const FlowView := preload("res://scripts/ui/FlowView.gd")
const StrikeBrowser := preload("res://scripts/ui/StrikeBrowser.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const GamePlanRows := preload("res://scripts/ui/GamePlanRows.gd")
const FirstWeekStrip := preload("res://scripts/ui/FirstWeekStrip.gd")
const MoveWords := preload("res://scripts/rules/MoveWords.gd")
const Halo := preload("res://scripts/ui/Halo.gd")

const PLACE_W := 250.0
const OPT := Vector2(440, 76)   # S416: wide enough for what the choice does
const BAR_W := 300.0
## The edge bar's scale (power points, PlanFight.EDGE summed over the lines) and its bands.
const EDGE_LO := -20.0
const EDGE_HI := 50.0
const BANDS := [[15.0, "Strong plan", UI.GREEN], [3.0, "Sound plan", UI.GOLD], [-3.0, "Even: no better than improvising", UI.MUTED],
	[-999.0, "Walks into the opponent's game", UI.RED]]

static var open := ""         # "place|when" of the line whose answers are showing
static var vs := ""           # the game the lines are rated against ("" = the booked opponent's)
static var adding := ""       # a situation line added, not answered yet
static var plans := false     # the Real fight plans list is open
static var last_edge := 0.0   # the bar animates from the last plan's edge

var main: Node
var f: Dictionary
var on_play: Callable
var arrows: Array
var _fill: ColorRect
var _bouts := {}   # S373 FLOWBOUT1: move id -> its PlanRecord.rates row over the fighter's real bouts
var _fill_to := 0.0
var _band: Label
var _pulse := false


static func make(m: Node, fighter: Dictionary, play: Callable) -> Control:
	var g := new()
	g.name = "GamePlan"
	g.main = m
	g.f = fighter
	g.on_play = play
	var saved: Array = fighter.get("arrows", [])
	g.arrows = (saved if not saved.is_empty() else PlanFight.starter()).duplicate(true)
	g.add_theme_constant_override("separation", 14)
	g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	g._build()
	return g


func _ready() -> void:
	_animate()


## The edge bar runs from the last plan's edge to this one's; a new band flashes.
func _animate() -> void:
	if _fill == null or not is_inside_tree():
		return
	var t := create_tween()
	t.tween_property(_fill, "size:x", _fill_to, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if _pulse:
		_band.modulate = Color(1.7, 1.7, 1.7)
		create_tween().tween_property(_band, "modulate", Color.WHITE, 0.6)


func _bout() -> Dictionary:
	var b: Dictionary = f.get("bout", {})
	return b if not b.is_empty() and not bool(b.get("done", false)) else {}


func _game() -> String:
	if vs != "":
		return vs
	var b := _bout()
	return OppFile.main_game(b["opp"]) if not b.is_empty() else "press"


func _limit() -> int:
	return StyleName.limit(f, PlanBoard.arrow_limit(float((main.career as Career).coach.get("rating", 0.0))))   # S459 + the style's line


func _build() -> void:
	UI.clear(self)
	_bouts = {}
	for r in PlanRecord.rates(main.career.results if main != null and main.get("career") != null else [], str(f.get("id", ""))):
		_bouts[str(r["move"])] = r
	add_child(_head())
	add_child(_meter())
	if not _bout().is_empty() and vs == "":
		add_child(_file())
	add_child(GamePlanRows.rounds(self))   # S397: the rounds and go-to rows moved to GamePlanRows (500-line rule)
	add_child(GamePlanRows.go_to(self))
	add_child(UI.caps("WHERE THE FIGHT GOES"))
	for p in PlanLines.PLACES:
		add_child(_line(str(p), ""))
	add_child(UI.caps("ANSWERS TO A SITUATION"))
	var whens := {}
	for l in PlanLines.lines(arrows):
		if str(l["when"]) != "":
			whens[str(l["when"])] = str(l["place"])
			add_child(_line(str(l["place"]), str(l["when"])))
	if adding != "" and not whens.has(adding):
		add_child(_line(PlanLines.place_for(adding), adding))
	add_child(_add_pills(whens))
	add_child(UI.sep())
	add_child(_actions())
	if plans:
		add_child(_templates())
	var tested: Dictionary = _bout().get("plan_test", {})
	if not tested.is_empty():
		add_child(_test_result(tested))


## Who the plan is for, and the game it is rated against (the booked opponent's, or a "what if").
func _head() -> Control:
	var v := UI.vbox(6)
	var b := _bout()
	var own := OppFile.main_game(b["opp"]) if not b.is_empty() else ""
	if not b.is_empty():
		v.add_child(UI.label("Next opponent: %s" % str(OppFile.GAME_WORDS.get(own, own)), UI.BODY, UI.FG, "bold", true))   # S448: names in the header only
	else:
		v.add_child(UI.label("No bout booked: try the plan against each kind of opponent.", UI.BODY, UI.FG, "bold", true))
	var row := UI.hbox(6)
	row.add_child(UI.caps("RATE AGAINST"))
	for g in OppFile.GAME_WORDS:
		var gid := str(g)
		var words := str(OppFile.GAME_WORDS[gid])
		if gid == own:
			words = "Next opponent: %s" % words
		row.add_child(UI.button(words, "PillOn" if gid == _game() else "Pill", func():
			vs = "" if gid == own else gid
			_refresh()))
	v.add_child(row)
	return v


## S375 SCOUTPLAN1 the plan against the opponent's file: every tell the tape has opened, the line of the plan that fires
## on it in the ring and how it scores (PlanFile), with the better answer one click away as a "When ..." line.
func _file() -> Control:
	var box := UI.vbox(6)
	box.name = "PlanFile"
	var opp: Dictionary = _bout()["opp"]
	box.add_child(UI.caps("WHAT THE TAPE FOUND ON %s - AND YOUR ANSWER" % str(opp.get("first", "")).to_upper()))
	for r in PlanFile.rows(opp, arrows, f.get("moves", {}), f.get("combos", {})):
		var rr: Dictionary = r
		var row := UI.hbox(10)
		row.name = "File_" + str(rr["id"]).replace(":", "_")
		var tag := UI.caps(str(rr["what"]))
		tag.custom_minimum_size = Vector2(110, 0)
		row.add_child(tag)
		var words := UI.vbox(0)
		words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var when_txt := ""
		if int(rr["round"]) > 0:
			when_txt = "  (round %d)" % int(rr["round"])
		elif float(rr["share"]) > 0.0:
			when_txt = "  (%d%% of the exchanges)" % roundi(100.0 * float(rr["share"]))
		words.add_child(UI.label(str(rr["value"]) + when_txt, UI.SMALL, UI.FG if bool(rr["known"]) else UI.MUTED, "semi", true))
		words.add_child(UI.muted(str(rr["say"]), UI.TINY, true))
		row.add_child(words)
		var fit := str(rr["fit"])
		if bool(rr["known"]) and str(rr["sit"]) != "":
			if str(rr["move"]) == "":
				row.add_child(UI.chip("No line", "amber"))
			elif fit != "none":
				row.add_child(UI.chip(str(PlanLines.FIT_WORDS[fit]), {"best": "green", "ok": "", "wrong": "red"}[fit]))
			var better := str(rr["best"]) != "" and str(rr["best"]) != str(rr["move"]) and float(rr["best_edge"]) > float(rr["edge"]) + 0.5
			if better:
				var b := UI.button("Answer: %s" % str(rr["best_name"]), "Btn", func():
					_pick(str(rr["place"]), str(rr["sit"]), str(rr["best"]), false))
				b.name = "Answer_" + str(rr["id"]).replace(":", "_")
				row.add_child(b)
		elif not bool(rr["known"]):
			row.add_child(Icons.icon("lock", 14, UI.MUTED, "Tape study in camp opens it: the tape room or a camp with film."))
		box.add_child(row)
	return box


## The lines the coach holds (filled, empty, locked behind a better coach) and the plan's edge bar.
func _meter() -> Control:
	var h := UI.hbox(18)
	h.name = "PlanMeter"
	var limit := _limit()
	var lines := UI.hbox(5)
	# S398 rank 5: with no saved plan this shows the coach's starter, which the fight does not use until a line is changed.
	var unsaved := (f.get("arrows", []) as Array).is_empty()
	var shown := "A SUGGESTION, NOT SAVED: %d LINES. CHANGE ANY LINE TO USE THEM" if unsaved else "ANSWERS WRITTEN: %d"
	lines.add_child(UI.caps((shown + ", THE COACH CAN HOLD %d") % [arrows.size(), limit]))
	for n in range(1, PlanBoard.TOP_COACH + 1):
		if n <= limit:
			lines.add_child(UI.dot(UI.GREEN if n <= arrows.size() else UI.LINE))
		else:
			lines.add_child(Icons.icon("lock", 14, UI.MUTED, "A coach rated %d+ teaches line %d." % [PlanLines.skill_for(n), n]))
	h.add_child(lines)
	var s := PlanLines.strength(arrows, _game(), f.get("moves", {}), f.get("combos", {}))
	var edge := float(s["edge"])
	var band: Array = BANDS[-1]
	var old_band: Array = BANDS[-1]
	for x in BANDS:
		if edge >= float(x[0]):
			band = x
			break
	for x in BANDS:
		if last_edge >= float(x[0]):
			old_band = x
			break
	var col := UI.vbox(4)
	var top := UI.hbox(8)
	top.add_child(UI.caps("THE PLAN SO FAR"))
	_band = UI.label(str(band[1]), UI.SMALL, band[2], "bold")
	_band.name = "EdgeBand"
	_band.mouse_filter = Control.MOUSE_FILTER_PASS
	_band.tooltip_text = "%+.0f over improvising" % edge   # S397 blind round 3: "Plan edge +5" was a raw number
	top.add_child(_band)
	col.add_child(top)
	var track := ColorRect.new()
	track.color = UI.ROWLINE
	track.custom_minimum_size = Vector2(BAR_W, 12)
	_fill = ColorRect.new()
	_fill.color = band[2]
	_fill.size = Vector2(_bar_w(last_edge), 12)
	_fill_to = _bar_w(edge)
	track.add_child(_fill)
	col.add_child(Icons.tip(track, "The plan's power points over improvising, against this game, summed over its lines - how the bout scores it."))
	col.add_child(UI.muted(PlanLines.tally_words(s), UI.TINY))
	h.add_child(col)
	_pulse = band[1] != old_band[1]
	last_edge = edge
	return h


func _bar_w(edge: float) -> float:
	return BAR_W * clampf((edge - EDGE_LO) / (EDGE_HI - EDGE_LO), 0.02, 1.0)


## One line: the place (or situation), its answer rated, and - open - every answer she has there.
func _line(place: String, when: String) -> Control:
	var key := place + "|" + when
	var i := PlanLines.find(arrows, place, when)
	var sit := PlanLines.sit_for(when, _game())
	var mastery: Dictionary = f.get("moves", {})
	var opts := PlanLines.options(place, sit, mastery, f.get("combos", {}))
	var is_open := open == key
	var card := PanelContainer.new()
	card.name = "Line_" + key.replace("|", "_")
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 10, 1, 14, 8))
	if is_open: Halo.ring(card, UI.GOLD, 10.0)
	var v := UI.vbox(8)
	card.add_child(v)
	var top := UI.hbox(10)
	v.add_child(top)
	var title := ("When " + str(FightFlow.WHEN_WORDS.get(when, when))) if when != "" else str(PlanLines.PLACE_WORDS.get(place, place))
	var tl := UI.label(title, UI.BODY, UI.FG, "bold")
	tl.custom_minimum_size = Vector2(PLACE_W, 0)
	top.add_child(tl)
	top.add_child(UI.label("->", UI.BODY, UI.MUTED, "bold"))
	if i >= 0:
		var mid := str(arrows[i]["move"])
		var o := _opt(opts, mid)
		top.add_child(UI.label(str(SM.move(mid).get("name", mid)), UI.BODY, UI.GOLD, "bold"))
		_rating(top, o)
		_in_bouts(top, mid); GamePlanRows.phase_tag(self, top, i)   # S460 INTEGRATE1 #3: the rounds this line lives in
		v.add_child(UI.muted(str(MoveWords.WORDS.get(mid, "")), UI.SMALL))   # S416 "the player just guesses what to pick"
	else:
		top.add_child(UI.muted("no line - improvises here", UI.SMALL))
	top.add_child(UI.spacer())
	top.add_child(UI.button("Close" if is_open else ("Change" if i >= 0 else "Write a line"), "BtnQuiet" if is_open else "Btn", func():
		open = "" if is_open else key
		_refresh()))
	if is_open:
		var flow := HFlowContainer.new()
		flow.add_theme_constant_override("h_separation", 8)
		flow.add_theme_constant_override("v_separation", 8)
		v.add_child(flow)
		for o in opts:
			flow.add_child(_option(place, when, o, i >= 0 and str(arrows[i]["move"]) == str(o["id"])))
		if i >= 0 or adding == when and when != "":
			v.add_child(UI.button("Clear this line", "BtnQuiet", func():
				_write(PlanLines.clear_line(arrows, place, when))
				if adding == when:
					adding = ""
				open = ""
				_refresh()))
	return card


## S373 FLOWBOUT1: the line's move across the fighter's real bouts (PlanRecord: exchanges it was thrown in, won), and
## the Playbook's word on it - "works" / "fails" / "even", or "too early" under PlanRecord.MIN_USED throws.
func _in_bouts(row: Control, mid: String) -> void:
	var r: Dictionary = _bouts.get(mid, {})
	if r.is_empty() or int(r["used"]) <= 0:
		return
	var word := PlanRecord.verdict(r)
	var chip := UI.chip("In bouts: %d of %d won, %s" % [int(r["won"]), int(r["used"]), word],
		{"works": "green", "fails": "red", "even": "", "too early": ""}.get(word, ""))
	chip.name = "InBouts_" + mid.replace("@", "_").replace(" ", "_")
	row.add_child(chip)


## The answer's fit chip and its edge, said the way the bout counts it.
func _rating(row: Control, o: Dictionary) -> void:
	if o.is_empty():
		return
	if str(o["why"]) != "":
		row.add_child(UI.chip(str(o["why"]), "amber"))
		return
	var fit := str(o["fit"])
	if fit != "none":   # S397 blind round 3: the edge number lives on hover, the chip says it in words
		row.add_child(UI.chip(str(PlanLines.FIT_WORDS[fit]), {"best": "green", "ok": "", "wrong": "red"}[fit]))
		row.get_child(-1).tooltip_text = "%+.0f over improvising" % float(o["edge"])
	if float(o["rate"]) < 1.0:
		row.add_child(Icons.icon("info", 16, UI.AMBER, "Untrained: lands 80% as well until it is drilled on the pads."))


func _option(place: String, when: String, o: Dictionary, picked: bool) -> Control:
	var id := str(o["id"])
	var locked := str(o["why"]) != ""
	var fit := str(o["fit"])
	var does := str(MoveWords.WORDS.get(id, ""))
	var small := ("%s
%s" % [str(o["why"]), does]) if locked else "%s then at %s
%s" % [
		str(PlanLines.FIT_WORDS[fit]) + ":" if fit != "none" else "Goes", str(SM.card(str(o["to"])).get("name", "")).to_lower(), does]
	var big_col: Color = Color("#b8a88f") if locked else ({"best": Color("#6fd39a"), "wrong": Color("#ff6b5e")}.get(fit, Color("#efe6d8")) as Color)   # S429 chalk on the dark wood
	var b := UI.button2(str(o["name"]), small, "ChoiceOn" if picked else "Choice", func(): _pick(place, when, id, locked),
		OPT, big_col, Color("#b8a88f"), false, UI.SMALL, UI.TINY)
	if not locked and fit != "none":
		b.tooltip_text = "%+.0f over improvising" % float(o["edge"])
	b.name = "Opt_" + id.replace(" ", "_").replace("@", "_at_")
	if locked:
		b.modulate = Color(1, 1, 1, 0.55)
	b.mouse_entered.connect(func(): on_play.call(id))
	return b


func _pick(place: String, when: String, id: String, locked: bool) -> void:
	on_play.call(id)
	if locked:
		main.toast("%s: %s." % [SM.move(id).get("name", id), SM.grey_reason(SM.move(id), f.get("moves", {}))])
		return
	if PlanLines.find(arrows, place, when) < 0 and arrows.size() >= _limit():
		var n := _limit() + 1
		main.toast("The plan is full: this coach teaches %d lines. Clear one%s." % [_limit(),
			", or a coach rated %d+ teaches line %d" % [PlanLines.skill_for(n), n] if n <= PlanBoard.TOP_COACH else ""])
		return
	_write(PlanLines.set_line(arrows, place, when, id))
	if adding == when:
		adding = ""
	_refresh()


## A pick saves at once when the plan is legal: she fights to it from the next bout.
func _write(next: Array) -> void:
	arrows = next
	if PlanBoard.validate(arrows, SM.MOVES, _limit(), FightFlow.WHEN_WORDS)["ok"]:
		var first := (f.get("arrows", []) as Array).is_empty()
		f["arrows"] = arrows.duplicate(true)
		if first and main != null and (main.get("career") as Career).guide != "":
			FirstWeekStrip.refresh(main)


func _add_pills(have: Dictionary) -> Control:
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 6)
	flow.add_theme_constant_override("v_separation", 6)
	for w in FightFlow.WHEN_WORDS:
		var wid := str(w)
		if have.has(wid) or wid == adding:
			continue
		flow.add_child(UI.button("+ When " + str(FightFlow.WHEN_WORDS[wid]), "Pill", func():
			adding = wid
			open = PlanLines.place_for(wid) + "|" + wid
			_refresh()))
	return flow


func _actions() -> Control:
	var h := UI.hbox(8)
	h.add_child(UI.button("Real fight plans", "PillOn" if plans else "Btn", func():
		plans = not plans
		_refresh()))
	h.add_child(UI.button("See the flow", "Btn", _flow))
	h.add_child(UI.button("Open the map", "Btn", _map))
	h.add_child(UI.spacer())
	h.add_child(UI.muted("Saved: runs from the next bout", UI.TINY))
	if not _bout().is_empty():
		var day := int((main.career as Career).day)   # S382 G3: a test is a spar night (PlanTest.button); none = greyed
		var none_left := PlanTest.left(f, day) == 0
		var tb := UI.button(PlanTest.NONE_LEFT if none_left else PlanTest.button(f, day), "BtnSolid", _test, none_left, PlanTest.NONE_LEFT)
		h.add_child(tb if tb.disabled else Icons.tip(tb, "20 quick bouts against the opponent with this plan."))
	return h


## The real fight plans (PlanTemplates): the ones made for the opponent's game first; Load fills the lines.
func _templates() -> Control:
	var box := UI.vbox(8)
	box.name = "RealPlans"
	var mine: Array = PlanTemplates.for_game(_game())
	var rows: Array = PlanTemplates.BOXING.duplicate()
	rows.sort_custom(func(a, b): return mine.has(a["id"]) and not mine.has(b["id"]))
	for t in rows:
		var tt: Dictionary = t
		var is_mine: bool = mine.has(t["id"])
		var row := UI.hbox(8)
		row.add_child(Icons.icon("target" if is_mine else "play", 16, UI.GOLD if is_mine else UI.LINE, "Made for this game." if is_mine else ""))
		var words := UI.vbox(0)
		words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		words.add_child(UI.label(str(t["name"]), UI.SMALL, UI.GOLD if is_mine else UI.FG, "semi", true))
		words.add_child(UI.muted("%s  (%s)" % [t["idea"], t["from"]], UI.TINY, true))
		row.add_child(words)
		row.add_child(UI.button("Load", "Btn", func():
			_write(PlanTemplates.load(tt, _limit(), arrows, SM.MOVES))
			plans = false
			_refresh()))
		box.add_child(row)
	return box


func _test() -> void:
	var v := PlanBoard.validate(arrows, SM.MOVES, _limit(), FightFlow.WHEN_WORDS)
	if not v["ok"]:
		main.toast(str(v["problems"][0]))
		return
	var b := _bout()
	var prev: Dictionary = (b.get("plan_test", {}) as Dictionary).duplicate()
	var r := PlanTest.run(main.career, f, arrows)
	if not bool(r["ok"]):
		main.toast(str(r["why"]))
		return
	b["plan_test_prev"] = prev
	_refresh()


## The last test, and how it moved against the one before.
func _test_result(r: Dictionary) -> Control:
	var box := UI.vbox(4)
	box.add_child(PlanPanel.test_block(r, str(_bout()["opp"].get("first", ""))))
	var prev: Dictionary = _bout().get("plan_test_prev", {})
	if not prev.is_empty():
		var d := (int(r["lo"]) + int(r["hi"])) - (int(prev["lo"]) + int(prev["hi"]))
		var said := "Same as the last test (%d-%d)." % [prev["lo"], prev["hi"]] if d == 0 else \
			"%s the last test (%d-%d)." % ["Up on" if d > 0 else "Down on", prev["lo"], prev["hi"]]
		box.add_child(UI.label(said, UI.SMALL, UI.GREEN if d > 0 else (UI.RED if d < 0 else UI.MUTED), "bold"))
	return box


func _flow() -> void:
	var v := FlowView.new()
	v.setup(FightFlow.build(arrows, SM.MOVES, "long"), {"title": "THE FLOW: %s" % str(f["name"]).to_upper(),
		"sub": "%d lines, read top to bottom" % arrows.size(), "place_name": func(id: String) -> String: return str(SM.card(id).get("name", id)),
		"move_name": func(id: String) -> String: return str(SM.move(id).get("name", id)),
		"try": func(): main.act("go", "playbook:2")})
	main.add_child(v)


## The move map behind the lines, full screen (StrikeBrowser's plan board; its Back re-draws the page).
func _map() -> void:
	var sb: Control = StrikeBrowser.new()
	sb.start_plan = true
	sb.for_fighter(main, f)
	main.add_child(sb)


func _refresh() -> void:
	_build()
	_animate()


func _opt(opts: Array, id: String) -> Dictionary:
	for o in opts:
		if str(o["id"]) == id:
			return o
	return {}
