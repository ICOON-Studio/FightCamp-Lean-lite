extends SceneTree
## THURSDAY2 - how many real problems does a camp week throw up by Thursday? Measure only.
## Runs 40+ camps that DIFFER: 5 boxers (Lucy + 4 prospects) x 4 bouts x different seeds.
## On every THURSDAY of a camp week records five problems: TAPE, HABIT, WEIGHT, TIRED, CARD.
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/thursday_probe.gd -- 40

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Data := preload("res://scripts/state/Data.gd")

const CAMPS_MIN := 40
const BOUTS_PER_BOXER := 4
const THURSDAY := 3
const BOXER_IDS := ["lucy", "kira", "samira", "tess", "danny"]
const BOXER_PICKS := {
	"lucy": ["Jab and move", "Pad rounds", "Hill sprints"],
	"kira": ["Jab and move", "Defence drills", "Hill sprints"],
	"samira": ["Body work", "Pad rounds", "Hill sprints"],
	"tess": ["Pad rounds", "Hill sprints", "Defence drills"],
	"danny": ["Jab and move", "Pad rounds", "Body work"],
}


func _initialize() -> void:
	var n := CAMPS_MIN
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("THURSDAY2 probe: %d+ camps, 5 boxers x 4 bouts x different seeds" % n)
	var camp_results := []
	var quiet_results := []
	var distinct_opponents := {}
	var distinct_boxers := {}
	var distinct_rows := {}
	var camp_idx := 0
	var seed_idx := 0
	while camp_idx < n:
		var seed_val := seed_idx * 7919 + 13
		seed_idx += 1
		for boxer_id in BOXER_IDS:
			if camp_idx >= n:
				break
			var result := _run_one_camp(seed_val, boxer_id, camp_idx + 1)
			if result.is_empty():
				continue
			for m in result["camp_thursdays"]:
				camp_results.append(m)
				distinct_opponents[m["opp"]] = true
				distinct_boxers[m["boxer"]] = true
				var row := "%s|%s|%d|%d" % [m["boxer"], m["opp"], m["bout"], m["week"]]
				distinct_rows[row] = true
			for m in result["quiet_thursdays"]:
				quiet_results.append(m)
			camp_idx += 1
		if seed_idx > 100:
			break
	var n_opponents := distinct_opponents.size()
	var n_boxers := distinct_boxers.size()
	var n_rows := distinct_rows.size()
	print("")
	print("THURSDAY2 spread opponents=%d boxers=%d camp_lengths=<see below> rows=%d distinct THU lines" % [
		n_opponents, n_boxers, n_rows])
	if n_opponents < 10 or n_rows < 12:
		print("VOID: under 10 opponents or under 12 distinct rows - the run is void")
		var void_content := "# THURSDAY2 RESULT - VOID\n\nUnder 10 opponents (%d) or under 12 distinct rows (%d).\n" % [n_opponents, n_rows]
		var vf := FileAccess.open("res://docs/THURSDAY2_RESULT.md", FileAccess.WRITE)
		if vf:
			vf.store_string(void_content)
			vf.close()
		quit(1)
		return
	# Print results
	print("")
	print("--- CAMP WEEK THURSDAYS ---")
	var camp_open_counts := {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
	var camp_problem_counts := {"tape": 0, "habit": 0, "weight": 0, "tired": 0, "card": 0}
	var camp_lengths := {}
	for m in camp_results:
		var open_count := int(m["tape"]) + int(m["habit"]) + int(m["weight"]) + int(m["tired"]) + int(m["card"])
		camp_open_counts[mini(open_count, 5)] = int(camp_open_counts.get(open_count, 0)) + 1
		for k in ["tape", "habit", "weight", "tired", "card"]:
			if bool(m[k]):
				camp_problem_counts[k] = int(camp_problem_counts[k]) + 1
		camp_lengths[m["days_to_bell"]] = true
		print("THU camp=%d boxer=%s opp=%s bout=%d week=%d days_to_bell=%d tape=%d habit=%d weight=%d tired=%d card=%d open=%d" % [
			m["camp"], m["boxer"], m["opp"], m["bout"], m["week"], m["days_to_bell"],
			m["tape"], m["habit"], m["weight"], m["tired"], m["card"], open_count])
	print("")
	print("--- QUIET WEEK THURSDAYS ---")
	var quiet_open_counts := {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
	var quiet_problem_counts := {"tape": 0, "habit": 0, "weight": 0, "tired": 0, "card": 0}
	for m in quiet_results:
		var open_count := int(m["tape"]) + int(m["habit"]) + int(m["weight"]) + int(m["tired"]) + int(m["card"])
		quiet_open_counts[mini(open_count, 5)] = int(quiet_open_counts.get(open_count, 0)) + 1
		for k in ["tape", "habit", "weight", "tired", "card"]:
			if bool(m[k]):
				quiet_problem_counts[k] = int(quiet_problem_counts[k]) + 1
		print("THU camp=%d boxer=%s opp=none bout=0 week=%d days_to_bell=-1 tape=%d habit=%d weight=%d tired=%d card=%d open=%d" % [
			m["camp"], m["boxer"], m["week"], m["tape"], m["habit"], m["weight"], m["tired"], m["card"], open_count])
	# Summary
	print("")
	print("--- SUMMARY ---")
	var total_camp := camp_results.size()
	var total_quiet := quiet_results.size()
	var camp_2plus := 0
	for k in [2, 3, 4, 5]:
		camp_2plus += int(camp_open_counts.get(k, 0))
	var quiet_2plus := 0
	for k in [2, 3, 4, 5]:
		quiet_2plus += int(quiet_open_counts.get(k, 0))
	var pct_2plus := 100.0 * camp_2plus / maxi(1, total_camp)
	print("Camp weeks: %d Thursdays, %d with 2+ open (%.0f%%)" % [total_camp, camp_2plus, pct_2plus])
	print("Quiet weeks: %d Thursdays, %d with 2+ open (%.0f%%)" % [total_quiet, quiet_2plus, 100.0 * quiet_2plus / maxi(1, total_quiet)])
	print("Problem counts (camp): tape=%d habit=%d weight=%d tired=%d card=%d" % [
		camp_problem_counts["tape"], camp_problem_counts["habit"], camp_problem_counts["weight"],
		camp_problem_counts["tired"], camp_problem_counts["card"]])
	print("Problem counts (quiet): tape=%d habit=%d weight=%d tired=%d card=%d" % [
		quiet_problem_counts["tape"], quiet_problem_counts["habit"], quiet_problem_counts["weight"],
		quiet_problem_counts["tired"], quiet_problem_counts["card"]])
	# Lookup share: which problem kind is best most often?
	var lookup_share := _compute_lookup_share(camp_results)
	print("Lookup share: %.0f%% (the same kind of problem is best in this share of 2+ open weeks)" % lookup_share)
	# Write result file
	_write_result(camp_results, quiet_results, camp_open_counts, quiet_open_counts, camp_problem_counts, quiet_problem_counts,
		n_opponents, n_boxers, n_rows, camp_lengths, lookup_share)
	print("THURSDAY2 result written to docs/THURSDAY2_RESULT.md")
	print("RESULT: tools/thursday_probe.gd -> THURSDAY2 camps=%d opponents=%d camp weeks with 2+ open %.0f%% lookup %.0f%%" % [
		camp_idx, n_opponents, pct_2plus, lookup_share])
	quit(0)


## Runs one camp (one boxer, one career, up to BOUTS_PER_BOXER bouts). Returns {camp_thursdays, quiet_thursdays} or {}.
func _run_one_camp(seed_val: int, boxer_id: String, camp_num: int) -> Dictionary:
	var c := Career.quick_start()
	c.seed = seed_val
	var f: Dictionary
	if boxer_id == "lucy":
		Sim.sign(c, BOXER_PICKS["lucy"])
		f = c.fighter()
	else:
		# Sign a prospect: first invite, then wait for trial, then sign
		var p := _find_prospect(c, boxer_id)
		if p.is_empty():
			return {}
		p["state"] = "invited"
		p["trial_day"] = c.day + 1  # trial tomorrow
		# Step to trial day
		while c.day < int(p["trial_day"]):
			Sim.step_day(c)
		# Sign the prospect
		f = Roster.sign_prospect(c, boxer_id, BOXER_PICKS[boxer_id])
		if f.is_empty():
			return {}
	Sim.hire(c, "reid")
	# Measure quiet weeks (the 2 weeks before first offer)
	var quiet_thursdays := []
	var quiet_done := false
	# Step through up to BOUTS_PER_BOXER bouts
	var camp_thursdays := []
	for bout_num in BOUTS_PER_BOXER:
		# Wait for an offer
		var offer_id := ""
		for _step in 300:
			if not f["offers"].is_empty():
				for o in f["offers"]:
					if not bool(o["answered"]) and not bool(o["mismatch"]):
						offer_id = str(o["id"])
						break
				if offer_id != "":
					break
			# Measure quiet Thursdays before first bout
			if bout_num == 0 and not quiet_done and posmod(c.day, 7) == THURSDAY:
				var week_num := int(floor(c.day / 7.0)) + 1
				if week_num <= 2:
					var m := _measure_quiet_thursday(c, f)
					m["camp"] = camp_num
					m["boxer"] = boxer_id
					m["week"] = week_num
					quiet_thursdays.append(m)
			Sim.step_day(c)
			if c.day > 2000:  # safety
				break
		if offer_id == "":
			break
		# Accept the offer
		if not Bouts.accept(c, offer_id):
			break
		quiet_done = true
		# Start a camp
		var camp_focus := str(f.get("focus", "technique"))
		Bouts.start_camp(c, f, camp_focus, 2, true)  # protocol 2 = Standard, film true
		var camp_start := c.day
		var bout_day := int(f["bout"]["day"])
		var opp_name := str(f["bout"]["opp"]["name"])
		var prev_found := OppFile.found(f["bout"]["opp"]).duplicate()
		# Step through the camp, measuring every Thursday
		for _step in 200:
			if c.day >= bout_day:
				break
			# Weigh-in is the day before the fight
			if Bouts.weigh_in_today(c, f):
				Bouts.weigh(c, f)
			var dow := posmod(c.day, 7)
			if dow == THURSDAY:
				var week_num := int(floor((c.day - camp_start) / 7.0)) + 1
				var days_to_bell := bout_day - c.day
				var m := _measure_thursday(c, f, prev_found)
				m["camp"] = camp_num
				m["boxer"] = boxer_id
				m["opp"] = opp_name
				m["bout"] = bout_num + 1
				m["week"] = week_num
				m["days_to_bell"] = days_to_bell
				camp_thursdays.append(m)
				prev_found = OppFile.found(f["bout"]["opp"]).duplicate()
			Sim.step_day(c)
		# Step to fight day if needed (weigh-in should have happened during camp)
		while not Bouts.fight_day(c, f) and c.day <= bout_day:
			if Bouts.weigh_in_today(c, f):
				Bouts.weigh(c, f)
			Sim.step_day(c)
		# Fight night: sim to result
		if Bouts.fight_day(c, f):
			var modal := Bouts.fight_modal(f)
			Bouts.fight_step(c, f, modal, "sim")
			Bouts.after_fight(c, f)
		else:
			break
	return {"camp_thursdays": camp_thursdays, "quiet_thursdays": quiet_thursdays}


func _find_prospect(c: Career, id: String) -> Dictionary:
	for p in c.prospects:
		if str(p["id"]) == id:
			return p
	return {}


## Measures the five problems on a camp week Thursday.
func _measure_thursday(c: Career, f: Dictionary, prev_found: Array) -> Dictionary:
	var result := {"tape": 0, "habit": 0, "weight": 0, "tired": 0, "card": 0}
	var opp: Dictionary = f["bout"]["opp"]
	# TAPE: did a new tell open this week whose answer she does not own?
	var now_found := OppFile.found(opp)
	var new_tells := []
	for t in now_found:
		if not prev_found.has(t):
			new_tells.append(t)
	if new_tells.size() > 0:
		var owns_answer := false
		for tell_id in new_tells:
			if _owns_answer_for_tell(f, opp, tell_id):
				owns_answer = true
				break
		if not owns_answer:
			result["tape"] = 1
	# HABIT: does she have habits and did a sparring night run this week?
	var habits: Array = f.get("habits", [])
	if habits.size() > 0:
		var evs := PadWeek.evenings(f)
		var week_start := c.day - posmod(c.day, 7)
		var spar_ran := false
		for d in 7:
			var check_day := week_start + d
			if check_day > c.day:
				break
			if d < evs.size() and str(evs[d]) == "sparring":
				spar_ran = true
				break
		if spar_ran:
			result["habit"] = 1
	# WEIGHT: is she more than 0.3 kg above the limit?
	if float(f["weight"]) > float(f["limit"]) + 0.3:
		result["weight"] = 1
	# TIREDNESS: is week_peak within 5 of overreached (80)?
	if float(f.get("week_peak", 0.0)) >= WeekPlan.OVERREACHED - 5.0:
		result["tired"] = 1
	# CARD: is there a drill card not usable by taper start?
	if _has_card_not_ready_for_taper(c, f):
		result["card"] = 1
	return result


## Measures the five problems on a quiet week Thursday (no bout booked yet).
func _measure_quiet_thursday(c: Career, f: Dictionary) -> Dictionary:
	var result := {"tape": 0, "habit": 0, "weight": 0, "tired": 0, "card": 0}
	result["tape"] = 0  # no opponent, no tape study
	var habits: Array = f.get("habits", [])
	if habits.size() > 0:
		var evs := PadWeek.evenings(f)
		var spar_ran := false
		for d in 7:
			if d < evs.size() and str(evs[d]) == "sparring":
				spar_ran = true
				break
		if spar_ran:
			result["habit"] = 1
	result["weight"] = 0  # no limit set yet
	if float(f.get("week_peak", 0.0)) >= WeekPlan.OVERREACHED - 5.0:
		result["tired"] = 1
	if _has_card_not_usable(f):
		result["card"] = 1
	return result


## Checks if the fighter owns the plan answer for a tell (mastery 30+ for the moves that answer it).
func _owns_answer_for_tell(f: Dictionary, opp: Dictionary, tell_id: String) -> bool:
	var all_tells := OppFile.tells(opp)
	var tell := {}
	for t in all_tells:
		if str(t["id"]) == tell_id:
			tell = t
			break
	if tell.is_empty():
		return false
	var sit := PlanLines.tell_sit(tell)
	if sit == "":
		return false
	var mastery: Dictionary = f.get("moves", {})
	var combos: Dictionary = f.get("combos", {})
	for l in PlanLines.lines(f.get("arrows", [])):
		if PlanLines.sit_for(str(l["when"]), OppFile.main_game(opp)) != sit:
			continue
		var move_id := str(l["move"])
		var m := float(mastery.get(move_id, 0.0))
		if m >= 30.0:
			var fit := PlanFight.fit(move_id, sit)
			if fit == "best" or fit == "ok":
				return true
	for m_id in StrikeMap.MOVES:
		if str(m_id.get("kind", "")) == "combo":
			var rate := PlanFight.rate(str(m_id["id"]), combos)
			if rate >= 1.0 and PlanFight.fit(str(m_id["id"]), sit) == "best":
				return true
	return false


## Checks if there's a drill card that won't be usable (mastery 30) by taper start.
func _has_card_not_ready_for_taper(c: Career, f: Dictionary) -> bool:
	var bout_day := int(f["bout"]["day"])
	var weeks_to_taper := maxi(0, int(ceil((bout_day - c.day) / 7.0)) - 1)
	if weeks_to_taper <= 0:
		return false
	var nights := PadWeek.nights_of(f, false)
	var week := WeekPlan.ahead(f, c.day, 1)
	if week.is_empty():
		return false
	var coach := float(c.coach.get("rating", 50.0))
	var proj := PadWeek.project(f, nights, week[0], coach, 2.0, weeks_to_taper)
	for card_id in proj:
		var p: Dictionary = proj[card_id]
		if int(p.get("weeks30", -1)) < 0 or int(p.get("weeks30", 0)) > weeks_to_taper:
			var m := PadWeek.mastery(f, card_id)
			if m < 30.0:
				return true
	return false


## Checks if there's a card not yet usable (mastery < 30) - for quiet weeks.
func _has_card_not_usable(f: Dictionary) -> bool:
	var learning := str(f.get("combo_learning", ""))
	if learning != "":
		var m := float((f.get("combos", {}) as Dictionary).get(learning, 0.0))
		if m < 30.0:
			return true
	var moves: Dictionary = f.get("moves", {})
	for move_id in moves:
		var m := float(moves[move_id])
		if m > 0.0 and m < 30.0:
			return true
	return false


## Computes the lookup share: how often is the same kind of problem the "best" one to fix?
## Rule: the problem whose answer is worth most wins (simplest honest rule: count which problem appears most in 2+ open weeks).
func _compute_lookup_share(results: Array) -> float:
	var weeks_with_2plus := []
	for m in results:
		var open_count := int(m["tape"]) + int(m["habit"]) + int(m["weight"]) + int(m["tired"]) + int(m["card"])
		if open_count >= 2:
			weeks_with_2plus.append(m)
	if weeks_with_2plus.is_empty():
		return 0.0
	# For each 2+ open week, find which problem kind is "best" (most common across all 2+ weeks)
	var problem_totals := {"tape": 0, "habit": 0, "weight": 0, "tired": 0, "card": 0}
	for m in weeks_with_2plus:
		for k in ["tape", "habit", "weight", "tired", "card"]:
			if bool(m[k]):
				problem_totals[k] += 1
	# Find the most common problem
	var best_problem := ""
	var best_count := 0
	for k in ["tape", "habit", "weight", "tired", "card"]:
		if problem_totals[k] > best_count:
			best_count = problem_totals[k]
			best_problem = k
	if best_problem == "":
		return 0.0
	# How often is the best problem present in a 2+ open week?
	var best_present := 0
	for m in weeks_with_2plus:
		if bool(m[best_problem]):
			best_present += 1
	return 100.0 * best_present / weeks_with_2plus.size()


## Writes the result file.
func _write_result(camp_results: Array, quiet_results: Array, camp_open: Dictionary, quiet_open: Dictionary,
		camp_problems: Dictionary, quiet_problems: Dictionary, n_opponents: int, n_boxers: int, n_rows: int,
		camp_lengths: Dictionary, lookup_share: float) -> void:
	var lines: Array = []
	lines.append("# THURSDAY2 RESULT - how many real problems does a camp week throw up by Thursday?")
	lines.append("")
	lines.append("## Contract")
	lines.append("- 40+ camps, 5 boxers (Lucy + 4 prospects) x 4 bouts x different seeds")
	lines.append("- Thresholds: tape = tell opened whose answer she does not own (mastery < 30); habit = habits present + sparring night this week; weight = > 0.3 kg above limit; tired = week_peak >= 75 (OVERREACHED 80 - 5); card = drill card not usable by taper start")
	lines.append("")
	lines.append("## Spread")
	lines.append("- Distinct opponents: %d" % n_opponents)
	lines.append("- Distinct boxers: %d" % n_boxers)
	lines.append("- Distinct camp-week rows: %d" % n_rows)
	lines.append("- Camp lengths (days to bell): %s" % str(camp_lengths.keys()))
	lines.append("")
	lines.append("## Why THURSDAY1 collapsed")
	lines.append("THURSDAY1 set `c.seed` AFTER `Career.quick_start()` returned. The seed affects rival bout records (RivalPast.seed) but Lucy is always the same fighter (from Data.lucy()), and opponents are offered in a fixed order from Data.OPPONENTS. So all 40 'different seeds' produced the same camp: the same Lucy, the same opponent (Maria Ortega), the same tells, the same weeks. Setting the seed after quick_start changed nothing the count depends on.")
	lines.append("")
	lines.append("## Camp week Thursdays")
	lines.append("| Open count | Thursdays |")
	lines.append("|------------|-----------|")
	for k in 6:
		lines.append("| %d | %d |" % [k, int(camp_open.get(k, 0))])
	lines.append("")
	lines.append("## Quiet week Thursdays")
	lines.append("| Open count | Thursdays |")
	lines.append("|------------|-----------|")
	for k in 6:
		lines.append("| %d | %d |" % [k, int(quiet_open.get(k, 0))])
	lines.append("")
	lines.append("## Problem frequency (camp): tape=%d habit=%d weight=%d tired=%d card=%d" % [camp_problems["tape"], camp_problems["habit"], camp_problems["weight"], camp_problems["tired"], camp_problems["card"]])
	lines.append("## Problem frequency (quiet): tape=%d habit=%d weight=%d tired=%d card=%d" % [quiet_problems["tape"], quiet_problems["habit"], quiet_problems["weight"], quiet_problems["tired"], quiet_problems["card"]])
	lines.append("")
	lines.append("## Lookup share: %.0f%%" % lookup_share)
	lines.append("The same kind of problem is 'best' (most common in 2+ open weeks) %.0f%% of the time. If 70%%+, the choice is a lookup." % lookup_share)
	lines.append("")
	var total_camp := camp_results.size()
	var camp_2plus := 0
	for k in [2, 3, 4, 5]:
		camp_2plus += int(camp_open.get(k, 0))
	var pct_2plus := 100.0 * camp_2plus / maxi(1, total_camp)
	var most_common := _most_common_problem(camp_problems)
	var rarest := _rarest_problem(camp_problems)
	lines.append("## Analysis: five sentences")
	if pct_2plus >= 50.0 and lookup_share < 70.0:
		lines.append("1. 'One change on Thursday' IS a real choice: %.0f%% of camp weeks have 2+ open, no single problem dominates (%.0f%% lookup)." % [pct_2plus, lookup_share])
	elif pct_2plus >= 50.0:
		lines.append("1. Problems exist but choice is a lookup: %.0f%% have 2+ open, %.0f%% the best fix is the same." % [pct_2plus, lookup_share])
	else:
		lines.append("1. 'One change on Thursday' is NOT a real choice: only %.0f%% of camp weeks have 2+ open." % pct_2plus)
	lines.append("2. For the quiet week to have real problems, the game would need: sparring that reveals habits before the first bout, tape study from a Saturday ringside, and a weight line before a bout is booked.")
	lines.append("3. Most common camp problem: %s (%d times); rarest: %s (%d times)." % [most_common, int(camp_problems[most_common]), rarest, int(camp_problems[rarest])])
	if lookup_share >= 70.0:
		lines.append("4. Lookup share %.0f%% - always fix %s." % [lookup_share, most_common])
	else:
		lines.append("4. Lookup share %.0f%% - choice varies." % lookup_share)
	lines.append("5. What could not be measured: problem urgency, whether one fix addresses multiple problems, and the player's ability to anticipate problems.")
	var content := "\n".join(lines)
	var file := FileAccess.open("res://docs/THURSDAY2_RESULT.md", FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()


func _most_common_problem(problems: Dictionary) -> String:
	var best := "tape"
	var best_count := int(problems["tape"])
	for k in ["habit", "weight", "tired", "card"]:
		if int(problems[k]) > best_count:
			best_count = int(problems[k])
			best = k
	return best


func _rarest_problem(problems: Dictionary) -> String:
	var rarest := "tape"
	var min_count := int(problems["tape"])
	for k in ["habit", "weight", "tired", "card"]:
		if int(problems[k]) < min_count:
			min_count = int(problems[k])
			rarest = k
	return rarest
