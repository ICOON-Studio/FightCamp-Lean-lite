extends RefCounted
## ROSTERROW1: one fighter's row on the Fighters page - values and words, no nodes.
## Reads the same functions the fighter page and Home already call.
## Missing today: Coach's weekly gain (CoachCheck does not compute it).
## S440 (Claude at collect, PAGES2B review): coach words + tag from COACH_DO (never the goal colour), the goal read always
## attached, an offer's days are to the bout (answer-by its own value), no OPEN tag without an entered open.
## S440 round 2 (Claude, fixer): the goal check is worded from the goal's own target that holds it back (Answer the offer /
## Find a bout / Drill stamina), never "Drill the goal"; the no-gi athlete's coach line is the move her classes drill
## (NoGi.drilling) with the way to her next belt as the ring (BeltRoad.readiness); with no open entered, NEXT FIGHT names the
## next open she can enter (NoGi.opens_after); a need belongs to a fighter by its arg (her id or her offer), else by her first
## name as a whole word.
## S440 round 3 (Claude's rulings): "No bout" says when the next offers come (NextOffer.day, the game's own offer clock);
## DO NEXT is never empty - a need first, else the no-gi athlete's open to enter, a boxer with nothing booked or offered
## plans the week, else Coach's change (Drill / Rest / Fix) on the week planner; the no-gi weight cell names her class.
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
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Data := preload("res://scripts/state/Data.gd")
const NextOffer := preload("res://scripts/rules/NextOffer.gd")

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
		var nm: String = NoGi.move_name(best_move) if is_g else best_move
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
	if is_g:   # no weight is kept for her in today's rules: the cell names her class, no kg, no bar
		return {"value": 0.0, "limit": 0.0, "over": 0.0, "word": str(f.get("wc", "")).replace(" (no-gi)", ""), "tone": "muted"}
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

## S440 (Claude at collect, PAGES2B review): Coach's one change in action words, per CoachCheck key: [words, tag].
const COACH_DO := {"fit": ["Rest this week", "REST"], "weight": ["Cut weight", "FIX"], "mood": ["Lift the mood", "FIX"],
	"fight": ["Find a bout", "FIX"], "camp": ["Set the camp", "DRILL"],
	"file": ["Scout the opponent", "DRILL"], "plan": ["Write a game plan", "DRILL"]}
## The DO NEXT pin's words for a need's act (the Home button word stays in "label").
const PIN_DO := {"openBout": "Answer offer", "goaltalk": "Set a goal", "weighin": "Weigh in", "camp": "Set camp",
	"injurychoice": "Decide on the bout", "prooffer": "Hear the offer", "opennight": "Go to the mats", "trial": "Watch the trial",
	"interview": "Meet the walk-in"}

## Coach's change for one CoachCheck row: [words, tag, act, arg].
static func coach_do(c: Career, f: Dictionary, ch: Dictionary) -> Array:
	var key: String = str(ch["key"])
	var act: String = str(ch.get("act", ""))
	var arg: String = str(ch.get("arg", ""))
	if key == "goal":
		return _goal_do(c, f, act, arg)
	if key == "fight" and act == "openBout":
		return ["Answer the offer", "FIX", act, arg]
	var said: Array = COACH_DO.get(key, [str(ch["label"]), "FIX"])
	return [str(said[0]), str(said[1]), act, arg]


## The goal check in the goal's own words: the target that holds the goal back (not met and not on track), else the first
## target not met. A bout target: answer the open offer, or find a bout; a stat target: drill that stat.
static func _goal_do(c: Career, f: Dictionary, act: String, arg: String) -> Array:
	var g: Dictionary = Sim.goal_read(c, f)
	if g.is_empty():
		return ["Set a goal", "FIX", act, arg]
	if str(g["code"]) == "MISSED":
		return ["Set a new goal", "FIX", act, arg]
	var pick: Dictionary = {}
	for t in g["targets"]:
		if bool(t.get("met", false)):
			continue
		if pick.is_empty() or (str(pick["status"]) == "ON_TRACK" and str(t["status"]) != "ON_TRACK"):
			pick = t
	if pick.is_empty():
		return ["Pick the next goal", "FIX", act, arg]
	var key: String = str(pick["key"])
	if key == "booked_fight":
		var o: Dictionary = _open_offer(f)
		if not o.is_empty():
			return ["Answer the offer", "FIX", "openBout", str(o["id"])]
		return ["Find a bout", "FIX", "go", "fights:0"]
	return ["Drill %s" % str(Data.LABEL.get(key, key.capitalize())).to_lower(), "DRILL", act, arg]


static func _open_offer(f: Dictionary) -> Dictionary:
	for o in f.get("offers", []):
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return o
	return {}

