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
## S533 P4PBUILD1 the corner's eye: what became of the plan's line in one exchange (LiveRound writes it as rec["line"]).
const ATTEMPTED := ["worked", "lost"]
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


## S533 the corner's eye: the plan's line for this exchange and what became of it. want = the line the plan has for this
## place ("" = none); fired = it was thrown; held = the boxer read it as wrong for the moment and held it.
##   "none" no line here | "not_ready" planned, not thrown (not learned, or not sharp enough to fire) | "held" |
##   "worked" thrown and the exchange won | "lost" thrown and the exchange lost
static func line_state(want: String, fired: bool, held: bool, won: bool) -> String:
	if want == "":
		return "none"
	if held:
		return "held"
	if not fired:
		return "not_ready"
	return "worked" if won else "lost"


## Every planned line of a bout by what became of it: {move: {worked, lost, held, not_ready}} from the exchanges that
## carry "line" (a bout from before S533 carries none: {}).
static func line_counts(rounds: Array) -> Dictionary:
	var out := {}
	for r in rounds:
		if not (r is Dictionary):
			continue
		for x in r.get("exchanges", []):
			var st := str((x as Dictionary).get("line", ""))
			var want := str((x as Dictionary).get("want", ""))
			if want == "" or st == "" or st == "none":
				continue
			var row: Dictionary = out.get(want, {"worked": 0, "lost": 0, "held": 0, "not_ready": 0})
			row[st] = int(row.get(st, 0)) + 1
			out[want] = row
	return out


## The one clue a bout keeps, watched or skipped alike: the planned line whose record says most. First a line that never
## got off twice or more (drill it), then one that lost more than it won, then the line that worked most.
## {move, kind: "not_ready" | "lost" | "worked", n, of} ({} = nothing recorded: say "no recorded clue").
static func clue(rounds: Array) -> Dictionary:
	var counts := line_counts(rounds)
	var best := {}
	for move in counts:
		var c: Dictionary = counts[move]
		var tried := int(c["worked"]) + int(c["lost"])
		var all := tried + int(c["held"]) + int(c["not_ready"])
		var cand := {}
		if int(c["not_ready"]) >= 2 and tried == 0:
			cand = {"move": str(move), "kind": "not_ready", "n": int(c["not_ready"]), "of": all, "rank": 300 + int(c["not_ready"])}
		elif tried >= 2 and int(c["lost"]) > int(c["worked"]):
			cand = {"move": str(move), "kind": "lost", "n": int(c["lost"]), "of": tried, "rank": 200 + int(c["lost"])}
		elif int(c["worked"]) >= 1:
			cand = {"move": str(move), "kind": "worked", "n": int(c["worked"]), "of": tried, "rank": 100 + int(c["worked"])}
		if not cand.is_empty() and (best.is_empty() or int(cand["rank"]) > int(best["rank"])):
			best = cand
	best.erase("rank")
	return best


## The clue in words. move_words = the line's own name as the screens say it.
static func clue_text(c: Dictionary, move_words: String) -> String:
	match str(c.get("kind", "")):
		"not_ready":
			return "The plan had %s %d times and it never got off: not sharp enough yet. Drill it, or plan a line that is ready." % [move_words, int(c["n"])]
		"lost":
			return "%s was thrown %d times and lost %d: the wrong answer for this opponent, or the wrong place for it." % [move_words.capitalize(), int(c["of"]), int(c["n"])]
		"worked":
			return "%s was thrown %d times and won %d: keep it in the plan." % [move_words.capitalize(), int(c["of"]), int(c["n"])]
	return "No recorded clue: the plan's lines were not tracked in this bout."
