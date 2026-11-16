extends SceneTree
## S495 FIGHTFILM1: the bout keeps every punch (BoutTape) when it is booked, for the fight analysis page.
## Path: BoutNight plays the bout on the corner's calls (headless: no ring) -> _finish -> AfterFight.book -> BoutTape.build
## (the settled rounds through ExchangeBeats, the ring's own path) -> m["tape"] -> FightLog.lines.
## Population: Lucy Jackson (orthodox out-boxer, step_back / pivot_out plan) vs a counter-puncher whose scout words say
## "Leaves her chin open" (RoundStyle.opponent_habits -> drops_right_after_jab), 3-round amateur. They differ in stats,
## technique and plan. Pure part: hand-built ring beats through BoutTape.exchange and after_facts.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutTape := preload("res://scripts/fight3d/BoutTape.gd")
const FightLog := preload("res://scripts/rules/FightLog.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


func _initialize() -> void:
	_pure_exchange()
	_habit_only_on_its_side()
	_played_bout()
	print("BOUT_TAPE failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


## The ring's beats of exchange 2 (absolute times 60-90 s): staging is dropped, punches kept with times inside the exchange.
func _pure_exchange() -> void:
	var ring := [
		{"t": 60.4, "who": "a", "move": "say", "result": "none", "caption": "Corner: \"Jab!\""},
		{"t": 61.0, "who": "a", "move": "step_in", "result": "none", "caption": ""},
		{"t": 62.5, "who": "a", "move": "jab", "result": "lands", "big": false, "def": "", "caption": ""},
		{"t": 63.1, "who": "b", "move": "cross", "result": "misses", "big": false, "def": "slip", "caption": "", "habit": "lunges_with_jab"},
		{"t": 64.0, "who": "b", "move": "lead_hook", "result": "lands", "big": true, "def": "", "caption": "", "end_t": 66.0},
		{"t": 70.0, "who": "a", "move": "clinch", "result": "none", "caption": ""},
		{"t": 75.25, "who": "a", "move": "body_hook", "result": "blocked", "big": false, "def": "block", "caption": ""},
	]
	var x := {"mode": "press", "place": 2, "pinned": true, "won": false}
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var ex := BoutTape.exchange(x, 2, 1, ring, {"a": [], "b": []}, rng)
	var beats: Array = ex["beats"]
	_check(beats.size() == 4, "4 punches kept of 7 beats (say, step_in, clinch dropped): %d" % beats.size())
	_check(is_equal_approx(float(beats[0]["t"]), 2.5) and is_equal_approx(float(beats[3]["t"]), 15.25), "times inside the exchange (2.5, 15.25)")
	_check(float(ex["at"]) == 60.0 and int(ex["i"]) == 2 and int(ex["round"]) == 1, "at 60, i 2, round 1")
	_check(str(ex["landed"]) == str([1, 1]), "landed [a, b] counted from the punches: %s" % str(ex["landed"]))
	_check(str(ex["mode"]) == "press" and int(ex["place"]) == 2 and bool(ex["pinned"]) and not bool(ex["won"]), "the exchange's mode, place, pinned, won carried")
	_check(str((beats[1] as Dictionary).get("habit", "")) == "lunges_with_jab" and not (beats[0] as Dictionary).has("habit"),
		"a punch the ring tagged with a habit keeps it; an untagged one has no habit key")
	_check(not (beats[2] as Dictionary).has("end_t") and not (beats[2] as Dictionary).has("caption"), "the ring's staging keys are not kept")
	var keys_ok := true
	for b in beats:
		for k in ["t", "who", "move", "result", "big", "def", "after", "seen"]:
			keys_ok = keys_ok and (b as Dictionary).has(k)
	_check(keys_ok, "every kept punch has t, who, move, result, big, def, after, seen")
	var lines := FightLog.lines([ex], 1)
	_check(lines.size() == 4 and str(lines[0]["range"]) == "ropes" and is_equal_approx(float(lines[0]["t"]), 62.5),
		"FightLog reads the tape: 4 lines, on the ropes, the first at 1:02")


## A habit raises its fact only for the side that has it: right low after the jab, b only.
func _habit_only_on_its_side() -> void:
	var beats: Array = []
	for i in 6000:
		beats.append({"t": float(i) * 3.0, "who": "a" if i % 2 == 0 else "b", "move": "jab" if i % 4 < 2 else "cross",
			"result": "misses", "big": false, "def": ""})
	var rng := RandomNumberGenerator.new()
	rng.seed = 495
	BoutTape.after_facts(beats, {"a": [], "b": ["drops_right_after_jab"]}, rng)
	var rate := {}
	for b in beats:
		var key := "%s_%s" % [b["who"], b["move"]]
		var cell: Array = rate.get(key, [0, 0])
		cell[0] = int(cell[0]) + int(str(b["after"]) == "right_low")
		cell[1] = int(cell[1]) + 1
		rate[key] = cell
	var r := {}
	for k in rate:
		r[k] = float(rate[k][0]) / float(rate[k][1])
	_check(float(r["b_jab"]) - float(r["b_cross"]) >= 0.25, "b (the habit): right low after the jab %.2f vs the cross %.2f" % [r["b_jab"], r["b_cross"]])
	_check(absf(float(r["a_jab"]) - float(r["a_cross"])) < 0.06, "a (no habit): right low after the jab %.2f vs the cross %.2f" % [r["a_jab"], r["a_cross"]])
	var seen := 0
	for b in beats:
		seen += int(bool(b["seen"]))
	_check(absf(float(seen) / beats.size() - 2.0 / 3.0) < 0.03, "the camera sees about 2 in 3: %.3f" % (float(seen) / beats.size()))


## A played, unwatched bout keeps its tape on the result record; the same on a second build; FightLog reads every round.
func _played_bout() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), 1000))
	var f: Dictionary = c.fighter()
	f["arrows"] = [{"move": "step_back"}, {"move": "pivot_out"}]
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	opp["weak"] = "Leaves her chin open"
	c.day = 61
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 3, "rounds": 3}
	var m := {"fid": str(f["id"]), "step": "tape", "round": 0, "rounds": [], "total": 3, "type": "fight"}
	Bouts.fight_step(c, f, m, "start")
	Bouts.fight_step(c, f, m, "rest")
	_check(str(m.get("step", "")) == "result" and m.has("tape"), "the bout reaches the result with its tape (step %s)" % m.get("step", ""))
	var tape: Array = m.get("tape", [])
	var rounds: Array = m.get("rounds", [])
	var want := 0
	for r in rounds:
		want += ((r as Dictionary).get("exchanges", []) as Array).size()
	_check(tape.size() == want and want > 0, "one tape exchange per settled exchange: %d of %d" % [tape.size(), want])
	_check(str(BoutTape.build(c, f, m)) == str(tape), "the same tape on a second build (no hidden roll)")
	var all := 0
	var named := false
	for n in range(1, rounds.size() + 1):
		var lines := FightLog.lines(tape.filter(func(x): return int(x["round"]) == n), n)
		all += lines.size()
		for l in lines:
			var w := FightLog.words(l)
			named = named or w.contains(str(f.get("first", "@@"))) or w.contains(str(opp.get("first", opp.get("name", "@@"))))
	_check(all >= 20 * rounds.size(), "every round has punch lines: %d over %d rounds" % [all, rounds.size()])
	_check(not named, "no names in the punch lines (owner S448)")
