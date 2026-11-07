extends PanelContainer
## The fighter's Training tab (S356 the coach's whiteboard; S382 DRILLCARD1 rebuilt as ONE strip of the week -
## TRAINING_SCREEN_S381.md sections 3-4 and the approved mockup). Top: the weeks strip to fight night (WeekStrip; "THIS
## WEEK" without a bout), Light / Standard / Hard (the pad nights: PadWeek.nights_for) and the fight-night gauges (GaugeRow,
## built by THIS CAMP - WeekCamp - and shown up here). Then the tray (DrillTray: LEARN, or THE PLAN vs <opponent> with a
## bout booked - PlanCards, S382 PLANTRAY1 - the drill cards, + Build a
## combination), GOAL (the focus stat now -> the end of this week, NightBar's gold tick) and INTENSITY (the week's blocks,
## PadWeek.intensity / TrainingPlan.DEFAULT_TOTAL), and the seven days: an AM card and a PM card each (WeekDay). Below the
## strip: the coach's line, the sparring nights, the coach's week, CONTINUE, and THIS CAMP (goal lines, diet, the twist).
## Nothing dims and nothing opens by itself (the S359 teaching dim, the More row and the pick lists are gone, section 8).
## Clicks: a tray card then a PADS night (or drag it there) = BoutActs drill; a split night's badge = padsplit; right-click
## = undrill; "+ drill it" = drillit; Light / Standard / Hard = nights; a morning opens its picker, a picture = wday.
##   WeekBoard.make(main, career, fighter) -> PanelContainer   goal_of(career, fighter)   plan_of(career, fighter)
##   WeekBoard.picking (static "fid|dow": the morning whose picker is open)

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const WeekDay := preload("res://scripts/ui/WeekDay.gd")
const DrillTray := preload("res://scripts/ui/DrillTray.gd")
const NightBar := preload("res://scripts/ui/NightBar.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const PlanCards := preload("res://scripts/rules/PlanCards.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekCamp := preload("res://scripts/ui/WeekCamp.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")

const WEEKS_NO_BOUT := 4
const STEP_WORDS := ["Light", "Standard", "Hard"]

static var picking := ""
## fid -> the GOAL bar's end-of-week number last drawn (it tweens on from there).
static var _seen_goal := {}

var _lines: Array = []
var _camp: Node = null   # THIS CAMP (WeekCamp): a morning under the cursor ghosts there (S382 G5)


static func make(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var p := new()
	p.name = "WeekBoard"
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 14, 1, 18, 16))
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
	WeekPhase.ensure(f, c.day)   # S385: a Monday board is drawn before the sim's Monday sync
	var goal := goal_of(c, f)
	var tw := WeekTwist.active(f)
	var base := WeekPlan.days_of(f)
	var days := WeekTwist.days(tw, base)
	var evs := PadWeek.evenings(f)   # S382 EVENINGS1: the GOAL / LEGS lines run the strip's nights
	var ctx := Sim.week_ctx(c, f)
	var wk := WeekPlan.week(days, ctx, evs)
	var lines := WeekPlan.goal_lines(goal, days, ctx, int(goal["weeks"]), evs, PadWeek.ahead(f, c.day, int(goal["weeks"])))
	var bout: Dictionary = goal["bout"]
	if not bout.is_empty() and not bool(bout.get("done", false)):
		var opp := WeekOpp.line(bout["opp"], days, str(f.get("phase", "base")))   # S360 Q-S294-90: the line only the player can read
		if not opp.is_empty():
			lines.append(opp)
	return {"goal": goal, "base": base, "days": days, "evs": evs, "ctx": ctx, "wk": wk, "lines": lines}


## S359 an open twist she has never answered: THIS CAMP's sticky says START HERE (S382: nothing dims any more).
static func teaching(f: Dictionary) -> bool:
	return WeekTwist.card(str(f.get("twist", ""))).has("a") and not bool(f.get("twist_locked", false)) \
		and str(f.get("twist_pick", "")) == "" and not bool(f.get("board_taught", false))


## The camp week ("camp week 2 of 4" in the old header); 0 with no camp under way.
static func camp_week(c: Career, f: Dictionary) -> int:
	var bout: Dictionary = f.get("bout", {})
	var camp: Dictionary = f.get("camp", {})
	if bout.is_empty() or bool(bout.get("done", false)) or camp.is_empty():
		return 0
	var weeks := maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	var total := maxi(weeks, int(ceil((int(bout["day"]) - int(camp.get("start", c.day))) / 7.0)))
	return clampi(total - weeks + 1, 1, total)


