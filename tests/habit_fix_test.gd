extends SceneTree
## S309 the corner's one fix for a habit (scripts/rules/HabitFix.gd, wired through LiveRound and Bouts):
##   1. a habit costs only in the situation Kalli's punish line names (drops the right -> a counter-puncher waiting);
##      slow_starter by the clock in round 1, fades_late in the last round; a habit that helps her never costs,
##   2. the fix takes the cost away as far as she takes it in (coachability), never more,
##   3. the corner offers only habits the coach has seen and that can cost her,
##   4. in the real bout: a habit she paid for goes into the coach's notebook at the bell, the corner fixes it with
##      "corner:<call>|<habit>", and next round it costs her nothing more than the slip she did not take in.
## Population: Lucy (Data.lucy) given drops_right_after_jab vs Priya (Data.OPPONENTS[1], Counter-puncher).

const H := preload("res://scripts/rules/HabitFix.gd")
const X := preload("res://scripts/rules/Exchanges.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const XB := preload("res://tools/exchange_balance.gd")

var failures := 0


func _initialize() -> void:
	# 1. Where a habit costs.
	_check(H.punished(["drops_right_after_jab"], "counter", 2, 3, false) == "drops_right_after_jab"
		and H.punished(["drops_right_after_jab"], "press", 2, 3, false) == "", "the dropped right costs against a counter-puncher only")
	_check(H.punished(["slow_starter"], "range", 1, 0, false) == "slow_starter" and H.punished(["slow_starter"], "range", 1, 2, false) == ""
		and H.punished(["slow_starter"], "range", 2, 0, false) == "", "slow starter: round 1's first minute only")
	_check(H.punished(["fades_late"], "range", 3, 4, true) == "fades_late" and H.punished(["fades_late"], "range", 3, 4, false) == ""
		and H.punished(["fades_late"], "range", 3, 1, true) == "", "fades late: the last round's second half only")
	var never := true
	for sit in X.MODES.keys():
		never = never and H.punished(["digs_body_when_hurt"], str(sit), 2, 3, true) == ""
	_check(never, "a habit that helps her (digs to the body when hurt) never costs")
	var known := true
	for id in H.PUNISHED_BY.keys():
		for sit in H.PUNISHED_BY[id]:
			known = known and X.MODES.has(sit)
	_check(known, "every punishing situation is a real one")
	# 2. The fix.
	_check(is_equal_approx(H.cost("drops_right_after_jab", "", 1.0), -H.HABIT_COST), "unfixed: the full cost")
	_check(is_equal_approx(H.cost("drops_right_after_jab", "drops_right_after_jab", 1.0), 0.0)
		and is_equal_approx(H.cost("drops_right_after_jab", "drops_right_after_jab", 0.7), -H.HABIT_COST * 0.3), "fixed: only what she did not take in")
	_check(is_equal_approx(H.cost("drops_right_after_jab", "low_lead_hand", 1.0), -H.HABIT_COST), "fixing another habit does not help this one")
	# 3. What the corner offers.
	var offers := H.offers(["drops_right_after_jab", "digs_body_when_hurt", "low_lead_hand"], ["habit:drops_right_after_jab", "habit:digs_body_when_hurt"])
	_check(offers == ["drops_right_after_jab"], "the corner offers seen habits that can cost her (%s)" % str(offers))
	# 4. The real bout.
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["habits"] = ["drops_right_after_jab"]
	f["notes_seen"] = []
	f["bout"] = {"opp": (Data.OPPONENTS[1] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")
	var r1: Dictionary = (m["rounds"] as Array)[0]
	var paid1 := int((r1.get("habits_paid", {}) as Dictionary).get("drops_right_after_jab", 0))
	var counter1 := (r1["exchanges"] as Array).filter(func(x): return str(x["sit"]) == "counter").size()
	print("  round 1: Priya waited to counter in %d of 6, the dropped right cost %d" % [counter1, paid1])
	_check(paid1 == counter1, "round 1: it cost her in every exchange Priya waited to counter")
	var lines_ok := (r1["exchanges"] as Array).all(func(x): return (str(x["habit"]) == "") == (str(x["habit_line"]) == ""))
	_check(lines_ok, "each exchange it cost her says so")
	var seen: Array = f.get("notes_seen", [])
	_check((paid1 > 0) == seen.has("habit:drops_right_after_jab"), "the coach saw the habit she paid for (%s)" % str(seen))
	var fixes := LiveRound.fixes(f, r1)
	_check(paid1 == 0 or (fixes.size() == 1 and int(fixes[0]["paid"]) == paid1), "the corner offers to fix it: %s" % str(fixes))
	f["notes_seen"] = ["habit:drops_right_after_jab"]
	Bouts.fight_step(c, f, m, "corner:lead|drops_right_after_jab")
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")
	var r2: Dictionary = (m["rounds"] as Array)[1]
	var held := (r2["exchanges"] as Array).filter(func(x): return str(x["habit"]) != "")
	_check(str(r2.get("fix", "")) == "drops_right_after_jab" and (r2.get("habits_paid", {}) as Dictionary).is_empty(), "round 2 fixed: nothing paid in full")
	_check(held.all(func(x): return str(x["habit_line"]).begins_with("The fix held")), "each time it would have cost her, the fix held (%d)" % held.size())
	_check(str(r2["corner"]) == "lead", "the plan still came through: %s" % r2["corner"])
	_check(not H.fixable("slow_starter") and H.fixable("fades_late"), "the corner never offers a habit that only costs before its first minute")
	# 5. Bounded, through the balance harness (400 even bouts each): fixing the habit the opponent punishes pays.
	var seen_share := XB.share(0.0, "seen", 1, ["drops_right_after_jab"])
	var fix_share := XB.share(0.0, "fix", 1, ["drops_right_after_jab"])
	print("  Lucy who drops the right vs Priya, even: the read %.2f, the read + the fix %.2f" % [seen_share, fix_share])
	_check(fix_share >= seen_share + 0.03, "fixing the punished habit wins more than the read alone")
	print("HABIT_FIX failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
