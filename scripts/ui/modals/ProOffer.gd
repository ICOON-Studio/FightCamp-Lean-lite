extends PanelContainer
## The promoter's offer to turn the boxer pro. S543 TURNPROBUILD17 step 4 (turning pro v17, owner Q-S294-320 / Q-S294-323;
## map DESIGN_TURNPRO1_V17.md section 7): ONE promoter, one offer; Turn pro now / Not yet with three patience marks; with
## no mark left the call is a rival gym's: Turn pro now / Let the boxer go.
## S544 (owner: "this is still confusing and looks like spreadheet you need to use art"): the pop-up is a SCENE, not rows.
## Left: the boxer in the signing office with the promoter's ticket (ProScene.art). Right: the question, and the two
## answers as CHOICE CARDS - a painting, the choice's name, at most four plain facts with an icon each, its own button.
## Under them one strip: the first pro fight's two bouts as two chips, and the debut tickets as the picture they always
## were. Every detail that used to be a row is the hover of the fact it belongs to.

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")
const Data := preload("res://scripts/state/Data.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const TicketBar := preload("res://scripts/ui/TicketBar.gd")
const ProScene := preload("res://scripts/ui/ProScene.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	var c: Career = main.career
	var o := c.pro_offer
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var rival := bool(o.get("rival", false))
	custom_minimum_size = Vector2(1560, 0)
	var row := UI.hbox(22)
	add_child(row)
	row.add_child(ProScene.art(f, "A RIVAL GYM IS ON THE PHONE" if rival else "%s IS ON THE PHONE" % str(o["promoter"]).to_upper(), Vector2(430, 700), not rival))
	var v := UI.vbox(12)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(v)
	v.add_child(UI.display("TURN PRO?", 50))
	var pitch := "\"Your boxer is tired of waiting. Sign the pro papers today, or the boxer signs with us.\"" if rival \
		else "\"I have a card in four weeks. %d wins as an amateur is enough: say the word.\"" % int(f["w"])
	var pl := UI.label(pitch, UI.BODY + 2, Palette.TEXT, "italic", true)
	pl.name = "RivalCall" if rival else "Pitch"
	v.add_child(pl)
	var age_line := ProCall.age_line(int(f.get("age", 22)))
	if age_line != "":
		v.add_child(UI.muted(age_line, UI.SMALL, true))
	var cards := UI.hbox(16)
	cards.name = "Choices"
	v.add_child(cards)
	cards.add_child(_turn_card(main, c, f, o))
	cards.add_child(_leave_card(main) if rival else _wait_card(main, c, f, o))
	v.add_child(_debut_strip(c, f, o))


## A choice card: the painting with the choice's name, the facts, then its button along the foot.
func _choice(node_name: String, art: String, title: String, tone: Color, facts: Array, button: Button) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Palette.alpha(Palette.TEXT, 0.05), Palette.alpha(tone, 0.55), 8, 2, 0, 0))
	var v := UI.vbox(0)
	p.add_child(v)
	v.add_child(ProScene.header(art, title, tone))
	var pad := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, 16)
	pad.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(pad)
	var inner := UI.vbox(12)
	pad.add_child(inner)
	for x in facts:
		inner.add_child(x)
	var gap := UI.spacer()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inner.add_child(gap)
	button.size_flags_horizontal = Control.SIZE_FILL
	button.custom_minimum_size.y = 54.0
	inner.add_child(button)
	return p


