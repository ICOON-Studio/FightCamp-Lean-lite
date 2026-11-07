extends RefCounted
## S396 truth pass (P15): the career saves itself at every week review, and the last KEEP weeks are kept as copies a
## player can go back to (user://autosave/week_<n>.save). The main slot is the one Load reads.
##   AutoSave.on_stop(career, main_path) -> bool (true when it saved)   AutoSave.last(main_path) -> "" or a line

const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Settings := preload("res://scripts/state/Settings.gd")

const DIR := "user://autosave"
const KEEP := 5


## Called when the clock stops. Saves on a week review (Monday) when autosave is on.
static func on_stop(career: Career, main_path: String, settings: Dictionary = {}) -> bool:
	var s := settings if not settings.is_empty() else Settings.read()
	if career == null or career.closed or not bool(s.get("autosave", true)) or career.day % 7 != 0:
		return false
	return save_now(career, main_path)


static func save_now(career: Career, main_path: String) -> bool:
	if not SaveGame.save(career, main_path):
		return false
	DirAccess.make_dir_recursive_absolute(DIR)
	SaveGame.save(career, "%s/week_%d.save" % [DIR, int(career.day / 7)])
	_trim()
	return true


## The newest KEEP copies stay.
static func copies() -> Array:
	var out: Array = []
	var da := DirAccess.open(DIR)
	if da == null:
		return out
	for fname in da.get_files():
		if fname.begins_with("week_") and fname.ends_with(".save"):
			out.append(int(fname.trim_prefix("week_").trim_suffix(".save")))
	out.sort()
	return out


static func _trim() -> void:
	var weeks := copies()
	while weeks.size() > KEEP:
		DirAccess.remove_absolute("%s/week_%d.save" % [DIR, int(weeks.pop_front())])


## "Last autosave: week 12, 3 minutes ago." for the Settings page ("" before the first).
static func last(main_path: String) -> String:
	if not FileAccess.file_exists(main_path):
		return ""
	var weeks := copies()
	var mins := int((Time.get_unix_time_from_system() - FileAccess.get_modified_time(main_path)) / 60.0)
	var ago := "just now" if mins < 1 else ("%d minute%s ago" % [mins, "" if mins == 1 else "s"] if mins < 120 else "%d hours ago" % int(mins / 60.0))
	return "Last save: %s%s. The last %d weeks are kept." % ["week %d, " % int(weeks[-1]) if not weeks.is_empty() else "", ago, KEEP]
