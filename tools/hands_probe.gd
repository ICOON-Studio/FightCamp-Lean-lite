extends SceneTree
## HANDSPROBE1 - how scarce are Reid's hands really? Measure only.
## Runs 40+ camps (5 boxers x 4 bouts x seeds). At TAPER START (first day phase == "taper",
## i.e. the Monday of fight week when weeks_to_bell <= 1) records: how many tells need answers,
## how many the boxer owns (mastery 30+), weeks from offer to bell, first-usable week per owned line.
## Four cells per camp on the same seeds:
##   (a) default week, Reid hired (Standard protocol 2: 2 pad + 2 spar)
##   (b) default week, no coach hired (coach rating 50)
##   (c) Hard protocol 3: 3 pad + 2 spar (one extra pad night)
##   (d) Light protocol 1: 2 pad + 1 spar (one fewer spar night; the game has no 1-pad protocol)
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/hands_probe.gd -- 40

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Roster := preload("res://scripts/state/Roster.gd")

const CAMPS_MIN := 10
const BOUTS_PER_BOXER := 4
const BOXER_IDS := ["lucy", "kira", "samira", "tess", "danny"]
const BOXER_PICKS := {
	"lucy": ["Jab and move", "Pad rounds", "Hill sprints"],
	"kira": ["Jab and move", "Defence drills", "Hill sprints"],
	"samira": ["Body work", "Pad rounds", "Hill sprints"],
	"tess": ["Pad rounds", "Hill sprints", "Defence drills"],
	"danny": ["Jab and move", "Pad rounds", "Body work"],
}
const CELLS := ["a", "b", "c", "d"]


func _initialize() -> void:
	var n := CAMPS_MIN
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("HANDSPROBE1 probe: %d+ camps, 5 boxers x 4 bouts x different seeds, 4 cells" % n)
	var all_results := []
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
			var results := _run_one_camp_all_cells(seed_val, boxer_id, camp_idx + 1)
			if results.is_empty():
				continue
			for r in results:
				all_results.append(r)
				distinct_opponents[r["opp"]] = true
				distinct_boxers[r["boxer"]] = true
				var row := "%s|%s|%d|%s" % [r["boxer"], r["opp"], r["bout"], r["cell"]]
				distinct_rows[row] = true
			camp_idx += 1
		if seed_idx > 100:
			break
	var n_opponents := distinct_opponents.size()
	var n_boxers := distinct_boxers.size()
	var n_rows := distinct_rows.size()
	print("")
	print("HANDSPROBE1 spread opponents=%d boxers=%d rows=%d" % [n_opponents, n_boxers, n_rows])
	if n_opponents < 10 or n_rows < 12:
		print("VOID: under 10 opponents or under 12 distinct rows")
		var void_content := "# HANDSPROBE1 RESULT - VOID\n\nUnder 10 opponents (%d) or under 12 distinct rows (%d).\n" % [n_opponents, n_rows]
		var vf := FileAccess.open("res://docs/HANDSPROBE1_RESULT.md", FileAccess.WRITE)
		if vf:
			vf.store_string(void_content)
			vf.close()
		quit(1)
		return
	# Print one line per camp and cell
	print("")
	print("--- HANDS MEASUREMENTS ---")
	for r in all_results:
		print("HANDS camp=%d cell=%s opp=%s needs=%d owned_at_taper=%d weeks_offer_to_bell=%d" % [
			r["camp"], r["cell"], r["opp"], r["needs"], r["owned"], r["weeks_offer_bell"]])
	# Summary per cell
	print("")
	print("--- SUMMARY ---")
	_write_result(all_results, n_opponents, n_boxers, n_rows, camp_idx)
	print("HANDSPROBE1 result written to docs/HANDSPROBE1_RESULT.md")
	var total_camps := camp_idx
	var all_owned_default := _count_all_owned(all_results, "a")
	var pct := 100.0 * all_owned_default / maxi(1, total_camps)
	print("RESULT: tools/hands_probe.gd -> HANDSPROBE1 camps=%d all_owned_default=%d%%" % [total_camps, pct])
	quit(0)


## Runs one camp in all 4 cells. Returns array of result dicts (one per cell per bout) or [].
func _run_one_camp_all_cells(seed_val: int, boxer_id: String, camp_num: int) -> Array:
	var results := []
	for cell in CELLS:
		var cell_results := _run_one_career_all_bouts(seed_val, boxer_id, camp_num, cell)
		results.append_array(cell_results)
	return results


