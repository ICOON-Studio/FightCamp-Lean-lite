extends RefCounted
## RANKSHOW1 - RankLine: the rank a fight earned, as a plain line.
## Pure rule module. Takes rows of {name, w, l, rating} for all fighters in a division.
## Ranked fighters are those with w >= min_wins, sorted by net wins, wins, rating (Region.before order).

## The table's order: net wins, then wins, then rating (same as Region.before).
static func _before(x: Dictionary, y: Dictionary) -> bool:
	var nx: int = int(x["w"]) - int(x["l"])
	var ny: int = int(y["w"]) - int(y["l"])
	if nx != ny:
		return nx > ny
	if int(x["w"]) != int(y["w"]):
		return int(x["w"]) > int(y["w"])
	return float(x["rating"]) > float(y["rating"])


## Filter rows to ranked fighters (w >= min_wins) and sort.
static func _ranked(rows: Array, min_wins: int) -> Array:
	var out: Array = []
	for r in rows:
		if int(r["w"]) >= min_wins:
			out.append((r as Dictionary).duplicate())
	out.sort_custom(_before)
	return out


## A name's place (1-based) in a ranked table, 0 when not in it.
static func _rank_of(table: Array, name: String) -> int:
	for i in table.size():
		if str(table[i]["name"]) == name:
			return i + 1
	return 0


## Find a fighter's record in the rows.
static func _find(rows: Array, name: String) -> Dictionary:
	for r in rows:
		if str(r["name"]) == name:
			return r as Dictionary
	return {}


## The rank line after a fight. Compares rankings before and after.
## Returns {was, now, moved, entered, left, passed, need, words}.
static func after(rows_before: Array, rows_after: Array, name: String, min_wins: int) -> Dictionary:
	var table_before: Array = _ranked(rows_before, min_wins)
	var table_after: Array = _ranked(rows_after, min_wins)
	var was: int = _rank_of(table_before, name)
	var now: int = _rank_of(table_after, name)
	var entered: bool = was == 0 and now > 0
	var left: bool = was > 0 and now == 0
	var moved: int = 0
	if was > 0 and now > 0:
		moved = was - now
	# Passed: names she was below in before but above in after
	var passed: Array = []
	if was > 0 and now > 0 and now < was:
		for r in table_before:
			var rname: String = str(r["name"])
			if rname == name:
				continue
			var pos_before: int = _rank_of(table_before, rname)
			var pos_after: int = _rank_of(table_after, rname)
			# She was below this fighter before (pos_before < was) and above now (pos_after > now)
			if pos_before < was and pos_after > now:
				passed.append(rname)
	# Need: wins still needed to enter (0 when ranked)
	var need: int = 0
	if now == 0:
		var rec: Dictionary = _find(rows_after, name)
		if rec.is_empty():
			rec = _find(rows_before, name)
		if not rec.is_empty():
			need = maxi(0, min_wins - int(rec["w"]))
		else:
			need = min_wins
	var words: String = _words(was, now, entered, left, moved, passed, need)
	return {"was": was, "now": now, "moved": moved, "entered": entered, "left": left,
		"passed": passed, "need": need, "words": words}


## The rank line before a fight (for the fight card).
## Returns {now, need, words}.
static func before(rows: Array, name: String, min_wins: int) -> Dictionary:
	var table: Array = _ranked(rows, min_wins)
	var now: int = _rank_of(table, name)
	var need: int = 0
	if now == 0:
		var rec: Dictionary = _find(rows, name)
		if not rec.is_empty():
			need = maxi(0, min_wins - int(rec["w"]))
		else:
			need = min_wins
	var words: String = ""
	if now > 0:
		words = "Number %d." % now
	else:
		if need > 0:
			words = "Unranked: %d win%s from entering." % [need, "" if need == 1 else "s"]
		else:
			words = "Unranked."
	return {"now": now, "need": need, "words": words}


## Build the plain English words.
static func _words(was: int, now: int, entered: bool, left: bool, moved: int, passed: Array, need: int) -> String:
	if entered:
		var s: String = "Enters the rankings at number %d." % now
		if passed.size() > 0:
			s += " Passed %s." % _join_names(passed)
		return s
	if left:
		return "Leaves the rankings."
	if now == 0 and was == 0:
		if need > 0:
			return "Unranked: %d win%s from entering." % [need, "" if need == 1 else "s"]
		return "Unranked."
	if was > 0 and now > 0:
		if moved > 0:
			var s: String = "Now number %d, up from %d." % [now, was]
			if passed.size() > 0:
				s += " Passed %s." % _join_names(passed)
			return s
		if moved < 0:
			return "Down to number %d from %d." % [now, was]
		return "Still number %d." % now
	return ""


## The boxers passed, counted (S448 operator: "names are only mentioned on the header" - the ladder itself lists them).
static func _join_names(names: Array) -> String:
	if names.size() == 0:
		return ""
	return "one boxer" if names.size() == 1 else "%d boxers" % names.size()
