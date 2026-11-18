extends SceneTree
## COACHROLES1: CoachRoles tests - R13's class table night by night, the clamp, the runway and its hire bands, R8's
## promotion ceiling, R4/R15's held nights. Every rule is a CHECK function run on the real module and on runtime
## MUTANTS of its source (CoachRoles.gd with one line changed, compiled here): the real module must pass, every mutant
## must fail - an assert that cannot go red is not a test.
## Map: ops/research/DESIGN_COACHSPEC1_R6_DOLA.md 1092-1177; ROWS below is that table written out as the reference.
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/coach_roles_test.gd

const CoachRoles := preload("res://scripts/rules/CoachRoles.gd")
const SRC := "res://scripts/rules/CoachRoles.gd"

## R13's four rows (map 1098-1101): [Mon, Wed, Fri] pad minutes, total minutes, drill units, class income.
const ROWS := [
	{"nights": [105, 105, 75], "pad_min": 285, "pad_units": 912, "class_pay": 0},
	{"nights": [105, 75, 75], "pad_min": 255, "pad_units": 816, "class_pay": 175},
	{"nights": [75, 75, 75], "pad_min": 225, "pad_units": 720, "class_pay": 350},
	{"nights": [75, 75, 45], "pad_min": 195, "pad_units": 624, "class_pay": 525},
]
## R8's ceilings, written out independently of the module: a coach signs below their own belt, brown signs purple,
## a black belt's 1st degree signs brown and only the 2nd degree+ signs black.
const CEILING := {"white": 0, "blue": 1, "purple": 2, "brown": 2, "black": 3}
const BELTS := ["white", "blue", "purple", "brown", "black"]
const TAPER := "Taper week: athlete needs rest"

var failures := 0


