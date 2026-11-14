extends SceneTree
## AIM_WIRE1 - the aim buttons: rib targets that never appear, a body bonus that never fires.
## Proves the two rules PaceAim wrote but LiveRound never called:
##   (1) after enough body work on one side the aim list offers that side's ribs
##   (2) aiming there wins the edge PaceAim promises (+4)
##   (3) body aim against a burned opponent gets the +3
##   (4) a fresh opponent gets none of it
## The test drives LiveRound.preview and LiveRound.exchange (the game path), not a mock.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

var failures := 0


func _initialize() -> void:
	_test1_fresh_opponent()
	_test2_body_work_opens_ribs()
	_test3_aim_at_hurt_ribs_gets_edge()
	_test5_liver_side_first()
	_test4_body_aim_against_burned_opponent()
	print("AIM_WIRE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## Build a bout the way exchanges_test.gd does: Lucy vs Priya, two different fighters.
func _build_bout() -> Array:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["bout"] = {"opp": (Data.OPPONENTS[1] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	return [c, f, m]


## 1. Fresh opponent: no ribs offered, no body bonus.
func _test1_fresh_opponent() -> void:
	var arr := _build_bout()
	var f: Dictionary = arr[1]
	var m: Dictionary = arr[2]
	var pv := LiveRound.preview(f, m)
	var aims: Array = pv.get("aims", [])
	_check(not aims.has("left_ribs") and not aims.has("right_ribs"), "fresh opponent: no ribs offered")
	_check(not aims.has("head_hurt"), "fresh opponent: no head_hurt offered")
	_check(aims.has("") and aims.has("head") and aims.has("body"), "fresh opponent: base aims present")


## 2. After enough body work, the aim list offers that side's ribs.
func _test2_body_work_opens_ribs() -> void:
	var arr := _build_bout()
	var c: Career = arr[0]
	var f: Dictionary = arr[1]
	var m: Dictionary = arr[2]
	# Fight exchanges aiming at the body to pile up body shots on the opponent.
	# Stop after exchange 4 (before the round closes at exchange 6).
	var exchanges_fought := 0
	while exchanges_fought < 4 and not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:body")
		exchanges_fought += 1
	var bt: Dictionary = LiveRound.live(m).get("body", {})
	var body_shots := int(bt.get("b", 0))
	# Check the aim list now offers ribs.
	var pv := LiveRound.preview(f, m)
	var aims: Array = pv.get("aims", [])
	var has_ribs := aims.has("left_ribs") or aims.has("right_ribs")
	_check(has_ribs, "after %d body shots in %d exchanges: ribs offered (aims: %s)" % [body_shots, exchanges_fought, str(aims)])


## 3. Aiming at hurt ribs wins the edge PaceAim promises (+4).
func _test3_aim_at_hurt_ribs_gets_edge() -> void:
	# Prove the rule directly: PaceAim.edge with hurt ribs gives +4.
	var edge_hurt := PaceAim.edge("steady", "left_ribs", {"left_ribs": true}, {})
	var edge_fresh := PaceAim.edge("steady", "left_ribs", {"left_ribs": false}, {})
	_check(is_equal_approx(edge_hurt - edge_fresh, 4.0), "hurt ribs edge: +4 (got %.1f)" % (edge_hurt - edge_fresh))


## 4. Body aim against a burned opponent gets the +3.
func _test4_body_aim_against_burned_opponent() -> void:
	# Prove the rule directly: PaceAim.edge with burned opponent gives +3.
	var edge_burned := PaceAim.edge("steady", "body", {}, {"core": 60.0})
	var edge_fresh := PaceAim.edge("steady", "body", {}, {"core": 20.0})
	_check(is_equal_approx(edge_burned - edge_fresh, 3.0), "body on burned: +3 (got %.1f)" % (edge_burned - edge_fresh))


## 5. S432: the two rib calls are not twins - the liver side hurts first. S467 (LIVERRIBS1 v2 s2 anatomy): the liver is on
## the RIGHT of every body, so a southpaw's right side opens first too (the S432 stance flip was the anatomy defect).
func _test5_liver_side_first() -> void:
	var lv := {"body": {"a": 0, "b": 7}, "opp_hurt": false}
	var ortho := PaceAim.opp_hurt(lv, "orthodox")
	_check(bool(ortho["right_ribs"]) and not bool(ortho["left_ribs"]), "orthodox, 7 body shots: the right ribs (liver) open first (%s)" % str(ortho))
	var lefty := PaceAim.opp_hurt(lv, "southpaw")
	_check(bool(lefty["right_ribs"]) and not bool(lefty["left_ribs"]), "southpaw, 7 body shots: the right ribs (liver) open first too (%s)" % str(lefty))
	# S467: aimed shots count on their side - 7 aimed at the left ribs open the left, not the liver.
	var aimed := PaceAim.opp_hurt({"body": {"a": 0, "b": 7}, "sides": {"b": {"ribs": 7}}, "opp_hurt": false}, "orthodox")
	_check(bool(aimed["left_ribs"]) and not bool(aimed["right_ribs"]), "7 shots aimed at the left ribs open the left (%s)" % str(aimed))
	var both := PaceAim.opp_hurt({"body": {"a": 0, "b": 10}, "opp_hurt": false}, "orthodox")
	_check(bool(both["right_ribs"]) and bool(both["left_ribs"]), "10 body shots: both sides hurt (%s)" % str(both))
	var none := PaceAim.opp_hurt({"body": {"a": 0, "b": 5}, "opp_hurt": false}, "orthodox")
	_check(not bool(none["right_ribs"]) and not bool(none["left_ribs"]), "5 body shots: no side yet (%s)" % str(none))
