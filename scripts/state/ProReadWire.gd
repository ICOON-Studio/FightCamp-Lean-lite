extends RefCounted
## S462 INTEGRATE1 #5: M7 PROFESSIONALS GET READ in the fight. ProRead.gd is pure; this keeps the tape it reads and puts
## its price in the exchange.
##   tape    f["pro_tape"]: one entry a professional bout, {"pro": true, "fired": {combo: n}, "read": {...}}, newest last
##   open    at the first bell of a pro bout: bout.pro_read = the line the opponent's corner waits for ({} = none)
##   edge    LiveRound: a planned, fired line on the round's read line loses READ_EDGE x ProRead.share of an exchange
##   close   BoutNight._finish: the bout's fired combinations (and, when it was read, how the read line did) on the tape
## Only punches are read (combinations); steps and ties are footwork. Amateurs and the debut are never read.
## READ_EDGE 6 is READ1's size (docs/READ1_RESULT.md, Claude's rerun): a careless pro loses 5.8 wins in 100, a changed plan 0.

const ProRead := preload("res://scripts/rules/ProRead.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const READ_EDGE := 6.0
const TAPE_KEEP := 4


## The read the opponent's corner brings to her next professional bout, from her tape and her combinations' tiers.
static func target(f: Dictionary) -> Dictionary:
	var tiers := {}
	var combos: Dictionary = f.get("combos", {})
	for k in combos.keys():
		tiers[str(k)] = MoveMastery.word(float(combos[k]))
	return ProRead.target(f.get("pro_tape", []), tiers)


## The first bell: a pro bout carries the read (and whether her plan feints) for the whole night.
static func open(f: Dictionary) -> void:
	var b: Dictionary = f["bout"]
	if not bool(b.get("pro", false)):
		b.erase("pro_read")
		return
	b["pro_read"] = target(f)
	b["pro_feint"] = (b.get("arrows", f.get("arrows", [])) as Array).any(func(a): return str((a as Dictionary).get("move", "")) == "feint")


## The read's price on this exchange (subtracted from the exchange edge): 0 off the read line, unplanned or unfired.
static func edge(b: Dictionary, n: int, arrow: String, pick: Dictionary, roll: float) -> float:
	var t: Dictionary = b.get("pro_read", {})
	if t.is_empty() or not bool(pick.get("planned", false)):
		return 0.0
	return READ_EDGE * ProRead.share(t, n, arrow, bool(b.get("pro_feint", false)), roll)


## The bout on her tape (pro bouts only): the combinations she fired, and how the read line did when she was read.
static func close(f: Dictionary, m: Dictionary) -> void:
	var b: Dictionary = f["bout"]
	if not bool(b.get("pro", false)):
		return
	var t: Dictionary = b.get("pro_read", {})
	var fired := {}
	var in_read := 0
	var won_in_read := 0
	var rounds: Array = m.get("rounds", [])
	for k in rounds.size():
		for x in (rounds[k] as Dictionary).get("exchanges", []):
			var arrow := str(x.get("arrow", ""))
			if not bool(x.get("planned", false)) or str(StrikeMap.move(arrow).get("kind", "")) != "combo":
				continue
			fired[arrow] = int(fired.get(arrow, 0)) + 1
			if not t.is_empty() and arrow == ProRead.round_line(t, k + 1):
				in_read += 1
				won_in_read += int(bool(x.get("won", false)))
	var entry := {"pro": true, "fired": fired, "d": int(b.get("day", 0))}
	if not t.is_empty():
		entry["read"] = {"line": str(t["line"]), "split": bool(t.get("split", false)), "fired_in_read": in_read, "won_in_read": won_in_read}
	var tape: Array = f.get_or_add("pro_tape", [])
	tape.append(entry)
	while tape.size() > TAPE_KEEP:
		tape.pop_front()


## Fight prep's line: what their corner will wait for, in move names. "" when nobody reads her.
static func words(f: Dictionary) -> String:
	if not bool((f.get("bout", {}) as Dictionary).get("pro", false)):
		return ""
	var t := target(f)
	if t.is_empty():
		return ""
	var named := t.duplicate()
	named["line"] = str(StrikeMap.move(str(t["line"])).get("name", t["line"]))
	if bool(t.get("split", false)):
		named["second"] = str(StrikeMap.move(str(t["second"])).get("name", t["second"]))
	return ProRead.words(named)
