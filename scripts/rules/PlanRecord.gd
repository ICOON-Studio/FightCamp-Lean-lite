extends RefCounted
## S370 FLOWBOUT1 - the bout's plan record: what the fight result's THE PLAN, LIT UP map showed for one night, kept.
## Each closed round already carries its plan tally (LiveRound: "arrows" = PlanFight.tally of its exchanges - which
## plan line she threw and whether that exchange was won - and "plan" = the arrows she fought it on), but it lived
## only on the fight-night modal and was thrown away. summary() folds a bout's rounds into the record BoutNight
## keeps on her result ("plan_rec"); rates() and verdict() read a fighter's results back so the Playbook can learn
## which of her plan lines win exchanges. Pure static; no state, preloads nothing.
##   summary(rounds) -> {plan: [move ids], used, worked, improvised, lines: {move_id: [won, used]}} ({} = no tallies)
##   rates(results, fid) -> [{move, won, used, bouts, rate}], most thrown first
##   verdict(row) -> "works" | "fails" | "too early" | "even"

## The smallest sample a verdict is read on, and the win shares that earn one: 0.55 / 0.35 either side of a coin
## flip, on 6+ thrown exchanges, so a line must lose as clearly as a working one wins to be called failing.
const MIN_USED := 6
const WORKS_RATE := 0.55
const FAILS_RATE := 0.35


## One bout's record from its closed rounds: the rounds' "arrows" tallies added up ("lines" is PlanFight.tally's
## "moves" under the record's own name: a plan line's [won, used]), and the plan she finished the bout on - the
## last tallied round's arrows as bare move ids (the corner may change one a round; the record keeps where she
## ended). A round with no "arrows" tally is skipped whole - it adds no counts and does not replace the plan; no
## tallied rounds at all (no rounds, or none that carry a tally) is {}: nothing was counted, so there is no record.
static func summary(rounds: Array) -> Dictionary:
	var plan: Array = []
	var lines := {}
	var used := 0
	var worked := 0
	var improvised := 0
	var tallied := false
	for r in rounds:
		if not (r is Dictionary) or not (r.get("arrows") is Dictionary):
			continue
		var arrows: Dictionary = r["arrows"]
		tallied = true
		used += int(arrows.get("used", 0))
		worked += int(arrows.get("worked", 0))
		improvised += int(arrows.get("improvised", 0))
		var moves: Variant = arrows.get("moves", {})
		if moves is Dictionary:
			for id in moves:
				var per: Variant = moves[id]
				if not (per is Array) or per.size() < 2:
					continue
				var line: Array = lines.get(str(id), [0, 0])
				lines[str(id)] = [int(line[0]) + int(per[0]), int(line[1]) + int(per[1])]
		plan = _plan_ids(r.get("plan", []))
	if not tallied:
		return {}
	return {"plan": plan, "used": used, "worked": worked, "improvised": improvised, "lines": lines}


## A round's "plan" (its arrows, [{"move": id, "when": ...}, ...]) as the move ids alone, in order; an entry that
## is already a bare id reads as itself, and an entry with no move on it is left out.
static func _plan_ids(plan: Variant) -> Array:
	var ids: Array = []
	if not (plan is Array):
		return ids
	for a in plan:
		var id := str(a.get("move", "")) if a is Dictionary else str(a)
		if id != "":
			ids.append(id)
	return ids


## Her plan lines across her kept results (Career.results with her "fid" and a non-empty "plan_rec"): one row per
## move id in their records, bouts = the nights that line appears on the record, rate = won / used exchanges (0.0
## when it was never actually thrown). Sorted by used descending, then by move id, so the table reads the same
## every time it is drawn.
static func rates(results: Array, fid: String) -> Array:
	var agg := {}
	for res in results:
		if not (res is Dictionary) or str(res.get("fid", "")) != fid:
			continue
		var rec: Variant = res.get("plan_rec", {})
		if not (rec is Dictionary) or rec.is_empty() or not (rec.get("lines") is Dictionary):
			continue
		var lines: Dictionary = rec["lines"]
		for id in lines:
			var per: Variant = lines[id]
			if not (per is Array) or per.size() < 2:
				continue
			var row: Array = agg.get(str(id), [0, 0, 0])
			agg[str(id)] = [int(row[0]) + int(per[0]), int(row[1]) + int(per[1]), int(row[2]) + 1]
	var out: Array = []
	for id in agg:
		var row: Array = agg[id]
		var won := int(row[0])
		var used := int(row[1])
		out.append({"move": str(id), "won": won, "used": used, "bouts": int(row[2]),
			"rate": float(won) / float(used) if used > 0 else 0.0})
	out.sort_custom(func(a, b): return int(a["used"]) > int(b["used"]) if int(a["used"]) != int(b["used"]) else str(a["move"]) < str(b["move"]))
	return out


## The Playbook's word on one rates() row: under MIN_USED thrown exchanges the line has not been read yet ("too
## early"); from there, winning WORKS_RATE or more of its exchanges "works", FAILS_RATE or fewer "fails", and the
## ground between is "even". A row carrying no "rate" is read off its won/used instead.
static func verdict(row: Dictionary) -> String:
	var used := int(row.get("used", 0))
	if used < MIN_USED:
		return "too early"
	var rate := float(row["rate"]) if row.has("rate") else float(int(row.get("won", 0))) / float(used)
	if rate >= WORKS_RATE:
		return "works"
	if rate <= FAILS_RATE:
		return "fails"
	return "even"
