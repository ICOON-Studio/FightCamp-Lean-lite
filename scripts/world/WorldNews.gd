extends RefCounted
## R85NEWS1 the world's year end becomes news: who retired, who arrived, who was crowned (WorldSim.year_end's result,
## which ProLadder used to throw away). One fact a line, under 110 characters, the player's divisions first.
## Pure static; zero preloads: plain Dictionaries only. The caller takes snapshot() BEFORE year_end, since year_end clears
## a retiree's belt and re-does the ranks. Collected S443 (Qwen draft, review fixes: ops/research/R85NEWS1_REVIEW_S443.md).

const MAX_OTHER := 6
const MAX_LINE := 110   # every line strictly under this
const RANKED_NAMED := 10   # a retiree ranked 1 to 10 gets a line of their own
const KIND_ORDER := ["crowned", "retired_champ", "retired_ranked", "retired_more", "arrived"]


## {id: {name, div, rank, belt, rating, age, club, w, l}} of every boxer not retired.
static func snapshot(divisions: Dictionary) -> Dictionary:
	var snap := {}
	for div_id in divisions:
		for bx in (divisions[div_id] as Dictionary).get("boxers", []):
			var b: Dictionary = bx
			if bool(b.get("retired", false)):
				continue
			snap[int(b.get("id", 0))] = {"name": str(b.get("name", "")), "div": str(b.get("div", div_id)),
				"rank": int(b.get("rank", 0)), "belt": str(b.get("belt", "")), "rating": float(b.get("rating", 0.0)),
				"age": int(b.get("age", 0)), "club": str(b.get("club", "")), "w": int(b.get("w", 0)), "l": int(b.get("l", 0))}
	return snap


## The part after the last "_" ("IBF_national" -> "national"); "" for "".
static func level_of(belt: String) -> String:
	var at := belt.rfind("_")
	return belt.substr(at + 1) if at >= 0 else ""


## The news lines, most important first: [{t, kind, id, div}].
static func lines(before: Dictionary, result: Dictionary, divisions: Dictionary, follow := []) -> Array:
	var mine: Array = []
	var other: Array = []
	var order: Array = []
	for d in follow:
		if divisions.has(str(d)) and not order.has(str(d)):
			order.append(str(d))
	for d in divisions:
		if not order.has(str(d)):
			order.append(str(d))
	for d in order:
		var dl := _division_lines(d, before, result, divisions)
		if follow.has(d):
			mine.append_array(dl)
		else:
			other.append_array(dl)
	# Other divisions: at most MAX_OTHER lines, crowned and retired champions first, then the rest in division order.
	var top: Array = other.filter(func(l): return str(l["kind"]) == "crowned" or str(l["kind"]) == "retired_champ")
	var rest: Array = other.filter(func(l): return not (str(l["kind"]) == "crowned" or str(l["kind"]) == "retired_champ"))
	var kept: Array = (top + rest).slice(0, MAX_OTHER)
	return mine + kept


## The division a boxer belongs to: the snapshot first, else the boxer as the world holds it now (a crowned arrival, a
## boxer missing from the snapshot).
static func _div_of(id: int, before: Dictionary, divisions: Dictionary) -> String:
	if before.has(id):
		return str((before[id] as Dictionary).get("div", ""))
	for d in divisions:
		for bx in (divisions[d] as Dictionary).get("boxers", []):
			if int((bx as Dictionary).get("id", -1)) == id:
				return str(d)
	return ""


