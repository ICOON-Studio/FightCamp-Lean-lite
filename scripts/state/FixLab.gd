extends RefCounted
## S443 the result page's ONE cause and its measured fix (operator Q-S294-199 "Yes, summary + tabs"; the coach critic's two
## musts, ops/research/RESULT_R4_CRITIC_B_S442.md: the best fix is BOTH plan changes, and "even the best plan makes it an
## even fight" when the numbers say so). The bout's plan, as the boxer walked out with it, fights NIGHTS scratch bouts
## against the same opponent through fight night's own rounds (BoutNight.play_out on a scratch career, as the Playbook's
## Test it does - nothing is booked), and so do up to three changes to it:
##   rewrite - the planned line that lost most while it walked into the opponent's game, set to the Playbook's top answer
##             at that line's own place (PlanLines.options; a move from another place is never offered)
##   add     - a new line for the situation lost most that no line answered (a new line, or in place of a line that never
##             fired when the coach holds no more lines)
##   both    - the two together
## The best of them is the fix the page offers; its wins against the plan's say whether the plan or the class decided it.
##   snap(f) -> the boxer at the first bell (BoutNight "start" keeps it on the moment as m["lab_from"])
##   changes(f, rounds, limit) -> {rewrite?, add?, both?} each {arrows, line, i, move, when, place, ...}
##   run(c, m, nights) -> {ok, nights, written, best, changes: {key: {wins, ...}}, verdict, cause}
## Pure apart from the scratch bouts; reads the moment's rounds and the first-bell copy, writes nothing on the career.

