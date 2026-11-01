extends SceneTree
## BodyTip (S348, operator C199: "the holo need to link to tooltips when mouse over head or liver to show stats like damage
## taken etc"): 4 tests.
## 1. Taken: three jabs and a big lead hook on her head read "Took 4: 3 jabs, 1 lead hook", the big shot and the last
##    punch with its round; the band and value lead the first line.
## 2. Names: her right ribs are the liver; a place nothing hit says so; a cut eye says it is open (or closed).
## 3. Face: a face place also gives her head's state; the head itself does not repeat it.
## 5. Close-ups (S348, the operator's anatomy-chart pictures): HEAD, LIVER, RIBS sit in the outer strip beside her body
##    (left panel: left of her head; right panel: right of it), inside the figure, apart; each shows its worst place and
##    its tooltip is that place's (a cut eye beats a fresh head).
## 4. Mouse: on her turning body (mh_boxer_11, red), a mouse move onto her right ribs rings that place, her tooltip
##    there starts "Liver", the tooltip is the HUD panel with the band word in the band colour; leaving clears the ring.

const BF := preload("res://scripts/ui/BodyFigure.gd")
const BodyTurn := preload("res://scripts/ui/BodyTurn.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	await _test4()
	await _test5()
	print("BODY_TIP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## 1. Taken.
func _test1() -> void:
	var log := {}
	for i in 3:
		BodyTip.log_hit(log, "head", "jab", false, 1)
	BodyTip.log_hit(log, "head", "lead_hook", true, 2)
	var t := BodyTip.text("head", 48.0, log["head"])
	var lines := t.split("\n")
	_check("1 first line is place, band, value", str(lines[0]) == "Head: hurt (48/100)", str(lines[0]))
	_check("1 what landed, by kind", t.contains("Took 4: 3 jabs, 1 lead hook"), t)
	_check("1 the big shot and the last punch with its round", t.contains("1 big shot - Last: lead hook, round 2"), t)


## 2. Names.
func _test2() -> void:
	var t := BodyTip.text("right_ribs", 100.0, {})
	_check("2 her right ribs are the liver", t.begins_with("Liver (right ribs): fine (100/100)"), t)
	_check("2 nothing landed says so", t.contains("Nothing landed here yet"), t)
	var log := {}
	BodyTip.log_hit(log, "left_eye", "cross", false, 3)
	_check("2 an open cut", BodyTip.text("left_eye", 30.0, log["left_eye"], -1.0, true, false).contains("Cut open"), "")
	_check("2 a closed cut", BodyTip.text("left_eye", 30.0, log["left_eye"], -1.0, true, true).contains("closed by the cutman"), "")
	_check("2 badly hurt band words", BodyTip.text("left_eye", 30.0, log["left_eye"]).begins_with("Left eye: badly hurt"), "")


## 3. Face.
func _test3() -> void:
	_check("3 a face place gives the head", BodyTip.text("nose", 80.0, {}, 52.0).ends_with("Head: hurt (52/100)"), "")
	_check("3 the head does not repeat itself", not BodyTip.text("head", 52.0, {}, 52.0).contains("\nHead:"), "")


## 4. Mouse.
func _test4() -> void:
	root.size = Vector2i(800, 900)
	var fig: Control = BF.new()
	fig.custom_minimum_size = Vector2(340, 420)
	fig.size = Vector2(340, 420)
	fig.position = Vector2(100, 100)
	root.add_child(fig)
	var ok := BodyTurn.attach(fig, Faces.glb("mh_boxer_11"), "red")
	_check("4 her turning body is baked", ok, "")
	var log := {}
	BodyTip.log_hit(log, "right_ribs", "body_hook", false, 1)
	fig.tip_fn = func(p: String) -> String: return BodyTip.text(p, 70.0, log.get(p, {}))
	var tip: Control = BodyTip.attach(fig)
	await process_frame
	var at: Vector2 = fig.centre_of("right_ribs")
	_check("4 her right ribs are under their own centre", fig.place_at(at) == "right_ribs", fig.place_at(at))
	# Headless Godot routes no mouse to the GUI: the figure gets the motion as the viewport would hand it over (local
	# position). The real route through the fight HUD is checked on the hidden desktop (tools/fight3d_play.gd hover=1).
	var mm := InputEventMouseMotion.new()
	mm.position = at
	fig.gui_input.emit(mm)
	await process_frame
	_check("4 the place under the mouse is ringed", tip.hover == "right_ribs", tip.hover)
	var words: String = fig._get_tooltip(at)
	_check("4 her tooltip there is the liver's", words.begins_with("Liver (right ribs): fine (70/100)") and words.contains("Took 1: 1 body hook"), words)
	var pan: Object = fig._make_custom_tooltip(words)
	var row := ((pan as Control).get_child(0) as Control).get_child(0) as HBoxContainer
	var band := row.get_child(1) as Label if row != null else null
	_check("4 the tooltip is the HUD panel, band word in its colour", pan is PanelContainer and band != null
		and band.get_theme_color("font_color").is_equal_approx(BodyTip.BAND_COLOURS["fine"]), str(pan))
	(pan as Node).free()
	tip.set_hover("")
	_check("4 leaving clears the ring", tip.hover == "", tip.hover)


## 5. Close-ups.
func _test5() -> void:
	const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
	for side_out in [-1.0, 1.0]:
		var fig: Control = BF.new()
		fig.custom_minimum_size = Vector2(340, 420)
		fig.size = Vector2(340, 420)
		root.add_child(fig)
		var glb := Faces.glb("mh_boxer_13")
		BodyTurn.attach(fig, glb, "blue")
		fig.set_values({"left_eye": 30.0, "head": 80.0, "right_ribs": 60.0})
		var co: Control = BodyCallouts.attach(fig, BF.portrait_for(glb, "blue"), side_out, func(p: String) -> String: return BodyTip.text(p, 50.0, {}))
		await process_frame
		_check("5 close-ups attach (%s)" % side_out, co != null, "")
		var head_x: float = fig.centre_of("head").x
		var ok := true
		var ys: Array = []
		for k in 3:
			var c: Vector2 = co.centre(k)
			ys.append(c.y)
			var outside := c.x + 30.0 < head_x - 40.0 if side_out < 0.0 else c.x - 30.0 > head_x + 40.0
			if not outside or c.x - 30.0 < 0.0 or c.x + 30.0 > 340.0 or c.y - 30.0 < 0.0 or c.y + 48.0 > 420.0:
				ok = false
				print("  close-up %d at %s (head x %.0f)" % [k, c, head_x])
		_check("5 each close-up in the outer strip, inside her figure (%s)" % side_out, ok, "")
		_check("5 the close-ups apart down the strip", float(ys[1]) - float(ys[0]) >= 60.0 and float(ys[2]) - float(ys[1]) >= 60.0, str(ys))
		_check("5 HEAD shows her worst face place (the cut eye)", co._worst(BodyCallouts.SPOTS[0]) == "left_eye", co._worst(BodyCallouts.SPOTS[0]))
		_check("5 HEAD's tooltip is that place's", co._spot_tip(BodyCallouts.SPOTS[0]).begins_with("Left eye"), "")
		fig.queue_free()


func _check(label: String, ok: bool, detail: String) -> void:
	print("  %s %s%s" % ["PASS" if ok else "FAIL", label, "" if ok or detail == "" else "  (" + detail + ")"])
	if not ok:
		failures += 1
