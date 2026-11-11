extends RefCounted
## The two editors under the day tiles. They send the same acts the popovers sent (wday, weve, drill,
## undrill, padsplit, drillit). Nothing about what an edit does changes.
##   make(main, f, pl, tired, pack, dow, camp) -> HBox  MorningTitle is the session name

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")
const WeekTiles := preload("res://scripts/ui/WeekTiles.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")

const LEVELS := ["light", "normal", "hard"]
const LEVEL_WORDS := ["Light", "Normal", "Hard"]
const KINDS := ["pads", "sparring", "film", "rest"]
const KIND_WORDS := ["Pads", "Sparring", "Film", "Rest"]
const SHORT := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]


static func make(main: Node, f: Dictionary, pl: Dictionary, tired: Array, pack: Dictionary, dow: int, camp: Node) -> HBoxContainer:
	var row := UI.hbox(10)
	row.name = "Editors"
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var morning := _panel("MorningEditor")
	morning.size_flags_stretch_ratio = 5.0
	var evening := _panel("EveningEditor")
	evening.size_flags_stretch_ratio = 7.0
	row.add_child(morning)
	row.add_child(evening)
	_morning(morning.get_child(0), main, f, pl, tired, dow, camp, int(pack.get("usable", 0)))
	_evening(evening.get_child(0), main, f, pl, pack, dow)
	return row


