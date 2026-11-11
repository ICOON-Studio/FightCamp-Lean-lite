extends SceneTree
## TRAINREAD1 test: the coach's read - which training each fighter needs.
## Three fighters from Data.gd (numbers copied, not loaded): Lucy, Samira, Tess.

const TrainRead := preload("res://scripts/rules/TrainRead.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")

var _fails := 0
var _pron := RegEx.create_from_string("(?i)\\b(he|him|his|she|her|hers)\\b")


func _initialize() -> void:
	# 1. Samira -> weakness, defense
	_samira_hole()
	# 2. Lucy -> weapon, speed
	_lucy_weapon()
	# 3. Tess with bout 10 days away -> fight
	_tess_fight()
	# 4. Tess with no bout -> craft
	_tess_craft()
	# 5. Rest checks
	_rest_checks()
	# 6. Samira with defense raised -> weapon, power
	_samira_weapon_after_fix()
	# 7. Bout boundary checks
	_bout_boundaries()
	# 8. Say/why shape checks for every read
	_say_why_shape()
	# 9. Alt checks
	_alt_checks()
	# 10. Unknown style
	_unknown_style()
	# 11. Determinism
	_determinism()
	# 12. Mutant proof: exact thresholds
	_mutant_thresholds()
	# kinds()
	_kinds_check()

	print("TRAIN_READ failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1


func _lucy() -> Dictionary:
	return {"first": "Lucy", "style": "Out-boxer", "pot": 84, "fatigue": 8.0, "bout": {},
		"stats": {"power": 58.4, "speed": 63.2, "technique": 60.1, "defense": 57.3,
			"conditioning": 61.6, "fight_iq": 59.0, "chin": 66.0}}


func _samira() -> Dictionary:
	return {"first": "Samira", "style": "Slugger", "pot": 82, "fatigue": 10.0, "bout": {},
		"stats": {"power": 66.0, "speed": 57.0, "technique": 54.5, "defense": 50.5,
			"conditioning": 60.0, "fight_iq": 54.0, "chin": 63.0}}


func _tess() -> Dictionary:
	return {"first": "Tess", "style": "Pressure fighter", "pot": 76, "fatigue": 15.0, "bout": {},
		"stats": {"power": 62.0, "speed": 55.0, "technique": 58.5, "defense": 58.0,
			"conditioning": 64.0, "fight_iq": 59.5, "chin": 67.0}}


func _deep_copy(d: Dictionary) -> Dictionary:
	return d.duplicate(true)


## 1. Samira -> weakness, defense, session WeekCoach.BUILDS["defense"][0], pace 1.25.
func _samira_hole() -> void:
	var f: Dictionary = _samira()
	var r: Dictionary = TrainRead.read(f, 1)
	_check(str(r["kind"]) == "weakness", "Samira -> weakness (got %s)" % str(r["kind"]))
	_check(str(r["stat"]) == "defense", "Samira weakness stat = defense (got %s)" % str(r["stat"]))
	_check(str(r["session"]) == str(WeekCoach.BUILDS["defense"][0]),
		"Samira weakness session = %s (got %s)" % [str(WeekCoach.BUILDS["defense"][0]), str(r["session"])])
	_check(abs(float(r["pace"]) - 1.25) < 0.001, "Samira weakness pace = 1.25 (got %.4f)" % float(r["pace"]))


## 2. Lucy -> weapon, speed, pace about 0.83 (within 0.01).
func _lucy_weapon() -> void:
	var f: Dictionary = _lucy()
	var r: Dictionary = TrainRead.read(f, 1)
	_check(str(r["kind"]) == "weapon", "Lucy -> weapon (got %s)" % str(r["kind"]))
	_check(str(r["stat"]) == "speed", "Lucy weapon stat = speed (got %s)" % str(r["stat"]))
	_check(abs(float(r["pace"]) - 0.83) < 0.01, "Lucy weapon pace ~= 0.83 (got %.4f)" % float(r["pace"]))


## 3. Tess with a bout 10 days away -> fight, and say contains "10 days".
func _tess_fight() -> void:
	var f: Dictionary = _tess()
	f["bout"] = {"day": 11, "opp": {"first": "Maria"}}
	var r: Dictionary = TrainRead.read(f, 1)
	_check(str(r["kind"]) == "fight", "Tess bout 10 days -> fight (got %s)" % str(r["kind"]))
	_check(str(r["say"]).find("10 days") >= 0, "Tess fight say contains '10 days': '%s'" % str(r["say"]))


## 4. Tess with no bout -> craft (conditioning pace 0.48 < WEAPON_PACE).
func _tess_craft() -> void:
	var f: Dictionary = _tess()
	var r: Dictionary = TrainRead.read(f, 1)
	_check(str(r["kind"]) == "craft", "Tess no bout -> craft (got %s)" % str(r["kind"]))
	_check(str(r["session"]) == "pads", "Tess craft session = pads (got %s)" % str(r["session"]))


## 5. Rest checks: fatigue 75 -> rest; hurt -> rest; bout 10 days + fatigue 75 -> fight wins.
func _rest_checks() -> void:
	var f: Dictionary = _lucy()
	f["fatigue"] = 75.0
	var r1: Dictionary = TrainRead.read(f, 1)
	_check(str(r1["kind"]) == "rest", "Lucy fatigue 75 -> rest (got %s)" % str(r1["kind"]))

	var f2: Dictionary = _lucy()
	var r2: Dictionary = TrainRead.read(f2, 1, true)
	_check(str(r2["kind"]) == "rest", "Lucy hurt -> rest (got %s)" % str(r2["kind"]))

	var f3: Dictionary = _lucy()
	f3["fatigue"] = 75.0
	f3["bout"] = {"day": 11, "opp": {"first": "Maria"}}
	var r3: Dictionary = TrainRead.read(f3, 1)
	_check(str(r3["kind"]) == "fight", "Lucy fatigue 75 + bout 10 days -> fight wins (got %s)" % str(r3["kind"]))


## 6. Samira with defense raised to 58.0 -> weapon, power.
func _samira_weapon_after_fix() -> void:
	var f: Dictionary = _samira()
	f["stats"]["defense"] = 58.0
	var r: Dictionary = TrainRead.read(f, 1)
	_check(str(r["kind"]) == "weapon", "Samira defense 58 -> weapon (got %s)" % str(r["kind"]))
	_check(str(r["stat"]) == "power", "Samira defense 58 weapon stat = power (got %s)" % str(r["stat"]))


## 7. Bout boundary: 15 days NOT fight; 14 days IS fight; past bout NOT fight.
func _bout_boundaries() -> void:
	var f: Dictionary = _tess()
	f["bout"] = {"day": 16, "opp": {"first": "Maria"}}
	var r1: Dictionary = TrainRead.read(f, 1)
	_check(str(r1["kind"]) != "fight", "Bout 15 days away NOT fight (got %s)" % str(r1["kind"]))

	var f2: Dictionary = _tess()
	f2["bout"] = {"day": 15, "opp": {"first": "Maria"}}
	var r2: Dictionary = TrainRead.read(f2, 1)
	_check(str(r2["kind"]) == "fight", "Bout 14 days away IS fight (got %s)" % str(r2["kind"]))

	var f3: Dictionary = _tess()
	f3["bout"] = {"day": 0, "opp": {"first": "Maria"}}
	var r3: Dictionary = TrainRead.read(f3, 1)
	_check(str(r3["kind"]) != "fight", "Bout in the past NOT fight (got %s)" % str(r3["kind"]))


## 8. Say/why shape: at most 11 words, contains first name, no pronouns, why not empty, read() did not change f.
func _say_why_shape() -> void:
	var fighters: Array = [_lucy(), _samira(), _tess()]
	fighters[2]["bout"] = {"day": 11, "opp": {"first": "Maria"}}
	var days: Array = [1, 1, 1]
	var labels: Array = ["Lucy weapon", "Samira weakness", "Tess fight"]

	# Also test rest and craft
	var f_rest: Dictionary = _lucy()
	f_rest["fatigue"] = 75.0
	fighters.append(f_rest)
	days.append(1)
	labels.append("Lucy rest")

	var f_craft: Dictionary = _tess()
	fighters.append(f_craft)
	days.append(1)
	labels.append("Tess craft")

	for i in fighters.size():
		var f: Dictionary = fighters[i]
		var before: Dictionary = _deep_copy(f)
		var r: Dictionary = TrainRead.read(f, days[i])
		var say: String = str(r["say"])
		var why: String = str(r["why"])
		var first: String = str(f["first"])
		var label: String = str(labels[i])

		# Word count
		var words: PackedStringArray = say.split(" ", false)
		_check(words.size() <= TrainRead.MAX_WORDS,
			"%s say has <= %d words (%d): '%s'" % [label, TrainRead.MAX_WORDS, words.size(), say])

		# Contains first name
		_check(say.find(first) >= 0, "%s say contains '%s': '%s'" % [label, first, say])

		# No pronouns
		var pron_match = _pron.search(say)
		_check(pron_match == null, "%s say has no pronouns: '%s'" % [label, say])

		# Why not empty
		_check(why.length() > 0, "%s why is not empty" % label)

		# read() did not change f
		_check(f == before, "%s read() did not change f" % label)


## 9. Alt is another stat than the named one, and its pace equals TrainingPreview.headroom for it.
func _alt_checks() -> void:
	# Samira weakness -> defense, alt should be a different stat
	var f1: Dictionary = _samira()
	var r1: Dictionary = TrainRead.read(f1, 1)
	var alt1: Dictionary = r1["alt"] as Dictionary
	_check(not alt1.is_empty(), "Samira weakness alt is not empty")
	_check(str(alt1["stat"]) != str(r1["stat"]), "Samira weakness alt stat != defense")
	var alt1_pace: float = float(alt1["pace"])
	var alt1_expected: float = TrainingPreview.headroom(int(f1["pot"]), float(f1["stats"][str(alt1["stat"])]))
	_check(abs(alt1_pace - alt1_expected) < 0.001,
		"Samira weakness alt pace = headroom(%.4f == %.4f)" % [alt1_pace, alt1_expected])

	# Lucy weapon -> speed, alt should be a different stat
	var f2: Dictionary = _lucy()
	var r2: Dictionary = TrainRead.read(f2, 1)
	var alt2: Dictionary = r2["alt"] as Dictionary
	_check(not alt2.is_empty(), "Lucy weapon alt is not empty")
	_check(str(alt2["stat"]) != str(r2["stat"]), "Lucy weapon alt stat != speed")
	var alt2_pace: float = float(alt2["pace"])
	var alt2_expected: float = TrainingPreview.headroom(int(f2["pot"]), float(f2["stats"][str(alt2["stat"])]))
	_check(abs(alt2_pace - alt2_expected) < 0.001,
		"Lucy weapon alt pace = headroom(%.4f == %.4f)" % [alt2_pace, alt2_expected])

	# Tess craft -> alt is the best trainable stat
	var f3: Dictionary = _tess()
	var r3: Dictionary = TrainRead.read(f3, 1)
	var alt3: Dictionary = r3["alt"] as Dictionary
	_check(not alt3.is_empty(), "Tess craft alt is not empty")
	var alt3_pace: float = float(alt3["pace"])
	var alt3_expected: float = TrainingPreview.headroom(int(f3["pot"]), float(f3["stats"][str(alt3["stat"])]))
	_check(abs(alt3_pace - alt3_expected) < 0.001,
		"Tess craft alt pace = headroom(%.4f == %.4f)" % [alt3_pace, alt3_expected])

	# Fight and rest: alt is {}
	var f4: Dictionary = _tess()
	f4["bout"] = {"day": 11, "opp": {"first": "Maria"}}
	var r4: Dictionary = TrainRead.read(f4, 1)
	_check((r4["alt"] as Dictionary).is_empty(), "Tess fight alt is empty")

	var f5: Dictionary = _lucy()
	f5["fatigue"] = 75.0
	var r5: Dictionary = TrainRead.read(f5, 1)
	_check((r5["alt"] as Dictionary).is_empty(), "Lucy rest alt is empty")


## 10. Unknown style ("Brawler") does not crash: weapon on highest trainable, or craft.
func _unknown_style() -> void:
	var f: Dictionary = {"first": "Brawler", "style": "Brawler", "pot": 80, "fatigue": 10.0, "bout": {},
		"stats": {"power": 60.0, "speed": 55.0, "technique": 58.0, "defense": 56.0,
			"conditioning": 59.0, "fight_iq": 57.0, "chin": 61.0}}
	var r: Dictionary = TrainRead.read(f, 1)
	var kind: String = str(r["kind"])
	_check(kind == "weapon" or kind == "craft", "Unknown style -> weapon or craft (got %s)" % kind)
	if kind == "weapon":
		# Should be the highest trainable stat
		_check(str(r["stat"]) == "chin", "Unknown style weapon stat = chin (highest trainable, got %s)" % str(r["stat"]))


## 11. Same input twice gives the same output.
func _determinism() -> void:
	var f: Dictionary = _samira()
	var r1: Dictionary = TrainRead.read(f, 1)
	var r2: Dictionary = TrainRead.read(f, 1)
	_check(r1 == r2, "Same input twice gives same output")


## 12. Mutant proof: exact thresholds.
func _mutant_thresholds() -> void:
	# Gap exactly 6.0 -> weakness
	# 6 stats at 60, defense at 53: mean = (60*6 + 53) / 7 = 413/7 = 59.0, gap = 59.0 - 53 = 6.0
	# headroom(78, 53) = (78-53)/25 = 1.0 >= WEAK_PACE
	var f_gap6: Dictionary = {"first": "Gap6", "style": "Slugger", "pot": 78, "fatigue": 10.0, "bout": {},
		"stats": {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 53.0,
			"conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0}}
	var r_gap6: Dictionary = TrainRead.read(f_gap6, 1)
	_check(str(r_gap6["kind"]) == "weakness", "Gap exactly 6.0 -> weakness (got %s)" % str(r_gap6["kind"]))

	# Gap 5.9 -> not weakness (use defense 53.12: mean = 413.12/7 = 59.017, gap = 5.897 < 6.0)
	var f_gap59: Dictionary = {"first": "Gap59", "style": "Slugger", "pot": 78, "fatigue": 10.0, "bout": {},
		"stats": {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 53.12,
			"conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0}}
	var r_gap59: Dictionary = TrainRead.read(f_gap59, 1)
	_check(str(r_gap59["kind"]) != "weakness", "Gap 5.9 -> not weakness (got %s)" % str(r_gap59["kind"]))

	# Headroom exactly 0.5 -> weapon (pot 73, stat 60: (73-60)/25 = 0.52 >= 0.5)
	# Need no weakness: all stats close together
	var f_hd05: Dictionary = {"first": "Hd05", "style": "Slugger", "pot": 73, "fatigue": 10.0, "bout": {},
		"stats": {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 60.0,
			"conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0}}
	var r_hd05: Dictionary = TrainRead.read(f_hd05, 1)
	_check(str(r_hd05["kind"]) == "weapon", "Headroom 0.52 (>= 0.5) -> weapon (got %s)" % str(r_hd05["kind"]))

	# Fatigue 69.9 -> not rest
	var f_fat69: Dictionary = {"first": "Fat69", "style": "Out-boxer", "pot": 84, "fatigue": 69.9, "bout": {},
		"stats": {"power": 58.4, "speed": 63.2, "technique": 60.1, "defense": 57.3,
			"conditioning": 61.6, "fight_iq": 59.0, "chin": 66.0}}
	var r_fat69: Dictionary = TrainRead.read(f_fat69, 1)
	_check(str(r_fat69["kind"]) != "rest", "Fatigue 69.9 -> not rest (got %s)" % str(r_fat69["kind"]))


## kinds() returns the five kinds.
func _kinds_check() -> void:
	var k: Array = TrainRead.kinds()
	_check(k.size() == 5, "kinds() has 5 entries")
	_check(k.has("fight") and k.has("rest") and k.has("weakness") and k.has("weapon") and k.has("craft"),
		"kinds() has fight, rest, weakness, weapon, craft")
