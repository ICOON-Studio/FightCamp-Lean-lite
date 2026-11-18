extends VBoxContainer
## S515 MATPLANUI1 (ops/research/MATPLAN_MAP_S433.md 4.1-4.3, section 5; build task M8, first cut): the no-gi athlete's
## plan lines under her A-game on the Playbook page. What the match does with them is BjjBeat.walk (MATWALK1):
##   LINES      one row a line (Line_<at>): ESCAPE or FINISH, where, the move (a click = the next usable move from there),
##              the timing (a click = the next timing), the chance in 100 against the next opponent (vs the field when no
##              open is entered), the price chips (MatPrice: points, miss, Tank, read, time), how well she does it and its
##              level. Lines past her hand (3 at white, 4 at blue, 5 from purple) say NOT BROUGHT. Drop takes a line out.
##   ADD        the bad positions with no line and a usable escape: one click adds the best one (Add_<at>).
##   SCOREBOARD LEVEL / AHEAD / BEHIND, each Push / Steady / Save (Board_<row>_<call>): her pace from the score.
##   Coach's draft (CoachDraft) puts MatLines.draft back. A plan with no lines gets the coach's draft the first time it shows.
##   MatPlanPanel.make(main, f, day, width) -> VBoxContainer

const UI := preload("res://scripts/ui/UI.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")
const MatPrice := preload("res://scripts/rules/MatPrice.gd")
const Info := preload("res://scripts/ui/MatTreeInfo.gd")

const ROWS := ["level", "ahead", "behind"]
const ROW_WORDS := {"level": "LEVEL", "ahead": "AHEAD", "behind": "BEHIND"}
const CALL_WORDS := {"push": "Push", "steady": "Steady", "save": "Save"}
const CALL_TIPS := {"push": "Tries about 1.3 times as often, takes the marginal shot, never holds a lead.",
	"steady": "The athlete's own pace.", "save": "Tries less; holds a lead from 2:00 left (off a pin the referee may count 20 s)."}
const GRADE_COL := {"Good": "green", "OK": "", "Poor": "red"}

var main: Node
var f: Dictionary = {}
var day := 0
var width := 1800.0
var _body: VBoxContainer


static func make(m: Node, fd: Dictionary, today: int, w: float = 1800.0) -> VBoxContainer:
	var p = load("res://scripts/ui/MatPlanPanel.gd").new()
	p.name = "MatPlanPanel"
	p.main = m
	p.f = fd
	p.day = today
	p.width = w
	p._build()
	return p


func _build() -> void:
	add_theme_constant_override("separation", 8)
	custom_minimum_size = Vector2(width, 0)
	var plan := _plan()
	if not plan.has("lines"):
		_coach()
	_body = UI.vbox(8)
	add_child(_body)
	refresh()


func _plan() -> Dictionary:
	if not f.has("bjj_plan"):
		f["bjj_plan"] = {}
	return f["bjj_plan"]


func _rules() -> Dictionary:
	return Info.rules(f)


## The coach's draft over every bad position (worst first), the route's finish, and Steady / Save / Push.
func _coach() -> void:
	var d := MatLines.draft(f, MatLines.ESCAPE_ORDER, _rules(), Info.next_opp(f, day))
	var plan := _plan()
	# The coach writes only what the hand brings, keeping one place for the route's finish; ADD AN ESCAPE has the rest.
	var hand := MatLines.hand_size(str(f.get("belt", "white")))
	var fins: Array = (d["lines"] as Array).filter(func(l): return MatLines._is_finish(BjjTree.edge(str(l["edge"]))))
	var escs: Array = (d["lines"] as Array).filter(func(l): return not MatLines._is_finish(BjjTree.edge(str(l["edge"]))))
	plan["lines"] = MatLines.brought(f, {"lines": escs.slice(0, hand - mini(1, fins.size())) + fins.slice(0, 1)}, _rules())
	plan["board"] = d["board"]
	plan["drafted"] = true


