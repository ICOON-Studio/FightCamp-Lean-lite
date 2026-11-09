extends SceneTree
## S410 a bout offer as a versus screen: both boxers, the tape, the win chance, Accept live on a legal offer and refused on an
## unsafe one, and everything from the old page one click away on the full report.

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
	var card: Control = main.find_child("VersusCard", true, false)
	_check(card != null, "the offer opens on the versus screen")
	_check(main.find_child("Side_red", true, false) != null and main.find_child("Side_blue", true, false) != null, "a boxer on each side")
	var blue: Node = main.find_child("Side_blue", true, false)
	if blue != null:
		var body: TextureRect = blue.find_child("Body", true, false)
		_check(body != null and body.texture != null and not body.flip_h, "the right-hand boxer has a picture and faces the middle")   # S412: the pictures already face left, so only the left side turns
	var red: Node = main.find_child("Side_red", true, false)
	if red != null:
		var red_body: TextureRect = red.find_child("Body", true, false)
		_check(red_body != null and red_body.texture != null and red_body.flip_h, "the left-hand boxer has a picture and is turned to face the middle")
	for row in ["RECORD", "AGE", "ON THE DAY", "HEIGHT", "STANCE"]:
		_check(main.find_child("Tape_" + row, true, false) != null, "the tape shows " + row)
	var win: Label = main.find_child("VersusWin", true, false)
	_check(win != null and win.text.ends_with("%"), "the win chance is on the card (%s)" % ("?" if win == null else win.text))
	_check(main.find_child("VersusStakes", true, false) != null, "what a win and a loss change is on the card")
	var wall: TextureRect = main.get_node_or_null("PaintedWall")
	_check(wall != null and wall.texture.resource_path == VersusPanel.BACKDROP, "the red and blue wall is behind it")
	if card != null:
		_check(card.get_global_rect().end.y <= 1080.0, "the whole card fits the screen (ends at %.0f)" % card.get_global_rect().end.y)
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
	_check(back != null, "a way back to the versus screen")
	if back != null:
		back.pressed.emit()
		await process_frame
		_check(main.find_child("VersusCard", true, false) != null, "back on the versus screen")

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
	_check(wall.texture.resource_path != VersusPanel.BACKDROP, "other pages get the plain wall back")

	print("VERSUS failures=%d" % failures)
	print("PASS versus_test" if failures == 0 else "FAIL versus_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
