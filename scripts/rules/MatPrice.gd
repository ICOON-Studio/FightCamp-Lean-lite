extends RefCounted
## MATPRICE1 (ops/research/TASK_MATPRICE1.md): the price of one line of the no-gi grappler's plan.
## Every number comes from the functions the match itself calls (BjjTree.odds, BjjBody.spend, TheRead.looks_needed):
## no second formula, no typed multiplier. The module assembles them for one line and words them for the screen.
## Pure static; preloads BjjTree, BjjBody, BjjBeat, TheRead, MatLines (none preload this).

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjBody := preload("res://scripts/rules/BjjBody.gd")
const BjjBeat := preload("res://scripts/rules/BjjBeat.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")

## Grade cut points on the body shift (ESTIMATE; the map marks them). Good at +0.08 or more, Poor at -0.08 or less.
const GRADE_GOOD_AT := 0.08
const GRADE_POOR_AT := -0.08
## The number of previous scripted tries whose looks count toward read_mult (the 3rd try sees 2 prior tries). Each try
## shows the opponent TheRead.LOOKS_PER_EXCHANGE looks, as BjjWalk.attempt adds them (REVIEW3: read, never retyped).
const READ_TRIES_BEFORE := 2


## The answer level AS KNOWN: the best legal answer the film has found (`known`: answer move id -> level; a found level 0
## is "no answer", which BjjTree.odds divides by the tree's floor D_NONE), or -1 when none of this edge's answers is found.
## REVIEW3: a hidden answer is NEVER read from the opponent (the delivery used BjjTree.answer_mastery(opp), which showed the
## player the hidden level); price() rates it as an even owned answer, MatLines.EVEN_ANSWER.
static func _found_level(e: Dictionary, rules: Dictionary, known: Dictionary) -> float:
	var best: float = -1.0
	for a in e.get("answers", []):
		var aid := str(a)
		if BjjTree.legal(aid, rules) and known.has(aid):
			best = maxf(best, float(known[aid]))
	return best


## The chance for one edge at the given answer level, with no read or chain (the base chance for the line).
static func _base_chance(e: Dictionary, m_att: float, m_ans: float, rules: Dictionary) -> float:
	return BjjTree.odds(e, m_att, m_ans, rules)


## The timing-adjusted chance: frame_first and set_up add two hand-fighting stacks on the logit; at_once is bare; sit_tight is 0.
static func _timed_chance(chance: float, timing: String) -> float:
	if timing == "sit_tight":
		return 0.0
	if timing == "at_once":
		return chance
	if timing == "frame_first" or timing == "set_up":
		return BjjTree.logit_add(chance, 2.0 * float(BjjTree.T["GRIP_W"]))
	return chance


## [what a try costs, what a miss ADDS] out of 100, by BjjBody.spend (the walk's own call) for this fighter's cardio.
## frame_first / set_up add two WORK beats as BjjBeat.walk charges one: WORK_GAS x (BEAT2_S / OLD_BEAT) x drain.
## REVIEW3: the delivery re-derived the cost, mapped unknown kinds to "transition", left out the beat factor (3x too much
## for the two work beats) and returned the miss as a total where the brief and the map ("a miss 2.8 more") ask what it adds.
static func _tank_cost(e: Dictionary, cardio: float, timing: String) -> Array:
	if BjjTree.is_base(str(e["move"])):
		return [0.0, 0.0]
	var kind := str(e.get("odds", ""))
	var hit := 1.0 - BjjBody.spend(1.0, kind, true, cardio)
	var miss := 1.0 - BjjBody.spend(1.0, kind, false, cardio)
	var setup := 0.0
	if timing == "frame_first" or timing == "set_up":
		setup = 2.0 * BjjBeat.WORK_GAS * float(BjjTree.T["BEAT2_S"]) / BjjBeat.OLD_BEAT * BjjBody.drain(cardio)
	return [100.0 * (hit + setup), 100.0 * (miss - hit)]


## The read multiplier by the 3rd scripted try: the factor the chance loses to the opponent's accumulated read.
## At white (IQ 40, 16 looks needed): 6 looks / 16 = 0.375 read; 1 / (1 + READ_W x 0.375) = 0.816 ~ 0.82.
## REVIEW3: the opponent's IQ as the walk reads it (BjjTree.watcher_iq: its own iq, else its belt's), the read capped at 1.
static func _read_mult(opp: Dictionary) -> float:
	var looks := TheRead.looks_needed(BjjTree.watcher_iq(opp), false)
	if looks <= 0.0:
		return 1.0
	var read := minf(1.0, float(READ_TRIES_BEFORE) * TheRead.LOOKS_PER_EXCHANGE / looks)
	return 1.0 / (1.0 + float(BjjTree.T["READ_W"]) * read)


## The grade word from the body shift: Good at +0.08 or more, Poor at -0.08 or less, OK between.
static func _grade(shift: float) -> String:
	if shift >= GRADE_GOOD_AT:
		return "Good"
	if shift <= GRADE_POOR_AT:
		return "Poor"
	return "OK"


