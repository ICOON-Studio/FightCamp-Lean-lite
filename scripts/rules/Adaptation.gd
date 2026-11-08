extends RefCounted
## S406 ONE CHANGE (ops/research/ADAPTATION_S406.md; operator "Build small version"): between rounds the corner may change how
## the boxer carries the guard for one round. It shares the habit fix's slot, so the corner gains no row. Elbows in sends part
## of the body punches to the head (each one moved saves its energy, adds head damage); Gloves high does the reverse. Measured
## before building: this moves where punches land and what they cost, not who wins. Leave it plays exactly as before.
## Pure static.
##   offers(exchanges, hold, last, ...) -> [{id, key, name, small, tip}]   start(bout, id, hold) -> the round's record
##   body_shots(lv, m, landed, share, roll) -> her body punches this exchange   result(record) -> the next card's line
##   suffix(chosen) -> the corner action's part

const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const PREFIX := "adapt:"
const ELBOWS := "elbows"
const GLOVES := "gloves"
const NAMES := {ELBOWS: "Elbows in", GLOVES: "Gloves high"}
## Offered from last round's punches on her (S406, medians per round: head 12-21; body 7 against a presser, 3-4 otherwise).
const OFFER_BODY_AT := 4
const OFFER_HEAD_AT := 10
## Elbows in: this part of the body punches go to the head. Gloves high: this much more of her punches go to the body.
const ELBOWS_MOVE := 0.5
const GLOVES_ADD := 0.15
## Head damage (Knockdowns) per punch moved onto the head, or taken off it. Tuned on tools/exchange_balance.gd.
const HEAD_DAMAGE := 2.0
## The same change two rounds running: the opponent has seen it.
const REPEAT_HOLD := 0.7


## What can be offered after a round. exchanges = the closed round's; hold = how much the boxer takes in (0..1); last = the
## change that round ("" = none).
static func offers(exchanges: Array, hold: float, last: String) -> Array:
	var body := 0
	var total := 0
	for x in exchanges:
		total += int((x as Dictionary)["landed"][1])
		body += int((x as Dictionary)["body"][1])
	var head := total - body
	var out: Array = []
	var elbows := _moved(body * ELBOWS_MOVE, hold, last == ELBOWS)
	if body >= OFFER_BODY_AT and elbows >= 1:
		out.append(_offer(ELBOWS, "%d fewer body, %d more head, +%d energy" % [elbows, elbows, _energy(elbows)],
			"About %d fewer punches to the body saves about %d energy. About %d more to the head brings a knockdown closer." % [elbows, _energy(elbows), elbows]))
	var gloves := _moved(total * GLOVES_ADD, hold, last == GLOVES)
	if head >= OFFER_HEAD_AT and gloves >= 1:
		out.append(_offer(GLOVES, "%d fewer head, %d more body, -%d energy" % [gloves, gloves, _energy(gloves)],
			"About %d fewer punches to the head keeps a knockdown further off. About %d more to the body costs about %d energy." % [gloves, gloves, _energy(gloves)]))
	return out


static func _moved(punches: float, hold: float, repeat: bool) -> int:
	return int(round(punches * clampf(hold, 0.0, 1.0) * (REPEAT_HOLD if repeat else 1.0)))


static func _energy(moved: int) -> int:
	return int(round(moved * Exchanges.BODY_COST))


static func _offer(id: String, small: String, tip: String) -> Dictionary:
	return {"id": id, "key": PREFIX + id, "name": str(NAMES[id]), "small": small, "tip": tip + " One round only."}


## The round's record, opened at the bell. Also remembers the change on the bout, so asking twice running holds less.
static func start(bout: Dictionary, id: String, hold: float) -> Dictionary:
	var h := clampf(hold, 0.0, 1.0) * (REPEAT_HOLD if id != "" and str(bout.get("last_adapt", "")) == id else 1.0)
	bout["last_adapt"] = id
	return {"id": id, "hold": h, "moved": 0}


## The share of her landed punches that go to the body, after the change.
static func share(id: String, base: float, hold: float) -> float:
	match id:
		ELBOWS:
			return base * (1.0 - ELBOWS_MOVE * clampf(hold, 0.0, 1.0))
		GLOVES:
			return minf(1.0, base + GLOVES_ADD * clampf(hold, 0.0, 1.0))
	return base


## The body punches she takes this exchange. Uses the caller's one roll, so a round with no change plays exactly as before.
static func body_shots(lv: Dictionary, m: Dictionary, landed: int, base_share: float, roll: float) -> int:
	var was := Exchanges.body_shots(landed, base_share, roll)
	var a: Dictionary = lv.get("adapt", {})
	if str(a.get("id", "")) == "":
		return was
	var now := Exchanges.body_shots(landed, share(str(a["id"]), base_share, float(a["hold"])), roll)
	a["moved"] = int(a["moved"]) + absi(was - now)
	var dmg: Dictionary = m.get("damage", {"a": 0.0, "b": 0.0})
	dmg["a"] = maxf(0.0, float(dmg.get("a", 0.0)) + float(was - now) * HEAD_DAMAGE)
	m["damage"] = dmg
	return now


## What last round's change did, for the next corner card. "" when there was none.
static func result(record: Dictionary) -> String:
	var id := str(record.get("id", ""))
	if id == "":
		return ""
	var n := int(record.get("moved", 0))
	if n <= 0:
		return "%s made no difference last round." % str(NAMES[id])
	if id == ELBOWS:
		return "Elbows in last round: %d fewer to the body, %d more to the head." % [n, n]
	return "Gloves high last round: %d fewer to the head, %d more to the body." % [n, n]


## The corner action's part for what the slot holds: "" (Leave it), a habit fix, or a change.
static func suffix(chosen: String) -> String:
	if chosen == "":
		return ""
	if chosen.begins_with(PREFIX):
		return "|adapt=" + chosen.trim_prefix(PREFIX)
	return "|fix=" + chosen