static func _coach_col(c: Career, f: Dictionary) -> Dictionary:
	if f.get("sport", "") == "bjj":
		return _mat_coach(c, f)
	var checks: Array = CoachCheck.rows(c, f)
	var urgent: Dictionary = {}
	for ch in checks:
		var st: String = str(ch["state"])
		if st == "bad":
			urgent = ch
			break
		if st == "warn" and urgent.is_empty():
			urgent = ch
	# The goal ring always reads the fighter page's own goal read (empty when no goal is set).
	var g: Dictionary = Sim.goal_read(c, f)
	if urgent.is_empty():
		return {"word": "No change this week", "tag": "", "tone": "good", "why": "every check Coach runs is green", "goal": g}
	var said: Array = coach_do(c, f, urgent)
	return {"word": str(said[0]), "tag": str(said[1]), "tone": "bad" if str(urgent["state"]) == "bad" else "watch",
		"why": "%s: %s" % [str(urgent["label"]), str(urgent["word"])], "act": str(said[2]), "arg": str(said[3]), "goal": g}


## The no-gi athlete: the move this week's classes drill (NoGi.drilling, as her page shows it) and, as the ring, the way to
## her next belt (BeltRoad.readiness: the stripes are its quarters).
static func _mat_coach(c: Career, f: Dictionary) -> Dictionary:
	var nxt: String = BeltRoad.next_belt(str(f.get("belt", "white")))
	if nxt == "":
		return {"word": "Top belt", "tag": "", "tone": "good", "why": "", "sub": "", "goal": {}}
	var bjj: Dictionary = f.get("bjj", {})
	var m: String = NoGi.drilling(f, c.day)
	var r: Dictionary = BeltRoad.readiness(f, bjj, c.day)
	var cls_left: int = maxi(0, int(r["mat"][1]) - int(r["mat"][0]))
	var mv_left: int = maxi(0, int(r["moves"][1]) - int(r["moves"][0]))
	# The ring's share is the lower of mat time and moves owned: the line names that one (the other sits in the hover).
	var cls_share: float = float(r["mat"][0]) / maxf(1.0, float(r["mat"][1]))
	var mv_share: float = float(r["moves"][0]) / maxf(1.0, float(r["moves"][1]))
	var cls_w: String = "%d class%s" % [cls_left, "" if cls_left == 1 else "es"]
	var mv_w: String = "%d move%s to own" % [mv_left, "" if mv_left == 1 else "s"]
	var left: String = ""
	if mv_left > 0 and (mv_share <= cls_share or cls_left == 0):
		left = mv_w
	elif cls_left > 0:
		left = "%s left" % cls_w
	elif int(r["days_left"]) > 0:
		left = "%d days left" % int(r["days_left"])
	var road_why: String = "%s belt: %s left, %s." % [nxt.capitalize(), cls_w, mv_w]
	var due: int = NoGi.stripes_due(f, c.day)
	var ready: bool = bool(r["ready"])
	var given: int = int(f.get("stripes", 0))
	var goal: Dictionary = {"title": "%s belt" % nxt.capitalize(), "share": float(r["share"]), "left_word": left,
		"status": "Stripe due" if due > 0 else ("Ready to promote" if ready else "%d of %d stripes" % [given, BeltRoad.STRIPES]),
		"cls": "green" if due > 0 or ready else "muted"}
	if m == "":
		return {"word": "Classes for the %s belt" % nxt, "tag": "DRILL", "tone": "ok", "sub": "every move owned",
			"why": "Every %s belt move is owned: mat time is what is left. %s" % [str(f.get("belt", "white")), road_why], "goal": goal}
	var mv_name: String = NoGi.move_name(m)
	return {"word": "Drill the %s" % mv_name.to_lower(), "tag": "DRILL", "tone": "ok", "goal": goal,
		"sub": "%s %d, owned at %d" % [mv_name, int(floor(float(bjj.get(m, 0.0)))), int(BeltRoad.OWNED_AT)],
		"why": "This week's classes drill the %s until it is owned. %s" % [mv_name.to_lower(), road_why]}

static func _next_fight_col(c: Career, f: Dictionary, is_g: bool) -> Dictionary:
	var bout: Dictionary = f.get("bout", {})
	if bout.has("day"):
		var opp: Dictionary = bout.get("opp", {})
		return {"days": int(bout["day"]) - c.day, "tag": "BOOKED", "opp_name": str(opp.get("name", "")),
			"opp_record": "%d-%d" % [int(opp.get("w", 0)), int(opp.get("l", 0))], "date": Clock.fmt(int(bout["day"])), "tone": "ok"}
	var o: Dictionary = _open_offer(f)
	if not o.is_empty():
		# S440: the big number is the days to the bout; the answer-by day is its own line.
		return {"days": int(o["day"]) - c.day, "tag": "OFFER", "opp_name": str(o["opp"]["name"]),
			"opp_record": "%d-%d" % [int(o["opp"].get("w", 0)), int(o["opp"].get("l", 0))], "date": Clock.fmt(int(o["day"])),
			"answer_by": Clock.fmt(int(o["expires"])), "answer_days": int(o["expires"]) - c.day, "tone": "watch"}
	if is_g:
		var entered: Array = (f.get("entered", []) as Array).duplicate()
		entered.sort()
		for d in entered:
			if int(d) >= c.day:
				var op: Dictionary = NoGi.open_on(int(d))
				return {"days": int(d) - c.day, "tag": "OPEN", "opp_name": str(op.get("name", "")), "opp_record": "",
					"date": Clock.fmt(int(d)), "tone": "ok"}
		# Nothing entered: the next open she can still enter (from tomorrow, as her page's NEXT OPENS lists them), no tag.
		var nx: Dictionary = NoGi.opens_after(c.day + 1, 1)[0]
		return {"days": int(nx["d"]) - c.day, "tag": "", "opp_name": str(nx["name"]), "opp_record": "",
			"date": Clock.fmt(int(nx["d"])), "word": "No open entered", "tone": "watch"}
	var nd: int = NextOffer.day(c, f)
	return {"days": -1, "tag": "", "word": "No bout", "tone": "watch", "next_day": nd,
		"next_word": "next offers %s" % Clock.fmt(nd) if nd >= 0 else ""}

