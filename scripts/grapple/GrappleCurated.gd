extends RefCounted
## S390: the GrappleMap moves a match refuses (assets/data/grapple_curated.json, written by tools/grapple_quality.gd): unfinished
## data, a body standing on its head, trunks through trunks. The browser still shows them; a match never plays them.

const PATH := "res://assets/data/grapple_curated.json"
static var _blocked: Dictionary = {}
static var _read := false


static func blocked(move_id: int) -> bool:
	if not _read:
		_read = true
		var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		if d is Dictionary:
			_blocked = (d as Dictionary).get("blocked", {})
	return _blocked.has(str(move_id))
