extends PanelContainer
## The fighter's Week tab. S398 Week v8 (docs/WEEK_REDESIGN_S397.md, mock-up docs/week_mock/week_v8.png; built on the S398
## main session's call after twelve blind critics held the paper version at 7): top to bottom
##   head      NEXT / THIS WEEK and its dates (or the weeks strip to fight night, WeekStrip), the fight-night gauges in camp,
##             WEEK TIREDNESS (the week's peak on the model's 0-100 scale: starts at, peak, the day)
##   totals    PLAN TOTALS: the week's gains by attribute and the moves that reach Usable
##   the week  seven columns: the morning card, the evening card, "tired N" at night (WeekCards); a click on a card opens its
##             popover (WeekPops): Light | Normal | Hard + the sessions, or Rest | Pads | Sparring + the drill cards
##   goal      the goal attribute this week (now -> Sunday), the target and the pace to it
##   coach     his one change with what it does on the button, and Back to the coach's week
##   tray      LEARN ON THE PADS (DrillTray): drag a card onto an evening, or click it then the evening
##   camp      THIS CAMP (WeekCamp) only with a fight booked
## One effort scale (tiredness), every number named, one edit grammar (click -> popover), blue = what you set.
##   WeekBoard.make(main, career, fighter) -> PanelContainer   goal_of(career, fighter)   plan_of(career, fighter)
##   WeekBoard.picking / picking_eve (static "fid|dow": the morning / evening whose popover is open)

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const WeekDay := preload("res://scripts/ui/WeekDay.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")
const WeekPops := preload("res://scripts/ui/WeekPops.gd")
const DrillTray := preload("res://scripts/ui/DrillTray.gd")
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
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekCamp := preload("res://scripts/ui/WeekCamp.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")

const WEEKS_NO_BOUT := 4

static var picking := ""
static var picking_eve := ""

var _lines: Array = []
var _camp: Node = null   # THIS CAMP (WeekCamp): a choice under the cursor ghosts there (S382 G5)
var _meter: Control = null   # WEEK FATIGUE, drawn on the totals row (S398: the camp head ran past 1920)


static func make(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var p := new()
	p.name = "WeekBoard"
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 14, 1, 18, 16))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# S397 blind rounds 5-6: Saturday and Sunday plan next week. The board draws a view of her for next Monday
	# (WeekPhase.ahead_view); the acts write that week's own exceptions, which WeekPhase.sync moves in on the Monday.
	var g := f
	if WeekPhase.weekend(c.day):
		g = WeekPhase.ahead_view(f, c.day)
		g["_ahead"] = true
	p._build(main, c, g)
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
	if not bool(f.get("_ahead", false)):   # the weekend's view of next week is already that week's (make)
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


static func booked(goal: Dictionary) -> bool:
	return not (goal["bout"] as Dictionary).is_empty() and not bool((goal["bout"] as Dictionary).get("done", false))


## Each day's tiredness: [start after the night's sleep, end at night, the day's cost] (WeekPlan.week's fatigue chain).
static func tired_days(pl: Dictionary) -> Array:
	var out: Array = []
	var prev := float((pl["ctx"] as Dictionary).get("fatigue", 20.0))
	for r in (pl["wk"] as Dictionary)["days"]:
		var start := prev * WeekPlan.FATIGUE_KEEP
		var end := float(r["fatigue"])
		out.append([start, end, maxf(0.0, end - start), float(r.get("load", 0.0)) / WeekPlan.LOAD_PER_FATIGUE])
		prev = end
	return out


