extends SceneTree
## S397 BJJ realism probe (operator: "is it deep enough for realistic results"): measures what decides a no-gi match in
## both engines, by belt gap and by style, so the numbers can be set against the real ones (ops/research/BJJ_REALISM_S397.md).
##  WALK  - BjjWalk.walk (the simulated opens): two BjjOpp.generate athletes, belt lo vs belt hi, each on its go-to route,
##          the LOWER belt's rules and clock (an open superfight / a gym roll: the safe rules). Win share of the higher belt,
##          finishes by submission / points / advantages / referee, mean points.
##  STYLE - the walk at one belt, style vs style (does the style change who wins?).
##  LIVE  - BjjMatch.odds (the live belt match) on a class-level chain: the GrappleMap positions folded into their classes
##          (standing, guard, half guard, side control, mount, back), each side's moves out by kind at its own mastery of
##          that kind, picked as the live match picks (best expected points; the opponent one of its best two). It is the
##          live engine's odds and gas maths, NOT the GrappleMap graph (that needs the 3D browser): it says what the odds
##          formula does with a belt gap.
##  INSIDE - the walk inside one belt: a four-stripe (class share 1.0) against a fresh athlete (0.0) of the same belt.
## Run: godot --headless --path . --script res://tools/bjj_realism_probe.gd -- [n=200] [parts=walk,style,inside,live]
##   [belts=white,blue,...] [style_belts=white,purple] [KEY=v ...]   KEY = a BjjTree.T / BjjOpp.T key (a range as lo:hi)
## Prints PROBE lines and BAR lines (S398: the bars of BJJ_REALISM_S397.md 2); seeded, the same arguments print the same table.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const BELTS := ["white", "blue", "purple", "brown", "black"]
## The walk table, kept for the BAR lines: "lo|hi" -> tally.
static var cells: Dictionary = {}


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	var n := 200
	var parts: Array = ["walk", "style"]
	var belts: Array = BELTS.duplicate()
	var style_belts: Array = ["white", "purple"]
	for a in OS.get_cmdline_user_args():
		var k := str(a).get_slice("=", 0)
		var v := str(a).get_slice("=", 1)
		match k:
			"n":
				n = int(v)
			"parts":
				parts = Array(v.split(","))
			"belts":
				belts = Array(v.split(","))
			"style_belts":
				style_belts = Array(v.split(","))
			_:
				set_key(k, v)
	var t0 := Time.get_ticks_msec()
	if parts.has("walk"):
		walk_matrix(belts, n)
		bars()
	if parts.has("inside"):
		inside_rows(belts, n)
	if parts.has("style"):
		for b in style_belts:
			style_matrix(str(b), n)
	if parts.has("live"):
		live_matrix(belts, n)
	print("PROBE done in %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


## A tuning value from the command line: BjjTree.T or BjjOpp.T, a Vector2 range as lo:hi.
static func set_key(k: String, v: String) -> void:
	var tab: Dictionary = BjjTree.T if BjjTree.T.has(k) else (BjjOpp.T if BjjOpp.T.has(k) else {})
	if tab.is_empty():
		print("PROBE unknown key %s" % k)
		return
	tab[k] = Vector2(float(v.get_slice(":", 0)), float(v.get_slice(":", 1))) if v.contains(":") else float(v)
	print("PROBE set %s = %s" % [k, str(tab[k])])


## The bars of BJJ_REALISM_S397.md 2 on the walk table (only the cells that ran).
static func bars() -> void:
	# S398 the bands (BJJ_REALISM_S397.md 8): one belt 0.70-0.85 (R proxy: a 100-250 rating gap), white->blue 0.80-0.90
	# (the move list as well as mat time: 8-12 owned moves against 25-36; v6 80-88), brown->black 0.60-0.72 (the smallest
	# step); two belts 0.85-0.97; three or more 0.92-0.99, no cell above 0.99.
	var gaps := {1: [0.70, 0.85], 2: [0.85, 0.97], 3: [0.92, 0.99], 4: [0.92, 0.99]}
	for key in cells:
		var lo := str(key).get_slice("|", 0)
		var hi := str(key).get_slice("|", 1)
		var t: Dictionary = cells[key]
		var nn := maxf(1.0, float(t["n"]))
		var g := BeltRoad.rank(hi) - BeltRoad.rank(lo)
		if g > 0:
			var p := float(t["b"]) / nn
			var band: Array = gaps[g]
			if g == 1 and lo == "white":
				band = [0.80, 0.90]
			elif g == 1 and lo == "brown":
				band = [0.60, 0.72]
			print("BAR gap%d %-6s>%-6s win %.3f in %.2f-%.2f %s" % [g, hi, lo, p, band[0], band[1], "PASS" if p >= band[0] and p <= band[1] else "FAIL"])
			continue
		var sub := float(t.get("submission", 0)) / nn
		var dec := float(t.get("decision", 0)) / nn
		var adv := float(t.get("advantages", 0)) / nn
		var sb: Array = {"white": [0.30, 0.55], "brown": [0.45, 0.60], "black": [0.40, 0.60]}.get(lo, [0.40, 0.60])
		var ok: bool = sub >= float(sb[0]) and sub <= float(sb[1]) and dec >= 0.02 and dec <= 0.10 and (adv <= 0.08 or BeltRoad.rank(lo) < 3)
		print("BAR even %-6s sub %.3f (%.2f-%.2f) ref %.3f (0.02-0.10) adv %.3f %s" % [lo, sub, sb[0], sb[1], dec, adv, "PASS" if ok else "FAIL"])


## Inside a belt: a four-stripe (class share 1.0) vs a fresh athlete (0.0); B = the four-stripe (bar: 0.60-0.76).
static func inside_rows(belts: Array, n: int) -> void:
	var keep: Vector2 = BjjOpp.T["CLASS_SHARE"]
	for b0 in belts:
		var belt := str(b0)
		var t := {}
		for s in n:
			var r := _rng(s, "inside|%s" % belt)
			BjjOpp.T["CLASS_SHARE"] = Vector2(0.0, 0.0)
			var a := gen(belt, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|ia|%s" % [s, belt]))
			BjjOpp.T["CLASS_SHARE"] = Vector2(1.0, 1.0)
			var b := gen(belt, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|ib|%s" % [s, belt]))
			if s % 2 == 0:
				tally_add(t, walk_one(a, b, r))
			else:
				var w := walk_one(b, a, r)
				w["win"] = not bool(w["win"])
				tally_add(t, w)
		BjjOpp.T["CLASS_SHARE"] = keep
		var p := float(t["b"]) / maxf(1.0, float(t["n"]))
		# Bands: 0.62-0.76 (R proxy: a 75-200 rating gap); white 0.72-0.85 - a fresh white has no classes, a ready one is a
		# fresh blue (class time teaches the moves too).
		var lo := 0.72 if belt == "white" else 0.62
		var hi := 0.85 if belt == "white" else 0.76
		print("PROBE INSIDE %-6s four-stripe vs fresh %s" % [belt, tally_line(t)])
		print("BAR inside %-6s win %.3f in %.2f-%.2f %s" % [belt, p, lo, hi, "PASS" if p >= lo and p <= hi else "FAIL"])
static func gen(belt: String, style: String, seed: int) -> Dictionary:
	return BjjOpp.generate(belt, style, seed)


static func _rng(s: int, tag: String) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash("%d|%s" % [s, tag])
	return r


static func _steps(o: Dictionary) -> Array:
	return BjjTree.route(str(o.get("route", ""))).get("steps", [])


static func _lower(a: String, b: String) -> String:
	return a if BeltRoad.rank(a) <= BeltRoad.rank(b) else b


## One walk between a (side 0) and b (side 1) under the lower belt's rules.
static func walk_one(a: Dictionary, b: Dictionary, r: RandomNumberGenerator) -> Dictionary:
	var rules := BjjTree.rules_for(_lower(str(a["belt"]), str(b["belt"])))
	return BjjWalk.walk(a, b, [_steps(a), _steps(b)], int(rules["minutes"]), rules, r, {"no_mood": true})


## t: n, b (side B's wins), the method of each result (by: submission / points / advantages / penalties / decision),
## B's wins and losses by submission, points scored, 0-0 bells.
static func tally_add(t: Dictionary, w: Dictionary) -> void:
	t["n"] = int(t.get("n", 0)) + 1
	var b_won := not bool(w["win"])
	t["b"] = int(t.get("b", 0)) + (1 if b_won else 0)
	var by := str(w.get("by", "submission" if str(w["how"]).begins_with("submission") else "points"))
	t[by] = int(t.get(by, 0)) + 1
	if by == "submission":
		t["b_sub" if b_won else "a_sub"] = int(t.get("b_sub" if b_won else "a_sub", 0)) + 1
	t["scored"] = float(t.get("scored", 0.0)) + float(int(w["score"][0]) + int(w["score"][1]))
	if int(w["score"][0]) == 0 and int(w["score"][1]) == 0:
		t["zero"] = int(t.get("zero", 0)) + 1
	t["att"] = float(t.get("att", 0.0)) + float(int(w["attempts"][0]) + int(w["attempts"][1])) / 2.0
	for row in w["path"]:
		if str(BjjTree.edge(str(row[0])).get("odds", "")) == "submission":
			t["sub_att"] = float(t.get("sub_att", 0.0)) + 0.5
	t["pens"] = float(t.get("pens", 0.0)) + float(int(w["pen"][0]) + int(w["pen"][1]))


static func tally_line(t: Dictionary) -> String:
	var n := maxf(1.0, float(t.get("n", 0)))
	var p := float(t.get("b", 0)) / n
	return "B wins %.3f (+-%.3f) | sub %.2f pts %.2f adv %.2f pen %.2f dec %.2f | B subs %.2f A subs %.2f | pts/match %.1f | 0-0 %.2f | att/athlete %.1f sub att %.1f pens %.2f" % [
		p, 1.96 * sqrt(p * (1.0 - p) / n), float(t.get("submission", 0)) / n, float(t.get("points", 0)) / n,
		float(t.get("advantages", 0)) / n, float(t.get("penalties", 0)) / n, float(t.get("decision", 0)) / n,
		float(t.get("b_sub", 0)) / n, float(t.get("a_sub", 0)) / n, float(t.get("scored", 0.0)) / n, float(t.get("zero", 0)) / n,
		float(t.get("att", 0.0)) / n, float(t.get("sub_att", 0.0)) / n, float(t.get("pens", 0.0)) / n]


static func walk_matrix(belts: Array, n: int) -> void:
	print("PROBE WALK  (A = row belt, B = column belt; B wins = the column belt's share; lower belt's rules)")
	for i in belts.size():
		for j in range(i, belts.size()):
			var t := {}
			var nn := n * (3 if j - i >= 3 else 1)
			for s in nn:
				var r := _rng(s, "walk|%s|%s" % [belts[i], belts[j]])
				var a := gen(belts[i], str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|a|%s" % [s, belts[i]]))
				var b := gen(belts[j], str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|b|%s" % [s, belts[j]]))
				# Side order alternates, so the initiative coin and side bias cancel.
				if s % 2 == 0:
					tally_add(t, walk_one(a, b, r))
				else:
					var w := walk_one(b, a, r)
					w["win"] = not bool(w["win"])
					tally_add(t, w)
			cells["%s|%s" % [belts[i], belts[j]]] = t
			print("PROBE WALK %-6s vs %-6s %s" % [belts[i], belts[j], tally_line(t)])


## Style vs style at one belt, each pair once (sides alternate): the cell is the column style's share; then each style's
## mean against the other four and its worst matchup (bars: mean 0.45-0.55, worst 8-15 points off even).
static func style_matrix(belt: String, n: int) -> void:
	print("PROBE STYLE %s (row vs column: the column's win share)" % belt)
	var styles: Array = BjjOpp.STYLE_ORDER
	var m := {}
	for i in styles.size():
		for j in range(i + 1, styles.size()):
			var t := {}
			for s in n:
				var r := _rng(s, "style|%s|%d|%d" % [belt, i, j])
				var a := gen(belt, str(styles[i]), hash("%d|sa|%d" % [s, i]))
				var b := gen(belt, str(styles[j]), hash("%d|sb|%d" % [s, j]))
				if s % 2 == 0:
					tally_add(t, walk_one(a, b, r))
				else:
					var w := walk_one(b, a, r)
					w["win"] = not bool(w["win"])
					tally_add(t, w)
			var p := float(t["b"]) / float(t["n"])
			m["%d|%d" % [i, j]] = p
			m["%d|%d" % [j, i]] = 1.0 - p
	for i in styles.size():
		var line := "PROBE STYLE %-6s %-18s" % [belt, styles[i]]
		var tot := 0.0
		var worst := 0.5
		var worst_vs := ""
		for j in styles.size():
			if i == j:
				line += "   -  "
				continue
			var mine := 1.0 - float(m["%d|%d" % [i, j]])
			line += " %.2f " % float(m["%d|%d" % [i, j]])
			tot += mine
			if absf(mine - 0.5) > absf(worst - 0.5):
				worst = mine
				worst_vs = str(styles[j])
		print("%s | mean %.2f, furthest %.2f vs %s" % [line, tot / 4.0, worst, worst_vs])


# --- the live engine's odds on a class chain ---------------------------------------------------------------------------

## The moves out of a class for the side on top (or bottom, or standing): [kind, to-class, who is on top after (0 = me)].
const OUTS := {
	"standing": [["takedown", "guard", 0]],
	"guard_bottom": [["sweep", "guard", 0], ["sub", "", 0], ["back", "back", 0]],
	"guard_top": [["pass", "side_control", 0], ["advance", "half_guard", 0]],
	"half_guard_bottom": [["sweep", "half_guard", 0], ["back", "back", 0]],
	"half_guard_top": [["pass", "side_control", 0], ["sub", "", 0]],
	"side_control_bottom": [["escape", "guard", 1]],
	"side_control_top": [["mount", "mount", 0], ["knee_on_belly", "side_control", 0], ["sub", "", 0]],
	"mount_bottom": [["escape", "half_guard", 1]],
	"mount_top": [["sub", "", 0], ["back", "back", 0]],
	"back_bottom": [["escape", "guard", 1]],
	"back_top": [["sub", "", 0]],
}
## The syllabus moves behind each kind (an athlete's mastery of the kind = its best of these, else PLAIN_MASTERY).
const KIND_MOVES := {"takedown": ["double_leg", "single_leg_shoot", "snap_down"], "sweep": ["scissor_sweep", "hip_bump_sweep",
	"butterfly_sweep", "x_guard_sweep", "deep_half"], "pass": ["bullfighter_pass", "knee_cut_pass", "body_lock_pass", "leg_drag"],
	"sub": ["armbar_guard", "kimura", "americana", "rear_naked_choke", "guillotine", "triangle", "darce", "anaconda", "kneebar",
	"inside_heel_hook", "omoplata"], "escape": ["shrimp_bridge", "frame_recover_guard", "seatbelt_escape"],
	"back": ["arm_drag_back", "seatbelt_escape"], "mount": [], "knee_on_belly": [], "advance": []}


static func kind_m(f: Dictionary, kind: String) -> float:
	var best := BjjMatch.PLAIN_MASTERY
	for id in KIND_MOVES.get(kind, []):
		best = maxf(best, BjjTree.mastery(f, str(id)))
	return best


## One live-engine match on the class chain: 0 or 1 wins, -1 a draw; how = sub | pts | draw.
static func live_one(a: Dictionary, b: Dictionary, r: RandomNumberGenerator) -> Array:
	var fa := a.duplicate()
	var oa := BjjOpen.match_opp(b)
	var st := BjjMatch.start(fa, oa)
	st["limit_s"] = float(BeltRoad.match_minutes(_lower(str(a["belt"]), str(b["belt"])))) * 60.0
	st["init"] = r.randi() % 2
	var ms: Array = [{}, {}]
	for k in KIND_MOVES:
		ms[0][k] = kind_m(a, k)
		ms[1][k] = kind_m(b, k)
	var cls := "standing"
	var top := -1
	while not bool(st["over"]):
		var me := int(st["init"])
		var key := cls if cls == "standing" else "%s_%s" % [cls, "top" if top == me else "bottom"]
		var offers: Array = []
		for o in OUTS.get(key, []):
			var kind := str(o[0])
			var p := BjjMatch.odds(kind, float(ms[me][kind]), float(st["skill"][me]), float(st["skill"][1 - me]), float(st["gas"][me]),
				float(st["strength"][me]), float(st["strength"][1 - me]))
			var pts := BjjMatch.points(kind)
			var ev := p * (10.0 if kind == "sub" else float(pts) + 0.5) - (1.0 - p) * (1.5 if kind == "sub" else 0.5)
			offers.append({"i": 0, "title": kind, "kind": kind, "odds": p, "pts": pts, "ev": ev, "to": str(o[1]), "top": int(o[2])})
		offers.sort_custom(func(x, y): return float(x["ev"]) > float(y["ev"]))
		var pick: Dictionary = offers[0] if me == 0 or offers.size() < 2 else offers[r.randi() % 2]
		var hit := BjjMatch.resolve(st, me, pick, r.randf())
		if hit and not bool(st["over"]):
			cls = str(pick["to"])
			top = me if int(pick["top"]) == 0 else 1 - me
		# ~2.5 s a move (the live match's pace: a move, a 0.3-0.5 s settle, the next).
		BjjMatch.tick(st, 2.5, false)
	return [int(st["winner"]), "sub" if str(st["how"]).begins_with("submission") else ("draw" if int(st["winner"]) < 0 else "pts")]


static func live_matrix(belts: Array, n: int) -> void:
	print("PROBE LIVE  (BjjMatch.odds on the class chain; B wins = the column belt's share, draws count half)")
	for b0 in belts:
		var g := BjjOpp.generate(str(b0), "Passer", 7)
		print("PROBE LIVE skill_of %-6s = %.1f, strength %.0f cardio %.0f" % [b0, BjjMatch.skill_of(g),
			float(BjjOpen.match_opp(g)["stats"]["strength"]), float(BjjOpen.match_opp(g)["stats"]["cardio"])])
	for i in belts.size():
		for j in range(i, belts.size()):
			var bw := 0.0
			var subs := 0
			var draws := 0
			for s in n:
				var r := _rng(s, "live|%s|%s" % [belts[i], belts[j]])
				var a := gen(belts[i], str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|la|%s" % [s, belts[i]]))
				var b := gen(belts[j], str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|lb|%s" % [s, belts[j]]))
				var flip := s % 2 == 1
				var res := live_one(b, a, r) if flip else live_one(a, b, r)
				var w := int(res[0])
				if w < 0:
					bw += 0.5
					draws += 1
				elif (w == 1) != flip:
					bw += 1.0
				subs += 1 if str(res[1]) == "sub" else 0
			print("PROBE LIVE %-6s vs %-6s B wins %.2f | sub %.2f draw %.2f" % [belts[i], belts[j], bw / n, float(subs) / n, float(draws) / n])
