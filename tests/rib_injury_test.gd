extends SceneTree
## S434 RIBHURT1: a boxer whose ribs took a beating is likelier to come out with a rib injury.
## The body map's left_ribs and right_ribs reach InjuryRoll.bout_roll; when either is at or under
## RIB_HURT_LINE (35), the ribs row weighs x HURT_WEIGHT (3) in the roll - exactly as face_cut
## doubles the cut row. Injuries.after_bout builds the places dict from the body map when present.

const IR := preload("res://scripts/rules/InjuryRoll.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_check_ribs_share()
	_check_face_cut_still_works()
	_check_no_body_map_old_save()
	_check_game_path_rib_injuries()
	_check_no_new_injury_type()
	print("RIB_INJURY checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	checks += 1
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## a. bout_roll over seeds 0..9999 with places {head 70, left_ribs 20}: the ribs share of injuries
## is at least 2x the share with {head 70, left_ribs 100}.
func _check_ribs_share() -> void:
	var dmg_hurt: Dictionary = {"places": {"head": 70.0, "left_ribs": 20.0}, "rounds": 3}
	var dmg_fresh: Dictionary = {"places": {"head": 70.0, "left_ribs": 100.0}, "rounds": 3}
	var ribs_hurt: int = 0
	var inj_hurt: int = 0
	var ribs_fresh: int = 0
	var inj_fresh: int = 0
	for s in range(0, 10000):
		var r1: Dictionary = IR.bout_roll(s, dmg_hurt)
		if r1["injured"]:
			inj_hurt += 1
			if str(r1["type"]) == "ribs":
				ribs_hurt += 1
		var r2: Dictionary = IR.bout_roll(s, dmg_fresh)
		if r2["injured"]:
			inj_fresh += 1
			if str(r2["type"]) == "ribs":
				ribs_fresh += 1
	var share_hurt: float = float(ribs_hurt) / float(inj_hurt) if inj_hurt > 0 else 0.0
	var share_fresh: float = float(ribs_fresh) / float(inj_fresh) if inj_fresh > 0 else 0.0
	var ratio: float = share_hurt / share_fresh if share_fresh > 0.0 else 0.0
	print("  ribs share: hurt=%f fresh=%f ratio=%f" % [share_hurt, share_fresh, ratio])
	_check(ratio >= 2.0, "ribs share at least 2x when ribs hurt: ratio=%f" % ratio)


## b. the face cut still works: {head 70, nose 20} gives a cut share at least 1.5x {head 70, nose 100}.
func _check_face_cut_still_works() -> void:
	var dmg_cut: Dictionary = {"places": {"head": 70.0, "nose": 20.0}, "rounds": 3}
	var dmg_fresh: Dictionary = {"places": {"head": 70.0, "nose": 100.0}, "rounds": 3}
	var cuts_cut: int = 0
	var inj_cut: int = 0
	var cuts_fresh: int = 0
	var inj_fresh: int = 0
	for s in range(0, 10000):
		var r1: Dictionary = IR.bout_roll(s, dmg_cut)
		if r1["injured"]:
			inj_cut += 1
			if str(r1["type"]) == "cut":
				cuts_cut += 1
		var r2: Dictionary = IR.bout_roll(s, dmg_fresh)
		if r2["injured"]:
			inj_fresh += 1
			if str(r2["type"]) == "cut":
				cuts_fresh += 1
	var share_cut: float = float(cuts_cut) / float(inj_cut) if inj_cut > 0 else 0.0
	var share_fresh: float = float(cuts_fresh) / float(inj_fresh) if inj_fresh > 0 else 0.0
	var ratio: float = share_cut / share_fresh if share_fresh > 0.0 else 0.0
	print("  cut share: cut=%f fresh=%f ratio=%f" % [share_cut, share_fresh, ratio])
	_check(ratio >= 1.5, "face cut still works: cut share ratio=%f" % ratio)


## c. no body map (an old save, m without "body_map"): after_bout rolls exactly as main did - InjuryRoll.bout_roll on
## the head-only place with the same seed. S434 collect: over 300 seeds, and some of them must be injured (else it proves nothing).
func _check_no_body_map_old_save() -> void:
	var same := true
	var injured := 0
	for sd in range(300):
		var c := _career()
		c.seed = sd
		c.day = 20
		var f: Dictionary = c.fighter()
		var m_old: Dictionary = {"rounds": [{}, {}, {}], "stopped": "", "outcome": "loss", "damage": {"a": 20.0}}
		var want: Dictionary = IR.bout_roll(Injuries._seed(c, f, 7), {"places": {"head": clampf(100.0 - 20.0 * Injuries.DAMAGE_TO_WORST, 0.0, 100.0)},
			"rounds": 3, "head_stoppage": false, "ko_history": [], "day": c.day})
		Injuries.after_bout(c, f, m_old)
		var got: Dictionary = f.get("injury", {})
		if bool(want["injured"]):
			injured += 1
			same = same and not got.is_empty() and str(got.get("type", "")) == str(want["type"]) and int(got.get("days_out", 0)) == int(want["days_out"])
		else:
			same = same and got.is_empty()
	_check(same and injured >= 5, "no body map: an old save rolls exactly as main's head-only roll (300 seeds, %d injured)" % injured)


## d. the GAME path: Injuries.after_bout on a quick-start career with body map whose left_ribs is 15,
## over 400 seeds: rib injuries come up at least 2x as often as with left_ribs 100.
func _check_game_path_rib_injuries() -> void:
	var ribs_hurt: int = 0
	var ribs_fresh: int = 0
	for seed_idx in range(0, 400):
		var c_hurt := _career()
		c_hurt.seed = seed_idx
		var f_hurt: Dictionary = c_hurt.fighter()
		c_hurt.day = 20
		var bm_hurt: Dictionary = BodyMap.fresh()
		bm_hurt["a"]["places"]["left_ribs"] = 15.0
		var m_hurt: Dictionary = {"rounds": [{}, {}, {}], "stopped": "", "outcome": "loss",
			"damage": {"a": 20.0}, "body_map": bm_hurt}
		Injuries.after_bout(c_hurt, f_hurt, m_hurt)
		var inj_hurt: Dictionary = f_hurt.get("injury", {})
		if not inj_hurt.is_empty() and str(inj_hurt.get("type", "")) == "ribs":
			ribs_hurt += 1

		var c_fresh := _career()
		c_fresh.seed = seed_idx
		var f_fresh: Dictionary = c_fresh.fighter()
		c_fresh.day = 20
		var bm_fresh: Dictionary = BodyMap.fresh()
		# left_ribs stays at 100 (fresh)
		var m_fresh: Dictionary = {"rounds": [{}, {}, {}], "stopped": "", "outcome": "loss",
			"damage": {"a": 20.0}, "body_map": bm_fresh}
		Injuries.after_bout(c_fresh, f_fresh, m_fresh)
		var inj_fresh: Dictionary = f_fresh.get("injury", {})
		if not inj_fresh.is_empty() and str(inj_fresh.get("type", "")) == "ribs":
			ribs_fresh += 1
	var ratio: float = float(ribs_hurt) / float(ribs_fresh) if ribs_fresh > 0 else float(ribs_hurt)
	print("  game path ribs: hurt=%d fresh=%d ratio=%f" % [ribs_hurt, ribs_fresh, ratio])
	_check(ribs_hurt >= 2 * ribs_fresh, "game path: rib injuries at least 2x when ribs hurt: hurt=%d fresh=%d" % [ribs_hurt, ribs_fresh])


## e. no new kind of injury and no days changed: every type rolled is in BOUT_TYPES, days inside its row.
func _check_no_new_injury_type() -> void:
	var type_ok := true
	var days_ok := true
	var valid_types: Array = []
	for t in IR.BOUT_TYPES:
		valid_types.append(str(t[0]))
	valid_types.append("ko")
	valid_types.append("none")
	for s in range(0, 1000):
		var dmg: Dictionary = {"places": {"head": 70.0, "left_ribs": 20.0, "nose": 30.0}, "rounds": 3}
		var r: Dictionary = IR.bout_roll(s, dmg)
		var tp: String = str(r.get("type", ""))
		if not valid_types.has(tp):
			type_ok = false
		if tp != "none" and tp != "ko":
			var days: int = int(r.get("days_out", 0))
			var found := false
			if tp == "ribs":
				# S467 LIVERRIBS1 v2 rule 9: a bout rib injury is bruised (10-21 days) or cracked (35-56 days).
				var span: Array = IR.LiverRibs.CRACKED_DAYS if str(r.get("kind", "")) == "cracked" else IR.LiverRibs.BRUISED_DAYS
				found = r.has("kind") and days >= int(span[0]) and days <= int(span[1])
				if not found:
					days_ok = false
				continue
			for t in IR.BOUT_TYPES:
				if str(t[0]) == tp:
					if days >= int(t[2]) and days <= int(t[3]):
						found = true
					break
			if not found:
				days_ok = false
	_check(type_ok and days_ok, "no new injury type and days inside their row")


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 325
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.cash = 1000000
	return c
