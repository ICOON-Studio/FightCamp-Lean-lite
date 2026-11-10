extends RefCounted
## S389 CLASH (operator: "make it clear in the fight what happens and why ... showing why and how each wins by a visual effect
## showing the icons of each skill colliding"; the judges: 0 of 3 first-time players could say why the match was won).
## The reasons are the real ones: factors() takes BjjMatch.odds apart term by term, so what the panel says IS what was rolled.
## Pure static.

const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")

## Below this the move is a long shot, above FAVOURED it should land (words only).
const LONG_SHOT := 0.25
const FAVOURED := 0.6
## A move this size gets the big clash in the middle of the mat; the rest only the small one.
const BIG_KINDS := ["sub", "takedown", "sweep", "pass", "mount", "back", "knee_on_belly"]

const ATTACK := {"takedown": ["Takedown", "trending-down"], "sweep": ["Sweep", "refresh-cw"], "pass": ["Guard pass", "footprints"],
	"mount": ["Take mount", "target"], "back": ["Take the back", "user"], "knee_on_belly": ["Knee on belly", "target"],
	"sub": ["Submission", "lock"], "escape": ["Escape", "zap"], "advance": ["Move up", "trending-up"]}
const DEFENCE := {"takedown": ["Sprawl", "shield"], "sweep": ["Base", "shield"], "pass": ["Guard", "shield"], "mount": ["Frames", "shield"],
	"back": ["Hand fight", "shield"], "knee_on_belly": ["Frames", "shield"], "sub": ["Defends the lock", "shield-alert"],
	"escape": ["The pin", "lock"], "advance": ["Frames", "shield"]}


## The odds term by term, in percentage points: base, technique (this move), skill, strength, gas. Their sum is the odds
## before BjjMatch's clamp.
static func factors(st: Dictionary, me: int, o: Dictionary) -> Array:
	var kind := str(o["kind"])
	var base := float(BjjMatch.KIND_BASE.get(kind, 0.3))
	var technique := base * (BjjMatch.MASTERY_FLOOR + float(o.get("m", BjjMatch.PLAIN_MASTERY)) / BjjMatch.MASTERY_SPAN) - base
	var skill := (float(st["skill"][me]) - float(st["skill"][1 - me])) / BjjMatch.SKILL_SPAN
	var strength := 0.0
	if BjjMatch.STRENGTH_KINDS.has(kind):
		strength = (float(st["strength"][me]) - float(st["strength"][1 - me])) / BjjMatch.STRENGTH_SPAN
	var pre := base + technique + skill + strength
	var gas := pre * (lerpf(0.6, 1.0, clampf(float(st["gas"][me]), 0.0, 1.0)) - 1.0)
	return [{"key": "base", "pts": base * 100.0}, {"key": "technique", "pts": technique * 100.0}, {"key": "skill", "pts": skill * 100.0},
		{"key": "strength", "pts": strength * 100.0}, {"key": "gas", "pts": gas * 100.0}]


## The reason in plain words: what helped most on a hit, what hurt most on a miss. `names` = [first, first].
static func reason(fs: Array, me: int, hit: bool, names: Array) -> String:
	var best: Dictionary = {}
	for x in fs:
		if str(x["key"]) == "base":
			continue
		var v := float(x["pts"]) * (1.0 if hit else -1.0)
		if v >= 1.0 and (best.is_empty() or v > float(best["v"])):
			best = {"key": str(x["key"]), "v": v, "pts": float(x["pts"])}
	var a := str(names[me])
	var d := str(names[1 - me])
	if best.is_empty():
		return "Nothing between them: it came down to the moment."
	var n := roundi(absf(float(best["pts"])))
	match str(best["key"]):
		"technique":
			return ("%s has drilled this: +%d%%" % [a, n]) if float(best["pts"]) > 0.0 else ("%s is raw at this move: -%d%%" % [a, n])
		"skill":
			return ("%s is the better grappler: +%d%%" % [a, n]) if float(best["pts"]) > 0.0 else ("%s is the better grappler: -%d%%" % [d, n])
		"strength":
			return ("%s is stronger: +%d%%" % [a, n]) if float(best["pts"]) > 0.0 else ("%s is stronger: -%d%%" % [d, n])
		_:
			return "%s is tiring: -%d%%" % [a, n]


## What the player reads: a submission or a drilled move by name, anything else by what it does. GrappleMap's step names
## ("Bottom Rolls Onto Side And Snatches Foot", "Tap") are data, not words for the screen.
static func title(o: Dictionary, syllabus_name: String = "") -> String:
	if str(o["kind"]) == "sub":
		return str(o["title"])
	if syllabus_name != "":
		return syllabus_name
	var word := str((ATTACK.get(str(o["kind"]), ATTACK["advance"]) as Array)[0])
	# S425: "Move up" three rows running said nothing: a move up or an escape says where it goes.
	var to := str(WHERE.get(str(o.get("to", "")), ""))
	if to != "" and str(o["kind"]) in ["advance", "escape"]:
		return "%s to %s" % [word, to]
	return word


## S425: a position's class in the words on screen.
const WHERE := {"guard": "guard", "half_guard": "half guard", "side_control": "side control", "mount": "the mount", "back": "the back",
	"standing": "the feet", "turtle": "turtle"}


## Everything the clash shows for one attempt.
static func read(st: Dictionary, me: int, o: Dictionary, hit: bool, names: Array) -> Dictionary:
	var kind := str(o["kind"])
	var p := float(o["odds"])
	var word := "LANDS" if hit else "STOPPED"
	if hit and kind == "sub":
		word = "LOCKED IN"
	elif hit and int(o["pts"]) > 0:
		word = "+%d" % int(o["pts"])
	var chance := "%d%% chance" % roundi(p * 100.0)
	if hit and p < LONG_SHOT:
		chance = "Long shot, %d%% chance" % roundi(p * 100.0)
	elif not hit and p > FAVOURED:
		chance = "Should have landed, %d%% chance" % roundi(p * 100.0)
	return {"attack": ATTACK.get(kind, ATTACK["advance"]), "defence": DEFENCE.get(kind, DEFENCE["advance"]), "word": word, "chance": chance,
		"reason": reason(factors(st, me, o), me, hit, names), "big": BIG_KINDS.has(kind), "sub": kind == "sub"}
