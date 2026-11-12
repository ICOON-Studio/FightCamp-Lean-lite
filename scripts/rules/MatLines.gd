extends RefCounted
## MATLINES1 (ops/research/MATPLAN_MAP_S433.md sections 4.1, 4.2, 4.5, build task M2): the no-gi athlete's plan lines.
## The plan shape (stored on the fighter as f["bjj_plan"], the three old keys unchanged, the new keys optional):
## {goal, steps, name, opening, lines: [{at, edge, timing}], board: {level, ahead, behind}}
## - opening: "pull" / "shoot" / "snap" / "wait"
## - a line: at = a node id, edge = an edge id leaving that node, timing by kind:
##   ESCAPE (at is a position underneath): "at_once" / "frame_first" / "sit_tight"
##   FINISH (the edge is a submission): "at_once" / "set_up"
## - board: each of level / ahead / behind is "push" / "steady" / "save"
## A finish is read from the edge's `odds` ("submission"), the same field BjjBeat and BjjWalk read. The one edge where
## that differs from the move's kind is e026 (kimura: move kind "grip_and_submission", edge odds "submission").
## Pure static; preloads BjjTree.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")

## The escape order: worst position first. The first six are "bottom" positions; the two leg positions are "defend"
## in bjj_tree.json (side "defend", families ashi and saddle).
const ESCAPE_ORDER := ["back_bottom", "mount_bottom", "side_control_bottom", "knee_on_belly_bottom",
	"north_south_bottom", "turtle_bottom", "ashi_defend", "saddle_defend"]

## Valid timing words by line kind.
const ESCAPE_TIMINGS := ["at_once", "frame_first", "sit_tight"]
const FINISH_TIMINGS := ["at_once", "set_up"]
## The words a player reads for each timing.
const TIMING_WORDS := {"at_once": "At once", "frame_first": "Frame first", "sit_tight": "Sit tight", "set_up": "Set it up"}

## Board row -> BjjBody.CALLS key (push = hunt, save = hold). The test checks every value is a CALLS key.
const BOARD_TO_CALLS := {"push": "hunt", "steady": "steady", "save": "hold"}

## Slide share at or above which an escape frames first; a finish's chance at once below which it is set up (map 4.2).
const FRAME_FIRST_AT := 0.5
const SET_UP_BELOW := 0.25
## The even owned answer draft assumes when no opponent is given.
const EVEN_ANSWER := 30.0
## The hand-fighting stack a frame_first / set_up line waits for (BjjBeat.walk's st["grip"][s]).
const WAIT_STACK := 2.0


## True when the edge is a finish (a submission).
static func _is_finish(e: Dictionary) -> bool:
	return str(e.get("odds", "")) == "submission"


static func _place(node_id: String) -> String:
	return str(BjjTree.node(node_id).get("name", node_id))


static func _words(timings: Array) -> String:
	var out: String = ""
	for i in timings.size():
		if i > 0:
			out += " or " if i == timings.size() - 1 else ", "
		out += str(TIMING_WORDS[timings[i]])
	return out


## The plain-word problem with one line, or "" when it is fine (the shared-position check is the caller's).
static func _line_problem(f: Dictionary, line: Dictionary, rules: Dictionary) -> String:
	var at: String = str(line.get("at", ""))
	var e: Dictionary = BjjTree.edge(str(line.get("edge", "")))
	if e.is_empty():
		return "A line on %s uses a move that does not exist" % _place(at)
	var mv: String = str(e["move"])
	var mname: String = BjjTree.move_name(mv)
	if str(e["from"]) != at:
		return "%s does not start from %s" % [mname, _place(at)]
	if not BjjTree.usable(BjjTree.mastery(f, mv)):
		return "%s is still Learning: drill it before bringing it" % mname
	if not BjjTree.legal(mv, rules):
		return "%s is not allowed at this belt" % mname
	var timing: String = str(line.get("timing", ""))
	var ok_t: Array = FINISH_TIMINGS if _is_finish(e) else ESCAPE_TIMINGS
	if not ok_t.has(timing):
		var kind: String = "an escape" if _is_finish(e) else "a finish"
		if TIMING_WORDS.has(timing):
			return "%s is for %s; for %s pick %s" % [TIMING_WORDS[timing], kind, mname, _words(ok_t)]
		return "Pick a timing for %s: %s" % [mname, _words(ok_t)]
	return ""