func _build(main: Node, c: Career, f: Dictionary) -> void:
	var pl := plan_of(c, f)
	var goal: Dictionary = pl["goal"]
	_lines = pl["lines"]
	_camp = WeekCamp.make(main, f, goal, _lines, teaching(f), func(g: Dictionary) -> Array: return plan_of(c, g)["lines"])
	var v := UI.vbox(14)
	add_child(v)
	var tired := tired_days(pl)
	v.add_child(_head(c, f, goal, pl, tired))
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
	var usable := 0
	for card in projs:
		projs[card]["eta"] = PadEdit.eta(f, str(card), projs[card], week, nights.get("spar", []))
		projs[card]["pads"] = nights.get("pads", [])
		if cards.has(card) and not PadEdit.crossing(f, str(card), projs[card]).is_empty():
			usable += 1
	if plan:   # judged on the camp's real weeks to the bout (PlanCards.fight_paths), not this week repeated
		var fd := int((f["bout"] as Dictionary)["day"])
		PlanCards.dress(f, projs, c.day - posmod(c.day, 7), fd, PlanCards.fight_paths(f, inp, c.day, fd))
	var bar := _twist_bar(main, f)   # S398 critics: an open twist is the week's one decision - one line above the week
	if bar != null:
		v.add_child(bar)
		var tn := _camp.find_child("Twist", true, false) as Control   # said once: the bar holds the decision
		if tn != null:
			tn.visible = false
	var tot := WeekCards.totals((pl["wk"] as Dictionary)["gains"], usable)
	tot.add_child(UI.spacer())
	tot.add_child(_meter)
	v.add_child(tot)
	v.add_child(_strip(main, c, f, pl, inp, projs, tired, cards))
	v.add_child(_goal_row(f, goal, pl))
	v.add_child(_coach_row(main, f, pl))
	(_camp as Control).visible = booked(goal)   # S398 critic: no fight booked, no camp to show
	if booked(goal):
		v.add_child(_camp)
	var fid := str(f["id"])
	var pick := func(card: String) -> void:   # click-click: the card waits for an evening (a second click puts it back)
		DrillTray.picked = "" if DrillTray.picked_for(fid) == card else "%s|%s" % [fid, card]
		main.render()
	var drill_it := func(card: String) -> void: main.act("drillit", "%s|%s" % [fid, card])
	v.add_child(DrillTray.make(main, f, cards, projs, pick, drill_it))
	if not booked(goal):
		v.add_child(_camp)


