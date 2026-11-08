extends SceneTree
## S406 ONE CHANGE: what is offered, what each change moves and costs, and that Leave it changes nothing.

const A := preload("res://scripts/rules/Adaptation.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

var failures := 0


func _initialize() -> void:
	_offers()
	_shots()
	_words()
	_bout()
	print("ADAPTATION failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _round(head: int, body: int) -> Array:
	return [{"landed": [10, head + body], "body": [0, body]}]


func _ids(o: Array) -> Array:
	return o.map(func(x): return str(x["id"]))


func _offers() -> void:
	_check(_ids(A.offers(_round(14, 7), 1.0, "")) == [A.ELBOWS, A.GLOVES], "a heavy round offers both")
	_check(_ids(A.offers(_round(14, 3), 1.0, "")) == [A.GLOVES], "3 to the body offers no Elbows in")
	_check(_ids(A.offers(_round(9, 2), 1.0, "")).is_empty(), "a quiet round offers nothing")
	var one: Dictionary = A.offers(_round(14, 8), 1.0, "")[0]
	_check(str(one["key"]) == "adapt:elbows" and str(one["small"]) == "4 fewer body, 4 more head, +5 energy", "the button's numbers: " + str(one["small"]))
	var twice: Dictionary = A.offers(_round(14, 8), 1.0, A.ELBOWS)[0]
	_check(str(twice["small"]).begins_with("3 fewer"), "asked twice running it promises less: " + str(twice["small"]))
	_check(str(A.offers(_round(14, 8), 0.5, "")[0]["small"]).begins_with("2 fewer"), "a boxer who half listens moves half")


func _shots() -> void:
	var m := {}
	var lv := {"adapt": {"id": "", "hold": 1.0, "moved": 0}}
	_check(A.body_shots(lv, m, 10, 0.2, 0.4) == Exchanges.body_shots(10, 0.2, 0.4) and m.is_empty(), "no change: the same punches, no damage")
	var lv0 := {}
	_check(A.body_shots(lv0, m, 10, 0.2, 0.4) == Exchanges.body_shots(10, 0.2, 0.4), "a round from an old save plays as before")
	var me := {}
	var le := {"adapt": {"id": A.ELBOWS, "hold": 1.0, "moved": 0}}
	var e := A.body_shots(le, me, 10, 0.4, 0.5)
	_check(e == Exchanges.body_shots(10, 0.2, 0.5) and e < Exchanges.body_shots(10, 0.4, 0.5), "Elbows in: fewer to the body (%d)" % e)
	_check(int(le["adapt"]["moved"]) == 2 and is_equal_approx(float(me["damage"]["a"]), 2.0 * A.HEAD_DAMAGE), "Elbows in: the moved punches add head damage")
	var mg := {"damage": {"a": 10.0, "b": 0.0}}
	var lg := {"adapt": {"id": A.GLOVES, "hold": 1.0, "moved": 0}}
	var g := A.body_shots(lg, mg, 10, 0.2, 0.5)
	_check(g > Exchanges.body_shots(10, 0.2, 0.5) and float(mg["damage"]["a"]) < 10.0, "Gloves high: more to the body, head damage comes off")
	var mz := {"damage": {"a": 0.5, "b": 0.0}}
	A.body_shots({"adapt": {"id": A.GLOVES, "hold": 1.0, "moved": 0}}, mz, 10, 0.2, 0.5)
	_check(float(mz["damage"]["a"]) == 0.0, "head damage never goes under nothing")
	var bout := {}
	_check(is_equal_approx(float(A.start(bout, A.ELBOWS, 0.8)["hold"]), 0.8), "first time: the boxer's own hold")
	_check(is_equal_approx(float(A.start(bout, A.ELBOWS, 0.8)["hold"]), 0.8 * A.REPEAT_HOLD), "second round running holds less")
	_check(is_equal_approx(float(A.start(bout, A.GLOVES, 0.8)["hold"]), 0.8), "a different change is new again")


func _words() -> void:
	_check(A.suffix("") == "" and A.suffix("adapt:gloves") == "|adapt=gloves" and A.suffix("wide_hook_tell") == "|fix=wide_hook_tell", "the corner action's part")
	_check(A.result({}) == "" and A.result({"id": "", "moved": 0}) == "", "no change, no line")
	_check(A.result({"id": A.ELBOWS, "moved": 3}).contains("3 fewer to the body"), "the next card says what it did")
	_check(A.result({"id": A.GLOVES, "moved": 0}).contains("no difference"), "and says so when it did nothing")


## Through the game's own corner action. Lucy (Data.lucy) against Priya (OPPONENTS[1]).
func _bout() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["notes_seen"] = []
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	opp["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "")
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")
	var r1: Dictionary = (m["rounds"] as Array)[0]
	_check(str((r1.get("adapt", {}) as Dictionary).get("id", "")) == "", "round 1 has no change")
	Bouts.fight_step(c, f, m, "corner:long|adapt=gloves")
	_check(str((LiveRound.live(m).get("adapt", {}) as Dictionary).get("id", "")) == A.GLOVES, "the corner action opens the round on the change")
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")
	var r2: Dictionary = (m["rounds"] as Array)[1]
	_check(str((r2.get("adapt", {}) as Dictionary).get("id", "")) == A.GLOVES, "the round records it")
	if Bouts.stopped(m) == "":
		Bouts.fight_step(c, f, m, "corner:long")
		_check(str((LiveRound.live(m).get("adapt", {}) as Dictionary).get("id", "")) == "", "it lasts one round")


func _check(ok: bool, what: String) -> void:
	print("  %s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1
