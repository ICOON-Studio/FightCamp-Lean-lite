extends SceneTree
## S489 STEPVALUE1 piece 3 (his Q-S294-231: "three in a round on your count = the next exchange is on the ropes"): StepWire
## counts planned steps on the round - three step backs put the next exchange on own_ropes and start the count again,
## pivot out / step out clear it, cut off / herd count toward the opponent's ropes, a step not planned (improvised) or a
## punch moves nothing. Run:
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/step_ropes_test.gd

const StepWire := preload("res://scripts/state/StepWire.gd")

var fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		fails += 1
		print("FAIL ", what)


func _go(lv: Dictionary, arrow: String, planned := true) -> Dictionary:
	lv["at"] = "long"   # where_next's pick, before the count
	var rec := {}
	StepWire.after(lv, rec, arrow, planned)
	return rec


func _initialize() -> void:
	var lv := {}
	_go(lv, "step_back")
	_go(lv, "step_back")
	_check(str(lv["at"]) == "long" and int(lv["ropes"]) == 2, "two step backs: count 2, the place is where_next's")
	var r3 := _go(lv, "step_back")
	_check(str(lv["at"]) == "own_ropes" and str(r3["ropes_put"]) == "own", "the third: the next exchange is on the ropes")
	_check(int(lv["ropes"]) == 0 and StepWire.times(lv) == 1, "the count starts again; once on the ropes")
	_go(lv, "step_back")
	_go(lv, "step_back")
	_go(lv, "pivot_out")
	_check(int(lv["ropes"]) == 0 and str(lv["at"]) == "long", "pivot out clears the count")
	_go(lv, "step_back")
	_go(lv, "step_out")
	_check(int(lv["ropes"]) == 0, "step out clears the count")
	_go(lv, "step_back", false)
	_go(lv, "step_back", false)
	_go(lv, "step_back", false)
	_check(int(lv.get("ropes", 0)) == 0 and str(lv["at"]) == "long", "an improvised step counts nothing")
	_go(lv, "1-2")
	_check(int(lv.get("ropes", 0)) == 0 and str(_go(lv, "1-2")["ropes_put"]) == "", "a punch moves nothing")
	var o := {}
	_go(o, "cut_off")
	_go(o, "herd")
	var r := _go(o, "cut_off")
	_check(str(o["at"]) == "opp_ropes" and str(r["ropes_put"]) == "opp" and int(o["opp_ropes"]) == 0,
		"cut off, herd, cut off: the opponent on the ropes")
	_check(StepWire.times(o) == 0, "the opponent's ropes are not counted as yours")
	_go(o, "step_back@outside")
	_check(int(o["ropes"]) == 1, "a step thrown on a card counts as its base step")
	print("step_ropes_test %s" % ("PASS" if fails == 0 else "FAIL (%d)" % fails))
	quit(0 if fails == 0 else 1)
