extends RefCounted
## S496 TRAININGK1: the Training screen's right side - THIS WEEK (each move the evenings drill: mastery Monday -> Sunday, the
## night it turns Usable or how far short), MORNINGS (the week's stat gains), the selected EVENING (the coach's minutes by
## face and what each boxer's move gets that night), COACH'S PICK (WeekCoach, his words) and CONTINUE; and the bout panel
## beside the week (no bout: the week is plain training; a bout: the night and the scale).
##   this_week(model)  mornings(model)  evening(model, on_day)  pick(model, on_fix)  go(main, model)  bout(model)

const B := preload("res://scripts/ui/TrainBits.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const TrainCoach := preload("res://scripts/ui/TrainCoach.gd")
const DAYS := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const SHORT := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
const W := 440.0


static func _box(name: String, title: String, sub: String) -> Array:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	h.add_child(B.caps(title, 22))
	var s := B.lab(sub, 16, Palette.MUTED, "bold")
	s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(s)
	v.add_child(h)
	var p := B.wrap(v, Palette.CARD, Palette.LINE, 12, 14)
	p.name = name
	p.custom_minimum_size = Vector2(W, 0)
	return [p, v]


static func this_week(model: Dictionary) -> PanelContainer:
	var bx := _box("ThisWeek", "NEXT WEEK" if bool(model.get("ahead", false)) else "THIS WEEK", "what the evenings teach")
	var v: VBoxContainer = bx[1]
	var moves: Array = model.get("moves", [])
	if moves.is_empty():
		v.add_child(B.lab("No pad night drills a move this week.", 16, Palette.MUTED, "body"))
	for mv in moves.slice(0, 3):
		var row := VBoxContainer.new()
		row.name = "Move_" + str(mv["card"]).replace(":", "_").replace(" ", "_")
		row.add_theme_constant_override("separation", 2)
		var top := HBoxContainer.new()
		var nm := B.lab(str(mv["title"]), 20, Palette.ELITE if float(mv["end"]) < B.USABLE else Palette.GOOD, "bold")
		nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top.add_child(nm)
		top.add_child(B.lab("%d → %d" % [roundi(float(mv["start"])), roundi(float(mv["end"]))], 22, Palette.TEXT, "bold"))
		row.add_child(top)
		var bar := B.MBar.new()
		bar.had = float(mv["start"])
		bar.now = float(mv["end"])
		bar.span = 60.0
		bar.custom_minimum_size = Vector2(0, 18)
		row.add_child(bar)
		var dow := int(mv["usable_dow"])
		var words := ""
		if dow >= 0:
			words = "✓ usable from %s" % SHORT[dow]
		elif float(mv["start"]) >= B.USABLE:
			words = "%s: kept sharp" % str(mv["word"])
		else:
			words = "%.1f short of Usable" % float(mv["short"])
		row.add_child(B.lab(words, 16, Palette.GOOD if dow >= 0 or float(mv["start"]) >= B.USABLE else Palette.MUTED, "bold"))
		v.add_child(row)
	var key := B.lab("Usable = thrown in a fight (30)", 16, Palette.MUTED, "body")
	key.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	key.custom_minimum_size = Vector2(W - 40, 0)
	v.add_child(key)
	return bx[0]


static func mornings(model: Dictionary) -> PanelContainer:
	var bx := _box("Mornings", "MORNINGS", "this week's stat gains")
	var v: VBoxContainer = bx[1]
	var t: Dictionary = model.get("totals", {"gains": {}, "sum": 0.0, "rest_drop": 0.0})
	var g := GridContainer.new()
	g.columns = 4
	g.add_theme_constant_override("h_separation", 18)
	g.add_theme_constant_override("v_separation", 2)
	var keys: Array = (t["gains"] as Dictionary).keys()
	keys.sort_custom(func(a, b): return float(t["gains"][a]) > float(t["gains"][b]))
	for k in keys:
		if float(t["gains"][k]) < 0.005:
			continue
		var n := B.lab(B.stat_word(str(k)), 18, Palette.ACCENT, "bold")
		n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		g.add_child(n)
		var val := B.lab("%+.2f" % float(t["gains"][k]), 20, Palette.GOOD, "bold")
		val.name = "Total_" + str(k)
		g.add_child(val)
	v.add_child(g)
	var foot := "Week total %+.2f" % float(t["sum"])
	if float(t["rest_drop"]) > 0.5:
		foot += " · rest day -%d tiredness" % roundi(float(t["rest_drop"]))
	var fl := B.lab(foot, 16, Palette.TEXT, "bold")
	fl.name = "WeekTotal"
	v.add_child(fl)
	if str(model.get("weak", "")) != "":   # S511 club week 3.3 WEAK SPOT: the morning focus that closes it is the player's
		var wl := B.lab(str(model["weak"]), 16, Palette.WARN, "bold")
		wl.name = "WeakSpot"
		wl.tooltip_text = "The lowest of the six fight abilities, 3 or more under this boxer's level. Mornings on it close the gap."
		v.add_child(wl)
	return bx[0]


static func evening(model: Dictionary, on_day: Callable, on_class: Callable = Callable()) -> PanelContainer:
	var n: Dictionary = model.get("night", {"dow": 0, "cell": {"kind": "none", "boxers": []}, "sides": []})
	var dow := int(n["dow"])
	var cell: Dictionary = n["cell"]
	var pads := str(cell["kind"]) == "pads"
	var bx := _box("Evening", "%s EVENING" % DAYS[dow].to_upper(), "%d min each" % roundi(float((cell["boxers"] as Array)[0]["min"])) if pads else "")
	var v: VBoxContainer = bx[1]
	(bx[0] as PanelContainer).add_theme_stylebox_override("panel", B.panel(Palette.CARD, Palette.CHOSEN, 12, 14, 2))
	var bar := TrainCoach.cell(cell, dow, str(model["sel"]), on_day, true)
	bar.name = "EveningCoach"
	v.add_child(bar)
	_class_button(v, str(cell["kind"]), dow, on_class)
	if not pads:
		v.add_child(B.lab({"spar": "Sparring night: your coach referees. Moves already usable get ring time.",
			"corner": "Bout night: your coach works the corner.", "closed": "Sunday: the gym is closed in the evening.",
			"class": "Class night: +$117 this week and new members over time; the boxers drill on the bag at half the rate."}.get(
			str(cell["kind"]), "No coached evening: rest."), 16, Palette.MUTED, "body"))
		var note := v.get_child(v.get_child_count() - 1) as Label
		note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART   # S519: a long note wraps, never widens the panel
		note.custom_minimum_size = Vector2(1, 0)
		return bx[0]
	var row := GridContainer.new()
	row.columns = mini(3, maxi(1, (n["sides"] as Array).size()))
	row.add_theme_constant_override("h_separation", 8)
	row.add_theme_constant_override("v_separation", 6)
	for s in n["sides"]:
		var sv := VBoxContainer.new()
		sv.add_theme_constant_override("separation", 2)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 6)
		h.add_child(B.face(str(s["stem"]), 26, Palette.CHOSEN if str(s["fid"]) == str(model["sel"]) else Palette.WOOD))
		var cd: Dictionary = s["card"]
		var top := B.lab("%d min" % roundi(float(s["min"])) + ("" if str(s["when"]) == "no bout booked" else " · " + str(s["when"])), 16, Palette.TEXT, "bold")
		top.clip_text = true
		top.tooltip_text = top.text
		top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(top)
		sv.add_child(h)
		if not cd.is_empty():
			var mv := B.lab(str(cd["title"]), 16, Palette.ELITE if float(cd["after"]) < B.USABLE else Palette.GOOD, "bold")
			mv.clip_text = true
			mv.tooltip_text = B.bar_tip(str(cd["title"]), float(cd["before"]), float(cd["after"]), false)
			sv.add_child(mv)
			var mb := B.MBar.new()
			mb.had = float(cd["before"])
			mb.now = float(cd["after"])
			mb.custom_minimum_size = Vector2(0, 14)
			sv.add_child(mb)
		var p := B.wrap(sv, Palette.TILE, Palette.LINE, 8, 6)
		p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(p)
	v.add_child(row)
	return bx[0]


