extends SceneTree
## KNOW1 old checks 10-16 kept (S524): Goose #378 rewrote knowledge_test.gd for v3 and dropped these;
## known / share_gone / pip_of / shown / the wrong-measure control still exist in Knowledge.gd.

const K := preload("res://scripts/rules/Knowledge.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

var failures := 0
var n_checks := 0


func _initialize() -> void:
	_test10_known_boundary()
	_test11_share_gone_formula()
	_test12_known_fresh_allseen()
	_test13_pip_of()
	_test14_stale_known()
	_test15_shown()
	_test16_control_wrong_measure()
	print("KNOWLEDGE_KEEP failures=%d (%d checks)" % [failures, n_checks])
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	n_checks += 1
	if ok:
		pass
	else:
		failures += 1
		print("FAIL " + label)


func _all_attrs() -> Array:
	var out: Array = []
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		out.append(a)
	return out


# --- 10. Known boundary tests ---
func _test10_known_boundary() -> void:
	# 10a Body: 17.9 -> known false, 18.0 -> known true
	var k_a: Dictionary = K.fresh(101)
	K.expose(k_a, "body", 17.9, "session")
	var body_17_9: bool = K.known(k_a, "body")
	K.expose(k_a, "body", 0.1, "session")
	var body_18_0: bool = K.known(k_a, "body")
	_check(not body_17_9 and body_18_0, "10a. body: 17.9 not known, 18.0 known")
	# 10b Skills: same
	var k_b: Dictionary = K.fresh(102)
	K.expose(k_b, "skills", 17.9, "session")
	var skills_17_9: bool = K.known(k_b, "skills")
	K.expose(k_b, "skills", 0.1, "session")
	var skills_18_0: bool = K.known(k_b, "skills")
	_check(not skills_17_9 and skills_18_0, "10b. skills: 17.9 not known, 18.0 known")
	# 10c Fire: 500 spar only -> known false
	var k_c: Dictionary = K.fresh(103)
	K.expose(k_c, "fire", 500.0, "spar")
	var fire_spar_only: bool = K.known(k_c, "fire")
	_check(not fire_spar_only, "10c. fire: 500 spar alone not known")
	# 10d Fire: 12.5 spar + 5.5 bout -> known true; 12.5 spar + 5.4 bout -> false
	var k_d1: Dictionary = K.fresh(104)
	K.expose(k_d1, "fire", 12.5, "spar")
	K.expose(k_d1, "fire", 5.5, "bout")
	var fire_5_5: bool = K.known(k_d1, "fire")
	var k_d2: Dictionary = K.fresh(105)
	K.expose(k_d2, "fire", 12.5, "spar")
	K.expose(k_d2, "fire", 5.4, "bout")
	var fire_5_4: bool = K.known(k_d2, "fire")
	_check(fire_5_5 and not fire_5_4, "10d. fire: 12.5 spar + 5.5 bout known, + 5.4 not")


# --- 11. share_gone equals e / (e + 12) within 0.0001 ---
func _test11_share_gone_formula() -> void:
	var ok := true
	var prev_body: float = -1.0
	var prev_skills: float = -1.0
	var e: float = 0.0
	while e <= 100.0:
		# Body
		var k_body: Dictionary = K.fresh(201)
		K.expose(k_body, "body", e, "session")
		var sg_body: float = K.share_gone(k_body, "body")
		var expected_body: float = e / (e + 12.0)
		if absf(sg_body - expected_body) > 0.0001:
			ok = false
			break
		if sg_body < prev_body - 0.0001:
			ok = false
			break
		prev_body = sg_body
		# Skills
		var k_skills: Dictionary = K.fresh(202)
		K.expose(k_skills, "skills", e, "session")
		var sg_skills: float = K.share_gone(k_skills, "skills")
		var expected_skills: float = e / (e + 12.0)
		if absf(sg_skills - expected_skills) > 0.0001:
			ok = false
			break
		if sg_skills < prev_skills - 0.0001:
			ok = false
			break
		prev_skills = sg_skills
		e += 0.5
	_check(ok, "11. share_gone equals e/(e+12) within 0.0001, never falls")


# --- 12. Known: fresh false for all three; all_seen true for all three ---
func _test12_known_fresh_allseen() -> void:
	var k_fresh: Dictionary = K.fresh(301)
	var fresh_body: bool = K.known(k_fresh, "body")
	var fresh_skills: bool = K.known(k_fresh, "skills")
	var fresh_fire: bool = K.known(k_fresh, "fire")
	var fresh_potential: bool = K.known(k_fresh, "potential")
	var k_all: Dictionary = K.all_seen()
	var all_body: bool = K.known(k_all, "body")
	var all_skills: bool = K.known(k_all, "skills")
	var all_fire: bool = K.known(k_all, "fire")
	var all_potential: bool = K.known(k_all, "potential")
	var sg_all_body: float = K.share_gone(k_all, "body")
	var ok := not fresh_body and not fresh_skills and not fresh_fire and not fresh_potential
	ok = ok and all_body and all_skills and all_fire and not all_potential
	ok = ok and absf(sg_all_body - 1.0) < 0.0001
	var sg_all_skills: float = K.share_gone(k_all, "skills")   # S434 collect: all three groups, as the brief says
	var sg_all_fire: float = K.share_gone(k_all, "fire")
	ok = ok and absf(sg_all_skills - 1.0) < 0.0001 and absf(sg_all_fire - 1.0) < 0.0001
	_check(ok, "12. fresh: all false; all_seen: all true, share_gone 1.0; potential false")


# --- 13. pip_of tests ---
func _test13_pip_of() -> void:
	# 13a: all three groups at exposure 3, 8, 18, 36, 60 -> pip_of 1, 2, 3, 4, 5
	var exposures: Array[float] = [3.0, 8.0, 18.0, 36.0, 60.0]
	var expected_pips: Array[int] = [1, 2, 3, 4, 5]
	var ok_a := true
	for i in exposures.size():
		var exp_val: float = exposures[i]
		var k_pip: Dictionary = K.fresh(400 + i)
		K.expose(k_pip, "body", exp_val, "session")
		K.expose(k_pip, "skills", exp_val, "session")
		K.expose(k_pip, "fire", exp_val, "bout")
		var pip: int = K.pip_of(k_pip)
		if pip != expected_pips[i]:
			ok_a = false
			break
		# Minus 0.05 -> one less
		var k_minus: Dictionary = K.fresh(410 + i)
		K.expose(k_minus, "body", exp_val - 0.05, "session")
		K.expose(k_minus, "skills", exp_val - 0.05, "session")
		K.expose(k_minus, "fire", exp_val - 0.05, "bout")
		var pip_minus: int = K.pip_of(k_minus)
		if pip_minus != expected_pips[i] - 1:
			ok_a = false
			break
	_check(ok_a, "13a. pip_of at exposures 3/8/18/36/60 -> 1/2/3/4/5; minus 0.05 -> one less")
	# 13b: fresh -> 0, all_seen -> 5
	var k_fresh_pip: Dictionary = K.fresh(420)
	var k_all_pip: Dictionary = K.all_seen()
	var pip_fresh: int = K.pip_of(k_fresh_pip)
	var pip_all: int = K.pip_of(k_all_pip)
	_check(pip_fresh == 0 and pip_all == 5, "13b. fresh -> pip 0, all_seen -> pip 5")
	# 13c: body 18, skills 18, fire 0 -> pip_of 2 (average share_gone = 0.4)
	var k_c: Dictionary = K.fresh(430)
	K.expose(k_c, "body", 18.0, "session")
	K.expose(k_c, "skills", 18.0, "session")
	var pip_c: int = K.pip_of(k_c)
	_check(pip_c == 2, "13c. body 18, skills 18, fire 0 -> pip 2")


# --- 14. Stale cuts fire below known ---
func _test14_stale_known() -> void:
	var k: Dictionary = K.fresh(501)
	K.expose(k, "fire", 18.0, "bout")
	K.expose(k, "body", 18.0, "session")
	var fire_before: bool = K.known(k, "fire")
	var body_before: bool = K.known(k, "body")
	K.stale(k, "knockout")
	var fire_after: bool = K.known(k, "fire")
	var body_after: bool = K.known(k, "body")
	_check(fire_before and body_before and not fire_after and body_after, "14. stale knockout: fire not known, body still known")


# --- 15. shown tests ---
func _test15_shown() -> void:
	# 15a: known group -> exact values
	var ok_a := true
	var truths: Array[float] = [0.0, 37.5, 100.0]
	for truth in truths:
		var k: Dictionary = K.fresh(601)
		K.expose(k, "body", 18.0, "session")
		var s: Dictionary = K.shown(k, "strength", truth)
		if absf(float(s["lo"]) - truth) > 0.0001 or absf(float(s["hi"]) - truth) > 0.0001:
			ok_a = false
			break
		if absf(float(s["centre"]) - truth) > 0.0001 or absf(float(s["width"])) > 0.0001:
			ok_a = false
			break
		if s["known"] != true:
			ok_a = false
			break
	_check(ok_a, "15a. shown: known group gives exact values (truths 0, 37.5, 100)")
	# 15b: open group -> equals range_of
	var ok_b := true
	var k_open: Dictionary = K.fresh(602)
	K.expose(k_open, "body", 5.0, "session")
	var hype_vals: Array[float] = [0.0, 0.7]
	for hype in hype_vals:
		var s_open: Dictionary = K.shown(k_open, "strength", 50.0, hype)
		var r: Dictionary = K.range_of(k_open, "strength", 50.0, hype)
		if absf(float(s_open["lo"]) - float(r["lo"])) > 0.0001:
			ok_b = false
			break
		if absf(float(s_open["hi"]) - float(r["hi"])) > 0.0001:
			ok_b = false
			break
		if absf(float(s_open["centre"]) - float(r["centre"])) > 0.0001:
			ok_b = false
			break
		if absf(float(s_open["width"]) - float(r["width"])) > 0.0001:
			ok_b = false
			break
		if s_open["known"] != false:
			ok_b = false
			break
	_check(ok_b, "15b. shown: open group equals range_of (hype 0.0, 0.7)")


# --- 16. Control: wrong measure vs share_gone ---
func _test16_control_wrong_measure() -> void:
	# Body at exposure 18: wrong measure (start - width) / start = 0.5625 < 0.6
	# share_gone uses (start - FLOOR - (width - FLOOR)) / (start - FLOOR) = 0.6 exactly
	var k: Dictionary = K.fresh(701)
	K.expose(k, "body", 18.0, "session")
	var w: float = K.width(k, "body")
	var wrong_measure: float = (K.BODY_START - w) / K.BODY_START
	var sg: float = K.share_gone(k, "body")
	var wrong_says_not_known: bool = wrong_measure < 0.6
	var sg_says_known: bool = sg >= 0.6 - 0.0001
	_check(wrong_says_not_known and sg_says_known, "16. control: wrong measure says not known, share_gone says known")

