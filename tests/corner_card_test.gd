extends SceneTree
## S303 CornerCard: what worked / what hurt from the beats the ring played, and the corner's call (tired -> calm, hurt by
## short punches -> long, outworked at range -> body, else more of what worked).

const K := preload("res://scripts/rules/CornerCard.gd")

var _fails := 0


func _initialize() -> void:
	var names := ["Lucy", "Maria"]
	# Her jab lands 3, her 1-2 lands whole; Maria's left hook lands 2.
	var beats := [_b("a", "jab", "lands", "1-2"), _b("a", "cross", "lands", "1-2"), _b("b", "lead_hook", "lands"),
		_b("a", "jab", "lands"), _b("b", "lead_hook", "lands"), _b("a", "jab", "lands"), _b("b", "jab", "blocked"),
		_b("a", "step_in", "none")]
	var s := K.summarize(beats)
	_check(int(s["a"]["landed"].get("jab", 0)) == 3 and int(s["a"]["landed"].get("cross", 0)) == 1, "summarize: her landed by punch (3 jab, 1 cross)")
	_check(int(s["b"]["landed"].get("lead_hook", 0)) == 2 and not s["b"]["landed"].has("jab"), "summarize: blocked punches do not count")
	_check((s["a"]["whole"] as Array) == ["1-2"], "summarize: the 1-2 landed whole")
	var c := K.card(s, 70.0, names)
	_check(str(c["worked"]).contains("jab") and str(c["worked"]).contains("3") and str(c["worked"]).contains("1-2"), "card: worked names her jab x3 and the 1-2 (%s)" % c["worked"])
	_check(str(c["hurt"]).contains("Maria") and str(c["hurt"]).contains("left hook"), "card: hurt names Maria's left hook (%s)" % c["hurt"])
	_check(str(c["call"]) == "long", "card: hurt by a short punch -> stay long")
	_check(str(K.card(s, 30.0, names)["call"]) == "calm", "card: tired (30) -> calm, whatever happened")
	# Outworked at range -> body.
	var s2 := K.summarize([_b("b", "jab", "lands"), _b("b", "cross", "lands"), _b("b", "jab", "lands"), _b("a", "jab", "lands")])
	_check(str(K.card(s2, 80.0, names)["call"]) == "body", "card: hurt by the jab at range -> go to the body")
	# Her body work lands, nothing hurts -> keep digging.
	var s3 := K.summarize([_b("a", "body_hook", "lands"), _b("a", "body_hook", "lands"), _b("b", "jab", "missed")])
	var c3 := K.card(s3, 80.0, names)
	_check(str(c3["call"]) == "body" and str(c3["hurt"]).contains("nothing"), "card: her body shots work -> body; hurt says nothing landed")
	# A cut combination never counts as whole; an empty round names her: 'Lucy landed nothing clean.' (S309: two women in
	# the ring, every line says whose punches).
	var cut := [_b("a", "jab", "lands", "1-2-3"), _b("a", "cross", "lands", "1-2-3")]
	cut[1]["combo_cut"] = true
	_check((K.summarize(cut)["a"]["whole"] as Array).is_empty(), "summarize: an unfinished combination is not whole")
	_check(str(K.card(K.summarize([]), 90.0, names)["worked"]) == "Lucy landed nothing clean.", "card: empty round")
	_check(str(c["worked"]).begins_with("Lucy landed 3 clean jabs") and str(K.card(s3, 80.0, names)["worked"]) == "Lucy landed 2 clean hooks to the body.",
		"card: whose punches and how many, plural right (%s / %s)" % [c["worked"], K.card(s3, 80.0, names)["worked"]])
	print("CORNER_CARD %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _b(who: String, move: String, result: String, cid: String = "") -> Dictionary:
	var d := {"t": 0.0, "who": who, "move": move, "result": result, "caption": ""}
	if cid != "":
		d["combo_id"] = cid
	return d


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
