extends SceneTree
## S533 P4PBUILD1 stage 2, THE CORNER'S EYE (DESIGN_THREEP4P_V2 section 4): every exchange records the line the plan had
## and what became of it (none / not ready / held / worked / lost); the ring map marks them truthfully; hurt and tired
## show together; the corner is pointed only at controls that exist; the bout keeps one clue, watched or skipped; and
## the bout's result is IDENTICAL with the overlay read at every exchange or never (the map decides nothing).
## Population: quick-start clubs with Lucy against the region's own rivals, seeds 301-306. Prints P4P_CORNER_EYE failures=N.

const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const RingMap := preload("res://scripts/rules/RingMap.gd")
const RingTopDown := preload("res://scripts/ui/RingTopDown.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

var _fails := 0
var _looks := 0


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _initialize() -> void:
	_rules()
	_bouts()
	print("P4P_CORNER_EYE failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _x(want: String, line: String) -> Dictionary:
	return {"want": want, "line": line, "arrow": want, "planned": line in ["worked", "lost"], "won": line == "worked", "at": "own_ropes"}


func _rules() -> void:
	_check(PlanRecord.line_state("", false, false, true) == "none" and PlanRecord.line_state("pivot_out", false, false, true) == "not_ready"
		and PlanRecord.line_state("pivot_out", false, true, false) == "held" and PlanRecord.line_state("pivot_out", true, false, true) == "worked"
		and PlanRecord.line_state("pivot_out", true, false, false) == "lost", "the five states: no line, not ready, held, worked, lost")
	var unready := [{"n": 1, "exchanges": [_x("pivot_out", "not_ready"), _x("pivot_out", "not_ready"), _x("1-2", "worked")]}]
	var cu := PlanRecord.clue(unready)
	_check(cu.get("kind") == "not_ready" and cu.get("move") == "pivot_out" and int(cu["n"]) == 2, "a line that never got off twice is the clue, ahead of one that worked: %s" % str(cu))
	var lost := PlanRecord.clue([{"n": 1, "exchanges": [_x("step_back", "lost"), _x("step_back", "lost"), _x("step_back", "worked"), _x("1-2", "worked")]}])
	_check(lost.get("kind") == "lost" and int(lost["n"]) == 2 and int(lost["of"]) == 3, "a line that lost more than it won is the clue: %s" % str(lost))
	var good := PlanRecord.clue([{"n": 1, "exchanges": [_x("1-2", "worked"), _x("1-2", "worked"), _x("step_back", "held")]}])
	_check(good.get("kind") == "worked" and good.get("move") == "1-2", "else the line that worked most; a held line is not a failure")
	_check(PlanRecord.clue([{"n": 1, "exchanges": [{"arrow": "1-2", "planned": true, "won": true}]}]).is_empty()
		and PlanRecord.clue_text({}, "").begins_with("No recorded clue"), "an old bout that tracked no lines: no recorded clue, nothing made up")
	_check(PlanRecord.clue_text(cu, "pivot off the ropes").contains("never got off") and not PlanRecord.clue_text(lost, "step back").contains("%"),
		"the clue reads in words")
	_check(RingTopDown.tags_for(20.0, true, false) == ["HURT", "TIRED"] and RingTopDown.tags_for(80.0, false, true) == ["ON THE ROPES"]
		and RingTopDown.tags_for(80.0, false, false).is_empty(), "hurt and tired show together; the pinned side says so")
	_check(RingTopDown.settled_line(7, 12).contains("exchange 8") and RingTopDown.settled_line(12, 12).contains("bell"), "the view says what is settled and when the corner acts next")
	var roped := [_x("pivot_out", "not_ready")]
	_check(RingMap.hint(roped, {"at": "own_ropes", "want": "pivot_out"}, 12) == "tie" and RingMap.hint([_x("", "none")], {"at": "own_ropes", "want": ""}, 12) == "tie",
		"on the ropes with the exit missing or not ready: the existing Tie up call is pointed at")
	_check(RingMap.hint([_x("pivot_out", "worked")], {"at": "own_ropes", "want": "pivot_out"}, 12) == "", "with a ready exit nothing is suggested")
	var open := _x("1-2", "lost")
	open["at"] = "mid"
	_check(RingMap.hint([open], {"at": "mid", "want": ""}, 12) == "" and RingMap.hint([open], {}, 1) == "bell", "in the open ring nothing; at the bell the corner minute")
	var words := RingTopDown.hint_line("tie")
	_check(words.contains(str(Exchanges.CALLS["tie"]["label"])) and words.contains("say nothing") and words.contains("%+d" % -roundi(float(Exchanges.CALLS["tie"]["cost"]))),
		"the hint names the real call, its signed energy and that silence is an answer: %s" % words)
	_check(RingTopDown.hint_line("bell").contains("keep the plan") and RingTopDown.hint_line("") == "", "at the bell keeping the plan is always there")


func _club(seed_value: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_value
	c.applicant = {}
	c.first_hour = {}
	c.guide = ""
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var opp := str(AskFlow.sheet_name(c, f))
	var day := c.day + 10 + 7 * (seed_value - 300)   # the bout's dice are the fight day's: a different night per seed
	while not Region.is_show_day(day):
		day += 1
	if not AskFlow.book(c, f, "sheet", opp, day):
		return null
	c.day = day
	# A plan with a way off the ropes, its lines drilled to Usable: they come off about half the time (FireLevel), so the
	# nights show lines that worked, lost and never got off.
	var plan: Array = load("res://scripts/rules/PlanFight.gd").starter()
	if plan.filter(func(a): return str(a["move"]) == "pivot_out").is_empty():
		plan.append({"move": "pivot_out"})
	f["arrows"] = plan
	var steps: Dictionary = f.get_or_add("steps", {})
	var combos: Dictionary = f.get_or_add("combos", {})
	for a in plan:
		var mid := str(a["move"]).split("@")[0]
		steps[mid] = 45.0
		combos[mid] = 45.0
	return c


## The overlay's whole read of the open round, as the fight's bar does it; the round's record must come out untouched.
func _look(m: Dictionary) -> bool:
	var lv := LiveRound.live(m)
	var exs: Array = lv["ex"]
	var before := JSON.stringify([exs, m.get("rounds", [])])
	var st: Dictionary = LiveRound.state(lv, exs.size())
	st["next"] = {"at": str(lv.get("at", "")), "want": str(lv.get("next_want", ""))}
	st["past"] = m.get("rounds", [])
	RingMap.frame(exs, exs.size() - 1)
	RingMap.plan_mark(exs[-1])
	RingMap.next_mark(st["next"])
	RingMap.pinned(exs)
	RingMap.ghosts(st["past"])
	RingMap.hint(exs, st["next"], Exchanges.EXCHANGES)
	var view: Control = RingTopDown.make(exs, st, Exchanges.EXCHANGES)
	view.set("show_plan", _looks % 2 == 0)   # Show plan and the clean view, turn about
	view.call("set_round", exs, st)
	view.free()
	_looks += 1
	return JSON.stringify([exs, m.get("rounds", [])]) == before


## One bout, a shout bar that says nothing and a corner that keeps the plan, exchange by exchange.
func _play(seed_value: int, overlay: bool) -> Dictionary:
	var c := _club(seed_value)
	if c == null:
		return {}
	var f: Dictionary = c.fighters[0]
	var m := Bouts.fight_modal(f)
	var clean := true
	Bouts.fight_step(c, f, m, "start")
	for guard in 200:
		if not LiveRound.live(m).is_empty():
			if overlay:
				clean = _look(m) and clean
			Bouts.fight_step(c, f, m, "shout:")
		elif BoutNight.stopped(m) != "" or int(m.get("round", 0)) >= BoutNight.rounds_of(f):
			break
		else:
			Bouts.fight_step(c, f, m, "corner:")
	Bouts.fight_step(c, f, m, "end")
	return {"c": c, "f": f, "m": m, "clean": clean}


func _bouts() -> void:
	var same := 0
	var played := 0
	var states := {}
	var consistent := true
	var with_clue := 0
	for s in range(301, 307):
		var a := _play(s, false)
		var b := _play(s, true)
		if a.is_empty() or b.is_empty():
			continue
		played += 1
		var ma: Dictionary = a["m"]
		var mb: Dictionary = b["m"]
		var equal: bool = JSON.stringify(ma["rounds"]) == JSON.stringify(mb["rounds"]) and ma["outcome"] == mb["outcome"] and ma["cards"] == mb["cards"] \
			and int(a["f"]["w"]) == int(b["f"]["w"]) and int(a["f"]["l"]) == int(b["f"]["l"]) and a["c"].cash == b["c"].cash and bool(b["clean"])
		same += 1 if equal else 0
		for r in ma["rounds"]:
			for x in r["exchanges"]:
				var st := str(x.get("line", "?"))
				states[st] = int(states.get(st, 0)) + 1
				var want := str(x.get("want", "?"))
				consistent = consistent and (st == "none") == (want == "") and st in ["none", "not_ready", "held", "worked", "lost"]
				if st in ["worked", "lost"]:
					consistent = consistent and bool(x["planned"]) and str(x["arrow"]) == want and (st == "worked") == bool(x["won"])
				if st == "held":
					consistent = consistent and bool(x["held"]) and not bool(x["planned"])
				if st == "not_ready":
					consistent = consistent and not bool(x["planned"]) and not bool(x["held"])
		with_clue += 1 if str(ma.get("clue", "")) != "" and str(a["c"].results[0].get("clue", "")) == str(ma["clue"]) else 0
	print("  P4P_CORNER_EYE bouts=%d overlay_reads=%d line_states=%s" % [played, _looks, str(states)])
	_check(played >= 4 and same == played, "the same seed gives the same rounds, cards, record and cash with the overlay read at every exchange or never (%d of %d)" % [same, played])
	_check(_looks >= 40, "the overlay was read through the bouts (%d reads), plan shown and clean view both" % _looks)
	_check(consistent, "every exchange's line state agrees with what was thrown, held and won")
	_check(int(states.get("worked", 0)) + int(states.get("lost", 0)) > 0 and states.size() >= 2, "real bouts show more than one state: %s" % str(states))
	_check(with_clue == played, "every bout keeps its clue on the result and on the record (%d of %d)" % [with_clue, played])
	# A skipped bout keeps its clue the same way.
	var c := _club(311)
	if c != null:
		var f: Dictionary = c.fighters[0]
		var m := Bouts.fight_modal(f)
		Bouts.fight_step(c, f, m, "sim")
		_check(str(m.get("clue", "")) != "" and str(c.results[0].get("clue", "")) == str(m["clue"]), "a skipped bout keeps its clue: %s" % str(m.get("clue", "")))
