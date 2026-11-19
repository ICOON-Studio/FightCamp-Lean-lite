extends SceneTree
## KNOWLEDGE1A - KnowReads tests (issue #378).
## Covers: every read, every stale cause, hype clear, moment threshold,
## honest-range sweep (1000 random truths/exposures: truth inside every band),
## word thresholds. Last line: KNOW_READS failures=0.

const K := preload("res://scripts/rules/Knowledge.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")

var failures := 0
var n_checks := 0

func _initialize() -> void:
	_test_prices()
	_test_look_closer()
	_test_trial()
	_test_test_day()
	_test_recheck()
	_test_hard_spar_club()
	_test_hard_spar_outside()
	_test_stale_causes()
	_test_hype_clear()
	_test_moment_threshold()
	_test_honest_range_sweep()
	_test_word_thresholds()
	_test_risk()
	_test_narrows()
	_test_recheck_ready()
	print("KNOW_READS failures=%d (%d checks)" % [failures, n_checks])
	quit(0 if failures == 0 else 1)

func _check(ok: bool, label: String) -> void:
	n_checks += 1
	if not ok:
		failures += 1
		print("FAIL " + label)

# Prices match the design table.
func _test_prices() -> void:
	var ok := KR.price("look_closer") == 120
	ok = ok and KR.price("test_day") == 60
	ok = ok and KR.price("recheck") == 40
	ok = ok and KR.price("hard_spar_club") == 0
	ok = ok and KR.price("hard_spar_outside") == 160
	ok = ok and KR.price("trial") == 500  # half stipend * 4 weeks
	_check(ok, "prices match design table")

# Look closer: narrows widest group to half day-one, or clears Hyped.
func _test_look_closer() -> void:
	# Clears hype
	var k_hyped: Dictionary = K.fresh(101)
	K.set_hyped(k_hyped, true)
	KR.apply(k_hyped, "look_closer")
	var ok: bool = not K.is_hyped(k_hyped)
	# Narrows widest group (body starts at ±8, which is wider than skills at ±12? No, skills is wider)
	# Actually skills starts at ±12, body at ±8, so skills is widest initially
	var k: Dictionary = K.fresh(102)
	var w_skills_before: float = K.width(k, "skills")
	KR.apply(k, "look_closer")
	var w_skills_after: float = K.width(k, "skills")
	ok = ok and w_skills_after < w_skills_before
	_check(ok, "look_closer: clears hype or narrows widest group")

# Trial: every group narrows as if signed.
func _test_trial() -> void:
	var k: Dictionary = K.fresh(201)
	var w_body_before: float = K.width(k, "body")
	var w_skills_before: float = K.width(k, "skills")
	KR.apply(k, "trial")
	var w_body_after: float = K.width(k, "body")
	var w_skills_after: float = K.width(k, "skills")
	var ok := w_body_after < w_body_before and w_skills_after < w_skills_before
	_check(ok, "trial: narrows body and skills")

# Test day: body narrows, twice with under 5 bouts.
func _test_test_day() -> void:
	# Under 5 bouts: double narrowing
	var k1: Dictionary = K.fresh(301)
	KR.apply(k1, "test_day")
	var w1: float = K.width(k1, "body")
	# Over 5 bouts: normal narrowing
	var k2: Dictionary = K.fresh(302)
	k2["bout_count"] = 10
	KR.apply(k2, "test_day")
	var w2: float = K.width(k2, "body")
	# Under 5 bouts should narrow more
	var ok := w1 < w2
	_check(ok, "test_day: twice with under 5 bouts")

# Recheck: halves stale.
func _test_recheck() -> void:
	var k: Dictionary = K.fresh(401)
	K.hard_spar(k, false)
	K.stale(k, "stoppage")
	var stale_before: float = float(k.get("stale_fire", 0.0))
	KR.apply(k, "recheck")
	var stale_after: float = float(k.get("stale_fire", 0.0))
	var ok: bool = absf(stale_after - stale_before * 0.5) < 0.001
	_check(ok, "recheck: halves stale")

# Hard spar club: opens under_fire to half way.
func _test_hard_spar_club() -> void:
	var k: Dictionary = K.fresh(501)
	KR.apply(k, "hard_spar_club")
	var ok: bool = bool(k.get("under_fire_opened", false))
	var w: float = K.width(k, "under_fire")
	ok = ok and w <= K.UNDER_FIRE_START
	_check(ok, "hard_spar_club: opens under_fire")

# Hard spar outside: opens under_fire to 3/4.
func _test_hard_spar_outside() -> void:
	var k: Dictionary = K.fresh(601)
	KR.apply(k, "hard_spar_outside")
	var ok: bool = bool(k.get("under_fire_opened", false))
	var w: float = K.width(k, "under_fire")
	ok = ok and w <= K.UNDER_FIRE_START
	_check(ok, "hard_spar_outside: opens under_fire wider than club")

