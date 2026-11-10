extends SceneTree
## S418 the Fighters roster, the week review's pad cards and a boxer's Overview on the wood and slate look.
## The cream card frames, the scouted strip and the white pad faces are gone: a dark foot under each picture,
## a framed slate for the strip, see-through pad faces, wooden buttons on the Overview. The picture's bright
## backdrop and a flipped card's gold back stay.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/roster_slate_test.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const DrillCard := preload("res://scripts/ui/DrillCard.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	RosterCards.view = "cards"
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	await _roster()
	await _overview()
	await _review()
	_done()


## Lucy signed, Ana on the mat, Danny signed: three roster cards, as the roster page is opened in roster_cards_test.
func _roster() -> void:
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	FirstWeek.ana_joins(c)
	var danny: Dictionary = Roster.prospect(c, "danny")
	danny["state"] = "invited"
	var signed: Dictionary = Roster.sign_prospect(c, "danny", ["Jab and move", "Pad rounds", "Hill sprints"])
	_check(not signed.is_empty(), "a third boxer signs, so the roster has three cards")
	main.act("go", "fighters:0")
	await _settle(4)
	var page := main.find_child("Fighters", true, false) as Control
	_check(page != null, "Fighters draws")
	if page == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(3)
	var strip := page.find_child("ScoutedStrip", true, false) as Control
	_check(strip != null, "ScoutedStrip is still on the page")
	var cards: Array = page.find_children("Row_*", "Button", true, false)
	_check(cards.size() == 3, "three roster cards are still on the page (%d)" % cards.size())
	for card in cards:
		_card(card as Button)
	if strip != null:
		for fault in SlateWalk.faults(strip):
			_check(false, "ScoutedStrip: " + str(fault))
		var sb: StyleBox = strip.get_theme_stylebox("panel")
		print("ROSTER_SLATE ScoutedStrip style %s" % sb.get_class())
		_check(sb is StyleBoxTexture, "ScoutedStrip is a framed slate (%s)" % sb.get_class())
		var rect := strip.get_global_rect()
		print("ROSTER_SLATE scouted strip ends at x %.0f (line 1920), y %.0f (line 1080)" % [rect.end.x, rect.end.y])
		_check(rect.end.x <= 1920.0, "the scouted strip stays inside x 1920 (%.0f)" % rect.end.x)
		_check(rect.end.y <= 1080.0, "the scouted strip stays inside y 1080 (%.0f)" % rect.end.y)
	var head := page.find_child("FightersHead", true, false) as Control
	if head != null:
		for fault in SlateWalk.faults(head):
			_check(false, "FightersHead: " + str(fault))


## The card's own frame, then the foot under the picture. The picture stays out of the walk: its backdrop is bright on purpose.
func _card(card: Button) -> void:
	var sb: StyleBox = card.get_theme_stylebox("normal")
	var flat := sb as StyleBoxFlat
	var lum := flat.bg_color.get_luminance() if flat != null else -1.0
	var alpha := flat.bg_color.a if flat != null else -1.0
	print("ROSTER_SLATE %s frame a=%.2f lum=%.2f" % [card.name, alpha, lum])
	_check(flat != null and alpha >= 0.5 and lum < 0.45, "%s frame is a dark plate (lum %.2f)" % [card.name, lum])
	var art := card.find_child("Art", true, false) as Control
	var walked := false
	var box := card.get_child(0)
	for c in box.get_children():
		if str(c.name) == "Art":
			continue
		walked = true
		for fault in SlateWalk.faults(c):
			_check(false, "%s foot: %s" % [card.name, str(fault)])
	_check(walked, "%s has a foot under the picture" % card.name)
	var name_l := _first_label(box, true)
	if name_l != null:
		var ink := name_l.get_theme_color("font_color")
		print("ROSTER_SLATE %s name lum=%.2f" % [card.name, ink.get_luminance()])
		_check(ink.get_luminance() >= 0.45, "%s name plate reads on the dark foot (lum %.2f)" % [card.name, ink.get_luminance()])
	if art != null:
		var tag := _first_label(art, false)
		if tag != null:
			var col := tag.get_theme_color("font_color")
			print("ROSTER_SLATE %s weight label lum=%.2f" % [card.name, col.get_luminance()])
			_check(col.get_luminance() >= 0.7, "%s weight class on the picture still reads (lum %.2f)" % [card.name, col.get_luminance()])
	var rect := card.get_global_rect()
	print("ROSTER_SLATE %s wide %.0f ends at x %.0f (line 1920)" % [card.name, rect.size.x, rect.end.x])
	_check(rect.size.x <= 226.5, "%s keeps its width (%.0f of 226)" % [card.name, rect.size.x])
	_check(rect.end.x <= 1920.0, "%s stays inside x 1920 (%.0f)" % [card.name, rect.end.x])


