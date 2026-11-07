extends SceneTree
## S398 Week redesign (approved rule change, docs/WEEK_REDESIGN_S397.md): each evening is set on the evening itself.
##   1. No edits: PadWeek.nights_of is the coach's laid week (coach_nights), unchanged.
##   2. Tuesday set to Pads: four pad nights (the count follows the evenings, not the Light / Standard / Hard step).
##   3. Monday set to Rest, Thursday's sparring set to Pads: those nights move; the other nights keep the coach's kinds.
##   4. Setting an evening back to the coach's own kind removes the exception (edit_eve), so the week is the coach's again.
##   5. The sim reads the same nights: PadWeek.evenings shows the player's kinds.
## Population: Lucy Jackson (Data.lucy) between fights, base phase, Standard (3 pads Mon/Wed/Fri, 1 sparring Thu).

const Data := preload("res://scripts/state/Data.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

var _fails := 0


func _initialize() -> void:
	var f := Data.fighter_state(Data.lucy(), 1)
	f["phase"] = "base"
	f["load_setting"] = "normal"
	var coach := PadWeek.coach_nights(f)
	var same := PadWeek.nights_of(f)
	_check(same["pads"] == coach["pads"] and same["spar"] == coach["spar"], "1. no edits: the coach's nights %s / %s" % [str(coach["pads"]), str(coach["spar"])])
	var ce := PadWeek.evenings_from(coach)
	WeekPhase.edit_eve(f, 1, "pads", str(ce[1]))
	var n := PadWeek.nights_of(f)
	_check((n["pads"] as Array).has(1) and (n["pads"] as Array).size() == (coach["pads"] as Array).size() + 1,
		"2. Tuesday on the pads: %s" % str(n["pads"]))
	WeekPhase.edit_eve(f, 0, "rest", str(ce[0]))
	WeekPhase.edit_eve(f, 3, "pads", str(ce[3]))
	n = PadWeek.nights_of(f)
	_check(not (n["pads"] as Array).has(0) and (n["pads"] as Array).has(3) and not (n["spar"] as Array).has(3),
		"3. Monday rests, Thursday pads: pads %s spar %s" % [str(n["pads"]), str(n["spar"])])
	_check((n["pads"] as Array).has(2) and (n["pads"] as Array).has(4), "3. Wednesday and Friday keep the coach's pads")
	WeekPhase.edit_eve(f, 0, str(ce[0]), str(ce[0]))
	WeekPhase.edit_eve(f, 1, str(ce[1]), str(ce[1]))
	WeekPhase.edit_eve(f, 3, str(ce[3]), str(ce[3]))
	_check((WeekPhase.edits(f).get("eve", {}) as Dictionary).is_empty(), "4. back to the coach's kinds: no exceptions left")
	n = PadWeek.nights_of(f)
	_check(n["pads"] == coach["pads"] and n["spar"] == coach["spar"], "4. the coach's week again")
	WeekPhase.edit_eve(f, 6, "sparring", str(ce[6]))
	_check(str(PadWeek.evenings(f)[6]) == "sparring", "5. the sim's evenings read the player's Sunday sparring")
	print("EVENING_EDITS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print(("ok   " if ok else "FAIL ") + what)
