extends SceneTree
## S379 CALLOUTPOP (operator on the fight's HEAD / LIVER / RIBS close-ups: "can you make these popout outlined only when a
## hit lands showing the region of the hit and a short summary of the organ condition and also show up as a tooltip when
## player moves mouse over the each body area"). S381 HOLOOFF (operator: "remove the holos from those if you agree"): the
## live holo panels are off in a round, so the close-ups show on the corner card's holo, on the mouse. 7 tests.
## 1. Line: CalloutLine - name, value, what landed in plain words, what the band means; at most 40 characters; nothing
##    landed says so; an open cut on the face says so.
## 2. Off in the round (S382: not even built): no holo figure or close-up under the fight view, before or after a punch.
## 3. Pop logic (BodyCallouts.struck on a stand-alone holo of blue, its line read from the bout's map): a body hook on blue's
##    liver pops ONLY the LIVER card with its condition line; it grows and fades in (a tween, never a snap) and is fully out
##    by 0.3 s - and still nothing in the fight view.
## 4. Hold + fade: still out at 2 s; a second hit there restarts the hold; mid-fade partly see-through; hidden after.
## 5. Corner card hover: the minute's card (CornerOverlay.build, as FightCast hands it the bout's map and what her places
##    took) shows her holo with close-ups that are hidden until wanted; the mouse on her head / liver / ribs shows that card
##    (only that one) with its line; the figure gives no text tooltip there (the card is the tooltip); leaving fades it out.
## 6. Input + room: the callouts layer ignores the mouse, hidden cards are not visible, their pictures ignore it; a shown card
##    and its line sit inside the corner card's panel and the frame.
## 7. Organ pictures (S381, operator: "add liver picture on the circle ?"): the LIVER card shows the liver picture (its own
##    colours, no kit shader), HEAD keeps her face and RIBS the holo - on the corner card; every organ picture names a card;
##    the picture is the holo look (dark plate corners, cyan organ) with the big lobe on the viewer's left; the card's dot sits
##    on the boxer's right side (the viewer's left), under the chest.

