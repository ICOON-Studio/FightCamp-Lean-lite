extends SceneTree
## S379 CALLOUTPOP (operator on the fight's HEAD / LIVER / RIBS close-ups: "can you make these popout outlined only when a
## hit lands showing the region of the hit and a short summary of the organ condition and also show up as a tooltip when
## player moves mouse over the each body area"): BodyCallouts through BodyLive, both boxers' panels as the fight HUD builds
## them (a stand-in view: the two bodies, names, round, scorebug). 6 tests.
## 1. Line: CalloutLine - name, value, what landed in plain words, what the band means; at most 40 characters; nothing
##    landed says so; an open cut on the face says so.
## 2. Hidden: before a punch no close-up shows on either boxer.
## 3. Pop: a body hook landing on blue's liver pops ONLY blue's LIVER card (none on red) with its condition line; it grows
##    and fades in (a tween, never a snap) and is fully out by 0.3 s.
## 4. Hold + fade: still out at 2 s; a second hit there restarts the hold (out 2 s after it); mid-fade it is partly
##    see-through; hidden after the hold and the fade.
## 5. Hover: the mouse on blue's head / liver / ribs shows that card (only that one) with its line; the figure gives no text
##    tooltip there (the card is the tooltip); off a place the figure keeps the punch-stats tooltip; leaving fades it out.
## 6. Input + room: the callouts layer ignores the mouse, a hidden card is not visible (takes no mouse); a shown card and its
##    line sit inside the boxer's panel (the 3D ring under the HUD gets nothing, the boxers are never covered).
## 7. Organ pictures (S381, operator: "add liver picture on the circle ?"): the LIVER card shows the liver picture (its own
##    colours, no kit shader), HEAD keeps her face and RIBS the holo; every organ picture names a card; the picture is the holo
##    look (dark plate corners, cyan organ) with the big lobe on the viewer's left; the card's dot sits on the boxer's right
##    side (the viewer's left), under the chest, on both bodies.