## Runs one career with BOUTS_PER_BOXER bouts in one cell. Returns array of result dicts.
func _run_one_career_all_bouts(seed_val: int, boxer_id: String, camp_num: int, cell: String) -> Array:
	var results := []
	var c := Career.quick_start()
	c.seed = seed_val
	var f: Dictionary
	if boxer_id == "lucy":
		Sim.sign(c, BOXER_PICKS["lucy"])
		f = c.fighter()
	else:
		var p := _find_prospect(c, boxer_id)
		if p.is_empty():
			return results
		p["state"] = "invited"
		p["trial_day"] = c.day + 1
		while c.day < int(p["trial_day"]):
			Sim.step_day(c)
		f = Roster.sign_prospect(c, boxer_id, BOXER_PICKS[boxer_id])
		if f.is_empty():
			return results
	# Cell b: no coach hired. All other cells: hire Reid.
	if cell != "b":
		Sim.hire(c, "reid")
	# Determine protocol based on cell
	var protocol := 2  # Standard
	if cell == "c":
		protocol = 3  # Hard: 3 pad nights
	elif cell == "d":
		protocol = 1  # Light: 1 spar night (same 2 pad nights)
	# Run BOUTS_PER_BOXER bouts
	for bout_num in BOUTS_PER_BOXER:
		var r := _run_one_bout(c, f, camp_num, cell, protocol, bout_num, boxer_id)
		if not r.is_empty():
			results.append(r)
	return results


## Runs one bout (camp + measurement). Returns a result dict or {}.
func _run_one_bout(c: Career, f: Dictionary, camp_num: int, cell: String, protocol: int, bout_num: int, boxer_id: String) -> Dictionary:
	# Wait for an offer, track the offer day
	var offer_day := -1
	var offer_id := ""
	for _step in 300:
		if not f["offers"].is_empty():
			for o in f["offers"]:
				if not bool(o["answered"]) and not bool(o["mismatch"]):
					offer_id = str(o["id"])
					offer_day = c.day
					break
			if offer_id != "":
				break
		Sim.step_day(c)
		if c.day > 2000:
			break
	if offer_id == "":
		return {}
	if not Bouts.accept(c, offer_id):
		return {}
	var camp_focus := str(f.get("focus", "technique"))
	Bouts.start_camp(c, f, camp_focus, protocol, true)
	var camp_start := c.day
	var bout_day := int(f["bout"]["day"])
	var opp_name := str(f["bout"]["opp"]["name"])
	var weeks_offer_bell := int(ceil(float(bout_day - offer_day) / 7.0))
	# Track mastery snapshots at end of each camp week (to find first-usable week)
	var mastery_history := []  # [{week, moves, combos}]
	var taper_reached := false
	var taper_day := -1
	# Step through the camp
	for _step in 200:
		if c.day >= bout_day:
			break
		if Bouts.weigh_in_today(c, f):
			Bouts.weigh(c, f)
		# Check if taper starts today
		var ph := WeekPhase.phase(f.get("bout", {}), c.day)
		if ph == "taper" and not taper_reached:
			taper_reached = true
			taper_day = c.day
			break
		# Record mastery at end of each week (every Sunday, day 6 of week)
		if posmod(c.day, 7) == 6:
			var week_num := int(floor((c.day - camp_start) / 7.0)) + 1
			var snap := {"week": week_num, "moves": f.get("moves", {}).duplicate(),
				"combos": f.get("combos", {}).duplicate()}
			mastery_history.append(snap)
		Sim.step_day(c)
	if not taper_reached:
		# Taper didn't start before fight day - measure at fight day
		taper_day = bout_day
	# At taper start: measure needs vs owned
	var opp: Dictionary = f["bout"]["opp"]
	var all_tells := OppFile.tells(opp)
	var needs := 0
	var owned_count := 0
	var owned_details := []  # [{tell_id, sit, first_week30}]
	for tell in all_tells:
		var sit := PlanLines.tell_sit(tell)
		if sit == "":
			continue
		needs += 1
		if _owns_answer_for_tell(f, opp, str(tell["id"])):
			owned_count += 1
			# Find first week this answer reached 30
			var first_week := _find_first_week30(f, opp, str(tell["id"]), mastery_history, camp_start)
			owned_details.append({"tell_id": str(tell["id"]), "sit": sit, "first_week30": first_week})
	# Step to fight day if needed
	while not Bouts.fight_day(c, f) and c.day <= bout_day:
		if Bouts.weigh_in_today(c, f):
			Bouts.weigh(c, f)
		Sim.step_day(c)
	# Fight night: sim to result
	if Bouts.fight_day(c, f):
		var modal := Bouts.fight_modal(f)
		Bouts.fight_step(c, f, modal, "sim")
		Bouts.after_fight(c, f)
	return {"camp": camp_num, "cell": cell, "boxer": boxer_id, "opp": opp_name,
		"bout": bout_num + 1, "needs": needs, "owned": owned_count,
		"weeks_offer_bell": weeks_offer_bell, "owned_details": owned_details,
		"taper_day": taper_day, "camp_start": camp_start}