static func pick(model: Dictionary, on_fix: Callable) -> PanelContainer:
	var ad: Dictionary = model.get("pick", {"say": "", "fix": {}})
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 4)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 12)
	h.add_child(B.face("mh_staff_coach", 60, Palette.WOOD))
	var words := VBoxContainer.new()
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.add_child(WB.ink("COACH'S PICK", 22, "marker", Palette.BAD_FILL))
	var say := WB.ink(str(ad["say"]), 22, "hand", Palette.PAGE, true)
	say.name = "CoachLine"
	words.add_child(say)
	if str(model.get("opp_prep", "")) != "":   # S527: what "your call" asks for (the tape's line, was only in a hidden box)
		var op := WB.ink(str(model["opp_prep"]), 18, "hand", Palette.PAGE, true)
		op.name = "OppPrep"
		words.add_child(op)
	h.add_child(words)
	v.add_child(h)
	v.add_child(B.lab("YOUR COACH", 16, Palette.WOOD, "bold"))
	for g in model.get("guard", []):   # S527: the camp's guard lines (GuardNotes), with a bout booked
		var gl := WB.ink(str(g), 16, "hand", Palette.PAGE, true)
		gl.name = "GuardNote"
		v.add_child(gl)
	if not (ad["fix"] as Dictionary).is_empty():
		var b := UI.button("Do it", "BtnSolid", on_fix)
		b.name = "CoachApply"
		b.size_flags_horizontal = Control.SIZE_SHRINK_END
		v.add_child(b)
	var p := B.wrap(v, Palette.TEXT, Palette.CHOSEN, 6, 14)
	p.name = "CoachPick"
	p.custom_minimum_size = Vector2(W, 0)
	return p


