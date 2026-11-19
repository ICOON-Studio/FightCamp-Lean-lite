extends SceneTree
## S527 KNOWBOTS6: a first look misreads the WHOLE kid, not each attribute on its own.
## Knowledge._offset = SHARED_MISREAD x one per-prospect misread + the rest x the attribute's own misread
## (docs/KNOWBOTS6_RESULT.md: rho 0.5 is the smallest share where knowing a boxer pays 8%+ on every seed set).
## Red on the tree before S527: offsets were independent per attribute (correlation ~0).
## Last line: KNOWLEDGE_SHARED failures=0.

const K := preload("res://scripts/rules/Knowledge.gd")

var failures := 0
var n_checks := 0

func _initialize() -> void:
	_test_correlated()
	_test_bounds()
	_test_stable()
	_test_rating_error()
	print("KNOWLEDGE_SHARED failures=%d (%d checks)" % [failures, n_checks])
	quit(0 if failures == 0 else 1)

func _check(ok: bool, label: String) -> void:
	n_checks += 1
	if not ok:
		failures += 1
		print("FAIL " + label)

# Two attributes of the same prospect lean the same way (rho 0.5 on equal spreads -> correlation ~0.5).
func _test_correlated() -> void:
	var xs: Array[float] = []
	var ys: Array[float] = []
	for s in 400:
		var k: Dictionary = K.fresh(5000 + s)
		xs.append(K._offset(k, "speed"))
		ys.append(K._offset(k, "timing"))
	var r := _corr(xs, ys)
	_check(r >= 0.35 and r <= 0.7, "speed/timing misread correlation 0.35..0.7 (got %.2f)" % r)

# The offset never leaves the old band, so the truth stays inside every shown range.
func _test_bounds() -> void:
	var ok := true
	for s in 300:
		var k: Dictionary = K.fresh(9000 + s)
		for a in K.BODY_ATTRS + K.SKILLS_ATTRS:
			var o: float = K._offset(k, a)
			if o < K.OFFSET_LO - K.EPS or o > K.OFFSET_HI + K.EPS:
				ok = false
	_check(ok, "offset stays inside OFFSET_LO..OFFSET_HI")

func _test_stable() -> void:
	var k1: Dictionary = K.fresh(4242)
	var k2: Dictionary = K.fresh(4242)
	_check(is_equal_approx(K._offset(k1, "defence"), K._offset(k2, "defence")), "same seed -> same offset")

# The point of the change: the shown rating (mean of shown centres) is off by more than the old 0.83.
func _test_rating_error() -> void:
	var total := 0.0
	var n := 0
	for s in 300:
		var k: Dictionary = K.fresh(7000 + s)
		var sum := 0.0
		var c := 0
		for a in K.BODY_ATTRS + K.SKILLS_ATTRS:
			var rg: Dictionary = K.range_of(k, a, 50.0)
			sum += float(rg["centre"]) - 50.0
			c += 1
		total += absf(sum / float(c))
		n += 1
	var err := total / float(n)
	_check(err > 1.2, "mean |shown rating - true| above 1.2 (got %.2f)" % err)

func _corr(xs: Array[float], ys: Array[float]) -> float:
	var n := float(xs.size())
	var mx := 0.0
	var my := 0.0
	for i in xs.size():
		mx += xs[i]
		my += ys[i]
	mx /= n
	my /= n
	var sxy := 0.0
	var sxx := 0.0
	var syy := 0.0
	for i in xs.size():
		sxy += (xs[i] - mx) * (ys[i] - my)
		sxx += (xs[i] - mx) * (xs[i] - mx)
		syy += (ys[i] - my) * (ys[i] - my)
	return sxy / sqrt(maxf(sxx * syy, 0.000001))
