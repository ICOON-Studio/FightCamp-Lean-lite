extends SceneTree
## S417 the Training week page on the wood and slate look. The cream sheet and the white cards are gone: one framed
## slate, see-through cards with a chalk outline, chalk words on the dark surface, paper words only on a light one.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/week_slate_test.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")

const SlateWalk := preload("res://tests/slate_walk.gd")   # S418: the walker, shared by every page's slate test

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _settle(6)
	var page := main.find_child("WeekBoard", true, false) as Control
	_check(page != null, "the Training tab draws the week")
	if page == null:
		_done()
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(3)
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))
	var rect := page.get_global_rect()
	print("WEEK_SLATE the week's slate ends at y %.0f" % rect.end.y)
	# S418: the seat's check read `>= 1080` and could only pass. With a fight booked (this jump) the week carries the camp
	# chart and has always run past the first screen: the cream page ended at 1363. The slate must not be taller than that.
	_check(rect.end.y <= 1363.0, "the week's slate is no taller than the cream page was (%.0f of 1363)" % rect.end.y)
	_check(rect.size.x <= 1920.0 and rect.end.x <= 1920.0, "nothing is wider than 1920 (%.0f ending at %.0f)" % [rect.size.x, rect.end.x])
	_done()


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("WEEK_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
