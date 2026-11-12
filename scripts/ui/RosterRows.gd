extends RefCounted
## PAGES2B: Fighters > Roster as painted rows (one wide row a fighter) from RosterRow.row. The Roster's default view
## (S440: the approved painting is what the player meets; the cards stay one click away). Header words in gold small
## caps; click a row = her page; the DO NEXT pin runs main.act for that need. Words a player cannot act on sit in the
## column's hover.
## S440 round 2 (fixer): the bottom key in words (best dot, the ticks, the level colours, needs you); Coach's second line
## (the no-gi athlete's drilled move); a not-entered open shown with its days and no tag; the mood bar in the painting's blue;
## the header tightened so the first row sits near the painting's y 190.
## S440 round 3 (Claude's rulings): "No bout" + when the next offers come; DO NEXT always one real button ("Plan the week"
## and Coach's Drill / Rest / Fix open the week planner on her); the no-gi weight cell names her class.

const Pulse := preload("res://scripts/ui/Pulse.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const Bits := preload("res://scripts/ui/RosterRowBits.gd")
const FighterPage := preload("res://scripts/ui/areas/FighterPage.gd")

const ROW_W := 1826.0
const ROW_H := 198.0
const NUM := 40
## Page-absolute column left edges from the painting, minus the shell's 28 px content margin.
const COLS := [
	["fighter", "FIGHTER", 18.0, 370.0],
	["overall", "OVERALL", 402.0, 300.0],
	["tiredness", "TIREDNESS", 716.0, 120.0],
	["weight", "WEIGHT", 844.0, 120.0],
	["mood", "MOOD", 974.0, 120.0],
	["coach", "COACH SAYS, THIS WEEK", 1104.0, 310.0],
	["next_fight", "NEXT FIGHT", 1424.0, 230.0],
	["do_next", "DO NEXT", 1662.0, 180.0],
]


static func build(main: Node, c: Career, foot: String = "") -> PanelContainer:
	# Dark plate so WoodKit.ink / SlateWalk read chalk words as on slate (rows themselves stay see-through).
	var wrap := PanelContainer.new()
	wrap.name = "RosterRows"
	wrap.add_theme_stylebox_override("panel", UI.box(Color(UI.DARK, 0.72), Color(0, 0, 0, 0), 12, 0, 4, 0))
	var v := UI.vbox(0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrap.add_child(v)
	v.add_child(_headers())
	var best: Dictionary = RosterRow.best_of(c)
	var ids: Array = []
	for f in c.fighters:
		ids.append(str(f["id"]))
	for g in c.grapplers:
		ids.append(str(g["id"]))
	for id in ids:
		var data: Dictionary = RosterRow.row(c, id)
		if data.is_empty():
			continue
		v.add_child(_row(main, id, data, best))
	# S442 owner ("slowly expand and shrink to draw players eyes"): only the first urgent DO NEXT on the page breathes.
	for pin in v.find_children("DoNext", "Button", true, false):
		if (pin as Button).theme_type_variation == "Go":
			Pulse.breathe(pin)
			break
	v.add_child(Bits.key_line(c.fighters.size() >= 2))
	if foot != "":
		var f_l := Bits.ink(foot, 16, WoodKit.SOFT)
		f_l.name = "Foot"
		v.add_child(f_l)
	return wrap


static func _headers() -> Control:
	var host := Control.new()
	host.name = "RowHeaders"
	host.custom_minimum_size = Vector2(ROW_W, 26)
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for col in COLS:
		var lab := Bits.ink(str(col[1]), 18, WoodKit.HEAD, "caps")
		lab.name = "Head_" + str(col[0])
		lab.position = Vector2(float(col[2]), 0)
		host.add_child(lab)
	return host


static func _row(main: Node, id: String, data: Dictionary, best: Dictionary) -> Control:
	var needs: bool = bool(data.get("needs_you", false))
	var b := PanelContainer.new()
	b.name = "Row_" + id
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.custom_minimum_size = Vector2(ROW_W, ROW_H)
	b.add_theme_stylebox_override("panel", Bits.need_wash() if needs else Bits.row_line())
	b.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			main.act("fighter", id))
	MenuFx.hover_grow(b, 1.005)
	var host := Control.new()
	host.name = "Cols"
	host.custom_minimum_size = Vector2(ROW_W, ROW_H)
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(host)
	host.add_child(_col_fighter(data.get("fighter", {}), needs, COLS[0]))
	host.add_child(_col_overall(data.get("overall", {}), best, id, COLS[1]))
	host.add_child(_col_meter("tiredness", data.get("tiredness", {}), 80.0, true, COLS[2],
		"Tiredness 0-100: too tired from 80 (the tick). Rest days bring it down."))
	host.add_child(_col_weight(data.get("weight", {}), COLS[3]))
	host.add_child(_col_meter("mood", data.get("mood", {}), -1.0, false, COLS[4],
		"Mood 0-100: Fired up, Steady, Flat or Low."))
	host.add_child(_col_coach(data.get("coach", {}), COLS[5]))
	host.add_child(_col_next(data.get("next_fight", {}), COLS[6]))
	host.add_child(_col_do(main, data.get("do_next", {}), COLS[7]))
	return b


## A column host: placed by the painting's x and width; PASS so its hover shows and a click still reaches the row.
static func _place(n: Control, key: String, col: Array, tip: String = "") -> Control:
	n.name = "Col_" + key
	n.position = Vector2(float(col[2]), 16)
	n.custom_minimum_size = Vector2(float(col[3]), ROW_H - 24)
	n.size = Vector2(float(col[3]), ROW_H - 24)
	n.mouse_filter = Control.MOUSE_FILTER_PASS
	n.tooltip_text = tip
	return n


static func _col_fighter(f: Dictionary, needs: bool, col: Array) -> Control:
	var box := HBoxContainer.new()
	var road := str(f.get("road_word", ""))
	# S442 UX audit: the road word is the step being worked on, not one reached ("3-1 Nationals ready" read as ready).
	if road != "" and road != "Pro" and not road.ends_with(" belt"):
		road = "Next: " + road
	_place(box, "fighter", col, "%s: %s" % [str(f.get("name", "")), road] if road != "" else "")
	box.add_theme_constant_override("separation", 12)
	box.add_child(Bits.face_pin(str(f.get("face", "")), needs))
	var who := UI.vbox(2)
	who.mouse_filter = Control.MOUSE_FILTER_IGNORE
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	who.add_child(Bits.name_plate(str(f.get("name", ""))))
	var wc := str(f.get("wc", ""))
	var age := int(f.get("age", 0))
	var sport := str(f.get("sport", "boxing"))
	var kind := wc if wc != "" else ("No-gi" if sport == "bjj" else "")
	who.add_child(Bits.ink("%s, %d" % [kind, age] if kind != "" else str(age), 18, WoodKit.SOFT, "body", true))
	var style := str(f.get("style", ""))
	var stance := str(f.get("stance", "")).to_lower()
	var line2 := style if stance == "" else ("%s, %s" % [style, stance] if style != "" else stance)
	if line2 != "":
		who.add_child(Bits.ink(line2, 18, WoodKit.INK, "semi", true))
	var rec := HBoxContainer.new()
	rec.add_theme_constant_override("separation", 10)
	rec.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var rec_l := Bits.ink(str(f.get("record_word", "")), 18, WoodKit.INK, "bold")
	rec_l.name = "Record"
	rec.add_child(rec_l)
	var road_l := Bits.ink(road, 18, WoodKit.HEAD, "semi", true)
	road_l.name = "Road"
	rec.add_child(road_l)
	who.add_child(rec)
	box.add_child(who)
	return box


static func _col_overall(o: Dictionary, best: Dictionary, id: String, col: Array) -> Control:
	var box := UI.vbox(4)
	_place(box, "overall", col, "Overall level 0-100 and the five groups it is measured from; a gold dot marks the best of the roster.")
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 6)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.add_child(Bits.overall_ring(int(o.get("ring", 0))))
	var bars := HBoxContainer.new()
	bars.name = "Bars"
	bars.add_theme_constant_override("separation", 0)
	bars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var groups: Dictionary = o.get("groups", {})
	var i := 0
	for gname in groups.keys():
		var gold: bool = str(best.get(str(gname), "")) == id
		bars.add_child(Bits.upright(str(gname), float(groups[gname]), gold, i % 2 == 1))
		i += 1
	top.add_child(bars)
	box.add_child(top)
	var bm: Dictionary = o.get("best_move", {})
	if not bm.is_empty():
		var move := "Best move: %s %d %s" % [str(bm.get("name", "")), int(round(float(bm.get("mastery", 0.0)))), str(bm.get("word", ""))]
		var bm_l := Bits.ink(move, 16, WoodKit.SOFT, "semi", true)
		bm_l.name = "BestMove"
		box.add_child(bm_l)
	return box