const BodyLive := preload("res://scripts/fight3d/BodyLive.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const CalloutLine := preload("res://scripts/ui/CalloutLine.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const LIVER := 1

var failures := 0
var bl: Node
var view: Control


class FakeStage extends Node:
	var boxers := [{"south": false}, {"south": false}]


class FakeView extends Control:
	var bodies := ["", ""]
	var stage: Node
	var round_n := 1
	var _names := ["Red", "Blue"]
	var _bug_box: Control


func _initialize() -> void:
	Engine.max_fps = 60   # a headless loop otherwise spins one core flat out (PC heat)
	_test1()
	root.size = Vector2i(1920, 1080)
	view = FakeView.new()
	view.bodies = [Faces.glb("mh_boxer_11"), Faces.glb("mh_boxer_13")]
	view.stage = FakeStage.new()
	view.add_child(view.stage)
	view._bug_box = Control.new()
	view.add_child(view._bug_box)
	root.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bl = BodyLive.attach(view)
	await _secs(0.2)
	_test2()
	await _test3()
	await _test4()
	await _test5()
	_test6()
	_test7()
	print("CALLOUT_POP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## 1. Line.
func _test1() -> void:
	var log := {}
	BodyTip.log_hit(log, "right_ribs", "body_hook", false, 1)
	BodyTip.log_hit(log, "right_ribs", "body_hook", false, 2)
	var t := CalloutLine.line("LIVER", 50.0, log["right_ribs"], true)
	_check("1 liver: name, value, what landed, gas", t == "LIVER 50 - two hooks, gas drains faster", t)
	t = CalloutLine.line("LIVER", 72.0, log["right_ribs"], true)
	_check("1 a fine liver still costs gas", t == "LIVER 72 - two body hooks, costs gas", t)
	_check("1 nothing landed says so", CalloutLine.line("RIBS", 100.0, {}, true) == "RIBS 100 - nothing landed yet", "")
	var head := {}
	for m in ["jab", "jab", "cross", "lead_hook", "rear_uppercut", "jab"]:
		BodyTip.log_hit(head, "head", m, m == "cross", 2)
	t = CalloutLine.line("HEAD", 30.0, head["head"], false, true)
	_check("1 head: several kinds count as shots, an open cut and the band say so", t == "HEAD 30 - six shots, cut, badly hurt", t)
	t = CalloutLine.line("HEAD", 10.0, head["head"], false, true)
	_check("1 the doctor's words beat the cut when both do not fit", t == "HEAD 10 - six shots, doctor may stop it", t)
	var longest := 0
	for v in [100.0, 60.0, 50.0, 30.0, 10.0]:
		for body in [true, false]:
			for cut in [false, true]:
				for e in [{}, log["right_ribs"], head["head"]]:
					longest = maxi(longest, CalloutLine.line("LIVER", v, e, body, cut).length())
	_check("1 never over 40 characters (longest %d)" % longest, longest <= CalloutLine.MAX, "")


## 2. Hidden.
func _test2() -> void:
	var any := false
	for side in 2:
		var co: Control = _co(side)
		_check("2 the close-ups attach (side %d)" % side, co != null, "")
		for k in 3:
			any = any or co.shown(k)
	_check("2 no close-up shows before a punch", not any, "")


## 3. Pop.
func _test3() -> void:
	var co: Control = _co(1)
	var card: Control = co._bubbles[LIVER]
	var start: Array = []   # the card's look the moment it turns visible (before its tween's first step)
	card.visibility_changed.connect(func() -> void:
		if card.visible and start.is_empty():
			start.append_array([card.modulate.a, card.scale.x]))
	bl.land({"t": 12.0, "who": "a", "move": "body_hook", "result": "lands", "big": false, "caption": "", "def": ""}, 0.0)
	var left := 60
	while left > 0 and not co.shown(LIVER):
		await process_frame
		left -= 1
	_check("3 the liver shot pops blue's LIVER card", co.shown(LIVER), "")
	_check("3 it starts small and see-through, then tweens (not a snap)", start.size() == 2 and float(start[0]) < 0.05
		and absf(float(start[1]) - BodyCallouts.POP_FROM) < 0.01 and card.get("tw") != null, str(start))
	_check("3 only the LIVER card (not HEAD, not RIBS)", not co.shown(0) and not co.shown(2), "")
	_check("3 nothing pops on red", not (_co(0).shown(0) or _co(0).shown(1) or _co(0).shown(2)), "")
	_check("3 with its condition line", co.line_of(LIVER).begins_with("LIVER 99 - one body hook"), co.line_of(LIVER))
	await _secs(0.3)
	_check("3 fully out by 0.3 s", card.modulate.a > 0.99 and absf(card.scale.x - 1.0) < 0.02,
		"a %.2f scale %.2f" % [card.modulate.a, card.scale.x])


## 4. Hold + fade.
func _test4() -> void:
	var co: Control = _co(1)
	var card: Control = co._bubbles[LIVER]
	await _secs(1.7)
	_check("4 still out at 2 s", co.shown(LIVER) and card.modulate.a > 0.99, "")
	bl.land({"t": 14.0, "who": "a", "move": "body_hook", "result": "lands", "big": true, "caption": "", "def": ""}, 0.0)
	await _secs(2.0)
	_check("4 a second hit restarts the hold (out 2 s after it)", co.shown(LIVER) and card.modulate.a > 0.99, "a %.2f" % card.modulate.a)
	_check("4 the line counts both", co.line_of(LIVER).contains("two"), co.line_of(LIVER))
	await _secs(0.75)
	_check("4 mid-fade it is partly see-through", co.shown(LIVER) and card.modulate.a > 0.02 and card.modulate.a < 0.98,
		"a %.2f" % card.modulate.a)
	await _secs(0.6)
	_check("4 hidden after the hold and the fade", not co.shown(LIVER), "a %.2f" % card.modulate.a)


## 5. Hover.
func _test5() -> void:
	var fig: Control = bl.figures[1]
	var co: Control = _co(1)
	var tip: Control = fig.get_node("BodyTip")
	for row in [["head", 0, "HEAD"], ["right_ribs", 1, "LIVER"], ["left_ribs", 2, "RIBS"]]:
		var at: Vector2 = fig.centre_of(str(row[0]))
		var mm := InputEventMouseMotion.new()
		mm.position = at
		fig.gui_input.emit(mm)   # headless routes no mouse to the GUI: the motion as the viewport hands it over
		await _secs(0.3)
		var k := int(row[1])
		var only := true
		for j in 3:
			if j != k and co.shown(j):
				only = false
		_check("5 the mouse on %s shows the %s card, only that one" % [row[0], row[2]], co.shown(k) and only and
			(co._bubbles[k] as Control).modulate.a > 0.99, "hover %s" % tip.hover)
		_check("5 its line names it (%s)" % co.line_of(k), co.line_of(k).begins_with(str(row[2]) + " "), "")
		_check("5 no text tooltip there: the card is the tooltip", str(fig._get_tooltip(at)) == "", str(fig._get_tooltip(at)))
		if k == 1:
			_check("6 the shown card sits inside the panel", _inside_panel(co, k), "")
		tip.set_hover("")   # the mouse leaves her body
		await _secs(0.65)
		_check("5 leaving fades the %s card out" % row[2], not co.shown(k), "")
	var off := Vector2(fig.size.x * 0.5, fig.size.y - 4.0)
	_check("5 off a place the figure keeps the punch-stats tooltip", fig.place_at(off) == "" and str(fig._get_tooltip(off)).contains("LANDED"),
		str(fig._get_tooltip(off)).left(40))


## 6. Input.
func _test6() -> void:
	var co: Control = _co(1)
	_check("6 the callouts layer ignores the mouse", co.mouse_filter == Control.MOUSE_FILTER_IGNORE, "")
	var hidden_ok := true
	for b in co._bubbles:
		if (b as Control).visible or (b.get_node("Pic") as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
			hidden_ok = false
	_check("6 hidden cards are not visible (no mouse), their pictures ignore it", hidden_ok, "")


## 7. Organ pictures.
func _test7() -> void:
	var lv := BodyCallouts.pic_of(LIVER)
	_check("7 the LIVER card shows the liver picture", lv != null and lv.resource_path.ends_with("organ_liver.png"),
		lv.resource_path if lv != null else "none")
	_check("7 HEAD keeps her face, RIBS the holo", BodyCallouts.pic_of(0) == null and BodyCallouts.pic_of(2) == null, "")
	var names := []
	for s in BodyCallouts.SPOTS:
		names.append(str(s["name"]))
	var stray := []
	for n in BodyCallouts.ORGAN_PICS:
		if not names.has(n):
			stray.append(n)
	_check("7 every organ picture names a card", stray.is_empty(), str(stray))
	var co: Control = _co(1)
	_check("7 the liver picture keeps its colours, the head card keeps the kit shader",
		(co._bubbles[LIVER].get_node("Pic") as Control).material == null and (co._bubbles[0].get_node("Pic") as Control).material != null, "")
	var img := Image.load_from_file(ProjectSettings.globalize_path("res://assets/ui/body/organ_liver.png"))
	var ok := img != null and img.get_width() == img.get_height()
	var left := 0
	var right := 0
	var dark_corners := ok
	if ok:
		var w := img.get_width()
		for p in [Vector2i(2, 2), Vector2i(w - 3, 2), Vector2i(2, w - 3), Vector2i(w - 3, w - 3)]:
			var cc := img.get_pixelv(p)
			dark_corners = dark_corners and cc.get_luminance() < 0.12
		for y in w:
			for x in w:
				var c := img.get_pixel(x, y)
				if c.b > 0.45 and c.b > c.r + 0.15:
					if x < w / 2:
						left += 1
					else:
						right += 1
	_check("7 the picture is the holo look: a cyan organ on the dark plate", ok and dark_corners and left + right > 1500,
		"organ px %d" % (left + right))
	_check("7 the liver's big lobe is on the viewer's left (her right side)", left > right * 1.3, "left %d right %d" % [left, right])
	for side in 2:
		var fig: Control = bl.figures[side]
		var head: Vector2 = fig.centre_of("head")
		var dot: Vector2 = fig.centre_of("right_ribs")
		var sh := float(fig.call("_geom_px", "head")["ry"])
		_check("7 side %d: the liver dot is on the boxer's right (the viewer's left), under the chest" % side,
			dot.x < head.x - sh * 0.4 and dot.y > head.y + sh * 3.0, "head %s dot %s" % [head, dot])


func _inside_panel(co: Control, k: int) -> bool:
	var panel: Control = bl.panels[1]
	var pr := panel.get_global_rect()
	var b: Control = co._bubbles[k]
	var c: Vector2 = co.centre(k)
	var plate: Rect2 = co._plate_rect(c, co._plate_w(k))
	var g := Rect2(co.get_global_transform() * plate.position, plate.size)
	var ok := pr.encloses(b.get_global_rect()) and pr.encloses(g) and root.get_visible_rect().encloses(g)
	if not ok:
		print("  panel %s card %s line %s" % [pr, b.get_global_rect(), g])
	return ok


func _co(side: int) -> Control:
	return (bl.figures[side] as Control).get_node_or_null("BodyCallouts")


func _secs(s: float) -> void:
	var end := Time.get_ticks_msec() + int(s * 1000.0)
	while Time.get_ticks_msec() < end:
		await process_frame


func _check(label: String, ok: bool, detail: String) -> void:
	print("  %s %s%s" % ["PASS" if ok else "FAIL", label, "" if ok or detail == "" else "  (" + detail + ")"])
	if not ok:
		failures += 1
