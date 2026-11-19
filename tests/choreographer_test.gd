extends SceneTree
## Choreographer test (FP2CHOREO1): one check block per rule R1-R12, a 40-seed sweep, and mutants.

const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
const Wait := preload("res://scripts/fight3d/v2/ChoreoWait.gd")
const React := preload("res://scripts/fight3d/v2/ChoreoReact.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")

var failures := 0
var db: Dictionary = {}


func _initialize() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(ClipCensus.DB_PATH))
	db = parsed if parsed is Dictionary else {}
	# R1: counts
	_r1_counts()
	# R2: time
	_r2_time()
	# R3: take fits
	_r3_fit()
	# R4: distance plan
	_r4_gap()
	# R5: step
	_r5_step()
	# R6: reaction
	_r6_reaction()
	# R7: stun
	_r7_stun()
	# R8: block/slip/miss
	_r8_def()
	# R9: heads apart
	_r9_heads()
	# R10: control
	_r10_control()
	# R11: pivots
	_r11_pivots()
	# R12: deterministic
	_r12_same()
	# R13: range (S525)
	_r13_range()
	# R14: the waits (S525)
	_r14_waits()
	# R15: reactions sized, the arm home (S526)
	_r15_sized()
	# Sweep
	_sweep()
	# Mutants
	_mutants()
	print("CHOREO failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _beat(who: String, move: String, result: String, t: float = 2.0, extra: Dictionary = {}) -> Dictionary:
	var b := {"t": t, "who": who, "move": move, "result": result, "def": "", "big": false, "knockback": false, "combo": false, "combo_id": ""}
	for k in extra:
		b[k] = extra[k]
	return b


func _opts(extra: Dictionary = {}) -> Dictionary:
	var o := {"t0": 0.0, "t1": 30.0, "gap0": R.REST_M, "seed": 1, "south": {"a": false, "b": false}}
	for k in extra:
		o[k] = extra[k]
	return o


# --- R1 COUNTS ---
func _r1_counts() -> void:
	# Lone jab that lands
	var plan := Choreo.plan([_beat("a", "jab", "lands")], db, _opts())
	_check(int(plan["counts"]["a"]["landed"]) == 1, "R1: one landed jab -> a.landed=1")
	_check(int(plan["counts"]["a"]["thrown"]) == 1, "R1: one landed jab -> a.thrown=1")
	# Jab-cross combo, both land
	var plan2 := Choreo.plan([_beat("a", "jab", "lands", 2.0), _beat("a", "cross", "lands", 2.35)], db, _opts())
	_check(int(plan2["counts"]["a"]["landed"]) == 2, "R1: jab-cross lands -> a.landed=2")
	# Miss doesn't count as landed
	var plan3 := Choreo.plan([_beat("a", "jab", "misses")], db, _opts())
	_check(int(plan3["counts"]["a"]["landed"]) == 0, "R1: miss -> a.landed=0")
	_check(int(plan3["counts"]["a"]["thrown"]) == 1, "R1: miss -> a.thrown=1")


# --- R2 TIME ---
func _r2_time() -> void:
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var ob: Dictionary = plan["beats"][0]
	var ct: float = float(ob["contact_t"])
	_check(ct >= 0.0 and ct <= 30.0, "R2: contact_t in [t0, t1]")
	_check(float(ob["t_play"]) <= ct, "R2: t_play <= contact_t")
	_check(float(ob["from_s"]) >= 0.0, "R2: from_s >= 0")
	# Combo: contacts keep input order
	var plan2 := Choreo.plan([_beat("a", "jab", "lands", 5.0), _beat("a", "cross", "lands", 5.35)], db, _opts())
	_check(float(plan2["beats"][0]["contact_t"]) < float(plan2["beats"][1]["contact_t"]), "R2: combo contacts keep order")


# --- R3 TAKE FITS ---
func _r3_fit() -> void:
	var plan := Choreo.plan([_beat("a", "jab", "lands")], db, _opts())
	var ob: Dictionary = plan["beats"][0]
	var take: String = str(ob["take"])
	_check(take != "", "R3: jab gets a take")
	if take != "":
		var rows: Dictionary = db.get("rows", {})
		if rows.has(take):
			var row: Dictionary = rows[take]
			_check(str(row.get("family", "")) == "jab", "R3: jab take family=jab")
			var cg: float = float(row.get("contact_gap_m", 0.0))
			var diff: float = absf(float(ob["gap"]) - cg)
			_check(diff <= R.IK_MAX_M, "R3: jab straight |gap - contact_gap_m| <= IK_MAX_M (got %.3f)" % diff)


# --- R4 DISTANCE PLAN ---
func _r4_gap() -> void:
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var gap: Array = plan["gap"]
	_check(gap.size() >= 2, "R4: gap plan has points")
	# Check continuity and slope
	var ok := true
	for i in range(1, gap.size()):
		var dt: float = float(gap[i][0]) - float(gap[i - 1][0])
		if dt <= 0.001:
			continue
		var dg: float = absf(float(gap[i][1]) - float(gap[i - 1][1]))
		if dg / dt > R.GAP_SPEED_MPS + 0.01:
			ok = false
	_check(ok, "R4: gap plan slope <= GAP_SPEED_MPS")
	# Never under MIN_GAP_M
	var min_ok := true
	for g in gap:
		if float(g[1]) < R.MIN_GAP_M - 0.001:
			min_ok = false
	_check(min_ok, "R4: gap plan never under MIN_GAP_M")
	# step_in moves to CREEP_M
	var plan2 := Choreo.plan([_beat("a", "step_in", "none", 3.0), _beat("a", "jab", "lands", 5.0)], db, _opts())
	var g_at_step: float = _gap_at_plan(plan2["gap"], 3.0)
	_check(absf(g_at_step - R.CREEP_M) < 0.1, "R4: step_in -> gap ~ CREEP_M (got %.2f)" % g_at_step)


# --- R5 STEP ---
func _r5_step() -> void:
	# From rest, a jab at t=5 should get a step event
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var steps: Array = plan["tracks"]["a"].filter(func(e): return str(e["kind"]) == "step")
	_check(steps.size() >= 1, "R5: jab from rest gets a step event (got %d)" % steps.size())


# --- R6 REACTION ---
func _r6_reaction() -> void:
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var reacts: Array = plan["tracks"]["b"].filter(func(e): return str(e["kind"]) == "reaction")
	_check(reacts.size() == 1, "R6: landed jab gives b a reaction")
	if reacts.size() > 0:
		var r: Dictionary = reacts[0]
		_check(str(r["clip"]) != "", "R6: reaction has a clip name")
		_check(absf(float(r["t"]) - 5.0 - R.impact_s_for("jab")) < 0.01, "R6: reaction starts at contact_t")
	# Hook reaction: size medium
	var plan2 := Choreo.plan([_beat("a", "lead_hook", "lands", 5.0)], db, _opts())
	var reacts2: Array = plan2["tracks"]["b"].filter(func(e): return str(e["kind"]) == "reaction")
	_check(reacts2.size() == 1, "R6: landed hook gives a reaction")
	# Big shot: heavy reaction
	var plan3 := Choreo.plan([_beat("a", "lead_hook", "lands", 5.0, {"big": true})], db, _opts())
	var ob3: Dictionary = plan3["beats"][0]
	_check(str(ob3.get("react", "")) != "", "R6: big shot has a react take")


# --- R7 STUN ---
func _r7_stun() -> void:
	# Landed jab stuns b. A punch by b inside the stun should slide or cut.
	var plan := Choreo.plan([
		_beat("a", "jab", "lands", 2.0),
		_beat("b", "jab", "misses", 2.2),
	], db, _opts())
	var b_punches: Array = plan["beats"].filter(func(b): return str(b["who"]) == "b" and R.is_punch(str(b["move"])))
	_check(b_punches.size() == 1, "R7: b's punch inside stun is planned")
	if b_punches.size() > 0:
		var bp: Dictionary = b_punches[0]
		# Should be slid or cut
		var slid: bool = float(bp["contact_t"]) > 2.2 + R.impact_s_for("jab") - 0.01
		var cut: bool = bool(bp.get("cut", false))
		_check(slid or cut, "R7: b's punch in stun is slid or cut")
	# Landed punch by stunned boxer is never cut
	var plan2 := Choreo.plan([
		_beat("a", "jab", "lands", 2.0),
		_beat("b", "jab", "lands", 2.15),
	], db, _opts())
	var b_landed: Array = plan2["beats"].filter(func(b): return str(b["who"]) == "b" and str(b["result"]) == "lands")
	_check(b_landed.size() == 1 and not bool(b_landed[0].get("cut", false)), "R7: landed punch by stunned boxer is never cut")


# --- R8 BLOCK/SLIP/MISS ---
func _r8_def() -> void:
	# Blocked cross: other man gets a block take
	var plan := Choreo.plan([_beat("a", "cross", "blocked", 5.0)], db, _opts())
	var blocks: Array = plan["tracks"]["b"].filter(func(e): return str(e["kind"]) == "block")
	_check(blocks.size() == 1, "R8: blocked cross gives b a block take")
	# Slipped jab: other man gets a defence take
	var plan2 := Choreo.plan([_beat("a", "jab", "misses", 5.0, {"def": "slip"})], db, _opts())
	var defs: Array = plan2["tracks"]["b"].filter(func(e): return str(e["kind"]) == "defence")
	_check(defs.size() == 1, "R8: slipped jab gives b a defence take")
	if defs.size() == 1:
		var dfe: Dictionary = defs[0]
		var d_ct: float = float(plan2["beats"][0]["contact_t"])
		var d_peak: float = float(db["rows"][str(dfe["clip"])].get("head_peak_s", 0.3))
		_check(d_ct - float(dfe["t"]) <= R.DEF_LEAD_S + 0.001, "R8: the slip starts no earlier than DEF_LEAD_S before the punch lands (%.2f s)" % (d_ct - float(dfe["t"])))
		_check(absf(float(dfe["t"]) + d_peak - float(dfe["from_s"]) - d_ct) < 0.01, "R8: ... and its head is furthest off the line as the punch arrives")
	# Miss: planned SHORT
	var plan3 := Choreo.plan([_beat("a", "jab", "misses", 5.0)], db, _opts())
	var ob: Dictionary = plan3["beats"][0]
	var rows: Dictionary = db.get("rows", {})
	if str(ob["take"]) != "" and rows.has(str(ob["take"])):
		var cg: float = float(rows[str(ob["take"])]["contact_gap_m"])
		_check(float(ob["gap"]) > cg, "R8: miss planned SHORT (gap > contact_gap_m)")


# --- R9 HEADS APART ---
func _r9_heads() -> void:
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var ob: Dictionary = plan["beats"][0]
	var take: String = str(ob["take"])
	if take != "" and db["rows"].has(take):
		var hfm: float = float(db["rows"][take].get("head_fwd_m", 0.0))
		var hfh: float = float(db["meta"]["head_from_hips_m"])
		var heads_gap: float = float(ob["gap"]) - hfm - hfh
		_check(heads_gap >= R.HEADS_APART_M - 0.01, "R9: heads apart >= HEADS_APART_M (got %.3f)" % heads_gap)


# --- R13 RANGE (S525: the plan in HEAD distance, the short takes passed over, the attacker's step out) ---
func _heads(ob: Dictionary) -> float:
	var row: Dictionary = db["rows"].get(str(ob["take"]), {})
	return float(ob["gap"]) - float(row.get("head_fwd_m", 0.0)) - R.VICTIM_HEAD_FWD_M


func _r13_range() -> void:
	var rows: Dictionary = db["rows"]
	# the short cross (0.64 m, heads 0.46 m apart) is owned and fresh: it must never be the landed cross from rest
	var short_seen := 0
	var low := INF
	for seed in 30:
		for move in ["cross", "jab", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut"]:
			var ob: Dictionary = Choreo.plan([_beat("a", move, "lands", 5.0)], db, _opts({"seed": seed}))["beats"][0]
			var row: Dictionary = rows.get(str(ob["take"]), {})
			if R.is_short(move, float(row.get("contact_gap_m", 0.9)), float(row.get("head_fwd_m", 0.0))):
				short_seen += 1
			low = minf(low, _heads(ob) - float(R.HEAD_FLOOR_M[R.range_kind(move)]))
	_check(short_seen == 0, "R13: no short take lands while its family owns a longer one (%d)" % short_seen)
	_check(low >= -0.021, "R13: the heads keep their floor at every landed punch from rest (worst %.3f m under)" % -low)
	_check(R.is_short("cross", 0.638, 0.16) and not R.is_short("cross", 0.895, 0.084), "R13: is_short tells the 0.64 m cross from the 0.90 m one")
	_check(absf(R.head_extra("cross", 0.859, 0.119, true) - 0.08) < 0.001 and R.head_extra("jab", 1.031, 0.163, true) == 0.0, "R13: the reach is what the floor is short by, none when the take is long enough")
	_check(R.head_extra("cross", 0.638, 0.16, true) <= float(R.REACH_M["straight"]) + 0.0001, "R13: a landed punch's reach stays inside the arm's budget")
	# a lone landed jab: one step in a viewer can count, then the man who punched steps out at once and both go to rest
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var ct: float = float(plan["beats"][0]["contact_t"])
	var gap: Array = plan["gap"]
	var step_in := 0.0
	var out_by := ""
	var out_m := 0.0
	var out_end := 0.0
	for i in range(1, gap.size()):
		var d: float = float(gap[i][1]) - float(gap[i - 1][1])
		if d < -0.01 and absf(float(gap[i][0]) - (ct - Gap.LEAD_S)) < 0.03:
			step_in = -d
		if d > 0.01 and float(gap[i - 1][0]) >= ct and out_by == "":
			out_by = str(gap[i][2])
			out_m = d
			out_end = float(gap[i][0])
	_check(absf(step_in - Gap.STEP_IN_M) < 0.02, "R13: the step in on the punch is one step (%.2f m)" % step_in)
	_check(out_by == "a" and absf(out_m - Gap.STEP_OUT_M) < 0.02 and out_end - ct <= 0.7, "R13: the man who punched steps out %.2f m within 0.7 s, one whole step (%s, %.2f m, %.2f s)" % [Gap.STEP_OUT_M, out_by, out_m, out_end - ct])
	_check(absf(_gap_at_plan(gap, ct + R.LEAVE_S) - R.REST_M) < 0.10, "R13: back at rest within LEAVE_S (%.2f m; the rest breathes 5-9 cm)" % _gap_at_plan(gap, ct + R.LEAVE_S))
	# S529 a lone landed cross: the man who is HIT gives the ground, at once (film 6, both critics: "the cross snaps the
	# head but the feet do not answer", 3 cm where a stiff cross moves a man 15-25)
	var pc := Choreo.plan([_beat("a", "cross", "lands", 5.0)], db, _opts())
	var cct: float = float(pc["beats"][0]["contact_t"])
	var hurt_by := ""
	var hurt_m := 0.0
	var hurt_t := 0.0
	for i in range(1, (pc["gap"] as Array).size()):
		var dc: float = float(pc["gap"][i][1]) - float(pc["gap"][i - 1][1])
		if dc > 0.01 and float(pc["gap"][i][0]) > cct + 0.01 and hurt_by == "":   # his reaction's own travel (a knock) counts
			hurt_by = str(pc["gap"][i][2]).trim_prefix("knock_")
			hurt_m = dc
			hurt_t = maxf(float(pc["gap"][i - 1][0]), cct)
	_check(hurt_by == "b" and hurt_m >= 0.15 and hurt_t - cct <= 0.2, "R13: a landed cross moves the man it hit: he steps back 15 cm or more, starting within 0.2 s (%s, %.2f m, %.2f s after)" % [hurt_by, hurt_m, hurt_t - cct])
	# two punches 1.0 s apart: the pair does not stay in the pocket of the first one's distance
	var p2 := Choreo.plan([_beat("a", "cross", "lands", 5.0), _beat("b", "jab", "lands", 6.0)], db, _opts())
	var c1: float = float(p2["beats"][0]["contact_t"])
	var c2: float = float(p2["beats"][1]["contact_t"])
	var widest := 0.0
	var tt := c1
	while tt < c2:
		widest = maxf(widest, Gap.at(p2["gap"], tt))
		tt += 0.02
	_check(c2 - c1 < Gap.POCKET_WAIT_S or widest >= float(p2["beats"][0]["gap"]) + Gap.POCKET_MIN_M - 0.01, "R13: with %.2f s to the next punch the puncher steps out between them (widest %.2f m, the punch %.2f m)" % [c2 - c1, widest, float(p2["beats"][0]["gap"])])


# --- R14 THE WAITS (S525: fidgets, paws and feints planned into every quiet stretch; the distance at rest breathes) ---
func _r14_waits() -> void:
	var rows: Dictionary = db["rows"]
	var overlaps := 0
	var through := 0
	var fidget_through := 0
	var longest := 0.0
	var kinds := {}
	var still := 0.0
	var longest_at := ""
	for seed in 12:
		var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Slugger", 30.0, seed)["beats"]
		var plan := Choreo.plan(beats, db, _opts({"t0": 0.0, "t1": 30.0, "seed": seed}))
		var cts: Array = []
		for ob in plan["beats"]:
			if R.is_punch(str(ob["move"])) and not bool(ob.get("cut", false)):
				cts.append(float(ob["contact_t"]))
		for side in ["a", "b"]:
			var evs: Array = plan["tracks"][side]
			var busy: Array = []
			var spans: Array = []   # everything of his that plays: what is left between two spans is the plain guard
			for e in evs:
				var k := str(e["kind"])
				if k in Wait.BUSY:
					var left: float = float(e.get("until_s", (rows.get(str(e.get("clip", "")), {}) as Dictionary).get("length_s", 1.2))) - float(e.get("from_s", 0.0))
					busy.append([float(e["t"]), maxf(float(e["control_t"]), float(e["t"]) + (left if k != "pass" else 2.0))])
					spans.append(busy[-1])
				elif k in ["fidget", "feint"]:
					kinds[str(e.get("what", k))] = int(kinds.get(str(e.get("what", k)), 0)) + 1
					spans.append([float(e["t"]), float(e["end_t"])])
				elif e.has("drift"):   # S528: a ring step is not the plain guard
					spans.append([float(e["t"]), float(e["end_t"])])
			for e in evs:
				if not (str(e["kind"]) in ["fidget", "feint"]):
					continue
				for b in busy:
					if float(e["t"]) < float(b[1]) and float(e["end_t"]) > float(b[0]) + 0.001:
						overlaps += 1
				if str(e["kind"]) == "feint":
					for c in cts:
						if float(c) > float(e["t"]) - 0.3 and float(c) < float(e["end_t"]) - 0.25 + 0.3:
							through += 1
				else:
					for c in cts:   # S529: a fidget take shuffles its man up to 14 cm; one played into a punch thrown short at him put the glove on his face
						if float(c) > float(e["t"]) - 0.05 and float(c) < float(e["end_t"]) + 0.30:
							fidget_through += 1
			for c in cts:   # S529: a man a punch is being thrown at is not idle (no fidget is planned into it)
				spans.append([float(c) - 0.35, float(c) + 0.05])
			spans.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
			var upto := 0.0
			for sp in spans + [[30.0, 30.0]]:
				if float(sp[0]) - upto > longest:
					longest = float(sp[0]) - upto
					longest_at = "seed %d %s %.2f-%.2f" % [seed, side, upto, float(sp[0])]
				upto = maxf(upto, float(sp[1]))
		# the distance: the longest stretch in which the gap does not change at all
		var gap: Array = plan["gap"]
		for i in range(1, gap.size()):
			if absf(float(gap[i][1]) - float(gap[i - 1][1])) < 0.001:
				still = maxf(still, float(gap[i][0]) - float(gap[i - 1][0]))
		_check(Gap.faults(gap, cts, 30.0).is_empty(), "R14 seed %d: the breathing distance plan has no fault" % seed)
	_check(overlaps == 0, "R14: no wait thing plays over a take of the same man (%d)" % overlaps)
	_check(through == 0, "R14: no paw or feint goes through a landing punch (%d)" % through)
	_check(fidget_through == 0, "R14: no fidget plays into a punch of either man (%d)" % fidget_through)
	_check(longest <= 4.2, "R14: nobody stands in the plain guard longer than 4.2 s (S531: was 2; the guard bounces, and nobody paws from out of reach any more) (longest %.2f s, %s)" % [longest, longest_at])
	_check(still <= 4.5, "R14: the distance never holds still longer than 4.5 s (S531: was 2.2; the rock at rest is off, the wait bounces, a half step in every 4-7 s) (longest %.2f s)" % still)
	_check(int(kinds.get("fidget", 0)) > 0 and int(kinds.get("paw", 0)) > 0 and int(kinds.get("cross_feint", 0)) > 0, "R14: fidgets, paws and feints are all planned (%s)" % str(kinds))
	var plain := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts({"waits": false}))
	_check((plain["tracks"]["a"] as Array).filter(func(e): return str(e["kind"]) in ["fidget", "feint"]).is_empty(), "R14: waits off = the plan without them")


# --- R15 REACTIONS SIZED TO THE PUNCH, THE ARM HOME (S526) ---
func _react_of(move: String, seed: int, big: bool = false) -> Dictionary:
	var plan := Choreo.plan([_beat("a", move, "lands", 5.0, {"big": big})], db, _opts({"seed": seed}))
	var evs: Array = plan["tracks"]["b"].filter(func(e): return str(e["kind"]) == "reaction")
	return evs[0] if evs.size() == 1 else {}


func _r15_sized() -> void:
	var rows: Dictionary = db["rows"]
	# the take is the one whose own head travel is nearest what the punch should do, among the ones that go the right way
	var mean := {}
	var flagged := 0
	var jab_dropped := 0
	for move in ["jab", "cross", "lead_hook", "body_hook"]:
		var sum := 0.0
		for seed in 20:
			var e := _react_of(move, seed)
			var row: Dictionary = rows.get(str(e.get("clip", "")), {})
			sum += float(row.get("head_rel_m", 0.0))
			if not (row.get("drop", []) as Array).is_empty():
				flagged += 1
				if move == "jab":
					jab_dropped += 1
				_check(React.may_play(row, true), "R15: a dropped take plays only for a face tipped up within the allowance (%s)" % str(e.get("clip", "")))
		mean[move] = sum / 20.0
	_check(float(mean["jab"]) < float(mean["cross"]) and float(mean["cross"]) <= float(mean["lead_hook"]) + 0.03 and float(mean["body_hook"]) > float(mean["cross"]),
		"R15: the hit head travels by the punch - jab %.2f < cross %.2f, hook %.2f, body %.2f m" % [float(mean["jab"]), float(mean["cross"]), float(mean["lead_hook"]), float(mean["body_hook"])])
	_check(float(mean["jab"]) >= 0.09 and float(mean["cross"]) >= 0.17 and float(mean["body_hook"]) >= 0.26, "R15: ... and no punch gets a take under its floor")
	_check(jab_dropped == 0, "R15: a jab never plays a take the census dropped (%d)" % jab_dropped)
	_check(not React.may_play({"drop": ["face tips up 34 deg"]}, true) and React.may_play({"drop": ["face tips up 29 deg"]}, true)
		and not React.may_play({"drop": ["face tips up 29 deg"]}, false) and not React.may_play({"drop": ["face tips up 20 deg", "glove over the crown 9 frames"]}, true),
		"R15: the face-up allowance is 30 deg, power punches only, and only when it is the one reason")
	# the reaction starts so the head's first peak against the hips is on the blow, and hands back to the guard
	for move in ["cross", "body_hook"]:
		var e := _react_of(move, 3)
		var row: Dictionary = rows.get(str(e.get("clip", "")), {})
		var snap: float = minf(float(row.get("head_peak_s", 0.0)), float(row.get("head_rel_s", 99.0)))
		_check(float(e.get("from_s", -1.0)) <= maxf(snap - R.react_peak_s(move), 0.0) + 0.001 and absf(float(e.get("from_s", -1.0)) - float(React.start_s(row, move, 30.0, 1.0)[0])) < 0.001, "R15: a %s's reaction starts react_peak_s before its snap or earlier (%s from %.2f, snap %.2f)" % [move, str(e.get("clip", "")), float(e.get("from_s", -1.0)), snap])
		_check(e.has("until_s") and float(e["until_s"]) > float(e["from_s"]) + 0.3 and float(e["until_s"]) <= float(row.get("length_s", 9.0)) + 0.001, "R15: ... and hands back to the guard inside the take (%.2f)" % float(e.get("until_s", -1.0)))
	var body := _react_of("body_hook", 3)
	var brow: Dictionary = rows.get(str(body.get("clip", "")), {})
	_check(float(body.get("from_s", 9.0)) < float(brow.get("head_peak_s", 0.0)) - R.REACT_FOLD_S - 0.1 or absf(float(brow.get("head_rel_s", 0.0)) - float(brow.get("head_peak_s", 0.0))) < 0.15,
		"R15: a body shot's reaction starts at the fold, not at the end of the stagger (%s from %.2f, stagger ends %.2f)" % [str(body.get("clip", "")), float(body.get("from_s", 9.0)), float(brow.get("head_peak_s", 0.0))])
	# S530 NO HEAD OVER THE BAR IN ONE PICTURE: a reaction joined at its peak put 0.4-0.5 of a 28-36 cm way into one
	# picture (the head jumps of film 6, 20 cm). It starts as late in its take as keeps every picture's step under the bar.
	var worst := 0.0
	var worst_of := ""
	var early := 0
	var at_peak := 0
	for move in ["jab", "cross", "lead_hook", "rear_hook", "lead_uppercut", "body_hook"]:
		for big in [false, true]:
			for seed in 20:
				var e := _react_of(move, seed, big)
				var row: Dictionary = rows.get(str(e.get("clip", "")), {})
				var curve: Array = row.get("head_g", [])
				if curve.is_empty():
					continue
				var from: float = float(e.get("from_s", 0.0))
				var step: float = React.worst_step(curve, from + 1.0 / R.FILM_HZ, R.JOIN_WAY["fold" if move == "body_hook" else ("snap" if bool(e.get("soft", false)) else "quick")], 30.0)
				if from > 0.0 and step > worst:
					worst = step
					worst_of = "%s%s %s %.3f m" % ["big " if big else "", move, str(e.get("clip", "")), step]
				var peak: float = minf(float(row.get("head_peak_s", 0.0)), float(row.get("head_rel_s", 99.0)))
				if from < peak - R.react_peak_s(move) - 0.02:
					early += 1
				elif from > 0.0:
					at_peak += 1
	_check(worst <= R.HEAD_STEP_MAX_M + 0.0005, "R15: no reaction's head goes over the bar in one picture (%s)" % worst_of)
	_check(early > 0 and at_peak > 0, "R15: ... a heavy take starts earlier for it (%d), a light one still on its peak (%d)" % [early, at_peak])
	_check(React.worst_step(rows["pro_hit_by_cross_v4"]["head_g"], float(rows["pro_hit_by_cross_v4"]["head_rel_s"]) - R.REACT_PEAK_S + 1.0 / R.FILM_HZ, R.JOIN_WAY["quick"], 30.0) > 0.10,
		"R15: ... the heavy cross take joined at its peak is over it (the old start: red)")
	var quick_jabs := 0
	for seed in 20:
		if not bool(_react_of("jab", seed).get("soft", true)):
			quick_jabs += 1
	_check(quick_jabs >= 10, "R15: ... a jab's light take keeps the quick join (the head furthest three pictures after the glove; %d of 20)" % quick_jabs)
	# a defence with nothing holding him starts its take earlier rather than joining it part-way at twice its speed
	var wv := Choreo.plan([_beat("a", "lead_hook", "misses", 5.0, {"def": "weave"})], db, _opts())
	var wes: Array = (wv["tracks"]["b"] as Array).filter(func(e): return str(e["kind"]) == "defence")
	if wes.size() == 1 and (rows.get(str(wes[0]["clip"]), {}) as Dictionary).has("head_g"):
		var wrow: Dictionary = rows[str(wes[0]["clip"])]
		_check(float(wes[0]["from_s"]) <= 0.001 or React.worst_step(wrow["head_g"], float(wes[0]["from_s"]), R.JOIN_WAY["defence"], 30.0) <= R.HEAD_STEP_MAX_M + 0.0005 or float(wes[0]["from_s"]) <= float(wrow["head_peak_s"]) - R.DEF_LEAD_S - R.DEF_EARLY_S + 0.02,
			"R15: a free defence starts early enough for its head (%s from %.2f)" % [str(wes[0]["clip"]), float(wes[0]["from_s"])])
	# S530: a straight is slipped with the quick weave, a hook is ducked under with a deep one; a weave comes up at once
	var wj := Choreo.plan([_beat("a", "jab", "misses", 5.0, {"def": "weave"})], db, _opts())
	var wjs: Array = (wj["tracks"]["b"] as Array).filter(func(e): return str(e["kind"]) == "defence")
	_check(wjs.size() == 1 and str(wjs[0]["clip"]) == R.WEAVE_STRAIGHT, "R15: a jab is slipped with the quick weave (%s)" % (str(wjs[0]["clip"]) if wjs.size() == 1 else "none"))
	_check(wes.size() == 1 and str(wes[0]["clip"]) != R.WEAVE_STRAIGHT and float(rows[str(wes[0]["clip"])]["head_rel_m"]) >= 0.30, "R15: a hook is ducked under with a deep weave")
	_check(wes.size() == 1 and wes[0].has("until_s") and absf(float(wes[0]["until_s"]) - float(rows[str(wes[0]["clip"])]["head_peak_s"]) - R.DEF_UP_S) < 0.001, "R15: a weave is handed back to the guard DEF_UP_S after its lowest point")
	_check(float(rows["pro_hit_by_cross_v4"].get("head_g", [1.0])[0]) < 0.05, "R15: the census reads a take's head from the guard's spot (head_g)")
	# the arm comes home: a punch's event says when the hand is back, a straight sooner than a hook
	var pj := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var ph := Choreo.plan([_beat("a", "lead_hook", "lands", 5.0)], db, _opts())
	var ej: Dictionary = (pj["tracks"]["a"] as Array).filter(func(e): return str(e["kind"]) == "punch")[0]
	var eh: Dictionary = (ph["tracks"]["a"] as Array).filter(func(e): return str(e["kind"]) == "punch")[0]
	var cj: float = float(rows[str(ej["clip"])]["contact_s"])
	var ch: float = float(rows[str(eh["clip"])]["contact_s"])
	_check(absf(float(ej["until_s"]) - cj - R.ARM_HOME_S - 0.25) < 0.001 and absf(float(eh["until_s"]) - ch - R.ARM_HOME_TURN_S - 0.25) < 0.001 and R.arm_home_s("jab") < R.arm_home_s("lead_hook"),
		"R15: the arm is home %.2f s after a straight's contact, %.2f s after a hook's" % [R.ARM_HOME_S, R.ARM_HOME_TURN_S])


# --- R10 CONTROL ---
func _r10_control() -> void:
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var evs: Array = plan["tracks"]["a"]
	var ok := true
	for i in range(1, evs.size()):
		if float(evs[i]["t"]) < float(evs[i - 1]["control_t"]) - 0.01:
			ok = false
	_check(ok, "R10: no overlapping events for one boxer")


# --- R11 PIVOTS ---
func _r11_pivots() -> void:
	# 30s exchange with quiet spells
	var beats: Array = []
	beats.append(_beat("a", "jab", "lands", 3.0))
	beats.append(_beat("b", "cross", "lands", 15.0))
	beats.append(_beat("a", "jab", "lands", 27.0))
	var plan := Choreo.plan(beats, db, _opts({"t0": 0.0, "t1": 30.0}))
	var pivots: Array = (plan["tracks"]["a"] as Array).filter(func(e): return str(e["kind"]) == "pivot")
	pivots.append_array((plan["tracks"]["b"] as Array).filter(func(e): return str(e["kind"]) == "pivot"))
	_check(pivots.size() >= 1, "R11: 30s exchange with quiet spells has pivots (got %d)" % pivots.size())


# --- R12 DETERMINISTIC ---
func _r12_same() -> void:
	var beats := [_beat("a", "jab", "lands", 5.0), _beat("b", "cross", "lands", 6.0)]
	var p1 := Choreo.plan(beats, db, _opts({"seed": 42}))
	var p2 := Choreo.plan(beats, db, _opts({"seed": 42}))
	_check(JSON.stringify(p1) == JSON.stringify(p2), "R12: same beats+db+opts = same plan")
	# Input not mutated
	var orig := JSON.stringify(beats)
	Choreo.plan(beats, db, _opts())
	_check(JSON.stringify(beats) == orig, "R12: input not mutated")


# --- SWEEP ---
func _sweep() -> void:
	var total_punches := 0
	var total_landed := 0
	var total_cut := 0
	var total_slid := 0
	var total_misfit := 0
	var worst_ik := 0.0
	var gap_faults := 0
	var heads_n := 0
	var heads_low := 0
	var shown := 0
	var logs := {}
	for seed in 40:
		var round := {"n": 1, "won": true, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var script := RS.build(round, "Slugger", "Slugger", 30.0, seed)
		var beats: Array = script["beats"]
		var plan := Choreo.plan(beats, db, _opts({"t0": 0.0, "t1": 30.0, "seed": seed}))
		# R1
		var exp_landed := {"a": 0, "b": 0}
		for b in beats:
			if str(b["result"]) == "lands":
				exp_landed[str(b["who"])] = int(exp_landed[str(b["who"])]) + 1
		for side in ["a", "b"]:
			_check(int(plan["counts"][side]["landed"]) == exp_landed[side], "sweep seed %d: R1 %s landed" % [seed, side])
		# R2
		for i in range(1, plan["beats"].size()):
			if str(plan["beats"][i]["who"]) == str(plan["beats"][i - 1]["who"]):
				if R.is_punch(str(plan["beats"][i]["move"])) and R.is_punch(str(plan["beats"][i - 1]["move"])):
					if float(plan["beats"][i]["contact_t"]) < float(plan["beats"][i - 1]["contact_t"]) - 0.01:
						_check(false, "sweep seed %d: R2 order" % seed)
		# R4: the distance plan holds on every seed (speed, floor, rest when no punch is near) - a fault FAILS
		var gap: Array = plan["gap"]
		var cts: Array = []
		for ob in plan["beats"]:
			if R.is_punch(str(ob["move"])) and not bool(ob.get("cut", false)):
				cts.append(float(ob["contact_t"]))
				if absf(Gap.at(gap, float(ob["contact_t"]) - Gap.LEAD_S) - float(ob["gap"])) > 0.03:
					_check(false, "sweep seed %d: R4 the plan is not at the punch's gap at %.2f (%.2f v %.2f)" % [seed, float(ob["contact_t"]), Gap.at(gap, float(ob["contact_t"]) - Gap.LEAD_S), float(ob["gap"])])
		var bad: Array = Gap.faults(gap, cts, 30.0)
		gap_faults += bad.size()
		if not bad.is_empty() and shown < 6:
			shown += 1
			print("  seed %d gap faults: %s" % [seed, str(bad.slice(0, 3))])
		for line in plan["log"]:
			var key := str(line).get_slice(":", 0)
			logs[key] = int(logs.get(key, 0)) + 1
			if key == "misfit":
				total_misfit += 1
		# R7, R9, R10
		for ob in plan["beats"]:
			if not R.is_punch(str(ob["move"])):
				continue
			total_punches += 1
			if str(ob["result"]) == "lands":
				total_landed += 1
			if bool(ob.get("cut", false)):
				total_cut += 1
			if float(ob.get("ik_m", 0.0)) > worst_ik:
				worst_ik = float(ob["ik_m"])
			if str(ob["result"]) == "lands" and not bool(ob.get("cut", false)) and str(ob["take"]) != "":
				heads_n += 1
				if _heads(ob) < float(R.HEAD_FLOOR_M[R.range_kind(str(ob["move"]))]) - 0.021:
					heads_low += 1
		# R10
		for side in ["a", "b"]:
			var evs: Array = plan["tracks"][side]
			for i in range(1, evs.size()):
				if float(evs[i]["t"]) < float(evs[i - 1]["control_t"]) - 0.01:
					_check(false, "sweep seed %d: R10 %s overlap" % [seed, side])
		# R12
		var plan2 := Choreo.plan(beats, db, _opts({"t0": 0.0, "t1": 30.0, "seed": seed}))
		if JSON.stringify(plan) != JSON.stringify(plan2):
			_check(false, "sweep seed %d: R12 deterministic" % seed)
	_check(gap_faults == 0, "sweep: the distance plan has no fault on 40 seeds (%d)" % gap_faults)
	_check(heads_low <= heads_n / 10, "sweep: at most 1 landed punch in 10 has the heads under their floor (%d of %d: a burst's follow-up, or a family with only short takes)" % [heads_low, heads_n])
	_check(total_misfit <= total_punches / 20, "sweep: at most 1 punch in 20 is thrown off its take's distance (%d of %d)" % [total_misfit, total_punches])
	print("CHOREO sweep log lines: ", logs)
	print("CHOREO sweep seeds=40 punches=%d landed=%d cut=%d slid=%d misfit=%d worst_ik=%.3f" % [total_punches, total_landed, total_cut, total_slid, total_misfit, worst_ik])


# --- MUTANTS ---
func _mutants() -> void:
	# Mutant 1: remove a landed beat from counts
	var plan := Choreo.plan([_beat("a", "jab", "lands", 5.0)], db, _opts())
	var m_counts: Dictionary = plan["counts"].duplicate(true)
	m_counts["a"]["landed"] = int(m_counts["a"]["landed"]) - 1
	_check(_check_r1(m_counts, [_beat("a", "jab", "lands", 5.0)]) != "", "mutant 1: removed landed beat fails R1")
	# Mutant 2: gap plan that jumps
	var bad_gap: Array = [[0.0, R.REST_M, ""], [5.0, R.REST_M, ""], [5.01, 0.5, "a"], [10.0, 0.5, ""]]
	_check(_check_r4_slope(bad_gap) != "", "mutant 2: gap jump fails R4")
	# Mutant 3: hit man punching inside stun without slide/cut
	var bad_beats: Array = [_beat("a", "jab", "lands", 2.0), _beat("b", "jab", "lands", 2.15)]
	var plan3 := Choreo.plan(bad_beats, db, _opts())
	# Manually break it: set b's punch contact_t before stun ends, not cut
	var b_punch: Dictionary = plan3["beats"][1].duplicate()
	b_punch["cut"] = false
	var a_ct: float = float(plan3["beats"][0]["contact_t"])
	var stun_end: float = a_ct + R.stun_for("light")
	b_punch["contact_t"] = stun_end - 0.1
	_check(_check_r7_stun([plan3["beats"][0], b_punch]) != "", "mutant 3: hit man punching in stun fails R7")


# --- Rule check functions (used by both normal tests and mutants) ---

func _check_r1(counts: Dictionary, beats: Array) -> String:
	var exp := {"a": 0, "b": 0}
	for b in beats:
		if str(b["result"]) == "lands":
			exp[str(b["who"])] = int(exp[str(b["who"])]) + 1
	for side in ["a", "b"]:
		if int(counts[side]["landed"]) != exp[side]:
			return "R1: %s landed %d != %d" % [side, counts[side]["landed"], exp[side]]
	return ""


func _check_r4_slope(gap: Array) -> String:
	for i in range(1, gap.size()):
		var dt: float = float(gap[i][0]) - float(gap[i - 1][0])
		if dt > 0.001:
			var dg: float = absf(float(gap[i][1]) - float(gap[i - 1][1]))
			if dg / dt > R.GAP_SPEED_MPS + 0.01:
				return "R4: slope %.2f > %.2f" % [dg / dt, R.GAP_SPEED_MPS]
	return ""


func _check_r7_stun(beats: Array) -> String:
	var stun_until := {"a": -1.0, "b": -1.0}
	for ob in beats:
		if not R.is_punch(str(ob["move"])):
			continue
		var who: String = str(ob["who"])
		var ct: float = float(ob["contact_t"])
		if ct < stun_until[who] and not bool(ob.get("cut", false)):
			# Punch inside stun, not cut. Check if it's slid enough.
			var base_ct: float = float(ob.get("t", 0.0)) + R.impact_s_for(str(ob["move"]))
			var slide: float = ct - base_ct
			if str(ob["result"]) == "lands":
				# Landed punch in stun: should be slid as far as allowed (SLIDE_MAX_S)
				if slide < R.SLIDE_MAX_S - 0.01:
					return "R7: %s landed punch in stun not slid enough (slide=%.2f)" % [who, slide]
			else:
				# Non-landed punch in stun: should be slid or cut
				if slide < R.SLIDE_MAX_S - 0.01:
					return "R7: %s punch in stun not slid/cut (slide=%.2f)" % [who, slide]
		if str(ob["result"]) == "lands":
			var other: String = "b" if who == "a" else "a"
			var size: String = R.react_size_for(str(ob["move"]), bool(ob.get("big", false)))
			stun_until[other] = maxf(stun_until[other], ct + R.stun_for(size))
	return ""


func _gap_at_plan(gap: Array, t: float) -> float:
	if gap.is_empty():
		return R.REST_M
	if t <= float(gap[0][0]):
		return float(gap[0][1])
	if t >= float(gap[-1][0]):
		return float(gap[-1][1])
	for i in range(1, gap.size()):
		if t <= float(gap[i][0]):
			var f: float = 0.0
			var dt: float = float(gap[i][0]) - float(gap[i - 1][0])
			if dt > 0.001:
				f = (t - float(gap[i - 1][0])) / dt
			return lerpf(float(gap[i - 1][1]), float(gap[i][1]), f)
	return float(gap[-1][1])
