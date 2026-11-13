## S451 FIGHTWEEKPROBE3 (AMATEURWEEK1 v5, Kalli SQ60 point 1): the fight week's load stop played over a season through the
## career harness (`week=rest|tick|through|coach`). A MEASUREMENT model, never game code: the stops are v5's, applied around
## the game's own fight week.
##   snap(f, day)  - at the first harness stop 8 days or fewer before the bell: stats and move mastery as they stand.
##   apply(f, c, policy) -> stop - on fight day, before the bout:
##       BANKED: the gains since the snapshot are scaled by the stop's share over the game's own fight week (the game's week
##       before a booked bout is its TAPER, light work = v5's Tick over, so Tick over keeps the game's gains: x1.0;
##       Rest up keeps 0.4 of them (a fifth of a full week against the taper's half), Train through 2.0 (a full week)).
##       TANK: the game's own tank off (BoutRules.tank_parts_for, as BoutNight._peak) plus the stop's own off (0 / 6 / 12).
##       ROUND 1: Rest up starts flat (bout["r1_flat"] = 2.0, LiveRound round 1).
##   after(f, stop) - Train through carries +6 tiredness into the next week (v5; v4 had +1).
## The coach's pick: tired (over 50) -> Rest up; an opponent with more wins than the boxer -> Tick over; else Train through.
## Limits (said in the result): the injury spike for a Train-through week is not modelled (the game's own weekly roll runs as
## usual); the banked share scales the days the harness saw (the snapshot can come 1-8 days out).

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")

const STOPS := {
	"rest": {"name": "Rest up", "bank": 0.4, "off": 0.0, "flat": 2.0, "carry": 0.0},
	"tick": {"name": "Tick over", "bank": 1.0, "off": 6.0, "flat": 0.0, "carry": 0.0},
	"through": {"name": "Train through", "bank": 2.0, "off": 12.0, "flat": 0.0, "carry": 6.0},
}


static func snap(f: Dictionary, day: int) -> void:
	f["fw_snap"] = {"day": day, "stats": (f["stats"] as Dictionary).duplicate(), "moves": (f.get("moves", {}) as Dictionary).duplicate()}


static func pick(f: Dictionary, policy: String) -> String:
	if STOPS.has(policy):
		return policy
	if FighterProfile.fatigue(f) > 50.0:
		return "rest"
	var opp: Dictionary = f["bout"].get("opp", {})
	return "tick" if int(opp.get("w", 0)) > int(f.get("w", 0)) else "through"


static func apply(f: Dictionary, c: Career, policy: String) -> String:
	var day := c.day
	var stop := pick(f, policy)
	var s: Dictionary = STOPS[stop]
	var sn: Dictionary = f.get("fw_snap", {})
	if not sn.is_empty():
		for k in ["stats", "moves"]:
			var now: Dictionary = f.get(k, {})
			var was: Dictionary = sn[k]
			for key in now:
				if was.has(key) and (now[key] is float or now[key] is int):
					var gain := float(now[key]) - float(was[key])
					if gain > 0.0:
						now[key] = float(was[key]) + gain * float(s["bank"])
	f.erase("fw_snap")
	var b: Dictionary = f["bout"]
	# the game's own tank first (BoutNight._peak's call), then the stop's; _peak keeps a present "stale"
	var base := float(BoutRules.tank_parts_for(c.results, f, float(f.get("week_fatigue", 20.0)), int(b.get("day", day)))["off"])
	b["stale"] = base + float(s["off"])
	b["r1_flat"] = float(s["flat"])
	return stop


static func after(f: Dictionary, stop: String) -> void:
	f["week_fatigue"] = clampf(float(f.get("week_fatigue", 20.0)) + float(STOPS[stop]["carry"]), 0.0, 100.0)
