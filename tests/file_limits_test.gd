extends SceneTree
## SPLIT500: every script under scripts/ must stay at or under 500 lines, and the two files this task
## targets (Main.gd, LiveRound.gd) must be at or under 470 so there is room for the next reason row.
## Known exceptions are files being split by other tasks in the same batch.

var failures := 0

## Files with a tighter limit (the current task's targets).
const TIGHT := {"res://scripts/ui/Main.gd": 470, "res://scripts/state/LiveRound.gd": 470}

## Known exceptions: other tasks in the SPLIT500 batch are splitting these.
## WeekCards.gd is R11G; the rest are other split tasks.
const KNOWN_EXCEPTIONS := {
	"res://scripts/ui/WeekCards.gd": "R11G splits WeekCards",
	"res://scripts/fight3d/CornerCrew.gd": "split by another task",
	"res://scripts/fight3d/FightIntro.gd": "split by another task",
	"res://scripts/fight3d/HudBars.gd": "split by another task",
	"res://scripts/fight3d/KnockdownCount.gd": "split by another task",
	"res://scripts/fight3d/MovePlayer.gd": "split by another task",
	"res://scripts/fight3d/RingCamera.gd": "split by another task",
	"res://scripts/grapple/GrappleBrowser.gd": "split by another task",
	"res://scripts/grapple/GrappleFinish.gd": "split by another task",
	"res://scripts/grapple/GrapplePlayer.gd": "split by another task",
	"res://scripts/state/Sim.gd": "split by another task",
	"res://scripts/ui/MatTreeInfo.gd": "split by another task",
}


func _initialize() -> void:
	var files := _gd_files("res://scripts")
	_check(files.size() > 50, "found %d scripts under scripts/" % files.size())
	for path in files:
		if KNOWN_EXCEPTIONS.has(path):
			continue
		var text := FileAccess.get_file_as_string(path)
		var lines := text.split("\n").size()
		if TIGHT.has(path):
			_check(lines <= TIGHT[path], "%s at %d lines (limit %d)" % [path, lines, TIGHT[path]])
		else:
			_check(lines <= 500, "%s at %d lines (limit 500)" % [path, lines])
	print("FILE_LIMITS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _gd_files(dir: String) -> Array:
	var out: Array = []
	for fn in DirAccess.get_files_at(dir):
		if fn.ends_with(".gd"):
			out.append(dir.path_join(fn))
	for sub in DirAccess.get_directories_at(dir):
		out.append_array(_gd_files(dir.path_join(sub)))
	return out


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
