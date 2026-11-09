extends RefCounted
## S333 THE READ inside the live round (moved out of LiveRound S398 to keep it under 500 lines): the read kept on the
## bout, whether she throws the read counter this exchange, and what the corner card shows of it.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")


static func _rng(c: Career, f: Dictionary, n: int, i: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 31 + n * 7 + i * 101 + 3 + c.fighters.find(f) * 1009
	return rng


## S333 THE READ for this bout, kept on the bout so it carries round to round. With film study her main game starts part-read.
static func read_state(f: Dictionary) -> Dictionary:
	var fb: Dictionary = f["bout"]
	if not fb.has("read"):
		var film := int(fb.get("film", 0)) >= BoutRules.FILM_DEPTH_WITH_STUDY
		fb["read"] = TheRead.start({}, Exchanges.favourite(str((fb["opp"] as Dictionary).get("style", ""))) if film else "")
	return fb["read"]


## Whether she throws the read counter this exchange: {} when not, else {game, read, trig, move, result, edge}.
static func read_fire(c: Career, f: Dictionary, lv: Dictionary, st: Dictionary, game: String, read_call: String, n: int,
		i: int) -> Dictionary:
	# Once a round per habit: the opponent sees the first one coming and is careful with that game for a while.
	if not TheRead.COUNTER.has(game) or bool(lv["her_hurt"]) or (lv.get("read_fired", []) as Array).has(game):
		return {}
	var now_read := TheRead.read(st, game)
	var call := "now" if read_call == "take" else str(lv.get("read_call", ""))
	var trig := TheRead.called(TheRead.trigger(f), call, now_read)
	if not TheRead.fires(now_read, trig):
		return {}
	var move := str(TheRead.COUNTER[game])
	var mastery := float((f.get("moves", {}) as Dictionary).get(move, 0.0))
	var landed := _rng(c, f, n, i + 51).randf() < TheRead.land_chance(now_read, mastery)
	if not lv.has("read_fired"):
		lv["read_fired"] = []
	(lv["read_fired"] as Array).append(game)
	return {"game": game, "read": snappedf(now_read, 0.01), "trig": snappedf(trig, 0.01), "move": move,
		"result": "landed" if landed else "missed", "edge": TheRead.EDGE_LANDED if landed else TheRead.EDGE_MISSED}


## What the corner card shows of THE READ on the game it sees: {game, label, read, trig, temper, line, counter}.
static func read_view(f: Dictionary, seen: String) -> Dictionary:
	if not TheRead.COUNTER.has(seen):
		return {}
	var st := read_state(f)
	var trig := TheRead.trigger(f)
	var label := str(Exchanges.MODES[seen]["label"])
	return {"game": seen, "label": label, "read": TheRead.read(st, seen), "trig": trig, "temper": TheRead.temperament(f),
		"line": TheRead.line(TheRead.read(st, seen), trig, label.to_lower()), "counter": str(TheRead.COUNTER[seen]),
		"dropped": TheRead.dropped(st, seen)}