## 1. validate(f, plan, rules) -> Array of plain-word problems (empty = fine).
static func validate(f: Dictionary, plan: Dictionary, rules: Dictionary) -> Array:
	var problems: Array = []
	var seen_at: Dictionary = {}
	for line in plan.get("lines", []):
		var at: String = str(line.get("at", ""))
		var p: String = _line_problem(f, line, rules)
		if p != "":
			problems.append(p)
		if seen_at.has(at):
			problems.append("Two lines on %s: keep one" % _place(at))
		seen_at[at] = true
	return problems


## 2. hand_size(belt) -> int: lines brought besides the A-game, from BjjTree.IQ (40 -> 3, 55 -> 4, 70 or more -> 5).
static func hand_size(belt: String) -> int:
	var iq: float = float(BjjTree.IQ.get(belt, BjjTree.IQ["white"]))
	if iq >= float(BjjTree.IQ["purple"]):
		return 5
	if iq >= float(BjjTree.IQ["blue"]):
		return 4
	return 3


## 3. brought(f, plan, rules) -> Array: the valid lines in escape order, worst first, then the finish lines in written
## order, cut to hand_size. With two valid lines on one position the first written one is kept.
static func brought(f: Dictionary, plan: Dictionary, rules: Dictionary) -> Array:
	var lines: Array = plan.get("lines", [])
	var valid: Dictionary = {}
	var order: Array = []
	for line in lines:
		var at: String = str(line.get("at", ""))
		if valid.has(at) or _line_problem(f, line, rules) != "":
			continue
		valid[at] = line
		order.append(at)
	var out: Array = []
	var limit: int = hand_size(str(f.get("belt", "white")))
	for node_id in ESCAPE_ORDER:
		if valid.has(node_id):
			out.append(valid[node_id])
	for at in order:
		if not ESCAPE_ORDER.has(at):
			out.append(valid[at])
	return out.slice(0, limit)


## The chance and the answer draft reads for one edge (Ana's mastery against the opponent's answer, else an even 30).
static func _rate(f: Dictionary, e: Dictionary, rules: Dictionary, opp: Dictionary) -> Array:
	var m_ans: float = EVEN_ANSWER if opp.is_empty() else BjjTree.answer_mastery(opp, e, rules)
	return [BjjTree.odds(e, BjjTree.mastery(f, str(e["move"])), m_ans, rules), m_ans]


## The best usable, legal edge leaving node_id of the wanted kind: [edge, chance, answer] or [] when none.
static func _best(f: Dictionary, node_id: String, finish: bool, rules: Dictionary, opp: Dictionary) -> Array:
	var best: Array = []
	for e in BjjTree.edges_from(node_id):
		if _is_finish(e) != finish:
			continue
		var mv: String = str(e["move"])
		if not BjjTree.legal(mv, rules) or not BjjTree.usable(BjjTree.mastery(f, mv)):
			continue
		var r: Array = _rate(f, e, rules, opp)
		if best.is_empty() or float(r[0]) > float(best[1]):
			best = [e, float(r[0]), float(r[1])]
	return best


## The position the A-game route ends on: the `ok` of the last step, or its `from` when that step is the tap itself.
static func route_end(steps: Array) -> String:
	if steps.is_empty():
		return ""
	var last_e: Dictionary = BjjTree.edge(str(steps.back()))
	var end_at: String = str(last_e.get("ok", ""))
	if BjjTree.is_ending(end_at):
		end_at = str(last_e.get("from", ""))
	return end_at