func _turn_card(main: Node, c: Career, f: Dictionary, o: Dictionary) -> Control:
	var sheet := Roster.debut_sheet(c, f, 1.0)
	var parts: Array = ["BBBofC licence %s" % UI.money(ProDebut.LICENCE)]
	if not bool(f.get("licensed", false)):
		parts.append("scans, medical, bloods %s" % UI.money(ProDebut.MEDICALS))
	if not Roster.trainer_licensed(c):
		parts.append("your coach's trainer licence %s" % UI.money(ProDebut.CORNER_LICENCE))
	var share := roundi(Roster.signing_share(f) * 100)
	var tip := "The pro purse. It grows by %s with each win, to %s. The gym keeps %d%% of every purse." % [UI.money(int(o["step"])), UI.money(int(o["top"])), share]
	if Roster.signing_share(f) < Roster.GYM_SHARE:
		tip += " Loyalty is under 50: an outside manager signs the boxer and the club keeps only the trainer's share."
	var purse := ProScene.fact("ticket", Palette.GOOD, "%s a fight" % UI.money(int(o["purse"])),
		"+%s a win, up to %s. The gym keeps %d%%%s." % [UI.money(int(o["step"])), UI.money(int(o["top"])), share,
		" (loyalty is under 50)" if Roster.signing_share(f) < Roster.GYM_SHARE else ""], tip)
	var pays := ProScene.fact("clipboard-pen", Palette.BAD, "-%s today" % UI.money(int(sheet["costs"])), "licence and medical, paid at signing", ", ".join(parts) + ".")
	pays.name = "PaysNow"
	var ends := ProScene.fact("x", Palette.MUTED, "Amateur days end", "no %s weekly stipend, no amateur bouts or rankings" % UI.money(GameMoney.FIGHTER_STIPEND),
		"For good: the club stipend (%s a week) stops, amateur bouts, rankings and the nationals are over, and the club's ticket cut (%s a bout, about %s a week) ends." % [
		UI.money(GameMoney.FIGHTER_STIPEND), UI.money(BoutRules.TICKET_CUT), UI.money(ProCall.LOST_CUT_A_WEEK)])
	var facts: Array = [purse, pays, ends]
	var before_nats := bool(Champs.check(c, f).get("ok", false))
	var why := ProOfferWire.morale_line(f, before_nats)   # S534 (owner C442 "why morale drops")
	if why != "":
		var go_m := ProOfferWire.morale(f, false, before_nats)
		var ml := ProScene.fact("heart", Palette.BAD if go_m < 0 else Palette.GOOD, "Morale %+d" % go_m,
			"the goal the boxer signed with is given up" if go_m < 0 else "this is what the boxer wanted", why)
		ml.name = "ProMorale"
		facts.append(ml)
	var go := UI.button("Turn pro now", "Go", main.act.bind("turnpro", ""))
	go.name = "TurnPro"
	go.tooltip_text = "Signs today. The boxer's profile opens with what changed; the debut is %d weeks out, picked on Fights." % Roster.PRO_DEBUT_WEEKS
	Pulse.breathe(go)
	return _choice("ChoiceTurn", ProScene.RING, "TURN PRO NOW", Palette.HEADER, facts, go)


func _wait_card(main: Node, c: Career, f: Dictionary, o: Dictionary) -> Control:
	var s: Dictionary = f.get("pro_start", {})
	var marks_now := int(s.get("patience", ProStart.PATIENCE))
	var after := maxi(0, marks_now - 2)
	var pat := UI.hbox(14)
	pat.name = "PatienceFact"
	pat.mouse_filter = Control.MOUSE_FILTER_STOP
	pat.tooltip_text = "How long the boxer waits for the move. Each Not yet spends a mark and %d hunger. With one mark left the next call is a rival gym's: turn pro then, or the boxer leaves." % -ProStart.NOT_YET_HUNGER
	pat.add_child(ResultTiles.icon("refresh-cw", 34, Palette.HEADER))
	var pv := UI.vbox(2)
	pv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var marks := UI.hbox(10)
	marks.add_child(UI.label("Patience", 24, Palette.HEADER, "bold"))
	marks.add_child(ResultTiles.pips(maxi(0, marks_now - 1), ProStart.PATIENCE - 1, Palette.HEADER, 18))   # S544: one dot = one Not yet
	pv.add_child(marks)
	pv.add_child(UI.label("this spends one: %s" % ("the next call is a rival gym's" if after == 0 else "%d Not yet left after it" % after),
		UI.SMALL, Palette.MUTED, "semi", true))
	pat.add_child(pv)
	var hunger := int(s.get("hunger", ProStart.HUNGER_START))
	var hg := ProScene.fact("flame", Palette.WARN, "Hunger %d" % ProStart.NOT_YET_HUNGER, "%d becomes %d. At 0 the boxer asks to leave." % [hunger, maxi(0, hunger + ProStart.NOT_YET_HUNGER)],
		"How much the boxer wants it. Waiting costs it; a risky pro bout brings it back.")
	var back := ProScene.fact("play", Palette.ACCENT, "%d weeks" % ProStart.NOT_YET_WEEKS, "the promoter calls again on %s" % Clock.fmt(c.day + ProStart.NOT_YET_WEEKS * 7),
		"Room for about two amateur bouts. More wins sell more debut tickets.")
	var wait := UI.button("Not yet", "BtnQuiet", main.act.bind("declinepro", ""))
	wait.name = "DeclinePro"
	wait.tooltip_text = "Stays amateur for now. The boxer's profile opens with what it cost."
	return _choice("ChoiceWait", ProScene.GYM, "NOT YET", Palette.ACCENT, [pat, hg, back, _later_fact(o, f)], wait)