## The bout panel beside the week: no bout = the week is plain training; a bout = its night and her scale.
static func bout(model: Dictionary) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.name = "BoutPanel"
	v.custom_minimum_size = Vector2(160, 0)
	v.add_theme_constant_override("separation", 6)
	var bt: Dictionary = model.get("bout", {"booked": false})
	if not bool(bt["booked"]):
		var nb := B.lab("NO BOUT BOOKED", 18, Palette.BAD, "caps")
		nb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		nb.custom_minimum_size = Vector2(160, 0)
		v.add_child(nb)
		var l := B.lab("Base week: every evening is training.", 16, Palette.TEXT, "bold")
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size = Vector2(160, 0)
		v.add_child(l)
		return v
	var dow := int(bt["dow"])
	v.add_child(B.lab("FIGHT WEEK" if dow >= 0 else "BOUT AHEAD", 18, Palette.BAD, "caps"))
	var when := B.lab(("Bout %s" % SHORT[dow]) if dow >= 0 else Clock.fmt(int(bt["day"])), 16, Palette.TEXT, "bold")
	v.add_child(when)
	var d: Dictionary = model.get("diet", {})
	if d.has("fight_kg"):
		v.add_child(B.lab("scale %.1f / %.1f kg est." % [float(d["fight_kg"]), float(d["limit"])], 16, Palette.TEXT, "bold"))
	var t: Dictionary = model.get("tired", {})
	if t.has("bell"):
		v.add_child(B.lab("first bell %d est." % roundi(float(t["bell"])), 16, Palette.GOOD if float(t["bell"]) < float(t["fresh"]) else Palette.WARN, "bold"))
	for c in v.get_children():
		if c is Label:
			(c as Label).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			(c as Label).custom_minimum_size = Vector2(160, 0)
	return v


## S519 club week 3.2: a weekday pad evening can be a class night (+$117, boxers on the bag) and back. Mon-Fri only.
static func _class_button(v: VBoxContainer, kind: String, dow: int, on_class: Callable) -> void:
	if not on_class.is_valid() or dow > 4 or not (kind in ["pads", "class"]):
		return
	var b := Button.new()
	b.name = "ClassNight"
	b.text = "Back to pads tonight" if kind == "class" else "Teach a class tonight: +$117"
	b.tooltip_text = "A paying class instead of pads: +$117 a week and new members over time. The boxers drill on the bag at half the rate that evening." if kind == "pads" else "The coach holds pads again this evening: full drilling, no class money."
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size", 16)
	b.pressed.connect(func(): on_class.call(dow))
	v.add_child(b)
