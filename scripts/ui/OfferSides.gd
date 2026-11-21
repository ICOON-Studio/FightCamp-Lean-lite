extends RefCounted
## S535 OFFERBUILD1 (owner Q-S294-296 "Yes, build it"; mockup ops/previews/s535_offer_mockup/offer.png): the three slates
## beside the bout offer's letter (OfferLetter). Left, our boxer and what a pass costs; right, the coach's read with the
## win range, and the opponent with WHAT DECIDES IT. Every number is the game's (TapeRows / TapeForm, BoutCompare.win_read,
## CoachRead, Sim.weigh_forecast, Bouts.pass_price); a fact not known reads "not on tape". Names only in the two headers.
##   tape(c, f, opp, stem) -> rows by label + "_mine" / "_theirs" (the two forms)
##   mine(...) read(...) opponent(...) -> PanelContainer

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")
const ClubCrest := preload("res://scripts/rules/ClubCrest.gd")
const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const TapeForm := preload("res://scripts/state/TapeForm.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const CoachRead := preload("res://scripts/rules/CoachRead.gd")
const CoachReadWire := preload("res://scripts/state/CoachReadWire.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

const SIDE_W := 400.0
const RIGHT_W := 484.0
const PORTRAIT := Vector2(190, 292)
const UNKNOWN := TapeRows.WHY   # "not on tape"


## The tape's rows by label, read with both forms filled on COPIES (the offer page changes nothing in the career).
static func tape(c: Career, f: Dictionary, opp: Dictionary, her_cm: float) -> Dictionary:
	var mine := f.duplicate()
	mine["bout"] = {}
	TapeForm.fill(c, mine)
	var theirs := opp.duplicate()
	TapeForm.fill_opp(c, theirs)
	var by := {}
	for r in TapeRows.rows(mine, theirs, her_cm):
		by[str(r["label"])] = r
	by["_mine"] = TapeRows.form_of(mine)
	by["_theirs"] = TapeRows.form_of(theirs)
	return by


static func kg(n: float) -> String:
	return "%d" % int(round(n)) if is_equal_approx(n, round(n)) else "%.1f" % n


static func slate(name: String, w: float) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = name
	p.custom_minimum_size = Vector2(w, 0)
	p.add_theme_stylebox_override("panel", WoodKit.slate(24, 22))
	return p


static func rule(colour: Color = Color(Palette.MUTED, 0.28)) -> ColorRect:
	var line := ColorRect.new()
	line.color = colour
	line.custom_minimum_size = Vector2(0, 1)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return line


static func gap(px: float) -> Control:
	var g := Control.new()
	g.custom_minimum_size = Vector2(0, px)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return g


static func cap(text: String) -> Label:
	return UI.label(text, 16, WoodKit.HEAD, "caps")


static func word(text: String, colour: Color = Palette.TEXT) -> Label:
	return UI.label(text, 18, colour, "bold")


## The slate's header: the one place a name is written.
static func header(name: String, who: String, sub: String) -> VBoxContainer:
	var v := UI.vbox(2)
	var title := UI.label(who, 34, Palette.TEXT, "marker")
	title.name = name
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(title)
	v.add_child(UI.label(sub, 17, Palette.MUTED, "semi", true))
	return v


## One fact: a thin line, the key in small caps on the left, the value on the right.
static func fact(name: String, key: String, value: Control, tip: String = "") -> VBoxContainer:
	var v := UI.vbox(0)
	v.name = name
	v.add_child(rule())
	var h := UI.hbox(10)
	h.custom_minimum_size = Vector2(0, 40)
	var k := UI.label(key.to_upper(), 16, Palette.MUTED, "caps")
	k.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(k)
	value.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if value is Label:
		var l := value as Label
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	else:
		h.add_child(UI.spacer())
	h.add_child(value)
	v.add_child(h)
	Icons.tip(v, tip)
	return v


## The last five as marks, newest first: a win green, a loss red. Nothing kept: "not on tape"; no bouts: says so.
static func form(fm: Dictionary) -> Control:
	if not bool(fm["known"]):
		return word(UNKNOWN, Palette.MUTED)
	var marks: Array = fm["marks"]
	if marks.is_empty():
		return word(TapeRows.NO_BOUTS, Palette.MUTED)
	var h := UI.hbox(8)
	for m in marks:
		var kind := str(m).left(1)
		h.add_child(UI.label(str(m), 18, Palette.GOOD if kind == "W" else (Palette.BAD if kind == "L" else Palette.MUTED), "mono"))
	return h


static func streak(fm: Dictionary) -> Label:
	if not bool(fm["known"]):
		return word(UNKNOWN, Palette.MUTED)
	var marks: Array = fm["marks"]
	return word(TapeRows.NO_BOUTS, Palette.MUTED) if marks.is_empty() else word(TapeRows.streak(marks))


static func _picture(path: String, alpha: float) -> TextureRect:
	var t := TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.texture = load(path)
	t.modulate = Color(Palette.FULL, alpha)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return t


## Left: our boxer. The painted body on the club's crest, then the record, the form, shape and mood, the weigh-in forecast
## and what a pass costs.
static func mine(c: Career, f: Dictionary, o: Dictionary, wf: Dictionary, by: Dictionary, stem: String, crest: String) -> PanelContainer:
	var p := slate("OfferMine", SIDE_W)
	var v := UI.vbox(0)
	p.add_child(v)
	v.add_child(header("MineName", str(f["name"]), "%s · your fighter" % str(f["wc"])))
	var art := Control.new()
	art.name = "MineArt"
	art.custom_minimum_size = Vector2(0, 260)
	art.size_flags_vertical = Control.SIZE_EXPAND_FILL
	art.clip_contents = true
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var badge := _picture(ClubCrest.path(crest), 0.10)
	badge.offset_top = 40
	badge.offset_bottom = -120
	art.add_child(badge)
	var body := RosterCards.body(stem)
	if body != null:
		body.mouse_filter = Control.MOUSE_FILTER_IGNORE
		art.add_child(body)
	v.add_child(art)
	v.add_child(fact("Mine_Record", "Record", word(str(by["Record"]["left"]))))
	v.add_child(fact("Mine_Last5", "Last 5", form(by["_mine"]), "The newest bout first. (KO) is a bout that ended inside the distance."))
	v.add_child(fact("Mine_Streak", "Streak", streak(by["_mine"])))
	var tired: Array = WB_KIT.fatigue_word(FighterProfile.fatigue(f), false)
	v.add_child(fact("Mine_Shape", "Shape · Mood", word("%s · %s" % [str(tired[0]).capitalize(), FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))]),
		"How tired the boxer is today, and the mood. Both move before the night."))
	var lim := float(f["limit"])
	var scale := word("%s kg of %s: makes it" % [kg(float(wf["day"])), kg(lim)], Palette.GOOD)
	if not bool(wf["ok"]):
		scale = word("%s kg over the %s kg limit" % [kg(float(wf["over"])), kg(lim)], Palette.BAD)
	v.add_child(fact("Mine_Scale", "On the scale", scale, "The forecast for the weigh-in, the day before the bout, cutting from tomorrow. Missing weight calls the bout off."))
	var price := 0 if bool(o["answered"]) else Bouts.pass_price(c, f, o)
	var pass_word := word("costs nothing", Palette.MUTED) if price == 0 else word("loyalty %d: wants this fight" % price, Palette.WARN)
	v.add_child(fact("Mine_Pass", "If you pass", pass_word, "Loyalty is %d of 100 now. Under %d a boxer leaves the club." % [Loyalty.value(f), Loyalty.LEAVES_UNDER]))
	return p


