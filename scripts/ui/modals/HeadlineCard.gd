extends VBoxContainer
## S442 LOOP drawing 3 (owner: "All three"; docs/mockups/s442/loop/headline_card.png): the headline between the last
## bell and the result page, shown once for the bout just booked (AfterFight.book wrote m["night"]). Words from
## Headline.headline: the night, the outcome and how, both fighters with records and ranks before -> after, the three
## cards, ONE cause, and one gold "See the fight" that opens today's result page (Enter, Space or a click work too).
## A milestone the game can tell (entering the rankings, a first win) gets the purple glow and a ribbon.
##   wanted(m) -> bool      make(main, m) -> HeadlineCard      go()

const UI := preload("res://scripts/ui/UI.gd")
const TV := preload("res://scripts/ui/TV.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Headline := preload("res://scripts/rules/Headline.gd")

const W := 840.0
const SOFT := Color("#b8a88f")
const WARM := Color("#e8ddd0")
const LOSS := Color("#ff8a78")
const GOLD_TOP := Color("#f2cd6a")
const GOLD_INK := Color("#231b16")
const RIBBON := Color("#2a1f45")
const RIBBON_INK := Color("#e6dcff")

var _main: Node
var _m: Dictionary
var _done := false


## Only the bout just fought (its facts are written by the booking) and only once.
static func wanted(m: Dictionary) -> bool:
	return m.has("night") and not bool(m.get("night_seen", false))


static func make(main: Node, m: Dictionary) -> VBoxContainer:
	var hc = new()
	hc._main = main
	hc._m = m
	hc._build()
	return hc


## See the fight: today's result page.
func go() -> void:
	if _done:
		return
	_done = true
	_m["night_seen"] = true
	_main.redraw_modal()


func _unhandled_input(e: InputEvent) -> void:
	if e.is_action_pressed("ui_accept") or (e is InputEventKey and (e as InputEventKey).pressed and (e as InputEventKey).keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]):
		get_viewport().set_input_as_handled()
		go()


func _build() -> void:
	name = "Headline"
	add_theme_constant_override("separation", -22)
	var c: Career = _main.career
	var f: Dictionary = c.fighter_by_id(str(_m["fid"]))
	var opp: Dictionary = (f["bout"] as Dictionary).get("opp", {})
	var h := Headline.headline(_m["night"])
	var ms: Dictionary = h["milestone"]
	var ribbon := CenterContainer.new()
	ribbon.z_index = 1
	ribbon.custom_minimum_size = Vector2(0, 44)
	add_child(ribbon)
	var card := PanelContainer.new()
	card.name = "HeadlineCard"
	card.custom_minimum_size = Vector2(W, 0)
	card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card.add_theme_stylebox_override("panel", UI.box(Color("#1b1612"), UI.PURPLE if not ms.is_empty() else Color("#4a3a30"), 8,
		2 if not ms.is_empty() else 1, 30, 34))
	card.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and (e as InputEventMouseButton).pressed and (e as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			go())
	add_child(card)
	if not ms.is_empty():
		var rb := PanelContainer.new()
		rb.name = "Milestone"
		rb.add_theme_stylebox_override("panel", UI.box(RIBBON, UI.PURPLE, 22, 2, 28, 6))
		var rh := UI.hbox(10)
		rh.add_child(Icons.icon("trophy", 24, Color("#c9b3ff"), str(ms["words"])))
		rh.add_child(UI.label(str(ms["words"]).to_upper(), 20, RIBBON_INK, "caps"))
		rb.add_child(rh)
		ribbon.add_child(rb)
		Halo.ring(card, UI.PURPLE, 8.0)
	var v := UI.vbox(14)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(v)
	v.add_child(_centred(UI.label(str(h["night"]).to_upper(), 19, SOFT, "caps")))
	var tone := str(h["tone"])
	var words := str(h["title"]).to_upper()   # 64 px as drawn; a longer headline steps down so the card keeps its width
	var t := _centred(UI.display(words, clampi(1380 / maxi(1, words.length()), 36, 64), LOSS if tone == "loss" else (Color.WHITE if tone == "win" else TV.FG)))
	t.name = "Title"
	v.add_child(t)
	var row := UI.hbox(10)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	var stems: Array = Faces.pair(f, opp)
	row.add_child(_side(str(f.get("name", f["first"])), "Red · " + str(f.get("style", "")), "", str(stems[0]), h["rec"][0], h["rank"][0], Broadcast.HERS))
	var vs := UI.display("V", 40, TV.MUTED)
	vs.custom_minimum_size = Vector2(100, 0)
	vs.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(vs)
	row.add_child(_side(str(opp.get("name", "")), "Blue · " + str(opp.get("style", "")), str(opp.get("club", "")), str(stems[1]), h["rec"][1], h["rank"][1], Broadcast.THEIRS))
	v.add_child(row)
	v.add_child(_cards())
	if str(h["cause"]) != "":
		var cause := UI.label(str(h["cause"]), 22, WARM, "bold", true)
		cause.name = "Cause"
		cause.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cause.custom_minimum_size = Vector2(760, 0)
		v.add_child(cause)
	var b := UI.button("", "BtnSolid", go)
	b.name = "HeadlineGo"
	b.custom_minimum_size = Vector2(260, 60)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for st in ["normal", "hover", "pressed", "focus"]:
		var sb := UI.box(GOLD_TOP if st != "pressed" else TV.GOLD, Color("#f7dc8f"), 6, 1, 18, 8)
		b.add_theme_stylebox_override(st, sb)
	var bh := UI.hbox(10)
	bh.alignment = BoxContainer.ALIGNMENT_CENTER
	bh.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bh.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bh.add_child(UI.label("See the fight", 26, GOLD_INK, "bold"))
	bh.add_child(Icons.icon("play", 22, GOLD_INK))
	b.add_child(bh)
	b.tooltip_text = "The result page: the rounds, what decided it, and what the bout did to the gym (Enter or Space)"
	v.add_child(b)
	Pulse.breathe(b)


