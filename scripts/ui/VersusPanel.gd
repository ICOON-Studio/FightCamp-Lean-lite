extends RefCounted
## S410 operator, Q-S294-134: "Build it like the right, painted surfaces" (docs/mockups/s409/concepts/versus_painted.png).
## A bout offer as a versus screen: the two boxers on a red and a blue wall, the tale of the tape between them, the win chance and
## the answer. Numbers are the game's; a thing the game does not know (venue, last five) is left off. The stats, the ranks at
## stake, the file and the terms stay one click away on the full report (BoutPage).
##   VersusPanel.build(main, c, f, o, opp, offer_id, wf, answer) -> Control

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
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
const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const CARD_W := 640.0
const NAME_COLOUR := Color("#f6dfb4")
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


static func tape_rows(f: Dictionary, opp: Dictionary, her_cm: float = 0.0) -> Array:
	return TapeRows.rows(f, opp, her_cm)


## Corner tags the offer and fight night share: Shape and Mood on the club side, Style on the other.
static func tags_for(f: Dictionary, opp: Dictionary) -> Array:
	var word: Array = WB_KIT.fatigue_word(FighterProfile.fatigue(f), false)
	var shape := "Shape: %s · Mood: %s" % [str(word[0]).capitalize(), FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))]
	return [shape, "Style: %s" % str(opp.get("style", ""))]


static func build(main: Node, c: Career, f: Dictionary, o: Dictionary, opp: Dictionary, offer_id: String, wf: Dictionary, answer: HBoxContainer) -> Control:
	var root := UI.hbox(0)
	root.name = "Versus"
	root.custom_minimum_size = Vector2(0, 900)
	var stems: Array = Faces.pair(f, opp)
	var poses: Array = FighterPose.pair(str(stems[0]), str(stems[1]), offer_id)
	var crests: Array = ClubCrest.pair(c.gym_name, str(opp["club"]))
	var tags: Array = tags_for(f, opp)
	root.add_child(side(str(f["name"]), "%s · your fighter" % str(f["wc"]), str(stems[0]), "red", str(tags[0]), false, int(poses[0]), str(crests[0]), hash(offer_id + "r")))
	root.add_child(_card(main, c, f, o, opp, offer_id, wf, answer, str(stems[0])))
	root.add_child(side(str(opp["name"]), "%s · %s" % [str(f["wc"]), str(opp["club"])], str(stems[1]), "blue", str(tags[1]), true, int(poses[1]), str(crests[1]), hash(offer_id + "b")))
	return root


## One half. sub_px / tag_px / foot let fight night keep every word at 20 px and the tag clear of the feet.
## foot 0 is the offer: the tag sits on the picture, as before.
static func side(who: String, sub: String, stem: String, corner: String, tag_text: String, right: bool, pose: int = 0, crest: String = "", key: int = 0, sub_px: int = 19, tag_px: int = 17, foot: float = 0.0, bleed: bool = true) -> Control:
	var col := Control.new()
	col.name = "Side_" + corner
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.clip_contents = true
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if crest != "":   # S412 "behind the maybe the lgoos of each gym ?"
		col.add_child(_crest(crest, right, bleed))
	var pic: Control = VersusLive.make(stem, corner, right, key)   # S412 shadowboxing, live; no picture (a test): the baked pose
	if pic == null:
		pic = RosterCards.body(FighterPose.picture(kit_stem(stem, corner), pose))
	if pic != null:
		pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		pic.offset_top = 70
		pic.offset_bottom = -foot
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
	var small := UI.label(sub, sub_px, Color.WHITE, "semi")
	small.horizontal_alignment = align
	words.add_child(small)
	col.add_child(words)
	col.add_child(_tag(tag_text, right, tag_px, foot))
	return col


static func _crest(crest: String, right: bool, bleed: bool = true) -> TextureRect:
	var t := TextureRect.new()
	t.name = "Crest"
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.texture = load(ClubCrest.path(crest))
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	t.offset_top = 190
	t.offset_bottom = -160
	var outward := 70.0 if right else -70.0   # the boxer stands on its middle: slide it to the outer side
	t.offset_left = outward
	# The offer can bleed past its half. A full-screen page stops at x 1920, so the right crest stays inside.
	t.offset_right = outward if bleed or not right else 0.0
	t.modulate = Color(1, 1, 1, 0.26)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


