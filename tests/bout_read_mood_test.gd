extends SceneTree
## S539 HOSTPROBE2 side defect: BoutRead's caches ignored the boxer's mood, so within a session the win read never moved with
## morale after the first read (the corner's trust, FighterProfile.TRUST, is part of the read).
## godot --headless --audio-driver Dummy --path . --script res://tests/bout_read_mood_test.gd

const Data := preload("res://scripts/state/Data.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var opp: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	f["morale"] = 80.0
	var hi := BoutRead.round_edges(f, opp, {}).duplicate(true)
	f["morale"] = 20.0
	var lo := BoutRead.round_edges(f, opp, {})
	_check(str(hi) != str(lo), "the read moves with her mood (fired up v low), no stale cache")
	f["morale"] = 80.0
	_check(str(BoutRead.round_edges(f, opp, {})) == str(hi), "the same mood reads the same (the cache still works)")
	print("BOUT_READ_MOOD failures=%d" % failures)
	quit(1 if failures > 0 else 0)
