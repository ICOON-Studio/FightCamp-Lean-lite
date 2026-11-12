extends RefCounted
## ROSTERROW1: one fighter's row on the Fighters page - values and words, no nodes.
## Reads the same functions the fighter page and Home already call.
## Missing today: Coach's weekly gain (CoachCheck does not compute it).
## S438 (Claude at collect): the five groups are the painted ones (CORE_LOOP_MAP_S432 section 3) read from Attrs,
## the ring is the measured level (Attrs.weighted), best_of marks the roster's best per group, stance and style shown.

const Attrs := preload("res://scripts/rules/Attrs.gd")
## The painted groups. Heart and the four traits are not trained and not part of a measured level: left out of the bars.
const GROUPS := {"Head": ["fight_iq", "composure"], "Hands": ["accuracy", "timing", "inside", "strength", "explosiveness"],
	"Guard": ["defence", "durability"], "Cardio": ["stamina", "recovery"], "Legs": ["speed", "footwork", "flexibility"]}

const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const NextStep := preload("res://scripts/rules/NextStep.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const FIGHTER_PAGE := preload("res://scripts/ui/areas/FighterPage.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Clock := preload("res://scripts/state/Clock.gd")

static func row(c: Career, fighter_id: String) -> Dictionary:
	var f: Dictionary = _find(c, fighter_id)
	if f.is_empty():
		return {}
	var g: bool = f.get("sport", "") == "bjj"
	return {"fighter": _fighter_col(c, f, g), "overall": _overall_col(f, g), "tiredness": _tiredness_col(f),
		"weight": _weight_col(c, f, g), "mood": _mood_col(f), "coach": _coach_col(c, f),
		"next_fight": _next_fight_col(c, f, g), "do_next": _do_next_col(c, f), "needs_you": _needs_you(c, f)}

## group -> the id of the boxer who is best of the roster in it (the gold dot). Empty with fewer than two boxers.
static func best_of(c: Career) -> Dictionary:
	var out: Dictionary = {}
	if c.fighters.size() < 2:
		return out
	for g in GROUPS:
		var best := -1.0
		for f in c.fighters:
			var v: float = _avg(Attrs.of(f), GROUPS[g])
			if v > best:
				best = v
				out[g] = str(f["id"])
	return out

static func _find(c: Career, id: String) -> Dictionary:
	for f in c.fighters:
		if str(f["id"]) == id:
			return f
	for g in c.grapplers:
		if str(g["id"]) == id:
			return g
	return {}

static func _fighter_col(c: Career, f: Dictionary, is_g: bool) -> Dictionary:
	var w: int = int(f.get("w", 0))
	var l: int = int(f.get("l", 0))
	var pro: bool = bool(f.get("pro", false))
	var road: Dictionary = NextStep.road(FIGHTER_PAGE._road_input(c, f), c.day)
	var lit: int = int(road["lit"])
	var road_w: String = "%s belt" % str(f.get("belt", "white")).capitalize() if is_g else ("Pro" if lit < 0 else str(road["steps"][lit]["name"]))
	return {"name": str(f["name"]), "first": str(f.get("first", f["name"])), "age": int(f.get("age", 0)),
		"wc": str(f.get("wc", "")), "sport": str(f.get("sport", "boxing")), "face": Faces.stem(f),
		"stance": str(f.get("stance", "")), "style": str(f.get("style", "")),
		"record": {"w": w, "l": l, "pro": pro}, "record_word": "%d-%d%s" % [w, l, " pro" if pro else ""],
		"road_word": road_w, "road_lit": lit, "tone": "ok"}

static func _overall_col(f: Dictionary, is_g: bool) -> Dictionary:
	var groups: Dictionary = {}
	var best_move: String = ""
	var best_mastery: float = -1.0
	if is_g:
		var bjj: Dictionary = f.get("bjj", {})
		groups["Guard"] = _avg(bjj, ["shrimp_bridge", "frame_recover_guard", "seatbelt_escape", "posture_closed_guard"])
		groups["Pass"] = _avg(bjj, ["bullfighter_pass", "knee_cut_pass"])
		groups["Sweep"] = _avg(bjj, ["scissor_sweep", "hip_bump_sweep"])
		groups["Takedown"] = _avg(bjj, ["double_leg"])
		groups["Finish"] = _avg(bjj, ["armbar_guard", "kimura", "americana", "rear_naked_choke", "guillotine"])
		for k in bjj:
			if float(bjj[k]) > best_mastery:
				best_mastery = float(bjj[k])
				best_move = k
	else:
		var a: Dictionary = Attrs.of(f)
		for gk in GROUPS:
			groups[gk] = _avg(a, GROUPS[gk])
		var moves: Dictionary = f.get("moves", {})
		for k in moves:
			if float(moves[k]) > best_mastery:
				best_mastery = float(moves[k])
				best_move = k
	var best_group: String = ""
	var best_val: float = -1.0
	for k in groups:
		if float(groups[k]) > best_val:
			best_val = float(groups[k])
			best_group = k
	var total: float = 0.0
	for k in groups:
		total += float(groups[k])
	var ring: int = int(round(total / maxf(1.0, float(groups.size())))) if not groups.is_empty() else 0
	if not is_g:
		ring = int(round(Attrs.weighted(Attrs.of(f))))
	var out: Dictionary = {"groups": groups, "best_group": best_group, "ring": ring, "tone": "ok"}
	if best_move != "":
		var nm: String = best_move.replace("_", " ") if is_g else best_move
		out["best_move"] = {"name": nm, "mastery": best_mastery, "word": MoveMastery.word(best_mastery)}
	return out

static func _avg(d: Dictionary, keys: Array) -> float:
	var t: float = 0.0
	var n: int = 0
	for k in keys:
		if d.has(k):
			t += float(d[k])
			n += 1
	return t / maxf(1.0, float(n)) if n > 0 else 0.0

static func _tiredness_col(f: Dictionary) -> Dictionary:
	var v: float = FighterProfile.fatigue(f)
	var w: String = str(WB_KIT.fatigue_word(v, false)[0]).to_lower()
	var tone: String = {"fresh": "good", "ok": "ok", "tired": "watch"}.get(w, "bad")
	return {"value": v, "word": w.capitalize(), "tone": tone}

static func _weight_col(c: Career, f: Dictionary, is_g: bool) -> Dictionary:
	if is_g:
		return {"value": 0.0, "limit": 0.0, "over": 0.0, "word": "", "tone": "muted"}
	var wt: float = float(f["weight"])
	var lim: float = float(f["limit"])
	var over: float = wt - lim
	var bout: Dictionary = f.get("bout", {})
	var has_wi: bool = bout.has("day")
	var word: String
	var tone: String
	if has_wi:
		var wf: Dictionary = Sim.weigh_forecast(c, f, int(bout["day"]))
		if bool(wf["ok"]):
			word = "%.1f kg on the day" % float(wf["day"])
			tone = "good"
		else:
			word = "%.1f kg over" % float(wf["over"])
			tone = "bad"
	elif over <= 0.0:
		word = "On weight"
		tone = "good"
	else:
		word = "limit %.1f" % lim
		tone = "ok"
	return {"value": wt, "limit": lim, "over": over, "word": word, "tone": tone, "weigh_in": has_wi}

static func _mood_col(f: Dictionary) -> Dictionary:
	var m: float = float(f.get("morale", FighterProfile.MORALE_START))
	var w: String = FighterProfile.mood(m)
	return {"value": m, "word": w, "tone": {"Fired up": "good", "Steady": "ok", "Flat": "watch", "Low": "bad"}.get(w, "ok")}

static func _coach_col(c: Career, f: Dictionary) -> Dictionary:
	if f.get("sport", "") == "bjj":
		var nxt: String = BeltRoad.next_belt(str(f.get("belt", "white")))
		return {"word": "Top belt" if nxt == "" else "%s belt" % nxt.capitalize(), "tag": "" if nxt == "" else "DRILL",
			"tone": "good" if nxt == "" else "ok"}
	var checks: Array = CoachCheck.rows(c, f)
	var urgent: Dictionary = {}
	for ch in checks:
		var st: String = str(ch["state"])
		if st == "bad":
			urgent = ch
			break
		if st == "warn" and urgent.is_empty():
			urgent = ch
	if urgent.is_empty():
		var g: Dictionary = Sim.goal_read(c, f)
		if g.is_empty():
			return {"word": "No goal set", "tag": "", "tone": "muted"}
		return {"word": "%s, %d days" % [str(g["status"]).to_lower(), int(g["left"])],
			"tag": str(g["cls"]).to_upper(), "tone": {"green": "good", "amber": "watch"}.get(str(g["cls"]), "bad"), "goal": g}
	var tag: String = {"fit": "REST", "goal": "DRILL", "camp": "DRILL"}.get(str(urgent["key"]), "FIX")
	return {"word": str(urgent["word"]), "tag": tag, "tone": "bad" if str(urgent["state"]) == "bad" else "watch",
		"act": str(urgent.get("act", "")), "arg": str(urgent.get("arg", ""))}

static func _next_fight_col(c: Career, f: Dictionary, is_g: bool) -> Dictionary:
	var bout: Dictionary = f.get("bout", {})
	if bout.has("day"):
		var opp: Dictionary = bout.get("opp", {})
		return {"days": int(bout["day"]) - c.day, "tag": "BOOKED", "opp_name": str(opp.get("name", "")),
			"opp_record": "%d-%d" % [int(opp.get("w", 0)), int(opp.get("l", 0))], "date": Clock.fmt(int(bout["day"])), "tone": "ok"}
	for o in f.get("offers", []):
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return {"days": int(o["expires"]) - c.day, "tag": "OFFER", "opp_name": str(o["opp"]["name"]),
				"opp_record": "%d-%d" % [int(o["opp"].get("w", 0)), int(o["opp"].get("l", 0))], "date": Clock.fmt(int(o["day"])), "tone": "watch"}
	return {"days": -1, "tag": "OPEN", "word": "No open entered" if is_g else "No bout", "tone": "watch"}

static func _do_next_col(c: Career, f: Dictionary) -> Dictionary:
	var fid: String = str(f["id"])
	for n in Needs.needs(c):
		var arg: String = str(n.get("arg", ""))
		if arg == fid or str(n["t"]).contains(f.get("first", "")):
			var red: bool = bool(n.get("red", false))
			return {"label": str(n.get("label", n["t"])), "act": str(n.get("act", "")), "arg": arg,
				"urgent": red, "tone": "bad" if red else "watch"}
	if f.get("sport", "") != "bjj":
		for ch in CoachCheck.rows(c, f):
			if str(ch["state"]) == "bad":
				return {"label": str(ch["label"]), "act": str(ch.get("act", "")), "arg": str(ch.get("arg", "")),
					"urgent": false, "tone": "watch"}
	return {}

static func _needs_you(c: Career, f: Dictionary) -> bool:
	if f.get("sport", "") != "bjj":
		for ch in CoachCheck.rows(c, f):
			if str(ch["state"]) == "bad":
				return true
	var fid: String = str(f["id"])
	for n in Needs.needs(c):
		if bool(n.get("red", false)):
			var arg: String = str(n.get("arg", ""))
			if arg == fid or str(n["t"]).contains(f.get("first", "")):
				return true
	return false
