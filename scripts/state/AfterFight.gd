extends RefCounted
## S430 the snapshots behind the result page's "what the fight did" tiles (rules/Aftermath.gd, operator: "after each fight
## it should show a summary of the damage on the fighter what he learned, morale effected etc"). BoutNight._finish takes
## one before it books the result and builds the tiles after everything is booked (the record, morale, the corner's
## calls, the goal, the rank, injuries), so the page shows what really changed and never a forecast.
##   snap(c, f, opp) -> {morale, mood, rank, cap, notes, rows, hidden}     tiles(c, f, m, before, bank) -> Array

const Aftermath := preload("res://scripts/rules/Aftermath.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BoutMarks := preload("res://scripts/fight3d/BoutMarks.gd")
const CoachNotes := preload("res://scripts/rules/CoachNotes.gd")
const CornerTrust := preload("res://scripts/rules/CornerTrust.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const Region := preload("res://scripts/state/Region.gd")


static func snap(c: Career, f: Dictionary, opp: Dictionary) -> Dictionary:
	var morale := float(f.get("morale", FighterProfile.MORALE_START))
	return {"morale": morale, "mood": FighterProfile.mood(morale), "rank": Region.our_rank(c, f),
		"cap": float(f.get("durability_cap", Attrs.HI)), "notes": (f.get("notes_seen", []) as Array).duplicate(),
		"fatigue": FighterProfile.fatigue(f),
		"rows": rows(c, f), "hidden": OppFile.hidden(opp).size()}


## Books what the fight leaves in the legs (Aftermath.toll) and writes the tiles on the result modal.
static func book(c: Career, f: Dictionary, m: Dictionary, before: Dictionary, bank: Dictionary) -> void:
	var rounds: Array = m.get("rounds", [])
	var tank := float(((rounds[-1] as Dictionary).get("energy", {}) as Dictionary).get("a_end", 100.0)) if not rounds.is_empty() else 100.0
	var stopped_loss := str(m.get("stopped", "")) != "" and str(m.get("outcome", "")) == "loss"
	f["week_fatigue"] = Aftermath.toll(FighterProfile.fatigue(f), tank, stopped_loss)
	if not BoutMarks.seen_all(m):   # S439: a skipped or unwatched bout still leaves its marks (the settled rounds)
		m["body_map"] = BoutMarks.build(c, f, m)
	if not m.has("bodies"):   # no ring drew them: the same pick the ring makes (FightCast.bodies_for)
		var pick := Faces.pair(f, (f["bout"] as Dictionary).get("opp", {}))
		m["bodies"] = [Faces.glb(pick[0]), Faces.glb(pick[1])]
	m["rank_words"] = "" if bool(m.get("pro", false)) else rank_words(c, f, before)
	m["aftermath"] = tiles(c, f, m, before, bank)


static func tiles(c: Career, f: Dictionary, m: Dictionary, before: Dictionary, bank: Dictionary) -> Array:
	var opp: Dictionary = (f["bout"] as Dictionary).get("opp", {})
	var after := snap(c, f, opp)
	var st := FightStats.of(m.get("rounds", []))
	var pro := bool(m.get("pro", false))
	var facts := {"first": str(f["first"]), "opp": str(opp.get("first", opp.get("name", "the opponent"))),
		"outcome": str(m.get("outcome", "")), "stopped": str(m.get("stopped", "")), "took": int(st["landed"][1]),
		"took_body": int(st["body"][1]), "counts": int((m.get("counts", {}) as Dictionary).get("a", 0)),
		"worst": _worst(m.get("body_map", {})), "places": _places(m.get("body_map", {})),
		"cuts": ((m.get("body_map", {}) as Dictionary).get("a", {}) as Dictionary).get("cuts", {}).keys(), "injury": str(m.get("injury", "")),
		"calls": CornerTrust.settle(f, str(opp.get("name", ""))), "learned": _learned(f, before, opp, bank)}
	var hist: Array = f.get("history", [])
	if not hist.is_empty() and (hist[-1] as Dictionary).has("met") and int((hist[-1] as Dictionary).get("d", -1)) == c.day:
		facts["goal"] = "met" if bool(hist[-1]["met"]) else "missed"
		facts["goal_title"] = str(hist[-1].get("title", ""))
	if not pro:
		facts["rank_words"] = rank_words(c, f, before)
	var out := Aftermath.tiles(before, after, facts)
	if pro:   # a pro is off the amateur table: her ladder line is on the page already
		out = out.filter(func(t): return str(t["id"]) != "rank")
	return out


## The rank line for the Why panel. A pro is off the amateur table, so the words are empty.
static func rank_words(c: Career, f: Dictionary, before: Dictionary) -> String:
	if bool(f.get("pro", false)):
		return ""
	var before_rows: Array = before.get("rows", [])
	var got: Dictionary = RankLine.after(before_rows, rows(c, f), str(f["name"]), Region.RANK_MIN_WINS)
	return str(got["words"])


## The division's table rows with the fighter in them whatever the wins (RankLine sorts and cuts it).
static func rows(c: Career, f: Dictionary) -> Array:
	var out: Array = []
	for r in c.rivals:
		if str(r["div"]) == str(f["div"]):
			out.append({"name": r["name"], "w": int(r["w"]), "l": int(r["l"]), "rating": float(r["rating"])})
	out.append({"name": f["name"], "w": int(f["w"]), "l": int(f["l"]), "rating": 0.0})
	return out


static func _rows(c: Career, f: Dictionary) -> Array:
	return rows(c, f)


## {place, value} of her lowest place on the body map ({} when the bout drew no map).
static func _worst(map: Dictionary) -> Dictionary:
	if map.is_empty() or not map.has("a"):
		return {}
	var best := ""
	var bv := 101.0
	for p in BodyMap.PLACES:
		var v := BodyMap.value(map, "a", p)
		if v < bv:
			bv = v
			best = p
	return {"place": best, "value": bv}


## {place: value} of her six places at the final bell ({} when the bout drew no map).
static func _places(map: Dictionary) -> Dictionary:
	var out := {}
	if map.is_empty() or not map.has("a"):
		return out
	for p in BodyMap.PLACES:
		out[p] = BodyMap.value(map, "a", p)
	return out


## What the fight taught the corner: the coach's new notes, habits seen paying, the opponent's file now complete.
static func _learned(f: Dictionary, before: Dictionary, opp: Dictionary, bank: Dictionary) -> Array:
	var out: Array = []
	var was: Array = before.get("notes", [])
	var lines := {}
	for row in CoachNotes.card(f, bank):
		lines[str(row["id"])] = str(row["line"])
	for id in f.get("notes_seen", []):
		if was.has(id) or not lines.has(str(id)):
			continue
		out.append(("A habit seen: %s" if str(id).begins_with("habit:") else "Coach's note: %s") % lines[str(id)])
	if int(before.get("hidden", 0)) > 0:
		out.append("The whole file on %s is open now: a rematch starts with everything known." % str(opp.get("first", opp.get("name", "the opponent"))))
	return out
