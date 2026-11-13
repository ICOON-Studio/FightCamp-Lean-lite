extends SceneTree
## FIRELEVEL1: how much is sharp worth over usable, and signature over sharp?
## Start from tools/read_back_probe.gd: Lucy vs Maria Ortega (Pressure fighter), GOOD plan, no film, no shouts, 3 rounds.
## 400 paired bouts a cell, same seeds in every cell so cells are paired.
## CONTROL FIRST: no key must give the plain plan's 41.3% to the decimal.
## Then with shares A (0.6 / 0.8 / 1.0) and B (0.5 / 0.75 / 1.0), every plan line's mastery set to 35, then 65, then 90.
## Then one line at a time at 35 with the others at 65.
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/fire_level_probe.gd -- [bouts]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
## The combos the plan reads: 1-1 is a combo, step_back/pivot_out/tie_up are steps/defences (mastery 100).
## For combos, the mastery field is f["combos"]["1-1"]. For steps/defences, mastery is 100 (always fires).
## The probe sets f["combos"]["1-1"] to control the combo line's mastery.
## The other three lines (step_back, pivot_out, tie_up) are steps/defences and always fire at 100.


func _initialize() -> void:
	var n := 400
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("FIRELEVEL1 population: Lucy vs Maria Ortega (Pressure fighter), GOOD plan %s, film 0, no shouts, 3 rounds, n=%d per cell, same dice days" % [str(GOOD.map(func(a): return a["move"])), n])
	# 1. CONTROL: no key -> today's game (41.3% to the decimal)
	# The control uses mastery 50 (matching read_back_probe.gd) so the combo can be used.
	print("--- 1. CONTROL ---")
	var ctrl := _run_cell("control (no key)", {}, 50.0, n)
	print("CTRL no key       -> %s" % ctrl)
	# 2. SHARES A: 0.6 / 0.8 / 1.0 at mastery 35, 65, 90
	print("--- 2. SHARES A (0.6/0.8/1.0) ---")
	var shares_a := {"usable": 0.6, "sharp": 0.8, "signature": 1.0}
	var a35 := _run_cell("A mastery 35", shares_a, 35.0, n)
	var a65 := _run_cell("A mastery 65", shares_a, 65.0, n)
	var a90 := _run_cell("A mastery 90", shares_a, 90.0, n)
	print("A mastery 35      -> %s" % a35)
	print("A mastery 65      -> %s" % a65)
	print("A mastery 90      -> %s" % a90)
	# 3. SHARES B: 0.5 / 0.75 / 1.0 at mastery 35, 65, 90
	print("--- 3. SHARES B (0.5/0.75/1.0) ---")
	var shares_b := {"usable": 0.5, "sharp": 0.75, "signature": 1.0}
	var b35 := _run_cell("B mastery 35", shares_b, 35.0, n)
	var b65 := _run_cell("B mastery 65", shares_b, 65.0, n)
	var b90 := _run_cell("B mastery 90", shares_b, 90.0, n)
	print("B mastery 35      -> %s" % b35)
	print("B mastery 65      -> %s" % b65)
	print("B mastery 90      -> %s" % b90)
	# 4. ONE LINE AT A TIME: 1-1 at 35, others at 65 (1-1 is the only combo; others are steps/defences at 100)
	# Since step_back/pivot_out/tie_up are steps/defences, they always fire at 100 regardless of the key.
	# The only line whose mastery we can set is 1-1 (the combo). So "one line at a time at 35 with others at 65"
	# means 1-1 at 35 (the others are steps at 100, which is above signature).
	print("--- 4. ONE LINE AT A TIME ---")
	var one_35 := _run_cell("1-1 at 35 (steps at 100)", shares_a, 35.0, n)
	print("1-1 at 35 (steps at 100) -> %s" % one_35)
	# 5. SUMMARY TABLE
	print("--- 5. SUMMARY TABLE ---")
	print("cell                          win%")
	var ctrl_pct := _extract_pct(ctrl)
	var a35_pct := _extract_pct(a35)
	var a65_pct := _extract_pct(a65)
	var a90_pct := _extract_pct(a90)
	var b35_pct := _extract_pct(b35)
	var b65_pct := _extract_pct(b65)
	var b90_pct := _extract_pct(b90)
	print("control (no key)              %.1f" % ctrl_pct)
	print("A usable 0.6 sharp 0.8 sig 1.0")
	print("  mastery 35 (usable)         %.1f  (%.1f vs ctrl)" % [a35_pct, a35_pct - ctrl_pct])
	print("  mastery 65 (sharp)          %.1f  (%.1f vs ctrl, +%.1f vs 35)" % [a65_pct, a65_pct - ctrl_pct, a65_pct - a35_pct])
	print("  mastery 90 (signature)      %.1f  (%.1f vs ctrl, +%.1f vs 65)" % [a90_pct, a90_pct - ctrl_pct, a90_pct - a65_pct])
	print("B usable 0.5 sharp 0.75 sig 1.0")
	print("  mastery 35 (usable)         %.1f  (%.1f vs ctrl)" % [b35_pct, b35_pct - ctrl_pct])
	print("  mastery 65 (sharp)          %.1f  (%.1f vs ctrl, +%.1f vs 35)" % [b65_pct, b65_pct - ctrl_pct, b65_pct - b35_pct])
	print("  mastery 90 (signature)      %.1f  (%.1f vs ctrl, +%.1f vs 65)" % [b90_pct, b90_pct - ctrl_pct, b90_pct - b65_pct])
	print("--- PROBE COMPLETE ---")
	print("RESULT: tools/fire_level_probe.gd -> control %.1f A usable %.1f sharp %.1f signature %.1f" % [ctrl_pct, a35_pct, a65_pct, a90_pct])
	quit(0)


func _extract_pct(result: String) -> float:
	var idx := result.find("bouts won ")
	if idx < 0:
		return 0.0
	var sub := result.substr(idx + 10)
	var pct_str := sub.substr(0, sub.find("%"))
	return float(pct_str)


func _run_cell(label: String, fire_level: Dictionary, combo_mastery: float, n: int) -> String:
	var bouts_won := 0
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = 60.0
		# FIRELEVEL1: set the combo mastery for 1-1 (the only combo in the GOOD plan).
		# The other lines (step_back, pivot_out, tie_up) are steps/defences and always fire at 100.
		f["combos"] = {"1-1": combo_mastery, "1-2": combo_mastery}
		f["arrows"] = GOOD.duplicate(true)
		c.coach = {}
		var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
		f["bout"]["fire_level"] = fire_level.duplicate()   # S450: always explicit; {} = today's game (no key now = the game's shares)
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "start")
		while true:
			while not LiveRound.live(m).is_empty():
				Bouts.fight_step(c, f, m, "shout:")
			if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
				break
			Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		Bouts.fight_step(c, f, m, "end")
		bouts_won += int(str(m.get("outcome", "")) == "win")
	return "bouts won %.1f%%" % (100.0 * bouts_won / n)
