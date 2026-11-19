extends SceneTree
## S524 KNOWLEDGE1 build step 2: KnowWire feeds Knowledge.gd from the game.
## A new signing starts fresh (under fire Unknown); the quick start's boxer (no record) reads exact, as old saves do;
## a week of mornings and pad nights narrows Body/Skills and leaves Under fire Unknown; a bout opens Under fire and
## a stoppage loss widens it with its cause; 12 weeks without a bout widens it once; a goal met narrows its group.
## Control arm: a resting boxer's day narrows nothing.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const K := preload("res://scripts/rules/Knowledge.gd")
const KnowWire := preload("res://scripts/state/KnowWire.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var lucy: Dictionary = c.fighter()
	_check(bool(KnowWire.of(lucy).get("seen_all", false)) and K.width(KnowWire.of(lucy), "body") == 0.0,
		"a boxer with no record (old save, quick start) reads exact")
	var raw := Data.lucy().duplicate(true)
	raw["id"] = "kw_new"
	raw["name"] = "New Signing"
	raw["first"] = "New"
	var f := Roster.sign_fighter(c, raw, [])
	var k := KnowWire.of(f)
	_check(not bool(k.get("seen_all", false)) and K.width(k, "body") == K.BODY_START and K.word(K.width(k, "under_fire")) == "Unknown",
		"a new signing starts at day one: body +-%.1f, under fire %s" % [K.width(k, "body"), K.word(K.width(k, "under_fire"))])
	var b0 := K.width(k, "body") + K.width(k, "skills")
	for i in 14:
		Sim.step_day(c)
	var b1 := K.width(k, "body") + K.width(k, "skills")
	_check(b1 < b0 - 0.5, "two weeks of mornings and nights narrow body + skills (%.2f -> %.2f)" % [b0, b1])
	_check(K.word(K.width(k, "under_fire")) == "Unknown", "training alone never opens under fire")
	# Control: a resting day narrows nothing.
	var before := k.duplicate(true)
	KnowWire.day(f, "roadwork", "pads", true)
	_check(k == before, "a resting day narrows nothing")
	# A bout opens under fire; a stoppage loss widens it and keeps the cause.
	KnowWire.bout(f, false, false, c.day)
	var w_open := K.width(k, "under_fire")
	_check(w_open < K.UNDER_FIRE_START, "a bout opens under fire (+-%.1f)" % w_open)
	KnowWire.bout(f, true, false, c.day)
	_check(K.stale_causes(k).size() == 1 and K.width(k, "under_fire") > w_open and str(K.stale_causes(k)[0]).begins_with("Stoppage"),
		"a stoppage loss widens under fire: %s" % str(K.stale_causes(k)))
	# 12 weeks without a bout: once.
	var day0 := int(k["last_bout"])
	KnowWire.week_end(f, day0 + 77)
	_check(K.stale_causes(k).size() == 1, "11 weeks: not yet stale")
	KnowWire.week_end(f, day0 + 84)
	KnowWire.week_end(f, day0 + 91)
	_check(K.stale_causes(k).size() == 2 and str(K.stale_causes(k)[1]).contains("12+ weeks"), "12 weeks without a bout widens it once")
	# A goal met narrows its group (old key technique -> accuracy, timing: skills).
	var s0 := K.width(k, "skills")
	KnowWire.goal_met(f, {"technique": 60.0})
	_check(K.width(k, "skills") < s0, "a technique goal met narrows skills (%.2f -> %.2f)" % [s0, K.width(k, "skills")])
	print("KNOW_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)
