extends SceneTree
## Blind contract test for STEPVALUE1 ropes count (ops/research/TASK_ROPESCONTRACT1.md).
## Written from the contract, StepEffect data table, and module header comments only.

const StepWire := preload("res://scripts/state/StepWire.gd")
const StepEffect := preload("res://scripts/rules/StepEffect.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures: int = 0


func _initialize() -> void:
	_test_times_and_constant()
	_test_unplanned_and_non_steps()
	_test_step_back_and_clears()
	_test_six_step_backs()
	_test_opp_ropes_and_priority()
	_test_live_round_close_and_reset()
	_test_corner_card()
	_test_fight_why()
	if failures == 0:
		print("ROPES_CONTRACT PASS fails=0")
	else:
		print("ROPES_CONTRACT FAIL fails=%d" % [failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("ok  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _test_times_and_constant() -> void:
	_check(StepEffect.ROPES_AT == 3, "StepEffect.ROPES_AT is 3")
	_check(StepWire.times({}) == 0, "StepWire.times({}) returns 0 when absent")
	_check(StepWire.times({"ropes_times": 4}) == 4, "StepWire.times reads lv[ropes_times]")


func _test_unplanned_and_non_steps() -> void:
	var lv: Dictionary = {}
	var rec: Dictionary = {}
	StepWire.after(lv, rec, "step_back", false)
	_check(int(lv.get("ropes", 0)) == 0, "unplanned step_back leaves lv[ropes] at 0")
	_check(rec.has("ropes_put") and str(rec["ropes_put"]) == "", "unplanned step_back sets rec[ropes_put] to empty")

	# Three step_backs with middle one unplanned -> count 2, not on ropes.
	lv = {}
	var r1: Dictionary = {}
	var r2: Dictionary = {}
	var r3: Dictionary = {}
	StepWire.after(lv, r1, "step_back", true)
	StepWire.after(lv, r2, "step_back", false)
	StepWire.after(lv, r3, "step_back", true)
	_check(int(lv.get("ropes", 0)) == 2 and str(lv.get("at", "")) != "own_ropes",
		"three step_backs with middle unplanned stays at 2 and not on own_ropes")
	_check(StepWire.times(lv) == 0 and str(r3.get("ropes_put", "x")) == "",
		"three step_backs with middle unplanned leaves times=0 and ropes_put empty")

	# Unplanned clears and opponent steps must not touch counts.
	lv = {"ropes": 2, "opp_ropes": 2}
	var rc: Dictionary = {"ropes_put": "stale"}
	StepWire.after(lv, rc, "pivot_out", false)
	_check(int(lv["ropes"]) == 2 and str(rc.get("ropes_put", "x")) == "",
		"unplanned pivot_out does not clear ropes and resets rec[ropes_put]")
	StepWire.after(lv, rc, "step_out", false)
	_check(int(lv["ropes"]) == 2 and str(rc.get("ropes_put", "x")) == "",
		"unplanned step_out does not clear ropes")
	StepWire.after(lv, rc, "cut_off", false)
	StepWire.after(lv, rc, "herd", false)
	_check(int(lv["opp_ropes"]) == 2 and str(lv.get("at", "")) != "opp_ropes",
		"unplanned cut_off/herd does not increment opp_ropes")

	# Non-step arrows (punch, combo, empty) and non-ropes steps change no count.
	lv = {"ropes": 2, "opp_ropes": 2}
	var non_steps: Array = ["jab", "cross", "1-2", "1-2-3", "slip 2-3", "", "step_in", "feint", "tie_up", "roll_out", "push_off"]
	var counts_ok: bool = true
	var put_ok: bool = true
	for move_id in non_steps:
		var arrow: String = str(move_id)
		var r_non: Dictionary = {"ropes_put": "stale"}
		StepWire.after(lv, r_non, arrow, true)
		if int(lv["ropes"]) != 2 or int(lv["opp_ropes"]) != 2 or StepWire.times(lv) != 0:
			counts_ok = false
		if not r_non.has("ropes_put") or str(r_non["ropes_put"]) != "":
			put_ok = false
	_check(counts_ok, "non-step arrows and non-ropes steps change no ropes count")
	_check(put_ok, "non-step arrows and non-ropes steps set rec[ropes_put] to empty")


func _test_step_back_and_clears() -> void:
	# Two step_backs, pivot_out, two step_backs -> never on the ropes; opp_ropes untouched.
	var lv: Dictionary = {"opp_ropes": 1}
	var r1: Dictionary = {}
	var r2: Dictionary = {}
	var r3: Dictionary = {}
	var r4: Dictionary = {}
	var r5: Dictionary = {}
	StepWire.after(lv, r1, "step_back", true)
	StepWire.after(lv, r2, "step_back", true)
	_check(int(lv.get("ropes", 0)) == 2 and str(r2.get("ropes_put", "x")) == "",
		"two planned step_backs bring lv[ropes] to 2")
	StepWire.after(lv, r3, "pivot_out", true)
	_check(int(lv.get("ropes", -1)) == 0 and int(lv.get("opp_ropes", 0)) == 1 and str(r3.get("ropes_put", "x")) == "",
		"planned pivot_out clears lv[ropes] to 0 without touching opp_ropes")
	StepWire.after(lv, r4, "step_back", true)
	StepWire.after(lv, r5, "step_back", true)
	_check(int(lv.get("ropes", 0)) == 2 and str(lv.get("at", "")) != "own_ropes" and StepWire.times(lv) == 0,
		"two step_backs after pivot_out stay at 2 and never put boxer on ropes")

	# Same clearing behavior for step_out.
	var lv_so: Dictionary = {}
	var rs: Dictionary = {}
	StepWire.after(lv_so, rs, "step_back", true)
	StepWire.after(lv_so, rs, "step_back", true)
	StepWire.after(lv_so, rs, "step_out", true)
	_check(int(lv_so.get("ropes", -1)) == 0 and str(rs.get("ropes_put", "x")) == "",
		"planned step_out clears lv[ropes] to 0")
	StepWire.after(lv_so, rs, "step_back", true)
	StepWire.after(lv_so, rs, "step_back", true)
	_check(int(lv_so.get("ropes", 0)) == 2 and str(lv_so.get("at", "")) != "own_ropes" and StepWire.times(lv_so) == 0,
		"two step_backs after step_out stay at 2 and never put boxer on ropes")


func _test_six_step_backs() -> void:
	var lv: Dictionary = {}
	var puts: Array = []
	for i in range(6):
		var rec: Dictionary = {}
		StepWire.after(lv, rec, "step_back", true)
		puts.append(str(rec.get("ropes_put", "missing")))
		if i == 2:
			_check(str(lv.get("at", "")) == "own_ropes" and int(lv.get("ropes", -1)) == 0,
				"3rd planned step_back sets at=own_ropes and resets ropes to 0")
			_check(StepWire.times(lv) == 1 and str(rec.get("ropes_put", "")) == "own",
				"3rd planned step_back sets ropes_times=1 and ropes_put=own")
		elif i == 3:
			_check(int(lv.get("ropes", 0)) == 1 and StepWire.times(lv) == 1 and str(rec.get("ropes_put", "x")) == "",
				"4th planned step_back starts new count at 1 with ropes_put empty")
	_check(str(lv.get("at", "")) == "own_ropes" and int(lv.get("ropes", -1)) == 0,
		"6th planned step_back sets at=own_ropes and resets ropes to 0")
	_check(int(lv.get("ropes_times", 0)) == 2 and StepWire.times(lv) == 2,
		"6 planned step_backs produce ropes_times=2")
	_check(", ".join(PackedStringArray(puts)) == ", , own, , , own",
		"6 planned step_backs emit ropes_put sequence ['', '', 'own', '', '', 'own']")


func _test_opp_ropes_and_priority() -> void:
	var lv: Dictionary = {}
	var r1: Dictionary = {}
	var r2: Dictionary = {}
	var r3: Dictionary = {}
	StepWire.after(lv, r1, "cut_off", true)
	_check(int(lv.get("opp_ropes", 0)) == 1 and int(lv.get("ropes", 0)) == 0 and str(r1.get("ropes_put", "x")) == "",
		"planned cut_off adds 1 to opp_ropes")
	StepWire.after(lv, r2, "herd", true)
	_check(int(lv.get("opp_ropes", 0)) == 2 and str(r2.get("ropes_put", "x")) == "",
		"planned herd adds 1 to opp_ropes")
	StepWire.after(lv, r3, "cut_off", true)
	_check(str(lv.get("at", "")) == "opp_ropes" and int(lv.get("opp_ropes", -1)) == 0,
		"3rd opp step sets at=opp_ropes and resets opp_ropes to 0")
	_check(str(r3.get("ropes_put", "")) == "opp" and StepWire.times(lv) == 0 and int(lv.get("ropes_times", 0)) == 0,
		"3rd opp step sets ropes_put=opp and leaves ropes_times at 0")

	# Three herds in a row also trigger opp_ropes.
	var lv_h: Dictionary = {}
	var rh: Dictionary = {}
	for _i in range(3):
		StepWire.after(lv_h, rh, "herd", true)
	_check(str(lv_h.get("at", "")) == "opp_ropes" and int(lv_h.get("opp_ropes", -1)) == 0 and str(rh.get("ropes_put", "")) == "opp" and StepWire.times(lv_h) == 0,
		"3 planned herds put opponent on opp_ropes with ropes_times=0")

	# Own count is checked before opponent's.
	var lv_both: Dictionary = {"ropes": 2, "opp_ropes": 3}
	var rb: Dictionary = {}
	StepWire.after(lv_both, rb, "step_back", true)
	_check(str(lv_both.get("at", "")) == "own_ropes" and str(rb.get("ropes_put", "")) == "own",
		"own ropes check takes priority over opp_ropes when both are >= 3")
	_check(int(lv_both.get("ropes", -1)) == 0 and int(lv_both.get("ropes_times", 0)) == 1 and int(lv_both.get("opp_ropes", 0)) == 3,
		"own priority resets ropes and increments ropes_times while leaving opp_ropes=3")


func _test_live_round_close_and_reset() -> void:
	# Hand-built closed rounds carry ropes = ropes_times.
	var f_min0: Dictionary = {"bout": {}}
	var m_min0: Dictionary = {"live": {"n": 1, "ex": [], "e": {}, "cost": 0.0, "plan": ""}}
	var c0: Dictionary = LiveRound.close(f_min0, m_min0)
	_check(c0.has("ropes") and int(c0["ropes"]) == 0, "LiveRound.close carries ropes=0 when ropes_times absent")

	var f_min2: Dictionary = {"bout": {}}
	var m_min2: Dictionary = {"live": {"n": 1, "ex": [], "e": {}, "cost": 0.0, "plan": "", "ropes_times": 2}}
	var c2: Dictionary = LiveRound.close(f_min2, m_min2)
	_check(int(c2.get("ropes", -1)) == 2, "LiveRound.close carries ropes=2 from lv[ropes_times]")

	# Real round open -> 3 step_backs -> close -> open round 2 resets counts.
	var career: Career = Career.quick_start()
	career.day = 30
	var fighter: Dictionary = Data.fighter_state(Data.lucy(), career.day)
	fighter["weight"] = float(fighter["limit"])
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	fighter["bout"] = {"opp": opp, "day": career.day, "weighed": true, "made": true, "done": false, "film": 1}
	career.fighters = [fighter]
	var energy: Dictionary = {"bonus": 0.0, "a": 100.0, "b": 100.0}
	var match_state: Dictionary = {"fid": fighter["id"]}

	LiveRound.open(career, fighter, match_state, 1, "", energy)
	var lv1: Dictionary = match_state["live"]
	var rec: Dictionary = {}
	for _i in range(3):
		StepWire.after(lv1, rec, "step_back", true)
	var closed1: Dictionary = LiveRound.close(fighter, match_state)
	_check(int(closed1.get("ropes", -1)) == 1, "round 1 close carries ropes=1 after 3 step_backs")

	LiveRound.open(career, fighter, match_state, 2, "", energy)
	var lv2: Dictionary = match_state["live"]
	_check(StepWire.times(lv2) == 0 and int(lv2.get("ropes", 0)) == 0,
		"round 2 LiveRound.open resets ropes and ropes_times to 0")
	var closed2: Dictionary = LiveRound.close(fighter, match_state)
	_check(int(closed2.get("ropes", -1)) == 0, "round 2 close carries ropes=0")


func _test_corner_card() -> void:
	var summary: Dictionary = CornerCard.summarize([])
	var names: Array = ["Lucy", "Maria"]
	var card0: Dictionary = CornerCard.card(summary, 80.0, names, 0)
	var card1: Dictionary = CornerCard.card(summary, 80.0, names, 1)
	var card2: Dictionary = CornerCard.card(summary, 80.0, names, 2)
	var card3: Dictionary = CornerCard.card(summary, 80.0, names, 3)

	_check(not str(card0["hurt"]).to_lower().contains("ropes"), "CornerCard ropes=0 hurt has no 'ropes'")
	_check(str(card1["hurt"]).contains("Put on the ropes once"), "CornerCard ropes=1 hurt says 'Put on the ropes once'")
	_check(str(card2["hurt"]).contains("Put on the ropes 2 times"), "CornerCard ropes=2 hurt says 'Put on the ropes 2 times'")
	_check(str(card3["hurt"]).contains("Put on the ropes 3 times"), "CornerCard ropes=3 hurt says 'Put on the ropes 3 times'")
	_check(str(card1["call"]) == str(card0["call"]) and str(card1["why"]) == str(card0["why"]),
		"CornerCard ropes=1 preserves call and why")
	_check(str(card2["call"]) == str(card0["call"]) and str(card2["why"]) == str(card0["why"]),
		"CornerCard ropes=2 preserves call and why")
	_check(str(card3["call"]) == str(card0["call"]) and str(card3["why"]) == str(card0["why"]),
		"CornerCard ropes=3 preserves call and why")


func _round_ropes(n: int) -> Dictionary:
	return {"exchanges": [{"won": false}], "won": false, "ropes": n}


func _test_fight_why() -> void:
	var why_absent: Dictionary = FightWhy.read([{"exchanges": [{"won": false}], "won": false}], "Lucy", "Maria")
	var why0: Dictionary = FightWhy.read([_round_ropes(0), _round_ropes(0)], "Lucy", "Maria")
	var why1: Dictionary = FightWhy.read([_round_ropes(0), _round_ropes(1)], "Lucy", "Maria")
	var why2: Dictionary = FightWhy.read([_round_ropes(2)], "Lucy", "Maria")
	var why3: Dictionary = FightWhy.read([_round_ropes(1), _round_ropes(2)], "Lucy", "Maria")

	_check(not str(why_absent["against"]).to_lower().contains("ropes"),
		"FightWhy absent ropes has no 'ropes' in against")
	_check(not str(why0["against"]).to_lower().contains("ropes"),
		"FightWhy sum=0 has no 'ropes' in against")
	var a1: String = str(why1["against"])
	_check(a1.ends_with("On the ropes once with no way off."),
		"FightWhy sum=1 against ends with 'On the ropes once with no way off.'")
	_check(not a1.contains("Lucy") and not a1.contains("Maria"),
		"FightWhy sum=1 against names nobody")
	var a2: String = str(why2["against"])
	_check(a2.ends_with("On the ropes 2 times with no way off."),
		"FightWhy sum=2 against ends with 'On the ropes 2 times with no way off.'")
	var a3: String = str(why3["against"])
	_check(a3.ends_with("On the ropes 3 times with no way off."),
		"FightWhy sum=3 across rounds against ends with 'On the ropes 3 times with no way off.'")
	_check(not a3.contains("Lucy") and not a3.contains("Maria"),
		"FightWhy sum=3 against names nobody")
