extends VBoxContainer
## THIS CAMP, the whiteboard's right column (split from WeekBoard.gd S362, which sat 10 lines under the 500 cap): each camp goal
## line where the camp lands (a line that moved since the last draw pulses with its delta), the injury load, and the week's
## twist on a sticky note - hovering an answer previews where the lines would land.
##   WeekCamp.make(main, f, goal, lines, teach, replan) -> VBoxContainer "Goal"
##   replan: Callable(f_copy) -> the goal lines for that fighter state (WeekBoard.plan_of(c, f_copy)["lines"])

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const CAMP_W := 470.0
## The training load ratio (this week's hours / her usual, TrainingLoad): 1.5 doubles the injury risk.
const LOAD_NEAR := 1.3
const LOAD_OVER := 1.5
## S359 (Kalli SQ25 "the change happens on the left while the lines move on the right"): a goal line that moved since the
## last draw pulses for this long with its delta.
const PULSE_S := 2.0

## fid -> {line id: where it landed} at the last draw (the pulse compares against it).
static var _seen := {}

var _f: Dictionary
var _lines: Array = []
var _delta := {}   # line id -> Label (the pulse's delta; FIX IT / WAIT preview on hover)
var _teach := false
var _replan: Callable


static func make(main: Node, f: Dictionary, goal: Dictionary, lines: Array, teach: bool, replan: Callable) -> VBoxContainer:
	var p := new()
	p.name = "Goal"
	p.add_theme_constant_override("separation", 10)
	p.custom_minimum_size = Vector2(CAMP_W, 0)
	p._f = f
	p._lines = lines
	p._teach = teach
	p._replan = replan
	p._build(main, f, goal, lines)
	return p


## THIS CAMP: each goal line where the camp lands, the injury load, the week's twist on a sticky note.
func _build(main: Node, f: Dictionary, goal: Dictionary, lines: Array) -> void:
	add_child(WB.ink("THIS CAMP", 34, "marker"))
	var fid := str(f["id"])
	var before: Dictionary = _seen.get(fid, {})
	var now := {}
	for ln in lines:
		var id := str(ln["id"])
		now[id] = float(ln["end"])
		var hold := PanelContainer.new()
		hold.name = "Line_" + id
		hold.add_theme_stylebox_override("panel", UI.box(Color(UI.GOLD, 0.35), Color(0, 0, 0, 0), 4, 0, 6, 2))
		hold.self_modulate = Color(1, 1, 1, 0)
		var row := UI.hbox(10)
		hold.add_child(row)
		var title := str(ln["label"]).to_upper() if id == "opp" else "WEIGHT" if id == "weight" else ("FATIGUE PEAK" if id == "fatigue" else str(Data.LABEL.get(id, ln["label"])).to_upper())
		row.add_child(WB.ink(title, 22, "marker"))
		var ok := bool(ln["ok"])
		if id == "weight":
			row.add_child(WB.ink("%.1f > %.1f kg" % [float(ln["now"]), float(ln["end"])], 22, "handbold"))
			row.add_child(WB.ink("ON TRACK" if ok else "%.1f OVER" % float(ln["short"]), 18, "marker", UI.GREEN if ok else WB.RED))
		elif id == "fatigue":
			row.add_child(WB.ink("%d" % int(round(float(ln["end"]))), 22, "handbold"))
			row.add_child(WB.ink("UNDER 80" if ok else "OVER 80", 18, "marker", UI.GREEN if ok else WB.RED))
		elif id == "opp":
			row.add_child(WB.ink("%d of %d" % [int(ln["end"]), int(ln["target"])], 22, "handbold"))
			row.add_child(WB.ink("READY" if ok else "%d SHORT" % int(ln["short"]), 18, "marker", UI.GREEN if ok else UI.AMBER))
		else:
			row.add_child(WB.ink("%.1f > %.1f" % [float(ln["now"]), float(ln["end"])], 22, "handbold"))
			row.add_child(WB.ink("ON TARGET" if ok else "%.1f SHORT" % float(ln["short"]), 18, "marker", UI.GREEN if ok else UI.AMBER))
		var d := WB.ink("", 18, "handbold", WB.INK)
		d.name = "Delta_" + id
		row.add_child(d)
		_delta[id] = d
		add_child(hold)
		add_child(_line_under(main, fid, f, id, ln, int(goal["weeks"])))
		if before.has(id) and absf(float(before[id]) - float(ln["end"])) >= 0.05:
			_pulse(hold, d, id, float(before[id]), float(ln["end"]))
	_seen[fid] = now
	var load := Injuries.ratio(f)
	var lr := UI.hbox(10)
	lr.add_child(WB.ink("INJURY RISK", 22, "marker"))
	lr.add_child(WB.ink("load %.1f" % load, 22, "handbold"))
	lr.add_child(WB.ink("OVER %.1f" % LOAD_OVER if load >= LOAD_OVER else ("NEAR %.1f" % LOAD_OVER if load >= LOAD_NEAR else "LOW"),
		18, "marker", WB.RED if load >= LOAD_OVER else (UI.AMBER if load >= LOAD_NEAR else UI.GREEN)))
	add_child(lr)
	add_child(WB.ink("this week's hours against the usual - over 1.5 doubles the injury risk", UI.SMALL, "hand", WB.PENCIL, true))
	var sticky := _twist(main, f)
	if sticky != null:
		add_child(sticky)
		if _teach:
			move_child(sticky, 0)   # S359 first open: the twist is the one thing to read, so it heads the column