## The big number, its bar, its word (Tiredness, Mood).
static func _col_meter(key: String, d: Dictionary, tick_at: float, zone: bool, col: Array, tip: String) -> Control:
	var box := UI.vbox(6)
	_place(box, key, col, tip)
	var tone := str(d.get("tone", "ok"))
	var c := Bits.tone_col(tone)
	var val := float(d.get("value", 0.0))
	var num := Bits.ink(str(int(round(val))), NUM, c, "bold")
	num.name = "Big"
	box.add_child(num)
	# The painting's mood bar is blue while steady; a tone colour once it is good, low or high.
	var bar_c: Color = WoodKit.BLUE if key == "mood" and tone == "ok" else c
	box.add_child(Bits.tick_bar(val, tick_at, bar_c, zone))
	var word := Bits.ink(str(d.get("word", "")), 18, c if tone != "ok" else WoodKit.SOFT, "body", true)
	word.name = "Word"
	box.add_child(word)
	return box


static func _col_weight(d: Dictionary, col: Array) -> Control:
	var box := UI.vbox(6)
	var tone := str(d.get("tone", "ok"))
	if tone == "muted":   # the no-gi athlete: no weight is kept in today's rules, so her class and no kg
		_place(box, "weight", col, "The class on the mats. No weight is kept and no cut in today's rules.")
		var cls := Bits.ink(str(d.get("word", "")), 18, WoodKit.SOFT, "body")   # the caption style of the other words, never trimmed
		cls.name = "Word"
		box.add_child(cls)
		return box
	var kg := float(d.get("value", 0.0))
	var lim := float(d.get("limit", 0.0))
	var wi: bool = bool(d.get("weigh_in", false))
	_place(box, "weight", col, "Limit %.1f kg (the tick).%s" % [lim, " Weigh-in before the booked bout." if wi else " No weigh-in coming."])
	var c := Bits.tone_col(tone)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 4)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var num := Bits.ink("%.1f" % kg, NUM, c, "bold")
	num.name = "Big"
	top.add_child(num)
	var unit := Bits.ink("kg", 18, WoodKit.SOFT)
	unit.size_flags_vertical = Control.SIZE_SHRINK_END
	top.add_child(unit)
	box.add_child(top)
	# The bar fills to the weight against a ceiling a little over the limit, so the limit tick sits inside the track.
	var ceiling := lim * 1.15 if lim > 0.0 else 100.0
	box.add_child(Bits.tick_bar((kg / ceiling) * 100.0, (lim / ceiling) * 100.0 if lim > 0.0 else -1.0, c, false))
	# S442 UX audit: "59.8 kg on the day" did not fit the 120 px column ("59.8 kg on th..."); the short form, the long one on hover.
	var said := str(d.get("word", ""))
	var short := said.replace(" kg over on the day", " over").replace(" kg on the day", " kg")
	if short != said:
		short = "Day: " + short
		box.tooltip_text += " Fight day: %s." % said
	var word := Bits.ink(short, 18, c if tone == "bad" else WoodKit.SOFT, "body", true)
	word.name = "Word"
	box.add_child(word)
	return box


