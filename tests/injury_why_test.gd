extends SceneTree
## R11A: every injury says why it happened. InjuryRoll.training_cause and InjuryRoll.bout_cause are pure;
## _hurt stores the clause as "why"; new_this_week appends it. No extra rng: the seeded rolls stay unchanged.

const IR := preload("res://scripts/rules/InjuryRoll.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")

var failures := 0


func _initialize() -> void:
	_test_training_cause_pushed()
	_test_training_cause_load()
	_test_training_cause_fatigue()
	_test_training_cause_risk()
	_test_training_cause_plain()
	_test_training_cause_order()
	_test_bout_cause_head()
	_test_bout_cause_rounds()
	_test_bout_cause_empty()
	_test_hurt_stores_why()
	_test_new_this_week_with_why()
	_test_old_save_no_why()
	_test_training_roll_seed_unchanged()
	_test_career_injury_shows_why()
	print("INJURY_WHY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. Pushed through the warning takes priority.
func _test_training_cause_pushed() -> void:
	var w := IR.training_cause(1.0, 0.0, 1.0, true)
	_check(w == "you pushed through the warning", "training_cause pushed: '%s'" % w)


## 2. Load multiplier above 1.0 and >= fatigue: the hours jumped.
func _test_training_cause_load() -> void:
	var w := IR.training_cause(1.5, 0.0, 1.0, false)
	_check(w == "the hours jumped against the usual week", "training_cause load spike: '%s'" % w)


## 3. Fatigue multiplier above 1.0 and > load: the week ran too hot.
func _test_training_cause_fatigue() -> void:
	var w := IR.training_cause(1.0, 76.0, 1.0, false)
	_check(w == "the week ran too hot", "training_cause fatigue: '%s'" % w)


## 4. Both multipliers at 1.0, risk above 1.0: the floor and kit.
func _test_training_cause_risk() -> void:
	var w := IR.training_cause(1.0, 0.0, 1.2, false)
	_check(w == "the floor and kit are poor", "training_cause risk: '%s'" % w)


## 5. Everything normal: plain bad luck.
func _test_training_cause_plain() -> void:
	var w := IR.training_cause(1.0, 0.0, 1.0, false)
	_check(w == "plain bad luck, the load was fine", "training_cause plain: '%s'" % w)


## 6. Order: pushed beats high load beats high fatigue beats risk.
func _test_training_cause_order() -> void:
	var ok := true
	if IR.training_cause(1.5, 80.0, 1.5, true) != "you pushed through the warning":
		ok = false
	if IR.training_cause(1.5, 80.0, 1.5, false) != "the hours jumped against the usual week":
		ok = false
	if IR.training_cause(1.0, 80.0, 1.5, false) != "the week ran too hot":
		ok = false
	_check(ok, "training_cause order: pushed > load > fatigue > risk > plain")


## 7. Bout cause: head is the worst place -> head shots.
func _test_bout_cause_head() -> void:
	var w := IR.bout_cause({"places": {"head": 30.0}, "rounds": 3})
	_check(w == "from the head shots taken", "bout_cause head worst: '%s'" % w)


## 8. Bout cause: head not worst -> the rounds.
func _test_bout_cause_rounds() -> void:
	var w := IR.bout_cause({"places": {"head": 80.0, "body": 20.0}, "rounds": 3})
	_check(w == "from the rounds boxed", "bout_cause body worst: '%s'" % w)


## 9. Bout cause: empty places -> the rounds.
func _test_bout_cause_empty() -> void:
	var w := IR.bout_cause({"places": {}, "rounds": 3})
	_check(w == "from the rounds boxed", "bout_cause empty: '%s'" % w)


## 10. _hurt stores the why clause in the injury dict.
func _test_hurt_stores_why() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	c.day = 20
	Injuries._hurt(c, f, {"type": "hand", "days_out": 21}, "in training", "the hours jumped against the usual week")
	var why := str((f.get("injury", {}) as Dictionary).get("why", ""))
	_check(why == "the hours jumped against the usual week", "_hurt stores why: '%s'" % why)


## 11. new_this_week appends the why clause.
func _test_new_this_week_with_why() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	c.day = 20
	Injuries._hurt(c, f, {"type": "hand", "days_out": 21}, "in training", "the hours jumped against the usual week")
	var line := Injuries.new_this_week(c, f)
	_check(line.ends_with(", the hours jumped against the usual week"), "new_this_week ends with why: '%s'" % line)


## 12. Old save without "why" reads exactly as today.
func _test_old_save_no_why() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	c.day = 20
	f["injury"] = {"type": "hand", "days_out": 21, "until_day": 41, "choice": ""}
	var line := Injuries.new_this_week(c, f)
	var base := Injuries.line(c, f)
	_check(line == base, "old save without why reads as before: '%s' == '%s'" % [line, base])


## 13. training_roll for a fixed seed gives the same result (no extra rng).
func _test_training_roll_seed_unchanged() -> void:
	var r1 := IR.training_roll(42, 10.0, 1.0)
	var r2 := IR.training_roll(42, 10.0, 1.0)
	var ok := true
	for k in ["injured", "type", "days_out"]:
		if r1[k] != r2[k]:
			ok = false
	_check(ok, "training_roll seed unchanged: injured=%s type=%s days=%s" % [str(r1["injured"]), str(r1["type"]), str(r1["days_out"])])


## 14. A real career: an injury shows the clause in new_this_week.
func _test_career_injury_shows_why() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	c.day = 20
	f["week_peak"] = 80.0
	var usual := Injuries.chronic(f)
	var risk := 1.0
	var pushed := false
	var why := IR.training_cause(10.0 / usual if usual > 0.0 else 1.0, 80.0, risk, pushed)
	Injuries._hurt(c, f, {"type": "strain", "days_out": 14}, "in training", why)
	var line := Injuries.new_this_week(c, f)
	_check(not line.is_empty() and line.ends_with(why), "career injury shows why in new_this_week: '%s'" % line)


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 325
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.cash = 1000000
	return c
