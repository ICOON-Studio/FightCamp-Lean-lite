extends RefCounted
## S458 PROREAD1 - professionals get read: across bouts, the opponent's corner studies the last two professional
## fights and waits for the punch we throw most. A boxer with two real weapons is harder to wait for; a feint
## makes the corner bite early. Pure static; ZERO preloads. The caller multiplies shares by the size READ1 measures.

const SPLIT_AT := 0.8
const FEINT_LINE := "Feint"
const FEINT_MISS := 0.5
const PROOF_FIRED := 3
const HELD_TIERS := ["Sharp", "Signature"]


## A bout record the caller keeps per bout: {"pro": bool, "fired": {line: int}} and, once read,
## "read": {"line": String, "split": bool, "fired_in_read": int, "won_in_read": int}.

## target: the line the opponent's corner expects from the last two professional bouts (one if only one).
## {} when there is no earlier professional bout (amateurs never read; the debut is never read).
static func target(history: Array, tiers: Dictionary) -> Dictionary:
	var pro_bouts: Array = []
	for bout in history:
		var bd: Dictionary = bout as Dictionary
		if bd.get("pro", false):
			pro_bouts.append(bd)
	if pro_bouts.is_empty():
		return {}
	var recent: Array = []
	if pro_bouts.size() >= 2:
		recent.append(pro_bouts[pro_bouts.size() - 2])
	recent.append(pro_bouts[pro_bouts.size() - 1])
	var counts: Dictionary = {}
	for r in recent:
		var rd: Dictionary = r as Dictionary
		var fired: Dictionary = rd.get("fired", {})
		for line in fired.keys():
			var k: String = str(line)
			counts[k] = int(counts.get(k, 0)) + int(fired.get(line, 0))
	if counts.is_empty():
		return {}   # S458 collect: no fired lines on tape = nothing to wait for
	var first_line: String = ""
	var first_count: int = 0
	for line in counts.keys():
		var c: int = int(counts.get(line, 0))
		if c > first_count or (c == first_count and (first_line == "" or str(line) < first_line)):
			first_line = str(line)
			first_count = c
	var second_line: String = ""
	var second_count: int = 0
	for line in counts.keys():
		if str(line) == first_line:
			continue
		var tier: String = str(tiers.get(str(line), ""))
		if not HELD_TIERS.has(tier):
			continue
		var c: int = int(counts.get(line, 0))
		# S458 collect: the MOST fired held line qualifies (ties alphabetical), per the brief
		if c >= int(ceil(float(first_count) * SPLIT_AT)):
			if c > second_count or (c == second_count and (second_line == "" or str(line) < second_line)):
				second_line = str(line)
				second_count = c
	return {"line": first_line, "second": second_line, "split": second_line != "", "count": first_count}


## round_line: the line for this round. "" for {}; the line when not split; split: odd rounds "line", even "second".
static func round_line(t: Dictionary, round_n: int) -> String:
	if t.is_empty():
		return ""
	if not t.get("split", false):
		return str(t.get("line", ""))
	if round_n % 2 == 1:
		return str(t.get("line", ""))
	return str(t.get("second", ""))


## share: how much of the read's cost this firing pays. 0.0 when off-target or feinted-and-missed;
## 1.0 on target without split; 0.5 when split.
static func share(t: Dictionary, round_n: int, line: String, feinted: bool, roll: float) -> float:
	if t.is_empty():
		return 0.0
	if line != round_line(t, round_n):
		return 0.0
	if feinted and roll < FEINT_MISS:
		return 0.0
	if t.get("split", false):
		return 0.5
	return 1.0


## proof: READ-PROOF - the last two professional bouts with a "read" entry each pass: split is true, OR
## fired_in_read >= PROOF_FIRED and won_in_read * 2 >= fired_in_read. False with fewer than two such bouts.
static func proof(history: Array) -> bool:
	var read_pro: Array = []
	for bout in history:
		var bd: Dictionary = bout as Dictionary
		if not bd.get("pro", false):
			continue
		if bd.has("read"):
			read_pro.append(bd)
	if read_pro.size() < 2:
		return false
	var prev: Dictionary = read_pro[read_pro.size() - 2]
	var last: Dictionary = read_pro[read_pro.size() - 1]
	return _read_passes(prev) and _read_passes(last)


static func _read_passes(r: Dictionary) -> bool:
	var rd: Dictionary = r.get("read", {})
	if rd.get("split", false):
		return true
	var fired: int = int(rd.get("fired_in_read", 0))
	var won: int = int(rd.get("won_in_read", 0))
	return fired >= PROOF_FIRED and won * 2 >= fired


## words: the corner's sentence. "" for {}; names the line; split names both; no pronouns, no names.
static func words(t: Dictionary) -> String:
	if t.is_empty():
		return ""
	var ln: String = str(t.get("line", ""))
	if not t.get("split", false):
		return "Their corner will wait for your " + ln
	var sec: String = str(t.get("second", ""))
	return "Their corner will switch between your " + ln + " and your " + sec + ", round by round"