## The week's name and dates (or the weeks strip to fight night), the fight-night gauges, WEEK TIREDNESS.
func _head(c: Career, f: Dictionary, goal: Dictionary, pl: Dictionary, tired: Array) -> Control:
	var h := UI.hbox(24)
	h.name = "BoardHead"
	var bout: Dictionary = goal["bout"]
	var camp: Dictionary = f.get("camp", {})
	if booked(goal):   # S398 (operator: nothing on screen the player cannot act on): the camp's weeks are Fight prep's
		var left := UI.hbox(14)
		left.add_child(WB.ink("THIS WEEK", 34, "marker"))
		var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
		var line := UI.label("%s - fight night %s, %d days" % [str(ph["name"]), Clock.fmt(int(bout["day"])), int(bout["day"]) - c.day], 17, UI.FG, "semi")
		line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left.add_child(line)
		h.add_child(left)
	else:
		var left := UI.hbox(14)
		var ahead := bool(f.get("_ahead", false))
		var t := WB.ink("NEXT WEEK" if ahead else "THIS WEEK", 34, "marker")
		left.add_child(t)
		var mon := int(f["phase_day"]) if ahead else c.day - posmod(c.day, 7)
		var dates := UI.label("%s - %s" % [Clock.fmt(mon), Clock.fmt(mon + 6)], 17, UI.FG, "semi")
		dates.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left.add_child(dates)
		var nb := UI.label("No fight booked", 16, UI.MUTED, "body")
		nb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left.add_child(nb)
		h.add_child(left)
	h.add_child(UI.spacer())
	var g: Node = _camp.get("_gauge")
	if g != null and booked(goal):
		g.get_parent().remove_child(g)
		(g as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(g)
	var wk: Dictionary = pl["wk"]
	var order := range(7)
	order.sort_custom(func(a, b): return float(tired[a][2]) > float(tired[b][2]))
	var heavy := ", ".join(order.slice(0, 2).map(func(d): return "%s %s" % [WeekCards.DAY_NAMES[d].left(3), WeekCards.tired_words(float(tired[d][2]))]))
	_meter = WeekCards.meter(float((pl["ctx"] as Dictionary).get("fatigue", 20.0)), float(wk["peak"]), maxi(0, int(wk["peak_day"])), heavy)
	return h


## GOAL: the goal attribute now -> Sunday, the target and the pace to it (WeekPlan.goal_lines' projection).
func _goal_row(f: Dictionary, goal: Dictionary, pl: Dictionary) -> Control:
	var h := UI.hbox(14)
	h.name = "GoalRow"
	var stat := str(goal["stat"])
	var now := float((f["stats"] as Dictionary).get(stat, 50.0))
	var end := float(((pl["wk"] as Dictionary)["stats_end"] as Dictionary).get(stat, now))
	h.add_child(UI.caps("GOAL"))
	var nums := UI.hbox(6)
	nums.name = "GoalNums"
	nums.add_child(UI.label(WeekCards.label_of(stat), 19, UI.FG, "body"))
	nums.add_child(UI.label("%.1f -> %.1f" % [now, end], 19, UI.FG, "bold"))
	nums.add_child(UI.label("this week", 19, UI.FG, "body"))
	h.add_child(nums)
	var line := {}
	for l in _lines:
		if str(l["id"]) == stat:
			line = l
	var bar := WeekCards.GoalBar.new()
	bar.name = "GoalBar"
	bar.now = now
	bar.week = end
	bar.pace = float(line.get("end", end))
	bar.target = float(line.get("target", float(goal["target"])))
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(bar)
	if not line.is_empty():
		var w := int(goal["weeks"])
		h.add_child(UI.label("target %d %s" % [roundi(float(line["target"])), "by fight night" if booked(goal) else "in %d weeks" % w], 17, UI.FG, "body"))
		var ok := bool(line["ok"])
		var pace := UI.label("on pace for %.1f%s" % [float(line["end"]), ", on target" if ok else ", a little short" if float(line["short"]) < 0.6 else ", short"],
			17, UI.GREEN if ok else UI.AMBER, "bold")
		pace.name = "GoalPace"
		h.add_child(pace)
	var key := UI.hbox(5)   # S398 critics: the gold dot on the mornings, said once
	var dot := ColorRect.new()
	dot.color = Color("#e0a400")
	dot.custom_minimum_size = Vector2(9, 9)
	dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	key.add_child(dot)
	key.add_child(UI.label("mornings that train it", 14, UI.MUTED, "body"))
	h.add_child(key)
	if booked(goal):   # S397: the fight-night line only when a fight is booked
		var words := BoutRules.night_line_words(stat)
		if words != "":
			h.add_child(UI.label(words, 16, UI.GREEN if BoutRules.clears_night_line(stat, end) else UI.MUTED, "body"))
	return h


## The seven columns: day head, the morning card, the evening card, "tired N" at night; the open popover floats beside its card.
func _strip(main: Node, c: Career, f: Dictionary, pl: Dictionary, inp: Dictionary, projs: Dictionary, tired: Array, cards: Array) -> Control:
	var fid := str(f["id"])
	var days: Array = pl["days"]
	var base: Array = pl["base"]
	var wk: Dictionary = pl["wk"]
	var changed: Dictionary = WeekPhase.edits(f).get("days", {})
	var coach := WeekPlan.coach_of(f)
	var monday := c.day - posmod(c.day, 7) + (7 if bool(f.get("_ahead", false)) else 0)   # S397 the weekend's next week
	var twist := str(WeekTwist.active(f).get("name", ""))
	var goal_key := str((pl["goal"] as Dictionary)["stat"])
	var set_day := func(i: int, card: Array) -> void:
		picking = ""
		main.act("wday", "%s|%d|%s|%s" % [fid, i, card[0], card[1]])
	var open := func(i: int) -> void:
		picking = "" if picking == "%s|%d" % [fid, i] else "%s|%d" % [fid, i]
		picking_eve = ""
		main.render()
	var open_eve := func(i: int) -> void:
		picking_eve = "" if picking_eve == "%s|%d" % [fid, i] else "%s|%d" % [fid, i]
		picking = ""
		main.render()
	var grid := UI.hbox(10)
	grid.name = "Week"
	var am_cards: Array = []
	var pm_cards: Array = []
	for i in 7:
		var col := UI.vbox(8)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.custom_minimum_size.x = 150
		var hd := WeekDay.head(i, monday + i, changed.has(str(i)), coach[i], set_day, _ghost_day)
		col.add_child(hd)
		var r: Dictionary = (wk["days"][i] as Dictionary).duplicate()
		# S398 built-page critics ("the cards don't add up to PLAN TOTALS in camp"): each card shows its gain as the week
		# counts it - the camp's multiplier on the camp's attribute (WeekPlan.week)
		var ctx: Dictionary = pl["ctx"]
		for k in [["stat", "gain"], ["stat2", "gain2"]]:
			if str(r.get(k[0], "")) != "" and str(r[k[0]]) == str(ctx.get("camp_stat", "")):
				r[k[1]] = float(r[k[1]]) * float(ctx.get("camp_mult", 1.0))
		var m: Array = days[i]
		var red := (wk["red"] as Array).has(i)
		var card := func() -> Dictionary: return WeekDay.magnet_card(m, base[i], r, red, changed.has(str(i)), twist)
		var am := WeekCards.am(i, m, base[i], r, float(tired[i][3]), float(tired[i][0]), goal_key, card, open)
		col.add_child(am)
		am_cards.append(am)
		var spec := _night_spec(main, f, i, inp, projs)
		spec["cost"] = float(tired[i][2]) - float(tired[i][3])
		spec["key2"] = str(r.get("stat2", "")) if float(r.get("gain2", 0.0)) >= 0.005 else ""
		spec["gain2"] = float(r.get("gain2", 0.0))
		spec["on_open"] = open_eve
		var pm := WeekDay.pm(spec)
		col.add_child(pm)
		pm_cards.append(pm)
		col.add_child(WeekCards.tired_line(i, float(tired[i][0]), float(tired[i][1]), float(tired[i][2])))
		grid.add_child(col)
	var close := func() -> void:
		picking = ""
		picking_eve = ""
		main.render()
	if picking.begins_with(fid + "|"):
		var i := int(picking.get_slice("|", 1))
		var body := WeekPops.morning(i, days[i], pl["ctx"], float(tired[i][0]), set_day, _ghost_day, goal_key)
		var p := WeekCards.pop("MorningPop", "%s morning" % WeekCards.DAY_NAMES[i], body, close)
		p.anchor = am_cards[i]
		p.left = i >= 2   # over the days before it, which the change cannot alter
		grid.add_child(p)
	elif picking_eve.begins_with(fid + "|"):
		var i := int(picking_eve.get_slice("|", 1))
		var spec: Dictionary = (pm_cards[i] as Control).get("spec")
		var body := WeekPops.evening(f, i, str(spec["kind"]), spec.get("entries", []), cards, PadWeek.pad_share(f),
			func(d: int, k: String): picking_eve = "" if k != "pads" else picking_eve; main.act("weve", "%s|%d|%s" % [fid, d, k]),
			func(d: int, cd: String): picking_eve = ""; main.act("drill", "%s|%d|%s" % [fid, d, cd]),
			func(d: int): picking_eve = ""; main.act("undrill", "%s|%d" % [fid, d]))
		var p := WeekCards.pop("EveningPop", "%s evening" % WeekCards.DAY_NAMES[i], body, close)
		p.anchor = pm_cards[i]
		p.left = i >= 2
		grid.add_child(p)
	return grid


## One evening card's spec (WeekDay.pm): what the night is, its cards and their gains, and the clicks.
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
	var spar_g: Array = []   # S398: "Uppercut +3" - what the sparring night drills, so the tray's week adds up
	for card in rows:
		if kind == "sparring" and (rows[card] as Dictionary).has(i):
			spar.append(PadEdit.title(f, str(card)))
			var d := roundi(float(rows[card][i][1]) - float(rows[card][i][0]))
			if d > 0:
				spar_g.append("%s %+d" % [PadEdit.title(f, str(card)), d])
	var picked := DrillTray.picked_for(fid)
	var click := func(dow: int) -> void:
		var now := DrillTray.picked_for(fid)
		if now != "":
			main.act("drill", "%s|%d|%s" % [fid, dow, now])
	return {"i": i, "kind": kind, "entries": (inp["week"] as Dictionary).get(PadWeek.DAYS[i], []), "rows": rows, "f": f,
		"chips": [], "picked": picked != "", "spar_cards": spar, "spar_gains": spar_g, "camp": PadWeek.in_camp(f), "partner": PlanCards.partner(f),
		"on_drop": func(dow: int, card: String): main.act("drill", "%s|%d|%s" % [fid, dow, card]),
		"on_click": click,
		"on_clear": func(dow: int): main.act("undrill", "%s|%d" % [fid, dow]),
		"on_remove": func(dow: int, card: String): main.act("undrill", "%s|%d|%s" % [fid, dow, card]),
		"on_split": func(dow: int): main.act("padsplit", "%s|%d" % [fid, dow])}


## The week's open twist as one bar: its name and line, the two answers as buttons (the coach's pick filled), the details
## on hover; THIS CAMP below keeps the full card. null when there is no choice to make.
func _twist_bar(main: Node, f: Dictionary) -> Control:
	var t := WeekTwist.card_for(f)
	if t.is_empty() or not t.has("a") or bool(f.get("twist_locked", false)) or str(f.get("twist_pick", "")) != "":
		return null
	var p := PanelContainer.new()
	p.name = "TwistBar"
	p.add_theme_stylebox_override("panel", UI.box(Color("#fff4cf"), Color("#e0a400"), 10, 1, 14, 8))
	var h := UI.hbox(14)
	p.add_child(h)
	h.add_child(UI.label(("%s" if bool(t.get("ask", false)) else "TWIST: %s") % str(t["name"]).to_upper(), 16, WB.RED, "bold"))
	var line := UI.label(str(t["line"]), 16, UI.FG, "body")
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.clip_text = true
	line.tooltip_text = str(t["line"])
	line.mouse_filter = Control.MOUSE_FILTER_STOP
	h.add_child(line)
	var shown := WeekTwist.answer(f)
	for a in ["a", "b"]:
		var opt: Dictionary = t[a]
		var b := UI.button(str(opt["label"]) + (" (coach's pick)" if a == shown else ""), "BtnSolid" if a == shown else "Btn",
			main.act.bind("twistpick", "%s|%s" % [f["id"], a]))
		b.name = "TwistBar_" + a
		b.tooltip_text = str(opt["line"])
		if _camp != null:
			b.mouse_entered.connect(func(): _camp.call("_preview", a))
			b.mouse_exited.connect(func(): _camp.call("_preview_off"))
		h.add_child(b)
	return p


## S382 G5: a choice under the cursor ghosts on THIS CAMP; [] = off.
func _ghost_day(dow: int, card: Array) -> void:
	if _camp != null:
		_camp.call("ghost_day", dow, card)


## The coach's one change with what it does written on the button (this week's gain, the peak), and Back to his week.
func _coach_row(main: Node, f: Dictionary, pl: Dictionary) -> Control:
	var fid := str(f["id"])
	var says := UI.hbox(12)
	says.name = "CoachRow"
	says.add_child(UI.caps("COACH"))
	# S397 blind round 5: with no bout booked the weight forecast is moot (it read as "over the limit" beside "on weight").
	var said_lines: Array = _lines if not (f.get("bout", {}) as Dictionary).is_empty() else _lines.filter(func(l): return str(l["id"]) != "weight")
	var ad := WeekCoach.advice(pl["days"], pl["wk"], said_lines, str((pl["ctx"] as Dictionary).get("diet", "hold")))
	var fix: Dictionary = ad["fix"]
	var line := UI.label("\"%s\"" % str(ad["say"]), 17, UI.FG, "body")
	line.name = "CoachLine"
	if float(ad["short"]) > 0.0:
		line.mouse_filter = Control.MOUSE_FILTER_STOP
		line.tooltip_text = "%.1f short of the line" % float(ad["short"])
	says.add_child(line)
	if not fix.is_empty():
		var arg := "%s|cut" % fid if fix.has("diet") else "%s|%d|%s|%s" % [fid, int(fix["dow"]), str(fix["card"][0]), str(fix["card"][1])]
		var apply := UI.button("Do it" + _fix_effect(pl, fix), "BtnSolid", main.act.bind("diet" if fix.has("diet") else "wday", arg))
		apply.name = "CoachApply"
		apply.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		says.add_child(apply)
	says.add_child(UI.spacer())
	var mine := not WeekPhase.edits(f).is_empty() and (not (WeekPhase.edits(f).get("days", {}) as Dictionary).is_empty()
		or not (WeekPhase.edits(f).get("eve", {}) as Dictionary).is_empty() or WeekPhase.edits(f).has("spar"))
	var reset := UI.button("Back to the coach's week", "Btn", main.act.bind("weekreset", fid), not mine, "This is the coach's week")
	reset.name = "WeekReset"
	reset.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	says.add_child(reset)
	return says


## ": Conditioning +0.06 this week, peak tired 56 -> 58" - the coach's morning change run through the same week.
static func _fix_effect(pl: Dictionary, fix: Dictionary) -> String:
	if not fix.has("dow"):
		return ""
	var days: Array = (pl["days"] as Array).duplicate(true)
	days[int(fix["dow"])] = [str(fix["card"][0]), str(fix["card"][1])]
	var wk2 := WeekPlan.week(days, pl["ctx"], pl["evs"])
	var wk: Dictionary = pl["wk"]
	var stat := str((pl["goal"] as Dictionary)["stat"])
	# S398 critics: the effect in the goal's own terms - where the pace ends, against the target
	var goal: Dictionary = pl["goal"]
	var l1 := WeekPlan.goal_lines(goal, pl["days"], pl["ctx"], int(goal["weeks"]), pl["evs"])
	var l2 := WeekPlan.goal_lines(goal, days, pl["ctx"], int(goal["weeks"]), pl["evs"])
	var out := ""
	for k in l1.size():
		if str(l1[k]["id"]) == stat:
			var reach := float(l2[k]["end"]) >= float(l1[k]["target"])
			out = ": %.1f of %d%s" % [float(l2[k]["end"]), roundi(float(l1[k]["target"])), "" if reach else ", still short"]
	if roundi(float(wk2["peak"])) != roundi(float(wk["peak"])):
		out += "%s peak fatigue %d -> %d" % [", " if out != "" else ": ", roundi(float(wk["peak"])), roundi(float(wk2["peak"]))]
	return out
