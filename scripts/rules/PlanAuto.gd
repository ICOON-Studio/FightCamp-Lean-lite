extends RefCounted
## S482 PLANFLOW1 stage 1 (his Q-240 "Yes, build it"; map DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI.md 3.3, build row P6): the
## plans the chart writes for the player, every line one she can FIRE (FireLevel: under Usable a line never fires).
##   suggestion(f, game) -> the coach's starter (PlanFight.starter) with each line she cannot fire swapped for the best she can
##   coach(f, rows, game, limit) -> "Your coach rewrites it": an IF for every moment film found (PlanFile rows), answered with
##       the best fireable line that does not walk into it, then the ranges of the suggestion; at most `limit` lines
##   last_bout(f, results, limit) -> {ok, why, arrows}: "Start from last bout" - the 2-3 lines thrown most in her last bout
##       with a plan record that she can still fire, kept as they stand on her plan
## Pure static: reads the fighter dictionary and the rows it is given, writes nothing.

const SM := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")

const LAST_KEEP := 3


static func fires(f: Dictionary, mid: String) -> bool:
	return FireLevel.mastery_of(f, mid) >= FireLevel.USABLE_AT


## The best answer at `place` against `sit` that she can fire and that does not walk into it ("" = none).
static func best(f: Dictionary, place: String, sit: String) -> String:
	for o in PlanLines.options(place, sit, f.get("moves", {}), f.get("combos", {})):
		if str(o["why"]) == "" and str(o["fit"]) != "wrong" and fires(f, str(o["id"])):
			return str(o["id"])
	return ""


static func suggestion(f: Dictionary, game: String) -> Array:
	var out: Array = []
	for a in PlanFight.starter():
		var mid := str(a["move"])
		if fires(f, mid):
			out.append(a)
			continue
		var pick := best(f, str(SM.move(mid).get("from", "")), game)
		if pick != "":
			out.append({"move": pick})
	return out


static func coach(f: Dictionary, rows: Array, game: String, limit: int) -> Array:
	var out: Array = []
	var whens := {}
	for r in rows:
		var sit := str(r.get("sit", ""))
		if out.size() >= limit or not bool(r.get("known", false)) or sit == "" or whens.has(sit):
			continue
		var pick := best(f, PlanLines.place_for(sit), sit)
		if pick != "":
			out.append({"move": pick, "when": sit})
			whens[sit] = true
	for a in suggestion(f, game):
		if out.size() >= limit:
			break
		var place := str(SM.move(str(a["move"])).get("from", ""))
		if PlanLines.find(out, place, "") < 0:
			out.append(a)
	return out


static func last_bout(f: Dictionary, results: Array, limit: int) -> Dictionary:
	var rec := {}
	for res in results:   # newest first (results are pushed to the front)
		if res is Dictionary and str(res.get("fid", "")) == str(f.get("id", "")) and (res.get("plan_rec", {}) is Dictionary) \
				and not (res["plan_rec"] as Dictionary).is_empty():
			rec = res["plan_rec"]
			break
	if rec.is_empty():
		return {"ok": false, "why": "No bout fought on a plan yet.", "arrows": []}
	var lines: Dictionary = rec.get("lines", {})
	var used: Array = lines.keys().filter(func(m): return int((lines[m] as Array)[1]) > 0 and fires(f, str(m)))
	used.sort_custom(func(a, b): return int((lines[a] as Array)[1]) > int((lines[b] as Array)[1]))
	var keep: Array = used.slice(0, mini(LAST_KEEP, limit))
	var out: Array = []
	for a in f.get("arrows", []):
		if keep.has(str(a["move"])) and out.size() < keep.size():
			out.append((a as Dictionary).duplicate())
	for m in keep:   # a line she has since changed comes back at its own range, with no IF
		if not out.any(func(x): return str(x["move"]) == str(m)):
			out.append({"move": str(m)})
	if out.is_empty():
		return {"ok": false, "why": "None of the last bout's lines fires now.", "arrows": []}
	return {"ok": true, "why": "", "arrows": out}
