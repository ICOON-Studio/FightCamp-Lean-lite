extends SceneTree
## S434 PUNCHSTART1 round 1: PlanChain (a plan in a round, in expectation, on the cards she really stands on), from the
## contract LiveRound keeps: the round opens on the game's card (PlanFight.GAME_CARD), a won exchange moves her to her
## move's card, a lost one where the game puts her (PlanFight.where_next), and an arrow is thrown only on its own card.
##   1. no plan: no edge,
##   2. an arrow whose card she keeps (a one-two at long against a range fighter: long whether she wins or loses; S466 a counter-puncher waits outside) is
##      worth its first exchange's edge in every exchange of the round,
##   3. an arrow whose card she leaves (a step back from mid against a presser: won -> long, lost -> her own ropes) is worth
##      only its first exchange when she always wins or always loses (one sixth of the game's-card read), and between at
##      even odds (a pivot off the ropes brings her back to mid),
##   4. a mixed game reads under the game's-card read (the step back's card is left), and a cold cache reads the same.
##   5. S434 round 2, walk() (exchange by exchange): the same steps every exchange read as round_mean; her own trouble
##      (she_tired) keeps the card the last exchange left (S466 CARDFIX1: LiveRound no longer resets it on a she_ situation);
##      a skipped situation adds no edge but still moves her card.
## Population: Lucy as signed (Data.lucy), her moves and combinations; games press and range.
## Prints PLAN_CHAIN failures=<n>.

const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const Data := preload("res://scripts/state/Data.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanChain := preload("res://scripts/rules/PlanChain.gd")

const SIX := 6
var failures := 0


func _initialize() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	var moves: Dictionary = f.get("moves", {})
	var combos: Dictionary = {"1-1": 50.0, "1-2": 50.0}
	var jab := [{"move": "1-2"}]   # S466: the one-two (long -> long), a best answer to a range fighter
	var back := [{"move": "step_back"}]
	_check(is_zero_approx(PlanChain.round_mean([], moves, combos, {"press": 1.0}, 0.5, SIX)), "no plan, no edge")
	var e_jab := _first(jab, moves, combos, "range")
	_check(e_jab > 1.0, "a one-two answers a range fighter at long (%.2f)" % e_jab)
	var sharp := PlanChain.round_mean(jab, moves, {"1-1": 50.0, "1-2": 70.0}, {"range": 1.0}, 0.5, SIX)
	_check(sharp > PlanChain.round_mean(jab, moves, combos, {"range": 1.0}, 0.5, SIX), "a Sharp one-two fires more often than a Usable one (S459)")
	for p in [0.0, 0.5, 1.0]:
		var got := PlanChain.round_mean(jab, moves, combos, {"range": 1.0}, p, SIX)
		_check(absf(got - e_jab) <= 0.001, "the one-two keeps its card: every exchange %.2f at p %.1f (got %.2f)" % [e_jab, p, got])
	var e_back := _first(back, moves, combos, "press")
	_check(e_back > 1.0, "a step back answers a presser at mid (%.2f)" % e_back)
	for p in [0.0, 1.0]:
		var got := PlanChain.round_mean(back, moves, combos, {"press": 1.0}, p, SIX)
		_check(absf(got - e_back / float(SIX)) <= 0.001, "the step back leaves mid: one exchange in six (%.2f, got %.2f) at p %.1f" % [e_back / float(SIX), got, p])
	# At p 0.5 some lost exchanges on her ropes are won by her pivot back to mid, where the step back is thrown again.
	var half := PlanChain.round_mean(back, moves, combos, {"press": 1.0}, 0.5, SIX)
	_check(half > e_back / float(SIX) + 0.01 and half < e_back - 0.01, "at p 0.5 she comes back to mid now and then (%.2f in %.2f..%.2f)" % [half, e_back / float(SIX), e_back])
	var both := jab + back
	var mixed := PlanChain.round_mean(both, moves, combos, {"press": 0.5, "range": 0.5}, 0.5, SIX)
	_check(mixed > 0.0 and mixed < 0.5 * (e_jab + e_back), "a mixed game reads under its game's-card read (%.2f < %.2f)" % [mixed, 0.5 * (e_jab + e_back)])
	PlanChain._cells = {}
	var again := PlanChain.round_mean(both, moves, combos, {"press": 0.5, "range": 0.5}, 0.5, SIX)
	_check(is_equal_approx(again, mixed), "the same read with a cold cache (%.4f vs %.4f)" % [again, mixed])
	_walk(moves, combos, jab, both)
	print("PLAN_CHAIN failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _walk(moves: Dictionary, combos: Dictionary, jab: Array, both: Array) -> void:
	var mix := {"press": 0.5, "range": 0.5}
	var steps: Array = []
	for _i in SIX:
		steps.append(mix)
	var a := PlanChain.round_mean(both, moves, combos, mix, 0.5, SIX)
	var b := PlanChain.walk(both, moves, combos, steps, 0.5, [])
	_check(absf(a - b) <= 0.0001, "walk on six equal steps = round_mean (%.4f vs %.4f)" % [b, a])
	# S466: her own trouble keeps her where she stands. A round opened on her trouble starts inside (the tie-up is thrown); a
	# press exchange first walks her to mid or her ropes, and her trouble no longer puts her back inside: the tie-up's
	# second exchange reads under its round-opening read whether she won the press exchange or not.
	var tie := [{"move": "tie_up"}]
	var e_tie := _first(tie, moves, combos, "she_tired")
	_check(e_tie > 1.0, "a tie-up answers her own trouble inside (%.2f)" % e_tie)
	for p in [0.0]:   # p 1.0: a won press exchange leaves her inside (where_next), where the tie-up is thrown anyway
		var got := PlanChain.walk(tie, moves, combos, [{"press": 1.0}, {"she_tired": 1.0}], p, ["press"])
		_check(got < e_tie / 2.0 - 0.001, "her own trouble keeps her card at p %.1f: under %.2f of 2 exchanges (got %.2f)" % [p, e_tie / 2.0, got])
	# Skipped: no edge, but her card still moves - a range fighter's exchanges keep the one-two at long either way.
	_check(is_zero_approx(PlanChain.walk(jab, moves, combos, [{"range": 1.0}, {"range": 1.0}], 0.5, ["range"])), "a skipped situation adds no edge")
	var after := PlanChain.walk(jab, moves, combos, [{"press": 1.0}, {"range": 1.0}], 1.0, ["press"])
	var won_to := PlanFight.where_next(str(PlanFight.choose(jab, "mid", moves, "press")["move"]), true, "press")
	print("  a won press exchange leaves her at %s; the range exchange after it reads %.2f" % [won_to, after * 2.0])


## The plan's edge on the game's own card (LiveRound's first exchange of a round).
func _first(plan: Array, moves: Dictionary, combos: Dictionary, sit: String) -> float:
	var at := str(PlanFight.GAME_CARD[sit])
	var pick := PlanFight.choose(plan, at, moves, sit)
	# S459: as the fight adds it - a planned line fires on its level's share of uses (FireLevel, S450 FIRELEVEL3).
	var fire := FireLevel.share(FireLevel.shares_for({}), FireLevel.mastery_of({"combos": combos}, str(pick["move"])))
	return fire * PlanFight.edge(pick, sit, PlanFight.rate(str(pick["move"]), combos), PlanFight.card_mean(at, sit, moves, combos))


func _check(ok: bool, label: String) -> void:
	if ok:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)