const BoutNight := preload("res://scripts/state/BoutNight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

## Scratch nights per plan (the page says "of N"); 4 plans x 40 bouts runs in about a second.
const NIGHTS := 40
## Bout k fights on day DICE_DAY + k * 7 of a scratch career, away from PlanTest's dice (50000) and any real night.
const DICE_DAY := 70000
## A change counts as a fix only when it wins this many more of the nights than the plan as written (under it is luck).
const MIN_GAIN := 3
## "An even fight": the best plan wins between these shares of the nights.
const EVEN_LO := 0.4
const EVEN_HI := 0.6
const LETTERS := "ABCDEFGHI"


## The boxer as the first bell found her (stats with any peak bonus, the Tank, her written plan), deep-copied so the bout
## the player watched cannot leak into the measurement.
static func snap(f: Dictionary) -> Dictionary:
	var s: Dictionary = f.duplicate(true)
	s.erase("history")
	return s


## The planned line that cost most: {i, move, when, place, lost, used} for the arrow lost most often while its fit was
## "wrong" (it walked into the opponent's game); {} when no planned line walked into it.
static func worst_line(arrows: Array, rounds: Array) -> Dictionary:
	var tally := {}   # move id -> [lost, used]
	for r in rounds:
		for x in (r as Dictionary).get("exchanges", []):
			if not bool(x.get("planned", false)) or str(x.get("arrow_fit", "")) != "wrong":
				continue
			var t: Array = tally.get(str(x["arrow"]), [0, 0])
			tally[str(x["arrow"])] = [int(t[0]) + int(not bool(x["won"])), int(t[1]) + 1]
	var best := {}
	for id in tally:
		var i := _index_of(arrows, str(id))
		if i < 0:
			continue
		var t: Array = tally[id]
		if best.is_empty() or int(t[0]) > int(best["lost"]):
			best = {"i": i, "move": str(id), "when": str((arrows[i] as Dictionary).get("when", "")),
				"place": str(StrikeMap.move(str(id)).get("from", "")), "lost": int(t[0]), "used": int(t[1])}
	return best


## The situation lost most that no line answers: {sit, lost, seen} ({} when every lost situation had a line).
static func open_sit(arrows: Array, rounds: Array) -> Dictionary:
	var lost := {}
	var seen := {}
	for r in rounds:
		for x in (r as Dictionary).get("exchanges", []):
			var sit := str(x.get("sit", ""))
			if sit == "" or sit.begins_with("she_") or not FightFlow.WHEN_WORDS.has(sit):
				continue
			seen[sit] = int(seen.get(sit, 0)) + 1
			if not bool(x["won"]):
				lost[sit] = int(lost.get(sit, 0)) + 1
	var top := ""
	for sit in lost:
		if PlanLines.find(arrows, PlanLines.place_for(sit), sit) >= 0:
			continue
		if top == "" or int(lost[sit]) > int(lost[top]):
			top = sit
	return {} if top == "" else {"sit": top, "lost": int(lost[top]), "seen": int(seen[top])}


## The Playbook's top answer at `place` against `sit` that the boxer can throw and that fits ({} when none fits).
static func top_answer(f: Dictionary, place: String, sit: String) -> Dictionary:
	for o in PlanLines.options(place, sit, f.get("moves", {}), f.get("combos", {})):
		if str(o["why"]) == "" and (str(o["fit"]) == "best" or str(o["fit"]) == "ok"):
			return o
	return {}


## The changes worth measuring on this bout. `limit` = the lines the coach holds.
static func changes(f: Dictionary, rounds: Array, limit: int) -> Dictionary:
	var arrows: Array = f.get("arrows", [])
	var out := {}
	var worst := worst_line(arrows, rounds)
	var rewrite: Array = []
	if not worst.is_empty():
		var sit := PlanLines.sit_for(str(worst["when"]), _game(f, rounds))
		var ans := top_answer(f, str(worst["place"]), sit)
		if not ans.is_empty() and str(ans["id"]) != str(worst["move"]):
			rewrite = arrows.duplicate(true)
			rewrite[int(worst["i"])] = {"move": str(ans["id"]), "when": str(worst["when"])} if str(worst["when"]) != "" else {"move": str(ans["id"])}
			out["rewrite"] = worst.merged({"arrows": rewrite, "to": str(ans["id"]), "to_name": str(ans["name"]), "fit": str(ans["fit"]),
				"letter": _letter(int(worst["i"])), "sit": sit})
	var open := open_sit(arrows, rounds)
	if not open.is_empty():
		var place := PlanLines.place_for(str(open["sit"]))
		var ans := top_answer(f, place, str(open["sit"]))
		if not ans.is_empty():
			var add := _with_line(arrows, rounds, {"move": str(ans["id"]), "when": str(open["sit"])}, limit)
			if not (add["arrows"] as Array).is_empty():
				out["add"] = open.merged({"arrows": add["arrows"], "i": int(add["i"]), "letter": _letter(int(add["i"])),
					"replaces": str(add.get("replaces", "")), "place": place, "to": str(ans["id"]), "to_name": str(ans["name"]), "fit": str(ans["fit"])})
				if not rewrite.is_empty():
					var both := _with_line(rewrite, rounds, {"move": str(ans["id"]), "when": str(open["sit"])}, limit, int(worst["i"]))
					if not (both["arrows"] as Array).is_empty():
						out["both"] = {"arrows": both["arrows"]}
	return out


## Measures the plan as written and each change over `nights` scratch bouts. m needs "lab_from" (snap at the first bell)
## and "rounds". {ok: false} without them.
static func run(c: Career, m: Dictionary, nights: int = NIGHTS) -> Dictionary:
	var f: Dictionary = m.get("lab_from", {})
	var rounds: Array = m.get("rounds", [])
	if f.is_empty() or rounds.is_empty() or (f.get("bout", {}) as Dictionary).is_empty():
		return {"ok": false}
	var limit := PlanBoard.arrow_limit(float(c.coach.get("rating", 0.0)))
	var ch := changes(f, rounds, limit)
	var res := {"ok": true, "nights": nights, "written": _wins(c, f, f.get("arrows", []), nights), "changes": {}}
	var best := ""
	for k in ["rewrite", "add", "both"]:
		if not ch.has(k):
			continue
		var row: Dictionary = ch[k]
		row["wins"] = _wins(c, f, row["arrows"], nights)
		res["changes"][k] = row
		# a tie goes to both changes: the new line answers a situation the bout lost and costs nothing (the coach critic's
		# must, RESULT_R4_CRITIC_B_S442.md 6.1: "Best fix = both lines")
		var top := -1 if best == "" else int(res["changes"][best]["wins"])
		if int(row["wins"]) - int(res["written"]) >= MIN_GAIN and (int(row["wins"]) > top or (k == "both" and int(row["wins"]) >= top)):
			best = k
	res["best"] = best
	res["best_wins"] = int(res["written"]) if best == "" else int(res["changes"][best]["wins"])
	res["verdict"] = verdict(int(res["written"]), int(res["best_wins"]), nights)
	return res


## What the numbers say about the night: "plan_right" (the plan as written wins most nights), "even" (the best plan only
## makes it even), "class" (even the best plan loses most nights), "fixed" (the fix wins most nights).
static func verdict(written: int, best: int, nights: int) -> String:
	var w := float(written) / float(maxi(1, nights))
	var b := float(best) / float(maxi(1, nights))
	if w >= EVEN_HI:
		return "plan_right"
	if b < EVEN_LO:
		return "class"
	if b <= EVEN_HI:
		return "even"
	return "fixed"


## The plan with `line` in it: appended when the coach holds another line, else in place of a line that never fired in
## the bout (never `keep`, the line just rewritten). {arrows: [] } when there is no room.
static func _with_line(arrows: Array, rounds: Array, line: Dictionary, limit: int, keep: int = -1) -> Dictionary:
	var out: Array = arrows.duplicate(true)
	if out.size() < limit:
		out.append(line)
		return {"arrows": out, "i": out.size() - 1}
	var fired := {}
	for r in rounds:
		for x in (r as Dictionary).get("exchanges", []):
			if bool(x.get("planned", false)):
				fired[str(x["arrow"])] = true
	for i in out.size():
		if i != keep and not fired.has(str((out[i] as Dictionary).get("move", ""))):
			var gone := str((out[i] as Dictionary).get("move", ""))
			out[i] = line
			return {"arrows": out, "i": i, "replaces": gone}
	return {"arrows": []}


static func _wins(c: Career, f: Dictionary, arrows: Array, nights: int) -> int:
	var wins := 0
	for k in nights:
		var sc := Career.new()
		sc.day = DICE_DAY + k * 7
		sc.coach = c.coach.duplicate(true)
		sc.seed = c.seed
		var sf: Dictionary = f.duplicate(true)
		sf["arrows"] = arrows.duplicate(true)
		sf["bout"].erase("arrows")
		sf["bout"]["done"] = false
		sc.fighters = [sf]
		var sm := BoutNight.fight_modal(sf)
		BoutNight.play_out(sc, sf, sm)
		wins += int(BoutNight.outcome_of(sf, sm) == "win")
	return wins


static func _index_of(arrows: Array, move: String) -> int:
	for i in arrows.size():
		if str((arrows[i] as Dictionary).get("move", "")) == move:
			return i
	return -1


static func _letter(i: int) -> String:
	return LETTERS[i] if i >= 0 and i < LETTERS.length() else ""


## The opponent's main game as the bout saw it (the mode met most), for a line with no situation of its own.
static func _game(f: Dictionary, rounds: Array) -> String:
	var n := {}
	for r in rounds:
		for x in (r as Dictionary).get("exchanges", []):
			n[str(x.get("mode", ""))] = int(n.get(str(x.get("mode", "")), 0)) + 1
	var top := ""
	for k in n:
		if k != "" and (top == "" or int(n[k]) > int(n[top])):
			top = k
	return top if top != "" else str(OppFile.main_game((f.get("bout", {}) as Dictionary).get("opp", {})))