## One corner: the portrait in the corner's colour, the name, corner and style, the club, the record and rank moves.
func _side(nm: String, kind: String, club: String, stem: String, rec: String, rank: String, colour: Color) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Side_" + ("red" if colour == Broadcast.HERS else "blue")
	var sb := UI.box(colour.darkened(0.78), colour, 6, 0, 16, 16)
	sb.border_width_bottom = 4
	p.add_theme_stylebox_override("panel", sb)
	p.custom_minimum_size = Vector2(330, 0)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(4)
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", UI.box(Color("#0b0a0a"), colour, 6, 3, 0, 0))
	frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	frame.clip_contents = true
	frame.custom_minimum_size = Vector2(156, 156)
	var pic := PromoShot.picture(stem, Vector2(150, 150))
	if pic != null:
		frame.add_child(pic)
	v.add_child(frame)
	v.add_child(_centred(UI.display(nm.to_upper(), 38, Color.WHITE)))
	v.add_child(_centred(UI.label(kind.to_upper(), UI.SMALL + 1, SOFT, "caps")))
	v.add_child(_centred(UI.label(club.to_upper() if club != "" else " ", UI.SMALL + 1, SOFT, "caps")))
	v.add_child(_moved(rec))
	if rank != "":
		v.add_child(_moved(rank))
	p.add_child(v)
	return p


## "3-1 → 3-2" with the after part in bold white.
func _moved(text: String) -> HBoxContainer:
	var h := UI.hbox(0)
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	var parts := text.split(Headline.ARROW)
	if parts.size() == 2:
		h.add_child(UI.label(parts[0] + Headline.ARROW, 20, WARM, "bold"))
		h.add_child(UI.label(parts[1], 20, Color.WHITE, "bold"))
	else:
		h.add_child(UI.label(text, 20, WARM, "bold"))
	return h


## The three cards, each in the colour of the corner it favours; a stoppage says the round instead.
func _cards() -> Control:
	var h := UI.hbox(14)
	h.name = "Cards"
	h.alignment = BoxContainer.ALIGNMENT_CENTER
	if str(_m.get("stopped", "")) != "":
		h.add_child(UI.label("Stopped in round %d of %d" % [(_m["rounds"] as Array).size(), int(_m.get("total", 3))], 22, WARM, "mono"))
		return h
	var cards: Array = _m.get("cards", [])
	for j in cards.size():
		var p := str(cards[j]).split("-")
		var ours := p.size() == 2 and int(p[0]) > int(p[1])
		var col: Color = Broadcast.HERS if ours else (Broadcast.THEIRS if p.size() == 2 and int(p[0]) < int(p[1]) else TV.MUTED)
		var box := PanelContainer.new()
		box.add_theme_stylebox_override("panel", UI.box(col.darkened(0.6), col, 5, 2, 10, 2))
		box.custom_minimum_size = Vector2(118, 52)
		var cv := UI.vbox(0)
		cv.add_child(_centred(UI.display(str(cards[j]), 30, Color.WHITE)))
		cv.add_child(_centred(UI.label("Judge %d" % (j + 1), UI.SMALL, SOFT)))
		box.add_child(cv)
		h.add_child(box)
	return h


static func _centred(l: Label) -> Label:
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l
