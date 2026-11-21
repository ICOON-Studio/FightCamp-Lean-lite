extends SceneTree
## KNOWMISREAD1 (S534, DEPTH_SCOPE change 4): the player can be WRONG about a prospect.
## The rule (Knowledge._offset, sized by KNOWBOTS6): half of every attribute's misread is ONE misread of the whole
## kid, so the errors no longer cancel and the shown overall rating is off by a shared amount.
## Red on a tree without the shared misread (SHARED_MISREAD 0.0: mean |shown - true| 0.86, groups uncorrelated).
## Population: 400 fresh prospects, seeds 61000.., every one with different true attributes (30..80 by hash).
## Last line: KNOW_MISREAD failures=0.

const K := preload("res://scripts/rules/Knowledge.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")

const N := 400
const SEED0 := 61000
const RATED: Array = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility",
	"accuracy", "timing", "defence", "footwork", "inside", "fight_iq", "durability", "composure"]

var failures := 0
var n_checks := 0

func _initialize() -> void:
	_test_shared_amount()
	_test_same_way()
	_test_bounded_and_honest()
	_test_by_seed()
	_test_full_knowledge()
	_test_reads_narrow()
	print("KNOW_MISREAD failures=%d (%d checks)" % [failures, n_checks])
	quit(0 if failures == 0 else 1)

func _check(ok: bool, label: String) -> void:
	n_checks += 1
	if not ok:
		failures += 1
		print("FAIL " + label)

func _truth(s: int, attr: String) -> float:
	return 30.0 + float(absi(hash([s, attr, "truth"])) % 5001) / 100.0

## Shown overall rating minus the true one: the mean of (centre - truth) over the attrs in the list.
func _miss(k: Dictionary, s: int, attrs: Array) -> float:
	var sum := 0.0
	for a in attrs:
		var t := _truth(s, str(a))
		sum += float(K.shown(k, str(a), t)["centre"]) - t
	return sum / float(attrs.size())

# The shown overall rating is off by the size KNOWBOTS6 measured (1.77 at half shared; 0.86 with none).
func _test_shared_amount() -> void:
	var total := 0.0
	var big := 0
	for i in N:
		var m := absf(_miss(K.fresh(SEED0 + i), SEED0 + i, RATED))
		total += m
		if m >= 2.0:
			big += 1
	var mean := total / float(N)
	print("KNOW_MISREAD mean |shown rating - true| = %.2f, misread by 2+ = %d of %d" % [mean, big, N])
	_check(mean >= 1.3 and mean <= 2.4, "mean |shown rating - true| 1.3..2.4 (got %.2f)" % mean)
	_check(big >= N / 5, "one prospect in five or more is misread by 2+ points (got %d of %d)" % [big, N])

# The misread is of the whole kid: body and skills lean the same way far more often than a coin.
func _test_same_way() -> void:
	var same := 0
	for i in N:
		var k: Dictionary = K.fresh(SEED0 + i)
		if _miss(k, SEED0 + i, K.BODY_ATTRS) * _miss(k, SEED0 + i, K.SKILLS_ATTRS) > 0.0:
			same += 1
	var share := float(same) / float(N)
	_check(share >= 0.62 and share <= 0.92, "body and skills misread the same way 62..92%% (got %.0f%%)" % (share * 100.0))

# Bounded: the miss never passes 0.6 of the widest range, and the truth stays inside every shown range.
func _test_bounded_and_honest() -> void:
	var inside := true
	var bounded := true
	for i in N:
		var s := SEED0 + i
		var k: Dictionary = K.fresh(s)
		var cap := 0.0
		for a in RATED:
			var t := _truth(s, str(a))
			var r: Dictionary = K.shown(k, str(a), t)
			cap += K.OFFSET_HI * float(r["width"])
			if t < float(r["lo"]) - K.EPS or t > float(r["hi"]) + K.EPS:
				inside = false
		if absf(_miss(k, s, RATED)) > cap / float(RATED.size()) + K.EPS:
			bounded = false
	_check(inside, "the truth is inside every shown range")
	_check(bounded, "the rating miss never passes 0.6 of the mean range half-width")

func _test_by_seed() -> void:
	var a := _miss(K.fresh(SEED0 + 7), SEED0 + 7, RATED)
	var b := _miss(K.fresh(SEED0 + 7), SEED0 + 7, RATED)
	_check(is_equal_approx(a, b), "same seed -> the same misread")
	var distinct := {}
	for i in 50:
		var k: Dictionary = K.fresh(SEED0 + i)
		var sum := 0.0
		for at in RATED:
			sum += float(K.range_of(k, str(at), 50.0)["centre"]) - 50.0
		distinct[snappedf(sum, 0.001)] = true
	_check(distinct.size() >= 45, "different seeds -> different misreads (got %d of 50)" % distinct.size())

# Full knowledge: the shown rating is the truth.
func _test_full_knowledge() -> void:
	var ok := true
	for i in 50:
		var s := SEED0 + i
		if absf(_miss(K.all_seen(), s, RATED)) > K.EPS:
			ok = false
		var k: Dictionary = K.fresh(s)
		K.expose(k, "body", 400.0, "session")  # body past the known share: its numbers are exact
		if not K.known(k, "body") or absf(_miss(k, s, K.BODY_ATTRS)) > K.EPS:
			ok = false
	_check(ok, "a fully seen boxer, and a known group, show the truth")

# A closer look, a test day, a trial and a hard spar narrow the misread; they never flip it.
func _test_reads_narrow() -> void:
	var steps: Array = ["look_closer", "test_day", "trial", "hard_spar_outside"]
	var mean_before := 0.0
	var mean_after := 0.0
	var shrank := true
	var kept_sign := true
	for i in N:
		var s := SEED0 + i
		var k: Dictionary = K.fresh(s)
		var body0 := _miss(k, s, K.BODY_ATTRS)
		var skills0 := _miss(k, s, K.SKILLS_ATTRS)
		mean_before += absf(_miss(k, s, K.BODY_ATTRS + K.SKILLS_ATTRS))
		for st in steps:
			KR.apply(k, str(st))
		var body1 := _miss(k, s, K.BODY_ATTRS)
		var skills1 := _miss(k, s, K.SKILLS_ATTRS)
		mean_after += absf(_miss(k, s, K.BODY_ATTRS + K.SKILLS_ATTRS))
		if absf(body1) > absf(body0) + K.EPS or absf(skills1) > absf(skills0) + K.EPS:
			shrank = false
		if body0 * body1 < -K.EPS or skills0 * skills1 < -K.EPS:
			kept_sign = false
	mean_before /= float(N)
	mean_after /= float(N)
	_check(shrank, "no group's misread grows after the reads")
	_check(kept_sign, "a read narrows a misread, it never flips it")
	_check(mean_after <= mean_before * 0.6, "the reads cut the mean misread by 40%%+ (%.2f -> %.2f)" % [mean_before, mean_after])
