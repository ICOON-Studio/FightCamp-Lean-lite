extends VBoxContainer
## S496 TRAININGK1 (operator Q-S294-259 "Yes, build it"; C416 on the old tab: "remove this training picture from the
## game"): TRAINING, the club's week on one screen (Training K v6c, ops/AgentComms/board_attach/
## Q-S294-259_0_training_k_v6c_nobout.png). Reached from the gym floor's Training pin and every old "the week" link
## (Routes.canon sends the fighter page's Training tab here). The fighter strip on top (TrainCards); the selected boxer's
## Mon-Sun below (TrainGrid: the coach's evening, the morning, the evening), her tiredness and diet (TrainTired),
## the session tray (TrainTray); on the right THIS WEEK, MORNINGS, the selected evening, COACH'S PICK, CONTINUE (TrainSide).
## Numbers: ClubWeek.model. Edits go through the week's own acts (wday, weve, diet).
##   build(main)   act(main, name, arg) -> bool   static sel_day (the evening opened on the right)

const UI := preload("res://scripts/ui/UI.gd")
const ClubForecast := preload("res://scripts/state/ClubForecast.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const B := preload("res://scripts/ui/TrainBits.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const WeekData := preload("res://scripts/state/WeekData.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const TrainCards := preload("res://scripts/ui/TrainCards.gd")
const TrainGrid := preload("res://scripts/ui/TrainGrid.gd")
const TrainTired := preload("res://scripts/ui/TrainTired.gd")
const TrainSide := preload("res://scripts/ui/TrainSide.gd")
const TrainTray := preload("res://scripts/ui/TrainTray.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

static var sel_day := 0
var model: Dictionary = {}


func build(main: Node) -> void:
	name = "Training"
	add_theme_constant_override("separation", 10)
	var c: Career = main.career
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	var back := UI.button("Gym floor", "Link", main.act.bind("area", "home"))
	back.name = "BackToGym"
	head.add_child(back)
	head.add_child(B.lab("›", 20, Palette.MUTED, "bold"))
	head.add_child(B.caps("TRAINING", 26))
	add_child(head)
	if c.fighters.is_empty():
		add_child(B.lab("Sign a boxer first: the week is planned here once someone trains at the club.", 20, Palette.TEXT, "bold"))
		return
	var f := ClubWeek.pick(c, str(main.route.get("fighter", "")))
	var fid := str(f["id"])
	model = ClubWeek.model(c, fid, sel_day)
	var mon := int(model["monday"])
	var when := B.lab("%s  %s - %s" % ["NEXT WEEK" if mon > c.day else "THIS WEEK", Clock.fmt(mon), Clock.fmt(mon + 6)], 18, Palette.TEXT, "bold")
	when.name = "WeekWhen"
	when.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(when)
	if c.fighters.size() >= 2 and not c.coach.is_empty():   # S519 club week 3.7: the next 4 weeks of coach time
		head.add_child(_forecast(c))
	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 14)
	add_child(body)
	var left := VBoxContainer.new()
	left.name = "Board"
	left.add_theme_constant_override("separation", 10)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(left)
	left.add_child(TrainCards.make(model, func(id: String): main.act("tkpick", id)))
	var cb := {"am_drop": func(dow: int, id: String): main.act("tkam", "%s|%d|%s" % [fid, dow, id]),
		"pm_drop": func(dow: int, kind: String): main.act("weve", "%s|%d|%s" % [fid, dow, kind]),
		"level": func(dow: int, lvl: String): main.act("tklevel", "%s|%d|%s" % [fid, dow, lvl]),
		"day": func(dow: int): main.act("tkday", str(dow))}
	var mid := HBoxContainer.new()
	mid.add_theme_constant_override("separation", 8)
	mid.add_child(TrainGrid.make(model, cb, sel_day, f))
	mid.add_child(TrainSide.bout(model))
	left.add_child(mid)
	left.add_child(TrainTired.make(model, TrainGrid.LABEL_W, TrainGrid.COL_W, 8.0, func(k: String): main.act("diet", "%s|%s" % [fid, k])))
	left.add_child(TrainTray.make(Sim.week_ctx(c, f), _pads_night(model), bool((model["bout"] as Dictionary)["booked"])))
	var right := VBoxContainer.new()
	right.name = "Side"
	right.add_theme_constant_override("separation", 10)
	right.custom_minimum_size = Vector2(TrainSide.W, 0)
	body.add_child(right)
	right.add_child(TrainSide.this_week(model))
	right.add_child(TrainSide.mornings(model))
	right.add_child(TrainSide.evening(model, cb["day"], func(dow: int): main.act("tkclass", str(dow))))
	right.add_child(TrainSide.pick(model, func(): main.act("tkfix", fid)))
	var go := UI.button2("START THE WEEK", "play the days", "BtnSolid", main.act.bind("go_btn", ""), Vector2(TrainSide.W, 64),
		Palette.TEXT, Palette.TEXT, false, 26, 16)
	go.name = "StartWeek"
	right.add_child(go)


## A pad night on her first drilled card ([before, after]) for the tray's Pads value; [] when no pad night drills one.
static func _pads_night(m: Dictionary) -> Array:
	for d in m.get("days", []):
		var cards: Array = (d["pm"] as Dictionary)["cards"]
		if str((d["pm"] as Dictionary)["kind"]) == "pads" and not cards.is_empty():
			return [float(cards[0]["before"]), float(cards[0]["after"])]
	return []


## The Training screen's own acts; the week's edits reuse BoutActs' (wday, weve, diet).
static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"tkpick":
			if not c.grappler_by_id(arg).is_empty():   # S505: her week is the mat's - her page holds what the classes drill
				main.nav({"area": "fighters", "fighter": arg, "ftab": 0})
			else:
				main.nav({"area": "training", "fighter": arg})
		"tkday":
			sel_day = clampi(int(arg), 0, 6)
			main.render()
		"tkclass":   # S519 club week 3.2: a weekday evening to a class night and back
			if not c.coach.is_empty():
				var was := ClubClasses.on(c.coach, int(arg))
				ClubClasses.toggle(c.coach, int(arg))
				c.add_news(("Back to pads on %s evenings." if was else "The coach teaches a class on %s evenings: +$117 a week, the boxers on the bag.") % ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"][clampi(int(arg), 0, 4)])
			main.render()
		"tkam", "tklevel":
			# "fid|dow|session" (a session dropped on a morning, its effort kept) or "fid|dow|light|normal|hard"
			var p := arg.split("|")
			var f := c.fighter_by_id(p[0])
			if f.is_empty():
				return true
			var g := WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
			var now: Array = WeekPlan.days_of(g)[clampi(int(p[1]), 0, 6)]
			var sess := p[2] if name == "tkam" else str(now[0])
			var lvl := p[2] if name == "tklevel" else (str(now[1]) if str(now[0]) != "rest" else "normal")
			main.act("wday", "%s|%s|%s|%s" % [p[0], p[1], sess, lvl])
		"tkfix":
			# the coach's pick applied (WeekCoach.advice's fix: one morning, or the cut)
			var f := c.fighter_by_id(arg)
			var pl := WeekData.plan_of(c, f)
			var said: Array = pl["lines"] if WeekData.booked(pl["goal"]) else (pl["lines"] as Array).filter(func(l): return str(l["id"]) != "weight")
			var fix: Dictionary = load("res://scripts/rules/WeekCoach.gd").advice(pl["days"], pl["wk"], said, str((pl["ctx"] as Dictionary).get("diet", "hold")))["fix"]
			if fix.has("diet"):
				main.act("diet", "%s|cut" % arg)
			elif fix.has("dow"):
				main.act("wday", "%s|%d|%s|%s" % [arg, int(fix["dow"]), str(fix["card"][0]), str(fix["card"][1])])
		_:
			return false
	return true


## S519: four small blocks, one a coming week - fight weeks, the coach's film nights, class nights; amber when a boxer
## would watch film alone.
static func _forecast(c: Career) -> Control:
	var row := HBoxContainer.new()
	row.name = "Forecast"
	row.add_theme_constant_override("separation", 6)
	row.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(18, 0)
	row.add_child(gap)
	for w in ClubForecast.weeks(c, 4):
		var tone: Color = Palette.WARN if bool(w["risk"]) else (Palette.TEXT if int(w["fights"]) > 0 else Palette.MUTED)
		var p := PanelContainer.new()
		p.name = "Week_%d" % int(w["monday"])
		p.add_theme_stylebox_override("panel", B.panel(Palette.CARD, Palette.WARN if bool(w["risk"]) else Palette.LINE, 6, 6, 1))
		var l := B.lab("%s: %s" % [w["date"], w["words"]], 14, tone, "bold")
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(l)
		p.tooltip_text = "Week of %s: %s.%s" % [w["date"], w["words"], (" %d boxer%s watch the tape alone (half a read)." % [int(w["alone"]), "" if int(w["alone"]) == 1 else "s"]) if bool(w["risk"]) else ""]
		row.add_child(p)
	return row
