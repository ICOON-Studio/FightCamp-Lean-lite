extends SceneTree
## S461 INTEGRATE1 #8: TrainRead reaches the roster. When every check Coach runs is green, the Coach cell says the coach's
## read (what to build next) instead of "No change this week", with the sums on the hover and no fighter's name (S448).
##   1. Each kind's short words are set and carry no name.
##   2. The roster cell of a fighter with all checks green reads TrainRead (control: the read itself, computed apart).

const Data := preload("res://scripts/state/Data.gd")
const TrainRead := preload("res://scripts/rules/TrainRead.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")

var failures := 0


func _initialize() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 1)
	var first := str(f["first"])
	for r in [{"kind": "fight"}, {"kind": "rest"}, {"kind": "weakness", "stat": "defense", "session_name": "Defence drills"},
			{"kind": "weapon", "stat": "power", "session_name": "Bag work"}, {"kind": "craft"}]:
		var s: Array = TrainRead.short(r)
		_check(str(s[0]) != "" and not str(s[0]).contains(first) and not str(s[1]).contains(first), "1 %s words (%s)" % [r["kind"], str(s)])
	var c := Career.new()
	c.day = 100
	c.coach = {"rating": 60.0}
	c.fighters = [f]
	var cell: Dictionary = RosterRow.green_cell(c, f, {})
	var want: Array = TrainRead.short(TrainRead.read(f, c.day))
	_check(str(cell["word"]) == str(want[0]) and str(cell.get("sub", "")) == str(want[1]) and str(cell["word"]) != "No change this week",
		"2 green cell reads TrainRead (%s vs %s)" % [str(cell), str(want)])
	_check(str(cell.get("why", "")).contains("Coach's read") and not str(cell["why"]).contains(first), "2 the sums on the hover, no name")
	var row: Dictionary = RosterRow.row(c, str(f["id"])).get("coach", {})
	_check(str(row.get("tone", "")) != "good" or str(row["word"]) == str(want[0]), "2 the roster row uses it when green (%s)" % str(row))
	print("TRAIN_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
