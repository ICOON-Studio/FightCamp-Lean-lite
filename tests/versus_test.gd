extends SceneTree
## S410 a bout offer's first screen: both boxers, the win chance, Accept live on a legal offer and refused on an unsafe one,
## and everything from the old page one click away on the full report. S535 OFFERBUILD1 (owner Q-S294-296 "Yes, build it"):
## that screen is the host club's letter now, not the versus card with the tale of the tape (tests/bout_offer_letter_test.gd
## holds the letter's own sections and numbers); the red and blue wall went with the card.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var f: Dictionary = c.fighter()
	f["offers"].append(Bouts._offer("lucy:t1", (Data.OPPONENTS[0] as Dictionary).duplicate(true), c.day + 30, c.day + 6, 4))
	f["offers"].append(Bouts._offer("lucy:t2", Data.MISMATCH.duplicate(true), c.day + 30, c.day + 6, 4))

	main.act("openBout", "lucy:t1")
	await process_frame
	await process_frame
	var card: Control = main.find_child("OfferLetter", true, false)
	_check(card != null, "the offer opens on the host club's letter")
	_check(main.find_child("VersusCard", true, false) == null, "the versus card with the tale of the tape is gone from the offer")
	_check(main.find_child("OfferMine", true, false) != null and main.find_child("OfferOpp", true, false) != null, "a boxer on each side")
	for side in ["OfferMine", "OfferOpp"]:
		var slate: Node = main.find_child(side, true, false)
		if slate != null:
			var body: TextureRect = slate.find_child("Body", true, false)
			_check(body != null and body.texture != null, "%s has the boxer's picture" % side)
	for row in ["Decides_Record", "Decides_Reach", "Decides_Experience"]:
		_check(main.find_child(row, true, false) != null, "what decides it shows " + row)
	var win: Label = main.find_child("ReadWin", true, false)
	_check(win != null and win.text.ends_with("%"), "the win chance is on the coach's read (%s)" % ("?" if win == null else win.text))
	_check(main.find_child("IfWin", true, false) != null and main.find_child("IfLoss", true, false) != null, "what a win and a loss change is on the letter")
	var wall: TextureRect = main.get_node_or_null("PaintedWall")
	_check(wall != null and wall.texture.resource_path != VersusPanel.BACKDROP, "the gym wall is behind it, not the red and blue one")
	var answer: Control = main.find_child("OfferAnswer", true, false)
	if answer != null:
		_check(answer.get_global_rect().end.y <= 1080.0, "the letter and its answer fit the screen (ends at %.0f)" % answer.get_global_rect().end.y)
	var accept: Button = main.find_child("Accept", true, false)
	_check(accept != null and not accept.disabled, "Accept is live on a legal offer")
	_check(main.find_child("Pass", true, false) != null, "and Pass is there")

	var report: Button = main.find_child("FullReport", true, false)
	_check(report != null, "the full report is one click away")
	if report != null:
		report.pressed.emit()
		await process_frame
		_check(main.find_child("BoutStats", true, false) != null and main.find_child("BoutRead", true, false) != null, "the stats and the ranks at stake are on it")
		_check(main.find_child("Accept", true, false) != null, "and the answer buttons")
	var back: Button = main.find_child("BackToVersus", true, false)
	_check(back != null, "a way back to the letter")
	if back != null:
		back.pressed.emit()
		await process_frame
		_check(main.find_child("OfferLetter", true, false) != null, "back on the letter")

	main.act("openBout", "lucy:t2")
	await process_frame
	var unsafe: Button = main.find_child("Accept", true, false)
	_check(unsafe != null and unsafe.disabled, "an unsafe offer cannot be accepted")
	_check(unsafe != null and unsafe.tooltip_text.contains("sanction"), "and the button says why")

	accept = null
	main.act("openBout", "lucy:t1")
	await process_frame
	accept = main.find_child("Accept", true, false)
	if accept != null:
		accept.pressed.emit()
		await process_frame
	_check(not (f["bout"] as Dictionary).is_empty(), "Accept books the bout")
	main.act("go", "world:0")
	await process_frame
	_check(wall.texture.resource_path != VersusPanel.BACKDROP, "other pages keep the plain wall")

	print("VERSUS failures=%d" % failures)
	print("PASS versus_test" if failures == 0 else "FAIL versus_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
