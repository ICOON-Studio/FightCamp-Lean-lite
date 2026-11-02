extends PanelContainer
## S354 CORE3 step 1 (operator: "when picking up the morning exercises it has to sum up gains/loses towards a goal [...]
## then the player adjust a bit the intesity to burn weight"; markups C210/C213 "make it a bit clearer what the player
## tunes here", C211/C212 the fatigue line "kind of weak diplay"): the fighter's Training tab. The goal - each line says
## what moves it and carries that dial; the week - seven mornings (session + Light/Normal/Hard, each card's numbers) and
## the evenings; a fatigue bar under every day. WeekPlan does the maths; BoutActs wday / spar / weekreset / diet / learn /
## combo take the clicks.
##   WeekBoard.make(main, career, fighter) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const DAY_W := 196.0
const WEEKS_NO_BOUT := 4
## Fatigue colours: green under 70, amber to 80, red at 80+ (overreached); a normal camp week sits in the 60s.
const AMBER_AT := 70.0
const DAYS := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
const SHORT := {"power": "power", "speed": "speed", "technique": "tech", "defense": "def", "conditioning": "cond",
	"fight_iq": "ring IQ", "chin": "chin"}


static func make(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var p := new()
	p.name = "WeekBoard"
	p.theme_type_variation = "Card"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p._build(main, c, f)
	return p


## The camp's goal: the class limit at the weigh-in, the main stat and its target, the weeks to fight night.
static func goal_of(c: Career, f: Dictionary) -> Dictionary:
	var stat := Sim.focus_of(c, f)
	var g: Dictionary = f.get("goal", {})
	var key := str(g.get("stat", g.get("key", "")))
	var now := float((f["stats"] as Dictionary).get(stat, 50.0))
	var target := floorf(now) + 2.0
	if key == stat and g.has("target"):
		target = float(g["target"])
	var bout: Dictionary = f.get("bout", {})
	var weeks := WEEKS_NO_BOUT
	if not bout.is_empty() and not bool(bout.get("done", false)):
		weeks = maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	return {"limit": float(f["limit"]), "stat": stat, "target": target, "weeks": weeks, "bout": bout}


func _build(main: Node, c: Career, f: Dictionary) -> void:
	var fid := str(f["id"])
	var v := UI.vbox(12)
	add_child(v)
	var goal := goal_of(c, f)
	var days := WeekPlan.days_of(f)
	var evs := WeekPlan.evenings_of(f)
	var ctx := Sim.week_ctx(c, f)
	var wk := WeekPlan.week(days, ctx, evs)
	var head := UI.hbox(16)
	head.add_child(UI.display("%s'S WEEK" % str(f["first"]).to_upper(), 40))
	var bout: Dictionary = goal["bout"]
	var when := "No bout booked: where the next %d weeks lead" % WEEKS_NO_BOUT if bout.is_empty() else \
		"%d weeks to fight night, %s vs %s" % [int(goal["weeks"]), Clock.fmt(int(bout["day"])), str(bout["opp"]["name"])]
	var sub := UI.muted(when, UI.BODY)
	sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(sub)
	v.add_child(head)
	v.add_child(_goal_card(main, f, goal, days, ctx, evs))
	v.add_child(UI.caps("2   THE WEEK - MORNINGS BUILD THE BODY (PICK A SESSION AND HOW HARD), EVENINGS SHARPEN THE MOVES"))
	var grid := GridContainer.new()
	grid.name = "Week"
	grid.columns = 7
	grid.add_theme_constant_override("h_separation", 8)
	for i in 7:
		grid.add_child(_day(main, fid, i, days[i], evs[i], wk["days"][i], (wk["red"] as Array).has(i)))
	v.add_child(grid)
	v.add_child(_evenings(main, c, f))


## 1  The goal: one line per target - where this week and the whole camp land, and the dial that moves it.
func _goal_card(main: Node, f: Dictionary, goal: Dictionary, days: Array, ctx: Dictionary, evs: Array) -> VBoxContainer:
	var box := UI.vbox(8)
	box.name = "Goal"
	box.add_child(UI.caps("1   THE GOAL - WHERE THIS WEEK'S PLAN LANDS, AND WHAT MOVES EACH LINE"))
	var lines := WeekPlan.goal_lines(goal, days, ctx, int(goal["weeks"]), evs)
	var fid := str(f["id"])
	for ln in lines:
		var row := UI.hbox(14)
		var name := UI.label(str(ln["label"]) if str(ln["id"]) != str(goal["stat"]) else str(Data.LABEL.get(goal["stat"], ln["label"])),
			UI.BODY, UI.FG, "bold")
		name.custom_minimum_size = Vector2(150, 0)
		row.add_child(name)
		var tr := _Track.new()
		tr.setup(float(ln["now"]), float(ln["week"]), float(ln["end"]), float(ln["target"]), str(ln["id"]) == "weight"
			or str(ln["id"]) == "fatigue", bool(ln["ok"]))
		row.add_child(tr)
		var nums := UI.label(_line_words(ln, goal), UI.SMALL, UI.GREEN if bool(ln["ok"]) else UI.AMBER, "body")
		nums.custom_minimum_size = Vector2(330, 0)
		row.add_child(nums)
		row.add_child(_dial(main, fid, f, str(ln["id"]), str(goal["stat"])))
		box.add_child(row)
	return box


func _line_words(ln: Dictionary, goal: Dictionary) -> String:
	var id := str(ln["id"])
	var weeks := int(goal["weeks"])
	if id == "weight":
		return "%.1f > %.1f kg this week, %.1f at the weigh-in (limit %.1f)%s" % [float(ln["now"]), float(ln["week"]),
			float(ln["end"]), float(ln["target"]), "" if bool(ln["ok"]) else ": %.1f kg over" % float(ln["short"])]
	if id == "fatigue":
		return "peaks at %d this week, %d over %d weeks (80+ = overreached)" % [int(ln["week"]), int(ln["end"]), weeks]
	return "%.1f > %.1f this week, %.1f in %d weeks (goal %d)%s" % [float(ln["now"]), float(ln["week"]), float(ln["end"]),
		weeks, int(ln["target"]), "" if bool(ln["ok"]) else ": %.1f short" % float(ln["short"])]


## The dial that moves a line, on the line (C210): the diet for weight, the mornings that build the stat, rest for fatigue.
func _dial(main: Node, fid: String, f: Dictionary, id: String, stat: String) -> Control:
	var h := UI.hbox(6)
	if id == "weight":
		h.add_child(UI.muted("Diet:", UI.SMALL))
		for d in [["hold", "Hold"], ["cut", "Cut"]]:
			var b := UI.button(str(d[1]), "ChoiceOn" if str(f["diet"]) == str(d[0]) else "Choice", main.act.bind("diet", "%s|%s" % [fid, d[0]]))
			b.name = "Diet_" + str(d[0])
			h.add_child(b)
		h.add_child(UI.muted("and Hard mornings burn more", UI.SMALL))
	elif id == "fatigue":
		h.add_child(UI.muted("Rest days and Light mornings bring it down; each sparring night adds", UI.SMALL))
	else:
		var builders := PackedStringArray()
		for s in WeekPlan.ORDER:
			if str(WeekPlan.session(str(s))["stat"]) == stat:
				builders.append(str(WeekPlan.session(str(s))["name"]))
		h.add_child(UI.muted("Built by %s mornings - make one Hard to push it" % " / ".join(builders), UI.SMALL))
	return h


## One day: the morning (session picker, Light/Normal/Hard, its numbers), the evening, the fatigue bar (C211).
func _day(main: Node, fid: String, i: int, m: Array, evening: String, r: Dictionary, red: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Day_%d" % i
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.PANEL if not red else Color(UI.RED, 0.08)
	sb.set_border_width_all(2 if red else 1)
	sb.border_color = UI.RED if red else UI.LINE
	sb.set_corner_radius_all(6)
	sb.set_content_margin_all(8)
	p.add_theme_stylebox_override("panel", sb)
	p.custom_minimum_size = Vector2(DAY_W, 0)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(4)
	p.add_child(v)
	v.add_child(UI.caps(DAYS[i] + ("   RED DAY" if red else "")))
	var pick := OptionButton.new()
	pick.name = "Session_%d" % i
	for s in WeekPlan.ORDER:
		pick.add_item(str(WeekPlan.session(str(s))["name"]))
	pick.select(maxi(0, WeekPlan.ORDER.find(str(m[0]))))
	pick.item_selected.connect(func(k): main.act("wday", "%s|%d|%s|%s" % [fid, i, WeekPlan.ORDER[k], str(m[1])]))
	v.add_child(pick)
	var it := UI.hbox(3)
	if str(m[0]) != "rest":
		for k in ["light", "normal", "hard"]:
			var b := UI.button(str(WeekPlan.INTENSITY[k]["label"]), "ChoiceOn" if str(m[1]) == k else "Choice",
				main.act.bind("wday", "%s|%d|%s|%s" % [fid, i, str(m[0]), k]))
			b.name = "Int_%d_%s" % [i, k]
			b.add_theme_font_size_override("font_size", UI.TINY)
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			it.add_child(b)
	v.add_child(it)
	var nums := PackedStringArray()
	if str(r["stat"]) != "":
		nums.append("%s %+.2f" % [SHORT.get(str(r["stat"]), str(r["stat"])), float(r["gain"])])
	if str(r.get("stat2", "")) != "":
		nums.append("%s %+.2f" % [SHORT.get(str(r["stat2"]), str(r["stat2"])), float(r["gain2"])])
	nums.append("%+.2f kg" % float(r["kg"]))
	var nl := UI.label("  ".join(nums), UI.TINY, UI.FG, "mono", true)
	nl.custom_minimum_size = Vector2(DAY_W - 20, 0)
	v.add_child(nl)
	var ev := UI.label("Evening: %s" % str((WeekPlan.EVENINGS.get(evening, WeekPlan.EVENINGS["rest"]) as Dictionary)["name"]),
		UI.TINY, UI.AMBER if evening == "sparring" else UI.MUTED, "body", true)
	ev.custom_minimum_size = Vector2(DAY_W - 20, 0)
	v.add_child(ev)
	var fat := float(r["fatigue"])
	var bar := _Fat.new()
	bar.value = fat
	v.add_child(bar)
	v.add_child(UI.label("fatigue %d" % int(round(fat)), UI.TINY, _fat_colour(fat), "bold"))
	return p


## 3  Evenings: sparring nights a week, the move on the pads, the combo; the coach's week.
func _evenings(main: Node, c: Career, f: Dictionary) -> VBoxContainer:
	var fid := str(f["id"])
	var box := UI.vbox(6)
	box.add_child(UI.caps("3   EVENINGS - PADS AND DRILLS EVERY NIGHT BUT SUNDAY; SPARRING NIGHTS TEST THE PLAN (REAL ROUNDS VS A PARTNER)"))
	var row := UI.hbox(10)
	row.add_child(UI.label("Sparring nights", UI.SMALL, UI.FG, "bold"))
	for n in 3:
		var b := UI.button("%d a week" % n, "ChoiceOn" if int(f.get("spar_nights", 1)) == n else "Choice", main.act.bind("spar", "%s|%d" % [fid, n]))
		b.name = "Spar_%d" % n
		row.add_child(b)
	row.add_child(UI.spacer())
	var moves: Dictionary = f["moves"]
	var learn := OptionButton.new()
	learn.name = "Learn_" + fid
	for mv in Data.MOVES:
		learn.add_item("%s (%s)" % [mv, MoveMastery.tier(float(moves[mv])).to_lower()])
	learn.select(maxi(0, Data.MOVES.find(str(f.get("learning", "")))))
	learn.item_selected.connect(func(i): main.act("learn", "%s|%s" % [fid, Data.MOVES[i]]))
	learn.tooltip_text = "Pad time on one new move: a weapon in 2-3 weeks"
	row.add_child(UI.label("Move on the pads", UI.SMALL, UI.FG, "bold"))
	row.add_child(learn)
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
	row.add_child(UI.label("Combo", UI.SMALL, UI.FG, "bold"))
	row.add_child(combo)
	var reset := UI.button("Coach's week", "BtnQuiet", main.act.bind("weekreset", fid))
	reset.name = "WeekReset"
	reset.tooltip_text = "Back to the coach's week: a camp's opening week that lands near the goal"
	row.add_child(reset)
	box.add_child(row)
	return box


static func _fat_colour(v: float) -> Color:
	return UI.GREEN if v < AMBER_AT else (UI.AMBER if v < WeekPlan.OVERREACHED else UI.RED)


## A goal line's track: where it is now, this week (solid), the whole camp (light), the target (black tick), an arrow at
## the camp's end in green (on target) or amber. low_good: weight and fatigue should go down.
class _Track extends Control:
	var now := 0.0
	var wk := 0.0
	var end := 0.0
	var target := 0.0
	var low_good := false
	var ok := false

	func setup(n: float, w: float, e: float, t: float, lg: bool, o: bool) -> void:
		now = n
		wk = w
		end = e
		target = t
		low_good = lg
		ok = o
		custom_minimum_size = Vector2(300, 22)
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _x(v: float) -> float:
		var lo := minf(minf(now, wk), minf(end, target))
		var hi := maxf(maxf(now, wk), maxf(end, target))
		var pad := maxf(0.5, (hi - lo) * 0.25)
		return clampf((v - (lo - pad)) / ((hi + pad) - (lo - pad)), 0.0, 1.0) * size.x

	func _draw() -> void:
		var y := size.y * 0.5
		draw_line(Vector2(0, y), Vector2(size.x, y), Color("#dfe6eb"), 10.0)
		draw_line(Vector2(_x(wk), y), Vector2(_x(end), y), Color("#9db8e6"), 10.0)
		draw_line(Vector2(_x(now), y), Vector2(_x(wk), y), Color("#2f6fdb"), 10.0)
		draw_line(Vector2(_x(target), 1), Vector2(_x(target), size.y - 1), Color("#22262e"), 3.0)
		var ex := _x(end)
		var col := Color("#23935d") if ok else Color("#d97a00")
		draw_colored_polygon(PackedVector2Array([Vector2(ex - 7, 0), Vector2(ex + 7, 0), Vector2(ex, 9)]), col)


## A day's fatigue: the bar filled to the value, green / amber / red, a tick at the 80 line.
class _Fat extends Control:
	var value := 0.0

	func _init() -> void:
		custom_minimum_size = Vector2(0, 12)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#dfe6eb"))
		var c := Color("#23935d") if value < 70.0 else (Color("#d97a00") if value < 80.0 else Color("#e2483d"))
		draw_rect(Rect2(Vector2.ZERO, Vector2(size.x * clampf(value / 100.0, 0.0, 1.0), size.y)), c)
		draw_line(Vector2(size.x * 0.8, 0), Vector2(size.x * 0.8, size.y), Color("#22262e"), 2.0)
