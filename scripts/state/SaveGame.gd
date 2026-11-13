extends RefCounted
## One save slot on this machine. The career's script variables go to disk with Godot's own typed format (store_var),
## so an int comes back an int and a float a float, no JSON number drift. A save from an older layout loads with the
## new fields at their defaults (Career.new() supplies them); a version-1 save (weeks 1-3: one fighter, her bout on the
## career) is moved onto the per-fighter layout of week 4 by _migrate_v1.

const Data := preload("res://scripts/state/Data.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const BodyFacts := preload("res://scripts/rules/BodyFacts.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")

const PATH := "user://career.save"
const VERSION := 2
## Week 1-3 career fields that now live on each fighter.
const V1_FIGHTER_FIELDS := ["offers", "bout", "camp", "goal_talk", "next_offer_day", "opp_index", "rank", "week_start"]


static func to_dict(c: Career) -> Dictionary:
	var props := {}
	for p in c.get_property_list():
		if int(p["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var v: Variant = c.get(p["name"])
			props[p["name"]] = v.duplicate(true) if (v is Array or v is Dictionary) else v
	return {"version": VERSION, "props": props}


static func from_dict(d: Dictionary) -> Career:
	var c := Career.new()
	var props: Dictionary = (d.get("props", {}) as Dictionary).duplicate(true)
	if int(d.get("version", 1)) < 2:
		_migrate_v1(props)
	for p in c.get_property_list():
		var key := str(p["name"])
		if int(p["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE and props.has(key):
			c.set(key, props[key])
	# A save from before the fight model (S300): every fighter gets her profile and morale; existing ones stay as saved.
	for f in c.fighters:
		FighterProfile.ensure(f)
		BodyFacts.fill(f)
		# S452 STEPMASTERY1: a save from before the step bars - her booked plan's steps start Sharp (60), the rest Usable (30).
		if not f.has("steps"):
			var arrows: Array = ((f.get("bout", {}) as Dictionary).get("arrows", []) as Array).map(func(a): return str((a as Dictionary).get("move", "")) if a is Dictionary else str(a))
			f["steps"] = StepMastery.from_old_save(arrows)
	# A save from before the belt road (S362): Ana joins the mat.
	if not props.has("grapplers"):
		c.grapplers = [NoGi.athlete()]
	# A save from before a rival joined the region (S339 Holly, Ellie, Jade): she arrives with her starting record.
	var names := {}
	for r in c.rivals:
		names[str(r["name"])] = true
	for r in Data.RIVALS:
		if not names.has(str(r["name"])):
			c.rivals.append((r as Dictionary).merged({"div": "wlw"}))
	# S371 MALE1: a save from before the men's divisions gets the men, each with an invented past, and the male prospects.
	for r in Data.DIVISION_RIVALS:
		if not names.has(str(r["name"])):
			var nr := (r as Dictionary).duplicate(true)
			var others: Array = Data.DIVISION_RIVALS.filter(func(o): return str(o["div"]) == str(nr["div"])).map(func(o): return [o["name"], o["club"]])
			nr["bouts"] = RivalPast.seed(nr, others, c.seed, c.day)
			c.rivals.append(nr)
	_classes_2025(c)
	var ids := {}
	for p in c.prospects:
		ids[str(p.get("id", ""))] = true
	for p in Data.PROSPECTS:
		if not ids.has(str(p["id"])):
			c.prospects.append((p as Dictionary).merged({"state": "scout", "trial_day": -1}, false).duplicate(true))
	return c


## S373 a save from before the women's 2025 classes (lightweight 61.2 -> 60, welterweight 66 -> 65): a fighter's limit
## follows her division and her weight moves by the same step, so the cut she faces is the one she had; a prospect still
## at the old data weight takes the new one. Runs once: a fighter on her division's limit, or a moved prospect, is left.
const OLD_PROSPECT_KG := {"samira": 67.4}


static func _classes_2025(c: Career) -> void:
	for f in c.fighters:
		var div: Dictionary = Data.DIVISIONS.get(str(f.get("div", "")), {})
		if div.is_empty() or not f.has("limit") or is_equal_approx(float(f["limit"]), float(div["limit"])):
			continue
		var step := float(div["limit"]) - float(f["limit"])
		f["limit"] = float(div["limit"])
		f["weight"] = float(f.get("weight", f["limit"])) + step
	for p in c.prospects:
		var id := str(p.get("id", ""))
		if OLD_PROSPECT_KG.has(id) and is_equal_approx(float(p.get("weight", 0.0)), float(OLD_PROSPECT_KG[id])):
			for d in Data.PROSPECTS:
				if str(d["id"]) == id:
					p["weight"] = float(d["weight"])


static func save(c: Career, path: String = PATH) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_var(to_dict(c))
	f.close()
	return true


## The saved career, or null when there is none or it cannot be read.
static func load_career(path: String = PATH) -> Career:
	if not FileAccess.file_exists(path):
		return null
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return null
	var v: Variant = f.get_var()
	f.close()
	if not (v is Dictionary) or not (v as Dictionary).has("props"):
		return null
	return from_dict(v)


static func exists(path: String = PATH) -> bool:
	return FileAccess.file_exists(path)


## "Anvil Street Gym, Mon 9 Mar 2026" for the title screen; "" when there is no save.
static func summary(path: String = PATH) -> String:
	var c := load_career(path)
	return "" if c == null else "%s, %s" % [c.gym_name, Clock.fmt_long(c.day)]


## Version 1 -> 2: the career's one bout/camp/offers/office talk/rank move onto the first fighter, every fighter gets the
## week-4 state (moves, division), the rivals get their division and the new divisions' rivals and the prospects arrive.
static func _migrate_v1(props: Dictionary) -> void:
	var fighters: Array = props.get("fighters", [])
	for i in fighters.size():
		var f: Dictionary = Data.fighter_state(fighters[i], int(props.get("day", 0)))
		if i == 0:
			for k in V1_FIGHTER_FIELDS:
				if props.has(k):
					f[k] = props[k]
		fighters[i] = f
	props["fighters"] = fighters
	for k in V1_FIGHTER_FIELDS:
		props.erase(k)
	var rivals: Array = props.get("rivals", [])
	for r in rivals:
		if not (r as Dictionary).has("div"):
			r["div"] = "wlw"
	for r in Data.DIVISION_RIVALS:
		rivals.append((r as Dictionary).duplicate(true))
	props["rivals"] = rivals
	var prospects: Array = []
	for p in Data.PROSPECTS:
		prospects.append((p as Dictionary).merged({"state": "scout", "trial_day": -1}, false).duplicate(true))
	props["prospects"] = prospects
