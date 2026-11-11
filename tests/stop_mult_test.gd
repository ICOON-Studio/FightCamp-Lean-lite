extends SceneTree
## S433 STOPMULT1 (foundation F8, CORE_LOOP_MAP_S432 section 5): the referee's stoppage multiplier works for BOTH corners.
## Before: BoutNight set stop_mult only on side "b" (our Finisher on the opponent) and Knockdowns.puncher_chance never read
## it, so an opponent's Finisher, or any later trait on our own fighter (HARDENED, SHAKEN), could not reach the referee.
## Checks: (1) count_sides puts the opponent's Finisher on side "a" and ours on side "b"; (2) puncher_chance stops a counted
## boxer more often at stop_mult 3 than at 1 on the same 3,000 seeds (bounds, never an exact count); (3) at stop_mult 1 the
## result is the same as without the key (the default is untouched). Population: a hard-hit boxer (chin 50, damage 60)
## against a heavy hand (power 80) and a light one (power 55), both with heart 50.

const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Data := preload("res://scripts/state/Data.gd")
const SEEDS := 3000

var _fails := 0


func _initialize() -> void:
	var f: Dictionary = Data.lucy()
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var plain := BoutNight.count_sides(f, opp)
	_check(is_equal_approx(float(plain["a"].get("stop_mult", -1.0)), 1.0) and is_equal_approx(float(plain["b"].get("stop_mult", -1.0)), 1.0),
		"no perks: both sides carry stop_mult 1.0 (a=%s b=%s)" % [str(plain["a"].get("stop_mult")), str(plain["b"].get("stop_mult"))])
	var opp_fin := opp.duplicate(true)
	opp_fin["perks"] = {"finisher": true}
	var s2 := BoutNight.count_sides(f, opp_fin)
	_check(float(s2["a"]["stop_mult"]) > 1.0 and is_equal_approx(float(s2["b"]["stop_mult"]), 1.0),
		"the opponent's Finisher lands on side a (a=%.2f b=%.2f)" % [float(s2["a"]["stop_mult"]), float(s2["b"]["stop_mult"])])

	for power in [80.0, 55.0]:
		var one := _stops(power, 1.0)
		var three := _stops(power, 3.0)
		var none := _stops(power, -1.0)
		print("  power %.0f vs chin 50: counts %d, stopped at stop_mult 1: %d, at 3: %d, no key: %d" % [power, one["counts"], one["stopped"], three["stopped"], none["stopped"]])
		_check(int(three["stopped"]) > int(one["stopped"]), "power %.0f: stop_mult 3 stops more counted boxers (%d > %d)" % [power, three["stopped"], one["stopped"]])
		_check(int(one["stopped"]) == int(none["stopped"]) and int(one["counts"]) == int(none["counts"]), "power %.0f: stop_mult 1 equals no key" % power)
		_check(int(three["counts"]) == int(one["counts"]), "power %.0f: the multiplier moves the referee, not the count (%d = %d)" % [power, three["counts"], one["counts"]])
	print("STOP_MULT failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _stops(power: float, mult: float) -> Dictionary:
	var counts := 0
	var stopped := 0
	for seed in range(SEEDS):
		var target := {"power": 60.0, "chin": 50.0, "heart": 50.0}
		if mult >= 0.0:
			target["stop_mult"] = mult
		var sides := {"a": target, "b": {"power": power, "chin": 60.0, "heart": 55.0}}
		var rng := RandomNumberGenerator.new()
		rng.seed = seed * 7919 + 13
		var k := Knockdowns.puncher_chance("a", sides, {"a": 60.0, "b": 0.0}, {"a": 0, "b": 0}, rng)
		counts += int(k["counts"])
		stopped += 1 if bool(k["stopped"]) else 0
	return {"counts": counts, "stopped": stopped}


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
