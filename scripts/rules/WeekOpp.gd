extends RefCounted
## S360 the opponent's goal line (operator Q-S294-90 "Both"; Kalli KALLI_WHITEBOARD_S357.md: "make the coach's week slightly
## wrong on purpose, in a way only the player can know ... every week, one goal line starts amber because the generic week
## doesn't fit the opponent"). The coach writes the week from the camp's phase only (WeekPhase); the player knows the
## opponent. Each kind of opponent asks for its own mornings, and no phase week of the coach's has enough of them, so the line
## opens amber and one or two edits turn it green - "the coach plans the camp, you plan the fight".
## It counts in the fight: every camp week that ran with the line met is a week of preparation (bout["prep"], recorded on the
## week's Monday by Sim), and in the exchanges fought on the opponent's own game she is that much readier (edge()).
## The sessions (real boxing preparation): a presser - slip rope, the head off the centre line under pressure; a range
## boxer - intervals, the engine to walk down a jab for 3 rounds; a counter-puncher - shadow boxing, feints and timing to
## draw the lead; a big hitter who loads up - neck work, to take the one that lands.
##   line(opp, days, phase) -> {id: "opp", label, now, week, end, target, ok, short, session, game} ({} without a known game)
##   record(bout, days, phase)   edge(bout, sit) -> power points
## Pure static; preloads the opponent's file (her game) only.

const OppFile := preload("res://scripts/rules/OppFile.gd")

## game -> [session, mornings a week]. Fight week (taper) asks for one, light or not.
const NEED := {"press": ["slip_rope", 2], "range": ["intervals", 3], "counter": ["shadow", 2], "loadup": ["neck", 2]}
const TAPER_NEED := 1
const WORDS := {"slip_rope": "slip rope", "intervals": "intervals", "shadow": "shadow boxing", "neck": "neck work"}
## A whole camp of prepared weeks: power points in each exchange on her game (under a plan arrow's best 9, PlanFight.EDGE).
const EDGE := 3.0


static func line(opp: Dictionary, days: Array, phase: String) -> Dictionary:
	var game := OppFile.main_game(opp) if not opp.is_empty() else ""
	if not NEED.has(game):
		return {}
	var session := str(NEED[game][0])
	var need := TAPER_NEED if phase == "taper" else int(NEED[game][1])
	var n := 0
	for d in days:
		n += int(str((d as Array)[0]) == session)
	return {"id": "opp", "label": "vs %s" % str(opp.get("first", opp.get("name", "her"))), "now": float(n), "week": float(n),
		"end": float(n), "target": float(need), "ok": n >= need, "short": float(maxi(0, need - n)), "session": session, "game": game}


## The week that starts running: one more camp week, and one more prepared week when its line is met.
static func record(bout: Dictionary, days: Array, phase: String) -> void:
	var ln := line(bout.get("opp", {}), days, phase)
	if ln.is_empty():
		return
	var p: Dictionary = bout.get("prep", {"met": 0, "weeks": 0})
	p["weeks"] = int(p["weeks"]) + 1
	p["met"] = int(p["met"]) + int(bool(ln["ok"]))
	bout["prep"] = p


## The share of her camp weeks spent preparing for this opponent.
static func share(bout: Dictionary) -> float:
	var p: Dictionary = bout.get("prep", {})
	return 0.0 if int(p.get("weeks", 0)) == 0 else float(p["met"]) / float(p["weeks"])


## The preparation's edge in an exchange: only when the fight is on the opponent's own game.
static func edge(bout: Dictionary, sit: String) -> float:
	if sit == "" or sit != OppFile.main_game(bout.get("opp", {})):
		return 0.0
	return EDGE * share(bout)


## The coach's words for an amber line: what the week lacks.
static func say(ln: Dictionary) -> String:
	return "%s %s: put %d more %s morning%s in." % [str(ln["label"]).trim_prefix("vs "), str(OppFile.GAME_WORDS.get(str(ln["game"]), "")),
		int(ln["short"]), str(WORDS.get(str(ln["session"]), ln["session"])), "" if int(ln["short"]) == 1 else "s"]
