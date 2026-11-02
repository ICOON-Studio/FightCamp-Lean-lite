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
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const DAY_W := 140.0
const CAMP_W := 470.0
const WEEKS_NO_BOUT := 4
const DAYS := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
const SHORT := {"power": "power", "speed": "speed", "technique": "tech", "defense": "def", "conditioning": "cond",
	"fight_iq": "ring IQ", "chin": "chin"}
## The training load ratio (this week's hours / her usual, TrainingLoad): 1.5 doubles the injury risk.
const LOAD_NEAR := 1.3
const LOAD_OVER := 1.5


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


func _build(main: Node, c: Career, f: Dictionary) -> void:
	var goal := goal_of(c, f)
	var tw := WeekTwist.active(f)
	var base := WeekPlan.days_of(f)
	var days := WeekTwist.days(tw, base)
	var evs := WeekTwist.evenings(tw, WeekPlan.evenings_of(f))
	var ctx := Sim.week_ctx(c, f)
	var wk := WeekPlan.week(days, ctx, evs)
	var lines := WeekPlan.goal_lines(goal, days, ctx, int(goal["weeks"]), evs, WeekPlan.ahead(f, c.day, int(goal["weeks"])))
	var v := UI.vbox(16)
	add_child(v)
	v.add_child(_head(c, f, goal))
	var mid := UI.hbox(26)
	v.add_child(mid)
	# The coach's line and the dials sit under the days (the mockup), so THIS CAMP's height never pushes CONTINUE down.
	var left := UI.vbox(18)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(_week(main, f, days, base, evs, wk))
	left.add_child(_foot(main, c, f, days, wk, lines, str(ctx.get("diet", "hold"))))
	mid.add_child(left)
	mid.add_child(_camp(main, f, goal, lines))


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
	if not bout.is_empty() and not bool(bout.get("done", false)):
		if not camp.is_empty():
			var total := maxi(weeks, int(ceil((int(bout["day"]) - int(camp.get("start", c.day))) / 7.0)))
			when = "camp week %d of %d" % [clampi(total - weeks + 1, 1, total), total]
		else:
			when = "%d weeks to fight night - no camp set yet" % weeks
	sub.add_child(WB.ink(when, 24, "hand", WB.INK))
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


## The seven days: a magnet for the morning (every card on a click), the evening's, the day's fatigue.
func _week(main: Node, f: Dictionary, days: Array, base: Array, evs: Array, wk: Dictionary) -> Control:
	var box := UI.vbox(8)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
	var changed: Dictionary = WeekPhase.edits(f).get("days", {})
	var said := "%s  Click a morning's magnet to change the day; pick the coach's card again to undo it%s." % [ph["line"],
		"" if changed.is_empty() else " (%d changed)" % changed.size()]
	var phase_line := WB.ink(said, UI.SMALL + 1, "hand", WB.PENCIL, true)
	phase_line.name = "Phase"
	box.add_child(phase_line)
	var row := UI.hbox(0)
	row.name = "Week"
	box.add_child(row)
	var cards := WeekPhase.cards()
	var items: Array = cards.map(func(d): return [WeekPhase.card(d), d])
	for i in 7:
		if i > 0:
			var rule := ColorRect.new()
			rule.color = Color(WB.INK, 0.22)
			rule.custom_minimum_size = Vector2(2, 0)
			row.add_child(rule)
		row.add_child(_day(main, str(f["id"]), i, days[i], base[i], evs[i], wk["days"][i], (wk["red"] as Array).has(i),
			changed.has(str(i)), items, str(WeekTwist.active(f).get("name", ""))))
	return box


func _day(main: Node, fid: String, i: int, m: Array, planned: Array, evening: String, r: Dictionary, red: bool, mine: bool,
		items: Array, twist := "") -> Control:
	var pad := MarginContainer.new()
	pad.name = "Day_%d" % i
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 8)
	pad.custom_minimum_size = Vector2(DAY_W, 0)
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(6)
	pad.add_child(v)
	var head := UI.hbox(6)
	head.add_child(WB.ink(DAYS[i], 26, "marker"))
	if mine:
		head.add_child(WB.ink("yours", UI.SMALL, "handbold", UI.GOLD))
	if m != planned:
		head.add_child(WB.ink("twist", UI.SMALL, "handbold", UI.AMBER))
	v.add_child(head)
	v.add_child(WB.ink(_kind(m), UI.SMALL + 2, "hand", WB.PENCIL))
	var rest := str(m[0]) == "rest"
	var name := "off" if rest else str(WeekPhase.NAMES.get(str(m[0]), str(m[0])))
	var tip := "%s\n%s\nfatigue %d by the night%s" % [WeekPhase.card(m), _numbers(r), int(round(float(r["fatigue"]))),
		"\nYour change - pick the coach's card again to undo it" if mine else ""]
	# S357 (S356 stills): a day the twist changed names the card it replaced.
	if m != planned:
		tip += "\nTwist (%s): replaces %s" % [twist, WeekPhase.card(planned)]
	var cur := items.map(func(it): return it[1]).find([str(m[0]), "normal" if rest else str(m[1])])
	var mag := WB.pick_magnet(name, "" if rest else WB.roman(str(m[1])), str(m[1]) == "hard", tip, items, cur,
		func(d): main.act("wday", "%s|%d|%s|%s" % [fid, i, d[0], d[1]]))
	mag.name = "Session_%d" % i
	v.add_child(mag)
	if evening == "rest":
		v.add_child(WB.ink("~ off", UI.SMALL + 2, "hand", WB.PENCIL))
	else:
		var spar := evening == "sparring"
		v.add_child(WB.magnet("spar" if spar else "pads", "III" if spar else "II", spar,
			str((WeekPlan.EVENINGS.get(evening, WeekPlan.EVENINGS["rest"]) as Dictionary)["name"])))
	var fat := float(r["fatigue"])
	var bar := WB.Fatigue.new()
	bar.value = fat
	v.add_child(bar)
	v.add_child(WB.ink("%d%s" % [int(round(fat)), "!" if fat >= WB.RED_AT or red else ""], UI.SMALL + 2, "handbold",
		WB.RED if red else WB.risk_colour(fat)))
	return pad