func _build(main: Node, c: Career, f: Dictionary) -> void:
	var pl := plan_of(c, f)
	var goal: Dictionary = pl["goal"]
	_lines = pl["lines"]
	_camp = WeekCamp.make(main, f, goal, _lines, teaching(f), func(g: Dictionary) -> Array: return plan_of(c, g)["lines"])
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(_head(main, c, f, goal, pl["evs"]))
	var inp := DrillWeek.inputs(c, f)
	var nights: Dictionary = inp["nights"]
	var week: Dictionary = inp["week"]
	var projs := PadWeek.project(f, nights, week, float(inp["skill"]), PadWeek.STATION_TIER, 8, inp["mults"], inp["carded"])
	# S382 PLANTRAY1: a booked bout turns the tray into THE PLAN (PlanCards), its cards dressed against fight night
	var plan := PlanCards.active(f)
	var cards := PlanCards.tray(f, week) if plan else PadEdit.tray(f, week)
	for card in cards:
		if not projs.has(card):
			projs[card] = PadEdit.idle(f, str(card))
	for card in projs:
		projs[card]["eta"] = PadEdit.eta(f, str(card), projs[card], week, nights.get("spar", []))
		projs[card]["pads"] = nights.get("pads", [])
	if plan:   # judged on the camp's real weeks to the bout (PlanCards.fight_paths), not this week repeated
		var fd := int((f["bout"] as Dictionary)["day"])
		PlanCards.dress(f, projs, c.day - posmod(c.day, 7), fd, PlanCards.fight_paths(f, inp, c.day, fd))
	var fid := str(f["id"])
	var pick := func(card: String) -> void:   # click-click: the card waits for a night (a second click puts it back)
		DrillTray.picked = "" if DrillTray.picked_for(fid) == card else "%s|%s" % [fid, card]
		main.render()
	var drill_it := func(card: String) -> void: main.act("drillit", "%s|%s" % [fid, card])
	v.add_child(DrillTray.make(main, f, cards, projs, pick, drill_it))
	v.add_child(_goal_row(f, goal, pl, nights))
	v.add_child(_strip(main, c, f, pl, inp, projs))
	var below := UI.hbox(26)
	var left := _foot(main, f, pl)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	below.add_child(left)
	below.add_child(_camp)
	v.add_child(below)