func refresh() -> void:
	for c in _body.get_children():
		_body.remove_child(c)
		c.queue_free()
	var plan := _plan()
	var rl := _rules()
	var opp := Info.next_opp(f, day)
	var hand := MatLines.hand_size(str(f.get("belt", "white")))
	var head := UI.hbox(12)
	head.add_child(UI.caps("THE PLAN ON THE MAT - ESCAPES, FINISHES, THE SCOREBOARD"))
	head.add_child(UI.spacer())
	var draft := UI.button("Coach's draft", "Btn", _on_coach)
	draft.name = "CoachDraft"
	head.add_child(draft)
	_body.add_child(head)
	var brought := MatLines.brought(f, plan, rl)
	var vs := "vs %s (%s)" % [str(opp.get("name", "")), str(opp.get("style", ""))] if not opp.is_empty() else "vs the field (no open entered)"
	_body.add_child(UI.muted("%s brings %d lines at %s belt - %d written. Chances %s. %s" % [str(f["first"]), hand,
		str(f.get("belt", "white")), (plan.get("lines", []) as Array).size(), vs,
		"The coach's draft." if bool(plan.get("drafted", false)) else "Your plan."], UI.SMALL, true))
	var ids: Array = brought.map(func(l): return str(l["at"]))
	for line in brought:
		_body.add_child(_row(line, opp, rl, true))
	for line in plan.get("lines", []):
		if not ids.has(str(line.get("at", ""))):
			_body.add_child(_row(line, opp, rl, false))
	for p in MatLines.validate(f, plan, rl):
		_body.add_child(UI.label(str(p), UI.SMALL, UI.RED, "semi", true))
	_body.add_child(_add_row(rl))
	_body.add_child(_board())


func _row(line: Dictionary, opp: Dictionary, rl: Dictionary, on: bool) -> Control:
	var at := str(line.get("at", ""))
	var e := BjjTree.edge(str(line.get("edge", "")))
	var row := UI.hbox(10)
	row.name = "Line_" + at
	var fin := MatLines._is_finish(e)
	row.add_child(UI.chip("FINISH" if fin else "ESCAPE", "gold" if fin else "amber"))
	var where := UI.label(MatLines._place(at), UI.BODY, UI.FG if on else UI.MUTED, "bold")
	where.custom_minimum_size = Vector2(200, 0)
	row.add_child(where)
	var mv := UI.button(BjjTree.move_name(str(e.get("move", ""))) if not e.is_empty() else "?", "Btn", _cycle_move.bind(at))
	mv.name = "Move_" + at
	mv.custom_minimum_size = Vector2(230, 0)
	mv.tooltip_text = "Click: the next usable move from here."
	row.add_child(mv)
	var t := str(line.get("timing", ""))
	var tb := UI.button(str(MatLines.TIMING_WORDS.get(t, t)), "Btn", _cycle_timing.bind(at))
	tb.name = "Timing_" + at
	tb.custom_minimum_size = Vector2(130, 0)
	tb.tooltip_text = {"at_once": "Tried on the first beat of acting there.", "frame_first": "Two beats of frames first (+chance), about 22 s under the pin.",
		"sit_tight": "No try: frame and wait.", "set_up": "Two beats winning the hands first (+chance); the bottom gets 22 s to escape."}.get(t, "")
	row.add_child(tb)
	var pr := MatPrice.price(f, opp, line, rl)
	if not pr.is_empty():
		var big := UI.label("%d in 100" % roundi(float(pr["chance_timed"]) * 100.0) if t != "sit_tight" else "no try", UI.BODY, UI.GOLD if on else UI.MUTED, "bold")
		big.custom_minimum_size = Vector2(100, 0)
		row.add_child(big)
		if not on:
			row.add_child(UI.chip("NOT BROUGHT", "red"))
		var chips: Array = pr["chips"]
		for i in range(1, chips.size()):
			if (i == 1 and int(pr["points"]) == 0) or (i == 4 and opp.is_empty()):
				continue   # no points on an escape; the read needs a named opponent
			row.add_child(UI.chip(str(chips[i]), ""))
		row.add_child(UI.chip("does it: %s" % str(pr["grade"]), str(GRADE_COL.get(str(pr["grade"]), ""))))
		row.add_child(UI.chip("%s %d" % [str(pr["level_word"]), roundi(float(pr["level"]))], ""))
	row.add_child(UI.spacer())
	var drop := UI.button("Drop", "Btn", _drop.bind(at))
	drop.name = "Drop_" + at
	row.add_child(drop)
	return row


