extends SceneTree
## S339 the coach's plan in the bout (operator Q-S294-61 "Yes, in that order", step 4: "she follows it, the corner changes
## one arrow a round"). PlanFight's rules: where each 30 seconds is fought, which arrow she throws there, what it is worth
## against the opponent's game, where she ends up, and the round's arrow tally.
## Population: Lucy's punches (Jab 60, Cross 55, Lead hook 45, Body hook 25, Uppercut 10, Check hook 0) - the 1-6-3 and
## the slip 2-3 are beyond her; a drilled 1-2 (combo mastery 40) and an undrilled 1-2-3 (12).

const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const MASTERY := {"Jab": 60.0, "Cross": 55.0, "Lead hook": 45.0, "Body hook": 25.0, "Uppercut": 10.0, "Check hook": 0.0}
const COMBOS := {"1-2": 40.0, "1-2-3": 12.0}

var failures := 0


func _initialize() -> void:
	# 1. every game of the opponent (and her own two states) has answers, all of them real moves on the map
	var known := {}
	for m in StrikeMap.MOVES:
		known[PlanFight.base_id(str(m["id"]))] = true
	var rows_ok := true
	for sit in Exchanges.MODES:
		if not PlanFight.ANSWERS.has(sit) or not PlanFight.GAME_CARD.has(sit):
			rows_ok = false
			print("  no row for ", sit)
			continue
		for k in ["best", "ok", "wrong"]:
			for id in PlanFight.ANSWERS[sit][k]:
				if not known.has(str(id)):
					rows_ok = false
					print("  unknown move ", id, " in ", sit)
	_check(rows_ok, "every situation has a ring card and best/ok/wrong answers from the map")

	# 2. she follows the arrow on her card; with none (or one she cannot throw yet) she does what she would on her own
	var plan := [{"move": "1-2"}, {"move": "step_back"}, {"move": "1-6-3@corner"}]
	var a := PlanFight.choose(plan, "long", MASTERY)
	_check(str(a["move"]) == "1-2" and bool(a["planned"]), "long range: she throws the plan's 1-2")
	var b := PlanFight.choose(plan, "outside", MASTERY)
	_check(str(b["move"]) != "" and not bool(b["planned"]) and str(StrikeMap.move(str(b["move"]))["from"]) == "outside",
		"outside (no arrow): she improvises a move from that card (%s)" % b["move"])
	var c := PlanFight.choose(plan, "corner", MASTERY)
	_check(str(c["move"]) != "1-6-3@corner" and not bool(c["planned"]), "an arrow she cannot throw yet (uppercut 10): improvised instead")
	_check(str(PlanFight.choose([], "clinch", MASTERY)["move"]) == "push_off", "the clinch with no plan: she pushes off (the only move she has)")

	_check(str(b["instinct"]) == "step_in" and str(a["instinct"]) == "1-1", "her instinct: the first move out of the card she can do")
	# 3. what a move is worth: a drilled best answer > the same undrilled > no fit; wrong costs in full
	var best_d := PlanFight.value("step_back", "press", 1.0)
	var best_u := PlanFight.value("step_back", "press", PlanBoard.UNDRILLED)
	var none := PlanFight.value("feint", "press", 1.0)
	var wrong_d := PlanFight.value("step_in", "press", 1.0)
	var wrong_u := PlanFight.value("step_in", "press", PlanBoard.UNDRILLED)
	_check(best_d > best_u and best_u > none and none == 0.0, "best drilled %.1f > undrilled %.1f > no fit %.1f" % [best_d, best_u, none])
	_check(wrong_d == wrong_u and wrong_d < 0.0, "a wrong move costs the same drilled or not")
	# ... and the plan's edge is the arrow's worth over the average of what she can do there: no plan = the game as balanced
	var base_r := PlanFight.card_mean("long", "range", MASTERY, COMBOS)
	var base_c := PlanFight.card_mean("long", "counter", MASTERY, COMBOS)
	_check(PlanFight.edge(PlanFight.choose([], "long", MASTERY), "range", 1.0, base_r) == 0.0, "no arrow: 0 - she fights her own way")
	var good := PlanFight.choose([{"move": "2-3"}], "long", MASTERY)
	var bad := PlanFight.choose([{"move": "1-2-3-2"}], "long", MASTERY)
	_check(PlanFight.edge(good, "range", 1.0, base_r) > 0.0 and PlanFight.edge(bad, "counter", 1.0, base_c) < 0.0,
		"long range: a cross-hook beats her average against a range boxer (%+.1f); a long combo into a counter-puncher loses (%+.1f)" % [
		PlanFight.edge(good, "range", 1.0, base_r), PlanFight.edge(bad, "counter", 1.0, base_c)])
	var push := PlanFight.choose([{"move": "push_off"}], "clinch", MASTERY)
	_check(is_zero_approx(PlanFight.edge(push, "press", 1.0, PlanFight.card_mean("clinch", "press", MASTERY, COMBOS))),
		"an arrow that is all she has on the card adds nothing (the clinch: push off)")
	_check(PlanFight.fit("3b-3@corner", "hurt") == PlanFight.fit("3b-3", "hurt"), "a move keeps its fit on every card (3b-3@corner = 3b-3)")
	_check(best_d < Exchanges.EDGE["best"], "the plan's edge stays under a best shout's (%.1f < %.1f): the corner still matters" % [best_d, Exchanges.EDGE["best"]])

	# 4. rate: steps and defences always drilled; a combo by its pad time
	_check(PlanFight.rate("step_back", COMBOS) == 1.0 and PlanFight.rate("1-2", COMBOS) == 1.0, "steps and a drilled 1-2 work in full")
	_check(PlanFight.rate("1-2-3", COMBOS) == PlanBoard.UNDRILLED and PlanFight.rate("3b-3@corner", COMBOS) == PlanBoard.UNDRILLED,
		"an undrilled 1-2-3 and a never-drilled 3b-3 at 80%")

	# 5. where the next 30 seconds is fought: she keeps the card she won, else the opponent's game decides
	_check(PlanFight.where_next("1-2-3", true, "range") == "mid", "won with the 1-2-3: she is at mid range")
	_check(PlanFight.where_next("1-2-3", false, "press") == "own_ropes", "lost to a presser: backed onto the ropes")
	_check(PlanFight.where_next("1-2", false, "range") == PlanFight.GAME_CARD["range"], "lost to a range boxer: back at her range")
	_check(PlanFight.where_next("", true, "counter") == PlanFight.GAME_CARD["counter"], "no move: the opponent's card")

	# 6. the coach's starter plan: legal for the newest coach, one arrow for each of four places
	var st := PlanFight.starter()
	_check(PlanBoard.validate(st, StrikeMap.MOVES, PlanBoard.NEW_COACH)["ok"] and st.size() == PlanBoard.NEW_COACH,
		"starter plan: %d arrows, valid for a new coach" % st.size())

	# 7. the round's arrow tally: used, worked (landed), and per arrow
	var exs := [{"arrow": "1-2", "planned": true, "won": true}, {"arrow": "1-2", "planned": true, "won": false},
		{"arrow": "step_back", "planned": true, "won": true}, {"arrow": "feint", "planned": false, "won": true}]
	var t := PlanFight.tally(exs)
	_check(int(t["used"]) == 3 and int(t["worked"]) == 2 and int(t["improvised"]) == 1, "tally: 3 arrows used, 2 worked, 1 improvised")
	_check(t["moves"]["1-2"] == [1, 2], "per arrow: the 1-2 worked 1 of 2")

	# 8. the corner's one change between rounds: one arrow swapped, or one added under the limit; never two at a place
	var ch := PlanFight.corner_change(plan, 1, "tie_up@own_ropes", 6)
	_check(ch.size() == 3 and str(ch[1]["move"]) == "tie_up@own_ropes" and str(plan[1]["move"]) == "step_back", "corner: arrow 2 changed, the plan she walked out with untouched")
	_check(PlanFight.corner_change(plan, 3, "pivot_out", 6).size() == 4, "corner: an arrow added under the coach's limit")
	_check(PlanFight.corner_change(plan, 3, "pivot_out", 3) == plan, "corner: no room - the plan stays")
	_check(PlanFight.corner_change(plan, 0, "1-1", 6) == [{"move": "1-1"}, plan[1], plan[2]], "corner: the 1-1 replaces the 1-2 at long range")
	_check(PlanFight.corner_change(plan, 1, "1-1", 6) == plan, "corner: a second arrow at long range is refused")

	# 9. the corner's choices: every one a legal single change; the cards she was fought on first; adds under the limit only
	var opts := PlanFight.corner_options(plan, MASTERY, 6, ["long", "outside"])
	var legal := opts.all(func(o): return PlanFight.corner_change(plan, int(o["i"]), str(o["move"]), 6) != plan)
	_check(not opts.is_empty() and legal, "corner choices: %d, each a legal one-arrow change" % opts.size())
	_check(str(opts[0]["from"]) == "long", "the card she was fought on most comes first")
	_check(opts.any(func(o): return str(o["from"]) == "outside" and str(o["was"]) == "" and int(o["i"]) == plan.size()),
		"a first arrow offered on a card she was fought on with none (outside)")
	_check(not PlanFight.corner_options(plan, MASTERY, 3, ["outside"]).any(func(o): return str(o["was"]) == ""), "at the coach's limit: no new arrows, changes only")
	_check(PlanFight.fought_cards([{"at": "long"}, {"at": "mid"}, {"at": "mid"}]) == ["mid", "long"], "fought cards, most first")

	print("PLAN_FIGHT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
