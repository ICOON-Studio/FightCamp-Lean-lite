extends SceneTree
## S418 Club > People on the wood and slate look. The cream cards are gone: the owner and each coach sit on a framed
## slate, the small tiles are see-through with a chalk outline, and no word keeps a paper ink on a dark surface.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/people_slate_test.gd

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	await _settle(2)
	main.act("quick")
	main.act("go", "gym:1")
	await _settle(6)
	var page := main.find_child("PeoplePage", true, false) as Control
	_check(page != null, "Club > People draws")
	if page == null:
		_done()
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(3)
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))
	_check(page.find_child("HeadCoachRow", true, false) != null, "the owner card is on the page")
	var coach := false
	for id in ["reid", "hale"]:
		if page.find_child("Assistant_" + id, true, false) != null:
			coach = true
	_check(coach, "a coach card is on the page")
	for id in ["assistant", "strength", "physio", "cutman"]:
		_check(page.find_child("Role_" + id, true, false) != null, "hire tile Role_%s is on the page" % id)
	var last := _last_card(page)
	print("PEOPLE_SLATE the last card ends at y %.0f" % last)
	_check(last <= 1080.0, "the page ends at or above 1080 (%.0f)" % last)
	_done()


func _last_card(page: Control) -> float:
	var last := page.get_global_rect().end.y
	for n in page.find_children("*", "PanelContainer", true, false):
		var r := (n as Control).get_global_rect()
		if r.end.y > last:
			last = r.end.y
	return last


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("PEOPLE_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
