extends RefCounted
## One save slot on this machine. The career's script variables go to disk with Godot's own typed format (store_var),
## so an int comes back an int and a float a float, no JSON number drift. A save from an older layout loads with the
## new fields at their defaults (Career.new() supplies them); a version-1 save (weeks 1-3: one fighter, her bout on the
## career) is moved onto the per-fighter layout of week 4 by _migrate_v1.

const Data := preload("res://scripts/state/Data.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

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
	return c


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
