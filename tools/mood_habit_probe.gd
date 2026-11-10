extends SceneTree
## MOODHABIT1: what a boxer's mood and each habit are worth in wins. Measure only.
## Start from tools/fire_level_probe.gd: Lucy vs opponent, GOOD plan, 400 paired bouts a cell, same seeds.
## CONTROL FIRST: Steady (morale 60) with corner calling must reproduce fire_level_probe's ~41.3% within 1 point.
## MOOD: Fired up (80), Steady (60), Flat (40), Low (20) - twice: corner calls, corner silent.
## HABITS: each of FighterProfile.HABITS, with and without, against punishing and non-punishing opponents.
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/mood_habit_probe.gd -- [bouts]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const HabitFix := preload("res://scripts/rules/HabitFix.gd")
const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]

## Opponents by style: who punishes which situation.
## Counter-puncher (Priya): counter situations -> drops_right_after_jab, talks_when_ahead, admires_her_work, bites_on_feints, chases_stoppage
## Pressure fighter (Maria): press situations -> freezes_on_ropes, switches_stance_under_pressure, retreats_straight_back, head_down_inside, one_and_done
## Volume puncher (Erin): press situations -> same as pressure
## Out-boxer: range situations -> wide_hook_tell, lunges_with_jab, waits_too_long

func _initialize() -> void:
	var n := 400
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("MOODHABIT1 population: Lucy vs opponents, GOOD plan, film 0, n=%d per cell, same dice days" % n)
	
	## 1. CONTROL: Steady (morale 60), corner calls, Maria Ortega (reproduces fire_level_probe's ~41.3%)
	print("--- 1. CONTROL ---")
	var ctrl := _run_cell("control", 60.0, "calls", "Maria Ortega", [], [], n)
	print("CTRL Steady calls Maria -> %s" % ctrl)
	var ctrl_pct := _extract_pct(ctrl)
	
	## 2. MOOD: four morale levels, corner calls vs silent, vs Maria Ortega (same opponent as control)
	print("--- 2. MOOD (corner calls) ---")
	var fired_calls := _run_cell("Fired up", 80.0, "calls", "Maria Ortega", [], [], n)
	var steady_calls := _run_cell("Steady", 60.0, "calls", "Maria Ortega", [], [], n)
	var flat_calls := _run_cell("Flat", 40.0, "calls", "Maria Ortega", [], [], n)
	var low_calls := _run_cell("Low", 20.0, "calls", "Maria Ortega", [], [], n)
	print("Fired up calls Maria -> %s" % fired_calls)
	print("Steady calls Maria   -> %s" % steady_calls)
	print("Flat calls Maria     -> %s" % flat_calls)
	print("Low calls Maria      -> %s" % low_calls)
	
	print("--- 2b. MOOD (corner silent) ---")
	var fired_silent := _run_cell("Fired up", 80.0, "silent", "Maria Ortega", [], [], n)
	var steady_silent := _run_cell("Steady", 60.0, "silent", "Maria Ortega", [], [], n)
	var flat_silent := _run_cell("Flat", 40.0, "silent", "Maria Ortega", [], [], n)
	var low_silent := _run_cell("Low", 20.0, "silent", "Maria Ortega", [], [], n)
	print("Fired up silent Maria -> %s" % fired_silent)
	print("Steady silent Maria   -> %s" % steady_silent)
	print("Flat silent Maria     -> %s" % flat_silent)
	print("Low silent Maria      -> %s" % low_silent)
	
	## 3. HABITS: each habit, with and without, against punishing and non-punishing opponents
	print("--- 3. HABITS ---")
	var habits := FighterProfile.HABITS.duplicate()
	var habit_results := []
	for habit_id in habits:
		## Find a punishing opponent (based on HabitFix.PUNISHED_BY) and a non-punishing one
		var punish_sits: Array = HabitFix.PUNISHED_BY.get(habit_id, [])
		var punish_opp := _find_punishing_opponent(punish_sits)
		var safe_opp := _find_safe_opponent(punish_sits)
		
		## With habit vs without, against punishing opponent
		var with_punish := _run_cell("with %s" % habit_id, 60.0, "calls", punish_opp.get("name", "Maria Ortega"), [habit_id], [], n)
		var without_punish := _run_cell("without %s" % habit_id, 60.0, "calls", punish_opp.get("name", "Maria Ortega"), [], [], n)
		var with_p := _extract_pct(with_punish)
		var without_p := _extract_pct(without_punish)
		var gap_punish := with_p - without_p
		
		## With habit vs without, against safe opponent
		var with_safe := _run_cell("with %s" % habit_id, 60.0, "calls", safe_opp.get("name", "Priya Nair"), [habit_id], [], n)
		var without_safe := _run_cell("without %s" % habit_id, 60.0, "calls", safe_opp.get("name", "Priya Nair"), [], [], n)
		var with_s := _extract_pct(with_safe)
		var without_s := _extract_pct(without_safe)
		var gap_safe := with_s - without_s
		
		habit_results.append({"id": habit_id, "punish_opp": punish_opp.get("name", "?"), "safe_opp": safe_opp.get("name", "?"),
			"with_punish": with_p, "without_punish": without_p, "gap_punish": gap_punish,
			"with_safe": with_s, "without_safe": without_s, "gap_safe": gap_safe})
		print("CELL kind=habit name=%s corner=calls opp=%s wins=%.1f (without=%.1f, gap=%.1f) opp_safe=%s wins=%.1f (without=%.1f, gap=%.1f)" % [
			habit_id, punish_opp.get("name", "?"), with_p, without_p, gap_punish, safe_opp.get("name", "?"), with_s, without_s, gap_safe])
	
	## 4. SUMMARY
	print("--- 4. SUMMARY TABLE ---")
	print("cell                          win%    gap")
	var fired_c_pct := _extract_pct(fired_calls)
	var steady_c_pct := _extract_pct(steady_calls)
	var flat_c_pct := _extract_pct(flat_calls)
	var low_c_pct := _extract_pct(low_calls)
	print("CONTROL Steady calls Maria    %.1f" % ctrl_pct)
	print("MOOD corner calls vs Maria:")
	print("  Fired up (80)               %.1f  (%.1f vs Steady)" % [fired_c_pct, fired_c_pct - steady_c_pct])
	print("  Steady (60)                 %.1f" % steady_c_pct)
	print("  Flat (40)                   %.1f  (%.1f vs Steady)" % [flat_c_pct, flat_c_pct - steady_c_pct])
	print("  Low (20)                    %.1f  (%.1f vs Steady)" % [low_c_pct, low_c_pct - steady_c_pct])
	
	var fired_s_pct := _extract_pct(fired_silent)
	var steady_s_pct := _extract_pct(steady_silent)
	var flat_s_pct := _extract_pct(flat_silent)
	var low_s_pct := _extract_pct(low_silent)
	print("MOOD corner silent vs Maria:")
	print("  Fired up (80)               %.1f  (%.1f vs Steady)" % [fired_s_pct, fired_s_pct - steady_s_pct])
	print("  Steady (60)                 %.1f" % steady_s_pct)
	print("  Flat (40)                   %.1f  (%.1f vs Steady)" % [flat_s_pct, flat_s_pct - steady_s_pct])
	print("  Low (20)                    %.1f  (%.1f vs Steady)" % [low_s_pct, low_s_pct - steady_s_pct])
	
	## Find best and worst habits
	var best_habit_gap := 0.0
	var best_habit_name := ""
	for hr in habit_results:
		if absf(hr["gap_punish"]) > absf(best_habit_gap):
			best_habit_gap = hr["gap_punish"]
			best_habit_name = hr["id"]
	
	print("--- PROBE COMPLETE ---")
	print("RESULT: tools/mood_habit_probe.gd -> MOODHABIT1 cells=%d flat_gap=%.1f best_habit_gap=%.1f" % [
		4 + 4 + habits.size() * 2, flat_c_pct - steady_c_pct, best_habit_gap])
	quit(0)


