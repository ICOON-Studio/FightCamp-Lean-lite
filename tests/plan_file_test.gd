extends SceneTree
## S375 SCOUTPLAN1: the plan board reads the opponent's file (PlanFile.rows), the ROUND row opens each round on its pace,
## a round-1 push catches a slow starter cold, and the ring counts each planned arrow over the bout (plan_tally).
## Population: a counter-puncher whose best weapon is "Right hand over the jab" and whose weakness is "Slow to start"
## (two tells that land on different situations), against Lucy (Data.lucy) with the starter plan.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")

var failures := 0


func _initialize() -> void:
	var opp := {"first": "Priya", "style": "Counter-puncher", "threat": "Right hand over the jab", "weak": "Slow to start",
		"w": 6, "l": 1, "stance": "orthodox"}
	var mastery := {"Jab": 60.0, "Cross": 60.0, "Lead hook": 50.0, "Body hook": 45.0, "Uppercut": 40.0}
	var combos := {"1-1": 50.0, "1-2": 50.0}
	var plan := PlanFight.starter()

	# a. Before the tape: the game is free, the weapon and weakness are locked.
	var rows := _by_id(PlanFile.rows(opp, plan, mastery, combos))
	_check(bool(rows["style"]["known"]) and str(rows["style"]["sit"]) == "counter" and is_equal_approx(float(rows["style"]["share"]), 0.55),
		"the game is free: counter, 55%% of her exchanges (got %s %s)" % [rows["style"]["sit"], rows["style"]["share"]])
	_check(not bool(rows["weapon"]["known"]) and not bool(rows["weakness"]["known"]), "weapon and weakness locked before the tape")
	_check(str(rows["weapon"]["value"]) == "?" and str(rows["weakness"]["value"]) == "?", "a locked tell never shows its answer")
	_check(PlanFile.round_hints(opp).is_empty(), "no round hint before the tape finds the weakness")

	# b. The tape opens both: the weapon is her counter game at long range, the starter's 1-2 there only works.
	OppFile.open(opp, "weapon")
	OppFile.open(opp, "weakness")
	rows = _by_id(PlanFile.rows(opp, plan, mastery, combos))
	var w: Dictionary = rows["weapon"]
	_check(str(w["sit"]) == "counter" and str(w["place"]) == "long" and str(w["move"]) == "1-2" and str(w["fit"]) == "ok",
		"weapon -> counter game at long range, 1-2 fires and Works (got %s %s %s %s)" % [w["sit"], w["place"], w["move"], w["fit"]])
	_check(str(w["best"]) != "" and PlanFight.fit(str(w["best"]), "counter") == "best" and float(w["best_edge"]) > float(w["edge"]),
		"a better answer is named: %s %+.1f over %+.1f" % [w["best"], float(w["best_edge"]), float(w["edge"])])
	_check(str(w["say"]).contains("better"), "the coach's line names the better answer: %s" % w["say"])
	var k: Dictionary = rows["weakness"]
	_check(int(k["round"]) == 1 and str(k["sit"]) == "counter", "slow to start -> round 1's counter exchanges")

	# c. Answering it: the better move as a "When she waits to counter" line now fires and Beats it.
	var plan2 := PlanLines.set_line(plan, str(w["place"]), "counter", str(w["best"]))
	var w2: Dictionary = _by_id(PlanFile.rows(opp, plan2, mastery, combos))["weapon"]
	_check(str(w2["move"]) == str(w["best"]) and str(w2["when"]) == "counter" and str(w2["fit"]) == "best",
		"answered: the When line fires and beats it (got %s %s %s)" % [w2["move"], w2["when"], w2["fit"]])

	# c2. A habit the weakness names is one row (Maria-like: "Fades after round 2" gives the habit fades_late too).
	var fader := {"first": "Maria", "style": "Pressure fighter", "threat": "Left hook to the body", "weak": "Fades after round 2"}
	for id in OppFile.hidden(fader):
		OppFile.open(fader, str(id))
	var fr := _by_id(PlanFile.rows(fader, plan, mastery, combos))
	_check(fr.has("weakness") and str(fr["weakness"]["sit"]) == "tiring" and int(fr["weakness"]["round"]) == 3 and not fr.has("habit:fades_late")
		and fr.has("habit:digs_body_when_hurt"), "fades late: one row (the weakness), the other habit kept (got %s)" % str(fr.keys()))

	# d. The round row and the cold edge.
	var hints := PlanFile.round_hints(opp)
	_check(hints.has(1) and str(hints[1][0]) == "push", "the file says: push round 1")
	_check(is_equal_approx(PlanFile.cold_edge(opp, "push", 1, 0), PlanFile.COLD_EDGE) and PlanFile.cold_edge(opp, "steady", 1, 0) == 0.0
		and PlanFile.cold_edge(opp, "push", 1, PlanFile.COLD_EXCHANGES) == 0.0 and PlanFile.cold_edge(opp, "push", 2, 0) == 0.0
		and PlanFile.cold_edge({"weak": "Fades after round 2"}, "push", 1, 0) == 0.0, "cold edge: a push in round 1's first minute vs a slow starter only")
	var rp := PlanFile.set_pace([], 1, "push")
	_check(rp == ["push"] and PlanFile.pace_for({"round_pace": rp}, 1) == "push" and PlanFile.pace_for({"round_pace": rp}, 2) == "",
		"set_pace: round 1 push, round 2 unset")
	_check(PlanFile.set_pace(["push", "", "save"], 3, "") == ["push"] and PlanFile.set_pace([], 3, "save") == ["", "", "save"],
		"set_pace trims and pads")

	# e. A real bout: round 1 opens on the plan's push, round 2 (unset) on steady, the tally counts the planned arrows.
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 30
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = combos.duplicate()
	f["arrows"] = plan2.duplicate(true)
	f["round_pace"] = ["push", "", "save"]
	f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	_check(str(LiveRound.live(m).get("pace", "")) == "push", "round 1 opens on the plan's push")
	var paces: Array = []
	var planned := 0
	var last_tally: Array = []
	var caption := ""
	while int((m.get("rounds", []) as Array).size()) < 3 and not bool(f["bout"].get("done", false)):
		var lv := LiveRound.live(m)
		if lv.is_empty():
			Bouts.fight_step(c, f, m, "corner:")
			continue
		Bouts.fight_step(c, f, m, "shout:")
	for r in m.get("rounds", []):
		if not (r["exchanges"] as Array).is_empty():
			paces.append(str((r["exchanges"] as Array)[0].get("pace", "")))
		for x in r["exchanges"]:
			if bool(x.get("planned", false)):
				planned += 1
				last_tally = x.get("plan_tally", [])
				caption = ExchangeBeats.plan_tally_caption(x)
	_check(paces.size() >= 3 and paces[0] == "push" and paces[1] == "steady" and paces[2] == "save",
		"round paces push / steady (unset) / save (got %s)" % str(paces))
	_check(planned > 0 and last_tally.size() == 2 and int(last_tally[1]) >= 1 and int(last_tally[0]) <= int(last_tally[1]),
		"%d planned exchanges, the last tally %s" % [planned, str(last_tally)])
	_check(caption.begins_with("PLAN: ") and caption.contains("/%d won)" % int(last_tally[1])), "the ring's caption: %s" % caption)
	var total_thrown := 0
	for a in (f["bout"].get("plan_tally", {}) as Dictionary).values():
		total_thrown += int(a[1])
	_check(total_thrown == planned, "the bout's tally counts every planned exchange (%d = %d)" % [total_thrown, planned])
	print("PLAN_FILE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _by_id(rows: Array) -> Dictionary:
	var out := {}
	for r in rows:
		out[str(r["id"])] = r
	return out


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