## The day's kind in the coach's shorthand: rest, hard, engine (conditioning), skill.
static func _kind(m: Array) -> String:
	if str(m[0]) == "rest":
		return "rest"
	if str(m[1]) == "hard":
		return "hard"
	return "engine" if str(WeekPlan.session(str(m[0]))["stat"]) == "conditioning" else "skill"


func _numbers(r: Dictionary) -> String:
	var nums := PackedStringArray()
	if str(r["stat"]) != "":
		nums.append("%s %+.2f" % [SHORT.get(str(r["stat"]), str(r["stat"])), float(r["gain"])])
	if str(r.get("stat2", "")) != "":
		nums.append("%s %+.2f" % [SHORT.get(str(r["stat2"]), str(r["stat2"])), float(r["gain2"])])
	nums.append("%+.2f kg" % float(r["kg"]))
	return ", ".join(nums)


## THIS CAMP: each goal line where the camp lands, the injury load, the week's twist on a sticky note.
func _camp(main: Node, f: Dictionary, goal: Dictionary, lines: Array) -> Control:
	var box := UI.vbox(10)
	box.name = "Goal"
	box.custom_minimum_size = Vector2(CAMP_W, 0)
	box.add_child(WB.ink("THIS CAMP", 34, "marker"))
	var fid := str(f["id"])
	for ln in lines:
		var id := str(ln["id"])
		var row := UI.hbox(10)
		var title := "WEIGHT" if id == "weight" else ("FATIGUE PEAK" if id == "fatigue" else str(Data.LABEL.get(id, ln["label"])).to_upper())
		row.add_child(WB.ink(title, 22, "marker"))
		var ok := bool(ln["ok"])
		if id == "weight":
			row.add_child(WB.ink("%.1f > %.1f kg" % [float(ln["now"]), float(ln["end"])], 22, "handbold"))
			row.add_child(WB.ink("ON TRACK" if ok else "%.1f OVER" % float(ln["short"]), 18, "marker", UI.GREEN if ok else WB.RED))
		elif id == "fatigue":
			row.add_child(WB.ink("%d" % int(round(float(ln["end"]))), 22, "handbold"))
			row.add_child(WB.ink("UNDER 80" if ok else "OVER 80", 18, "marker", UI.GREEN if ok else WB.RED))
		else:
			row.add_child(WB.ink("%.1f > %.1f" % [float(ln["now"]), float(ln["end"])], 22, "handbold"))
			row.add_child(WB.ink("ON TARGET" if ok else "%.1f SHORT" % float(ln["short"]), 18, "marker", UI.GREEN if ok else UI.AMBER))
		box.add_child(row)
		box.add_child(_line_under(main, fid, f, id, ln, int(goal["weeks"])))
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
	return box


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
	var t := WeekTwist.card(str(f.get("twist", "")))
	if t.is_empty():
		return null
	var note := WB.sticky()
	note.name = "Twist"
	var v := UI.vbox(6)
	note.add_child(v)
	v.add_child(WB.ink("TWIST: %s" % str(t["name"]).to_upper(), 24, "marker", WB.RED))
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
		var words := str(opt["label"]).to_upper() + ("  (coach)" if str(f.get("twist_pick", "")) == "" and a == shown else "")
		var b := UI.button(words, "PillOn" if a == shown else "Pill", main.act.bind("twistpick", "%s|%s" % [f["id"], a]))
		b.name = "TwistPick_" + a
		b.disabled = locked
		col.add_child(b)
		var w := WB.ink(str(opt["line"]), UI.SMALL, "hand", WB.INK if a == shown else WB.PENCIL, true)
		w.custom_minimum_size = Vector2((CAMP_W - 60) / 2.0, 0)
		col.add_child(w)
		row.add_child(col)
	v.add_child(row)
	if locked:
		v.add_child(WB.ink("answered - the week is running", UI.SMALL, "hand", WB.PENCIL))
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
	var reset := UI.button("Coach's week", "BtnQuiet", main.act.bind("weekreset", fid))
	reset.name = "WeekReset"
	reset.tooltip_text = "Undo your changes: back to the coach's week for this phase"
	row.add_child(reset)
	row.add_child(UI.spacer())
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
	row.add_child(go)
	v.add_child(row)
	return v
