extends PanelContainer
## The fighter's Training tab as the coach's whiteboard (S356, operator Q-S294-84 "Yes, build it", the Miro "Whiteboard
## planner" mockup; the mechanics of S354-S356 underneath). Top: her name, the camp week and its phase, the fight date
## circled in red. Middle: the seven days - a magnet for the morning (click it for every card: "Hard intervals"), one for the
## evening, the fatigue bar (colour only near or over the line); THIS CAMP beside it - weight, the camp's stat, the fatigue
## peak and the injury load, each with where the camp lands - and the week's twist on a sticky note. Bottom: the coach's
## one line (WeekCoach), the evening dials, CONTINUE. The numbers behind a magnet are on its hover.
## WeekPlan does the maths; BoutActs wday / spar / weekreset / diet / learn / combo / twistpick take the clicks.
##   WeekBoard.make(main, career, fighter) -> PanelContainer   WeekBoard.goal_of(career, fighter) -> the camp's goal

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const WeekDay := preload("res://scripts/ui/WeekDay.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const CAMP_W := 470.0
const WEEKS_NO_BOUT := 4
## The training load ratio (this week's hours / her usual, TrainingLoad): 1.5 doubles the injury risk.
const LOAD_NEAR := 1.3
const LOAD_OVER := 1.5
## S359 (Kalli SQ25 "the change happens on the left while the lines move on the right"): a goal line that moved since the
## last draw pulses for this long with its delta.
const PULSE_S := 2.0

## fid -> {line id: where it landed} at the last draw (the pulse compares against it).
static var _seen := {}
static var more_open := false   # S360 the More row opened by hand (camp week 1)

var _c: Career
var _f: Dictionary
var _lines: Array = []
var _delta := {}   # line id -> Label (the pulse's delta; FIX IT / WAIT preview on hover)


static func make(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var p := new()
	p.name = "WeekBoard"
	p.add_theme_stylebox_override("panel", WB.board_style())
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p._build(main, c, f)
	return p


static func goal_of(c: Career, f: Dictionary) -> Dictionary:
	var stat := Sim.focus_of(c, f)
	var g: Dictionary = f.get("goal", {})
	var key := str(g.get("stat", g.get("key", "")))
	var now := float((f["stats"] as Dictionary).get(stat, 50.0))
	var target := floorf(now) + 2.0
	if key == stat and g.has("target"):
		target = float(g["target"])
	# S356 in camp the goal was fixed the day it started (PeakCamp).
	var cg: Dictionary = (f.get("camp", {}) as Dictionary).get("goal", {})
	if str(cg.get("stat", "")) == stat:
		target = float(cg["target"])
	var bout: Dictionary = f.get("bout", {})
	var weeks := WEEKS_NO_BOUT
	if not bout.is_empty() and not bool(bout.get("done", false)):
		weeks = maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	return {"limit": float(f["limit"]), "stat": stat, "target": target, "weeks": weeks, "bout": bout}


## The week as drawn: the twist applied, every day's numbers, the camp's goal lines.
static func plan_of(c: Career, f: Dictionary) -> Dictionary:
	var goal := goal_of(c, f)
	var tw := WeekTwist.active(f)
	var base := WeekPlan.days_of(f)
	var days := WeekTwist.days(tw, base)
	var evs := WeekTwist.evenings(tw, WeekPlan.evenings_of(f))
	var ctx := Sim.week_ctx(c, f)
	var wk := WeekPlan.week(days, ctx, evs)
	var lines := WeekPlan.goal_lines(goal, days, ctx, int(goal["weeks"]), evs, WeekPlan.ahead(f, c.day, int(goal["weeks"])))
	var bout: Dictionary = goal["bout"]
	if not bout.is_empty() and not bool(bout.get("done", false)):
		var opp := WeekOpp.line(bout["opp"], days, str(f.get("phase", "base")))   # S360 Q-S294-90: the line only the player can read
		if not opp.is_empty():
			lines.append(opp)
	return {"goal": goal, "base": base, "days": days, "evs": evs, "ctx": ctx, "wk": wk, "lines": lines}


## S359 (Kalli SQ25 "the grid stays visible but dimmed ... brightens once the twist is answered"): until she has answered a
## twist once, an open twist question is the only thing lit.
static func teaching(f: Dictionary) -> bool:
	return WeekTwist.card(str(f.get("twist", ""))).has("a") and not bool(f.get("twist_locked", false)) \
		and str(f.get("twist_pick", "")) == "" and not bool(f.get("board_taught", false))


func _build(main: Node, c: Career, f: Dictionary) -> void:
	_c = c
	_f = f
	var pl := plan_of(c, f)
	var goal: Dictionary = pl["goal"]
	var days: Array = pl["days"]
	var wk: Dictionary = pl["wk"]
	_lines = pl["lines"]
	var v := UI.vbox(16)
	add_child(v)
	v.add_child(_head(c, f, goal))
	var mid := UI.hbox(26)
	v.add_child(mid)
	# The coach's line and the dials sit under the days (the mockup), so THIS CAMP's height never pushes CONTINUE down.
	var left := UI.vbox(18)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var grid := _week(main, f, days, pl["base"], pl["evs"], wk)
	left.add_child(grid)
	var foot := _foot(main, c, f, days, wk, _lines, str((pl["ctx"] as Dictionary).get("diet", "hold")))
	left.add_child(foot)
	if teaching(f):
		grid.modulate = Color(1, 1, 1, 0.35)
		foot.modulate = Color(1, 1, 1, 0.35)
	mid.add_child(left)
	mid.add_child(_camp(main, f, goal, _lines))


## Her name, the camp's week and phase; the fight date circled.
func _head(c: Career, f: Dictionary, goal: Dictionary) -> Control:
	var h := UI.hbox(24)
	var left := UI.vbox(2)
	left.add_child(WB.ink("%s'S CAMP" % str(f["first"]).to_upper(), 42, "marker"))   # her full name heads the page already
	var sub := UI.hbox(12)
	var bout: Dictionary = goal["bout"]
	var camp: Dictionary = f.get("camp", {})
	var weeks := int(goal["weeks"])
	var when := "no bout booked: the next %d weeks" % WEEKS_NO_BOUT
	var total := 0
	if not bout.is_empty() and not bool(bout.get("done", false)):
		total = weeks
		if not camp.is_empty():
			total = maxi(weeks, int(ceil((int(bout["day"]) - int(camp.get("start", c.day))) / 7.0)))
			when = "camp week %d of %d" % [clampi(total - weeks + 1, 1, total), total]
		else:
			when = "%d weeks to fight night - no camp set yet" % weeks
	sub.add_child(WB.ink(when, 24, "hand", WB.INK))
	if total > 0:
		sub.add_child(WB.phase_strip(phase_cells(total), total - weeks))
	else:
		var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
		sub.add_child(WB.tape_chip(str(ph["name"]).to_upper()))
	left.add_child(sub)
	h.add_child(left)
	h.add_child(UI.spacer())
	if not bout.is_empty() and not bool(bout.get("done", false)):
		var opp: Dictionary = bout["opp"]
		var parts := str(opp.get("name", "")).split(" ")
		var who := "%s. %s" % [parts[0].left(1), parts[-1]] if parts.size() > 1 else str(opp.get("name", ""))
		var date := WB.circled(Clock.fmt(int(bout["day"])).to_upper(), "vs %s, %.1f kg" % [who, float(f["limit"])])
		date.name = "FightDate"
		h.add_child(date)
	h.add_child(UI.spacer())
	return h


## The camp week the header shows ("camp week 2 of 4"); 0 with no camp under way.
static func camp_week(c: Career, f: Dictionary) -> int:
	var bout: Dictionary = f.get("bout", {})
	var camp: Dictionary = f.get("camp", {})
	if bout.is_empty() or bool(bout.get("done", false)) or camp.is_empty():
		return 0
	var weeks := maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	var total := maxi(weeks, int(ceil((int(bout["day"]) - int(camp.get("start", c.day))) / 7.0)))
	return clampi(total - weeks + 1, 1, total)


## The camp's weeks by phase, counted back from fight night as WeekPhase.phase does (BUILD ... PEAK, TAPER).
static func phase_cells(total: int) -> Array:
	var out: Array = []
	for k in total:
		var to_go := total - k
		out.append("TAPER" if to_go <= 1 else ("PEAK" if to_go == 2 else "BUILD"))
	return out


## The seven days: a magnet for the morning (every card on a click), the evening's, the day's fatigue.
func _week(main: Node, f: Dictionary, days: Array, base: Array, evs: Array, wk: Dictionary) -> Control:
	var box := UI.vbox(8)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
	var changed: Dictionary = WeekPhase.edits(f).get("days", {})
	# S359 one undo route (Kalli SQ25): 'undo' on a changed day, "Coach's week" for all of them.
	var said := "%s  Click a morning's magnet to change the day%s." % [ph["line"],
		"" if changed.is_empty() else " (%d changed: 'undo' on the day, or Coach's week below for all)" % changed.size()]
	var phase_line := WB.ink(said, UI.SMALL + 1, "hand", WB.PENCIL, true)
	phase_line.name = "Phase"
	box.add_child(phase_line)
	var row := UI.hbox(0)
	row.name = "Week"
	box.add_child(row)
	var cards := WeekPhase.cards()
	var items: Array = cards.map(func(d): return [WeekPhase.card(d), d])
	var coach := WeekPlan.coach_of(f)
	for i in 7:
		if i > 0:
			var rule := ColorRect.new()
			rule.color = Color(WB.INK, 0.22)
			rule.custom_minimum_size = Vector2(2, 0)
			row.add_child(rule)
		row.add_child(WeekDay.make(main, str(f["id"]), i, days[i], base[i], evs[i], wk["days"][i], (wk["red"] as Array).has(i),
			changed.has(str(i)), items, str(WeekTwist.active(f).get("name", "")), coach[i]))
	return box


## THIS CAMP: each goal line where the camp lands, the injury load, the week's twist on a sticky note.
func _camp(main: Node, f: Dictionary, goal: Dictionary, lines: Array) -> Control:
	var box := UI.vbox(10)
	box.name = "Goal"
	box.custom_minimum_size = Vector2(CAMP_W, 0)
	box.add_child(WB.ink("THIS CAMP", 34, "marker"))
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
		box.add_child(hold)
		box.add_child(_line_under(main, fid, f, id, ln, int(goal["weeks"])))
		if before.has(id) and absf(float(before[id]) - float(ln["end"])) >= 0.05:
			_pulse(hold, d, id, float(before[id]), float(ln["end"]))
	_seen[fid] = now
	var load := Injuries.ratio(f)
	var lr := UI.hbox(10)
	lr.add_child(WB.ink("INJURY RISK", 22, "marker"))
	lr.add_child(WB.ink("load %.1f" % load, 22, "handbold"))
	lr.add_child(WB.ink("OVER %.1f" % LOAD_OVER if load >= LOAD_OVER else ("NEAR %.1f" % LOAD_OVER if load >= LOAD_NEAR else "LOW"),
		18, "marker", WB.RED if load >= LOAD_OVER else (UI.AMBER if load >= LOAD_NEAR else UI.GREEN)))
	box.add_child(lr)
	box.add_child(WB.ink("this week's hours against her usual - over 1.5 doubles the injury risk", UI.SMALL, "hand", WB.PENCIL, true))
	var sticky := _twist(main, f)
	if sticky != null:
		box.add_child(sticky)
		if teaching(f):
			box.move_child(sticky, 0)   # S359 first open: the twist is the one thing to read, so it heads the column
	return box


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
	var lines: Array = plan_of(_c, g)["lines"]
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
	if teaching(f):
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


## The coach's one line, the evening dials, CONTINUE.
func _foot(main: Node, c: Career, f: Dictionary, days: Array, wk: Dictionary, lines: Array, diet: String) -> Control:
	var fid := str(f["id"])
	var v := UI.vbox(10)
	var says := UI.hbox(10)
	says.add_child(WB.ink("COACH:", 26, "marker"))
	var line := WB.ink("\"%s\"" % WeekCoach.line(days, wk, lines, diet), 24, "hand", WB.INK, true)
	line.name = "CoachLine"
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	says.add_child(line)
	v.add_child(says)
	var row := UI.hbox(10)
	row.add_child(WB.ink("Sparring nights", UI.SMALL + 2, "handbold"))
	for n in 3:
		var b := UI.button("%d" % n, "PillOn" if WeekPlan.evenings_of(f).count("sparring") == n else "Pill", main.act.bind("spar", "%s|%d" % [fid, n]))
		b.name = "Spar_%d" % n
		b.custom_minimum_size = Vector2(40, 34)
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(b)
	# S360 (Q-S294-90, Kalli: "the new move and combo dials go into a collapsed 'More' row until camp week 2"): week 1 of a
	# camp shows the twist, the goal lines and the days; More opens the pad dials.
	if camp_week(c, f) < 2 and not more_open:
		var more := UI.button("More: pads, combo", "BtnQuiet", func():
			more_open = true
			main.render())
		more.name = "More"
		row.add_child(more)
	var reset := UI.button("Coach's week", "BtnQuiet", main.act.bind("weekreset", fid))
	reset.name = "WeekReset"
	reset.tooltip_text = "Undo your changes: back to the coach's week for this phase"
	row.add_child(reset)
	row.add_child(UI.spacer())
	row.add_child(_continue(main))
	v.add_child(row)
	if camp_week(c, f) >= 2 or more_open:   # S361 the dials on a row of their own (in one row they ran the page off 1920)
		var dials := UI.hbox(10)
		_dials(main, f, fid, dials)
		v.add_child(dials)
	return v


## The pad dials: the new move on the pads and the combo being drilled.
func _dials(main: Node, f: Dictionary, fid: String, row: Control) -> void:
	row.add_child(WB.ink("   Pads:", UI.SMALL + 2, "handbold"))
	var moves: Dictionary = f["moves"]
	var learn := OptionButton.new()
	learn.name = "Learn_" + fid
	for mv in Data.MOVES:
		learn.add_item("%s (%s)" % [mv, MoveMastery.tier(float(moves[mv])).to_lower()])
	learn.select(maxi(0, Data.MOVES.find(str(f.get("learning", "")))))
	learn.item_selected.connect(func(i): main.act("learn", "%s|%s" % [fid, Data.MOVES[i]]))
	learn.tooltip_text = "Pad time on one new move: a weapon in 2-3 weeks"
	row.add_child(learn)
	row.add_child(WB.ink("   Combo:", UI.SMALL + 2, "handbold"))
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
	if ids.is_empty():
		combo.add_item("none yet")
		combo.disabled = true
		combo.tooltip_text = "A combo opens when each of its punches reaches 30 on the pads"
	row.add_child(combo)


func _continue(main: Node) -> Button:
	var go := Button.new()
	go.name = "BoardContinue"
	go.text = "CONTINUE"
	go.add_theme_font_override("font", UI.font("marker"))
	go.add_theme_font_size_override("font_size", 30)
	for k in ["normal", "hover", "pressed", "focus"]:
		var s := UI.box(WB.RED if k != "hover" else WB.RED.lightened(0.1), Color("#8e1f1a"), 4, 2, 34, 10)
		s.set_border_width(SIDE_BOTTOM, 6)
		go.add_theme_stylebox_override(k, s)
	go.add_theme_color_override("font_color", Color.WHITE)
	go.add_theme_color_override("font_hover_color", Color.WHITE)
	go.pressed.connect(func(): main.act("go_btn"))
	return go
