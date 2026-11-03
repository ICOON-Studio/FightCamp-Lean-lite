extends SceneTree
## S373 tired legs (operator S369: "when fighter is tired legs should become red on the holo and this should affect the
## power that the shots have"): BodyBurn's emptying tank reaches the legs' Burn (the holo and the HUD's legs ring), her
## steps and her punch power, beside the parts' own load. Population: two fresh bodies (no load) - one boxer on a full
## tank, one on BodyBurn.TANK_ALL; one halfway between TANK_FROM and TANK_ALL.

const BodyBurn := preload("res://scripts/fight3d/BodyBurn.gd")
const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const FightMeters := preload("res://scripts/rules/FightMeters.gd")

var failures := 0


func _initialize() -> void:
	var bb: Node = BodyBurn.new()
	bb.off = false
	bb._tank = {"a": 100.0, "b": BodyBurn.TANK_ALL}
	var fresh: Dictionary = bb._fx("a")
	var spent: Dictionary = bb._fx("b")
	_check(is_equal_approx(float(fresh["b_legs"]), 0.0) and is_equal_approx(float(fresh["legs"]), 1.0)
		and is_equal_approx(float(fresh["power_rear"]), 1.0), "a full tank on a fresh body: legs clear, full steps, full power")
	_check(is_equal_approx(float(spent["b_legs"]), 100.0), "an empty tank turns the legs red on the holo (%.0f)" % float(spent["b_legs"]))
	_check(is_equal_approx(float(spent["legs"]), BodyLoad.STEP_MIN), "and shortens the steps to the burnt-legs minimum (%.2f)" % float(spent["legs"]))
	var want := lerpf(1.0, BodyLoad.POWER_MIN, BodyBurn.TANK_POWER)
	_check(is_equal_approx(float(spent["power_lead"]), want) and is_equal_approx(float(spent["power_rear"]), want),
		"tired shots land lighter (power %.2f)" % float(spent["power_rear"]))
	bb._tank["b"] = (BodyBurn.TANK_FROM + BodyBurn.TANK_ALL) / 2.0
	var half: Dictionary = bb._fx("b")
	_check(float(half["b_legs"]) > BodyLoad.EFFECT_FROM and float(half["b_legs"]) < 100.0
		and float(half["legs"]) < 1.0 and float(half["legs"]) > BodyLoad.STEP_MIN, "halfway down the tank, halfway red (%.0f)" % float(half["b_legs"]))
	var bars := FightMeters.bars({"energy": BodyBurn.TANK_ALL, "burn": {"legs": float(spent["b_legs"])}})
	_check(float(bars["legs"]["fill"]) <= 0.01, "the HUD's legs ring empties with her (%s)" % str(bars["legs"]))
	bb.off = true
	_check(is_equal_approx(float(bb._fx("b")["b_legs"]), 0.0), "the control arm (-- noburn) shows nothing")
	bb.free()
	print("TIRED_LEGS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
