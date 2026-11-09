extends SceneTree
## S410 Fighters > Roster as painted full-body cards: every fighter has a card that opens the fighter's page, the three tiles, a
## scouted strip, the painted gym behind, and the table one click away (nothing the table shows is lost).

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

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
	FirstWeek.ana_joins(c)
	main.act("go", "fighters:0")
	await process_frame
	await process_frame

	var lucy: Button = main.find_child("Row_lucy", true, false)
	_check(lucy != null, "Lucy has a card")
	if lucy != null:
		var body: TextureRect = lucy.find_child("Body", true, false)
		_check(body != null and body.texture != null, "the card carries the full-body picture")
		_check(lucy.find_child("Paint", true, false) != null, "and the painted surface behind it")
		var tiles: Node = lucy.find_child("Tiles", true, false)
		_check(tiles != null and tiles.find_children("*", "PanelContainer", true, false).size() == 3, "condition, mood and weight tiles")
		_check(lucy.find_child("Next", true, false) != null, "the next-fight lines")
		_check(lucy.size.x <= 226.5, "a card keeps its width (%.0f), so eight fit one line" % lucy.size.x)
		_check(lucy.get_global_rect().end.x <= 1920.0, "the card is on the screen")
	var ana: Button = main.find_child("Row_ana", true, false)
	_check(ana != null, "Ana has a card too")
	if ana != null:
		var ana_tiles: Node = ana.find_child("Tiles", true, false)
		_check(ana_tiles != null and ana_tiles.find_children("*", "PanelContainer", true, false).size() == 2, "no-gi has no weight tile")
		_check(ana.find_child("Flag_ana", true, false) == null, "and no boxing flag")
	var strip: Control = main.find_child("ScoutedStrip", true, false)
	_check(strip != null, "the scouted strip sits under the cards")
	if strip != null:
		_check(strip.get_global_rect().end.x <= 1920.0, "the strip is on the screen (ends at %.0f)" % strip.get_global_rect().end.x)
		_check(strip.get_global_rect().end.y <= 1080.0, "the page fits without scrolling (ends at %.0f)" % strip.get_global_rect().end.y)
	_check(main.find_child("StripInvite_kira", true, false) != null, "a scouted prospect can be invited from the strip")
	var to_end: Control = main.find_child("View_table", true, false)
	_check(to_end != null and to_end.get_global_rect().end.x <= 1920.0, "the Table button is on the screen")
	var wall: TextureRect = main.get_node_or_null("PaintedWall")
	_check(wall != null and wall.texture.resource_path == RosterCards.BACKDROP, "the painted gym is behind the page")

	var to_table: Button = main.find_child("View_table", true, false)
	_check(to_table != null, "the table is one click away")
	if to_table != null:
		to_table.pressed.emit()
		await process_frame
		_check(main.find_child("Sort_condition", true, false) != null, "the table still sorts")
		var to_cards: Button = main.find_child("View_cards", true, false)
		to_cards.pressed.emit()
		await process_frame
		_check(main.find_child("Sort_condition", true, false) == null, "and back to the cards")

	lucy = main.find_child("Row_lucy", true, false)
	if lucy != null:
		lucy.pressed.emit()
		await process_frame
		_check(str(main.route.get("fighter", "")) == "lucy", "a card opens the fighter's page")
		_check(wall.texture.resource_path != RosterCards.BACKDROP, "the fighter's page keeps the plain wall")
	main.act("go", "world:0")
	await process_frame
	_check(wall.texture.resource_path != RosterCards.BACKDROP, "and other pages get the plain wall back")

	print("ROSTER_CARDS failures=%d" % failures)
	print("PASS roster_cards_test" if failures == 0 else "FAIL roster_cards_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
