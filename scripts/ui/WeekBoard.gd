extends PanelContainer
## The fighter's Training tab, approach B: a tiredness curve, seven day tiles, the morning and evening
## editors, and the coach's bar. The old week strip stays in the tree (hidden) so earlier checks still find
## its cards. Editors send the same acts as the popovers. Numbers come from plan_of / tired_days.
##   make(main, career, fighter)   goal_of   plan_of   picking / picking_eve ("fid|dow", the selected day)

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const WeekDay := preload("res://scripts/ui/WeekDay.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")
const DrillTray := preload("res://scripts/ui/DrillTray.gd")
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
const WeekCamp := preload("res://scripts/ui/WeekCamp.gd")
const WeekTired := preload("res://scripts/ui/WeekTired.gd")
const WeekTiles := preload("res://scripts/ui/WeekTiles.gd")
const WeekEditors := preload("res://scripts/ui/WeekEditors.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")
const FaceFrame := preload("res://scripts/ui/FaceFrame.gd")

const WEEKS_NO_BOUT := 4
const COL_GAP := 12.0
const SHORT := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

static var picking := ""
static var picking_eve := ""

var _lines: Array = []
var _camp: Node = null


static func make(main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var p := new()
	p.name = "WeekBoard"
	p.theme_type_variation = "Card"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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
	var cg: Dictionary = (f.get("camp", {}) as Dictionary).get("goal", {})
	if str(cg.get("stat", "")) == stat:
		target = float(cg["target"])
	var bout: Dictionary = f.get("bout", {})
	var weeks := WEEKS_NO_BOUT
	if not bout.is_empty() and not bool(bout.get("done", false)):
		weeks = maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	var goal := {"stat": stat, "target": target, "weeks": weeks, "bout": bout}
	if not bout.is_empty() and not bool(bout.get("done", false)):
		goal["limit"] = float(f["limit"])
	return goal


static func plan_of(c: Career, f: Dictionary) -> Dictionary:
	if not bool(f.get("_ahead", false)):
		WeekPhase.ensure(f, c.day)
	var goal := goal_of(c, f)
	var tw := WeekTwist.active(f)
	var base := WeekPlan.days_of(f)
	var days := WeekTwist.days(tw, base)
	var evs := PadWeek.evenings(f)
	var ctx := Sim.week_ctx(c, f)
	var wk := WeekPlan.week(days, ctx, evs)
	var lines := WeekPlan.goal_lines(goal, days, ctx, int(goal["weeks"]), evs, PadWeek.ahead(f, c.day, int(goal["weeks"])))
	var bout: Dictionary = goal["bout"]
	if not bout.is_empty() and not bool(bout.get("done", false)):
		var opp := WeekOpp.line(bout["opp"], days, str(f.get("phase", "base")))
		if not opp.is_empty():
			lines.append(opp)
	return {"goal": goal, "base": base, "days": days, "evs": evs, "ctx": ctx, "wk": wk, "lines": lines}


static func teaching(f: Dictionary) -> bool:
	return WeekTwist.card(str(f.get("twist", ""))).has("a") and not bool(f.get("twist_locked", false)) \
		and str(f.get("twist_pick", "")) == "" and not bool(f.get("board_taught", false))


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


static func tired_days(pl: Dictionary) -> Array:
	var out: Array = []
	var prev := float((pl["ctx"] as Dictionary).get("fatigue", 20.0))
	for r in (pl["wk"] as Dictionary)["days"]:
		var start := prev * WeekPlan.FATIGUE_KEEP
		var end := float(r["fatigue"])
		out.append([start, end, maxf(0.0, end - start), float(r.get("load", 0.0)) / WeekPlan.LOAD_PER_FATIGUE])
		prev = end
	return out


static func shown_dow(fid: String) -> int:
	var key := picking if picking.begins_with(fid + "|") else picking_eve
	if key.begins_with(fid + "|"):
		return clampi(int(key.get_slice("|", 1)), 0, 6)
	return 0


static func _points(tired: Array) -> Array:
	var pts: Array = []
	for row in tired:
		pts.append(float(row[0]))
		pts.append(float(row[1]))
	return pts


func _build(main: Node, c: Career, f: Dictionary) -> void:
	var pl := plan_of(c, f)
	var goal: Dictionary = pl["goal"]
	_lines = pl["lines"]
	_camp = WeekCamp.make(main, f, goal, _lines, teaching(f), func(g: Dictionary) -> Array: return plan_of(c, g)["lines"])
	var tired := tired_days(pl)
	var pack := _pack(c, f)
	var fid := str(f["id"])
	var dow := shown_dow(fid)
	var v := UI.vbox(8)
	add_child(v)
	var curve := WeekTired.new()
	curve.name = "WeekTired"
	curve.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	curve.custom_minimum_size = Vector2(0, 220)
	curve.setup(_points(tired), dow, COL_GAP)
	v.add_child(curve)
	v.add_child(WeekTiles.make(pl["days"], pl["evs"], _fight_dow(c, f, goal), dow, COL_GAP, _pick.bind(main, fid)))
	v.add_child(WeekEditors.make(main, f, pl, tired, pack, dow, _camp))
	var twist := _twist_row(main, f)
	if twist != null:
		v.add_child(twist)
	v.add_child(_bottom(main, c, f, pl, goal))
	var legacy := Control.new()
	legacy.name = "Legacy"
	legacy.visible = false
	legacy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	legacy.add_child(_head(c, f, goal))
	legacy.add_child(_strip(main, c, f, pl, pack, tired))
	legacy.add_child(_camp)
	v.add_child(legacy)


func _pick(i: int, main: Node, fid: String) -> void:
	picking = "%s|%d" % [fid, i]
	picking_eve = ""
	main.render()


func _fight_dow(c: Career, f: Dictionary, goal: Dictionary) -> int:
	if not booked(goal):
		return -1
	var ahead := bool(f.get("_ahead", false))
	var mon := int(f["phase_day"]) if ahead else c.day - posmod(c.day, 7)
	var bd := int((goal["bout"] as Dictionary)["day"])
	return bd - mon if bd >= mon and bd < mon + 7 else -1


func _pack(c: Career, f: Dictionary) -> Dictionary:
	var inp := DrillWeek.inputs(c, f)
	var nights: Dictionary = inp["nights"]
	var week: Dictionary = inp["week"]
	var projs := PadWeek.project(f, nights, week, float(inp["skill"]), PadWeek.STATION_TIER, 8, inp["mults"], inp["carded"])
	var plan := PlanCards.active(f)
	var cards: Array = PlanCards.tray(f, week) if plan else PadEdit.tray(f, week)
	var usable := 0
	for held in cards:
		if not projs.has(held):
			projs[held] = PadEdit.idle(f, str(held))
	for one in projs:
		projs[one]["eta"] = PadEdit.eta(f, str(one), projs[one], week, nights.get("spar", []))
		projs[one]["pads"] = nights.get("pads", [])
		if cards.has(one) and not PadEdit.crossing(f, str(one), projs[one]).is_empty():
			usable += 1
	if plan:
		var fd := int((f["bout"] as Dictionary)["day"])
		PlanCards.dress(f, projs, c.day - posmod(c.day, 7), fd, PlanCards.fight_paths(f, inp, c.day, fd))
	return {"inp": inp, "projs": projs, "cards": cards, "usable": usable}


func _head(c: Career, f: Dictionary, goal: Dictionary) -> Control:
	var h := UI.hbox(24)
	h.name = "BoardHead"
	var bout: Dictionary = goal["bout"]
	if booked(goal):
		var left := UI.hbox(14)
		left.add_child(WB.ink("THIS WEEK", 34, "marker", UI.FG))
		var ph: Dictionary = WeekPhase.PHASES.get(str(f.get("phase", "base")), WeekPhase.PHASES["base"])
		var line := UI.label("%s - fight night %s, %d days" % [str(ph["name"]), Clock.fmt(int(bout["day"])), int(bout["day"]) - c.day], 20, UI.FG, "semi")
		line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left.add_child(line)
		h.add_child(left)
	else:
		var left2 := UI.hbox(14)
		var ahead := bool(f.get("_ahead", false))
		left2.add_child(WB.ink("NEXT WEEK" if ahead else "THIS WEEK", 34, "marker", UI.FG))
		var mon := int(f["phase_day"]) if ahead else c.day - posmod(c.day, 7)
		var dates := UI.label("%s - %s" % [Clock.fmt(mon), Clock.fmt(mon + 6)], 20, UI.FG, "semi")
		dates.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left2.add_child(dates)
		var nb := UI.label("No fight booked", 20, UI.MUTED, "body")
		nb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left2.add_child(nb)
		h.add_child(left2)
	h.add_child(UI.spacer())
	var g: Node = _camp.get("_gauge")
	if g != null and booked(goal):
		g.get_parent().remove_child(g)
		(g as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(g)
	return h


func _strip(main: Node, c: Career, f: Dictionary, pl: Dictionary, pack: Dictionary, tired: Array) -> Control:
	var fid := str(f["id"])
	var days: Array = pl["days"]
	var base: Array = pl["base"]
	var wk: Dictionary = pl["wk"]
	var changed: Dictionary = WeekPhase.edits(f).get("days", {})
	var coach := WeekPlan.coach_of(f)
	var monday := c.day - posmod(c.day, 7) + (7 if bool(f.get("_ahead", false)) else 0)
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
	for i in 7:
		var col := UI.vbox(8)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.custom_minimum_size.x = 150
		col.add_child(WeekDay.head(i, monday + i, changed.has(str(i)), coach[i], set_day, _ghost_day))
		var r: Dictionary = (wk["days"][i] as Dictionary).duplicate()
		var ctx: Dictionary = pl["ctx"]
		for k in [["stat", "gain"], ["stat2", "gain2"]]:
			if str(r.get(k[0], "")) != "" and str(r[k[0]]) == str(ctx.get("camp_stat", "")):
				r[k[1]] = float(r[k[1]]) * float(ctx.get("camp_mult", 1.0))
		var m: Array = days[i]
		var red: bool = (wk["red"] as Array).has(i)
		var card_fn := _magnet.bind(m, base[i], r, red, changed.has(str(i)), twist)
		col.add_child(WeekCards.am(i, m, base[i], r, float(tired[i][3]), float(tired[i][0]), goal_key, card_fn, open))
		var spec := _night_spec(main, f, i, pack)
		spec["cost"] = float(tired[i][2]) - float(tired[i][3])
		spec["key2"] = str(r.get("stat2", "")) if float(r.get("gain2", 0.0)) >= 0.005 else ""
		spec["gain2"] = float(r.get("gain2", 0.0))
		spec["on_open"] = open_eve
		col.add_child(WeekDay.pm(spec))
		grid.add_child(col)
	return grid


func _night_spec(main: Node, f: Dictionary, i: int, pack: Dictionary) -> Dictionary:
	var fid := str(f["id"])
	var inp: Dictionary = pack["inp"]
	var projs: Dictionary = pack["projs"]
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
	var spar_g: Array = []
	for card in rows:
		if kind == "sparring" and (rows[card] as Dictionary).has(i):
			spar.append(PadEdit.title(f, str(card)))
			var d := roundi(float(rows[card][i][1]) - float(rows[card][i][0]))
			if d > 0:
				spar_g.append("%s %+d" % [PadEdit.title(f, str(card)), d])
	var picked := DrillTray.picked_for(fid)
	return {"i": i, "kind": kind, "entries": (inp["week"] as Dictionary).get(PadWeek.DAYS[i], []), "rows": rows, "f": f,
		"chips": [], "picked": picked != "", "spar_cards": spar, "spar_gains": spar_g, "camp": PadWeek.in_camp(f),
		"partner": PlanCards.partner(f),
		"on_drop": func(dow: int, card: String): main.act("drill", "%s|%d|%s" % [fid, dow, card]),
		"on_click": func(dow: int): _place_picked(main, fid, dow),
		"on_clear": func(dow: int): main.act("undrill", "%s|%d" % [fid, dow]),
		"on_remove": func(dow: int, card: String): main.act("undrill", "%s|%d|%s" % [fid, dow, card]),
		"on_split": func(dow: int): main.act("padsplit", "%s|%d" % [fid, dow])}


static func _magnet(m: Array, planned: Array, r: Dictionary, red: bool, mine: bool, twist: String) -> Dictionary:
	return WeekDay.magnet_card(m, planned, r, red, mine, twist)


func _place_picked(main: Node, fid: String, dow: int) -> void:
	var now := DrillTray.picked_for(fid)
	if now != "":
		main.act("drill", "%s|%d|%s" % [fid, dow, now])


func _ghost_day(dow: int, card: Array) -> void:
	if _camp != null:
		_camp.call("ghost_day", dow, card)


func _twist_row(main: Node, f: Dictionary) -> Control:
	var t := WeekTwist.card_for(f)
	if t.is_empty() or not t.has("a") or bool(f.get("twist_locked", false)) or str(f.get("twist_pick", "")) != "":
		return null
	var p := PanelContainer.new()
	p.name = "TwistRow"
	p.add_theme_stylebox_override("panel", WoodKit.slate(12, 8))
	var h := UI.hbox(10)
	p.add_child(h)
	if teaching(f):
		var first := UI.label("Start here", 26, UI.RED, "bold")
		first.name = "StartHere"
		first.tooltip_text = "This is the coach's week. Change a day only if you disagree."
		h.add_child(first)
	var shown := WeekTwist.answer(f)
	for a in ["a", "b"]:
		var opt: Dictionary = t[a]
		var b := _press(str(opt["label"]), "PillOn" if a == shown else "Btn", 26,
			main.act.bind("twistpick", "%s|%s" % [f["id"], a]))
		b.name = "TwistGo_" + a
		b.tooltip_text = str(opt["line"])
		if a == shown and str(f.get("twist_pick", "")) == "":
			b.tooltip_text += "\nCoach's pick."
		h.add_child(b)
	return p


func _bottom(main: Node, c: Career, f: Dictionary, pl: Dictionary, goal: Dictionary) -> Control:
	var bar := PanelContainer.new()
	bar.name = "WeekBar"
	bar.add_theme_stylebox_override("panel", WoodKit.slate(12, 6))
	var h := UI.hbox(10)
	bar.add_child(h)
	var face := TextureRect.new()
	face.name = "CoachFace"
	face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var coach: Texture2D = load("res://assets/ui/face/mh_staff_coach.jpg")
	face.texture = coach
	FaceFrame.fit(face, FaceFrame.box_for(coach), Vector2(52, 52))
	h.add_child(face)
	var who := UI.label("Coach", 22, WoodKit.HEAD, "bold")
	who.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(who)
	var fid := str(f["id"])
	var said: Array = _lines if not (f.get("bout", {}) as Dictionary).is_empty() else _lines.filter(func(l): return str(l["id"]) != "weight")
	var ad := WeekCoach.advice(pl["days"], pl["wk"], said, str((pl["ctx"] as Dictionary).get("diet", "hold")))
	var fix: Dictionary = ad["fix"]
	var note := UI.label(_coach_short(pl, fix), 22, WoodKit.INK, "bold")
	note.name = "CoachLine"
	note.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	note.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	note.tooltip_text = "\"%s\"%s" % [str(ad["say"]), _fix_effect(pl, fix)]
	h.add_child(note)
	if not fix.is_empty():
		var arg := "%s|cut" % fid if fix.has("diet") else "%s|%d|%s|%s" % [fid, int(fix["dow"]), str(fix["card"][0]), str(fix["card"][1])]
		var apply := _press("Do it", "BtnSolid", 28, main.act.bind("diet" if fix.has("diet") else "wday", arg))
		apply.name = "CoachApply"
		h.add_child(apply)
	var mine := not WeekPhase.edits(f).is_empty() and (not (WeekPhase.edits(f).get("days", {}) as Dictionary).is_empty()
		or not (WeekPhase.edits(f).get("eve", {}) as Dictionary).is_empty() or WeekPhase.edits(f).has("spar"))
	var reset := _press("Leave", "Btn", 26, main.act.bind("weekreset", fid))
	reset.name = "WeekReset"
	reset.disabled = not mine
	reset.tooltip_text = "This is the coach's week." if not mine else "Back to the coach's week."
	h.add_child(reset)
	h.add_child(UI.spacer())
	if booked(goal):
		var wlab := UI.label("%.1f / %.1f kg" % [float(f["weight"]), float(f["limit"])], 22, WoodKit.INK, "bold")
		wlab.name = "WeightNow"
		wlab.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var fc := WeekCamp.forecast(c, f, goal)
		var d := GaugeRow.read(fc, f, c.day)
		wlab.tooltip_text = "Tiredness %.0f, %s. Tank %.0f at the first bell. Scale %.1f kg. Risk %.1f%%." % [float(d["legs"]),
			str((d["legs_band"] as Dictionary)["tired"]), float(d["tank"]), float(d["kg"]), float(d["injury"]) * 100.0]
		h.add_child(wlab)
		var diet := str(f.get("diet", "hold"))
		var hold := _press("Hold", "PillOn" if diet == "hold" else "Btn", 26, main.act.bind("diet", "%s|hold" % fid))
		hold.name = "HoldBtn"
		h.add_child(hold)
		var cut := _press("Cut", "PillOn" if diet == "cut" else "Btn", 26, main.act.bind("diet", "%s|cut" % fid))
		cut.name = "CutBtn"
		cut.tooltip_text = "Cut 500 kcal a day."
		h.add_child(cut)
	var go := _press("Start week", "BtnSolid", 28, main.act.bind("go_btn", ""))
	go.name = "StartWeek"
	go.tooltip_text = "Play the days."
	h.add_child(go)
	return bar


func _coach_short(pl: Dictionary, fix: Dictionary) -> String:
	if fix.is_empty():
		return "Leave it"
	if fix.has("diet"):
		return "Cut"
	var dow := int(fix["dow"])
	var name := str(WeekPlan.session(str(fix["card"][0]))["name"])
	if str(fix["card"][0]) != "rest":
		name = "%s %s" % [name, str(fix["card"][1]).capitalize()]
	var days: Array = (pl["days"] as Array).duplicate(true)
	days[dow] = [str(fix["card"][0]), str(fix["card"][1])]
	var wk2 := WeekPlan.week(days, pl["ctx"], pl["evs"])
	var a := roundi(float((pl["wk"] as Dictionary)["peak"]))
	var b := roundi(float(wk2["peak"]))
	var bit := "%s → %s" % [SHORT[dow], name]
	if a != b:
		bit += "   %d → %d" % [a, b]
	return bit


static func _press(text: String, variation: String, px: int, on_press: Callable) -> Button:
	var b := UI.button(text, variation, on_press)
	b.add_theme_font_size_override("font_size", px)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b


static func _fix_effect(pl: Dictionary, fix: Dictionary) -> String:
	if not fix.has("dow"):
		return ""
	var days: Array = (pl["days"] as Array).duplicate(true)
	days[int(fix["dow"])] = [str(fix["card"][0]), str(fix["card"][1])]
	var wk2 := WeekPlan.week(days, pl["ctx"], pl["evs"])
	var wk: Dictionary = pl["wk"]
	var stat := str((pl["goal"] as Dictionary)["stat"])
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
