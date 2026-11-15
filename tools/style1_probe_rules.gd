extends RefCounted
## STYLE1 probe rules - Part B week simulation helpers.
## Pure static; preloads only rule modules. No class_name.

const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const StyleName := preload("res://scripts/rules/StyleName.gd")
const ProgRules := preload("res://tools/prog_probe_rules.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const Data := preload("res://scripts/state/Data.gd")
const LearnSlots := preload("res://scripts/rules/LearnSlots.gd")


static func sim_week_arm_b(f: Dictionary, day: int, week: int) -> void:
	var nights := PadWeek.nights_for(1, false, false, false)
	var slot := ProgRules.slot_moves(f, 58.0)
	var at30 := ProgRules.all_punches_for_cards(f)
	var days: Array = nights.get("pads", [])
	var wp := {}
	if not days.is_empty():
		var ni := 0
		for sm in slot:
			if ni >= days.size():
				break
			wp[PadWeek.DAYS[days[ni]]] = [{"card": "move:" + str(sm), "share": 1.0}]
			ni += 1
		var combo := ""
		for p in at30:
			if float(f.get("moves", {}).get(str(p), 0.0)) >= 30.0:
				combo = _combo_for(f, str(p))
				if combo != "":
					break
		if combo != "" and ni < days.size():
			wp[PadWeek.DAYS[days[ni]]] = [{"card": "combo:" + combo, "share": 1.0}]
			ni += 1
		var rem := days.size() - ni
		if rem > 0 and not at30.is_empty():
			var si := (week * rem) % at30.size()
			for ri in rem:
				wp[PadWeek.DAYS[days[ni + ri]]] = [{"card": "move:" + str(at30[(si + ri) % at30.size()]), "share": 1.0}]
	PadWeek.run_week(f, nights, wp, 58.0, PadWeek.STATION_TIER, {}, [])
	for d in 7:
		if (nights.get("pads", []) as Array).has(d):
			SkillAwards.count_session(f, "pads")
		if (nights.get("spar", []) as Array).has(d):
			SkillAwards.count_session(f, "sparring")
	if day % 7 == 6:
		SkillAwards.assess(f, day)
	var shadow := ProgRules.shadow_mornings(f, 58.0, PadWeek.STATION_TIER)
	var units := {}
	for card in shadow:
		_attr_units(units, str(card), float(shadow[card]))
	ProgRules.apply_hold(f, units, ProgRules.SHARP_HOLD_DEFAULT, ProgRules.SIGNATURE_HOLD_DEFAULT, ProgRules.is_frozen(f))


static func _combo_for(f: Dictionary, mv: String) -> String:
	for b in Combos.BOOK:
		var moves := b["moves"] as Array
		if moves.has(mv):
			var ok := true
			for m in moves:
				if float(f.get("moves", {}).get(str(m), 0.0)) < Combos.LEARN_AT:
					ok = false
					break
			if ok:
				return str(b["id"])
	return ""


static func _attr_units(u: Dictionary, card: String, mins: float) -> void:
	if card.begins_with("move:"):
		u[card.substr(5)] = float(u.get(card.substr(5), 0.0)) + mins
	elif card.begins_with("combo:"):
		var row := Combos.row(card.substr(6))
		var moves := row.get("moves", []) as Array
		if moves.is_empty():
			return
		var sh := mins / float(moves.size())
		for m in moves:
			u[str(m)] = float(u.get(str(m), 0.0)) + sh


static func make_population(rng: RandomNumberGenerator) -> Array:
	var pop: Array = []
	for p in Data.PROSPECTS:
		pop.append(_from_prospect(p))
	for i in 60:
		pop.append(_make_walkin(i, rng))
	return pop


static func _from_prospect(p: Dictionary) -> Dictionary:
	var f := {"id": str(p["id"]), "name": str(p["name"]), "first": str(p["first"]),
		"sex": str(p["sex"]), "age": int(p["age"]), "style": str(p["style"]),
		"stats": (p["stats"] as Dictionary).duplicate(true), "pot": int(p.get("pot", 75))}
	_init_state(f)
	return f


static func _make_walkin(idx: int, rng: RandomNumberGenerator) -> Dictionary:
	var styles := ["Out-boxer", "Swarmer", "Pressure fighter", "Slugger", "Counter-puncher", "Volume puncher"]
	var f := {"id": "w%d" % idx, "name": "W%d" % idx, "first": "W%d" % idx,
		"sex": "f" if idx % 2 == 0 else "m", "age": 18 + rng.randi() % 12, "style": styles[idx % 6],
		"stats": {"power": 50.0 + rng.randf() * 20.0, "speed": 50.0 + rng.randf() * 20.0,
			"technique": 45.0 + rng.randf() * 20.0, "defense": 50.0 + rng.randf() * 15.0,
			"conditioning": 50.0 + rng.randf() * 20.0, "fight_iq": 45.0 + rng.randf() * 20.0,
			"chin": 50.0 + rng.randf() * 20.0}, "pot": 65 + rng.randi() % 25}
	_init_state(f)
	return f


static func _init_state(f: Dictionary) -> void:
	var tech := float(f["stats"]["technique"])
	var moves := {}
	for m in Data.MOVES:
		moves[m] = maxf(30.0, PunchStart.mastery(tech, m))
	f["moves"] = moves
	f["steps"] = MoveTree.day0_steps(float(f["stats"].get("speed", 55.0)))
	f["combos"] = {}
	f["awards"] = []
	f["award_sessions"] = 0
	f["bout"] = {}
	f["phase"] = "base"
	f["phase_day"] = 0
	f["injured"] = false
	f["learning"] = "Uppercut"
	f["learning_slots"] = []
	f["cards"] = []
	f["tray"] = []


static func sim_career(f: Dictionary, tw: int) -> Dictionary:
	var fc: Dictionary = f.duplicate(true)
	var first_held := {}
	var named_styles := {}
	var two_held_ever := false
	for week in tw:
		var day := week * 7
		fc["phase_day"] = day
		sim_week_arm_b(fc, day, week)
		# Pick new moves to learn (like prog_probe)
		_pick_for(fc, week)
		var m: Dictionary = StyleName.monday(fc)
		var named_now: String = str(m.get("style", ""))
		if named_now != "":
			named_styles[named_now] = true
		var held: Array = MoveTree.styles_held(fc)
		for style_name in held:
			if not first_held.has(style_name):
				first_held[style_name] = week + 1
		if StyleName.two_held(fc):
			two_held_ever = true
	return {"first_held": first_held, "named_styles": named_styles, "two_held_ever": two_held_ever}


static func _pick_for(f: Dictionary, week: int) -> void:
	_free_completed_slots(f)
	var ls: Array = f.get("learning_slots", [])
	var sc: int = slot_count(58.0)
	if ls.size() >= sc:
		return
	var gains := {}
	for n in MoveTree.NODES:
		gains[str(n["id"])] = SHADOW_MORNING_RATE * 1.0
	var cards := coach_cards(f, "Out-boxer", gains)
	if cards.is_empty():
		return
	for card in cards:
		var cid := str(card["id"])
		if MoveTree.mastery(f, cid) < 30.0:
			if LearnSlots.pick(f, cid, sc):
				return
	for n in MoveTree.NODES:
		var nid := str(n["id"])
		if MoveTree.state(f, nid) == "open" and MoveTree.mastery(f, nid) < 30.0:
			if LearnSlots.pick(f, nid, sc):
				return


static func _free_completed_slots(f: Dictionary) -> void:
	var ls: Array = f.get("learning_slots", [])
	var to_remove: Array = []
	for mv in ls:
		var m := MoveTree.mastery(f, str(mv))
		if m >= 30.0:
			to_remove.append(mv)
	for mv in to_remove:
		ls.erase(mv)


const SLOT_PADS_THRESHOLD := 65.0
const SHADOW_MORNING_RATE := 0.85


static func slot_count(pad_rating: float) -> int:
	return 2 if pad_rating >= SLOT_PADS_THRESHOLD else 1


static func coach_cards(f: Dictionary, opp_style: String, gains: Dictionary) -> Array:
	return LearnSlots.cards(f, opp_style, gains)