func _find_prospect(c: Career, id: String) -> Dictionary:
	for p in c.prospects:
		if str(p["id"]) == id:
			return p
	return {}


## Checks if the fighter owns the plan answer for a tell (mastery 30+ for moves that answer it).
## Same test as thursday_probe.
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


## Finds the first camp week when the answer for a tell reached mastery 30.
## Uses mastery_history snapshots taken at end of each week.
func _find_first_week30(f: Dictionary, opp: Dictionary, tell_id: String, history: Array, _camp_start: int) -> int:
	var all_tells := OppFile.tells(opp)
	var tell := {}
	for t in all_tells:
		if str(t["id"]) == tell_id:
			tell = t
			break
	if tell.is_empty():
		return -1
	var sit := PlanLines.tell_sit(tell)
	if sit == "":
		return -1
	# Check each week's snapshot to find when the answer first had mastery 30+
	for snap in history:
		var moves: Dictionary = snap["moves"]
		var combos: Dictionary = snap["combos"]
		if _has_answer_at_30(f, opp, tell, sit, moves, combos):
			return int(snap["week"])
	return -1


## Checks if the answer for a tell is at mastery 30+ in the given moves/combos state.
func _has_answer_at_30(f: Dictionary, opp: Dictionary, tell: Dictionary, sit: String, mastery: Dictionary, combos: Dictionary) -> bool:
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


## Counts camps where ALL needs are owned in a given cell.
func _count_all_owned(results: Array, cell: String) -> int:
	var camps := {}
	for r in results:
		if r["cell"] != cell:
			continue
		var camp := int(r["camp"])
		if not camps.has(camp):
			camps[camp] = true
	var all_owned := 0
	for r in results:
		if r["cell"] != cell:
			continue
		if int(r["needs"]) > 0 and int(r["owned"]) >= int(r["needs"]):
			all_owned += 1
	return all_owned


