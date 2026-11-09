extends RefCounted
## S410 operator, Q-S294-134: "Build it like the right, painted surfaces" (docs/mockups/s409/concepts/versus_painted.png).
## A bout offer as a versus screen: the two boxers on a red and a blue wall, the tale of the tape between them, the win chance and
## the answer. Numbers are the game's; a thing the game does not know (venue, last five) is left off. The stats, the ranks at
## stake, the file and the terms stay one click away on the full report (BoutPage).
##   VersusPanel.build(main, c, f, o, opp, offer_id, wf, answer) -> Control

const UI := preload("res://scripts/ui/UI.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")

const BACKDROP := "res://assets/ui/art/versus_backdrop.jpg"
const FighterPose := preload("res://scripts/rules/FighterPose.gd")
const ClubCrest := preload("res://scripts/rules/ClubCrest.gd")
const VersusLive := preload("res://scripts/ui/VersusLive.gd")
const CARD_W := 640.0
const NAME_COLOUR := Color("#f6dfb4")
const PAPER := Color("#fbf1df")
const PAPER_DEEP := Color("#efe0c6")
const EDGE := Color("#c9b490")
const INK := Color("#231f1b")
const INK_SOFT := Color("#6e6256")
## Bodies baked in the blue kit by default (tools/bake_hub_sprites.gd BLUE_STEMS); their "_alt" picture is the red kit, and the
## other way round for the rest.
const BLUE_KIT := ["02", "08", "12", "14", "17", "20", "23"]

## The offer whose full report is open ("" = none): opening another offer starts on its versus screen.
static var report_for := ""


static func show_report(main: Node, offer_id: String) -> void:
	report_for = offer_id
	main.render()


static func kit_stem(stem: String, corner: String) -> String:
	var worn := "blue" if stem.right(2) in BLUE_KIT else "red"
	return stem if worn == corner else stem + "_alt"


static func build(main: Node, c: Career, f: Dictionary, o: Dictionary, opp: Dictionary, offer_id: String, wf: Dictionary, answer: HBoxContainer) -> Control:
	var root := UI.hbox(0)
	root.name = "Versus"
	root.custom_minimum_size = Vector2(0, 900)
	var stems: Array = Faces.pair(f, opp)
	var poses: Array = FighterPose.pair(str(stems[0]), str(stems[1]), offer_id)
	var crests: Array = ClubCrest.pair(c.gym_name, str(opp["club"]))
	var word: Array = WB_KIT.fatigue_word(FighterProfile.fatigue(f), false)
	var shape := "Shape: %s · Mood: %s" % [str(word[0]).capitalize(), FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))]
	root.add_child(_side(str(f["name"]), "%s · your fighter" % str(f["wc"]), str(stems[0]), "red", shape, false, int(poses[0]), str(crests[0]), hash(offer_id + "r")))
	root.add_child(_card(main, c, f, o, opp, offer_id, wf, answer, str(stems[0])))
	root.add_child(_side(str(opp["name"]), "%s · %s" % [str(f["wc"]), str(opp["club"])], str(stems[1]), "blue", "Style: %s" % str(opp["style"]), true, int(poses[1]), str(crests[1]), hash(offer_id + "b")))
	return root


static func _side(who: String, sub: String, stem: String, corner: String, tag_text: String, right: bool, pose: int = 0, crest: String = "", key: int = 0) -> Control:
	var col := Control.new()
	col.name = "Side_" + corner
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.clip_contents = true
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if crest != "":   # S412 "behind the maybe the lgoos of each gym ?"
		col.add_child(_crest(crest, right))
	var pic: Control = VersusLive.make(stem, corner, right, key)   # S412 shadowboxing, live; no picture (a test): the baked pose
	if pic == null:
		pic = RosterCards.body(FighterPose.picture(kit_stem(stem, corner), pose))
	if pic != null:
		pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		pic.offset_top = 70
		if pic is TextureRect:
			(pic as TextureRect).flip_h = not right   # S412 the pictures face left: the left side turns, so both face the middle
		col.add_child(pic)
	var words := UI.vbox(0)
	words.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	var align := HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	var title := UI.display(who, 56, NAME_COLOUR)
	title.horizontal_alignment = align
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.55))
	title.add_theme_constant_override("shadow_offset_y", 3)
	words.add_child(title)
	var small := UI.label(sub, UI.BODY, Color.WHITE, "semi")
	small.horizontal_alignment = align
	words.add_child(small)
	col.add_child(words)
	col.add_child(_tag(tag_text, right))
	return col


