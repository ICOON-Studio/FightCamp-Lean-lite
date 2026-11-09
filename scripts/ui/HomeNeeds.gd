extends RefCounted
## S394 HOME's notice board (operator: "try something more orginial for home screen messages pinned on board"): what needs the
## player, each a paper note pinned to the club's cork board. A red pin stops the clock, an amber pin should come next, a steel pin
## can wait. Paper and pins, not cartoon: operator S393 "i want serious proposals".

const UI := preload("res://scripts/ui/UI.gd")
const HomeLook := preload("res://scripts/ui/HomeLook.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const NOTE := Vector2(300, 196)
const NOTE_FACE := Vector2(440, 196)   # a note with a photo clipped to it
const FACE := Vector2(76, 76)
const TILT := [-1.1, 0.8, -0.5, 1.2, -0.8, 0.6]   # degrees: nobody pins a note dead straight
const CORK := Color("#c9a97f")
const WOOD := Color("#8a6a45")
const PAPER := Color("#fbf7ee")
const STEEL := Color("#8d96a0")
const LATER := ["go:money:3"]   # a sponsor on offer waits; a camp, a goal or an entry date does not


## Clock-stoppers first, then what costs a fighter something if it waits, then what can wait; Needs' own order inside each.
static func ranked(c: Career) -> Array:
	var n := Needs.needs(c)
	var out: Array = []
	for level in 3:
		out += n.filter(func(x): return urgency(x) == level)
	return out


static func urgency(x: Dictionary) -> int:
	if bool(x["red"]):
		return 0
	return 2 if LATER.has(str(x["act"]) + ":" + str(x["arg"])) or str(x["act"]) == "review" else 1


static func pressing(c: Career) -> Array:
	return ranked(c).filter(func(x): return urgency(x) < 2)


static func build(main: Node, c: Career) -> Control:
	var board := PanelContainer.new()
	board.name = "Needs"
	var frame := UI.box(CORK, WOOD, 4, 4, 20, 22)
	frame.shadow_color = Color(0, 0, 0, 0.18)
	frame.shadow_size = 6
	board.add_theme_stylebox_override("panel", frame)
	board.add_child(Speckle.new())
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 22)
	flow.add_theme_constant_override("v_separation", 22)
	board.add_child(flow)
	var n := ranked(c)
	if n.is_empty():
		flow.add_child(_note(main, c, {"red": false, "t": "Nothing needs you", "s": "Press Continue when you are ready.", "act": "", "arg": "", "label": ""}, 0))
	for i in n.size():
		flow.add_child(_note(main, c, n[i], i))
	return board


## A container straightens its children, so the note hangs free inside a plain slot: that is what lets it tilt.
static func _note(main: Node, c: Career, x: Dictionary, i: int) -> Control:
	var level := urgency(x)
	var p := PanelContainer.new()
	p.name = "Need_%d" % i
	var sheet := UI.box(PAPER, Color(0, 0, 0, 0), 2, 0, 16, 14)
	sheet.content_margin_top = 22
	sheet.shadow_color = Color(0, 0, 0, 0.28)
	sheet.shadow_size = 5
	sheet.shadow_offset = Vector2(1, 3)
	p.add_theme_stylebox_override("panel", sheet)
	var with_face: bool = str(x["act"]) == "interview" and not c.applicant.is_empty()
	var area: Vector2 = NOTE_FACE if with_face else NOTE
	p.size = area
	p.custom_minimum_size = area
	p.rotation = deg_to_rad(float(TILT[i % TILT.size()]))
	p.pivot_offset = area * 0.5
	var h := UI.hbox(12)
	p.add_child(h)
	if with_face:
		var face := HomeLook.face(Faces.stem(c.applicant), FACE)
		if face != null:
			h.add_child(face)
	var v := UI.vbox(3)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	var t := UI.label(str(x["t"]), 23, UI.FG, "handbold", true)
	t.max_lines_visible = 2
	t.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(t)
	var s := UI.label(str(x["s"]), 16, Color(UI.FG, 0.85), "body", true)
	s.max_lines_visible = 2
	s.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(s)
	var push := Control.new()
	push.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(push)
	if str(x["label"]) != "":
		var b := UI.button(str(x["label"]), "Ink" if i == 0 and level < 2 else "Btn", main.act.bind(str(x["act"]), str(x["arg"])))
		if i == 0:
			b.name = "GuideHomeAction"   # the top need: where the guide's light goes on Home
		b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		v.add_child(b)
	var pin := Pin.new()
	pin.colour = [UI.RED, UI.AMBER, STEEL][level]
	p.add_child(pin)
	var slot := Control.new()
	slot.custom_minimum_size = area
	slot.add_child(p)
	return slot


## The cork's grain: small dark and light flecks, the same every time.
class Speckle extends Control:
	const FLECKS := 2600

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = 394
		for i in FLECKS:
			var at := Vector2(rng.randf() * size.x, rng.randf() * size.y)
			var dark := rng.randf() < 0.6
			draw_circle(at, rng.randf_range(0.8, 2.6), Color(0.35, 0.22, 0.1, 0.34) if dark else Color(1, 0.95, 0.8, 0.28))


## A round map pin at the top of the note; drawn into the note's margin, so it takes no room.
class Pin extends Control:
	const R := 11.0
	var colour := Color.WHITE

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var at := Vector2(size.x * 0.5, -12.0)
		draw_circle(at + Vector2(1.5, 3.0), R, Color(0, 0, 0, 0.3))
		draw_circle(at, R, colour)
		draw_circle(at + Vector2(-2.5, -2.5), R * 0.3, Color(1, 1, 1, 0.65))
