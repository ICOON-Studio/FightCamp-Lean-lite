extends SceneTree
## S467 LIVERRIBS1 v2 rules 2-3: LiverFold - a hurt liver can fold a boxer (a body knockdown, one count); fresh liver shots
## only; at most LiverRibs.FOLDS_MAX a bout; rib shots never fold. Population: Lucy (Data.lucy, day 40) v Data.OPPONENTS[0].

const LiverFold := preload("res://scripts/state/LiverFold.gd")
const LiverRibs := preload("res://scripts/rules/LiverRibs.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	_check(is_equal_approx(LiverFold.liver_value(0), 100.0) and LiverFold.liver_value(100) == 0.0, "liver value: fresh 100, floors at 0")
	var hurt_at := ceili(45.0 / LiverFold.shot_points)
	_check(LiverFold.liver_value(hurt_at) <= 55.0 and LiverFold.liver_value(hurt_at - 1) > 55.0, "liver hurt after %d liver shots" % hurt_at)
	var folds := 0
	var max_folds := 0
	var rib_folds := 0
	var repeat_folds := 0
	for s in 200:
		var f := _f({"a": {"liver": 30}, "b": {}})
		var so := {"a": 0, "b": 0}
		var k := LiverFold.roll(f, so, 1000 + s, {"a": 0.0, "b": 0.0})
		if not k.is_empty():
			folds += 1
			_check_quiet(str(k["who"]) == "a" and int(k["counts"]) == 1, "a fold is hers, one count")
		# the same tally again: no fresh liver shots, no roll
		if not LiverFold.roll(f, so, 2000 + s, {"a": 0.0, "b": 0.0}).is_empty():
			repeat_folds += 1
		# keep adding fresh shots: never past FOLDS_MAX
		for r in 10:
			f["bout"]["sides"]["a"]["liver"] = int(f["bout"]["sides"]["a"]["liver"]) + 10
			LiverFold.roll(f, so, 3000 + s * 10 + r, {"a": 0.0, "b": 0.0})
		max_folds = maxi(max_folds, int(f["bout"]["folds"]["a"]))
		var g := _f({"a": {"ribs": 60}, "b": {}})
		if not LiverFold.roll(g, {"a": 0, "b": 0}, 4000 + s, {"a": 0.0, "b": 0.0}).is_empty():
			rib_folds += 1
	print("LIVER_FOLD folds=%d/200 (30 liver shots) repeat=%d max_folds=%d rib_folds=%d" % [folds, repeat_folds, max_folds, rib_folds])
	_check(folds > 0, "a hurt liver folds her sometimes")
	_check(folds < 200, "but not every time")
	_check(repeat_folds == 0, "no fresh liver shots, no fold")
	_check(max_folds <= LiverRibs.FOLDS_MAX, "never more than FOLDS_MAX folds a bout")
	_check(rib_folds == 0, "CONTROL: rib shots never fold")
	# S467 rule 6: critical left ribs crack sometimes, and the round says so; fresh ribs never crack.
	var cracks := 0
	var fresh_cracks := 0
	var said := 0
	for s in 200:
		var g := _f({"a": {"ribs": 14}, "b": {}})
		var lines: Array = []
		LiverFold.roll(g, {"a": 0, "b": 0}, 5000 + s, {"a": 0.0, "b": 0.0}, lines)
		if bool(g["bout"]["cracked"]["a"]):
			cracks += 1
			said += int(lines.size() > 0)
		var h := _f({"a": {"ribs": 3}, "b": {}})
		LiverFold.roll(h, {"a": 0, "b": 0}, 6000 + s, {"a": 0.0, "b": 0.0}, [])
		fresh_cracks += int(bool(h["bout"]["cracked"]["a"]))
	print("LIVER_FOLD cracks=%d/200 (14 rib shots) fresh_cracks=%d" % [cracks, fresh_cracks])
	_check(cracks > 0 and cracks < 200, "critical left ribs crack sometimes")
	_check(said == cracks, "every crack has its round line")
	_check(fresh_cracks == 0, "CONTROL: ribs that are not critical never crack")
	print("LIVER_FOLD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _f(tally: Dictionary) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 40)
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "sides": tally}
	return f


func _check_quiet(cond: bool, label: String) -> void:
	if not cond:
		failures += 1
		print("FAIL " + label)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
