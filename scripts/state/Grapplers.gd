## The gym's no-gi athletes on the calendar (S362, the belt road): the week on the mat each Sunday, the opens she entered
## on their Saturday, the professor's stripes and promotions. The rules are NoGi / BeltRoad; this moves the career.
##   Grapplers.day(career) -> an open ran (Clock stops)   Grapplers.enter / stripe / promote(career, id) -> "" or why not

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")


## Returns true when an open ran today (the clock stops on it).
static func day(c: Career) -> bool:
	var ran := false
	for f in c.grapplers:
		if posmod(c.day, 7) == 6:
			NoGi.week(f)
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
	var rows: Array = res["matches"]
	for i in rows.size():
		(f["opens"] as Array).push_front(rows[i])
		if bool(rows[i]["win"]):
			f["w"] = int(f["w"]) + 1
		else:
			f["l"] = int(f["l"]) + 1
	var medal := str(res["medal"])
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


static func stripe(c: Career, id: String) -> String:
	var f := c.grappler_by_id(id)
	if f.is_empty() or NoGi.stripes_due(f, c.day) <= 0:
		return "No stripe due."
	f["stripes"] = int(f.get("stripes", 0)) + 1
	(f.get_or_add("belt_log", []) as Array).append({"d": c.day, "t": "Stripe %d" % int(f["stripes"]), "note": ""})
	return ""


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
	(f.get_or_add("belt_log", []) as Array).append({"d": c.day, "t": "%s belt" % str(f["belt"]).capitalize(),
		"note": "promoted early" if bool(r["early"]) else ""})
	c.add_news("%s is a %s belt." % [f["name"], f["belt"]])
	return ""
