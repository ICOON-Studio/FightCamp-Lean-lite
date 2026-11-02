## The gym's no-gi athletes on the calendar (S362, the belt road): the week on the mat each Sunday, the opens she entered
## on their Saturday, the professor's stripes and promotions. The rules are NoGi / BeltRoad; this moves the career.
##   Grapplers.day(career) -> an open ran (Clock stops)   Grapplers.enter / promote(career, id) -> "" or why not
##   Grapplers.stripe(career, id, call) -> StripeCall.apply's result (S363: now / hold / early)
##   Grapplers.week_report(career) -> the week review's rows, one per athlete (S363; Sim.end_week)

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const StripeCall := preload("res://scripts/rules/StripeCall.gd")


## Returns true when an open ran today (the clock stops on it).
static func day(c: Career) -> bool:
	var ran := false
	for f in c.grapplers:
		if posmod(c.day, 7) == 6:
			var before: Dictionary = (f.get("bjj", {}) as Dictionary).duplicate()
			var m := NoGi.week(f, c.day)
			f["mat_week"] = {"move": m, "before": float(before.get(m, 0.0)), "after": float((f["bjj"] as Dictionary).get(m, 0.0)) if m != "" else 0.0}
		var entered: Array = f.get("entered", [])
		if entered.has(c.day):
			entered.erase(c.day)
			_open(c, f, NoGi.open_on(c.day))
			ran = true
	return ran


static func _open(c: Career, f: Dictionary, o: Dictionary) -> void:
	if o.is_empty():
		return
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d|%s|%d" % [c.seed, f["id"], c.day])
	var res := NoGi.run_open(f, o, c.day, rng)
	f.erase("tough_next")
	var rows: Array = res["matches"]
	var mood := 0
	for i in rows.size():
		(f["opens"] as Array).push_front(rows[i])
		if bool(rows[i]["win"]):
			f["w"] = int(f["w"]) + 1
			mood += NoGi.WIN_MORALE
		else:
			f["l"] = int(f["l"]) + 1
			mood -= NoGi.TAP_MORALE if str(rows[i]["how"]).begins_with("submission") else NoGi.LOSS_MORALE
	f["morale"] = clampi(int(f.get("morale", NoGi.MORALE_START)) + mood, 0, 100)
	var medal := str(res["medal"])
	f["open_week"] = {"name": str(o["name"]), "medal": medal, "matches": rows.duplicate(true), "morale": mood}
	c.add_news("%s at the %s: %s (%d-%d)." % [f["first"], o["name"], ("%s medal" % medal) if medal != "" else "out in the first round",
		int(res["wins"]), rows.size() - int(res["wins"])])


static func enter(c: Career, id: String, d: int) -> String:
	var f := c.grappler_by_id(id)
	var o := NoGi.open_on(d)
	if f.is_empty() or o.is_empty() or d <= c.day:
		return "No open that day."
	var entered: Array = f.get_or_add("entered", [])
	if entered.has(d):
		return "Already entered."
	entered.append(d)
	c.pay(-int(o["fee"]), "Entry: %s (%s)" % [o["name"], f["first"]])
	return ""


## The professor's stripe call ("now", "hold" or "early"): StripeCall.apply plus its news line and member change.
static func stripe(c: Career, id: String, call: String = "now") -> Dictionary:
	var f := c.grappler_by_id(id)
	if f.is_empty():
		return {"ok": false, "why": "Nobody to grade.", "line": "", "news": "", "members": 0}
	var r := StripeCall.apply(f, call, c.day)
	if bool(r["ok"]):
		if str(r["news"]) != "":
			c.add_news(str(r["news"]))
		c.members = maxi(0, c.members + int(r["members"]))
	return r


## The week on the mat for the review, one row per athlete: {id, name, first, belt, stripes, classes, mat [have, need],
## move, before, after, owned (the drilled move became a weapon), open ({name, medal, matches, morale} or {}), due,
## morale, loyalty, held}. Clears the week's marks.
static func week_report(c: Career) -> Array:
	var out: Array = []
	for f in c.grapplers:
		var mw: Dictionary = f.get("mat_week", {})
		var r := BeltRoad.readiness(f, f.get("bjj", {}), c.day)
		var before := float(mw.get("before", 0.0))
		var after := float(mw.get("after", 0.0))
		out.append({"id": f["id"], "name": f["name"], "first": f["first"], "belt": f["belt"], "stripes": int(f.get("stripes", 0)),
			"classes": NoGi.CLASSES_PER_WEEK if not mw.is_empty() else 0, "mat": r["mat"], "next": BeltRoad.next_belt(str(f["belt"])),
			"move": str(mw.get("move", "")), "before": before, "after": after,
			"owned": before < BeltRoad.OWNED_AT and after >= BeltRoad.OWNED_AT, "open": f.get("open_week", {}),
			"due": NoGi.stripes_due(f, c.day), "morale": int(f.get("morale", NoGi.MORALE_START)),
			"loyalty": int(f.get("loyalty", NoGi.MORALE_START)), "held": int(f.get("held", 0))})
		f.erase("mat_week")
		f.erase("open_week")
	return out


static func promote(c: Career, id: String) -> String:
	var f := c.grappler_by_id(id)
	if f.is_empty():
		return "Nobody to promote."
	var r := BeltRoad.promote(f, f.get("bjj", {}), c.day)
	if not bool(r["ok"]):
		return str(r["why"])
	var nf: Dictionary = r["fighter"]
	for k in nf:
		f[k] = nf[k]
	f["stripes"] = 0
	f.erase("held")
	(f.get_or_add("belt_log", []) as Array).append({"d": c.day, "t": "%s belt" % str(f["belt"]).capitalize(),
		"note": "promoted early" if bool(r["early"]) else ""})
	c.add_news("%s is a %s belt." % [f["name"], f["belt"]])
	return ""
