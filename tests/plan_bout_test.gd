extends SceneTree
## S339 the coach's plan in a real bout (LiveRound + BoutNight): she walks out with her saved plan (none = she fights her
## own way, edge 0), every 30 seconds is fought on a card with the arrow she throws there, the round counts the arrows that worked,
## and the corner changes ONE arrow between rounds - on the bout's copy, never her saved board.
## Population: Lucy Jackson (Data.lucy, out-boxer) against Maria Ortega (Data.OPPONENTS[0], pressure fighter, southpaw) -
## two different fighters; 80 bouts on 80 different days (the dice), each plan on the same 80.
## Control arm: the same bouts with a plan that answers a presser vs one that walks into her. The good plan must win more
## exchanges, and by a bounded margin (the plan is one edge among the corner's).

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")

## Answers a presser: jab and move at long range, step back from mid, turn off the ropes, tie up inside.
const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
## Walks into her: cut the ring at long range, stand and trade at mid, chase her to the corner, trade inside.
const BAD := [{"move": "cut_off"}, {"move": "3b-3"}, {"move": "herd"}, {"move": "3b-3@inside"}]
const BOUTS := 80

var failures := 0


func _initialize() -> void:
	# 1. No saved plan: she fights her own way; every exchange fought on a map card with a move from that card.
	var c := _career(30)
	var f: Dictionary = c.fighter()
	var m := _book(c, f)
	Bouts.fight_step(c, f, m, "start")
	_check((f["bout"]["arrows"] as Array).is_empty(), "no saved plan: she walks out with none")
	while not LiveRound.live(m).is_empty():
		Bouts.fight_step(c, f, m, "shout:")
	var r1: Dictionary = (m["rounds"] as Array)[0]
	var cards_ok := true
	for x in r1["exchanges"]:
		var row := StrikeMap.move(str(x["arrow"]))
		if StrikeMap.card(str(x["at"])).is_empty() or (not row.is_empty() and str(row["from"]) != str(x["at"])):
			cards_ok = false
	_check(cards_ok, "round 1: each exchange on a card, the move thrown from that card")
	var t: Dictionary = r1["arrows"]
	_check(int(t["used"]) == 0 and int(t["improvised"]) == (r1["exchanges"] as Array).size(),
		"round 1 tally, no plan: %d arrows used, %d on instinct" % [t["used"], t["improvised"]])

	# 2. The corner changes one arrow: on the bout, not on her saved board; a change that breaks the plan is refused.
	f["arrows"] = GOOD.duplicate(true)
	var c2 := _career(31)
	var f2: Dictionary = c2.fighter()
	f2["arrows"] = GOOD.duplicate(true)
	var m2 := _book(c2, f2)
	Bouts.fight_step(c2, f2, m2, "start")
	_check(f2["bout"]["arrows"] == GOOD, "a saved plan: she walks out with it")
	while not LiveRound.live(m2).is_empty():
		Bouts.fight_step(c2, f2, m2, "shout:")
	var mn := CornerJobsRow.menu(f2, (m2["rounds"] as Array)[-1])
	_check(not (mn["changes"] as Array).is_empty() and int(mn["limit"]) == BoutNight.arrow_limit(c2) and (mn["arrows"] as Array).size() == 4,
		"the corner card offers %d one-arrow changes (limit %d)" % [(mn["changes"] as Array).size(), int(mn["limit"])])
	_check(CornerJobsRow.suffix({"arrow": {"i": 0, "move": "1-2"}}) == "|arrow=0:1-2", "the card builds the arrow part")
	Bouts.fight_step(c2, f2, m2, "corner:long|arrow=0:1-2")
	var ch: Dictionary = LiveRound.live(m2).get("arrow_change", {})
	_check(bool(ch.get("ok", false)) and str(f2["bout"]["arrows"][0]["move"]) == "1-2" and str(f2["arrows"][0]["move"]) == "1-1",
		"corner: the 1-1 became a 1-2 for this bout; her saved plan keeps the 1-1")
	while not LiveRound.live(m2).is_empty():
		Bouts.fight_step(c2, f2, m2, "shout:")
	Bouts.fight_step(c2, f2, m2, "corner:long|arrow=1:1-1")
	_check(not bool(LiveRound.live(m2)["arrow_change"]["ok"]) and str(f2["bout"]["arrows"][1]["move"]) == "step_back",
		"corner: a second arrow at long range is refused, the plan stays")
	_check(str(Bouts.corner_jobs("long|arrow=2:slip 2-3@own_ropes".split("|"))["arrow"]["move"]) == "slip 2-3@own_ropes", "the arrow job parses a move with a space and a card")

	# 2b. The ring shows the arrow: a planned combination is her first punches; a planned step opens the exchange; the words say it.
	var beats := [{"t": 1.0, "who": "a", "move": "jab", "result": "lands"}, {"t": 2.0, "who": "b", "move": "cross", "result": "misses"},
		{"t": 3.0, "who": "a", "move": "jab", "result": "misses"}, {"t": 4.0, "who": "a", "move": "jab", "result": "lands"}]
	ExchangeBeats._arrow(beats, {"planned": true, "arrow": "1-2-3"})
	var hers := beats.filter(func(b): return str(b["who"]) == "a").map(func(b): return str(b["move"]))
	_check(hers == ["jab", "cross", "lead_hook"] and beats.filter(func(b): return str(b.get("combo_id", "")) == "1-2-3").size() == 3,
		"a planned 1-2-3: her punches in the ring are jab, cross, lead hook (%s)" % str(hers))
	var steps := [{"t": 1.5, "who": "a", "move": "jab", "result": "lands"}]
	ExchangeBeats._arrow(steps, {"planned": true, "arrow": "step_back"})
	_check(str(steps[0]["move"]) == "step_out" and float(steps[0]["t"]) < 1.5 and steps[0].has("caption"),
		"a planned step back: she steps out first (a full beat: FightView reads its caption)")
	var none := [{"t": 1.0, "who": "a", "move": "jab", "result": "lands"}]
	ExchangeBeats._arrow(none, {"planned": false, "arrow": "1-2-3"})
	_check(none.size() == 1 and str(none[0]["move"]) == "jab", "no arrow: the ring is as it was")
	_check(PlanFight.arrow_line({"arrow": "step_back", "at": "mid", "planned": true, "won": true}, ["Lucy", "Maria"]) == "Plan (Mid range): Step back - it worked."
		and PlanFight.arrow_line({"arrow": "1-1", "at": "long", "planned": false}, ["Lucy", "Maria"]) == "No arrow on Long range: Lucy does her own thing.",
		"the words: the arrow, its card, whether it worked")

	# 3. Control arm: the same 80 bouts, a plan that answers a presser vs one that walks into her (and none).
	var g := _share(GOOD)
	var b := _share(BAD)
	var o := _share([])
	var good := float(g[0])
	var bad := float(b[0])
	print("  exchanges won: good plan %.3f, her own way %.3f, bad plan %.3f" % [good, float(o[0]), bad])
	print("  mean plan edge an exchange: good %+.2f, her own way %+.2f, bad %+.2f" % [g[1], o[1], b[1]])
	_check(float(g[1]) > 1.5 and float(b[1]) < 0.0 and float(o[1]) == 0.0, "the plan's edge: good above +1.5, bad below 0, none exactly 0")
	_check(good - float(o[0]) >= 0.02 and good - bad >= 0.03, "the good plan wins more exchanges than her own way and the bad plan (%.3f / %.3f / %.3f)" % [good, float(o[0]), bad])
	_check(bad <= float(o[0]) + 0.01, "the bad plan does no better than no plan")
	_check(good - bad <= 0.20, "by a bounded margin - the plan is one edge among the corner's (%.3f)" % (good - bad))

	print("PLAN_BOUT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _career(day: int) -> Career:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = day
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	return c


func _book(c: Career, f: Dictionary) -> Dictionary:
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	return {"fid": f["id"], "step": "tape", "total": 3}


## [share of exchanges she won, mean plan edge an exchange] over BOUTS simulated bouts (days 40..) with this saved plan.
func _share(arrows: Array) -> Array:
	var won := 0
	var all := 0
	var edge := 0.0
	for i in BOUTS:
		var c := _career(40 + i)
		var f: Dictionary = c.fighter()
		f["arrows"] = arrows.duplicate(true)
		var m := _book(c, f)
		Bouts.fight_step(c, f, m, "sim")
		for r in m["rounds"]:
			for x in r["exchanges"]:
				all += 1
				won += int(bool(x["won"]))
				edge += float(x.get("plan_edge", 0.0))
	return [float(won) / maxf(1.0, float(all)), edge / maxf(1.0, float(all))]


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
