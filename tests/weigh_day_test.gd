extends SceneTree
## S513 FIGHTWEEK3 (map AMATEURWEEK1 v6 s6): the club-show weigh-in's three ways, through Bouts.weigh.
##   1. TRAIN IT OFF: 0.2 kg outside the gap -> made, 0.3 kg lighter, +8 tiredness; without it -> not made;
##   2. ASK FOR A KILO: 0.8 kg outside -> made with the kilo; the lock spends one favour; greyed with no favour / inside;
##   3. A MISS: over many seeds about 1 in 3 re-matched on the night (the bout goes on with a spare at her weight),
##      the rest off with one favour taken by the host.
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/weigh_day_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const WeighGap := preload("res://scripts/rules/WeighGap.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## A club with Lucy on a club-show bout whose opponent stands `outside` kg beyond the gap below her.
func _club(seed: int, outside: float, plan: Dictionary = {}) -> Career:
	var c := Career.quick_start()
	c.seed = seed
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var lim := float(f["limit"])
	f["weight"] = lim + 1.0   # over the limit: only the walking-weight gap can make the match
	var opp := float(f["weight"]) - WeighGap.gap_kg(lim) - outside
	var rival: Dictionary = {}
	for n in (Data.DIVISIONS[f["div"]]["opponents"] as Array):
		rival = c.rival(str(n)).duplicate(true)
		if not rival.is_empty():
			break
	rival["weight"] = opp
	f["bout"] = {"day": c.day, "done": false, "fight_week": true, "host": "Test Host ABC", "opp": rival}
	for k in plan:
		f["bout"][k] = plan[k]
	return c


func _initialize() -> void:
	var c := _club(3, 0.2)
	var f: Dictionary = c.fighters[0]
	var lim := float(f["limit"])
	var w0 := float(f["weight"])
	var t0 := FightWeekPlan.tired(f)
	_check(FightWeekPlan.weight(f)["in_gap"] == false and FightWeekPlan.weight(f, {"train_off": true})["in_gap"] == true,
		"the screen's scale: outside by 0.2, inside once trained off")
	c = _club(3, 0.2, {"train_off": true})
	f = c.fighters[0]
	_check(Bouts.weigh(c, f), "train it off: made")
	_check(is_equal_approx(float(f["weight"]), w0 - WeighGap.TRAIN_OFF_KG) and FightWeekPlan.tired(f) == t0 + WeighGap.TRAIN_OFF_TIRED,
		"train it off: %.1f -> %.1f kg, tiredness %d -> %d" % [w0, float(f["weight"]), t0, FightWeekPlan.tired(f)])
	var k := _club(4, 0.8)
	var kf: Dictionary = k.fighters[0]
	k.favours["Test Host ABC"] = 1
	var ways := FightWeekPlan.weigh_ways(k, kf)
	_check(bool(ways[2]["ok"]), "ask for a kilo: open 0.8 kg outside with a favour")
	k.favours["Test Host ABC"] = 0
	_check(not bool(FightWeekPlan.weigh_ways(k, kf)[2]["ok"]), "ask for a kilo: greyed with no favour (%s)" % str(FightWeekPlan.weigh_ways(k, kf)[2]["why"]))
	var k2 := _club(4, 0.8, {"ask_kilo": true})
	_check(Bouts.weigh(k2, k2.fighters[0]), "ask for a kilo: made on the day")
	var rem := 0
	var off := 0
	var fav_ok := 0
	var spare_ok := 0
	var n := 300
	for s in n:
		var m := _club(100 + s, 0.8)
		m.favours["Test Host ABC"] = 2
		var mf: Dictionary = m.fighters[0]
		var was := str(mf["bout"]["opp"].get("name", ""))
		var made := Bouts.weigh(m, mf)
		if made:
			rem += 1
			if str(mf["bout"]["opp"].get("name", "")) != was and is_equal_approx(float(mf["bout"]["opp"]["weight"]), float(mf["weight"])):
				spare_ok += 1
		else:
			off += 1
			if int(m.favours["Test Host ABC"]) == 1 and (mf["bout"] as Dictionary).is_empty():
				fav_ok += 1
	var rate := float(rem) / n
	_check(rate > 0.25 and rate < 0.42, "a miss: re-matched on the night %d of %d (rule 1 in 3)" % [rem, n])
	_check(rem > 0 and spare_ok == rem, "every re-match is a new opponent at her walking weight (%d of %d)" % [spare_ok, rem])
	_check(off > 0 and fav_ok == off, "every miss that goes off costs the host's favour and ends the bout (%d of %d)" % [fav_ok, off])
	print("WEIGH_DAY %s" % ("PASS" if failures == 0 else "FAIL %d" % failures))
	quit(0 if failures == 0 else 1)
