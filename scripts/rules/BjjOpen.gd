extends RefCounted
## GAMETREE1 (S384) the opens and the gym roll on the tree (design 3.5, 5.1, 5.5):
## - run_open: NoGi.run_open's shape ({matches, wins, medal}) with every row now TRUE - each bout is BjjWalk.walk against
##   the bracket path drawn at entry (f["field"][day]), rows {d, open, win, opp, how} + {path, end, opp_id, style, lines};
##   plus "leak": the hole the field walked Ana into that cost the most, with its Drill.
## - roll_week: every ROLL_EVERY-th Sunday (not in an open week) a 5-minute walk against Marta, the club partner: white-belt
##   leg-lock rules, no morale, no records, no film; a move that turned felt since the last roll is tried once.
## Pure static; preloads BjjTree, BjjWalk, BjjOpp, NoGi, BeltRoad.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const ROLLS_KEPT := 6
const LINES_KEPT := 5


static func run_open(f: Dictionary, o: Dictionary, today: int, rng: RandomNumberGenerator) -> Dictionary:
	var belt := str(f.get("belt", "white"))
	var rules := BjjTree.rules_for(belt)
	var field: Array = (f.get("field", {}) as Dictionary).get(today, [])
	if field.size() < 3:
		field = BjjOpp.field(f, o, rng.randi())
	var rounds := int(round(log(float(NoGi.BRACKET)) / log(2.0)))
	var plan := BjjTree.plan_of(f, rules)
	var matches: Array = []
	var wins := 0
	var visits := {}
	for r in rounds:
		var opp: Dictionary = field[r]
		var w := BjjWalk.walk(f, opp, [plan, BjjTree.route(str(opp.get("route", ""))).get("steps", [])], int(rules["minutes"]), rules, rng)
		for k in w["visits"]:
			var v: Array = visits.get_or_add(k, [0, 0, 0])
			for i in 3:
				v[i] += int(w["visits"][k][i])
		matches.append({"d": today, "open": str(o["name"]), "win": bool(w["win"]), "opp": str(opp["name"]), "how": str(w["how"]),
			"path": w["path"], "end": str(w["end"]), "opp_id": str(opp.get("id", "")), "style": str(opp.get("style", "")),
			"lines": BjjWalk.rule_lines(w, LINES_KEPT)})
		if not bool(w["win"]):
			break
		wins += 1
	var medal := "gold" if wins == rounds else ("silver" if wins == rounds - 1 else ("bronze" if wins == rounds - 2 else ""))
	return {"matches": matches, "wins": wins, "medal": medal, "leak": leak_of(f, visits, rules)}


## The open's leak: of Ana's holes the walk visited, the one with the most points lost + TAP_VALUE x taps, with the move
## that would fill it best and its Drill plan; {} when no hole cost anything.
static func leak_of(f: Dictionary, visits: Dictionary, rules: Dictionary) -> Dictionary:
	var best := ""
	var top := 0.0
	for node in BjjTree.holes(f, rules):
		if not visits.has(node):
			continue
		var v: Array = visits[node]
		var cost := float(v[1]) + float(BjjTree.T["TAP_VALUE"]) * float(v[2])
		if cost > top:
			top = cost
			best = node
	if best == "":
		return {}
	var mv := BjjTree.leak_move(f, best, rules)
	if mv == "":
		return {}
	var v2: Array = visits[best]
	return {"node": best, "node_name": str(BjjTree.node(best)["name"]), "move": mv, "move_name": BjjTree.move_name(mv),
		"plan": BjjTree.drill_plan_for(f, mv), "lost_pts": int(v2[1]), "taps": int(v2[2]), "visits": int(v2[0])}


## f["mat_stats"][edge] = [tried, landed] for Ana's non-BASE attempts in the open.
static func note_stats(f: Dictionary, res: Dictionary) -> void:
	var stats: Dictionary = f.get_or_add("mat_stats", {})
	for row in res.get("matches", []):
		for p in (row as Dictionary).get("path", []):
			if int(p[1]) != 0 or BjjTree.is_base(str(BjjTree.edge(str(p[0])).get("move", ""))):
				continue
			var s: Array = stats.get_or_add(str(p[0]), [0, 0])
			s[0] += 1
			if str(p[2]) == "hit":
				s[1] += 1


## One line for a bout: "R1 Rosa Lund (Guard player): double leg, run the pipe, rear naked choke - won, submission ...".
static func path_line(row: Dictionary, i: int) -> String:
	var landed: Array = []
	for p in row.get("path", []):
		if int(p[1]) == 0 and str(p[2]) == "hit":
			landed.append(BjjTree.move_name(str(BjjTree.edge(str(p[0])).get("move", ""))).to_lower())
	var moves := "no attack landed" if landed.is_empty() else ", ".join(landed.slice(0, 5)) + (", ..." if landed.size() > 5 else "")
	var style := str(row.get("style", ""))
	return "R%d %s%s: %s - %s, %s." % [i + 1, str(row.get("opp", "")), (" (%s)" % style) if style != "" else "", moves,
		"won" if bool(row.get("win", false)) else "lost", str(row.get("how", ""))]