func _initialize() -> void:
	var real: GDScript = CoachRoles
	var checks := ["_check_class_rows", "_check_class_clamp", "_check_class_pill", "_check_runway", "_check_hire_bands",
		"_check_promote", "_check_academy", "_check_held", "_check_held_allowed"]
	for ck in checks:
		var bad: Array = call(ck, real)
		for b in bad:
			_fail("%s: %s" % [ck, b])
	# Mutants: [what, old line, new line, the check that must go red].
	var mutants := [
		["the freed minutes spread over all three nights", "for i in range(CLASS_DEFAULT - n):", "for i in range(3):",
			"_check_class_rows"],
		["the third class cuts Friday under the 45 floor",
			"nights[2] = maxi(PAD_MIN_FLOOR, PAD_BASE_MIN - CLASS_MIN * (n - CLASS_DEFAULT))",
			"nights[2] = PAD_BASE_MIN - CLASS_MIN * (n - CLASS_DEFAULT)", "_check_class_rows"],
		["one class pays the whole evening's $350", "const CLASS_PAY := 175", "const CLASS_PAY := 350",
			"_check_class_rows"],
		["the pill shows with no class to drop", "if class_nights <= 0:", "if class_nights < 0:", "_check_class_pill"],
		["the runway rounds up", "return int(floor(cash / -weekly_net))", "return int(ceil(cash / -weekly_net))",
			"_check_runway"],
		["7 weeks reads red, not amber", "if after < RUNWAY_RED:", "if after < RUNWAY_WARN:", "_check_hire_bands"],
		["the hire line forgets the income the coach brings",
			"var after: int = runway(cash, weekly_net - wage_change + income_added)",
			"var after: int = runway(cash, weekly_net - wage_change)", "_check_hire_bands"],
		["the promotion ceiling ignored", "return to <= ceiling", "return to <= coach", "_check_promote"],
		["a black 1st degree signs black", "ceiling = coach if coach_degree >= 2 else coach - 1", "ceiling = coach",
			"_check_promote"],
		["the half night keeps the full mastery", "\"mastery_share\": 0.53", "\"mastery_share\": 1.0", "_check_held"],
		["the held row shared with the caller", "return row.duplicate(true)", "return row", "_check_held"],
		["a second held night allowed", "if held_this_week >= HELD_MAX_A_WEEK:", "if held_this_week >= 2:",
			"_check_held_allowed"],
		["a held night in the fight week", "if fight_week:", "if false:", "_check_held_allowed"],
	]
	for mu in mutants:
		var s := _mutant(str(mu[1]), str(mu[2]))
		if s == null:
			_fail("mutant '%s': the line to change is not in CoachRoles.gd (the test is stale)" % mu[0])
			continue
		var mu_bad: Array = call(str(mu[3]), s)
		if mu_bad.is_empty():
			_fail("mutant '%s' stayed GREEN under %s" % [mu[0], mu[3]])
		else:
			print("  mutant red: %s (%s: %s)" % [mu[0], mu[3], str(mu_bad[0])])
	if failures == 0:
		print("COACH_ROLES PASS")
	else:
		print("COACH_ROLES FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _fail(what: String) -> void:
	failures += 1
	print("  FAIL: " + what)


func _mutant(old: String, new: String) -> GDScript:
	var src := FileAccess.get_file_as_string(SRC)
	if not src.contains(old):
		return null
	var g := GDScript.new()
	g.source_code = src.replace(old, new)
	if g.reload() != OK:
		return null
	return g


## The four rows exactly, the per-night list first: Monday takes the freed minutes, Friday alone loses the third class.
func _check_class_rows(S: GDScript) -> Array:
	var bad: Array = []
	for n in range(4):
		var want: Dictionary = ROWS[n]
		var got: Dictionary = S.call("class_week", n)
		if got.size() != 4:
			bad.append("class_week(%d) keys %s, want nights/pad_min/pad_units/class_pay" % [n, str(got.keys())])
		var nights: Array = got.get("nights", [])
		if nights != want["nights"]:
			bad.append("class_week(%d) nights %s, want %s" % [n, str(nights), str(want["nights"])])
		for key in ["pad_min", "pad_units", "class_pay"]:
			if int(got.get(key, -1)) != int(want[key]):
				bad.append("class_week(%d).%s = %s, want %d" % [n, key, str(got.get(key)), int(want[key])])
	return bad


## Out-of-range class nights clamp to the ends of the table, and the table is not a shared array.
func _check_class_clamp(S: GDScript) -> Array:
	var bad: Array = []
	var low: Dictionary = S.call("class_week", -1)
	if low != ROWS[0]:
		bad.append("class_week(-1) %s, want the 0-class row %s" % [str(low), str(ROWS[0])])
	for over in [4, 5, 99]:
		var hi: Dictionary = S.call("class_week", over)
		if hi != ROWS[3]:
			bad.append("class_week(%d) %s, want the 3-class row %s" % [over, str(hi), str(ROWS[3])])
	var base: Dictionary = S.call("class_week", 2)
	if base != ROWS[2]:
		bad.append("class_week(2) %s after a read of the third class, want the baseline %s" % [str(base), str(ROWS[2])])
	return bad


## R13's pill, word for word, and only when a class can be dropped.
func _check_class_pill(S: GDScript) -> Array:
	var bad: Array = []
	var want := "-1 class -> +60 pad min · -$175/wk ($2.9/min)"
	for n in [1, 2, 3]:
		var pill: String = S.call("class_pill", n)
		if pill != want:
			bad.append("class_pill(%d) '%s', want '%s'" % [n, pill, want])
	for n in [0, -1]:
		var none: String = S.call("class_pill", n)
		if none != "":
			bad.append("class_pill(%d) '%s', want '' (no class left to drop)" % [n, none])
	return bad


## R5: a net that earns its keep is safe, a burn floors to whole weeks, cash already gone is 0.
func _check_runway(S: GDScript) -> Array:
	var bad: Array = []
	var cases := [
		[2000.0, 0.0, 999], [2000.0, 120.0, 999], [0.0, 0.0, 999],
		[2000.0, -140.0, 14], [900.0, -100.0, 9], [800.0, -100.0, 8],
		[100.0, -30.0, 3], [50.0, -100.0, 0], [0.0, -100.0, 0], [-50.0, -100.0, 0],
	]
	for c in cases:
		var weeks: int = S.call("runway", float(c[0]), float(c[1]))
		if weeks != int(c[2]):
			bad.append("runway(%.0f, %.0f) = %d, want %d" % [float(c[0]), float(c[1]), weeks, int(c[2])])
	return bad


## The bands at 9, 7 and 5 weeks after the hire, the before -> after line, and the two routes the map prices: a
## full-time coach lands red but is still hireable, R7's second coach pays for itself and lengthens the runway.
## The warn line is exclusive, as GymBills.status reads it: 8 weeks still ok, 7 amber, 6 amber, 5 red.
func _check_hire_bands(S: GDScript) -> Array:
	var bad: Array = []
	var cases := [[900.0, 9, "ok"], [800.0, 8, "ok"], [700.0, 7, "amber"], [600.0, 6, "amber"],
		[500.0, 5, "red"], [0.0, 0, "red"]]
	for c in cases:
		var line: Dictionary = S.call("hire_line", float(c[0]), -100.0, 0.0, 0.0)
		var weeks: int = int(c[1])
		if int(line.get("after", -1)) != weeks:
			bad.append("hire_line after %s, want %d weeks" % [str(line.get("after")), weeks])
		if int(line.get("before", -1)) != weeks:
			bad.append("hire_line before %s, want %d weeks (no wage change)" % [str(line.get("before")), weeks])
		if str(line.get("band", "")) != str(c[2]):
			bad.append("hire_line at %d weeks band '%s', want '%s'" % [weeks, str(line.get("band")), str(c[2])])
		var want_text := "Runway: %d weeks -> %d weeks" % [weeks, weeks]
		if str(line.get("text", "")) != want_text:
			bad.append("hire_line text '%s', want '%s'" % [str(line.get("text")), want_text])
		if line.size() != 4:
			bad.append("hire_line keys %s, want before/after/band/text - it never blocks a hire" % str(line.keys()))
	var full: Dictionary = S.call("hire_line", 2000.0, -140.0, 640.0, 0.0)
	if int(full.get("before", 0)) != 14 or int(full.get("after", -1)) != 2 or str(full.get("band", "")) != "red":
		bad.append("full-time hire %s, want before 14 after 2 red" % str(full))
	if str(full.get("text", "")) != "Runway: 14 weeks -> 2 weeks":
		bad.append("full-time hire text '%s', want 'Runway: 14 weeks -> 2 weeks'" % str(full.get("text")))
	var second: Dictionary = S.call("hire_line", 2000.0, -140.0, 380.0, 450.0)
	if int(second.get("after", 0)) != 28 or str(second.get("band", "")) != "ok":
		bad.append("second coach %s, want after 28 ok (net -140 - 380 + 450 = -70)" % str(second))
	return bad


## Every coach belt against every belt to sign, at 1st degree, then the black belt's degrees.
func _check_promote(S: GDScript) -> Array:
	var bad: Array = []
	for belt in BELTS:
		bad.append_array(_promote_row(S, str(belt), 1, int(CEILING[str(belt)])))
	for degree in [0, 1, 2, 3, 7]:
		bad.append_array(_promote_row(S, "black", int(degree), 4 if int(degree) >= 2 else 3))
	for to in BELTS:
		if bool(S.call("can_promote", "red", 2, to)):
			bad.append("can_promote(red, 2, %s) is true (a belt that is not one signs nothing)" % to)
		if bool(S.call("can_promote", "", 2, to)):
			bad.append("can_promote('', 2, %s) is true" % to)
	for belt in BELTS:
		if bool(S.call("can_promote", belt, 2, "red")):
			bad.append("can_promote(%s, 2, red) is true" % belt)
		if bool(S.call("can_promote", belt, 2, "")):
			bad.append("can_promote(%s, 2, '') is true" % belt)
	if not bool(S.call("can_promote", "BROWN", 1, "purple")):
		bad.append("can_promote(BROWN, 1, purple) is false (the mat's belt case)")
	if bool(S.call("can_promote", "Brown", 1, "brown")):
		bad.append("can_promote(Brown, 1, brown) is true (a brown belt signs purple only)")
	return bad


func _promote_row(S: GDScript, belt: String, degree: int, ceiling: int) -> Array:
	var bad: Array = []
	for to in BELTS:
		var want: bool = BELTS.find(to) <= ceiling
		var got: bool = S.call("can_promote", belt, degree, to)
		if got != want:
			bad.append("can_promote(%s, %d, %s) = %s, want %s" % [belt, degree, to, str(got), str(want)])
	return bad


## R8's Academy Month: the fee, the weeks away and the button's label word for word.
func _check_academy(S: GDScript) -> Array:
	var bad: Array = []
	var m: Dictionary = S.call("academy_month")
	if int(m.get("fee", 0)) != 450:
		bad.append("academy fee %s, want 450" % str(m.get("fee")))
	if int(m.get("weeks", 0)) != 4:
		bad.append("academy weeks %s, want 4" % str(m.get("weeks")))
	var label := "Academy Month - get promoted · $450 · away 4 weeks"
	if str(m.get("label", "")) != label:
		bad.append("academy label '%s', want '%s'" % [str(m.get("label")), label])
	if m.size() != 3:
		bad.append("academy keys %s, want fee/weeks/label" % str(m.keys()))
	return bad


## R4's full night and R15's half night, every field; an unknown kind holds nothing; the row is the caller's own copy.
func _check_held(S: GDScript) -> Array:
	var bad: Array = []
	var full := {"minutes": 75, "mornings_cost": 2, "load_mult": 1.38, "ratio": "1.3 -> 1.38",
		"risk_mult": 1.4, "mastery_share": 1.0}
	var half := {"minutes": 40, "mornings_cost": 1, "load_mult": 1.34, "ratio": "1.3 -> 1.34",
		"risk_mult": 1.2, "mastery_share": 0.53}
	for row in [["full", full], ["half", half]]:
		var kind: String = str(row[0])
		var want: Dictionary = row[1]
		var got: Dictionary = S.call("held_night", kind)
		if got.size() != want.size():
			bad.append("held_night(%s) keys %s, want %s" % [kind, str(got.keys()), str(want.keys())])
		for key in want:
			if got.get(key) != want[key]:
				bad.append("held_night(%s).%s = %s, want %s" % [kind, key, str(got.get(key)), str(want[key])])
	var unknown: Dictionary = S.call("held_night", "spar")
	if not unknown.is_empty():
		bad.append("held_night(spar) %s, want {} (Thursday sparring is never a held night)" % str(unknown))
	# The caller's own writable copy: Godot marks a const row read-only, so handing the row straight back is a failure
	# twice over - it cannot be edited, and an edit that did land would reach into next week.
	var edited: Dictionary = S.call("held_night", "full")
	if edited.is_read_only():
		bad.append("held_night(full) hands back the read-only constant row, not the caller's own copy")
	else:
		edited["minutes"] = 10
		edited["mastery_share"] = 0.0
		var again: Dictionary = S.call("held_night", "full")
		if int(again.get("minutes", 0)) != 75 or float(again.get("mastery_share", 0.0)) != 1.0:
			bad.append("held_night(full) %s after a caller edited its row, want the full night back" % str(again))
	return bad


## R4: the fight week greys the button with the taper line, and a second hold in one week is not allowed.
func _check_held_allowed(S: GDScript) -> Array:
	var bad: Array = []
	var fresh: Dictionary = S.call("held_allowed", false, 0)
	if not bool(fresh.get("ok", false)) or str(fresh.get("why", "x")) != "":
		bad.append("held_allowed(false, 0) %s, want ok with no why" % str(fresh))
	var taper: Dictionary = S.call("held_allowed", true, 0)
	if bool(taper.get("ok", true)) or str(taper.get("why", "")) != TAPER:
		bad.append("held_allowed(true, 0) %s, want not ok with '%s'" % [str(taper), TAPER])
	var second: Dictionary = S.call("held_allowed", false, 1)
	if bool(second.get("ok", true)):
		bad.append("held_allowed(false, 1) %s, want not ok (one held night a week)" % str(second))
	if str(second.get("why", "")) == "":
		bad.append("the second hold gives no why")
	var third: Dictionary = S.call("held_allowed", false, 2)
	if bool(third.get("ok", true)):
		bad.append("held_allowed(false, 2) is ok")
	var both: Dictionary = S.call("held_allowed", true, 1)
	if bool(both.get("ok", true)) or str(both.get("why", "")) != TAPER:
		bad.append("held_allowed(true, 1) %s, want the taper line first" % str(both))
	for row in [fresh, taper, second, third, both]:
		if (row as Dictionary).size() != 2:
			bad.append("held_allowed keys %s, want ok/why" % str((row as Dictionary).keys()))
	return bad
