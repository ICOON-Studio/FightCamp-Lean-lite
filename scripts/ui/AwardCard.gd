extends RefCounted
## S370 GOALTESTS1 (operator Q-S294-92 "Yes, build it"): her road on the Training tab - the six skills awards as a ladder
## (passed gold, next blue, the rest grey), what the next grade's assessment asks (8 coached sessions, its moves a weapon on
## the pads, Platinum a bout) with a bar for each, and her engine read as the bleep test: now, and where this week's plan
## takes it in four weeks (women's norms, SkillAwards). Every bar says what fills it.
##   make(career, fighter) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
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
	head.add_child(UI.caps("HER ROAD: THE SKILLS AWARDS"))
	head.add_child(UI.muted("each grade: 8 coached sessions, then the coach's assessment - a medal and a certificate", UI.SMALL))
	v.add_child(head)
	v.add_child(_ladder(f))
	var pr := SkillAwards.progress(f)
	if bool(pr.get("done", false)):
		v.add_child(UI.label("Every award passed - Platinum on the wall.", UI.BODY, UI.GOLD, "bold"))
	else:
		v.add_child(_next(pr))
	v.add_child(UI.sep())
	v.add_child(_engine(c, f))
	return p


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
		int(pr["sessions"]) >= int(pr["need"]), "Pads-and-drills and sparring evenings with the coach count - set them on the week below."))
	for m in pr["moves"]:
		v.add_child(_bar(str(m["name"]), clampf(float(m["now"]) / float(m["need"]), 0.0, 1.0), "%d / %d" % [int(m["now"]), int(m["need"])],
			bool(m["ok"]), "Her %s on the pads: the coach marks it clean at %d. Pad time goes to the move being learned." % [str(m["name"]).to_lower(), int(m["need"])]))
	if bool(pr["bout"]):
		v.add_child(_bar("A skills bout in the ring", 1.0 if bool(pr["bout_ok"]) else 0.0, "done" if bool(pr["bout_ok"]) else "not yet",
			bool(pr["bout_ok"]), "One bout in the ring - FIGHTS > Offers."))
	var ready := bool(pr["ready"])
	v.add_child(UI.label("READY - the coach assesses her on Sunday." if ready else "The coach assesses her the first Sunday every bar is full.",
		UI.SMALL, UI.GREEN if ready else UI.MUTED, "bold" if ready else "body"))
	return v


static func _bar(name: String, frac: float, value: String, ok: bool, tip: String) -> HBoxContainer:
	var row := UI.stat_row(name, 0.0, ok, UI.GREEN if ok else UI.FG, "")
	var bar: Control = row.get_meta("bar")
	bar.frac = frac
	(row.get_child(row.get_child_count() - 1) as Control).get_child(0).set("text", value)
	row.tooltip_text = tip
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	return row


## Her engine as the bleep test (women's norms): now, and in four weeks on this week's plan.
static func _engine(c: Career, f: Dictionary) -> HBoxContainer:
	var h := UI.hbox(14)
	h.name = "Engine"
	var cond := float(f["stats"]["conditioning"])
	var now := SkillAwards.bleep(cond)
	var per_day := float(Sim.daily_gain(c, f).get("conditioning", 0.0))
	var then := SkillAwards.bleep(minf(100.0, cond + per_day * AHEAD_DAYS))
	h.add_child(UI.caps("ENGINE: BLEEP TEST"))
	var lv := UI.label("level %.1f" % now, UI.BODY + 4, UI.FG, "bold")
	h.add_child(lv)
	h.add_child(UI.muted(SkillAwards.bleep_words(now), UI.SMALL))
	h.add_child(UI.spacer())
	h.add_child(UI.label("in 4 weeks on this plan: %.1f" % then, UI.SMALL, UI.GREEN if then > now else UI.MUTED, "bold"))
	Tips.card(h, func(): return {"title": "Bleep test", "rows": [["Average adult woman (21-30)", "%.1f" % SkillAwards.BLEEP_ADULT, "", ""],
		["A national team", "%.1f" % SkillAwards.BLEEP_NATIONAL, "", ""], ["Her level now", "%.1f" % now, "", ""], ["In 4 weeks", "%.1f" % then, "", ""]],
		"means": "20 m shuttles to a beep that speeds up; the level she reaches. It follows her conditioning: change the week's roadwork and intervals and watch the 4-week number move."})
	return h
