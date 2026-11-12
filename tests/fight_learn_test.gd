extends SceneTree
## ASKPROBE1: FightLearn tests. teach() equals Matchmaking's own arithmetic for 8 hand cases computed IN THE TEST
## from Matchmaking's constants. A points loss to a better boxer teaches more than a win over a soft one.
## Words are monotonic. MUTANT: a copy without GROW_LOSS fails.

const FightLearn := preload("res://scripts/rules/FightLearn.gd")
const Matchmaking := preload("res://scripts/rules/Matchmaking.gd")

var failures := 0


func _initialize() -> void:
	_teach_even_win()
	_teach_step_up_win()
	_teach_points_loss_up()
	_teach_stoppage_loss()
	_teach_soft_win()
	_teach_gap_past_learn_gap()
	_teach_soft_gap()
	_teach_stoppage_win()
	_loss_better_teaches_more_than_soft_win()
	_words_monotonic()
	_stop_word_monotonic()
	_mutant_no_grow_loss_fails()
	print("FIGHT_LEARN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + what)


## Reference: compute growth exactly as Matchmaking.apply_result does.
func _ref(gap: float, won: bool, stopped: bool) -> float:
	var grow: float
	if gap > -Matchmaking.SOFT_GAP:
		grow = Matchmaking.GROW_BASE + Matchmaking.GROW_PER_POINT * clampf(gap, 0.0, Matchmaking.LEARN_GAP)
	else:
		grow = Matchmaking.GROW_SOFT
	if not won:
		if gap <= Matchmaking.LEARN_GAP and not stopped:
			grow += Matchmaking.GROW_LOSS
		if stopped:
			grow -= Matchmaking.STOP_COST
	return grow


## Even win (gap = 0): GROW_BASE.
func _teach_even_win() -> void:
	var gap := 0.0
	var got := FightLearn.teach(gap, true, false)
	var want := _ref(gap, true, false)
	_check(absf(got - want) < 0.001, "even win: got %.3f, want %.3f" % [got, want])


## Step up win (gap = 4): GROW_BASE + GROW_PER_POINT * 4.
func _teach_step_up_win() -> void:
	var gap := 4.0
	var got := FightLearn.teach(gap, true, false)
	var want := _ref(gap, true, false)
	_check(absf(got - want) < 0.001, "step up win gap=4: got %.3f, want %.3f" % [got, want])


## Points loss to a better boxer (gap = 3, not stopped): GROW_BASE + GROW_PER_POINT*3 + GROW_LOSS.
func _teach_points_loss_up() -> void:
	var gap := 3.0
	var got := FightLearn.teach(gap, false, false)
	var want := _ref(gap, false, false)
	_check(absf(got - want) < 0.001, "points loss gap=3: got %.3f, want %.3f" % [got, want])


## Stoppage loss (gap = 2, stopped): GROW_BASE + GROW_PER_POINT*2 - STOP_COST (no GROW_LOSS when stopped).
func _teach_stoppage_loss() -> void:
	var gap := 2.0
	var got := FightLearn.teach(gap, false, true)
	var want := _ref(gap, false, true)
	_check(absf(got - want) < 0.001, "stoppage loss gap=2: got %.3f, want %.3f" % [got, want])


## Soft win (gap = -7): GROW_SOFT.
func _teach_soft_win() -> void:
	var gap := -7.0
	var got := FightLearn.teach(gap, true, false)
	var want := _ref(gap, true, false)
	_check(absf(got - want) < 0.001, "soft win gap=-7: got %.3f, want %.3f" % [got, want])


## Gap past LEARN_GAP (gap = 10): clamped to LEARN_GAP.
func _teach_gap_past_learn_gap() -> void:
	var gap := 10.0
	var got := FightLearn.teach(gap, true, false)
	var want := _ref(gap, true, false)
	_check(absf(got - want) < 0.001, "gap past LEARN_GAP: got %.3f, want %.3f" % [got, want])


## Soft gap boundary (gap = -6): exactly at -SOFT_GAP, uses GROW_SOFT.
func _teach_soft_gap() -> void:
	var gap := -6.0
	var got := FightLearn.teach(gap, true, false)
	var want := _ref(gap, true, false)
	_check(absf(got - want) < 0.001, "soft gap boundary gap=-6: got %.3f, want %.3f" % [got, want])


## Stoppage win (gap = 2, stopped): same as normal win (stoppage only matters for loss).
func _teach_stoppage_win() -> void:
	var gap := 2.0
	var got := FightLearn.teach(gap, true, true)
	var want := _ref(gap, true, true)
	_check(absf(got - want) < 0.001, "stoppage win gap=2: got %.3f, want %.3f" % [got, want])


## A points loss to a better boxer teaches more than a win over a soft one.
func _loss_better_teaches_more_than_soft_win() -> void:
	var loss_better := FightLearn.teach(3.0, false, false)
	var soft_win := FightLearn.teach(-7.0, true, false)
	_check(loss_better > soft_win, "points loss to better (%.3f) > soft win (%.3f)" % [loss_better, soft_win])


## Words are monotonic: little < some < lot.
func _words_monotonic() -> void:
	var w1 := FightLearn.word(0.2)
	var w2 := FightLearn.word(0.5)
	var w3 := FightLearn.word(0.8)
	_check(w1 == "teaches little", "word(0.2) = '%s'" % w1)
	_check(w2 == "teaches some", "word(0.5) = '%s'" % w2)
	_check(w3 == "teaches a lot", "word(0.8) = '%s'" % w3)


## Stop words are monotonic: unlikely < possible < real risk.
func _stop_word_monotonic() -> void:
	var s1 := FightLearn.stop_word(0.05)
	var s2 := FightLearn.stop_word(0.2)
	var s3 := FightLearn.stop_word(0.4)
	_check(s1 == "unlikely", "stop_word(0.05) = '%s'" % s1)
	_check(s2 == "possible", "stop_word(0.2) = '%s'" % s2)
	_check(s3 == "a real risk", "stop_word(0.4) = '%s'" % s3)


## MUTANT: a copy without GROW_LOSS fails.
func _mutant_no_grow_loss_fails() -> void:
	## Simulate a mutant that does not add GROW_LOSS on a points loss.
	var gap := 3.0
	var mutant_grow: float
	if gap > -Matchmaking.SOFT_GAP:
		mutant_grow = Matchmaking.GROW_BASE + Matchmaking.GROW_PER_POINT * clampf(gap, 0.0, Matchmaking.LEARN_GAP)
	else:
		mutant_grow = Matchmaking.GROW_SOFT
	## Mutant does NOT add GROW_LOSS.
	var real := FightLearn.teach(gap, false, false)
	_check(absf(real - mutant_grow) > 0.1, "mutant without GROW_LOSS differs from real: real=%.3f, mutant=%.3f" % [real, mutant_grow])