## Moves usable (felt or better) right now.
static func usable_moves(f: Dictionary) -> Array:
	var lv := BjjTree.levels(f)
	return lv.keys().filter(func(id): return BjjTree.usable(float(lv[id])))


## The Sunday's roll (called after the week): the partner gains the week's classes; every ROLL_EVERY-th Sunday outside
## an open week Ana rolls with the partner. Returns the roll entry ({} when no roll). Never touches morale, w/l or opens.
static func roll_week(c: Career, f: Dictionary) -> Dictionary:
	var p: Dictionary = f.get("partner", {})
	if p.is_empty():
		p = BjjOpp.partner(f, c.seed)
		f["partner"] = p
	else:
		p["mat_classes"] = int(p.get("mat_classes", 0)) + NoGi.CLASSES_PER_WEEK
	if (c.day / 7) % int(BjjTree.T["ROLL_EVERY"]) != 0 or f.has("open_week"):
		return {}
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d|%s|%d|roll" % [c.seed, str(f["id"]), c.day])
	var rules := BjjTree.rules_for(str(f.get("belt", "white")), true)
	var rolls: Array = f.get_or_add("bjj_rolls", [])
	var now := usable_moves(f)
	var try_once: Array = []
	if not rolls.is_empty():
		var was: Array = (rolls.back() as Dictionary).get("felt", [])
		try_once = now.filter(func(id): return not was.has(id))
	var w := BjjWalk.walk(f, p, [BjjTree.plan_of(f, rules), BjjTree.route(str(p.get("route", ""))).get("steps", [])],
		int(rules["minutes"]), rules, rng, {"try_once": try_once, "no_mood": true})
	var entry := {"d": c.day, "how": str(w["how"]), "win": bool(w["win"]), "path": w["path"], "felt": now, "tried": try_once}
	entry["line"] = roll_line(f, entry, rolls.back() if not rolls.is_empty() else {})
	rolls.append(entry)
	while rolls.size() > ROLLS_KEPT:
		rolls.pop_front()
	f["roll_week"] = entry
	return entry


static func _short(roll: Dictionary) -> String:
	var how := str(roll.get("how", ""))
	if how.begins_with("submission"):
		return ("won by tap " if bool(roll.get("win", false)) else "tapped ") + how.get_slice(" ", how.get_slice_count(" ") - 1)
	return ("won " if bool(roll.get("win", false)) else "lost ") + how.trim_prefix("points ").get_slice(",", 0)


## "Rolling with Marta: Ana 4-2 on points (last roll: tapped 3:10). Kimura landed 1/2. Ana tried the sprawl: landed 1/1."
static func roll_line(f: Dictionary, roll: Dictionary, last: Dictionary = {}) -> String:
	var who := str(f.get("first", "Ana"))
	var mate := BjjOpp.PARTNER_NAME.get_slice(" ", 0)
	var how := str(roll["how"])
	var head := ""
	if how.begins_with("submission"):
		var what := how.trim_prefix("submission ")
		head = ("%s tapped %s %s" % [who, mate, what]) if bool(roll["win"]) else ("%s tapped %s %s" % [mate, who, what])
	else:
		head = "%s %s on points" % [who, how.trim_prefix("points ")] + (", won" if bool(roll["win"]) else ", lost")
	var out := "Rolling with %s: %s%s." % [mate, head, (" (last roll: %s)" % _short(last)) if not last.is_empty() else ""]
	var tally := {}
	for p in roll.get("path", []):
		if int(p[1]) != 0:
			continue
		var mv := str(BjjTree.edge(str(p[0])).get("move", ""))
		if BjjTree.is_base(mv):
			continue
		var t: Array = tally.get_or_add(mv, [0, 0])
		t[0] += 1
		if str(p[2]) == "hit":
			t[1] += 1
	var top := ""
	for mv in tally:
		if not (roll.get("tried", []) as Array).has(mv) and (top == "" or int(tally[mv][1]) > int(tally[top][1])):
			top = mv
	if top != "":
		out += " %s landed %d/%d." % [BjjTree.move_name(top), int(tally[top][1]), int(tally[top][0])]
	for mv in roll.get("tried", []):
		if tally.has(mv):
			out += " %s tried the %s: landed %d/%d." % [who, BjjTree.move_name(str(mv)).to_lower(), int(tally[mv][1]), int(tally[mv][0])]
	return out
