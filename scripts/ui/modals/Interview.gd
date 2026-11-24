extends PanelContainer
## The walk-in at reception. S408 operator: "there is not even a picture of the fighter you are signing, there is not even a single
## icon or graphics and tone of text with unreadable small letters": the coach's office fills the screen, the fighter's photo
## is pinned up large, and the card says who they are in big words (the detail is on hover).

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Data := preload("res://scripts/state/Data.gd")
const RecruitPanel := preload("res://scripts/ui/RecruitPanel.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const VisitWire := preload("res://scripts/state/VisitWire.gd")
const CardAsk := preload("res://scripts/rules/CardAsk.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Region := preload("res://scripts/state/Region.gd")
const Tip := preload("res://scripts/ui/Tip.gd")


func build(main: Node, m: Dictionary) -> void:
	custom_minimum_size = main.get_viewport_rect().size
	# S498 ONELOOK1 (operator: "some pictures ahve some dont"): the walk-in stands on the one gym wall at the house
	# exposure, like every page - no office photo of its own.
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	var wall := MenuFx.wall()
	wall.name = "PaintedWall"
	add_child(wall)
	var a: Dictionary = main.career.applicant
	var picks: Array = m["picks"]
	var middle := CenterContainer.new()
	add_child(middle)
	var row := UI.hbox(34)
	middle.add_child(row)
	var photo := _photo(a)
	row.add_child(photo)
	var card := PanelContainer.new()
	card.name = "WalkInCard"
	# The old card padded 30. slate() is 30 across and 26 down, so the frame sits in that pad and the card does not grow.
	card.add_theme_stylebox_override("panel", WoodKit.slate())
	row.add_child(card)
	var v := UI.vbox(12)
	card.add_child(v)
	# S533 P4PBUILD1 the visit: a boxer your boxer beat (CardAsk) - the last day in the header, the known club and place
	# on the ladder, what the trial told, and the three answers with their real cost (_visit_foot).
	var visit := bool(a.get("from_card", false))
	var t: Dictionary = VisitWire.terms(main.career) if visit else {}
	var head := UI.caps("ASKED AFTER THE BOUT - AT RECEPTION UNTIL %s" % Clock.fmt(int(t["expires"])).to_upper() if visit else "AT RECEPTION")
	head.name = "VisitUntil"
	v.add_child(head)
	v.add_child(UI.display(str(a["name"]).to_upper(), 58))
	v.add_child(UI.label("%d, %s, %s, amateur %d-%d, %s%s" % [a["age"], str(a["wc"]).to_lower(), a["stance"], a["w"], a["l"],
		str(a["style"]).to_lower(), _known(main.career, a) if visit else ""], UI.BODY + 2, UI.MUTED, "body", true))
	# S397 rank 5: each walk-in speaks for themself (FirstHour.walkin's quote); the first one's line stays.
	v.add_child(UI.label(str(a.get("quote", "\"I've had four fights at a church hall. I want a proper gym and a proper coach.\"")), UI.BODY + 2, UI.FG, "italic", true))
	if not visit:   # S545 KNOWBUILD1: the read the signing card shows - three ranges against the level (a walk-in has no dates: no strip)
		v.add_child(_reads(main.career, a))
	# S354 the reception as an RPG recruit (operator: "get it more rpg elements to this"): RecruitPanel.
	if visit and bool(t["trial_seen"]):
		var said := UI.label("Your coach, after the trial: \"%s\"" % str(Roster.trial_read(main.career, a)["verdict"]), UI.BODY + 2, UI.GOLD, "italic", true)
		said.name = "TrialSaid"
		v.add_child(said)
	elif visit and int(t["trial_booked"]) >= 0:
		v.add_child(UI.label("Trial on %s: your coach watches a morning. No place is held until you sign." % Clock.fmt(int(t["trial_booked"])), UI.BODY + 2, UI.MUTED, "body", true))
	v.add_child(RecruitPanel.build(main, main.career, a, picks, "pickcard"))
	var foot := UI.hbox(12)
	var blocked := str(t.get("blocked", ""))
	var terms := UI.label("Gym stipend, $250 a week", UI.BODY + 2, UI.FG, "bold")
	if visit:
		terms.text = ("No place free: %s. The visit stays open until %s." % [blocked, Clock.fmt(int(t["expires"]))]) if blocked != "" else (
			"Sign now: place %d of %d, gym stipend %s a week, training starts this week.%s" % [int(t["used"]) + 1, int(t["places"]), UI.money(int(t["stipend"])),
				" Trial first: your coach's read before you pay, but 1 time in 4 the old club talks the boxer round first." if int(t["trial_day"]) >= 0 else ""])
		terms.name = "VisitTerms"
	foot.add_child(terms)
	foot.add_child(UI.spacer())
	# S397 a later walk-in can be turned away (the first one is the club's only boxer: Pass keeps them waiting).
	var first: bool = main.career.fighters.is_empty()
	var pass_b := UI.button("Pass", "BtnQuiet", main.act.bind("passvisit" if visit else ("decline" if first else "passwalkin"), ""))
	pass_b.name = "Pass"
	foot.add_child(pass_b)
	if visit:
		Tip.button(pass_b, "Back to the old club: no place used, no stipend, and no new ask for %d days." % CardAsk.COOLDOWN_DAYS)
	if visit and int(t["trial_day"]) >= 0:
		var trial_b := UI.button("Trial first - %s" % Clock.fmt(int(t["trial_day"])), "Btn", main.act.bind("trialvisit", ""))
		trial_b.name = "Trial"
		Tip.button(trial_b, "Your coach watches a morning that Monday; 1 time in 4 the old club wins the boxer back first.")
		foot.add_child(trial_b)
	var focus := RecruitPanel.focus_of(picks)
	var ready := (focus != "" or picks.size() == 3) and blocked == ""
	var sign := UI.button("Sign - %s" % str(Recruit.FOCUS[focus]["name"]).to_lower() if focus != "" else
		("Sign" if ready else "Sign: choose a starting focus"), "BtnSolid",
		main.act.bind("signvisit" if visit else "sign", ""), not ready, (blocked if blocked != "" else "Choose one starting focus first") if not ready else "")
	sign.name = "Sign"
	sign.custom_minimum_size = Vector2(0, 52)
	if ready:
		MenuFx.hover_grow(sign)
		if visit:
			Tip.button(sign, "Takes place %d of %d and adds %s a week to the stipends; training starts this week." % [int(t["used"]) + 1, int(t["places"]), UI.money(int(t["stipend"]))])
	foot.add_child(sign)
	v.add_child(foot)
	if not m.get("shown", false):   # a pick rebuilds this modal: the entrance plays once
		m["shown"] = true
		MenuFx.pop(photo, 0.05)
		MenuFx.arrive([card], 0.12)


## S545 KNOWBUILD1: the walk-in's first look, the same knowledge the signed boxer starts with (KnowWire.start's seed).
func _reads(c: Career, a: Dictionary) -> Control:
	var K: GDScript = load("res://scripts/rules/Knowledge.gd")
	var PS: GDScript = load("res://scripts/ui/ProspectScene.gd")
	var k: Dictionary = K.fresh(absi(hash(str(a.get("id", a.get("name", ""))))))
	var r: Dictionary = load("res://scripts/rules/ProspectClock.gd").ranges(k, a)
	var lvl: float = load("res://scripts/state/ProspectWire.gd").level(c, str(a.get("div", "wlw")))
	var h := UI.hbox(28)
	h.name = "WalkInReads"
	for g in [["body", "BODY"], ["skills", "SKILLS"], ["ceiling", "CEILING"]]:
		h.add_child(PS.read_col(str(g[0]), str(g[1]), r[g[0]], lvl, "One look so far: training and bouts narrow it. White tick: the region's level.", 170.0))
	return h


## What is known of a visitor beyond the card: the club the boxer comes from and the place on the regional ladder.
func _known(c: Career, a: Dictionary) -> String:
	var club := str(a.get("club_before", ""))
	var rows: Array = Region.rankings(c, str(a.get("div", "")))
	var at := -1
	for i in rows.size():
		if str(rows[i]["name"]) == str(a.get("rival", a.get("name", ""))):
			at = i
	return "; from %s, %s" % [club if club != "" else "a club not known", ("no. %d of %d on the regional ladder" % [at + 1, rows.size()]) if at >= 0 else "not on the regional ladder"]


## The fighter's photo, pinned up slightly crooked, with the name written under it.
func _photo(a: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.name = "WalkInPhoto"
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.add_theme_stylebox_override("panel", WoodKit.slate(14, 14))   # S498: the house panel (was a white photo mount)
	var v := UI.vbox(10)
	p.add_child(v)
	var shot := PromoShot.picture(Faces.stem(a), Vector2(320, 360))
	if shot != null:
		v.add_child(shot)
	var n := UI.label(str(a["first"]), 40, WoodKit.INK, "marker")
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(n)
	return p
