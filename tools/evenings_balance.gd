extends SceneTree
## S382 EVENINGS1 balance check ("the strip is the truth": the sim's evenings follow PadWeek's nights). Three fighters -
## Lucy (Luke Reid), Danny (Hale), Josh (no coach):
## - BETWEEN FIGHTS: 8 weeks of Sim.step_day with no bout, her TrainingLoad Standard and Hard: every stat's gain a week,
##   the fatigue peak, the week's hours (Injuries.week_hours) and the move masteries the nights drill.
## - CAMP: a bout 25 days out against Priya (OPPONENTS[1]), CampForecast.run for Light / Standard / Hard on her power
##   camp: the camp stat's gain, the fatigue peak and fight-night fatigue, the injury chance, and the win share of that
##   fighter on the night (BalanceHarness.round_shares, heavy legs included; common random numbers per fighter).
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/evenings_balance.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const H := preload("res://scripts/rules/BalanceHarness.gd")

const WEEKS := 8
const CAMP_DAYS := 25
const N := 1500


func _initialize() -> void:
	var cast := [[Data.lucy(), "reid"], [_prospect("danny"), "hale"], [_prospect("josh"), ""]]
	for who in cast:
		for load in ["normal", "hard"]:
			_between(who[0], str(who[1]), load)
	for who in cast:
		_camp(who[0], str(who[1]))
	quit(0)


func _prospect(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true).merged({"limit": float(Data.DIVISIONS[str(p["div"])]["limit"]), "cards": [],
				"focus": "technique", "diet": "hold", "fatigue": 8, "weekly_salary": 250, "booked_fight": false, "history": [], "goal": {}})
	return {}


func _career(base: Dictionary, coach_id: String) -> Career:
	var c := Career.quick_start()
	if coach_id != "":
		c.coach = Data.coach(coach_id)
	c.fighters.clear()
	c.fighters.append(Data.fighter_state(base.duplicate(true), c.day))
	return c


func _between(base: Dictionary, coach_id: String, load: String) -> void:
	var c := _career(base, coach_id)
	var f: Dictionary = c.fighter()
	f["load_setting"] = load
	var s0: Dictionary = (f["stats"] as Dictionary).duplicate()
	var peak := 0.0
	var hours := 0.0
	for w in WEEKS:
		hours += Injuries.week_hours(f)
		for d in 7:
			Sim.step_day(c)
			peak = maxf(peak, float(f.get("week_fatigue", 0.0)))
	var parts := []
	var total := 0.0
	for k in s0:
		var g := (float(f["stats"][k]) - float(s0[k])) / WEEKS
		total += g
		if absf(g) >= 0.005:
			parts.append("%s %+.2f" % [str(k).substr(0, 4), g])
	print("BETWEEN %-6s %-6s gain/wk %.2f [%s]  fatigue peak %.1f end %.1f  hours/wk %.1f  bout %s" % [str(f["first"]), load, total,
		", ".join(parts), peak, float(f.get("week_fatigue", 0.0)), hours / WEEKS, str(not (f.get("bout", {}) as Dictionary).is_empty())])


func _camp(base: Dictionary, coach_id: String) -> void:
	var c := _career(base, coach_id)
	var f: Dictionary = c.fighter()
	var opp: Dictionary = Data.OPPONENTS[1].duplicate(true)
	f["bout"] = {"day": c.day + CAMP_DAYS, "done": false, "opp": opp}
	WeekPhase.sync(f, c.day)
	for p in [1, 2, 3]:
		var fc := CampForecast.run(c, f, "power", p)
		var g := float(fc["stats"]["power"]) - float(f["stats"]["power"])
		var other := 0.0
		for k in fc["stats"]:
			if str(k) != "power":
				other += float(fc["stats"][k]) - float(f["stats"][k])
		var fighter := {"stats": (fc["stats"] as Dictionary).duplicate(), "moves": (f["moves"] as Dictionary).duplicate(),
			"combos": (f.get("combos", {}) as Dictionary).duplicate(), "camp": {"protocol": p, "focus": "power"},
			"bout": {"opp": opp.duplicate(true), "answered": 0, "stale": float(fc["stale"])}}
		var share: Dictionary = H.round_shares(fighter, ["", "body", "body"], N, 4242)
		print("CAMP %-6s %-8s power %+.2f other %+.2f  peak %.1f night %.1f  heavy legs %.1f  injury %.1f%%  win %.3f" % [
			str(f["first"]), BoutRules.PROTOCOLS[p]["name"], g, other, float(fc["peak"]), float(fc["fatigue_end"]), float(fc["stale"]),
			float(fc["injury"]) * 100.0, float(share["bout"])])
