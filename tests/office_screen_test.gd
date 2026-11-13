extends SceneTree
## OFFICE1 (S450): the club office as the office computer, in the real game (the pattern of home_look_test, on Main).
## The hub's "Club office" pin opens area "office"; the 7 app buttons are there with their words; exactly ONE control
## on the desktop pulses (the first need's button); each app button goes where TASK_OFFICE1 section 2 says.
## Prints OFFICE_SCREEN failures=<n>.
##   godot --headless --audio-driver Dummy --path . --script res://tests/office_screen_test.gd

const Pulse := preload("res://scripts/ui/Pulse.gd")

const APPS := ["Desktop", "Mail", "Schedule", "Fighters", "Staff", "Finance", "Records"]
## App -> [area, tab] it opens (Mail: the game's news list, World > News; Staff and Records: the Club pages, where
## StaffCard.TABS puts People and Records).
const GOES := {"Desktop": ["office", 0], "Mail": ["world", 0], "Schedule": ["fights", 0], "Fighters": ["fighters", 0],
	"Staff": ["gym", 1], "Finance": ["money", 0], "Records": ["gym", 4]}

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	await _settle()
	var pin := main.find_child("Place_office", true, false) as Button
	_check(pin != null, "the hub has the Club office pin")
	if pin != null:
		pin.pressed.emit()
		await _settle()
	_check(str(main.route["area"]) == "office", "the office pin opens area office (went to %s tab %d)" % [main.route["area"], int(main.route["tab"])])
	var desk := main.find_child("OfficeDesktop", true, false) as Control
	_check(desk != null, "the office desktop is on screen")
	if desk == null:
		_done()
		return
	for app in APPS:
		var b := desk.find_child("App_" + str(app).to_lower(), true, false) as Button
		_check(b != null, "the %s app button is there" % app)
		if b != null:
			var words: Array = b.find_children("*", "Label", true, false).map(func(l): return (l as Label).text)
			_check(b.text == app or words.has(app), "the %s button says %s (%s)" % [app, app, str(words)])
	await create_timer(0.3).timeout
	var pulsing: Array = []
	for n in desk.find_children("*", "Control", true, false):
		if Pulse.running(n as Control) or bool((n as Control).get_meta(Pulse.ON, false)):
			pulsing.append(str(n.name))
	_check(pulsing.size() == 1, "exactly one control pulses on the desktop (%s)" % str(pulsing))
	_check(pulsing.size() == 1 and str(pulsing[0]) == "NeedGo_0", "it is the first need's button (%s)" % str(pulsing))
	for want in ["NeedsPanel", "CalendarPanel", "MailPanel", "FightersPanel", "MoneyPanel", "StaffPanel", "OfficeFoot"]:
		_check(desk.find_child(want, true, false) != null, "the desktop has %s" % want)
	for app in APPS:
		await _route(str(app))
	_done()


func _route(app: String) -> void:
	main.nav({"area": "office", "tab": 0})
	await _settle()
	var b := main.find_child("App_" + app.to_lower(), true, false) as Button
	if b == null:
		_check(false, "%s button found for routing" % app)
		return
	b.pressed.emit()
	await _settle()
	var want: Array = GOES[app]
	var ok: bool = str(main.route["area"]) == str(want[0]) and int(main.route["tab"]) == int(want[1])
	_check(ok, "%s opens %s tab %d (went to %s tab %d)" % [app, want[0], int(want[1]), main.route["area"], int(main.route["tab"])])
	if app == "Mail":
		_check(int(main.career.unread) == 0, "opening Mail reads the news (unread %d)" % int(main.career.unread))


func _settle() -> void:
	for i in 3:
		await process_frame


func _done() -> void:
	print("OFFICE_SCREEN failures=%d" % failures)
	main.queue_free()
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok: " if ok else "  FAIL: ") + what)
	if not ok:
		failures += 1
