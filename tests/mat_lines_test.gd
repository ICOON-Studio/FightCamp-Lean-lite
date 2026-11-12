extends SceneTree
## MATLINES1: the no-gi athlete's plan lines (scripts/rules/MatLines.gd). Prints MAT_LINES failures=N.
## Two different athletes from the game's own makers: Ana (NoGi.athlete, white) and a blue belt from BjjOpp.generate,
## the maker bjj_tree_test uses for a blue. Every chance, slide share and legality is asserted against the BjjTree
## function the match itself calls; the only typed masteries are copies that move one move across a threshold.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjBody := preload("res://scripts/rules/BjjBody.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")

const FIVE := [
	{"at": "side_control_bottom", "edge": "e046", "timing": "at_once"},
	{"at": "back_bottom", "edge": "e031", "timing": "at_once"},
	{"at": "mount_bottom", "edge": "e037", "timing": "frame_first"},
	{"at": "knee_on_belly_bottom", "edge": "e039", "timing": "at_once"},
	{"at": "turtle_bottom", "edge": "e024", "timing": "sit_tight"}]

var _fails := 0
var _rules: Dictionary = {}


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	_rules = BjjTree.rules_for("white")
	var ana := NoGi.athlete()
	var blue := BjjOpp.generate("blue", "Passer", 3)
	_check(str(ana["belt"]) == "white" and str(blue["belt"]) == "blue" and str(ana["stats"]) != str(blue["stats"]),
		"two different athletes (white Ana, blue %s)" % str(blue["name"]))
	_validate(ana)
	_hand_and_brought(ana, blue)
	_draft_escapes(ana)
	_draft_finish(ana)
	_pick(ana, blue)
	_board_call()
	_lines_using()
	_escape_order()
	print("MAT_LINES failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _place(id: String) -> String:
	return str(BjjTree.node(id)["name"])


func _one(f: Dictionary, lines: Array) -> Array:
	return MatLines.validate(f, {"lines": lines}, _rules)


func _ats(lines: Array) -> Array:
	return lines.map(func(l): return str(l["at"]))


## 1. validate: one plain-word problem per refused line, naming the move or the position.
func _validate(ana: Dictionary) -> void:
	var rnc := BjjTree.move_name("rear_naked_choke")
	_check(not BjjTree.usable(BjjTree.mastery(ana, "rear_naked_choke")), "Ana's rear naked choke is Learning (the case)")
	var learn := [{"at": "back_top", "edge": "e029", "timing": "at_once"}]
	var p1: Array = _one(ana, learn)
	_check(p1.size() == 1 and str(p1[0]).contains(rnc), "a Learning move is refused, naming the move (%s)" % str(p1))
	var f15 := ana.duplicate(true)
	f15["bjj"]["rear_naked_choke"] = BjjTree.T["FELT"]
	_check(_one(f15, learn).is_empty(), "the same line is accepted at mastery %.0f" % float(BjjTree.T["FELT"]))
	var p2: Array = _one(ana, [{"at": "mount_bottom", "edge": "e046", "timing": "at_once"}])
	_check(p2.size() == 1 and str(p2[0]).contains(BjjTree.move_name("frame_recover_guard"))
		and str(p2[0]).contains(_place("mount_bottom")), "a line whose position is not the move's start is refused (%s)" % str(p2))
	var fk := ana.duplicate(true)
	fk["bjj"]["kneebar"] = 30.0
	_check(BjjTree.usable(BjjTree.mastery(fk, "kneebar")) and not BjjTree.legal("kneebar", _rules), "kneebar: usable, not legal at white")
	var p3: Array = _one(fk, [{"at": "half_guard_top", "edge": "e103", "timing": "at_once"}])
	_check(p3.size() == 1 and str(p3[0]).contains(BjjTree.move_name("kneebar")), "an illegal move is refused (%s)" % str(p3))
	_check(MatLines.validate(fk, {"lines": [{"at": "half_guard_top", "edge": "e103", "timing": "at_once"}]},
		BjjTree.rules_for("brown")).is_empty(), "the same kneebar line is fine under brown rules")
	var p4: Array = _one(f15, [{"at": "back_top", "edge": "e029", "timing": "frame_first"}])
	_check(p4.size() == 1 and str(p4[0]).contains("Frame first"), "an escape timing on a finish is refused (%s)" % str(p4))
	var p5: Array = _one(ana, [{"at": "side_control_bottom", "edge": "e046", "timing": "set_up"}])
	_check(p5.size() == 1 and str(p5[0]).contains("Set it up"), "a finish timing on an escape is refused (%s)" % str(p5))
	_check(_one(ana, [{"at": "side_control_bottom", "edge": "e046", "timing": ""}]).size() == 1, "a line with no timing is refused")
	var p6: Array = _one(ana, [{"at": "side_control_bottom", "edge": "e046", "timing": "at_once"},
		{"at": "side_control_bottom", "edge": "e047", "timing": "at_once"}])
	_check(p6.size() == 1 and str(p6[0]).contains(_place("side_control_bottom")), "two lines on one position are refused (%s)" % str(p6))
	var p7: Array = _one(ana, [{"at": "back_bottom", "edge": "e999", "timing": "at_once"}])
	_check(p7.size() == 1, "a line on a missing move is refused (%s)" % str(p7))
	var all: Array = p1 + p2 + p3 + p4 + p5 + p6 + p7
	var raw := RegEx.create_from_string("e\\d{3}|_")
	_check(all.all(func(p): return raw.search(str(p)) == null), "every problem is in plain words (no edge or position ids)")
	_check(_one(ana, FIVE).is_empty(), "the five escape lines are valid for Ana")


## 2-3. hand_size and brought.
func _hand_and_brought(ana: Dictionary, blue: Dictionary) -> void:
	_check(MatLines.hand_size("white") == 3 and MatLines.hand_size("blue") == 4, "white brings 3, blue 4")
	_check(MatLines.hand_size("purple") == 5 and MatLines.hand_size("brown") == 5 and MatLines.hand_size("black") == 5,
		"purple and up bring 5")
	var plan := {"lines": FIVE}
	_check(_one(blue, FIVE).is_empty(), "the five escape lines are valid for the blue")
	var w: Array = _ats(MatLines.brought(ana, plan, _rules))
	_check(w == ["back_bottom", "mount_bottom", "side_control_bottom"], "white brings 3 in the escape order, back first (%s)" % str(w))
	var b: Array = _ats(MatLines.brought(blue, plan, _rules))
	_check(b == ["back_bottom", "mount_bottom", "side_control_bottom", "knee_on_belly_bottom"], "blue brings 4 (%s)" % str(b))
	var dup: Array = MatLines.brought(ana, {"lines": [{"at": "side_control_bottom", "edge": "e046", "timing": "at_once"},
		{"at": "side_control_bottom", "edge": "e047", "timing": "frame_first"}]}, _rules)
	_check(dup.size() == 1 and str(dup[0]["edge"]) == "e046", "two lines on one position: the first written one is brought")
	var mixed: Array = MatLines.brought(ana, {"lines": [{"at": "mount_top", "edge": "e032", "timing": "at_once"},
		{"at": "back_top", "edge": "e029", "timing": "at_once"},
		{"at": "side_control_bottom", "edge": "e046", "timing": "at_once"}]}, _rules)
	_check(_ats(mixed) == ["side_control_bottom", "mount_top"], "escapes first, the finish after, a Learning line left home (%s)" % str(_ats(mixed)))


## The escape draft should pick: the best usable legal non-finish edge out of node_id by BjjTree.odds, and its timing
## from BjjTree.p_bad of the same answer.
func _expect_escape(f: Dictionary, node_id: String, opp: Dictionary) -> Array:
	var best: Array = []
	for e in BjjTree.edges_from(node_id):
		var mv := str(e["move"])
		if str(e["odds"]) == "submission" or not BjjTree.legal(mv, _rules) or not BjjTree.usable(BjjTree.mastery(f, mv)):
			continue
		var m_ans: float = BjjTree.answer_mastery(opp, e, _rules)
		var p: float = BjjTree.odds(e, BjjTree.mastery(f, mv), m_ans, _rules)
		if best.is_empty() or p > float(best[1]):
			best = [str(e["id"]), p, BjjTree.p_bad(m_ans)]
	return best


func _line_at(d: Dictionary, at: String) -> Dictionary:
	for l in d["lines"]:
		if str(l["at"]) == at:
			return l
	return {}


func _bare(tree: Dictionary) -> Dictionary:
	return {"id": "nobody", "belt": "white", "mat_classes": 0, "bjj": {}, "tree": tree}


## 4a. draft's escapes: frame_first exactly when a miss slides 1 time in 2 or more.
func _draft_escapes(ana: Dictionary) -> void:
	var owner := BjjOpp.generate("white", "Wrestler", 100)
	var cases := [["an opponent from the game's maker", owner], ["an answer at 15", _bare({"turtle_back_take": 15.0})],
		["an answer at 14", _bare({"turtle_back_take": 14.0})], ["no answer", _bare({})]]
	var timings: Array = []
	for c in cases:
		var opp: Dictionary = c[1]
		var want: Array = _expect_escape(ana, "back_bottom", opp)
		var line := _line_at(MatLines.draft(ana, ["back_bottom"], _rules, opp), "back_bottom")
		_check(not want.is_empty() and not line.is_empty(), "draft writes a back escape against %s" % c[0])
		if line.is_empty() or want.is_empty():
			continue
		var t := "frame_first" if float(want[2]) >= 0.5 else "at_once"
		_check(str(line["edge"]) == str(want[0]) and str(line["timing"]) == t,
			"against %s: %s %s (slide %.2f)" % [c[0], line["edge"], line["timing"], float(want[2])])
		timings.append(str(line["timing"]))
	_check(timings == ["frame_first", "frame_first", "at_once", "at_once"], "both sides of the 1-in-2 slide are drafted (%s)" % str(timings))
	_check(is_equal_approx(BjjTree.p_bad(BjjTree.answer_mastery(_bare({"turtle_back_take": 15.0}), BjjTree.edge("e031"), _rules)), 0.5),
		"the answer at 15 slides exactly 1 in 2")
	var want_sc: Array = _expect_escape(ana, "side_control_bottom", _bare({}))
	var sc := _line_at(MatLines.draft(ana, ["side_control_bottom"], _rules, _bare({})), "side_control_bottom")
	_check(BjjTree.edges_from("side_control_bottom").size() >= 2 and not sc.is_empty() and str(sc["edge"]) == str(want_sc[0]),
		"of two escapes the best chance is drafted (%s)" % str(sc))
	var raw := ana.duplicate(true)
	raw["mat_classes"] = 0
	var none_line := _line_at(MatLines.draft(raw, ["ashi_defend"], _rules), "ashi_defend")
	_check(_expect_escape(raw, "ashi_defend", _bare({})).is_empty() and none_line.is_empty(), "a position with no usable escape gets no line")
	var even := _line_at(MatLines.draft(ana, ["back_bottom"], _rules), "back_bottom")
	_check(not even.is_empty() and str(even["timing"]) == ("frame_first" if BjjTree.p_bad(30.0) >= 0.5 else "at_once"),
		"with no opponent the answer is an even owned 30 (%s)" % str(even))


## The finish draft should pick at the route's end: [edge id, chance at once] by BjjTree.odds with the draft's answer.
func _expect_finish(f: Dictionary, at: String, opp: Dictionary) -> Array:
	var best: Array = []
	for e in BjjTree.edges_from(at):
		var mv := str(e["move"])
		if str(e["odds"]) != "submission" or not BjjTree.legal(mv, _rules) or not BjjTree.usable(BjjTree.mastery(f, mv)):
			continue
		var p: float = BjjTree.odds(e, BjjTree.mastery(f, mv), BjjTree.answer_mastery(opp, e, _rules), _rules)
		if best.is_empty() or p > float(best[1]):
			best = [str(e["id"]), p]
	return best


func _with_route(f: Dictionary, rid: String) -> Dictionary:
	var g := f.duplicate(true)
	g["bjj_plan"] = {"goal": "", "name": rid, "steps": BjjTree.route(rid)["steps"]}
	return g


## 4b. draft's finish at the route's end: set_up exactly when the chance at once is under 0.25.
func _draft_finish(ana: Dictionary) -> void:
	var opp := _bare({})
	var timings: Array = []
	var cg := _with_route(ana, "closed_guard_basics")
	var rnc := _with_route(ana, "kimura_to_back")
	rnc["bjj"]["rear_naked_choke"] = 30.0
	var bf := _with_route(ana, "butterfly_slx")
	for c in [[cg, "mount_top"], [rnc, "back_top"], [bf, "side_control_top"]]:
		var f: Dictionary = c[0]
		var d := MatLines.draft(f, [], _rules, opp)
		_check(d["steps"] == f["bjj_plan"]["steps"], "draft keeps the A-game route %s" % f["bjj_plan"]["name"])
		var want: Array = _expect_finish(f, str(c[1]), opp)
		var line := _line_at(d, str(c[1]))
		_check(not want.is_empty() and not line.is_empty(), "%s: a finish is drafted at %s" % [f["bjj_plan"]["name"], c[1]])
		if want.is_empty() or line.is_empty():
			continue
		var t := "set_up" if float(want[1]) < 0.25 else "at_once"
		_check(str(line["edge"]) == str(want[0]) and str(line["timing"]) == t,
			"%s: %s %s (at once %.3f)" % [f["bjj_plan"]["name"], line["edge"], line["timing"], float(want[1])])
		timings.append(str(line["timing"]))
	_check(timings.has("set_up") and timings.has("at_once"), "both sides of 0.25 are drafted (%s)" % str(timings))
	_check(MatLines.route_end(BjjTree.route("butterfly_slx")["steps"]) == "side_control_top",
		"a route ending on a pass finishes where the pass lands")
	var many := MatLines.draft(cg, ["back_bottom", "mount_bottom", "side_control_bottom"], _rules, opp)
	_check(_ats(many["lines"]) == ["back_bottom", "mount_bottom", "side_control_bottom", "mount_top"],
		"Coach writes every line, three escapes and the finish (%s)" % str(_ats(many["lines"])))
	_check(_ats(MatLines.brought(cg, many, _rules)) == ["back_bottom", "mount_bottom", "side_control_bottom"],
		"the white hand brings 3 of the 4")
	_check(many["board"] == {"level": "steady", "ahead": "save", "behind": "push"}, "the drafted board: level steady, ahead save, behind push")
	_check(MatLines.validate(cg, many, _rules).is_empty(), "the draft passes validate")


func _st(at: String, g0: float, g1: float) -> Dictionary:
	return {"at": at, "grip": [g0, g1]}


## 5. pick: the line's edge on its own position only; {} everywhere else and with no lines.
func _pick(ana: Dictionary, blue: Dictionary) -> void:
	var a := ana.duplicate(true)
	var b := blue.duplicate(true)
	var ctx := {"f": [a, b], "rules": _rules}
	var nodes: Array = BjjTree.data()["nodes"].keys()
	_check(nodes.size() == 49, "the tree has 49 nodes (%d)" % nodes.size())
	a["bjj_plan"] = {"lines": [{"at": "side_control_bottom", "edge": "e046", "timing": "frame_first"}]}
	var bad := 0
	for n in nodes:
		var pk: Dictionary = MatLines.pick(ctx, _st(str(n), 0.0, 0.0), 0)
		if str(n) == "side_control_bottom":
			_check(pk.has("e") and pk.has("why") and str(pk["e"].get("id", "")) == "e046" and str(pk["why"]) == "line",
				"pick returns the line's edge on its own position (%s)" % str(pk.get("e", {}).get("id", "")))
		elif not pk.is_empty():
			bad += 1
	_check(bad == 0, "pick returns {} on the other 48 nodes (%d did not)" % bad)
	for plan in [{"lines": []}, {}, {"lines": [{"at": "back_top", "edge": "e029", "timing": "at_once"}]}]:
		a["bjj_plan"] = plan
		var hits := 0
		for n in nodes:
			if not MatLines.pick(ctx, _st(str(n), 0.0, 0.0), 0).is_empty():
				hits += 1
		_check(hits == 0, "no brought line %s: {} on all 49 nodes" % str(plan))
	# Side 1 reads its own fighter, the mirrored position and its own stack.
	a["bjj_plan"] = {}
	b["bjj_plan"] = {"lines": [{"at": "side_control_bottom", "edge": "e046", "timing": "frame_first"}]}
	var top := BjjTree.mirror("side_control_bottom")
	var p1: Dictionary = MatLines.pick(ctx, _st(top, 5.0, 0.0), 1)
	_check(str(p1.get("e", {}).get("id", "")) == "e046" and bool(p1.get("wait", false)), "side 1: the line on its mirrored position, waiting on its own stack")
	_check(not bool(MatLines.pick(ctx, _st(top, 0.0, 2.0), 1).get("wait", true)), "side 1 at its own stack 2 goes")
	_check(MatLines.pick(ctx, _st(top, 0.0, 0.0), 0).is_empty() and MatLines.pick(ctx, _st("side_control_bottom", 0.0, 0.0), 1).is_empty(),
		"side 0 with no lines and side 1 on top get {}")
	# Waiting on the hand-fighting stack.
	for c in [["side_control_bottom", "e046", "frame_first", [true, true, false]], ["side_control_bottom", "e047", "at_once", [false, false, false]],
			["mount_top", "e032", "set_up", [true, true, false]], ["mount_top", "e032", "at_once", [false, false, false]]]:
		a["bjj_plan"] = {"lines": [{"at": c[0], "edge": c[1], "timing": c[2]}]}
		var got: Array = []
		for g in [0.0, 1.0, 2.0]:
			var pk: Dictionary = MatLines.pick(ctx, _st(str(c[0]), g, 0.0), 0)
			got.append(bool(pk.get("wait", null)) if pk.has("wait") and str(pk["e"].get("id", "")) == str(c[1]) else null)
		_check(got == c[3], "%s waits at stacks 0 / 1 / 2: %s" % [c[2], str(got)])
	a["bjj_plan"] = {"lines": [{"at": "side_control_bottom", "edge": "e046", "timing": "sit_tight"}]}
	var sit: Dictionary = MatLines.pick(ctx, _st("side_control_bottom", 2.0, 0.0), 0)
	_check(bool(sit.get("sit", false)) and str(sit.get("why", "")) == "line" and sit.has("e") and (sit["e"] as Dictionary).is_empty(),
		"sit_tight sits and attempts nothing (%s)" % str(sit))


## 6. board_call: each score reads its own row; no board = the fighter's own call.
func _board_call() -> void:
	_check(MatLines.BOARD_TO_CALLS.values().all(func(k): return BjjBody.CALLS.has(k)), "every board word maps to a mat call")
	var plan := {"board": {"level": "push", "ahead": "steady", "behind": "save"}}
	var got := [MatLines.board_call(plan, 2, 2), MatLines.board_call(plan, 4, 2), MatLines.board_call(plan, 0, 2)]
	_check(got == ["hunt", "steady", "hold"], "level / ahead / behind read their own rows (%s)" % str(got))
	var plan2 := {"board": {"level": "save", "ahead": "push", "behind": "steady"}}
	var got2 := [MatLines.board_call(plan2, 0, 0), MatLines.board_call(plan2, 3, 0), MatLines.board_call(plan2, 0, 3)]
	_check(got2 == ["hold", "hunt", "steady"], "a second board reads its own rows (%s)" % str(got2))
	_check(MatLines.board_call({}, 0, 0, {"mat_call": "hunt"}) == "hunt" and MatLines.board_call({}, 4, 0, {"mat_call": "hold"}) == "hold",
		"no board: the fighter's own call")
	_check(MatLines.board_call({}, 0, 0, {}) == "steady" and MatLines.board_call({}, 0, 0) == "steady", "no board, no call: steady")


## 7. lines_using.
func _lines_using() -> void:
	var plan := {"lines": [{"at": "mount_top", "edge": "e032", "timing": "set_up"},
		{"at": "side_control_bottom", "edge": "e046", "timing": "at_once"}, {"at": "side_control_top", "edge": "e042", "timing": "at_once"}]}
	var am: Array = MatLines.lines_using(plan, "americana")
	_check(am.size() == 2 and str(am[0]["edge"]) == "e032" and str(am[1]["edge"]) == "e042", "lines_using finds both americana lines")
	_check(MatLines.lines_using(plan, "kimura").is_empty() and MatLines.lines_using({}, "americana").is_empty(), "lines_using: nothing for kimura or no lines")


## The escape order: every id in the tree; six "bottom" positions, then the two leg positions ("defend" in the tree).
func _escape_order() -> void:
	var order: Array = MatLines.ESCAPE_ORDER
	_check(order.size() == 8, "eight positions in the escape order")
	for i in order.size():
		var n: Dictionary = BjjTree.node(str(order[i]))
		var ok: bool = not n.is_empty() and (str(n["side"]) == "bottom" if i < 6
			else str(n["side"]) == "defend" and ["ashi", "saddle"].has(str(n["family"])))
		_check(ok, "escape order %s exists (%s)" % [order[i], str(n.get("side", "missing"))])
