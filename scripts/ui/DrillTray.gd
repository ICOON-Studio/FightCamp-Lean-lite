extends VBoxContainer
## S382 DRILLCARD1 (TRAINING_SCREEN_S381.md section 3, the approved mockup): the tray above the week - LEARN and up to four
## drill cards (PadEdit.tray: this week's nights, her pins, the coach's new move, her own combinations), then "+ Build a
## combination" (opens PLAYBOOK > Combos, the one builder; it replaced the S375 combo planner card). A clicked card waits
## for a night (picked, the click-click route); the hint on the right says so. S382 PLANTRAY1: with a bout booked the
## title is "THE PLAN vs <her face> <NAME>" and the cards are the plan's (PlanCards.tray, chosen by WeekBoard); the cards
## slide in when the mode changes (booking, and back to LEARN after the fight).
##   DrillTray.make(main, f, cards, projs, on_pick, on_drill_it) -> DrillTray "DrillTray"   DrillTray.picked (static)

const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const DrillCard := preload("res://scripts/ui/DrillCard.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const PlanCards := preload("res://scripts/rules/PlanCards.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const SLOTS := 4
const FACES := "res://assets/ui/face/studio"
const SLIDE_S := 0.35
const SLIDE_PX := 60.0

## The card waiting for a night after a click ("" = none); fid|card so another fighter's pick never carries over.
static var picked := ""
## fid -> the tray's mode last drawn ("learn" / "plan"): a change slides the cards in.
static var _mode := {}


static func picked_for(fid: String) -> String:
	return picked.get_slice("|", 1) if picked.begins_with(fid + "|") else ""


static func make(main: Node, f: Dictionary, cards: Array, projs: Dictionary, on_pick: Callable, on_drill_it: Callable) -> VBoxContainer:
	var t := new()
	t.name = "DrillTray"
	t.add_theme_constant_override("separation", 8)
	var fid := str(f["id"])
	var head := UI.hbox(14)
	head.name = "TrayHead"
	var plan := PlanCards.active(f)
	# S398 Week v8: one caps title, the level ladder once for the page (MoveMastery.LADDER), the hint in plain words.
	var title := UI.caps("THE PLAN vs" if plan else "LEARN ON THE PADS")
	title.name = "TrayTitle"
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(title)
	if plan:
		_versus(head, f)
	var ladder := UI.label(MoveMastery.LADDER, 14, UI.MUTED, "body")
	ladder.name = "Ladder"
	ladder.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(ladder)
	head.add_child(UI.spacer())
	var now := picked_for(fid)
	var hint := UI.label("%s: now click an evening" % PadEdit.title(f, now) if now != "" else "Drag a card onto an evening, or click it then the evening",
		15, UI.FG if now != "" else UI.MUTED, "semi" if now != "" else "body")
	hint.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hint.name = "TrayHint"
	head.add_child(hint)
	t.add_child(head)
	var row := UI.hbox(14)
	row.name = "TrayCards"
	t.add_child(row)
	for c in cards:
		row.add_child(DrillCard.make(f, str(c), projs.get(c, {}), now == str(c), on_pick, on_drill_it))
	for i in range(cards.size(), SLOTS):
		var gap := Control.new()
		gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(gap)
	row.add_child(_build(main, f))
	# The switch slides: LEARN -> THE PLAN on booking, back after the fight (one tween, no modal).
	var mode := "plan" if plan else "learn"
	if _mode.has(fid) and str(_mode[fid]) != mode:
		row.modulate.a = 0.0
		row.ready.connect(func() -> void:
			var tw := row.create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tw.tween_property(row, "modulate:a", 1.0, SLIDE_S)
			tw.tween_property(row, "position:x", row.position.x, SLIDE_S).from(row.position.x - SLIDE_PX), CONNECT_ONE_SHOT)
	_mode[fid] = mode
	return t


## "vs" her face and first name (the face the weeks strip's poster shows).
## S397 blind Week critics ("the bars have no key"): what the card bars' parts mean, once, above the cards.
static func _key() -> HBoxContainer:
	var k := UI.hbox(6)
	k.name = "BarKey"
	k.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	for part in [[DrillCard.SLATE, "learned"], [UI.GREEN, "this week"], [UI.FG, "next level"], [DrillCard.HATCH, "past the ceiling"]]:
		var sw := ColorRect.new()
		sw.color = part[0]
		sw.custom_minimum_size = Vector2(3, 14) if str(part[1]) == "next level" else Vector2(16, 8)
		sw.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		k.add_child(sw)
		k.add_child(UI.label(str(part[1]), 14, UI.MUTED, "semi"))
		var gap := Control.new()
		gap.custom_minimum_size = Vector2(10, 0)
		k.add_child(gap)
	return k


static func _versus(head: HBoxContainer, f: Dictionary) -> void:
	var opp := PlanCards.opp(f)
	var path := FACES.path_join(str(Faces.pair(f, opp)[1]) + ".jpg")
	if ResourceLoader.exists(path):
		var tex: Texture2D = load(path)
		var a := AtlasTexture.new()   # the head: the middle half, from just above the hair
		a.atlas = tex
		var s := tex.get_size()
		a.region = Rect2(s.x * 0.25, s.y * 0.12, s.x * 0.5, s.x * 0.5)
		var face := TextureRect.new()
		face.name = "OppFace"
		face.custom_minimum_size = Vector2(44, 44)
		face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		face.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		face.texture = a
		head.add_child(face)
	var who := WB.ink(str(opp.get("first", str(opp.get("name", "")).get_slice(" ", 0))).to_upper(), 18, "bold")
	who.name = "OppName"
	head.add_child(who)


## "+ Build a combination": the Playbook's builder for her (the one builder, never a second one).
static func _build(main: Node, f: Dictionary) -> Button:
	var b := Button.new()
	b.name = "BuildCombo"
	b.focus_mode = Control.FOCUS_NONE
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(0, DrillCard.CARD_H)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for st in ["normal", "hover", "pressed", "focus"]:
		var s := UI.box(UI.PANEL if st == "normal" else Color("#f3f6fb"), UI.MUTED if st == "hover" else UI.LINE, 10, 2, 0, 0)
		b.add_theme_stylebox_override(st, s)
	b.pressed.connect(func():
		Playbook.pick = str(f["id"])
		ComboBuilder.chain = []
		main.act("go", "playbook:2"))
	var v := UI.vbox(2)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(v)
	for w in [["+", 40, "body", UI.MUTED], ["Build a combination", 19, "semi", UI.FG], ["opens the Playbook", 18, "hand", UI.MUTED]]:
		var l := UI.label(str(w[0]), int(w[1]), w[3], str(w[2]))
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(l)
	return b