## The bad positions with no line where she has a usable escape: one click adds the best.
func _add_row(rl: Dictionary) -> Control:
	var row := UI.hbox(8)
	row.name = "AddLines"
	row.add_child(UI.caps("ADD AN ESCAPE"))
	var have: Array = (_plan().get("lines", []) as Array).map(func(l): return str(l.get("at", "")))
	var any := false
	for at in MatLines.ESCAPE_ORDER:
		if have.has(at) or MatLines._best(f, at, false, rl, {}).is_empty():
			continue
		var b := UI.button("+ " + MatLines._place(at), "Btn", _add.bind(at))
		b.name = "Add_" + at
		row.add_child(b)
		any = true
	if not any:
		row.add_child(UI.muted("every bad position with a usable escape already has a line", UI.SMALL))
	return row


func _board() -> Control:
	var v := UI.vbox(4)
	v.name = "Scoreboard"
	v.add_child(UI.caps("THE SCOREBOARD - THE PACE FROM THE SCORE"))
	var board: Dictionary = _plan().get("board", {"level": "steady", "ahead": "save", "behind": "push"})
	for r in ROWS:
		var h := UI.hbox(6)
		var w := UI.label(str(ROW_WORDS[r]), UI.BODY, UI.FG, "bold")
		w.custom_minimum_size = Vector2(110, 0)
		h.add_child(w)
		for call in ["push", "steady", "save"]:
			var b := UI.button(str(CALL_WORDS[call]), "TabOn" if str(board.get(r, "")) == call else "Tab", _set_board.bind(r, call))
			b.name = "Board_%s_%s" % [r, call]
			b.tooltip_text = str(CALL_TIPS[call])
			h.add_child(b)
		v.add_child(h)
	return v


# --- changes (each one marks the plan as yours and redraws) ------------------------------------------------------------

func _changed() -> void:
	_plan()["drafted"] = false
	refresh()


func _on_coach() -> void:
	_coach()
	refresh()


func _line_at(at: String) -> Dictionary:
	for l in _plan().get("lines", []):
		if str(l.get("at", "")) == at:
			return l
	return {}


func _usable_from(at: String, finish: bool) -> Array:
	var out: Array = []
	var rl := _rules()
	for e in BjjTree.edges_from(at):
		var mv := str(e["move"])
		if MatLines._is_finish(e) == finish and BjjTree.legal(mv, rl) and BjjTree.usable(BjjTree.mastery(f, mv)):
			out.append(str(e["id"]))
	return out


func _cycle_move(at: String) -> void:
	var l := _line_at(at)
	if l.is_empty():
		return
	var ids := _usable_from(at, MatLines._is_finish(BjjTree.edge(str(l["edge"]))))
	if ids.size() < 2:
		return
	l["edge"] = ids[(ids.find(str(l["edge"])) + 1) % ids.size()]
	_changed()


func _cycle_timing(at: String) -> void:
	var l := _line_at(at)
	if l.is_empty():
		return
	var ts: Array = MatLines.FINISH_TIMINGS if MatLines._is_finish(BjjTree.edge(str(l["edge"]))) else MatLines.ESCAPE_TIMINGS
	l["timing"] = ts[(ts.find(str(l.get("timing", ""))) + 1) % ts.size()]
	_changed()


func _drop(at: String) -> void:
	var plan := _plan()
	plan["lines"] = (plan.get("lines", []) as Array).filter(func(l): return str(l.get("at", "")) != at)
	_changed()


func _add(at: String) -> void:
	var b := MatLines._best(f, at, false, _rules(), Info.next_opp(f, day))
	if b.is_empty():
		return
	var t := "frame_first" if BjjTree.p_bad(float(b[2])) >= MatLines.FRAME_FIRST_AT else "at_once"
	(_plan()["lines"] as Array).append({"at": at, "edge": str(b[0]["id"]), "timing": t})
	_changed()


func _set_board(r: String, call: String) -> void:
	var plan := _plan()
	var board: Dictionary = plan.get("board", {"level": "steady", "ahead": "save", "behind": "push"})
	board[r] = call
	plan["board"] = board
	_changed()
