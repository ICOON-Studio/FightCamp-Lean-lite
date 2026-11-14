extends SceneTree
## S460 INTEGRATE1 #3: PlanPhase reaches the game. A plan line tagged early / middle / late is fought only in those rounds
## (the ring: LiveRound picks from PlanFile.arrows_for), the last round opens on the "If ahead" / "If behind" pace, and the
## forecast picks the same lines (BoutRead). Each ring check has a control arm that cannot share the bug: the same plan untagged.
##   1. PlanFile.arrows_for: an untagged line lives all bout, a late line only in round 3; a late state adds its lines.
##   2. PlanFile.pace_for: the late state's pace wins in round 3 by the rounds won so far; never in rounds 1-2.
##   3. The ring: the plan tagged "late" fires no planned exchange in rounds 1-2 and some in round 3; untagged it fires in round 1.
##   4. The Plan screen's pieces: the rounds pill cycles all -> early -> middle -> late -> all; the words match the split.

const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const PlanPhase := preload("res://scripts/rules/PlanPhase.gd")
const GamePlanRows := preload("res://scripts/ui/GamePlanRows.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")

const PLAN := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BOUTS := 6

var failures := 0


func _initialize() -> void:
	_lines()
	_pace()
	_ring()
	_pill()
	print("PHASE_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _lines() -> void:
	var arrows := [{"move": "1-1"}, {"move": "step_back", "rounds": "late"}]
	var r1 := PlanFile.arrows_for(arrows, {}, 1, 3)
	var r3 := PlanFile.arrows_for(arrows, {}, 3, 3)
	_check(r1.size() == 1 and str(r1[0]["move"]) == "1-1", "1 round 1: only the untagged line (%s)" % str(r1))
	_check(r3.size() == 2, "1 round 3: both lines (%s)" % str(r3))
	var late := {"ahead": {"arrows": [{"move": "pivot_out"}]}, "behind": {"arrows": [{"move": "tie_up"}]}}
	var ahead := PlanFile.arrows_for(arrows, late, 3, 3, [{"won": true}, {"won": true}])
	var behind := PlanFile.arrows_for(arrows, late, 3, 3, [{"won": true}, {"won": false}])
	_check(ahead.any(func(a): return str(a["move"]) == "pivot_out") and not ahead.any(func(a): return str(a["move"]) == "tie_up"),
		"1 two rounds up: the If ahead line joins (%s)" % str(ahead))
	_check(behind.any(func(a): return str(a["move"]) == "tie_up"), "1 level: the If behind line joins (%s)" % str(behind))


func _pace() -> void:
	var f := {"round_pace": ["push", "", "save"], "late": {"ahead": {"pace": "steady"}, "behind": {"pace": "push"}}}
	_check(PlanFile.pace_for(f, 1, []) == "push", "2 round 1 keeps its own pace")
	_check(PlanFile.pace_for(f, 3, [{"won": true}, {"won": true}]) == "steady", "2 round 3 two up: If ahead's steady (not the row's save)")
	_check(PlanFile.pace_for(f, 3, [{"won": false}, {"won": false}]) == "push", "2 round 3 two down: If behind's push")
	_check(PlanFile.pace_for({"round_pace": ["", "", "save"]}, 3, []) == "save", "2 no late state: the row's own pace")


## Planned exchanges per round over BOUTS bouts of Lucy with `arrows`.
func _planned(arrows: Array) -> Array:
	var per := [0, 0, 0]
	for k in BOUTS:
		var sc := Career.new()
		sc.day = 60000 + k * 7
		sc.seed = 460
		sc.coach = {"rating": 60.0}
		var sf: Dictionary = Data.fighter_state(Data.lucy(), sc.day)
		sf["arrows"] = arrows.duplicate(true)
		# S463 STEPMASTERY1 gate: her steps at Signature (85, always fire = before the gate) - this test is about the phase tags.
		sf["steps"] = {"step_back": 85.0, "pivot_out": 85.0, "tie_up": 85.0}
		var opp: Dictionary = (Data.OPPONENTS[k % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
		sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
		sc.fighters = [sf]
		var m: Dictionary = BoutNight.fight_modal(sf)
		BoutNight.play_out(sc, sf, m)
		var rounds: Array = m["rounds"]
		for n in mini(3, rounds.size()):
			for ex in (rounds[n] as Dictionary).get("exchanges", []):
				if (ex as Dictionary).has("plan_tally"):
					per[n] += 1
	return per


func _ring() -> void:
	var tagged: Array = PLAN.duplicate(true)
	for a in tagged:
		a["rounds"] = "late"
	var t := _planned(tagged)
	var u := _planned(PLAN.duplicate(true))
	_check(u[0] > 0, "3 control: the untagged plan fires in round 1 (%s)" % str(u))
	_check(t[0] == 0 and t[1] == 0, "3 tagged late: nothing planned in rounds 1-2 (%s)" % str(t))
	_check(t[2] > 0, "3 tagged late: the plan fires in round 3 (%s)" % str(t))


func _pill() -> void:
	var seen := ["all"]
	var w := "all"
	for k in 4:
		w = str(GamePlanRows.PHASE_NEXT[w])
		seen.append(w)
	_check(seen == ["all", "early", "middle", "late", "all"], "4 the pill cycles %s" % str(seen))
	_check(PlanPhase.words({"move": "1-1", "rounds": "late"}, 3) == "R3" and PlanPhase.words({"move": "1-1"}, 3) == "All rounds",
		"4 the pill's words: R3 / All rounds")


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		failures += 1