static func _do_next_col(c: Career, f: Dictionary) -> Dictionary:
	for n in Needs.needs(c):
		if _need_for(c, f, n):
			var arg: String = str(n.get("arg", ""))
			var red: bool = bool(n.get("red", false))
			var act: String = str(n.get("act", ""))
			return {"label": str(n.get("label", n["t"])), "words": str(PIN_DO.get(act, n.get("label", n["t"]))), "act": act,
				"arg": arg, "tip": "%s: %s" % [str(n["t"]), str(n.get("s", ""))], "urgent": red, "tone": "bad" if red else "watch"}
	return _do_fallback(c, f)


## DO NEXT with no need on her: one thing the game allows right now. "planweek" = the week planner on her (the UI opens it).
static func _do_fallback(c: Career, f: Dictionary) -> Dictionary:
	var id: String = str(f["id"])
	if f.get("sport", "") == "bjj":
		var ahead: bool = false
		for d in f.get("entered", []):
			ahead = ahead or int(d) >= c.day
		if not ahead:
			var nx: Dictionary = NoGi.opens_after(c.day + 1, 1)[0]
			return _pin("Enter the open", "go", "fights:0", "%s on %s, entry $%d: enter on the Fights page." % [str(nx["name"]),
				Clock.fmt(int(nx["d"])), int(nx.get("fee", 0))])
		var mc: Dictionary = _mat_coach(c, f)
		return _pin(str(mc.get("tag", "DRILL")).capitalize(), "fighter", id, "Coach: %s. What the classes drill is set on the athlete's page." % str(mc["word"]))
	if (f.get("bout", {}) as Dictionary).is_empty() and _open_offer(f).is_empty():
		return _pin("Plan the week", "planweek", id, "Nothing booked or offered yet: set the week's training while the offers come.")
	for ch in CoachCheck.rows(c, f):
		if str(ch["state"]) == "bad":
			var said: Array = coach_do(c, f, ch)
			if str(said[2]) != "":
				return {"label": str(ch["label"]), "words": str(said[0]), "act": str(said[2]), "arg": str(said[3]),
					"tip": "%s: %s" % [str(ch["label"]), str(ch["word"])], "urgent": false, "tone": "watch"}
	var co: Dictionary = _coach_col(c, f)
	if str(co.get("tag", "")) != "":
		return _pin(str(co["tag"]).capitalize(), "planweek", id, "Coach: %s. Opens the week planner." % str(co["word"]))
	return _pin("Plan the week", "planweek", id, "Coach has no change this week: the week planner.")


static func _pin(words: String, act: String, arg: String, tip: String) -> Dictionary:
	return {"label": words, "words": words, "act": act, "arg": arg, "tip": tip, "urgent": false, "tone": "watch"}

static func _needs_you(c: Career, f: Dictionary) -> bool:
	if f.get("sport", "") != "bjj":
		for ch in CoachCheck.rows(c, f):
			if str(ch["state"]) == "bad":
				return true
	for n in Needs.needs(c):
		if bool(n.get("red", false)) and _need_for(c, f, n):
			return true
	return false


## Whose need it is: its arg names a fighter (her id, or the id of one of her offers); else her first name stands in its
## words as a whole word (a pro-offer or nationals line, whose arg is a page). Never part of another name, never "".
static func _need_for(c: Career, f: Dictionary, n: Dictionary) -> bool:
	var arg: String = str(n.get("arg", ""))
	if arg != "":
		var owner: String = _arg_owner(c, arg)
		if owner != "":
			return owner == str(f["id"])
	return _has_word(str(n.get("t", "")), str(f.get("first", "")))


static func _arg_owner(c: Career, arg: String) -> String:
	for list in [c.fighters, c.grapplers]:
		for x in list:
			if str(x["id"]) == arg:
				return arg
			for o in x.get("offers", []):
				if str(o["id"]) == arg:
					return str(x["id"])
	return ""


static func _has_word(text: String, word: String) -> bool:
	if word == "":
		return false
	var at: int = text.find(word)
	while at >= 0:
		var end: int = at + word.length()
		if (at == 0 or not _letter(text[at - 1])) and (end >= text.length() or not _letter(text[end])):
			return true
		at = text.find(word, at + 1)
	return false


static func _letter(ch: String) -> bool:
	return ch.to_upper() != ch.to_lower()
