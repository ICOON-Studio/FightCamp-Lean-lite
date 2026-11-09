extends SceneTree
## S413 the guide as a person: an old trainer, one short line, a light on the thing to touch.

const MAIN := preload("res://scenes/Main.tscn")
const GuideLines := preload("res://scripts/rules/GuideLines.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FORBIDDEN := [" he ", " she ", " his ", " her ", " him ", "He ", "She ", "His ", "Her "]

var failures := 0
var main: Node
var walkin: Dictionary


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	walkin = c.applicant.duplicate(true)
	_lines(c)
	await _on_screen(c)
	print("GUIDE_PERSON failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Every step's line, on a boxer over the limit and on one inside it.
func _lines(c: Career) -> void:
	var first := c.guide
	for step in ["sign", "coach", "week", "go", "offer", "prep", "fight", "club", ""]:
		c.guide = str(step)
		_line_ok(GuideLines.line(c), str(step))
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var f: Dictionary = c.fighter()
	for kg in [float(f["limit"]) - 1.0, float(f["limit"]) + 2.5]:
		f["weight"] = kg
		for step in ["week", "offer", "prep", "club"]:
			c.guide = str(step)
			_line_ok(GuideLines.line(c), "%s at %.1f kg" % [step, kg])
	c.guide = first


func _line_ok(line: String, what: String) -> void:
	var words := line.split(" ", false).size()
	_check(words >= 2 and words <= GuideLines.MAX_WORDS, "%s: %d words: %s" % [what, words, line])
	var padded := " " + line + " "
	var bad := FORBIDDEN.filter(func(w): return padded.contains(str(w)))
	_check(bad.is_empty(), "%s: no he or she: %s" % [what, line])


func _on_screen(c: Career) -> void:
	c.guide = "sign"
	c.applicant = walkin
	main.render()
	for i in 16:
		await process_frame
	var first: Node = main.find_child("FirstWeekStrip", true, false)
	_check(first != null and first.target() == main.find_child("Place_reception", true, false), "on Home the light is on Reception")
	c.guide = "coach"
	main.act("go", "gym:1")
	await process_frame
	await process_frame
	var light: Node = main.find_child("FirstWeekStrip", true, false)
	_check(light != null, "the guide is on screen")
	var face := main.find_child("GuideFace", true, false) as TextureRect
	_check(face != null and face.texture != null, "the old trainer has a face")
	var said := main.find_child("GuideWhat", true, false) as Label
	_check(said != null and said.text == GuideLines.line(c), "the bubble says the line")
	_check(main.find_children("*", "Label", true, false).filter(func(l): return (l as Label).text.begins_with("1  ")).is_empty(), "no numbered chips")
	for i in 16:
		await process_frame
	var hire := main.find_child("Hire_reid", true, false) as Control
	_check(hire != null and light.target() == hire, "the light is on the Hire button")
	_check((light as Control).mouse_filter == Control.MOUSE_FILTER_IGNORE, "the dim never blocks a click")
	var v: Vector2 = root.get_visible_rect().size
	var corner := main.find_child("GuideCorner", true, false) as Control
	var r := corner.get_global_rect()
	_check(r.position.x >= 0.0 and r.end.y <= v.y + 0.5 and r.end.x < v.x * 0.5, "the corner fits the bottom left (%s)" % str(r))
	main.open_modal({"type": "info", "title": "t", "body": "x"})
	for i in 16:
		await process_frame
	light = main.find_child("FirstWeekStrip", true, false)
	_check(light == null or light.target() == null, "no light under a pop-up")
	main.close_modal()


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + what)
