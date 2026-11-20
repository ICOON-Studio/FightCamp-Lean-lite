extends RefCounted
## S387 (blind critic, the offers list 3/10: "no face, record, style or win chance"): one card per bout offer. The opponent's photo,
## name, record and style; the date and answer-by; the win band read off BoutRead; the gap, rank and ticket-cut chips; Open.

const UI := preload("res://scripts/ui/UI.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const CoachRead := preload("res://scripts/rules/CoachRead.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const HotStreak := preload("res://scripts/state/HotStreak.gd")
const Region := preload("res://scripts/state/Region.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

const PHOTO := Vector2(96, 120)
const BAND_W := 170.0


static func make(main: Node, c: Career, f: Dictionary, o: Dictionary) -> PanelContainer:
	var opp: Dictionary = o["opp"]
	var unsafe := bool(o["mismatch"])
	var card := PanelContainer.new()
	card.name = "Offer_" + str(o["id"])
	card.theme_type_variation = "Card"
	var h := UI.hbox(16)
	card.add_child(h)
	var photo := PromoShot.picture(str(Faces.pair(f, opp)[1]), PHOTO)
	if photo != null:
		h.add_child(photo)
	var who := UI.vbox(2)
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	who.add_child(UI.muted("%s's offer" % f["first"], UI.SMALL))
	who.add_child(UI.display(str(opp["name"]).to_upper(), 30))
	who.add_child(UI.label("%d-%d, %s, %s" % [opp["w"], opp["l"], opp["stance"], str(opp["style"]).to_lower()], UI.SMALL, UI.FG, "semi"))
	who.add_child(UI.label(_bio(opp), UI.SMALL, UI.MUTED, "body", true))
	who.add_child(UI.label(_read(opp), UI.SMALL, UI.FG, "body", true))
	var why := "Not safe: your boxer has %d bouts, the opponent %d" % [int(o["own_bouts"]), int(o["their_bouts"])]   # S448: names in the header only
	who.add_child(UI.label(why if unsafe else "%s, answer by %s" % [Clock.fmt(int(o["day"])), Clock.fmt(int(o["expires"]))],
		UI.SMALL, UI.RED if unsafe else UI.MUTED, "body", true))
	var chips := UI.hbox(6)
	for chip in BoutCompare.offer_chips(c, f, o):
		chips.add_child(chip)
	who.add_child(chips)
	who.add_child(coach_read(c, f, o))   # S531 THE COACH'S READ
	h.add_child(who)
	h.add_child(_band(c, f, o))
	var open := UI.button("Open", "BtnSolid" if not unsafe else "Btn", main.act.bind("openBout", o["id"]))
	open.name = "Open_" + str(o["id"])
	open.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(open)
	return card


## S391 C238 ("very little information is displayed on the fighters"): who she is, from what the booking shows.
static func _bio(opp: Dictionary) -> String:
	var bits: Array = []
	if opp.has("age"):
		bits.append("Age %d" % int(opp["age"]))
	if opp.has("height"):
		bits.append("%d cm" % int(opp["height"]))
	if opp.has("reach"):
		bits.append("reach %d cm" % int(opp["reach"]))
	if str(opp.get("club", "")) != "":
		bits.append(str(opp["club"]))
	return ", ".join(bits)


## Her game in words, and how much of her file is open: nothing here that scouting has not found.
static func _read(opp: Dictionary) -> String:
	var tells := OppFile.tells(opp)
	var game := ""
	for t in tells:
		if str(t["id"]) == "style":
			game = str(t["value"])
	var paid := tells.filter(func(t): return str(t["how"]) != "booking").size()
	var report := "Scouting report: %d of %d found" % [OppFile.found(opp).size(), paid]
	return report if game == "" else "%s. %s" % [game, report]


static func _band(c: Career, f: Dictionary, o: Dictionary) -> Control:
	var b := BoutRead.band(f, o["opp"], BoutRead.camp_for(f, int(o["day"]) - c.day), c.seed, float(c.coach.get("rating", 0.0)))   # S397 rank 3
	var lo := roundi(float(b["lo"]) * 100.0)
	var hi := roundi(float(b["hi"]) * 100.0)
	var v := UI.vbox(0)
	v.custom_minimum_size = Vector2(BAND_W, 0)
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	v.add_child(UI.caps("WIN CHANCE"))
	v.add_child(UI.label("%d%% to %d%%" % [lo, hi], 22, UI.GREEN if lo >= 50 else (UI.RED if hi <= 50 else UI.FG), "bold"))
	if hi - lo >= 30:   # BoutCompare.win_read: a band this wide is still a rough guess
		v.add_child(UI.muted("Camp film narrows it", UI.TINY))   # S442 UX audit: an amateur offer has no scout button; film in the camp opens the file
	return v


## S531 THE COACH'S READ: the head coach's verdict on this offer with one reason for and one against (CoachRead).
static func coach_read(c: Career, f: Dictionary, o: Dictionary) -> Label:
	var r := CoachRead.read(facts(c, f, o))
	var lab := UI.label(CoachRead.line(r, str(c.coach.get("name", "Coach")) if not c.coach.is_empty() else ""), UI.SMALL,
		{"go": UI.GREEN, "care": UI.AMBER, "stop": UI.RED}.get(str(r["tone"]), UI.FG), "semi", true)
	lab.name = "CoachRead_" + str(o["id"])
	return lab


static func facts(c: Career, f: Dictionary, o: Dictionary) -> Dictionary:
	var opp: Dictionary = o["opp"]
	var day := int(o["day"])
	var wf: Dictionary = Sim.weigh_forecast(c, f, day)
	var rows := Region.rankings(c, str(f["div"]))
	var g: Dictionary = f.get("goal", {})
	return {"gap": roundi(BoutRead.mismatch(f, opp, BoutRead.camp_for(f, day - c.day), c.seed)), "unsafe": bool(o["mismatch"]),
		"rest": BoutRules.days_since_bout(c.results, str(f["id"]), day), "over": 0.0 if bool(wf.get("ok", true)) else float(wf.get("over", 0.0)),
		"hot": HotStreak.hot(c, f), "streak_words": HotStreak.words(c, f), "her_rank": BoutRead.rank_of(rows, str(f["name"])),
		"opp_rank": BoutRead.rank_of(rows, str(opp["name"])), "goal": str(g.get("title", "")), "coach": not c.coach.is_empty(),
		"opp_style": str(opp.get("style", ""))}
