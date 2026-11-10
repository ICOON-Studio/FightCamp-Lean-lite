extends SceneTree
## FIGHTDISPLAY1: the corner bar stays up for the whole round, the calls are graded, Push writes the live pace,
## the NOW plate fires the set-up, and the scorebug's first dot takes the winner's colour after one exchange.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

## Exchanges.fit returns best / ok / wrong (the brief's good / ok / bad). The drawing's words for those three.
const GRADE := {"best": "Beats it", "ok": "Works", "wrong": "Wrong"}
const RED := Color("#e2483d")
const BLUE := Color("#3a7ce0")

var failures := 0
var main: Node
var view: Node


func _initialize() -> void:
	print("CORNER_BAR boot")
	Engine.max_fps = 30
	FightView.force3d = true
	FightIntro.from_corners = true
	get_root().size = Vector2i(1920, 1080)
	if not await _boot():
		_finish()
		return
	await _before_the_call()
	await _at_the_call()
	await _now_plate()
	_finish()


func _finish() -> void:
	print("CORNER_BAR failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _boot() -> bool:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	if not TestJump.run(main, "fight"):
		_fail("boot: the fight jump did not reach fight night")
		return false
	main.act("fightstep", "start")
	await _frames(6)
	if main._fight_layer.get_child_count() == 0:
		_fail("boot: no fight view")
		return false
	view = main._fight_layer.get_child(0)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	if not await _until(func(): return bool(view.playing) and view.get("_shouting") == null and float(view.t) < 5.0):
		_fail("boot: the round never played before the first call (playing %s t %.1f)" % [view.playing, float(view.t)])
		return false
	await _frames(4)
	return true


## The bar is up before anyone shouts, with the graded calls and a pace button that writes the live round.
func _before_the_call() -> void:
	var bar := _bar()
	_check(bar != null, "a CornerBar exists before the first call")
	if bar == null:
		_fail("no corner bar: the call, grade, pace and type-size checks could not run")
		return
	_check(view.get("_shouting") == null, "that is before the shout window")
	# S424: measured against the fight view's own box, not a fixed 1080 - headless the view is taller than the window
	# (it read y 1745 of a 1920-tall view); the windowed 1920x1080 render shows the bar at y 905-1075.
	var rect := (bar as Control).get_global_rect()
	var vrect := (view as Control).get_global_rect() if view is Control else Rect2(Vector2.ZERO, Vector2(get_root().size))
	_check(absf(vrect.end.y - rect.end.y) <= 20.0 and rect.size.y >= 40.0 and rect.size.y <= 200.0,
		"the bar sits along the bottom of the fight view (bar %s, view %s)" % [rect, vrect])
	var pv := LiveRound.preview(_fighter(), main.modal)
	_check_calls(bar, pv)
	_check_type(bar)
	var push := bar.find_child("Pace_push", true, false) as Button
	_check(push != null, "Push is on the bar")
	if push != null:
		push.pressed.emit()
		_check(str(main.modal["live"]["pace"]) == "push", "Push sets the live pace to push (%s)" % str(main.modal["live"]["pace"]))


## After the opening exchange the first dot is that exchange's winner, and the shout window is open.
func _at_the_call() -> void:
	view.t = 30.0
	if not await _until(func(): return view.get("_shouting") != null):
		_fail("the first call never opened")
		return
	await _frames(2)
	var ex: Array = LiveRound.live(main.modal).get("ex", [])
	_check(ex.size() >= 1, "one exchange has been fought")
	var bug := view.find_child("ScoreBug", true, false)
	var dot: Node = null
	if bug != null:
		dot = bug.find_child("Dot0", true, false)
	_check(dot != null, "the scorebug has six dots, the first one named")
	if dot != null and ex.size() >= 1:
		var want: Color = RED if bool((ex[0] as Dictionary)["won"]) else BLUE
		var fill: Color = dot.get("fill")
		_check(_same(fill, want), "after one exchange the first dot is the winner's colour (%s, want %s)" % [fill, want])


## A set-up whose gap is the situation the corner sees: the plate shows, and a click fights "now".
func _now_plate() -> void:
	if view.get("_shouting") == null:
		_fail("no shout window, so the NOW plate could not be clicked")
		return
	var f: Dictionary = _fighter()
	var lv: Dictionary = LiveRound.live(main.modal)
	var pv: Dictionary = LiveRound.preview(f, main.modal)
	lv["setup"] = {"combo": "1-2", "gap": str(pv.get("sit", "")), "mastery": 80.0, "used": ""}
	await _frames(3)
	var plate := view.find_child("NowPlate", true, false) as Button
	var shown: Dictionary = {}
	var raw: Variant = LiveRound.preview(f, main.modal).get("now", {})
	if raw is Dictionary:
		shown = raw
	_check(plate != null and plate.visible and not (shown as Dictionary).is_empty(),
		"a NowPlate is visible while the gap is open")
	if plate == null or not plate.visible:
		return
	var before := (lv["ex"] as Array).size()
	plate.pressed.emit()
	await _frames(2)
	var after: Array = LiveRound.live(main.modal).get("ex", [])
	var rec: Dictionary = after[-1] if after.size() > before else {}
	_check(after.size() == before + 1 and str(rec.get("setup", "")) in ["landed", "missed"],
		"the plate's click fights the exchange with the shout now (%s)" % str(rec.get("setup", "")))


func _check_calls(bar: Node, pv: Dictionary) -> void:
	var offers: Array = pv.get("offers", [])
	var buttons := bar.find_children("Call_*", "Button", true, false)
	var say := bar.find_child("SayNothing", true, false) as Button
	_check(buttons.size() == offers.size() and say != null,
		"the bar has %d call buttons and Say nothing (saw %d, say %s)" % [offers.size(), buttons.size(), say != null])
	var sit := str(pv.get("sit", ""))
	for call in offers:
		var chip := bar.find_child("Grade_" + str(call), true, false) as Label
		var word := str(GRADE.get(Exchanges.fit(str(call), sit), ""))
		_check(chip != null and chip.text == word, "grade for %s is %s (saw %s)" % [call, word, "" if chip == null else chip.text])


func _check_type(bar: Node) -> void:
	for n in bar.find_children("*", "Label", true, false):
		var l := n as Label
		var px := l.get_theme_font_size("font_size")
		_check(px >= 20, "label %s is %d px" % [l.name, px])
		if str(l.name).begins_with("CallTitle"):
			_check(px >= 30, "call title %s is %d px" % [l.name, px])
		_check(not _clipped(l), "label %s is not clipped (%s)" % [l.name, l.text])
	for n in bar.find_children("*", "Button", true, false):
		var b := n as Button
		_check(b.get_theme_font_size("font_size") >= 20, "button %s is %d px" % [b.name, b.get_theme_font_size("font_size")])


func _clipped(l: Label) -> bool:
	if l.text.strip_edges() == "":
		return false
	if l.size.x < 2.0 or l.size.y < 2.0:
		return true
	if l.autowrap_mode != TextServer.AUTOWRAP_OFF:
		return l.get_visible_line_count() < l.get_line_count()
	return l.get_minimum_size().x > l.size.x + 2.0 or l.get_minimum_size().y > l.size.y + 2.0


func _bar() -> Node:
	return null if view == null else view.find_child("CornerBar", true, false)


func _fighter() -> Dictionary:
	return main.career.fighter_by_id(str(view.fid))


func _same(a: Color, b: Color) -> bool:
	return absf(a.r - b.r) < 0.02 and absf(a.g - b.g) < 0.02 and absf(a.b - b.b) < 0.02


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1


func _fail(label: String) -> void:
	_check(false, label)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _until(cond: Callable, cap: int = 180) -> bool:
	for i in cap:
		if cond.call():
			return true
		await process_frame
	return cond.call()
