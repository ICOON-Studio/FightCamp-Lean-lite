extends SceneTree
## S418 the FIGHT CAMP pop-up and the bout offer's centre card on the wood and slate look. The white cards and the cream
## centre card are gone: see-through cards with a chalk outline, a gold edge on the chosen one, a framed slate between the
## red and blue halves. The halves stay light on purpose, so only the centre card is walked.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/camp_slate_test.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	await _camp()
	await _offer()
	_done()


func _camp() -> void:
	var f := _book()
	_check(not f.is_empty(), "a fighter has an even bout booked")
	if f.is_empty():
		return
	main.act("camp", str(f["id"]))
	await _settle(6)
	var page := main.modal_node() as Control
	_check(page != null and str(main.modal.get("type", "")) == "camp", "SET CAMP opens the camp pop-up")
	if page == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(page)
	await _settle(3)
	for fault in SlateWalk.faults(page):
		# The gold "this week" cell is WeekStrip's own mark. That file is not this task's, so the cell stays gold.
		if str(fault).begins_with("Week_") and str(fault).contains("light plate"):
			print("CAMP_SLATE week cell stays gold: " + str(fault))
			continue
		_check(false, str(fault))
	for k in BoutRules.CAMP_FOCUSES:
		_check(page.find_child("Focus_" + k, true, false) != null, "focus card %s is there" % k)
	for i in [1, 2, 3]:
		_check(page.find_child("Protocol_%d" % i, true, false) != null, "intensity card %d is there" % i)
	var focus := str(main.modal.get("focus", ""))
	var chosen := page.find_child("Focus_" + focus, true, false) as Button
	if chosen != null:
		var sb := chosen.get_theme_stylebox("normal") as StyleBoxFlat
		var fill := sb.bg_color.a if sb != null else -1.0
		var edge := sb.border_color.to_html(false) if sb != null else "?"
		print("CAMP_SLATE chosen card fill a=%.2f edge=%s" % [fill, edge])
		_check(sb != null and fill < 0.5, "the chosen card's fill is see-through (a=%.2f)" % fill)
		_check(sb != null and sb.border_color.is_equal_approx(WoodKit.HEAD), "the chosen card's edge is gold (%s)" % edge)
	var rect := page.get_global_rect()
	print("CAMP_SLATE the camp ends at x %.0f y %.0f" % [rect.end.x, rect.end.y])
	_check(rect.end.x <= 1920.0, "the camp is no wider than the screen (%.0f of 1920)" % rect.end.x)


func _offer() -> void:
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var f: Dictionary = c.fighter()
	f["offers"].append(Bouts._offer("lucy:t1", (Data.OPPONENTS[0] as Dictionary).duplicate(true), c.day + 30, c.day + 6, 4))
	main.act("openBout", "lucy:t1")
	await _settle(4)
	var card := main.find_child("VersusCard", true, false) as Control
	_check(card != null, "the offer opens on the centre card")
	if card == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(card)
	await _settle(3)
	for fault in SlateWalk.faults(card):
		_check(false, str(fault))
	var accept := main.find_child("Accept", true, false)
	_check(accept != null, "Accept is still on the centre card")
	var sb := card.get_theme_stylebox("panel")
	print("CAMP_SLATE centre card style %s" % sb.get_class())
	_check(sb is StyleBoxTexture, "the centre card is a framed slate (%s)" % sb.get_class())
	var read := card.find_child("VersusRead", true, false) as Control
	if read != null:
		var strip := read.get_theme_stylebox("panel") as StyleBoxFlat
		var fill := strip.bg_color.a if strip != null else -1.0
		print("CAMP_SLATE win strip fill a=%.2f" % fill)
		_check(strip != null and fill < 0.5, "the win strip is see-through (a=%.2f)" % fill)
	var rect := card.get_global_rect()
	print("CAMP_SLATE the centre card ends at x %.0f y %.0f" % [rect.end.x, rect.end.y])
	_check(rect.end.y <= 1080.0, "the centre card stays on the screen (%.0f of 1080)" % rect.end.y)
	_check(rect.end.x <= 1920.0, "the centre card stays inside the screen (%.0f of 1920)" % rect.end.x)


## The golden path's first weeks, as camp_cards_test books them: Lucy signed, the coach hired, her first even offer taken.
func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			return f
	return {}


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("CAMP_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
