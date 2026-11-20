extends SceneTree
## S532 GUIDETIPS1 (owner: "should the guide be structured a bit better like give the player time to explore the tabs"):
## explore first. ops/research/GUIDETIPS1_STANDARD.md section 3.
##   1. The lessons are data: every line is 11 words or fewer, names nobody, and its note exists.
##   2. A new career: the old trainer is there, nothing is dimmed and nothing is ringed; he says what the page is FOR.
##   3. SHOW ME lights the thing to click; pressing it again puts the light out; a new job starts unlit.
##   4. Stuck for GUIDE_IDLE_PULSE_S with no click: the ring pulses, the page still does not dim.
##   5. A page's line is said on the first visit only.

const GuideLight := preload("res://scripts/ui/GuideLight.gd")
const Lessons := preload("res://scripts/rules/Lessons.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")

var _fails := 0
var main: Node


func _initialize() -> void:
	for id in Lessons.PAGES:
		_check(str(Lessons.PAGES[id]).split(" ", false).size() <= Lessons.MAX_WORDS, "page line %s is %d words or fewer" % [id, Lessons.MAX_WORDS])
	for r in Lessons.LIST:
		var line := str(r["line"])
		_check(line.split(" ", false).size() <= Lessons.MAX_WORDS, "lesson %s is %d words or fewer: %s" % [r["id"], Lessons.MAX_WORDS, line])
		_check(str(r["note"]) == "" or not Glossary.term(str(r["note"])).is_empty(), "lesson %s: its note exists" % r["id"])
		for word in [" he ", " she ", " his ", " her "]:
			_check(not (" " + line.to_lower() + " ").contains(word), "lesson %s names nobody" % r["id"])
	_check(Lessons.page_id({"area": "training"}) == "training" and Lessons.page_id({"area": "fighters", "tab": 1, "fighter": ""}) == "fighters" and Lessons.page_id({"area": "fighters", "fighter": "f1", "ftab": 5}) == "prep"
		and Lessons.page_id({"area": "nowhere"}) == "", "a route has its page")
	var seen := {}
	_check(Lessons.page_line(seen, {"area": "money"}) == str(Lessons.PAGES["money"]), "a first visit gets the page's line")
	Lessons.left(seen, "money")
	_check(Lessons.page_line(seen, {"area": "money"}) == "", "a page that was left has been taught")

	load("res://scripts/ui/MenuFx.gd").instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	main.size = Vector2(1920, 1080)
	GuideLight.show_step = ""
	GuideLight.idle_s = 0.0
	main.act("newcareer")
	main.act("quick")
	await _settle(30)
	var c: Career = main.career
	var light := _light()
	_check(light != null and c.guide == "sign", "a new career: the old trainer is in his corner (%s)" % c.guide)
	_check(light != null and light.target() != null, "he knows where the first job is")
	_check(light != null and not light.lit() and not light.pulsing() and not _ring_on(), "explore first: nothing is dimmed, nothing is ringed")
	var page := main.find_child("GuidePage", true, false) as Label
	_check(page != null and page.text == str(Lessons.PAGES["home"]), "he says what the page is for (%s)" % (page.text if page != null else "nothing"))
	var show := main.find_child("GuideShow", true, false) as Button
	_check(show != null and show.text == "Show me", "the bubble has a Show me button")
	if show != null:
		show.pressed.emit()
	await _settle(30)
	light = _light()
	_check(light != null and light.lit() and _ring_on(), "Show me lights the thing to click")
	show = main.find_child("GuideShow", true, false) as Button
	_check(show != null and show.text == "Hide it", "the button now puts the light out")
	if show != null:
		show.pressed.emit()
	await _settle(30)
	light = _light()
	_check(light != null and not light.lit() and not _ring_on(), "pressed again: the light is out")

	GuideLight.idle_s = GuideLight.GUIDE_IDLE_PULSE_S + 1.0
	await _settle(30)
	light = _light()
	_check(light != null and light.pulsing() and not light.lit() and _ring_on(), "stuck with no click: the ring pulses, the page does not dim")
	GuideLight.idle_s = 0.0

	main.act("go", "money:0")
	await _settle(8)
	page = main.find_child("GuidePage", true, false) as Label
	_check(page != null and page.text == str(Lessons.PAGES["money"]), "Money, first visit: its line")
	_check(c.lessons.has("page_home"), "leaving Home taught Home's line")
	main.act("area", "home")
	await _settle(8)
	_check(main.find_child("GuidePage", true, false) == null, "back on Home: the line is not said twice")

	GuideLight.show_step = "sign"
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("close")
	await _settle(30)
	light = _light()
	_check(c.guide != "sign" and (light == null or not light.lit()), "a new job starts unlit (%s)" % c.guide)
	GuideLight.show_step = ""
	print("GUIDE_EXPLORE %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _light() -> Node:
	return main.find_child("FirstWeekStrip", true, false)


func _ring_on() -> bool:
	var l := _light()
	var ring := l.get_node_or_null("Halo") as Control if l != null else null
	return ring != null and ring.visible


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
