extends PanelContainer
## The fighter's Training tab as the coach's whiteboard (S356, operator Q-S294-84 "Yes, build it", the Miro "Whiteboard
## planner" mockup; the mechanics of S354-S356 underneath). Top: her name, the weeks strip to fight night (S381 G2,
## WeekStrip), the fight date circled in red. Middle: the seven days - a magnet for the morning (click it for every card:
## "Hard intervals"), one for the evening, the fatigue bar (colour only near or over the line); THIS CAMP beside it - weight, the camp's stat, the fatigue
## peak and the injury load, each with where the camp lands - and the week's twist on a sticky note. Bottom: the coach's
## one line (WeekCoach), the evening dials, CONTINUE. The numbers behind a magnet are on its hover. THIS CAMP is WeekCamp.gd.
## WeekPlan does the maths; BoutActs wday / spar / weekreset / diet / learn / combo / twistpick take the clicks.
##   WeekBoard.make(main, career, fighter) -> PanelContainer   WeekBoard.goal_of(career, fighter) -> the camp's goal

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const WeekDay := preload("res://scripts/ui/WeekDay.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const WeekCamp := preload("res://scripts/ui/WeekCamp.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")

const WEEKS_NO_BOUT := 4

static var more_open := false   # S360 the More row opened by hand (camp week 1)

var _lines: Array = []
var _camp: Node = null   # THIS CAMP (WeekCamp): a morning under the cursor ghosts there (S382 G5)


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
	var pl := plan_of(c, f)
	var goal: Dictionary = pl["goal"]
	var days: Array = pl["days"]
	var wk: Dictionary = pl["wk"]
	_lines = pl["lines"]
	var v := UI.vbox(16)
	add_child(v)
	v.add_child(_head(c, f, goal, pl["evs"]))
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
	_camp = WeekCamp.make(main, f, goal, _lines, teaching(f), func(g: Dictionary) -> Array: return plan_of(c, g)["lines"])
	mid.add_child(_camp)


## Her name, the weeks strip to fight night (WeekStrip; this week's pips = the evenings drawn); her opponent circled.
func _head(c: Career, f: Dictionary, goal: Dictionary, evs: Array) -> Control:
	var h := UI.hbox(24)
	var left := UI.vbox(2)
	left.add_child(WB.ink("%s'S CAMP" % str(f["first"]).to_upper(), 42, "marker"))   # her full name heads the page already
	var sub := UI.hbox(12)
	var bout: Dictionary = goal["bout"]
	var camp: Dictionary = f.get("camp", {})
	if not bout.is_empty() and not bool(bout.get("done", false)):
		# S381 G2: the weeks strip to fight night (WeekStrip) replaced "camp week 2 of 4" and the phase cells.
		sub.add_child(WeekStrip.make(f, bout.get("opp", {}), int(bout["day"]), c.day, int(camp.get("start", c.day)),
			str(camp.get("focus", f.get("focus", ""))), bool(camp.get("film", false)), evs.count("sparring")))
		if camp.is_empty():
			sub.add_child(WB.ink("no camp set yet", 24, "hand", WB.INK))
	else:
		sub.add_child(WB.ink("no bout booked: the next %d weeks" % WEEKS_NO_BOUT, 24, "hand", WB.INK))
		var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
		sub.add_child(WB.tape_chip(str(ph["name"]).to_upper()))
	left.add_child(sub)
	h.add_child(left)
	h.add_child(UI.spacer())
	if not bout.is_empty() and not bool(bout.get("done", false)):
		var opp: Dictionary = bout["opp"]
		var parts := str(opp.get("name", "")).split(" ")
		var who := "%s. %s" % [parts[0].left(1), parts[-1]] if parts.size() > 1 else str(opp.get("name", ""))
		# S382 proof stills: the strip's poster ends on the date, so the circle names who and the limit (no second date)
		var date := WB.circled("VS " + who.to_upper(), "%.1f kg limit" % float(f["limit"]))
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
			changed.has(str(i)), items, str(WeekTwist.active(f).get("name", "")), coach[i], _ghost_day))
	return box


## S382 G5: a morning card under the cursor (WeekDay) ghosts on THIS CAMP; [] = off.
func _ghost_day(dow: int, card: Array) -> void:
	if _camp != null:
		_camp.call("ghost_day", dow, card)


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
