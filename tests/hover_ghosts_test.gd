extends SceneTree
## S382 G5 (gym idea 2, hover ghosts): hovering a camp card or a whiteboard morning ghosts its dry run on the gauge row.
##   1. Pure: GaugeRow.ghost_delta - "+N" / "-N" from the needle to the dry run, green lower / red higher (fatigue, kilos,
##      injury chance), "same" in pencil under the dial's MOVED.
##   2. The widget: preview() sweeps the ghost needle and counts the delta up in GHOST_S (about 0.15 s), not at once; a
##      second preview starts from the ghost; preview_off() clears; a commit's flash does not wipe a hover's number.
##   3. The FIGHT CAMP modal: each pick but the current one (focus, protocol, Partner, Film) ghosts exactly that pick's
##      CampForecast dry run on the left column's dials; leaving clears; the current card ghosts nothing; the Partner
##      card reads "same" (it changes who she spars, not the days); hovering commits nothing.
##   4. The whiteboard (jump=camp): THIS CAMP's ghost_day(dow, card) ghosts the week with that morning changed (the same
##      numbers as a dry run of that edit), the day's own card ghosts nothing, [] clears; a changed day's 'undo' ghosts the
##      coach's card on hover; the morning's picker ghosts the card under the cursor (its focused item) and clears off the
##      list or closed; hovering changes no plan.
## Population: hand-written forecasts (2); the jump=camp career (TestJump "camp": Lucy in camp, her bout booked) for 3-4.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")
const WeekDay := preload("res://scripts/ui/WeekDay.gd")
const WeekCamp := preload("res://scripts/ui/WeekCamp.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")

var _fails := 0
var main: Node


