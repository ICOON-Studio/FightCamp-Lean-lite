extends RefCounted
## S370 GOALTESTS1 (operator Q-S294-92 "Yes, build it"): her road on the Training tab - the six skills awards as a ladder
## (passed gold, next blue, the rest grey), what the next grade's assessment asks (8 coached sessions, its moves a weapon on
## the pads, Platinum a bout) with a bar for each, and her engine read as the bleep test: now, and where this week's plan
## takes it in four weeks (women's norms, SkillAwards). Every bar says what fills it.
##   make(career, fighter) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const TestDay := preload("res://scripts/rules/TestDay.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Clock := preload("res://scripts/state/Clock.gd")

const AHEAD_DAYS := 28


static func make(c: Career, f: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "AwardCard"
	p.theme_type_variation = "Card"
	var v := UI.vbox(8)
	p.add_child(v)
	var head := UI.hbox(10)
	head.add_child(UI.caps("THE ROAD: THE SKILLS AWARDS"))
	head.add_child(UI.muted("each grade: 8 coached sessions, then the coach's assessment - a medal and a certificate", UI.SMALL))
	v.add_child(head)
	v.add_child(_ladder(f))
	var pr := SkillAwards.progress(f)
	if bool(pr.get("done", false)):
		v.add_child(UI.label("Every award passed - Platinum on the wall.", UI.BODY, UI.GOLD, "bold"))
	else:
		v.add_child(_next(pr))
	v.add_child(UI.sep())
	if SkillAwards.bleep_known(Data.sex_of(f)):
		v.add_child(_engine(c, f))
		v.add_child(_wall(f))
	return p


## S371 the records wall: her best on each Sunday test, the beaten number beside it (Grok/Gemini: chalk through the old one).
static func _wall(f: Dictionary) -> HBoxContainer:
	var h := UI.hbox(18)
	h.name = "RecordsWall"
	h.add_child(UI.caps("RECORDS WALL"))
	var rows := TestDay.wall(f)
	var sex := Data.sex_of(f)
	if rows.is_empty():
		h.add_child(UI.muted("the first Sunday check-in writes the numbers up", UI.SMALL))
	for r in rows:
		var cell := UI.hbox(6)
		cell.add_child(UI.muted(str(r["name"]), UI.SMALL))
		cell.add_child(UI.label(TestDay.text(r), UI.BODY, UI.GOLD if float(r["prev"]) >= 0.0 else UI.FG, "bold"))
		# S373 Kalli K_CALIB1 Q3: the norm word for her own sex beside every number.
		var word := TestDay.norm(str(r["id"]), float(r["best"]), sex)
		if word != "":
			var w := UI.label(word, UI.SMALL, UI.GREEN if word == "ELITE" else (UI.GOLD if word == "CLUB" else UI.MUTED), "bold")
			w.name = "Norm_" + str(r["id"])
			cell.add_child(w)
		if float(r["prev"]) >= 0.0:
			var was := RichTextLabel.new()
			was.bbcode_enabled = true
			was.fit_content = true
			was.autowrap_mode = TextServer.AUTOWRAP_OFF
			was.text = "[s]%s[/s]" % (str(r["fmt"]) % float(r["prev"]))
			was.add_theme_color_override("default_color", UI.MUTED)
			cell.add_child(was)
		if float(r["best"]) > float(r["first"]) and float(r["first"]) != float(r["prev"]):  # not the chalked number twice
			cell.add_child(UI.label("day %d: %s" % [int(r["first_d"]), TestDay.text(r, "first")], UI.SMALL, UI.GREEN))
		h.add_child(cell)
	Tips.card(h, func(): return {"title": "Records wall", "rows": rows.map(func(r): return [str(r["name"]), TestDay.text(r) + " " + TestDay.norm(str(r["id"]), float(r["best"]), sex).to_lower(),
		("beat " + (str(r["fmt"]) % float(r["prev"]))) if float(r["prev"]) >= 0.0 else "first mark",
		"day %d: %s" % [int(r["first_d"]), TestDay.text(r, "first")]]),
		"means": "Every Sunday the coach times three tests: the bleep test (stamina), punches in 10 seconds, the average of three tries (speed) and the rear hand's force on the bag sensor (power). The word beside each number is where it sits for a %s: beginner, club or elite. A new best goes up in chalk and the old one is crossed out. Train the stat and the number moves - no luck in it." % ("man" if sex == "m" else "woman")})
	return h


## The six grades left to right: passed (gold, with the day), next (blue), still to come (grey).
static func _ladder(f: Dictionary) -> HBoxContainer:
	var h := UI.hbox(6)
	h.name = "AwardLadder"
	var done: Array = f.get("awards", [])
	var nxt := str(SkillAwards.next_award(f).get("id", ""))
	for a in SkillAwards.AWARDS:
		var id := str(a["id"])
		var when := ""
		for d in done:
			if str(d["id"]) == id:
				when = Clock.fmt(int(d["d"]))
		var key := "gold" if when != "" else ("" if id != nxt else "green")
		var chip := UI.chip(str(a["name"]).to_upper(), key)
		chip.name = "Award_" + id
		chip.mouse_filter = Control.MOUSE_FILTER_PASS
		chip.tooltip_text = "%s: %s.%s" % [a["name"], a["tests"], (" Passed %s." % when) if when != "" else ""]
		if when == "" and id != nxt:
			chip.modulate = Color(1, 1, 1, 0.55)
		h.add_child(chip)
	return h


## The next grade: what it tests, then one bar per requirement and whether the coach can assess her this Sunday.
static func _next(pr: Dictionary) -> VBoxContainer:
	var a: Dictionary = pr["award"]
	var v := UI.vbox(4)
	v.name = "AwardNext"
	var t := UI.hbox(10)
	t.add_child(UI.label("%s award" % a["name"], UI.BODY + 6, UI.FG, "display"))
	t.add_child(UI.muted("tests " + str(a["tests"]), UI.SMALL, true))
	v.add_child(t)
	v.add_child(_bar("Coached sessions", float(pr["sessions"]) / float(pr["need"]), "%d / %d" % [pr["sessions"], pr["need"]],
		int(pr["sessions"]) >= int(pr["need"]), "Pads-and-drills and sparring evenings with the coach count - set them on the week below.",
		int(pr["need"])))
	for m in pr["moves"]:
		v.add_child(_bar(str(m["name"]), clampf(float(m["now"]) / float(m["need"]), 0.0, 1.0), "%d / %d" % [int(m["now"]), int(m["need"])],
			bool(m["ok"]), "The %s on the pads: the coach marks it clean at %d. Pad time goes to the move being learned." % [str(m["name"]).to_lower(), int(m["need"])]))
	if bool(pr["bout"]):
		v.add_child(_bar("A skills bout in the ring", 1.0 if bool(pr["bout_ok"]) else 0.0, "done" if bool(pr["bout_ok"]) else "not yet",
			bool(pr["bout_ok"]), "One bout in the ring - FIGHTS > Offers."))
	var ready := bool(pr["ready"])
	v.add_child(UI.label("READY - the coach assesses on Sunday." if ready else "The coach assesses the first Sunday every bar is full.",
		UI.SMALL, UI.GREEN if ready else UI.MUTED, "bold" if ready else "body"))
	return v


## S375 `pips` > 0: one pip per counted thing (8 coached sessions = 8 pips), not the meter's usual ten.
static func _bar(name: String, frac: float, value: String, ok: bool, tip: String, pips := 0) -> HBoxContainer:
	var row := UI.stat_row(name, 0.0, ok, UI.GREEN if ok else UI.FG, "")
	var bar: Control = row.get_meta("bar")
	bar.frac = frac
	if pips > 0 and pips <= 24:
		bar.segments = pips
	(row.get_child(row.get_child_count() - 1) as Control).get_child(0).set("text", value)
	row.tooltip_text = tip
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	return row


## The engine as the bleep test (that sex's norms): now, and in four weeks on this week's plan. S434 CARDIO1: it reads
## conditioning, the mean of Stamina and Recovery, so the row says CARDIO (the group, CORE_LOOP C3), never Stamina.
static func _engine(c: Career, f: Dictionary) -> HBoxContainer:
	var h := UI.hbox(14)
	h.name = "Engine"
	var cond := float(f["stats"]["conditioning"])
	var sex := Data.sex_of(f)
	var now := SkillAwards.bleep(cond, sex)
	var per_day := float(Sim.daily_gain(c, f).get("conditioning", 0.0))
	var then := SkillAwards.bleep(minf(100.0, cond + per_day * AHEAD_DAYS), sex)
	var norms := SkillAwards.bleep_norms(sex)
	h.add_child(UI.caps("CARDIO: BLEEP TEST"))
	var lv := UI.label("level %.1f" % now, UI.BODY + 4, UI.FG, "bold")
	h.add_child(lv)
	h.add_child(UI.muted(SkillAwards.bleep_words(now, sex), UI.SMALL))
	h.add_child(UI.spacer())
	h.add_child(UI.label("in 4 weeks on this plan: %.1f" % then, UI.SMALL, UI.GREEN if then > now else UI.MUTED, "bold"))
	Tips.card(h, func(): return {"title": "Bleep test", "rows": [["Average adult %s (21-30)" % ("man" if sex == "m" else "woman"), "%.1f" % norms.x, "", ""],
		["A national team", "%.1f" % norms.y, "", ""], ["Level now", "%.1f" % now, "", ""], ["In 4 weeks", "%.1f" % then, "", ""]],
		"means": "20 m shuttles to a beep that speeds up; the level reached. It follows Stamina and Recovery together: change the week's roadwork and intervals and watch the 4-week number move."})
	return h