static func _crest(crest: String, right: bool) -> TextureRect:
	var t := TextureRect.new()
	t.name = "Crest"
	t.texture = load(ClubCrest.path(crest))
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	t.offset_top = 190
	t.offset_bottom = -160
	var outward := 70.0 if right else -70.0   # the boxer stands on its middle: slide it to the outer side
	t.offset_left = outward
	t.offset_right = outward
	t.modulate = Color(1, 1, 1, 0.26)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


static func _tag(text: String, right: bool) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(PAPER, EDGE, 8, 2, 14, 8))
	p.add_child(UI.label(text, 17, INK, "bold"))
	p.anchor_top = 1.0
	p.anchor_bottom = 1.0
	p.anchor_left = 1.0 if right else 0.0
	p.anchor_right = p.anchor_left
	p.offset_top = -10
	p.offset_bottom = -10
	p.grow_vertical = Control.GROW_DIRECTION_BEGIN
	p.grow_horizontal = Control.GROW_DIRECTION_BEGIN if right else Control.GROW_DIRECTION_END
	return p


static func _card(main: Node, c: Career, f: Dictionary, o: Dictionary, opp: Dictionary, offer_id: String, wf: Dictionary, answer: HBoxContainer, stem: String) -> Control:
	var p := PanelContainer.new()
	p.name = "VersusCard"
	p.custom_minimum_size = Vector2(CARD_W, 0)
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.add_theme_stylebox_override("panel", UI.box(PAPER, EDGE, 12, 4, 26, 18))
	var v := UI.vbox(0)
	p.add_child(v)
	var day := int(o["day"])
	v.add_child(_centre(UI.label("%s · 3 X 3 MIN" % Clock.fmt(day).to_upper(), 22, INK, "bold")))
	var weeks := int((day - c.day) / 7.0)
	var time_words := "%d week%s to prepare" % [weeks, "" if weeks == 1 else "s"] if weeks >= 1 else "no time for a camp"
	v.add_child(_centre(UI.label("%s to the club · %s · answer by %s" % [UI.money(BoutRules.TICKET_CUT), time_words, Clock.fmt(int(o["expires"]))], UI.TINY + 1, INK_SOFT)))
	v.add_child(_centre(UI.display("VS", 64, UI.RED)))
	var chip := UI.chip("Not safe" if bool(o["mismatch"]) else ("Weight at risk" if not bool(wf["ok"]) else "Legal, even match"),
		"red" if bool(o["mismatch"]) else ("amber" if not bool(wf["ok"]) else "green"))
	chip.name = "VersusChip"
	chip.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(chip)
	v.add_child(_gap(8))
	_rows(v, f, opp, wf, stem)
	v.add_child(_gap(10))
	v.add_child(_read(c, f, opp, day))
	v.add_child(_gap(12))
	_answer(v, main, offer_id, answer)
	return p


static func _centre(l: Label) -> Label:
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


static func _gap(px: float) -> Control:
	var g := Control.new()
	g.custom_minimum_size = Vector2(0, px)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return g


