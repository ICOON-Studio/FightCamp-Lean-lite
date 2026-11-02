extends RefCounted
## S354 the perk road (Kalli KALLI_RECEPTION_RPG_S354.md, operator "get it more rpg elements"): perks that open as
## training builds the attributes - the payoff a week of mornings works toward. A perk opens for good once its need is met
## (f["perks"] keeps the day). Pure static.
##   status(f) -> [{id, name, effect, need, have, open, near}]   newly_open(f, day) -> [names] (records them)
## The fight effects are the next step (each needs its hook in the fight model and a playtest); the road shows and opens now.

## need: {stat: value} or {"move:<name>": mastery}.
const PERKS := [
	{"id": "iron_chin", "name": "Iron chin", "effect": "The first knockdown each fight is a stagger instead", "need": {"chin": 70}},
	{"id": "stiff_jab", "name": "Stiff jab", "effect": "Jabs stop a rush 20% more often", "need": {"technique": 65}},
	{"id": "second_wind", "name": "Second wind", "effect": "+10% stamina back at the start of round 3", "need": {"conditioning": 70}},
	{"id": "ring_general", "name": "Ring general", "effect": "Corner calls work 25% better", "need": {"fight_iq": 65}},
	{"id": "counter_sense", "name": "Counter sense", "effect": "A slip gives a free counter 30% of the time", "need": {"defense": 65, "move:Check hook": 30}},
	{"id": "body_snatcher", "name": "Body snatcher", "effect": "Body shots drain 15% more stamina", "need": {"move:Body hook": 30}},
	{"id": "finisher", "name": "Finisher", "effect": "A stoppage is 1.5x as likely on a hurt opponent", "need": {"power": 70}},
	{"id": "hand_speed", "name": "Fast hands", "effect": "Combinations land whole 10% more often", "need": {"speed": 70}},
]
const NEAR := 5.0
const SHORT := {"power": "power", "speed": "speed", "technique": "tech", "defense": "def", "conditioning": "cond",
	"fight_iq": "ring IQ", "chin": "chin"}


static func _value(f: Dictionary, key: String) -> float:
	if key.begins_with("move:"):
		return float((f.get("moves", {}) as Dictionary).get(key.substr(5), 0.0))
	return float((f.get("stats", {}) as Dictionary).get(key, 0.0))


static func status(f: Dictionary) -> Array:
	var out: Array = []
	var opened: Dictionary = f.get("perks", {})
	for p in PERKS:
		var need: Dictionary = p["need"]
		var met := true
		var gap := 0.0
		var words := PackedStringArray()
		for k in need.keys():
			var have := _value(f, str(k))
			met = met and have >= float(need[k])
			gap = maxf(gap, float(need[k]) - have)
			var label := str(k).substr(5).to_lower() if str(k).begins_with("move:") else str(SHORT.get(k, k))
			words.append("%s %d (%d)" % [label, int(need[k]), int(floor(have))])
		var is_open := met or opened.has(p["id"])
		out.append({"id": p["id"], "name": p["name"], "effect": p["effect"], "need": " + ".join(words), "open": is_open,
			"near": not is_open and gap <= NEAR})
	return out


## Perks that opened since last asked: recorded in f["perks"] {id: day}; returns their names (for the news).
static func newly_open(f: Dictionary, day: int) -> Array:
	if not f.has("perks"):
		f["perks"] = {}
	var names: Array = []
	for s in status(f):
		if bool(s["open"]) and not (f["perks"] as Dictionary).has(s["id"]):
			f["perks"][s["id"]] = day
			names.append(s["name"])
	return names
