extends SceneTree
## CoachNotes tests (fight model step 5):
##   1. New fighter's card is empty; progress is [0, n]. A has 5 seeable (2 habits + 3 traits), B has 2.
##   2. reveal("fight") on A: 1st+2nd reveal habits, 3rd-5th traits, 6th returns [].
##   3. reveal("film") never reveals a trait; reveal("sparring") over 1000 seeds reveals in 30-40% of first calls.
##   4. No duplicate in notes_seen; no id she does not have; card lines from bank verbatim after {name};
##      same fighter gets same habit line every call.
##   5. Old save without notes_seen / personality / habits works (empty card, no error).
##   6. Unknown habit ids in f["habits"] are skipped by card() (no error).

const CN := preload("res://scripts/rules/CoachNotes.gd")

var failures := 0
var BANK: Dictionary = {}


func _initialize() -> void:
	var text: String = FileAccess.get_file_as_string("res://assets/data/fight_habits.json")
	BANK = JSON.parse_string(text)

	_test_1_new_fighter()
	_test_2_fight_reveal_order()
	_test_3_film_and_sparring()
	_test_4_no_duplicates_and_stable_lines()
	_test_5_old_save()
	_test_6_unknown_habit()

	print("COACH_NOTES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _fighter_a() -> Dictionary:
	return {
		"id": "f1",
		"name": "Tess",
		"habits": ["drops_right_after_jab", "fades_late"],
		"personality": {
			"heart": 82.0,
			"temper": 35.0,
			"confidence": 55.0,
			"discipline": 60.0,
			"coachability": 72.0,
			"loyalty": 50.0,
		},
	}


func _fighter_b() -> Dictionary:
	return {
		"id": "f2",
		"name": "Grace",
		"habits": ["slow_starter", "wide_hook_tell"],
		"personality": {
			"heart": 45.0,
			"temper": 60.0,
			"confidence": 50.0,
			"discipline": 41.0,
			"coachability": 55.0,
			"loyalty": 65.0,
		},
	}


## 1. New fighter: empty card, progress [0, n]. A has 5 seeable, B has 2.
func _test_1_new_fighter() -> void:
	var a: Dictionary = _fighter_a()
	var card_a: Array = CN.card(a, BANK)
	_check(card_a.is_empty(), "new fighter A: card is empty")
	var prog_a: Array = CN.progress(a)
	_check(prog_a[0] == 0 and prog_a[1] == 5, "new fighter A: progress [0, 5], got [%d, %d]" % [prog_a[0], prog_a[1]])

	var b: Dictionary = _fighter_b()
	var card_b: Array = CN.card(b, BANK)
	_check(card_b.is_empty(), "new fighter B: card is empty")
	var prog_b: Array = CN.progress(b)
	_check(prog_b[0] == 0 and prog_b[1] == 2, "new fighter B: progress [0, 2], got [%d, %d]" % [prog_b[0], prog_b[1]])


## 2. reveal("fight") on A: 1st+2nd habits, 3rd-5th traits, 6th [].
func _test_2_fight_reveal_order() -> void:
	var a: Dictionary = _fighter_a()
	var rng := RandomNumberGenerator.new()
	rng.seed = 42

	var r1: Array = CN.reveal(a, "fight", rng)
	_check(r1.size() == 1 and str(r1[0]).begins_with("habit:"), "fight 1 reveals a habit: %s" % str(r1))
	var r2: Array = CN.reveal(a, "fight", rng)
	_check(r2.size() == 1 and str(r2[0]).begins_with("habit:"), "fight 2 reveals the 2nd habit: %s" % str(r2))
	var r3: Array = CN.reveal(a, "fight", rng)
	_check(r3.size() == 1 and str(r3[0]).begins_with("trait:"), "fight 3 reveals a trait: %s" % str(r3))
	var r4: Array = CN.reveal(a, "fight", rng)
	_check(r4.size() == 1 and str(r4[0]).begins_with("trait:"), "fight 4 reveals a trait: %s" % str(r4))
	var r5: Array = CN.reveal(a, "fight", rng)
	_check(r5.size() == 1 and str(r5[0]).begins_with("trait:"), "fight 5 reveals a trait: %s" % str(r5))
	var r6: Array = CN.reveal(a, "fight", rng)
	_check(r6.is_empty(), "fight 6 reveals nothing (all seen): %s" % str(r6))


## 3. film never reveals a trait; sparring hits 30-40% over 1000 seeds.
func _test_3_film_and_sparring() -> void:
	var film_ok := true
	for seed in range(200):
		var a: Dictionary = _fighter_a()
		var rng := RandomNumberGenerator.new()
		rng.seed = seed + 1
		for i in 10:
			var r: Array = CN.reveal(a, "film", rng)
			for id in r:
				if str(id).begins_with("trait:"):
					film_ok = false
	_check(film_ok, "film never reveals a trait over 200 seeds x 10 calls")

	var hits := 0
	var total := 1000
	for seed in range(total):
		var a: Dictionary = _fighter_a()
		var rng := RandomNumberGenerator.new()
		rng.seed = seed + 1000
		var r: Array = CN.reveal(a, "sparring", rng)
		if not r.is_empty():
			hits += 1
	var rate: float = float(hits) / float(total)
	_check(rate >= 0.30 and rate <= 0.40, "sparring first-call reveal rate %.2f in [0.30, 0.40]" % rate)


## 4. No duplicate in notes_seen; no unknown id; lines verbatim from bank; same fighter -> same line.
func _test_4_no_duplicates_and_stable_lines() -> void:
	var a: Dictionary = _fighter_a()
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 5:
		CN.reveal(a, "fight", rng)
	var seen: Array = a["notes_seen"]
	var seen_set: Dictionary = {}
	var dup := false
	for id in seen:
		if seen_set.has(str(id)):
			dup = true
		seen_set[str(id)] = true
	_check(not dup, "no duplicate in notes_seen after 5 fight reveals")

	var seeable_set: Dictionary = {}
	for id in CN.seeable(a):
		seeable_set[str(id)] = true
	var stray := false
	for id in seen:
		if not seeable_set.has(str(id)):
			stray = true
	_check(not stray, "no id in notes_seen that isn't seeable")

	var lines: Array = CN.card(a, BANK)
	var verbatim_ok := true
	for entry in lines:
		var id: String = str(entry["id"])
		var line: String = str(entry["line"])
		if id.begins_with("habit:"):
			var hid: String = id.substr("habit:".length())
			var found := false
			for row in BANK["habits"]:
				if str(row["id"]) == hid:
					found = true
					var in_notes := false
					for n in row["notes"]:
						if str(n).replace("{name}", a["name"]) == line:
							in_notes = true
							break
					if not in_notes:
						verbatim_ok = false
					break
			if not found:
				verbatim_ok = false
	_check(verbatim_ok, "card lines come verbatim from the bank (after {name})")

	var lines2: Array = CN.card(a, BANK)
	var stable := true
	if lines.size() != lines2.size():
		stable = false
	else:
		for i in lines.size():
			if str(lines[i]["line"]) != str(lines2[i]["line"]):
				stable = false
				break
	_check(stable, "same fighter gets the same habit line on every card() call")


## 5. Old save without notes_seen / personality / habits: empty card, no error.
func _test_5_old_save() -> void:
	var old: Dictionary = {"id": "old1", "name": "Oldie"}
	var card_old: Array = CN.card(old, BANK)
	_check(card_old.is_empty(), "old save: card is empty")
	var prog_old: Array = CN.progress(old)
	_check(prog_old[0] == 0 and prog_old[1] == 0, "old save: progress [0, 0]")
	var r: Array = CN.reveal(old, "fight", RandomNumberGenerator.new())
	_check(r.is_empty(), "old save: reveal returns []")


## 6. Unknown habit ids in f["habits"] are skipped by card() (no error).
func _test_6_unknown_habit() -> void:
	var a: Dictionary = _fighter_a()
	a["habits"].append("totally_fake_habit")
	a["notes_seen"] = ["habit:totally_fake_habit", "habit:drops_right_after_jab"]
	var lines: Array = CN.card(a, BANK)
	var only_known := true
	for entry in lines:
		if str(entry["id"]) == "habit:totally_fake_habit":
			only_known = false
	_check(only_known, "unknown habit id is skipped by card()")
	_check(lines.size() == 1, "only the known habit appears in the card")