static func _tag(text: String, right: bool, px: int = 17, foot: float = 0.0) -> Control:
	var p := PanelContainer.new()
	p.name = "CornerTag"
	# S419: chalk on the red or blue side. Fight night (foot > 0) puts it on a dark plate, 16 px under the figure.
	var bg := Color(0.07, 0.05, 0.04, 0.88) if foot > 0.0 else Color(1, 1, 1, 0.04)
	p.add_theme_stylebox_override("panel", UI.box(bg, Color(WoodKit.SOFT, 0.35), 4, 1, 14, 8))
	p.add_child(UI.label(text, px, WoodKit.INK, "bold"))
	p.anchor_top = 1.0
	p.anchor_bottom = 1.0
	p.anchor_left = 1.0 if right else 0.0
	p.anchor_right = p.anchor_left
	p.offset_top = -(foot - 16.0) if foot > 0.0 else -10.0
	p.offset_bottom = -8.0 if foot > 0.0 else -10.0
	p.grow_vertical = Control.GROW_DIRECTION_BEGIN
	p.grow_horizontal = Control.GROW_DIRECTION_BEGIN if right else Control.GROW_DIRECTION_END
	return p


static func _card(main: Node, c: Career, f: Dictionary, o: Dictionary, opp: Dictionary, offer_id: String, wf: Dictionary, answer: HBoxContainer, stem: String) -> Control:
	var p := PanelContainer.new()
	p.name = "VersusCard"
	p.custom_minimum_size = Vector2(CARD_W, 0)
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	# The frame is 22 px. Content inset stays 26 across and 22 down, so the words clear the brass and the card does not grow.
	p.add_theme_stylebox_override("panel", WoodKit.slate(26, 22))
	var v := UI.vbox(0)
	p.add_child(v)
	var day := int(o["day"])
	v.add_child(_centre(UI.label("%s · 3 X 3 MIN" % Clock.fmt(day).to_upper(), 22, UI.FG, "bold")))
	var weeks := int((day - c.day) / 7.0)
	var time_words := "%d week%s to prepare" % [weeks, "" if weeks == 1 else "s"] if weeks >= 1 else "no time for a camp"
	v.add_child(_centre(UI.label("%s to the club · %s · answer by %s" % [UI.money(BoutRules.TICKET_CUT), time_words, Clock.fmt(int(o["expires"]))], UI.TINY + 1, UI.MUTED)))
	v.add_child(_centre(UI.display("VS", 64, UI.RED)))
	var chip := UI.chip("Not safe" if bool(o["mismatch"]) else ("Weight at risk" if not bool(wf["ok"]) else "Legal, even match"),
		"red" if bool(o["mismatch"]) else ("amber" if not bool(wf["ok"]) else "green"))
	chip.name = "VersusChip"
	chip.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(chip)
	v.add_child(gap(4))
	_rows(v, f, opp, wf, stem)
	v.add_child(gap(10))
	v.add_child(_read(c, f, opp, day))
	v.add_child(gap(8))
	_answer(v, main, offer_id, answer)
	return p


static func _centre(l: Label) -> Label:
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


static func gap(px: float) -> Control:
	var g := Control.new()
	g.custom_minimum_size = Vector2(0, px)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return g


## Record, age, height, reach and stance come from TapeRows. The weight row: her forecast for the day against the opponent's weigh-in, the limit in the title.
static func _rows(v: VBoxContainer, f: Dictionary, opp: Dictionary, wf: Dictionary, stem: String) -> void:
	var by := {}
	for r in tape_rows(f, opp, Faces.cm(stem)):
		by[str(r["label"])] = r
	draw_fact(v, by["Record"], "RECORD")
	draw_fact(v, by["Age"], "AGE")
	var heavy := not bool(wf["ok"])
	# S420 operator ("i meant weight"): her weight in her column; the limit moves into the row's title.
	var ow := TapeRows.opp_weight(opp, float(f["limit"]))
	pair_row(v, "WEIGHT, LIMIT %.0f" % float(f["limit"]), "%.1f kg" % float(wf["day"]), ("%.1f kg" % ow) if ow > 0.0 else "?", UI.RED if heavy else UI.FG, UI.FG)
	v.get_child(v.get_child_count() - 1).name = "Tape_WEIGHT"   # a fixed name; the title carries the limit
	draw_fact(v, by["Height"], "HEIGHT")
	if by.has("Reach"):   # S420 operator: "reach is not shown in the still i saw" - fight night had it, the offer did not
		draw_fact(v, by["Reach"], "REACH")
	draw_fact(v, by["Stance"], "STANCE")