func _overview() -> void:
	var c: Career = main.career
	var id := str(c.fighter()["id"])
	main.act("fighter", id)
	await _settle(4)
	var page := main.find_child("FighterPage", true, false) as Control
	_check(page != null, "the boxer's page draws")
	if page == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(3)
	var overview := page.find_child("DarkOverview", true, false) as Control
	_check(overview != null, "the Overview is on the page")
	var walked: Control = overview if overview != null else page
	for fault in SlateWalk.faults(walked):
		_check(false, "Overview: " + str(fault))
	var find := _button_text(page, "Find a bout")
	_check(find != null, "Find a bout is still on the Overview")
	if find != null:
		var find_sb: StyleBox = find.get_theme_stylebox("normal")
		print("ROSTER_SLATE Find a bout style %s variation %s" % [find_sb.get_class(), find.theme_type_variation])
		_check(find_sb is StyleBoxTexture, "Find a bout is a wooden button (%s)" % find_sb.get_class())
	for words in ["Plan the week", "Fight plan"]:
		var b := _button_text(page, words)
		_check(b != null, "%s is still on the Overview" % words)
		if b != null:
			var quiet_sb: StyleBox = b.get_theme_stylebox("normal")
			print("ROSTER_SLATE %s style %s variation %s" % [words, quiet_sb.get_class(), b.theme_type_variation])
			_check(quiet_sb is StyleBoxTexture, "%s is a wooden button (%s)" % [words, quiet_sb.get_class()])
	var rect := walked.get_global_rect()
	print("ROSTER_SLATE the Overview ends at x %.0f (line 1920), y %.0f (line 1080)" % [rect.end.x, rect.end.y])
	_check(rect.end.x <= 1920.0, "the Overview stays inside x 1920 (%.0f)" % rect.end.x)
	_check(rect.end.y <= 1080.0, "the Overview stays inside y 1080 (%.0f)" % rect.end.y)


## A week review with pad cards, reached the way card_flip_test opens that pop-up (review_reveal_test checks the headline rule only).
func _review() -> void:
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	f["combos"]["1-1"] = 27.0
	var nights: Dictionary = PadWeek.nights_of(f)
	var first := int((nights["pads"] as Array)[0]) if not (nights["pads"] as Array).is_empty() else -1
	_check(first >= 0, "the boxer has a pad night this week")
	if first < 0:
		return
	PadEdit.clear(f, nights, first)
	_check(PadEdit.place(f, nights, first, "combo:1-1"), "the 1-1 is on the first pad night")
	for i in 14:
		if c.review_pending:
			break
		main.run_to_stop()
	_check(c.review_pending, "the week ran to its review")
	main.act("review")
	await _settle(4)
	var page := main.modal_node() as Control
	_check(page != null and str(main.modal.get("type", "")) == "review", "the week review pop-up is open")
	if page == null:
		return
	root.size = Vector2i(1920, 1080)
	var host: Node = page.get_parent() if page.get_parent() != null else page
	WoodKit.ink(host)
	await _settle(3)
	var cards: Array = page.find_children("PadCard_*", "", true, false)
	_check(not cards.is_empty(), "the review has pad cards (%d)" % cards.size())
	for card in cards:
		var face := card.find_child("Face", true, false) as Control
		_check(face != null, "%s has its face" % card.name)
		if face == null:
			continue
		for fault in SlateWalk.faults(face):
			_check(false, "%s: %s" % [card.name, str(fault)])
		var fsb := face.get_theme_stylebox("panel") as StyleBoxFlat
		var fill := fsb.bg_color.a if fsb != null else -1.0
		print("ROSTER_SLATE %s face fill a=%.2f" % [card.name, fill])
		_check(fsb != null and fill < 0.5, "%s face is see-through (a=%.2f)" % [card.name, fill])
		var back: Node = card.get("back")
		if back != null:
			var gsb := (back as Control).get_theme_stylebox("panel") as StyleBoxFlat
			var glum := gsb.bg_color.get_luminance() if gsb != null else -1.0
			print("ROSTER_SLATE %s gold back lum=%.2f" % [card.name, glum])
			_check(gsb != null and gsb.bg_color.is_equal_approx(DrillCard.GOLD_BG), "%s gold back stays gold" % card.name)
	var rect := page.get_global_rect()
	print("ROSTER_SLATE the review ends at x %.0f (line 1920), y %.0f (line 1080)" % [rect.end.x, rect.end.y])
	_check(rect.end.x <= 1920.0, "the review stays inside x 1920 (%.0f)" % rect.end.x)
	_check(rect.end.y <= 1080.0, "the review stays inside y 1080 (%.0f)" % rect.end.y)


func _first_label(n: Node, skip_art: bool) -> Label:
	if n is Label:
		return n
	for c in n.get_children():
		if skip_art and str(c.name) == "Art":
			continue
		var got := _first_label(c, skip_art)
		if got != null:
			return got
	return null


func _button_text(root: Node, text: String) -> Button:
	for n in root.find_children("*", "Button", true, false):
		if (n as Button).text == text:
			return n
	return null


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("ROSTER_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
