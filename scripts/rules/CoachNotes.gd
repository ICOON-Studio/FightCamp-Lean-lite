extends RefCounted
## CoachNotes: the coach's notebook. Decides what he has seen of a fighter (habits + notable traits)
## and renders the card's lines from Kalli's fight_habits.json bank. Pure static; zero preloads.

const HIGH := 70.0
const LOW := 40.0
const SPAR_ODDS := 0.35


## What can be seen of f: "habit:<id>" for each of her habits, "trait:<key>" for each notable trait.
static func seeable(f: Dictionary) -> Array:
	var out: Array = []
	var habits: Array = f.get("habits", [])
	for hid in habits:
		out.append("habit:" + str(hid))
	var personality: Dictionary = f.get("personality", {})
	for key in personality.keys():
		var v: float = float(personality[key])
		if v >= HIGH or v <= LOW:
			out.append("trait:" + str(key))
	return out


## One event the coach watched. Reveals unseen items (habits first) depending on source.
## Returns the ids revealed this time.
static func reveal(f: Dictionary, source: String, rng: RandomNumberGenerator) -> Array:
	if not f.has("notes_seen"):
		f["notes_seen"] = []
	var seen: Array = f["notes_seen"]
	var pool: Array = _build_pool(f, source)
	var revealed: Array = []
	if source == "fight":
		var pick: String = _pick_unseen(pool, seen)
		if pick != "":
			seen.append(pick)
			revealed.append(pick)
	elif source == "film":
		var habits_only: Array = []
		for id in pool:
			if str(id).begins_with("habit:"):
				habits_only.append(id)
		var pick: String = _pick_unseen(habits_only, seen)
		if pick != "":
			seen.append(pick)
			revealed.append(pick)
	elif source == "sparring":
		if rng.randf() < SPAR_ODDS:
			var pick: String = _pick_unseen(pool, seen)
			if pick != "":
				seen.append(pick)
				revealed.append(pick)
	return revealed


## The card's lines in reveal order. Each entry: {"id": "<id>", "line": "<text>"}.
static func card(f: Dictionary, bank: Dictionary) -> Array:
	var out: Array = []
	var seen: Array = f.get("notes_seen", [])
	var habits_bank: Array = bank.get("habits", [])
	var trait_notes: Dictionary = bank.get("trait_notes", {})
	var habit_map: Dictionary = {}
	for row in habits_bank:
		habit_map[str(row["id"])] = row
	var name: String = str(f.get("name", ""))
	for id in seen:
		var sid: String = str(id)
		if sid.begins_with("habit:"):
			var hid: String = sid.substr("habit:".length())
			if not habit_map.has(hid):
				continue
			var row: Dictionary = habit_map[hid]
			var notes: Array = row.get("notes", [])
			if notes.is_empty():
				continue
			var idx: int = absi(hash(str(f.get("id", "")) + sid)) % notes.size()
			var line: String = str(notes[idx]).replace("{name}", name)
			out.append({"id": sid, "line": line})
		elif sid.begins_with("trait:"):
			var key: String = sid.substr("trait:".length())
			if not trait_notes.has(key):
				continue
			var tn: Dictionary = trait_notes[key]
			var personality: Dictionary = f.get("personality", {})
			var v: float = float(personality.get(key, 50.0))
			var which: String = "high" if v >= HIGH else "low"
			if not tn.has(which):
				continue
			var line: String = str(tn[which]).replace("{name}", name)
			out.append({"id": sid, "line": line})
	return out


## [seen_count, seeable_count] for the card header.
static func progress(f: Dictionary) -> Array:
	var seen: Array = f.get("notes_seen", [])
	var seeable_list: Array = seeable(f)
	var valid_seen := 0
	var seeable_set: Dictionary = {}
	for id in seeable_list:
		seeable_set[str(id)] = true
	for id in seen:
		if seeable_set.has(str(id)):
			valid_seen += 1
	return [valid_seen, seeable_list.size()]


## --- helpers ---

static func _build_pool(f: Dictionary, source: String) -> Array:
	var pool: Array = []
	var habits: Array = f.get("habits", [])
	for hid in habits:
		pool.append("habit:" + str(hid))
	if source != "film":
		var personality: Dictionary = f.get("personality", {})
		for key in personality.keys():
			var v: float = float(personality[key])
			if v >= HIGH or v <= LOW:
				pool.append("trait:" + str(key))
	return pool


static func _pick_unseen(pool: Array, seen: Array) -> String:
	var seen_set: Dictionary = {}
	for id in seen:
		seen_set[str(id)] = true
	var candidates: Array = []
	for id in pool:
		if not seen_set.has(str(id)):
			candidates.append(id)
	if candidates.is_empty():
		return ""
	return str(candidates[0])