func _initialize() -> void:
	_pure()
	await _widget()
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	await _board()
	await _camp_modal()
	print("HOVER_GHOSTS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _pure() -> void:
	var a := GaugeRow.ghost_delta("legs", 54.0, 48.0)
	_check(a["text"] == "-6" and a["colour"] == UI.GREEN, "LEGS 54 -> 48: -6 green (%s)" % a["text"])
	a = GaugeRow.ghost_delta("scale", 59.9, 60.4)
	_check(a["text"] == "+0.5 kg" and a["colour"] == WB.RED, "SCALE 59.9 -> 60.4: +0.5 kg red (%s)" % a["text"])
	a = GaugeRow.ghost_delta("risk", 0.02, 0.06)
	_check(a["text"] == "+4%" and a["colour"] == WB.RED, "RISK 2 -> 6 %%: +4%% red (%s)" % a["text"])
	_check(GaugeRow.ghost_delta("legs", 48.0, 48.4)["text"] == "same" and GaugeRow.ghost_delta("scale", 60.0, 60.04)["text"] == "same"
		and GaugeRow.ghost_delta("risk", 0.05, 0.053)["text"] == "same" and GaugeRow.ghost_delta("legs", 1.0, 1.0)["colour"] == WB.PENCIL,
		"under MOVED: same, in pencil")
	_check(is_equal_approx(GaugeRow.GHOST_S, 0.15), "the ghost sweeps in 0.15 s")


func _fc(fat: float, kg: float, inj: float) -> Dictionary:
	return {"fatigue_end": fat, "fatigue_now": 49.0, "peak": 69.0, "stale": 0.0, "kg": kg, "limit": 60.0, "injury": inj}


func _widget() -> void:
	var f := {"sex": "f", "weight": 61.4, "injury": {}, "bout": {"day": 120}}
	var row = GaugeRow.make(GaugeRow.read(_fc(54.0, 59.9, 0.02), f, 100), {}, 330.0)
	root.add_child(row)
	await process_frame
	var dial: Control = row.find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	row.preview(GaugeRow.read(_fc(48.0, 60.4, 0.06), f, 100))
	var first := (row.deltas["legs"] as Label).text
	_check(first == "-0" and (row.deltas["legs"] as Label).modulate.a < 0.5 and is_equal_approx(float(dial.get("ghost")), 54.0),
		"the ghost starts at the needle and the number at 0, faded (%s, %.1f)" % [first, float(dial.get("ghost"))])
	await create_timer(0.3).timeout
	_check((row.deltas["legs"] as Label).text == "-6" and (row.deltas["scale"] as Label).text == "+0.5 kg"
		and (row.deltas["risk"] as Label).text == "+4%", "after the sweep: -6 / +0.5 kg / +4%% (%s %s %s)" % [(row.deltas["legs"] as Label).text,
		(row.deltas["scale"] as Label).text, (row.deltas["risk"] as Label).text])
	_check(is_equal_approx(float(dial.get("ghost")), 48.0) and is_equal_approx(float(dial.get("v")), 54.0),
		"the ghost needle at 48, the needle stays at 54")
	_check((row.deltas["legs"] as Label).get_theme_color("font_color") == UI.GREEN and (row.deltas["risk"] as Label).get_theme_color("font_color") == WB.RED,
		"green lower, red higher")
	var pd: Control = row.find_child("Gauge_risk", true, false).find_child("Dial", true, false)
	_check(int(pd.get("ghost_lit")) == 2, "RISK ghost: 2 pips")
	row.preview(GaugeRow.read(_fc(60.0, 59.9, 0.02), f, 100))
	_check(float(dial.get("ghost")) < 49.0, "a second hover sweeps on from the ghost (%.1f)" % float(dial.get("ghost")))
	await create_timer(0.3).timeout
	_check((row.deltas["legs"] as Label).text == "+6" and (row.deltas["scale"] as Label).text == "same", "second hover: +6 / same")
	row.preview_off()
	_check((row.deltas["legs"] as Label).text == "" and is_nan(float(dial.get("ghost"))) and int(pd.get("ghost_lit")) == 0, "preview off clears")
	var before: Dictionary = row.values()
	row.queue_free()
	# A commit's change under the dial, then a hover inside its 2 s: the flash must not wipe the hover's number.
	var row2 = GaugeRow.make(GaugeRow.read(_fc(48.0, 59.9, 0.02), f, 100), before, 330.0)
	root.add_child(row2)
	await process_frame
	_check((row2.deltas["legs"] as Label).text == "-6", "the commit's change under the dial")
	row2.preview(GaugeRow.read(_fc(58.0, 59.9, 0.02), f, 100))
	await create_timer(GaugeRow.PULSE_S + 0.6).timeout
	_check((row2.deltas["legs"] as Label).text == "+10" and (row2.deltas["legs"] as Label).modulate.a > 0.9, "the hover's +10 outlives the flash")
	row2.queue_free()


func _board() -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	f["board_taught"] = true
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _frames(3)
	var b := main.find_child("WeekBoard", true, false)
	var camp = b.find_child("Goal", true, false) if b != null else null
	var gauge = camp.find_child("Gauges", true, false) if camp != null else null
	_check(gauge != null, "THIS CAMP has the gauge row")
	if gauge == null:
		return
	var dial: Control = gauge.find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	var days := WeekPlan.days_of(f)
	var today := posmod(c.day, 7)
	var dow := -1
	for d in range(today, 7):
		if str((days[d] as Array)[0]) != "rest":
			dow = d
	_check(dow >= 0, "a training morning left this week (%d)" % dow)
	if dow < 0:
		return
	var plan_before: Variant = f.get("week_edits", {}).duplicate(true)
	camp.ghost_day(dow, days[dow])
	_check(is_nan(float(dial.get("ghost"))), "the day's own card ghosts nothing")
	camp.ghost_day(dow, ["rest", "normal"])
	await create_timer(0.3).timeout
	var g := f.duplicate(true)
	WeekPhase.edit(g, dow, ["rest", "normal"], WeekPlan.coach_of(g))
	var want := GaugeRow.read(WeekCamp.forecast(c, g, WeekBoard.goal_of(c, g)), g, c.day)
	_check(is_equal_approx(float(dial.get("ghost")), float(want["legs"])), "a rest morning ghosts the dry run's LEGS (%.1f / %.1f)" % [
		float(dial.get("ghost")), float(want["legs"])])
	_check(str((gauge.deltas["legs"] as Label).text) != "", "and its change under LEGS (%s)" % (gauge.deltas["legs"] as Label).text)
	_check(f.get("week_edits", {}) == plan_before, "hovering changes no plan")
	camp.ghost_day(dow, [])
	_check(is_nan(float(dial.get("ghost"))) and (gauge.deltas["legs"] as Label).text == "", "[] clears the ghost")
	# 'undo' on a changed day ghosts the coach's card.
	main.act("wday", "%s|%d|rest|normal" % [fid, dow])
	await _frames(3)
	b = main.find_child("WeekBoard", true, false)
	var undo := b.find_child("Undo_%d" % dow, true, false) as Button
	gauge = b.find_child("Goal", true, false).find_child("Gauges", true, false)
	dial = gauge.find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	_check(undo != null, "the changed day has 'undo'")
	if undo != null:
		undo.mouse_entered.emit()
		await create_timer(0.3).timeout
		_check(not is_nan(float(dial.get("ghost"))), "hovering 'undo' ghosts the coach's card")
		undo.mouse_exited.emit()
		_check(is_nan(float(dial.get("ghost"))), "leaving 'undo' clears it")
		undo.pressed.emit()
		await _frames(3)
	# The morning's picker: the item under the cursor (its focused item) ghosts that card; closing it clears.
	b = main.find_child("WeekBoard", true, false)
	var mag := b.find_child("Session_%d" % dow, true, false) as MenuButton
	gauge = b.find_child("Goal", true, false).find_child("Gauges", true, false)
	dial = gauge.find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	var pop := mag.get_popup()
	var k := WeekPhase.cards().find(["rest", "normal"])
	plan_before = f.get("week_edits", {}).duplicate(true)
	pop.about_to_popup.emit()
	pop.set_focused_item(k)
	await create_timer(0.3).timeout
	_check(is_equal_approx(float(dial.get("ghost")), float(want["legs"])), "the picker's Rest under the cursor ghosts it (%.1f)" % float(dial.get("ghost")))
	pop.set_focused_item(-1)
	await _frames(2)
	_check(is_nan(float(dial.get("ghost"))), "off the list: no ghost")
	pop.set_focused_item(k)
	await _frames(2)
	pop.popup_hide.emit()
	await _frames(2)
	_check(is_nan(float(dial.get("ghost"))), "closing the picker clears the ghost")
	_check(f.get("week_edits", {}) == plan_before, "the picker's hover changes no plan")


func _camp_modal() -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	main.act("camp", str(f["id"]))
	await _frames(3)
	var m: Node = main.modal_node()
	var gauge = m.find_child("Gauges", true, false) if m != null else null
	_check(gauge != null, "SET CAMP: the gauge row on the left")
	if gauge == null:
		return
	var focus := str(main.modal["focus"])
	var proto := int(main.modal["protocol"])
	var film := bool(main.modal["film"])
	var dial: Control = gauge.find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	var sdial: Control = gauge.find_child("Gauge_scale", true, false).find_child("Dial", true, false)
	await create_timer(0.6).timeout
	(m.find_child("Focus_" + focus, true, false) as Control).mouse_entered.emit()
	_check(is_nan(float(dial.get("ghost"))), "the current focus card ghosts nothing")
	var other := ""
	for k in BoutRules.CAMP_FOCUSES:
		if k != focus:
			other = k
			break
	await _hover_matches(m, gauge, dial, sdial, "Focus_" + other, CampForecast.run(c, f, other, proto, film), f, c.day)
	var p2 := 3 if proto != 3 else 1
	await _hover_matches(m, gauge, dial, sdial, "Protocol_%d" % p2, CampForecast.run(c, f, focus, p2, film), f, c.day)
	(m.find_child("Protocol_%d" % proto, true, false) as Control).mouse_entered.emit()
	_check(is_nan(float(dial.get("ghost"))), "the current protocol ghosts nothing")
	var pc := m.find_child("Partner", true, false) as Control
	pc.mouse_entered.emit()
	await create_timer(0.3).timeout
	_check((gauge.deltas["legs"] as Label).text == "same" and (gauge.deltas["scale"] as Label).text == "same"
		and (gauge.deltas["risk"] as Label).text == "same", "the Partner card: same on all three dials")
	pc.mouse_exited.emit()
	if OppFile.has_tape(f["bout"]["opp"]):
		await _hover_matches(m, gauge, dial, sdial, "Film", CampForecast.run(c, f, focus, proto, not film), f, c.day)
	_check(str(main.modal["focus"]) == focus and int(main.modal["protocol"]) == proto and bool(main.modal["film"]) == film
		and not bool(main.modal.get("partner", false)), "hovering commits nothing")
	main.act("cproto", str(p2))
	await _frames(3)
	m = main.modal_node()
	var d2: Dictionary = GaugeRow.read(CampForecast.run(c, f, focus, p2, film), f, c.day)
	var nd: Control = m.find_child("Gauges", true, false).find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	await create_timer(0.6).timeout
	_check(is_equal_approx(float(nd.get("v")), float(d2["legs"])), "the click commits: the needle lands where the ghost was")
	main.act("close", "")


func _hover_matches(m: Node, gauge: Node, dial: Control, sdial: Control, card: String, fc: Dictionary, f: Dictionary, day: int) -> void:
	var b := m.find_child(card, true, false) as Control
	_check(b != null, "%s is on the modal" % card)
	if b == null:
		return
	var want := GaugeRow.read(fc, f, day)
	b.mouse_entered.emit()
	await create_timer(0.3).timeout
	var gd := GaugeRow.ghost_delta("legs", float(dial.get("v")), float(want["legs"]))
	_check(is_equal_approx(float(dial.get("ghost")), float(want["legs"])) and is_equal_approx(float(sdial.get("ghost")), float(want["kg"]))
		and (gauge.deltas["legs"] as Label).text == str(gd["text"]),
		"%s ghosts its dry run: LEGS %.1f, SCALE %.1f, %s" % [card, float(want["legs"]), float(want["kg"]), (gauge.deltas["legs"] as Label).text])
	b.mouse_exited.emit()
	_check(is_nan(float(dial.get("ghost"))) and (gauge.deltas["legs"] as Label).text == "", "%s: leaving clears the ghost" % card)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
