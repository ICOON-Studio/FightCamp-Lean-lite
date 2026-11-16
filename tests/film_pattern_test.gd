extends SceneTree
## FILMPATTERN1 test - the film game's rules: what can be marked, the coach's check,
## the words and figures, which claim finds which tell.

const FP := preload("res://scripts/rules/FilmPattern.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_claims()
	_test_checks()
	_test_after_moment()
	_test_throws_fewer()
	_test_outlanded()
	_test_pool()
	_test_report_game()
	_test_report_weapon()
	_test_figure()
	_test_word_text()
	_test_matches()
	_test_noise_rate()
	print("FILM_PATTERN failures=%d noise_avg=%.4f noise_worst=%.4f" % [failures, _noise_avg, _noise_worst])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


# ---------- claims ----------

func _test_claims() -> void:
	var c := FP.claims()
	_check(c.size() == 72, "claims has 72 pairs (9 x 8)")
	# unique pairs
	var seen := {}
	var dupes := 0
	for pair in c:
		var key: String = "%s->%s" % [str(pair["when"]), str(pair["then"])]
		if seen.has(key):
			dupes += 1
		seen[key] = true
	_check(dupes == 0, "all 72 pairs are unique")
	# first and last
	var first: Dictionary = c[0]
	_check(first["when"] == "jab" and first["then"] == "right_low", "first claim: jab -> right_low")
	_check(first["words"] == "their jab -> right hand low", "first claim words")
	var last: Dictionary = c[71]
	_check(last["when"] == "walked" and last["then"] == "outlanded", "last claim: walked -> outlanded")


# ---------- checks ----------

func _test_checks() -> void:
	# No coach: 2 checks
	_check(FP.checks(50, false, 0, 4) == 2, "no coach: 2 checks")
	# Rating < 60: 2 checks
	_check(FP.checks(50, true, 0, 4) == 2, "rating < 60: 2 checks")
	# Rating 60-79: 3 checks
	_check(FP.checks(60, true, 0, 4) == 3, "rating 60: 3 checks")
	_check(FP.checks(79, true, 0, 4) == 3, "rating 79: 3 checks")
	# Rating 80+: 4 checks
	_check(FP.checks(80, true, 0, 4) == 4, "rating 80: 4 checks")
	_check(FP.checks(100, true, 0, 4) == 4, "rating 100: 4 checks")
	# Cap: 2 x opp_films - used_on_opp
	_check(FP.checks(100, true, 0, 2) == 4, "cap: 4 films, 0 used, rating 100 -> 4 (min(4, 4))")
	_check(FP.checks(100, true, 0, 1) == 2, "cap: 1 film, 0 used, rating 100 -> 2 (min(4, 2))")
	_check(FP.checks(100, true, 3, 4) == 4, "cap: 4 films, 3 used, rating 100 -> min(4, 5) = 4")
	_check(FP.checks(100, true, 7, 4) == 1, "cap: 4 films, 7 used -> min(4, 1) = 1")
	_check(FP.checks(100, true, 8, 4) == 0, "cap: 4 films, 8 used -> min(4, 0) = 0")
	_check(FP.checks(100, true, 10, 4) == 0, "cap: 4 films, 10 used -> never below 0")
	_check(FP.checks(50, true, 0, 0) == 0, "0 films: 0 checks")


# ---------- after_moment ----------

func _test_after_moment() -> void:
	# PASS case: k=8, n=25, rest_k=5, rest_n=150
	# rate_rest = 5/150 = 0.0333; E = 25 * 0.0333 = 0.8333
	# spread = sqrt(0.8333 + 0.8333*25/150) = sqrt(0.8333 + 0.1389) = sqrt(0.9722) = 0.9860
	# z = (8 - 0.8333) / 0.9860 = 7.268 -> pass (k>=3, z>=2.33)
	var r1 := FP.after_moment(8, 25, 5, 150)
	_check(r1["word"] == "pass", "after_moment pass: k=8,n=25,rest_k=5,rest_n=150")
	_check(int(r1["k"]) == 8, "after_moment pass: k=8")
	_check(int(r1["n"]) == 25, "after_moment pass: n=25")

	# MAYBE case: k=4, n=20, rest_k=10, rest_n=100
	# rate_rest = 10/100 = 0.1; E = 20 * 0.1 = 2.0
	# spread = sqrt(2.0 + 2.0*20/100) = sqrt(2.0 + 0.4) = sqrt(2.4) = 1.5492
	# z = (4 - 2.0) / 1.5492 = 1.291 -> maybe (k>=2, z>=1.28)
	var r2 := FP.after_moment(4, 20, 10, 100)
	_check(r2["word"] == "maybe", "after_moment maybe: k=4,n=20,rest_k=10,rest_n=100")

	# NOTHING case: k=2, n=20, rest_k=10, rest_n=100
	# same E and spread as above; z = (2 - 2.0) / 1.5492 = 0.0 -> nothing
	var r3 := FP.after_moment(2, 20, 10, 100)
	_check(r3["word"] == "nothing", "after_moment nothing: k=2,n=20,rest_k=10,rest_n=100")

	# NOT_ENOUGH: n < 3
	var r4 := FP.after_moment(100, 2, 5, 150)
	_check(r4["word"] == "not_enough", "after_moment not_enough: n=2")

	# rest_n = 0 (no division by zero)
	# rate_rest = 5 / max(0,1) = 5.0; E = 10 * 5.0 = 50.0
	# spread = sqrt(50 + 50*10/1) = sqrt(550) = 23.45
	# z = (5 - 50) / 23.45 = -1.919 -> nothing
	var r5 := FP.after_moment(5, 10, 5, 0)
	_check(r5["word"] == "nothing", "after_moment rest_n=0: no division by zero")

	# Huge z but n < 3 -> not_enough
	var r6 := FP.after_moment(100, 1, 0, 100)
	_check(r6["word"] == "not_enough", "after_moment huge z but n=1 -> not_enough")


# ---------- throws_fewer ----------

func _test_throws_fewer() -> void:
	# PASS: inside=5, inside_min=2.0, outside=40, outside_min=8.0, slowdown=0.8
	# E = (40/8.0) * 2.0 * 0.8 = 5.0 * 2.0 * 0.8 = 8.0
	# spread = sqrt(8.0 + 64.0/40) = sqrt(8.0 + 1.6) = sqrt(9.6) = 3.098
	# z = (8.0 - 5) / 3.098 = 0.968... wait, DOWNWARDS z = (E - inside) / spread
	# z = (8.0 - 5) / 3.098 = 0.968 -> not pass
	# Let me recalculate for a clear pass:
	# inside=2, inside_min=2.0, outside=50, outside_min=5.0, slowdown=0.9
	# E = (50/5.0) * 2.0 * 0.9 = 10.0 * 2.0 * 0.9 = 18.0
	# spread = sqrt(18.0 + 324.0/50) = sqrt(18.0 + 6.48) = sqrt(24.48) = 4.948
	# k = roundi(18.0 - 2) = 16; z = (18.0 - 2) / 4.948 = 3.234 -> pass (k>=3, z>=2.33)
	var r1 := FP.throws_fewer(2, 2.0, 50, 5.0, 0.9)
	_check(r1["word"] == "pass", "throws_fewer pass: inside=2, outside=50")

	# MAYBE: inside=10, inside_min=3.0, outside=30, outside_min=5.0, slowdown=0.9
	# E = (30/5.0) * 3.0 * 0.9 = 6.0 * 3.0 * 0.9 = 16.2
	# spread = sqrt(16.2 + 262.44/30) = sqrt(16.2 + 8.748) = sqrt(24.948) = 4.995
	# k = roundi(16.2 - 10) = 6; z = (16.2 - 10) / 4.995 = 1.241 -> not maybe (z < 1.28)
	# Try: inside=11, inside_min=3.0, outside=30, outside_min=5.0, slowdown=0.9
	# E = 16.2; spread = sqrt(16.2 + 262.44/30) = 4.995
	# k = roundi(16.2 - 11) = 5; z = (16.2 - 11) / 4.995 = 1.041 -> nothing
	# Try: inside=12, inside_min=4.0, outside=40, outside_min=5.0, slowdown=0.9
	# E = (40/5.0) * 4.0 * 0.9 = 8.0 * 4.0 * 0.9 = 28.8
	# spread = sqrt(28.8 + 829.44/40) = sqrt(28.8 + 20.736) = sqrt(49.536) = 7.038
	# k = roundi(28.8 - 12) = 17; z = (28.8 - 12) / 7.038 = 2.387 -> pass
	# For maybe: inside=14, inside_min=3.0, outside=30, outside_min=5.0, slowdown=0.9
	# E = (30/5.0) * 3.0 * 0.9 = 16.2
	# spread = sqrt(16.2 + 262.44/30) = sqrt(24.948) = 4.995
	# k = roundi(16.2 - 14) = 2; z = (16.2 - 14) / 4.995 = 0.440 -> nothing
	# For maybe: inside=13, inside_min=3.5, outside=35, outside_min=5.0, slowdown=0.9
	# E = (35/5.0) * 3.5 * 0.9 = 7.0 * 3.5 * 0.9 = 22.05
	# spread = sqrt(22.05 + 486.2025/35) = sqrt(22.05 + 13.891) = sqrt(35.941) = 5.995
	# k = roundi(22.05 - 13) = 9; z = (22.05 - 13) / 5.995 = 1.510 -> maybe (k>=2, z>=1.28)
	var r2 := FP.throws_fewer(13, 3.5, 35, 5.0, 0.9)
	_check(r2["word"] == "maybe", "throws_fewer maybe: inside=13, outside=35")

	# NOTHING: inside=20, inside_min=3.0, outside=30, outside_min=5.0, slowdown=0.9
	# E = (30/5.0) * 3.0 * 0.9 = 16.2
	# spread = sqrt(16.2 + 262.44/30) = sqrt(24.948) = 4.995
	# k = roundi(16.2 - 20) = -4 -> negative, nothing
	var r3 := FP.throws_fewer(20, 3.0, 30, 5.0, 0.9)
	_check(r3["word"] == "nothing", "throws_fewer nothing: inside=20, outside=30")

	# NOT_ENOUGH: n < 3
	var r4 := FP.throws_fewer(1, 2.0, 1, 5.0, 0.9)
	_check(r4["word"] == "not_enough", "throws_fewer not_enough: n=2")


# ---------- outlanded ----------

func _test_outlanded() -> void:
	# PASS: in_landed=20, in_min=3.0, out_landed=5, out_min=5.0
	# E = (5/5.0) * 3.0 = 3.0
	# spread = sqrt(3.0 + 9.0/5) = sqrt(3.0 + 1.8) = sqrt(4.8) = 2.191
	# k = roundi(20 - 3.0) = 17; z = (20 - 3.0) / 2.191 = 7.759 -> pass
	var r1 := FP.outlanded(20, 3.0, 5, 5.0)
	_check(r1["word"] == "pass", "outlanded pass: in=20, out=5")

	# MAYBE: in_landed=8, in_min=3.0, out_landed=5, out_min=5.0
	# E = (5/5.0) * 3.0 = 3.0
	# spread = sqrt(3.0 + 9.0/5) = sqrt(4.8) = 2.191
	# k = roundi(8 - 3.0) = 5; z = (8 - 3.0) / 2.191 = 2.282 -> not pass (z < 2.33)
	# but k>=2, z>=1.28 -> maybe
	var r2 := FP.outlanded(8, 3.0, 5, 5.0)
	_check(r2["word"] == "maybe", "outlanded maybe: in=8, out=5")

	# NOTHING: in_landed=3, in_min=3.0, out_landed=5, out_min=5.0
	# E = 3.0; spread = 2.191
	# k = roundi(3 - 3.0) = 0; z = (3 - 3.0) / 2.191 = 0.0 -> nothing
	var r3 := FP.outlanded(3, 3.0, 5, 5.0)
	_check(r3["word"] == "nothing", "outlanded nothing: in=3, out=5")

	# NOT_ENOUGH: n < 3
	var r4 := FP.outlanded(1, 3.0, 1, 5.0)
	_check(r4["word"] == "not_enough", "outlanded not_enough: n=2")


# ---------- pool ----------

func _test_pool() -> void:
	var a := {"k": 5, "n": 20, "rest_k": 10, "rest_n": 100, "label": "film1"}
	var b := {"k": 3, "n": 15, "rest_k": 8, "rest_n": 120, "label": "film2"}
	var p := FP.pool(a, b)
	_check(int(p["k"]) == 8, "pool: k adds (5+3=8)")
	_check(int(p["n"]) == 35, "pool: n adds (20+15=35)")
	_check(int(p["rest_k"]) == 18, "pool: rest_k adds (10+8=18)")
	_check(int(p["rest_n"]) == 220, "pool: rest_n adds (100+120=220)")
	_check(str(p["label"]) == "film1", "pool: label from a")


# ---------- report_game ----------

func _test_report_game() -> void:
	# Share >= 0.40 -> pass
	var r1 := FP.report_game({"press": 12, "range": 4, "counter": 2})
	_check(r1["word"] == "pass", "report_game pass: press=12/18=0.667")
	_check(str(r1["game"]) == "press", "report_game: game=press")

	# Share < 0.40 -> nothing
	var r2 := FP.report_game({"press": 5, "range": 5, "counter": 5, "loadup": 3})
	_check(r2["word"] == "nothing", "report_game nothing: max=5/18=0.278")

	# Edge: exactly 0.40 -> pass
	# 4 out of 10 = 0.40
	var r3 := FP.report_game({"press": 4, "range": 2, "counter": 2, "loadup": 2})
	_check(r3["word"] == "pass", "report_game pass at 0.40: 4/10=0.40")

	# Edge: just below 0.40
	# 3 out of 8 = 0.375
	var r4 := FP.report_game({"press": 3, "range": 2, "counter": 2, "loadup": 1})
	_check(r4["word"] == "nothing", "report_game nothing at 0.375: 3/8")


# ---------- report_weapon ----------

func _test_report_weapon() -> void:
	# 3 clean, strictly most -> pass
	var r1 := FP.report_weapon({"jab": 3, "cross": 2, "hook": 1})
	_check(r1["word"] == "pass", "report_weapon pass: jab=3 strictly most")
	_check(str(r1["punch"]) == "jab", "report_weapon: punch=jab")

	# Tie -> nothing
	var r2 := FP.report_weapon({"jab": 3, "cross": 3, "hook": 1})
	_check(r2["word"] == "nothing", "report_weapon nothing: tie jab=cross=3")

	# 2 clean -> nothing (< 3)
	var r3 := FP.report_weapon({"jab": 2, "cross": 1})
	_check(r3["word"] == "nothing", "report_weapon nothing: max=2 < 3")

	# 3 but tied with second -> nothing
	var r4 := FP.report_weapon({"jab": 3, "cross": 3})
	_check(r4["word"] == "nothing", "report_weapon nothing: 3 tied with 3")


# ---------- figure ----------

func _test_figure() -> void:
	# pass, one film -> 0.70
	_check(FP.figure("pass", 1, false) == 0.70, "figure pass 1 film = 0.70")
	# pass, two films -> 0.85
	_check(FP.figure("pass", 2, false) == 0.85, "figure pass 2 films = 0.85")
	# maybe, one film -> 0.30
	_check(FP.figure("maybe", 1, false) == 0.30, "figure maybe 1 film = 0.30")
	# maybe, two films -> 0.20
	_check(FP.figure("maybe", 2, false) == 0.20, "figure maybe 2 films = 0.20")
	# alone, pass -> 0.30
	_check(FP.figure("pass", 1, true) == 0.30, "figure alone pass = 0.30")
	# alone, maybe -> 0.0
	_check(FP.figure("maybe", 1, true) == 0.0, "figure alone maybe = 0.0")
	# nothing -> 0.0
	_check(FP.figure("nothing", 1, false) == 0.0, "figure nothing = 0.0")
	# not_enough -> 0.0
	_check(FP.figure("not_enough", 1, false) == 0.0, "figure not_enough = 0.0")
	# alone, nothing -> 0.0
	_check(FP.figure("nothing", 1, true) == 0.0, "figure alone nothing = 0.0")


# ---------- word_text ----------

func _test_word_text() -> void:
	_check(FP.word_text("pass", "her") == "That's it" and FP.word_text("pass", "him") == "That's it", "word_text pass: no her/him")
	_check(FP.word_text("maybe", "her") == "Maybe", "word_text maybe")
	_check(FP.word_text("not_enough", "him") == "Not enough moments", "word_text not_enough")
	_check(FP.word_text("nothing", "her") == "Nothing there", "word_text nothing")


# ---------- matches ----------

func _test_matches() -> void:
	var habits := ["drops_right_after_jab", "lunges_with_jab", "admires_her_work",
		"digs_body_when_hurt", "loads_up_when_hurt", "fades_late", "slow_starter"]
	var weak := "fades in the last round, slow to start, chin, body shots hurt, backed up"

	# jab + right_low with habit -> habit:drops_right_after_jab
	_check(FP.matches(habits, weak, {"when": "jab", "then": "right_low"}) == "habit:drops_right_after_jab",
		"matches: jab+right_low with habit")
	# jab + right_low without habit -> ""
	_check(FP.matches([], weak, {"when": "jab", "then": "right_low"}) == "",
		"matches: jab+right_low without habit")

	# jab + lunged with habit
	_check(FP.matches(habits, weak, {"when": "jab", "then": "lunged"}) == "habit:lunges_with_jab",
		"matches: jab+lunged with habit")
	_check(FP.matches([], weak, {"when": "jab", "then": "lunged"}) == "",
		"matches: jab+lunged without habit")

	# combo + stood with habit
	_check(FP.matches(habits, weak, {"when": "combo", "then": "stood"}) == "habit:admires_her_work",
		"matches: combo+stood with habit")
	_check(FP.matches([], weak, {"when": "combo", "then": "stood"}) == "",
		"matches: combo+stood without habit")

	# hurt + to_body with habit
	_check(FP.matches(habits, weak, {"when": "hurt", "then": "to_body"}) == "habit:digs_body_when_hurt",
		"matches: hurt+to_body with habit")
	_check(FP.matches([], weak, {"when": "hurt", "then": "to_body"}) == "",
		"matches: hurt+to_body without habit")

	# hurt + wild with habit
	_check(FP.matches(habits, weak, {"when": "hurt", "then": "wild"}) == "habit:loads_up_when_hurt",
		"matches: hurt+wild with habit")
	_check(FP.matches([], weak, {"when": "hurt", "then": "wild"}) == "",
		"matches: hurt+wild without habit")

	# last_min + fewer with habit -> habit:fades_late
	_check(FP.matches(habits, weak, {"when": "last_min", "then": "fewer"}) == "habit:fades_late",
		"matches: last_min+fewer with habit")
	# last_min + fewer without habit but weak has "fade"
	_check(FP.matches([], weak, {"when": "last_min", "then": "fewer"}) == "weakness",
		"matches: last_min+fewer without habit, weak has 'fade'")
	# last_min + fewer without habit and no matching weak
	_check(FP.matches([], "chin", {"when": "last_min", "then": "fewer"}) == "",
		"matches: last_min+fewer without habit, no matching weak")

	# round1 + fewer with habit -> habit:slow_starter
	_check(FP.matches(habits, weak, {"when": "round1", "then": "fewer"}) == "habit:slow_starter",
		"matches: round1+fewer with habit")
	# round1 + fewer without habit but weak has "slow to start"
	_check(FP.matches([], weak, {"when": "round1", "then": "fewer"}) == "weakness",
		"matches: round1+fewer without habit, weak has 'slow to start'")
	# round1 + fewer without habit and no matching weak
	_check(FP.matches([], "chin", {"when": "round1", "then": "fewer"}) == "",
		"matches: round1+fewer without habit, no matching weak")

	# after_body + fewer with weak "body"
	_check(FP.matches([], weak, {"when": "after_body", "then": "fewer"}) == "weakness",
		"matches: after_body+fewer with weak 'body'")
	_check(FP.matches([], "chin", {"when": "after_body", "then": "fewer"}) == "",
		"matches: after_body+fewer without weak 'body'")

	# walked + outlanded with weak "backed up"
	_check(FP.matches([], weak, {"when": "walked", "then": "outlanded"}) == "weakness",
		"matches: walked+outlanded with weak 'backed up'")
	# walked + outlanded with weak "pressure"
	_check(FP.matches([], "pressure fighter", {"when": "walked", "then": "outlanded"}) == "weakness",
		"matches: walked+outlanded with weak 'pressure'")
	# walked + outlanded with weak "backs straight"
	_check(FP.matches([], "backs straight", {"when": "walked", "then": "outlanded"}) == "weakness",
		"matches: walked+outlanded with weak 'backs straight'")
	_check(FP.matches([], "chin", {"when": "walked", "then": "outlanded"}) == "",
		"matches: walked+outlanded without matching weak")

	# 10 noise claims -> ""
	var noise_claims := [
		{"when": "jab", "then": "stood"},
		{"when": "jab", "then": "to_body"},
		{"when": "jab", "then": "wild"},
		{"when": "cross", "then": "right_low"},
		{"when": "cross", "then": "lunged"},
		{"when": "hook", "then": "right_low"},
		{"when": "hook", "then": "stood"},
		{"when": "combo", "then": "right_low"},
		{"when": "combo", "then": "lunged"},
		{"when": "hurt", "then": "right_low"},
	]
	var noise_ok := true
	for nc in noise_claims:
		if FP.matches(habits, weak, nc) != "":
			noise_ok = false
	_check(noise_ok, "matches: 10 noise claims all return ''")


# ---------- noise rate ----------

var _noise_avg: float = 0.0
var _noise_worst: float = 0.0

func _test_noise_rate() -> void:
	# Seeded RNG, 1000 films per claim, for each after-moment claim with NO true tell.
	# n ~ 25-35 moments, rest_n ~ 120-160, fact base rate 0.10-0.25 drawn per film,
	# k and rest_k each binomial at that same rate (draw per moment).
	# Count passes. Assert avg pass rate < 0.03 and worst < 0.08.

	var rng := RandomNumberGenerator.new()
	rng.seed = 495

	# The 63 noise claims: all 72 minus the 9 true ones
	var true_pairs := [
		["jab", "right_low"], ["jab", "lunged"], ["combo", "stood"],
		["hurt", "to_body"], ["hurt", "wild"], ["last_min", "fewer"],
		["round1", "fewer"], ["after_body", "fewer"], ["walked", "outlanded"]]
	var noise_claims: Array = []
	for w in FP.WHEN_IDS:
		for t in FP.THEN_IDS:
			var is_true := false
			for tp in true_pairs:
				if str(tp[0]) == str(w) and str(tp[1]) == str(t):
					is_true = true
					break
			if not is_true:
				noise_claims.append({"when": str(w), "then": str(t)})

	_check(noise_claims.size() == 63, "noise: 63 noise claims (72 - 9 true)")

	var total_pass_rate: float = 0.0
	var worst_pass_rate: float = 0.0
	var films_per_claim := 1000

	for claim in noise_claims:
		var pass_count := 0
		for _film_idx in films_per_claim:
			# n ~ 25-35, rest_n ~ 120-160
			var n: int = 25 + rng.randi_range(0, 10)
			var rest_n: int = 120 + rng.randi_range(0, 40)
			# base rate 0.10-0.25
			var base_rate: float = 0.10 + rng.randf() * 0.15
			# k: binomial(n, base_rate) - draw per moment
			var k := 0
			for _i in n:
				if rng.randf() < base_rate:
					k += 1
			# rest_k: binomial(rest_n, base_rate)
			var rest_k := 0
			for _i in rest_n:
				if rng.randf() < base_rate:
					rest_k += 1
			var result := FP.after_moment(k, n, rest_k, rest_n)
			if str(result["word"]) == "pass":
				pass_count += 1
		var rate: float = float(pass_count) / float(films_per_claim)
		total_pass_rate += rate
		if rate > worst_pass_rate:
			worst_pass_rate = rate

	_noise_avg = total_pass_rate / float(noise_claims.size())
	_noise_worst = worst_pass_rate

	_check(_noise_avg < 0.03, "noise avg pass rate < 0.03 (got %.4f)" % _noise_avg)
	_check(_noise_worst < 0.08, "noise worst pass rate < 0.08 (got %.4f)" % _noise_worst)