## The weeks strip (or THIS WEEK), Light / Standard / Hard, the fight-night gauges (THIS CAMP's GaugeRow, shown up here).
func _head(main: Node, c: Career, f: Dictionary, goal: Dictionary, evs: Array) -> Control:
	var h := UI.hbox(24)
	h.name = "BoardHead"
	var bout: Dictionary = goal["bout"]
	var camp: Dictionary = f.get("camp", {})
	if not bout.is_empty() and not bool(bout.get("done", false)):
		h.add_child(WeekStrip.make(f, bout.get("opp", {}), int(bout["day"]), c.day, int(camp.get("start", c.day)),
			str(camp.get("focus", f.get("focus", ""))), bool(camp.get("film", false)), evs.count("sparring")))
	else:
		var left := UI.vbox(0)
		left.add_child(WB.ink("THIS WEEK", 34, "marker"))
		var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
		left.add_child(UI.label(str(ph["name"]), 16, UI.MUTED, "semi"))
		h.add_child(left)
	h.add_child(_steps(main, f))
	h.add_child(UI.spacer())
	var g: Node = _camp.get("_gauge")
	if g != null:
		g.get_parent().remove_child(g)
		(g as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(g)
	return h


## Light / Standard / Hard: her pad nights (in camp the camp's protocol, else her training load).
static func _steps(main: Node, f: Dictionary) -> Control:
	var row := UI.hbox(0)
	row.name = "Steps"
	row.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var on := PadWeek.step_of(f)
	var camp := PadWeek.in_camp(f)
	# The tooltip counts the pad nights as PadWeek.nights_of will (film takes one, the taper halves them); the sparring
	# nights are the Sparring nights pills', not the step's.
	var ph := str(f.get("phase", "base"))
	var film := camp and WeekPhase.film_night(ph, f.get("camp", {}), int(f.get("phase_day", -1)))   # S385: this week's film only
	for i in 3:
		var pads: int = (PadWeek.nights_for(i, camp, film, camp and ph == "taper")["pads"] as Array).size()
		var b := Button.new()
		b.name = "Step_%d" % i
		b.text = STEP_WORDS[i]
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(108, 44)
		b.add_theme_font_override("font", UI.font("semi"))
		b.add_theme_font_size_override("font_size", 19)
		var lit := i == on
		for k in ["font_color", "font_hover_color", "font_pressed_color"]:
			b.add_theme_color_override(k, Color.WHITE if lit else UI.FG)
		for st in ["normal", "hover", "pressed", "focus"]:
			var s := UI.box(UI.GOLD if lit else (UI.PANEL2 if st == "hover" else UI.PANEL), UI.GOLD if lit else UI.LINE, 0, 1, 0, 0)
			s.corner_radius_top_left = 8 if i == 0 else 0
			s.corner_radius_bottom_left = 8 if i == 0 else 0
			s.corner_radius_top_right = 8 if i == 2 else 0
			s.corner_radius_bottom_right = 8 if i == 2 else 0
			b.add_theme_stylebox_override(st, s)
		b.tooltip_text = "%d pad night%s a week" % [pads, "" if pads == 1 else "s"]
		b.pressed.connect(main.act.bind("nights", "%s|%d" % [f["id"], i]))
		row.add_child(b)
	return row


## GOAL: the focus stat now -> the end of this week (the mornings' sum; NightBar's gold tick at the number that changes
## the night) and INTENSITY: the week's blocks against the coach's 16.
func _goal_row(f: Dictionary, goal: Dictionary, pl: Dictionary, nights: Dictionary) -> Control:
	var h := UI.hbox(14)
	h.name = "GoalRow"
	var stat := str(goal["stat"])
	var now := float((f["stats"] as Dictionary).get(stat, 50.0))
	var end := now
	for r in (pl["wk"] as Dictionary).get("days", []):
		if str(r.get("stat", "")) == stat:
			end += float(r.get("gain", 0.0))
		if str(r.get("stat2", "")) == stat:
			end += float(r.get("gain2", 0.0))
	h.add_child(UI.label("GOAL", 16, UI.FG, "caps"))
	var nums := UI.hbox(6)
	nums.name = "GoalNums"
	nums.add_child(UI.label(str(Data.LABEL.get(stat, stat)), 19, UI.FG, "body"))
	# S397 blind round 3 ("65.1 -> 65.2"): her stat as the page shows it everywhere, the week's gain in words, decimals on hover.
	nums.add_child(UI.label("%d" % int(now), 19, UI.FG, "bold"))
	var d := end - now
	nums.add_child(UI.label("holding" if d < 0.05 else ("up a little" if d < 0.6 else ("up" if d < 1.5 else "a big week")), 19, UI.GREEN if d >= 0.05 else UI.MUTED, "bold"))
	nums.tooltip_text = "%.1f now, %.1f by Sunday" % [now, end]
	nums.mouse_filter = Control.MOUSE_FILTER_STOP
	h.add_child(nums)
	var fid := str(f["id"])
	var bar := NightBar.make(stat, now, end, float(_seen_goal.get(fid, end)))
	_seen_goal[fid] = end
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(bar)
	var words := BoutRules.night_line_words(stat)
	if words != "":
		h.add_child(UI.label(words, 18, UI.GOLD if BoutRules.clears_night_line(stat, end) else UI.MUTED, "hand"))
	h.add_child(UI.spacer())
	var blocks := PadWeek.intensity(pl["days"], (nights.get("pads", []) as Array).size(), (nights.get("spar", []) as Array).size())
	h.add_child(UI.label("INTENSITY", 16, UI.FG, "caps"))
	var n := UI.label("%d" % blocks, 24, WB.RED if blocks > TrainingPlan.DEFAULT_TOTAL else UI.FG, "bold")
	n.name = "Intensity"
	h.add_child(n)
	h.add_child(UI.label("/ %d" % TrainingPlan.DEFAULT_TOTAL, 18, UI.MUTED, "body"))
	return h


## The seven days: heads, the AM cards, the open morning's picker, the PM cards.
func _strip(main: Node, c: Career, f: Dictionary, pl: Dictionary, inp: Dictionary, projs: Dictionary) -> Control:
	var fid := str(f["id"])
	var box := UI.vbox(8)
	box.name = "Week"
	var days: Array = pl["days"]
	var base: Array = pl["base"]
	var wk: Dictionary = pl["wk"]
	var changed: Dictionary = WeekPhase.edits(f).get("days", {})
	var coach := WeekPlan.coach_of(f)
	var monday := c.day - posmod(c.day, 7)
	var twist := str(WeekTwist.active(f).get("name", ""))
	var set_day := func(i: int, card: Array) -> void:
		picking = ""
		main.act("wday", "%s|%d|%s|%s" % [fid, i, card[0], card[1]])
	var open := func(i: int) -> void:
		picking = "" if picking == "%s|%d" % [fid, i] else "%s|%d" % [fid, i]
		main.render()
	var heads := UI.hbox(10)
	var ams := UI.hbox(10)
	ams.name = "Mornings"
	var pms := UI.hbox(10)
	pms.name = "Nights"
	for i in 7:
		var hd := WeekDay.head(i, monday + i, changed.has(str(i)), coach[i], set_day, _ghost_day)
		hd.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hd.custom_minimum_size.x = 60
		heads.add_child(hd)
		ams.add_child(WeekDay.am(f, i, days[i], base[i], wk["days"][i], (wk["red"] as Array).has(i), changed.has(str(i)), twist, open))
		pms.add_child(WeekDay.pm(_night_spec(main, f, i, inp, projs)))
	box.add_child(heads)
	box.add_child(ams)
	if picking.begins_with(fid + "|"):
		var i := int(picking.get_slice("|", 1))
		box.add_child(WeekDay.picker(f, i, days[i], set_day, _ghost_day))
	box.add_child(pms)
	return box


## One PM card's spec (WeekDay.pm): what the night is, its cards and their gains, the chips, and the clicks.
func _night_spec(main: Node, f: Dictionary, i: int, inp: Dictionary, projs: Dictionary) -> Dictionary:
	var fid := str(f["id"])
	var nights: Dictionary = inp["nights"]
	var kind := "rest"
	if (nights.get("pads", []) as Array).has(i):
		kind = "pads"
	elif (nights.get("spar", []) as Array).has(i):
		kind = "sparring"
	elif int(nights.get("film", -1)) == i:
		kind = "film"
	var rows := PadEdit.night_rows(f, projs)
	var spar: Array = []
	for card in rows:
		if kind == "sparring" and (rows[card] as Dictionary).has(i):
			spar.append(PadEdit.title(f, str(card)))
	var c: Career = main.career
	var coach := float(c.coach.get("rating", 0.0))
	var who := str(c.coach.get("name", "")).get_slice(" ", 0)
	var chips := ["%s: +%d%% from sessions" % [who, roundi(40.0 * coach / 100.0)] if coach > 0.0 else "No coach: sessions at base",
		"Gym kit: level %d" % int(PadWeek.STATION_TIER)]
	var picked := DrillTray.picked_for(fid)
	var click := func(dow: int) -> void:
		var now := DrillTray.picked_for(fid)
		if now != "":
			main.act("drill", "%s|%d|%s" % [fid, dow, now])
	return {"i": i, "kind": kind, "entries": (inp["week"] as Dictionary).get(PadWeek.DAYS[i], []), "rows": rows, "f": f,
		"chips": chips, "picked": picked != "", "spar_cards": spar, "camp": PadWeek.in_camp(f), "partner": PlanCards.partner(f),
		"on_drop": func(dow: int, card: String): main.act("drill", "%s|%d|%s" % [fid, dow, card]),
		"on_click": click,
		"on_clear": func(dow: int): main.act("undrill", "%s|%d" % [fid, dow]),
		"on_remove": func(dow: int, card: String): main.act("undrill", "%s|%d|%s" % [fid, dow, card]),
		"on_split": func(dow: int): main.act("padsplit", "%s|%d" % [fid, dow])}


## S382 G5: a morning card under the cursor (WeekDay) ghosts on THIS CAMP; [] = off.
func _ghost_day(dow: int, card: Array) -> void:
	if _camp != null:
		_camp.call("ghost_day", dow, card)


## Under the strip: the coach's one line, the sparring nights, the coach's week, CONTINUE.
func _foot(main: Node, f: Dictionary, pl: Dictionary) -> Control:
	var fid := str(f["id"])
	var v := UI.vbox(12)
	var says := UI.hbox(10)
	says.add_child(WB.ink("COACH:", 24, "marker"))
	var line := WB.ink("\"%s\"" % WeekCoach.line(pl["days"], pl["wk"], _lines, str((pl["ctx"] as Dictionary).get("diet", "hold"))), 22,
		"hand", WB.INK, true)
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
	var reset := UI.button("Coach's week", "BtnQuiet", main.act.bind("weekreset", fid))
	reset.name = "WeekReset"
	reset.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	reset.tooltip_text = "Undo your changes to the mornings: back to the coach's week for this phase"
	row.add_child(reset)
	row.add_child(UI.spacer())
	row.add_child(_continue(main))
	v.add_child(row)
	return v


func _continue(main: Node) -> Button:
	var go := Button.new()
	go.name = "BoardContinue"
	go.text = "CONTINUE"
	go.add_theme_font_override("font", UI.font("marker"))
	go.add_theme_font_size_override("font_size", 28)
	for k in ["normal", "hover", "pressed", "focus"]:
		var s := UI.box(WB.RED if k != "hover" else WB.RED.lightened(0.1), Color("#8e1f1a"), 4, 2, 30, 8)
		s.set_border_width(SIDE_BOTTOM, 6)
		go.add_theme_stylebox_override(k, s)
	go.add_theme_color_override("font_color", Color.WHITE)
	go.add_theme_color_override("font_hover_color", Color.WHITE)
	go.pressed.connect(func(): main.act("go_btn"))
	return go
