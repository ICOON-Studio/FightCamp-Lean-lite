extends SceneTree
## S539 owner "build the weigh-in miss answers for pro bouts": a pro boxer who misses weight gets the other corner's answer
## (WeighMiss.gd) and the player decides (WeighMissWire.gd), instead of the bout simply being off.
##   1. rules: up to 0.5 kg over they box for 20%; over 2.5 kg they walk; in between they want 35% or walk, a tough style
##      walks half as often;
##   2. a pro miss keeps the bout, waits on the player (the weigh-in stays open, so it blocks Continue);
##   3. box anyway: the share leaves the purse, she boxes drained, fight night comes tomorrow;
##   4. pull out: the old path (bout off, $300 for the empty slot); a walk-out cannot be boxed;
##   5. amateur bouts keep their own path (no answer to wait on).
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/weigh_miss_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeighMiss := preload("res://scripts/rules/WeighMiss.gd")
const WeighMissWire := preload("res://scripts/state/WeighMissWire.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## A pro boxer `over` kg above the limit, weigh-in today, a $2,000 purse.
func _pro(seed: int, over: float, style := "Out-boxer", pro := true) -> Career:
	var c := Career.quick_start()
	c.seed = seed
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["pro"] = pro
	f["weight"] = float(f["limit"]) + over
	var rival: Dictionary = {}
	for n in (Data.DIVISIONS[f["div"]]["opponents"] as Array):
		rival = c.rival(str(n)).duplicate(true)
		if not rival.is_empty():
			break
	rival["style"] = style
	f["bout"] = {"day": c.day + 1, "done": false, "opp": rival, "purse": 2000}
	return c


func _initialize() -> void:
	# 1. the rules
	_check(WeighMiss.answer(0.3, "", 0.0) == "fight" and WeighMiss.answer(3.0, "Slugger", 0.99) == "walk", "0.3 kg over: they box; 3.0 kg over: they walk")
	var walks := 0
	var tough_walks := 0
	for i in 200:
		var r := (i + 0.5) / 200.0
		walks += 1 if WeighMiss.answer(1.5, "Out-boxer", r) == "walk" else 0
		tough_walks += 1 if WeighMiss.answer(1.5, "Slugger", r) == "walk" else 0
	_check(walks > 60 and walks < 140 and tough_walks < walks, "1.5 kg over: walks %d of 200, a tough style %d" % [walks, tough_walks])
	_check(WeighMiss.price("fight", 2000) == 400 and WeighMiss.price("terms", 2000) == 700 and WeighMiss.price("walk", 2000) == 0, "the share: 20% / 35% / none")
	# 2. a pro miss waits on the player
	var c := _pro(11, 0.3)
	var f: Dictionary = c.fighters[0]
	var made := Bouts.weigh(c, f)
	_check(not made and WeighMissWire.pending(f), "a pro miss keeps the bout and waits for the answer")
	_check(Bouts.weigh_in_today(c, f), "the weigh-in stays open (it blocks Continue) until the player answers")
	_check(str(f["bout"]["miss"]["ans"]) == "fight" and int(f["bout"]["miss"]["cost"]) == 400, "0.3 kg over: they box for $400")
	# 3. box anyway
	WeighMissWire.box(c, f)
	_check(not WeighMissWire.pending(f) and int(f["bout"]["purse"]) == 1600 and bool(f["bout"]["missed_weight"]), "boxed: purse 2000 -> %d, drained" % int(f["bout"].get("purse", -1)))
	_check(not Bouts.weigh_in_today(c, f), "answered: the weigh-in closes")
	c.day += 1
	_check(Bouts.fight_day(c, f), "fight night comes tomorrow")
	# 4. pull out, and a walk-out
	c = _pro(12, 0.3)
	f = c.fighters[0]
	var cash0 := c.cash
	Bouts.weigh(c, f)
	WeighMissWire.pull(c, f)
	_check((f["bout"] as Dictionary).is_empty() and c.cash == cash0 - BoutRules.MISSED_WEIGHT_COST, "pulled out: bout off, $%d for the empty slot" % BoutRules.MISSED_WEIGHT_COST)
	c = _pro(13, 3.0)
	f = c.fighters[0]
	Bouts.weigh(c, f)
	_check(str(f["bout"]["miss"]["ans"]) == "walk" and not WeighMiss.can_box("walk"), "3.0 kg over: they walk, no box button")
	WeighMissWire.box(c, f)
	_check((f["bout"] as Dictionary).is_empty(), "box on a walk-out falls back to the bout off")
	# 5. amateur bouts keep their path
	c = _pro(14, 0.3, "Out-boxer", false)
	f = c.fighters[0]
	Bouts.weigh(c, f)
	_check(not WeighMissWire.pending(f), "an amateur miss has no answer to wait on")
	print("WEIGH_MISS failures=%d" % failures)
	quit(1 if failures > 0 else 0)
