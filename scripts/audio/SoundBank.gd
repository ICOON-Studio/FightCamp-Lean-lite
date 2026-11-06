extends RefCounted
## S385 Round 1, ported S390: the sound bank. Reads sounds.json once (cached), serves event lookups.
## Static, pure - no nodes, no AudioServer. The game's one source of truth for what sounds exist.
## EAR RULE: files() serves only rows the operator heard and kept, so nothing unheard can reach a speaker.

const MANIFEST := "res://assets/audio/sounds.json"
const VALID_BUSES := ["Master", "Music", "SFX", "Crowd", "UI", "Voice", "Room"]
const NEUTRAL := 0.6   # the power that plays a file as it was heard: 0 dB, no pitch change

static var _data: Dictionary = {}
static var _loaded := false


static func _ensure() -> void:
	if _loaded:
		return
	_loaded = true
	if not FileAccess.file_exists(MANIFEST):
		return
	var text := FileAccess.get_file_as_string(MANIFEST)
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Dictionary:
		_data = parsed


static func events() -> Array:
	_ensure()
	var evts: Dictionary = _data.get("events", {})
	return evts.keys()


static func event(id: String) -> Dictionary:
	_ensure()
	var evts: Dictionary = _data.get("events", {})
	return evts.get(id, {})


static func has(id: String) -> bool:
	return not event(id).is_empty()


## The event's playable files: only rows heard and kept.
static func files(id: String) -> Array:
	var out: Array = []
	for f in event(id).get("files", []):
		if kept(str(f)):
			out.append(f)
	return out


## True when the operator heard this file on the sound board and said keep.
static func kept(res_path: String) -> bool:
	var row := file_data(res_path.trim_prefix("res://"))
	return bool(row.get("heard", false)) and str(row.get("verdict", "")) == "keep"


static func bus(id: String) -> String:
	return str(event(id).get("bus", "SFX"))


static func volume_db(id: String) -> float:
	return float(event(id).get("volume_db", 0.0))


## The random pitch spread of every play (0.04 = +-4%), so a repeat never sounds like a copy.
static func pitch(id: String) -> float:
	return float(event(id).get("pitch", 0.0))


static func cooldown(id: String) -> float:
	return float(event(id).get("cooldown", 0.0))


static func priority(id: String) -> int:
	return int(event(id).get("priority", 0))


static func kind(id: String) -> String:
	return str(event(id).get("kind", "sfx"))


static func is_loop(id: String) -> bool:
	return bool(event(id).get("loop", false))


## Power 0..1 -> volume_db -3..+2, pitch_scale 1.06..0.96 (harder = louder + lower); NEUTRAL leaves the file as heard.
static func intensity(power: float) -> Dictionary:
	var p := clampf(power, 0.0, 1.0)
	return {"volume_db": lerpf(-3.0, 2.0, p), "pitch_scale": 1.0 + (NEUTRAL - p) * 0.1}


static func file_data(rel_path: String) -> Dictionary:
	return all_file_data().get(rel_path, {})


static func all_file_data() -> Dictionary:
	_ensure()
	return _data.get("files", {})
