extends SceneTree
## S523 TURNPRO1 map M14: the house's lean on the first 6 pro offer sets (ProLean.extra) and the softer ask's tune-up sets.
## Control arm: no house (an old save) and the 7th pro fight leave the promoter's rows as they were.

const ProLean := preload("res://scripts/state/ProLean.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _cand(id: int, mid: float) -> Dictionary:
	return {"b": {"id": id}, "mid": mid}


func _out() -> Array:
	return [{"id": 1, "kind": "tune"}, {"id": 2, "kind": "above"}, {"id": 3, "kind": "payday"}]


func _kinds(rows: Array) -> Array:
	return rows.map(func(o): return str(o["kind"]))


func _initialize() -> void:
	var tunes := [_cand(1, 0.82), _cand(4, 0.90), _cand(5, 0.75)]
	var steps := [_cand(2, 0.5), _cand(6, 0.6), _cand(7, 0.3)]
	var hf := {"pro_house": "hf", "pro_w": 1}
	var r := ProLean.extra(hf, _out(), tunes, steps, false, 100, [], 0.82, 0.5)
	_check(_kinds(r) == ["tune", "above", "payday", "tune"] and int(r[3]["id"]) == 5, "Harrow & Finch adds the next-nearest tune-up (id %d)" % int(r[3]["id"]))
	var bow := {"pro_house": "bow"}
	r = ProLean.extra(bow, _out(), tunes, steps, false, 100, [], 0.82, 0.5)
	_check(_kinds(r) == ["tune", "above", "payday", "above"] and int(r[3]["id"]) == 6, "Bow Lane adds the next-nearest step up (id %d)" % int(r[3]["id"]))
	r = ProLean.extra(bow, _out(), tunes, steps, true, 100, [], 0.82, 0.5)
	_check(r.size() == 3, "no extra step up while rebuilding or after two ducks")
	r = ProLean.extra({"pro_house": "hf", "pro_w": 5, "pro_l": 1}, _out(), tunes, steps, false, 100, [], 0.82, 0.5)
	_check(r.size() == 3 and ProLean.line({"pro_house": "hf", "pro_w": 6}) == "", "after 6 pro fights the lean ends (control)")
	r = ProLean.extra({}, _out(), tunes, steps, false, 100, [], 0.82, 0.5)
	_check(r.size() == 3, "no house (an old save): the rows unchanged (control)")
	r = ProLean.extra({"pro_house": "bow", "pro_tune_ups": 2}, _out(), tunes, steps, false, 100, [], 0.82, 0.5)
	_check(_kinds(r) == ["tune"], "the softer ask: tune-ups only")
	_check(ProLean.line({"pro_house": "hf", "pro_w": 2}).contains("4 left") and ProLean.line({"pro_tune_ups": 1}).contains("tune-ups"),
		"the Fights line: '%s'" % ProLean.line({"pro_house": "hf", "pro_w": 2}))
	print("PRO_LEAN %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