## One paired row, the same drawing the offer uses. The better side is tinted green by the caller.
static func draw_fact(v: VBoxContainer, row: Dictionary, title: String, label_px: int = 16, value_px: int = 25, mid_w: float = 150.0) -> void:
	var lc := UI.FG
	var rc := UI.FG
	if str(row.get("better", "")) == "left":
		lc = UI.GREEN
	elif str(row.get("better", "")) == "right":
		rc = UI.GREEN
	pair_row(v, title, str(row["left"]), str(row["right"]), lc, rc, str(row.get("why", "")), label_px, value_px, mid_w)


static func pair_row(v: VBoxContainer, title: String, left: String, right: String, left_colour: Color, right_colour: Color, why: String = "", label_px: int = 16, value_px: int = 25, mid_w: float = 150.0) -> void:
	var line := ColorRect.new()
	line.color = Color(WoodKit.SOFT, 0.35)
	line.custom_minimum_size = Vector2(0, 1)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(line)
	var h := UI.hbox(0)
	h.name = "Tape_" + title
	h.custom_minimum_size = Vector2(0, 50)
	h.add_child(_cell(left, left_colour, value_px))
	var mid := _centre(UI.label(title, label_px, UI.MUTED, "caps"))
	mid.custom_minimum_size = Vector2(mid_w, 0)
	mid.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(mid)
	var rv := _cell(right, right_colour, value_px)
	if why != "":
		rv.tooltip_text = why
		rv.mouse_filter = Control.MOUSE_FILTER_PASS
	h.add_child(rv)
	v.add_child(h)


static func _cell(text: String, colour: Color, px: int = 25) -> Label:
	var l := _centre(UI.label(text, px, colour, "bold"))
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return l


static func _read(c: Career, f: Dictionary, opp: Dictionary, day: int) -> Control:
	var read := BoutCompare.win_read(c, f, opp, BoutRead.camp_for(f, day - c.day))
	var p := PanelContainer.new()
	p.name = "VersusRead"
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 14, 10))
	var h := UI.hbox(12)
	p.add_child(h)
	var num := UI.mono("%d%%" % int(read["mid"]), 34, UI.GREEN if int(read["lo"]) >= 50 else (UI.RED if int(read["hi"]) <= 50 else UI.FG))
	num.name = "VersusWin"
	num.tooltip_text = "%d to %d%%" % [int(read["lo"]), int(read["hi"])]
	num.mouse_filter = Control.MOUSE_FILTER_PASS
	var tile := UI.vbox(0)
	tile.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	tile.add_child(_centre(UI.label("WIN CHANCE", UI.TINY, UI.MUTED, "caps")))
	tile.add_child(_centre(num))
	h.add_child(tile)
	var words := UI.vbox(2)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	words.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	words.add_child(UI.label("%s, %d%% to %d%%. Scouting report: %d of %d found" % [
		str(read["sure"]).left(1).to_upper() + str(read["sure"]).substr(1), int(read["lo"]), int(read["hi"]),
		int(read["found"]), int(read["all"])], 16, UI.FG, "semi", true))
	var stakes := UI.hbox(14)
	stakes.name = "VersusStakes"
	stakes.add_child(UI.label("A win: %s" % str(read["win_word"]), UI.SMALL, UI.GREEN, "bold"))
	stakes.add_child(UI.label("A loss: %s" % str(read["loss_word"]), UI.SMALL, UI.MUTED, "bold"))
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
	# Pass stays BtnQuiet. The quiet tab vanished on the paper card, so it was forced onto the plank; on the slate the tab reads.
	for b in buttons:
		(b as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(b)
	answer.queue_free()
	v.add_child(row)
	for r in reasons:
		var l := r as Label
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v.add_child(gap(6))
		v.add_child(l)