func _find_punishing_opponent(situations: Array) -> Dictionary:
	## Find an opponent whose style creates one of these situations
	for opp in Data.OPPONENTS:
		var style: String = str(opp.get("style", ""))
		## Counter-puncher creates "counter" situations
		if style == "Counter-puncher" and situations.has("counter"):
			return opp
		## Pressure fighter creates "press" situations
		if style == "Pressure fighter" and situations.has("press"):
			return opp
		## Volume puncher creates "press" situations
		if style == "Volume puncher" and situations.has("press"):
			return opp
		## Out-boxer creates "range" situations
		if style == "Out-boxer" and situations.has("range"):
			return opp
	## Clock habits (slow_starter, fades_late) or habits with no punish - use Maria as default
	if situations.is_empty():
		return Data.OPPONENTS[0]
	## Fallback: return first opponent
	return Data.OPPONENTS[0]


func _find_safe_opponent(situations: Array) -> Dictionary:
	## Find an opponent whose style does NOT create any of these situations
	for opp in Data.OPPONENTS:
		var style: String = str(opp.get("style", ""))
		var creates_punish := false
		if style == "Counter-puncher" and situations.has("counter"):
			creates_punish = true
		if style == "Pressure fighter" and situations.has("press"):
			creates_punish = true
		if style == "Volume puncher" and situations.has("press"):
			creates_punish = true
		if style == "Out-boxer" and situations.has("range"):
			creates_punish = true
		if not creates_punish:
			return opp
	## All opponents punish this habit - return last one as fallback
	return Data.OPPONENTS[Data.OPPONENTS.size() - 1]


func _extract_pct(result: String) -> float:
	var idx := result.find("bouts won ")
	if idx < 0:
		return 0.0
	var sub := result.substr(idx + 10)
	var pct_str := sub.substr(0, sub.find("%"))
	return float(pct_str)


func _run_cell(label: String, morale: float, corner_mode: String, opp_name: String, add_habits: Array, remove_habits: Array, n: int) -> String:
	var bouts_won := 0
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = morale
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = GOOD.duplicate(true)
		c.coach = {}
		
		## Find the opponent by name
		var opp: Dictionary = {}
		for o in Data.OPPONENTS:
			if str(o.get("name", "")) == opp_name:
				opp = (o as Dictionary).duplicate(true)
				break
		if opp.is_empty():
			opp = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		
		## Modify habits: add habits in add_habits, remove habits in remove_habits
		var current_habits: Array = f.get("habits", []).duplicate()
		for h in add_habits:
			if not current_habits.has(h):
				current_habits.append(h)
		for h in remove_habits:
			current_habits.erase(h)
		f["habits"] = current_habits
		
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "start")
		while true:
			while not LiveRound.live(m).is_empty():
				if corner_mode == "silent":
					Bouts.fight_step(c, f, m, "shout:")
				else:
					Bouts.fight_step(c, f, m, "shout:")
			if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
				break
			if corner_mode == "silent":
				## Silent corner: pass empty string after "corner:"
				Bouts.fight_step(c, f, m, "corner:")
			else:
				Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		Bouts.fight_step(c, f, m, "end")
		bouts_won += int(str(m.get("outcome", "")) == "win")
	return "bouts won %.1f%%" % (100.0 * bouts_won / n)


## MOODHABIT1 RESULT
