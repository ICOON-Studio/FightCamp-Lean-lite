extends SceneTree
## S361 trust in the fight (FighterProfile.trust in LiveRound: what she takes in of the corner's call and fix): the same
## fighter on the same nights (same seeds) with only her morale changed. Bounds, never exact counts; the measured numbers
## are printed (they back the ask card's "a Flat or Low fighter takes in less of the corner's calls").
##   1. Low (20) wins fewer rounds than Fired up (80) against the same opponent,
##   2. control arm: two Steady mornings (55 and 70) fight the very same bouts (trust 1.0 both) - the instrument reads
##      nothing where there is nothing.
## Population: Lucy (Data.lucy, out-boxer) vs Maria (Data.OPPONENTS[0], pressure fighter) and Erin (Data.OPPONENTS[2],
## volume puncher). NIGHTS each.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const NIGHTS := 120

var _fails := 0


func _initialize() -> void:
	for opp_i in [0, 2]:
		var low := _arm(opp_i, 20.0)
		var fired := _arm(opp_i, 80.0)
		var who := str((Data.OPPONENTS[opp_i] as Dictionary)["name"])
		print("  vs %s: rounds won Low %d, Fired up %d (of ~%d)" % [who, low["won"], fired["won"], NIGHTS * 3])
		_check(int(fired["won"]) > int(low["won"]), "vs %s: a fighter who trusts the corner wins more rounds" % who)
		_check(int(fired["won"]) - int(low["won"]) < NIGHTS, "vs %s: trust is an edge, not the fight (gap %d)" % [who, int(fired["won"]) - int(low["won"])])
	var s1 := _arm(0, 55.0)
	var s2 := _arm(0, 70.0)
	_check(s1 == s2, "control: Steady 55 and Steady 70 fight the same bouts (%d = %d rounds)" % [s1["won"], s2["won"]])
	print("TRUST_FIGHT %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _arm(opp_i: int, morale: float) -> Dictionary:
	var out := {"won": 0, "landed": 0}
	var c := Career.quick_start()
	c.fighters.insert(0, {})
	for i in NIGHTS:
		c.day = 20 + i
		c.news.clear()
		var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
		f["morale"] = morale
		c.fighters[0] = f
		f["bout"] = {"opp": (Data.OPPONENTS[opp_i] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true,
			"done": false, "film": 1}
		f["camp"] = {}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		for r in m["rounds"]:
			out["won"] = int(out["won"]) + int(bool(r["won"]))
			out["landed"] = int(out["landed"]) + int((r["landed"] as Array)[0])
	return out


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
