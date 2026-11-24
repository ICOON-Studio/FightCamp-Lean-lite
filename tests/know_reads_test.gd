extends SceneTree
## KNOWLEDGE1A - KnowReads tests (issue #378).
## Covers: every read, every stale cause, hype clear, moment threshold,
## honest-range sweep (1000 random truths/exposures: truth inside every band),
## word thresholds. Last line: KNOW_READS failures=0.
## S545 KNOWBUILD1 rewrote two checks to the owner's new rules (interview S543 K4, map v9 C1-C2): the prices (the trial was
## $500 for 4 weeks, now $36 a day; the test day was $60, now day 1 of the trial at the same $36) and _test_test_day
## ("twice with under 5 bouts") -> _test_trial_days (each evening's question narrows its own group, a second ask half as much).

const K := preload("res://scripts/rules/Knowledge.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")

var failures := 0
var n_checks := 0

func _initialize() -> void:
	_test_prices()
	_test_look_closer()
	_test_trial()
	_test_trial_days()
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
	ok = ok and KR.price("test_day") == 36  # S545: the test day is the trial's body question, a trial day's price
	ok = ok and KR.price("recheck") == 40
	ok = ok and KR.price("hard_spar_club") == 0
	ok = ok and KR.price("hard_spar_outside") == 160
	ok = ok and KR.price("trial") == 36  # S545 map v9 C1: $36 a day (was $500 for 4 weeks)
	for q in KR.QUESTIONS:
		ok = ok and KR.price(q) == KR.PRICE_TRIAL_DAY
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

# S545 K4: each trial day answers the question picked the evening before; a second ask narrows again, half as much.
func _test_trial_days() -> void:
	var k: Dictionary = K.fresh(301)
	k["ceil_hw"] = 14.0
	var b0: float = K.width(k, "body")
	var s0: float = K.width(k, "skills")
	var paid := KR.apply_trial_day(k, "body")
	var b1: float = K.width(k, "body")
	_check(paid == 36 and b1 < b0 and absf(K.width(k, "skills") - s0) < 0.0001, "trial day body: body narrows, skills untouched, $36")
	KR.apply_trial_day(k, "body")
	var b2: float = K.width(k, "body")
	_check(b2 < b1 and (b1 - b2) < (b0 - b1), "trial day body again: narrows again, less than the first ask")
	KR.apply_trial_day(k, "skills")
	_check(K.width(k, "skills") < s0, "trial day skills: skills narrow")
	KR.apply_trial_day(k, "pads")
	_check(absf(float(k["ceil_hw"]) - 7.0) < 0.0001, "the pad test halves the ceiling's range (14 -> 7)")
	KR.apply_trial_day(k, "pads")
	_check(absf(float(k["ceil_hw"]) - 5.25) < 0.0001, "a second pad test takes a quarter (7 -> 5.25)")
	var opened := bool(k.get("under_fire_opened", false))
	KR.apply_trial_day(k, "spar")
	var f1: float = K.width(k, "under_fire")
	KR.apply_trial_day(k, "spar")
	_check(not opened and bool(k["under_fire_opened"]) and bool(k.get("pressure_seen", false)) and K.width(k, "under_fire") < f1,
		"the hard spar opens under fire and the pressure trait; a second narrows it")
	_check(int(k["asks"]["body"]) == 2 and KR.least_asked(k) == "skills" and KR.apply_trial_day(k, "nap") == 0, "asks counted; least asked; an unknown question costs nothing")

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