## Writes the result file.
func _write_result(results: Array, n_opponents: int, n_boxers: int, n_rows: int, total_camps: int) -> void:
	var lines: Array = []
	lines.append("# HANDSPROBE1 RESULT - how scarce are Reid's hands really?")
	lines.append("")
	lines.append("## Contract")
	lines.append("- 40+ camps, 5 boxers (Lucy + 4 prospects) x 4 bouts x different seeds")
	lines.append("- Four cells per camp on same seeds:")
	lines.append("  - (a) Default Standard protocol (2 pad + 2 spar nights), Reid hired")
	lines.append("  - (b) Default Standard protocol, no coach hired (rating 50)")
	lines.append("  - (c) Hard protocol (3 pad + 2 spar nights), Reid hired - one extra pad night")
	lines.append("  - (d) Light protocol (2 pad + 1 spar night), Reid hired - one fewer spar night")
	lines.append("- Taper start: first day where WeekPhase.phase() == 'taper' (Monday of fight week, weeks_to_bell <= 1)")
	lines.append("- Owned: mastery 30+ on a move that fits the tell's situation (best or ok)")
	lines.append("")
	lines.append("## Spread")
	lines.append("- Distinct opponents: %d" % n_opponents)
	lines.append("- Distinct boxers: %d" % n_boxers)
	lines.append("- Distinct camp-cell rows: %d" % n_rows)
	lines.append("- Total camps: %d" % total_camps)
	lines.append("")
	# Table per cell
	for cell in CELLS:
		var cell_results: Array = results.filter(func(r): return r["cell"] == cell)
		lines.append("## Cell %s" % cell)
		lines.append("| Category | Count |")
		lines.append("|----------|-------|")
		var all_owned := 0
		var all_but_one := 0
		var half_or_less := 0
		var total := 0
		var sum_weeks_offer := 0
		var sum_first_usable := 0
		var count_first_usable := 0
		for r in cell_results:
			var needs := int(r["needs"])
			var owned := int(r["owned"])
			if needs == 0:
				continue
			total += 1
			sum_weeks_offer += int(r["weeks_offer_bell"])
			if owned >= needs:
				all_owned += 1
			elif owned >= needs - 1:
				all_but_one += 1
			if needs > 0 and float(owned) <= float(needs) / 2.0:
				half_or_less += 1
			for d in r.get("owned_details", []):
				var fw := int(d.get("first_week30", -1))
				if fw > 0:
					sum_first_usable += fw
					count_first_usable += 1
		if total > 0:
			lines.append("| Camps with needs > 0 | %d |" % total)
			lines.append("| All owned at taper | %d (%.0f%%) |" % [all_owned, 100.0 * all_owned / total])
			lines.append("| All but one owned | %d (%.0f%%) |" % [all_but_one, 100.0 * all_but_one / total])
			lines.append("| Half or fewer owned | %d (%.0f%%) |" % [half_or_less, 100.0 * half_or_less / total])
			lines.append("| Mean weeks offer to bell | %.1f |" % [float(sum_weeks_offer) / total])
			if count_first_usable > 0:
				lines.append("| Mean first-usable week | %.1f |" % [float(sum_first_usable) / count_first_usable])
			else:
				lines.append("| Mean first-usable week | N/A |")
		else:
			lines.append("| No camps with needs | 0 |")
		lines.append("")
	# Overall summary
	var default_results: Array = results.filter(func(r): return r["cell"] == "a")
	var default_all_owned := 0
	var default_total := 0
	for r in default_results:
		if int(r["needs"]) > 0:
			default_total += 1
			if int(r["owned"]) >= int(r["needs"]):
				default_all_owned += 1
	var pct_all_owned := 100.0 * default_all_owned / maxi(1, default_total)
	lines.append("## Summary")
	lines.append("- Share of camps where EVERY answer is owned at taper (default cell a): %.0f%% (%d/%d)" % [pct_all_owned, default_all_owned, default_total])
	if pct_all_owned >= 70.0:
		lines.append("- **Reid's hands are NOT scarce on the default week**: %.0f%% of camps have all answers owned by taper." % pct_all_owned)
	else:
		lines.append("- **Reid's hands ARE scarce on the default week**: only %.0f%% of camps have all answers owned by taper." % pct_all_owned)
	# Mean weeks offer to bell and first-usable
	var sum_offer := 0
	var sum_usable := 0
	var cnt_usable := 0
	for r in default_results:
		sum_offer += int(r["weeks_offer_bell"])
		for d in r.get("owned_details", []):
			var fw := int(d.get("first_week30", -1))
			if fw > 0:
				sum_usable += fw
				cnt_usable += 1
	var mean_offer := float(sum_offer) / maxi(1, default_total)
	var mean_usable := float(sum_usable) / maxi(1, cnt_usable)
	lines.append("- Mean weeks from offer to bell: %.1f" % mean_offer)
	lines.append("- Mean first-usable week (when answers reach 30): %.1f" % mean_usable)
	lines.append("")
	# Five sentences
	lines.append("## Analysis: five sentences")
	var missing_pct := 100.0 - pct_all_owned
	lines.append("1. The default week leaves at least one answer missing at taper in %.0f%% of camps." % missing_pct)
	# Compare cells
	var cell_all_owned := {}
	for cell in CELLS:
		var cr: Array = results.filter(func(r): return r["cell"] == cell)
		var co := 0
		var ct := 0
		for r in cr:
			if int(r["needs"]) > 0:
				ct += 1
				if int(r["owned"]) >= int(r["needs"]):
					co += 1
		cell_all_owned[cell] = 100.0 * co / maxi(1, ct)
	lines.append("2. Extra pad night (cell c): %.0f%% all owned; no coach (cell b): %.0f%%; fewer spar nights (cell d): %.0f%%." % [
		cell_all_owned.get("c", 0.0), cell_all_owned.get("b", 0.0), cell_all_owned.get("d", 0.0)])
	# PadWeek.NIGHTS says what?
	lines.append("3. PadWeek.NIGHTS['camp'] = [[2,1], [2,2], [3,2]]: Light has 2 pad nights, Standard 2, Hard 3. 'Two evenings' is the game's Standard number; the design v3 number.")
	# Which cell comes closest to a real squeeze?
	var squeeze_cell := "b"
	var squeeze_pct := 100.0
	for cell in CELLS:
		var p: float = float(cell_all_owned.get(cell, 100.0))
		if p < squeeze_pct:
			squeeze_pct = p
			squeeze_cell = cell
	lines.append("4. Cell %s comes closest to a real squeeze: only %.0f%% have all answers owned at taper." % [squeeze_cell, squeeze_pct])
	lines.append("5. What could not be measured: whether the player's evening edits change the picture, the effect of film nights taking pad time, and whether answers are owned in time for the player to actually use them in corner calls.")
	var content := "\n".join(lines)
	var file := FileAccess.open("res://docs/HANDSPROBE1_RESULT.md", FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()
