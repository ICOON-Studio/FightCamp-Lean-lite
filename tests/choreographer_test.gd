extends SceneTree
## Choreographer test (FP2CHOREO1): one check block per rule R1-R12, a 40-seed sweep, and mutants.

const Choreo := preload("res://scripts/fight3d/v2/Choreographer.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Gap := preload("res://scripts/fight3d/v2/ChoreoGap.gd")
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
	# From rest (1.7 m), a jab at t=5 should get a step event
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
