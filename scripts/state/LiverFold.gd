extends RefCounted
## S467 LIVERRIBS1 v2 rules 2-3: the liver fold. Once a boxer's liver (the right side) is hurt, each new liver shot she took
## this round rolls LiverRibs.liver_fold_chance; a fold is a body knockdown - a standing count that counts toward the
## referee's limits like any other (Knockdowns.COUNTS_ROUND_STOP / COUNTS_BOUT_STOP). At most LiverRibs.FOLDS_MAX a bout.
## The liver's value in the bout is read from the shot tally (shot_points a shot), because the body map is built after
## the bell. Its own dice (salted seed), so a bout without a fold rolls exactly as before.

const LiverRibs := preload("res://scripts/rules/LiverRibs.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")

## Points one liver shot of the live tally takes off (100 fresh, hurt <= 55, critical <= 35). Not BodyMap.RIB_HIT: the live
## tally counts every body shot of the exchanges (about 9 liver shots a boxer a bout, at most 13 in 100 bouts), so 2.9 a
## shot never reached hurt (tools/liverfold_probe.gd, S467: 0 folds in 100 bouts). S467 probe, 100 bouts: 6.0 -> 7 folds of 27 counts
## (26 %; bar 10-20 %), 7.5 -> 22 of 42, 5.5 -> 0. LIVERPROBE1 tunes it on 400 bouts.
static var shot_points := 6.0
## The fold chance's scale on top of LiverRibs.liver_fold_chance (its BASE_FOLD is the design's ESTIMATE, "tuned by
## LIVERPROBE1"): the same probe's knob, kept here so the pure module keeps the design's numbers.
static var fold_scale := 1.0
const MASTERY := 50.0   # the move's mastery is not on the round yet; 50 = the formula's middle (0.75 of the power)


## The liver's value (100 fresh) after `shots` liver shots.
static func liver_value(shots: int) -> float:
	return maxf(0.0, 100.0 - float(shots) * shot_points)


## {} or a count like Knockdowns.round_counts' plus "who" (the boxer who folds). Call once a round, after the round's counts,
## only when nobody was counted. Keeps f.bout.liver_seen / f.bout.folds.
static func roll(f: Dictionary, so_far: Dictionary, seed_value: int, damage: Dictionary, lines: Array = []) -> Dictionary:
	var b: Dictionary = f["bout"]
	var tally: Dictionary = b.get("sides", {})
	if tally.is_empty():
		return {}
	var seen: Dictionary = b.get("liver_seen", {"a": 0, "b": 0})
	var folds: Dictionary = b.get("folds", {"a": 0, "b": 0})
	var att := {"a": AttrGen.attrs_of(b["opp"]), "b": Attrs.of(f)}   # who hits the liver of "a" is the opponent
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value * 7 + 4111 + hash(str(b["opp"].get("name", "")) + str(tally))   # this bout's own dice
	var out := {}
	for who in ["a", "b"]:
		var liver := int(LiverRibs.counts(tally.get(who, {}))["liver"])
		var fresh := liver - int(seen.get(who, 0))
		seen[who] = liver
		if not out.is_empty():
			continue
		var hitter: Dictionary = att[who]
		var me: Dictionary = att["b" if who == "a" else "a"]
		for i in maxi(0, fresh):
			var p := LiverRibs.liver_fold_chance(float(hitter.get("strength", 55.0)), float(hitter.get("explosiveness", 55.0)),
				MASTERY, float(me.get("durability", 55.0)), liver_value(liver - fresh + i + 1), int(folds.get(who, 0)))
			if p > 0.0 and rng.randf() < p * fold_scale:
				folds[who] = int(folds.get(who, 0)) + 1
				var n := int(so_far.get(who, 0)) + 1
				out = {"who": who, "counts": 1, "up_at": [8], "damage": damage,
					"how": "RSC" if n >= Knockdowns.COUNTS_BOUT_STOP else "", "stopped": n >= Knockdowns.COUNTS_BOUT_STOP}
				break
	b["liver_seen"] = seen
	b["folds"] = folds
	_crack(b, tally, rng, lines)
	return out


## Rule 6: once a boxer's left ribs are critical, each fresh rib shot rolls LiverRibs.crack_chance; a crack is kept on
## the bout (b.cracked) - that side lands x CRACK_OUTPUT from then (LiveRound) - and on the round (r.rib_crack, the
## injury after the bell reads it). Same per-shot scale as the liver.
static func _crack(b: Dictionary, tally: Dictionary, rng: RandomNumberGenerator, lines: Array) -> void:
	var seen: Dictionary = b.get("ribs_seen", {"a": 0, "b": 0})
	var cracked: Dictionary = b.get("cracked", {"a": false, "b": false})
	for who in ["a", "b"]:
		var ribs := int(LiverRibs.counts(tally.get(who, {}))["ribs"])
		var fresh := ribs - int(seen.get(who, 0))
		seen[who] = ribs
		for i in maxi(0, fresh):
			var p := LiverRibs.crack_chance(liver_value(ribs - fresh + i + 1), bool(cracked.get(who, false)))
			if p > 0.0 and rng.randf() < p:
				cracked[who] = true
				lines.append("%s's left ribs crack: that side is holding on now." % ("Your boxer" if who == "a" else "The opponent"))
				break
	b["ribs_seen"] = seen
	b["cracked"] = cracked
