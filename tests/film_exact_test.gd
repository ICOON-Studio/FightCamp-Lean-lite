extends SceneTree
## FILM_EXACT test - the exact statistical functions: Fisher tail and Poisson tails.

const FP := preload("res://scripts/rules/FilmPattern.gd")

var failures := 0


func _initialize() -> void:
	_test_tail_p()
	_test_tail_p_monotone()
	_test_tail_p_luck()
	_test_poisson_low()
	_test_poisson_high()
	_test_poisson_edge()
	_test_binom_low()
	_test_binom_high()
	_test_binom_luck()
	print("FILM_EXACT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _assert_approxEQ(actual: float, expected: float, tol: float, label: String) -> void:
	var diff: float = abs(actual - expected)
	if diff <= tol:
		print("PASS %s (got %.6f, expected %.6f)" % [label, actual, expected])
	else:
		failures += 1
		print("FAIL %s (got %.6f, expected %.6f, diff %.6f > tol %.6f)" % [label, actual, expected, diff, tol])


# --- tail_p (Fisher exact) ---

func _test_tail_p() -> void:
	# k=3, n=3, rest_k=0, rest_n=97 -> 3/100 * 2/99 * 1/98 = 6.18e-6
	_assert_approxEQ(FP.tail_p(3, 3, 0, 97), 6.18e-6, 1e-7, "tail_p k=3,n=3,rest_k=0,rest_n=97")
	# k=0 -> 1.0
	_check(FP.tail_p(0, 10, 5, 85) == 1.0, "tail_p k=0 -> 1.0")
	# k=1, n=10, rest_k=9, rest_n=90 -> about 0.669
	_assert_approxEQ(FP.tail_p(1, 10, 9, 90), 0.6695, 0.01, "tail_p k=1,n=10,rest_k=9,rest_n=90")
	# Empty side: n=0 -> 1.0
	_check(FP.tail_p(0, 0, 5, 95) == 1.0, "tail_p n=0 -> 1.0")
	# Empty side: rest_n=0 -> 1.0
	_check(FP.tail_p(3, 10, 2, 0) == 1.0, "tail_p rest_n=0 -> 1.0")
	# total_k=0 -> 1.0
	_check(FP.tail_p(0, 10, 0, 90) == 1.0, "tail_p total_k=0 -> 1.0")


func _test_tail_p_monotone() -> void:
	# Monotone in k: higher k -> lower p
	var p1: float = FP.tail_p(2, 20, 10, 100)
	var p2: float = FP.tail_p(3, 20, 10, 100)
	var p3: float = FP.tail_p(4, 20, 10, 100)
	_check(p1 > p2, "tail_p monotone: p(k=2) > p(k=3)")
	_check(p2 > p3, "tail_p monotone: p(k=3) > p(k=4)")


func _test_tail_p_luck() -> void:
	# The luck case: k=3, n=4, rest_k=30, rest_n=60 must NOT be "pass"
	var result: Dictionary = FP.after_moment(3, 4, 30, 60)
	_check(str(result["word"]) != "pass", "luck case k=3,n=4,rest_k=30,rest_n=60 not pass")
	# Verify the p-value is above PASS_P
	var p: float = FP.tail_p(3, 4, 30, 60)
	_check(p > 0.01, "luck case p > 0.01 (got %.4f)" % p)


# --- Poisson tails ---

func _test_poisson_low() -> void:
	# E=2: P(X <= 0) = e^(-2) = 0.1353
	_assert_approxEQ(FP.poisson_tail_low(0, 2.0), 0.1353, 0.001, "poisson_low obs=0,E=2")
	# E=2: P(X <= 1) = e^(-2) * (1 + 2) = 0.4060
	_assert_approxEQ(FP.poisson_tail_low(1, 2.0), 0.4060, 0.001, "poisson_low obs=1,E=2")
	# E=2: P(X <= 5) = 0.9834
	_assert_approxEQ(FP.poisson_tail_low(5, 2.0), 0.9834, 0.001, "poisson_low obs=5,E=2")


func _test_poisson_high() -> void:
	# E=2: P(X >= 5) = 1 - P(X <= 4) = 0.0527
	_assert_approxEQ(FP.poisson_tail_high(5, 2.0), 0.0527, 0.001, "poisson_high obs=5,E=2")
	# E=2: P(X >= 10) ~ 0.0001
	_assert_approxEQ(FP.poisson_tail_high(10, 2.0), 0.0001, 0.0005, "poisson_high obs=10,E=2")
	# E=5: P(X >= 10) = 0.0318
	_assert_approxEQ(FP.poisson_tail_high(10, 5.0), 0.0318, 0.001, "poisson_high obs=10,E=5")


func _test_poisson_edge() -> void:
	# E=0, obs=0 -> low: 1.0, high: 1.0
	_check(FP.poisson_tail_low(0, 0.0) == 1.0, "poisson_low E=0,obs=0 -> 1.0")
	_check(FP.poisson_tail_high(0, 0.0) == 1.0, "poisson_high E=0,obs=0 -> 1.0")
	# E=0, obs=1 -> high: 0.0 (impossible event)
	_check(FP.poisson_tail_high(1, 0.0) == 0.0, "poisson_high E=0,obs=1 -> 0.0")
	# obs=0 -> high: always 1.0
	_check(FP.poisson_tail_high(0, 5.0) == 1.0, "poisson_high obs=0 -> 1.0")


# --- Binomial tails ---

func _test_binom_low() -> void:
	# n=4, q=0.5: P(X <= 0) = (0.5)^4 = 0.0625
	_assert_approxEQ(FP.binom_tail_low(0, 4, 0.5), 0.0625, 0.001, "binom_low k=0,n=4,q=0.5")
	# n=4, q=0.5: P(X <= 1) = P(X=0) + P(X=1) = 0.0625 + 4*0.0625 = 0.3125
	_assert_approxEQ(FP.binom_tail_low(1, 4, 0.5), 0.3125, 0.001, "binom_low k=1,n=4,q=0.5")
	# n=10, q=0.2: P(X <= 0) = (0.8)^10 = 0.1074
	_assert_approxEQ(FP.binom_tail_low(0, 10, 0.2), 0.1074, 0.001, "binom_low k=0,n=10,q=0.2")


func _test_binom_high() -> void:
	# n=4, q=0.5: P(X >= 4) = (0.5)^4 = 0.0625
	_assert_approxEQ(FP.binom_tail_high(4, 4, 0.5), 0.0625, 0.001, "binom_high k=4,n=4,q=0.5")
	# n=4, q=0.5: P(X >= 3) = P(X=3) + P(X=4) = 4*0.0625 + 0.0625 = 0.3125
	_assert_approxEQ(FP.binom_tail_high(3, 4, 0.5), 0.3125, 0.001, "binom_high k=3,n=4,q=0.5")
	# n=10, q=0.2: P(X >= 5) = 1 - P(X <= 4) ≈ 0.0328
	_assert_approxEQ(FP.binom_tail_high(5, 10, 0.2), 0.0328, 0.001, "binom_high k=5,n=10,q=0.2")


func _test_binom_luck() -> void:
	# The luck case from the task: inside 3 landed in 1 min against outside 6 in 2 min (same rate).
	# For outlanded: r0=1.0, q = in_min / (in_min + out_min) = 1 / (1 + 2) = 1/3.
	# n = 3 + 6 = 9, in_landed = 3.
	# P(X >= 3) with n=9, q=1/3 should be high (not significant).
	var p: float = FP.binom_tail_high(3, 9, 1.0 / 3.0)
	_check(p > 0.10, "binom luck case: p > 0.10 (got %.4f)" % p)
	# Test the full outlanded function: should be "nothing"
	var result: Dictionary = FP.outlanded(3, 1.0, 6, 2.0)
	_check(str(result["word"]) == "nothing", "binom luck case outlanded: word=nothing (got %s)" % str(result["word"]))
