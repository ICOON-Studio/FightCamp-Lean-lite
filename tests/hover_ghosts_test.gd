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
##      coach's card on hover; the morning's picker (S382: picture cards) ghosts the card under the cursor and clears off the
##      list or closed; hovering changes no plan.
## Population: hand-written forecasts (2); the jump=camp career (TestJump "camp": Lucy in camp, her bout booked) for 3-4.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")
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
	# S496: the whiteboard part (_board) went with the old Training tab (TRAINING has no gauge row); the camp modal stays.
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
