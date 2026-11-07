extends SceneTree
## S395 FightHud.shown: the rings' tanks ease through the exchange being fought and meet its "after" on the 30 s line, so the
## bell shows the number the corner card reads (film: rings 67/69 at the bell, the card 62/65). Body and hurt stay on the line.

const FightHud := preload("res://scripts/fight3d/FightHud.gd")
const CornerOverlay := preload("res://scripts/fight3d/CornerOverlay.gd")
const CornerRest := preload("res://scripts/fight3d/CornerRest.gd")
const FightCalls := preload("res://scripts/fight3d/FightCalls.gd")
const HudArc := preload("res://scripts/fight3d/HudArc.gd")

var failures := 0


func _initialize() -> void:
	var start := {"a": 100.0, "b": 100.0, "body": [0, 0], "hurt": [false, false]}
	var exs := [{"after": {"a": 90.0, "b": 80.0, "body": [1, 0], "hurt": [false, false]}},
		{"after": {"a": 70.0, "b": 60.0, "body": [2, 3], "hurt": [true, false]}}]
	_near(FightHud.shown(exs, 0.0, start)["a"], 100.0, "the round opens on the start")
	_near(FightHud.shown(exs, 15.0, start)["a"], 95.0, "halfway through the first exchange, her tank is halfway down")
	_near(FightHud.shown(exs, 15.0, start)["b"], 90.0, "and so is the opponent's")
	_near(FightHud.shown(exs, 30.0, start)["a"], 90.0, "on the line it is the exchange's after")
	_near(FightHud.shown(exs, 45.0, start)["a"], 80.0, "the second exchange eases from the first's after")
	_check(FightHud.shown(exs, 45.0, start)["body"] == [1, 0], "body stays on the last finished exchange")
	_check(FightHud.shown(exs, 45.0, start)["hurt"] == [false, false], "hurt is not shown before it was watched")
	_near(FightHud.shown(exs, 60.0, start)["a"], 70.0, "past the last exchange fought: its after")
	_near(FightHud.shown(exs, 180.0, start)["b"], 60.0, "at the bell: the number the corner card reads")
	_near(FightHud.shown([], 45.0, start)["a"], 100.0, "no exchanges yet: the start")
	_check(CornerOverlay.clock_text(59.2, 2) == "CORNER   1:00   ROUND 2 NEXT", "the corner clock never reads 0:60")
	_check(CornerOverlay.clock_text(9.0, 3) == "CORNER   0:09   ROUND 3 NEXT", "and pads the seconds")
	_near(CornerRest.at(62.0, 81.0, 0.0), 62.0, "the rest starts on the bell's number")
	_near(CornerRest.at(62.0, 81.0, 1.0), 81.0, "and ends on what the next round opens on")
	_near(CornerRest.at(62.0, 81.0, 2.0), 81.0, "and stays there")
	_check(CornerRest.at(62.0, 81.0, 0.5) > 71.5, "most of it comes back early in the rest")
	_near(CornerRest.at(70.0, 60.0, 0.5), 70.0, "a rest never takes a tank down")
	_check(FightCalls.line("rear_hook", false) == "RIGHT HOOK", "the TV line names the punch")
	_check(FightCalls.line("body_hook", true) == "BIG HOOK TO THE BODY", "and marks a big one")
	_near(FightCalls.envelope(0.0), 0.0, "the lens starts out")
	_near(FightCalls.envelope(0.5), 1.0, "is in during the slow part")
	_near(FightCalls.envelope(FightCalls.HOLD_S + FightCalls.OUT_S), 0.0, "and back out after it")
	_check(FightCalls.allowed(0, 99.0), "the first big shot of a round gets the moment")
	_check(not FightCalls.allowed(2, 99.0), "a third does not")
	_check(not FightCalls.allowed(1, 3.0), "nor one straight after another")
	_check(not HudArc.number_on_arc("stamina", 0.2), "stamina has the middle, not an arc number")
	_check(not HudArc.number_on_arc("legs", 0.9), "a fine part shows no number")
	_check(HudArc.number_on_arc("legs", 0.5), "a low part does")
	var two := ["Lucy", "Maria"]
	_check(CornerRest.parts_text({"legs": [60.0, 80.0], "guard": [70.0, 90.0]}, 1.0) == "LEGS 80   GUARD 90", "the body line ends on the opening numbers")
	_check(CornerRest.parts_text({"legs": [60.0, 80.0]}, 0.0) == "LEGS 60", "and leaves out a guard not scouted")
	_near(CornerRest.opens(70.0, {}, {}), 70.0, "no corner jobs: the rest alone")
	_check(CornerRest.word(two, 81.0, 75.0, 81.0, 75.0) == "LUCY FRESHER", "the strip names who the rest leaves fresher")
	_check(CornerRest.word(two, 62.0, 65.0, 81.0, 75.0) == "ENERGY", "not the other one on the way there")
	_check(CornerRest.word(two, 69.0, 74.0, 72.0, 80.0) == "MARIA FRESHER", "either way round")
	_check(CornerRest.word(two, 70.0, 71.0, 70.0, 71.0) == "ENERGY", "and names nobody when it is close")
	_check(FightHud.round_line(1, 3, [], two) == "ROUND 1 OF 3", "nothing to tally in round 1")
	_check(FightHud.round_line(2, 3, [{"won": false}], two) == "ROUND 2 OF 3   MARIA LEADS 1-0", "the round line carries the fight score")
	_check(FightHud.round_line(3, 3, [{"won": true}, {"won": false}], two) == "ROUND 3 OF 3   LEVEL 1-1", "and says when it is level")
	print("hud_shown_test failures=", failures)
	quit(failures)


func _near(got: Variant, want: float, label: String) -> void:
	_check(absf(float(got) - want) < 0.001, "%s (%s, want %s)" % [label, got, want])


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
