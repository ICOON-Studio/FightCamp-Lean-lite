## The gym's no-gi athletes on the calendar (S362, the belt road): the week on the mat each Sunday, the opens she entered
## on their Saturday, the professor's stripes and promotions. The rules are NoGi / BeltRoad; this moves the career.
##   Grapplers.day(career) -> an open ran (Clock stops)   Grapplers.enter / promote(career, id) -> "" or why not
##   Grapplers.stripe(career, id, call) -> StripeCall.apply's result (S363: now / hold / early)
##   Grapplers.week_report(career) -> the week review's rows, one per athlete (S363; Sim.end_week)

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const StripeCall := preload("res://scripts/rules/StripeCall.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
## S384 GAMETREE1-A: the opens and the tree drilling run on Ana's game tree (BjjTree / BjjWalk / BjjOpen / BjjOpp).
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")


## Returns true when an open ran today (the clock stops on it).
static func day(c: Career) -> bool:
	var ran := false
	for f in c.grapplers:
		if posmod(c.day, 7) == 6:
			# S384 GAMETREE1: a tree:/route:/ahead: plan drills on the tree (before NoGi.week, whose drilling_for would fall
			# back silently); a finished one falls through to the coach's pick. The levels snapshot feeds the report's arrows.
			var lv := BjjTree.levels(f)
			var plan := str(f.get("drill", "coach"))
			if BjjTree.is_tree_plan(plan) and not BjjTree.drill_target(f, plan).is_empty():
				f["mat_week"] = BjjTree.week_mark(f, lv, BjjTree.week(f, c.day))
			else:
				var before: Dictionary = (f.get("bjj", {}) as Dictionary).duplicate()
				var m := NoGi.week(f, c.day)
				f["mat_week"] = {"move": m, "before": float(before.get(m, 0.0)), "after": float((f["bjj"] as Dictionary).get(m, 0.0)) if m != "" else 0.0}
				f["mat_week"]["levels_before"] = lv
			BjjOpen.roll_week(c, f)
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
	var res := BjjOpen.run_open(f, o, c.day, rng)
	BjjOpen.note_stats(f, res)
	f.erase("tough_next")
	(f.get("field", {}) as Dictionary).erase(c.day)
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
	f["open_week"] = {"name": str(o["name"]), "medal": medal, "matches": rows.duplicate(true), "morale": mood, "leak": res.get("leak", {})}
	c.add_news("%s at the %s: %s (%d-%d)." % [f["first"], o["name"], ("%s medal" % medal) if medal != "" else "out in the first round",
		int(res["wins"]), rows.size() - int(res["wins"])])
	var joined := BjjSide.medal(c.bjj_side, medal)
	f["open_week"]["joined"] = joined
	if joined > 0:
		c.add_news("%d joined the BJJ classes after %s's %s medal. %d on the mat." % [joined, f["first"], medal, int(c.bjj_side["members"])])


static func enter(c: Career, id: String, d: int) -> String:
	var f := c.grappler_by_id(id)
	var o := NoGi.open_on(d)
	if f.is_empty() or o.is_empty() or d <= c.day:
		return "No open that day."
	var entered: Array = f.get_or_add("entered", [])
	if entered.has(d):
		return "Already entered."
	entered.append(d)
	(f.get_or_add("field", {}) as Dictionary)[d] = BjjOpp.field(f, o, c.seed)   # S384 the bracket path, drawn at entry
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
		BjjSide.join(c.bjj_side, int(r["members"]))   # S365 the grading standard is the BJJ members' trust
	return r


## S365 Kalli part 4: from blue belt she may take the beginners' class (BjjSide: the hired coach's class saved, one of
## her own classes gone). Returns "" or why not.
static func teach(c: Career, id: String, on: bool) -> String:
	var f := c.grappler_by_id(id)
	if f.is_empty():
		return "Nobody to teach."
	var why := BjjSide.can_teach(f) if on else ""
	if why != "":
		return why
	f["teaches"] = on
	return ""


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
			"classes": NoGi.classes_of(f) if not mw.is_empty() else 0, "mat": r["mat"], "next": BeltRoad.next_belt(str(f["belt"])),
			"move": str(mw.get("move", "")), "before": before, "after": after,
			"owned": before < BeltRoad.OWNED_AT and after >= BeltRoad.OWNED_AT, "open": f.get("open_week", {}),
			"due": NoGi.stripes_due(f, c.day), "morale": int(f.get("morale", NoGi.MORALE_START)),
			"loyalty": int(f.get("loyalty", NoGi.MORALE_START)), "held": int(f.get("held", 0))})
		tree_report(out.back(), f, mw)
		f.erase("mat_week")
		f.erase("open_week")
		f.erase("roll_week")
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
	if f.has("partner"):   # S384 the gym partner is regenerated at the new belt, same seed (no news line)
		f["partner"] = BjjOpp.partner_at(int(f["partner"]["seed"]), str(f["belt"]))
	(f.get_or_add("belt_log", []) as Array).append({"d": c.day, "t": "%s belt" % str(f["belt"]).capitalize(),
		"note": "promoted early" if bool(r["early"]) else ""})
	c.add_news("%s is a %s belt." % [f["name"], f["belt"]])
	var joined := BjjSide.promoted(c.bjj_side, str(f["belt"]))
	if joined > 0:
		c.add_news("%d joined the BJJ classes to train with a %s belt. %d on the mat." % [joined, f["belt"], int(c.bjj_side["members"])])
	return ""


