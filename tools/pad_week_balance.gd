extends SceneTree
## S382 PADWEEK1 balance check by hand (TRAINING_SCREEN_S381.md section 9: "pad concentration vs the old fixed split, and
## the spar share size"): 3 fighters x 8 weeks, BEFORE (the old fixed lumps: new move 420, combo 240 a week, everything
## else fading) against AFTER (PadWeek nights via DrillWeek): the coach's Standard week, Hard, and 3 nights on the 1-1.
##   godot --headless --path . --script res://tools/pad_week_balance.gd

const Data := preload("res://scripts/state/Data.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

const WEEKS := 8


func _initialize() -> void:
	var cast := [[Data.lucy(), "reid"], [_prospect("danny"), "hale"], [_prospect("josh"), ""]]
	for who in cast:
		for mode in ["before", "standard", "hard", "1-1 x3"]:
			_report(who[0], str(who[1]), mode)
	quit(0)


func _prospect(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			return (p as Dictionary).duplicate(true).merged({"limit": float(Data.DIVISIONS[str(p["div"])]["limit"]), "cards": [], "focus": "technique", "diet": "hold",
				"fatigue": 8, "weekly_salary": 250, "booked_fight": false, "history": [], "goal": {}})
	return {}


func _report(base: Dictionary, coach_id: String, mode: String) -> void:
	var c := Career.quick_start()
	if coach_id != "":
		c.coach = Data.coach(coach_id)
	c.fighters.append(Data.fighter_state(base.duplicate(true), c.day))
	var f: Dictionary = c.fighter()
	if mode == "hard":
		f["load_setting"] = "hard"
	if mode == "1-1 x3":
		var one := [{"card": "combo:1-1", "share": 1.0}]
		f["pad_week"] = {"mon": one, "wed": one, "fri": one}
	var landed := []
	var spar := 0.0
	for w in range(1, WEEKS + 1):
		var before: Dictionary = (f["moves"] as Dictionary).duplicate()
		var cb: Dictionary = (f.get("combos", {}) as Dictionary).duplicate()
		if mode == "before":
			_old_week(c, f)
		else:
			for row in DrillWeek.run(c, f)["pads"]:
				if int(row[0]) == 3:   # Thursday: the sparring night's share
					spar += float(row[3]) - float(row[2])
		for m in Data.MOVES:
			if float(before.get(m, 0.0)) < 30.0 and float(f["moves"][m]) >= 30.0:
				landed.append("%s w%d" % [m, w])
		for id in f.get("combos", {}):
			if float(cb.get(id, 0.0)) < 30.0 and float(f["combos"][id]) >= 30.0:
				landed.append("%s w%d" % [id, w])
	var usable_m := 0
	for m in Data.MOVES:
		usable_m += 1 if float(f["moves"][m]) >= 30.0 else 0
	var usable_c := 0
	for id in f.get("combos", {}):
		usable_c += 1 if float(f["combos"][id]) >= 30.0 else 0
	print("%-6s %-8s moves>=30 %d  combos>=30 %d  Jab %.1f  LH %.1f  1-1 %.1f  spar +%.1f  | %s" % [str(f["first"]), mode, usable_m, usable_c,
		float(f["moves"]["Jab"]), float(f["moves"]["Lead hook"]), float(f.get("combos", {}).get("1-1", 0.0)), spar, ", ".join(landed)])


## The rules before PADWEEK1 (Sim.drill_week + drill_combos at main be186f15), news left out: the new move 420 min of pads,
## the combo 240, week-card moves 120 on the bag, everything else fading 0.75.
func _old_week(c: Career, f: Dictionary) -> void:
	var moves: Dictionary = f["moves"]
	var cap := MoveMastery.cap(float(f["stats"]["technique"]), float(f["stats"]["fight_iq"]))
	var skill := float(c.coach.get("rating", 0.0))
	var learning := str(f.get("learning", ""))
	var new_weapon := ""
	for m in Data.MOVES:
		var before := float(moves.get(m, 0.0))
		moves[m] = MoveMastery.gain(before, "pads", 420.0, skill, 2, 1.0, cap) if m == learning else MoveMastery.decay_week(before, false)
		if before < BoutRules.WEAPON_MASTERY and float(moves[m]) >= BoutRules.WEAPON_MASTERY:
			new_weapon = m
	if new_weapon != "" and new_weapon == learning:
		var next := ""
		for m in Data.MOVES:
			if float(moves[m]) < BoutRules.WEAPON_MASTERY:
				next = m
				break
		if next == "":
			for m in Data.MOVES:
				if next == "" or float(moves[m]) < float(moves[next]):
					next = m
		f["learning"] = next
	if not f.has("combos"):
		f["combos"] = {}
	var combos: Dictionary = f["combos"]
	var drilling := str(f.get("combo_learning", ""))
	if drilling == "" or not Combos.unlocked(moves).has(drilling):
		drilling = Combos.next_to_learn(moves, combos)
	var ids: Array = combos.keys()
	if drilling != "" and not ids.has(drilling):
		ids.append(drilling)
	var new_combo := ""
	for id in ids:
		var before := float(combos.get(id, 0.0))
		var after := Combos.fade(before, false)
		if id == drilling:
			after = Combos.drill(before, id, 240.0, skill, 2, Combos.cap(id, moves, float(f["stats"]["technique"]), float(f["stats"]["fight_iq"])))
		combos[id] = after
		if before < Combos.LEARN_AT and after >= Combos.LEARN_AT:
			new_combo = id
	f["combo_learning"] = Combos.next_to_learn(moves, combos) if new_combo == drilling else drilling