const BodyLive := preload("res://scripts/fight3d/BodyLive.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const CalloutLine := preload("res://scripts/ui/CalloutLine.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")

const LIVER := 1

var failures := 0
var bl: Node
var view: Control
var corner: Control
var pop_fig: Control
var pop_co: Control
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")


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
	view._bug_box.visible = true   # the scorebug is up: a round is playing
	view.add_child(view._bug_box)
	root.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bl = BodyLive.attach(view)
	# The pop logic's stand-alone holo (blue), outside the fight view; its close-ups read the bout's map.
	pop_fig = BodyFigure.new()
	pop_fig.custom_minimum_size = Vector2(340, 420)
	var still: Dictionary = BodyFigure.portrait_for(view.bodies[1], "blue")
	pop_fig.set_portrait(still)
	root.add_child(pop_fig)
	pop_co = BodyCallouts.attach(pop_fig, still, 1.0, func(p: String) -> String: return BodyLive.place_tip(bl.map, "b", bl.taken[1], p))
	if pop_co != null:
		pop_co.set("line_fn", func(s: Dictionary) -> String: return BodyLive.spot_line(bl.map, "b", bl.taken[1], s))
	await _secs(0.2)
	_test2()
	await _test3()
	await _test4()
	await _corner()
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


## 2. Off in the round.
func _test2() -> void:
	_check("2 S405: the live round builds its side holos", _live_on_screen(), "")
	_check("2 the stand-alone holo carries the close-ups", pop_co != null, "")
	var any := false
	for k in 3:
		any = any or (pop_co != null and pop_co.shown(k))
	_check("2 no close-up shows before a punch", not any, "")


## 3. Pop logic.
func _test3() -> void:
	var co: Control = pop_co
	var card: Control = co._bubbles[LIVER]
	var start: Array = []   # the card's look the moment it turns visible (before its tween's first step)
	card.visibility_changed.connect(func() -> void:
		if card.visible and start.is_empty():
			start.append_array([card.modulate.a, card.scale.x]))
	await _land_and_pop({"t": 12.0, "who": "a", "move": "body_hook", "result": "lands", "big": false, "caption": "", "def": ""})
	var left := 60
	while left > 0 and not co.shown(LIVER):
		await process_frame
		left -= 1
	_check("3 the liver shot pops blue's LIVER card", co.shown(LIVER), "")
	_check("3 it starts small and see-through, then tweens (not a snap)", start.size() == 2 and float(start[0]) < 0.05
		and absf(float(start[1]) - BodyCallouts.POP_FROM) < 0.01 and card.get("tw") != null, str(start))
	_check("3 only the LIVER card (not HEAD, not RIBS)", not co.shown(0) and not co.shown(2), "")
	_check("3 with its condition line", co.line_of(LIVER).begins_with("LIVER %d - one body hook" % roundi(100.0 - BodyMap.RIB_HIT)), co.line_of(LIVER))
	await _secs(0.3)
	_check("3 fully out by 0.3 s", card.modulate.a > 0.99 and absf(card.scale.x - 1.0) < 0.02,
		"a %.2f scale %.2f" % [card.modulate.a, card.scale.x])
	_check("3 and the side holos stay up (S405)", _live_on_screen(), "")


## A punch lands on the bout's map (BodyLive), then the stand-alone holo's close-up for each place it took pops.
func _land_and_pop(b: Dictionary) -> void:
	var before := {}
	for p in BodyMap.PLACES:
		before[p] = BodyMap.value(bl.map, "b", p)
	bl.land(b, 0.0)
	await _secs(0.1)
	for p in BodyMap.PLACES:
		if BodyMap.value(bl.map, "b", p) < float(before[p]):
			pop_co.struck(p)


## 4. Hold + fade.
func _test4() -> void:
	var co: Control = pop_co
	var card: Control = co._bubbles[LIVER]
	await _secs(1.7)
	_check("4 still out at 2 s", co.shown(LIVER) and card.modulate.a > 0.99, "")
	await _land_and_pop({"t": 14.0, "who": "a", "move": "body_hook", "result": "lands", "big": true, "caption": "", "def": ""})
	await _secs(1.9)
	_check("4 a second hit restarts the hold (out 2 s after it)", co.shown(LIVER) and card.modulate.a > 0.99, "a %.2f" % card.modulate.a)
	_check("4 the line counts both", co.line_of(LIVER).contains("two"), co.line_of(LIVER))
	await _secs(0.75)
	_check("4 mid-fade it is partly see-through", co.shown(LIVER) and card.modulate.a > 0.02 and card.modulate.a < 0.98,
		"a %.2f" % card.modulate.a)
	await _secs(0.6)
	_check("4 hidden after the hold and the fade", not co.shown(LIVER), "a %.2f" % card.modulate.a)


## The corner minute: red takes a body hook and a cross, then the card is built as FightCast hands it over.
func _corner() -> void:
	bl.land({"t": 20.0, "who": "b", "move": "body_hook", "side": "right", "result": "lands", "big": true, "caption": "", "def": ""}, 0.0)
	bl.land({"t": 21.0, "who": "b", "move": "cross", "result": "lands", "big": false, "caption": "", "def": ""}, 0.0)
	await _secs(0.2)
	view._bug_box.visible = false   # the corner minute hides the HUD
	corner = CornerOverlay.new()
	root.add_child(corner)
	corner.build({"worked": "", "hurt": "", "why": "", "call": "", "body_map": bl.map, "body_taken": bl.taken[0],
		"body_glb": view.bodies[0]}, ["Red", "Blue"])
	corner.show_card(true)
	await _secs(0.4)


## 5. Corner card hover.
func _test5() -> void:
	var co: Control = corner.callouts
	_check("5 the corner card's holo carries the close-ups", co != null and co.is_visible_in_tree(), "")
	if co == null:
		return
	var fig: Control = co.fig
	_check("5 her holo is on screen on the card", fig.is_visible_in_tree() and float(fig._values.get("right_ribs", 100.0)) < 100.0,
		str(fig._values))
	_check("5 none shows before the mouse", not (co.shown(0) or co.shown(1) or co.shown(2)), "")
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
			_check("5 the LIVER line tells the body hook she took", co.line_of(k).contains("body hook"), co.line_of(k))
			_check("6 the shown card and its line sit inside the corner card and the frame", _inside_card(co, k), "")
		tip.set_hover("")   # the mouse leaves her body
		await _secs(0.65)
		_check("5 leaving fades the %s card out" % row[2], not co.shown(k), "")


## 6. Input.
func _test6() -> void:
	var co: Control = corner.callouts
	if co == null:
		_check("6 corner close-ups", false, "none")
		return
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
	_check("7 HEAD keeps her face on the corner card, RIBS shows the ribs", BodyCallouts.pic_of(0) == null and BodyCallouts.pic_of(2) != null, "")
	var names := []
	for s in BodyCallouts.SPOTS:
		names.append(str(s["name"]))
	var stray := []
	for n in BodyCallouts.ORGAN_PICS:
		if not names.has(n):
			stray.append(n)
	_check("7 every organ picture names a card", stray.is_empty(), str(stray))
	var co: Control = corner.callouts
	if co == null:
		_check("7 corner close-ups", false, "none")
		return
	_check("7 on the corner card the liver picture keeps its colours, the head card keeps the kit shader",
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
	var fig: Control = co.fig
	var head: Vector2 = fig.centre_of("head")
	var dot: Vector2 = fig.centre_of("right_ribs")
	var sh := float(fig.call("_geom_px", "head")["ry"])
	_check("7 the corner holo's liver dot is on the boxer's right (the viewer's left), under the chest",
		dot.x < head.x - sh * 0.4 and dot.y > head.y + sh * 3.0, "head %s dot %s" % [head, dot])


func _inside_card(co: Control, k: int) -> bool:
	var card: Control = corner._card
	var pr := card.get_global_rect()
	var b: Control = co._bubbles[k]
	var c: Vector2 = co.centre(k)
	var plate: Rect2 = co._plate_rect(c, co._plate_w(k))
	var g := Rect2(co.get_global_transform() * plate.position, plate.size)
	var ok := pr.encloses(b.get_global_rect()) and pr.encloses(g) and root.get_visible_rect().encloses(g)
	if not ok:
		print("  card %s close-up %s line %s" % [pr, b.get_global_rect(), g])
	return ok


## Any holo figure or close-up under the fight view (S382: none is built for the live round).
func _live_on_screen() -> bool:
	return not view.find_children("*", "Control", true, false).filter(func(n):
		return n.get_script() == BodyFigure or n.get_script() == BodyCallouts).is_empty()


func _secs(s: float) -> void:
	var end := Time.get_ticks_msec() + int(s * 1000.0)
	while Time.get_ticks_msec() < end:
		await process_frame


func _check(label: String, ok: bool, detail: String) -> void:
	print("  %s %s%s" % ["PASS" if ok else "FAIL", label, "" if ok or detail == "" else "  (" + detail + ")"])
	if not ok:
		failures += 1
