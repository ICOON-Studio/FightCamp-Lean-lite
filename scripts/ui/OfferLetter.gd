extends RefCounted
## S535 OFFERBUILD1 (owner C448 on the offer: "this looks too much like the tale of tape, maybe change it ?", then
## Q-S294-296 "Yes, build it"; mockup ops/previews/s535_offer_mockup/offer.png): a bout offer is the host club's LETTER.
## Centre, on paper: the crest and the club, "Bout offer", the matchmaker's line, the night, time to prepare, the money,
## the sanction, IF YOUR BOXER WINS / LOSES, and the answer-by stamp. Our boxer on the left, the coach's read and the
## opponent on the right (OfferSides), then Pass (its cost), Full report, Accept the bout (date and money).
## Every number is read from the game; nothing is typed in. The stats, the file and the terms table stay on the Full report.
##   build(main, c, f, o, opp, offer_id, wf) -> Control "OfferPage"     answer_state(c, f, o) -> {open, off, why, tip, price}

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const OfferSides := preload("res://scripts/ui/OfferSides.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const ClubCrest := preload("res://scripts/rules/ClubCrest.gd")
const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Region := preload("res://scripts/state/Region.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ClubForecast := preload("res://scripts/state/ClubForecast.gd")

const PAPER := "res://assets/ui/art/menu_paper.jpg"
const INK := Palette.PAPER_INK
const INK2 := Palette.PAPER_MUTED
const PEN := Palette.PAPER_BLUE
const WIN := Palette.GOOD_FILL
const LOSS := Palette.BAD_FILL
const WEEKDAYS := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const COUNT := {1: "One round", 2: "Two rounds", 3: "Three rounds", 4: "Four rounds", 5: "Five rounds", 6: "Six rounds"}
const PAGE_H := 900.0


static func build(main: Node, c: Career, f: Dictionary, o: Dictionary, opp: Dictionary, offer_id: String, wf: Dictionary) -> Control:
	var root := UI.hbox(38)
	root.name = "OfferPage"
	root.custom_minimum_size = Vector2(0, PAGE_H)
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var stems: Array = Faces.pair(f, opp)
	var crests: Array = ClubCrest.pair(c.gym_name, str(opp["club"]))
	var by := OfferSides.tape(c, f, opp, Faces.cm(str(stems[0])))
	root.add_child(OfferSides.mine(c, f, o, wf, by, str(stems[0]), str(crests[0])))
	var mid := UI.vbox(16)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_child(_letter(c, f, o, wf, str(crests[1]), by))
	mid.add_child(_answer(main, c, f, o, offer_id))
	for line in _reasons(c, f, o, wf):
		mid.add_child(line)
	root.add_child(mid)
	var right := UI.vbox(20)
	right.add_child(OfferSides.read(c, f, o, opp))
	right.add_child(OfferSides.opponent(f, o, opp, by, str(stems[1])))
	root.add_child(right)
	return root


## Whether the offer can still be answered, why Accept is off, and what Pass costs (Bouts.pass_price).
static func answer_state(c: Career, f: Dictionary, o: Dictionary) -> Dictionary:
	var open := not bool(o["answered"])
	var why := ""
	var tip := ""
	if bool(o["mismatch"]):
		why = "The federation would not sanction it"
		tip = "The federation would not sanction it: a novice (%d bouts) may not meet an open fighter (%d bouts)." % [int(o["own_bouts"]), int(o["their_bouts"])]
	elif not open:
		why = "Already answered"
		tip = "You already answered this offer - pick another from Fights"
	return {"open": open, "off": bool(o["mismatch"]) or not open, "why": why, "tip": tip, "price": Bouts.pass_price(c, f, o) if open else 0}


static func _ink(text: String, size: int, colour: Color = INK, kind: String = "semi", wrap: bool = false) -> Label:
	return UI.label(text, size, colour, kind, wrap)


static func _crest(crest: String) -> PanelContainer:
	var disc := PanelContainer.new()
	disc.custom_minimum_size = Vector2(92, 92)
	disc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	disc.add_theme_stylebox_override("panel", UI.box(PEN, Palette.CLEAR, 46, 0, 13, 13))
	var t := TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.texture = load(ClubCrest.path(crest))
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disc.add_child(t)
	return disc


## One term of the offer: the name in small caps, the value big, a line of small print under it.
static func _term(name: String, key: String, value: String, small: String, tip: String = "", colour: Color = INK, unit: String = "") -> VBoxContainer:
	var v := UI.vbox(0)
	v.name = name
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(OfferSides.rule(Color(INK2, 0.45)))
	v.add_child(OfferSides.gap(9))
	v.add_child(_ink(key.to_upper(), 16, INK2, "caps"))
	var line := UI.hbox(8)
	line.add_child(_ink(value, 27, colour, "bold"))
	if unit != "":
		var u := _ink(unit, 18, INK, "semi")
		u.size_flags_vertical = Control.SIZE_SHRINK_END
		line.add_child(u)
	v.add_child(line)
	v.add_child(_ink(small, 17, INK2, "semi", true))
	v.add_child(OfferSides.gap(9))
	Icons.tip(v, tip)
	return v


static func _plural(n: int, one: String, many: String) -> String:
	return "%d %s" % [n, one if n == 1 else many]


static func _prepare(days: int) -> String:
	return _plural(int(days / 7.0), "week", "weeks") if days >= 7 else _plural(maxi(days, 0), "day", "days")


## IF YOUR BOXER WINS / LOSES: the ladder first (BoutRead.rank_move on the region's table), then members, record, loyalty.
static func _outcome(name: String, title: String, big: String, lines: Array, colour: Color) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = name
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := UI.box(Color(Palette.FULL, 0.35), colour, 4, 2, 16, 12)
	p.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(2)
	p.add_child(v)
	v.add_child(_ink(title.to_upper(), 16, colour, "caps"))
	v.add_child(_ink(big, 25, INK, "bold", true))
	for line in lines:
		v.add_child(_ink("•  %s" % str(line), 17, INK, "semi", true))
	return p


static func _win_place(m: Dictionary) -> String:
	var now := int(m["now"])
	var to := int(m["win"])
	if to == 0:
		return "%s to enter the ladder" % _plural(int(m["need"]), "more win", "more wins")
	if now == 0:
		return "Enters the ladder at #%d" % to
	if to == now:
		return "Holds #%d on the ladder" % to
	return "%s to #%d on the ladder, from #%d" % ["Up" if to < now else "Down", to, now]


static func _loss_place(m: Dictionary) -> String:
	var now := int(m["now"])
	var to := int(m["loss"])
	if to == 0:
		return "Stays unranked" if now == 0 else "Drops off the ladder, from #%d" % now
	if now == 0:
		return "Enters the ladder at #%d" % to
	if to == now:
		return "Holds #%d on the ladder" % to
	return "%s to #%d on the ladder, from #%d" % ["Drops" if to > now else "Up", to, now]


static func _stamp(c: Career, o: Dictionary) -> Control:
	var holder := Control.new()
	holder.name = "LetterStamp"
	holder.custom_minimum_size = Vector2(290, 78)
	holder.size_flags_vertical = Control.SIZE_SHRINK_END
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(Palette.CLEAR, LOSS, 6, 3, 16, 7))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(0)
	p.add_child(v)
	var left := int(o["expires"]) - c.day
	var top := _ink("ANSWER BY %s" % Clock.fmt(int(o["expires"])).to_upper(), 19, LOSS, "caps")
	top.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(top)
	var under := _ink("LAST DAY" if left <= 0 else _plural(left, "DAY LEFT", "DAYS LEFT"), 16, LOSS, "caps")
	under.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(under)
	p.position = Vector2(4, 8)
	p.rotation_degrees = -4.0
	p.ready.connect(func(): p.pivot_offset = p.size * 0.5)
	holder.add_child(p)
	Icons.tip(holder, "After that day the slot goes to another club and the offer is gone.")
	return holder


static func _letter(c: Career, f: Dictionary, o: Dictionary, wf: Dictionary, crest: String, by: Dictionary) -> Control:
	var opp: Dictionary = o["opp"]
	var club := str(opp["club"])
	var day := int(o["day"])
	var wrap := Control.new()
	wrap.name = "LetterWrap"
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shade := Panel.new()
	var soft := UI.box(Palette.CLEAR, Palette.CLEAR, 3, 0, 0, 0)
	soft.shadow_color = Color(Palette.PAGE, 0.6)
	soft.shadow_size = 18
	soft.shadow_offset = Vector2(0, 8)
	shade.add_theme_stylebox_override("panel", soft)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	wrap.add_child(shade)
	var p := PanelContainer.new()
	p.name = "OfferLetter"
	var paper := StyleBoxTexture.new()
	paper.texture = load(PAPER)
	paper.content_margin_left = 50
	paper.content_margin_right = 50
	paper.content_margin_top = 34
	paper.content_margin_bottom = 24
	p.add_theme_stylebox_override("panel", paper)
	p.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	wrap.add_child(p)
	var strip := ColorRect.new()   # the strip of tape that holds the letter to the wall
	strip.color = Color(Palette.CHOSEN, 0.82)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	strip.anchor_left = 0.5
	strip.anchor_right = 0.5
	strip.offset_left = -75
	strip.offset_right = 75
	strip.offset_top = -14
	strip.offset_bottom = 20
	strip.rotation_degrees = 1.2
	wrap.add_child(strip)
	var fit := func():
		for sheet in [shade, p]:
			(sheet as Control).pivot_offset = wrap.size * 0.5
			(sheet as Control).rotation_degrees = -0.5
		wrap.custom_minimum_size = Vector2(0, p.get_combined_minimum_size().y)
	wrap.resized.connect(fit)
	p.minimum_size_changed.connect(fit)
	p.ready.connect(fit)

	var v := UI.vbox(0)
	p.add_child(v)
	var head := UI.hbox(20)
	head.name = "LetterHead"
	head.add_child(_crest(crest))
	var who := UI.vbox(0)
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	who.add_child(_ink(club.to_upper(), 30, INK, "bold"))
	who.add_child(_ink("Club show · the matchmaker's offer", 17, INK2))
	head.add_child(who)
	var cls := _ink("%s, %s kg" % [str(f["wc"]), OfferSides.kg(float(f["limit"]))], 17, INK2)
	cls.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(cls)
	v.add_child(head)
	v.add_child(OfferSides.gap(14))
	v.add_child(OfferSides.rule(INK2))
	v.add_child(OfferSides.gap(2))
	v.add_child(OfferSides.rule(INK2))
	v.add_child(OfferSides.gap(12))
	var title := _ink("Bout offer", 54, INK, "marker")
	title.name = "LetterTitle"
	v.add_child(title)
	var fair := "" if bool(o["mismatch"]) else ", fair match"
	var lede := _ink("\"We have a %s on our show who needs an opponent. %s%s. Can your boxer make it?\"" % [
		str(f["wc"]).to_lower(), str(COUNT.get(BoutRules.ROUNDS, "%d rounds" % BoutRules.ROUNDS)), fair], 23, INK, "hand", true)
	lede.name = "LetterLede"
	v.add_child(lede)
	v.add_child(OfferSides.gap(10))

	var terms := GridContainer.new()
	terms.columns = 2
	terms.add_theme_constant_override("h_separation", 38)
	terms.add_theme_constant_override("v_separation", 0)
	terms.add_child(_term("Term_night", "The night", Clock.fmt(day), "%d x 3 min, at their club show" % BoutRules.ROUNDS,
		"A Saturday club show at the host's gym. The weigh-in is the day before."))
	terms.add_child(_term("Term_prepare", "Time to prepare", _prepare(day - c.day), "No camp needed: a fight week",
		"An amateur bout takes a light fight week, not a camp. The weeks before it are ordinary training."))
	terms.add_child(_term("Term_club", "To the gym", UI.money(BoutRules.TICKET_CUT), "Purse: none, amateur",
		"The host pays the visiting gym a share of the door. Amateurs box for no purse.", INK, "ticket cut"))
	var own := int(o["own_bouts"])
	var theirs := int(o["their_bouts"])
	var novice := AmateurBooking.NOVICE_MAX_BOUTS
	var word := "Legal, even match"
	var tone := WIN
	var small := "%d bouts against %d: %s" % [own, theirs, "both novices" if own <= novice and theirs <= novice else "open class"]
	if bool(o["mismatch"]):
		word = "Not safe"
		tone = LOSS
		small = "%d bouts against %d: a novice may not meet an open boxer" % [own, theirs]
	elif not bool(wf["ok"]):
		word = "Weight at risk"
		tone = LOSS
		small = "%s kg over at the weigh-in, even cutting from tomorrow" % OfferSides.kg(float(wf["over"]))
	terms.add_child(_term("Term_sanction", "Sanction", word, small,
		"The federation's rule: a novice (up to %d bouts) only meets another novice. From bout %d a boxer is open class." % [novice, novice + 1], tone))
	v.add_child(terms)
	v.add_child(OfferSides.gap(8))

	var m := BoutRead.rank_move(Region.rankings(c, str(f["div"])), f, str(opp["name"]), Callable(Region, "before"), Region.RANK_MIN_WINS)
	var w := int(f["w"])
	var l := int(f["l"])
	var after: Array = ["W"]
	after.append_array(by["_mine"]["marks"])
	var run := TapeRows.streak(after)
	var won: Array = ["+%d members sign up" % BoutRules.WIN_MEMBERS, "Record %d-%d%s" % [w + 1, l, ", %s" % run if run.contains("in a row") else ""]]
	var up := int(Loyalty.move_for(f, "bout_won", c.day).get("n", 0))
	if up != 0:
		won.append("Loyalty %+d" % up)
	var down := int(Loyalty.move_for(f, "bout_lost", c.day).get("n", 0))
	var hard := int(Loyalty.move_for(f, "stopped", c.day).get("n", 0))
	var lost: Array = ["%s (%d if stopped)" % [_plural(BoutRules.LOSS_MEMBERS, "member leaves", "members leave"), BoutRules.STOPPED_LOSS_MEMBERS],
		"Record %d-%d" % [w, l + 1], "Loyalty holds" if down == 0 and hard == 0 else "Loyalty %+d (stopped: %+d)" % [down, hard]]
	var ifs := UI.hbox(20)
	ifs.add_child(_outcome("IfWin", "If your boxer wins", _win_place(m), won, WIN))
	ifs.add_child(_outcome("IfLoss", "If your boxer loses", _loss_place(m), lost, LOSS))
	v.add_child(ifs)
	var push := Control.new()
	push.custom_minimum_size = Vector2(0, 10)
	push.size_flags_vertical = Control.SIZE_EXPAND_FILL
	push.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(push)

	var foot := UI.hbox(16)
	foot.name = "LetterSign"
	var hand := UI.vbox(0)
	hand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand.size_flags_vertical = Control.SIZE_SHRINK_END
	hand.add_child(_ink("Reply by %s and the slot is yours." % str(WEEKDAYS[posmod(int(o["expires"]), 7)]), 22, PEN, "hand", true))
	hand.add_child(_ink("The matchmaker, %s" % club, 16, INK2))
	foot.add_child(hand)
	foot.add_child(_stamp(c, o))
	v.add_child(foot)
	return wrap


## A two-line button's words sit in its middle, as on the approved picture.
static func _centre(n: Node) -> void:
	for ch in n.get_children():
		if ch is Label:
			(ch as Label).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			(ch as Label).size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_centre(ch)


## Pass (its cost), Full report, Accept the bout (the date and the money).
static func _answer(main: Node, c: Career, f: Dictionary, o: Dictionary, offer_id: String) -> HBoxContainer:
	var st := answer_state(c, f, o)
	var open := bool(st["open"])
	var price := int(st["price"])
	var row := UI.hbox(14)
	row.name = "OfferAnswer"
	var pass_b := UI.button2("Pass", "costs nothing" if price == 0 else "loyalty %d" % price, "BtnQuiet", main.act.bind("declineOffer", offer_id),
		Vector2(0, 60), UI.FG, UI.MUTED, not open, 21, 16, "Already answered" if not open else "")
	pass_b.name = "Pass"
	_centre(pass_b)
	pass_b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(pass_b)
	var report := UI.button("Full report", "Btn", VersusPanel.show_report.bind(main, offer_id))
	report.name = "FullReport"
	report.custom_minimum_size = Vector2(0, 60)
	report.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(report)
	var accept := UI.button2("Accept the bout", "%s, %s to the gym" % [Clock.fmt(int(o["day"])), UI.money(BoutRules.TICKET_CUT)], "BtnSolid",
		main.act.bind("accept", offer_id), Vector2(0, 60), UI.FG, UI.MUTED, bool(st["off"]), 21, 16, str(st["why"]))
	accept.name = "Accept"
	_centre(accept)
	accept.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	accept.size_flags_stretch_ratio = 1.5
	if bool(st["off"]):
		accept.tooltip_text = str(st["tip"])
	row.add_child(accept)
	return row


## The lines that say why not, under the answer: the weight missed, the week's film nights short.
static func _reasons(c: Career, f: Dictionary, o: Dictionary, wf: Dictionary) -> Array:
	var out: Array = []
	if bool(o["answered"]) or bool(o["mismatch"]):
		return out
	if not bool(wf["ok"]):
		var heavy := UI.label("Your boxer would come in %.1f kg over even cutting from tomorrow. Missing weight calls the bout off and the gym pays %s for the empty slot." % [
			float(wf["over"]), UI.money(BoutRules.MISSED_WEIGHT_COST)], UI.SMALL, UI.RED, "body", true)
		heavy.name = "WeightWarn"
		out.append(heavy)
	var cl := ClubForecast.clash(c, f, int(o["day"]))   # S519 club week 3.7: the week's film nights run short
	if cl != "":
		var cw := UI.label(cl, UI.SMALL, UI.AMBER, "body", true)
		cw.name = "ClashLine"
		out.append(cw)
	return out
