extends RefCounted
## S539 the pro weigh-in miss, wired (rules: WeighMiss.gd). Bouts.weigh calls open() on a pro miss; the weigh-in modal
## shows the other corner's answer while bout["miss"] is set (Bouts.weigh_in_today stays true, so it blocks Continue),
## and the player answers with box() or pull().

const WeighMiss := preload("res://scripts/rules/WeighMiss.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")


## A pro bout that may get the other corner's answer (championship draws and amateur bouts keep their own paths).
static func applies(f: Dictionary) -> bool:
	var b: Dictionary = f.get("bout", {})
	return bool(f.get("pro", false)) and not b.has("champ") and not WeekPhase.amateur(b)


## The purse the share is taken from: the bout's, else the boxer's going rate.
static func purse_of(f: Dictionary) -> int:
	return int((f["bout"] as Dictionary).get("purse", f.get("purse", 0)))


## The miss is on the record; the other corner answers. Returns false (she did not make weight).
static func open(c: Career, f: Dictionary) -> bool:
	var b: Dictionary = f["bout"]
	var over := float(f["weight"]) - float(f["limit"])
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 7919 + int(b.get("day", c.day)) * 37 + absi(hash(str(f.get("id", "")) + "|weighmiss"))
	var opp: Dictionary = b.get("opp", {})
	var ans := WeighMiss.answer(over, str(opp.get("style", "")), rng.randf())
	b["miss"] = {"over": snappedf(over, 0.1), "ans": ans, "cost": WeighMiss.price(ans, purse_of(f))}
	b["made"] = false
	f["missed_weight_n"] = int(f.get("missed_weight_n", 0)) + 1
	return false


static func pending(f: Dictionary) -> bool:
	return (f.get("bout", {}) as Dictionary).has("miss")


## Box anyway: the share leaves the boxer's purse (the gym's cut shrinks with it), and she boxes drained.
static func box(c: Career, f: Dictionary) -> void:
	var b: Dictionary = f["bout"]
	var m: Dictionary = b["miss"]
	if not WeighMiss.can_box(str(m["ans"])):
		pull(c, f)
		return
	var cost := int(m["cost"])
	if b.has("purse"):
		b["purse"] = maxi(0, int(b["purse"]) - cost)
	else:
		c.pay(-cost, "Weigh-in miss: %s's share to the other corner" % f["first"])
	b["missed_weight"] = true
	b["made"] = true
	b.erase("miss")
	c.add_news("%s missed weight by %.1f kg and boxes anyway: %s to the other corner." % [f["first"], float(m["over"]), GameMoney.text(cost)])


## Pull out (or the other corner walked): the bout is off, the club pays for the empty slot.
static func pull(c: Career, f: Dictionary) -> void:
	(f["bout"] as Dictionary).erase("miss")
	load("res://scripts/state/Bouts.gd").call_off(c, f)
