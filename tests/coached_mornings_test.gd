extends SceneTree
## MORNINGS1: pure morning budgets, weak spots, pairing, and extra gains.

const M := preload("res://scripts/rules/CoachedMornings.gd")
var failures := 0


func _initialize() -> void:
	_rates()
	_weak_spots()
	_allocation()
	_pairing()
	print("COACHED_MORNINGS %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("ok   " if ok else "FAIL ") + what)


func _near(actual: float, expected: float, what: String) -> void:
	_check(is_equal_approx(actual, expected), what)


func _ask(id: String, ability: String, use: String, weak: bool = false) -> Dictionary:
	return {"id": id, "ability": ability, "use": use, "weak": weak}


func _stats() -> Dictionary:
	return {"power": 50, "speed": 50, "technique": 50, "defense": 50, "conditioning": 50, "fight_iq": 50}


func _rates() -> void:
	_check(M.owned("sessional") == 6, "sessional owns six mornings")
	_check(M.owned("full_time") == 7, "full-time owns seven mornings")
	_check(M.owned("none") == 4, "no coach owns four mornings")
	_check(M.owned("x") == 4, "unknown coach owns four mornings")
	_near(M.mult("solo", false), 1.25, "solo normal rate")
	_near(M.mult("solo", true), 1.4, "solo weak rate")
	_near(M.mult("shared", false), 1.15, "shared normal rate")
	_near(M.mult("shared", true), 1.15, "shared weak rate stays shared")
	_near(M.mult("none", true), 1.0, "uncoached weak rate")
	_near(M.mult("x", false), 1.0, "unknown use is uncoached")
	_near(M.mult("pads", true), 1.0, "pads are not a stat multiplier")
	_near(M.pads_rate(), 0.8, "morning pads rate")


func _weak_spots() -> void:
	var stats := _stats()
	_check(M.weak_spot(stats) == "", "level fifties have no weak spot")
	_check(M.weak_line(stats) == "", "no weak spot has no line")
	stats["defense"] = 44
	_check(M.weak_spot(stats) == "defense", "44 defense is five under mean 49")
	_check(M.weak_line(stats) == "Low Defence: pressure fighters find it", "defence weak line")
	stats["defense"] = 48
	_check(M.weak_spot(stats) == "", "48 defense is less than three below mean")
	stats["defense"] = 40
	stats["speed"] = 40
	_check(M.weak_spot(stats) == "speed", "lowest tie follows fight ability order")
	stats = _stats()
	stats["power"] = 47
	stats["speed"] = 53
	_check(M.weak_spot(stats) == "power", "exactly three below mean qualifies")
	stats = _stats()
	stats.erase("power")
	_check(M.weak_spot(stats) == "power", "missing fight ability counts as zero")
	_check(M.weak_spot({}) == "", "all missing abilities are level zeros")
	stats = _stats()
	stats["unrelated"] = -10000
	_check(M.weak_spot(stats) == "", "only the six fight abilities set the mean")


func _allocation() -> void:
	var asks: Array = []
	for i in range(7):
		asks.append(_ask(str(i), "power", "solo"))
	var before := asks.duplicate(true)
	var dealt := M.deal(asks, "sessional")
	_check(asks == before, "deal does not mutate asks")
	_check(dealt.size() == 7, "one result per ask")
	for i in range(7):
		_check(dealt[i]["id"] == str(i) and dealt[i]["ability"] == "power" and dealt[i].size() == 4, "result shape and order %d" % i)
		_check(dealt[i]["use"] == ("solo" if i < 6 else "none"), "sessional solo allocation %d" % i)
		_near(float(dealt[i]["mult"]), 1.25 if i < 6 else 1.0, "solo allocation rate %d" % i)
	_near(M.added(dealt), 1.5, "six solo mornings add 1.5")
	_check(M.deal(asks, "full_time")[6]["use"] == "solo", "full-time funds seventh solo")
	_check(M.deal(asks, "none")[4]["use"] == "none", "no coach exhausts after four")
	_check(M.deal([], "sessional").is_empty(), "empty asks return empty deal")
	_near(M.added([]), 0.0, "empty week adds zero")
	dealt = M.deal([_ask("weak", "defense", "solo", true)], "none")
	_near(float(dealt[0]["mult"]), 1.4, "deal carries solo weak bonus")
	dealt = M.deal([_ask("pad", "technique", "pads", true)], "none")
	_check(dealt[0]["use"] == "pads", "pads retain their use")
	_near(float(dealt[0]["mult"]), 0.8, "dealt pads rate")
	_near(M.added(dealt), 0.0, "pads add no stat morning-equivalents")


func _pairing() -> void:
	var asks: Array = []
	for i in range(6):
		asks.append(_ask(str(i), "speed", "shared", true))
	# Three pairs leave the fourth player-owned morning available for a solo.
	asks.append(_ask("last", "power", "solo"))
	asks.append(_ask("overflow", "power", "solo"))
	var dealt := M.deal(asks, "none")
	for i in range(6):
		_check(dealt[i]["use"] == "shared", "paired use %d" % i)
		_near(float(dealt[i]["mult"]), 1.15, "paired rate %d" % i)
	_check(dealt[6]["use"] == "solo" and dealt[7]["use"] == "none", "six shared asks use exactly three mornings")
	_near(M.added(dealt.slice(0, 6)), 0.9, "six shared asks add 0.9")
	dealt = M.deal([_ask("lone", "speed", "shared")], "none")
	_check(dealt[0]["use"] == "solo", "lone shared becomes solo")
	_near(float(dealt[0]["mult"]), 1.25, "lone shared solo rate")
	dealt = M.deal([_ask("lone", "speed", "shared", true)], "none")
	_near(float(dealt[0]["mult"]), 1.4, "lone weak shared receives solo weak rate")
	asks = [
		_ask("a", "speed", "shared"), _ask("b", "power", "shared"),
		_ask("c", "speed", "solo"), _ask("d", "speed", "shared"),
		_ask("e", "power", "shared"), _ask("f", "speed", "shared"),
	]
	dealt = M.deal(asks, "none")
	_check(dealt[0]["use"] == "shared" and dealt[3]["use"] == "shared", "pairs skip other abilities and nonshared asks")
	_check(dealt[1]["use"] == "shared" and dealt[4]["use"] == "shared", "interleaved ability gets its own pair")
	_check(dealt[5]["use"] == "solo", "next matching partner is used only once")
	asks = []
	for i in range(3):
		asks.append(_ask(str(i), "power", "pads"))
	asks.append(_ask("pair1", "defense", "shared"))
	asks.append(_ask("unfunded", "speed", "solo"))
	asks.append(_ask("pair2", "defense", "shared"))
	asks.append(_ask("unfunded_pad", "power", "pads"))
	dealt = M.deal(asks, "none")
	_check(dealt[3]["use"] == "shared" and dealt[5]["use"] == "shared", "last morning covers its later reserved partner")
	_check(dealt[4]["use"] == "none" and dealt[6]["use"] == "none", "exhausted budget rejects intervening solo and later pads")
	_near(float(dealt[4]["mult"]), 1.0, "unfunded stat rate is neutral")
	_near(float(dealt[6]["mult"]), 1.0, "unfunded pads rate is neutral")
	_near(M.added(dealt), 0.3, "mixed week counts only the shared stat gains")
