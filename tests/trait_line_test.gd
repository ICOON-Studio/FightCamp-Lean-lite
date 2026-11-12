extends SceneTree
## R50TRAIT1 test: every trait's lines (TraitLine) proved against the code on both sides of each threshold,
## every trait has an upside and a downside, the three NEW rows, two real prospects, next_line, crossed,
## hover, no pronouns, and two MUTANT copies that must fail the same asserts.

const TL := preload("res://scripts/rules/TraitLine.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const PushBack := preload("res://scripts/rules/PushBack.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Data := preload("res://scripts/state/Data.gd")

const PRONOUNS: Array = ["them", "they", "their", "her", "his", "its", "you", "your", "she", "he", "we", "us", "our", "me", "my"]

var fails := 0


func _initialize() -> void:
	# 1. Every "code" line agrees with the code on both sides of its threshold.
	# Confidence 49/50: fire edge 2.0 vs 1.5
	var f49: Dictionary = CornerJobs.talk("fire", {"confidence": 49.0, "temper": 30.0})
	var f50: Dictionary = CornerJobs.talk("fire", {"confidence": 50.0, "temper": 30.0})
	_check(float(f49["edge"]) == 2.0 and float(f50["edge"]) == 1.5,
		"fire edge at confidence 49 vs 50: 2.0 vs 1.5")
	# Truth at confidence 44/45 (discipline 60): the -2 penalty
	var t44: Dictionary = CornerJobs.talk("truth", {"confidence": 44.0, "discipline": 60.0, "temper": 50.0})
	var t45: Dictionary = CornerJobs.talk("truth", {"confidence": 45.0, "discipline": 60.0, "temper": 50.0})
	_check(float(t44["edge"]) < 0.0 and float(t45["edge"]) > 0.0,
		"truth edge at confidence 44 vs 45: negative vs positive")
	# Truth at discipline 59/60: 0.3 vs 1.2
	var d59: Dictionary = CornerJobs.talk("truth", {"discipline": 59.0, "confidence": 50.0, "temper": 50.0})
	var d60: Dictionary = CornerJobs.talk("truth", {"discipline": 60.0, "confidence": 50.0, "temper": 50.0})
	_check(float(d59["edge"]) == 0.3 and float(d60["edge"]) == 1.2,
		"truth edge at discipline 59 vs 60: 0.3 vs 1.2")
	# Fire at temper 64/65: edge and hurt
	var ft64: Dictionary = CornerJobs.talk("fire", {"temper": 64.0, "confidence": 60.0})
	var ft65: Dictionary = CornerJobs.talk("fire", {"temper": 65.0, "confidence": 60.0})
	_check(float(ft64["edge"]) > 0.0 and float(ft65["edge"]) < 0.0,
		"fire edge at temper 64 vs 65: positive vs negative")
	_check(float(ft64["hurt"]) == 1.3 and float(ft65["hurt"]) == 1.6,
		"fire hurt at temper 64 vs 65: 1.3 vs 1.6")
	# Calm at temper 64/65: edge 0 vs 1
	var c64: Dictionary = CornerJobs.talk("calm", {"temper": 64.0})
	var c65: Dictionary = CornerJobs.talk("calm", {"temper": 65.0})
	_check(float(c64["edge"]) == 0.0 and float(c65["edge"]) == 1.0,
		"calm edge at temper 64 vs 65: 0 vs 1")
	# Discipline "pushes back" at == PushBack.LOW_DISCIPLINE
	var found_push := false
	var disc_rows: Array = TL.LINES["discipline"]
	for r in disc_rows:
		var row: Dictionary = r
		if str(row["word"]) == "Wanders off the plan":
			_check(float(row["at"]) == PushBack.LOW_DISCIPLINE,
				"discipline pushes back at == PushBack.LOW_DISCIPLINE (%.0f)" % PushBack.LOW_DISCIPLINE)
			found_push = true
	_check(found_push, "found discipline pushes back row")
	# Heart: KO_ODDS matches the 0.7 in the heart down does
	_check(float(Knockdowns.KO_ODDS) == 0.7, "KO_ODDS == 0.7 (heart down factor)")

	# 2. Every trait has at least one "up" row and one "down" row.
	for tn in TL.THE_FIVE:
		var has_up := false
		var has_down := false
		var rows: Array = TL.LINES[tn]
		for r in rows:
			var row: Dictionary = r
			if str(row["side"]) == "up":
				has_up = true
			if str(row["side"]) == "down":
				has_down = true
		_check(has_up, "%s has at least one up row" % tn)
		_check(has_down, "%s has at least one down row" % tn)

	# 3. "new" rows are exactly the three: coachability 40, coachability 70, discipline 45.
	var new_rows: Array = []
	for tn in TL.THE_FIVE:
		var rows: Array = TL.LINES[tn]
		for r in rows:
			var row: Dictionary = r
			if str(row["source"]) == "new":
				new_rows.append({"tn": tn, "at": float(row["at"])})
	_check(new_rows.size() == 3, "exactly 3 new rows (got %d)" % new_rows.size())
	var new_ats: Array = []
	for nr in new_rows:
		var n: Dictionary = nr
		new_ats.append("%s@%.0f" % [str(n["tn"]), float(n["at"])])
	_check(new_ats.has("coachability@40"), "new: coachability@40")
	_check(new_ats.has("coachability@70"), "new: coachability@70")
	_check(new_ats.has("discipline@45"), "new: discipline@45")

	# 4. Two real prospects: Tess (coachability 36) and Kira (84).
	var tess: Dictionary = Data.PROSPECTS[2].duplicate(true)
	var kira: Dictionary = Data.PROSPECTS[0].duplicate(true)
	var tess_p: Dictionary = tess.get("personality", {})
	var kira_p: Dictionary = kira.get("personality", {})
	_check(float(tess_p.get("coachability", 0.0)) == 36.0, "Tess coachability is 36")
	_check(float(kira_p.get("coachability", 0.0)) == 84.0, "Kira coachability is 84")
	_check(TL.word("coachability", 36.0) == "Stubborn", "word coachability 36: Stubborn")
	_check(TL.word("coachability", 84.0) == "Listens", "word coachability 84: Listens")
	var tess_card: Array = TL.card(tess_p)
	var kira_card: Array = TL.card(kira_p)
	_check(tess_card != kira_card, "card() differs between Tess and Kira")

	# 5. next_line
	var nl_c36: Dictionary = TL.next_line("coachability", 36.0)
	_check(not nl_c36.is_empty() and float(nl_c36["at"]) == 40.0, "next_line coachability 36: at 40")
	_check(not nl_c36.is_empty() and int(nl_c36["points"]) == 4, "next_line coachability 36: 4 points")
	var nl_c84: Dictionary = TL.next_line("coachability", 84.0)
	_check(nl_c84.is_empty(), "next_line coachability 84: {} (no more lines)")
	var nl_t70: Dictionary = TL.next_line("temper", 70.0)
	_check(not nl_t70.is_empty() and float(nl_t70["at"]) == 65.0, "next_line temper 70: at 65 (downward)")
	_check(not nl_t70.is_empty() and int(nl_t70["points"]) == 5, "next_line temper 70: 5 points")
	var nl_h: Dictionary = TL.next_line("heart", 50.0)
	_check(nl_h.is_empty(), "next_line heart: {} (always)")

	# 6. crossed
	var cr := TL.crossed("coachability", 39.0, 40.0)
	_check(cr.size() == 1, "crossed(coachability, 39, 40): one row changed")
	if cr.size() >= 1:
		var cr0: Dictionary = cr[0]
		var cr_row: Dictionary = cr0["row"]
		_check(str(cr_row["word"]) == "Stubborn" and str(cr0["now"]) == "gone",
			"crossed(coachability, 39, 40): Stubborn row gone")
	var cr2 := TL.crossed("coachability", 39.0, 39.0)
	_check(cr2.is_empty(), "crossed(coachability, 39, 39): empty (no change)")

	# 7. hover
	var h_c84: String = TL.hover("coachability", 84.0)
	var u84: float = Exchanges.uptake(84.0, 0)
	var exp_c := "takes in %d in 100 of each full shout" % roundi(u84 * 100.0)
	_check(h_c84 == exp_c, "hover coachability 84: %s" % exp_c)
	var h_h50: String = TL.hover("heart", 50.0)
	var exp_stop: float = 1.4 - 50.0 / 100.0
	var exp_down: float = (1.0 - 50.0 / 100.0) * float(Knockdowns.KO_ODDS)
	var exp_h := "referee's stop odds x%.2f; stays down after a bad count x%.2f" % [exp_stop, exp_down]
	_check(h_h50 == exp_h, "hover heart 50: %s" % exp_h)
	var h_empty: String = TL.hover("temper", 50.0)
	_check(h_empty == "", "hover temper: empty")

	# 8. No pronoun in any does, word or hover string.
	for tn in TL.THE_FIVE:
		var rows: Array = TL.LINES[tn]
		for r in rows:
			var row: Dictionary = r
			_check(not _has_pronoun(str(row["does"])),
				"no pronoun in %s does: %s" % [tn, str(row["does"])])
			_check(not _has_pronoun(str(row["word"])),
				"no pronoun in %s word: %s" % [tn, str(row["word"])])
		var h: String = TL.hover(tn, 50.0)
		if h != "":
			_check(not _has_pronoun(h), "no pronoun in %s hover" % tn)

	# 9. MUTANTS
	# MUTANT now() with <= for "under": at confidence 45 it wrongly includes "Fragile".
	var real_w45: String = TL.word("confidence", 45.0)
	_check(real_w45 != "Fragile", "real rows_now: confidence 45 does not include Fragile (45 is not < 45)")
	var mutant_w45: String = _mutant_word("confidence", 45.0)
	if mutant_w45 == "Fragile":
		print("MUTANT caught: rows_now with <= wrongly includes Fragile at confidence 45")
	else:
		fails += 1
		print("FAIL MUTANT rows_now was not caught")
	# MUTANT next_line ignoring temper's downward direction: temper 70 returns {} instead of at 65.
	var real_nl: Dictionary = TL.next_line("temper", 70.0)
	_check(not real_nl.is_empty() and float(real_nl["at"]) == 65.0, "real next_line: temper 70 -> at 65")
	var mutant_nl: Dictionary = _mutant_next_line("temper", 70.0)
	if mutant_nl.is_empty():
		print("MUTANT caught: next_line ignoring temper direction wrongly returns {} for temper 70")
	else:
		fails += 1
		print("FAIL MUTANT next_line was not caught")

	# S442 collect: `side` is what crossing the next line BRINGS, and `ends` says the row stops.
	var c36: Dictionary = TL.next_line("coachability", 36.0)
	_check(str(c36.get("side", "")) == "up" and bool(c36.get("ends", false)), "next_line: leaving Stubborn at 40 is a gain, the row ends")
	var c60: Dictionary = TL.next_line("coachability", 60.0)
	_check(int(c60.get("at", 0)) == 70 and str(c60.get("side", "")) == "up" and not bool(c60.get("ends", true)), "next_line: Listens at 70 is a gain that begins")
	var f47: Dictionary = TL.next_line("confidence", 47.0)
	_check(int(f47.get("at", 0)) == 50 and str(f47.get("side", "")) == "down" and bool(f47.get("ends", false)), "next_line: confidence 47 -> 50 loses the Fire up upside")
	var t70: Dictionary = TL.next_line("temper", 70.0)
	_check(str(t70.get("side", "")) == "up" and bool(t70.get("ends", false)), "next_line: temper under 65 ends Short fuse, a gain")
	_check(TL.now("heart", 60.0) == TL.rows_now("heart", 60.0), "now() is rows_now()")
	_check(not _has_pronoun(TL.hover("heart", 60.0)) and TL.hover("heart", 60.0).find("ref stop") < 0, "hover: heart in plain words")
	print("TRAIT_LINE failures=%d" % fails)
	quit(1 if fails > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		fails += 1
		print("FAIL ", label)


func _has_pronoun(s: String) -> bool:
	var clean: String = s.to_lower()
	for c in "().,;:'\"-/+":
		clean = clean.replace(c, " ")
	var words: Array = clean.split(" ", false)
	for w in words:
		if PRONOUNS.has(w):
			return true
	return false


## MUTANT: a copy of rows_now() that reads "under" as <= instead of <.
func _mutant_now(trait_name: String, v: float) -> Array:
	var rows: Array = TL.LINES.get(trait_name, [])
	var out: Array = []
	for r in rows:
		var row: Dictionary = r
		var at: float = float(row["at"])
		if at < 0.0:
			out.append(row)
		elif str(row["dir"]) == "under":
			if v <= at:
				out.append(row)
		else:
			if v >= at:
				out.append(row)
	return out


## MUTANT: word() using the mutant rows_now().
func _mutant_word(trait_name: String, v: float) -> String:
	var rows := _mutant_now(trait_name, v)
	for r in rows:
		var row: Dictionary = r
		var w: String = str(row["word"])
		if w != "":
			return w
	return ""


## MUTANT: a copy of next_line that ignores temper's downward direction (always uses "up").
func _mutant_next_line(trait_name: String, v: float) -> Dictionary:
	if trait_name == "heart":
		return {}
	var rows: Array = TL.LINES.get(trait_name, [])
	var dir_up: bool = true
	var best: Dictionary = {}
	var best_dist: float = 999.0
	for r in rows:
		var row: Dictionary = r
		var at: float = float(row["at"])
		if at < 0.0:
			continue
		var dist: float
		if dir_up:
			if at <= v:
				continue
			dist = at - v
		else:
			if at >= v:
				continue
			dist = v - at
		if dist < best_dist:
			best_dist = dist
			best = {"at": at, "word": str(row["word"]), "does": str(row["does"]),
				"side": str(row["side"]), "points": roundi(dist)}
	return best
