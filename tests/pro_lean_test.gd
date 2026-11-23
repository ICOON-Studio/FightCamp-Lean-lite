extends SceneTree
## S523 TURNPRO1 map M14 (the house's lean on the first 6 pro offer sets, the softer ask's tune-up sets) was CUT by S543
## TURNPROBUILD17 (v17: one promoter, no asks; fights 1-6 are the safe / risky pair, ProPair). Its checks of the lean and the
## softer ask are deleted with the rule (docs/TURNPROBUILD17_RESULT.md). What stays: ProLean.extra hands ProLadder's rows
## back unchanged (the normal booking from fight 7 is untouched), and pro_fights counts the record.

const ProLean := preload("res://scripts/state/ProLean.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var out := [{"id": 1, "kind": "tune"}, {"id": 2, "kind": "above"}, {"id": 3, "kind": "payday"}]
	var r := ProLean.extra({"pro_house": "hf", "pro_w": 1, "pro_tune_ups": 2}, out.duplicate(true), [], [], false, 100, [], 0.82, 0.5)
	_check(r == out, "the rows come back unchanged, whatever an old save's house or softer ask says")
	_check(ProLean.pro_fights({"pro_w": 3, "pro_l": 1, "pro_d": 1}) == 5, "pro fights count wins, losses and draws")
	_check(ProLean.LEAN_FIGHTS == 6, "the two-bout fights are six (the v17 probe reads it)")
	print("PRO_LEAN failures=%d" % failures)
	quit(0 if failures == 0 else 1)