## What four more weeks of training would do to the first fight's odds, in one plain line (was two rows of numbers).
func _later_fact(o: Dictionary, f: Dictionary) -> Control:
	var now: Dictionary = o.get("pair_now", {})
	var later: Dictionary = o.get("pair_later", {})
	var best := 0.0
	var words: Array = []
	for kind in ProStart.KINDS:
		if not now.has(kind) or not later.has(kind):
			continue
		best = maxf(best, float(later[kind]["chance"]) - float(now[kind]["chance"]))
		words.append("%s %d%% to %d%%" % [str(ProStart.KIND_NAMES[kind]).to_lower(), roundi(float(now[kind]["chance"]) * 100.0), roundi(float(later[kind]["chance"]) * 100.0)])
	var focus := str(Data.LABEL.get(str(f.get("focus", "")), "the current")).to_lower()
	var tip := "Four more weeks of %s training, read the same way as today: %s. The promoter finds a harder opponent for a better boxer, so a strong boxer's odds stay where they are." % [focus, ", ".join(words)]
	var x: HBoxContainer
	if best > 0.005:
		x = ProScene.fact("trending-up", Palette.GOOD, "Better odds in 4 weeks", ", ".join(words), tip)
	else:
		x = ProScene.fact("target", Palette.MUTED, "Same odds in 4 weeks", "waiting does not make the first fight easier", tip)
	x.name = "Later"
	return x


func _leave_card(main: Node) -> Control:
	var facts: Array = [
		ProScene.fact("x", Palette.BAD, "Gone for good", "the boxer signs with the rival gym"),
		ProScene.fact("user", Palette.MUTED, "A place frees", "one fewer boxer on the roster"),
		ProScene.fact("trending-down", Palette.WARN, "Reputation falls", "the town hears the club lost a prospect")]
	var go_away := UI.button("Let the boxer go", "BtnQuiet", main.act.bind("rivalgo", ""))
	go_away.name = "LetGo"
	go_away.tooltip_text = "The boxer leaves for the rival gym for good: the place on the roster frees, the club loses a little reputation."
	return _choice("ChoiceLeave", ProScene.EMPTY_GYM, "LET THE BOXER GO", Palette.BAD, facts, go_away)