## 0..1 on one track: the whole range the chance could be, the coach's middle as the bright mark, an even bout as the tick.
static func range_bar(lo: float, hi: float, mid: float) -> Control:
	var bar := Control.new()
	bar.name = "ReadRange"
	bar.custom_minimum_size = Vector2(0, 24)
	var track := Panel.new()
	track.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, Palette.LINE, 7, 1, 0, 0))
	track.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	track.offset_top = 5
	track.offset_bottom = -5
	track.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(track)
	var ramp := Gradient.new()
	ramp.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
	ramp.colors = PackedColorArray([Palette.BAD_FILL, Palette.WARN, Palette.GOOD_FILL])
	var tex := GradientTexture1D.new()
	tex.gradient = ramp
	var fill := TextureRect.new()
	fill.texture = tex
	fill.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fill.stretch_mode = TextureRect.STRETCH_SCALE
	fill.anchor_left = clampf(lo, 0.0, 1.0)
	fill.anchor_right = clampf(hi, 0.0, 1.0)
	fill.anchor_bottom = 1.0
	fill.offset_top = 6
	fill.offset_bottom = -6
	fill.modulate = Color(Palette.FULL, 0.8)
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(fill)
	for mark in [[0.5, 1.0, Palette.MUTED, 3.0], [clampf(mid, 0.0, 1.0), 4.0, Palette.TEXT, 0.0]]:
		var m := ColorRect.new()
		m.color = mark[2]
		m.anchor_left = float(mark[0])
		m.anchor_right = float(mark[0])
		m.anchor_bottom = 1.0
		m.offset_left = -float(mark[1]) / 2.0
		m.offset_right = float(mark[1]) / 2.0
		m.offset_top = float(mark[3])
		m.offset_bottom = -float(mark[3])
		m.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bar.add_child(m)
	Icons.tip(bar, "0 to 100%. The coloured stretch is everywhere the chance could be, the bright mark the coach's middle, the thin tick an even bout.")
	return bar


