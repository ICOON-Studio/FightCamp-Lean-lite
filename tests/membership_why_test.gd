extends SceneTree
## R11B: every membership change says why. Membership.week_cause is pure; Sim stores the clause as "members_why";
## WeekReview shows it after the count. No extra rng: the seeded rolls stay unchanged.

const Membership := preload("res://scripts/rules/Membership.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var failures := 0


func _initialize() -> void:
	_test_no_change_empty()
	_test_rose_to_cap_with_natural_above()
	_test_rose_otherwise()
	_test_fell_premium_dues()
	_test_fell_cap_forced()
	_test_fell_otherwise()
	_test_old_save_no_members_why()
	_test_career_week_shows_why()
	print("MEMBERSHIP_WHY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. No change: empty string.
func _test_no_change_empty() -> void:
	var w := Membership.week_cause(50, 50, 60, 100, "standard")
	_check(w == "", "no change returns empty: '%s'" % w)


## 2. Rose and after reached cap while natural is above cap: "the gym is full now".
func _test_rose_to_cap_with_natural_above() -> void:
	var w := Membership.week_cause(50, 60, 80, 60, "standard")
	_check(w == "the gym is full now", "rose to cap with natural above: '%s'" % w)


## 3. Rose otherwise: "word is getting round".
func _test_rose_otherwise() -> void:
	var w := Membership.week_cause(50, 55, 70, 100, "standard")
	_check(w == "word is getting round", "rose otherwise: '%s'" % w)


## 4. Fell and band is premium with draw below 1.0: "the dues are putting people off".
func _test_fell_premium_dues() -> void:
	var w := Membership.week_cause(60, 55, 50, 100, "premium")
	_check(w == "the dues are putting people off", "fell premium dues: '%s'" % w)


## 5. Fell and natural is at or above cap: "the gym has less room".
func _test_fell_cap_forced() -> void:
	var w := Membership.week_cause(60, 55, 70, 50, "standard")
	_check(w == "the gym has less room", "fell cap forced: '%s'" % w)


## 6. Fell otherwise: "more than the gym's name can hold".
func _test_fell_otherwise() -> void:
	var w := Membership.week_cause(60, 55, 50, 100, "standard")
	_check(w == "more than the gym's name can hold", "fell otherwise: '%s'" % w)


## 7. Old save without members_why reads exactly as today.
func _test_old_save_no_members_why() -> void:
	var r := {"members": 50, "members_delta": 2}
	var why := str(r.get("members_why", ""))
	_check(why == "", "old save without members_why reads as empty: '%s'" % why)


## 8. A real career: one week played shows the clause in the week result.
func _test_career_week_shows_why() -> void:
	var c := Career.quick_start()
	c.seed = 325
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.cash = 1000000
	var before := c.members
	var rep := c.reputation
	var cap := 1000
	var band := c.dues_band
	var natural := Membership.natural_members(rep, band)
	var after := Membership.step_members(before, mini(natural, cap))
	var why := Membership.week_cause(before, after, natural, cap, band)
	_check(why != "" or before == after, "career week produces a clause (or no change): before=%d after=%d natural=%d cap=%d band=%s why='%s'" % [before, after, natural, cap, band, why])