static func _col_coach(d: Dictionary, col: Array) -> Control:
	var box := UI.vbox(10)
	_place(box, "coach", col, str(d.get("why", "")))
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var said := Bits.ink(str(d.get("word", "")), 20, WoodKit.INK, "bold")
	said.name = "Said"
	top.add_child(said)
	var tag := str(d.get("tag", ""))
	if tag != "":
		top.add_child(Bits.tag_chip(tag))
	box.add_child(top)
	var sub := str(d.get("sub", ""))
	if sub != "":
		var sub_l := Bits.ink(sub, 18, WoodKit.SOFT, "semi", true)
		sub_l.name = "Sub"
		box.add_child(sub_l)
	var goal: Dictionary = d.get("goal", {})
	if goal.is_empty():
		return box
	var gbox := HBoxContainer.new()
	gbox.name = "Goal"
	gbox.add_theme_constant_override("separation", 10)
	gbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var cls := str(goal.get("cls", "green"))
	var gcol: Color = {"green": UI.GREEN, "amber": UI.AMBER, "muted": WoodKit.SOFT}.get(cls, UI.RED)
	var share := clampf(float(goal.get("share", 0.0)), 0.0, 1.0)
	gbox.add_child(Bits.goal_ring(share, str(int(round(share * 100.0))), gcol))
	var gv := UI.vbox(2)
	gv.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var title := Bits.ink("Goal: %s" % str(goal.get("title", "")), 18, WoodKit.INK, "semi", true)
	title.name = "GoalTitle"
	gv.add_child(title)
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 8)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var left := Bits.ink(str(goal["left_word"]) if goal.has("left_word") else "%d days left" % int(goal.get("left", 0)), 16, WoodKit.SOFT)
	left.name = "GoalLeft"
	if left.text != "":
		line.add_child(left)
	else:
		left.free()
	var st := Bits.ink(str(goal.get("status", "")), 16, gcol, "semi", true)
	st.name = "GoalStatus"
	line.add_child(st)
	gv.add_child(line)
	gbox.add_child(gv)
	box.add_child(gbox)
	return box