static func _read_line(name: String, key: String, colour: Color, text: String) -> HBoxContainer:
	var h := UI.hbox(10)
	h.name = name
	var k := UI.label(key.to_upper(), 16, colour, "caps")
	k.custom_minimum_size = Vector2(96, 0)
	h.add_child(k)
	h.add_child(UI.label(text, 17, Palette.TEXT, "semi", true))
	return h


## Right, top: the coach's read (CoachRead: the verdict, its checked gain and cost, how much is known) and the win chance
## with its whole range (BoutCompare.win_read). No coach hired: the same evidence as your estimate.
static func read(c: Career, f: Dictionary, o: Dictionary, opp: Dictionary) -> PanelContainer:
	var p := slate("OfferRead", RIGHT_W)
	var v := UI.vbox(8)
	p.add_child(v)
	var r := CoachRead.read(CoachReadWire.facts(c, f, o))
	var guess := bool(r["guess"])
	v.add_child(cap("YOUR ESTIMATE" if guess else "THE COACH'S READ"))
	var tone: Color = {"go": Palette.GOOD, "care": Palette.WARN, "stop": Palette.BAD}.get(str(r["tone"]), Palette.TEXT)
	var quote := UI.label(("%s." if guess else "\"%s.\"") % str(r["verdict"]), 23, tone, "hand", true)
	quote.name = "ReadQuote"
	v.add_child(quote)
	var win := BoutCompare.win_read(c, f, opp, BoutRead.camp_for(f, int(o["day"]) - c.day))
	var lo := int(win["lo"])
	var hi := int(win["hi"])
	var chance := UI.hbox(16)
	var num := UI.label("%d%%" % int(win["mid"]), 50, Palette.GOOD if lo >= 50 else (Palette.BAD if hi <= 50 else Palette.TEXT), "mono")
	num.name = "ReadWin"
	num.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	Icons.tip(num, "The middle of the range. The plan and the shouts on the night can beat it.")
	chance.add_child(num)
	var side := UI.vbox(2)
	side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	side.add_child(UI.label("Win chance: %s" % str(win["sure"]), 17, Palette.TEXT, "bold"))
	side.add_child(range_bar(lo / 100.0, hi / 100.0, int(win["mid"]) / 100.0))
	var more := " Scouting narrows it." if int(win["found"]) < int(win["all"]) else ""
	side.add_child(UI.label("Anywhere from %d%% to %d%%.%s" % [lo, hi, more], 16, Palette.MUTED, "body", true))
	chance.add_child(side)
	v.add_child(chance)
	v.add_child(_read_line("ReadGain", "Gain", Palette.GOOD, "%s." % str(r["gain"])))
	v.add_child(_read_line("ReadRisk", "Risk", Palette.BAD, "%s." % str(r["cost"])))
	var why := str(r["sure_words"]).get_slice("(", 1).trim_suffix(")")
	var record := "" if str(r["record"]) == "" else " %s." % str(r["record"])
	v.add_child(_read_line("ReadSure", "How sure", Palette.MUTED, "%d of 3: %s.%s" % [int(r["sure"]), why, record]))
	return p


## The opponent's picture, head to waist, fading into the slate.
static func _portrait(stem: String) -> Control:
	var box := Control.new()
	box.name = "OppArt"
	box.custom_minimum_size = PORTRAIT
	box.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	box.clip_contents = true
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var body := RosterCards.body(stem)
	if body != null:
		body.mouse_filter = Control.MOUSE_FILTER_IGNORE
		body.set_anchors_preset(Control.PRESET_TOP_LEFT)
		body.position = Vector2(-70, -6)
		body.size = Vector2(330, 640)
		if body is TextureRect:
			(body as TextureRect).stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		box.add_child(body)
	var ramp := Gradient.new()
	ramp.offsets = PackedFloat32Array([0.0, 1.0])
	ramp.colors = PackedColorArray([Color(Palette.CARD, 0.0), Palette.CARD])
	var tex := GradientTexture2D.new()
	tex.gradient = ramp
	tex.fill_from = Vector2(0, 0)
	tex.fill_to = Vector2(0, 1)
	var fade := TextureRect.new()
	fade.texture = tex
	fade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fade.stretch_mode = TextureRect.STRETCH_SCALE
	fade.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	fade.offset_top = -70
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(fade)
	return box


