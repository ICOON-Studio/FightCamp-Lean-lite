extends RefCounted
## MATRECEIPT1 (MATPLAN_MAP_S433 section 4.6, build task M7): the mat plan's receipt per line after an open.
## After the open the coach goes down the plan: "your back escape: tried 3, worked 2; the americana: never got there".
## Over several opens the coach says which lines work.
## Pure static; preloads MatLines, BjjTree, PlanRecord only.

const MatLines := preload("res://scripts/rules/MatLines.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")

## Cap on how much one move can gain from one open (map 4.6 BOUTS TEACH).
const TEACH_CAP := 3.0
## A miss or reset is worth half a landed try for teaching.
const MISS_GAIN := 0.5


## 1. line_receipt(line, rows) -> Dictionary: over the open's bout rows, Ana's (actor 0) tries of the line's edge.
## {at, edge, tried, landed, missed (slid: the walk wrote "miss"), reset, first_t} and `words`.
## Rows without a path (a live bout) are skipped.
static func line_receipt(line: Dictionary, rows: Array) -> Dictionary:
	var edge_id: String = str(line.get("edge", ""))
	var tried := 0
	var landed := 0
	var missed := 0
	var reset_count := 0
	var first_t := -1.0
	for row in rows:
		if not (row is Dictionary):
			continue
		var path: Variant = row.get("path", [])
		if not (path is Array):
			continue
		for p in path:
			if not (p is Array) or p.size() < 4:
				continue
			if int(p[1]) != 0:
				continue
			if str(p[0]) != edge_id:
				continue
			tried += 1
			var result: String = str(p[2])
			if result == "hit":
				landed += 1
			elif result == "miss":
				missed += 1
			elif result == "reset":
				reset_count += 1
			var t: float = float(p[3])
			if first_t < 0.0 or t < first_t:
				first_t = t
	var mv_id: String = str(BjjTree.edge(edge_id).get("move", ""))
	var mname: String = BjjTree.move_name(mv_id)
	var w: String = "%s: %d of %d" % [mname, landed, tried]
	if tried == 0:
		w += ", never reached"
	return {"at": str(line.get("at", "")), "edge": edge_id, "tried": tried, "landed": landed,
		"missed": missed, "reset": reset_count, "first_t": first_t, "words": w}


## 2. receipt(plan, f, rows, rules) -> Array: one line_receipt per BROUGHT line (MatLines.brought), in the brought order.
static func receipt(plan: Dictionary, f: Dictionary, rows: Array, rules: Dictionary) -> Array:
	var brought: Array = MatLines.brought(f, plan, rules)
	var out: Array = []
	for line in brought:
		out.append(line_receipt(line, rows))
	return out


## 3. season_add(book, receipts) -> Dictionary: adds an open's receipts into a running book keyed by edge id
## ({used, won} like PlanRecord rows) and returns it.
static func season_add(book: Dictionary, receipts: Array) -> Dictionary:
	for r in receipts:
		if not (r is Dictionary):
			continue
		var edge_id: String = str(r.get("edge", ""))
		if edge_id == "":
			continue
		var row: Array = book.get(edge_id, [0, 0])
		row = [int(row[0]) + int(r.get("tried", 0)), int(row[1]) + int(r.get("landed", 0))]
		book[edge_id] = row
	return book


## verdict_of(book, edge) -> String: PlanRecord.verdict on that row.
static func verdict_of(book: Dictionary, edge: String) -> String:
	var row: Array = book.get(edge, [0, 0])
	var used: int = int(row[0])
	var won: int = int(row[1])
	if used < PlanRecord.MIN_USED:
		return "too early"
	var rate: float = float(won) / float(used) if used > 0 else 0.0
	var vr := {"used": used, "won": won, "rate": rate}
	return PlanRecord.verdict(vr)


## 4. teach(receipts) -> Dictionary (map 4.6 BOUTS TEACH, ESTIMATE): {move_id: gain}: +1 a landed try, +0.5 a missed
## or reset one, at most +3 a move an open.
static func teach(receipts: Array) -> Dictionary:
	var out: Dictionary = {}
	for r in receipts:
		if not (r is Dictionary):
			continue
		var edge_id: String = str(r.get("edge", ""))
		if edge_id == "":
			continue
		var mv_id: String = str(BjjTree.edge(edge_id).get("move", ""))
		if mv_id == "":
			continue
		var gain: float = float(int(r.get("landed", 0))) * 1.0
		gain += float(int(r.get("missed", 0)) + int(r.get("reset", 0))) * MISS_GAIN
		if gain <= 0.0:
			continue
		if gain > TEACH_CAP:
			gain = TEACH_CAP
		var prev: float = float(out.get(mv_id, 0.0))
		out[mv_id] = prev + gain
	return out