static func _panel(node_name: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", WoodKit.slate(14, 10))
	p.add_child(UI.vbox(8))
	return p


static func _btn(text: String, variation: String, px: int, on_press: Callable) -> Button:
	var b := UI.button(text, variation, on_press)
	b.add_theme_font_size_override("font_size", px)
	return b


static func _morning(v: Node, main: Node, f: Dictionary, pl: Dictionary, tired: Array, dow: int, camp: Node, usable: int) -> void:
	var m: Array = (pl["days"] as Array)[dow]
	var sid := str(m[0])
	var lvl := "normal" if sid == "rest" else str(m[1])
	var ctx: Dictionary = pl["ctx"]
	var start := float(tired[dow][0])
	var fid := str(f["id"])
	var head := UI.hbox(10)
	v.add_child(head)
	head.add_child(_ico(WeekTiles.session_icon(sid), str(WeekPlan.session(sid)["name"])))
	var names := UI.vbox(0)
	var title := UI.label(str(WeekPlan.session(sid)["name"]), 40, WoodKit.HEAD, "bold")
	title.name = "MorningTitle"
	names.add_child(title)
	var day := UI.label(SHORT[dow], 26, WoodKit.INK, "bold")
	day.name = "MorningDay"
	names.add_child(day)
	head.add_child(names)
	var levels := UI.hbox(8)
	var costs := UI.hbox(8)
	var gains := UI.hbox(8)
	v.add_child(levels)
	v.add_child(costs)
	v.add_child(gains)
	for n in LEVELS.size():
		var key: String = LEVELS[n]
		var on: bool = key == lvl and sid != "rest"
		var b := _btn(LEVEL_WORDS[n], "PillOn" if on else "Btn", 28, _set_morning.bind(main, fid, dow, sid, key))
		b.disabled = sid == "rest"
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.tooltip_text = "Rest has no intensity." if sid == "rest" else LEVEL_WORDS[n]
		if camp != null and sid != "rest":
			b.mouse_entered.connect(_ghost.bind(camp, dow, [sid, key]))
			b.mouse_exited.connect(_ghost.bind(camp, dow, []))
		levels.add_child(b)
		var r := WeekPlan.day(sid, key, ctx, start)
		var cost := UI.label("+%d" % roundi(float(r["load"]) / WeekPlan.LOAD_PER_FATIGUE), 22, UI.RED, "bold")
		cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cost.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cost.tooltip_text = "Tiredness this morning adds."
		costs.add_child(cost)
		var gv := float(r["gain"]) if str(r["stat"]) != "" else 0.0
		var gl := UI.label("%+.2f" % gv, 22, UI.GREEN, "bold")
		gl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		gl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		gl.tooltip_text = WeekCards.gain_words(str(r["stat"]), gv) if str(r["stat"]) != "" else "No attribute this morning."
		gains.add_child(gl)
	var icons := UI.hbox(6)
	v.add_child(icons)
	for s in WeekPhase.SESSIONS + ["rest"]:
		var id := str(s)
		var ib := Button.new()
		ib.focus_mode = Control.FOCUS_NONE
		ib.custom_minimum_size = Vector2(46, 46)
		ib.icon = Icons.texture(WeekTiles.session_icon(id), 28)
		ib.tooltip_text = str(WeekPlan.session(id)["name"])
		for state in ["icon_normal_color", "icon_hover_color", "icon_pressed_color"]:
			ib.add_theme_color_override(state, WoodKit.HEAD if id == sid else WoodKit.INK)
		var edge := Color(WoodKit.HEAD if id == sid else WoodKit.SOFT, 1.0 if id == sid else 0.4)
		for st in ["normal", "hover", "pressed", "focus"]:
			ib.add_theme_stylebox_override(st, UI.box(Color(1, 1, 1, 0.05), edge, 8, 2, 2, 2))
		var use := "normal" if id == "rest" else lvl
		ib.pressed.connect(_set_morning.bind(main, fid, dow, id, use))
		if camp != null:
			ib.mouse_entered.connect(_ghost.bind(camp, dow, [id, use]))
			ib.mouse_exited.connect(_ghost.bind(camp, dow, []))
		icons.add_child(ib)
	_goal(v, f, pl, usable)


static func _goal(v: Node, f: Dictionary, pl: Dictionary, usable: int) -> void:
	var goal: Dictionary = pl["goal"]
	var stat := str(goal["stat"])
	var now := float((f["stats"] as Dictionary).get(stat, 50.0))
	var end := float(((pl["wk"] as Dictionary)["stats_end"] as Dictionary).get(stat, now))
	var line := UI.label("%s  %.1f → %.1f" % [WeekCards.label_of(stat), now, end], 26, WoodKit.INK, "bold")
	line.name = "GoalLine"
	var bits: PackedStringArray = PackedStringArray()
	var gains: Dictionary = (pl["wk"] as Dictionary)["gains"]
	for k in gains:
		if float(gains[k]) >= 0.005:
			bits.append(WeekCards.gain_words(str(k), float(gains[k])))
	var tip := ", ".join(bits)
	for ln in (pl["lines"] as Array):
		if str(ln["id"]) == stat:
			tip += "\nTarget %d. On pace for %.1f." % [roundi(float(ln["target"])), float(ln["end"])]
	var night := BoutRules.night_line_words(stat)
	if night != "":
		tip += "\n" + night
	if usable > 0:
		tip += "\n%d move%s reach%s Usable." % [usable, "" if usable == 1 else "s", "es" if usable == 1 else ""]
	line.tooltip_text = tip
	var row := UI.hbox(12)
	row.add_child(line)
	var gain := UI.label("%+.2f" % (end - now), 26, UI.GREEN, "bold")
	gain.tooltip_text = "This week's gain."
	row.add_child(gain)
	v.add_child(row)


static func _evening(v: Node, main: Node, f: Dictionary, pl: Dictionary, pack: Dictionary, dow: int) -> void:
	var fid := str(f["id"])
	var inp: Dictionary = pack["inp"]
	var nights: Dictionary = inp["nights"]
	var kind := "rest"
	if (nights.get("pads", []) as Array).has(dow):
		kind = "pads"
	elif (nights.get("spar", []) as Array).has(dow):
		kind = "sparring"
	elif int(nights.get("film", -1)) == dow:
		kind = "film"
	var head := UI.hbox(10)
	v.add_child(head)
	head.add_child(_ico(WeekTiles.evening_icon(kind), KIND_WORDS[KINDS.find(kind)]))
	var title := UI.label(KIND_WORDS[KINDS.find(kind)], 40, WoodKit.HEAD, "bold")
	title.name = "EveningTitle"
	head.add_child(title)
	head.add_child(UI.spacer())
	var kinds := UI.hbox(6)
	head.add_child(kinds)
	for n in KINDS.size():
		var key: String = KINDS[n]
		var b := _btn(KIND_WORDS[n], "PillOn" if key == kind else "Btn", 26, _set_eve.bind(main, fid, dow, key))
		b.name = "Eve_%s" % key
		b.icon = Icons.texture(WeekTiles.evening_icon(key), 26)
		b.tooltip_text = str((WeekPlan.EVENINGS.get(key, WeekPlan.EVENINGS["rest"]) as Dictionary)["name"])
		kinds.add_child(b)
	if kind != "pads":
		return
	var entries: Array = (inp["week"] as Dictionary).get(PadWeek.DAYS[dow], [])
	var mins := PadWeek.night_minutes(nights, dow)
	v.add_child(_split(main, fid, dow, entries, mins))
	var projs: Dictionary = pack["projs"]
	var rows: Dictionary = PadEdit.night_rows(f, projs)
	var on_now: Array = []
	for e in entries:
		var card := str((e as Dictionary)["card"])
		on_now.append(card)
		v.add_child(_drill_row(main, f, fid, dow, card, rows, projs, false))
	var tray := UI.vbox(6)
	v.add_child(tray)
	for c in (pack["cards"] as Array):
		var id := str(c)
		if on_now.has(id) or not PadWeek.drillable(f, id):
			continue
		tray.add_child(_drill_row(main, f, fid, dow, id, rows, projs, true))
	var combo := _btn("Combo", "Btn", 26, _combo.bind(main, fid))
	combo.tooltip_text = "Build a combination. Opens the Playbook."
	tray.add_child(combo)


static func _split(main: Node, fid: String, dow: int, entries: Array, mins: float) -> Control:
	if entries.size() < 2:
		var l := UI.label(str(roundi(mins)), 28, WoodKit.INK, "bold")
		l.name = "PadMinutes"
		l.tooltip_text = "Minutes on the pads."
		return l
	var row := UI.hbox(6)
	row.name = "SplitBar"
	for e in entries:
		var share := float((e as Dictionary)["share"])
		var b := _btn(str(roundi(mins * share)), "Btn", 26, _split_act.bind(main, fid, dow))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.size_flags_stretch_ratio = maxf(share, 0.15)
		b.tooltip_text = "Minutes on this drill. Click to change the split."
		row.add_child(b)
	return row


static func _drill_row(main: Node, f: Dictionary, fid: String, dow: int, card: String, rows: Dictionary, projs: Dictionary, add: bool) -> Control:
	var h := UI.hbox(8)
	var nm := UI.label(PadEdit.title(f, card), 24, WoodKit.INK, "bold")
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var proj: Dictionary = projs.get(card, {})
	var eta: Dictionary = proj.get("eta", {})
	nm.tooltip_text = str(eta.get("text", PadEdit.title(f, card)))
	h.add_child(nm)
	var one: Dictionary = rows.get(card, {})
	if one.has(dow):
		var g := UI.label("%d → %d" % [roundi(float(one[dow][0])), roundi(float(one[dow][1]))], 22, UI.GREEN, "bold")
		g.tooltip_text = "Mastery this night."
		h.add_child(g)
	var step := UI.label(MoveMastery.word(PadWeek.mastery(f, card)), 22, WoodKit.SOFT, "bold")
	step.tooltip_text = "Mastery step. " + MoveMastery.LADDER
	h.add_child(step)
	if add:
		var plus := _btn("+", "Btn", 28, _add.bind(main, fid, dow, card))
		plus.tooltip_text = "Put this drill on the night."
		h.add_child(plus)
		var drill := _btn("Drill", "Btn", 26, _drill_it.bind(main, fid, card))
		drill.tooltip_text = "Drill %s." % PadEdit.title(f, card)
		h.add_child(drill)
	else:
		var minus := _btn("−", "Btn", 28, _drop.bind(main, fid, dow, card))
		minus.name = "DropDrill"
		minus.tooltip_text = "Take this drill off the night."
		h.add_child(minus)
	var box := UI.vbox(4)
	box.name = "Drill_" + card.replace(":", "_").replace(" ", "_")
	box.add_child(h)
	var held := _held_line(main, f, fid, card, proj)
	if held != null:
		box.add_child(held)
	return box


## A combination a punch holds back: the same line and button the tray card had. The button drills the punch.
static func _held_line(main: Node, f: Dictionary, fid: String, card: String, proj: Dictionary) -> Control:
	var held: Array = proj.get("held_by", [])
	if held.is_empty():
		return null
	var m := PadWeek.mastery(f, card)
	var end := m
	var night: Dictionary = PadEdit.night_rows(f, {card: proj}).get(card, {})
	for d in night:
		end = maxf(end, float(night[d][1]))
	if m >= 30.0 and end + 20.0 < float(proj.get("cap", 100.0)):
		return null
	var punch := str(held[0])
	var line := UI.hbox(8)
	line.name = "Held"
	var words := UI.label("Held at %d by the %s" % [int(float(proj.get("cap", 100.0))), punch], 22, WoodKit.SOFT, "bold")
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.add_child(words)
	var go := _btn("Drill the %s" % punch, "Btn", 22, _drill_it.bind(main, fid, "move:" + punch))
	go.name = "DrillIt"
	go.tooltip_text = "Puts the %s on the next pad night not set yet." % punch
	line.add_child(go)
	return line


static func _ico(icon_name: String, tip: String) -> TextureRect:
	var r := Icons.icon(icon_name, 48, WoodKit.INK, tip)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


static func _set_morning(main: Node, fid: String, dow: int, sid: String, level: String) -> void:
	main.act("wday", "%s|%d|%s|%s" % [fid, dow, sid, level])


static func _set_eve(main: Node, fid: String, dow: int, kind: String) -> void:
	main.act("weve", "%s|%d|%s" % [fid, dow, kind])


static func _add(main: Node, fid: String, dow: int, card: String) -> void:
	main.act("drill", "%s|%d|%s" % [fid, dow, card])


static func _drop(main: Node, fid: String, dow: int, card: String) -> void:
	main.act("undrill", "%s|%d|%s" % [fid, dow, card])


static func _split_act(main: Node, fid: String, dow: int) -> void:
	main.act("padsplit", "%s|%d" % [fid, dow])


static func _drill_it(main: Node, fid: String, card: String) -> void:
	main.act("drillit", "%s|%s" % [fid, card])


static func _combo(main: Node, fid: String) -> void:
	Playbook.pick = fid
	ComboBuilder.chain = []
	main.act("go", "playbook:2")


static func _ghost(camp: Node, dow: int, card: Array) -> void:
	if camp != null:
		camp.call("ghost_day", dow, card)