## Under the two answers: the first pro fight's two bouts as two chips, and the debut's tickets as a picture.
func _debut_strip(c: Career, f: Dictionary, o: Dictionary) -> Control:
	var card := UI.card("THE FIRST PRO FIGHT: PICKED AFTER SIGNING, %d WEEKS OUT" % Roster.PRO_DEBUT_WEEKS)
	card[0].name = "Pair"
	var row := UI.hbox(28)
	card[1].add_child(row)
	var now: Dictionary = o.get("pair_now", {})
	for kind in ProStart.KINDS:
		if not now.has(kind):
			continue
		var b: Dictionary = now[kind]
		var tone: Color = Palette.GOOD if kind == "safe" else Palette.WARN
		var chance := roundi(float(b["chance"]) * 100.0)
		var chip := UI.vbox(4)
		chip.name = "Pair_" + kind
		chip.mouse_filter = Control.MOUSE_FILTER_STOP
		var is_line := str(ProStart.KIND_IS[kind])
		chip.tooltip_text = "%s: about %d%% to win as the boxer stands today, purse %s, name +%d on a win. The same number the fight is fought at." % [
			is_line.left(1).to_upper() + is_line.substr(1), chance, UI.money(int(b["purse"])), int(b["name"])]
		var top := UI.hbox(10)
		top.add_child(UI.label(str(ProStart.KIND_NAMES[kind]).to_upper(), 22, tone, "bold"))
		var ch := UI.label("%d%%" % chance, 30, tone, "bold")
		ch.name = "Chance_" + kind
		top.add_child(ch)
		chip.add_child(top)
		chip.add_child(ResultTiles.pips(roundi(float(b["chance"]) * 10.0), 10, tone, 12))
		chip.add_child(UI.label("%s  ·  name +%d" % [UI.money(int(b["purse"])), int(b["name"])], UI.SMALL, Palette.MUTED, "semi"))
		row.add_child(chip)
	var debut := UI.vbox(2)
	debut.name = "Debut"
	debut.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	debut.mouse_filter = Control.MOUSE_FILTER_STOP
	var parts := ticket_parts(c, f)
	debut.tooltip_text = "The debut: %d rounds, %d tickets at %s to sell. Today's buyers: %s. The first %d pay the promoter's night; half of each ticket past that goes to the boxer." % [
		Roster.PRO_ROUNDS, ProDebut.TICKETS, UI.money(ProDebut.TICKET_PRICE), ", ".join(parts.map(func(x): return "%s %d" % [str(x["t"]).to_lower(), int(x["n"])])), ProDebut.BREAK_EVEN]
	debut.add_child(UI.label("DEBUT TICKETS", UI.SMALL, Palette.MUTED, "caps"))
	var bar := TicketBar.new()
	bar.name = "Tickets"
	bar.total = ProDebut.TICKETS
	bar.break_even = ProDebut.BREAK_EVEN
	bar.parts = parts
	debut.add_child(bar)
	row.add_child(debut)
	return card[0]


## The three patience marks: gold = a Not yet still open, grey = spent. The third mark is the rival gym's call.
static func patience_row(s: Dictionary) -> Control:
	var h := UI.hbox(8)
	h.name = "Patience"
	h.mouse_filter = Control.MOUSE_FILTER_STOP
	h.tooltip_text = "How long the boxer waits for the move. Each Not yet spends a mark and %d hunger; with one mark left the next call is a rival gym's." % -ProStart.NOT_YET_HUNGER
	h.add_child(UI.label("PATIENCE", UI.SMALL, UI.MUTED, "caps"))
	var left := maxi(0, int(s.get("patience", ProStart.PATIENCE)) - 1)   # S544: one dot = one Not yet (three marks read as "2 left" beside three dots)
	for i in ProStart.PATIENCE - 1:
		h.add_child(UI.dot(UI.GOLD if i < left else UI.MUTED))
	h.add_child(UI.label("%d Not yet left" % left, UI.SMALL, UI.FG))
	return h


## Who buys her tickets, in ProDebut's order, trimmed to the tickets she has: [{t, n, col}].
static func ticket_parts(c: Career, f: Dictionary) -> Array:
	var raw := [
		{"t": "Family and friends", "n": ProDebut.FAMILY, "col": UI.MUTED},
		{"t": "Gym members", "n": int(floor(maxi(0, c.members) * ProDebut.PER_MEMBER)), "col": UI.GOLD},
		{"t": "%d wins" % int(f["w"]), "n": ProDebut.PER_WIN * maxi(0, int(f["w"])), "col": Palette.ACCENT},
		{"t": "Titles", "n": ProDebut.PER_TITLE * Roster.titles(f), "col": UI.GREEN},
		{"t": "Club show crowd", "n": int(f.get("followers", 0)), "col": UI.AMBER},   # S523 map M9: topping our own show
	]
	var left := ProDebut.TICKETS
	var out: Array = []
	for p in raw:
		var n := mini(int(p["n"]), left)
		left -= n
		if n > 0:
			out.append({"t": p["t"], "n": n, "col": p["col"]})
	return out