static func _col_next(d: Dictionary, col: Array) -> Control:
	var box := UI.vbox(4)
	var tag := str(d.get("tag", ""))
	var days := int(d.get("days", -1))
	if days < 0:
		var nxt := str(d.get("next_word", ""))
		_place(box, "next_fight", col, "Nothing booked. The next pair of offers comes on %s; answer it on the Fights page." % 			nxt.trim_prefix("next offers ") if nxt != "" else "Nothing booked: offers come in on the Fights page.")
		var none := Bits.ink(str(d.get("word", "")), 22, WoodKit.SOFT, "bold", true)
		none.name = "Word"
		box.add_child(none)
		if nxt != "":
			var nl := Bits.ink(nxt, 18, WoodKit.SOFT, "body", true)
			nl.name = "NextOffers"
			box.add_child(nl)
		return box
	var by := str(d.get("answer_by", ""))
	var word_tip := "Not entered yet: enter it on the Fights page or the athlete's page." if tag == "" else ""
	_place(box, "next_fight", col, "Answer by %s, or the offer goes." % by if by != "" else word_tip)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var num := Bits.ink(str(days), NUM, WoodKit.INK, "bold")
	num.name = "Big"
	top.add_child(num)
	var unit := Bits.ink("day" if days == 1 else "days", 18, WoodKit.SOFT)
	unit.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top.add_child(unit)
	if tag != "":
		top.add_child(Bits.tag_chip(tag))
	box.add_child(top)
	var opp := Bits.ink(("%s %s" % [str(d.get("opp_name", "")), str(d.get("opp_record", ""))]).strip_edges(), 18, WoodKit.INK, "bold", true)
	opp.name = "Opp"
	box.add_child(opp)
	var date := Bits.ink(str(d.get("date", "")), 16, WoodKit.SOFT, "body", true)
	date.name = "Date"
	box.add_child(date)
	if by != "":
		var ans := Bits.ink("answer by %s" % by, 16, UI.AMBER, "semi", true)
		ans.name = "AnswerBy"
		box.add_child(ans)
	var w_txt := str(d.get("word", ""))
	if w_txt != "":
		var wl := Bits.ink(w_txt, 18, UI.AMBER, "semi", true)
		wl.name = "Word"
		box.add_child(wl)
	return box


static func _col_do(main: Node, d: Dictionary, col: Array) -> Control:
	var box := CenterContainer.new()
	_place(box, "do_next", col, str(d.get("tip", "")))
	var words := str(d.get("words", d.get("label", "")))
	var act := str(d.get("act", ""))
	if words == "" or act == "":   # RosterRow always gives one; a row without one stays a plain click to her page
		return box
	var press := _press(main, act, str(d.get("arg", "")))
	var w := float(col[3])
	var pin: Button
	if bool(d.get("urgent", false)):
		pin = UI.button(words, "Go", press)
		pin.custom_minimum_size = Vector2(minf(w - 8.0, 180.0), 56)
	else:
		pin = UI.button(words, "Btn", press)
		pin.custom_minimum_size = Vector2(minf(w - 8.0, 160.0), 48)
	pin.name = "DoNext"
	pin.tooltip_text = str(d.get("tip", ""))
	box.add_child(pin)
	return box


## The pin's press: "planweek" opens the week planner (her page's Training tab, as "Plan the week" there does); any
## other act goes through main.act exactly as the same need does on Home.
static func _press(main: Node, act: String, arg: String) -> Callable:
	if act == "planweek":
		return func(): main.nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": FighterPage.TRAINING_TAB})
	return main.act.bind(act, arg)