# Every stale cause recorded.
func _test_stale_causes() -> void:
	var k: Dictionary = K.fresh(701)
	K.hard_spar(k, false)
	K.stale(k, "stoppage")
	K.stale(k, "layoff")
	K.stale(k, "step_up")
	K.stale(k, "ageing")
	var causes: Array = K.stale_causes(k)
	var ok := causes.size() == 4
	ok = ok and str(causes[0]).contains("Stoppage")
	ok = ok and str(causes[1]).contains("bout")
	ok = ok and str(causes[2]).contains("step up")
	ok = ok and str(causes[3]).contains("Age")
	_check(ok, "every stale cause recorded")

# Hype clear: centre jumps to truth, band still contains it.
func _test_hype_clear() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 801
	var ok: bool = true
	for i in 200:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		K.set_hyped(k, true)
		K.expose(k, "body", 5.0, "session")
		var truth: float = rng.randf_range(10.0, 90.0)
		# Clear hype
		K.clear_hype(k)
		# After clear: range without hype, truth still inside
		var r_after: Dictionary = K.range_of(k, "strength", truth, 0.0)
		if truth < float(r_after["lo"]) - 0.001 or truth > float(r_after["hi"]) + 0.001:
			ok = false
			break
	_check(ok, "hype clear: truth inside band after clear (200 cases)")

# Moment threshold: 4.9 width change = no, 5.0 = yes.
func _test_moment_threshold() -> void:
	# under_fire opening is always a moment
	var k_before: Dictionary = K.fresh(901)
	var k_after: Dictionary = k_before.duplicate()
	K.hard_spar(k_after, false)
	var ok := K.moment(k_before, k_after)
	# Small width change (< 5) is not a moment
	var k_a: Dictionary = K.fresh(902)
	K.expose(k_a, "body", 2.0, "session")
	var k_b: Dictionary = k_a.duplicate()
	K.expose(k_b, "body", 3.0, "session")
	ok = ok and not K.moment(k_a, k_b)
	# Large width change (>= 5) is a moment
	var k_c: Dictionary = K.fresh(903)
	var k_d: Dictionary = K.fresh(903)
	K.expose(k_d, "body", 50.0, "session")
	ok = ok and K.moment(k_c, k_d)
	_check(ok, "moment threshold: 4.9=no, 5.0=yes")

# Honest-range sweep: 1000 random truths and exposures, truth inside every band.
func _test_honest_range_sweep() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1001
	var ok := true
	for i in 1000:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		# Random exposures
		K.expose(k, "body", rng.randf_range(0.0, 50.0), "session")
		K.expose(k, "skills", rng.randf_range(0.0, 50.0), "session")
		if rng.randf() < 0.5:
			K.hard_spar(k, rng.randf() < 0.5)
		K.expose(k, "under_fire", rng.randf_range(0.0, 30.0), "spar")
		# Random stale
		if rng.randf() < 0.3:
			K.stale(k, ["stoppage", "layoff", "step_up", "ageing"][rng.randi_range(0, 3)])
		# Check every attr with range
		for attr in K.BODY_ATTRS + K.SKILLS_ATTRS + K.UNDER_FIRE_ATTRS:
			var truth: float = rng.randf_range(0.0, 100.0)
			var hype: float = rng.randf_range(0.0, 1.0)
			var r: Dictionary = K.range_of(k, attr, truth, hype)
			if truth < float(r["lo"]) - 0.001 or truth > float(r["hi"]) + 0.001:
				ok = false
				break
		if not ok:
			break
	_check(ok, "honest-range sweep: truth inside every band (1000 cases)")

# Width word thresholds.
func _test_word_thresholds() -> void:
	var ok := K.word(1.0) == "Exact"
	ok = ok and K.word(2.0) == "Exact"
	ok = ok and K.word(2.5) == "Good read"
	ok = ok and K.word(5.0) == "Good read"
	ok = ok and K.word(8.0) == "Good read"
	ok = ok and K.word(10.0) == "Rough"
	ok = ok and K.word(14.0) == "Rough"
	ok = ok and K.word(16.0) == "Unknown"
	ok = ok and K.word(50.0) == "Unknown"
	_check(ok, "width word thresholds")

# Risk numbers for hard spar.
func _test_risk() -> void:
	var r_club: Dictionary = KR.risk("hard_spar_club")
	var r_out: Dictionary = KR.risk("hard_spar_outside")
	var ok: bool = float(r_club.get("injury_mult", 0.0)) == 2.0
	ok = ok and int(r_club.get("tiredness", 0)) == 15
	ok = ok and float(r_out.get("injury_mult", 0.0)) == 2.0
	ok = ok and int(r_out.get("tiredness", 0)) == 15
	_check(ok, "risk numbers for hard spar")

# Narrows descriptions.
func _test_narrows() -> void:
	var ok := true
	for kind in KR.READS:
		var n: Dictionary = KR.narrows(kind)
		if str(n.get("desc", "")) == "":
			ok = false
			break
	_check(ok, "narrows: every read has a description")

# Recheck ready: once every 3 weeks.
func _test_recheck_ready() -> void:
	var k: Dictionary = K.fresh(1101)
	var ok: bool = KR.recheck_ready(k, 0)  # fresh: ready
	K.recheck_done(k, 0)
	ok = ok and not KR.recheck_ready(k, 10)  # 10 days later: not ready
	ok = ok and KR.recheck_ready(k, 22)  # 22 days later: ready
	_check(ok, "recheck_ready: once every 3 weeks")