## S384 GAMETREE1: the tree's part of the week row - move_name, the arrows that turned felt / owned / signature (events,
## class-taught ones folded into class_line), the off-belt rate line, one path line per bout (+ its most decisive rule
## line), the open's leak and the gym roll.
static func tree_report(row: Dictionary, f: Dictionary, mw: Dictionary) -> void:
	var mv := str(row["move"])
	row["move_name"] = BjjTree.move_name(mv) if mv != "" else ""
	var events: Array = []
	var lb: Dictionary = mw.get("levels_before", {})
	if not lb.is_empty():
		var now := BjjTree.levels(f)
		for id in now:
			var a := float(lb.get(id, 0.0))
			var b := float(now[id])
			var ka := BjjTree.state(a)
			var kb := BjjTree.state(b)
			if ka != kb and b > a:
				events.append({"move": id, "name": BjjTree.move_name(id), "kind": kb, "before": a, "after": b,
					"src": "drill" if id == mv else "class", "belt": str(BjjTree.move(id).get("belt", ""))})
	var by_kind := {}
	for ev in events:
		if ev["src"] == "class":
			(by_kind.get_or_add(str(ev["kind"]), []) as Array).append(ev)
	var lines: Array = []
	for k in by_kind:
		if (by_kind[k] as Array).size() >= 3:
			lines.append("Class time: %d %s basics now %s." % [(by_kind[k] as Array).size(), str(by_kind[k][0]["belt"]), k])
			events = events.filter(func(ev): return not (ev["src"] == "class" and str(ev["kind"]) == k))
	row["events"] = events
	row["class_line"] = " ".join(lines)
	var n := int(mw.get("n", 0))
	row["off_belt_line"] = "" if n <= 0 or mv == "" else "%s %s - a %s-belt move, %s rate." % [row["move_name"],
		_gain_text(float(row["after"]) - float(row["before"])), str(BjjTree.move(mv).get("belt", "")), _rate_word(n)]
	var paths: Array = []
	var o: Dictionary = row.get("open", {})
	var ms: Array = o.get("matches", [])
	for i in ms.size():
		var lines_i: Array = (ms[i] as Dictionary).get("lines", [])
		paths.append({"line": BjjOpen.path_line(ms[i], i), "rule": str(lines_i[0]) if not lines_i.is_empty() else ""})
	row["paths"] = paths
	row["leak"] = o.get("leak", {})
	var rw: Dictionary = f.get("roll_week", {})
	row["roll"] = {} if rw.is_empty() else {"line": str(rw.get("line", "")), "how": str(rw.get("how", ""))}


static func _rate_word(n: int) -> String:
	if n == 1:
		return "half"
	return "quarter" if n == 2 else "1/%d" % int(pow(2, n))


static func _gain_text(d: float) -> String:
	return "%+.1f" % d