## Lower is better for the weight and the fatigue peak, higher for the camp's stat.
static func _better(id: String, was: float, to: float) -> bool:
	return to < was if id == "weight" or id == "fatigue" else to > was


static func _fmt(id: String, v: float) -> String:
	return "%d" % int(round(v)) if id == "fatigue" or id == "opp" else "%.1f" % v


## A goal line that moved: its band flashes twice and the delta shows by fight night, both gone after PULSE_S.
func _pulse(hold: PanelContainer, d: Label, id: String, was: float, to: float) -> void:
	d.text = "%s %s" % ["+" if to > was else "-", _fmt(id, absf(to - was))]
	d.add_theme_color_override("font_color", UI.GREEN if _better(id, was, to) else WB.RED)
	d.tooltip_text = "By fight night %s -> %s" % [_fmt(id, was), _fmt(id, to)]
	d.mouse_filter = Control.MOUSE_FILTER_PASS
	hold.ready.connect(func():
		var tw := hold.create_tween()
		for k in 2:
			tw.tween_property(hold, "self_modulate:a", 1.0, PULSE_S / 8.0)
			tw.tween_property(hold, "self_modulate:a", 0.0, PULSE_S / 8.0)
		tw.tween_interval(PULSE_S / 2.0)
		tw.tween_property(d, "modulate:a", 0.0, 0.3)
		tw.tween_callback(func():
			d.text = ""
			d.modulate.a = 1.0))


## S359 (Kalli SQ25 "hovering FIX IT or WAIT previews the goal lines before the player commits"): each line where the
## camp would land with that answer.
func _preview(a: String) -> void:
	var g := _f.duplicate(true)
	g["twist_pick"] = a
	var lines: Array = _replan.call(g)
	for ln in lines:
		var id := str(ln["id"])
		var d: Label = _delta.get(id)
		if d == null:
			continue
		var was := 0.0
		for o in _lines:
			if str(o["id"]) == id:
				was = float(o["end"])
		var to := float(ln["end"])
		d.modulate.a = 1.0
		var same := absf(to - was) < 0.05
		d.text = "same" if same else "-> %s" % _fmt(id, to)
		d.add_theme_color_override("font_color", WB.PENCIL if same else (UI.GREEN if _better(id, was, to) else WB.RED))


func _preview_off() -> void:
	for d in _delta.values():
		(d as Label).text = ""


