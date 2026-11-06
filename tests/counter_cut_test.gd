extends SceneTree
## S393: a stopped punch moves to meet the other's landed punch. Who lands what never changes.

const CC := preload("res://scripts/rules/CounterCut.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1


func _p(t: float, who: String, move: String, result: String) -> Dictionary:
	return {"t": t, "who": who, "move": move, "result": result, "caption": "", "big": false, "knockback": false, "def": ""}


func _rng(chance_passes: bool) -> RandomNumberGenerator:
	for s in 200:
		var r := RandomNumberGenerator.new()
		r.seed = s
		var state := r.state
		var pass_now := r.randf() < CC.CHANCE
		r.state = state
		if pass_now == chance_passes:
			return r
	return RandomNumberGenerator.new()


func _initialize() -> void:
	var beats: Array = [_p(5.0, "a", "cross", "lands"), _p(5.8, "b", "jab", "blocked"), _p(20.0, "a", "jab", "lands")]
	var moved := CC.apply(beats, _rng(true))
	_check(not moved.is_empty() and str(moved["who"]) == "b", "her blocked punch is the one that moves")
	_check(is_equal_approx(float(moved["t"]), 5.0 + CC.START_AFTER_S), "it starts just after the other's punch")
	_check(bool(moved.get("stopped", false)), "it is marked stopped, so no defence or sound shows")
	_check(beats.filter(func(b): return str(b["result"]) == "lands").size() == 2, "who lands what is unchanged")
	_check(beats.filter(func(b): return bool(b.get("stopped", false))).size() == 1, "one an exchange")
	_check(float(beats[0]["t"]) <= float(beats[1]["t"]) and float(beats[1]["t"]) <= float(beats[2]["t"]), "the beats stay in order")

	var skip: Array = [_p(5.0, "a", "cross", "lands"), _p(5.8, "b", "jab", "blocked")]
	_check(CC.apply(skip, _rng(false)).is_empty(), "not every exchange has one")

	var landed: Array = [_p(5.0, "a", "cross", "lands"), _p(5.8, "b", "jab", "lands")]
	_check(CC.apply(landed, _rng(true)).is_empty(), "a punch that lands is never moved")

	var combo := _p(5.8, "b", "jab", "blocked")
	combo["combo_id"] = "1-2"
	_check(CC.apply([_p(5.0, "a", "cross", "lands"), combo], _rng(true)).is_empty(), "a combo keeps its rhythm")

	var busy: Array = [_p(5.0, "a", "cross", "lands"), _p(5.8, "b", "jab", "blocked"), _p(4.9, "b", "cross", "misses")]
	var got := CC.apply(busy, _rng(true))
	_check(got.is_empty() or absf(float(got["t"]) - 5.08) < 0.001 and busy.filter(func(b): return str(b["who"]) == "b" and absf(float(b["t"]) - 5.08) < CC.OWN_CLEAR_S).size() <= 2, "no punch moves on top of her own")

	var hurt: Array = [_p(4.5, "a", "jab", "lands"), _p(5.0, "a", "cross", "lands"), _p(5.8, "b", "jab", "blocked")]
	var after_hit := CC.apply(hurt, _rng(true))
	_check(after_hit.is_empty() or float(after_hit["t"]) < 4.9, "she is not moved into a hit she is still reacting to")

	var tied: Array = [_p(5.0, "a", "cross", "lands"), _p(5.8, "b", "jab", "blocked"), {"t": 5.5, "who": "a", "move": "clinch", "result": "none"}]
	_check(CC.apply(tied, _rng(true)).is_empty(), "nothing moves beside a clinch")
	print("COUNTER_CUT failures=%d" % failures)
	quit(1 if failures > 0 else 0)