## 4. draft(f, leaks, rules, opp = {}) -> Dictionary: Coach's draft of lines and board. Every leak with a usable escape
## gets a line and the route's end gets a finish; brought() decides which of them the hand takes.
static func draft(f: Dictionary, leaks: Array, rules: Dictionary, opp: Dictionary = {}) -> Dictionary:
	var lines: Array = []
	for node_id in leaks:
		var b: Array = _best(f, str(node_id), false, rules, opp)
		if b.is_empty():
			continue
		var t: String = "frame_first" if BjjTree.p_bad(float(b[2])) >= FRAME_FIRST_AT else "at_once"
		lines.append({"at": str(node_id), "edge": str(b[0]["id"]), "timing": t})
	var steps: Array = BjjTree.plan_of(f, rules)
	var end_at: String = route_end(steps)
	if end_at != "" and not lines.any(func(l): return str(l.get("at", "")) == end_at):
		var fb: Array = _best(f, end_at, true, rules, opp)
		if not fb.is_empty():
			var ft: String = "set_up" if float(fb[1]) < SET_UP_BELOW else "at_once"
			lines.append({"at": end_at, "edge": str(fb[0]["id"]), "timing": ft})
	var old: Dictionary = f.get("bjj_plan", {})
	return {"goal": str(old.get("goal", "")), "steps": steps, "name": str(old.get("name", "")),
		"lines": lines, "board": {"level": "steady", "ahead": "save", "behind": "push"}}


## 5. pick(ctx, st, s) -> Dictionary: called before the walk's own choice. On a position with a brought line for side s:
## {e, why = "line", wait} in BjjWalk.choose's shape; wait while timing is frame_first / set_up and st["grip"][s] (the
## hand-fighting stack BjjBeat.walk builds on a WORK beat) is under 2. sit_tight: {e = {}, why = "line", sit = true}, no
## attempt (BjjBeat.walk reads an empty e as WORK). Any other position, or no lines: {} (today's path unchanged).
static func pick(ctx: Dictionary, st: Dictionary, s: int) -> Dictionary:
	var f: Dictionary = ctx["f"][s]
	var plan: Dictionary = f.get("bjj_plan", {})
	if (plan.get("lines", []) as Array).is_empty():
		return {}
	var own: String = str(st["at"]) if s == 0 else BjjTree.mirror(str(st["at"]))
	var line: Dictionary = {}
	for l in brought(f, plan, ctx["rules"]):
		if str(l.get("at", "")) == own:
			line = l
			break
	if line.is_empty():
		return {}
	var timing: String = str(line.get("timing", ""))
	if timing == "sit_tight":
		return {"e": {}, "why": "line", "sit": true}
	var waits: bool = (timing == "frame_first" or timing == "set_up") and float(st["grip"][s]) < WAIT_STACK
	return {"e": BjjTree.edge(str(line["edge"])), "why": "line", "wait": waits}


## 6. board_call(plan, my_points, their_points, f = {}) -> String: the BjjBody.CALLS key (hunt / steady / hold) for the
## board row of the score now (level when equal). A plan with no board returns the fighter's own mat_call, else "steady".
static func board_call(plan: Dictionary, my_points: int, their_points: int, f: Dictionary = {}) -> String:
	var board: Dictionary = plan.get("board", {})
	if board.is_empty():
		return str(f.get("mat_call", "steady"))
	var row: String = "level"
	if my_points > their_points:
		row = "ahead"
	elif my_points < their_points:
		row = "behind"
	return str(BOARD_TO_CALLS.get(str(board.get(row, "steady")), "steady"))


## 7. lines_using(plan, move_id) -> Array: the lines whose edge uses that move (for the Playbook's chip).
static func lines_using(plan: Dictionary, move_id: String) -> Array:
	var out: Array = []
	for line in plan.get("lines", []):
		var e: Dictionary = BjjTree.edge(str(line.get("edge", "")))
		if str(e.get("move", "")) == move_id:
			out.append(line)
	return out