static func _division_lines(div_id: String, before: Dictionary, result: Dictionary, divisions: Dictionary) -> Array:
	var info: Dictionary = (divisions[div_id] as Dictionary).get("info", {})
	var full := str(info.get("name", div_id))
	var short := str(info.get("weight_class", full)).capitalize()
	var out: Array = []
	for cx in result.get("crowned", []):
		var c: Dictionary = cx
		var cid := int(c.get("id", 0))
		if _div_of(cid, before, divisions) == div_id:
			out.append(_line(["%s wins the vacant %s title (%s)." % [str(c.get("name", "")), str(c.get("level", "")), full],
				"%s wins the vacant %s title (%s)." % [str(c.get("name", "")), str(c.get("level", "")), short]],
				"crowned", cid, div_id))
	var more := 0
	for rx in result.get("retired", []):
		var r: Dictionary = rx
		var rid := int(r.get("id", 0))
		if _div_of(rid, before, divisions) != div_id:
			continue
		# The belt and the rank as they were: year_end has cleared both on the boxer by now.
		var was: Dictionary = before.get(rid, {})
		var belt := str(was.get("belt", ""))
		var rank := int(was.get("rank", 0))
		var who := str(r.get("name", was.get("name", "")))
		var age := int(r.get("age", was.get("age", 0)))
		var rec := "%d-%d" % [int(r.get("w", was.get("w", 0))), int(r.get("l", was.get("l", 0)))]
		if belt != "":
			out.append(_line(["%s retires at %d, %s, the %s champion of %s." % [who, age, rec, level_of(belt), full],
				"%s retires at %d, %s, the %s champion of %s." % [who, age, rec, level_of(belt), short]], "retired_champ", rid, div_id))
		elif rank >= 1 and rank <= RANKED_NAMED:
			out.append(_line(["%s retires at %d after %s, ranked %d at %s." % [who, age, rec, rank, full],
				"%s retires at %d after %s, ranked %d at %s." % [who, age, rec, rank, short]], "retired_ranked", rid, div_id))
		else:
			more += 1
	if more > 0:
		var noun := "boxer" if more == 1 else "boxers"
		out.append(_line(["%d more %s retired in %s." % [more, noun, full], "%d more %s retired in %s." % [more, noun, short]],
			"retired_more", 0, div_id))
	var arrivals: Array = (result.get("arrived", []) as Array).filter(func(a): return _div_of(int(a.get("id", 0)), before, divisions) == div_id or str(a.get("div", "")) == div_id)
	if not arrivals.is_empty():
		var best: Dictionary = arrivals[0]
		for ax in arrivals:
			if float((ax as Dictionary).get("rating", 0.0)) > float(best.get("rating", 0.0)):
				best = ax
		var tail := " (%d new this year)" % arrivals.size() if arrivals.size() >= 2 else ""
		var who := str(best.get("name", ""))
		var age := int(best.get("age", 0))
		var club := str(best.get("club", ""))
		out.append(_line(["New face in %s: %s, %d, from %s.%s" % [full, who, age, club, tail],
			"New face in %s: %s, %d, from %s.%s" % [short, who, age, club, tail],
			"New face in %s: %s, %d.%s" % [short, who, age, tail]], "arrived", int(best.get("id", 0)), div_id))
	# The kind order above, each kind in the order it came (sort_custom is not stable).
	var ordered: Array = []
	for k in KIND_ORDER:
		ordered.append_array(out.filter(func(l): return str(l["kind"]) == k))
	return ordered


## The first wording under MAX_LINE (the last one cut to fit if none is).
static func _line(words: Array, kind: String, id: int, div: String) -> Dictionary:
	var t := str(words[-1])
	for w in words:
		if str(w).length() < MAX_LINE:
			t = str(w)
			break
	if t.length() >= MAX_LINE:
		t = t.substr(0, MAX_LINE - 4) + "..."
	return {"t": t, "kind": kind, "id": id, "div": div}


## {id: {mark, until}}: every arrival "new face" until day + 365; every retiree "retired" for ever (until -1).
static func marks(result: Dictionary, day: int) -> Dictionary:
	var m := {}
	for a in result.get("arrived", []):
		m[int((a as Dictionary).get("id", 0))] = {"mark": "new face", "until": day + 365}
	for r in result.get("retired", []):
		m[int((r as Dictionary).get("id", 0))] = {"mark": "retired", "until": -1}
	return m


## "new face" while day < until, "retired" when until is -1, else "".
static func mark_of(m: Dictionary, id: int, day: int) -> String:
	if not m.has(id):
		return ""
	var e: Dictionary = m[id]
	var until := int(e.get("until", 0))
	if until == -1 or day < until:
		return str(e.get("mark", ""))
	return ""