static func _rows(v: VBoxContainer, f: Dictionary, opp: Dictionary, wf: Dictionary, stem: String) -> void:
	var mine := int(Faces.CM.get(stem, Faces.MEN_CM.get(stem, 0)))
	var theirs := int(opp.get("height", 0))
	var heavy := not bool(wf["ok"])
	var rows: Array = [
		["RECORD", "%d-%d" % [int(f["w"]), int(f["l"])], "%d-%d" % [int(opp["w"]), int(opp["l"])], INK],
		["AGE", str(int(f["age"])), str(int(opp["age"])), INK],
		["ON THE DAY", "%.1f kg" % float(wf["day"]), "limit %.1f" % float(f["limit"]), UI.RED if heavy else INK],
		["HEIGHT", "%d cm" % mine if mine > 0 else "-", "%d cm" % theirs if theirs > 0 else "-", UI.GREEN if mine > theirs and theirs > 0 else INK],
		["STANCE", str(f["stance"]).capitalize(), str(opp["stance"]).capitalize(), INK],
	]
	for r in rows:
		var line := ColorRect.new()
		line.color = EDGE
		line.custom_minimum_size = Vector2(0, 1)
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(line)
		var h := UI.hbox(0)
		h.name = "Tape_" + str(r[0])
		h.custom_minimum_size = Vector2(0, 50)
		h.add_child(_cell(str(r[1]), r[3]))
		var mid := _centre(UI.label(str(r[0]), UI.SMALL, INK_SOFT, "caps"))
		mid.custom_minimum_size = Vector2(150, 0)
		mid.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(mid)
		h.add_child(_cell(str(r[2]), INK))
		v.add_child(h)


static func _cell(text: String, colour: Color) -> Label:
	var l := _centre(UI.label(text, 25, colour, "bold"))
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return l


static func _read(c: Career, f: Dictionary, opp: Dictionary, day: int) -> Control:
	var read := BoutCompare.win_read(c, f, opp, BoutRead.camp_for(f, day - c.day))
	var p := PanelContainer.new()
	p.name = "VersusRead"
	p.add_theme_stylebox_override("panel", UI.box(PAPER_DEEP, Color(0, 0, 0, 0), 8, 0, 14, 10))
	var h := UI.hbox(12)
	p.add_child(h)
	var num := UI.mono("%d%%" % int(read["mid"]), 34, UI.GREEN if int(read["lo"]) >= 50 else (UI.RED if int(read["hi"]) <= 50 else INK))
	num.name = "VersusWin"
	num.tooltip_text = "%d to %d%%" % [int(read["lo"]), int(read["hi"])]
	num.mouse_filter = Control.MOUSE_FILTER_PASS
	var tile := UI.vbox(0)
	tile.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	tile.add_child(_centre(UI.label("WIN CHANCE", UI.TINY, INK_SOFT, "caps")))
	tile.add_child(_centre(num))
	h.add_child(tile)
	var words := UI.vbox(2)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	words.add_child(UI.label("%s · %d of %d found on the file" % [str(read["sure"]).left(1).to_upper() + str(read["sure"]).substr(1), int(read["found"]), int(read["all"])], 18, INK, "semi"))
	var stakes := UI.hbox(14)
	stakes.name = "VersusStakes"
	stakes.add_child(UI.label("A win: %s" % str(read["win_word"]), UI.SMALL, UI.GREEN, "bold"))
	stakes.add_child(UI.label("A loss: %s" % str(read["loss_word"]), UI.SMALL, INK_SOFT, "bold"))
	words.add_child(stakes)
	h.add_child(words)
	return p


## The answer row BoutPage built (Accept, Pass, the reason line): its buttons go on the card beside the full report.
static func _answer(v: VBoxContainer, main: Node, offer_id: String, answer: HBoxContainer) -> void:
	var row := UI.hbox(10)
	row.name = "VersusAnswer"
	var report := UI.button("Full report", "Btn", show_report.bind(main, offer_id))
	report.name = "FullReport"
	report.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(report)
	var reasons: Array = []
	var buttons: Array = []
	for n in answer.get_children():
		answer.remove_child(n)
		(buttons if n is Button else reasons).append(n)
	buttons.reverse()   # Pass, then Accept on the right, as the picture has it
	for b in buttons:
		(b as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if (b as Control).name == "Pass":   # the quiet style all but vanishes on paper
			(b as Control).theme_type_variation = "Btn"
		row.add_child(b)
	answer.queue_free()
	v.add_child(row)
	for r in reasons:
		var l := r as Label
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v.add_child(_gap(6))
		v.add_child(l)