func _line_under(main: Node, fid: String, f: Dictionary, id: String, ln: Dictionary, weeks: int) -> Control:
	var h := UI.hbox(8)
	if id == "weight":
		h.add_child(WB.ink("limit %.1f at the weigh-in; diet:" % float(ln["target"]), UI.SMALL, "hand", WB.PENCIL))
		for d in [["hold", "Hold"], ["cut", "Cut 500 kcal"]]:
			var b := UI.button(str(d[1]), "PillOn" if str(f["diet"]) == str(d[0]) else "Pill", main.act.bind("diet", "%s|%s" % [fid, d[0]]))
			b.name = "Diet_" + str(d[0])
			h.add_child(b)
	elif id == "fatigue":
		h.add_child(WB.ink("this week %d; rest days and Light mornings bring it down" % int(round(float(ln["week"]))), UI.SMALL, "hand", WB.PENCIL, true))
	elif id == "opp":
		var who := str(ln["label"]).trim_prefix("vs ")
		h.add_child(WB.ink("%s %s: %d %s morning%s a week. The coach's week ignores the opponent - you watched the tape." % [who,
			str(OppFile.GAME_WORDS.get(str(ln["game"]), "")), int(ln["target"]), str(WeekOpp.WORDS.get(str(ln["session"]), "")),
			"" if int(ln["target"]) == 1 else "s"], UI.SMALL, "hand", WB.PENCIL, true))
	else:
		var builders := PackedStringArray()
		for s in WeekPlan.ORDER:
			if str(WeekPlan.session(str(s))["stat"]) == id:
				builders.append(str(WeekPhase.NAMES.get(str(s), s)))
		h.add_child(WB.ink("goal %.1f in %d weeks; built by %s mornings" % [float(ln["target"]), weeks, " / ".join(builders)],
			UI.SMALL, "hand", WB.PENCIL, true))
	return h


## The week's twist card on a sticky note; a choice shows its two answers (until Monday locks it).
func _twist(main: Node, f: Dictionary) -> Control:
	var t := WeekTwist.card_for(f)
	if t.is_empty():
		return null
	var note := WB.sticky()
	note.name = "Twist"
	var v := UI.vbox(6)
	note.add_child(v)
	if _teach:
		var first := WB.ink("START HERE. COACH: \"This is my week. Change a day only if you disagree.\"", UI.SMALL + 2,
			"handbold", WB.RED, true)
		first.name = "StartHere"
		v.add_child(first)
	v.add_child(WB.ink(("%s" if bool(t.get("ask", false)) else "TWIST: %s") % str(t["name"]).to_upper(), 24, "marker", WB.RED))
	v.add_child(WB.ink(str(t["line"]), UI.SMALL + 2, "hand", WB.INK, true))
	if not t.has("a"):
		return note
	var shown := WeekTwist.answer(f)
	var locked := bool(f.get("twist_locked", false))
	var row := UI.hbox(10)
	for a in ["a", "b"]:
		var opt: Dictionary = t[a]
		var col := UI.vbox(2)
		col.custom_minimum_size = Vector2((CAMP_W - 60) / 2.0, 0)
		# S359 (Kalli SQ25 "'(coach)' reads as 'the coach will do this'"): the default is named COACH'S PICK.
		var pick := WB.ink("COACH'S PICK" if str(f.get("twist_pick", "")) == "" and a == shown else " ", UI.SMALL - 2,
			"caps", WB.PENCIL)
		pick.name = "CoachPick_" + a
		col.add_child(pick)
		var b := UI.button(str(opt["label"]).to_upper(), "PillOn" if a == shown else "Pill", main.act.bind("twistpick", "%s|%s" % [f["id"], a]))
		b.name = "TwistPick_" + a
		b.disabled = locked
		if not locked:
			b.mouse_entered.connect(_preview.bind(a))
			b.mouse_exited.connect(_preview_off)
		col.add_child(b)
		var w := WB.ink(str(opt["line"]), UI.SMALL, "hand", WB.INK if a == shown else WB.PENCIL, true)
		w.custom_minimum_size = Vector2((CAMP_W - 60) / 2.0, 0)
		col.add_child(w)
		row.add_child(col)
	v.add_child(row)
	if bool(t.get("ask", false)):   # S361 her ask (PushBack): her mood is her trust in the corner
		v.add_child(WB.ink("Mood %s - trust: a Flat or Low fighter takes in less of the corner's calls." % Sim.FighterProfile.mood(
			float(f.get("morale", 60.0))), UI.SMALL, "hand", WB.PENCIL, true))
	if locked:
		v.add_child(WB.ink("answered - the week is running", UI.SMALL, "hand", WB.PENCIL))
	else:
		var rule := WB.ink("No answer by Monday = the coach's pick. Hover an answer to see where the camp lands.", UI.SMALL,
			"hand", WB.PENCIL, true)
		rule.name = "TwistRule"
		v.add_child(rule)
	return note