## One row of WHAT DECIDES IT: ours, the fact's name, theirs. The better side is green; an unknown side says so.
static func _versus_row(name: String, title: String, left: String, right: String, better: String) -> VBoxContainer:
	var v := UI.vbox(0)
	v.name = name
	v.add_child(rule())
	var h := UI.hbox(0)
	h.custom_minimum_size = Vector2(0, 44)
	for cell in [[left, "left"], [title, ""], [right, "right"]]:
		var mid := str(cell[1]) == ""
		var text := str(cell[0])
		var unknown := text == TapeRows.MISSING
		var l := UI.label(UNKNOWN if unknown else text, 16 if mid else (17 if unknown else 21),
			Palette.MUTED if mid or unknown else (Palette.GOOD if better == str(cell[1]) else Palette.TEXT), "caps" if mid else "bold")
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if mid:
			l.custom_minimum_size = Vector2(150, 0)
		else:
			l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(l)
	v.add_child(h)
	return v


static func _more(a: int, b: int) -> String:
	return "" if a == b else ("left" if a > b else "right")


## Right, under the read: the opponent. What the booking shows (form, style), the best punch once tape has found it, the
## three facts that decide it, and how much of the file is open.
static func opponent(f: Dictionary, o: Dictionary, opp: Dictionary, by: Dictionary, stem: String) -> PanelContainer:
	var p := slate("OfferOpp", RIGHT_W)
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var v := UI.vbox(0)
	p.add_child(v)
	var top := UI.hbox(12)
	var facts := UI.vbox(0)
	facts.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	facts.add_child(header("OppName", str(opp["name"]), "%s · %s" % [str(f["wc"]), str(opp["club"])]))
	facts.add_child(gap(10))
	facts.add_child(fact("Opp_Last5", "Last 5", form(by["_theirs"]), "The newest bout first. (KO) is a bout that ended inside the distance."))
	facts.add_child(fact("Opp_Streak", "Streak", streak(by["_theirs"])))
	var style := str(opp.get("style", "")).strip_edges()
	facts.add_child(fact("Opp_Style", "Style", word(style) if style != "" else word(UNKNOWN, Palette.MUTED)))
	var found := OppFile.known(opp, "weapon") and str(opp.get("threat", "")) != ""
	facts.add_child(fact("Opp_Best", "Best punch", word(str(opp.get("threat", ""))) if found else word(UNKNOWN, Palette.MUTED),
		"" if found else "Tape study finds it. It is the first thing a coach looks for."))
	top.add_child(facts)
	top.add_child(_portrait(stem))
	v.add_child(top)
	v.add_child(gap(14))
	v.add_child(cap("WHAT DECIDES IT"))
	v.add_child(gap(4))
	var names := UI.hbox(0)
	for side in [["YOUR BOXER", Palette.BAD], ["", Palette.MUTED], ["THE OPPONENT", Palette.ACCENT]]:
		var l := UI.label(str(side[0]), 16, side[1], "caps")
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if str(side[0]) == "":
			l.custom_minimum_size = Vector2(150, 0)
		else:
			l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		names.add_child(l)
	v.add_child(names)
	v.add_child(gap(4))
	var rec: Dictionary = by["Record"]
	v.add_child(_versus_row("Decides_Record", "RECORD", str(rec["left"]), str(rec["right"]), str(rec["better"])))
	var reach: Dictionary = by.get("Reach", {"left": TapeRows.MISSING, "right": TapeRows.MISSING, "better": ""})
	v.add_child(_versus_row("Decides_Reach", "REACH", str(reach["left"]), str(reach["right"]), str(reach["better"])))
	var own := int(o["own_bouts"])
	var theirs := int(o["their_bouts"])
	v.add_child(_versus_row("Decides_Experience", "EXPERIENCE", "%d bouts" % own, "%d bouts" % theirs, _more(own, theirs)))
	var filler := Control.new()
	filler.size_flags_vertical = Control.SIZE_EXPAND_FILL
	filler.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(filler)
	var s := BoutRead.stage(opp)
	var note := UI.vbox(0)
	note.name = "ScoutLine"
	note.add_child(UI.label("Scouting: %d of %d found." % [int(s["found"]), int(s["all"])], 16, Palette.WARN, "bold"))
	note.add_child(UI.label("The whole file is in the Full report.", 16, Palette.MUTED, "body", true))
	Icons.tip(note, "Tape study opens the file one find at a time. Each find narrows the win chance.")
	v.add_child(note)
	return p