## The price of one line: every value from the functions the match itself calls.
## f: the attacker; opp: the opponent (may be empty for "vs the field"); line: {at, edge, timing, chain?};
## rules: BjjTree.rules_for(...); known: {move_id: level} for film-found answers (empty = even 30).
## Returns a Dictionary with: chance, chance_lo, chance_hi, chance_timed, points, lands_at, miss_at, miss_gives,
## miss_slides, tank, tank_miss, time_s, read_mult, grade, level, level_word, chips.
static func price(f: Dictionary, opp: Dictionary, line: Dictionary, rules: Dictionary, known: Dictionary = {}) -> Dictionary:
	var e := BjjTree.edge(str(line.get("edge", "")))
	if e.is_empty():
		return {}
	var mv := str(e["move"])
	var m_att := BjjTree.mastery(f, mv)
	var found := _found_level(e, rules, known)
	var m_ans: float = found if found >= 0.0 else MatLines.EVEN_ANSWER
	var chain := bool(line.get("chain", false))
	var timing := str(line.get("timing", "at_once"))

	# Chance: the base odds with the known answer; chance_lo/hi bracket the range while the answer is hidden.
	var chance := BjjTree.odds(e, m_att, m_ans, rules, chain)
	# Hidden: chance_lo = an even owned answer (30), chance_hi = no answer (level 0: odds divides by the floor D_NONE; the
	# delivery passed D_NONE itself as a mastery level). Found: lo == hi == chance.
	var chance_lo := chance
	var chance_hi := chance
	if found < 0.0:
		chance_hi = BjjTree.odds(e, m_att, 0.0, rules, chain)

	# Timed chance: frame_first / set_up add two hand-fighting stacks; sit_tight is 0.
	var chance_timed := _timed_chance(chance, timing)

	# Points and landing: the edge's points and the node it gives.
	var points := int(e.get("points", 0))
	var lands_at := str(e.get("ok", ""))

	# Miss: where a miss lands, what it gives, and how often it slides there.
	var miss_at := str(e.get("bad", ""))
	var miss_gives := int(e.get("bad_gives", 0))
	var miss_slides := BjjTree.p_bad(m_ans)

	# Tank: what a try costs out of 100, and what a miss adds. sit_tight spends nothing.
	var cardio := BjjBody.attr(f, "cardio")
	var tank_arr := _tank_cost(e, cardio, timing) if timing != "sit_tight" else [0.0, 0.0]
	var tank := float(tank_arr[0])
	var tank_miss := float(tank_arr[1])

	# Time: 0 for at_once, two beats for frame_first / set_up, 0 for sit_tight.
	var time_s := 0.0
	if timing == "frame_first" or timing == "set_up":
		time_s = 2.0 * float(BjjTree.T["BEAT2_S"])

	# Read: the factor the line loses by the 3rd scripted try.
	var rm := _read_mult(opp) if not opp.is_empty() else 1.0

	# Grade: from the body shift for this move against this opponent.
	var a_attrs := BjjBody.attrs(f)
	var d_attrs := BjjBody.attrs(opp) if not opp.is_empty() else BjjBody.attrs(f)
	var sh := BjjBody.shift(e, a_attrs, d_attrs)
	var grade := _grade(sh)

	# Level: the fighter's mastery and state word.
	var level := m_att
	var level_word := BjjTree.state(m_att)

	# Chips: six short plain strings for the screen, in order: chance, points, miss, tank, read, time.
	var chips := _chips(chance_timed, points, lands_at, miss_at, miss_gives, miss_slides, tank, tank_miss, rm, time_s, timing)

	return {"chance": chance, "chance_lo": chance_lo, "chance_hi": chance_hi, "chance_timed": chance_timed,
		"points": points, "lands_at": lands_at, "miss_at": miss_at, "miss_gives": miss_gives, "miss_slides": miss_slides,
		"tank": tank, "tank_miss": tank_miss, "time_s": time_s, "read_mult": rm, "grade": grade,
		"level": level, "level_word": level_word, "chips": chips}


## The six chip strings for the screen: chance, points, miss, tank, read, time.
## The tank chip uses "Tank" (the word the mat screens show; see ComboStrip.gd tank.name = "Tank").
static func _chips(chance_timed: float, points: int, lands_at: String, miss_at: String, miss_gives: int,
		miss_slides: float, tank: float, tank_miss: float, read_mult: float, time_s: float, timing: String) -> Array:
	var chips: Array = []
	# Chance: "<round(chance_timed x 100)> in 100"
	chips.append("%d in 100" % roundi(chance_timed * 100.0))
	# Points: "+N, to <place>" or "No points"
	if points > 0:
		chips.append("+%d, to %s" % [points, _place_name(lands_at)])
	else:
		chips.append("No points")
	# Miss: "miss: <place>, <gives> (<slide> in 10)" or "miss: reset"
	if miss_at == "" or miss_slides <= 0.001:
		chips.append("miss: reset")
	else:
		chips.append("miss: %s, %d (%d in 10)" % [_place_name(miss_at), miss_gives, roundi(miss_slides * 10.0)])
	# Tank: "Tank -N, -M on a miss" (the map's chip: what a try costs, and the whole cost of a miss)
	chips.append("Tank -%d, -%d on a miss" % [roundi(tank), roundi(tank + tank_miss)])
	# Read: "read x0.NN by the 3rd try"
	chips.append("read x%.2f by the 3rd try" % read_mult)
	# Time: "N s" or "No time"
	if time_s > 0.0:
		chips.append("%.0f s" % time_s)
	else:
		chips.append("No time")
	return chips


## The place name for a node id (the node's name, or the id when the node is missing).
static func _place_name(node_id: String) -> String:
	var n := BjjTree.node(node_id)
	if n.is_empty():
		return node_id
	return str(n.get("name", node_id))
