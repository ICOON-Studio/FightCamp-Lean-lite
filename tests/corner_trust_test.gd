extends SceneTree
## S401 CornerTrust: a wrong corner call costs her trust; a Low fighter stops listening.
## Pure rules + tests: the module (CornerTrust.gd), the morale events (call_wrong / call_right),
## and the wiring inside LiveRound and BoutNight. No screens, no new meter - morale moves.
##
## Covers:
##   1. tally: every row of the design table (wrong+lost, best+won, ok+won, wrong+won, best+lost,
##      fit=none, no shout) - one case each.
##   2. lands: morale 29.9 false, 30.0 true, 80 true.
##   3. settle: 5 wrong -> at most 3 counted; 5 right -> at most 3 counted; second settle no-op;
##      0 calls no-op.
##   4. real bouts (Lucy vs Maria and Erin, 120 nights each): at morale 20 a shouting corner
##      fights the same rounds as a silent one (nothing lands); at morale 60 it does NOT (control).
##   5. morale-per-bout: always-right vs always-wrong shouter; always-wrong must lose more.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const NIGHTS := 120

var _fails := 0


func _initialize() -> void:
	_test_tally()
	_test_lands()
	_test_settle()
	_test_real_bouts()
	print("CORNER_TRUST failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _test_tally() -> void:
	var b1 := {}
	CornerTrust.tally(b1, [{"shout": true, "fit": "wrong", "won": false}])
	_check(int(b1.get("calls_wrong", 0)) == 1, "tally: wrong+lost -> calls_wrong +1")

	var b2 := {}
	CornerTrust.tally(b2, [{"shout": true, "fit": "best", "won": true}])
	_check(int(b2.get("calls_right", 0)) == 1, "tally: best+won -> calls_right +1")

	var b3 := {}
	CornerTrust.tally(b3, [{"shout": true, "fit": "ok", "won": true}])
	_check(int(b3.get("calls_right", 0)) == 1, "tally: ok+won -> calls_right +1")

	var b4 := {}
	CornerTrust.tally(b4, [{"shout": true, "fit": "wrong", "won": true}])
	_check(int(b4.get("calls_wrong", 0)) == 0 and int(b4.get("calls_right", 0)) == 0,
		"tally: wrong+won -> nothing")

	var b5 := {}
	CornerTrust.tally(b5, [{"shout": true, "fit": "best", "won": false}])
	_check(int(b5.get("calls_wrong", 0)) == 0 and int(b5.get("calls_right", 0)) == 0,
		"tally: best+lost -> nothing")

	var b6 := {}
	CornerTrust.tally(b6, [{"shout": true, "fit": "none", "won": true}])
	_check(int(b6.get("calls_wrong", 0)) == 0 and int(b6.get("calls_right", 0)) == 0,
		"tally: fit=none -> nothing")

	var b7 := {}
	CornerTrust.tally(b7, [{"shout": false, "fit": "wrong", "won": false}])
	_check(int(b7.get("calls_wrong", 0)) == 0 and int(b7.get("calls_right", 0)) == 0,
		"tally: no shout -> nothing")


func _test_lands() -> void:
	_check(not CornerTrust.lands({"morale": 29.9}), "lands: morale 29.9 -> false (Low)")
	_check(CornerTrust.lands({"morale": 30.0}), "lands: morale 30.0 -> true (Flat)")
	_check(CornerTrust.lands({"morale": 80.0}), "lands: morale 80 -> true (Fired up)")


func _test_settle() -> void:
	var f1 := _make_fighter(50.0)
	f1["bout"] = {"calls_wrong": 5, "calls_right": 0}
	var m0: float = float(f1["morale"])
	var r1 := CornerTrust.settle(f1, "Test")
	_check(int(r1["wrong"]) == 3, "settle: 5 wrong -> 3 counted (cap)")
	_check(float(f1["morale"]) < m0, "settle: wrong calls -> morale down")
	var max_drop: float = 3.0 * 2.0 * 1.3
	_check(m0 - float(f1["morale"]) <= max_drop + 0.2,
		"settle: drop within bounds (got %.2f, max %.2f)" % [m0 - float(f1["morale"]), max_drop])

	var m1: float = float(f1["morale"])
	CornerTrust.settle(f1, "Test")
	_check(abs(float(f1["morale"]) - m1) < 0.01, "settle: second call changes nothing")

	var f2 := _make_fighter(50.0)
	f2["bout"] = {"calls_wrong": 0, "calls_right": 5}
	var m2: float = float(f2["morale"])
	var r2 := CornerTrust.settle(f2, "Test")
	_check(int(r2["right"]) == 3, "settle: 5 right -> 3 counted (cap)")
	_check(float(f2["morale"]) > m2, "settle: right calls -> morale up")

	var f3 := _make_fighter(50.0)
	f3["bout"] = {"calls_wrong": 0, "calls_right": 0}
	var m3: float = float(f3["morale"])
	CornerTrust.settle(f3, "Test")
	_check(abs(float(f3["morale"]) - m3) < 0.01, "settle: 0 calls -> no change")


func _test_real_bouts() -> void:
	for opp_i in [0, 2]:
		var who := str((Data.OPPONENTS[opp_i] as Dictionary)["first"])
		var silent_20 := _arm(opp_i, 20.0, "silent")
		var shout_20 := _arm(opp_i, 20.0, "shout")
		print("  vs %s morale 20: silent %d rounds, shout %d rounds" % [who, silent_20, shout_20])
		_check(silent_20 == shout_20,
			"vs %s morale 20: shout == silent (%d == %d)" % [who, silent_20, shout_20])
		var silent_60 := _arm(opp_i, 60.0, "silent")
		var shout_60 := _arm(opp_i, 60.0, "shout")
		print("  vs %s morale 60: silent %d rounds, shout %d rounds" % [who, silent_60, shout_60])
		_check(silent_60 != shout_60,
			"vs %s morale 60: shout != silent (%d != %d)" % [who, silent_60, shout_60])
	var n_rt := 30
	var right_total := 0.0
	var wrong_total := 0.0
	for opp_i in [0, 2]:
		for i in n_rt:
			var c := Career.quick_start()
			c.day = 20 + i
			c.news.clear()
			var fr := Data.fighter_state(Data.lucy(), c.day)
			fr["morale"] = 60.0
			c.fighters = [fr]
			fr["bout"] = {"opp": (Data.OPPONENTS[opp_i] as Dictionary).duplicate(true),
				"day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
			fr["camp"] = {}
			_fight_one(c, fr, "right")
			right_total += float(fr["morale"]) - 60.0
		for i in n_rt:
			var c := Career.quick_start()
			c.day = 20 + i
			c.news.clear()
			var fw := Data.fighter_state(Data.lucy(), c.day)
			fw["morale"] = 60.0
			c.fighters = [fw]
			fw["bout"] = {"opp": (Data.OPPONENTS[opp_i] as Dictionary).duplicate(true),
				"day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
			fw["camp"] = {}
			_fight_one(c, fw, "wrong")
			wrong_total += float(fw["morale"]) - 60.0
	var right_avg := right_total / float(n_rt * 2)
	var wrong_avg := wrong_total / float(n_rt * 2)
	print("  morale/bout always-right: %.2f" % right_avg)
	print("  morale/bout always-wrong: %.2f" % wrong_avg)
	_check(wrong_avg < right_avg, "always-wrong loses more morale than always-right")


func _make_fighter(heart: float) -> Dictionary:
	var f := {"id": "test_ct", "morale": 60.0,
		"personality": {"heart": heart, "confidence": 50.0, "coachability": 55.0}}
	FighterProfile.ensure(f)
	return f


func _arm(opp_i: int, morale: float, strategy: String) -> int:
	var won := 0
	var c := Career.quick_start()
	c.fighters.insert(0, {})
	for i in NIGHTS:
		c.day = 20 + i
		c.news.clear()
		var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
		f["morale"] = morale
		c.fighters[0] = f
		f["bout"] = {"opp": (Data.OPPONENTS[opp_i] as Dictionary).duplicate(true),
			"day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		f["camp"] = {}
		var m: Dictionary
		if strategy == "silent":
			m = {"fid": f["id"], "step": "tape", "total": 3}
			Bouts.fight_step(c, f, m, "sim")
		else:
			m = _fight_one(c, f, strategy)
		for r in m["rounds"]:
			won += 1 if bool(r["won"]) else 0
	return won


func _fight_one(c: Career, f: Dictionary, strategy: String) -> Dictionary:
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	var rounds_total: int = BoutNight.rounds_of(f)
	for round_i in range(rounds_total):
		if round_i > 0:
			if BoutNight.stopped(m) != "":
				break
			Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		for _ex_i in range(5):
			if BoutNight.stopped(m) != "":
				break
			if LiveRound.live(m).is_empty():
				break
			var shout := ""
			if strategy == "shout":
				shout = "long"
			elif strategy == "right":
				shout = _best_call(f, m)
			elif strategy == "wrong":
				shout = _worst_call(f, m)
			Bouts.fight_step(c, f, m, "shout:" + shout)
	Bouts.fight_step(c, f, m, "end")
	return m


func _best_call(f: Dictionary, m: Dictionary) -> String:
	if LiveRound.live(m).is_empty():
		return ""
	var p := LiveRound.preview(f, m)
	return str(p.get("coach", ""))


func _worst_call(f: Dictionary, m: Dictionary) -> String:
	if LiveRound.live(m).is_empty():
		return ""
	var p := LiveRound.preview(f, m)
	var sit := str(p.get("sit", ""))
	var mode: Dictionary = Exchanges.MODES.get(sit, {})
	return str(mode.get("wrong", "calm"))


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
